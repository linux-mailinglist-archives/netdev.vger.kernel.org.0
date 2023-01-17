Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45CE366E281
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbjAQPmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjAQPkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:40:53 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8401C42BD2
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:38:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0NDdBF211YZMWYFoIPI2b8EZwhYJ/Mc6G9w7ic0O6+OcFjBlbqmE55NecnLMRUsT+VhKFREN7Fk90H+7cTlTyoEbl07KtIjhcQRamkK5HOtOWXec4I6X8ylZzahARVL7SpLIUXgys99ghr1IaBdUrXWtku7XsRiSOKA7yx10c4Drro+F+mt6Y71FI0H8Fb0I7uFHNr1L3by6ht/xm25AvVCTqfNKo+7byN/5/ViOUpzsEqScwhGAIy9zUbQRhXhhBZC5OKL/r8i9oCq7HHDfdK1oK7UlJKZhCZH4k5DbJ6e2cXG3it17Tzhmek0m5iUGONQDun5rVgRiNRDCWkJCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YnwTL+m7ioIjHom+JwWgbhnSJZnFzq7oCYh6OKHO3ok=;
 b=FP3e/3SIjlwdGzgv+XBmfFT6c0NT7FrfL5jHnyShTH1jS+43lHcSJ7YXeCqIFVNuWRiFM7tgcZhUyIIi3fkBBYW0hg4wrpMdkc9qXkYr48PaAEya8geuiO8nPJQQdLnCSrYy/zC2ERXX3vYOhIUaZrVMnkHl5RgYbXSy1CSdTytzOrNOW26mzVIbM2vLfLdONo40rUbCNdj3s/EfHwXUpwU10RfKXQ9RMejGIB5ti2+ykCTLZ6seA8ZvkG0AS8RjkK9lu27yGMjCLNPW1R6q3YKP/IE/EaszKJpHH0GfJQH96T7gwXhpkatFYWjyh3TVfritoC4HufECUu1V7v37NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnwTL+m7ioIjHom+JwWgbhnSJZnFzq7oCYh6OKHO3ok=;
 b=nZYGeIcx3yt4ev2KrpLCxliqyrnZevMAbSmbxqE5SETFo1srrdK/Udj/l7xJqKc82a/tNPObjySOMFvdIYDCVeIhSsZhwy8G7ZoKzm5FFuf7ygKR0Z0Fd+uLKIAEdbjbEZsxDWAKIgMLu53Jm7EnJ3rnUvXwgR1Yk2IFdg4E7wGhaqL1Hi6Nn5o0ZL9UTlYXV8iiYrHc2rj3LnU63MQ1boTs/loitVqh6mr+C4k1tQXzpnfhWJZNFZtXDWjf3fa3y5cveR5YFYqthpf0Jh3D/7e5Y6gn7U6sdS9mk3SGBtCCe06nean4/LwpRCG0rykL0cfddqldediQn1NbyTLkTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Tue, 17 Jan
 2023 15:38:36 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:38:36 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v9 25/25] net/mlx5e: NVMEoTCP, statistics
