Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B62467750
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 13:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244571AbhLCM2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 07:28:39 -0500
Received: from mail-co1nam11on2101.outbound.protection.outlook.com ([40.107.220.101]:17504
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244531AbhLCM2h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 07:28:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cV8vawNNU08qk01btz7psprwjADbf4NyQu7+zVl5l8UV4wxwgFJHVXupZYDJa+xAHQwiFbjfEi6WR97rU5uXnilFVo+VId7gPgJLvLWSgm1ZNIWXCLPrN6zWQCMcaCvGgRefi2GQTP7Xt2UT/M0Sk6XKdOYj9jnFJ/vIB+kHaG/JW4LF6PO/jmrnCTqdYD3wXCCSayzbvnX286HgTe5todt09OL2/WwpfxSm6rxR93F7mwVhl8h9AUNmytQmb1xc4pdsuaIKiLYUY5HU+PXgG05rGvsfR0cPRQwliAHLUg41MLP9aEUJ0tWmUiLizdTNRv9WCfcQQXYm+TtCUSCr0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=937RczJ/0qLoChymm0oYEEFrZkYaHmKo/ttsiiwj3Mg=;
 b=YW9msriTNQY3RNxKNMiG2ShRe9b0XhZumEEaLaE7iEhtxIiyRe1DR4Eb+mwycm+QxoGepwH+ke2WpKzBEIBP9bXuTzdJeTgq32TL42Y8znMRjY/R2ftIUaqI88LllUpjtftW2FG86+SUfPp1E0NolIFAlGXYFG5qUzuoGANuq3RDDowWspfbEzBp5mXA1se6HKdqIAE7o0Gouj/SZAmF80r/UUo7jLvgbrB1ni3bEdzt/lfB8lK7TPhQ1BEj7OhrjSJ1K9rhjCofWW0pyg6W4N0kyIx37uYoxjVCFZ6t+d86f1fv3HftRr2BNdKILvSCgylZAuRQ4T2UgLkoO8Sg1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=937RczJ/0qLoChymm0oYEEFrZkYaHmKo/ttsiiwj3Mg=;
 b=EuH94Glj11nLqO6xYRG/V2H+eXxMMN6fN1lG5qMQspy1o87Edkx/KHuB7WQMk3LybRmXgg6Mxg0fyaXbqFE3zuppeQVeijgg/3PmWSTkkq7pvH3NooyjpXbyQgXE+RIzbXw4LSLNb9aAzcppXH4NX2ooLrSGbniBu+InoeYClTE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5283.namprd13.prod.outlook.com (2603:10b6:510:f4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Fri, 3 Dec
 2021 12:25:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4755.015; Fri, 3 Dec 2021
 12:25:12 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 05/12] flow_offload: add ops to tc_action_ops for flow action setup
Date:   Fri,  3 Dec 2021 13:24:37 +0100
Message-Id: <20211203122444.11756-6-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211203122444.11756-1-simon.horman@corigine.com>
References: <20211203122444.11756-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0059.eurprd03.prod.outlook.com
 (2603:10a6:207:5::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:207:5::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Fri, 3 Dec 2021 12:25:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f4b43da-9afd-48db-6b6e-08d9b657f41d
X-MS-TrafficTypeDiagnostic: PH0PR13MB5283:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5283495FD6207FADF68A3442E86A9@PH0PR13MB5283.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ZB9dY8/cILBla+GNudi8JEn06HJQySfFb6209VIQ4mVrNP2OYkCatLUMEeqosYF0MSgxyCH8unCwalcQCosBc2eZeyMrjQE0d1JaamuoEZy96XV8qY9Kiudk+oh9z9nvCUiwaKIQ0xBnC9iMrmbf7a+3LL6hk8J3cnErhGDEPrDzra8Edlt934NLPcM2OhRBHRKTzQgXoDozz9ITAE+4wFFfl6s00MxHGL8UxqbE+ZuedD0oNFYh7QCSC9bwJbW+vxKMq2tGo+U0+EtFGKqiLPtM7gVhiKVK2USgZksowcOjHpsm9joUkvFFD7BZIlAT1Du/cxlUHNgbmJnhHf3U4c5PUPKeTrrjzj535QbPtcLYhoO5XnN7JyLZLHbTpqsgp4qi646/clNsku12se8nabzxXkOl8joRXO8QHINe1siHs0WF7N+MH82HpkzUB8Z2lZ/pAdXxcHBdNse/twXMwNYkjUpZMQw2/x5gTuWYxq/L5CYJKPwwx8BDqnTxL380WBQr4jOJInPQ2KXEzANKBjUjSESRV3hQXh2lIvSd3ZgB8IMRYhThcuM3thsj/gcyP1/j2mUYwbCzXNnHZF7tEeKAr5R0IdcDL8mFFEum/e89iWdfYMNWjGqYSHAotCWhbtbLq8qTyNlPsR9Ls7PZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39830400003)(346002)(376002)(136003)(396003)(86362001)(52116002)(36756003)(44832011)(508600001)(186003)(83380400001)(6666004)(6486002)(66946007)(6916009)(5660300002)(316002)(2616005)(66476007)(8676002)(6506007)(8936002)(107886003)(30864003)(2906002)(6512007)(54906003)(38100700002)(1076003)(4326008)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dB2+8bt3hdVhQj0ci5CMtdJ4NesEboWngoFvCz/w3/KjEmQ3k6JuY+Xmdedq?=
 =?us-ascii?Q?nR3n00jGv9tdx/b4jXLoIvrFObUD1kWytIyNqruWgtdO40Q9mMiqcyw0JxIq?=
 =?us-ascii?Q?Dzv3/SrADOF8FXbB4gGM1H0AB6G8E9LT6U0ek5QQSIl5qkyNmoVMjugHxxSD?=
 =?us-ascii?Q?z5KiSPmHWTaOG5EA3d/wFfBv8OwcY0y1Ou/nJr/KM2R2PRc+XA+31UyYJfDD?=
 =?us-ascii?Q?pDiZP8CfBMftmIE6qNQkWmP38/I9Vfqpaq+2XVN8U38/URXCEZZQDs7sVYGJ?=
 =?us-ascii?Q?QoCmRCcWj/nJ/l9kHzGr9GRGncLknaPd2fhdjdhZGBRWDJXGTLl60E6SGU5Z?=
 =?us-ascii?Q?/cj7vPYKZyobul6Nr8vCW4Dnke3Di/YXENQp+EU6nWgsLaBdCK9Gn3A4/QF+?=
 =?us-ascii?Q?zejnuLtbwjyBi+hU1PBpVDZgL1zky+grq+urCU+hgK2wbFgGDwzEY/i952gr?=
 =?us-ascii?Q?Xh63Brske27ZuWAGHzSS1q5cYekoEIhilJYZjQm4dr4lCqxXnwfJ8dI//D6k?=
 =?us-ascii?Q?CR/1pAz33TMgsVL385gI7cPogYztLJg6jbx3f1VyOvGk+ZI0LG5zN6BSWJyr?=
 =?us-ascii?Q?7sZHVQhhGm2tVTSJcErHzCmMWaO35zBt73VtsUBtUoX/ImXu74CsvTIdmgQw?=
 =?us-ascii?Q?TqZDuaYP3ob9LdjyhKqo+fdigAVZYk1spoJGqY0i89VOdRoF845ohAXNhR/M?=
 =?us-ascii?Q?n3gA7hQJAc39CFzKCWV/SnJGKA2HszsVBGR3oNfnhD4Y3Kq8iR+zcvYV0exA?=
 =?us-ascii?Q?PSHFK150uUa1zQRh3xcBU1+DqVrqdI3fQPGR5Mq2QrYbxPWd3PpBaAnrJkG2?=
 =?us-ascii?Q?ri7QfSxL4EI75oBMYotm0/4IWXtgGG5rtatWedjSE+9rZis23/yjxkswlVoS?=
 =?us-ascii?Q?Tkx31FLIqQ6JTg7I9oWMaGjwHSeXbAPxtuYyrjWKTFDZFERSkGJhYjsL7WHb?=
 =?us-ascii?Q?j6sjGBEWv8hMpkpMSO3s+cmLWiL82XF2Gj5LKGvm1EJxlOKlzQHv5oq8gUft?=
 =?us-ascii?Q?NcTQvCVGtK0+iEU8FUizh5XFAamdD3AvoJYAwqSsJ67VZrwZeA6SVzxsdDn6?=
 =?us-ascii?Q?Ub5fuOI9qWaim/jPgM13zb4mKslGmP3FjTB+A3bKsN1ytZOQ8+NvPwsskrHu?=
 =?us-ascii?Q?VU/Zmy6kPecfuEDMB06rxqV23NZQJrvvKkFKRodtXZh0QIgMDpP1FzEc9Q9b?=
 =?us-ascii?Q?GU6S2MpRCwPhQzWzN61mq7USGeQMKHidK0UJxgAC/bJzWZJQFhBM1wgRctom?=
 =?us-ascii?Q?BZPFtqO4yLV2mJ0V8K6QH6nnFshpTAHEMm5zrDI2kNjxfdrCcYKkbMZAtw9I?=
 =?us-ascii?Q?V75CzNTY0tq66k39/5XRgL0mhnuLbLzjZdnysjMcSLyxTiZte0skD85uXUn6?=
 =?us-ascii?Q?XKWrpu0opuEbqnYLlSnnx0Q2v/q1Io4cNe3g3lPrxWyUe7JxjGDamzWeEo4b?=
 =?us-ascii?Q?v+oVEie63G+IkGFjvEQe9tLx2juk+BuRmA519M5SbB5tVfyvP/CnaElE9ggR?=
 =?us-ascii?Q?wkQfRTd1UQwI3IC/JPXhxRiiiBnAo7ConPwAEVvqYJC8C4AXnkT8YKYr0LL2?=
 =?us-ascii?Q?exzufa9jc/KvR3Ep6JmCOmx8OGoXX6B9pxeAHihGhNY2FL7gy0A1C1KbPx0/?=
 =?us-ascii?Q?w0kwxOCQozHNIaICPgtbkjsNtRJHX4/bv6xUavkyhUxpfm9agZ1NgJ01c/x5?=
 =?us-ascii?Q?lKwAU6OLJ/jYDKjc6y1IJ/1svQ7wjn80RWbc6JMO2wLgr28Cb7HUiewjFVzf?=
 =?us-ascii?Q?U7WpyBpg/W/f5jmaP8wo96F70IEvQrg=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f4b43da-9afd-48db-6b6e-08d9b657f41d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 12:25:12.6163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ibd7392R8uMcQ/bfdp7YYvRLKtBU0k5EPA0B1Dan/F0kUt/J1eJ+P9RQtSpoZxxISuy8Lfk8pT0N7y0FvidsGubWGy+Jm/Et1DhyNX2ab5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5283
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add a new ops to tc_action_ops for flow action setup.

Refactor function tc_setup_flow_action to use this new ops.

We make this change to facilitate to add standalone action module.

We will also use this ops to offload action independent of filter
in following patch.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/act_api.h      |  12 ++
 net/sched/act_csum.c       |  17 +++
 net/sched/act_ct.c         |  19 ++++
 net/sched/act_gact.c       |  27 +++++
 net/sched/act_gate.c       |  47 ++++++++
 net/sched/act_mirred.c     |  39 +++++++
 net/sched/act_mpls.c       |  38 +++++++
 net/sched/act_pedit.c      |  34 ++++++
 net/sched/act_police.c     |  23 ++++
 net/sched/act_sample.c     |  28 +++++
 net/sched/act_skbedit.c    |  27 +++++
 net/sched/act_tunnel_key.c |  47 ++++++++
 net/sched/act_vlan.c       |  34 ++++++
 net/sched/cls_api.c        | 222 +++----------------------------------
 14 files changed, 406 insertions(+), 208 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index b5b624c7e488..73f15c4ff928 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -88,6 +88,16 @@ static inline void tcf_tm_dump(struct tcf_t *dtm, const struct tcf_t *stm)
 	dtm->expires = jiffies_to_clock_t(stm->expires);
 }
 
