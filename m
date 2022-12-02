Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E554640F0E
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbiLBURC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234921AbiLBUQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:16:26 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0AAF465A
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:16:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JjKH4DiwkTS6xzwcOdi6UeYp16x+elvkMjGs0gahRnjg5emvDHHgaJmVJ8ZFLu0drLbDCTXhLRwWVRZsPoTm1N9piVblN9Pc6le3iZWIKleXHVBj1sv1y9Ak5vQrRK58NXNnUl2yQhwnleG8/vL74YNpp4tB40y9lqZmrZnWxl6hOEEqHdY5h4b9ZIOzebevWjDiKJ8fFaOf7t9f6UNN9pQJdlad7KKfe60QGKmp6//yRPTC6Z3V653BjXAn8khmpZbwOMmFQPA4TADDrySG+DU+jMyo/bqfQHaOnqbIPvTXChQdbFVpSzNmwNaBUZNLqyw5cKRdic2IUwD6GPXjPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6WMJsMzuhCqWQxG4bw+my/aRStR358sY5SBr/EXg7gk=;
 b=CkqizirsBko9o5kXaZI+fWut1o6wWQ5kW1Dm8EvxA53ZUiNNPv4NEhzFgNciNVLzjOrdcCR+M2Q0T5vdoONfm7q8PPtPrd19r5cvx8EzfMQCewoVVB1D0V1WvN/NnhtU9ln8Zm/REjyT3u8Iw55c9peBSLhaQfedMPEepYL6rJMdmSBYwknBM7jaXg1GvgCsREdjVMJGeeNR2y8Jw2kkNa57OMid48Zs4COGmgYjVrXgm+IeZDX4RGqhP0FLxaQmE5zzKwNbjq9CN00iuFKnUJkt9H9Lpsa9YsCLd6l8mlqi/2s8p6wroYUGnCUOp2UYJxNzF2CG7f3cjY7eCjxsjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WMJsMzuhCqWQxG4bw+my/aRStR358sY5SBr/EXg7gk=;
 b=oinQ4MGltgikU2MRwclPhQK4Yc7ZmJOTO1fl/V7tYCwpKHBJ3JnlS4geiJTmsa8GR7kusH/U14f8P2UTQA+4VzW2+VBDMXI9HDraM3Y90bD+ExK5OqCku/yob5bm7Zj84wlFRvgHR8aZTDOn6I6qGktzsvY4h/VmQsHJ3ifC9+xWZ71kmO+0zp5An+odjIS5HXv7Vf4jmhMYyOw43CVLpLzKRW2vbJZ+sTqFd4l+IW42neUd+iPgviyWC5Qh2ewRUrJG8om/h0tV3D72tfw3MLIdK7mHsxb2fCIj/HfPtoc7c/YCLLpTFnTd9uFEwqrWmaRRsaxFQQKEWHy/LGwgmg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by PH7PR12MB7308.namprd12.prod.outlook.com (2603:10b6:510:20c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 20:16:24 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f051:6bd:a5b2:175]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f051:6bd:a5b2:175%5]) with mapi id 15.20.5880.008; Fri, 2 Dec 2022
 20:16:24 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Aya Levin <ayal@nvidia.com>, Gal Pressman <gal@nvidia.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net/mlx5: Implement ptp_clock_info .getfine function
Date:   Fri,  2 Dec 2022 12:15:31 -0800
Message-Id: <20221202201528.26634-3-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.36.2
In-Reply-To: <20221202201528.26634-1-rrameshbabu@nvidia.com>
References: <20221202201528.26634-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0038.namprd08.prod.outlook.com
 (2603:10b6:a03:117::15) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|PH7PR12MB7308:EE_
