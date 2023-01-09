Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4C4662741
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbjAINg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234702AbjAINgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:36:33 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A504D3C0DE
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:34:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FuVZiXbbaiACe59iYiIRDYhspfYgubI1FPZSgnwgE9pQER6xdT6OCkirbHHxdKnS7tnePExg5xXXb8MhMFfcRQncHuHWBEMFe8aYuX13jFvjMOivHFDAWs/M+6AGbxvfD1QLZwnxhWyM1i8ALTzja0tyaLhmA9yu5WfsQzlkAgGuTPXL4w4E0vetEc6eKUGxm9s2tPHStKEJNFbXxhh9APDCkM2Xnw2Qr37KzJ+nt+ZMfkWmvv4g645EBTwmquEuTM6EJ573AyAi7USvRUuoxPna7U+zq9rjw9mt0gYg/q3tANo+chtyogYEaOLZ3cq1r2XLsY3NboU4tZt/WceB1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IKbDuN7SL0K2ms7x3cUDgzAC4vUUY45/IhdiON1RscI=;
 b=IJnbLdA4aWqioK4N27Cc2vQYwri0FDuWWwRD2qwlVjhV2ic+GWqdTHZ6ykVwQEg0z/9lIk4nHLDb8+hF5tqDLILE8Qn7didMBpwlmzC/NPXKOQqcnNLwH2xvXkLEUUf6/vfLHmx1C1GBWHC9VDYpt4J+r5A6KyPu1HbsoMX3xVesenuF3MszQfBs7d5dLs1NqOIGVWHKH9t1a47gNRcg5cvkh7n8nQ0TkbiPG+yycIiMLj65IfcCFTgzBraRKsnx4a62uv7rX6xIOPFfbDiRA8l+WlyyNImQFiSDaWZ7O+/wZQGI9/b+1l6OtoCQ0OLcLkIe6L0svCuScJWWttGyRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKbDuN7SL0K2ms7x3cUDgzAC4vUUY45/IhdiON1RscI=;
 b=RrxpS2v0QFSx5szhG5370GUZ1pmU69MyTeMCJ69dRoPkltKbm47KVfkzTz33bCV4o3HAeCLC/4NBfJh0sS6Ck/3LspaSfGAZwRKAsEFKtsr0Si1vC5czBqJwnZ95ByBpv/N+8rJPxVlcTYWAFYYm0OJoOy9KG0AzC5IAOjp3OV3exXGhBEG59a9hsg8Oy1q/N7jcRnsJChcs5FzWP/eje9bDq1xPpXPqgWoPNCXL2/MUIyL/Bqcq89LB4FY2B4qtbLBtyWb/uOr2VHTjv8SIBt1oaXtC/F4BW7/FCCDnN/UtxeATALJF4Q5lBxhtxa2CMqGJqxuDlL5DgKhUOo/HiA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by CH0PR12MB5074.namprd12.prod.outlook.com (2603:10b6:610:e1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:34:09 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:34:09 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v8 25/25] net/mlx5e: NVMEoTCP, statistics
