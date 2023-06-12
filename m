Return-Path: <netdev+bounces-10239-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F46172D315
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 23:17:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD0861C20BE1
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2B1022D69;
	Mon, 12 Jun 2023 21:16:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB7EC8C1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 21:16:24 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2045.outbound.protection.outlook.com [40.107.94.45])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A3E4EC2
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:16:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWBtKc+0FK68Hqg7KUtmdEIYZNN7f0L4ciZMjplUlvH8iJ2f4waLqfTugqYtVvhcjpsJ1w011MCK+BE9rpt23uBivsPRgbtIne3dewPbesNNdHUmNcYzv91DQCyzDTlfzBmdtPlszA45TSpc8RBOO4nIDGMusGJKwFRufOv6xvF4qnyxfUJ2oPZLsKMzOKRIjJwnuI7jruuDcNrq1zM7H9jwgtJ3stuCXJsM9T8q+CL+ebZjgKLagUhJE3lwr1Jw9nJEUVkKwRjLMKJYXoirdQBQ72yb5hAngjCvoXjOlH58kcaWX35xSB/GKSyORtalG7ucJBilUtebDwkzucCg1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KpPFD7TiIrwKK2gu8iRaUxgs28ouw1CuUUH5mmbGia4=;
 b=MT2kZdP1w9KMHOLmClBz/YjoQDBdmM34YqiVW//tmaOD9G/0zgdvHulpmJtjdICUZlmTmtZ50zfBznczsnlCYxA3M57XqyyCXHnohQjIzBuKWHpmQZy4v0iMIUMaGwopLaks5lEHNBOlIptkqRaNi5IeqOOO56CZ3u5hvRPom7MahUcNtWFFURF6ekefJGMItURSCMd0XUZERXBPqHe7rcSaeD2Q7HKgOyHJ3ZxiriEinh700k/K/DmIR19NM/c7cttARNVD8W/k+NAhOWOY22yF4PZWJy1sSZHfqRP6+fU5zxREEBzNLWK7qqJfOAFWqi1Sk8jwodTeJ69Tz6b2+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KpPFD7TiIrwKK2gu8iRaUxgs28ouw1CuUUH5mmbGia4=;
 b=PjIoLx33V70xAsjTU1RE/Je0k+b5tyB0CyLyb57q7swt1gJbhGb2nnmLJV5l8pu/IpNbDFXdHRWae1Cqw9o5z4L6Lv+2yqg6Ov2UehvsEUe6aTOjx2f/enA1lAuT2zrYzkegetUP38a9q5+atfwVy2ftYG7vzDeIR/e5AuosRPeP4ZZeB88yblMJkB5oYOXfr+m26usDk+O84DY1TrLPqZfooY8n5dn1A77oZgqqoWbJd+Ot1VdiD9tHPcS23sn5wS2TvpeUDm4+06jAr3potugetUAJbay9/hueGnQ0UW1QcfYMUwWBY/9S+3hh0m5e7uJlHntaU08nNCt9+4+HCA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by CO6PR12MB5441.namprd12.prod.outlook.com (2603:10b6:303:13b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 21:16:02 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471%6]) with mapi id 15.20.6455.030; Mon, 12 Jun 2023
 21:16:01 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: Gal Pressman <gal@nvidia.com>,
	Saeed Mahameed <saeed@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH v3 6/9] net/mlx5: Add .getmaxphase ptp_clock_info callback
Date: Mon, 12 Jun 2023 14:14:57 -0700
Message-Id: <20230612211500.309075-7-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230612211500.309075-1-rrameshbabu@nvidia.com>
References: <20230612211500.309075-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0052.namprd02.prod.outlook.com
 (2603:10b6:a03:54::29) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|CO6PR12MB5441:EE_