Date:   Tue, 17 Jan 2023 17:35:35 +0200
Message-Id: <20230117153535.1945554-26-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0070.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::9) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|BL1PR12MB5157:EE_
X-MS-Office365-Filtering-Correlation-Id: 24c2743b-2241-4e61-5695-08daf8a0e5b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wfHELWLA0mPF/cWG5Sh4cKgJMs8Lm9EKGOsxUAxWHDvDEDLPVvjsS16apSn445PT3ynwPVx82IAz/+l47EvCTjAaiOu8B2pem0bpFPd+9yvRDXqXk/tqCP2oRtD4C0znQtfsZtykOmr8GEUGRcU0+itv70PFsAGPxjglQnYUu/8Fo+egNEkuiEyQp5IOzGrLI1vsA7obeCV2dZazSFrhxdiGHOUSPxav49L2aUsOTTVLYsnaWau2RLZ6lpt/M2wypyZeuT7APZdszLxYuwed3FGfizgDvJndwRNkmvEwqJn+X6AoDkcjLUXQrd9tPFaD/wrgKxK6lHWYl6ga9rFGzNyMoEYbHXwqs5bQ+xku9dCE1HAjNvodNRW5HVztzyqBoWSuCMHSHt2iOkhQJJOFBNr8J0onGC5GGu8MwiWoCc3HWz9h9hdf7lijK6/cz7sdYLjlcVt0y5QF++4vho46iin0vNo/b5DmopnTtjFxPWsWQUbndZs+6lPuDbFpQnkaP2CxShN1jK28+GnV3bl6EPuY8aRZ8T/zSql6wgo90qFYqsoHUhaY2Psqf7MqPRfovaRtSk3WU4FPHGU/z99SjqFk62QxJ44xpij2rt7EUibjQdm8uOQ5ZNzFP7c46qCcDuii6QOQdksMYB+7M7bZWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(451199015)(83380400001)(38100700002)(86362001)(7416002)(30864003)(5660300002)(2906002)(8936002)(8676002)(4326008)(66476007)(66946007)(66556008)(41300700001)(6512007)(6506007)(186003)(26005)(2616005)(1076003)(316002)(478600001)(107886003)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r61V87JtcyVVQrsvGSItdBbxdl8oDWyDZ8pxQITbKooDfWZUAPQ12tIi1A8x?=
 =?us-ascii?Q?ukPr4gM/tg7zpdDOKO+5/w7WMH9xbQnVaxZIYUOay8MFGQO9PXEmsT0smtmE?=
 =?us-ascii?Q?31ZbHp0OKkZ8ycDHzxJLoorir8vzqJdKW1t0p5SJVD+3Wk8+VK3N51WHS7rX?=
 =?us-ascii?Q?P7rTsK0pcuM4LlHPirsjMeYgIvtPzGlQlXMW3qfdicyXz5XcHWRi2CSH/7Sr?=
 =?us-ascii?Q?4iq1JgTDBTwWd/9h75RUxls98Bhbhdhi7DHk1yMVJJSmMVq0DouHW5jlV9d3?=
 =?us-ascii?Q?Ya5DwACdP0y8vylzgocE/iFbGGgZ604knyczC/Gi99VSABdVJ2LgsiIp2EN0?=
 =?us-ascii?Q?eDtgOFgUADn+XReO70XFxv4WLF+nQ1MKUTEPtLfenBpekqGBvGOLHD5Zzf9X?=
 =?us-ascii?Q?lqt2gDtIxg8OINS8HEuiiedww0moOsjPdmPS2GFMchPQ6oX6wh4HnhUIYlDu?=
 =?us-ascii?Q?x51e5wpqZqYUPm1JeKXSfoEPVBMQcamwTJs1vUCOgphDnQSpU93WhMd5IzVz?=
 =?us-ascii?Q?6HeMYOHFycnBnZKiwpr3fIirDzWG9c9ZYKRP+bfFAQU5PpSf6Jgitp0uwbQS?=
 =?us-ascii?Q?M725HAMT+9Ov3sQ/hh4FOvl2uN1pYtV+ZzOo2HSgND4HJWrgoWcROtxsaoad?=
 =?us-ascii?Q?clmUB0mCFVDNiUeGW1SaRdnFRct/NxuVMXLjHu5S6tbqobWhCiFz/F76QCri?=
 =?us-ascii?Q?8v2igERFBV3tI5ssy0cjh5eK0hFr/Okf9pF3O5gv8vE7bxWYBMDZfHAO/UZW?=
 =?us-ascii?Q?plxM6SNoYhoV3BAXGMa4AGX8vyPxgyi3cdMGqUv/m8fgFGNSZZBxtlOUfU7Y?=
 =?us-ascii?Q?xoGf9RliR1FRyl1MEyzomtWf35xBXrLC/xcpqXe1Nei6nkj9ExWHtNagwagq?=
 =?us-ascii?Q?OlFYwEfLlyga08VnKo682Ni9z6Ma++1i+yzk5ES6ifYPKht+l0ytusv7IG+K?=
 =?us-ascii?Q?b9ll0s3cdlWxQuQ5wHXQFly3YbsUUB6vxnWwETVTJeYn4gn3mNp9F+I2sei5?=
 =?us-ascii?Q?IWgrcrcY8H/yJUAlYOHDQiGaXuD8tz+uE9dornfKq2HuR166zkjWUBx0kG/m?=
 =?us-ascii?Q?k1aKC/5J2kGwe8DcTmmqngd0PHv5jnIkn8SZYtF5uTndb5hKmU3MzEopTVGK?=
 =?us-ascii?Q?xAdr8u6M2il/P3f4kMPcttpnfxWpW0zBhZXsynXF3y3bRaMbKC+q2Vl8RWRX?=
 =?us-ascii?Q?vWwm60wDY3Gqq3ozrlYjESMoQJfXrvsozxoYcKodjbukdGpSqv8DxStat+ZP?=
 =?us-ascii?Q?tv78aDncj90wJ908IkHB8yowbtjZdDeJYbmiPuY0YVW7DUvHopQXqtLfe6XE?=
 =?us-ascii?Q?5HS80WB+Q23GpqrG8uX8Zzw16oNcim4mMo/bf3vITFEiTj9vVUoer9IKjcLZ?=
 =?us-ascii?Q?XG9jUvW/tJ4qME58HIydkRA59UP5Hjg2EGK/Kpwc8qZMjuu20IuRjEeNHVqS?=
 =?us-ascii?Q?gDKMo8WyF8foHTlnQK4OV63fmVo0LpAS2Zcby+StQCUyivHtUiOOnpuH5VNT?=
 =?us-ascii?Q?RiMMfRFrJ7V7HtifFEu6A/MilvtnbFT7dT8Y55xjzrDPv7mwDxzzsoxvFQ1X?=
 =?us-ascii?Q?a18DsuI/Dcvc1HZHF83YHyHUOh278QGF0ppi3W+c?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24c2743b-2241-4e61-5695-08daf8a0e5b2
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:38:36.0190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xteYHZDdkkMIAxf0bWKyJW1wUP5QYIv+4K6iTW+3anU3wQsAfyliFLmbcLT91SuMwMTaftWaAAxEP7sAdnzjcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5157
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NVMEoTCP offload statistics include both control and data path
statistic: counters for the netdev ddp ops, offloaded packets/bytes,
resync and dropped packets.