Date:   Mon,  9 Jan 2023 15:31:16 +0200
Message-Id: <20230109133116.20801-26-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0153.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::11) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|CH0PR12MB5074:EE_
X-MS-Office365-Filtering-Correlation-Id: 95256836-fa49-45c4-aeab-08daf2462fe3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G4uGJlsRT5cTkCHYakcYMCyNWklY+TTO9oLEP9CqO9Q2VzTQIddNApNBhZdbEudxzRv6jxoWrUeO1PsDvCj+xdA9t7BlPtuUD/z6sqksZc6jXyPaXOwtyQDpSGr4RVQIY9CBkRfdg13OvQu8fT3XdGiH1Fcts8WryJFgpMr7CebvE5n57dBmBPd/lUa3S3ieF4TxNWjXY0UzR4BOc+S1l8E3qBpdPC1XivWXFp5Dl77bE/Ix2dXSubKQEX3b1O8VgIv5o5h0beCKXpdBcFtxNt1jze0n6I2EE407GY40toDClV370Aha5ATsPaR78+C+J28IPMOGSPNoAzpq+RfAOQ36mNkmSQ8ciYho3DSFJLF/6XQywCPh5/MaJek5fu8h2hPCUQS/LLaAOYXA6S4C7cBpHMRZ6SkgWkr/e4++UnBk3vtIXKSZwu6lj6XgRIpje/8vsXpKGPtvRzhNESpyMa2Xx/ga1GHCHmU4eRteuQuqK9b4c75aCh9q0lYtL5uuzXYsjIyw8V93OwLEfyYlCgyUk6AkrhgDJJw0rUL+AT4s7muBPAdNI5eN4IYZ+LWgkmJe5LSFCp/6ZET1lVcBAB0+bs7+dBfKqTAwEoC6gA6vatQNWt1Ttj/7LUoxcA6zkADu+0efKdeuwCtEVDq8LQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199015)(1076003)(30864003)(316002)(5660300002)(7416002)(26005)(6512007)(186003)(6486002)(478600001)(2616005)(41300700001)(4326008)(66556008)(66946007)(66476007)(8676002)(8936002)(83380400001)(86362001)(36756003)(6666004)(107886003)(6506007)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PHi86ilFoSREdpY9ewopIyC2euWQ3PQ/luKDrpMnuu0iiAOd7IcLHYwu9PLv?=
 =?us-ascii?Q?PV6fl+/L//gJ/4SKD35+X/B4xQ35HFj7um6ek+LPcRIaJjQxEW/zYXFZzWGh?=
 =?us-ascii?Q?dsrKZK6AnFg/5vU1J0GCRY1vcmTwuWoD2CsZ9Jx3Fhfb2SyoDUprQtMv1RZ1?=
 =?us-ascii?Q?IWG6dNDfPUK15TwDVXnbq2BXKktQvpeiazjNRmf+wG+nXl+UNA5bYO1caELE?=
 =?us-ascii?Q?NrRH69L/RSj8wqXD5id8V0Rlg9yTxARZZmtvMETDKpJ8CeFStXHdF3xT8Q4P?=
 =?us-ascii?Q?OfpivmgRRD9cSi5s/urFplg8rOXCPWou1+Q6xblqHnMt45nA1CF3gkOGx2Ma?=
 =?us-ascii?Q?nZPcrlDpGiVGlkM6Qd596ypaqhbQnfBqvG6UagcuW3Jy5Nhbq6e6rOQBvL9P?=
 =?us-ascii?Q?fT63qM0ZSoivJ+E+4yxpjnB043poLDZm5BqWiGZsobsHJdRjrL+2DyVzLbNf?=
 =?us-ascii?Q?l/CmXufsarbWYoPr/HwAbSEuemWX/BetQQ4du397Th7gsqLtHEO7uyYHf89K?=
 =?us-ascii?Q?nyzv0DxJKtClloCMSntRxDNZOFtzppSr5j68Hq/L1QHdK+zrkm03y4wQ9qYD?=
 =?us-ascii?Q?KWJANL6WIpznH2ehjp+b4zXeOXDLy8FGwNbHbIYPTKpKfSc4/ae1JR8uhtU3?=
 =?us-ascii?Q?lvMMAQUH1Jt2k5RieoCinDnLLvC5gnzMYcJk+XrdcPzWG7lm9xFxQLBQHl97?=
 =?us-ascii?Q?tOcjGVeiRj48yx261UEQ52tX+CdcUw2HOoftbdENEbjaVTWZpNJtD2LGgvtC?=
 =?us-ascii?Q?dHv4KFt30rSnKg5XJsfouGlGIwf7ubZ8qciPuPJeEDtyr+X9VPQD3MpM9zUg?=
 =?us-ascii?Q?o1rZ3QW1ntDvCxKW2/C7MnurZWRkfn53+cynb8BBjFg2Fr0iYyGr4Wd92TJh?=
 =?us-ascii?Q?nxyx/dwhOZVKbLA/+xYNUXAyoJiRPEOdSLr3rO99DmllhzrGv2v5hRz33K6O?=
 =?us-ascii?Q?03GeO+epFgKdY+NPfwyO6VaccYFulKElF0owXae3LuJr5wCK1Yv99OVCqh4B?=
 =?us-ascii?Q?Kkilw+hHertnh3JLS9B3fH3ZlQ+eQXIa6hDW2IcoW1+PnJHRrmOp8af+kjsP?=
 =?us-ascii?Q?CBNwuLRv4fXK4+flY+MDWyWNcXQi2noBc+NaD4rXnzW5UZd0fXBQKwirlQca?=
 =?us-ascii?Q?tsv7xNBlT6e/CM+dBl8jTXzDxPS/Z7KxMCCrrInvalspdsCZV8nT0k0wipH5?=
 =?us-ascii?Q?jUZxBFmSU5Gbi5ADDfHNn0z/xrGeTU1/DHk9G34y6K8gCmlUVc6llrYoXGdl?=
 =?us-ascii?Q?IF53T1w3o1lgk8LJyhmjz/kwBuWb/WfDMT1HdC7IVmU14bLPwf/A+1lgO9TL?=
 =?us-ascii?Q?8V6BLQI2WsY08KJ7/Vb0I1l9Mxd/OXQfm5StGGkZN8aJkol2+W/kss5+Evyi?=
 =?us-ascii?Q?A3HP/FMkSpD1BbEUhejGcC+E+B7N1eHe1wxx97H9htfawBeJNJOk4B5Ytt52?=
 =?us-ascii?Q?yobLnUfDR+fY/+z0ZlN2GwJD6OpRv8pX5uLFjj2de4Vs64lQDh1Xyni0c4FW?=
 =?us-ascii?Q?7FXefOYdL8qpWrwVYzX0r2mQbTL5oXx9IOgFfZxgPqLWGIMg/jPVkb6IWHMJ?=
 =?us-ascii?Q?iEcl68VLZ30mdnpZ+6ewxbFAsDMG3Kas6qt/oPLT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95256836-fa49-45c4-aeab-08daf2462fe3
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:34:09.2054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8WDn0jcqAZA5EMhb8wyi+EAJwaZ8v/z+aFamczwXYVn9jzMRzqqArPEoB4qku4EGhNK1Z+H6tO+Exd0eWDbHXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5074
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
statistic: counters for the netdev ddp ops, offloaded packets/bytes
and dropped packets.

