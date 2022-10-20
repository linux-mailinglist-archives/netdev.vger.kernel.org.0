Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA66605C27
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiJTKWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiJTKVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:21:18 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90B12DE2
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:20:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fTdb44DLOMQ50aCzKvr0Q6cOKPH/RvKy+kwRv+Fn1feYrgowhEuXERS8m89lT8HqV8pVUrcFURJCdIKWP1YuMLNcwU1l5tmDFGkxdxFCrb9gBkoQhsN/EfvIyo/iMRaXKxhSDeX7azBe+WhDktlarduOyCoZr69OWimUc+WJ+H/QCr4twAfTPltWqCwVXf7LobE97w2UsHzeVpD/xuelUqBV288iqaUUwnNx0i7LFWxCOukWe6PVmkJGRyPNa4+9JsqTEnZreu77p7pIZdJ9jP/tbIgRByO5UO5KfKOQ3psUAHv1+x9gXYh4Urli7pDMdeExIu5QhkPk98POabXKEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XePqweTNL9ty/66V/HnpENohxyvIrmAoYQVLo2gH1/E=;
 b=fqbS9y/Z1OZNDo4LctqlNLmiJN9AYc67lNLKCFvTVsv1VHadtAzaBV5Xz6jHpJRqxRjUKArNyL73T8mJ7NYkmoFJMAANojwdGtkvHqeN/GByu5NG96fAownoY+VtkmyqkgeZQ6eM+x0JzlJkJx/5lAELY5Ic5neWeUzBjViDZ9wfmJ9yg+0VOcZRB00clLp+MdJvBxcPjlteTEZg+1Kz5wGoKEs6owJ3q6IeT/aZiNa7Vqt8mXqwbN2aUM3K9phc9R7zwCqZgtdmtCAdenmqTc/nkrltLqKs6l0WuriMOd0IbE/XdVtVVxyp4XB7GuK55TQfKeQKla+W4S27cpClkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XePqweTNL9ty/66V/HnpENohxyvIrmAoYQVLo2gH1/E=;
 b=blPUfNMHtHBwh+kzOGcRjAzTIHPPEF0thc04Gl+f2QlcDjaJK0f2BJXpcZA/HFRevszXT18baBfb9TPAbuU3RJI2mGWT0WF02USXlgqC7KQAJ2LS0FPvRYzl/gO+qSw8reUkoyc2ZjvyuDL3ahhPd/ghmbrqThmZ7N9nhCd+6LPUkNq5FhZNdIiaN5RBX7946fx/DJQ1e/TV+n40rl3iuFMzagwaaQIEPSI1iNpP7bts1aUbGjzS7qA+onPB5dm0HRIL6p/swwXkTF1eLgbxhOC3a987otMSNBS7nzfFN4sHJZUBchQ/H95dHlG+fFoaRTKRCqjaK6GSuMXUf6Vquw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5133.namprd12.prod.outlook.com (2603:10b6:5:390::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Thu, 20 Oct
 2022 10:20:22 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 10:20:22 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v6 16/23] net/mlx5e: NVMEoTCP, offload initialization
