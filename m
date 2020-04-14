Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E311A733E
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 08:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405708AbgDNGBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 02:01:18 -0400
Received: from mail-eopbgr60065.outbound.protection.outlook.com ([40.107.6.65]:46959
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729093AbgDNGBG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 02:01:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WxEi9mjy96Nv4HqRK64O2oGU0LIh2sgEtBaYU3JCplmWIBHw2srODf03rISzqzQNDcsubj9Jg9ielkTZX9L8MnzunlwTndlpvrfDZLnvqgJEdnPbm4myi2zd3NOXGSn3Sq6ocv7DiA9gfDh5asfI3wcpJ95k0iCACIqxpSg1Vk4BF3sJUgF6tTIicIKs/Mc8Aepvy8tuR42q6C5G3mARO16ez/xrWQcDdR9KAN1Tf4t27/zZqTZJmlIUYBp3Dh6bx5D+1SEdWr1hyJgCbnC4hbST1IbugXZ4C76xMJvINvtN5j8avDAztiRARfaYToRN/Pv3Kw8eEfgVnRQs7P4GfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UwqjrR+qmYXBRGa7cv/pcXveA9JCQdlX7Yp0rz88ow=;
 b=FD8ysCBHheCl92J0g1y3SUBFOL9c0SvGjLKxW/JtFFUjfDkwMvfnAa8BTDV7tk2/+IXnnoc8fnyndME9u/HZt3cpH56xUVRrHvcimXR30CBwsgk6qUMZLUh4BPQs93DojcP7hwoeRKHDyuaSQf/9sQMj5ycOOzSjCsNZWlDbfPocZvtOswN9/JVWosHsNB+QVDvdFLUARgnXXCRj+BGqlDgwZEuW0zFY4FQEQfjTO7JRK15XwVKPrTFl2utAkq/52ZeG5qaN3zqda/W/Sr+yvfFcS+Z+rfRQ/fKH6cHrkRQFABY1AHJrqaNeXivciQRlHrF4vyShK9tgPLf7EcfmyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UwqjrR+qmYXBRGa7cv/pcXveA9JCQdlX7Yp0rz88ow=;
 b=HnspqmIOxiTZX0FnMI/SgvZa5TuNa14AH48pjTdNTV4W+A1EWiBRmNl54blD30DVVRS/3/O27CyOh2vOV7Foa02nKCxGSTgS9h0sJ12JMUJVd8Obv0YBU2gvfF4N+9X0l8qmPkS3uKGViCgnJEGPpPpr7o8tGIzFC1EHcS7Rlfk=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6749.eurprd04.prod.outlook.com (2603:10a6:803:129::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Tue, 14 Apr
 2020 06:01:02 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 06:01:02 +0000
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
Subject: [ v2,net-next  2/4] net: schedule: add action gate offloading
Date:   Tue, 14 Apr 2020 13:40:25 +0800
Message-Id: <20200414054027.4280-3-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200414054027.4280-1-Po.Liu@nxp.com>
References: <20200324034745.30979-8-Po.Liu@nxp.com>
 <20200414054027.4280-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0173.apcprd06.prod.outlook.com
 (2603:1096:1:1e::27) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR06CA0173.apcprd06.prod.outlook.com (2603:1096:1:1e::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Tue, 14 Apr 2020 06:00:54 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dab65a62-afdf-4c41-a231-08d7e03935ca
X-MS-TrafficTypeDiagnostic: VE1PR04MB6749:|VE1PR04MB6749:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB674941D245D4EA2CF4EA005992DA0@VE1PR04MB6749.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(52116002)(2906002)(6506007)(956004)(81156014)(498600001)(69590400007)(6512007)(2616005)(6666004)(5660300002)(8676002)(8936002)(186003)(6486002)(36756003)(66476007)(16526019)(66946007)(7416002)(1076003)(26005)(66556008)(86362001)(4326008);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vOI8qr+lyRhO3giJhxrV9FNtumFLg9tepmlsPBXsTQeSKtsje4T/2+R3zOA0Yx+PRZ/3/uwXfNTwjcsiaXWn9qr4Xhro5L8PjZvkEfLYxTiHvtARx7zstVPKNbPmbIzzYiccIg5JZfdaMrXlYuYMhyqt3duzyVDhbcbG6/QVw/z2Rxa2Xhn1qF1WdvxbqAUUjetvfpgGsGvYe9esKpHmLwu0aDNWHXOcOhZc35aAwzlqNqb4NvvJ8RAhzMHtunrPt4419i1rV3WbiMPtoxWPKipdeGaGSxmgNvLeh9RZRQL9uwb/w6b8LLNDKXf82nqhXhKaT8UZOErMxxAXTMf1W6KkyfgZj3bXR5LSbgpcS/ddNRR88D7LYxpbf6u7DkX0ckumga1TB7XJ58nCt/A4T/chD+7h6vCBMNFDLdDwvirPgpCiwX77oOkhSUzcHJoTj9VqNVp6mwsspgfQkHSmDBCqIq/V8lRG5UZBvXKYA7SDwbjst3XeFyAEoV5ikPTE
X-MS-Exchange-AntiSpam-MessageData: 0oapcDCy5iyKy/uUnZkpTB42/101Mww2ylLeAss8euIZVkXdKdZpTUXTofHKNuyAU/Hkw5VlSkLGixppHaSYPQ/nX6rWJOXTTJef9Y2+H/H8V9PjPe5B1TWZSSnEQ6goMDR43i65/wNYpe74ecRzBA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dab65a62-afdf-4c41-a231-08d7e03935ca
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2020 06:01:01.9932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WIwIef0Cpts7/6+01b/g8HqGaDfOuEXH/lbQNiKGYyMiPL/hdRzEOWX/0NjfSza3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6749
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
index f6a3b969ead0..c8de5a887230 100644
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

