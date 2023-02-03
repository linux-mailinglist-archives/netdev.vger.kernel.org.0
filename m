Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7AD96899C6
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbjBCNbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232866AbjBCNbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:31:08 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20608.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F4255BE
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:30:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LpeKX5RU85D71yXrNxQnHfxWsNmO0EBz/DIQecMYPG5uxrX3X4/U/bS4OQFu1R95DJSrZW+RR68MZb2y2+9N19AZPCglMDNkbxGCEhGm/A5qpI/STA4BF+Akfr+p8zTo9Z1PAagtYbX+veQr8/o6wvGEFv7p+DSnHg8Xx0EmVGj/zJmkumScFcxfDUYYNqf4TYvozVFLVSRcDggmlNAZ9EGsnSm0m6tzLDujKR9gZD+j+D/6M8uMKUh/L2aniKu/RXnXhARg5VoLYjdPct4DzQRRTwKezxwgg4CYfKPNys3GaASe9avL9xkwdKiDWtZJIvVyjdHXrUBRJnuwDfom2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cnh5x9bCBLaBW6IkwQgHvbk1H2B7LLi8Lq6VUgpmidY=;
 b=VS2IuBPtggnabpIRoB4yQxKyHiK4stfaW93UojkZ5B4g6TqXJ34rNvqLtWXTxKEbDvsRUOa9FWoDsHea5LGBSsWkFOEeqnNFxOn+zFYzS0HrDcOwHzTHTRD/O7EeeWUPJexC4ID7TCx3RVqcghjvnG4Jn7WRbUUaFudFKkPquiQee6QeQaVS1O29g18iF5PD5z3dMZp4sSjatBAvHjIYOkBqb2yCPlCjeAa3cR508J/I1PaHNt9ur+98nxr70q1R94eDc2/QGeYYw1pcAMevfjzBwHA7n4Y//RdC4J+qKIzbHf8Q9oRAtKFGxu274KyifoHgDw/DkU7NOyS4xKnYMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cnh5x9bCBLaBW6IkwQgHvbk1H2B7LLi8Lq6VUgpmidY=;
 b=UBn6XpjxvkdzDvMYLK13UiooFAMBKr7HCeiCupnAOvVjWK9N0qhsJd78FruXegDaDCka5VO4u+AIEJb/K7Bpolac74nhZb9miFM8YLKDSpxLWjWkyePoOHonoU1ua3weTsvmBXAayZmyrZEZ7D2cpgXYjqNZT2f32g4AE2hCc0DtMmuBURlEraPDFkMwvF8gIpeUAQZjTsf6ObRCPhMzcURqeX8LLBMYQTxnf62tXS1mcBLRW7BO1BGztkhAr40NjCDTxnrS1h33mvfVGjfU05JHf7m2UhmWw+rViS4wjH8RiRcYI2vGvYWtBB6jzv5yeM+ZvX2vprBr2oBsEWaCDQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH0PR12MB7929.namprd12.prod.outlook.com (2603:10b6:510:284::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 13:30:04 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 13:30:04 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v11 25/25] net/mlx5e: NVMEoTCP, statistics