Date:   Thu, 20 Oct 2022 13:18:31 +0300
Message-Id: <20221020101838.2712846-17-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221020101838.2712846-1-aaptel@nvidia.com>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::17) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5133:EE_
X-MS-Office365-Filtering-Correlation-Id: 2298d7a2-588a-4c6b-fda8-08dab284b24e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5jHPUme7/is+gv3PHeUTB1BbwlocJLaKvNo/TCikx9sK7Cec6e+1Kf45pGsgFkojCB/owp4Q84MkMln9ckNocGnNVFNrir2oeW+fONajtHdjXdf6t+atOj4pUntin8VUHOwXB4+uh+8elYh18bBi8sWvJg0Lx3WpArMfF5XJ904pwlVy0kaIY6JUyfX5dC404Kg2msRDzsmjLBZ2FVTZgzLjYStn3tuFrk74cnEJTRuLTcSEQ3u/LWD0cWVYO08aSM2rrxFiEpnKSizF8uqNHTVThZUhjBEfB9/VHoOfFIpSilvcIfg2FTB5vTJKHpQ86Wv4hY//xl9orE+kfM1vMCIOIKDlXDvPQRPZoGMkMLnKM3fnU8cEnjUe5fDztQARgSWVc54z7Mnzjr4u0btYsyA2RwU/cEHZpaq2tsoobMrZxBPBgUkaJ4WE+wrrWnxe8gL06cQGfdeWfJYKqLVJ3IIsMrwtALK6SPApZiq+HQhMiBXimn1RgU923HSFc7Eoq5JlNt6C+HBeLm9Uu699ex0/6lIl4IfjfRbtstHouTpNK5aBQju6dxa3taonb89ElPX6AQpnp7J4t0fyu3QPThapgJQOnOk2Gb8TJxsjXfjF8/egGgfW+eVrM3ktcWCPiy2/fLS0Ji4t/mHkUSyW9QN1sTj2J+hj1H3Tj5V9gkXbC8Is93NUDL/HumyBFiFXt4mdpHUPMcS9HRmC/KWLbaDfeDGENNetxW+K4ZYFn9p7u1eHooeIchDdhQjBZ0T3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199015)(66899015)(6506007)(6512007)(26005)(4326008)(86362001)(2906002)(921005)(8936002)(7416002)(30864003)(5660300002)(36756003)(41300700001)(66476007)(8676002)(66556008)(38100700002)(83380400001)(66946007)(316002)(6486002)(6636002)(186003)(2616005)(1076003)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jSvJIR/oGh60lXbyWzD6NZarL4MQdYi8yS4dFlWus5gVEGvUPdidJWeQHqy6?=
 =?us-ascii?Q?S/9IVbrcuP9LGlwInCTEHvTzwR4Me0u2AX9h1+pboxrBE7L9fdzQfMGp0J0i?=
 =?us-ascii?Q?GU0SnJViRuPawOHJqpvhYCqbEEV7RHJQK4fzYUG5LtLNOkiOmNv2kd59PaUP?=
 =?us-ascii?Q?fChr11qjr/0wgm25GK8dRAFzob6A+XB0iK3sVtd7EvuzFeHewLHKX1bBdw/F?=
 =?us-ascii?Q?E4V6vkU6bbsO6OuYDFnadHdPArWTb/KSHuMCTZVUI3FyzA8SBGZ/WtpmRZSC?=
 =?us-ascii?Q?vh+Gc98qd8vMBT2UYcp70sxJl4yL4b72YOvvT/IG8KLgF574sCDSTTeK4glc?=
 =?us-ascii?Q?nKqqY7LZ/PyTe0tutoIwu+wwVjV6EQChyjWnKTFeeRr0fXWKgL9yof43d38Q?=
 =?us-ascii?Q?PiHcs6fal6Rkgk0vFc1s1bszDSmW9GwdqDZozGG5fNgZl4BDvuFCFDLSEWD2?=
 =?us-ascii?Q?OGB9Ov6Awuw7h/p4L1TnSGB3FOdyM+Q/nqHGSGWqYZlHjFTp55Fo7io4xB8C?=
 =?us-ascii?Q?N5cgL0YCIwDddT16V5C5M+lmggMdVU/5UyIfwwknoAE3Zk3htg/gFZDmTzOz?=
 =?us-ascii?Q?Dw2GW1VSMaZG5PeKyu6O+1RauM4ARG+9AGaIZ7tk91laYNLX61fFtu9cmO33?=
 =?us-ascii?Q?Rv3TDLOYBTdqKuU5xBg5mPAhzi0NIZ4DGoPxQdLevljj+irsQud9T3WPlMJV?=
 =?us-ascii?Q?ig+YWHwfYNI8A6oZGn3QKzongZBrCtHLDNhGHczQwvTTKUchB1I9iGyadcYi?=
 =?us-ascii?Q?fN1lzXQvTUqLgfeqgV31ULrvHFbCVIFk4XJBW3FfWrbTDDq0/ZitST49d75W?=
 =?us-ascii?Q?y9xrI8oySUzVHl/ktT/LLTUB2XwBoL0aZc65H9culzDFvx2b02YkGArTPvId?=
 =?us-ascii?Q?z+MxKNX8aHGVYnktgL8/Iu3Raz2RxdImX9ifSprHnwgsbYjO8FqEdqWm0l2x?=
 =?us-ascii?Q?P36sXhQb+EzTK5lnzPw3zx7mHp1vzVQr4ApzTMJAE6qzr7BkQqqvNw7Vc+KK?=
 =?us-ascii?Q?Ug52uyNyelMZBFfoCSR/rPrG0hL6xVC5Vk9QGdj9ZwUIhr5RE+BGB1tTafyT?=
 =?us-ascii?Q?HR5ntVdBTVoDiDp2KBtuDh5XLeC/U3QJ++kpDJktk+95jLYltHiWzbmTFfic?=
 =?us-ascii?Q?sy6V+JKPMmy/mfLR66RX8uV0iRVp3EWpyYzv/UIvm9v/XDaut0edc8OqEBbz?=
 =?us-ascii?Q?joYWndl9zIX7kL4oLZZBTcNpKba1aupRg3ykcAvkh/pzCGsHWK/RNR4UT+kV?=
 =?us-ascii?Q?bb2B7H1/hug0H/KWGpshUqKOUH32b3NkI9XToCYLXVgA5QjTpwIJKr+RIl4/?=
 =?us-ascii?Q?Co3iwYJBU6HhWWECLmW5rSL5YoiMhyqckF1UOU0Mi+G5u8lOiORbQSZujyG3?=
 =?us-ascii?Q?lwSDEJAk97fMDo/s0uhEAgRQFBy6O0OnJcdUBvPUeF9CXwePHzRuTamPttA3?=
 =?us-ascii?Q?Cc17Dq7UPxwyIJKJzLjUdDfVCrCuAleMaF2PXt4OEe9nq34wBAFaexjT62xQ?=
 =?us-ascii?Q?NUq9lGlsGnJaFLS5/kO6sKRbViz6DsLzg3EeTspkgx1nAEjwbPziwSvsgz0J?=
 =?us-ascii?Q?jniZ8uuc5d6vSxP2opYazrWtH5qvTszAUItjHJi2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2298d7a2-588a-4c6b-fda8-08dab284b24e
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 10:20:22.5627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tT5lJu6sbfRKjhd0jTAv5LmipRrnM/oWdW929FFHFvJamxme9O5HpNgv2/iSg6VUXet2E70RYwoAw3KAGZY5Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5133
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

