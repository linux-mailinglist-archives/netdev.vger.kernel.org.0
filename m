Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0DB36E697
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 10:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239672AbhD2ILM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 04:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbhD2ILK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 04:11:10 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7143C06138B
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 01:10:24 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id l4so98493644ejc.10
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 01:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C6WbTJO/zDdD2tvAgG9xj+2NPAbiJB4oUtQs/y3G1S0=;
        b=Gt33oDeMYDVzUqCDY8+o1mR9w7UrrtHVngjAnzFNGXSBBShpAs9mTiTDQs2KXfbtvG
         sJ3xbrOqCeDWdsm6WyvFoj3Wt47o4+2b0nUgDJDWZRONOz9pH1lMnbm0LbV06wQX+UMi
         JW7nnGZo7DbyJy29umMSnT0W4d5POOaUst2ttjX43x9Ds/ESxjxYc5nIiAlHZ+hcXP3x
         8pmv3PWv7PbuJuyhZZC8ooXAqOPivA/SNvmRcWP7VzL2ETGQxTPoVBQ2byw8zhhfETVZ
         xixJDpLeANqBeJXz1w5b0zI4clJ8S4ipovnfanywFxN6TK/09BfriKRGCIvq3xKKLykb
         ze5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C6WbTJO/zDdD2tvAgG9xj+2NPAbiJB4oUtQs/y3G1S0=;
        b=ow+y7MxYWpwSzQnzO9WypVKDkBthW+78axpzzdnz8rggRIJs02gGvS8hshOTPNkRrZ
         82Tv4Nr6BZ6BL1d4ekHK5n0bgtqzMwgHwWDsANR40LEaFxX86GBpnIiHhynWrMD9x0XX
         j0doCss/SodhglT41Gj0Lupj1onR3/WzYVklEvj5zHRUkNZIhupmbLysZKaEqCc4MRlp
         eiqviEkPadFvhrziIEgez3KkCmNSlXpIX5oJxW94o7N8PoMUY0VlMdkzNUBMzJ52hPFy
         aMAVAcjkgf0gi3oZy7rtVzzs81T9WDYT9VMY+QM+eMiG/MR3N+V9FcSp0dauBTcecqb4
         59Tg==
X-Gm-Message-State: AOAM533PpOFRYRc0l4JRRzJpy1Cp7B58fBnCjcocrdJMSbRdtmukixdm
        Q+VKbHiuLwG14U+Kq8wcy6mYyw==
X-Google-Smtp-Source: ABdhPJyElm8FkuAga4szBb95axEw53Phpun56VwW46PTCAF/qf7d3hieIpDgm186u78hjvtgpgbExA==
X-Received: by 2002:a17:907:7882:: with SMTP id ku2mr15354186ejc.346.1619683823324;
        Thu, 29 Apr 2021 01:10:23 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id b19sm841188edd.66.2021.04.29.01.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 01:10:22 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [RFC net-next] net/flow_offload: allow user to offload tc action to net device
Date:   Thu, 29 Apr 2021 10:10:14 +0200
Message-Id: <20210429081014.28498-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to offload
tc actions independent of flows.

The motivation for this work is to prepare for using TC police action
instances to provide hardware offload of OVS metering feature - which calls
for policers that may be used my multiple flows and whose lifecycle is
independent of any flows that use them.

