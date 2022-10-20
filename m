Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9DD9605C32
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiJTKX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiJTKWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:22:07 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0239350182
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:21:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0cusqo0DqTsA/UacPMkObgbDFNJiL1qDf11PnK9+Xq2lGX3OCnKOOkxW4lBtTDcgkox5B0DzH/48Mhu5g3oBn0xaA8xkME5uKEPokwCcF9se8p583/dJcv6/twnEgr/CW+r1iF8f9lnp2Tr/rzJcXRj1vIxDaFHnaNTDqgxdWbH/Uvlzh5gSTDoIGWoT+QW0pBm8l6Ifyb2MpmvNOLWD3rMFf6rFC3avvtbKfVe5it+mD670AWFJuNiwsjl6W6k3HWCLtjIiQeYDszgj+RC39608zmSyehluMHBy6fweVAy8gA9a3IKyrXm8jmb/oRut6x9N88SQk41hD4PaVotxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EmIAl4gT+m48EQ+LqXiHL779rMzAS32NpzyFEIe7Nn8=;
 b=BULidcH0rJJqEogkWnUcYxu4X1jDQA/QtMlZQrv5XoOoP5IoY9dKG8nhmAJ4uQhlZ3m1IPiyYwQg9WKuvyi7IHX/hjUOdDeFu0CcEw6nUKI7WSgNTrv0o4NwdhskfMCn5Adga09gdyR4L0LwKHbNfGpnuBEMtuc+GBKc+Uq8ZzQFvOBlnCOF8/YBY9uRQEmqdx/LMNMQ4ICDXPfnazWW7OvPgo11ikfT75VGUw/ZTf1g8/GZozx0y5+igzqEBQmv+W2BnnnDagyUTOgkIFzu9pkP6J4Y7PXT9POUQxwdkVdJuctTKFS1mD+NWTf+Ol6Pqh77ZF4JlkJtMBNqdMN9nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmIAl4gT+m48EQ+LqXiHL779rMzAS32NpzyFEIe7Nn8=;
 b=jMaFzVM3Daarz/KAfaMhaXxl9YbERd2Ft7YsWB7Uh2/2+iDlhm/yTHCfcqx7fnYgFvi//5xe3t6M6Q6hUDsGBc1pJXMB7h4jR/bTGm1YU+VMIIlynUvTE2TgtStyLRQ4Xw590b6lASArr1qS0W0efz+hcI0/SOb2urChqYGE6vLTzViDaWkLDjWVcxo+trs5x0bP200LqXREOheU2sC8doqTKDbSFLF9UDBU7VWyygtQTt4xZRnpwDj5+4XLc6BcnmlupQB8LcdkmoPMHwpRwIqwpj/kBuDgf7sMbZkdoDsyybATCENmzG35gUnqGdqq+ifSqzAsL/r4Lu9g8VEV+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by SA1PR12MB6946.namprd12.prod.outlook.com (2603:10b6:806:24d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Thu, 20 Oct
 2022 10:20:59 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 10:20:59 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v6 23/23] net/mlx5e: NVMEoTCP, statistics
