Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511BB455C56
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhKRNL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:11:58 -0500
Received: from mail-dm6nam10on2122.outbound.protection.outlook.com ([40.107.93.122]:47280
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230161AbhKRNLq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 08:11:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dEbD3f0nPwTFOJqpz/OM0lMQqNvRqaC1foNU3l50jXb1Q7HSXge4ixFNr7D300cNj8Ok/8zuCaoNxtZKzHR+PvT+/PsRJJULcVBaikH7ax4AmEZoGzlzJKe2W1PW0Z9DmjgP0fEub0dhsxv7HzexVjphZ4PRhC7b1XsFaQjBmM1F1grav/jmqNrg3G0iNdNdUbE98WY/Si7N1RLciMDfpeRC6c954PGYBO9EfXwLBTIeCbLE92A1yjaVyoagI4vrz5+khpZVOpTMfmkLo+GlwfPBjBWBEqaV+fRPabalLJ8z/lHoH2zlWoWhaCh6wfRF9kMeAx1Y6OI+fB3jKxU9lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qn3uz3CLQ/Y0YrGv1CQoN2WLN/wuclM7MSKo2y1IVcw=;
 b=f0Y1+Pk/HD/fMsFuTrvpC5MAZupSYSJdgTYbzmgayp9A2yEIDbpzvXMkE6fVr3gdaTyE4Ja/kubwdWqLI3AxSUAGvnq/AR8dSs19NlYebjqLmA3v4TzQgehIRwr5wRlx3tJ589n2OyKnvOqWkJWxUrShLW9dM+fFbktQMchmOSOSl3reDrIkTWqw8wNaJhbizt8aVG6BbVLaqgqWyF6GB3pVzwH0lTRpouqmqSI8KxVVd7zSy1BenlehsznvmwWZ6/IBCr3FdO1/keLaRaykGFhThRQz3b3qjEd3GlznS63j1vjFqZ/T6G7c7RHXdt3NbQNT5VquywGdXszVFdVUjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qn3uz3CLQ/Y0YrGv1CQoN2WLN/wuclM7MSKo2y1IVcw=;
 b=NxFSa5PxDx9YHxpq2gBBNXDiWqtWQg3k3cJGE6XDAJF0WhfQ2fvNeTQvB3T/2BOMvkCM6HGSX08+XFxF9jurWiaYxn/FxRz972p9hzNDmwlJT7nw+wSnZCwm8F6pINdO7u+IETAF1IR3tNP5BWsqYs0FpEfkvC+xPp/rkJEimXM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5780.namprd13.prod.outlook.com (2603:10b6:510:11b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.7; Thu, 18 Nov
 2021 13:08:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7%7]) with mapi id 15.20.4713.016; Thu, 18 Nov 2021
 13:08:38 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
