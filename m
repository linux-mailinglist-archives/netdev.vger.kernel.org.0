Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD5F4766B1
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 00:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbhLOXt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 18:49:26 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56608 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbhLOXtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 18:49:23 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3988B625F3;
        Thu, 16 Dec 2021 00:46:54 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 3/7] netfilter: nf_queue: remove leftover synchronize_rcu
Date:   Thu, 16 Dec 2021 00:49:07 +0100
Message-Id: <20211215234911.170741-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211215234911.170741-1-pablo@netfilter.org>
References: <20211215234911.170741-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Its no longer needed after commit 870299707436
("netfilter: nf_queue: move hookfn registration out of struct net").

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_queue.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 4acc4b8e9fe5..b61165e97252 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1527,15 +1527,9 @@ static void __net_exit nfnl_queue_net_exit(struct net *net)
 		WARN_ON_ONCE(!hlist_empty(&q->instance_table[i]));
 }
 
-static void nfnl_queue_net_exit_batch(struct list_head *net_exit_list)
-{
-	synchronize_rcu();
-}
-
 static struct pernet_operations nfnl_queue_net_ops = {
 	.init		= nfnl_queue_net_init,
 	.exit		= nfnl_queue_net_exit,
-	.exit_batch	= nfnl_queue_net_exit_batch,
 	.id		= &nfnl_queue_net_id,
 	.size		= sizeof(struct nfnl_queue_net),
 };
-- 
2.30.2

