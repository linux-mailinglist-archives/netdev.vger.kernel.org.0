Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C6F447702
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 01:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbhKHAsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 19:48:45 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.219]:59515 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229807AbhKHAso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 19:48:44 -0500
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Nov 2021 19:48:42 EST
HMM_SOURCE_IP: 172.18.0.48:43760.616130149
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-110.80.1.45 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 1090E2800AF;
        Mon,  8 Nov 2021 08:38:21 +0800 (CST)
X-189-SAVE-TO-SEND: +zhenggy@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id a7c1a4c9887d45d59953a2e84212ca75 for lvs-devel@vger.kernel.org;
        Mon, 08 Nov 2021 08:38:42 CST
X-Transaction-ID: a7c1a4c9887d45d59953a2e84212ca75
X-Real-From: zhenggy@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: zhenggy@chinatelecom.cn
From:   GuoYong Zheng <zhenggy@chinatelecom.cn>
To:     lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     horms@verge.net.au, ja@ssi.bg, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org,
        GuoYong Zheng <zhenggy@chinatelecom.cn>
Subject: [PATCH] ipvs: remove unused variable for ip_vs_new_dest
Date:   Fri,  5 Nov 2021 19:39:40 +0800
Message-Id: <1636112380-11040-1-git-send-email-zhenggy@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dest variable is not used after ip_vs_new_dest anymore in
ip_vs_add_dest, do not need pass it to ip_vs_new_dest, remove it.

Signed-off-by: GuoYong Zheng <zhenggy@chinatelecom.cn>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index e62b40b..494399d 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -959,8 +959,7 @@ static void ip_vs_trash_cleanup(struct netns_ipvs *ipvs)
  *	Create a destination for the given service
  */
 static int
-ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest,
-	       struct ip_vs_dest **dest_p)
+ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 {
 	struct ip_vs_dest *dest;
 	unsigned int atype, i;
@@ -1020,8 +1019,6 @@ static void ip_vs_trash_cleanup(struct netns_ipvs *ipvs)
 	spin_lock_init(&dest->stats.lock);
 	__ip_vs_update_dest(svc, dest, udest, 1);
 
-	*dest_p = dest;
-
 	LeaveFunction(2);
 	return 0;
 
@@ -1095,7 +1092,7 @@ static void ip_vs_trash_cleanup(struct netns_ipvs *ipvs)
 		/*
 		 * Allocate and initialize the dest structure
 		 */
-		ret = ip_vs_new_dest(svc, udest, &dest);
+		ret = ip_vs_new_dest(svc, udest);
 	}
 	LeaveFunction(2);
 
-- 
1.8.3.1