This patch includes basic changes to offload drivers to return EOPNOTSUPP
if this feature is used - it is not yet supported by any driver.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  2 +-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  3 ++
 .../ethernet/netronome/nfp/flower/offload.c   |  3 ++
 include/linux/netdevice.h                     |  1 +
 include/net/flow_offload.h                    | 15 ++++++++
 include/net/pkt_cls.h                         |  6 ++++
 include/net/tc_act/tc_police.h                |  5 +++
 net/core/flow_offload.c                       | 26 +++++++++++++-
 net/sched/act_api.c                           | 30 ++++++++++++++++
 net/sched/cls_api.c                           | 34 ++++++++++++++++---
 10 files changed, 119 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 5e4429b14b8c..edbbf7b4df77 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1951,7 +1951,7 @@ static int bnxt_tc_setup_indr_cb(struct net_device *netdev, struct Qdisc *sch, v
 				 void *data,
 				 void (*cleanup)(struct flow_block_cb *block_cb))
 {
-	if (!bnxt_is_netdev_indr_offload(netdev))
+	if (!netdev || !bnxt_is_netdev_indr_offload(netdev))
 		return -EOPNOTSUPP;
 
 	switch (type) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 6cdc52d50a48..c8dde4bc3961 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -490,6 +490,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, struct Qdisc *sch, void *
 			    void *data,
 			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
+	if (!netdev)
+		return -EOPNOTSUPP;
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
 		return mlx5e_rep_indr_setup_block(netdev, sch, cb_priv, type_data,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index e95969c462e4..f6c665051173 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1839,6 +1839,9 @@ nfp_flower_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch, void *
 			    void *data,
 			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
+	if (!netdev)
+		return -EOPNOTSUPP;
+
 	if (!nfp_fl_is_netdev_to_offload(netdev))
 		return -EOPNOTSUPP;
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5cbc950b34df..2f8cb65d85d1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -923,6 +923,7 @@ enum tc_setup_type {
 	TC_SETUP_QDISC_TBF,
 	TC_SETUP_QDISC_FIFO,
 	TC_SETUP_QDISC_HTB,
+	TC_SETUP_ACT,
 };
 
 /* These structures hold the attributes of bpf state that are being passed
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index dc5c1e69cd9f..5fd8b5600b4a 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -551,6 +551,21 @@ struct flow_cls_offload {
 	u32 classid;
 };
 
+enum flow_act_command {
+	FLOW_ACT_REPLACE,
+	FLOW_ACT_DESTROY,
+	FLOW_ACT_STATS,
+};
+
+struct flow_offload_action {
+	struct netlink_ext_ack *extack;
+	enum flow_act_command command;
+	struct flow_stats stats;
+	struct flow_action action;
+};
+
+struct flow_offload_action *flow_action_alloc(unsigned int num_actions);
+
 static inline struct flow_rule *
 flow_cls_offload_flow_rule(struct flow_cls_offload *flow_cmd)
 {
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 255e4f4b521f..5c6549ae0cc7 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -266,6 +266,9 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 	for (; 0; (void)(i), (void)(a), (void)(exts))
 #endif
 
+#define tcf_act_for_each_action(i, a, actions) \
+	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
+
 static inline void
 tcf_exts_stats_update(const struct tcf_exts *exts,
 		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
@@ -538,6 +541,8 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
 
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts);
+int tc_setup_action(struct flow_action *flow_action,
+		    struct tc_action *actions[]);
 void tc_cleanup_flow_action(struct flow_action *flow_action);
 
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
@@ -558,6 +563,7 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
 			  enum tc_setup_type type, void *type_data,
 			  void *cb_priv, u32 *flags, unsigned int *in_hw_count);
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
+unsigned int tcf_act_num_actions(struct tc_action *actions[]);
 
 #ifdef CONFIG_NET_CLS_ACT
 int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
index 72649512dcdd..6309519bf9d4 100644
--- a/include/net/tc_act/tc_police.h
+++ b/include/net/tc_act/tc_police.h
@@ -53,6 +53,11 @@ static inline bool is_tcf_police(const struct tc_action *act)
 	return false;
 }
 
+static inline u32 tcf_police_index(const struct tc_action *act)
+{
+	return act->tcfa_index;
+}
+
 static inline u64 tcf_police_rate_bytes_ps(const struct tc_action *act)
 {
 	struct tcf_police *police = to_police(act);
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 715b67f6c62f..0fa2f75cc9b3 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -27,6 +27,27 @@ struct flow_rule *flow_rule_alloc(unsigned int num_actions)
 }
 EXPORT_SYMBOL(flow_rule_alloc);
 
+struct flow_offload_action *flow_action_alloc(unsigned int num_actions)
+{
+	struct flow_offload_action *fl_action;
+	int i;
+
+	fl_action = kzalloc(struct_size(fl_action, action.entries, num_actions),
+			    GFP_KERNEL);
+	if (!fl_action)
+		return NULL;
+
+	fl_action->action.num_entries = num_actions;
+	/* Pre-fill each action hw_stats with DONT_CARE.
+	 * Caller can override this if it wants stats for a given action.
+	 */
+	for (i = 0; i < num_actions; i++)
+		fl_action->action.entries[i].hw_stats = FLOW_ACTION_HW_STATS_DONT_CARE;
+
+	return fl_action;
+}
+EXPORT_SYMBOL(flow_action_alloc);
+
 #define FLOW_DISSECTOR_MATCH(__rule, __type, __out)				\
 	const struct flow_match *__m = &(__rule)->match;			\
 	struct flow_dissector *__d = (__m)->dissector;				\
@@ -476,6 +497,9 @@ int flow_indr_dev_setup_offload(struct net_device *dev, struct Qdisc *sch,
 
 	mutex_unlock(&flow_indr_block_lock);
 
-	return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
+	if (bo)
+		return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
+	else
+		return 0;
 }
 EXPORT_SYMBOL(flow_indr_dev_setup_offload);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index f6d5755d669e..dab24688d9c7 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1059,6 +1059,34 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	return ERR_PTR(err);
 }
 
