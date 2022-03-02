Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92BB4C9C2A
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 04:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239345AbiCBDal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 22:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiCBDak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 22:30:40 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2131.outbound.protection.outlook.com [40.107.95.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3659FB0D17
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 19:29:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djWoWMqZscKHXIudyrgt++UxX7007vHbBUKeYLghY9Srm0bhQC+2o4+tAAFwFkQIT15GesSCMDHlqRUxP8X1dBKbLv1sK07UJFGvvtNRms6vQUD6lMhnD8xqeJjAboL8/7xfzlhPBWI5BFOuLpOS5c0AZAjzqDrPeo/6tpmGcuMdeLqDFBlVWLYgjzlmDKMwCcemmqzBkjgPGB26CGI9IMOY3gBxiABW5bWEvlVoMMHsa0Q/4HII23jn7Ysha7Lezz94IxT/PrX2pQpnotatgOA7RkSJq5RfBbXRac1+9TBdEn9m18ngOb9zMmZtLniDpMyFgyr5bp9TqaxI3e9/gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQzHGrav5Bw0c91+rsdOve8iAiXfHwciPXKa+GeeN/g=;
 b=XYlYu2sB3wkku56ZimDn6xEIeAGkmHtRwudCiJk4GgmfG1fBa4u3vbjUq1tA6V4Ye0JpzekqMB5nUeV1H223uUAnCX4cSp/Y95Ypc1lZAgHtB/0scGseZdP9v8bLdmU05x3OhEbeh2+rGKLmOuQO8qkHmQzcAZkQvtZ5wS3R8p+sZBWnjgyVzXMR1qxM0OVXgp9wSgW+w1WAsS6DzgePYpC9kyGsAPeuilNkqU0d04o/zt7BI9upL8rZ//5kBlQkRHLPidCV7jJmx5bO5hRv9GMilTLJ8c3vwLUeVtJUyx+MtPIqC16xu+1fDEtogMABJngR/9i4NkVirBHpgE9bvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQzHGrav5Bw0c91+rsdOve8iAiXfHwciPXKa+GeeN/g=;
 b=aDgx1A9TUO84E5+simFcAVKfNz545Uz/r9aJ8UwCz+OtRBYYxO0TRyNkf3z30CjMmXs0tPZOAWp81gfywtIvLwRe3pQhXevDJ2yEe6pT98ZGeZj0TMKe4wJhFOjaardFNNub/3kwkJvA5RRSLSjIkiHLRO++9TABjRAFxB6TD0o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by CY4PR13MB1031.namprd13.prod.outlook.com (2603:10b6:903:37::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.11; Wed, 2 Mar
 2022 03:29:54 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::1d6a:3497:58f3:d6bb]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::1d6a:3497:58f3:d6bb%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 03:29:54 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     xiyou.wangcong@gmail.com, jhs@mojatatu.com, netdev@vger.kernel.org,
        oss-drivers@corigine.com, simon.horman@corigine.com,
        roid@nvidia.com
Subject: [PATCH net-next v2] flow_offload: improve extack msg for user when adding invalid filter
Date:   Wed,  2 Mar 2022 11:29:29 +0800
Message-Id: <1646191769-17761-1-git-send-email-baowen.zheng@corigine.com>
X-Mailer: git-send-email 2.5.0
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0601CA0002.apcprd06.prod.outlook.com (2603:1096:3::12)
 To DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d72eaa9-d0ec-4fb3-2f4c-08d9fbfcead3
X-MS-TrafficTypeDiagnostic: CY4PR13MB1031:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB1031C078EAB3C0FF1605862CE7039@CY4PR13MB1031.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f6af4rxB7eugZBG5KKlfoA+9Cc/A5nEuDYBtp89t1zYj60SF7YoDegEdM0r1QJ+xjf5h++XcbNtd+Z5vKahsMJjRP1yGY9CoXNjogFrZhb8vJTKbAlXt7jfbN7kqxBvFjSKovo/y7oWBYhBaXpkLrIBYgTdbFzX3cLtLRTiSgAas8m4y0QyLvohUGVDVjL/4NHd67Zi5rA/m1mqLHlWkwDKr+0DA6rOo6LweQWxlKaMrhD3Y2XCM3T/YRb4ZitxAv+1EWdyDTK+Eg0izTCLdoQAAm8/zRQMKHaGGSTLHt3tV6CDoJpPHybk8NqfZbqK286OENyvdIFuwcgzJIW3xELfRCc1uRrH0ty07qAaxlvFIvlE04cGQ+yd/rOD2r5cJkAz/Kn8Bnm/YXM+jSTY4+nTcj2vbgc9adxh7S2oYOKmXPY2OV18wkj2mrl72SY2BjaUAPj0wPXqB1K8XyI4ZjdYFibbGBHVrFrKM6xt/bY2bXYgrmP1d0M/dNX1m0SKj7KtXvnyNTmMGCAKF7RgXgYtCRzonqwqam05dHssdLiaIH7r5zLlonLTe/eW3eXdVeqbNdIAXHCeiSLBj4/JsSmcjP6A5An0fUpmomopMJMhb4LnN/wNh2BDbv4Om9KgMDSb0En2ibcHr2EhKEA6EojGfyUk18wJZiHKB3CnMqW3VH6nSlHxzjB64csvOl5SYMgpg50qxg8hXqfHuWxMJ4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(396003)(376002)(136003)(346002)(39830400003)(36756003)(66476007)(6506007)(6512007)(66946007)(6666004)(66556008)(38350700002)(38100700002)(8676002)(5660300002)(4326008)(26005)(186003)(2616005)(83380400001)(52116002)(316002)(6486002)(508600001)(44832011)(2906002)(8936002)(4744005)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dy50emyJGPJVEXO+ojPNcrqK9b7t1DiYvROFtt3bkzZAQPhcjWnHsr95/ehC?=
 =?us-ascii?Q?SDDYPeiZj2LOKRgTd0CjodEiC+jigLxtbkb+eN1LyFw81LCm8LlvqaAmaA9S?=
 =?us-ascii?Q?yt1xDKnpK12TEgjyQ5Js9qh3gBzkRD2k4W1c9LBXfB8Kp3++owxO4n+xAuFn?=
 =?us-ascii?Q?faq+N2rp6JuPTHEOpX84utYRpmerTFTztNO6xxkaVQOPR2TVrylunlJ4qCtW?=
 =?us-ascii?Q?7r2HwgBjeMT58AXABG5uOOBQT+mbK9LoKE8EFL6wYcfnqO2eFvlphbOE2Fb6?=
 =?us-ascii?Q?gcYz5aCytzjYDnW8WX4dkYG3yr54JrJf24TwERsjJi4nOolwRKQ7/zWPeYnK?=
 =?us-ascii?Q?UnhFX8STaYWZm2tnoWYGmBnwdbjgyaTY2LtcAVHdT7z6Z9fCQYhKPaXoR8JO?=
 =?us-ascii?Q?G8K1HvT6WYCwiHSV/68Rme9x2sFA253ura1lblmu+yGpu8WOsRYStBDCoaRN?=
 =?us-ascii?Q?nwVdFZtT3COjHq7P/ww+pusLH8WVLr3OOuZE4BKfLeMwG+02EFnH93XeBzYD?=
 =?us-ascii?Q?9DZFprc/FiiBX9w5ST6osOHyQaSIrW0jwTMNBf1ZU2r81WbCkuKv7LM1tKLV?=
 =?us-ascii?Q?tT2DaEabEOGxHe9A3TQxeD1xXzYmlaZButlbgiX9p2joqLecGozQ+9fa+0tn?=
 =?us-ascii?Q?LRtv5P4qAPxdIlW636jCs2hhI1ipbNIGR69ZKGRcIS/xfIff8MFibxVyjNe8?=
 =?us-ascii?Q?DoUvh19HHdE084cNXTCQkTxgryZSBIZeieYEmOuGq2hp2WkGNI8Nlf/QINZZ?=
 =?us-ascii?Q?BNuar1XIeV/qjl1/BTM4to+AYqdiD8a+MIbjohzKK5ZBJdq3X0rXFiNySowQ?=
 =?us-ascii?Q?oJy7kbk63QKmKw3Z5EikUMaudo/mhW7xZkFHn+aHXn81oGLVxdcEA/qSbOe0?=
 =?us-ascii?Q?hbqWbOdwqBK8J1zC3sMdv4v1luT3Ceq7zIQ1aFU51ggEjP6G+jhfwXY9YBbx?=
 =?us-ascii?Q?z5tNmsBa3CVHjfVtC6Ml1ADKZi1Ibyzy28m83wwSlYO+Yq2Ghq8hfOoEGkr+?=
 =?us-ascii?Q?kegU5HvNGQ9uaBZa1bn983bc+zBJj7Dg04aLfZAnorRPBG8+gnSSjfarEkrq?=
 =?us-ascii?Q?98Q24Pz7Cy5SKC0VuUcvjQ/VxcQV1jjJMNGx7HR6yJcxSUMydgYC9ScmJPUM?=
 =?us-ascii?Q?w0qW/qGkxIDMhQ8Vuz3+blQ25AQvHtKZdnlkn/GD5bo1p19bOyUyLTbGOVuV?=
 =?us-ascii?Q?iklxdUmWMhEiwwfd6O3Q8UwE8cbC9JuHW1i4WKbU/IuNvyxklMlcuzr1xu7n?=
 =?us-ascii?Q?X4uZB0OWaP9AZDLcgoJPh2ntnIMPdVSLjxwsf1uFNyGTlaeep/0PKJ0mF51M?=
 =?us-ascii?Q?XMY6rg4o9EcDtJ1f/i/23f8ymAUNd7EIy4ciZHYbZBMykmu/fL876FOKrH+x?=
 =?us-ascii?Q?aO1x43yVaVZpH0+/8AhyaGzvzFhZHd3X+Cg/GI+X2oIkNUqAuRhV+9sLmpo5?=
 =?us-ascii?Q?nK/Mxlv8yaRJRC8xQAR8W7H2FSNp6Scf1zXQP2PYbRoFqxSJNtWGZ7s3DCXE?=
 =?us-ascii?Q?ealOv0Ar+6PDB0IJt3ZwZ055jZCSmeR9Olv+/vrCdbJ12xtKUWhvz1wIEdTl?=
 =?us-ascii?Q?EW3Y5zBDMc8Y27cofovOzJ0KUlNuKsWjLYk/ML1VZpXmAPAuuzvXoV9bPbIb?=
 =?us-ascii?Q?RwpHD517DMGht2CdMRE3BcA+/0ZcGVbM8zooO0D/T56DBc/tYZ4dx03NWdJM?=
 =?us-ascii?Q?0Hy1CA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d72eaa9-d0ec-4fb3-2f4c-08d9fbfcead3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 03:29:54.4518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xyZa01DNyEYmPSYBLz5wnVYuWhdg72kOgyotX86R6EL135UvHQ4Sw0XQojTLIRtULMh75iPSkgdvQHFjA5XQ9fAy/3x/AKAvNQHnqZBJ89c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1031
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add extack message to return exact message to user when adding invalid
filter with conflict flags for TC action.

In previous implement we just return EINVAL which is confusing for user.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 net/sched/act_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index ca03e72..4f51094 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1446,6 +1446,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 				continue;
 			if (skip_sw != tc_act_skip_sw(act->tcfa_flags) ||
 			    skip_hw != tc_act_skip_hw(act->tcfa_flags)) {
+				NL_SET_ERR_MSG(extack,
+					       "Mismatch between action and filter offload flags");
 				err = -EINVAL;
 				goto err;
 			}
-- 
2.5.0

