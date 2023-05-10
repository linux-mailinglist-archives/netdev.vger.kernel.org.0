Return-Path: <netdev+bounces-1578-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D61876FE5DD
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:59:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90FF4281415
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:59:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D7B121CEB;
	Wed, 10 May 2023 20:58:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC1E21CC7
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 20:58:45 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEFE30C2
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:58:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qbwqs+WOjZnk+KSM0AdpdclLJuTEYYvK4MxIda2BUYTZi7/Tb2Mt4sHf+C/Og0CeZMIBKXpyzuSOgcKg1l/ttmkCYdScmw8/LAM5SSkhpVIyur6j0UYWrbn0Eyw7HLa+TR4hpQzNmKLG2YChx0B+3NiYQQCXhfmaq7smNiuAtgj+yOmN5Ugmt6dyAfL7oj8cKQWxxmwcFf0MfUX55BwFGaIEiWDsCtKuWl149vAwO1chVLaWHzej93wjuSLT3pgMm3Pb/ETRw42EwL32hXJIacrhuQAgKOPTfk7G+4OW81beEO8eAvZjd6XK3R9vDgCdYo/plf8wNAbjFKkoeh3khA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7eOXSrvp6mpv9XNszhtfuvjSvM/f8WbAee6aRo0U5B0=;
 b=Rjpvg5LxriS5JRKe6uAbOdYJzrYPZMtPfwLcla45eI4vWxvqN1wTxtpDEefl0j1vHJXeMhWD+G7BEyATohefwvxz95z+tkpI80XW30MtHC3WFFQAwwcfva5+CVXrdhVCQSuA2Au7eAbDLpDB9BMT3Sb5bcTuOPWwQiWzezgz03T85ffi7/GoNanVEPzvBOHjcA/FNzSgljmC2UsPQ/TXemLfxM7KMz+TsL6iw6MCulB9CbX04ozz4tkg7YVG2Z5t+7iloH0Mr4HgKh1UM1doqx7RuZKltUwWv+zYyR1zqAmWj8/dSzUjDnHnB07+jnfJ7+XAJ2db6IIrsRoL5R/TeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7eOXSrvp6mpv9XNszhtfuvjSvM/f8WbAee6aRo0U5B0=;
 b=hm8emj8qdUGZ3QhZM6FvGorZsDstw80EDZpONf/uAha7cT8TPGv3ZkUAuWQXKucNRl/g2yPuAqh7qeT6xe8zN4N8K02Z+S8omSvS9TbF1LaW2Zd1L/M6CI5WS0bfpGfHCne3+HZ39n/HhhIEf/7oPv2rIb21Bc1GKtl5h80hPEIzYbIAYYciPukI5JRob3dCg1/0bblrvoRLgUDArYNmzYnHjepDou7RJ/nw0FNGGRSSeO9BlFrRev0l2SuP0W4NTK88ymyZbzf1rqZ8tX/k/OE9si+H77JgQzoxOirqOnemAHwINDXIhLeXrMbUDHOA+rXC4vmlapAkIcwOdVmEzA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MW5PR12MB5624.namprd12.prod.outlook.com (2603:10b6:303:19d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Wed, 10 May
 2023 20:53:58 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861%7]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 20:53:58 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: Saeed Mahameed <saeed@kernel.org>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next 6/9] net/mlx5: Add .getmaxphase ptp_clock_info callback