Expose the statistics using the new ethtool_ops->get_ulp_ddp_stats()
and the new ETH_SS_ULP_DDP_STATS string set instead of the regular
statistics flow.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   3 +-
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    |  43 +++++--
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    |  19 +++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.c        |  11 +-
 .../mlx5/core/en_accel/nvmeotcp_stats.c       | 108 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  17 +++
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  17 +++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  10 ++
 8 files changed, 217 insertions(+), 11 deletions(-)
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
index b440ed10c373..6e07cea438ba 100644
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
 
@@ -816,25 +826,35 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
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
@@ -846,8 +866,12 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
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
@@ -894,6 +918,7 @@ mlx5e_nvmeotcp_ddp_teardown(struct net_device *netdev,
 	q_entry->queue = queue;
 
 	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_INV_UMR, ddp->command_id, 0);
+	atomic64_inc(&queue->sw_stats->rx_nvmeotcp_ddp_teardown);
 }
 
 static void
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
index a5cfd9e31be7..2d6a12b40429 100644
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
@@ -113,6 +125,9 @@ void mlx5e_nvmeotcp_ddp_inv_done(struct mlx5e_icosq_wqe_info *wi);
 void mlx5e_nvmeotcp_ctx_complete(struct mlx5e_icosq_wqe_info *wi);
 static inline void mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv) {}
 void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv);
+int mlx5e_nvmeotcp_get_count(struct mlx5e_priv *priv);
+int mlx5e_nvmeotcp_get_strings(struct mlx5e_priv *priv, uint8_t *data);
+int mlx5e_nvmeotcp_get_stats(struct mlx5e_priv *priv, u64 *data);
 extern const struct ulp_ddp_dev_ops mlx5e_nvmeotcp_ops;
 #else
 
@@ -122,5 +137,9 @@ static inline void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv) {}
 static inline int set_ulp_ddp_nvme_tcp(struct net_device *dev, bool en) { return -EOPNOTSUPP; }
 static inline void mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv) {}
 static inline void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv) {}
+static inline int mlx5e_nvmeotcp_get_count(struct mlx5e_priv *priv) { return 0; }
+static inline int mlx5e_nvmeotcp_get_strings(struct mlx5e_priv *priv, uint8_t *data)
+{ return 0; }
+static inline int mlx5e_nvmeotcp_get_stats(struct mlx5e_priv *priv, u64 *data) { return 0; }
 #endif
 #endif /* __MLX5E_NVMEOTCP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