This commit introduces the driver structures and initialization blocks
for NVMEoTCP offload. The mlx5 nvmeotcp structures are:

- queue (mlx5e_nvmeotcp_queue) - pairs 1:1 with nvmeotcp driver queues and
  deals with the offloading parts. The mlx5e queue is accessed in the ddp
  ops: initialized on sk_add, used in ddp setup,teardown,resync and in the
  fast path when dealing with packets, destroyed in the sk_del op.

- queue entry (nvmeotcp_queue_entry) - pairs 1:1 with offloaded IO from
  that queue. Keeps pointers to the SG elements describing the buffers
  used for the IO and the ddp context of it.

- queue handler (mlx5e_nvmeotcp_queue_handler) - we use icosq per NVME-TCP
  queue for UMR mapping as part of the ddp offload. Those dedicated SQs are
  unique in the sense that they are driven directly by the NVME-TCP layer
  to submit and invalidate ddp requests.
  Since the life-cycle of these icosqs is not tied to the channels, we
  create dedicated napi contexts for polling them such that channels can be
  re-created during offloading. The queue handler has pointer to the cq
  associated with the queue's sq and napi context.

- main offload context (mlx5e_nvmeotcp) - has ida and hash table instances.
  Each offloaded queue gets an ID from the ida instance and the <id, queue>
  pairs are kept in the hash table. The id is programmed as flow tag to be
  set by HW on the completion (cqe) of all packets related to this queue
  (by 5-tuple steering). The fast path which deals with packets uses the
  flow tag to access the hash table and retrieve the queue for the
  processing.

