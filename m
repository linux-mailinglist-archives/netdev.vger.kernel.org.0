Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCEE156E2
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 02:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfEGAYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 20:24:44 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37660 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbfEGAYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 20:24:43 -0400
Received: by mail-qt1-f193.google.com with SMTP id o7so5127432qtp.4
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 17:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HO8Asfar3dW8Pa/bH/BqsaFhjMzRZ74FdAbgbn+NWNg=;
        b=sN52IbR7a4oPWJMO+NzlIeGRI+X5q7ZYph969XYLBCNXDMu10UkcC03sD4NxX2eKVM
         3PpcscuMui8RH0BezUcA8xiWCrNVQ976WtVMlmWiHcU1621zrf1Jo4w3hJj39ef/I7rh
         mRtjmN7n2p19TwYwK/k9uFBqSyGXjB4oxlLC2n0uA06almQtqZZLoiqWBN4+CjS6Izui
         /DoMJdXmEdYtUHFs4BUBelCGxXXn6PRzGpGGJZEZTUlHfnJIbo76g4PGoRDT3+Wq9qxc
         fS2NQTW+Hv3isKCmC0pSiSqToF2AChQoArrfe8yG3QUAAlQYsjT+K6+NyAptST/dkl4e
         85jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HO8Asfar3dW8Pa/bH/BqsaFhjMzRZ74FdAbgbn+NWNg=;
        b=MjHp8o5bdxyYjiZCcFWz/+mHrzIUi1PKL48dN3HXYfo+z1spjU/MtBfiu6fyXCtYz1
         K/fOTBxF4EfvM95xeEQhePCMRHWm1DMjQysepvshKYojuLi6TgQX015z8nj9W3KJZMsI
         JIpqCezT4FFtv5wiVt2iL+O9Kd1Md/vwvVebukuyzH3PQjMhAP1gqtF5I9XBFjx6lT2G
         86VC1BOuWXhFWr5YTGN3FUDRU4oKx/ymgz4P06lUHSJ1WBmySEoK1BC/h8FADpKoRniw
         V7IB9xLW36BlyPOuIySwkoDimbVuw1v/MZ7SK6Nr2/yFTOLS/w61X+FEYg7Pu3a4sL85
         8hlQ==
X-Gm-Message-State: APjAAAVNOMQOZkOnBwzhflqMmfcXCUHcLnaUmIeMnVMh2aBHS4Ufa4Cp
        hwXa8E8pNgpMkFyJjeG+guf+XA==
X-Google-Smtp-Source: APXvYqzBAmxrR8+Py3d4+12ZJ1zC9pRcLmtbDi7jMyhojbaKsr+zUNPGtkBsYV1ugemcYsBkQn14PQ==
X-Received: by 2002:a0c:afc8:: with SMTP id t8mr22849116qvc.123.1557188682486;
        Mon, 06 May 2019 17:24:42 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m26sm3710760qtp.8.2019.05.06.17.24.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 17:24:41 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net, jiri@resnulli.us
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        xiyou.wangcong@gmail.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next] net/sched: remove block pointer from common offload structure
Date:   Mon,  6 May 2019 17:24:21 -0700
Message-Id: <20190507002421.32690-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Based on feedback from Jiri avoid carrying a pointer to the tcf_block
structure in the tc_cls_common_offload structure. Instead store
a flag in driver private data which indicates if offloads apply
to a shared block at block binding time.