Date:   Fri,  3 Feb 2023 15:27:05 +0200
Message-Id: <20230203132705.627232-26-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230203132705.627232-1-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0498.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::17) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH0PR12MB7929:EE_
X-MS-Office365-Filtering-Correlation-Id: 47bc9671-4d8c-4099-1ca7-08db05eac20c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 05CpOPwwBw73KuNjdi+elg7AhXkrddDUaG5R35g1oVm7esMGlFYL8Coj0Ip3D3eZm10/kOHxs94B6JZceiZc4SqSiQGgXgXRnzCc31dbQWzcDGB74ejV9bqSFa5t/vc+kQYoYF3JwUYJzW9pNWjDI2jxOS6WIeaEEeojPdhPMYNsLnv0f23pUSYlz9bpjrf2KHLVGb366oi0oypsni3/C8DVGbDdB+curznyy1naQvpgqQ9Z+6r0oWueB6/GT/kRRqrWz47KGVCzRnQOQQjCckbUa2aSR7wG4MZbOu69QR+glVX0Qqji1EXQuNNULWgj1RLTcvFlDBIOvkfBsIODPxuNwSYYzKEm4h5aXefgEN8OCuhXRXhsSvkkiWpzH2rM+sg4Hia57V5VDFtDyi1Cub3t0UbWXCnCzWQJWuTyvQyOvEEybbbozG5PXUKdRhki6NFa60yS7CwWne37Y9JxkG3fyrraHBKzccWl8aHpX3aYlK1rtLladdE2zXF2fdwpvQ1nsqlayEKhQWgJZIMYKQ7Ww4xa0nndagiSRYXVwKrUpFfrRZ0ju0eVFAvm3qSKddkkFZBtPlt2hO3vdBTxzHHm3ZuWCm1kCJJjOQERF2ybwSeFDrAHtKQKDmyU4sut6dRiqF/VQIMCZ52s5CRIwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(39860400002)(346002)(136003)(396003)(451199018)(2906002)(86362001)(41300700001)(478600001)(36756003)(30864003)(7416002)(107886003)(6512007)(6506007)(26005)(186003)(6486002)(2616005)(8936002)(5660300002)(1076003)(38100700002)(8676002)(66946007)(66556008)(4326008)(66476007)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kj7Hr3Diev2210zTZCoUh42OW98Pf1liOPkEdydAp1f5+dmXZAdxWUDFRgq3?=
 =?us-ascii?Q?9fnoJO1e1hfJsTSsDBZN2XeOERZS6mLKsPAzUCE18b4lBfiafX7r0R03bc5+?=
 =?us-ascii?Q?QxjkCAay85UELdn9eiXZTef+teHjH/9e+XjufVHSdLb5IIK0/d2JjbFs0Rc/?=
 =?us-ascii?Q?i/8Lgna7YyCi2gMsgqD1lUU1tefDpUoGy4NoS9sHH+bdnHBWOkbPmcLhuglQ?=
 =?us-ascii?Q?1DIPwvxPx6ByTk6yOn82zNzipwqYSAfvi+KBii2Ex7RCI8scNka5zpN5Gq/E?=
 =?us-ascii?Q?qir4QEwYEtbxfRIA3fCsjBsDfwu3WB2BRiPg0UjoRxEbxO3ZgRa1oI0Kvgk7?=
 =?us-ascii?Q?3f4pvC7XxyZHMj8WDyr0QspYUfx9sbF0z+876xJ1O9AfKT3jldsmdqluDuuE?=
 =?us-ascii?Q?hm/vfKJIA8nfMViEw8MEMxu20xJqD0esuE0HctFrnSoNdm7HDZsldgqrA1hH?=
 =?us-ascii?Q?epsx3RhfEYFiGoc5r3MCBEkWGm0b6aXY93QVcBHkrdHMETKJL9sLfckz5SaN?=
 =?us-ascii?Q?tp4fpI1V8SEFHeVeX8ApZqE0YRGih9R7oTLnJJiDT4mgx7wJDcBHSiqn9PCX?=
 =?us-ascii?Q?VxhlUxCSbWHW+Td38Ud7uEi6O+opBKrA9a6FPB0nfB4Er1vgnwHcfBwwQ1du?=
 =?us-ascii?Q?uhQAYNYJToNR/ErIN9y4bVdLzD1cTjktC3NTHw5/hO4ayXhf5+X/PHp/pFxD?=
 =?us-ascii?Q?rvRwmBrPgVw7p1bUZ4eFIEfIntiFAMMmL5DlOIW64lhyKp2HwCak1aiDzVAt?=
 =?us-ascii?Q?mEIbHcp2LjxpZ/gHMMPBm3v+d5DB5niKNTQ4UgGtQXixNVyC6grPuq6xwPzg?=
 =?us-ascii?Q?IuDohlb9BmrbFqQshQDt7jGtGZe0hFSY5douCEIvbE+XQxSykhAF7ySmqdhB?=
 =?us-ascii?Q?QrMpjyUbfBEFHFeTWs7CjMpv1lcTUmRSGwaFkBjM6W+P8DLGcGMWH3lwsA5E?=
 =?us-ascii?Q?0RhoCXicV1S/RlNyE8CrR7wUDqQittNKED55045kkpsEeuZ4apSZrUvjW7GN?=
 =?us-ascii?Q?xnkz4mBOm9yyRW8Ido+0I49AYxrPzqNtemYusNX3cSzF3dBRRP6LnK5vmG8g?=
 =?us-ascii?Q?e7tfBHWJgLsQ3LZrl8w9yn8ZhJlc0spxk9unhEl3gBhTvFMQv8osEZMFJg6L?=
 =?us-ascii?Q?0TSGAmxsVCW2V5t79tLdd6OhiC/av+Yh+Ih1HMlYE2mbHWl08PgKa3YSLZHp?=
 =?us-ascii?Q?6RONh0M5RCbhYe6gUcjtDK4Og7zVDv4Zbk9lOoUn4sbDaDTKlDJuMDM//7EO?=
 =?us-ascii?Q?z/WH2zFdoDTlx1n1IytRzDY6w9kLvtWA/3QfbgGFVT7KC7WGyVCYCBOxScP7?=
 =?us-ascii?Q?tQ+mavxNh+LhquWlO54Rrm5EkfZCM8rqTbprhUJ6OwNcy4oDtRTvsq2ELUo4?=
 =?us-ascii?Q?oZJBgxuc53fFml7qbBPHskxIqIaniUNkqvIgybi4sp0wqGA2Z5b9IhtzSoFc?=
 =?us-ascii?Q?IbuRBpNiBSmcve9io+sDWJ9hCWy2TH1RI2iDyhCJk2kpNdM/b15Sse1Se5xE?=
 =?us-ascii?Q?27KOwRwXlUiKx267wMhI3Gq27iwo/fcu3Vpf18FSrPjV2gZtUFGui1HfgmFD?=
 =?us-ascii?Q?ro5MbsLxzovjfUrCAFupJiXl6ZbYkEJVpxKrqV2P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47bc9671-4d8c-4099-1ca7-08db05eac20c
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 13:30:04.0522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bfWkuhtWxc9GOfBLVLdZD0mwVHDqKSXZZ6fDt851ig+s6Kg24a99K3Y+Jf8xijBBigPF204hqX7aOV2g02XWiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7929
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NVMEoTCP offload statistics include both control and data path
statistic: counters for the netdev ddp ops, offloaded packets/bytes,
resync and dropped packets.

