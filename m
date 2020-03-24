Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCF36190422
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgCXEIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:08:16 -0400
Received: from mail-eopbgr130070.outbound.protection.outlook.com ([40.107.13.70]:62438
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725873AbgCXEIO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 00:08:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EjN2rz51h+DA6uSeSq5r2IOXfCBdvxzxvPDzbe1s9gwQOUmEVJAAj+PPk/mxwsv9ol3GCkZdpTW9qt8NIwNm+TbS++1MRFVVc8uqxJOUtnHuM9FeG0NhIujL8KwEvdOIJ9ufAln+O+drY88DioBuwM3n66lvU8IEl5nD9zBoUurEz5BEyjcV6lRJ9z5gFOb8RaMu7fUC7/O6CDqD3FgnA5PqPUCLOmQxlZLI/9p5kS11CLQ5bCtb5LXATbV38i0AhqGNJVF9hSgGl9hCciR83xodIDsWwTuYC5jinOzcYZV5/sEImYlvooBGtbblZfc/1kaU21VM+Zaiz1fSUFZSqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VtoCYoidBKQEQ96gJu8ekxkOdArNTaoOYH/dw/gq9ms=;
 b=nIKf0j/Kc8fQQfvJUx/kqUhFwKUU/5s0GEytqXALcM5GKalHu6GzAt4hqwilg09/vozWDWBc4elH6dywhqlbJH5ZHhxoKiYWJBB2S2Jgp85kGOTqcJoF3euUXvLTQbzYS+JOiK0ycKOdxj0aszziUIfe1KSU7rCXBI3R9rhwchFUgITPrpjMIVi/6QNd3dys46T6vTAkLYZNOWRR9DTF93rLZNWXFsIzRTXe5f665YeVxxF0+PhE5/gvIWZoQ2rs7fYZphOu6+QJgDcnTbYFowgUF9jKrWVe+WHpQIu0mbtdNso7/gwtXHExoLFUETaHvRwQu2+KDPmRw7Sg8HmKvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VtoCYoidBKQEQ96gJu8ekxkOdArNTaoOYH/dw/gq9ms=;
 b=svq7JFK8rWfLZipInQEknNdzt7/nTyiOjoQB3zQKfS6SWGL8p3NpcS85+90o+g+y9MJ/DdgbaF0Q6V7ha63CPPFoPn5EbcWGb8EkJ2evOhXdr8bBpi+n9DSD5KeBn2ENSy7j83OdcQp5/Tp2VpZVHjf9Y3NyhKz4xM6y6NmvYkk=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6413.eurprd04.prod.outlook.com (20.179.232.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Tue, 24 Mar 2020 04:07:45 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 04:07:45 +0000
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
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org,
        Po Liu <Po.Liu@nxp.com>
Subject: [v1,net-next  3/5] net: schedule: add action gate offloading
Date:   Tue, 24 Mar 2020 11:47:41 +0800
Message-Id: <20200324034745.30979-4-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324034745.30979-1-Po.Liu@nxp.com>
References: <20200306125608.11717-11-Po.Liu@nxp.com>
 <20200324034745.30979-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0204.apcprd06.prod.outlook.com (2603:1096:4:1::36)
 To VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR06CA0204.apcprd06.prod.outlook.com (2603:1096:4:1::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Tue, 24 Mar 2020 04:07:36 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7076e02f-ac15-4cc0-1352-08d7cfa8e7b9
X-MS-TrafficTypeDiagnostic: VE1PR04MB6413:|VE1PR04MB6413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6413DD48F0333984F6F8C65C92F10@VE1PR04MB6413.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(136003)(39860400002)(346002)(16526019)(26005)(86362001)(69590400007)(1076003)(478600001)(52116002)(6506007)(186003)(4326008)(7416002)(6512007)(6486002)(8936002)(81166006)(8676002)(81156014)(2906002)(316002)(66556008)(6666004)(956004)(66476007)(5660300002)(66946007)(36756003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6413;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2uNMFGrp93Rg7Tx5fCAXCqYC1JscYxygUqQgy5bfDnkOzDs2i8tqwd7OO1ZVQIGL3HTy4uWGgEPDVQI1/yvqiBt7zuDSjmwSMfFcP9pqrCYqrU4/OjG/gYSVp6xExEbrzOn6E60iM6reYB2geJZUy/iNIFKUjJW9CoqEVHCQvUjw7hHfe34A1omCWmA/j3MbVgn33FzuT16uePRv/M8YRr6EJv82PZ9NYqjlXhJhYovcJLTLhKM8tNMUdle9D9+OKpQMckSFnVdil5/HNyFjwOXzhGUEbWciTlmkxS3MfPgw2GU/Smt+PPHMVThblibWtENr+IPtx8hWzHgTg1mKRu6N6EwfWekjGhmB/xb030zCTJo3mOHjuFF8zGuGw2G8sgL7z/8ZjewHPlx79HdAIm1cvJfNHVacqqSXL1EWXi1nPgBp9L38kjjDwwD4rJKTMayDhTdpdocFkEmpVHPzItE55PRvL5WPhayzVeEyrnlP39yqhq5VxI57uf5CMehq
X-MS-Exchange-AntiSpam-MessageData: ppHPtc4C1/8QKpcEXB1OHmMVzqU8O8eGDZfGCHLt/TaVEdZxcGEa0aKFf3DKHVP85QI2GlknbmqQnutccs2rzXBk7yn8JWcINabI+k4sTKXzqWfaUJBI3/xu2MC4rBgBcgGdJXnQER25jw525ZUgkQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7076e02f-ac15-4cc0-1352-08d7cfa8e7b9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 04:07:44.9693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iL9bj7fbPyyh3lnrJfFCDwaWl5q3meTNfo+MWOQQbPVCNdvBMFILq9X7dlI+Ih0h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6413
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
index cae3658a1844..ef9b8fe82e85 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -147,6 +147,7 @@ enum flow_action_id {
 	FLOW_ACTION_MPLS_PUSH,
 	FLOW_ACTION_MPLS_POP,
 	FLOW_ACTION_MPLS_MANGLE,
+	FLOW_ACTION_GATE,
 	NUM_FLOW_ACTIONS,
 };
 
@@ -254,6 +255,15 @@ struct flow_action_entry {
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
index b0ace55b2aaa..62633cb02c7a 100644
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
index fb6c3660fb9a..047733442850 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -39,6 +39,7 @@
 #include <net/tc_act/tc_skbedit.h>
 #include <net/tc_act/tc_ct.h>
 #include <net/tc_act/tc_mpls.h>
+#include <net/tc_act/tc_gate.h>
 #include <net/flow_offload.h>
 
 extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
@@ -3522,6 +3523,27 @@ static void tcf_sample_get_group(struct flow_action_entry *entry,
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
@@ -3668,6 +3690,17 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 		} else if (is_tcf_skbedit_priority(act)) {
 			entry->id = FLOW_ACTION_PRIORITY;
 			entry->priority = tcf_skbedit_priority(act);
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

