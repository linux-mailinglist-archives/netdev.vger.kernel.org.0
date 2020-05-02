Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A711C28BC
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 00:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgEBW64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 18:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728577AbgEBW6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 18:58:55 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4950BC061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 15:58:55 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id z90so10913250qtd.10
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 15:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jt7qg+m0aHrReAJz5szdVvPU333Pm6HstauSJBkIl58=;
        b=MNTzmbfqOabiuyBbgDIDTdEAJJExvSbD79x8iC3D+Zs5m7XhxgkuHCj0zhlGUuBJrB
         RQRDEP4agX3Wk6z0DgrAOvqdrHx95YSSYxZeS/QN5usSOXvScNvn/WnWU6O/HHaDIQIe
         QoHEq7dTDjTNcOj2L/4Dx0H1w34o+Aml18ZZc/JSLfppPk9GKyoF9CrtRNxYHo5ys7EO
         uBOPZHU/m3Ve0wdYoFf3SzRXxgY9fXmiwbU6efrY/cDypP9Dt18ORn9mQQ1o6Kv3F2W6
         Tdyrf/jNsvAacvJwG/olZ5W+jOGxPjt4kZQf20FyECweObNv1aqxiMiLLqP/TESHZyf/
         mWHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jt7qg+m0aHrReAJz5szdVvPU333Pm6HstauSJBkIl58=;
        b=cTmH4fldozBRAzwOBLO8Svq1LtprPP5GYq98esTCPfm5equQdEjo2pzX3HtMF71AS5
         cjQFByWS8uKr0qZQKaEMcCOUqlJCENlabrwEl4EH3KvYo0zha67obQFZDXSN40SCHdkb
         SY5EQnqgsC6mgucgHT03EegWtbph7BKBSscETXp6Z0lppd4r9S2CRQZHtBzqjhcI+5p4
         3BJn6QmJQQGyWgtaIaDx+78G+I3UYy4c2JwAOYPv9WwpSkR3PmDAeMZGigg7UowmDuw0
         J8G0Cnkbu2cpFEHb4TlM2LF21Ee15gggd8O37uGKr9pwky6nriisYNyjqCSobOkAj/f8
         X3mQ==
X-Gm-Message-State: AGi0Pub3fJAfmj+/MX3iCXtN+5keaYNGiv2RgGMV+P+dB3f7WWM3p8Uy
        Pb0Y4zT+Q6xmbKZiWw2z2t/KCT6Z
X-Google-Smtp-Source: APiQypL52OsXnSmJ0J+2Mq+wAit5akHHZ5lgbVBfBm4qCZOFG9nXVnRLmX4O08LqAjktamTr3zVsIA==
X-Received: by 2002:ac8:5204:: with SMTP id r4mr2896021qtn.39.1588460334138;
        Sat, 02 May 2020 15:58:54 -0700 (PDT)
Received: from localhost.localdomain ([45.72.161.207])
        by smtp.gmail.com with ESMTPSA id p22sm6784464qte.2.2020.05.02.15.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 15:58:53 -0700 (PDT)
From:   Alexander Aring <alex.aring@gmail.com>
To:     netdev@vger.kernel.org
Cc:     mcr@sandelman.ca, stefan@datenfreihafen.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [PATCH iproute2-next 2/2] lwtunnel: add support for rpl segment routing
Date:   Sat,  2 May 2020 18:58:34 -0400
Message-Id: <20200502225834.28938-2-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200502225834.28938-1-alex.aring@gmail.com>
References: <20200502225834.28938-1-alex.aring@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for rpl segment routing settings.
Example:

ip -n ns0 -6 route add 2001::3 encap rpl segs \
fe80::c8fe:beef:cafe:cafe,fe80::c8fe:beef:cafe:beef dev lowpan0

Signed-off-by: Alexander Aring <alex.aring@gmail.com>
---
 ip/iproute.c          |   2 +-
 ip/iproute_lwtunnel.c | 111 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 112 insertions(+), 1 deletion(-)

diff --git a/ip/iproute.c b/ip/iproute.c
index 07c45169..05ec2c29 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -101,7 +101,7 @@ static void usage(void)
 		"TIME := NUMBER[s|ms]\n"
 		"BOOL := [1|0]\n"
 		"FEATURES := ecn\n"
-		"ENCAPTYPE := [ mpls | ip | ip6 | seg6 | seg6local ]\n"
+		"ENCAPTYPE := [ mpls | ip | ip6 | seg6 | seg6local | rpl ]\n"
 		"ENCAPHDR := [ MPLSLABEL | SEG6HDR ]\n"
 		"SEG6HDR := [ mode SEGMODE ] segs ADDR1,ADDRi,ADDRn [hmac HMACKEYID] [cleanup]\n"
 		"SEGMODE := [ encap | inline ]\n"
diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index ff7c9d7f..5f73f402 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -29,6 +29,8 @@
 
 #include <linux/seg6.h>
 #include <linux/seg6_iptunnel.h>
+#include <linux/rpl.h>
+#include <linux/rpl_iptunnel.h>
 #include <linux/seg6_hmac.h>
 #include <linux/seg6_local.h>
 #include <linux/if_tunnel.h>
@@ -50,6 +52,8 @@ static const char *format_encap_type(int type)
 		return "seg6";
 	case LWTUNNEL_ENCAP_SEG6_LOCAL:
 		return "seg6local";