We query nvmeotcp capabilities to see if the offload can be supported and
use 128B CQEs when this happens. By default, the offload is off but can
be enabled with `ethtool -K <device> ulp-ddp-offload on`.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |  11 ++
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   4 +
 .../ethernet/mellanox/mlx5/core/en/params.c   |  12 +-
 .../ethernet/mellanox/mlx5/core/en/params.h   |   3 +
 .../mellanox/mlx5/core/en_accel/en_accel.h    |   3 +
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 175 ++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    | 119 ++++++++++++
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |   5 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  26 +++
 .../net/ethernet/mellanox/mlx5/core/main.c    |   1 +
 11 files changed, 357 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 26685fd0fdaa..0c790952fdf7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -163,6 +163,17 @@ config MLX5_EN_TLS
 	help
 	Build support for TLS cryptography-offload acceleration in the NIC.
 
+config MLX5_EN_NVMEOTCP
+	bool "NVMEoTCP acceleration"
+	depends on ULP_DDP
+	depends on MLX5_CORE_EN
+	default y
+	help
+	Build support for NVMEoTCP acceleration in the NIC.
+	This includes Direct Data Placement and CRC offload.
+	Note: Support for hardware with this capability needs to be selected
+	for this option to become available.
+
 config MLX5_SW_STEERING
 	bool "Mellanox Technologies software-managed steering"
 	depends on MLX5_CORE_EN && MLX5_ESWITCH
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index a22c32aabf11..222cdb1586a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -103,6 +103,8 @@ mlx5_core-$(CONFIG_MLX5_EN_TLS) += en_accel/ktls_stats.o \
 				   en_accel/fs_tcp.o en_accel/ktls.o en_accel/ktls_txrx.o \
 				   en_accel/ktls_tx.o en_accel/ktls_rx.o
 
+mlx5_core-$(CONFIG_MLX5_EN_NVMEOTCP) += en_accel/fs_tcp.o en_accel/nvmeotcp.o
+
 mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o \
 					steering/dr_matcher.o steering/dr_rule.o \
 					steering/dr_icm_pool.o steering/dr_buddy.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index cf6bb00e735c..e1d779ec4d8c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -328,6 +328,7 @@ struct mlx5e_params {
 	unsigned int sw_mtu;
 	int hard_mtu;
 	bool ptp_rx;
+	bool nvmeotcp;
 };
 
 static inline u8 mlx5e_get_dcb_num_tc(struct mlx5e_params *params)