Suggested-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
Quick follow up to the series from two days ago, implementing Jiri's
suggestion.  Doesn't look like the trees got merged, yet, so I'm
putting net-next in the subject 🤞
---
 .../net/ethernet/netronome/nfp/flower/main.h    |  2 ++
 .../net/ethernet/netronome/nfp/flower/offload.c |  4 ++++
 .../ethernet/netronome/nfp/flower/qos_conf.c    |  4 ++--
 include/net/pkt_cls.h                           |  3 ---
 net/sched/cls_bpf.c                             |  8 +++-----
 net/sched/cls_flower.c                          | 11 ++++-------
 net/sched/cls_matchall.c                        | 12 ++++--------
 net/sched/cls_u32.c                             | 17 ++++++-----------
 8 files changed, 25 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 6a6be7285105..40957a8dbfe6 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -215,6 +215,7 @@ struct nfp_fl_qos {
  * @lag_port_flags:	Extended port flags to record lag state of repr
  * @mac_offloaded:	Flag indicating a MAC address is offloaded for repr
  * @offloaded_mac_addr:	MAC address that has been offloaded for repr
+ * @block_shared:	Flag indicating if offload applies to shared blocks
  * @mac_list:		List entry of reprs that share the same offloaded MAC
  * @qos_table:		Stored info on filters implementing qos
  */
@@ -223,6 +224,7 @@ struct nfp_flower_repr_priv {
 	unsigned long lag_port_flags;
 	bool mac_offloaded;
 	u8 offloaded_mac_addr[ETH_ALEN];
+	bool block_shared;
 	struct list_head mac_list;
 	struct nfp_fl_qos qos_table;
 };
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 9c6bcc6e9d68..1fbfeb43c538 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1197,10 +1197,14 @@ static int nfp_flower_setup_tc_block(struct net_device *netdev,
 				     struct tc_block_offload *f)
 {
 	struct nfp_repr *repr = netdev_priv(netdev);
+	struct nfp_flower_repr_priv *repr_priv;
 
 	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
 
+	repr_priv = repr->app_priv;
+	repr_priv->block_shared = tcf_block_shared(f->block);
+
 	switch (f->command) {
 	case TC_BLOCK_BIND:
 		return tcf_block_cb_register(f->block,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 1b2ee18d7ff9..86e968cd5ffd 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -76,8 +76,9 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 		return -EOPNOTSUPP;
 	}
 	repr = netdev_priv(netdev);
+	repr_priv = repr->app_priv;
 
-	if (tcf_block_shared(flow->common.block)) {
+	if (repr_priv->block_shared) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload not supported on shared blocks");
 		return -EOPNOTSUPP;
 	}
@@ -123,7 +124,6 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 	config->cir = cpu_to_be32(rate);
 	nfp_ctrl_tx(repr->app->ctrl, skb);
 
-	repr_priv = repr->app_priv;
 	repr_priv->qos_table.netdev_port_id = netdev_port_id;
 	fl_priv->qos_rate_limiters++;
 	if (fl_priv->qos_rate_limiters == 1)
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index eed98f8fcb5e..514e3c80ecc1 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -629,7 +629,6 @@ struct tc_cls_common_offload {
 	u32 chain_index;
 	__be16 protocol;
 	u32 prio;
-	struct tcf_block *block;
 	struct netlink_ext_ack *extack;
 };
 
@@ -731,13 +730,11 @@ static inline bool tc_in_hw(u32 flags)
 static inline void
 tc_cls_common_offload_init(struct tc_cls_common_offload *cls_common,
 			   const struct tcf_proto *tp, u32 flags,
-			   struct tcf_block *block,
 			   struct netlink_ext_ack *extack)
 {
 	cls_common->chain_index = tp->chain->index;
 	cls_common->protocol = tp->protocol;
 	cls_common->prio = tp->prio;
-	cls_common->block = block;
 	if (tc_skip_sw(flags) || flags & TCA_CLS_FLAGS_VERBOSE)
 		cls_common->extack = extack;
 }
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index ce7ff286ccb8..27365ed3fe0b 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -157,8 +157,7 @@ static int cls_bpf_offload_cmd(struct tcf_proto *tp, struct cls_bpf_prog *prog,
 	skip_sw = prog && tc_skip_sw(prog->gen_flags);
 	obj = prog ?: oldprog;
 
-	tc_cls_common_offload_init(&cls_bpf.common, tp, obj->gen_flags, block,
-				   extack);
+	tc_cls_common_offload_init(&cls_bpf.common, tp, obj->gen_flags, extack);
 	cls_bpf.command = TC_CLSBPF_OFFLOAD;
 	cls_bpf.exts = &obj->exts;
 	cls_bpf.prog = prog ? prog->filter : NULL;
@@ -227,8 +226,7 @@ static void cls_bpf_offload_update_stats(struct tcf_proto *tp,
 	struct tcf_block *block = tp->chain->block;
 	struct tc_cls_bpf_offload cls_bpf = {};
 
-	tc_cls_common_offload_init(&cls_bpf.common, tp, prog->gen_flags, block,
-				   NULL);
+	tc_cls_common_offload_init(&cls_bpf.common, tp, prog->gen_flags, NULL);
 	cls_bpf.command = TC_CLSBPF_STATS;
 	cls_bpf.exts = &prog->exts;
 	cls_bpf.prog = prog->filter;
@@ -670,7 +668,7 @@ static int cls_bpf_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 			continue;
 
 		tc_cls_common_offload_init(&cls_bpf.common, tp, prog->gen_flags,
-					   block, extack);
+					   extack);
 		cls_bpf.command = TC_CLSBPF_OFFLOAD;
 		cls_bpf.exts = &prog->exts;
 		cls_bpf.prog = add ? prog->filter : NULL;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 3cb372b0e933..f6685fc53119 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -389,8 +389,7 @@ static void fl_hw_destroy_filter(struct tcf_proto *tp, struct cls_fl_filter *f,
 	if (!rtnl_held)
 		rtnl_lock();
 
-	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, block,
-				   extack);
+	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, extack);
 	cls_flower.command = TC_CLSFLOWER_DESTROY;
 	cls_flower.cookie = (unsigned long) f;
 
@@ -423,8 +422,7 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 		goto errout;
 	}
 
-	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, block,
-				   extack);
+	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, extack);
 	cls_flower.command = TC_CLSFLOWER_REPLACE;
 	cls_flower.cookie = (unsigned long) f;
 	cls_flower.rule->match.dissector = &f->mask->dissector;
