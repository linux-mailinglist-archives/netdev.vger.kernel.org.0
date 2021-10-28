Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BECA343DFC3
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 13:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbhJ1LJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 07:09:58 -0400
Received: from mail-bn8nam11on2113.outbound.protection.outlook.com ([40.107.236.113]:43800
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230170AbhJ1LJv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 07:09:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+gOV1l3mcsuRFKzr+I9ohkeMTunVa8t5sZf2h93tjh3TNZ4IOMd/ukjPTV9tdK0Fa0ikqcBrFUyV7Sajy8FcTavLtI7DifQShO0ETy6dC75gVaOaGXtflCRazTroecGkev0a28o9E9e+Iu2AxxqsLOn+ve/7ZmGWo0BEKrGNHNl4O/aqpsQiKOC2Art/KztfT52Hl3volMtwR0f8u56EWdlRtwVTWIeZnIQthhu1waBoMNr6Imd+wEoaVmPAH+6RW5KQEohL0V/PQruS9r6FKA+fHQBbV1HJvuwUX0Tue/BTYOfgnFd7JCX3U+4W2qzcuNtOfrAlWjg3eYq3pcDMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=28R8aZtPnnaNPJMk9V88HMkRGRJERf5FVr2s03fIvCs=;
 b=VbZ66/dhL34Vvyt65nHhRdRvNDuDwGc4eTvQ18NoZiPCcPXsgyJZ+PV1KF3wCY8imrJE7BJ+PwQ5VN0vv+fvo8Ycjc4nf/caHRT9FJZM3uSKfOZtRM+i/jDaFPywvTelUixRGcEmm2I21Bck/MVKROwcwqrYdV7UBA8YElLpk2k5WNOJXfEGcayz2qQ3TyeJw+8dQ9SuMqB8wmA4loYDmKKXf2Lvf2LuhUAeiPiupLW8N6c30TGXc3mkSchwAM9cN5s06bYZBD296lY4C6u2gY02EXY7ZcghfkA+SVCFvaWjiQed4HnxAHpp5WxCnSNoKdACs7ElVKz7gT7DIjf4zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=28R8aZtPnnaNPJMk9V88HMkRGRJERf5FVr2s03fIvCs=;
 b=IdOUEU+4DoBkdTJkL9fPN4/vizXRIHPB7DEDs/UwralLH//QnA3B0EoYrg+xahhP0YMdMTrX2M9vfHmfFgdWctgfgJuGMLoAJYVx/JTQrYp+3v5PBDGJlkuCc/H2vL1tQfYiwck/WIioAWwe2NibRWs7ClbY/EygmoMkgXMZ4jo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4956.namprd13.prod.outlook.com (2603:10b6:510:98::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11; Thu, 28 Oct
 2021 11:07:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4669.005; Thu, 28 Oct 2021
 11:07:22 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of filter and actions
Date:   Thu, 28 Oct 2021 13:06:46 +0200
Message-Id: <20211028110646.13791-9-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211028110646.13791-1-simon.horman@corigine.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0040.eurprd03.prod.outlook.com (2603:10a6:208::17)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR03CA0040.eurprd03.prod.outlook.com (2603:10a6:208::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 28 Oct 2021 11:07:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bbab98d-b4d8-43a9-b7e4-08d99a031db1
X-MS-TrafficTypeDiagnostic: PH0PR13MB4956:
X-Microsoft-Antispam-PRVS: <PH0PR13MB49565B1C514DCFF96273CFF9E8869@PH0PR13MB4956.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:24;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wTfOjfIREAnxAo4Eiy1dOc1wu0z9mBjbclGC1CYATPeFbGgOODabfPRTtI82sF/pYCK9cuqaYVAkOdk6bQfAcvWKOGmoI+u5fOZ31X+C+9pLPyUBjcNRi3K5zo/KQBvg7KP61qtSmBruHzive9vXA6XT0xl6BwRgYqGEUFza03hTjUia4dBGj0ZCRhVj4Ls4LzZ0OzAjJN2+Kl0WbBoWaxGn1EsqLtS5Nw2hHbwrlVkVIROzdTudjjDZRBGQ35oRo7q17qnMnMOPrmF1ifQp4bSXiaurMXka2ugl4FV8Xbstjw+KLmKgUSaD07XvRkYj7m1SktK/Iw7nlJHQirFd3U0uv0ahiTUsK52vcTR9sbdd/S2JElmqDyIPnH3vi+qIT/rU99E8V++M8YK/oKYOL8RgjoSpNEUo5Q6cSBaOX4pXFlgpb4FzINWYapKosH5BkufisOOP72xmpv31qXk9er/+za+61Y8uNoau4ZDwAwDdFuMHsKBia/sqrxkn5j2G3ppVvUZp8XakSosQg1XuWKbzuygYqpsTTmcBmwnyVpoV/Byohkcas4L8sS3fd97yjxSGRO2I8PHa5+L6ineLn5kAsV3HDEvl6PQ9C27dzVcwhTCakneI8XLXGai2SgOKJmRsVLw6PJU6ywE+zqPocA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(39840400004)(396003)(4326008)(83380400001)(316002)(36756003)(54906003)(44832011)(6512007)(8676002)(2616005)(2906002)(5660300002)(8936002)(6666004)(52116002)(186003)(66476007)(107886003)(66556008)(15650500001)(6916009)(508600001)(6486002)(1076003)(66946007)(6506007)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gZSACZto41R6Rp2PqnqI7G8h/HEbvh6vR6Nlbc9N2Wfah8z3O+TrlES/ec4F?=
 =?us-ascii?Q?uRFNbWChBw0RHSv92FCgvzl2RX9oFD4+iMbKJaf4WZkYbnE4V62UjW8qkQYU?=
 =?us-ascii?Q?KM27rJWGU5hUrm3/ef2pF0toVcM1L+xuWYn9H3SunHYXNMzBHKZ7aBU2mgjz?=
 =?us-ascii?Q?qTV1TKlssWiEWwcU/I6GhQDR7hpJ7y1zAYqs83Zmh7wdoTzamezyUeLsUzyM?=
 =?us-ascii?Q?yKLHLhcf1mO1J+5TcAeoAUYOmZ2hVWONTfHU2TpCvEnlvqzvFsi87O7V6SjK?=
 =?us-ascii?Q?0gaTOIhYMQakE6CK6snvnDd/uQHH+42GQ/ihh5HNoVJlvahrs3nJlq3TnH21?=
 =?us-ascii?Q?hasiypssY1015XRo1ug+KXaQkkyaif3WUp8VmL9GrbSseMaOZOexlVL+4QYO?=
 =?us-ascii?Q?7fTq5YR4pnFQPys2hChgBDQx06JkdFO8mF6huZquh/zJkO7ANhWdciY2emJX?=
 =?us-ascii?Q?QgyT+opkfqXBAH745crz1jbK2xhJ7CT7iEOlNiW95JSI7dpAUDGSjHDQnArj?=
 =?us-ascii?Q?ligiPjrxXAqbj7oM8gDFY2IZlDuiTjixZFEaayVFVzbb+qCBmaz68HbDueRs?=
 =?us-ascii?Q?fAPWDESCSS3vzhgZYhN/zRFjy5/u0ceCBHlgG1CNSsJ7eXvUBrpJ+uXJiNs0?=
 =?us-ascii?Q?Ovgatwp2TDal+ynIv2je4B9H8w4vTpw1MrZ8SHbkIrBTpjYQYBWaLzMOxMpK?=
 =?us-ascii?Q?R3sCUonseekEwpIiri/kFwBvTpuQjOWhyBeENkmhQFki4ygmwEkMvy6C6Wu6?=
 =?us-ascii?Q?tmXL+k20qOxGgPJbt1NthBnH11OT4Ia9jTzmUF/lfAMNLbaf/jubELaKYjEn?=
 =?us-ascii?Q?neIaL2FjjSeHxzx2NxMLCg77PcooI3CmzMeCwvfXou3qw8+6Z3peVJ/ysD5U?=
 =?us-ascii?Q?YRdodpH41b9FLSWJT41H6S12Z6DjVti7zEqqnJ2Exx1Onpot6RXcNBV6v7wZ?=
 =?us-ascii?Q?KqkTuJEkQD6SHvL+L9BI9mHwZnlfZpr3LPtgD02A/1GXIyXqrHKJGu91Rbaz?=
 =?us-ascii?Q?bLCqCsBowsBgSymBLt1T0XQ2X47xvRd099cyQqglte20hefxZWoHOE7dC1QD?=
 =?us-ascii?Q?uR/eXy399nFcJ3iHLKLVWEpKZuriUUKejZnXQ64W3V0Au3stTIXYwabcRYcY?=
 =?us-ascii?Q?Gooj2Kf8pTR7NoyK/ynEq1wvMJUPQoN/5Wh7BrDz/JBVbl1rGUJ/Cy3HGayZ?=
 =?us-ascii?Q?X7L2dSP4i7MnuglfBsqAnlcojhvXBObXDQ1PRJe3sLvVBwMY52ZciyszQls0?=
 =?us-ascii?Q?uydncnl1P9c91f41Z9SfG1X6RsmZGxXoR8EGyEjQJOkf4yTi7lL2ONvFn2tl?=
 =?us-ascii?Q?C9EReL+ZonPD1xFDyUqR5kmi9v8E7TIb+rX3fnAWxRBwH1KODFq1QYDsU44R?=
 =?us-ascii?Q?re0nmJ4Y5aW1IfJaL4PwbtiJnI+j5IBiW51Ed7stH8Db983UGhVVhcChb1bk?=
 =?us-ascii?Q?wkq5uoMdkeTbSfkxTVPmQ7U4lHFssX4OHHtQRjjsSIQO3TmDwvdv7YxosxYR?=
 =?us-ascii?Q?m8faA8sLLxtgV3daYWlQTvbwfwRurthyjZduOFwsDhonKOCOOJzXYYeJI/vK?=
 =?us-ascii?Q?86HLTRYLlclioUbsgm7X06RQ6hbdabEkQpASliNdYJz6JnTvIaZ2QaMpcpp0?=
 =?us-ascii?Q?VpxaTNKsDsI5TpGPY4h1o6T2St1UReZxrhkHPg1VlqbY/0fugktlzsVdSzJ2?=
 =?us-ascii?Q?wse9/vY+HCrnPJZMyjYKPMF2NAK/hme/tG8fg4Oa+A4TSAGzc/s95I0+sZwT?=
 =?us-ascii?Q?tc+EPBlrbN2PO5xneQu3jUKBfFHgUg4=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bbab98d-b4d8-43a9-b7e4-08d99a031db1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 11:07:22.4237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0hXjpXbqmXccEZ05veij50HRi2OsNPEBH4Q2m7lzWhJ4omi2gl/T4yVWnucMM05B0Ic6V1WMYE34Pu0P8wwoM2YJk02kOLzhCyReWHYxENo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4956
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
 net/sched/cls_api.c      | 26 ++++++++++++++++++++++++++
 net/sched/cls_flower.c   |  3 ++-
 net/sched/cls_matchall.c |  4 ++--
 net/sched/cls_u32.c      |  7 ++++---
 4 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 351d93988b8b..80647da9713a 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3025,6 +3025,29 @@ void tcf_exts_destroy(struct tcf_exts *exts)
 }
 EXPORT_SYMBOL(tcf_exts_destroy);
 
+static bool tcf_exts_validate_actions(const struct tcf_exts *exts, u32 flags)
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
 int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 		      struct nlattr *rate_tlv, struct tcf_exts *exts,
 		      u32 flags, struct netlink_ext_ack *extack)
