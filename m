Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019982D2A50
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbgLHMIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:08:49 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9128 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727650AbgLHMIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 07:08:49 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CqzT33RTzz15WRj;
        Tue,  8 Dec 2020 20:07:35 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Dec 2020 20:07:58 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net/sched: cls_u32: simplify the return expression of u32_reoffload_knode()
Date:   Tue, 8 Dec 2020 20:08:22 +0800
Message-ID: <20201208120822.9100-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/sched/cls_u32.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 54209a18d7fe..6e1abe805448 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1171,7 +1171,6 @@ static int u32_reoffload_knode(struct tcf_proto *tp, struct tc_u_knode *n,
 	struct tc_u_hnode *ht = rtnl_dereference(n->ht_down);
 	struct tcf_block *block = tp->chain->block;
 	struct tc_cls_u32_offload cls_u32 = {};
-	int err;
 
 	tc_cls_common_offload_init(&cls_u32.common, tp, n->flags, extack);
 	cls_u32.command = add ?
@@ -1194,13 +1193,9 @@ static int u32_reoffload_knode(struct tcf_proto *tp, struct tc_u_knode *n,
 			cls_u32.knode.link_handle = ht->handle;
 	}
 
-	err = tc_setup_cb_reoffload(block, tp, add, cb, TC_SETUP_CLSU32,
-				    &cls_u32, cb_priv, &n->flags,
-				    &n->in_hw_count);
-	if (err)
-		return err;
-
-	return 0;
+	return tc_setup_cb_reoffload(block, tp, add, cb, TC_SETUP_CLSU32,
+				     &cls_u32, cb_priv, &n->flags,
+				     &n->in_hw_count);
 }
 
 static int u32_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
-- 
2.22.0

