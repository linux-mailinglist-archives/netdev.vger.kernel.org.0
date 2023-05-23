Return-Path: <netdev+bounces-4807-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DDD870E6FD
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 22:57:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E54C01C20A68
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 20:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE280BA3E;
	Tue, 23 May 2023 20:56:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B15A958
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:56:27 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F590186
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:55:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8+s654KYOjySusDJ73UM7DQ6afYG32Gcwu/AzXbqJO3Ao/7JMVHsOTczxjmR/vstVDAdBIeuuetcnmZmmG+9q7Fr8x3fElOF19voFBWHSDpi7K+EAPQod6ImeY0kxvLotjqbjtbjWec/zAVQPz4J6/ZMmZ9n6OSafD/Rd08t9+8BI+mKMYOgUoNJX9oUA1fllNIs3s1VNk9Z7CjDEamz024zz685g7+xpD6ZnvwfPQF4KUOTXLhZVD/hEbBEtYokQWj3Igayr1bUxOzhVSounnb+JkzgqS3p9IgvYuQDjdQjUFGSvv++fuDtNzqegWKA6C7Tp/Mv4rbNbsrD0wKAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5HJp3wiVtMq4ICjqFWFw/dI7l939iD/xx5s18c8SOg0=;
 b=YU4PNW3AqNkNn40CLy5Ztn1TA0fAdhBgzSYymPj5QgDfVknkia8RjXsk8u+orNGlsUhkFW6cUUTjkvcIT22DDIgFNRCbB8d5TN3Xk9+eqnb/X27x3mbneTQoCO8zmw08KPbyDWmcs0u/HLygDHfi2lpvbfL2QlxZXuglisdpjKMTZyGnbuk5okvi8yxvunor34lmx9pw/PJvNOzzki0S+YXGVTe6e8SGJnD9e2HkS5tLPLO5RcVKwDI8YQh1cGTDUHsZDd6mvklis9xHum2C1xAxBYnFsYlxzK9+MkInk8AyLyPwPJzUFLnURdBOOVeKAI2V1A15gDuSrlw/VnCZug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5HJp3wiVtMq4ICjqFWFw/dI7l939iD/xx5s18c8SOg0=;
 b=aihNk0nnMoC1EvUk+sKtASjneV2xx57ZUMTtuDk3VYUsGSevfQuHseV/W4Ovo/R88kMEXWHjPAn94T5QFahNCU5lNkrnJg8FfKmfmkIY65lR6GbPRkgo0447xkkZ7uONlZZck+OaRUIv3W5hA0pv+T3Hd8YES6ERR2Fvj3g6CTgExzcLMp5ymNe+qRNpU6TISk3NI+4aUzTx+eW6CwfZbZAOMYS4BQj1dB1bHl98vbl3pbVmoCF7OZT293wYEKCQ9mwYDiBlkwCSLm9wgR75OkFO8w8GMP9llxUXwT1lw3pQzNkQGWYaTUdXQrHeVYUBPl1CdfbLVdSQgODJmVi/hA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Tue, 23 May
 2023 20:55:48 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1%5]) with mapi id 15.20.6411.019; Tue, 23 May 2023
 20:55:48 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeed@kernel.org>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next v2 6/9] net/mlx5: Add .getmaxphase ptp_clock_info callback