Date: Wed, 10 May 2023 13:53:03 -0700
Message-Id: <20230510205306.136766-7-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
In-Reply-To: <20230510205306.136766-1-rrameshbabu@nvidia.com>
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0021.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::34) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MW5PR12MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e15d3f0-3d68-4dfb-feb2-08db5198ad08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tMBf9JygYpc4cWR6r/wGYtSy/XmpV78BSt9xN2RRr3L/CF8x8qxcf+2Fg+6a1Xxi1rUSxNagCTZv81MhphGt+ouG4djx3F2bv7os0fwoBAILOut862pIg+DlpriFEO362jlGyUaeiJE3yUtftCJiTAR2E9yt3ZdjC4ubPEAfNhYnZ8GGHqXB4AyHXkPYOWe0m+6e4dkW/WmsW9SxuibELl8vekBuX3luByvHLF5vfalHcff8AP6Xai1t3Cm0io9so5UKRfLrI/7R44A4fdslLzb/hTS4DsUm+NqrcOac9zgh1G2/+mv81mpNprlQjDk3XMqBkMYylILZZWLq/OJkZaZLFZpAm6r9wuuZ4OenfMsnwYQ93wHqtaBksxFTLdVPTjZoiqV0KLjLYsr3Z8GcDrm4s4/TfWAsvORR+Tm1e6NSadJmokIeJKQe6YFj/qmWb/DhpfPAwY3RRM8WUPand1rHcwDxfVl4NQJgRKayc1ktL/V5DKyNgfGYQPFV8zlEBaYj7z9WDwoTY7RwVDYOtr7C5BZKy3V8tWcKMafJT9w4s+MoRcZCn/gK+P/G1fUsemCcgH+1j5GsHBpbE3GR3znqe1rytTjvfgcXBNIhjio=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199021)(86362001)(5660300002)(41300700001)(4326008)(6666004)(38100700002)(316002)(6486002)(6506007)(6512007)(26005)(1076003)(478600001)(54906003)(36756003)(2906002)(8936002)(8676002)(186003)(83380400001)(66946007)(6916009)(66476007)(66556008)(2616005)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?livtg/pVVbQDvGx3Ec01v/5sJNiPHHBrzQ23dpx2hOEIBVxcq108JDehfgrs?=
 =?us-ascii?Q?Ry7bx4Yhunx9M9EjsAGKYNkLJl9MAdoaxqfG0JanZI1Q1ATIGZZwsiBjVoDM?=
 =?us-ascii?Q?kK3Jv91paYD55wpJSSlS1FQ+XB68U8hRP6ynUsCmgORKuC92g+CG5O/5hxqg?=
 =?us-ascii?Q?9XBRmpNU6vU/6JNh3pLABS4Az0q2SDsA8x7YMUUIuejfz+1hoDTRj+RMCwWD?=
 =?us-ascii?Q?mf+GvU63gZ72KVAp/TU4F2bhG4xk9scLCynz69VOe5UamfYAFfY9X4bsM6CG?=
 =?us-ascii?Q?dKqGxNNlxlXXDsrj5volkNbvmg/H3/+ZIRDrlNUG0SMdGMqygm8pMZI7xY/U?=
 =?us-ascii?Q?xBwlQAiwjOOMC0H3gror4QiVgDVnPLRuH/Gbn1w+F1xm9Z+419i0PxgaPtO1?=
 =?us-ascii?Q?IqzB2e85FjwMHUASbAjeUxQu5EWi3czZU4PkzU5/C9YW90tqVMntq+QFSLFW?=
 =?us-ascii?Q?dkKlnCoTAbaHkLFUOwmKcs9syGy6AFN7gGAAHfgck81ZbI+itQIBYb3wUgSB?=
 =?us-ascii?Q?3WcL39vCba7oxhGkbaeopgGDClhzl5YCrz6vczSR4nrH1DUErPNasjDXSFsl?=
 =?us-ascii?Q?i7dSlF/9NSeIMj8SHbsBs+h4lH8CsZXJMlBI7jFBg76DylNpF15HICMj7M5B?=
 =?us-ascii?Q?H4MgnNeHe2rRYYPI5RIJMa0fGnwtO7MyUNDHmlqNfG91vgMkIhhWgkydpb5O?=
 =?us-ascii?Q?zLVZG1Rd4Bmgf8/qnrSOp2g7z+0mdU8nrjRCJHAfosqj79tFsQ7I3U2hvDP6?=
 =?us-ascii?Q?r3gjZJMGG8L0vZcNwqUnAlO4J58SwZ74kPt9fqWgWXomRxm2vN5J8y8ANDS7?=
 =?us-ascii?Q?EvwCIIOIlaNJlxVYICmymfisOz7orNSgCj4kCQfB8BUnC7mgrAaywoSpC3dp?=
 =?us-ascii?Q?8K+57lLfZxuawUvcDFwwIx3iv/gw3JFQARSBa7I+DBUohRMYSaJB6tJGlUzx?=
 =?us-ascii?Q?bemLggpuRcOhR/9Lek82fcZfGurR/Uyn9EIiey0aVmDdEJOrkrslbc1bFrMy?=
 =?us-ascii?Q?lZDv5f5Sjm6FEULVSSjZgt7SExDYcNIehIO4eFfqsw+Zg2wg7pAvXomlyMSo?=
 =?us-ascii?Q?LxlFRkWzcBjtssQnEO+naKR3DNsP4HF/a8nw2W9SdJvaCyVfMLFMBb7SsEHg?=
 =?us-ascii?Q?IUk85fx2F5pGv5W69oGtxHw2VWEarRpg1yczSC+8rZocBh/zUgQsZFIbomHH?=
 =?us-ascii?Q?g9fz68chP57PyAVSvvtM0SEjysCF38ICT3X0GbrGkwGAlJ8CUb29DeAvCyK/?=
 =?us-ascii?Q?BJyJgJfWTu5OEJ/wd789GhmNh5VU7pkk3L//qEs3QmDc3iQRoLMdw3JZD2T5?=
 =?us-ascii?Q?LaQkloLeLdPMSFW/pq9KJZCkZSuo22LhoakqjQqnnrocZGvQlFZ5vHBrYcGG?=
 =?us-ascii?Q?EtM6dHJN8QHPA+mr1qEwYw4CZ/k2N9EMNEoRgu4eiqG0RqWRLDHCIutfXodb?=
 =?us-ascii?Q?Di2X6tk3i5QwHN9PXuz0UnsybZx098iyqjBw3z4q7bA58K4ZYtRwlZzXvfDV?=
 =?us-ascii?Q?pm6yqXKxsEfXhqR9C+t0D4yTJiQxrnOz3B500C+bzUCgXCEEWvMAu1Xqh1nw?=
 =?us-ascii?Q?t8BT4FP6ZMKO8EmHKk8D3JXrTytTsTrRrcrONIluboW5BZMeWBOZ/Uwzd/PP?=
 =?us-ascii?Q?Pw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e15d3f0-3d68-4dfb-feb2-08db5198ad08
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 20:53:58.4699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H9OYiI77z1lnqYq7TtTDnYmV9+Mk/dCntpRT/Z4SK7h49Wh1h9aXMMtEgzf2tKzLbtV9wKaz6oheb2lQ62d/tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5624
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