Date:   Thu, 20 Oct 2022 13:18:38 +0300
Message-Id: <20221020101838.2712846-24-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221020101838.2712846-1-aaptel@nvidia.com>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0012.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::17) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|SA1PR12MB6946:EE_
X-MS-Office365-Filtering-Correlation-Id: 36926e2b-2e46-4fde-fb3e-08dab284c878
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CtKoS6op1uB+dAvrFUExI5M6k2P0H4qCwJCcixHOfyteP/E/BJt+VWGVT2Rn5flIXUc6TpewpkHZq/05hu0NF+0oDLKrzPLm50QSKurPFToVc4T3DnO/JEDnqzkYFX2KqbvL8pFotcsn24qx2lal56elu6Zy23UNnZn70gLuzCxKWEWR3HxON/CdYtLkm9u/7H7yPBcbPVAmnkLqrcZ5sJpf7qJd+vkXql+XKWAd9cXgZXmbRARHvniuumN276urP9mLauhhXueTnQNFvy7uu3zjmk5wJnYINJZ15a1DQju9Zq4gKpK5zC+6a+WQhUY8PbkOb4WO2DBhNMkUum+ZTXze50QNVcEkwnOfmw5tyEiPty0F8MadIBTVnl68gEnOGdIy3o0g7nXmnKyi4tnzi6HtaGeN4GllcxIRw3noIkhfSfv9+NBPuhuol2vayNxLpNGWDf7x6E/iLdyTgxI5qzGcr4LUU1mZUpyfouRv81LZw52HMF7b5qeE6HVaqZLB9UaWF+P+VIOXTVFYKb8Z0KiLWt2DB/RhTz4IYjVLW7TrmLEsFWe2NWZHY782QobDdJ7q1ClFN/JSMkJGMuu/xvGKqCdMwNfG1r14Dk658vLGI/VIhLeY3VnurmokBANCHE1hNFhk4TDhT9zBoDW4ZsHIcLND87bpHBKbEKr3z+A3a/xwHd9ozrnyxf+pO8/PwXMM33xVsDKeLIKcXyEJq1cfrfUQ7aTiPpdHTL573VZ87q3ihWi02Tl1tARbIljX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199015)(36756003)(83380400001)(186003)(86362001)(1076003)(2616005)(38100700002)(921005)(8936002)(6636002)(7416002)(66476007)(5660300002)(316002)(4326008)(8676002)(66946007)(41300700001)(6666004)(478600001)(66556008)(6512007)(26005)(6506007)(6486002)(30864003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kFsS4MUnOBGqZ8KBb44tbx6AjjBaOSvw3MeW21V8bhTaF16z2ySp6jBeo3tw?=
 =?us-ascii?Q?TyHOai+K8ZFaqbrBw64D/KEsyxGrcPsoFgOB1+WZymxi+IbQD8zIDUnDKO0D?=
 =?us-ascii?Q?LCvDK7300RRqNh8mS38yGv2mUIQ4f0/6xOC+lzU5NU/U++CE5zqB1AeFyRYo?=
 =?us-ascii?Q?848FF6bg4z8dePJk0s8m5encSvEKZX1TKnR8wBmaQbreJEAC6UPJgZB/GEFT?=
 =?us-ascii?Q?brgLHNy9WeejYh8ltlXNZXN1KtrcElCb/Nk9mXGL7lLC1W+OlS0hwAUfzCtE?=
 =?us-ascii?Q?4scAa/ZEiffqGXkwujaCPkJ9SflDQbnWTpRsRijOQk2gGb6WduijCO6hRtqf?=
 =?us-ascii?Q?wP/YSFoB3yBQKyhM3gshw9/l8qih0m+EBl+tf8Mh2AiUEtwRM7D8tmaSZZMj?=
 =?us-ascii?Q?8mLhWrJiDgdbh6QcHDtGd1ChYJGeMkJ0e87Bmox6NZ11/iiZ7VikQw+T5QBk?=
 =?us-ascii?Q?U/XiPDXzdM6TZLKeBBTKZT2FhZGKIr5STNk4iA6puDTsS6FRVaDZGrrY9zLG?=
 =?us-ascii?Q?hiyRxu67WU9DLf7WKfzVPSVydLSajieVYAwcYhM47DPDAPhOSJPnpr+lS0An?=
 =?us-ascii?Q?NYVkPBeJm4DhGJKW0dPft4cigJjd9cwlFUwLWVpEvhg3GTmXN5P6KtYrK/Iv?=
 =?us-ascii?Q?Sf4m6XRiOplBDkDIRXZANdfook+UrP4GYTBDrnCjCAm8a5H+NPHfOO/V1Q84?=
 =?us-ascii?Q?12vXk/OqxB/7bVaDQeKhDDoD3MsCKrvaUIm65Tjv3Bg6cxHcEWGxPT9GoLRJ?=
 =?us-ascii?Q?l90mTZcy+rHIVo8i2awV3GBB03jt3ZR2BUCVvg3RKayhYh545laqp9/6tE9A?=
 =?us-ascii?Q?CTSqIyTrsDLVtGvHjIsM3HNTmS47MSCBWSHbLXBJ9Vv8O4xdGUF363DX4iWC?=
 =?us-ascii?Q?FHqwu88xwidfl1GH5altZte2cNfTp5Ci6kCXsEQ+j2Iv6a1qyLnyqkniJBVT?=
 =?us-ascii?Q?gk2TDZiAxN+sCHiT0u08uZo7TA2bwkjLlDAEdcxyHPYszNrM1XBI59maGIoi?=
 =?us-ascii?Q?cb/Rs2dUopTQ+6QRb1TJfC4zhhoY20BtEuZWXWIb2MZa+KOBBmncrvLYoJ3u?=
 =?us-ascii?Q?YrjcGr/ng8PsTrIK3TPFxuSDUnZ0o3OTnx8WyXtT09pMxNcvUbmOwW+b7sfI?=
 =?us-ascii?Q?IQ3raT22kWTTWxrQd1NMQQj7IqS/1eS6mktW0mBzCXdxRmlpolXa1M6+0Ey9?=
 =?us-ascii?Q?6OUuV8qWv9WKuzrQHHaCetR9hsjHB+4Ls1Pi31dgc4rMYd04Ox7UsGmxMzlv?=
 =?us-ascii?Q?chr3nSlCtfgZEOEtJNfP7vr7y4ujgTxcZval8nFkDXA4S6QY9/ZMymY/uumP?=
 =?us-ascii?Q?ihTp1bvvTIEeROelEjmVv8BoOFwOj/VRcxMfP9wPnt0Goz5WGbBstDPn9Zyl?=
 =?us-ascii?Q?unG27jlNfny/gu3CcQ5v+kWrgolWCgZAbfri1rWdK6cMFYgUtaQq8UkkTBfX?=
 =?us-ascii?Q?/93vdJhd62jB5ZCIpx2H1Ghg3XN6e6oAPFgg6+JkYvp1aBtmVV2QAaEXQQBJ?=
 =?us-ascii?Q?Nyp6a5d3E32Tgg0svfnPsUAZetDkvXmYr9JE4Ka2py8D6u0EclEilA/f5STz?=
 =?us-ascii?Q?i1VzaCgWCLnUY8I6qS3qFRewS4lCMkgH78GTJCSz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36926e2b-2e46-4fde-fb3e-08dab284c878
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 10:20:59.6486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XoitOebBMs9y+mODpaCBcygPOl4ZJnGRygaqhT+nhvs/GJXgoFUPmtBNTxspEwsVQ7AFbPGeza4p7XJke1NnuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6946
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

NVMEoTCP offload statistics include both control and data path
statistic: counters for the netdev ddp ops, offloaded packets/bytes
and dropped packets.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  3 +-
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 44 ++++++++++---
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    | 19 ++++++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.c        | 11 +++-
 .../mlx5/core/en_accel/nvmeotcp_stats.c       | 61 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 38 ++++++++++++
 .../ethernet/mellanox/mlx5/core/en_stats.h    | 12 ++++
 7 files changed, 176 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_stats.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index b61f23f24883..18aa3e378a2f 100644
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
index 8fb749ce545d..edd069e99a38 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -615,9 +615,15 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 {
 	struct nvme_tcp_ddp_config *config = (struct nvme_tcp_ddp_config *)tconfig;
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
@@ -644,11 +650,11 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
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
@@ -660,6 +666,7 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 	if (err)
 		goto destroy_rx;
 
+	atomic64_inc(&sw_stats->rx_nvmeotcp_sk_add);
 	write_lock_bh(&sk->sk_callback_lock);
 	ulp_ddp_set_ctx(sk, queue);
 	write_unlock_bh(&sk->sk_callback_lock);
@@ -673,6 +680,7 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 free_queue:
 	kfree(queue);
 out:
+	atomic64_inc(&sw_stats->rx_nvmeotcp_sk_add_fail);
 	return err;
 }
 
@@ -686,6 +694,8 @@ mlx5e_nvmeotcp_queue_teardown(struct net_device *netdev,
 
 	queue = container_of(ulp_ddp_get_ctx(sk), struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
 
+	atomic64_inc(&queue->sw_stats->rx_nvmeotcp_sk_del);
+
 	WARN_ON(refcount_read(&queue->ref_count) != 1);
 	mlx5e_nvmeotcp_destroy_rx(priv, queue, mdev);
 
@@ -817,25 +827,35 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
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
+	atomic64_inc(&sw_stats->rx_nvmeotcp_ddp_setup);
 
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
@@ -847,8 +867,12 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
 	nvqt->ccid_gen++;
 	nvqt->sgl_length = count;
 	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, count);
-
 	return 0;
+
+ddp_setup_fail:
+	dma_unmap_sg(mdev->device, ddp->sg_table.sgl, count, DMA_FROM_DEVICE);
+	atomic64_inc(&sw_stats->rx_nvmeotcp_ddp_setup_fail);
+	return ret;
 }
 
 void mlx5e_nvmeotcp_ctx_complete(struct mlx5e_icosq_wqe_info *wi)
@@ -895,7 +919,7 @@ mlx5e_nvmeotcp_ddp_teardown(struct net_device *netdev,
 	q_entry->queue = queue;
 
 	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_INV_UMR, ddp->command_id, 0);
-
+	atomic64_inc(&queue->sw_stats->rx_nvmeotcp_ddp_teardown);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
index 8c812e5dcf04..175ce49317b9 100644
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
  *	@static_params_done: Async completion structure for the initial umr mapping synchronization
  *	@sq_lock: Spin lock for the icosq
  *	@qh: Completion queue handler for processing umr completions
@@ -87,6 +97,7 @@ struct mlx5e_nvmeotcp_queue {
 	u8 crc_rx:1;
 	/* for ddp invalidate flow */
 	struct mlx5e_priv *priv;
+	struct mlx5e_nvmeotcp_sw_stats *sw_stats;
 	/* end of data-path section */
 
 	struct completion static_params_done;
@@ -96,6 +107,7 @@ struct mlx5e_nvmeotcp_queue {
 };
 
 struct mlx5e_nvmeotcp {
+	struct mlx5e_nvmeotcp_sw_stats sw_stats;
 	struct ida queue_ids;
 	struct rhashtable queue_hash;
 	bool enabled;
@@ -112,6 +124,9 @@ void mlx5e_nvmeotcp_ddp_inv_done(struct mlx5e_icosq_wqe_info *wi);
 void mlx5e_nvmeotcp_ctx_complete(struct mlx5e_icosq_wqe_info *wi);
 static inline void mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv) {}
 void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv);
+int mlx5e_nvmeotcp_get_count(struct mlx5e_priv *priv);
+int mlx5e_nvmeotcp_get_strings(struct mlx5e_priv *priv, uint8_t *data);
+int mlx5e_nvmeotcp_get_stats(struct mlx5e_priv *priv, u64 *data);
 #else
 
 static inline void mlx5e_nvmeotcp_build_netdev(struct mlx5e_priv *priv) {}
@@ -120,5 +135,9 @@ static inline void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv) {}
 static inline int set_feature_nvme_tcp(struct net_device *netdev, bool enable) { return 0; }
 static inline void mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv) {}
 static inline void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv) {}