+static inline enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
+{
+	if (WARN_ON_ONCE(hw_stats > TCA_ACT_HW_STATS_ANY))
+		return FLOW_ACTION_HW_STATS_DONT_CARE;
+	else if (!hw_stats)
+		return FLOW_ACTION_HW_STATS_DISABLED;
+
+	return hw_stats;
+}
+
 #ifdef CONFIG_NET_CLS_ACT
 
 #define ACT_P_CREATED 1
@@ -121,6 +131,8 @@ struct tc_action_ops {
 	struct psample_group *
 	(*get_psample_group)(const struct tc_action *a,
 			     tc_action_priv_destructor *destructor);
+	int     (*flow_act_setup)(struct tc_action *act, void *entry_data,
+				  u32 *index_inc, bool bind);
 };
 
 struct tc_action_net {
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index a15ec95e69c3..b55d687e3adc 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -695,6 +695,22 @@ static size_t tcf_csum_get_fill_size(const struct tc_action *act)
 	return nla_total_size(sizeof(struct tc_csum));
 }
 
+static int tcf_csum_flow_act_setup(struct tc_action *act, void *entry_data,
+				   u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		entry->id = FLOW_ACTION_CSUM;
+		entry->csum_flags = tcf_csum_update_flags(act);
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_csum_ops = {
 	.kind		= "csum",
 	.id		= TCA_ID_CSUM,
@@ -706,6 +722,7 @@ static struct tc_action_ops act_csum_ops = {
 	.walk		= tcf_csum_walker,
 	.lookup		= tcf_csum_search,
 	.get_fill_size  = tcf_csum_get_fill_size,
+	.flow_act_setup = tcf_csum_flow_act_setup,
 	.size		= sizeof(struct tcf_csum),
 };
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index ab1810f2e660..9edfed3b0f4b 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1493,6 +1493,24 @@ static void tcf_stats_update(struct tc_action *a, u64 bytes, u64 packets,
 	c->tcf_tm.lastuse = max_t(u64, c->tcf_tm.lastuse, lastuse);
 }
 
+static int tcf_ct_flow_act_setup(struct tc_action *act, void *entry_data,
+				 u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		entry->id = FLOW_ACTION_CT;
+		entry->ct.action = tcf_ct_action(act);
+		entry->ct.zone = tcf_ct_zone(act);
+		entry->ct.flow_table = tcf_ct_ft(act);
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_ct_ops = {
 	.kind		=	"ct",
 	.id		=	TCA_ID_CT,
@@ -1504,6 +1522,7 @@ static struct tc_action_ops act_ct_ops = {
 	.walk		=	tcf_ct_walker,
 	.lookup		=	tcf_ct_search,
 	.stats_update	=	tcf_stats_update,
+	.flow_act_setup =	tcf_ct_flow_act_setup,
 	.size		=	sizeof(struct tcf_ct),
 };
 
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index d8dce173df37..2342aa5d8284 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -252,6 +252,32 @@ static size_t tcf_gact_get_fill_size(const struct tc_action *act)
 	return sz;
 }
 
+static int tcf_gact_flow_act_setup(struct tc_action *act, void *entry_data,
+				   u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		if (is_tcf_gact_ok(act)) {
+			entry->id = FLOW_ACTION_ACCEPT;
+		} else if (is_tcf_gact_shot(act)) {
+			entry->id = FLOW_ACTION_DROP;
+		} else if (is_tcf_gact_trap(act)) {
+			entry->id = FLOW_ACTION_TRAP;
+		} else if (is_tcf_gact_goto_chain(act)) {
+			entry->id = FLOW_ACTION_GOTO;
+			entry->chain_index = tcf_gact_goto_chain_index(act);
+		} else {
+			return -EOPNOTSUPP;
+		}
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_gact_ops = {
 	.kind		=	"gact",
 	.id		=	TCA_ID_GACT,
@@ -263,6 +289,7 @@ static struct tc_action_ops act_gact_ops = {
 	.walk		=	tcf_gact_walker,
 	.lookup		=	tcf_gact_search,
 	.get_fill_size	=	tcf_gact_get_fill_size,
+	.flow_act_setup =	tcf_gact_flow_act_setup,
 	.size		=	sizeof(struct tcf_gact),
 };
 
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index ac985c53ebaf..cbdcbe4376bb 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -597,6 +597,52 @@ static size_t tcf_gate_get_fill_size(const struct tc_action *act)
 	return nla_total_size(sizeof(struct tc_gate));
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
+static int tcf_gate_flow_act_setup(struct tc_action *act, void *entry_data,
+				   u32 *index_inc, bool bind)
+{
+	int err;
+
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		entry->id = FLOW_ACTION_GATE;
+		entry->gate.prio = tcf_gate_prio(act);
+		entry->gate.basetime = tcf_gate_basetime(act);
+		entry->gate.cycletime = tcf_gate_cycletime(act);
+		entry->gate.cycletimeext = tcf_gate_cycletimeext(act);
+		entry->gate.num_entries = tcf_gate_num_entries(act);
+		err = tcf_gate_get_entries(entry, act);
+		if (err)
+			return err;
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_gate_ops = {
 	.kind		=	"gate",
 	.id		=	TCA_ID_GATE,
@@ -609,6 +655,7 @@ static struct tc_action_ops act_gate_ops = {
 	.stats_update	=	tcf_gate_stats_update,
 	.get_fill_size	=	tcf_gate_get_fill_size,
 	.lookup		=	tcf_gate_search,
+	.flow_act_setup =	tcf_gate_flow_act_setup,
 	.size		=	sizeof(struct tcf_gate),
 };
 
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index efc963ab995a..8c953b2dc2d5 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -448,6 +448,44 @@ static size_t tcf_mirred_get_fill_size(const struct tc_action *act)
 	return nla_total_size(sizeof(struct tc_mirred));
 }
 
+static void tcf_flow_mirred_get_dev(struct flow_action_entry *entry,
+				    const struct tc_action *act)
+{
+	entry->dev = act->ops->get_dev(act, &entry->destructor);
+	if (!entry->dev)
+		return;
+	entry->destructor_priv = entry->dev;
+}
+
+static int tcf_mirred_flow_act_setup(struct tc_action *act, void *entry_data,
+				     u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		if (is_tcf_mirred_egress_redirect(act)) {
+			entry->id = FLOW_ACTION_REDIRECT;
+			tcf_flow_mirred_get_dev(entry, act);
+		} else if (is_tcf_mirred_egress_mirror(act)) {
+			entry->id = FLOW_ACTION_MIRRED;
+			tcf_flow_mirred_get_dev(entry, act);
+		} else if (is_tcf_mirred_ingress_redirect(act)) {
+			entry->id = FLOW_ACTION_REDIRECT_INGRESS;
+			tcf_flow_mirred_get_dev(entry, act);
+		} else if (is_tcf_mirred_ingress_mirror(act)) {
+			entry->id = FLOW_ACTION_MIRRED_INGRESS;
+			tcf_flow_mirred_get_dev(entry, act);
+		} else {
+			return -EOPNOTSUPP;
+		}
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_mirred_ops = {
 	.kind		=	"mirred",
 	.id		=	TCA_ID_MIRRED,
@@ -460,6 +498,7 @@ static struct tc_action_ops act_mirred_ops = {
 	.walk		=	tcf_mirred_walker,
 	.lookup		=	tcf_mirred_search,
 	.get_fill_size	=	tcf_mirred_get_fill_size,
+	.flow_act_setup =	tcf_mirred_flow_act_setup,
 	.size		=	sizeof(struct tcf_mirred),
 	.get_dev	=	tcf_mirred_get_dev,
 };
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 2b30dc562743..69bc9e10ee3e 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -384,6 +384,43 @@ static int tcf_mpls_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_mpls_flow_act_setup(struct tc_action *act, void *entry_data,
+				   u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		switch (tcf_mpls_action(act)) {
+		case TCA_MPLS_ACT_PUSH:
+			entry->id = FLOW_ACTION_MPLS_PUSH;
+			entry->mpls_push.proto = tcf_mpls_proto(act);
+			entry->mpls_push.label = tcf_mpls_label(act);
+			entry->mpls_push.tc = tcf_mpls_tc(act);
+			entry->mpls_push.bos = tcf_mpls_bos(act);
+			entry->mpls_push.ttl = tcf_mpls_ttl(act);
+			break;
+		case TCA_MPLS_ACT_POP:
+			entry->id = FLOW_ACTION_MPLS_POP;
+			entry->mpls_pop.proto = tcf_mpls_proto(act);
+			break;
+		case TCA_MPLS_ACT_MODIFY:
+			entry->id = FLOW_ACTION_MPLS_MANGLE;
+			entry->mpls_mangle.label = tcf_mpls_label(act);
+			entry->mpls_mangle.tc = tcf_mpls_tc(act);
+			entry->mpls_mangle.bos = tcf_mpls_bos(act);
+			entry->mpls_mangle.ttl = tcf_mpls_ttl(act);
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_mpls_ops = {
 	.kind		=	"mpls",
 	.id		=	TCA_ID_MPLS,
@@ -394,6 +431,7 @@ static struct tc_action_ops act_mpls_ops = {
 	.cleanup	=	tcf_mpls_cleanup,
 	.walk		=	tcf_mpls_walker,
 	.lookup		=	tcf_mpls_search,
+	.flow_act_setup =	tcf_mpls_flow_act_setup,
 	.size		=	sizeof(struct tcf_mpls),
 };
 
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index cd3b8aad3192..ddd93909636b 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -487,6 +487,39 @@ static int tcf_pedit_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_pedit_flow_act_setup(struct tc_action *act, void *entry_data,
+				    u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+		int k;
+
+		for (k = 0; k < tcf_pedit_nkeys(act); k++) {
+			switch (tcf_pedit_cmd(act, k)) {
+			case TCA_PEDIT_KEY_EX_CMD_SET:
+				entry->id = FLOW_ACTION_MANGLE;
+				break;
+			case TCA_PEDIT_KEY_EX_CMD_ADD:
+				entry->id = FLOW_ACTION_ADD;
+				break;
+			default:
+				return -EOPNOTSUPP;
+			}
+			entry->mangle.htype = tcf_pedit_htype(act, k);
+			entry->mangle.mask = tcf_pedit_mask(act, k);
+			entry->mangle.val = tcf_pedit_val(act, k);
+			entry->mangle.offset = tcf_pedit_offset(act, k);
+			entry->hw_stats = tc_act_hw_stats(act->hw_stats);
+			entry++;
+		}
+		*index_inc = k;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_pedit_ops = {
 	.kind		=	"pedit",
 	.id		=	TCA_ID_PEDIT,
@@ -498,6 +531,7 @@ static struct tc_action_ops act_pedit_ops = {
 	.init		=	tcf_pedit_init,
 	.walk		=	tcf_pedit_walker,
 	.lookup		=	tcf_pedit_search,
+	.flow_act_setup =	tcf_pedit_flow_act_setup,
 	.size		=	sizeof(struct tcf_pedit),
 };
 
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index c13a6245dfba..f48e9765b70e 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -405,6 +405,28 @@ static int tcf_police_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_police_flow_act_setup(struct tc_action *act, void *entry_data,
+				     u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		entry->id = FLOW_ACTION_POLICE;
+		entry->police.burst = tcf_police_burst(act);
+		entry->police.rate_bytes_ps =
+			tcf_police_rate_bytes_ps(act);
+		entry->police.burst_pkt = tcf_police_burst_pkt(act);
+		entry->police.rate_pkt_ps =
+			tcf_police_rate_pkt_ps(act);
+		entry->police.mtu = tcf_police_tcfp_mtu(act);
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 MODULE_AUTHOR("Alexey Kuznetsov");
 MODULE_DESCRIPTION("Policing actions");
 MODULE_LICENSE("GPL");
@@ -420,6 +442,7 @@ static struct tc_action_ops act_police_ops = {
 	.walk		=	tcf_police_walker,
 	.lookup		=	tcf_police_search,
 	.cleanup	=	tcf_police_cleanup,
+	.flow_act_setup =	tcf_police_flow_act_setup,
 	.size		=	sizeof(struct tcf_police),
 };
 
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 91a7a93d5f6a..1b0bb501218e 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -282,6 +282,33 @@ tcf_sample_get_group(const struct tc_action *a,
 	return group;
 }
 
+static void tcf_flow_sample_get_group(struct flow_action_entry *entry,
+				      const struct tc_action *act)
+{
+	entry->sample.psample_group =
+		act->ops->get_psample_group(act, &entry->destructor);
+	entry->destructor_priv = entry->sample.psample_group;
+}
+
+static int tcf_sample_flow_act_setup(struct tc_action *act, void *entry_data,
+				     u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		entry->id = FLOW_ACTION_SAMPLE;
+		entry->sample.trunc_size = tcf_sample_trunc_size(act);
+		entry->sample.truncate = tcf_sample_truncate(act);
+		entry->sample.rate = tcf_sample_rate(act);
+		tcf_flow_sample_get_group(entry, act);
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_sample_ops = {
 	.kind	  = "sample",
 	.id	  = TCA_ID_SAMPLE,
@@ -294,6 +321,7 @@ static struct tc_action_ops act_sample_ops = {
 	.walk	  = tcf_sample_walker,
 	.lookup	  = tcf_sample_search,
 	.get_psample_group = tcf_sample_get_group,
+	.flow_act_setup    = tcf_sample_flow_act_setup,
 	.size	  = sizeof(struct tcf_sample),
 };
 
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index cb2d10d3dcc0..b0d791560aa6 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -327,6 +327,32 @@ static size_t tcf_skbedit_get_fill_size(const struct tc_action *act)
 		+ nla_total_size_64bit(sizeof(u64)); /* TCA_SKBEDIT_FLAGS */
 }
 
+static int tcf_skbedit_flow_act_setup(struct tc_action *act, void *entry_data,
+				      u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		if (is_tcf_skbedit_mark(act)) {
+			entry->id = FLOW_ACTION_MARK;
+			entry->mark = tcf_skbedit_mark(act);
+		} else if (is_tcf_skbedit_ptype(act)) {
+			entry->id = FLOW_ACTION_PTYPE;
+			entry->ptype = tcf_skbedit_ptype(act);
+		} else if (is_tcf_skbedit_priority(act)) {
+			entry->id = FLOW_ACTION_PRIORITY;
+			entry->priority = tcf_skbedit_priority(act);
+		} else {
+			return -EOPNOTSUPP;
+		}
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_skbedit_ops = {
 	.kind		=	"skbedit",
 	.id		=	TCA_ID_SKBEDIT,
@@ -339,6 +365,7 @@ static struct tc_action_ops act_skbedit_ops = {
 	.walk		=	tcf_skbedit_walker,
 	.get_fill_size	=	tcf_skbedit_get_fill_size,
 	.lookup		=	tcf_skbedit_search,
+	.flow_act_setup =	tcf_skbedit_flow_act_setup,
 	.size		=	sizeof(struct tcf_skbedit),
 };
 
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index d9cd174eecb7..14d8307c31a5 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -787,6 +787,52 @@ static int tunnel_key_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
+static void tcf_tunnel_encap_put_tunnel(void *priv)
+{
+	struct ip_tunnel_info *tunnel = priv;
+
+	kfree(tunnel);
+}
+
+static int tcf_tunnel_encap_get_tunnel(struct flow_action_entry *entry,
+				       const struct tc_action *act)
+{
+	entry->tunnel = tcf_tunnel_info_copy(act);
+	if (!entry->tunnel)
+		return -ENOMEM;
+	entry->destructor = tcf_tunnel_encap_put_tunnel;
+	entry->destructor_priv = entry->tunnel;
+	return 0;
+}
+
+static int tcf_tunnel_key_flow_act_setup(struct tc_action *act,
+					 void *entry_data,
+					 u32 *index_inc,
+					 bool bind)
+{
+	int err;
+
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		if (is_tcf_tunnel_set(act)) {
+			entry->id = FLOW_ACTION_TUNNEL_ENCAP;
+			err = tcf_tunnel_encap_get_tunnel(entry, act);
+			if (err)
+				return err;
+		} else if (is_tcf_tunnel_release(act)) {
+			entry->id = FLOW_ACTION_TUNNEL_DECAP;
+		} else {
+			return -EOPNOTSUPP;
+		}
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_tunnel_key_ops = {
 	.kind		=	"tunnel_key",
 	.id		=	TCA_ID_TUNNEL_KEY,
@@ -797,6 +843,7 @@ static struct tc_action_ops act_tunnel_key_ops = {
 	.cleanup	=	tunnel_key_release,
 	.walk		=	tunnel_key_walker,
 	.lookup		=	tunnel_key_search,
+	.flow_act_setup =	tcf_tunnel_key_flow_act_setup,
 	.size		=	sizeof(struct tcf_tunnel_key),
 };
 
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index e4dc5a555bd8..5de24a995020 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -368,6 +368,39 @@ static size_t tcf_vlan_get_fill_size(const struct tc_action *act)
 		+ nla_total_size(sizeof(u8)); /* TCA_VLAN_PUSH_VLAN_PRIORITY */
 }
 
+static int tcf_vlan_flow_act_setup(struct tc_action *act, void *entry_data,
+				   u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		switch (tcf_vlan_action(act)) {
+		case TCA_VLAN_ACT_PUSH:
+			entry->id = FLOW_ACTION_VLAN_PUSH;
+			entry->vlan.vid = tcf_vlan_push_vid(act);
+			entry->vlan.proto = tcf_vlan_push_proto(act);
+			entry->vlan.prio = tcf_vlan_push_prio(act);
+			break;
+		case TCA_VLAN_ACT_POP:
+			entry->id = FLOW_ACTION_VLAN_POP;
+			break;
+		case TCA_VLAN_ACT_MODIFY:
+			entry->id = FLOW_ACTION_VLAN_MANGLE;
+			entry->vlan.vid = tcf_vlan_push_vid(act);
+			entry->vlan.proto = tcf_vlan_push_proto(act);
+			entry->vlan.prio = tcf_vlan_push_prio(act);
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_vlan_ops = {
 	.kind		=	"vlan",
 	.id		=	TCA_ID_VLAN,
@@ -380,6 +413,7 @@ static struct tc_action_ops act_vlan_ops = {
 	.stats_update	=	tcf_vlan_stats_update,
 	.get_fill_size	=	tcf_vlan_get_fill_size,
 	.lookup		=	tcf_vlan_search,
+	.flow_act_setup =	tcf_vlan_flow_act_setup,
 	.size		=	sizeof(struct tcf_vlan),
 };
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 7a680cae0bae..33b81c867ac0 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3474,81 +3474,25 @@ void tc_cleanup_flow_action(struct flow_action *flow_action)
 }
 EXPORT_SYMBOL(tc_cleanup_flow_action);
 
-static void tcf_mirred_get_dev(struct flow_action_entry *entry,
-			       const struct tc_action *act)
+static int tc_setup_flow_act(struct tc_action *act,
+			     struct flow_action_entry *entry,
+			     u32 *index_inc)
 {
 #ifdef CONFIG_NET_CLS_ACT
-	entry->dev = act->ops->get_dev(act, &entry->destructor);
-	if (!entry->dev)
-		return;
-	entry->destructor_priv = entry->dev;
-#endif
-}
-
-static void tcf_tunnel_encap_put_tunnel(void *priv)
-{
-	struct ip_tunnel_info *tunnel = priv;
-
-	kfree(tunnel);
-}
-
-static int tcf_tunnel_encap_get_tunnel(struct flow_action_entry *entry,
-				       const struct tc_action *act)
-{
-	entry->tunnel = tcf_tunnel_info_copy(act);
-	if (!entry->tunnel)
-		return -ENOMEM;
-	entry->destructor = tcf_tunnel_encap_put_tunnel;
-	entry->destructor_priv = entry->tunnel;
+	if (act->ops->flow_act_setup)
+		return act->ops->flow_act_setup(act, entry, index_inc, true);
+	else
+		return -EOPNOTSUPP;
+#else
 	return 0;
-}
-
-static void tcf_sample_get_group(struct flow_action_entry *entry,
-				 const struct tc_action *act)
-{
-#ifdef CONFIG_NET_CLS_ACT
-	entry->sample.psample_group =
-		act->ops->get_psample_group(act, &entry->destructor);
-	entry->destructor_priv = entry->sample.psample_group;
 #endif
 }
 
-static void tcf_gate_entry_destructor(void *priv)
-{
-	struct action_gate_entry *oe = priv;
-
-	kfree(oe);
-}
-
-static int tcf_gate_get_entries(struct flow_action_entry *entry,
-				const struct tc_action *act)
-{
-	entry->gate.entries = tcf_gate_get_list(act);
-
-	if (!entry->gate.entries)
-		return -EINVAL;
-
-	entry->destructor = tcf_gate_entry_destructor;
-	entry->destructor_priv = entry->gate.entries;
-
-	return 0;
-}
-
-static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
-{
-	if (WARN_ON_ONCE(hw_stats > TCA_ACT_HW_STATS_ANY))
-		return FLOW_ACTION_HW_STATS_DONT_CARE;
-	else if (!hw_stats)
-		return FLOW_ACTION_HW_STATS_DISABLED;
-
-	return hw_stats;
-}
-
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts)
 {
+	int i, j, index, err = 0;
 	struct tc_action *act;
-	int i, j, k, err = 0;
 
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_ANY != FLOW_ACTION_HW_STATS_ANY);
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
@@ -3569,151 +3513,13 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 
 		entry->hw_stats = tc_act_hw_stats(act->hw_stats);
 		entry->index = act->tcfa_index;
-
-		if (is_tcf_gact_ok(act)) {
-			entry->id = FLOW_ACTION_ACCEPT;
-		} else if (is_tcf_gact_shot(act)) {
-			entry->id = FLOW_ACTION_DROP;
-		} else if (is_tcf_gact_trap(act)) {
-			entry->id = FLOW_ACTION_TRAP;
-		} else if (is_tcf_gact_goto_chain(act)) {
-			entry->id = FLOW_ACTION_GOTO;
-			entry->chain_index = tcf_gact_goto_chain_index(act);
-		} else if (is_tcf_mirred_egress_redirect(act)) {
-			entry->id = FLOW_ACTION_REDIRECT;
-			tcf_mirred_get_dev(entry, act);
-		} else if (is_tcf_mirred_egress_mirror(act)) {
-			entry->id = FLOW_ACTION_MIRRED;
-			tcf_mirred_get_dev(entry, act);
-		} else if (is_tcf_mirred_ingress_redirect(act)) {
-			entry->id = FLOW_ACTION_REDIRECT_INGRESS;
-			tcf_mirred_get_dev(entry, act);
-		} else if (is_tcf_mirred_ingress_mirror(act)) {
-			entry->id = FLOW_ACTION_MIRRED_INGRESS;
-			tcf_mirred_get_dev(entry, act);
-		} else if (is_tcf_vlan(act)) {
-			switch (tcf_vlan_action(act)) {
-			case TCA_VLAN_ACT_PUSH:
-				entry->id = FLOW_ACTION_VLAN_PUSH;
-				entry->vlan.vid = tcf_vlan_push_vid(act);
-				entry->vlan.proto = tcf_vlan_push_proto(act);
-				entry->vlan.prio = tcf_vlan_push_prio(act);
-				break;
-			case TCA_VLAN_ACT_POP:
-				entry->id = FLOW_ACTION_VLAN_POP;
-				break;
-			case TCA_VLAN_ACT_MODIFY:
-				entry->id = FLOW_ACTION_VLAN_MANGLE;
-				entry->vlan.vid = tcf_vlan_push_vid(act);
-				entry->vlan.proto = tcf_vlan_push_proto(act);
-				entry->vlan.prio = tcf_vlan_push_prio(act);
-				break;
-			default:
-				err = -EOPNOTSUPP;
-				goto err_out_locked;
-			}
-		} else if (is_tcf_tunnel_set(act)) {
-			entry->id = FLOW_ACTION_TUNNEL_ENCAP;
-			err = tcf_tunnel_encap_get_tunnel(entry, act);
-			if (err)
-				goto err_out_locked;
-		} else if (is_tcf_tunnel_release(act)) {
-			entry->id = FLOW_ACTION_TUNNEL_DECAP;
-		} else if (is_tcf_pedit(act)) {
-			for (k = 0; k < tcf_pedit_nkeys(act); k++) {
-				switch (tcf_pedit_cmd(act, k)) {
-				case TCA_PEDIT_KEY_EX_CMD_SET:
-					entry->id = FLOW_ACTION_MANGLE;
-					break;
-				case TCA_PEDIT_KEY_EX_CMD_ADD:
-					entry->id = FLOW_ACTION_ADD;
-					break;
-				default:
-					err = -EOPNOTSUPP;
-					goto err_out_locked;
-				}
-				entry->mangle.htype = tcf_pedit_htype(act, k);
-				entry->mangle.mask = tcf_pedit_mask(act, k);
-				entry->mangle.val = tcf_pedit_val(act, k);
-				entry->mangle.offset = tcf_pedit_offset(act, k);
-				entry->hw_stats = tc_act_hw_stats(act->hw_stats);
-				entry = &flow_action->entries[++j];
-			}
-		} else if (is_tcf_csum(act)) {
-			entry->id = FLOW_ACTION_CSUM;
-			entry->csum_flags = tcf_csum_update_flags(act);
-		} else if (is_tcf_skbedit_mark(act)) {
-			entry->id = FLOW_ACTION_MARK;
-			entry->mark = tcf_skbedit_mark(act);
-		} else if (is_tcf_sample(act)) {
-			entry->id = FLOW_ACTION_SAMPLE;
-			entry->sample.trunc_size = tcf_sample_trunc_size(act);
-			entry->sample.truncate = tcf_sample_truncate(act);
-			entry->sample.rate = tcf_sample_rate(act);
-			tcf_sample_get_group(entry, act);
-		} else if (is_tcf_police(act)) {
-			entry->id = FLOW_ACTION_POLICE;
-			entry->police.burst = tcf_police_burst(act);
-			entry->police.rate_bytes_ps =
-				tcf_police_rate_bytes_ps(act);
-			entry->police.burst_pkt = tcf_police_burst_pkt(act);
-			entry->police.rate_pkt_ps =
-				tcf_police_rate_pkt_ps(act);
-			entry->police.mtu = tcf_police_tcfp_mtu(act);
-		} else if (is_tcf_ct(act)) {
-			entry->id = FLOW_ACTION_CT;
-			entry->ct.action = tcf_ct_action(act);
-			entry->ct.zone = tcf_ct_zone(act);
-			entry->ct.flow_table = tcf_ct_ft(act);
-		} else if (is_tcf_mpls(act)) {
-			switch (tcf_mpls_action(act)) {
-			case TCA_MPLS_ACT_PUSH:
-				entry->id = FLOW_ACTION_MPLS_PUSH;
-				entry->mpls_push.proto = tcf_mpls_proto(act);
-				entry->mpls_push.label = tcf_mpls_label(act);
-				entry->mpls_push.tc = tcf_mpls_tc(act);
-				entry->mpls_push.bos = tcf_mpls_bos(act);
-				entry->mpls_push.ttl = tcf_mpls_ttl(act);
-				break;
-			case TCA_MPLS_ACT_POP:
-				entry->id = FLOW_ACTION_MPLS_POP;
-				entry->mpls_pop.proto = tcf_mpls_proto(act);
-				break;
-			case TCA_MPLS_ACT_MODIFY:
-				entry->id = FLOW_ACTION_MPLS_MANGLE;
-				entry->mpls_mangle.label = tcf_mpls_label(act);
-				entry->mpls_mangle.tc = tcf_mpls_tc(act);
-				entry->mpls_mangle.bos = tcf_mpls_bos(act);
-				entry->mpls_mangle.ttl = tcf_mpls_ttl(act);
-				break;
-			default:
-				err = -EOPNOTSUPP;
-				goto err_out_locked;
-			}
-		} else if (is_tcf_skbedit_ptype(act)) {
-			entry->id = FLOW_ACTION_PTYPE;
-			entry->ptype = tcf_skbedit_ptype(act);
-		} else if (is_tcf_skbedit_priority(act)) {
-			entry->id = FLOW_ACTION_PRIORITY;
-			entry->priority = tcf_skbedit_priority(act);
-		} else if (is_tcf_gate(act)) {
-			entry->id = FLOW_ACTION_GATE;
-			entry->gate.prio = tcf_gate_prio(act);
-			entry->gate.basetime = tcf_gate_basetime(act);
-			entry->gate.cycletime = tcf_gate_cycletime(act);
-			entry->gate.cycletimeext = tcf_gate_cycletimeext(act);
-			entry->gate.num_entries = tcf_gate_num_entries(act);
-			err = tcf_gate_get_entries(entry, act);
-			if (err)
-				goto err_out_locked;
-		} else {
-			err = -EOPNOTSUPP;
+		index = 0;
+		err = tc_setup_flow_act(act, entry, &index);
+		if (!err)
+			j += index;
+		else
 			goto err_out_locked;
-		}
 		spin_unlock_bh(&act->tcfa_lock);
-
-		if (!is_tcf_pedit(act))
-			j++;
 	}
 
 err_out:
-- 
2.20.1