index 4c7dab28ef56..4f23f6e396b7 100644
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
 
+	stats->nvmeotcp_offload_packets++;
+	stats->nvmeotcp_offload_bytes += cclen;
 	mlx5e_nvmeotcp_put_queue(queue);
 	return true;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_stats.c
new file mode 100644
index 000000000000..8e800886cf27
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_stats.c
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES.
+
+#include "en_accel/nvmeotcp.h"
+
+/* Global counters */
+static const struct counter_desc nvmeotcp_sw_stats_desc[] = {
+	{ MLX5E_DECLARE_STAT(struct mlx5e_nvmeotcp_sw_stats, rx_nvmeotcp_sk_add) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_nvmeotcp_sw_stats, rx_nvmeotcp_sk_add_fail) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_nvmeotcp_sw_stats, rx_nvmeotcp_sk_del) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_nvmeotcp_sw_stats, rx_nvmeotcp_ddp_setup) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_nvmeotcp_sw_stats, rx_nvmeotcp_ddp_setup_fail) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_nvmeotcp_sw_stats, rx_nvmeotcp_ddp_teardown) },
+};
+
+/* Per-rx-queue counters */
+static const struct counter_desc nvmeotcp_rq_stats_desc[] = {
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_drop) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_resync) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_offload_packets) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_offload_bytes) },
+};
+
+/* Names of sums of the per-rx-queue counters
+ *
+ * The per-queue desc have the queue number in their name, so we
+ * cannot use them for the sums. We don't store the sums in sw_stats
+ * so there are no struct offsets to specify.
+ */
+static const char *const nvmeotcp_rq_sum_names[] = {
+	"rx_nvmeotcp_drop",
+	"rx_nvmeotcp_resync",
+	"rx_nvmeotcp_offload_packets",
+	"rx_nvmeotcp_offload_bytes",
+};
+
+static_assert(ARRAY_SIZE(nvmeotcp_rq_stats_desc) == ARRAY_SIZE(nvmeotcp_rq_sum_names));
+
+#define MLX5E_READ_CTR_ATOMIC64(ptr, dsc, i) \
+	atomic64_read((atomic64_t *)((char *)(ptr) + (dsc)[i].offset))
+
+int mlx5e_nvmeotcp_get_count(struct mlx5e_priv *priv)
+{
+	int max_nch = priv->stats_nch;
+
+	if (!priv->nvmeotcp)
+		return 0;
+
+	return ARRAY_SIZE(nvmeotcp_sw_stats_desc) +
+		ARRAY_SIZE(nvmeotcp_rq_stats_desc) +
+		(max_nch * ARRAY_SIZE(nvmeotcp_rq_stats_desc));
+}
+
+int mlx5e_nvmeotcp_get_strings(struct mlx5e_priv *priv, uint8_t *data)
+{
+	unsigned int i, ch, n = 0, idx = 0;
+
+	if (!priv->nvmeotcp)
+		return 0;
+
+	/* global counters */
+	for (i = 0; i < ARRAY_SIZE(nvmeotcp_sw_stats_desc); i++, n++)
+		strcpy(data + (idx++) * ETH_GSTRING_LEN,
+		       nvmeotcp_sw_stats_desc[i].format);
+
+	/* summed per-rx-queue counters */
+	for (i = 0; i < ARRAY_SIZE(nvmeotcp_rq_stats_desc); i++, n++)
+		strcpy(data + (idx++) * ETH_GSTRING_LEN,
+		       nvmeotcp_rq_sum_names[i]);
+
+	/* per-rx-queue counters */
+	for (ch = 0; ch < priv->stats_nch; ch++)
+		for (i = 0; i < ARRAY_SIZE(nvmeotcp_rq_stats_desc); i++, n++)
+			sprintf(data + (idx++) * ETH_GSTRING_LEN,
+				nvmeotcp_rq_stats_desc[i].format, ch);
+
+	return n;
+}
+
+int mlx5e_nvmeotcp_get_stats(struct mlx5e_priv *priv, u64 *data)
+{
+	unsigned int i, ch, n = 0, idx = 0, sum_start = 0;
+
+	if (!priv->nvmeotcp)
+		return 0;
+
+	/* global counters */
+	for (i = 0; i < ARRAY_SIZE(nvmeotcp_sw_stats_desc); i++, n++)
+		data[idx++] = MLX5E_READ_CTR_ATOMIC64(&priv->nvmeotcp->sw_stats,
+						      nvmeotcp_sw_stats_desc, i);
+
+	/* summed per-rx-queue counters */
+	sum_start = idx;
+	for (i = 0; i < ARRAY_SIZE(nvmeotcp_rq_stats_desc); i++, n++)
+		data[idx++] = 0;
+
+	/* per-rx-queue counters */
+	for (ch = 0; ch < priv->stats_nch; ch++) {
+		for (i = 0; i < ARRAY_SIZE(nvmeotcp_rq_stats_desc); i++, n++) {
+			u64 v = MLX5E_READ_CTR64_CPU(&priv->channel_stats[ch]->rq,
+						     nvmeotcp_rq_stats_desc, i);
+			data[idx++] = v;
+			data[sum_start + i] += v;
+		}
+	}
+
+	return n;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 7f763152f989..dc9fc48eff12 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -246,6 +246,8 @@ int mlx5e_ethtool_get_sset_count(struct mlx5e_priv *priv, int sset)
 		return MLX5E_NUM_PFLAGS;
 	case ETH_SS_TEST:
 		return mlx5e_self_test_num(priv);
+	case ETH_SS_ULP_DDP_STATS:
+		return mlx5e_stats_ulp_ddp_total_num(priv);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -276,6 +278,10 @@ void mlx5e_ethtool_get_strings(struct mlx5e_priv *priv, u32 stringset, u8 *data)
 	case ETH_SS_STATS:
 		mlx5e_stats_fill_strings(priv, data);
 		break;
+
+	case ETH_SS_ULP_DDP_STATS:
+		mlx5e_stats_ulp_ddp_fill_strings(priv, data);
+		break;
 	}
 }
 