+	case LWTUNNEL_ENCAP_RPL:
+		return "rpl";
 	default:
 		return "unknown";
 	}
@@ -84,6 +88,8 @@ static int read_encap_type(const char *name)
 		return LWTUNNEL_ENCAP_SEG6;
 	else if (strcmp(name, "seg6local") == 0)
 		return LWTUNNEL_ENCAP_SEG6_LOCAL;
+	else if (strcmp(name, "rpl") == 0)
+		return LWTUNNEL_ENCAP_RPL;
 	else if (strcmp(name, "help") == 0)
 		encap_type_usage();
 
@@ -162,6 +168,32 @@ static void print_encap_seg6(FILE *fp, struct rtattr *encap)
 	print_srh(fp, tuninfo->srh);
 }
 
+static void print_rpl_srh(FILE *fp, struct ipv6_rpl_sr_hdr *srh)
+{
+	int i;
+
+	for (i = srh->segments_left - 1; i >= 0; i--) {
+		print_color_string(PRINT_ANY, COLOR_INET6,
+				   NULL, "%s ",
+				   rt_addr_n2a(AF_INET6, 16, &srh->rpl_segaddr[i]));
+	}
+}
+
+static void print_encap_rpl(FILE *fp, struct rtattr *encap)
+{
+	struct rtattr *tb[RPL_IPTUNNEL_MAX + 1];
+	struct ipv6_rpl_sr_hdr *srh;
+
+	parse_rtattr_nested(tb, RPL_IPTUNNEL_MAX, encap);
+
+	if (!tb[RPL_IPTUNNEL_SRH])
+		return;
+
+	srh = RTA_DATA(tb[RPL_IPTUNNEL_SRH]);
+
+	print_rpl_srh(fp, srh);
+}
+
 static const char *seg6_action_names[SEG6_LOCAL_ACTION_MAX + 1] = {
 	[SEG6_LOCAL_ACTION_END]			= "End",
 	[SEG6_LOCAL_ACTION_END_X]		= "End.X",
@@ -567,6 +599,9 @@ void lwt_print_encap(FILE *fp, struct rtattr *encap_type,
 	case LWTUNNEL_ENCAP_SEG6_LOCAL:
 		print_encap_seg6local(fp, encap);
 		break;
+	case LWTUNNEL_ENCAP_RPL:
+		print_encap_rpl(fp, encap);
+		break;
 	}
 }
 
@@ -690,6 +725,79 @@ out:
 	return ret;
 }
 
+static struct ipv6_rpl_sr_hdr *parse_rpl_srh(char *segbuf)
+{
+	struct ipv6_rpl_sr_hdr *srh;
+	int nsegs = 0;
+	int srhlen;
+	char *s;
+	int i;
+
+	s = segbuf;
+	for (i = 0; *s; *s++ == ',' ? i++ : *s);
+	nsegs = i + 1;
+
+	srhlen = 8 + 16 * nsegs;
+
+	srh = calloc(1, srhlen);
+
+	srh->hdrlen = (srhlen >> 3) - 1;
+	srh->type = 3;
+	srh->segments_left = nsegs;
+
+	for (s = strtok(segbuf, ","); s; s = strtok(NULL, ",")) {
+		inet_prefix addr;
+
+		get_addr(&addr, s, AF_INET6);
+		memcpy(&srh->rpl_segaddr[i], addr.data, sizeof(struct in6_addr));
+		i--;
+	}
+
+	return srh;
+}
+
+static int parse_encap_rpl(struct rtattr *rta, size_t len, int *argcp,
+			   char ***argvp)
+{
+	struct ipv6_rpl_sr_hdr *srh;
+	char **argv = *argvp;
+	char segbuf[1024] = "";
+	int argc = *argcp;
+	int segs_ok = 0;
+	int ret = 0;
+	int srhlen;
+
+	while (argc > 0) {
+		if (strcmp(*argv, "segs") == 0) {
+			NEXT_ARG();
+			if (segs_ok++)
+				duparg2("segs", *argv);
+
+			strlcpy(segbuf, *argv, 1024);
+		} else {
+			break;
+		}
+		argc--; argv++;
+	}
+
+	srh = parse_rpl_srh(segbuf);
+	srhlen = (srh->hdrlen + 1) << 3;
+
+	if (rta_addattr_l(rta, len, RPL_IPTUNNEL_SRH, srh,
+			  srhlen)) {
+		ret = -1;
+		goto out;
+	}
+
+	*argcp = argc + 1;
+	*argvp = argv - 1;
+
+out:
+	free(srh);
+
+	return ret;
+}
+
 struct lwt_x {
 	struct rtattr *rta;
 	size_t len;
@@ -1537,6 +1645,9 @@ int lwt_parse_encap(struct rtattr *rta, size_t len, int *argcp, char ***argvp,
 	case LWTUNNEL_ENCAP_SEG6_LOCAL:
 		ret = parse_encap_seg6local(rta, len, &argc, &argv);
 		break;
+	case LWTUNNEL_ENCAP_RPL:
+		ret = parse_encap_rpl(rta, len, &argc, &argv);
+		break;
 	default:
 		fprintf(stderr, "Error: unsupported encap type\n");
 		break;
-- 
2.20.1