+static inline int mlx5e_nvmeotcp_get_count(struct mlx5e_priv *priv) { return 0; }
+static inline int mlx5e_nvmeotcp_get_strings(struct mlx5e_priv *priv, uint8_t *data)
+{ return 0; }
+static inline int mlx5e_nvmeotcp_get_stats(struct mlx5e_priv *priv, u64 *data) { return 0; }
 #endif
 #endif /* __MLX5E_NVMEOTCP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
index 3228d308d7bc..138e15396c7c 100644
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
+	stats->nvmeotcp_offload_packets++;
+	stats->nvmeotcp_offload_bytes += cclen;
 	mlx5e_nvmeotcp_put_queue(queue);
 	return true;
 }
@@ -217,17 +221,20 @@ mlx5e_nvmeotcp_rebuild_rx_skb_linear(struct mlx5e_rq *rq, struct sk_buff *skb,
 	struct mlx5e_nvmeotcp_queue *queue;
 	struct mlx5e_cqe128 *cqe128;
 	u32 queue_id;
+	struct mlx5e_rq_stats *stats = rq->stats;
 
 	queue_id = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
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
 
+	stats->nvmeotcp_offload_packets++;
+	stats->nvmeotcp_offload_bytes += cclen;
 	mlx5e_nvmeotcp_put_queue(queue);
 	return true;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_stats.c
new file mode 100644
index 000000000000..4078317e5e25
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_stats.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES.
+
+#include "en_accel/nvmeotcp.h"
+
+static const struct counter_desc mlx5e_nvmeotcp_sw_stats_desc[] = {
+	{ MLX5E_DECLARE_STAT(struct mlx5e_nvmeotcp_sw_stats, rx_nvmeotcp_sk_add) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_nvmeotcp_sw_stats, rx_nvmeotcp_sk_add_fail) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_nvmeotcp_sw_stats, rx_nvmeotcp_sk_del) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_nvmeotcp_sw_stats, rx_nvmeotcp_ddp_setup) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_nvmeotcp_sw_stats, rx_nvmeotcp_ddp_setup_fail) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_nvmeotcp_sw_stats, rx_nvmeotcp_ddp_teardown) },
+};
+
+#define MLX5E_READ_CTR_ATOMIC64(ptr, dsc, i) \
+	atomic64_read((atomic64_t *)((char *)(ptr) + (dsc)[i].offset))
+
+static const struct counter_desc *get_nvmeotcp_atomic_stats(struct mlx5e_priv *priv)
+{
+	if (!priv->nvmeotcp)
+		return NULL;
+	return mlx5e_nvmeotcp_sw_stats_desc;
+}
+
+int mlx5e_nvmeotcp_get_count(struct mlx5e_priv *priv)
+{
+	if (!priv->nvmeotcp)
+		return 0;
+	return ARRAY_SIZE(mlx5e_nvmeotcp_sw_stats_desc);
+}
+
+int mlx5e_nvmeotcp_get_strings(struct mlx5e_priv *priv, uint8_t *data)
+{
+	const struct counter_desc *stats_desc;
+	unsigned int i, n, idx = 0;
+
+	stats_desc = get_nvmeotcp_atomic_stats(priv);
+	n = mlx5e_nvmeotcp_get_count(priv);
+
+	for (i = 0; i < n; i++)
+		strcpy(data + (idx++) * ETH_GSTRING_LEN,
+		       stats_desc[i].format);
+
+	return n;
+}
+
+int mlx5e_nvmeotcp_get_stats(struct mlx5e_priv *priv, u64 *data)
+{
+	const struct counter_desc *stats_desc;
+	unsigned int i, n, idx = 0;
+
+	stats_desc = get_nvmeotcp_atomic_stats(priv);
+	n = mlx5e_nvmeotcp_get_count(priv);
+
+	for (i = 0; i < n; i++)
+		data[idx++] =
+		    MLX5E_READ_CTR_ATOMIC64(&priv->nvmeotcp->sw_stats,
+					    stats_desc, i);
+
+	return n;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 03c1841970f1..5ae81381ff48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -36,6 +36,7 @@
 #include "en_accel/en_accel.h"
 #include "en/ptp.h"
 #include "en/port.h"
+#include "en_accel/nvmeotcp.h"
 
 #ifdef CONFIG_PAGE_POOL_STATS
 #include <net/page_pool.h>
@@ -211,6 +212,12 @@ static const struct counter_desc sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_res_retry) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_res_skip) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_err) },
+#endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_drop) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_resync) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_offload_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_offload_bytes) },
 #endif
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_events) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_poll) },
@@ -391,6 +398,12 @@ static void mlx5e_stats_grp_sw_update_stats_rq_stats(struct mlx5e_sw_stats *s,
 	s->rx_tls_resync_res_skip     += rq_stats->tls_resync_res_skip;
 	s->rx_tls_err                 += rq_stats->tls_err;
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	s->rx_nvmeotcp_drop		+= rq_stats->nvmeotcp_drop;
+	s->rx_nvmeotcp_resync		+= rq_stats->nvmeotcp_resync;
+	s->rx_nvmeotcp_offload_packets	+= rq_stats->nvmeotcp_offload_packets;
+	s->rx_nvmeotcp_offload_bytes	+= rq_stats->nvmeotcp_offload_bytes;
+#endif
 }
 
 static void mlx5e_stats_grp_sw_update_stats_ch_stats(struct mlx5e_sw_stats *s,
@@ -1934,6 +1947,23 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(tls)
 
 static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(tls) { return; }
 
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(nvmeotcp)
+{
+	return mlx5e_nvmeotcp_get_count(priv);
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(nvmeotcp)
+{
+	return idx + mlx5e_nvmeotcp_get_strings(priv, data + idx * ETH_GSTRING_LEN);
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(nvmeotcp)
+{
+	return idx + mlx5e_nvmeotcp_get_stats(priv, data + idx);
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(nvmeotcp) { return; }
+
 static const struct counter_desc rq_stats_desc[] = {
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, packets) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, bytes) },
@@ -1994,6 +2024,12 @@ static const struct counter_desc rq_stats_desc[] = {
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_resync_res_skip) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_err) },
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_drop) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_resync) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_offload_packets) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_offload_bytes) },
+#endif
 };
 
 static const struct counter_desc sq_stats_desc[] = {
@@ -2445,6 +2481,7 @@ MLX5E_DEFINE_STATS_GRP(channels, 0);
 MLX5E_DEFINE_STATS_GRP(per_port_buff_congest, 0);
 MLX5E_DEFINE_STATS_GRP(eth_ext, 0);
 static MLX5E_DEFINE_STATS_GRP(tls, 0);
+static MLX5E_DEFINE_STATS_GRP(nvmeotcp, 0);
 MLX5E_DEFINE_STATS_GRP(ptp, 0);
 static MLX5E_DEFINE_STATS_GRP(qos, 0);
 
@@ -2466,6 +2503,7 @@ mlx5e_stats_grp_t mlx5e_nic_stats_grps[] = {
 	&MLX5E_STATS_GRP(ipsec_sw),
 #endif
 	&MLX5E_STATS_GRP(tls),
+	&MLX5E_STATS_GRP(nvmeotcp),
 	&MLX5E_STATS_GRP(channels),
 	&MLX5E_STATS_GRP(per_port_buff_congest),
 	&MLX5E_STATS_GRP(ptp),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 9f781085be47..4e3567bfbd65 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -199,6 +199,12 @@ struct mlx5e_sw_stats {
 	u64 rx_congst_umr;
 	u64 rx_arfs_err;
 	u64 rx_recover;
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	u64 rx_nvmeotcp_drop;
+	u64 rx_nvmeotcp_resync;
+	u64 rx_nvmeotcp_offload_packets;
+	u64 rx_nvmeotcp_offload_bytes;
+#endif
 	u64 ch_events;
 	u64 ch_poll;
 	u64 ch_arm;
@@ -393,6 +399,12 @@ struct mlx5e_rq_stats {
 	u64 tls_resync_res_skip;
 	u64 tls_err;
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	u64 nvmeotcp_drop;
+	u64 nvmeotcp_resync;
+	u64 nvmeotcp_offload_packets;
+	u64 nvmeotcp_offload_bytes;
+#endif
 };
 
 struct mlx5e_sq_stats {
-- 
2.31.1

