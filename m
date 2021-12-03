Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC61246775A
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 13:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380772AbhLCM3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 07:29:00 -0500
Received: from mail-mw2nam10on2095.outbound.protection.outlook.com ([40.107.94.95]:24832
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1380775AbhLCM2w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 07:28:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AuI3A621CAQ8JY0kYamIBC8cr87Tkj5PljCBh5pJ1c4djrj/UxCJS8a/HQG5156tS2Al9PYoGhaK6GO16fCDYDp5ZbPf9Rkcte6seUyWbNIqWjd3UFtFPai3OEpZjLkMXzbsXYm8fcSCG/Voe9IGk9N2QhSAzm5clUf9RkYDbuAp2uVBh4fe5vn1IKgmJ0lUKsde3Ps3XTXfvjG07kGVmHaG/Vnr8qX6qNoDnHsBSPSWh0gCfh+u5+tkly30V9kVG26OtIsib1s+W6pQXKjr0Xlw3f8p0DmHqw1PwG0biZL2Of5ihvm3CvRU382UO12gNJPYz6/3ZciWqfCvZYiauw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iQgWj+DCdO0wPFHB6SobC+E+Z6UytmFuAHLSUykhOEM=;
 b=jE5kRdccfzMseJCKkT+guKiXuveZJO3y8rryiqWp8JAIKcpFaAwPtGC1xYkg478Q5nq1i73K6IfIO8YMRem6hTV7+0Y572TZyRSDklvsQgYKgfqRxlf5jfR3jngVKzqMeF2XkbbXibazi1h/UCmrJtQgbeX/c5OUJb3ZODHQD8hVVHXtAT7F1A9KViJCbha6qRAfbbNMQ2VMVyv8bGFF+RFgVksPno4n/sTGihbqkgEvsR1afEFuNX9GauUwJZAi6DmKjVSDD4we0NMGK3k6o1lMXqo+q3IAISVdZJPTy9HrqTl/SIhAwktAM84kk2EQ2LqBiv31jl4zN0+GLNyipQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQgWj+DCdO0wPFHB6SobC+E+Z6UytmFuAHLSUykhOEM=;
 b=aVNFurqWcVnCeCN+r7fCybVuz6tU27AuxlWB5FHojEsqvvVkvHsQUpbGwlkyh4lUVYTAOypXDlfA2qT1AeTB9OxKRVAbJtSJz/XPrsNuM/w0dIRQgy0fy0TDyUXLr+Sv29XBJZmaTzNTgI35h6fZZYT2OehpID6lSNwm05nFXWM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5423.namprd13.prod.outlook.com (2603:10b6:510:12a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.7; Fri, 3 Dec
 2021 12:25:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4755.015; Fri, 3 Dec 2021
 12:25:27 +0000
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
Subject: [PATCH v5 net-next 11/12] flow_offload: validate flags of filter and actions
Date:   Fri,  3 Dec 2021 13:24:43 +0100
Message-Id: <20211203122444.11756-12-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211203122444.11756-1-simon.horman@corigine.com>
References: <20211203122444.11756-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0059.eurprd03.prod.outlook.com
 (2603:10a6:207:5::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:207:5::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Fri, 3 Dec 2021 12:25:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e986c2c-bbdc-4b04-1e73-08d9b657fd07
X-MS-TrafficTypeDiagnostic: PH0PR13MB5423:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB54231879AF76BB27BE7E953DE86A9@PH0PR13MB5423.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:16;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ScpKmWRRQtH1CIuHTklOW3u7HH5uEbT1uBeU2WJtjPjSeDqyNhfNi6M411qqkl/+TQttYG94/ReX64Yf5gXsNQcLK35tVll9MJMMEUrwySoCnAicJZ3QY9ibX7veurAeu13GzhYqMMmT79YiWyGMVjZz0nYsXV+U/zPkGPePjnJKo1Eq4egNkTM6a1RxE9SVMw0nb77YPSGCEV338/5LNcV6N95s6R1yvGpkFj9wsPntbQ6pTvzyCg81dsTztjEY5QlwIGMUKPc+CnIxBLJfiG/dK93PAqNkCrE9X46pJ6yljJDesrTaZYWu9o80BoZuBHsMeD0G1GAJlAJpoAzMhdHYOqXeFAa25TUsmG4bWcOUsdvmlRuC23jzYGiwpVCXYLtrIRMnleXbRv4Y0S8MrnxfuP5ZWflwr6ABNSNaoGDLczKMwKydyzW8FXMTnNlKYK1GrbD2vpSLKoScj3RVKtfARo1yvO/5UH5eD4RYNoscztRgaRkprcE9kkZuCcsAd0BV1XKp4uIPculyusGqK2M4vQD3n4BTpCLCT7GesS4fpGq7ahHgQIuq/hfCR86k1jzVKE2RzALcyV9o4zWlJVQTsSLfonMUW6YMb9Dn+VBAaSdnA8rvKcsuGCrA5EBqULqnEa8Js9y9Ha+oPmNh8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(366004)(346002)(376002)(396003)(136003)(6666004)(8936002)(38100700002)(2616005)(6506007)(4326008)(66946007)(66556008)(15650500001)(8676002)(36756003)(186003)(316002)(1076003)(44832011)(6486002)(508600001)(66476007)(5660300002)(107886003)(54906003)(52116002)(86362001)(83380400001)(6916009)(6512007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SCy0dqFkSRyo6+zdLhcoIOcJi3NRKnRKAyyJfjO3Pq+vuYMB8QEptAaydhmn?=
 =?us-ascii?Q?KHS4zYZESwW2ZQBB8ba6bJedSF4x/7Ii5DkvViK+OEAEJA9FXI1lEH7FqLRT?=
 =?us-ascii?Q?F42XRETzKYIJZ01ZAfRCoPgBLgX1TVf3UbkzbITtJw/z7LgiMKxKx4syia3R?=
 =?us-ascii?Q?3s4SRc5GGuC04XG6T3TR9SfLuDlBf2nD7s9A+V2aNMgYwR+Bl53t4L4PGSIi?=
 =?us-ascii?Q?T2WarCntgrUdqfQZpTdh0jq1oqbbvBx5prYTe1NKXMtCbL6YXk9VAbC3IeUw?=
 =?us-ascii?Q?6VqeH8UR1Ql8LeFS5dPkK56o+ZFDYSDDTnB5RTi6yiz5qYGwWkCeM2g2v1st?=
 =?us-ascii?Q?6+kh1xL/jHtT1hdnbTKJX/+S74Jg7So375O50UneHKA4BhxL3UZB5IzMeyjM?=
 =?us-ascii?Q?m0sURD7dS9QR7HgRnWudiJhDLIfZAfKYDs5CuCCSr9zC+j/f8NVA9L3amIq/?=
 =?us-ascii?Q?vkiCDybktFRyMhLV3lWIaFaS2QelaBhFs/Fu/GCeT6kmaarruK9ACediXPzJ?=
 =?us-ascii?Q?wDBSbMWUNvFsjfIPqVA8KK0KUoARn+XReGHrnmJUunt04WZzWzLOzfbZMvGt?=
 =?us-ascii?Q?2IEZILTRkTK9IQBB9xQralPlC2BOOCOWHczOBHY39gaCBAak1rbJVDL5V0GT?=
 =?us-ascii?Q?6iTvIWNiTa5AcRRn/nBezbfut/knpyP5Aq/snZ2Nt8dkMDn4IjibkX6G2CIX?=
 =?us-ascii?Q?HygmFY+dzVa70BPxPeX+bH1siLGTELAzq+Q9ArfVA0Y1AGiIOeNyx6a1CCpB?=
 =?us-ascii?Q?N3Z6638Xj/JdrW07qjsfAKYS/07luqsjuH1E4F/mMAjqppPj3aL/zkhlBbJl?=
 =?us-ascii?Q?qDfaJc0LTjqRNYnxGkYwNB3+Zz0iLTvpUrTLWlbyRbbjfw9XW6KrMyPBLH/R?=
 =?us-ascii?Q?FwxNPgYs26qc/3pS5t4pz+hhcHLrM/5+7xgk85E2JHblLnfzIEa+pJ8xWflt?=
 =?us-ascii?Q?YRwfguCrstfY8tStIBJVf6Z4FIM26cth1wIiW72vzL6TlnZM2UspabeKSVKc?=
 =?us-ascii?Q?4+JffmSFgaWqd+8OWVWRquvsODZSNJmoXrYDTOnXNViTESIR7khH686zTmxl?=
 =?us-ascii?Q?ANCVRsRXEUQYD3DTi8sSGMReAHh3Hs4T0sGHc8a+RV2Mxp4dnIgFIRhJGl3q?=
 =?us-ascii?Q?uYoRF4VOhHERhf0bKha1rwf2Ufbwz5ykuTU6Cf8UUuVJiRXPMnCMmGNCQILY?=
 =?us-ascii?Q?T6O8wQCUuNjTE/qV5qKU0wXZ6/VHokCFjkSNSgnUC+5GEiDK6zKkYnePgu/g?=
 =?us-ascii?Q?q13x3cDdA6wPwO9zs4Hf5jbbypGGwd6t39ZwMOd7VnxpWvxdOVbs+XzNIbAQ?=
 =?us-ascii?Q?bk7uGZso21Z/Lm359SMpOW0I9q4SLZCjxIoFqPYOQcDU81a2p82z8zWoWOfq?=
 =?us-ascii?Q?RNOnNUte7PuUUIkokGdaw1mKATXxznDWPoXxttNL+Mu5rY2hxUGiJTiFF4iG?=
 =?us-ascii?Q?QvDT21be91ZyGfI4omTbFgaA3MzlyNCL8BOXkW+U4OQuNLdfJqBV6nOfgKAC?=
 =?us-ascii?Q?VyBk+WK5N3nAp8u1PrJmsFroXEe3dzxin2+o7XMfpM9iLE3bwN+eP0OcjOwp?=
 =?us-ascii?Q?YxVyL1w8FnDCE9uOWfIq77x0P6Wi08hxstr/YbcHZ7jiyU6v+WOQ7W8VzWyF?=
 =?us-ascii?Q?Shv+n9G4MYbLyelSkUywD5h9grOyJPTgl/ipCbn7qhe+mf4ty7ZdsASEreln?=
 =?us-ascii?Q?mRepKhrB0PqQ1XiOP6rxX6RGNf2vHu6A1TyvRPFJNLirRBo2csrgWJsBHB70?=
 =?us-ascii?Q?H1dQiIkEyHL9PojkyA19oEXCIoFgiOg=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e986c2c-bbdc-4b04-1e73-08d9b657fd07
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 12:25:27.5647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pRiFCJ8SJxStKMQUYCmzWMj2dkRpHMWLpYraO0YSL1wOSg0GUEYlH0LWzUR0nCYNhcu64DG+3d1UePA+9CRClzdB5p7p9ijcP1yfTVNPmhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5423
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add process to validate flags of filter and actions when adding
a tc filter.

We need to prevent adding filter with flags conflicts with its actions.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/act_api.h    |  2 +-
 include/net/pkt_cls.h    |  3 +++
 net/sched/act_api.c      | 18 +++++++++++++++---
 net/sched/cls_api.c      | 18 ++++++++++++++----
 net/sched/cls_flower.c   |  9 ++++++---
 net/sched/cls_matchall.c |  9 +++++----
 net/sched/cls_u32.c      | 12 +++++++-----
 7 files changed, 51 insertions(+), 20 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 87ad1d3f2063..39daa1bf1af5 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -203,7 +203,7 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est,
 		    struct tc_action *actions[], int init_res[], size_t *attr_size,
-		    u32 flags, struct netlink_ext_ack *extack);
+		    u32 flags, u32 fl_flags, struct netlink_ext_ack *extack);
 struct tc_action_ops *tc_action_load_ops(struct nlattr *nla, bool police,
 					 bool rtnl_held,
 					 struct netlink_ext_ack *extack);
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 1942fe72b3e3..55abc3c1d761 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -326,6 +326,9 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp,
 		      struct nlattr **tb, struct nlattr *rate_tlv,
 		      struct tcf_exts *exts, u32 flags,
 		      struct netlink_ext_ack *extack);
+int tcf_exts_validate_ex(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
+			 struct nlattr *rate_tlv, struct tcf_exts *exts,
+			 u32 flags, u32 fl_flags, struct netlink_ext_ack *extack);
 void tcf_exts_destroy(struct tcf_exts *exts);
 void tcf_exts_change(struct tcf_exts *dst, struct tcf_exts *src);
 int tcf_exts_dump(struct sk_buff *skb, struct tcf_exts *exts);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index ec80b5411a62..2b85d07dde05 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1383,7 +1383,8 @@ static bool tc_act_bind(u32 flags)
 
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est, struct tc_action *actions[],
-		    int init_res[], size_t *attr_size, u32 flags,
+		    int init_res[], size_t *attr_size,
+		    u32 flags, u32 fl_flags,
 		    struct netlink_ext_ack *extack)
 {
 	struct tc_action_ops *ops[TCA_ACT_MAX_PRIO] = {};
@@ -1421,7 +1422,18 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		sz += tcf_action_fill_size(act);
 		/* Start from index 0 */
 		actions[i - 1] = act;
-		if (!tc_act_bind(flags)) {
+		if (tc_act_bind(flags)) {
+			bool skip_sw = tc_skip_sw(fl_flags);
+			bool skip_hw = tc_skip_hw(fl_flags);
+
+			if (tc_act_bind(act->tcfa_flags))
+				continue;
+			if (skip_sw != tc_act_skip_sw(act->tcfa_flags) ||
+			    skip_hw != tc_act_skip_hw(act->tcfa_flags)) {
+				err = -EINVAL;
+				goto err;
+			}
+		} else {
 			err = tcf_action_offload_add(act, extack);
 			if (tc_act_skip_sw(act->tcfa_flags) && err)
 				goto err;
@@ -1924,7 +1936,7 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
 
 	for (loop = 0; loop < 10; loop++) {
 		ret = tcf_action_init(net, NULL, nla, NULL, actions, init_res,
-				      &attr_size, flags, extack);
+				      &attr_size, flags, 0, extack);
 		if (ret != -EAGAIN)
 			break;
 	}
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2a1cc7fe2dd9..0894a1c90943 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3025,9 +3025,9 @@ void tcf_exts_destroy(struct tcf_exts *exts)
 }
 EXPORT_SYMBOL(tcf_exts_destroy);
 
-int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
-		      struct nlattr *rate_tlv, struct tcf_exts *exts,
-		      u32 flags, struct netlink_ext_ack *extack)
+int tcf_exts_validate_ex(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
+			 struct nlattr *rate_tlv, struct tcf_exts *exts,
+			 u32 flags, u32 fl_flags, struct netlink_ext_ack *extack)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	{
@@ -3061,7 +3061,8 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 			flags |= TCA_ACT_FLAGS_BIND;
 			err = tcf_action_init(net, tp, tb[exts->action],
 					      rate_tlv, exts->actions, init_res,
-					      &attr_size, flags, extack);
+					      &attr_size, flags, fl_flags,
+					      extack);
 			if (err < 0)
 				return err;
 			exts->nr_actions = err;