Expose the statistics using the new ethtool_ops->get_ulp_ddp_stats()
instead of the regular statistics flow.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  3 +-
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 43 +++++++++---
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    | 16 +++++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.c        | 11 +++-
 .../mlx5/core/en_accel/nvmeotcp_stats.c       | 66 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 11 ++++
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  7 ++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  7 ++
 8 files changed, 153 insertions(+), 11 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_stats.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 9804bd086bf4..d48bde4ca8de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -103,7 +103,8 @@ mlx5_core-$(CONFIG_MLX5_EN_TLS) += en_accel/ktls_stats.o \
 				   en_accel/fs_tcp.o en_accel/ktls.o en_accel/ktls_txrx.o \
 				   en_accel/ktls_tx.o en_accel/ktls_rx.o
 
-mlx5_core-$(CONFIG_MLX5_EN_NVMEOTCP) += en_accel/fs_tcp.o en_accel/nvmeotcp.o en_accel/nvmeotcp_rxtx.o
+mlx5_core-$(CONFIG_MLX5_EN_NVMEOTCP) += en_accel/fs_tcp.o en_accel/nvmeotcp.o \
+					en_accel/nvmeotcp_rxtx.o en_accel/nvmeotcp_stats.o
 
 mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o \
 					steering/dr_matcher.o steering/dr_rule.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index 47f3b53ed78e..4fc84b81ce99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -614,9 +614,15 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 {
 	struct nvme_tcp_ddp_config *config = &tconfig->nvmeotcp;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_nvmeotcp_sw_stats *sw_stats;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_nvmeotcp_queue *queue;
 	int queue_id, err;
+	u32 channel_ix;
+
+	channel_ix = mlx5e_get_channel_ix_from_io_cpu(&priv->channels.params,
+						      config->io_cpu);
+	sw_stats = &priv->nvmeotcp->sw_stats;
 
 	if (tconfig->type != ULP_DDP_NVME) {
 		err = -EOPNOTSUPP;
@@ -643,11 +649,11 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 	queue->id = queue_id;
 	queue->dgst = config->dgst;
 	queue->pda = config->cpda;
-	queue->channel_ix = mlx5e_get_channel_ix_from_io_cpu(&priv->channels.params,
-							     config->io_cpu);
+	queue->channel_ix = channel_ix;
 	queue->size = config->queue_size;
 	queue->max_klms_per_wqe = MLX5E_MAX_KLM_PER_WQE(mdev);
 	queue->priv = priv;
+	queue->sw_stats = sw_stats;
 	init_completion(&queue->static_params_done);
 
 	err = mlx5e_nvmeotcp_queue_rx_init(queue, config, netdev);
@@ -659,6 +665,7 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 	if (err)
 		goto destroy_rx;
 
+	atomic64_inc(&sw_stats->rx_nvmeotcp_sk_add);
 	write_lock_bh(&sk->sk_callback_lock);
 	ulp_ddp_set_ctx(sk, queue);
 	write_unlock_bh(&sk->sk_callback_lock);
@@ -672,6 +679,7 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 free_queue:
 	kfree(queue);
 out:
+	atomic64_inc(&sw_stats->rx_nvmeotcp_sk_add_fail);
 	return err;
 }
 
@@ -685,6 +693,8 @@ mlx5e_nvmeotcp_queue_teardown(struct net_device *netdev,
 
 	queue = container_of(ulp_ddp_get_ctx(sk), struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
 
+	atomic64_inc(&queue->sw_stats->rx_nvmeotcp_sk_del);
+
 	WARN_ON(refcount_read(&queue->ref_count) != 1);
 	mlx5e_nvmeotcp_destroy_rx(priv, queue, mdev);
 
@@ -816,25 +826,34 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
 			 struct ulp_ddp_io *ddp)
 {
 	struct scatterlist *sg = ddp->sg_table.sgl;
+	struct mlx5e_nvmeotcp_sw_stats *sw_stats;
 	struct mlx5e_nvmeotcp_queue_entry *nvqt;
 	struct mlx5e_nvmeotcp_queue *queue;
 	struct mlx5_core_dev *mdev;
 	int i, size = 0, count = 0;
+	int ret = 0;
 
 	queue = container_of(ulp_ddp_get_ctx(sk),
 			     struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
+	sw_stats = queue->sw_stats;
 	mdev = queue->priv->mdev;
 	count = dma_map_sg(mdev->device, ddp->sg_table.sgl, ddp->nents,
 			   DMA_FROM_DEVICE);
 
-	if (count <= 0)
-		return -EINVAL;
+	if (count <= 0) {
+		ret = -EINVAL;
+		goto ddp_setup_fail;
+	}
 
-	if (WARN_ON(count > mlx5e_get_max_sgl(mdev)))
-		return -ENOSPC;
+	if (WARN_ON(count > mlx5e_get_max_sgl(mdev))) {
+		ret = -ENOSPC;
+		goto ddp_setup_fail;
+	}
 
-	if (!mlx5e_nvmeotcp_validate_sgl(sg, count, READ_ONCE(netdev->mtu)))
-		return -EOPNOTSUPP;
+	if (!mlx5e_nvmeotcp_validate_sgl(sg, count, READ_ONCE(netdev->mtu))) {
+		ret = -EOPNOTSUPP;
+		goto ddp_setup_fail;
+	}
 
 	for (i = 0; i < count; i++)
 		size += sg_dma_len(&sg[i]);
@@ -846,8 +865,13 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
 	nvqt->ccid_gen++;
 	nvqt->sgl_length = count;
 	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, count);
-
+	atomic64_inc(&sw_stats->rx_nvmeotcp_ddp_setup);
 	return 0;
+
+ddp_setup_fail:
+	dma_unmap_sg(mdev->device, ddp->sg_table.sgl, count, DMA_FROM_DEVICE);
+	atomic64_inc(&sw_stats->rx_nvmeotcp_ddp_setup_fail);
+	return ret;
 }
 
 void mlx5e_nvmeotcp_ctx_complete(struct mlx5e_icosq_wqe_info *wi)
@@ -894,6 +918,7 @@ mlx5e_nvmeotcp_ddp_teardown(struct net_device *netdev,
 	q_entry->queue = queue;
 
 	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_INV_UMR, ddp->command_id, 0);
+	atomic64_inc(&queue->sw_stats->rx_nvmeotcp_ddp_teardown);
 }
 
 static void
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
index a5cfd9e31be7..f2a7f3cc945d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
@@ -9,6 +9,15 @@
 #include "en.h"
 #include "en/params.h"
 
+struct mlx5e_nvmeotcp_sw_stats {
+	atomic64_t rx_nvmeotcp_sk_add;
+	atomic64_t rx_nvmeotcp_sk_add_fail;
+	atomic64_t rx_nvmeotcp_sk_del;
+	atomic64_t rx_nvmeotcp_ddp_setup;
+	atomic64_t rx_nvmeotcp_ddp_setup_fail;
+	atomic64_t rx_nvmeotcp_ddp_teardown;
+};
+
 struct mlx5e_nvmeotcp_queue_entry {
 	struct mlx5e_nvmeotcp_queue *queue;
 	u32 sgl_length;
@@ -52,6 +61,7 @@ struct mlx5e_nvmeotcp_queue_handler {
  *	@sk: The socket used by the NVMe-TCP queue
  *	@crc_rx: CRC Rx offload indication for this queue
  *	@priv: mlx5e netdev priv
+ *	@sw_stats: Global software statistics for nvmeotcp offload
  *	@static_params_done: Async completion structure for the initial umr mapping
  *	synchronization
  *	@sq_lock: Spin lock for the icosq
@@ -88,6 +98,7 @@ struct mlx5e_nvmeotcp_queue {
 	u8 crc_rx:1;
 	/* for ddp invalidate flow */
 	struct mlx5e_priv *priv;
+	struct mlx5e_nvmeotcp_sw_stats *sw_stats;
 	/* end of data-path section */
 
 	struct completion static_params_done;
@@ -97,6 +108,7 @@ struct mlx5e_nvmeotcp_queue {
 };
 
 struct mlx5e_nvmeotcp {
+	struct mlx5e_nvmeotcp_sw_stats sw_stats;
 	struct ida queue_ids;
 	struct rhashtable queue_hash;
 	bool enabled;
@@ -113,6 +125,7 @@ void mlx5e_nvmeotcp_ddp_inv_done(struct mlx5e_icosq_wqe_info *wi);
 void mlx5e_nvmeotcp_ctx_complete(struct mlx5e_icosq_wqe_info *wi);
 static inline void mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv) {}
 void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv);
+int mlx5e_nvmeotcp_get_stats(struct mlx5e_priv *priv, struct ethtool_ulp_ddp_stats *stats);
 extern const struct ulp_ddp_dev_ops mlx5e_nvmeotcp_ops;
 #else
 
@@ -122,5 +135,8 @@ static inline void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv) {}
 static inline int set_ulp_ddp_nvme_tcp(struct net_device *dev, bool en) { return -EOPNOTSUPP; }
 static inline void mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv) {}
 static inline void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv) {}