+/* offload the tc command after inserted */
+int tcf_action_offload_cmd(struct tc_action *actions[], bool add, struct netlink_ext_ack *extack)
+{
+	int err = 0;
+	struct flow_offload_action *fl_act;
+
+	fl_act = flow_action_alloc(tcf_act_num_actions(actions));
+	if (!fl_act)
+		return -ENOMEM;
+
+	fl_act->extack = extack;
+	err = tc_setup_action(&fl_act->action, actions);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to setup tc actions for offload\n");
+		goto err_out;
+	}
+	fl_act->command = add ? FLOW_ACT_REPLACE : FLOW_ACT_DESTROY;
+
+	flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT, fl_act, NULL, NULL);
+
+	tc_cleanup_flow_action(&fl_act->action);
+
+err_out:
+	kfree(fl_act);
+	return err;
+}
+EXPORT_SYMBOL(tcf_action_offload_cmd);
+
 /* Returns numbers of initialized actions or negative error. */
 
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
@@ -1107,6 +1135,7 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 	 */
 	tcf_idr_insert_many(actions);
 
+	tcf_action_offload_cmd(actions, true, extack);
 	*attr_size = tcf_action_full_attrs_size(sz);
 	err = i - 1;
 	goto err_mod;
@@ -1465,6 +1494,7 @@ tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
 	if (event == RTM_GETACTION)
 		ret = tcf_get_notify(net, portid, n, actions, event, extack);
 	else { /* delete */
+		tcf_action_offload_cmd(actions, false, extack);
 		ret = tcf_del_notify(net, n, actions, portid, attr_size, extack);
 		if (ret)
 			goto err;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 40fbea626dfd..995024c20df6 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3551,8 +3551,8 @@ static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
 	return hw_stats;
 }
 
-int tc_setup_flow_action(struct flow_action *flow_action,
-			 const struct tcf_exts *exts)
+int tc_setup_action(struct flow_action *flow_action,
+		    struct tc_action *actions[])
 {
 	struct tc_action *act;
 	int i, j, k, err = 0;
@@ -3561,11 +3561,11 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
 
-	if (!exts)
+	if (!actions)
 		return 0;
 
 	j = 0;
-	tcf_exts_for_each_action(i, act, exts) {
+	tcf_act_for_each_action(i, act, actions) {
 		struct flow_action_entry *entry;
 
 		entry = &flow_action->entries[j];
@@ -3732,6 +3732,16 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 	spin_unlock_bh(&act->tcfa_lock);
 	goto err_out;
 }
+EXPORT_SYMBOL(tc_setup_action);
+
+int tc_setup_flow_action(struct flow_action *flow_action,
+			 const struct tcf_exts *exts)
+{
+	if (!exts)
+		return 0;
+
+	return tc_setup_action(flow_action, exts->actions);
+}
 EXPORT_SYMBOL(tc_setup_flow_action);
 
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
@@ -3750,6 +3760,22 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
 }
 EXPORT_SYMBOL(tcf_exts_num_actions);
 
+unsigned int tcf_act_num_actions(struct tc_action *actions[])
+{
+	unsigned int num_acts = 0;
+	struct tc_action *act;
+	int i;
+
+	tcf_act_for_each_action(i, act, actions) {
+		if (is_tcf_pedit(act))
+			num_acts += tcf_pedit_nkeys(act);
+		else
+			num_acts++;
+	}
+	return num_acts;
+}
+EXPORT_SYMBOL(tcf_act_num_actions);
+
 #ifdef CONFIG_NET_CLS_ACT
 static int tcf_qevent_parse_block_index(struct nlattr *block_index_attr,
 					u32 *p_block_index,
-- 
2.20.1