@@ -3077,6 +3078,15 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 
 	return 0;
 }
+EXPORT_SYMBOL(tcf_exts_validate_ex);
+
+int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
+		      struct nlattr *rate_tlv, struct tcf_exts *exts,
+		      u32 flags, struct netlink_ext_ack *extack)
+{
+	return tcf_exts_validate_ex(net, tp, tb, rate_tlv, exts,
+				    flags, 0, extack);
+}
 EXPORT_SYMBOL(tcf_exts_validate);
 
 void tcf_exts_change(struct tcf_exts *dst, struct tcf_exts *src)
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index aab13ba11767..c3a104832a17 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1917,12 +1917,14 @@ static int fl_set_parms(struct net *net, struct tcf_proto *tp,
 			struct cls_fl_filter *f, struct fl_flow_mask *mask,
 			unsigned long base, struct nlattr **tb,
 			struct nlattr *est,
-			struct fl_flow_tmplt *tmplt, u32 flags,
+			struct fl_flow_tmplt *tmplt,
+			u32 flags, u32 fl_flags,
 			struct netlink_ext_ack *extack)
 {
 	int err;
 
-	err = tcf_exts_validate(net, tp, tb, est, &f->exts, flags, extack);
+	err = tcf_exts_validate_ex(net, tp, tb, est, &f->exts, flags,
+				   fl_flags, extack);
 	if (err < 0)
 		return err;
 
@@ -2036,7 +2038,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	}
 
 	err = fl_set_parms(net, tp, fnew, mask, base, tb, tca[TCA_RATE],
-			   tp->chain->tmplt_priv, flags, extack);
+			   tp->chain->tmplt_priv, flags, fnew->flags,
+			   extack);
 	if (err)
 		goto errout;
 
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 24f0046ce0b3..a0c2a81d5762 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -163,12 +163,13 @@ static const struct nla_policy mall_policy[TCA_MATCHALL_MAX + 1] = {
 static int mall_set_parms(struct net *net, struct tcf_proto *tp,
 			  struct cls_mall_head *head,
 			  unsigned long base, struct nlattr **tb,
-			  struct nlattr *est, u32 flags,
+			  struct nlattr *est, u32 flags, u32 fl_flags,
 			  struct netlink_ext_ack *extack)
 {
 	int err;
 
-	err = tcf_exts_validate(net, tp, tb, est, &head->exts, flags, extack);
+	err = tcf_exts_validate_ex(net, tp, tb, est, &head->exts, flags,
+				   fl_flags, extack);
 	if (err < 0)
 		return err;
 
@@ -226,8 +227,8 @@ static int mall_change(struct net *net, struct sk_buff *in_skb,
 		goto err_alloc_percpu;
 	}
 
-	err = mall_set_parms(net, tp, new, base, tb, tca[TCA_RATE], flags,
-			     extack);
+	err = mall_set_parms(net, tp, new, base, tb, tca[TCA_RATE],
+			     flags, new->flags, extack);
 	if (err)
 		goto err_set_parms;
 
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 4272814487f0..cf5649292ee0 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -709,12 +709,13 @@ static const struct nla_policy u32_policy[TCA_U32_MAX + 1] = {
 static int u32_set_parms(struct net *net, struct tcf_proto *tp,
 			 unsigned long base,
 			 struct tc_u_knode *n, struct nlattr **tb,
-			 struct nlattr *est, u32 flags,
+			 struct nlattr *est, u32 flags, u32 fl_flags,
 			 struct netlink_ext_ack *extack)
 {
 	int err;
 
-	err = tcf_exts_validate(net, tp, tb, est, &n->exts, flags, extack);
+	err = tcf_exts_validate_ex(net, tp, tb, est, &n->exts, flags,
+				   fl_flags, extack);
 	if (err < 0)
 		return err;
 
@@ -895,7 +896,8 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 			return -ENOMEM;
 
 		err = u32_set_parms(net, tp, base, new, tb,
-				    tca[TCA_RATE], flags, extack);
+				    tca[TCA_RATE], flags, new->flags,
+				    extack);
 
 		if (err) {
 			u32_destroy_key(new, false);
@@ -1060,8 +1062,8 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 	}
 #endif
 
-	err = u32_set_parms(net, tp, base, n, tb, tca[TCA_RATE], flags,
-			    extack);
+	err = u32_set_parms(net, tp, base, n, tb, tca[TCA_RATE],
+			    flags, n->flags, extack);
 	if (err == 0) {
 		struct tc_u_knode __rcu **ins;
 		struct tc_u_knode *pins;
-- 
2.20.1