@@ -957,6 +958,9 @@ struct mlx5e_priv {
 #endif
 #ifdef CONFIG_MLX5_EN_TLS
 	struct mlx5e_tls          *tls;
+#endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	struct mlx5e_nvmeotcp      *nvmeotcp;
 #endif
 	struct devlink_health_reporter *tx_reporter;
 	struct devlink_health_reporter *rx_reporter;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 29dd3a04c154..4f2235379d93 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -805,7 +805,8 @@ static void mlx5e_build_common_cq_param(struct mlx5_core_dev *mdev,
 	void *cqc = param->cqc;
 
 	MLX5_SET(cqc, cqc, uar_page, mdev->priv.uar->index);
-	if (MLX5_CAP_GEN(mdev, cqe_128_always) && cache_line_size() >= 128)
+	if (MLX5_CAP_GEN(mdev, cqe_128_always) &&
+	    (cache_line_size() >= 128 || param->force_cqe128))
 		MLX5_SET(cqc, cqc, cqe_sz, CQE_STRIDE_128_PAD);
 }
 
@@ -835,6 +836,9 @@ static void mlx5e_build_rx_cq_param(struct mlx5_core_dev *mdev,
 	void *cqc = param->cqc;
 	u8 log_cq_size;
 
+	/* nvme-tcp offload mandates 128 byte cqes */
+	param->force_cqe128 |= IS_ENABLED(CONFIG_MLX5_EN_NVMEOTCP) && params->nvmeotcp;
+
 	switch (params->rq_wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
 		hw_stridx = MLX5_CAP_GEN(mdev, mini_cqe_resp_stride_index);
@@ -1170,9 +1174,9 @@ static u8 mlx5e_build_async_icosq_log_wq_sz(struct mlx5_core_dev *mdev)
 	return MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
 }
 
-static void mlx5e_build_icosq_param(struct mlx5_core_dev *mdev,
-				    u8 log_wq_size,
-				    struct mlx5e_sq_param *param)
+void mlx5e_build_icosq_param(struct mlx5_core_dev *mdev,
+			     u8 log_wq_size,
+			     struct mlx5e_sq_param *param)
 {
 	void *sqc = param->sqc;
 	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 034debd140bc..a56e8b19b188 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -17,6 +17,7 @@ struct mlx5e_cq_param {
 	struct mlx5_wq_param       wq;
 	u16                        eq_ix;
 	u8                         cq_period_mode;
+	bool                       force_cqe128;
 };
 
 struct mlx5e_rq_param {
@@ -146,6 +147,8 @@ void mlx5e_build_xdpsq_param(struct mlx5_core_dev *mdev,
 			     struct mlx5e_params *params,
 			     struct mlx5e_xsk_param *xsk,
 			     struct mlx5e_sq_param *param);
+void mlx5e_build_icosq_param(struct mlx5_core_dev *mdev,
+			     u8 log_wq_size, struct mlx5e_sq_param *param);
 int mlx5e_build_channel_param(struct mlx5_core_dev *mdev,
 			      struct mlx5e_params *params,
 			      u16 q_counter,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 07187028f0d3..e38656229399 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -40,6 +40,7 @@
 #include "en_accel/ktls.h"
 #include "en_accel/ktls_txrx.h"
 #include <en_accel/macsec.h>
+#include "en_accel/nvmeotcp.h"
 #include "en.h"
 #include "en/txrx.h"
 
@@ -202,11 +203,13 @@ static inline void mlx5e_accel_tx_finish(struct mlx5e_txqsq *sq,
 
 static inline int mlx5e_accel_init_rx(struct mlx5e_priv *priv)
 {
+	mlx5e_nvmeotcp_init_rx(priv);
 	return mlx5e_ktls_init_rx(priv);
 }
 
 static inline void mlx5e_accel_cleanup_rx(struct mlx5e_priv *priv)
 {
+	mlx5e_nvmeotcp_cleanup_rx(priv);
 	mlx5e_ktls_cleanup_rx(priv);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
new file mode 100644
index 000000000000..b00dc46c7c3c
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES.
+
+#include <linux/netdevice.h>
+#include <linux/idr.h>
+#include "en_accel/nvmeotcp.h"
+#include "en_accel/fs_tcp.h"
+#include "en/txrx.h"
+
+#define MAX_NUM_NVMEOTCP_QUEUES	(512)
+#define MIN_NUM_NVMEOTCP_QUEUES	(1)
+
+static const struct rhashtable_params rhash_queues = {
+	.key_len = sizeof(int),
+	.key_offset = offsetof(struct mlx5e_nvmeotcp_queue, id),
+	.head_offset = offsetof(struct mlx5e_nvmeotcp_queue, hash),
+	.automatic_shrinking = true,
+	.min_size = MIN_NUM_NVMEOTCP_QUEUES,
+	.max_size = MAX_NUM_NVMEOTCP_QUEUES,
+};
+
+static int
+mlx5e_nvmeotcp_offload_limits(struct net_device *netdev,
+			      struct ulp_ddp_limits *ulp_limits)
+{
+	return 0;
+}
+
+static int
+mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
+			  struct sock *sk,
+			  struct ulp_ddp_config *tconfig)
+{
+	return 0;
+}
+
+static void
+mlx5e_nvmeotcp_queue_teardown(struct net_device *netdev,
+			      struct sock *sk)
+{
+}
+
+static int
+mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
+			 struct sock *sk,
+			 struct ulp_ddp_io *ddp)
+{
+	return 0;
+}
+
+static int
+mlx5e_nvmeotcp_ddp_teardown(struct net_device *netdev,
+			    struct sock *sk,
+			    struct ulp_ddp_io *ddp,
+			    void *ddp_ctx)
+{
+	return 0;
+}
+
+static void
+mlx5e_nvmeotcp_ddp_resync(struct net_device *netdev,
+			  struct sock *sk, u32 seq)
+{
+}
+
+static const struct ulp_ddp_dev_ops mlx5e_nvmeotcp_ops = {
+	.ulp_ddp_limits = mlx5e_nvmeotcp_offload_limits,
+	.ulp_ddp_sk_add = mlx5e_nvmeotcp_queue_init,
+	.ulp_ddp_sk_del = mlx5e_nvmeotcp_queue_teardown,
+	.ulp_ddp_setup = mlx5e_nvmeotcp_ddp_setup,
+	.ulp_ddp_teardown = mlx5e_nvmeotcp_ddp_teardown,
+	.ulp_ddp_resync = mlx5e_nvmeotcp_ddp_resync,
+};
+
+int set_feature_nvme_tcp(struct net_device *netdev, bool enable)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_params new_params;
+	int err = 0;
+
+	/* There may be offloaded queues when an ethtool callback to disable the feature is made.
+	 * Hence, we can't destroy the tcp flow-table since it may be referenced by the offload
+	 * related flows and we'll keep the 128B CQEs on the channel RQs. Also, since we don't
+	 * deref/destroy the fs tcp table when the feature is disabled, we don't ref it again
+	 * if the feature is enabled multiple times.
+	 */
+	if (!enable || priv->nvmeotcp->enabled)
+		return 0;
+
+	mutex_lock(&priv->state_lock);
+
+	err = mlx5e_accel_fs_tcp_create(priv->fs);
+	if (err)
+		goto out_err;
+
+	new_params = priv->channels.params;
+	new_params.nvmeotcp = enable;
+	err = mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
+	if (err)
+		goto fs_tcp_destroy;
+
+	priv->nvmeotcp->enabled = true;
+
+	mutex_unlock(&priv->state_lock);
+	return 0;
+
+fs_tcp_destroy:
+	mlx5e_accel_fs_tcp_destroy(priv->fs);
+out_err:
+	mutex_unlock(&priv->state_lock);
+	return err;
+}
+
+void mlx5e_nvmeotcp_build_netdev(struct mlx5e_priv *priv)
+{
+	struct net_device *netdev = priv->netdev;
+	struct mlx5_core_dev *mdev = priv->mdev;
+
+	if (!(MLX5_CAP_GEN(mdev, nvmeotcp) &&
+	      MLX5_CAP_DEV_NVMEOTCP(mdev, zerocopy) &&
+	      MLX5_CAP_DEV_NVMEOTCP(mdev, crc_rx) && MLX5_CAP_GEN(mdev, cqe_128_always)))
+		return;
+
+	/* report ULP DPP as supported, but don't enable it by default */
+	netdev->hw_features |= NETIF_F_HW_ULP_DDP;
+	netdev->ulp_ddp_ops = &mlx5e_nvmeotcp_ops;
+}
+
+void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv)
+{
+	if (priv->nvmeotcp && priv->nvmeotcp->enabled)
+		mlx5e_accel_fs_tcp_destroy(priv->fs);
+}
+
+int mlx5e_nvmeotcp_init(struct mlx5e_priv *priv)
+{
+	struct mlx5e_nvmeotcp *nvmeotcp = NULL;
+	int ret = 0;
+
+	if (!MLX5_CAP_GEN(priv->mdev, nvmeotcp))
+		return 0;
+
+	nvmeotcp = kzalloc(sizeof(*nvmeotcp), GFP_KERNEL);
+
+	if (!nvmeotcp)
+		return -ENOMEM;
+
+	ida_init(&nvmeotcp->queue_ids);
+	ret = rhashtable_init(&nvmeotcp->queue_hash, &rhash_queues);
+	if (ret)
+		goto err_ida;
+
+	nvmeotcp->enabled = false;
+
+	priv->nvmeotcp = nvmeotcp;
+	return 0;
+
+err_ida:
+	ida_destroy(&nvmeotcp->queue_ids);
+	kfree(nvmeotcp);
+	return ret;
+}
+
+void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv)
+{
+	struct mlx5e_nvmeotcp *nvmeotcp = priv->nvmeotcp;
+
+	if (!nvmeotcp)
+		return;
+
+	rhashtable_destroy(&nvmeotcp->queue_hash);
+	ida_destroy(&nvmeotcp->queue_ids);
+	kfree(nvmeotcp);
+	priv->nvmeotcp = NULL;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
new file mode 100644
index 000000000000..ef24dbd7a1c8
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
@@ -0,0 +1,119 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. */
+#ifndef __MLX5E_NVMEOTCP_H__
+#define __MLX5E_NVMEOTCP_H__
+
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+
+#include <net/ulp_ddp.h>
+#include "en.h"
+#include "en/params.h"
+
+struct mlx5e_nvmeotcp_queue_entry {
+	struct mlx5e_nvmeotcp_queue *queue;
+	u32 sgl_length;
+	u32 klm_mkey;
+	struct scatterlist *sgl;
+	u32 ccid_gen;
+	u64 size;
+
+	/* for the ddp invalidate done callback */
+	void *ddp_ctx;
+	struct ulp_ddp_io *ddp;
+};
+
+struct mlx5e_nvmeotcp_queue_handler {
+	struct napi_struct napi;
+	struct mlx5e_cq *cq;
+};
+
+/**
+ *	struct mlx5e_nvmeotcp_queue - mlx5 metadata for NVMEoTCP queue
+ *	@ulp_ddp_ctx: Generic ulp ddp context
+ *	@tir: Destination TIR created for NVMEoTCP offload
+ *	@fh: Flow handle representing the 5-tuple steering for this flow
+ *	@id: Flow tag ID used to identify this queue
+ *	@size: NVMEoTCP queue depth
+ *	@ccid_gen: Generation ID for the CCID, used to avoid conflicts in DDP
+ *	@max_klms_per_wqe: Number of KLMs per DDP operation
+ *	@hash: Hash table of queues mapped by @id
+ *	@pda: Padding alignment
+ *	@tag_buf_table_id: Tag buffer table for CCIDs
+ *	@dgst: Digest supported (header and/or data)
+ *	@sq: Send queue used for posting umrs
+ *	@ref_count: Reference count for this structure
+ *	@after_resync_cqe: Indicate if resync occurred
+ *	@ccid_table: Table holding metadata for each CC (Command Capsule)
+ *	@ccid: ID of the current CC
+ *	@ccsglidx: Index within the scatter-gather list (SGL) of the current CC
+ *	@ccoff: Offset within the current CC
+ *	@ccoff_inner: Current offset within the @ccsglidx element
+ *	@channel_ix: Channel IX for this nvmeotcp_queue
+ *	@sk: The socket used by the NVMe-TCP queue
+ *	@crc_rx: CRC Rx offload indication for this queue
+ *	@priv: mlx5e netdev priv
+ *	@static_params_done: Async completion structure for the initial umr mapping synchronization
+ *	@sq_lock: Spin lock for the icosq
+ *	@qh: Completion queue handler for processing umr completions
+ */
+struct mlx5e_nvmeotcp_queue {
+	struct ulp_ddp_ctx ulp_ddp_ctx;
+	struct mlx5e_tir tir;
+	struct mlx5_flow_handle *fh;
+	int id;
+	u32 size;
+	/* needed when the upper layer immediately reuses CCID + some packet loss happens */
+	u32 ccid_gen;
+	u32 max_klms_per_wqe;
+	struct rhash_head hash;
+	int pda;
+	u32 tag_buf_table_id;
+	u8 dgst;
+	struct mlx5e_icosq sq;
+
+	/* data-path section cache aligned */
+	refcount_t ref_count;
+	/* for MASK HW resync cqe */
+	bool after_resync_cqe;
+	struct mlx5e_nvmeotcp_queue_entry *ccid_table;
+	/* current ccid fields */
+	int ccid;
+	int ccsglidx;
+	off_t ccoff;
+	int ccoff_inner;
+
+	u32 channel_ix;
+	struct sock *sk;
+	u8 crc_rx:1;
+	/* for ddp invalidate flow */
+	struct mlx5e_priv *priv;
+	/* end of data-path section */
+
+	struct completion static_params_done;
+	/* spin lock for the ico sq, ULP can issue requests from multiple contexts */
+	spinlock_t sq_lock;
+	struct mlx5e_nvmeotcp_queue_handler qh;
+};
+
+struct mlx5e_nvmeotcp {
+	struct ida queue_ids;
+	struct rhashtable queue_hash;
+	bool enabled;
+};
+
+void mlx5e_nvmeotcp_build_netdev(struct mlx5e_priv *priv);
+int mlx5e_nvmeotcp_init(struct mlx5e_priv *priv);
+int set_feature_nvme_tcp(struct net_device *netdev, bool enable);
+void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv);
+static inline void mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv) {}
+void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv);
+#else
+
+static inline void mlx5e_nvmeotcp_build_netdev(struct mlx5e_priv *priv) {}
+static inline int mlx5e_nvmeotcp_init(struct mlx5e_priv *priv) { return 0; }
+static inline void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv) {}
+static inline int set_feature_nvme_tcp(struct net_device *netdev, bool enable) { return 0; }
+static inline void mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv) {}
+static inline void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv) {}
+#endif
+#endif /* __MLX5E_NVMEOTCP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 24aa25da482b..c3dcc1f808a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1957,6 +1957,11 @@ int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool new_val
 		return -EINVAL;
 	}
 