Date: Tue, 23 May 2023 13:54:37 -0700
Message-Id: <20230523205440.326934-7-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
In-Reply-To: <20230523205440.326934-1-rrameshbabu@nvidia.com>
References: <20230523205440.326934-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0041.namprd02.prod.outlook.com
 (2603:10b6:a03:54::18) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|DM6PR12MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: c225432a-4cb1-4796-d5a7-08db5bd015b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Hy5ZmWlmzYAyHhZg8QD9gb9xK6BHR6nz3BVK+8Ch9ZQej6ctUNTIWBzlU9RSduu2LbNlLGKZ8jZT8SWj9OFAekr4TA+mswnBg/1iX8UK6BEgbfp/debDGmYs6bsF/ktAL1oHejp/MYk0poXKWNUc8yB48Q19rKWsJkbReO8SDFiLdoIPWRckzndP04HE0VrcgDVz3+CEU8DC4y+5zWnEZ4CAIAdhYz+3Vidtrb8vnutoZ1zw4u65a0QT9OhF/GeWlm0qqTQt1lORnWaM2SL0v9wBIHUvrpw3prgEOLNSBX1SLWIEwSx9dvEUL77ibsdi6l3PZME364Pn5ha3W6m8ddjAIUabGwp6J6ttPv+FOS63JgHBue4oD9UejZ9RsBPdE90jk3vvxVZYrtNsd5L9pyyVtdRZu1rBih7gBF3NSiL2VpDwLHLznJSaKZUoyHB5UzAcFTwIFWbQza5XyPjNfN6fWNalCrWbDfEKOt/qlrXzbqlvha2q30bZTwuvZ2IEPF761TMw2YoaDiGQSWRSvCiegx8u+7S/v1mPJhzI/WJkeCEAUH11DQPFfb/5FeFeMNtOgrLEGNpUFK4wk3Am0ndz/ue/SM9FJjYiECZ8WEo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(451199021)(26005)(186003)(1076003)(6512007)(6506007)(2616005)(36756003)(83380400001)(2906002)(41300700001)(6486002)(316002)(54906003)(6666004)(38100700002)(478600001)(66476007)(66946007)(66556008)(6916009)(4326008)(86362001)(8936002)(8676002)(5660300002)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mcg30WVo2F7gPsd7no9WVoeyjX5RaL15HnZJmUBdyABbUSx9XAgtC7ll5dnE?=
 =?us-ascii?Q?ZNjfZp+bTMJqQ5wQ1rn9M4Xjc2XgSdk/yuea+mn+1gRhhJOC4JqbSd229Sa8?=
 =?us-ascii?Q?QVPp7cK3Xbq8LKnnSCgw+wmVakjLt7/FRx0R40wQLYpQTQBnv+KIrMtUEW5+?=
 =?us-ascii?Q?gg1kiveOqBwrT+OPQCc6f+fqCeZop2VQ/ee+XybiuNxLDah5GZHyYPPUBywA?=
 =?us-ascii?Q?YW6dawogJY412ItRg3IWhpIYlxbFKjaHzSepVKD86g5YFfrKkr3HzTjdYIxj?=
 =?us-ascii?Q?bgp/1d2nMwnm4LQ2l3FIi6UUvNu2NnxDUlgQgHVKz6aO66q8byrO5+KweT4W?=
 =?us-ascii?Q?iZemE0SrM8IUCoGYFOKER/LZftMtsb6xSHp3wAqJ8dzlWCUnIkwrJKHnx3oe?=
 =?us-ascii?Q?TOK9u/ZnkWhLQi45ETfD3YkczWYZe3zVIViUn3+3AozWK7eiPj4chHhdqUFX?=
 =?us-ascii?Q?YSwqYHdR4Wwpy6JIOuTYhNulJMQTRgCZ/RENWQ9YxnnaZFV4ctl/DzyXKFZr?=
 =?us-ascii?Q?qCiPJ2WUxdf3DffRSaWSk1xFdvwlk1X88xwiyA4XEicT6HTr0rH5XlIWk2fI?=
 =?us-ascii?Q?y4neCWd5CUSW+E+XDpxdtigyerab5EuQu3VgHxkUjyFN50mWIttqNj/rtm6t?=
 =?us-ascii?Q?qE7/sWZ9Cnz4p0EnQsr+ow6ivxdDfggWmT4zojDrQkxIGd1FZm9jC6SIjQWE?=
 =?us-ascii?Q?CIzMgXIO59W3AmCkjC2ZjpawSI39i25CqkhHtVh7KJ2xn3izFMHv0puHasDN?=
 =?us-ascii?Q?AOaGVWDH1W5u87vPClmp0k6IL2Uc0CJkAIkeTOKCNOno9A/USMw29+JQhARC?=
 =?us-ascii?Q?qncGKrn6BhZy4eO9zdNh9Xo3Cnjs3h6ndmwlbseEBQ3ElpsQgnAQudjzS9g8?=
 =?us-ascii?Q?rHTEjSgXx07gI/sAAJzWuiJ1Qe5vYMlkTzp60QaAD1+tumpxGutGYtHlDDqw?=
 =?us-ascii?Q?HwkjV0AM6W3i8tj2uvBrrKHaa8dAhyArsV8Fs93uDb3LpF5HPg9jVM3Cjbg5?=
 =?us-ascii?Q?c79mLKXbeWjkPw80R9XiiHirjvmYrTFySdXxuDRPNlXq1BkUcexdMaFZo5mJ?=
 =?us-ascii?Q?5wi0n24LRX/xdjuGgxILkAZ4N8BTOAPCnF31kRw+51u9XgynHgZEXuJus24q?=
 =?us-ascii?Q?Yx2a4w1saZd83vxpTeSapYfrcG6Dl13nD1VUiT1ylIIc73KtPgOXoO4tYHS8?=
 =?us-ascii?Q?3GWSV3irLfU3UzPlZbsoPwC4kAwGVNDidJmg9C9L8Fp9/ww2KGoYaittHW3F?=
 =?us-ascii?Q?BBLO+nZd2s7RlsFyCnpnuiilADiTDW9KzXKoR0zof9ZtejERoL4dVNeprZnu?=
 =?us-ascii?Q?n1l3YVv/u+7J2czBlqJK3BDZboLwokxBu8VDRS95fRdJnNa0rCE+UPZ19Htp?=
 =?us-ascii?Q?fQe0F1doPZmCxgxs3NWNtJP3+OBLd1twX/vQ+cvXXVkvKI4+ua+WvDBEZr/l?=
 =?us-ascii?Q?5MigjdTafLfkPpMJpXZshOnET6yKDEVuylfq86rYEsqxML6GyTwu3LC+Fw+s?=
 =?us-ascii?Q?UnWq/cYQSPDjetG7OuC/8DNaqZAd/v9dCyLcD7OSnhE2n0IDFqt3hVDY+yOj?=
 =?us-ascii?Q?kFPQDc/k1WcmvunTG6bsetDCGFAbM6D8PyDlJ4tcE5N/sS8QKy8VJwhleOoL?=
 =?us-ascii?Q?VA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c225432a-4cb1-4796-d5a7-08db5bd015b7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 20:55:48.0434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IcROGRs+k426nV4kyfJhPeGYRrdixueJZoPrxksFQC7MusjyhGv9LFIf/4Th7S6StIlTCZ27Zv5qqDaPar5/IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4337
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Implement .getmaxphase callback of ptp_clock_info in mlx5 driver. No longer
do a range check in .adjphase callback implementation. Handled by the ptp
stack.

