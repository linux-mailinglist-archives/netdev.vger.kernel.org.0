Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2073141EC02
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353950AbhJALfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:35:15 -0400
Received: from mail-bn7nam10on2122.outbound.protection.outlook.com ([40.107.92.122]:44000
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353957AbhJALfD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 07:35:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzRp77aGbnoFubhc6c8KXWeIFI8nwL+9VIUQ4kuN09O61kFgPQQhLaDf32VqtSqe81wKQO/qQ19kZEiFTeTZ+NhgVzJgMSf90bzfiEzSHL2o0KrLZz6kR1f2hIeFROQlJPurVSulhu7euaf/Ps9ZPioOwUsFOe2ht4xV9U7CoEM/2FqFS9Ug5qzydll61NTHBwsvD4w3VzQlzbf/VRO+ICq7zfasZAkIdxVHI+ZdV3IbGDtDxYEYMXcUD+cEglPaqGm5aH4qIyW0DYTFw8p/33Wu7gDvCluNgACD4vzUir4docSgB0XrU7TXxFH73JLiZboaIlpqDtOSBb7IBxA4EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cXSyUiBXXj7j/IKwckBW+AJUq9cE0595u95xgbEf5n0=;
 b=IYNaN4SYWCsgUZ8GvvT44o1eXITCjJ2CfnHjDTT4Ljsn/roFnFJphNC6nAFlzNjz8jf/uEZIBeqpzPbr029f5bKyvXpHmRAkxJ47T/cksmbB+paUvrqw1HUpuEg0br5GGdSvzvkckBo7Agspa959Ycv9wxJ6u1O9IAakC4iqi6zIbr6DqILg5okQrfDKJHPGzUeHD94mVqTjrmK/ASXGrC2V0UgEsuvM/DE0qYci0ZSJD5OeZAEoFHsoyXX7JbjXTdu9czXuNvXoP7zxqXRDZS6Fc7aNL/gmlgLS9WqCcSTpDsgYcbV7Lq8+TChTGjIOq1RPEq0FlEXwl/T7S1orMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cXSyUiBXXj7j/IKwckBW+AJUq9cE0595u95xgbEf5n0=;
 b=LXZqIt8Qb7CCoCPsLnlp8QNygEOomtQDTMkPeErH+ktLyM+W+JlVdxsfD/axotBJSCqmrkbC8IBFC7nCc/BP7Ywz/fmh9xzX5CYKeGILQvVE+dPOHK5Hs4aGqEHM6SAhTvFMJpzFGUl6L5nS65amY8kV3fverCMy7ngUGkbuE6Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by BY5PR13MB3362.namprd13.prod.outlook.com (2603:10b6:a03:196::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9; Fri, 1 Oct
 2021 11:33:16 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::4e4:4194:c369:de5e]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::4e4:4194:c369:de5e%8]) with mapi id 15.20.4587.007; Fri, 1 Oct 2021
 11:33:16 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [RFC/PATCH net-next v2 5/5] flow_offload: validate flags of filter and actions
