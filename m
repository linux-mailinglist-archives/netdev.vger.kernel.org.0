Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D0E3D7B56
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhG0Qro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhG0Qro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 12:47:44 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E994C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 09:47:44 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f13so5944007plj.2
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 09:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ux0ftsvG6THy8iD6Sw9bFKyipa0ygcBx85ECnGWWm9k=;
        b=U21EURD7NzXss8/JtuE142gUTLKgg/1x4rM4jIGbxcihhQkBsMy0oVDxWMIBQcqOds
         NtJYz4svx8fpPdsQHZWHCn//xEs9qYFxUbjb3pPILf2lpr9dgZbhMdXSHUKscBbA2/++
         cVvcBhlbs1oYGDAFq6KO6kNjk2Z6CjDIoXVjrlv+IXRCWzWHb/IwT/VmEIbz2eoA3slL
         Htv9j7Zuj+sByC5HjZLVbhdvSeAJ21qxgGvgbnSO3pjuZCrSRnTD84QJqM1Kr320TcK1
         Kb8ztXr4QtF+VdWdOjTwyXoa6WqqXmlvsxkIHS2m2vnhYY45NgiXEQ1h9smtP+vNEwR8
         zzMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ux0ftsvG6THy8iD6Sw9bFKyipa0ygcBx85ECnGWWm9k=;
        b=pi13RSuOXN4hFpBl5hJ7VtrT0BFB1XOM1j78FaecROIfPHlAPgSl7NPoqS5iJ26teL
         zWr3vUQ867JQKskH3TJ5OLdKpAkuG134mrw+s7jqDJ1yI/DxO+E82dvIs7m4BN0CJOlI
         Vv5jN0xUQfXUopWQXJPnU1J04Khyn/Rt4ivTMmm+eTFW+uW3sS51n93s/PUvM08rKSSq
         x36k1M4Tb0hNOS7ZKY/WIIQD2VnID7z723yfwojujAysxU7IYIevOGo+UkapfscguHlo
         YL1agyWStGSiYDZtHqxin1Ku4Me2b5fAbbJtyF7Vc2kV38DW5YQDapmzPTjFMgHWaoMV
         wYDA==
X-Gm-Message-State: AOAM530eOVabCZ6XPb/YTfNtjjsBnnchhB+d848S5Kgm+XShUvqFU2yJ
        harj50MBJ1Y5gQGFDKnBpI1+yqBYQjrJb2bU
X-Google-Smtp-Source: ABdhPJyshhql85v3JEU3BoGOTXP9V91UjvPC7lIxsX3u2bWoa6gcXM3gc2dPI8rG1YLbMhBQyEmQmA==
X-Received: by 2002:a63:ed4b:: with SMTP id m11mr24592106pgk.14.1627404463510;
        Tue, 27 Jul 2021 09:47:43 -0700 (PDT)
Received: from lattitude.lan ([49.206.114.8])
        by smtp.googlemail.com with ESMTPSA id q21sm4392799pgk.71.2021.07.27.09.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:47:43 -0700 (PDT)
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Cc:     Gokul Sivakumar <gokulkumar792@gmail.com>
Subject: [PATCH iproute2-next v2] ipneigh: add support to print brief output of neigh cache in tabular format
Date:   Tue, 27 Jul 2021 22:16:28 +0530
Message-Id: <20210727164628.2005805-1-gokulkumar792@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the already available brief flag and print the basic details of
the IPv4 or IPv6 neighbour cache in a tabular format for better readability
when the brief output is expected.

$ ip -br neigh
172.16.12.100                           bridge0          b0:fc:36:2f:07:43
172.16.12.174                           bridge0          8c:16:45:2f:bc:1c
172.16.12.250                           bridge0          04:d9:f5:c1:0c:74
fe80::267b:9f70:745e:d54d               bridge0          b0:fc:36:2f:07:43
fd16:a115:6a62:0:8744:efa1:9933:2c4c    bridge0          8c:16:45:2f:bc:1c
fe80::6d9:f5ff:fec1:c74                 bridge0          04:d9:f5:c1:0c:74