Expose the statistics using ulp_ddp_ops->get_stats()
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
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 53 ++++++++++++---
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    | 16 +++++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.c        | 11 +++-
 .../mlx5/core/en_accel/nvmeotcp_stats.c       | 66 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  7 ++
 6 files changed, 145 insertions(+), 11 deletions(-)
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
index 3fb082cfc632..af8635a3d7b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -4,6 +4,7 @@
 #include <linux/netdevice.h>
 #include <linux/idr.h>
 #include <linux/nvme-tcp.h>
+#include <linux/ethtool.h>
 #include "en_accel/nvmeotcp.h"
 #include "en_accel/nvmeotcp_utils.h"
 #include "en_accel/fs_tcp.h"
@@ -614,9 +615,15 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
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
@@ -643,11 +650,11 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
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
@@ -659,6 +666,7 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 	if (err)
 		goto destroy_rx;
 
+	atomic64_inc(&sw_stats->rx_nvmeotcp_sk_add);
 	write_lock_bh(&sk->sk_callback_lock);
 	ulp_ddp_set_ctx(sk, queue);
 	write_unlock_bh(&sk->sk_callback_lock);
@@ -672,6 +680,7 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 free_queue:
 	kfree(queue);
 out:
+	atomic64_inc(&sw_stats->rx_nvmeotcp_sk_add_fail);
 	return err;
 }
 
@@ -685,6 +694,8 @@ mlx5e_nvmeotcp_queue_teardown(struct net_device *netdev,
 
 	queue = container_of(ulp_ddp_get_ctx(sk), struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
 
+	atomic64_inc(&queue->sw_stats->rx_nvmeotcp_sk_del);
+
 	WARN_ON(refcount_read(&queue->ref_count) != 1);
 	mlx5e_nvmeotcp_destroy_rx(priv, queue, mdev);
 
@@ -816,25 +827,34 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
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
@@ -846,8 +866,13 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
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
@@ -894,6 +919,7 @@ mlx5e_nvmeotcp_ddp_teardown(struct net_device *netdev,
 	q_entry->queue = queue;
 
 	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_INV_UMR, ddp->command_id, 0);
+	atomic64_inc(&queue->sw_stats->rx_nvmeotcp_ddp_teardown);
 }
 
 static void
@@ -927,6 +953,14 @@ void mlx5e_nvmeotcp_put_queue(struct mlx5e_nvmeotcp_queue *queue)
 	}
 }
 
+static int mlx5e_ulp_ddp_get_stats(struct net_device *dev,
+				   struct ethtool_ulp_ddp_stats *stats)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+
+	return mlx5e_nvmeotcp_get_stats(priv, stats);
+}
+
 int set_ulp_ddp_nvme_tcp(struct net_device *netdev, bool enable)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -1015,6 +1049,7 @@ const struct ulp_ddp_dev_ops mlx5e_nvmeotcp_ops = {
 	.teardown = mlx5e_nvmeotcp_ddp_teardown,
 	.resync = mlx5e_nvmeotcp_ddp_resync,
 	.set_caps = mlx5e_ulp_ddp_set_caps,
+	.get_stats = mlx5e_ulp_ddp_get_stats,
 };
 
 void mlx5e_nvmeotcp_build_netdev(struct mlx5e_priv *priv)
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

