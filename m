Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9B267D14A
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbjAZQY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbjAZQY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:24:56 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3D49008
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:24:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Np2aeSkzPaW/7zBuoK1wVxrIBvlS+VaJ8aeHUcQWrE4/KOokOYStyYf46ICjxkDxqAPsTf31WI3uLheaRFcUvpwccImJPVBL+AQIwfXBUwtD4fnsN88/s3saNwbJDNCsgrKOXhoRSZoE2nqAtSeFMcsX+ljbnrw66lnkGTJNKTcIBjspi9QYfMYc0iUBFbHbI9SrYujChmIX5pC37iAo2MnOU4tCE9cof0jnrmhyxPQmo3OhcIxFQZy5URSD7x42b+m31fmehwVryGrGTGvUdUPevkUWC9Ceq4uVv+RkzCFLvrUOuDTd8obhf/vEf2Opvl/9KwQIFAWIQoSURQvT6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e4IewiU05Hj2s0tELEgmWqWmLASDhZPV3wUJmmDmEuE=;
 b=j90t16Z2WLm0Gpi+SvWUsme+pv0kVUnYKROTveTbfqIUMKa1+/i91gJeBm56uHcYX81wz3bb7cDCOga8CPvfmqqe6/C6TYfDA/movUU4ilkWzgb1hOuzgR2VdArIJEK7nXhrmHc55B3pgC0AuRU30VnxCxKXoBMR6q37n7JcAMeVEmEWxz2hQCxDSDeJBUlP9zPBqrUpb1aKke8VfMlzIYYXJrpLHyVugVI7saM5CewdNOGEEHvN4FRZgqWoQk4ufawb5p018wewlr1NQhB4C6Z08CvRzJOmjA9PSVNi5rvaEa18yuNOb0Km1ghwkEwl1oJ926bw43H8Tjfq2Tv/bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4IewiU05Hj2s0tELEgmWqWmLASDhZPV3wUJmmDmEuE=;
 b=YDx4xDmEhPRGTiQtKBwmAr4KPyw/SREuoHhhIMXxMEsAYYvJVOu2OU8Tb5rTjeoeER1BhfY02Xw5jyuZ5mrREnQDnOTfxL3NtC46aiuTlBcvAxG7iSqRJL/quTpxVnucmB9xJ7vyHQTQ7xZlHhqEWbaUnHKk3aZjwyisGsodpZ8AYUj5nxnAsCLX7KVto7Ar0s5NftUqD1JB5VtvpySpPdaGqvNPoZ9KAmdZskdOmy0awsUNqrcxLVheujRfcbS/grZpc4DlW2sA10ubQWafOudKVbKIBBpI2GakBMbrfIr870ukCgyhZXVBGuDdkLH8UmMNBsEQ/uAshxUN9CNPLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH0PR12MB7792.namprd12.prod.outlook.com (2603:10b6:510:281::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 16:23:21 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:23:21 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v10 15/25] net/mlx5e: Have mdev pointer directly on the icosq structure
