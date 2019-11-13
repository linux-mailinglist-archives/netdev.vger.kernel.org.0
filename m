Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85964FA921
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 05:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfKMEqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 23:46:50 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:41526 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbfKMEqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 23:46:50 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id E34D54184C;
        Wed, 13 Nov 2019 12:46:43 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, davem@davemloft.net
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 2/4] netfilter: flow_table_core: remove unnecessary parameter in flow_offload_fill_dir
Date:   Wed, 13 Nov 2019 12:46:40 +0800
Message-Id: <1573620402-10318-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573620402-10318-1-git-send-email-wenxu@ucloud.cn>
References: <1573620402-10318-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUlNS0tLSkNCTENKSkJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ny46Ghw*STg0IRQdCEkVHQ0u
        PkwaCjxVSlVKTkxITUlLT0tIQkJPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlJTE03Bg++
X-HM-Tid: 0a6e6315ceed2086kuqye34d54184c
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The ct is already in the struct flow_offload. We should remove it

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 8468d2d..9889d52 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -18,11 +18,11 @@
 static LIST_HEAD(flowtables);
 
 static void
-flow_offload_fill_dir(struct flow_offload *flow, struct nf_conn *ct,
+flow_offload_fill_dir(struct flow_offload *flow,
 		      enum flow_offload_tuple_dir dir)
 {
 	struct flow_offload_tuple *ft = &flow->tuplehash[dir].tuple;
-	struct nf_conntrack_tuple *ctt = &ct->tuplehash[dir].tuple;
+	struct nf_conntrack_tuple *ctt = &flow->ct->tuplehash[dir].tuple;
 
 	ft->dir = dir;
 
@@ -57,8 +57,8 @@ struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 
 	flow->ct = ct;
 
-	flow_offload_fill_dir(flow, ct, FLOW_OFFLOAD_DIR_ORIGINAL);
-	flow_offload_fill_dir(flow, ct, FLOW_OFFLOAD_DIR_REPLY);
+	flow_offload_fill_dir(flow, FLOW_OFFLOAD_DIR_ORIGINAL);
+	flow_offload_fill_dir(flow, FLOW_OFFLOAD_DIR_REPLY);
 
 	if (ct->status & IPS_SRC_NAT)
 		flow->flags |= FLOW_OFFLOAD_SNAT;
-- 
1.8.3.1