@@ -3066,6 +3089,9 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 				return err;
 			exts->nr_actions = err;
 		}
+
+		if (!tcf_exts_validate_actions(exts, flags))
+			return -EINVAL;
 	}
 #else
 	if ((exts->action && tb[exts->action]) ||
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index eb6345a027e1..55f89f0e393e 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2035,7 +2035,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	}
 
 	err = fl_set_parms(net, tp, fnew, mask, base, tb, tca[TCA_RATE],
-			   tp->chain->tmplt_priv, flags, extack);
+			   tp->chain->tmplt_priv, flags | fnew->flags,
+			   extack);
 	if (err)
 		goto errout;
 
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 24f0046ce0b3..00b76fbc1dce 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -226,8 +226,8 @@ static int mall_change(struct net *net, struct sk_buff *in_skb,
 		goto err_alloc_percpu;
 	}
 
-	err = mall_set_parms(net, tp, new, base, tb, tca[TCA_RATE], flags,
-			     extack);
+	err = mall_set_parms(net, tp, new, base, tb, tca[TCA_RATE],
+			     flags | new->flags, extack);
 	if (err)
 		goto err_set_parms;
 
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 4272814487f0..fc670cc45122 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -895,7 +895,8 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 			return -ENOMEM;
 
 		err = u32_set_parms(net, tp, base, new, tb,
-				    tca[TCA_RATE], flags, extack);
+				    tca[TCA_RATE], flags | new->flags,
+				    extack);
 
 		if (err) {
 			u32_destroy_key(new, false);
@@ -1060,8 +1061,8 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 	}
 #endif
 
-	err = u32_set_parms(net, tp, base, n, tb, tca[TCA_RATE], flags,
-			    extack);
+	err = u32_set_parms(net, tp, base, n, tb, tca[TCA_RATE],
+			    flags | n->flags, extack);
 	if (err == 0) {
 		struct tc_u_knode __rcu **ins;
 		struct tc_u_knode *pins;
-- 
2.20.1