And add "ip neigh show" to the list of ip sub commands mentioned in the man
page that support the brief output in tabular format.

Signed-off-by: Gokul Sivakumar <gokulkumar792@gmail.com>
---

Notes:
    Changes in v2:
    - Reordered the columns in the brief output to be consistent with the order of the
      fields in the non-brief output.
    - changed the format specifier width of dst field from "%-40s" to "%-39s " to be
      consistent with the way width of dev field is specified.

 ip/ipneigh.c  | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/ip.8 |  2 +-
 2 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/ip/ipneigh.c b/ip/ipneigh.c
index 2d6b7f58..95bde520 100644
--- a/ip/ipneigh.c
+++ b/ip/ipneigh.c
@@ -251,6 +251,51 @@ static void print_neigh_state(unsigned int nud)
 	close_json_array(PRINT_JSON, NULL);
 }
 
+static int print_neigh_brief(FILE *fp, struct ndmsg *r, struct rtattr *tb[])
+{
+	if (tb[NDA_DST]) {
+		const char *dst;
+		int family = r->ndm_family;
+
+		if (family == AF_BRIDGE) {
+			if (RTA_PAYLOAD(tb[NDA_DST]) == sizeof(struct in6_addr))
+				family = AF_INET6;
+			else
+				family = AF_INET;
+		}
+
+		dst = format_host_rta(family, tb[NDA_DST]);
+		print_color_string(PRINT_ANY, ifa_family_color(family),
+				   "dst", "%-39s ", dst);
+	}
+
+	if (!filter.index && r->ndm_ifindex) {
+		print_color_string(PRINT_ANY, COLOR_IFNAME,
+				   "dev", "%-16s ",
+				   ll_index_to_name(r->ndm_ifindex));
+	}
+
+	if (tb[NDA_LLADDR]) {
+		const char *lladdr;
+
+		SPRINT_BUF(b1);
+
+		lladdr = ll_addr_n2a(RTA_DATA(tb[NDA_LLADDR]),
+				     RTA_PAYLOAD(tb[NDA_LLADDR]),
+				     ll_index_to_type(r->ndm_ifindex),
+				     b1, sizeof(b1));
+
+		print_color_string(PRINT_ANY, COLOR_MAC,
+				   "lladdr", "%s", lladdr);
+	}
+
+	print_string(PRINT_FP, NULL, "%s", "\n");
+	close_json_object();
+	fflush(fp);
+
+	return 0;
+}
+
 int print_neigh(struct nlmsghdr *n, void *arg)
 {
 	FILE *fp = (FILE *)arg;
@@ -337,6 +382,9 @@ int print_neigh(struct nlmsghdr *n, void *arg)
 	else if (n->nlmsg_type == RTM_GETNEIGH)
 		print_null(PRINT_ANY, "miss", "%s ", "miss");
 
+	if (brief)
+		return print_neigh_brief(fp, r, tb);
+
 	if (tb[NDA_DST]) {
 		const char *dst;
 		int family = r->ndm_family;
@@ -412,7 +460,7 @@ int print_neigh(struct nlmsghdr *n, void *arg)
 
 	print_string(PRINT_FP, NULL, "\n", "");
 	close_json_object();
-	fflush(stdout);
+	fflush(fp);
 
 	return 0;
 }
diff --git a/man/man8/ip.8 b/man/man8/ip.8
index c9f7671e..3f572889 100644
--- a/man/man8/ip.8
+++ b/man/man8/ip.8
@@ -227,7 +227,7 @@ print human readable rates in IEC units (e.g. 1Ki = 1024).
 .BR "\-br" , " \-brief"
 Print only basic information in a tabular format for better
 readability. This option is currently only supported by
-.BR "ip addr show " and " ip link show " commands.
+.BR "ip addr show ", " ip link show " & " ip neigh show " commands.
 
 .TP
 .BR "\-j", " \-json"
-- 
2.25.1