Cc: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 31 +++++++++----------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 932fbc843c69..973babfaff25 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -93,17 +93,23 @@ static bool mlx5_modify_mtutc_allowed(struct mlx5_core_dev *mdev)
 	return MLX5_CAP_MCAM_FEATURE(mdev, ptpcyc2realtime_modify);
 }
 
-static bool mlx5_is_mtutc_time_adj_cap(struct mlx5_core_dev *mdev, s64 delta)
+static s32 mlx5_ptp_getmaxphase(struct ptp_clock_info *ptp)
 {
-	s64 min = MLX5_MTUTC_OPERATION_ADJUST_TIME_MIN;
-	s64 max = MLX5_MTUTC_OPERATION_ADJUST_TIME_MAX;
+	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
+	struct mlx5_core_dev *mdev;
 
-	if (MLX5_CAP_MCAM_FEATURE(mdev, mtutc_time_adjustment_extended_range)) {
-		min = MLX5_MTUTC_OPERATION_ADJUST_TIME_EXTENDED_MIN;
-		max = MLX5_MTUTC_OPERATION_ADJUST_TIME_EXTENDED_MAX;
-	}
+	mdev = container_of(clock, struct mlx5_core_dev, clock);
+
+	return MLX5_CAP_MCAM_FEATURE(mdev, mtutc_time_adjustment_extended_range) ?
+		       MLX5_MTUTC_OPERATION_ADJUST_TIME_EXTENDED_MAX :
+			     MLX5_MTUTC_OPERATION_ADJUST_TIME_MAX;
+}
+
+static bool mlx5_is_mtutc_time_adj_cap(struct mlx5_core_dev *mdev, s64 delta)
+{
+	s64 max = mlx5_ptp_getmaxphase(&mdev->clock.ptp_info);
 
-	if (delta < min || delta > max)
+	if (delta < -max || delta > max)
 		return false;
 
 	return true;
@@ -351,14 +357,6 @@ static int mlx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 
 static int mlx5_ptp_adjphase(struct ptp_clock_info *ptp, s32 delta)
 {
-	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
-	struct mlx5_core_dev *mdev;
-
-	mdev = container_of(clock, struct mlx5_core_dev, clock);
-
-	if (!mlx5_is_mtutc_time_adj_cap(mdev, delta))
-		return -ERANGE;
-
 	return mlx5_ptp_adjtime(ptp, delta);
 }
 
@@ -734,6 +732,7 @@ static const struct ptp_clock_info mlx5_ptp_clock_info = {
 	.pps		= 0,
 	.adjfine	= mlx5_ptp_adjfine,
 	.adjphase	= mlx5_ptp_adjphase,
+	.getmaxphase    = mlx5_ptp_getmaxphase,
 	.adjtime	= mlx5_ptp_adjtime,
 	.gettimex64	= mlx5_ptp_gettimex,
 	.settime64	= mlx5_ptp_settime,
-- 
2.38.4


