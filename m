Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4394B3DB97C
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 15:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238925AbhG3Nkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 09:40:42 -0400
Received: from mail-eopbgr20123.outbound.protection.outlook.com ([40.107.2.123]:37764
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239011AbhG3NkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 09:40:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gED3MwAEtKex1k0B+oitjSYKmEWrXNp7AP6kNeOFVK+ttkTQZ7mKSEkv8K5tiee+3bCFQbc9RMMp/m8j0UUIjErs74GOL796lp4BAeeHUrTiVdSaSmrkAKYH3fMy+e49hDsVr4jhvTtJSaQenVx4jfh+BpISq11JSzPPJ3EsjJ1iD73suihKH+VzTrPD2QaFcQ1hmUCiqBNJMhH+81Lo9RYZ+ZcS4QZd77KydYEGGVaxIN3yCkWiBhvUdd1SjGyFpRcyPdKL+nyuaNWgi0eHWn/+1NlvRPmklokhU+fZN1YPW9zbRbyxTbiyifpZrpxkSit4Tt0UOaw0lokU7Qn1iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vddhFZWo8GTPMKr7Gb4+5GIgWUP3/r0dzf8NPUO8yZ8=;
 b=Fd7VTVdJiT1w1BV9zvoMGBq4KwaLBZ/+6lnWwKih4krJrDUG4zaGjIz6/a1+lDV+4eI3XjOZo5OeoC2kNMD+o5B7+I3WNL+sLrj043v4oNsjICfy+deHei2HRQ3nA3Jbq02mB/y4AytC7ZEN5/KxfLBEvkSzP4M20l3Suzl6EIYltWuCkFL13JzfWD1Shs24N2gnECFUyPjz9FQMTjRKBSU4y5xRrAqZ2zkrd34gL0P5z7zy/Gl3ZDpuAZxl/TI1bQ6vJONVNY4VjHbC7U7Zxj5LZDIM9kQ4zV/RP6In1jHiF1gEJA7qI72GIRGmolqjZRlU9FN8HKzzSBQlrTbo8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vddhFZWo8GTPMKr7Gb4+5GIgWUP3/r0dzf8NPUO8yZ8=;
 b=jtS2yD/Dl31RlslKQheNdWllQyGZ7qMA2/3glrrS2TBqGZmJty2rXwWhmZIOXCWaM3BLFZHiMvqWb7srxKhCacTzk8sr4nIjWwJj54ikOBpMbE01sBXAsnfCzkWjHvAJqIWbyL1EwxeM6dVa+ugIIyRJG5bjL6YTlzH5HA5ScA8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e4::5)
 by AS8P190MB1271.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2b6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 30 Jul
 2021 13:39:45 +0000
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230]) by AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230%9]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 13:39:45 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next 4/4] net: marvell: prestera: Offload FLOW_ACTION_POLICE
Date:   Fri, 30 Jul 2021 16:39:25 +0300
Message-Id: <20210730133925.18851-5-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210730133925.18851-1-vadym.kochan@plvision.eu>
References: <20210730133925.18851-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0012.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:90::25) To AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:2e4::5)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P194CA0012.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:90::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Fri, 30 Jul 2021 13:39:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25ad0637-7040-45a6-90ab-08d9535f7e3c
X-MS-TrafficTypeDiagnostic: AS8P190MB1271:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AS8P190MB1271D0861D5B191177FB1A9595EC9@AS8P190MB1271.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WhbAsttMKcFvzkb+UkLqDIZauDyTh6XIeRAeJ7GUYq/dj9KWiGoZBDYqbNNxVHwhO8PGVlFVWE/CI131pJdAEjKBFReK2CBUxibLynSTxwSkK1aOHJ+N8Mil898z30BPADMVx/GW9cX3tUwmgiSUzoXVN9hibcUkIMsb3HWjOjCKKxp8u+WCYQPuYS53us56C3pvAUsBkCrm58mDgBAkRY+C2wMZTR4fcN+vJk/+5ke3qKu4UpZEjZz4eMy5gsUUtfYyXE7BWkwKqRFgA9JvJ+RizkWpsfxUeJdbqkeQ18CCr4V/tVe31Io415VCRdfyWu7VPMMkOBLxd6BR2Rv7YF+nhtY5Mc9BtitiT0WPSwyGz6iM1YeT8khxHIiJNXClPEH9MLM80bwnbStJA7qxjj11hTDXm6B4ICc3R+5m1xz6eqTANKWELcI6j8eJn3KUc0KuHBu9RMX/mSEBtE7oTgZsAsgRZSl7rL963lD1WAi1MO+c8VGMW227WcTJCC4wJ/MDoMF1Mfk9neSRSIAoZ2E36WHAJxzc+Sw04pZlZ+Rq766Zi8vtSDyBrCISiXwKJzDzDhW6m6Pcc5lMv6PpVWhpc2Dn9mPOjcoi+sKJs9TYu52s4lpbFFXNaEJqugHazGW6YXeNhgBCVcYcFVy4ZemvsYOdEFiKs3d4DzlmjSUOQ4F5kRR8cygWIFbVUoFi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P190MB1063.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(136003)(39830400003)(366004)(396003)(376002)(52116002)(8676002)(83380400001)(5660300002)(36756003)(54906003)(26005)(186003)(110136005)(6636002)(6666004)(8936002)(44832011)(2616005)(956004)(478600001)(6486002)(2906002)(6506007)(1076003)(6512007)(38100700002)(86362001)(38350700002)(66946007)(66556008)(7416002)(316002)(4326008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MkK6CIaxksJaZp3ARtXSDoyXc1Ua62ubZ/h2HsnshihsoRtx7S6+JRfCbGyS?=
 =?us-ascii?Q?MO0JxxfQF1EfCZdXvOcdvarhP2eyz9XKBLHf/1r6u2/PR8wvoRml4F2WnBgm?=
 =?us-ascii?Q?bk6dy0ey3RJu88VYmBuYohV+vBmCqJoBR6cR7ldSmIzBa4WNg6q9FpM9TZm8?=
 =?us-ascii?Q?kp47Xn302qDKBUiau1zEZtUOS2u4NAwvQA8TDBi2IR3zLDkqwTMoYPdSTMon?=
 =?us-ascii?Q?kiF9oxGVuf+24ThxNYBr1VbJRsP16P/u3Lr5xPxUo5A/vvvaZp+N2OzGQphh?=
 =?us-ascii?Q?rk35RGcCTjqj/bwGxFEJgPP1OWZfKZy4mqTGKAo3qXDy3Yw+wiyv2BGbv69/?=
 =?us-ascii?Q?g1zwHoi0ZaToDDGaQk+Xs3Stq4vVumr39MDjQmXYR/izNat4ULV1PkN3bpny?=
 =?us-ascii?Q?vfC5dpNVuxAiBHPkBHuNd1bQRidjq4l9tKDLqkJzQ04Bsht6h7mRC7f/sf/u?=
 =?us-ascii?Q?GH73C1PHN0H3//sMVCoKvT5PjqJ3BLNXaNobfkbAxtggydnhk1vkJ0ETfVoD?=
 =?us-ascii?Q?zwFxNtGVu5xN+CgMsE8BLUnXQYKOY3mBkds0sa5/6isWx8qch7W7hzU6du5I?=
 =?us-ascii?Q?J8gqLKtNfBPhlCs1he+YyafeMZRoFr02+Nk8Hi2fBg7w9/SeCeM/c0SW88AJ?=
 =?us-ascii?Q?bL0IQNAzy03dcupyU1Sxxv0siE7IxJTo2rA4URTIU3Yeu79saqGp7xJgq3Lv?=
 =?us-ascii?Q?gHP+v3EXyS/AABimQQudfq0lu+daGZXW5lwG+8uytPX4WM7d9/N+3a4vj0kq?=
 =?us-ascii?Q?5PgXxRhNtspv94OWDlZrE1Of24LBbKRViFdVxCItJy9cbIEwApKi3QgsFNGE?=
 =?us-ascii?Q?iBCIM59aapIiyyezV0PgvnqS4dIqi3s5t3baG6KCZVtdyc0AnuXrHFcAL94K?=
 =?us-ascii?Q?/leZsq3sJyax9VeJ0H97zr+zDPfM27+XY2SPgtwJ8DOADpzSAu/4WBSNoO5j?=
 =?us-ascii?Q?6RrU9IHNAePBw1yXAGcbOCEdWu2lHuiF3Bn5MC5c1HbvxaR1ytKTb/J09xeQ?=
 =?us-ascii?Q?KSI+D/cV5gD5cnKiN9+cONlkyvlfvR3mninurL+W5v74wG3qXvLzlKzqskqg?=
 =?us-ascii?Q?QEm6c6TLql3PhX/uU7eTKj0E0X2CKynwO/Cbs0ZCxCMRXXFx5gk9IP9Iz19m?=
 =?us-ascii?Q?QoValar5dhqakTzwlNJVm6tC530C5vY1EZ5m9qKAeTV1YnkLv3427j0ojQD1?=
 =?us-ascii?Q?0hxE5vNWA1tPGeOqQXWhwPhTAleTnVJd0mgysGKoVOq9l749t354WVt+s2yU?=
 =?us-ascii?Q?KYc8EHoR5qdFEUPMWmpzDU0W9U2xGd4ql8m+bjU/tO1jykT5a9tLqQ/9dgOk?=
 =?us-ascii?Q?bZJ8zt4h5NZXNgFHU354E7L9?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 25ad0637-7040-45a6-90ab-08d9535f7e3c
X-MS-Exchange-CrossTenant-AuthSource: AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 13:39:45.5936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kW/RdWYAlvTtpY5uGYOvYPkMJ38m0MtC5sJfBX1qSt90RrAwebquQUVeU2vjSS9H/1fCCXR8kl1lgZU+IW1JVfew+jFV68OfEauQv/St9FI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Serhiy Boiko <serhiy.boiko@plvision.eu>

Offload action police when keyed to a flower classifier.
Only rate and burst is supported for now. The conform-exceed
drop is assumed as a default value.

Policer support requires FW 3.1 version. Still to make a backward
compatibility with ACL of FW 3.0 introduced separate FW msg structs for
ACL calls which have different field layout.

Co-developed-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Co-developed-by: Vadym Kochan <vkochan@marvell.com>
Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 .../ethernet/marvell/prestera/prestera_acl.c  |  14 ++
 .../ethernet/marvell/prestera/prestera_acl.h  |  11 +-
 .../marvell/prestera/prestera_flower.c        |  18 +++
 .../ethernet/marvell/prestera/prestera_hw.c   | 125 +++++++++++++++++-
 .../ethernet/marvell/prestera/prestera_pci.c  |   1 +
 5 files changed, 165 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
index 83c75ffb1a1c..9a473f94fab0 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
@@ -8,6 +8,8 @@
 #include "prestera_acl.h"
 #include "prestera_span.h"
 
+#define PRESTERA_ACL_DEF_HW_TC		3
+
 struct prestera_acl {
 	struct prestera_switch *sw;
 	struct list_head rules;
@@ -29,6 +31,7 @@ struct prestera_acl_rule {
 	u32 priority;
 	u8 n_actions;
 	u8 n_matches;
+	u8 hw_tc;
 	u32 id;
 };
 
@@ -203,6 +206,7 @@ prestera_acl_rule_create(struct prestera_flow_block *block,
 	INIT_LIST_HEAD(&rule->action_list);
 	rule->cookie = cookie;
 	rule->block = block;
+	rule->hw_tc = PRESTERA_ACL_DEF_HW_TC;
 
 	return rule;
 }
@@ -251,6 +255,16 @@ void prestera_acl_rule_priority_set(struct prestera_acl_rule *rule,
 	rule->priority = priority;
 }
 
+u8 prestera_acl_rule_hw_tc_get(struct prestera_acl_rule *rule)
+{
+	return rule->hw_tc;
+}
+
+void prestera_acl_rule_hw_tc_set(struct prestera_acl_rule *rule, u8 hw_tc)
+{
+	rule->hw_tc = hw_tc;
+}
+
 int prestera_acl_rule_match_add(struct prestera_acl_rule *rule,
 				struct prestera_acl_rule_match_entry *entry)
 {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.h b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
index 39b7869be659..2a2fbae1432a 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
@@ -25,7 +25,8 @@ enum prestera_acl_rule_match_entry_type {
 enum prestera_acl_rule_action {
 	PRESTERA_ACL_RULE_ACTION_ACCEPT,
 	PRESTERA_ACL_RULE_ACTION_DROP,
-	PRESTERA_ACL_RULE_ACTION_TRAP
+	PRESTERA_ACL_RULE_ACTION_TRAP,
+	PRESTERA_ACL_RULE_ACTION_POLICE,
 };
 
 struct prestera_switch;
@@ -50,6 +51,12 @@ struct prestera_flow_block {
 struct prestera_acl_rule_action_entry {
 	struct list_head list;
 	enum prestera_acl_rule_action id;
+	union {
+		struct {
+			u64 rate;
+			u64 burst;
+		} police;
+	};
 };
 
 struct prestera_acl_rule_match_entry {
@@ -120,5 +127,7 @@ void prestera_acl_rule_del(struct prestera_switch *sw,
 int prestera_acl_rule_get_stats(struct prestera_switch *sw,
 				struct prestera_acl_rule *rule,
 				u64 *packets, u64 *bytes, u64 *last_use);
+u8 prestera_acl_rule_hw_tc_get(struct prestera_acl_rule *rule);
+void prestera_acl_rule_hw_tc_set(struct prestera_acl_rule *rule, u8 hw_tc);
 
 #endif /* _PRESTERA_ACL_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
index e571ba09ec08..76f30856ac98 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -5,6 +5,8 @@
 #include "prestera_acl.h"
 #include "prestera_flower.h"
 
+#define PRESTERA_HW_TC_NUM	8
+
 static int prestera_flower_parse_actions(struct prestera_flow_block *block,
 					 struct prestera_acl_rule *rule,
 					 struct flow_action *flow_action,
@@ -30,6 +32,11 @@ static int prestera_flower_parse_actions(struct prestera_flow_block *block,
 		case FLOW_ACTION_TRAP:
 			a_entry.id = PRESTERA_ACL_RULE_ACTION_TRAP;
 			break;
+		case FLOW_ACTION_POLICE:
+			a_entry.id = PRESTERA_ACL_RULE_ACTION_POLICE;
+			a_entry.police.rate = act->police.rate_bytes_ps;
+			a_entry.police.burst = act->police.burst;
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
 			pr_err("Unsupported action\n");
@@ -110,6 +117,17 @@ static int prestera_flower_parse(struct prestera_flow_block *block,
 		return -EOPNOTSUPP;
 	}
 
+	if (f->classid) {
+		int hw_tc = __tc_classid_to_hwtc(PRESTERA_HW_TC_NUM, f->classid);
+
+		if (hw_tc < 0) {
+			NL_SET_ERR_MSG_MOD(f->common.extack, "Unsupported HW TC");
+			return hw_tc;
+		}
+
+		prestera_acl_rule_hw_tc_set(rule, hw_tc);
+	}
+
 	prestera_acl_rule_priority_set(rule, f->common.prio);
 
 	if (flow_rule_match_key(f_rule, FLOW_DISSECTOR_KEY_META)) {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index c1297859e471..2d1dfb52aca4 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -91,6 +91,7 @@ enum {
 enum {
 	PRESTERA_CMD_SWITCH_ATTR_MAC = 1,
 	PRESTERA_CMD_SWITCH_ATTR_AGEING = 2,
+	PRESTERA_SWITCH_ATTR_TRAP_POLICER = 3,
 };
 
 enum {
@@ -319,6 +320,19 @@ struct prestera_msg_acl_action {
 	u32 id;
 };
 
+struct prestera_msg_acl_action_ext {
+	u32 id;
+	union {
+		struct {
+			u64 rate;
+			u64 burst;
+		} police;
+		struct {
+			u64 res[3];
+		} reserv;
+	} __packed;
+};
+
 struct prestera_msg_acl_match {
 	u32 type;
 	union {
@@ -354,6 +368,16 @@ struct prestera_msg_acl_rule_req {
 	u8 n_matches;
 };
 
+struct prestera_msg_acl_rule_ext_req {
+	struct prestera_msg_cmd cmd;
+	u32 id;
+	u32 priority;
+	u16 ruleset_id;
+	u8 n_actions;
+	u8 n_matches;
+	u8 hw_tc;
+};
+
 struct prestera_msg_acl_rule_resp {
 	struct prestera_msg_ret ret;
 	u32 id;
@@ -908,6 +932,36 @@ static int prestera_hw_acl_actions_put(struct prestera_msg_acl_action *action,
 	return 0;
 }
 
+static int prestera_hw_acl_actions_ext_put(struct prestera_msg_acl_action_ext *action,
+					   struct prestera_acl_rule *rule)
+{
+	struct list_head *a_list = prestera_acl_rule_action_list_get(rule);
+	struct prestera_acl_rule_action_entry *a_entry;
+	int i = 0;
+
+	list_for_each_entry(a_entry, a_list, list) {
+		action[i].id = a_entry->id;
+
+		switch (a_entry->id) {
+		case PRESTERA_ACL_RULE_ACTION_ACCEPT:
+		case PRESTERA_ACL_RULE_ACTION_DROP:
+		case PRESTERA_ACL_RULE_ACTION_TRAP:
+			/* just rule action id, no specific data */
+			break;
+		case PRESTERA_ACL_RULE_ACTION_POLICE:
+			action[i].police.rate = a_entry->police.rate;
+			action[i].police.burst = a_entry->police.burst;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		i++;
+	}
+
+	return 0;
+}
+
 static int prestera_hw_acl_matches_put(struct prestera_msg_acl_match *match,
 				       struct prestera_acl_rule *rule)
 {
@@ -963,9 +1017,9 @@ static int prestera_hw_acl_matches_put(struct prestera_msg_acl_match *match,
 	return 0;
 }
 
-int prestera_hw_acl_rule_add(struct prestera_switch *sw,
-			     struct prestera_acl_rule *rule,
-			     u32 *rule_id)
+int __prestera_hw_acl_rule_add(struct prestera_switch *sw,
+			       struct prestera_acl_rule *rule,
+			       u32 *rule_id)
 {
 	struct prestera_msg_acl_action *actions;
 	struct prestera_msg_acl_match *matches;
@@ -1017,6 +1071,71 @@ int prestera_hw_acl_rule_add(struct prestera_switch *sw,
 	return err;
 }
 
+int __prestera_hw_acl_rule_ext_add(struct prestera_switch *sw,
+				   struct prestera_acl_rule *rule,
+				   u32 *rule_id)
+{
+	struct prestera_msg_acl_action_ext *actions;
+	struct prestera_msg_acl_rule_ext_req *req;
+	struct prestera_msg_acl_match *matches;
+	struct prestera_msg_acl_rule_resp resp;
+	u8 n_actions;
+	u8 n_matches;
+	void *buff;
+	u32 size;
+	int err;
+
+	n_actions = prestera_acl_rule_action_len(rule);
+	n_matches = prestera_acl_rule_match_len(rule);
+
+	size = sizeof(*req) + sizeof(*actions) * n_actions +
+		sizeof(*matches) * n_matches;
+
+	buff = kzalloc(size, GFP_KERNEL);
+	if (!buff)
+		return -ENOMEM;
+
+	req = buff;
+	actions = buff + sizeof(*req);
+	matches = buff + sizeof(*req) + sizeof(*actions) * n_actions;
+
+	/* put acl actions into the message */
+	err = prestera_hw_acl_actions_ext_put(actions, rule);
+	if (err)
+		goto free_buff;
+
+	/* put acl matches into the message */
+	err = prestera_hw_acl_matches_put(matches, rule);
+	if (err)
+		goto free_buff;
+
+	req->ruleset_id = prestera_acl_rule_ruleset_id_get(rule);
+	req->priority = prestera_acl_rule_priority_get(rule);
+	req->n_actions = prestera_acl_rule_action_len(rule);
+	req->n_matches = prestera_acl_rule_match_len(rule);
+	req->hw_tc = prestera_acl_rule_hw_tc_get(rule);
+
+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_ACL_RULE_ADD,
+			       &req->cmd, size, &resp.ret, sizeof(resp));
+	if (err)
+		goto free_buff;
+
+	*rule_id = resp.id;
+free_buff:
+	kfree(buff);
+	return err;
+}
+
+int prestera_hw_acl_rule_add(struct prestera_switch *sw,
+			     struct prestera_acl_rule *rule,
+			     u32 *rule_id)
+{
+	if (sw->dev->fw_rev.maj == 3 && sw->dev->fw_rev.min == 0)
+		return __prestera_hw_acl_rule_add(sw, rule, rule_id);
+
+	return __prestera_hw_acl_rule_ext_add(sw, rule, rule_id);
+};
+
 int prestera_hw_acl_rule_del(struct prestera_switch *sw, u32 rule_id)
 {
 	struct prestera_msg_acl_rule_req req = {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index ce4cf51dba5a..f988603af1b6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -15,6 +15,7 @@
 #define PRESTERA_MSG_MAX_SIZE 1500
 
 static struct prestera_fw_rev prestera_fw_supp[] = {
+	{ 3, 1 },
 	{ 3, 0 },
 	{ 2, 0 }
 };
-- 
2.17.1

