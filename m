Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A73A42FE64
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243411AbhJOWzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:55:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:46074 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243405AbhJOWzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 18:55:40 -0400
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mbW4x-000Beu-PZ; Sat, 16 Oct 2021 00:53:31 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH iproute2 -next 2/4] ip, neigh: Fix up spacing in netlink dump
Date:   Sat, 16 Oct 2021 00:53:17 +0200
Message-Id: <20211015225319.2284-3-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211015225319.2284-1-daniel@iogearbox.net>
References: <20211015225319.2284-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26323/Fri Oct 15 10:25:36 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix up spacing to consistently add a single ' ' after an attribute has
been printed. Currently, it is a bit of a mix of before and after which
can lead to double spacing to be printed.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 ip/ipneigh.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/ip/ipneigh.c b/ip/ipneigh.c
index b778de00..564e787c 100644
--- a/ip/ipneigh.c
+++ b/ip/ipneigh.c
@@ -235,7 +235,7 @@ static void print_neigh_state(unsigned int nud)
 #define PRINT_FLAG(f)						\
 	if (nud & NUD_##f) {					\
 		nud &= ~NUD_##f;				\
-		print_string(PRINT_ANY, NULL, " %s", #f);	\
+		print_string(PRINT_ANY, NULL, "%s ", #f);	\
 	}
 
 	PRINT_FLAG(INCOMPLETE);
@@ -423,27 +423,27 @@ int print_neigh(struct nlmsghdr *n, void *arg)
 			fprintf(fp, "lladdr ");
 
 		print_color_string(PRINT_ANY, COLOR_MAC,
-				   "lladdr", "%s", lladdr);
+				   "lladdr", "%s ", lladdr);
 	}
 
 	if (r->ndm_flags & NTF_ROUTER)
-		print_null(PRINT_ANY, "router", " %s", "router");
+		print_null(PRINT_ANY, "router", "%s ", "router");
 
 	if (r->ndm_flags & NTF_PROXY)
-		print_null(PRINT_ANY, "proxy", " %s", "proxy");
+		print_null(PRINT_ANY, "proxy", "%s ", "proxy");
 
 	if (r->ndm_flags & NTF_EXT_LEARNED)
-		print_null(PRINT_ANY, "extern_learn", " %s ", "extern_learn");
+		print_null(PRINT_ANY, "extern_learn", "%s ", "extern_learn");
 
 	if (r->ndm_flags & NTF_OFFLOADED)
-		print_null(PRINT_ANY, "offload", " %s", "offload");
+		print_null(PRINT_ANY, "offload", "%s ", "offload");
 
 	if (show_stats) {
 		if (tb[NDA_CACHEINFO])
 			print_cacheinfo(RTA_DATA(tb[NDA_CACHEINFO]));
 
 		if (tb[NDA_PROBES])
-			print_uint(PRINT_ANY, "probes", " probes %u",
+			print_uint(PRINT_ANY, "probes", "probes %u ",
 				   rta_getattr_u32(tb[NDA_PROBES]));
 	}
 
@@ -453,7 +453,7 @@ int print_neigh(struct nlmsghdr *n, void *arg)
 	if (protocol) {
 		SPRINT_BUF(b1);
 
-		print_string(PRINT_ANY, "protocol", " proto %s ",
+		print_string(PRINT_ANY, "protocol", "proto %s ",
 			     rtnl_rtprot_n2a(protocol, b1, sizeof(b1)));
 	}
 
-- 
2.27.0