@@ -480,8 +478,7 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
 	if (!rtnl_held)
 		rtnl_lock();
 
-	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, block,
-				   NULL);
+	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, NULL);
 	cls_flower.command = TC_CLSFLOWER_STATS;
 	cls_flower.cookie = (unsigned long) f;
 	cls_flower.classid = f->res.classid;
@@ -1760,7 +1757,7 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 		}
 
 		tc_cls_common_offload_init(&cls_flower.common, tp, f->flags,
-					   block, extack);
+					   extack);
 		cls_flower.command = add ?
 			TC_CLSFLOWER_REPLACE : TC_CLSFLOWER_DESTROY;
 		cls_flower.cookie = (unsigned long)f;
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 820938fa09ed..da916f39b719 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -71,8 +71,7 @@ static void mall_destroy_hw_filter(struct tcf_proto *tp,
 	struct tc_cls_matchall_offload cls_mall = {};
 	struct tcf_block *block = tp->chain->block;
 
-	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, block,
-				   extack);
+	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, extack);
 	cls_mall.command = TC_CLSMATCHALL_DESTROY;
 	cls_mall.cookie = cookie;
 
@@ -94,8 +93,7 @@ static int mall_replace_hw_filter(struct tcf_proto *tp,
 	if (!cls_mall.rule)
 		return -ENOMEM;
 
-	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, block,
-				   extack);
+	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, extack);
 	cls_mall.command = TC_CLSMATCHALL_REPLACE;
 	cls_mall.cookie = cookie;
 
@@ -295,8 +293,7 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 	if (!cls_mall.rule)
 		return -ENOMEM;
 
-	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, block,
-				   extack);
+	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, extack);
 	cls_mall.command = add ?
 		TC_CLSMATCHALL_REPLACE : TC_CLSMATCHALL_DESTROY;
 	cls_mall.cookie = (unsigned long)head;
@@ -331,8 +328,7 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
 	struct tc_cls_matchall_offload cls_mall = {};
 	struct tcf_block *block = tp->chain->block;
 
