Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2A21BB4DC
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 05:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgD1D4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 23:56:00 -0400
Received: from mail-db8eur05on2086.outbound.protection.outlook.com ([40.107.20.86]:13408
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725917AbgD1Dz7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 23:55:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXfpyc9qVPFx9a+FIB8rJr/uiQ1Hpmvhw3oe2rpxhW5lANEnBESk4sCTAkbpez8Onh09x1h8zQOFpVdj7SgUWa8gttbuKUGdWxuvK+zMqN6tO11Ty+INA+0OKe9gGgMU0cugU9Kyqdo1MQY4bTwiid8tnNEyvzpPQMDyni2Ra+PyRxGFoqwSGnRGyAwyHVGFPgVwPlsJmPaDdp1TDhhXMT++oVnYP2uNcRgEuU6bzAXMcJ0vMqGIzwrCx1VOqeHWn4/bdxmPFIxbX/qOaNbBQUlVU2wsyzMb7YadLsSGC1FOcSfvCHNzBTwbh65xPogoiBF/74CFTj1F8MLQa4Xj4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhEL5XhQM7xRmC6uBA/aNtl1o74kDRjT2al05E5NIEw=;
 b=HjKdYtfs++l1CSoGPPZVc66o3Vie1T7kgq3gNEQrLnoR070o60OeHS/OSY4RE/tH9sKnfUODfZrqFfZ3SUvKv5O+hEedHiKxEvTZ2XA/KDkhFcYPJQ0XcEa2feAz30F8hNYPhTX/xauq8Zh5APMCLfjl7Z4qLKc/ZCba8z4FZKgYuhUPhD4ComQgSg8dn+wJ+cSFb6S73Lp07xPjnI48TNU/udgBhsDLlWX7MyWmooeXIKirW4UKaLgqkuRpL6w4gklqPg+5sGVlJ1sq+L71WZRkjhC78cqAzUSub/x+Ee+97pywZbnihjmzHzprykabbvwMIflISjEb71rZxaUWsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhEL5XhQM7xRmC6uBA/aNtl1o74kDRjT2al05E5NIEw=;
 b=GVf7j5LWYKBttYTDXYFUYN/ms+dKpkNJhTXlAuSweAGQrMFNERqwKO4r2TTBKgpSzD1+ihBzR4lBUH0vwLqnU0IzXT+ekOAYP83IdqxIno1BdU/PFNbhl3cDytTrR2Zg7ZlDD7dbrXlNkDvn0TdoP4N4tTw1vkaLoN8aBswh5W0=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6445.eurprd04.prod.outlook.com (2603:10a6:803:11c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 03:55:55 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 03:55:55 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        leon@kernel.org, jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org,
        Po Liu <Po.Liu@nxp.com>
Subject: [v4,net-next  2/4] net: schedule: add action gate offloading
Date:   Tue, 28 Apr 2020 11:34:51 +0800
Message-Id: <20200428033453.28100-3-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428033453.28100-1-Po.Liu@nxp.com>
References: <20200422024852.23224-5-Po.Liu@nxp.com>
 <20200428033453.28100-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0198.apcprd04.prod.outlook.com
 (2603:1096:4:14::36) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR04CA0198.apcprd04.prod.outlook.com (2603:1096:4:14::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Tue, 28 Apr 2020 03:55:47 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 35899dc7-b0d9-4489-5ca1-08d7eb280d2b
X-MS-TrafficTypeDiagnostic: VE1PR04MB6445:|VE1PR04MB6445:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB644572408D96DBD6C31A071992AC0@VE1PR04MB6445.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(6666004)(52116002)(478600001)(69590400007)(16526019)(1076003)(6506007)(81156014)(6486002)(8936002)(8676002)(316002)(5660300002)(186003)(86362001)(956004)(2906002)(6512007)(66946007)(2616005)(66556008)(66476007)(7416002)(4326008)(36756003)(26005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RFRoij1lyi/yhvSn2/s/88wBe2dNK4BY2cb4f/TFQfsWtQdgFgPESFebn6ZcZVO/HkubASQOb9aXZPEOem3OyQtAUuVuU8aMbcgUOp5ouoljk4FI8BRbH8wSxewnzkmLKh9GHVgv74Hl/YO0w21fYFD7x3gwU7pSHfZ87t78XYl4XdV3OeRg9q2ZAelFz+XMQEOaxtiwh6WL7F1S+v9ji94UnXzh2mklflbkf3YGdPoMbQI0yfNjDpGNGxSEHyhdDKQM/hiJFIYkZ9Zepei4+cu29BywUebuAyBLSL+O6fOqbSiGtQvXm0vsEYzzXCOU+dgBHwOCA0HE105mNw96mWSgm05otfANX4W9+foRUpgCDTILv1U0YnTfDsOxa2e8WeKPKc7xBFT9RJdGU15eWa4FbUt2/h2DhGT746uhlNY6L2SXZ9lw8RYrtyJuQBPZIxNq5pcxzyF1sTfJgdAz4siXJpJR0y2AZ6Di1aT2MN6j1yrfH+7znh+HGC/tuF41
X-MS-Exchange-AntiSpam-MessageData: ef6gIvRnLvU63L7CzPNKjEPx8NiB8sG7mTzpr6pv7j8INOnUN4a8g5tAkr58Ex1RDmEHs1F48JAyQp/qxC5vhA9qxNGd8nV/nfHINL7+iW1Ie3D52SMEAUf9tvMSXIwT+2GNnKo1UVSTEbynDudTCVGrk9W6s980hNirexAvYKuInR+EjY9921z5YTCvXWX84crfszqkPqFkr4TiB++ouFFssEyKpq38pDPXDB93eZFL9kW3LUnxeSnRB+Fh8O8O/+5ZOa4/iAAzj8ni8bD2ewQ+1YaO0a2Os45awzWaTv57N+Mym6yYTrln5Z8gQrzXDyFxzM8btmes1zqUxd74P/n9LCNoPT52eelm/1155mF5zz5AfHPq5XWE1+QPHWhRrMDjhIC1d0EG43flFjBKxif0yx2K/SKzr1DNb1E/uih+oJBgajW+SmdmYgqbWA/tc6fnsp2cmkejo/kP2BbJI5yFlXFHj3ZwRq8rXHhYxxZnSLmiUNkc5C56SUtikXUjdQ6UeWAVrEoR6s6fIb7QkVt3vI6j7cjJe+UUuaX7KcCuaiRLOnu1MGXzNLnKqNbS9gCFVqFWMlyu89vLBvp6fRAshHNFgiOm+69u885THWLqaWl/sRkWH/2HQVSvMoZdgIDZBYM7Nu/l+iSz8LZSyqcgAQvi+xwBp3XiriLmuEdsz51JshdOsjEj9CJotfo7c0ViCLqwOQi+Tqmx1dDI7dLER7UXlkDVDbUICNfgLFNpwI8T25PPhoUT6OF2FnJBlgn0wnujCzprpGlc+8MK1MoZp1FXA2cwZKtOn53Lt/c=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35899dc7-b0d9-4489-5ca1-08d7eb280d2b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 03:55:55.1567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GhFpTvh+IQ+9BoTaj9C3pkB5RrNMWCMwjIJ9EkUKiHPJsFeFahHk33IEzRSjxyVr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6445
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the gate action to the flow action entry. Add the gate parameters to
the tc_setup_flow_action() queueing to the entries of flow_action_entry
array provide to the driver.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 include/net/flow_offload.h   |  10 ++++
 include/net/tc_act/tc_gate.h | 113 +++++++++++++++++++++++++++++++++++
 net/sched/cls_api.c          |  33 ++++++++++
 3 files changed, 156 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 3619c6acf60f..94a30fe02e6d 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -147,6 +147,7 @@ enum flow_action_id {
 	FLOW_ACTION_MPLS_PUSH,
 	FLOW_ACTION_MPLS_POP,
 	FLOW_ACTION_MPLS_MANGLE,
+	FLOW_ACTION_GATE,
 	NUM_FLOW_ACTIONS,
 };
 
@@ -255,6 +256,15 @@ struct flow_action_entry {
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
index 330ad8b02495..9e698c7d64cd 100644
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
@@ -44,4 +51,110 @@ struct tcf_gate {
 
 #define to_gate(a) ((struct tcf_gate *)a)
 
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
+	tcfg_prio = to_gate(a)->param.tcfg_priority;
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
+	tcfg_basetime = to_gate(a)->param.tcfg_basetime;
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
+	tcfg_cycletime = to_gate(a)->param.tcfg_cycletime;
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
+	tcfg_cycletimeext = to_gate(a)->param.tcfg_cycletime_ext;
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
+	num_entries = to_gate(a)->param.num_entries;
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
+
+	p = &to_gate(a)->param;
+	num_entries = p->num_entries;
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
+	rcu_read_unlock();
+
+	return oe;
+}
 #endif
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 11b683c45c28..7e85c91d0752 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -39,6 +39,7 @@
 #include <net/tc_act/tc_skbedit.h>
 #include <net/tc_act/tc_ct.h>
 #include <net/tc_act/tc_mpls.h>
+#include <net/tc_act/tc_gate.h>
 #include <net/flow_offload.h>
 
 extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
@@ -3526,6 +3527,27 @@ static void tcf_sample_get_group(struct flow_action_entry *entry,
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
@@ -3672,6 +3694,17 @@ int tc_setup_flow_action(struct flow_action *flow_action,
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