X-MS-Office365-Filtering-Correlation-Id: ef19b397-e2d9-439d-2593-08dad4a215bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q4LadLdaUhXWFlw9BDUU4xAy5YXt3PJpBoxqXpQwUbXnrHUr/Ai2Boss9UvKDHShaV2hnkOQp7/70CLKQoAWpMj14lC2N/B6blilawoMfk2X2ft0vfzhpH/hcOonS1lgb94VLvaAn2eSuNvSIRr+VBb71KDeKvjFEYJY7Fd1HfYIm6nvnyRO0BXMN3hpRyGFkKrVNdI8UP5qwQKaGNppg3IybzADExN1Cnpg0NiUCveZRSP1BYFPz0378mJO5dR5XjddwjFMVXc60ZWC3ReuNCcwhLYM++3xX+aAcnB6zdnX8CW0X+gvmJ5RzXy728YlOBf3TyRdW6uwH9Psca+tBDzLBwYA5gIhgJbVHxneJ99JK7ixWIfCX7R9zUyjgZHM10LtCRaqz5at327f4ngNkGKzif6ZbH2xc90STznY0GRPUnvj4ve3Avv09a7yNR/OURlm58wC8U6Bz9HSrycdTjQpxrh4XhaCx7AGVovZWSYRSlJP5AMk1yQopewjr3xYz577DOE8jZmwvVLhwxytqgvbFsLzYjb+XozjVNwhOwk4g2JCyEgBXsnWhVLm215QMZoPSkJSMogDysUKA9ekUEI+n51B2JUcgts0/x8lU8jshE+44HrXjPqdDXzePhNYT7M8rAPXi1qQ8WSvc3q2f2q/zUmRLc1qDPPlxTJYU7c0zcm/KSTX5hW8c2ujKvXICcdttJW8TI1te1b7we3ftg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(451199015)(1076003)(2616005)(921005)(6636002)(6486002)(316002)(110136005)(36756003)(86362001)(5660300002)(6506007)(6666004)(38100700002)(83380400001)(186003)(6512007)(2906002)(8936002)(478600001)(66476007)(66556008)(66946007)(41300700001)(8676002)(4326008)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dc1zYTFlJFTEs7lJCK8oYqDCyIUg6JCiTEg0KACjF40Lmht1yy4t+zT6Squc?=
 =?us-ascii?Q?lLYkydPDxpHhJXvR8Pk3S2f0zmz5kyVr3XgMeK/HNNt4lwbcZrLe2bazVFeA?=
 =?us-ascii?Q?o1XBzam4ggV/rhyczT4tjvuUNbchMaAmjGZyKzRot2hIpsPSnrjbkf7xLsXa?=
 =?us-ascii?Q?sxIQzZ62GUgUqCwO2zXFRTTOly4w+0cIO4KVEdfdi4mCBm3N60uajBQfmNma?=
 =?us-ascii?Q?0u83KeAYR8IF7dINqfnq5/lJEsflhXwOubpgqaT4aqeLwAew7Y3L/pEawj0y?=
 =?us-ascii?Q?wgq3/a0UNWQL5BtZRJ8RVoKq6q3kmDSt0TJsd3fDov4Qtnzqobbd/HPB4u+E?=
 =?us-ascii?Q?e2+wP8ValifftKScxwwDygmqUR9SfXdZrIf+uNbBQqXOMW3PzaXBjHl5ZaPn?=
 =?us-ascii?Q?AQjhUWhbT3nNbzokY5qbAtYqOmFbuUdUeEGHtAavgfQnVlUUJGVsDADmabBs?=
 =?us-ascii?Q?3RcU74w6nh+ZGjm0dwYjrhB+IVprIb0JErlfImqmcofP1kqXT075XW5PXHyf?=
 =?us-ascii?Q?7SNo63xW2NAXvWUi1e5RGV+1i+V3OtSso12nUCunbCUlkkSpzcXBiFtBgBdm?=
 =?us-ascii?Q?d5XMt3yDWkkah15dvRl20Fq5ltc0osDjh40JTUerxRyQ2iakVSOgbDqrgLIl?=
 =?us-ascii?Q?Y0sx0bVNTbC6vBrcPaxz09A1ydHIfzTf3URkT8fUp+sJI7IeRDnb4yoKhMr5?=
 =?us-ascii?Q?rX/SZg41r2E+vV/iCy5Hf9nlOeLHnKG2kYnf+iG0hPrpnv5YmAVygrBNszno?=
 =?us-ascii?Q?PCJapNA2sTu9DpbYsCt1G9pxkmA7nc+xiiWgdSd5hPyZlNuQJy1qOrdnrnNi?=
 =?us-ascii?Q?SNB6Zjmr1bmkHuvvOUj9d6NGfqocnFgzc8jglv95FmymktvBb29DrW9am9Gf?=
 =?us-ascii?Q?ykTkxAYAz4ObI5dX1AsFnNFseY41ED/Dsi0eIemAnxtwXecbG2m1ZJYxy3ei?=
 =?us-ascii?Q?ku8sHYqUyHk7yDGGsVdspDvl4aa00XvHjB0+XNxaBnpPm1s8WJWgb/UREL06?=
 =?us-ascii?Q?3EbPIiRgEPv4XQ+JDHQZlFPne1GfdKYgeDC/93znVmknHHaqsJaV0wH6Kle4?=
 =?us-ascii?Q?+nG8zopzwsPPdC+vwC0uYeKvMIAmHrm5h65i6nq1cC2UEbC8RPraFyKNATtS?=
 =?us-ascii?Q?ks9BsakA1K7TrZRtkbjzyvGvXEOB2E3c5b56vi7U3KwDC3BHJLFInsi4L6KG?=
 =?us-ascii?Q?RNoqAm/g9va2zLjWaVJ/PZSoFQ6euhLWRZQcdAtz63huHPRvxUyUfTJkVe/H?=
 =?us-ascii?Q?5Wkda5H4UCTJiKXVc1cOlbxdeypggeIAiR1NplmQJeYPEYLuqJVn9BiNPmYr?=
 =?us-ascii?Q?RqFn9lcpbrLizixV41t8YhiUkmFyJV67tZgHOoIPLNN/HgjSOYwe0ciXd6cR?=
 =?us-ascii?Q?1VPQexJGSY3znFTFjjzN+XI1TyxPeciXtRofMB8HQJfGHyRkVRZIDKP4aTzj?=
 =?us-ascii?Q?AGKJmye11b3W3P9+sf4jRgz2K1Y1o6itii4vXYYW86NUXLye0wQQCrNofsyZ?=
 =?us-ascii?Q?05gSYwt8jwdACoGIrOmveZzRipVTzsqgjQ18RmHC3SXf6uxybRww5h4FzFXK?=
 =?us-ascii?Q?pcRPEfyRJioIWAY9++YRK/pA0cp1QerwjgdTR6/JXfhfs/gB70XSe9BRDdXM?=
 =?us-ascii?Q?kZefUzbC9yTdFvdOyASkTzxyjunJ0g6LHbh4cq7jts9qFiQWX13ckTCQfTC+?=
 =?us-ascii?Q?POtRXg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef19b397-e2d9-439d-2593-08dad4a215bb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 20:16:24.2129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oYvg2BYRoiF+MIN/XtstzxeOiFmQfuGr6wW5BcEIzJ3Cp9Mdx5R5reyc3GaTuEhah5a1Vx3HMJcvnYk/Ne6zZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7308
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

