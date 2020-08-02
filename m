Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35B72359E6
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 20:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgHBScK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 14:32:10 -0400
Received: from correo.us.es ([193.147.175.20]:45774 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbgHBScI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 14:32:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A5C04E4B8C
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 20:32:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 985EBDA78E
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 20:32:06 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8E0DEDA78D; Sun,  2 Aug 2020 20:32:06 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 59947DA73F;
        Sun,  2 Aug 2020 20:32:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 02 Aug 2020 20:32:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (120.205.137.78.rev.vodafone.pt [78.137.205.120])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7B32A4265A2F;
        Sun,  2 Aug 2020 20:32:03 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 5/7] netfilter: ip6tables: Remove redundant null checks
Date:   Sun,  2 Aug 2020 20:31:46 +0200
Message-Id: <20200802183149.2808-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200802183149.2808-1-pablo@netfilter.org>
References: <20200802183149.2808-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gaurav Singh <gaurav1086@gmail.com>

Remove superfluous check for NULL pointer to header.

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/ip6t_ah.c   | 3 +--
 net/ipv6/netfilter/ip6t_frag.c | 3 +--
 net/ipv6/netfilter/ip6t_hbh.c  | 3 +--
 net/ipv6/netfilter/ip6t_rt.c   | 3 +--
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 4e15a14435e4..70da2f2ce064 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -74,8 +74,7 @@ static bool ah_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		 ahinfo->hdrres, ah->reserved,
 		 !(ahinfo->hdrres && ah->reserved));
 
-	return (ah != NULL) &&
-		spi_match(ahinfo->spis[0], ahinfo->spis[1],
+	return spi_match(ahinfo->spis[0], ahinfo->spis[1],
 			  ntohl(ah->spi),
 			  !!(ahinfo->invflags & IP6T_AH_INV_SPI)) &&
 		(!ahinfo->hdrlen ||
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index fb91eeee4a1e..3aad6439386b 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -85,8 +85,7 @@ frag_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		 !((fraginfo->flags & IP6T_FRAG_NMF) &&
 		   (ntohs(fh->frag_off) & IP6_MF)));
 
-	return (fh != NULL) &&
-		id_match(fraginfo->ids[0], fraginfo->ids[1],
+	return id_match(fraginfo->ids[0], fraginfo->ids[1],
 			 ntohl(fh->identification),
 			 !!(fraginfo->invflags & IP6T_FRAG_INV_IDS)) &&
 		!((fraginfo->flags & IP6T_FRAG_RES) &&
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 467b2a86031b..e7a3fb9355ee 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -86,8 +86,7 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		  ((optinfo->hdrlen == hdrlen) ^
 		   !!(optinfo->invflags & IP6T_OPTS_INV_LEN))));
 
-	ret = (oh != NULL) &&
-	      (!(optinfo->flags & IP6T_OPTS_LEN) ||
+	ret = (!(optinfo->flags & IP6T_OPTS_LEN) ||
 	       ((optinfo->hdrlen == hdrlen) ^
 		!!(optinfo->invflags & IP6T_OPTS_INV_LEN)));
 
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index f633dc84ca3f..733c83d38b30 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -89,8 +89,7 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		 !((rtinfo->flags & IP6T_RT_RES) &&
 		   (((const struct rt0_hdr *)rh)->reserved)));
 
-	ret = (rh != NULL) &&
-	      (segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
+	ret = (segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
 			      rh->segments_left,
 			      !!(rtinfo->invflags & IP6T_RT_INV_SGS))) &&
 	      (!(rtinfo->flags & IP6T_RT_LEN) ||
-- 
2.20.1