+	if (priv->channels.params.nvmeotcp) {
+		netdev_warn(priv->netdev, "Can't set CQE compression after ulp-ddp-offload\n");
+		return -EINVAL;
+	}
+
 	new_params = priv->channels.params;
 	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_RX_CQE_COMPRESS, new_val);
 	if (rx_filter)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ad7bdb1e94a2..971d13ffbc8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -48,6 +48,7 @@
 #include "en_accel/macsec.h"
 #include "en_accel/en_accel.h"
 #include "en_accel/ktls.h"
+#include "en_accel/nvmeotcp.h"
 #include "lib/vxlan.h"
 #include "lib/clock.h"
 #include "en/port.h"
@@ -4031,6 +4032,9 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_NTUPLE, set_feature_arfs);
 #endif
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TLS_RX, mlx5e_ktls_set_feature_rx);
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_ULP_DDP, set_feature_nvme_tcp);
+#endif
 
 	if (err) {
 		netdev->features = oper_features;
@@ -4126,6 +4130,21 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 			netdev_warn(netdev, "Disabling HW-GRO, not supported when CQE compress is active\n");
 			features &= ~NETIF_F_GRO_HW;
 		}
+
+		if (features & NETIF_F_HW_ULP_DDP) {
+			features &= ~NETIF_F_HW_ULP_DDP;
+			netdev_warn(netdev, "Disabling ulp-ddp offload, not supported when CQE compress is active\n");
+		}
+	}
+
+	if (features & (NETIF_F_LRO | NETIF_F_GRO_HW)) {
+		if (params->nvmeotcp) {
+			netdev_warn(netdev, "Disabling HW-GRO/LRO, not supported after ulp-ddp-offload\n");
+			features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
+		} else if (features & NETIF_F_HW_ULP_DDP) {
+			netdev_warn(netdev, "Disabling ulp-ddp-offload, not supported with HW_GRO/LRO\n");
+			features &= ~NETIF_F_HW_ULP_DDP;
+		}
 	}
 
 	if (mlx5e_is_uplink_rep(priv))