+static inline int mlx5e_nvmeotcp_get_stats(struct mlx5e_priv *priv,
+					   struct ethtool_ulp_ddp_stats *stats)
+{ return 0; }
 #endif
 #endif /* __MLX5E_NVMEOTCP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
index 4c7dab28ef56..d703ca3f0155 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
@@ -111,6 +111,7 @@ mlx5e_nvmeotcp_rebuild_rx_skb_nonlinear(struct mlx5e_rq *rq, struct sk_buff *skb
 	int ccoff, cclen, hlen, ccid, remaining, fragsz, to_copy = 0;
 	struct net_device *netdev = rq->netdev;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_rq_stats *stats = rq->stats;
 	struct mlx5e_nvmeotcp_queue_entry *nqe;
 	skb_frag_t org_frags[MAX_SKB_FRAGS];
 	struct mlx5e_nvmeotcp_queue *queue;
@@ -122,12 +123,14 @@ mlx5e_nvmeotcp_rebuild_rx_skb_nonlinear(struct mlx5e_rq *rq, struct sk_buff *skb
 	queue = mlx5e_nvmeotcp_get_queue(priv->nvmeotcp, queue_id);
 	if (unlikely(!queue)) {
 		dev_kfree_skb_any(skb);
+		stats->nvmeotcp_drop++;
 		return false;
 	}
 
 	cqe128 = container_of(cqe, struct mlx5e_cqe128, cqe64);
 	if (cqe_is_nvmeotcp_resync(cqe)) {
 		nvmeotcp_update_resync(queue, cqe128);
+		stats->nvmeotcp_resync++;
 		mlx5e_nvmeotcp_put_queue(queue);
 		return true;
 	}
@@ -201,7 +204,8 @@ mlx5e_nvmeotcp_rebuild_rx_skb_nonlinear(struct mlx5e_rq *rq, struct sk_buff *skb
 						 org_nr_frags,
 						 frag_index);
 	}
-
+	stats->nvmeotcp_packets++;
+	stats->nvmeotcp_bytes += cclen;
 	mlx5e_nvmeotcp_put_queue(queue);
 	return true;
 }