Subject: [PATCH v4 09/10] flow_offload: validate flags of filter and actions
Date:   Thu, 18 Nov 2021 14:08:04 +0100
Message-Id: <20211118130805.23897-10-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211118130805.23897-1-simon.horman@corigine.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0021.eurprd02.prod.outlook.com
 (2603:10a6:200:89::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9) by AM4PR0202CA0021.eurprd02.prod.outlook.com (2603:10a6:200:89::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 13:08:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd81860c-f3d8-4719-763c-08d9aa94892c
X-MS-TrafficTypeDiagnostic: PH0PR13MB5780:
X-Microsoft-Antispam-PRVS: <PH0PR13MB5780C78571324D379B9ADBC8E89B9@PH0PR13MB5780.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:16;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PwyJEgrR8Zhco5/gcjbCFUUmTjJCuA4rBMf7NjjCd7JQY/A2cf3kPu36Yxd4Z7cPhZMZfAO7p538wcq/Rpgo5k8hOlTjPJ1871Kf7U8GNPwtCUPTXarn8bK1pmp5wle4XIbE6luZn77d7MslVK5FzansDOsXz6AG8UC2Lp7bACYmdiM8qe1qlsJBeCW10ZizjVQ64997kfKJYh0AM+OBHUq61Wq47pfx9rgofePhIhTIpPW2gsTBFrl5B+3JPD+RKDE+WKlZfgOIQmZEMZJi7XFtaV68UKvJHlT3O8WF0FffPy0tHThqLjYBhy+6mLcn88Gl4R/+Dz0yPIBxVU+dBOiRgOb6bc321aHPLVg+OSqYPWDgRm2KEePpuCTnFmTO9VaIYFyTnMBgM1u4k5FiqVI+JUAjqUlLiY3mj+59Muq5pXz620L7tHBLOaWOgUUIBKKuAH1YtU3GwcErPyoUxWJvOr9byFfx6ZToDKaTKG8skMs4twmHPCpUkcQHjZpSIG8jzmG+QdAN2wVO2susn/jch55xNiFgABLndaiy+w0/r4Jr+QfIvuHoTlMdX9UCxgm41wBLwiuyGbkuNte/ePV2fwnu7W/sh8oFaiAE0DrdGaHrhsnPTZs+UqBXTZ8zlkoiwxvPIG0NLjQiMQp1Bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(346002)(396003)(366004)(376002)(136003)(316002)(66476007)(6916009)(54906003)(66946007)(52116002)(6506007)(8676002)(6486002)(66556008)(186003)(86362001)(4326008)(15650500001)(6666004)(44832011)(6512007)(83380400001)(107886003)(38100700002)(8936002)(2616005)(508600001)(5660300002)(36756003)(1076003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ykAiRxCoz3ncwbyYoTpKfXQlJ+nyTaWfocUZNfxMSQ0zFJI0CINW2Jqpet5X?=
 =?us-ascii?Q?J+Bz9DR3cBQL/SCh19Xm5W1J++9kpIusFHG+KmXp9ChJt7+91G9niOycV4QB?=
 =?us-ascii?Q?3mIAZN3YtSIfcsPnzYDNTh5kciFa7TORgn/TVaI17ceVFfRKtIfbyn2sA2s6?=
 =?us-ascii?Q?K2Lnu00C6NzD/UjWvFAeN77r0lsmnImuSd55tJpBE2xxY0xo/JSUTdzIyTEp?=
 =?us-ascii?Q?b5ZtjHKhms4wy+q3A/Am+SHck4szL9AoQmdGtL+rF3wB1NJd+tDpKL9Yi2sb?=
 =?us-ascii?Q?AC58rVlqckR/InaIuRzfMi6EzwOvWKcl5n8+JmGqYbsFOtlBHGGA0oK4OjXQ?=
 =?us-ascii?Q?FdJ8YBvCX96pbd6kVIOKke2blP1dBAk81ASuWEGVRxClEvAvD+XvfWmLL57w?=
 =?us-ascii?Q?geWvNMNXBpFUjMJlwPiH2GId/Do8dmGjHx1TEXJxmcVgE4sgMIkd3bztVQW5?=
 =?us-ascii?Q?EkxzexvTsUPZ2LccmmVcvuOuvMtelSP7OxeuHtuMkaJaL8mawt2BEJSVPOXw?=
 =?us-ascii?Q?cbjXEeWoP+cjdq/E9OGgNFP8BO47m91zn6TvS2p8NDQUewRQn3+iPGvWRscI?=
 =?us-ascii?Q?u+fDicvhicTqDlFdnj1LVa1m58NPSdO8dhc+PV6/Y57PiHfZvInnelCu1bbL?=
 =?us-ascii?Q?tsL7oxyttVsgRz6czab066JnZQ4gtIASH3a5Jd5pas20aKXVn25vFUIJXRO2?=
 =?us-ascii?Q?BU072UVeLmespIEBuffXKtbOeZEN1P3d6eWv4/Dpb6L2DODMtGw1KC8+xwyv?=
 =?us-ascii?Q?tdRQ5wEj+Uz/Gm56yeRADU0vLqZRYlUHYPZjTLI4rnoZvEVDBN2AZYvQYHca?=
 =?us-ascii?Q?DuCKsIwEMlXto7UQ+EJKR5Uh4WT/3TLqn4PgeyIGAW2+7lbM0MxNLQwhk1HB?=
 =?us-ascii?Q?oVor6rqjx60rYxrj9tDHC4fUEFD3UlU02mZrWrme1HOyVJzHrmqXoXQsp501?=
 =?us-ascii?Q?MecjiwisOuyvuJb0Mdu14ctKc2kh1zJ4wDDM3F1jCIxqjJLD4cwRbTtNYQoh?=
 =?us-ascii?Q?6RI0Pmrz7XsKBMRib0c3Ja5aHiVWV76AkE5AnMEURkrOT5NIN3TklVDRUHrP?=
 =?us-ascii?Q?/I8MA/MtTHxbRkia57uc43PbGHTT2kbUqY0xsOYSOp+H5UTnxfzT0VweH3/j?=
 =?us-ascii?Q?BSQ3ov+fsv4bY96wswEUI82VRGgtFlRwBl6KwkQ2SamROumsDZHTl/YTX3fs?=
 =?us-ascii?Q?EoSiT6mWrDn0AhbDiKsGbHMtS5L1TpuLP3v4DhmsOywh5QXw3HqYLIBeHihu?=
 =?us-ascii?Q?6eo22/1fF1rC8lLtDHdXU6TbZ7JCybpZ4DGPUnmiWT/JuGudohzPTmB0h99C?=
 =?us-ascii?Q?ooyXs5xDtISgDGozBPOeghvDlTcTBlKTr6qeP9yXbjJz9ma74clO3D8IDQSm?=
 =?us-ascii?Q?hV1d8YBiH5JxR5QRwFWkgBK7Occ3Bx8ZSCUobQuNDvWWTVjzqj0Y+nEi6+LD?=
 =?us-ascii?Q?eY0oYyR39bVPLFXdUfkCQ7V+yiXFkFJkbP1hVlQrkF0tvQBWE0Yt5iSWz/ca?=
 =?us-ascii?Q?Bxu8LAu1gArmvVU52m4f5zvNkhkQAvlINObDi0csRbHRs5U4K0oVj34yQsry?=
 =?us-ascii?Q?mjbdpxD5TAshP72WB+r4/ZrOm28NKauVz9nldskOt+NlrCLXIwRfV8i0HKRx?=
 =?us-ascii?Q?F0OcgPL6GUc0i68J6SBWVq/oMWghVWsj8Mxg0m5rbnDH9dDX2ENu/u8ZTMx4?=
 =?us-ascii?Q?G2fg4Ye/biTRVK4NWuUCqisol4cSaLTSEFZewzti1eVLo23TlHTkjlOMdb93?=
 =?us-ascii?Q?0BA5rwksfhmUdy8sTsMCPDviekIWEZE=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd81860c-f3d8-4719-763c-08d9aa94892c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 13:08:38.4144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jbaiE6/EH3MSm283DvQ4vKOtEzUpLRsxOF0x2wcinM06luPlfAZvj3TdvVwawMWEuAyT1HoJkapzjrrDnVXsDvhak/qVWSpQAi8TXlfHVv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5780
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
index e5e6e58df618..10cac4486a1c 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -191,7 +191,7 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est,
 		    struct tc_action *actions[], int init_res[], size_t *attr_size,
-		    u32 flags, struct netlink_ext_ack *extack);
+		    u32 flags, u32 fl_flags, struct netlink_ext_ack *extack);
 struct tc_action_ops *tc_action_load_ops(struct nlattr *nla, bool police,
 					 bool rtnl_held,
 					 struct netlink_ext_ack *extack);
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index c8e1aac82752..94439d0521e3 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -354,6 +354,9 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp,
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
index ada51b2df851..23ef884c1681 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1474,7 +1474,8 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est, struct tc_action *actions[],
-		    int init_res[], size_t *attr_size, u32 flags,
+		    int init_res[], size_t *attr_size,
+		    u32 flags, u32 fl_flags,
 		    struct netlink_ext_ack *extack)
 {
 	struct tc_action_ops *ops[TCA_ACT_MAX_PRIO] = {};
@@ -1512,7 +1513,18 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
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
@@ -1925,7 +1937,7 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
 
 	for (loop = 0; loop < 10; loop++) {
 		ret = tcf_action_init(net, NULL, nla, NULL, actions, init_res,
-				      &attr_size, flags, extack);
+				      &attr_size, flags, 0, extack);
 		if (ret != -EAGAIN)
 			break;
 	}
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 55fa48999d43..e0426202215e 100644
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

