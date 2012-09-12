<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="com.jaeksoft.searchlib.facet.FacetFieldList"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8"
	language="java"%>
<%@ page import="com.jaeksoft.searchlib.renderer.Renderer"%>
<%@ page import="com.jaeksoft.searchlib.renderer.RendererField"%>
<%@ page import="com.jaeksoft.searchlib.result.AbstractResultSearch"%>
<%@ page import="com.jaeksoft.searchlib.request.SearchRequest"%>
<%@ page import="com.jaeksoft.searchlib.result.ResultDocument"%>
<%@ page import="com.jaeksoft.searchlib.schema.FieldValueItem"%>
<%@ page import="com.jaeksoft.searchlib.facet.FacetField"%>
<%@ page import="com.jaeksoft.searchlib.facet.FacetList"%>
<%@ page import="com.jaeksoft.searchlib.facet.Facet"%>
<%@ page import="com.jaeksoft.searchlib.facet.FacetItem"%>
<%@ page import="com.jaeksoft.searchlib.renderer.PagingSearchResult"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%
	String[] hiddenParameterList = { "use", "name", "login", "key" };
	String query = request.getParameter("query");
	String fq = request.getParameter("fq");
	if (query == null)
		query = "";
	Renderer renderer = (Renderer) request.getAttribute("renderer");
	AbstractResultSearch result = (AbstractResultSearch) request.getAttribute("result");
	PagingSearchResult paging = result == null ? null : new PagingSearchResult(result, 10);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
.osscmnrdr { <%=renderer .getCommonStyle()==null?"": renderer.getCommonStyle()%>
}

.ossinputrdr { <%=renderer .getInputStyle()==null?"": renderer.getInputStyle()%>
}

.ossbuttonrdr { <%=renderer .getButtonStyle()==null?"": renderer.getButtonStyle()%>
}

<%int j  = 0; for  (RendererField rendererField : renderer.getFields ()) {
	j++;%> .ossfieldrdr <%=j%>{ <%=rendererField.getStyle()==null?"":rendererField.getStyle
	()%>
	
}

<%}%>
a:link { <%=renderer .getAlink()==null?"": renderer.getAlink()%>
}

a:hover { <%=renderer .getAhover()==null?"": renderer.getAhover()%>
}

a:visited { <%=renderer .getAvisited()==null?"": renderer.getAvisited()%>
}

a:active { <%=renderer .getAactive()==null?"": renderer.getAactive()%>
}

#ossautocomplete { <%=renderer .getAutocompleteStyle()==null?"": renderer.getAutocompleteStyle()%>
}

#ossautocompletelist { <%=renderer.getAutocompleteListStyle()==null?"":
		renderer.getAutocompleteListStyle()%>
}

.ossautocomplete_link { <%=renderer.getAutocompleteLinkStyle()==null?"":
		renderer.getAutocompleteLinkStyle()%>
}

.ossautocomplete_link_over { <%=renderer.getAutocompleteLinkHoverStyle()==null?"":
		renderer.getAutocompleteLinkHoverStyle()%>
}

.ossnumfound { <%=renderer.getDocumentFoundStyle()==null?"":
		renderer.getDocumentFoundStyle()%>
}

.oss-facet { <%=renderer.getFacetStyle()==null?"":
		renderer.getFacetStyle()%>
}
.oss-result { <%=renderer.getResultStyle()==null?"":
		renderer.getResultStyle()%>
}
</style>
</head>
<body>

	<form method="get">
		<%
			StringBuffer getUrl = new StringBuffer("?query=");
			getUrl.append(URLEncoder.encode(query, "UTF-8"));
			for (String p : hiddenParameterList) {
				String v = request.getParameter(p);
				if (v != null) {
					getUrl.append('&');
					getUrl.append(p);
					getUrl.append('=');
					getUrl.append(URLEncoder.encode(v, "UTF-8"));
		%>
		<input type="hidden" name="<%=p%>" value="<%=v%>" />
		<%
			}
			}
		%>


		<input class="osscmnrdr ossinputrdr" size="60" type="text" id="query"
			name="query" value="<%=query%>" onkeyup="autosuggest(event)"
			autocomplete="off" /> <input class="osscmnrdr ossbuttonrdr"
			type="submit" value="<%=renderer.getSearchButtonLabel()%>" />
		<div style="position: absolute;">
			<div id="ossautocomplete"></div>
		</div>
	</form>

	<br />
	<%
		if (result != null && result.getDocumentCount() > 0) {
		SearchRequest searchRequest = result.getRequest();
		int start = searchRequest.getStart();
		int end = searchRequest.getStart() + result.getDocumentCount();
		float time=(float)(result.getTimer().duration());
	%>
	<div class="ossnumfound"><%=result.getNumFound()-result.getCollapsedDocCount()%>
		documents found (<%=time/1000%>
		seconds)
	</div>
	<%
	FacetList facetList = result.getFacetList();
		if(facetList!=null && facetList.getList().size() > 0) {
	%>
	<div class="oss-facet">
		<%
				for (Facet facet : facetList){
		%>
		<ul style="margin: 0px; padding: 0px; list-style-type: none">
			<li style="text-transform: capitalize;"><%= facet.getFacetField().getName()%></li>
			<%
				for (FacetItem facetItem : facet) {
			%>
			<li>
			<a href="<%=getUrl.toString()%>&fq=<%=facet.getFacetField().getName()%>:<%=facetItem.getTerm()%>"><%=facetItem.getTerm()%> (<%=facetItem.getCount()%>)</a>
			<li>
			<%
				}
			%>
		</ul>
		<%
			}
		%>
	</div>
	<% } %>
	<div class="oss-result">
		<%
			for (int i = start; i < end; i++) {
					ResultDocument resultDocument = result.getDocument(i);
		%>
		<%
			j = 0;
					for (RendererField rendererField : renderer.getFields()) {
						j++;
						String url = rendererField.getUrlField(resultDocument);
						if (url != null)
							if (url.length() == 0)
								url = null;
						FieldValueItem[] fieldValueItems = rendererField.getFieldValue(resultDocument);
						for (FieldValueItem fieldValueItem : fieldValueItems) {
		%>
		<div class="osscmnrdr ossfieldrdr<%=j%>">
			<%
				if (url != null) {
			%>
			<a target="_top" href="<%=url%>"> <%
 	}
 %> <%=fieldValueItem.getValue()%>
				<%
					if (url != null) {
				%>
			</a>
			<%
				}
			%>
		</div>
		<%
			} // end loop fieldValueItem	
				} // (end loop renderer fields)
		%>
		<br />
		<%
			} // (end loop documents)
		%>

		<table>
			<tr>
				<%
					for (int i = paging.getLeftPage(); i <= paging.getRightPage(); i++) {
				%>
				<td><a href="<%=getUrl.toString()%>&page=<%=i%>"
					class="osscmnrdr"><%=i%></a></td>
				<%
					} // (end loop paging)
				%>
			</tr>
		</table>
	</div>
	<%
		} // (if result != null)
	%>
	<div align="right">
		<a href="http://www.open-search-server.com/" target="_blank"></a> <img
			alt="OPENSEARCHSERVER" src=" images/oss_logo_32.png"
			style="vertical-align: bottom" />
	</div>
	<script type="text/javascript" src="js/opensearchserver.js">
		
	</script>
</body>
</html>