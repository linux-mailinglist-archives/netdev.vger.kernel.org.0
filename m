Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23659455C53
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhKRNLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:11:42 -0500
Received: from mail-dm6nam10on2122.outbound.protection.outlook.com ([40.107.93.122]:47280
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230164AbhKRNLg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 08:11:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFpCnTR1O5h6t5NYdLxtM16sLZOB7gTEbKMBFFaF2HS3qfTLVH41yIkW/5+7ayu0iexOokSG/hoOAVSgET5q3aBKBQ5joBraFZ35rJRPlmPRoQ3puO2P+AmmwqweHCmNvFxf5V/VQlm+GsYYYPFlVHDAlr9KCzbTtUJpCcIj8GKuMW9iaLnyt39eAreTLA18jKfZ5Wi9VXc0CVQIQcwVwl9vZkuB7Bvl+JiirwEzD97xWmEJhuPIEpCLqnomLFE0FQZ088cdGBkadhIqpd5updpVlKr/lBV/IWIFVWHcfRStPIG+9kMY97k/N3KilbKKUC8zwXFWk9rEgx+7xVhFGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ftIQusN75fnz6kLEUlq2GQu0roP7XoM/2a9WSrXoqE=;
 b=ENEQ9b04vD8rbOL98ksO7ltXNGqw1uJ7o+S0Bw+b7+m0BC3GiKtAW/00YzyGzyK5AnZ/f0hxRk9yb75U4ObcHXbvKZuIhV3EhraQVaYXUZHg19Lv6C4ktmXomCsOl9ITs0VWHqYh3ZiuGgYyuyn36BwgZ2em7xWDNZQoaBSCS5nF6070Ljk+dNebV4oXY1YZet1aUIvpsPkNC/JnU/ZGqdAGB/vkL9t/OUgPkpzJ338xVLy2tNuh05eKsXf505Vc1kTX1kerD+RKoG6CA952+Zy4/d+l7MBU/DqBV98dcu3KbcEA1XNOAduQcHUmm/6cgsUSOb1NwenEC4aqM3OyMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ftIQusN75fnz6kLEUlq2GQu0roP7XoM/2a9WSrXoqE=;
 b=h/EWPgU/uSu2WwdkR2BXGnICaibARNsqFAV3LCDM2rZ48yo2nIxt4SLIpknjUs+lHgjJ2Vx2GfZDUzMfBkGli0fXhniCAB1oa+OAMvYYkBoUnR2g6d/iqIIFN8OSCIILdXZxwyuf+kdKQ9rChhfNYMrDqKa2TZIalu7ARE6iwoE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5780.namprd13.prod.outlook.com (2603:10b6:510:11b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.7; Thu, 18 Nov
 2021 13:08:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7%7]) with mapi id 15.20.4713.016; Thu, 18 Nov 2021
 13:08:33 +0000
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
Subject: [PATCH v4 07/10] net: sched: save full flags for tc action
Date:   Thu, 18 Nov 2021 14:08:02 +0100
Message-Id: <20211118130805.23897-8-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211118130805.23897-1-simon.horman@corigine.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0021.eurprd02.prod.outlook.com
 (2603:10a6:200:89::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9) by AM4PR0202CA0021.eurprd02.prod.outlook.com (2603:10a6:200:89::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 13:08:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de6309fc-3a27-4589-fd44-08d9aa9485ff
X-MS-TrafficTypeDiagnostic: PH0PR13MB5780:
X-Microsoft-Antispam-PRVS: <PH0PR13MB57805E429329C6098AD3E8C8E89B9@PH0PR13MB5780.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jpieo7THcDZixC15i95da3y6gCCnd9WlMEEeQAMkMAYQacvysq5yvspvD8ZNbnAXcVV+Nylk5houNgEVLCJT8E+I/yBNxKoHkMaT/xHb5a9kMSrblaZujz9rgzjjdyQ3mwJCshtjlAzGKhaBUO4fE6QY/BaftnNqSp0y+7Ggjo8kxIlB7vfVubJn+Ah88D/JZt/AI9mPxvOy8droFuEnpEN88HJImL2nuEBBo8PGODfvqxvUslXl4XrofBM1zcuGCqGyGVta8ZbW+OB85Ne9UBlShWh26YvhNPkj3z2aQoxog3jJIK3TPhOBb/SkBLMdXd+wAn2dcKBrT+Gd2lswH3pPfDtGy477Lxl2+9slWflg8iqAcnYSz+m3aG6S8E6Wp2t0RFvI0e05sDtKmbF6Ik5ezuX8g3Y9nJ9zcTvWhDeWgCq8XbyNBn7+4tpJvEMVdYIpSlvbMFpp2EAv15Ft/9Z3FkmkW5XV+lDEpEdSgdnKf8pYz/jGRF2NV6UoFTjrp9Y+ym47rx9I9UvmHxYfwxTT+5P8BzG/Y70g4g6gR418n5/h6UzYurm4Y9QdoOFRhQDfO14+3JsSLKWFPT/+bKJOgPlT0nDXm9CJ2TcMbZLRBLHbbplJP+b2vj5VlC3ekjZDtwYwN4OSP0a9cWZa9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(346002)(396003)(366004)(376002)(136003)(316002)(66476007)(6916009)(54906003)(66946007)(52116002)(6506007)(8676002)(6486002)(66556008)(186003)(86362001)(4326008)(6666004)(44832011)(6512007)(83380400001)(107886003)(38100700002)(8936002)(2616005)(508600001)(5660300002)(36756003)(1076003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VfEyeN8nc7UC4ZBaY/IELlIEHtW6nvoq88ngVU0s8AGkBWNIJTN2XHsodPUw?=
 =?us-ascii?Q?40ghFlxrT5cEgp4IgpbGGcruy3T/nBGmlXMDYp8KuzABRTM68uIoaWD+CWhm?=
 =?us-ascii?Q?ciiV8C742PnWIWCwMT7G8zOnNeZCslQIkCYRiHo9FRrgcPpOJq/7Qf035tOD?=
 =?us-ascii?Q?qtLPWeqgcZ/6Yfs1187TyFe8sh38RwRyyMAdyZXG7Mpb/0ZSxoahvsiL017n?=
 =?us-ascii?Q?phVlPpI9SIzYf6qaBzfK9uhIy827J59IG4Ckf3AWKpQyHPKGOUUezD6j45Pb?=
 =?us-ascii?Q?smZa8c6eSw2RITh2qXsk7obA79XejJKlfgceoTfyJJ2HcZljOy93/9J+lNnZ?=
 =?us-ascii?Q?bjRIi7glu13gdiFlJgZF+Nf12FOlaX7L9B5haA/T7wXCIFMi1nL7pUZIDYU2?=
 =?us-ascii?Q?WGVPvhK5CAW9sUFgH4NIE9JZQbXrk8Vf2vmBui2NRdvMEJwe2+KMtl+hn1vG?=
 =?us-ascii?Q?i/84V1VDsf6aXCp/HrCuBZP0Vmt6ew62svDp6p2EKSqI7kg9+1TCjIe6Q+s+?=
 =?us-ascii?Q?60GgWVOxnw55bo8VbokcbBb7D6dUED/GieoVG8ODZwbFHVlI/Q0cAHWtv6qU?=
 =?us-ascii?Q?NoroxozX8QrRcoCxaXoU1Y0wE67gbvJHarL9Yn0Nfvx/L/HVWWEXlRtxDdkj?=
 =?us-ascii?Q?JN7rJkzBoOFdqrVAiEX4ynNP5B4EvpRsOZVtqPALrIIAbaT98TtfxK2jqIzV?=
 =?us-ascii?Q?0M2Mav3TCukENEPgeixbcn3Upnx2osyCoWm+n301nZM6eDOgXGAuwCHimN+S?=
 =?us-ascii?Q?d1iF87c0m7itbMyhQ+0QtMyH3AGBlft2RHu3tIm6DAm+xhw60evoFq7GRX1S?=
 =?us-ascii?Q?oL/KDZvHtvEXMZ2XwPXRqdTIcksSLbTgMghJ2R/HZKB2PlpKI+rTx2i2noA0?=
 =?us-ascii?Q?lUvWMkR0MglPFCeVWC/3lpCk+N6dPfgEiVxVYpmrzi2Nn57up9BJHO+jvP/e?=
 =?us-ascii?Q?OZ4DydPmG6pWMbv6xEG0+0qWYUnN/8KcBTxalWkytHGpon43pXrf3U5dJ/IO?=
 =?us-ascii?Q?9dMKvY27XEhnjDKZv4i+JXpMUL392VKTyJDackeBNdSC8AuVm3WjDFotot9h?=
 =?us-ascii?Q?uAtsj40EB7alDmpky/31k4hKnhFc3jgtmUI8xGZuhwQ11PFvqHdA/vNtj2ZC?=
 =?us-ascii?Q?4t/8L/TLdfta69XEkF08vGPNsuN4IOzpOt2zFc6j+NuLj9aeVPSHsLV5Xpke?=
 =?us-ascii?Q?fSuj1jfFbPAlF6P7c0GfRrHDNgaSH429CKmoFy1P4gyEJBy7+//Rwm4VlRHE?=
 =?us-ascii?Q?uvLWaAIoIzVHLcQ9/qsO9GMaJOzrq+l/c68kZ73xyQeYXK46Xwzw6Y7L655Y?=
 =?us-ascii?Q?8n5W9Ko04wordTaK7w63pyScPtrQrrvDiPfmRxFlc0DizBO1iwQuDqYqd+W2?=
 =?us-ascii?Q?e7CzlMa/nulzI4YJ2J9YZTdGOKJZwqN01LHAx5GR/xErdgzJxBZuGPvIruP3?=
 =?us-ascii?Q?wDcfXSVX9gYMKbHcC9UuMjp17hvZkSpqvf26xPuHvetdIZWnQOS24ufYVbaC?=
 =?us-ascii?Q?ZIxeKbIstgpYyOyFgvpkMH1hr+UigSO2GvARTmMyeW4FivG4wND3aEpq96Nv?=
 =?us-ascii?Q?D4kXo69fY9LWJihFDvvAcLVLCACM96uW4mQrpoZTC52v19MASxZk4Oxluk14?=
 =?us-ascii?Q?qe7wQ45eOJHeHuDXIagYzt7NLIRvDicZ85NQ226QA2He9jcbksfP8q0oCZRe?=
 =?us-ascii?Q?g7SkWWT0SD6HDYDhTBk6K5CTVbjfwIMqgcV5q1QLpsNXGKk94lY19focCwdB?=
 =?us-ascii?Q?wHAVLD0PFT5HdxeuGCJZalV9e6/P4uE=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de6309fc-3a27-4589-fd44-08d9aa9485ff
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 13:08:33.0888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NF6UeYKDAV3sLaVVuoJJPDWX7090+KWPaq56D5HdYZyJgKtNaSEEZtKurt/TPWQu0CqL5sbJDto/xoohvylQa7FEUykFCizS2bu1EpNe2xo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5780
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Save full action flags and return user flags when return flags to
user space.

Save full action flags to distinguish if the action is created
independent from classifier.

We made this change mainly for further patch to reoffload tc actions.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 net/sched/act_api.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 01f0bed9c399..f5834d47a392 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -716,7 +716,7 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 	p->tcfa_tm.install = jiffies;
 	p->tcfa_tm.lastuse = jiffies;
 	p->tcfa_tm.firstuse = 0;
-	p->tcfa_flags = flags & TCA_ACT_FLAGS_USER_MASK;
+	p->tcfa_flags = flags;
 	if (est) {
 		err = gen_new_estimator(&p->tcfa_bstats, p->cpu_bstats,
 					&p->tcfa_rate_est,
@@ -1043,6 +1043,7 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	int err = -EINVAL;
 	unsigned char *b = skb_tail_pointer(skb);
 	struct nlattr *nest;
+	u32 flags;
 
 	if (tcf_action_dump_terse(skb, a, false))
 		goto nla_put_failure;
@@ -1057,9 +1058,10 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 			       a->used_hw_stats, TCA_ACT_HW_STATS_ANY))
 		goto nla_put_failure;
 
-	if (a->tcfa_flags &&
+	flags = a->tcfa_flags & TCA_ACT_FLAGS_USER_MASK;
+	if (flags &&
 	    nla_put_bitfield32(skb, TCA_ACT_FLAGS,
-			       a->tcfa_flags, a->tcfa_flags))
+			       flags, flags))
 		goto nla_put_failure;
 
 	if (nla_put_u32(skb, TCA_ACT_IN_HW_COUNT, a->in_hw_count))
-- 
2.20.1

