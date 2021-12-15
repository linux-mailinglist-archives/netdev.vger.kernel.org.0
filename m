Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7004766AE
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 00:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhLOXt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 18:49:26 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56606 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbhLOXtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 18:49:23 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0AA4B625F1;
        Thu, 16 Dec 2021 00:46:53 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 1/7] ipvs: remove unused variable for ip_vs_new_dest
Date:   Thu, 16 Dec 2021 00:49:05 +0100
Message-Id: <20211215234911.170741-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211215234911.170741-1-pablo@netfilter.org>
References: <20211215234911.170741-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: GuoYong Zheng <zhenggy@chinatelecom.cn>

The dest variable is not used after ip_vs_new_dest anymore in
ip_vs_add_dest, do not need pass it to ip_vs_new_dest, remove it.

Signed-off-by: GuoYong Zheng <zhenggy@chinatelecom.cn>
Acked-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 39c523bd775c..7f645328b47f 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -960,8 +960,7 @@ __ip_vs_update_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest,
  *	Create a destination for the given service
  */
 static int
-ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest,
-	       struct ip_vs_dest **dest_p)
+ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 {
 	struct ip_vs_dest *dest;
 	unsigned int atype, i;
@@ -1021,8 +1020,6 @@ ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest,
 	spin_lock_init(&dest->stats.lock);
 	__ip_vs_update_dest(svc, dest, udest, 1);
 
-	*dest_p = dest;
-
 	LeaveFunction(2);
 	return 0;
 
@@ -1096,7 +1093,7 @@ ip_vs_add_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 		/*
 		 * Allocate and initialize the dest structure
 		 */
-		ret = ip_vs_new_dest(svc, udest, &dest);
+		ret = ip_vs_new_dest(svc, udest);
 	}
 	LeaveFunction(2);
 
-- 
2.30.2

