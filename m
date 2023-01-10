Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CF0664D28
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 21:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbjAJUUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 15:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbjAJUUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 15:20:43 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262135C922
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 12:20:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQmUm5mYCKRBZ7aFmcPf4lhMIfKGYM9hGITQCQpvYItauvKrqCBLekxTEb7ZNAGeLaSG5QbPqoYZ1ml5NADZDd5f6sJ7z9bqYycvUeKU3xUJ6y3nPs2Ixyz894epnoYVqJVGDTJQHXeDc448Q+sN/pQn83hKMn6FPILtVb/Rg+TC1s4bQKi4P5M4F04rl9vocNGa9zI3Pg2zYH7pwgpW5IUHH1wEaqVTtM3GIpT1GwTNL1kDgn8/sC4fgLTlbgnrLqrxEg/s8y+sreXpTjZrCCAw26Bl4zJa404iuwKH3GmOVv4Gxx3M6EZNzbNofMznJynrHmXBTk+ZP0cke+VuHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PdBfw38Km1Q5JOCuAJBhmuMFmvDxwTTzE3S+uh7V4NI=;
 b=is5hbxxLM5ZR3NxIim1a8oy9QNLweC1I1WKhSE+oBXn+ApABV5PeGpihtlo+g+JFVA7ExniF77vLRo2ZmtPQV4EqbBoYl6FNbTPRyyjQdkd5Ux9TvGXCt6ohkBWFVoOh6taOcGtDYW+g9BRv0jTYDRtKIpwR1ndIocIcNkuT9g4oD8ObuyRNWAthIyo/x5z7LLGJNQm///Ri6G1+3oOMI2hUfZKwgp/5h/YAocNWdy/u9bYJx98J/g/K3/3tnl5qcmhzFzbT8NKdmA26GPq+j5XS1daXjH3iH/j4Z5qpgMkmllH5kc1DW8ouoXHJXhkJs7wHfDepE0Ohi76OF/LbTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdBfw38Km1Q5JOCuAJBhmuMFmvDxwTTzE3S+uh7V4NI=;
 b=sDVbnUmQxuOtsXj4mcSE35loaa+6BqVj1AKuRWOeuzQAE6/4Nkrks3genDpUX9SxGnXDaqv7blopPMibq1Vgo0OEuI7LcwfrmsNNbrxIsixaEHsfNyCDUoOT5c9m1y/umw+79fIw+CVo0mXpbwNRZVO1va0rHkAZ61DzXZZY559eBGX1ZCG0fm20qwuR5tXar1HZojHLYPfGEHoMozwKn2VdhtaNE4K1GobFaGALudWYygdvkuPI3Ey6nZt4Sa3BGERZ6/rMSAHW4uryG3846OBqkXaL6i0iCvFE37t4aJxvPX1SI/SXmRo6QOT+GKQyUUzdg3JcOjmd1uogTxE1xw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MW6PR12MB7072.namprd12.prod.outlook.com (2603:10b6:303:238::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 20:20:40 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 20:20:40 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH net] sch_htb: Avoid grafting on htb_destroy_class_offload when destroying htb
