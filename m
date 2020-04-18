Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BA41AE933
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 03:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgDRBc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 21:32:59 -0400
Received: from mail-am6eur05on2051.outbound.protection.outlook.com ([40.107.22.51]:6062
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725768AbgDRBc5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 21:32:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LiiptjQdSN8efztxIfEchtauUJ6kMYXDV8mit0ETjXQFzgtDmAp4AmDFJu3dPlw1iSZyZw8gg0vP1fmxsYHTCTmcpiLv2WOcKrAL71r0eX1s1a03UUuWNM6k73IXYE2KovA2p6Ed4OWYq1VuzsJ0T7k0TY8mZvKriXprZOsEfFfRMMVEze0Z6wlDNBcxBxdDViFDTIKpfnqKAbS3SSFM436+uV7gtoA1C1ZQCill/VyZPk0KKxDyYveQPYynmWVHwIu++CVZYppP3HMs2RAlj0kfCo5n58yPHN+iHU3Ry/WgHI3uRifcxiNiVxOrR13DZuAxuBtyueLf4S/+/+O7yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UwqjrR+qmYXBRGa7cv/pcXveA9JCQdlX7Yp0rz88ow=;
 b=V46qRVlosQwMbtpjey7JMA8HE32yVdw9EHZCKyEbesutziui6Lff0J0GlsWNPWjQ0GNL94KFWZMkFIEbKukhAqVFej1Ua/5dX4xg4uhLKCi9BURZ9n3qaeMbSRp4FNTE5/0WaqpVfgOt6x0m2u6Zn5lpS72dWspCljpqFP/elp/JBIb0I5b6usBtP9pmSS+U+BdzGCs6Qnpl9KspuE8JfHKgkg0u6B8rL4XRgSQi2tH3b12LfuKwecLZdGsoFtCs+6XorJtfALTuc4CU+JE698H8/E0GUiFcf95MsjZb460nZ6c17/f/PVatq29jJg8bz1mo9TCBgxNPfTtj9oyFsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UwqjrR+qmYXBRGa7cv/pcXveA9JCQdlX7Yp0rz88ow=;
 b=GeB2SrnQ9rKEw7/AFJ4GHY74qhQ6/lwluHzSaSMHYPfwpAFGsQ0AIa8EsV4v+7JNKGPXesvbB9t92Rt2q9cRqvMAbR1W+lIXqJ7ofSq/zjEFCvzjgcR44p6WYlQKpYu/15GRZb34Z8aQK1CIlLAuuhXZ4wEyHEv5ccre9NMWpKY=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6640.eurprd04.prod.outlook.com (2603:10a6:803:122::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Sat, 18 Apr
 2020 01:32:52 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2921.027; Sat, 18 Apr 2020
 01:32:52 +0000
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
Date:   Sat, 18 Apr 2020 09:12:09 +0800
Message-Id: <20200418011211.31725-3-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200418011211.31725-1-Po.Liu@nxp.com>
References: <20200324034745.30979-8-Po.Liu@nxp.com>
 <20200418011211.31725-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0037.namprd11.prod.outlook.com
 (2603:10b6:a03:80::14) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by BYAPR11CA0037.namprd11.prod.outlook.com (2603:10b6:a03:80::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Sat, 18 Apr 2020 01:32:41 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 12e40de7-76ef-46c4-c68b-08d7e338692b
X-MS-TrafficTypeDiagnostic: VE1PR04MB6640:|VE1PR04MB6640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6640DF6026F8AED000A3E7F092D60@VE1PR04MB6640.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 0377802854
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(366004)(136003)(376002)(39860400002)(346002)(186003)(1076003)(66556008)(4326008)(81156014)(66946007)(316002)(66476007)(8936002)(86362001)(16526019)(36756003)(8676002)(6506007)(26005)(6666004)(5660300002)(956004)(478600001)(2616005)(52116002)(6486002)(2906002)(69590400007)(7416002)(6512007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ip9IytHNfjLYjMaLKEr4M+7f0h0BzuhIRO2ZQKOUoZrh/NNIUpTyRKZCiccEhdeZzxU9i3trwoxAItFLQ5lCoaVp09b9P59uO3cXTuhg7HyVrs4zAOgC+R1LrzMP0JYU6BWjf28p3X0IrmSvP+6KfWdDjOES5vSrVMS2v2N/HufWxmvmp9eV6fvSKGaI94QgYUEjz3fFnpDlcpEfJ6b1SNxQHIo01OdIuyQj3rLEK6M3T3tG4GBBmImrMojpUN62BpbAmnCeWR8K0g6ex0L+7XC/0vTyKYf8IvzctT/jq+5ztstt2LKqZ5pljK9O5o9wq4nkllb24hji+uGidtYraM1PyWQ2pQVcoe1/FzgSoTzLOCxJ2Arp1VZ2CNXY+XQhj2mL2kpoEmLcN7Qef/SSebqvobI7nK6Y5yvi+wkheslVy6lY9PRQoeXGRDvG4PqJcjOu6tE+K0zIPDJ+JCdJBzPdqvTc/b7kM1FUq/zcLIgr+HmiYUIM2H+Ycgs+umUx
X-MS-Exchange-AntiSpam-MessageData: 6o5Scrla8l/qErT2o5fAQdpW8I8tpRqIbxdQ3fvNMW3eezHQVV2kaSaaR2R1x7UgamVPheIwnXmGTNbO4yEm2Y2RNvfDGz/Gw5UuayfrWt6BJU1cC0ELyYRbLQL+8+pMEubZGmjlQFZwV+sNOOunQw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12e40de7-76ef-46c4-c68b-08d7e338692b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2020 01:32:52.3192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mZOUH6HngJ8aQYc9rKdqTpcMOtp35jdmL2omvqMxNvVaWx6ScOCnoNKHsjcJsWuE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6640
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

