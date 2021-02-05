Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF653104F0
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 07:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhBEG2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 01:28:18 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12401 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhBEG2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 01:28:17 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DX55y16Lbz7hSV;
        Fri,  5 Feb 2021 14:26:14 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Feb 2021 14:27:24 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH] net: core: Clean code style issues in `neighbour.c`
Date:   Fri, 5 Feb 2021 14:28:21 +0800
Message-ID: <20210205062821.3893-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do code format alignment to clean code style issues.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/core/neighbour.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 9500d28a43b0..a742c918a09b 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -299,7 +299,7 @@ static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
 		struct neighbour __rcu **np = &nht->hash_buckets[i];
 
 		while ((n = rcu_dereference_protected(*np,
-					lockdep_is_held(&tbl->lock))) != NULL) {
+						      lockdep_is_held(&tbl->lock))) != NULL) {
 			if (dev && n->dev != dev) {
 				np = &n->next;
 				continue;
@@ -309,7 +309,7 @@ static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
 				continue;
 			}
 			rcu_assign_pointer(*np,
-				   rcu_dereference_protected(n->next,
+					   rcu_dereference_protected(n->next,
 						lockdep_is_held(&tbl->lock)));
 			write_lock(&n->lock);
 			neigh_del_timer(n);
@@ -634,7 +634,7 @@ static struct neighbour *___neigh_create(struct neigh_table *tbl,
 					    lockdep_is_held(&tbl->lock));
 	     n1 != NULL;
 	     n1 = rcu_dereference_protected(n1->next,
-			lockdep_is_held(&tbl->lock))) {
+					    lockdep_is_held(&tbl->lock))) {
 		if (dev == n1->dev && !memcmp(n1->primary_key, n->primary_key, key_len)) {
 			if (want_ref)
 				neigh_hold(n1);
@@ -962,7 +962,7 @@ static void neigh_periodic_work(struct work_struct *work)
 	 * BASE_REACHABLE_TIME.
 	 */
 	queue_delayed_work(system_power_efficient_wq, &tbl->gc_work,
-			      NEIGH_VAR(&tbl->parms, BASE_REACHABLE_TIME) >> 1);
+			   NEIGH_VAR(&tbl->parms, BASE_REACHABLE_TIME) >> 1);
 	write_unlock_bh(&tbl->lock);
 }
 
@@ -1620,8 +1620,7 @@ struct neigh_parms *neigh_parms_alloc(struct net_device *dev,
 	if (p) {
 		p->tbl		  = tbl;
 		refcount_set(&p->refcnt, 1);
-		p->reachable_time =
-				neigh_rand_reach_time(NEIGH_VAR(p, BASE_REACHABLE_TIME));
+		p->reachable_time = neigh_rand_reach_time(NEIGH_VAR(p, BASE_REACHABLE_TIME));
 		dev_hold(dev);
 		p->dev = dev;
 		write_pnet(&p->net, net);
@@ -1693,7 +1692,7 @@ void neigh_table_init(int index, struct neigh_table *tbl)
 
 #ifdef CONFIG_PROC_FS
 	if (!proc_create_seq_data(tbl->id, 0, init_net.proc_net_stat,
-			      &neigh_stat_seq_ops, tbl))
+				  &neigh_stat_seq_ops, tbl))
 		panic("cannot create neighbour proc dir entry");
 #endif
 
@@ -1714,10 +1713,10 @@ void neigh_table_init(int index, struct neigh_table *tbl)
 	rwlock_init(&tbl->lock);
 	INIT_DEFERRABLE_WORK(&tbl->gc_work, neigh_periodic_work);
 	queue_delayed_work(system_power_efficient_wq, &tbl->gc_work,
-			tbl->parms.reachable_time);
+			   tbl->parms.reachable_time);
 	timer_setup(&tbl->proxy_timer, neigh_proxy_process, 0);
 	skb_queue_head_init_class(&tbl->proxy_queue,
-			&neigh_table_proxy_queue_class);
+				  &neigh_table_proxy_queue_class);
 
 	tbl->last_flush = now;
 	tbl->last_rand	= now + tbl->parms.reachable_time * 20;
-- 
2.22.0