@@ -2400,6 +2406,16 @@ static void mlx5e_get_rmon_stats(struct net_device *netdev,
 }
 
 #ifdef CONFIG_MLX5_EN_NVMEOTCP
+static int mlx5e_get_ulp_ddp_stats(struct net_device *netdev,
+				   u64 *stats)
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
@@ -2501,6 +2517,7 @@ const struct ethtool_ops mlx5e_ethtool_ops = {
 	.get_rmon_stats    = mlx5e_get_rmon_stats,
 	.get_link_ext_stats = mlx5e_get_link_ext_stats,
 #ifdef CONFIG_MLX5_EN_NVMEOTCP
+	.get_ulp_ddp_stats = mlx5e_get_ulp_ddp_stats,
 	.set_ulp_ddp_capabilities = mlx5e_set_ulp_ddp_capabilities,
 #endif
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 6687b8136e44..811f71ed8153 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -2497,3 +2497,20 @@ unsigned int mlx5e_nic_stats_grps_num(struct mlx5e_priv *priv)
 {
 	return ARRAY_SIZE(mlx5e_nic_stats_grps);
 }
+
+/* ULP DDP stats */
+
+unsigned int mlx5e_stats_ulp_ddp_total_num(struct mlx5e_priv *priv)
+{
+	return mlx5e_nvmeotcp_get_count(priv);
+}
+
+void mlx5e_stats_ulp_ddp_fill_strings(struct mlx5e_priv *priv, u8 *data)
+{
+	mlx5e_nvmeotcp_get_strings(priv, data);
+}
+
+void mlx5e_stats_ulp_ddp_get(struct mlx5e_priv *priv, u64 *stats)
+{
+	mlx5e_nvmeotcp_get_stats(priv, stats);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 375752d6546d..1b2a2c7de824 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -129,6 +129,10 @@ void mlx5e_stats_rmon_get(struct mlx5e_priv *priv,
 void mlx5e_get_link_ext_stats(struct net_device *dev,
 			      struct ethtool_link_ext_stats *stats);
 
+unsigned int mlx5e_stats_ulp_ddp_total_num(struct mlx5e_priv *priv);
+void mlx5e_stats_ulp_ddp_fill_strings(struct mlx5e_priv *priv, u8 *data);
+void mlx5e_stats_ulp_ddp_get(struct mlx5e_priv *priv, u64 *stats);
+
 /* Concrete NIC Stats */
 
 struct mlx5e_sw_stats {
@@ -395,6 +399,12 @@ struct mlx5e_rq_stats {
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