@@ -5163,6 +5182,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	mlx5e_macsec_build_netdev(priv);
 	mlx5e_ipsec_build_netdev(priv);
 	mlx5e_ktls_build_netdev(priv);
+	mlx5e_nvmeotcp_build_netdev(priv);
 }
 
 void mlx5e_create_q_counters(struct mlx5e_priv *priv)
@@ -5232,13 +5252,19 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	if (err)
 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
 
+	err = mlx5e_nvmeotcp_init(priv);
+	if (err)
+		mlx5_core_err(mdev, "NVMEoTCP initialization failed, %d\n", err);
+
 	mlx5e_health_create_reporters(priv);
+
 	return 0;
 }
 
 static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 {
 	mlx5e_health_destroy_reporters(priv);
+	mlx5e_nvmeotcp_cleanup(priv);
 	mlx5e_ktls_cleanup(priv);
 	mlx5e_ipsec_cleanup(priv);
 	mlx5e_fs_cleanup(priv->fs);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 0b459d841c3a..231d08bff121 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1546,6 +1546,7 @@ static const int types[] = {
 	MLX5_CAP_DEV_SHAMPO,
 	MLX5_CAP_MACSEC,
 	MLX5_CAP_ADV_VIRTUALIZATION,
+	MLX5_CAP_DEV_NVMEOTCP,
 };
 
 static void mlx5_hca_caps_free(struct mlx5_core_dev *dev)
-- 
2.31.1