-	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, block,
-				   NULL);
+	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, NULL);
 	cls_mall.command = TC_CLSMATCHALL_STATS;
 	cls_mall.cookie = cookie;
 
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 2feed0ffa269..4b8710a266cc 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -485,8 +485,7 @@ static void u32_clear_hw_hnode(struct tcf_proto *tp, struct tc_u_hnode *h,
 	struct tcf_block *block = tp->chain->block;
 	struct tc_cls_u32_offload cls_u32 = {};
 
-	tc_cls_common_offload_init(&cls_u32.common, tp, h->flags, block,
-				   extack);
+	tc_cls_common_offload_init(&cls_u32.common, tp, h->flags, extack);
 	cls_u32.command = TC_CLSU32_DELETE_HNODE;
 	cls_u32.hnode.divisor = h->divisor;
 	cls_u32.hnode.handle = h->handle;
@@ -504,7 +503,7 @@ static int u32_replace_hw_hnode(struct tcf_proto *tp, struct tc_u_hnode *h,
 	bool offloaded = false;
 	int err;
 
-	tc_cls_common_offload_init(&cls_u32.common, tp, flags, block, extack);
+	tc_cls_common_offload_init(&cls_u32.common, tp, flags, extack);
 	cls_u32.command = TC_CLSU32_NEW_HNODE;
 	cls_u32.hnode.divisor = h->divisor;
 	cls_u32.hnode.handle = h->handle;
@@ -530,8 +529,7 @@ static void u32_remove_hw_knode(struct tcf_proto *tp, struct tc_u_knode *n,
 	struct tcf_block *block = tp->chain->block;
 	struct tc_cls_u32_offload cls_u32 = {};
 
-	tc_cls_common_offload_init(&cls_u32.common, tp, n->flags, block,
-				   extack);
+	tc_cls_common_offload_init(&cls_u32.common, tp, n->flags, extack);
 	cls_u32.command = TC_CLSU32_DELETE_KNODE;
 	cls_u32.knode.handle = n->handle;
 
@@ -548,7 +546,7 @@ static int u32_replace_hw_knode(struct tcf_proto *tp, struct tc_u_knode *n,
 	bool skip_sw = tc_skip_sw(flags);
 	int err;
 
-	tc_cls_common_offload_init(&cls_u32.common, tp, flags, block, extack);
+	tc_cls_common_offload_init(&cls_u32.common, tp, flags, extack);
 	cls_u32.command = TC_CLSU32_REPLACE_KNODE;
 	cls_u32.knode.handle = n->handle;
 	cls_u32.knode.fshift = n->fshift;
@@ -1172,12 +1170,10 @@ static int u32_reoffload_hnode(struct tcf_proto *tp, struct tc_u_hnode *ht,
 			       bool add, tc_setup_cb_t *cb, void *cb_priv,
 			       struct netlink_ext_ack *extack)
 {
-	struct tcf_block *block = tp->chain->block;
 	struct tc_cls_u32_offload cls_u32 = {};
 	int err;
 
-	tc_cls_common_offload_init(&cls_u32.common, tp, ht->flags, block,
-				   extack);
+	tc_cls_common_offload_init(&cls_u32.common, tp, ht->flags, extack);
 	cls_u32.command = add ? TC_CLSU32_NEW_HNODE : TC_CLSU32_DELETE_HNODE;
 	cls_u32.hnode.divisor = ht->divisor;
 	cls_u32.hnode.handle = ht->handle;
@@ -1199,8 +1195,7 @@ static int u32_reoffload_knode(struct tcf_proto *tp, struct tc_u_knode *n,
 	struct tc_cls_u32_offload cls_u32 = {};
 	int err;
 
-	tc_cls_common_offload_init(&cls_u32.common, tp, n->flags, block,
-				   extack);
+	tc_cls_common_offload_init(&cls_u32.common, tp, n->flags, extack);
 	cls_u32.command = add ?
 		TC_CLSU32_REPLACE_KNODE : TC_CLSU32_DELETE_KNODE;
 	cls_u32.knode.handle = n->handle;
-- 
2.21.0

