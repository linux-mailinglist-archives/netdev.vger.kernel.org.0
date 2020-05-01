Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEE31C0B8E
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 03:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgEABOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 21:14:31 -0400
Received: from mail-eopbgr40072.outbound.protection.outlook.com ([40.107.4.72]:52484
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727114AbgEABO3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 21:14:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZVAklPcbSLdJEVKXpKubR7ta1ZXaqawK+8xMfwfOZHDKyc4rVMJpuUymQsgG9OkOzIYe0S4XB3FnTQ54KyQ/1iEGblQrkSzXZsgo23e8BFeV3RSfol/IroXalGZMYlnsmCheutu0muIJdQE4DHgNy2EM4+myeilU845Jft64wiyYJgheTsTxiltepNf64fxKTkTH81CEipMFfkq3LSpxDyvu+OpS3u5M9qlGeROctKXrGhot9zoSx51gorjLvxHlKhVT3Ok6oYmH5VeTLCULF5hzwR3SHUDSM0VAPkRj5ngxJKp7ddrCf7Jch1bq+oPUT6yvZYq6iWb8nbFUIZwoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zm0cco+T03mZ4zZSwElOLbuaYUFZq9V03gv8wD0U7co=;
 b=U4kpBAZFBEBQeMiSc0w8a24cYFqOm+qgF/nZX57gqFcl2epDJsijOFZ7SSqog2BHiOnwzWBAe75+IJQ7UZCK/QBIjVgqvioo8mHYZ5XWiqjYRCoOKEaRGCAwBjjDQL05yEFzN1ML14K+OQkLuSLj+SB28jT3TjZyRjmvDR0CVZpXsxfcp6+hEQnvUJ7nvLnOgPHKhrgxwZv8nnQdrltBgX+QLr3oLByohN7eWgMUzpOtbSFBAXLKtxKNZ1ll0mlqdlQFsOctr+2NYaHL8js/YfMUN2duREcJxYmsqQy+e35lACcAJNSLaxsCSFQHrPxni/w9MeUBqGg9uTcIKm9QGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zm0cco+T03mZ4zZSwElOLbuaYUFZq9V03gv8wD0U7co=;
 b=Kr8ZJ/shq3XD8KmKQM23cBKW+AKLAL6nX/tK/9Urn0naGshi4zBjt8e+zNiprsuqFEgn3YCeB9Wzl+0/gkCLj0FoeNle4t4u4iNdjUNKUT3lzdPn3xgcRo70nPtxTDmCwVnyccOEGQxqBKrlyuCbO5BzCQonpAKAo7yKSujQtsM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6734.eurprd04.prod.outlook.com (2603:10a6:803:121::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Fri, 1 May
 2020 01:14:25 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2937.023; Fri, 1 May 2020
 01:14:25 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, vlad@buslov.dev, po.liu@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org,
        Po Liu <Po.Liu@nxp.com>
Subject: [v5,net-next  2/4] net: schedule: add action gate offloading
Date:   Fri,  1 May 2020 08:53:16 +0800
Message-Id: <20200501005318.21334-3-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200501005318.21334-1-Po.Liu@nxp.com>
References: <20200428033453.28100-5-Po.Liu@nxp.com>
 <20200501005318.21334-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0108.apcprd03.prod.outlook.com
 (2603:1096:4:7c::36) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR03CA0108.apcprd03.prod.outlook.com (2603:1096:4:7c::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.16 via Frontend Transport; Fri, 1 May 2020 01:14:17 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c277efef-c1dc-452b-dc77-08d7ed6cfd01
X-MS-TrafficTypeDiagnostic: VE1PR04MB6734:|VE1PR04MB6734:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6734AD79CDEEE44F272892DD92AB0@VE1PR04MB6734.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 0390DB4BDA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: deFUv4Kuo5/SD3hWQ/AthnlqWlbeZ1eE32gALTY0BtAz5mPx47/6xwIgwtneaARUdDz0vOJ9Z/3Icu5AjW2P2t+G7VQYSORZqmriMnWSZAy/11VqIQ4KvH0zpNYbH2Ne3TGb/3PMSD2O/ZoVnE4QrAYsl7VyaSWwuulkOKKWjzgGGcK70xmJnf5cySUE15DumqQTGluMjSHJ8PlpDYuHFIIR2md0rX3U0o3xhwTW1XDSiFwSIo2NGvuDsBVU/OOnqd+ZmIfJjS8Uy+G00XmiLfI5v1fKo1vemyEcwW+4xPwJdAF6hQQh/dOaJ+IqVLs82w1jdVjZndga3UmAO91bxX6KgmOkcr8QfW9PmFmEnuSehQ8CsSxt7ya3OKzIaRhDeODBHDfRWCmnYkTOdVIDXVc4Z4uxOuu9QuKZ6xVFke72ZXhLXoxkJQgcKDxHyBX48vjotONVMPec0RuGM7uAiwpoaGt7p9lfbZMItX3hqP5ZytlxUq1hPZpxj8pNDjxj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(16526019)(186003)(36756003)(478600001)(26005)(2906002)(4326008)(8936002)(6486002)(86362001)(52116002)(316002)(7416002)(6512007)(6506007)(69590400007)(1076003)(66476007)(66556008)(2616005)(66946007)(956004)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dgCQzpJCFgA9V9CongzJK+r5NtMZvZVMa0r1lU0bfN1FmwPeKzVtZmObCPquxnXD2H349Q9A0U8TBc1/zSyJ6hZyWnY6/yfWbJPrMN6Wqbl0JpDA0CeFQduYRjNhtujweIhc/iKBgdGGyHz5982rE2ELAtPWkNaUrkPQ804/Z7UvS3CRuGnrA9VvsZfyXnyjTTI0ZmmDZEOL71Pz0rGkLtMlm1XXmExLdqRjnnA9pG4tB5FwvFpvilDsMssz+shIYDzsAitbmtVvBKCvv7pqyptFuPCsifaCiw8mswjZnSxiHOaHzdGGRImSymwtZz3ZdRD4Y80LncglELGjDqUp6+f3c5OzbcOFuQ0Gr/VLJ06AEbM5LHlxcyt5fihYxvrHprZN3boZBteVOv1Fo7zmyYXU0jRvfw3FpZfJzxtNj0M50ZmiUuKIxsqqwDiiUzwZnS4/ubUZLdt9CcFrW62+d6v/riIcCe8+xPiR9DPFygU2RGS91+CvwzVVQTTaQRCS6RVRx4dd9l4PgvZQPiN1yRFYE0mOVyyxg93xpJi7TbtMPx+gjCm2DmyiI9SBdEWc4axv394vs+L2z9OIfF5H886whLSCeIu0G0ddFBi9rA7wu8mBEiuusBUVmXeJyVNPRL/mLhUpQB3OMnNZSfIUO+d7nL2z008BqSeirnhhEpk9a7R73cS0YAJQTl9z/c31MhgzofzvsIo8B9EIHfTpu/aCTjkC+YswQ6qGeTLkyUURUi3CK1D5FBzrxRY26rh7sGHlp2usj1Dape0Ek615I7JKEA4IInZhoQugmmDfREg=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c277efef-c1dc-452b-dc77-08d7ed6cfd01
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2020 01:14:25.7410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uvYb+DuoNa7ynzIBjSkCkirtirooKdp2z6wBe/e/Tl/h2PqK4zR3gpDMsuzpRsVO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6734
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the gate action to the flow action entry. Add the gate parameters to
the tc_setup_flow_action() queueing to the entries of flow_action_entry
array provide to the driver.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 include/net/flow_offload.h   | 10 ++++
 include/net/tc_act/tc_gate.h | 99 ++++++++++++++++++++++++++++++++++++
 net/sched/cls_api.c          | 33 ++++++++++++
 3 files changed, 142 insertions(+)

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
index 330ad8b02495..8bc6be81a7ad 100644
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
@@ -44,4 +51,96 @@ struct tcf_gate {
 
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
+	tcfg_prio = to_gate(a)->param.tcfg_priority;
+
+	return tcfg_prio;
+}
+
+static inline u64 tcf_gate_basetime(const struct tc_action *a)
+{
+	u64 tcfg_basetime;
+
+	tcfg_basetime = to_gate(a)->param.tcfg_basetime;
+
+	return tcfg_basetime;
+}
+
+static inline u64 tcf_gate_cycletime(const struct tc_action *a)
+{
+	u64 tcfg_cycletime;
+
+	tcfg_cycletime = to_gate(a)->param.tcfg_cycletime;
+
+	return tcfg_cycletime;
+}
+
+static inline u64 tcf_gate_cycletimeext(const struct tc_action *a)
+{
+	u64 tcfg_cycletimeext;
+
+	tcfg_cycletimeext = to_gate(a)->param.tcfg_cycletime_ext;
+
+	return tcfg_cycletimeext;
+}
+
+static inline u32 tcf_gate_num_entries(const struct tc_action *a)
+{
+	u32 num_entries;
+
+	num_entries = to_gate(a)->param.num_entries;
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
+	p = &to_gate(a)->param;
+	num_entries = p->num_entries;
+
+	list_for_each_entry(entry, &p->entries, list)
+		i++;
+
+	if (i != num_entries)
+		return NULL;
+
+	oe = kcalloc(num_entries, sizeof(*oe), GFP_ATOMIC);
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

