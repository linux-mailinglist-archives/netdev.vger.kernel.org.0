Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8581E17BDEC
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgCFNPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:15:05 -0500
Received: from mail-eopbgr60073.outbound.protection.outlook.com ([40.107.6.73]:24838
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbgCFNPE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 08:15:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYPr7g2uPECUfLPYXvhzBa6NwdPMAR+n7MLRwx5hxocqtjTdfMLP4vDFz0REBTTURTwLLynlZdswAY4fc/LEKwppniHdVy6z0mEapkpiH6qpsxuEJ1rJMvJ8bMFnmelwDKVp4owM2xgFpoa8yOIMUClAPIiM1vjy1RsDEvlrgtMieFyCozN/FCbpHID2Kgp0bpfPUfqYY3wBN38SJS6q2Y+Ku0l83vcyvQ0wYrZlcJE2b/BrWcQaTU0NHVsfX+Eb2bTKoaQswik+ennTay7ooFOgBDBugYBw5LdtwZQqBLvJFRynvkXVuNTfaPULe8OPIfhp1Lk75OptkjuEp7YhMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DAgc2UspUk0K/Fz2+16UGv34n3RRZjNj7IB0eezktk=;
 b=OQ9+xGg1wmxzrxpqFsQbe/y2GmzOXjDABa00mTaDhnn9PZSKuDhuWx3wc6nNyIL6Of+6LzLeFKslCkK9rditniohfYLOQHQ2t0Nnhq86E2nW11yZ098XUEO2qD9Alfbe4F8YkJmhquCef9neQgbEqPWyjFY2Emafek2+hGZ7hiLg0okt5rlmCQTeaVIgG9htkcMjXm6LAlApi5aw1RnbI/+T4EIv0rZz4Fh6IPhje9yie0KEPLDdr8rUm9epSNqEt6nvImGiQHdXm4yzDjpwRu39ReRTrT5nM9URDzLzg5ZT6kdVogbbOFyYH2s0OOG8Ok/bM6cwixB1dVS0Cc/8Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DAgc2UspUk0K/Fz2+16UGv34n3RRZjNj7IB0eezktk=;
 b=RIjD6b0C2xoxYgny3RNoF0NvX1uzOgJle7Jfa4ZczcP7oAC8Sg3oG0Wg5wfsW5SvC1Vl8RuctQ1/6eziY5pom9LMnCtGeaTt0PZAIkAv4pkT2DOwTRLKiNl+7HeMHw7OdBEQxDQKOiBUaMSBJb8VEUKVaMtpmXi0Ci7pTIPZZiM=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6718.eurprd04.prod.outlook.com (20.179.234.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.16; Fri, 6 Mar 2020 13:15:01 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2772.019; Fri, 6 Mar 2020
 13:15:01 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, roy.zang@nxp.com, mingkai.hu@nxp.com,
        jerry.huang@nxp.com, leoyang.li@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        john.hurley@netronome.com, simon.horman@netronome.com,
        pieter.jansenvanvuuren@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, ivan.khoronzhuk@linaro.org,
        m-karicheri2@ti.com, andre.guedes@linux.intel.com,
        jakub.kicinski@netronome.com, Po Liu <Po.Liu@nxp.com>
Subject: [RFC,net-next  3/9] net: schedule: add action gate offloading
Date:   Fri,  6 Mar 2020 20:56:01 +0800
Message-Id: <20200306125608.11717-4-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306125608.11717-1-Po.Liu@nxp.com>
References: <20200306125608.11717-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0205.apcprd06.prod.outlook.com
 (2603:1096:4:68::13) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR06CA0205.apcprd06.prod.outlook.com (2603:1096:4:68::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Fri, 6 Mar 2020 13:14:51 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 612d61d4-d7ec-4bd6-b998-08d7c1d05fee
X-MS-TrafficTypeDiagnostic: VE1PR04MB6718:|VE1PR04MB6718:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6718A8321EE912EBC545402792E30@VE1PR04MB6718.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 0334223192
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(199004)(189003)(36756003)(5660300002)(66946007)(66476007)(66556008)(6666004)(478600001)(316002)(2616005)(86362001)(956004)(4326008)(26005)(6506007)(6486002)(6512007)(52116002)(16526019)(8936002)(186003)(69590400007)(81166006)(1076003)(81156014)(7416002)(8676002)(2906002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6718;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hhb5gJVA5UiXAgurxBYszuJwPjHf0eua86o+OxL4cfM3lxCrQOUjbnGp9K1wEQkjew3hmLNxkhh7efYwFFZ7el3ieg/fQ4CJ5DmjWqHoJ+/6JlBEIdCZd9h3J6ilo3r24YltkmySkfmX0jj+1tOyEXZT5hgIR1cCWZg4ycrZRw42k5HjCBae2scWXTAUQXrqDOpEQ05HcBxJcbELlWabIhOtU6inh3zrxGkU93279MmGiKF3HztRRiamH+eLQBbi6qTpz9U1QkbWjqhtrOk9aYGkIHxtOEJhoK1br/+3Tx+JRc7PhEt/pXXSIHo5lz41NbyWi8JieJmWtiQwULaJT84S42TLOtFvobI1Dg21Aoxs5400fYIX9TQ5R11XhzoAJoUgPYXalbw1QEIVsOmX2fzXQRnYP5Vmjj6NyyRHn7/jcaAln75qfPG76ZIZaXIS7AcI5SpOdBUHpgWXPIhTLAQVsDi33j34U3LKEpu1CjOh2PG3dXYgfTHTjtuAo5Kd363+Uj00F0vu596Bgg7YLg==
X-MS-Exchange-AntiSpam-MessageData: w24/ge6L6FzMGcYRsh0wUhlywwCeuwfE6mLjf8CKOotNm8vd6iNqTQQIxanmE4+44E5f4DWXk7wCM/ebilxYhNE+NOEpBWlubL9T31KqBjYE0hBRMgKnB6Ef/wmmJr7Go2+DyIsZ2ectXh6UitpZOQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 612d61d4-d7ec-4bd6-b998-08d7c1d05fee
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2020 13:15:00.8420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PgJ0apCh/7PNh3G4zEclAvqgbjNJ6FLGYEHFLXNTOgXD9ggoUcj9UNcxHU7/bzLj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6718
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the gate action to the flow action entry. Add the gate parameters to
the tc_setup_flow_action() queueing to the entries of flow_action_entry
array provide to the driver.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 include/net/flow_offload.h   |  10 +++
 include/net/tc_act/tc_gate.h | 115 +++++++++++++++++++++++++++++++++++
 net/sched/cls_api.c          |  33 ++++++++++
 3 files changed, 158 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index eb013ffc24f3..7f5a097f5072 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -138,6 +138,7 @@ enum flow_action_id {
 	FLOW_ACTION_MPLS_PUSH,
 	FLOW_ACTION_MPLS_POP,
 	FLOW_ACTION_MPLS_MANGLE,
+	FLOW_ACTION_GATE,
 	NUM_FLOW_ACTIONS,
 };
 
@@ -223,6 +224,15 @@ struct flow_action_entry {
 			u8		bos;
 			u8		ttl;
 		} mpls_mangle;
+		struct {
+			u32		index;
+			s32		prio;
+			u64		basetime;
+			u64		cycletime;
+			u64		cycletimeext;
+			u32		num_entries;
+			struct action_gate_entry *entries;
+		} gate;
 	};
 	struct flow_action_cookie *cookie; /* user defined action cookie */
 };
diff --git a/include/net/tc_act/tc_gate.h b/include/net/tc_act/tc_gate.h
index 932a2b91b944..d93fa0d6f516 100644
--- a/include/net/tc_act/tc_gate.h
+++ b/include/net/tc_act/tc_gate.h
@@ -7,6 +7,13 @@
 #include <net/act_api.h>
 #include <linux/tc_act/tc_gate.h>
 
+struct action_gate_entry {
+	u8			gate_state;
+	u32			interval;
+	s32			ipv;
+	s32			maxoctets;
+};
+
 struct tcfg_gate_entry {
 	int			index;
 	u8			gate_state;
@@ -51,4 +58,112 @@ struct tcf_gate {
 #define get_gate_param(act) ((struct tcf_gate_params *)act)
 #define get_gate_action(p) ((struct gate_action *)p)
 
+static inline bool is_tcf_gate(const struct tc_action *a)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	if (a->ops && a->ops->id == TCA_ID_GATE)
+		return true;
+#endif
+	return false;
+}
+
+static inline u32 tcf_gate_index(const struct tc_action *a)
+{
+	return a->tcfa_index;
+}
+
+static inline s32 tcf_gate_prio(const struct tc_action *a)
+{
+	s32 tcfg_prio;
+
+	rcu_read_lock();
+	tcfg_prio = rcu_dereference(to_gate(a)->actg)->param.tcfg_priority;
+	rcu_read_unlock();
+
+	return tcfg_prio;
+}
+
+static inline u64 tcf_gate_basetime(const struct tc_action *a)
+{
+	u64 tcfg_basetime;
+
+	rcu_read_lock();
+	tcfg_basetime =
+		rcu_dereference(to_gate(a)->actg)->param.tcfg_basetime;
+	rcu_read_unlock();
+
+	return tcfg_basetime;
+}
+
+static inline u64 tcf_gate_cycletime(const struct tc_action *a)
+{
+	u64 tcfg_cycletime;
+
+	rcu_read_lock();
+	tcfg_cycletime =
+		rcu_dereference(to_gate(a)->actg)->param.tcfg_cycletime;
+	rcu_read_unlock();
+
+	return tcfg_cycletime;
+}
+
+static inline u64 tcf_gate_cycletimeext(const struct tc_action *a)
+{
+	u64 tcfg_cycletimeext;
+
+	rcu_read_lock();
+	tcfg_cycletimeext =
+		rcu_dereference(to_gate(a)->actg)->param.tcfg_cycletime_ext;
+	rcu_read_unlock();
+
+	return tcfg_cycletimeext;
+}
+
+static inline u32 tcf_gate_num_entries(const struct tc_action *a)
+{
+	u32 num_entries;
+
+	rcu_read_lock();
+	num_entries =
+		rcu_dereference(to_gate(a)->actg)->param.num_entries;
+	rcu_read_unlock();
+
+	return num_entries;
+}
+
+static inline struct action_gate_entry
+			*tcf_gate_get_list(const struct tc_action *a)
+{
+	struct action_gate_entry *oe;
+	struct tcf_gate_params *p;
+	struct tcfg_gate_entry *entry;
+	u32 num_entries;
+	int i = 0;
+
+	rcu_read_lock();
+	p = &(rcu_dereference(to_gate(a)->actg)->param);
+	num_entries = p->num_entries;
+	rcu_read_unlock();
+
+	list_for_each_entry(entry, &p->entries, list)
+		i++;
+
+	if (i != num_entries)
+		return NULL;
+
+	oe = kzalloc(sizeof(*oe) * num_entries, GFP_KERNEL);
+	if (!oe)
+		return NULL;
+
+	i = 0;
+	list_for_each_entry(entry, &p->entries, list) {
+		oe[i].gate_state = entry->gate_state;
+		oe[i].interval = entry->interval;
+		oe[i].ipv = entry->ipv;
+		oe[i].maxoctets = entry->maxoctets;
+		i++;
+	}
+
+	return oe;
+}
 #endif
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 4e766c5ab77a..0ada7b2a5c2c 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -38,6 +38,7 @@
 #include <net/tc_act/tc_skbedit.h>
 #include <net/tc_act/tc_ct.h>
 #include <net/tc_act/tc_mpls.h>
+#include <net/tc_act/tc_gate.h>
 #include <net/flow_offload.h>
 
 extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
@@ -3458,6 +3459,27 @@ static void tcf_sample_get_group(struct flow_action_entry *entry,
 #endif
 }
 
+static void tcf_gate_entry_destructor(void *priv)
+{
+	struct action_gate_entry *oe = priv;
+
+	kfree(oe);
+}
+
+static int tcf_gate_get_entries(struct flow_action_entry *entry,
+				const struct tc_action *act)
+{
+	entry->gate.entries = tcf_gate_get_list(act);
+
+	if (!entry->gate.entries)
+		return -EINVAL;
+
+	entry->destructor = tcf_gate_entry_destructor;
+	entry->destructor_priv = entry->gate.entries;
+
+	return 0;
+}
+
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts)
 {
@@ -3592,6 +3614,17 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 		} else if (is_tcf_skbedit_ptype(act)) {
 			entry->id = FLOW_ACTION_PTYPE;
 			entry->ptype = tcf_skbedit_ptype(act);
+		} else if (is_tcf_gate(act)) {
+			entry->id = FLOW_ACTION_GATE;
+			entry->gate.index = tcf_gate_index(act);
+			entry->gate.prio = tcf_gate_prio(act);
+			entry->gate.basetime = tcf_gate_basetime(act);
+			entry->gate.cycletime = tcf_gate_cycletime(act);
+			entry->gate.cycletimeext = tcf_gate_cycletimeext(act);
+			entry->gate.num_entries = tcf_gate_num_entries(act);
+			err = tcf_gate_get_entries(entry, act);
+			if (err)
+				goto err_out;
 		} else {
 			err = -EOPNOTSUPP;
 			goto err_out_locked;
-- 
2.17.1