X-MS-Office365-Filtering-Correlation-Id: e6538b21-7955-43e8-de13-08db6b8a3974
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8pGwc/r1OJmlkQ9Ot2odmzRpTRfku4hfnRk0OfxbTAYWIb7tn0+PEmabBfaRXijwP921ZQoNEmof4t5aUTQnLqy8OvfGvVWXiWDBwZP30y+pi28HlMG0+MAc5kHVs5/1Wix9WRsMCb3CnxNS48VgkGrdaEFbV+sxLNRGkRL/Isdj0SvBAQ/SlcU2ig/lYj9c/OECnOgDNNzMMCDUM1ZGOujyYZgMPS4Smtt+YhIevWPGzSWVVDxAaMTnpUYZ1O+Wmy/6SZ4ZRxK48PU649X7JO7Z7esaA6fbKB3Hse5HFmVcNk1MU2F3CeFAj3oyy8jTd9BT4UIrmwrUyndP1OIEL2uJFDYAh40OfdCbmyR8ylEpjJ5sFDieZp5+3v2NuGJV8B3jPoq0+zBox85kDlEHucipnKdD9z4g5L7E52UXIDocrd0Ulp6zj/TJs/a/mWeMyqf67GOUXrrc8YJOA/rqHx6AhugcIq+z3v9b4qKLK3GzJY1gcEiydlO7oTqQtqGH+TdOH4Ro6h4Zc1PARvdz0VAMkQcazc50SRXXNY0pFVoq68JeF1ZcAlR2DLg+AWRGlpdTcqhSj4G47zzbv2jxGJ4FeA/jBAaN6xzLYGaR7T8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199021)(36756003)(2906002)(86362001)(5660300002)(186003)(83380400001)(6666004)(6512007)(107886003)(1076003)(6506007)(26005)(6486002)(54906003)(66946007)(66556008)(66476007)(4326008)(2616005)(316002)(38100700002)(6916009)(478600001)(8936002)(8676002)(41300700001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jiiaEPVbTc8CsEexgAJ9/9/uFGzM4Na4Q6Vv/heiN6CxbXZqFflz/sjcgwMq?=
 =?us-ascii?Q?g/HZmoHBgXZTcqfSxdgTYFRl19+wNOnmxuPWLDR708Mk85vEadoOLmKefZtl?=
 =?us-ascii?Q?MqQWsTucbhVBSZ4/LbwDY7/38faxi0mziqS2Phi/lOxXmC1oAHngMdnohkEp?=
 =?us-ascii?Q?hVa2+UOSwescpS85vFogcw5WiBcKSXFmd6TyRk7KBg3qkEi4912Izpc2qU1a?=
 =?us-ascii?Q?o1fYhAhPEoK3gKVklAfl1rD09mg6xy8ieyesK9iDifc/pm0HDTQk26J4xQcq?=
 =?us-ascii?Q?jxx7UAd+97dUSOZVxq2tAm1ErAb5zOE2cEXf65DqsWoqHZlqwpTvlM+Tz88b?=
 =?us-ascii?Q?mjb2bGw8VNzjyLHU+p9WMh2ix8nrmEz4M/s906ng6GLZRnwUTb/jRtsaYyf7?=
 =?us-ascii?Q?M2e9ZpURIWGDq5X205421Y1tPjvXUN7bmlyZcoFEAFIhmDIjBIjsYuxcnYjt?=
 =?us-ascii?Q?bRugm8IRa2OuJf6rV/ibzErj6/kUlnR+XUNIi0RwcMdspJ65mSMyCnNriKUE?=
 =?us-ascii?Q?MtnyyeZZyW++Yp/DRuM1AusfIrkGcjjCOQUqWdTzXbIJdSqNOdIII7zIk3gg?=
 =?us-ascii?Q?eqSTR55aBjA/JeFFEM6dM9489i2J1nbGsYyVJqWnz/BsdRRVZlQnIbCXn67u?=
 =?us-ascii?Q?xndzuByJb/kpiMuJYIyg/hZa0i4nG2J5hOsXE6PoQmYN8xFt3WEJdzL8MnSV?=
 =?us-ascii?Q?YwDgblHMb2GA2BWMV3fzk3uYV91syDzX3FXDrbSzmSGiS89TFxw774vWai1P?=
 =?us-ascii?Q?A3mfutif8IVxIFooFcxufJUvU8s517/1PXmV7TKlT1tSC1mxhcIADcK6nnI4?=
 =?us-ascii?Q?zlxro4YDc4Iests2Vg8YHe+tPDdNaf8oMOOOFh/fRE8t/NYcl10h2MHAw4Vd?=
 =?us-ascii?Q?ugS9INF2knbMScGpq4utkYNpfhkohLtpn1xA/vV0QGEDM6xsihoGWksAWMaJ?=
 =?us-ascii?Q?xjpeTGleqCMVG4i1b+k/VNfZC+C7kqMLlHu8bJKlYNSVh8lVso3UVLIJckCj?=
 =?us-ascii?Q?mNRlpBvA63suhK5qwKbY0B4o520NWnP6IAFw5ITkTlJT/kMIB0oSf7ig6O9N?=
 =?us-ascii?Q?LdLoHMVvP7r40mWn/5Gz6eJCs681xyX+kD2Q2Mdj1Tggo7bgu1wQLC+litsf?=
 =?us-ascii?Q?W/845foAUcLseMGZne/rrL8R2SmBBi26oaT6xHYiOk4ZUuwIyqnuwrmHMAeX?=
 =?us-ascii?Q?58Vnxr1eJI6ByyivTtWMM7fTUsenUE1JyWWjiN9ihfYk34e7UGicS0wdYSLT?=
 =?us-ascii?Q?notymwGYcIMiv9UkDvpWGLLtOv0Z86dFDPQ/dbzuSijO2GQu+ZPK/kGNpdMd?=
 =?us-ascii?Q?wpZmPjGoXRB6OBWEz3uZteE1vHnn9t1EtNmxXUWnGvcsaOvTZJf9T5VAb4Ms?=
 =?us-ascii?Q?fcEhXd6CxV8pTiC7hfhwB6MLc7AGguSRCK+hwFLbQheXH8JTJfnQYc+v9JUy?=
 =?us-ascii?Q?A97ervya3sVYLkoXxKzx4VAMRuMVFKgUXj3TST8BIiGu9kYQWyal1NMeZsaN?=
 =?us-ascii?Q?ntdZznBfoNJ5lIilXsfum7twqzG2TeQ8vRyNNpv9HHVMvgAU6Ag6fMxijazw?=
 =?us-ascii?Q?/e79MgFE7afgPxO8oB4K6qFcWWEpa+M5TthXmTLgTU6ICrLzqgaUIEIvAkon?=
 =?us-ascii?Q?jw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6538b21-7955-43e8-de13-08db6b8a3974
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 21:16:01.8420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zik1uUt46jUcG9Zh+X7lhu3c6Y9ieNug8XdA9yamTMAi/CHNFwlUrvHldJDHpZxEh/h16ywQ/+SkqcT3zFFjSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5441
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
2.40.1