Date:   Thu, 26 Jan 2023 18:21:26 +0200
Message-Id: <20230126162136.13003-16-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230126162136.13003-1-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0044.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::7) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH0PR12MB7792:EE_
X-MS-Office365-Filtering-Correlation-Id: 17595193-ab7d-45be-f036-08daffb9a3e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7b8tsym4NlJxxxeEUyEQJRK/0YnlGQ85IJxmDNKg9+/kJGPPNhsqyHEbWqh9QdwFjROeXFEvwnXU4mF+gq9VmhNRloS4JMzJXnwAKjgUjhrxSsbhG3hIFREwHY/B8fCnxW1/ah9EOQnW4UyhJkrhsk9hMcV4SMEZh7JbiMcXd+TZhfyiDkQGdyYsGfo4nHohGJl/fI8vRr5nEOO2Aje3dYubqdv9sc7fOuM63THnrd/nscJsYpIMu55r8fSe0e3kfGSqiDNfJWv/q6EUxr924fzawP60IUfkAGuxFlDTm3X1hgWf5BicBojOfDsX4zies446k+Li0VDXHIIEfTUWydIHN+u+HsnoJAC5G50+XUPawjXG++DESyTTDy9I1qOfxwQU+NcpQIQ4RRPKiJXt2GqnMCf6Sjc9Mmb2a0jyjPmlkvjmTnj8qYCyWKD6+rMKb6B+K2orTbiud9x6uzf+iiK/R0ZBo92ZUlmqhzLZMMGD8wdKeS1xtyps76EZcTivCcBaDK+oi8aejCGVWQUPzbhmsGRzivNOlUuQAcYfZWx+X8qSaliv1o/EhV+ddwNEDAcOYzRuU95j6qD7LPPE3EgF4/uW7ZgYywKDw/CNI2Cfim4AmKTlx3Q4krewABPsvCoUnVFBCz7+x4ww44CndQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199018)(4326008)(66476007)(316002)(36756003)(66556008)(86362001)(66946007)(8676002)(6512007)(107886003)(478600001)(2616005)(26005)(83380400001)(8936002)(186003)(5660300002)(1076003)(6486002)(2906002)(7416002)(38100700002)(6506007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BMsgCI/vkhzyEa1dG6WrDTpcSVxXKvPnylEmE2YFicpmkA43leTHRP5AYVvT?=
 =?us-ascii?Q?biWVGbh7ZaZpvQI7mr19Ms0MV6CfVWVF0MZrQmxacFwwAQazwKkJRDl36u4w?=
 =?us-ascii?Q?/3UDYsOilfplRnP9CVgjoyTFqVOFC/qr1v70TvGkAmzCw70OEQbkfNZW0UCn?=
 =?us-ascii?Q?rl2W5TyQE88m6tL+jPx4qlJz2St7XaliJ4mFlb2iWjzGsyTVoEnCXKkstuvB?=
 =?us-ascii?Q?AiswIZetRdmdT7lxNE74Cy5LUaftcnjadW9XDttSadGwVz9y5dq3kSnBnaXS?=
 =?us-ascii?Q?5v0QdAC1o1V8ak2foNVBGyoVhP9ACkPfYGa3KA5dSgHIsSRss0frblEj4D4s?=
 =?us-ascii?Q?m0CeUWN8RUt+zmPfkN6QXHiB8/NekEpDJusonusA+LmhMa71MAGIDOoHeJQN?=
 =?us-ascii?Q?cdRQm6PLsEG50DBIhNFO/J0lRzc/zOcjMYIo4T8kUzu+MarvItX69qX1RbFh?=
 =?us-ascii?Q?Z9KAM9665awbEBrRk8axNSpLnF/ZBe/P45mYm4zBzlQ7daY9IvVUDUe+fq0E?=
 =?us-ascii?Q?iCIE34Cvruc+I/TmoGOW8X7EsTzbzRLlZzn4T9pbfwF4BrTdQ2SdDS5ungFy?=
 =?us-ascii?Q?kwpwEd+hwmb6ICyxDRsO2rB6DIAjsnYodjVCoPZaeU8K9n42W3hnJF6QUlMF?=
 =?us-ascii?Q?+ilfUJhEynCSNywjmkM+JU8y/cfavLxJlLGkiCnJdEYjJ6ff8IuDqeTn4jwh?=
 =?us-ascii?Q?AlKt0dtlPekPIk1sEnortKYOu1YMaL0hLVz7j/zmzPKDS2jXIe4KoDvf6iqh?=
 =?us-ascii?Q?fUAgoW07thbyhiyWDfzFGoFa8Kd1qGBjah7OIgk9N2y0tVao3Iz9c+Qh7Phv?=
 =?us-ascii?Q?rSiXusiBFyvQWu11dSKH6jWdQHuYcNDrUul9wUQyAF4CXk9syiMQXz0VeuN6?=
 =?us-ascii?Q?t6fWBLbr+JwUCWyiZ+tNhMxN70CtGVLTQx6ZlvMs2GcJML5zXY2sfq4wuqKc?=
 =?us-ascii?Q?7bXwdflMSyuDetMEDlO9lWo5QREm/R+636GTbwiYmYFyt+mUKpqTGFhFV7ro?=
 =?us-ascii?Q?OKdqYj4dQwHrdM7xwqczycdGKbcHo3K0U8fbdhjDQRz0i36BjuC8+Jfj8d7G?=
 =?us-ascii?Q?Nt31NqjfWYONXGVpHnohEESpujD6k6NTPzwjzJ8hpT7E0bRL5vc6UWr7ctrp?=
 =?us-ascii?Q?YyveXTFWwYHbTgOLSctubOrNlCy0KooV7g5i0YIGWmNkDmm3mWxs+1s2Umda?=
 =?us-ascii?Q?GjikdUm2a7JkfK7WoqX7a0+1ldcMKiVMaabsOYQDUHdw8pKvzCO8LqhFXR4p?=
 =?us-ascii?Q?/XZJ5B08HwfnII9FuDi/PEI6hwXDdY+rZVFIj9ctluW1j7lNPH8E59DrrYwK?=
 =?us-ascii?Q?1D7r3DLbizWA/E0e9tMzNyAPAzStu1EixpMQ3z/yteFHoE/MT/4NBA8cj1ow?=
 =?us-ascii?Q?PrWZTRCSRMaA7OKKJ+B+z00YkvDGkHt4m0aNPrPmG4HNTV52u1WtxnHg24yc?=
 =?us-ascii?Q?lMm0YiotcCfWUanOun6UfzALOa+SmZbvFmKx8J2tb7pVBHDgyJPj8EKkhEla?=
 =?us-ascii?Q?R5/0djJx6Mcs4dgYsjjjozs0broL2BYqzYZHMj5SqN5DpPZQoFAhtqJHuGU1?=
 =?us-ascii?Q?NRD80amNd2vrOaSBaJovn7xkDYgGSqq1aneoP4qP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17595193-ab7d-45be-f036-08daffb9a3e1
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:23:21.1590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U38xW2m3B1CWji0rd657mMrPqFCs5hlSAMVS6dqnE9Rv3LbPPV83Peh6EL+r4Jh/ArtzuXYJiDcZPkQII6IRVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7792
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Gerlitz <ogerlitz@nvidia.com>

This provides better separation between channels to ICO SQs for use-cases
where they are not tightly coupled (such as the upcoming nvmeotcp code).

No functional change here.

Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h               | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c   | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c          | 5 ++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index da58322cbc3a..f3f9a5bd75fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -592,6 +592,7 @@ struct mlx5e_icosq {
 	/* control path */
 	struct mlx5_wq_ctrl        wq_ctrl;
 	struct mlx5e_channel      *channel;
+	struct mlx5_core_dev      *mdev;
 
 	struct work_struct         recover_work;
 } ____cacheline_aligned_in_smp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 95edab4a1732..bfac3f09f964 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -33,7 +33,7 @@ static int mlx5e_query_rq_state(struct mlx5_core_dev *dev, u32 rqn, u8 *state)
 
 static int mlx5e_wait_for_icosq_flush(struct mlx5e_icosq *icosq)
 {
-	struct mlx5_core_dev *dev = icosq->channel->mdev;
+	struct mlx5_core_dev *dev = icosq->mdev;
 	unsigned long exp_time;
 
 	exp_time = jiffies + msecs_to_jiffies(mlx5_tout_ms(dev, FLUSH_ON_ERROR));
@@ -78,7 +78,7 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
 	rq = &icosq->channel->rq;
 	if (test_bit(MLX5E_RQ_STATE_ENABLED, &icosq->channel->xskrq.state))
 		xskrq = &icosq->channel->xskrq;
-	mdev = icosq->channel->mdev;
+	mdev = icosq->mdev;
 	dev = icosq->channel->netdev;
 	err = mlx5_core_query_sq_state(mdev, icosq->sqn, &state);
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 8551ddd500b2..fe9e04068b0f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -266,7 +266,7 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 		goto err_out;
 	}
 
-	pdev = mlx5_core_dma_dev(sq->channel->priv->mdev);
+	pdev = mlx5_core_dma_dev(sq->mdev);
 	buf->dma_addr = dma_map_single(pdev, &buf->progress,
 				       PROGRESS_PARAMS_PADDED_SIZE, DMA_FROM_DEVICE);
 	if (unlikely(dma_mapping_error(pdev, buf->dma_addr))) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 1e0afaa31dd0..076a2ca43cd5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1389,6 +1389,7 @@ static int mlx5e_alloc_icosq(struct mlx5e_channel *c,
 	int err;
 
 	sq->channel   = c;
+	sq->mdev      = mdev;
 	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 	sq->reserved_room = param->stop_room;
 
@@ -1786,11 +1787,9 @@ void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
 
 static void mlx5e_close_icosq(struct mlx5e_icosq *sq)
 {
-	struct mlx5e_channel *c = sq->channel;
-
 	if (sq->ktls_resync)
 		mlx5e_ktls_rx_resync_destroy_resp_list(sq->ktls_resync);
-	mlx5e_destroy_sq(c->mdev, sq->sqn);
+	mlx5e_destroy_sq(sq->mdev, sq->sqn);
 	mlx5e_free_icosq_descs(sq);
 	mlx5e_free_icosq(sq);
 }
-- 
2.31.1

