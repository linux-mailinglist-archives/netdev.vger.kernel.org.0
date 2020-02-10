Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 317E6157024
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 08:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbgBJH4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 02:56:32 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9714 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726061AbgBJH4c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 02:56:32 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A2B9DFD0DD28BAA8F6C7;
        Mon, 10 Feb 2020 15:56:29 +0800 (CST)
Received: from euler.huawei.com (10.175.104.193) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Mon, 10 Feb 2020 15:56:21 +0800
From:   Chen Wandun <chenwandun@huawei.com>
To:     <jon.maloy@ericsson.com>, <ying.xue@windreiver.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <tuong.t.lien@dektech.com.au>, <netdev@vger.kernel.org>,
        <tipc-discussion@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
CC:     <chenwandun@huawei.com>
Subject: [PATCH next] tipc: make three functions static
Date:   Mon, 10 Feb 2020 16:11:09 +0800
Message-ID: <20200210081109.10664-1-chenwandun@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.104.193]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warning:

net/tipc/node.c:281:6: warning: symbol 'tipc_node_free' was not declared. Should it be static?
net/tipc/node.c:2801:5: warning: symbol '__tipc_nl_node_set_key' was not declared. Should it be static?
net/tipc/node.c:2878:5: warning: symbol '__tipc_nl_node_flush_key' was not declared. Should it be static?

Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Fixes: e1f32190cf7d ("tipc: add support for AEAD key setting via netlink")

Signed-off-by: Chen Wandun <chenwandun@huawei.com>
---
 net/tipc/node.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 99b28b69fc17..0c88778c88b5 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -278,7 +278,7 @@ struct tipc_crypto *tipc_node_crypto_rx_by_list(struct list_head *pos)
 }
 #endif
 
-void tipc_node_free(struct rcu_head *rp)
+static void tipc_node_free(struct rcu_head *rp)
 {
 	struct tipc_node *n = container_of(rp, struct tipc_node, rcu);
 
@@ -2798,7 +2798,7 @@ static int tipc_nl_retrieve_nodeid(struct nlattr **attrs, u8 **node_id)
 	return 0;
 }
 
-int __tipc_nl_node_set_key(struct sk_buff *skb, struct genl_info *info)
+static int __tipc_nl_node_set_key(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *attrs[TIPC_NLA_NODE_MAX + 1];
 	struct net *net = sock_net(skb->sk);
@@ -2875,7 +2875,8 @@ int tipc_nl_node_set_key(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
-int __tipc_nl_node_flush_key(struct sk_buff *skb, struct genl_info *info)
+static int __tipc_nl_node_flush_key(struct sk_buff *skb,
+				    struct genl_info *info)
 {
 	struct net *net = sock_net(skb->sk);
 	struct tipc_net *tn = tipc_net(net);
-- 
2.17.1

