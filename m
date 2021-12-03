Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B0C467753
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 13:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352150AbhLCM2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 07:28:47 -0500
Received: from mail-mw2nam10on2132.outbound.protection.outlook.com ([40.107.94.132]:46432
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244531AbhLCM2m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 07:28:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cX5cX9JBcEG8JeTQDrXisTulPwwBSHq+5ymxITWhKROexXaX1lAxYfdpQIJdzu8RKZBh3HIlMh23BtW3HNqZl7OAvVdycAiQxnJJ8GvXSlfe+0fUsfLwmbm2gBt7+taoZC+xdq35E7bZB2QmAWU7koazwZ3DZ94vcjRePLOxKDkRBsKVCKiBKCwbIsvgRpol8TM8sF+NziN4LEdgDJLPDvbQJZtwwSfacUj9r0KcMtoR9adQ98BGk57ObX3NtQ8Ai3OUjlCvV/kfa5CaVdeWOC+6ux98vyzn+yE5/84AD3uxHUF/PKNZKVn99fU/XHXomvHcYigzfW9VV0W+/631UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2OBkj9X5POozdYrp2fPiEE+HrGJUsKKXizHoCL0ZFQ=;
 b=Ebbf5qoSmnR/5A4ocXjoVBvruKOy1OB7C+ZyqC4ikcKJMq1sZLLlYj/feNH5fXipmQdJn/bjVvmoaWdJMD4HKCPy8SEHONCEg28xiw1mslk5tPvDt5xiyASAMov9j4kAYNkny+6E2kVAa5fRchYRAj4CRnY25W/Tcqd6dtwOpldb6szSSJY04PTX3HpQF5TzXfY7pHrWLM+5fb7EtODGo/XEQu00OzON//RsnZaW/XOqALQN9mhcOXYjasU6eflu1ET/u9OIqhPYZSaBtZKum6pw1m5c6YvDqFNgnHGhQMCI4S4nqGQAWmysa+ahwqeLimiH5kpAHhsljYK+rze7RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2OBkj9X5POozdYrp2fPiEE+HrGJUsKKXizHoCL0ZFQ=;
 b=TLSctekniCuzvlGdKw6eGTpZwqNpk2WEGSm5ALcBL3vCP3IiAz8Wmcv+nSH2WOnyuY5M+P/dh/PTYRMYz0vLzxdC+ih2yENzfySCeacTzfMHurRpvdEN3smwu7i7kRTHAHv4XMmql0kUwTc176a8NYFofWJA2uvydNZa1ul5exY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5423.namprd13.prod.outlook.com (2603:10b6:510:12a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.7; Fri, 3 Dec
 2021 12:25:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4755.015; Fri, 3 Dec 2021
 12:25:17 +0000
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
Subject: [PATCH v5 net-next 07/12] flow_offload: add skip_hw and skip_sw to control if offload the action
Date:   Fri,  3 Dec 2021 13:24:39 +0100
Message-Id: <20211203122444.11756-8-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211203122444.11756-1-simon.horman@corigine.com>
References: <20211203122444.11756-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0059.eurprd03.prod.outlook.com
 (2603:10a6:207:5::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:207:5::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Fri, 3 Dec 2021 12:25:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: deeed9e6-3fc9-4975-4340-08d9b657f708
X-MS-TrafficTypeDiagnostic: PH0PR13MB5423:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5423EC705CBA06A29F40A477E86A9@PH0PR13MB5423.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:568;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UXHDwLWyOMh2BBuUHcg0gjSIeUetyfk0UV/2RaD32PuLDnTmvT3S/8j7dUwzeVvFn2rhVN48j/56lMzrQ+fjjZQqOHgTHqMf2nT+GijTtDo743fAXxvS81uVixrTobngWGub0vL1t9shWW2sigpw2k+RuprEqUv5A+52B5pYoVQW8AApqAPt4XqiJaINmYCXUZ8/3RCz4AgzIOkJ+1grXwoo+8PYS9WmKwScuzwNCPgo//EHJWuLHKiF3Ajcc9uZ5RwJ3Ia9CFtSup5SnxXiYzJyjOHDSgMWxbG1vZAwNZx4fe1cSCVgR/pwMDqohVC9oP3DuHUybV2bWUPlCvCkc/QWnMhLHq4fpgYggtZfxSRHuCy9G+2SZs2pG+E2Gan10sYsx4JSZtHWM5JgI95GZvOQtltiXaA2Be73Bche9mPsK7b4gGZgRjnoQ5hhYLLq8yL9ywA1gwxxbeZobspm+SY7ETNJHL2/K6uwBA6vQRKtbW6+fhpm9LiWDgH6D/K9xSRknjKXBwzW+CCSXnFCxglOU9w2dEvK9a36NVZXbfw6uZk3hS6fWE3bIOIL2v7l6gfaK+wkt8jgB53E3oLmtEFRl4yJyj9JyLOWYyFCaYWlIgZR0Sl/duwtBJyNjWxlNNn5QldTPDqlQBWuHmjQ1eD0YLDtbMdv2fMu8quUIKU1EG8/0BrwbNKruJPKhtO9L/iegVDtNab087/wHDGs9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(366004)(346002)(376002)(396003)(136003)(6666004)(8936002)(38100700002)(2616005)(6506007)(4326008)(66946007)(66556008)(8676002)(36756003)(186003)(316002)(1076003)(44832011)(6486002)(508600001)(66476007)(5660300002)(107886003)(54906003)(52116002)(86362001)(83380400001)(6916009)(6512007)(2906002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fnCkdSsVaRo3z3tihPqAXSYJTvO6x6M/k85HTHAzQNjFyaRGYQrJP08t6FxV?=
 =?us-ascii?Q?R3sb6Xy0SX1xzrCC98XwbQOPnj6TDB3Ygb5B2ZSO76Ietc7ljGndRLDJPQuO?=
 =?us-ascii?Q?MnDZd+W5aoZxd71KKT7WiLay1+63qaJAFnEoIDh/b0EFcm9prTebeOPWcjnJ?=
 =?us-ascii?Q?KTe3kPWHXdncDGwblvFQPltO7JKpZt5XL3cXbllZKp218rPQ1qT1Gfs6asOt?=
 =?us-ascii?Q?nr7c5oN5wHOJL81GyYWNsqoqnnUQVS8KamXM2u33+VJWX9iZznd9eBfxpb1z?=
 =?us-ascii?Q?sjZ5qzpLz4TkXDVNigOGbwDAUQZF0BYei4l3EiaidTHaygRTo9fV+o288jcc?=
 =?us-ascii?Q?gcjf2IlTvgGQ+2G6iMttWbTj3UnxbahKX77a96WQiwwIsJ/jWyV5t79op2r9?=
 =?us-ascii?Q?61gp1z+e7GdSYl07pLebSiBP3g/eiG6saL+6Wpez5wkm81gp2tpliOBjTX+H?=
 =?us-ascii?Q?OdE/87iJ6POwPd0UjZpX3EtdZ4BEsuyJ6MUViIBWB1pOYu1FePPxdaMvryPV?=
 =?us-ascii?Q?CmvkYpoKo2VMXGeUzxy0uwwbYBNQOLM1ETg/Y5mKj26oeHF6Zr3rLtXFbVMz?=
 =?us-ascii?Q?wLbDwFdAZpskYpEHhjl+eokLE7jMstUmFQX7/cbkLHecYK5v++0cu94KAoAF?=
 =?us-ascii?Q?DrZl9YF7xgJBr53trqoKEgTLh5eI7nhIX9WYLKVf4S9Iz4z4sfbVqXtbS0Pg?=
 =?us-ascii?Q?V5l6bqmiaNl9HvoFeaw4WHhAiqYjNS69XY+Kdu+4tmx83Uh2z+rTV0vHsYMU?=
 =?us-ascii?Q?sJrlDznJGfKK+JEeLeCALS4c8V9DhmnueYE5Epo/XlR+VssK53ReFThepbIJ?=
 =?us-ascii?Q?QMmGsAdsJ948wPJ4WNBmwL+5C5F9+dGde9jMM3kabCnWbMhdALS7hP4hBh6k?=
 =?us-ascii?Q?TjWCB7114Q7wVXhADE4rQL9O8ORZ7GZSghTblfqedH0hnNo4ySJnybas3+R4?=
 =?us-ascii?Q?tORHIHwoFjfsUV4C7rpRnq4tqSxCqWy/faQrSu9fifAdKKJQX4Y+PFPVIs63?=
 =?us-ascii?Q?rgD/rQT14EP3oI6Y912si+ZF31B2mXvLt+z5p/J8E5Y1xUKOcvzsc2K7HR26?=
 =?us-ascii?Q?Jns6z/P+sFFWgM2GExGNgv02o8aesPCEuaOIoiZzUX4sQ/4WOT3lbFV96vPV?=
 =?us-ascii?Q?EB/2gaXpqry7VjvJ/zRveaVmuPc9EH2nt4po2/LwV0nMSaOvRITDN6EA7C7v?=
 =?us-ascii?Q?uRR082/Id1yqh4meNqi0+u5aetsL/mUm6EH/2IQH8vc7f+LHRQ5+NyOThjlW?=
 =?us-ascii?Q?3S8eUzVBwEepZdbzi35rVT/IlqMKYob5vFW5PXgzwd/mrmLfs53XjsKItBIa?=
 =?us-ascii?Q?HbJ+OuJuxe4uY2m7ga55e3xse/A+Rk/rwRe7j91yNG/CHejQvxhXULS66FdX?=
 =?us-ascii?Q?IPW+GyBZK/hzTCrQbekx67lTkJbQftfqUFT8p1reCgIjB7qM8Z6Sig5rX7rS?=
 =?us-ascii?Q?/9dfDHKnNdIJ9nw07QJxnaUVCR91ULxuZXS8BoPuII/VJjMOMZIWHSCOkbTh?=
 =?us-ascii?Q?Yj9FMzko33yo3pxPdV8exNwnf7ufkO793nAr440h+Ivr46orQE4gtYOF7eT/?=
 =?us-ascii?Q?LSlU0sovcFNmm6C139EFQFdqnG2X/eEJGb03NIU8rR428N18JJ2dKqlw7LR+?=
 =?us-ascii?Q?9AXzh3jFr8ad8cUnszOum7RXzlE1SHqFUHnpKzgYHqanVbiqSfdBH9BMQVfn?=
 =?us-ascii?Q?FibFSOM0fq4/whk8oiQW1GZXE7CZ0wct965cDf5gUceEMFp1uMVs4aQnEq0L?=
 =?us-ascii?Q?Qa6x4wtKUYHBpoL9mRDFYpYDYYGtEas=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deeed9e6-3fc9-4975-4340-08d9b657f708
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 12:25:17.3784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vFh+fankTopdcMolOWVa3R7S6U6pMVl4KZv2qgDpAB9rxwVb1uxFS8f4u6mkWlD1O0TylGje1hsPTzzVvkz7nKQQpLSoVzg4Jfya7Zdrhf8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5423
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

We add skip_hw and skip_sw for user to control if offload the action
to hardware.

We also add in_hw_count for user to indicate if the action is offloaded
to any hardware.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/act_api.h        |  1 +
 include/uapi/linux/pkt_cls.h |  9 ++--
 net/sched/act_api.c          | 83 +++++++++++++++++++++++++++++++++---
 3 files changed, 84 insertions(+), 9 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 73f15c4ff928..7e4e79b50216 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -44,6 +44,7 @@ struct tc_action {
 	u8			hw_stats;
 	u8			used_hw_stats;
 	bool			used_hw_stats_valid;
+	u32			in_hw_count;
 };
 #define tcf_index	common.tcfa_index
 #define tcf_refcnt	common.tcfa_refcnt
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 6836ccb9c45d..ee38b35c3f57 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -19,13 +19,16 @@ enum {
 	TCA_ACT_FLAGS,
 	TCA_ACT_HW_STATS,
 	TCA_ACT_USED_HW_STATS,
+	TCA_ACT_IN_HW_COUNT,
 	__TCA_ACT_MAX
 };
 
 /* See other TCA_ACT_FLAGS_ * flags in include/net/act_api.h. */
-#define TCA_ACT_FLAGS_NO_PERCPU_STATS 1 /* Don't use percpu allocator for
-					 * actions stats.
-					 */
+#define TCA_ACT_FLAGS_NO_PERCPU_STATS (1 << 0) /* Don't use percpu allocator for
+						* actions stats.
+						*/
+#define TCA_ACT_FLAGS_SKIP_HW	(1 << 1) /* don't offload action to HW */
+#define TCA_ACT_FLAGS_SKIP_SW	(1 << 2) /* don't use action in SW */
 
 /* tca HW stats type
  * When user does not pass the attribute, he does not care.
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 120e72d8502c..1d469029f2cd 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -131,6 +131,12 @@ static void free_tcf(struct tc_action *p)
 	kfree(p);
 }
 
+static void flow_action_hw_count_set(struct tc_action *act,
+				     u32 hw_count)
+{
+	act->in_hw_count = hw_count;
+}
+
 static unsigned int tcf_act_num_actions_single(struct tc_action *act)
 {
 	if (is_tcf_pedit(act))
@@ -139,6 +145,29 @@ static unsigned int tcf_act_num_actions_single(struct tc_action *act)
 		return 1;
 }
 
+static bool tc_act_skip_hw(u32 flags)
+{
+	return (flags & TCA_ACT_FLAGS_SKIP_HW) ? true : false;
+}
+
+static bool tc_act_skip_sw(u32 flags)
+{
+	return (flags & TCA_ACT_FLAGS_SKIP_SW) ? true : false;
+}
+
+static bool tc_act_in_hw(struct tc_action *act)
+{
+	return !!act->in_hw_count;
+}
+
+/* SKIP_HW and SKIP_SW are mutually exclusive flags. */
+static bool tc_act_flags_valid(u32 flags)
+{
+	flags &= TCA_ACT_FLAGS_SKIP_HW | TCA_ACT_FLAGS_SKIP_SW;
+
+	return flags ^ (TCA_ACT_FLAGS_SKIP_HW | TCA_ACT_FLAGS_SKIP_SW);
+}
+
 static int flow_action_init(struct flow_offload_action *fl_action,
 			    struct tc_action *act,
 			    enum flow_act_command cmd,
@@ -155,6 +184,7 @@ static int flow_action_init(struct flow_offload_action *fl_action,
 }
 
 static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
+				  u32 *hw_count,
 				  struct netlink_ext_ack *extack)
 {
 	int err;
@@ -164,6 +194,9 @@ static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
 	if (err < 0)
 		return err;
 
+	if (hw_count)
+		*hw_count = err;
+
 	return 0;
 }
 
@@ -171,12 +204,17 @@ static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
 static int tcf_action_offload_add(struct tc_action *action,
 				  struct netlink_ext_ack *extack)
 {
+	bool skip_sw = tc_act_skip_sw(action->tcfa_flags);
 	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
 		[0] = action,
 	};
 	struct flow_offload_action *fl_action;
+	u32 in_hw_count = 0;
 	int err = 0;
 
+	if (tc_act_skip_hw(action->tcfa_flags))
+		return 0;
+
 	fl_action = flow_action_alloc(tcf_act_num_actions_single(action));
 	if (!fl_action)
 		return -ENOMEM;
@@ -192,7 +230,13 @@ static int tcf_action_offload_add(struct tc_action *action,
 		goto fl_err;
 	}
 
-	err = tcf_action_offload_cmd(fl_action, extack);
+	err = tcf_action_offload_cmd(fl_action, &in_hw_count, extack);
+	if (!err)
+		flow_action_hw_count_set(action, in_hw_count);
+
+	if (skip_sw && !tc_act_in_hw(action))
+		err = -EINVAL;
+
 	tc_cleanup_flow_action(&fl_action->action);
 
 fl_err:
@@ -204,13 +248,24 @@ static int tcf_action_offload_add(struct tc_action *action,
 static int tcf_action_offload_del(struct tc_action *action)
 {
 	struct flow_offload_action fl_act = {};
+	u32 in_hw_count = 0;
 	int err = 0;
 
+	if (!tc_act_in_hw(action))
+		return 0;
+
 	err = flow_action_init(&fl_act, action, FLOW_ACT_DESTROY, NULL);
 	if (err)
 		return err;
 
-	return tcf_action_offload_cmd(&fl_act, NULL);
+	err = tcf_action_offload_cmd(&fl_act, &in_hw_count, NULL);
+	if (err)
+		return err;
+
+	if (action->in_hw_count != in_hw_count)
+		return -EINVAL;
+
+	return 0;
 }
 
 static void tcf_action_cleanup(struct tc_action *p)
@@ -820,6 +875,9 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 			jmp_prgcnt -= 1;
 			continue;
 		}
+
+		if (tc_act_skip_sw(a->tcfa_flags))
+			continue;
 repeat:
 		ret = a->ops->act(skb, a, res);
 		if (ret == TC_ACT_REPEAT)
@@ -925,6 +983,9 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 			       a->tcfa_flags, a->tcfa_flags))
 		goto nla_put_failure;
 
+	if (nla_put_u32(skb, TCA_ACT_IN_HW_COUNT, a->in_hw_count))
+		goto nla_put_failure;
+
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
@@ -1004,7 +1065,9 @@ static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
 	[TCA_ACT_COOKIE]	= { .type = NLA_BINARY,
 				    .len = TC_COOKIE_MAX_SIZE },
 	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
-	[TCA_ACT_FLAGS]		= NLA_POLICY_BITFIELD32(TCA_ACT_FLAGS_NO_PERCPU_STATS),
+	[TCA_ACT_FLAGS]		= NLA_POLICY_BITFIELD32(TCA_ACT_FLAGS_NO_PERCPU_STATS |
+							TCA_ACT_FLAGS_SKIP_HW |
+							TCA_ACT_FLAGS_SKIP_SW),
 	[TCA_ACT_HW_STATS]	= NLA_POLICY_BITFIELD32(TCA_ACT_HW_STATS_ANY),
 };
 
@@ -1117,8 +1180,13 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 			}
 		}
 		hw_stats = tcf_action_hw_stats_get(tb[TCA_ACT_HW_STATS]);
-		if (tb[TCA_ACT_FLAGS])
+		if (tb[TCA_ACT_FLAGS]) {
 			userflags = nla_get_bitfield32(tb[TCA_ACT_FLAGS]);
+			if (!tc_act_flags_valid(userflags.value)) {
+				err = -EINVAL;
+				goto err_out;
+			}
+		}
 
 		err = a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, tp,
 				userflags.value | flags, extack);
@@ -1193,8 +1261,11 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		sz += tcf_action_fill_size(act);
 		/* Start from index 0 */
 		actions[i - 1] = act;
-		if (!tc_act_bind(flags))
-			tcf_action_offload_add(act, extack);
+		if (!tc_act_bind(flags)) {
+			err = tcf_action_offload_add(act, extack);
+			if (tc_act_skip_sw(act->tcfa_flags) && err)
+				goto err;
+		}
 	}
 
 	/* We have to commit them all together, because if any error happened in
-- 
2.20.1