Date:   Fri,  1 Oct 2021 13:32:37 +0200
Message-Id: <20211001113237.14449-6-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211001113237.14449-1-simon.horman@corigine.com>
References: <20211001113237.14449-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P191CA0023.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::28) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM8P191CA0023.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 11:33:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2244adb-3418-46cf-3854-08d984cf4297
X-MS-TrafficTypeDiagnostic: BY5PR13MB3362:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR13MB33621F14D579F849BCEB3C39E8AB9@BY5PR13MB3362.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:67;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zJ7LMQDvYK699ndXWAw0fwbQmxK3kZZt+I2LmPQGpbS6Ymz3RB+yDFzW26vqK4JVHuIalWo6gq1XrgmG+CtvXlghfhodPihLNB0cK8kDbL9jYnZ551xMC+qxf8jiPeo7VCyE9CFzL1/lZ0bXrW3sRrK4CjBoUobGPInR7zzgW8v8olR/NeZI2X0aZA6UWXkoBLKucLUKnoenEz9Vaq8BwTpja0aVrS7UhWbEPjwQpJucVL98PoGlIeNnIP06VBIO+QXpYNaWBAa6jr0baQoFutekKZlTxp/sZgoQfD2dFku3SLtvTygVTuIMoNeb/6YBCIpjVMPXJCNgTJxqIyQXUfTBiUpWcyjV19VCb23VCwo7WzpfL0ehbGnPF+Lz2c9wxXsuCu5iHkHPsxrbaeJ3cou9mylUAP4I2Aw/yzjIQYka/0iPTmvZw9UWs5fQRKJWVFGOtg1RUnR5N5f08fUY8qHwlOT+UW6gF3KHTrEy2bese0vU+VOdsMq47KZTtFCZSJWiUV7zsYDpBwE5fUfm3qAkGkMGNjOlkONe+JaqJEwVOlFSoSxVRhnZ7K2Pd9PEfWqmUt0mmO+0yYcKLpgqYeNX5V4DW8tssdRFwgNfSwPvSvaV0g+E9NZdNIrzGtpergrGCyMlElDtKXWqANhDGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39830400003)(136003)(346002)(366004)(396003)(6486002)(66556008)(66946007)(186003)(6666004)(5660300002)(6512007)(86362001)(66476007)(2616005)(1076003)(6506007)(8936002)(15650500001)(38100700002)(2906002)(6916009)(83380400001)(44832011)(508600001)(52116002)(8676002)(107886003)(316002)(36756003)(4326008)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FrBLOu/jZQzGipPVPTGr991VdUp8Ge1Y9ICXQX1CiB2p/YBsjIcP/9aGGr/S?=
 =?us-ascii?Q?fbxxIN5OUBP19jU6HIgRoPWcXfqBLEPnukSkinOOHWhrUYdJik/dGLmJH7qr?=
 =?us-ascii?Q?Mm2aDFcUQoFBLPLdzV7Hz6HOYZh1l1kXHSYgxPm1ENpCYbIWXYvTdOg5ckiT?=
 =?us-ascii?Q?lCFKbO3dQCmw+08Lgt5wqX4bdkq8LPeXQ8w7KcKzG1yRpojmoqstozsSQIqo?=
 =?us-ascii?Q?GSjflz8K34gY2T04KdETr5oWtD5Y9lhBNWf+lnaVqMb+g5/Fbo2p4CBvGrsw?=
 =?us-ascii?Q?jI/nFP8F2/PN87G3bMnlOT25D+Sf3F6R698qie0H4v7p8teh9Lrtmt1Y14Wa?=
 =?us-ascii?Q?kt6caq6q7td8N4MOpvxlIEknrh6YEtuLSa/5uHGkMU2MDduNognnteTIZRML?=
 =?us-ascii?Q?BO92RA5wdgscSKbm3T9MORofN7y2ArJYay2T3ZYj3QNzI3XHgDfn2s1BwvUT?=
 =?us-ascii?Q?61iCwQoKdNvTxFTNutqmhroGw9SUs8gE/tbphOZ2u0pPze5diyGYSBWquT73?=
 =?us-ascii?Q?Xr14eiZUk872C5xSkiG0ErGdi1dLPuEBeIFjwLGtVDaN72k20Au78k9NSyPN?=
 =?us-ascii?Q?+E4kS5UsEV5/LQcmqtrQXD4WzzgDfOkwLAdFEsy6nTwJavkWr9kF7UrrJrzG?=
 =?us-ascii?Q?33HQkQcQyr5jx4MrLLJr+FT0bAbS6pHnFB89YcdOyMOrIQLXazM6tfKylfKK?=
 =?us-ascii?Q?CyrXis4pO0QPdpZ08Jw7h7p5SLxsMf+gQvghgwLwKCKAFDZE8s19L5RFwO90?=
 =?us-ascii?Q?60d4sX0V8kYTOAo9EeLPEEw7kL9OyH1aidU2An9sMXDAKS5h5zwgVGosPZa4?=
 =?us-ascii?Q?EEr/S+TDET1ZdL5g2TAJxn1io627RdH1MLf3JR6y959hU3Ak/zRJhH9E8Or+?=
 =?us-ascii?Q?Adaj7p1kwOu+tJjKyGAv+kVRRA3w1mtxafiTlqQr9djXY6Pj/+2UBryD/skY?=
 =?us-ascii?Q?YMUnAL597bJAUwCb3R7TmwWx/fdQqlzyd/qM3vYAQ5E68xkQiVUJwz+1mOUn?=
 =?us-ascii?Q?Beau0RD72ZRxWAZR2G/FwX1SYGzHIjPCcR2l2N1OTN23wnGRfXnQhQxSE8Tt?=
 =?us-ascii?Q?BFSIOoON3Du4O8ejxGmJMJUranL/a1QSxS0niuRWFZAvUKGGZgD8rGdSVgx9?=
 =?us-ascii?Q?G6l30I9RJluGpFMdnY75cK7Tt1IXrv7vF1e9L4piuneJau8u/6Y0tHz5kdFG?=
 =?us-ascii?Q?72wVHGrIqDWFnuk9u4c50ZlakyIFyMpQEQgmXLZeUseg8Vbqc3Ynu5Pvl77U?=
 =?us-ascii?Q?7C01PRWcjUX3fy2oJWF/z0IU4RYo4VKjO0V6wZcy7KO8JSR1Xn1VyC0Uh8H0?=
 =?us-ascii?Q?2Am2iEbZoCGFdIUTDo2SxSrH9XKTqkbBGocF4P/goB3h3v304jN6KaE9s8/b?=
 =?us-ascii?Q?jWE6oo8f1h+Fj7tUpjcLBzpHpiv8?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2244adb-3418-46cf-3854-08d984cf4297
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 11:33:16.2995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LANwzjAtcwTak4+a05fo1jUsJ6o+CUpvR/Uqcho0bzIsYJUf3ia5vnpVwgBqd0kD1aQ3R4kfWaPQk4WbM9+zQgcgFRwuMY+SDB0lvDO8mRM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3362
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
 include/net/pkt_cls.h    | 32 ++++++++++++++++++++++++++++++++
 net/sched/cls_flower.c   |  5 +++++
 net/sched/cls_matchall.c |  6 ++++++
 net/sched/cls_u32.c      | 11 +++++++++++
 4 files changed, 54 insertions(+)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 5c394f04feb5..2d51bed434d2 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -735,6 +735,38 @@ static inline bool tc_in_hw(u32 flags)
 	return (flags & TCA_CLS_FLAGS_IN_HW) ? true : false;
 }
 