Date:   Tue, 10 Jan 2023 12:20:04 -0800
Message-Id: <20230110202003.25452-1-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.36.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::13) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MW6PR12MB7072:EE_
X-MS-Office365-Filtering-Correlation-Id: de784f56-0283-4313-4418-08daf3482466
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ya2o0pvVoj5owBTIGJA1VqvMWGB42ou2XsIh8rRy4T0DugEmkId3GAy9dE/0f56EELi/ogbZQQUveafFT7Mhh06Tg53tUZyU9uuNfi9v1gNmTedWlSBIEGqzbQ4/YE0K5M8EIrYl3VkAFwSPMidqJVXI5fXzZASaHxWzW9NDKOikAO9tJ69GxJrqIjjXIixMNZNAJYN9xTPvBHoBuY+UMZJLIb6AUwFpChx39So+uinRGGQBKubk8HrPiffVpNkkFpX1BEzgpntrdE80ORzSELT1ysOlTHpF/ViZqG0Lvb3j/ZUO/OG01qY/ttM8O7RwOd5eQZoyKKesQjdD602Q7HlBEAbz5UsSdBWvDYlJR2xUpPBJgsgRpAaAVa5ixNSo9gwYs+2nudEKB8i49Px9zzdrOO2ga+esuMWkOvDMALgdBiyd+/Ie1umMcJfWfHB0TxkWryjtfKoiXH3laX2jwqAw/qA1p/k68BzJuUBRZvujODV4Tjmv7qYj+WijWg3Iih2x3TF6jGxDWVQvQDgtBm60+qpxLU97GdMFEZLok7Je8TOJDSm8vmH57mmngzIxv9wCbmHlxylPgfrbuDASEnY2iWvsBSUgI89OYsy0OURvg7NgU1IavOf4TsHV9EFNPjBcsXZtsZ3n20qbe/bKgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(376002)(39860400002)(136003)(451199015)(36756003)(66556008)(86362001)(6916009)(8936002)(66946007)(66476007)(5660300002)(4326008)(8676002)(2906002)(38100700002)(83380400001)(478600001)(316002)(54906003)(41300700001)(6486002)(186003)(1076003)(2616005)(6512007)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/17Pra/lEHEBf8f3iNOqxNJF85t2IcdaOXITneEqVT8fwOe7BAsBEvXMySws?=
 =?us-ascii?Q?fajn+CYDRwyLb1Mo+Ji+53DFuuB3WSc8pWKeDFfb0qIzB+iB0OnTimQmX7F2?=
 =?us-ascii?Q?DmX+hcYxS8LlliJW9/7NubrWOisS26GlgRBtDMTsFa1zqOcn48v632gctU/k?=
 =?us-ascii?Q?kymaHD+qtkWKBIlv/D5ntAOra1MsDAGZGALbIr3PBSb33lFZn72BbwP5bTPT?=
 =?us-ascii?Q?rhtmW7Ykh16QXSspD9MXJQCer4Bc1n+uiTBiO1RJeMpAZMoaGuQKHltjPDuY?=
 =?us-ascii?Q?+yPzQxpYTqBYLhFBLqil1FzLMA77hGdY7GG+7GA7huODmAUVVOY+6YOx1V4k?=
 =?us-ascii?Q?9l81oOmWUwZ3PytOBLgsUBu5qqP6qbMAQbNbVE4Vmppu6XdumgD04PJaYKu4?=
 =?us-ascii?Q?2No2ja/dAkzVHkd9fVPXEYb3trMG+oHfjVLI22neTX6g/kDPTbfK8k0rSHIi?=
 =?us-ascii?Q?uUjtGIeFnN+L1bNQw9/YUkJkbP7nasfyS/FuoJwF3SR2B51+0JlHO2DKj17R?=
 =?us-ascii?Q?XbFkFnDbe2WlbiDO65jQ9snsVuzKVIMxWXnpt3gMZcNCoEaX1wqLekJ1aVQR?=
 =?us-ascii?Q?0rEdiHErb9x+Qy5VDJXAYwO5UgkRlLPvee8wsn0o9qf8K7WNP/BPlOUewJl5?=
 =?us-ascii?Q?Nu5b/Jvkzd1GgfK0iw55msh7s+ZytkCBVcblNuhy+klcbQwOTm7CEcl0PJc3?=
 =?us-ascii?Q?f7/gIQ/DpOWSKdnYP+iOAszTSh2EGuWRcs6uqyBJ34cU4oQfEK+gSMEIG2H6?=
 =?us-ascii?Q?H93JOeDQrPt3LPaz0bzUS9pA1OtYGXw/0SHqWPQcYNtFrp3+u0sYnS2SZ9eN?=
 =?us-ascii?Q?bL5mBjp+ej68gFwaxBdBUtyFNhK8w5q09xI5NCtLpwXqjvz3gKF82Vs1nc1d?=
 =?us-ascii?Q?8UU/YCSj1DVPC0m0fLac4C5YH9RuI3+lgV0TbAzNS5U8jdJUGpf7D6HE3mtP?=
 =?us-ascii?Q?uxxVldUXcwqLVOTDE80+otDj5F5MsoEBmJsSJNoTCMUzP2EHxqA2jGX9oTWb?=
 =?us-ascii?Q?ucw2tPlPxJE1laCw3f9iqtcsCdsXHBi4x42oUrkUg5OLHpoD1+2zDR1NRUEm?=
 =?us-ascii?Q?7rjQzv7rMtywYfrGZ7ANA2AGtSVc8+XWSqao8/f7ewBMXZwCQKBCX5aA/ZHE?=
 =?us-ascii?Q?Ks8H7Zww5UImvaQxFU6zBlGiIEw4MlROh56q5MJosSSYwdR8ozRb7f9OY2+K?=
 =?us-ascii?Q?81qHeMwbSCfpzmTYv8nYYEK5rQQi4UIf5WMQhH0e+V4sFuDPYiXsP9xUMKQz?=
 =?us-ascii?Q?kcZGTw6xO8acN5h9DDyAAz5+b8kL6ZEcC+h2PpdvgF/2uQ/8d07ShiKagVW/?=
 =?us-ascii?Q?pyZBMlvTWE9XQ+K+LsoWGTZHC1fr6sNy70R0J4u/l73c6xkLRXb28SzccJe8?=
 =?us-ascii?Q?wiZd9V97zJyOf3BPf+Y9jAonLdqJiw182BVzO1MXLyyIBLVV230ZEliAlEuD?=
 =?us-ascii?Q?sba6hKVJSgqX3G6vX841s5D8pZGvz9+fS915bPYtfyMIoE1nz/rzMEGS3Pvj?=
 =?us-ascii?Q?vT4b9xnICNLJDEoMUN+0T6aitqIxpRKMKrh1b82TX+w8fjLfXBe+wZzx+ykj?=
 =?us-ascii?Q?LGm6/qQzR2DGMjuiJS1OcaVVgPs876xAh/N6wkplgw+3pO7mP5OiKFvvtJ9Q?=
 =?us-ascii?Q?S2/6x4jVQIIy3sBYOA7VEL0kzK0TVIFo/mFgmU4R3Ys2n/DGMVqYb7evYOJy?=
 =?us-ascii?Q?SxkmQA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de784f56-0283-4313-4418-08daf3482466
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 20:20:40.1629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0o739iIj3t6Z6tuWzr0FY2EWJV3TWoOn7IgLmoLBCBsQAAYs0XaWBrzUAnZY/umQXjSylj+3o/FvAn+80xpsoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7072
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Peek at old qdisc and graft only when deleting leaf class in the htb. When
destroying the htb, the caller may already have grafted a new qdisc that is
not part of the htb structure being destroyed. htb_destroy_class_offload
should not peek at the qdisc of the netdev queue since that will either be
the new qdisc in the case of replacing the htb or simply a noop_qdisc is
the case of destroying the htb without a replacement qdisc.

Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 net/sched/sch_htb.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 2238edece1a4..360ce8616fd2 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1557,14 +1557,13 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 
 	WARN_ON(!q);
 	dev_queue = htb_offload_get_queue(cl);
-	old = htb_graft_helper(dev_queue, NULL);
-	if (destroying)
-		/* Before HTB is destroyed, the kernel grafts noop_qdisc to
-		 * all queues.
+	if (!destroying) {
+		old = htb_graft_helper(dev_queue, NULL);
+		/* Last qdisc grafted should be the same as cl->leaf.q when
+		 * calling htb_destroy
 		 */
-		WARN_ON(!(old->flags & TCQ_F_BUILTIN));
-	else
 		WARN_ON(old != q);
+	}
 
 	if (cl->parent) {
 		_bstats_update(&cl->parent->bstats_bias,
@@ -1581,10 +1580,14 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 	};
 	err = htb_offload(qdisc_dev(sch), &offload_opt);
 
-	if (!err || destroying)
-		qdisc_put(old);
-	else
-		htb_graft_helper(dev_queue, old);
+	/* htb_offload related errors when destroying cannot be handled */
+	WARN_ON(err && destroying);
+	if (!destroying) {
+		if (!err)
+			qdisc_put(old);
+		else
+			htb_graft_helper(dev_queue, old);
+	}
 
 	if (last_child)
 		return err;
-- 
2.36.2