@@ -213,6 +217,7 @@ mlx5e_nvmeotcp_rebuild_rx_skb_linear(struct mlx5e_rq *rq, struct sk_buff *skb,
 	int ccoff, cclen, hlen, ccid, remaining, fragsz, to_copy = 0;
 	struct net_device *netdev = rq->netdev;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_rq_stats *stats = rq->stats;
 	struct mlx5e_nvmeotcp_queue_entry *nqe;
 	struct mlx5e_nvmeotcp_queue *queue;
 	struct mlx5e_cqe128 *cqe128;
@@ -222,12 +227,14 @@ mlx5e_nvmeotcp_rebuild_rx_skb_linear(struct mlx5e_rq *rq, struct sk_buff *skb,
 	queue = mlx5e_nvmeotcp_get_queue(priv->nvmeotcp, queue_id);
 	if (unlikely(!queue)) {
 		dev_kfree_skb_any(skb);
+		stats->nvmeotcp_drop++;
 		return false;
 	}
 
 	cqe128 = container_of(cqe, struct mlx5e_cqe128, cqe64);
 	if (cqe_is_nvmeotcp_resync(cqe)) {
 		nvmeotcp_update_resync(queue, cqe128);
+		stats->nvmeotcp_resync++;
 		mlx5e_nvmeotcp_put_queue(queue);
 		return true;
 	}
@@ -301,6 +308,8 @@ mlx5e_nvmeotcp_rebuild_rx_skb_linear(struct mlx5e_rq *rq, struct sk_buff *skb,
 				       hlen + cclen, remaining);
 	}
 
+	stats->nvmeotcp_packets++;
+	stats->nvmeotcp_bytes += cclen;
 	mlx5e_nvmeotcp_put_queue(queue);
 	return true;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_stats.c
new file mode 100644
index 000000000000..21b0ac17f1b2
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_stats.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES.
+
+#include "en_accel/nvmeotcp.h"
+
+struct ethtool_counter_map {
+	size_t eth_offset;
+	size_t mlx_offset;
+};
+
+#define DECLARE_ULP_SW_STAT(fld) \
+	{ offsetof(struct ethtool_ulp_ddp_stats, fld), \
+	  offsetof(struct mlx5e_nvmeotcp_sw_stats, fld) }
+
+#define DECLARE_ULP_RQ_STAT(fld) \
+	{ offsetof(struct ethtool_ulp_ddp_stats, rx_ ## fld), \
+	  offsetof(struct mlx5e_rq_stats, fld) }
+
+#define READ_CTR_ATOMIC64(ptr, dsc, i) \
+	atomic64_read((atomic64_t *)((char *)(ptr) + (dsc)[i].mlx_offset))
+
+#define READ_CTR(ptr, desc, i) \
+	(*((u64 *)((char *)(ptr) + (desc)[i].mlx_offset)))
+
+#define SET_ULP_STAT(ptr, desc, i, val) \
+	(*(u64 *)((char *)(ptr) + (desc)[i].eth_offset) = (val))
+
+/* Global counters */
+static const struct ethtool_counter_map sw_stats_desc[] = {
+	DECLARE_ULP_SW_STAT(rx_nvmeotcp_sk_add),
+	DECLARE_ULP_SW_STAT(rx_nvmeotcp_sk_del),
+	DECLARE_ULP_SW_STAT(rx_nvmeotcp_ddp_setup),
+	DECLARE_ULP_SW_STAT(rx_nvmeotcp_ddp_setup_fail),
+	DECLARE_ULP_SW_STAT(rx_nvmeotcp_ddp_teardown),
+};
+
+/* Per-rx-queue counters */
+static const struct ethtool_counter_map rq_stats_desc[] = {
+	DECLARE_ULP_RQ_STAT(nvmeotcp_drop),
+	DECLARE_ULP_RQ_STAT(nvmeotcp_resync),
+	DECLARE_ULP_RQ_STAT(nvmeotcp_packets),
+	DECLARE_ULP_RQ_STAT(nvmeotcp_bytes),
+};
+
+int mlx5e_nvmeotcp_get_stats(struct mlx5e_priv *priv, struct ethtool_ulp_ddp_stats *stats)
+{
+	unsigned int i, ch, n = 0;
+
+	if (!priv->nvmeotcp)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(sw_stats_desc); i++, n++)
+		SET_ULP_STAT(stats, sw_stats_desc, i,
+			     READ_CTR_ATOMIC64(&priv->nvmeotcp->sw_stats, sw_stats_desc, i));
+
+	for (i = 0; i < ARRAY_SIZE(rq_stats_desc); i++, n++) {
+		u64 sum = 0;
+
+		for (ch = 0; ch < priv->stats_nch; ch++)
+			sum += READ_CTR(&priv->channel_stats[ch]->rq, rq_stats_desc, i);
+
+		SET_ULP_STAT(stats, rq_stats_desc, i, sum);
+	}
+
+	return n;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 7f763152f989..ce29951ad027 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -2400,6 +2400,16 @@ static void mlx5e_get_rmon_stats(struct net_device *netdev,
 }
 
 #ifdef CONFIG_MLX5_EN_NVMEOTCP
+static int mlx5e_get_ulp_ddp_stats(struct net_device *netdev,
+				   struct ethtool_ulp_ddp_stats *stats)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+
+	mlx5e_stats_ulp_ddp_get(priv, stats);
+
+	return 0;
+}
+
 static int mlx5e_set_ulp_ddp_capabilities(struct net_device *netdev, unsigned long *new_caps)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -2501,6 +2511,7 @@ const struct ethtool_ops mlx5e_ethtool_ops = {
 	.get_rmon_stats    = mlx5e_get_rmon_stats,
 	.get_link_ext_stats = mlx5e_get_link_ext_stats,
 #ifdef CONFIG_MLX5_EN_NVMEOTCP
+	.get_ulp_ddp_stats = mlx5e_get_ulp_ddp_stats,
 	.set_ulp_ddp_capabilities = mlx5e_set_ulp_ddp_capabilities,
 #endif
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 6687b8136e44..60f60a4c6bc3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -2497,3 +2497,10 @@ unsigned int mlx5e_nic_stats_grps_num(struct mlx5e_priv *priv)
 {
 	return ARRAY_SIZE(mlx5e_nic_stats_grps);
 }
+
+/* ULP DDP stats */
+
+void mlx5e_stats_ulp_ddp_get(struct mlx5e_priv *priv, struct ethtool_ulp_ddp_stats *stats)
+{
+	mlx5e_nvmeotcp_get_stats(priv, stats);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 375752d6546d..8b3d43518d05 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -128,6 +128,7 @@ void mlx5e_stats_rmon_get(struct mlx5e_priv *priv,
 			  const struct ethtool_rmon_hist_range **ranges);
 void mlx5e_get_link_ext_stats(struct net_device *dev,
 			      struct ethtool_link_ext_stats *stats);
+void mlx5e_stats_ulp_ddp_get(struct mlx5e_priv *priv, struct ethtool_ulp_ddp_stats *stats);
 
 /* Concrete NIC Stats */
 
@@ -395,6 +396,12 @@ struct mlx5e_rq_stats {
 	u64 tls_resync_res_skip;
 	u64 tls_err;
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	u64 nvmeotcp_drop;
+	u64 nvmeotcp_resync;
+	u64 nvmeotcp_packets;
+	u64 nvmeotcp_bytes;
+#endif
 };
 
 struct mlx5e_sq_stats {
-- 
2.31.1