.getfine gives the driver the ability to report the frequency offset from
the device. The frequency offset from the nominal frequency is reported by
the driver in scaled 16-bit fractional parts-per-million.

Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 69cfe60c558a..4ecf67f617c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -326,6 +326,40 @@ static int mlx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	return 0;
 }
 
+static int mlx5_ptp_getfine(struct ptp_clock_info *ptp, long *scaled_ppm)
+{
+	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
+	u32 in[MLX5_ST_SZ_DW(mtutc_reg)] = {};
+	u32 out[MLX5_ST_SZ_DW(mtutc_reg)];
+	struct mlx5_core_dev *mdev;
+	s64 delta;
+	int err;
+
+	mdev = container_of(clock, struct mlx5_core_dev, clock);
+
+	err = mlx5_core_access_reg(mdev, in, sizeof(in), out, sizeof(out),
+				   MLX5_REG_MTUTC, 0, 0);
+	if (err)
+		return err;
+
+	delta = MLX5_GET(mtutc_reg, out, freq_adjustment);
+	/* Convert parts-per-billion (10^-9) to parts-per-million (10^-6)
+	 * with a 16 bit binary fractional field
+	 *
+	 *    scaled_ppm = ppb * 2^16 / 1000
+	 *
+	 * which is equivalent to
+	 *
+	 *    scaled_ppm = ppb * 2^13 / 125
+	 */
+	delta <<= 13;
+	delta /= 125;
+
+	*scaled_ppm = delta;
+
+	return 0;
+}
+
 static int mlx5_ptp_adjfreq_real_time(struct mlx5_core_dev *mdev, s32 freq)
 {
 	u32 in[MLX5_ST_SZ_DW(mtutc_reg)] = {};
@@ -688,6 +722,7 @@ static const struct ptp_clock_info mlx5_ptp_clock_info = {
 	.n_pins		= 0,
 	.pps		= 0,
 	.adjfine	= mlx5_ptp_adjfine,
+	.getfine	= mlx5_ptp_getfine,
 	.adjtime	= mlx5_ptp_adjtime,
 	.gettimex64	= mlx5_ptp_gettimex,
 	.settime64	= mlx5_ptp_settime,
-- 
2.36.2