+/**
+ * tcf_exts_validate_actions - check if exts actions flags are compatible with
+ * tc filter flags
+ * @exts: tc filter extensions handle
+ * @flags: tc filter flags
+ *
+ * Returns true if exts actions flags are compatible with tc filter flags
+ */
+static inline bool
+tcf_exts_validate_actions(const struct tcf_exts *exts, u32 flags)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	bool skip_sw = tc_skip_sw(flags);
+	bool skip_hw = tc_skip_hw(flags);
+	int i;
+
+	if (!(skip_sw | skip_hw))
+		return true;
+
+	for (i = 0; i < exts->nr_actions; i++) {
+		struct tc_action *a = exts->actions[i];
+
+		if ((skip_sw && tc_act_skip_hw(a->tcfa_flags)) ||
+		    (skip_hw && tc_act_skip_sw(a->tcfa_flags)))
+			return false;
+	}
+	return true;
+#else
+	return true;
+#endif
+}
+
 static inline void
 tc_cls_common_offload_init(struct flow_cls_common_offload *cls_common,
 			   const struct tcf_proto *tp, u32 flags,
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index eb6345a027e1..15e439349124 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2039,6 +2039,11 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	if (err)
 		goto errout;
 
+	if (!tcf_exts_validate_actions(&fnew->exts, fnew->flags)) {
+		err = -EINVAL;
+		goto errout;
+	}
+
 	err = fl_check_assign_mask(head, fnew, fold, mask);
 	if (err)
 		goto errout;
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 24f0046ce0b3..89dbbb9f31e8 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -231,6 +231,11 @@ static int mall_change(struct net *net, struct sk_buff *in_skb,
 	if (err)
 		goto err_set_parms;
 
+	if (!tcf_exts_validate_actions(&new->exts, new->flags)) {
+		err = -EINVAL;
+		goto err_validate;
+	}
+
 	if (!tc_skip_hw(new->flags)) {
 		err = mall_replace_hw_filter(tp, new, (unsigned long)new,
 					     extack);
@@ -246,6 +251,7 @@ static int mall_change(struct net *net, struct sk_buff *in_skb,
 	return 0;
 
 err_replace_hw_filter:
+err_validate:
 err_set_parms:
 	free_percpu(new->pf);
 err_alloc_percpu:
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 4272814487f0..8bc19af18e4a 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -902,6 +902,11 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 			return err;
 		}
 
+		if (!tcf_exts_validate_actions(&new->exts, flags)) {
+			u32_destroy_key(new, false);
+			return -EINVAL;
+		}
+
 		err = u32_replace_hw_knode(tp, new, flags, extack);
 		if (err) {
 			u32_destroy_key(new, false);
@@ -1066,6 +1071,11 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 		struct tc_u_knode __rcu **ins;
 		struct tc_u_knode *pins;
 
+		if (!tcf_exts_validate_actions(&n->exts, n->flags)) {
+			err = -EINVAL;
+			goto err_validate;
+		}
+
 		err = u32_replace_hw_knode(tp, n, flags, extack);
 		if (err)
 			goto errhw;
@@ -1086,6 +1096,7 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 		return 0;
 	}
 
+err_validate:
 errhw:
 #ifdef CONFIG_CLS_U32_MARK
 	free_percpu(n->pcpu_success);
-- 
2.20.1

