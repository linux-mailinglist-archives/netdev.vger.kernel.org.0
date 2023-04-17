Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6666E478B
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjDQMWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbjDQMVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:21:45 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FF5AD28
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:21:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYRadkqdzvlutA+17QFYv1loi7Vp/4kbMKYYNyJGZpBxcXZZ7ib06n1ebfRAvdDSNrxSYP8ymaPmJM6d3mH9hxh9dRJ5rs/Ev6BEfZK+x7DFvVxs8oN9W2o0kNW2wzIxURV5PRZgj/GqvYcGhGNEwQuWQZX2sklwsJNWlc6WNO0jaZDTH1ib1K3Nyloukh6p9V4yZqzEK8bvRo3v+/GcQM2mZ5ZpMGutN8llqTqmoBatLneHeox5GXrr95iHaEXBW2av8jDkwPobCNzfcsw6eZvqZd6kHxIM0UAu/3jrv89zBDSBAl/a/pPnRW3YbmbtDBSuxMD9aJ8igzRgJUqxSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sVQtEADz7kzPrySHF82I4YoQ84yduAPClVb0gUYuMz4=;
 b=ITZoU1HZTzuLwAatgIPrUB/GXlS+xtpwPBoszOrPIK2RvPvyYNgkWE7ru3qF2fs2i3pPnnJsydOfkQlQkqabTaj1Xy08w0P2n0fiOxOyZmpmaD9IjVjHqDnTsNciz0DYRwzuibXgAQyo+geui0mJHdC0yoE+8ZYN5p3K/XRXOLSqj+V7QibP5Ebq/C+ub8OUw/TXtq1mBn8nkSFhqRXdLWpBLhO5Jj7388ZHLWg+FLB6g4cWnyLe+2fnz0MfLCTqpjmD07mzBphyJOQIOMUNmZOfcFbPqyFU2boKQ5bIllvYAJpTTZcYyu4/Jq6Bc4/keWbe3FLP/1hASo3Psnfhag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sVQtEADz7kzPrySHF82I4YoQ84yduAPClVb0gUYuMz4=;
 b=hVGg5g5SvF3ujYR09DqCQdalg5H1VbTEUv3QPyloM/C5zNkVfjFiL6P7/Sq8KUB0luB/FvCrQ5hMUv5zrKV8ml4wCYrX5Kt5QpNYcVFSX6RbT28qgVEWw7bAtKCnjZNdMjDFkTR4HVK3ZCmVMqqlUQcbQWTq4vpuizmr05SOMpWdD5VLzTdJz6wMKuSsWs2NT3I8rgESz0/7M5og+FehlhnY7DKISjWbdKdTKd/aJRRUCdMqexr66sjHF6brtPIiF3FuvmQCdZ3uY4L/cQIBKyjahjylOmMn/CsRFTowfBeqOZEpRDIW+cWa8Y8/UkIblqSVtorCaJ+W4hovLHd9Qg==
Received: from BN9PR03CA0269.namprd03.prod.outlook.com (2603:10b6:408:ff::34)
 by IA1PR12MB6020.namprd12.prod.outlook.com (2603:10b6:208:3d4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 12:20:59 +0000
Received: from BN8NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::65) by BN9PR03CA0269.outlook.office365.com
 (2603:10b6:408:ff::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Mon, 17 Apr 2023 12:20:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT113.mail.protection.outlook.com (10.13.176.163) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.19 via Frontend Transport; Mon, 17 Apr 2023 12:20:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 17 Apr 2023
 05:20:42 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 17 Apr
 2023 05:20:42 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 17 Apr
 2023 05:20:39 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Henning Fehrmann <henning.fehrmann@aei.mpg.de>,
        "Oliver Behnke" <oliver.behnke@aei.mpg.de>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 15/15] net/mlx5e: RX, Add XDP multi-buffer support in Striding RQ
Date:   Mon, 17 Apr 2023 15:19:03 +0300
Message-ID: <20230417121903.46218-16-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230417121903.46218-1-tariqt@nvidia.com>
References: <20230417121903.46218-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT113:EE_|IA1PR12MB6020:EE_
X-MS-Office365-Filtering-Correlation-Id: dea0c307-5815-4e1d-5518-08db3f3e336b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bKC7soXqE0c56QfIrbpRAdjusQliqwY2KT+Ui/iAoHu9c0Mq4XpIcxEbOucPA5aLf/s+C9XFyD+ynJ53126V91flNo0le/bDMEgYrF9UG/Svh7hy0hBqABHmKSp4i0vemePSst+MtOec+lOmkKxOnrSc4grqjgIGsgfykSvoyPx89/uUhE3wOBb6yNdgcxuFl9lMKH23lTuoZZ21lgUTo6wsvJ+raQIkGjFFPlSD4Z5tkIq815mQHUk+Lt5fNWPqcGTe/ERmADpNvptI/49y934mmtjtUftYRwML/Nh4k6egfATrE76Mtd2EtNjlKZo9A0eZeGYTgcWPJ2KIbd2Sr2AdAV1+zpr8BJ86F0PWrfwEP8nRxlxOHnoeRoxiXhUUy2nvIHTlfmZ6i1Qw5/Dz5vB7Uwas+SMrfwxVMcG3kBfQdrnGGvDaJLD5VzZvgg9wy2CVhlMRi4N5s5V18H81hV4ZPZF6g53NClx2GacS9fCKJ8PKilNByJLDidOushUwjsMz0M3iUgigky6U81mjWRo3HeDJMag8mHo/dPeMnl75iiDtEhvvatGHHs/Nq+4qpx76mn7kfzrocnFJdWkWYrruFNCnXMcAGDA1EE1C+tFaLDCs/u/TFSAJFA4TNqiem96D/ZbPd3Go0s1jDhw71kXDFQ/Aif4vzMGGZUHV2DmB5T6McmZQz1W0/A46CF+gtFMROp6s0O4gSmyJRUnt/XgQPjoIeHczZ0sCN4upw6sq2fTYvYGEDLmy6ikq9kJ1+oUqG4aBvzd3+5v4U0PVUpl+LxSkcrbyGPT1h4S6x1w=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(346002)(396003)(451199021)(46966006)(36840700001)(40470700004)(478600001)(6666004)(34020700004)(8936002)(8676002)(316002)(41300700001)(82740400003)(4326008)(70586007)(40480700001)(70206006)(54906003)(7636003)(110136005)(356005)(40460700003)(186003)(107886003)(2906002)(30864003)(36756003)(1076003)(26005)(426003)(336012)(86362001)(83380400001)(47076005)(82310400005)(2616005)(36860700001)(5660300002)(7696005)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:20:58.4220
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dea0c307-5815-4e1d-5518-08db3f3e336b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6020
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here we add support for multi-buffer XDP handling in Striding RQ, which
is our default out-of-the-box RQ type. Before this series, loading such
an XDP program would fail, until you switch to the legacy RQ (by
unsetting the rx_striding_rq priv-flag).

To overcome the lack of headroom and tailroom between the strides, we
allocate a side page to be used for the descriptor (xdp_buff / skb) and
the linear part. When an XDP program is attached, we structure the
xdp_buff so that it contains no data in the linear part, and the whole
packet resides in the fragments.

In case of XDP_PASS, where an SKB still needs to be created, we copy up
to 256 bytes to its linear part, to match the current behavior, and
satisfy functions that assume finding the packet headers in the SKB
linear part (like eth_type_trans).

Performance testing:

Packet rate test, 64 bytes, 32 channels, MTU 9000 bytes.
CPU: Intel(R) Xeon(R) Platinum 8380 CPU @ 2.30GHz.
NIC: ConnectX-6 Dx, at 100 Gbps.

+----------+-------------+-------------+---------+
| Test     | Legacy RQ   | Striding RQ | Speedup |
+----------+-------------+-------------+---------+
| XDP_DROP | 101,615,544 | 117,191,020 | +15%    |
+----------+-------------+-------------+---------+
| XDP_TX   |  95,608,169 | 117,043,422 | +22%    |
+----------+-------------+-------------+---------+

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   1 +
 .../ethernet/mellanox/mlx5/core/en/params.c   |  21 ++-
 .../ethernet/mellanox/mlx5/core/en/params.h   |   3 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  37 +++--
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 135 +++++++++++++-----
 5 files changed, 138 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 0e15afbe1673..b8987a404d75 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -587,6 +587,7 @@ union mlx5e_alloc_units {
 struct mlx5e_mpw_info {
 	u16 consumed_strides;
 	DECLARE_BITMAP(skip_release_bitmap, MLX5_MPWRQ_MAX_PAGES_PER_WQE);
+	struct mlx5e_frag_page linear_page;
 	union mlx5e_alloc_units alloc_units;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 196862e67af3..ef546ed8b4d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -323,6 +323,20 @@ static bool mlx5e_verify_rx_mpwqe_strides(struct mlx5_core_dev *mdev,
 	return log_num_strides >= MLX5_MPWQE_LOG_NUM_STRIDES_BASE;
 }
 
+bool mlx5e_verify_params_rx_mpwqe_strides(struct mlx5_core_dev *mdev,
+					  struct mlx5e_params *params,
+					  struct mlx5e_xsk_param *xsk)
+{
+	u8 log_wqe_num_of_strides = mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk);
+	u8 log_wqe_stride_size = mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk);
+	enum mlx5e_mpwrq_umr_mode umr_mode = mlx5e_mpwrq_umr_mode(mdev, xsk);
+	u8 page_shift = mlx5e_mpwrq_page_shift(mdev, xsk);
+
+	return mlx5e_verify_rx_mpwqe_strides(mdev, log_wqe_stride_size,
+					     log_wqe_num_of_strides,
+					     page_shift, umr_mode);
+}
+
 bool mlx5e_rx_mpwqe_is_linear_skb(struct mlx5_core_dev *mdev,
 				  struct mlx5e_params *params,
 				  struct mlx5e_xsk_param *xsk)
@@ -405,6 +419,10 @@ u8 mlx5e_mpwqe_get_log_stride_size(struct mlx5_core_dev *mdev,
 	if (mlx5e_rx_mpwqe_is_linear_skb(mdev, params, xsk))
 		return order_base_2(mlx5e_rx_get_linear_stride_sz(mdev, params, xsk, true));
 
+	/* XDP in mlx5e doesn't support multiple packets per page. */
+	if (params->xdp_prog)
+		return PAGE_SHIFT;
+
 	return MLX5_MPWRQ_DEF_LOG_STRIDE_SZ(mdev);
 }
 
@@ -575,9 +593,6 @@ int mlx5e_mpwrq_validate_regular(struct mlx5_core_dev *mdev, struct mlx5e_params
 	if (!mlx5e_check_fragmented_striding_rq_cap(mdev, page_shift, umr_mode))
 		return -EOPNOTSUPP;
 
-	if (params->xdp_prog && !mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL))
-		return -EINVAL;
-
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index c9be6eb88012..a5d20f6d6d9c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -153,6 +153,9 @@ int mlx5e_build_channel_param(struct mlx5_core_dev *mdev,
 
 u16 mlx5e_calc_sq_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
 int mlx5e_validate_params(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
+bool mlx5e_verify_params_rx_mpwqe_strides(struct mlx5_core_dev *mdev,
+					  struct mlx5e_params *params,
+					  struct mlx5e_xsk_param *xsk);
 
 static inline void mlx5e_params_print_info(struct mlx5_core_dev *mdev,
 					   struct mlx5e_params *params)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a95ce206391b..7eb1eeb115ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -803,6 +803,9 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		pool_size = rq->mpwqe.pages_per_wqe <<
 			mlx5e_mpwqe_get_log_rq_size(mdev, params, xsk);
 
+		if (!mlx5e_rx_mpwqe_is_linear_skb(mdev, params, xsk) && params->xdp_prog)
+			pool_size *= 2; /* additional page per packet for the linear part */
+
 		rq->mpwqe.log_stride_sz = mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk);
 		rq->mpwqe.num_strides =
 			BIT(mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk));
@@ -4060,10 +4063,9 @@ void mlx5e_set_xdp_feature(struct net_device *netdev)
 
 	val = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
 	      NETDEV_XDP_ACT_XSK_ZEROCOPY |
+	      NETDEV_XDP_ACT_RX_SG |
 	      NETDEV_XDP_ACT_NDO_XMIT |
 	      NETDEV_XDP_ACT_NDO_XMIT_SG;
-	if (params->rq_wq_type == MLX5_WQ_TYPE_CYCLIC)
-		val |= NETDEV_XDP_ACT_RX_SG;
 	xdp_set_features_flag(netdev, val);
 }
 
@@ -4261,23 +4263,20 @@ static bool mlx5e_params_validate_xdp(struct net_device *netdev,
 		mlx5e_rx_is_linear_skb(mdev, params, NULL) :
 		mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL);
 
-	/* XDP affects striding RQ parameters. Block XDP if striding RQ won't be
-	 * supported with the new parameters: if PAGE_SIZE is bigger than
-	 * MLX5_MPWQE_LOG_STRIDE_SZ_MAX, striding RQ can't be used, even though
-	 * the MTU is small enough for the linear mode, because XDP uses strides
-	 * of PAGE_SIZE on regular RQs.
-	 */
-	if (!is_linear && params->rq_wq_type != MLX5_WQ_TYPE_CYCLIC) {
-		netdev_warn(netdev, "XDP is not allowed with striding RQ and MTU(%d) > %d\n",
-			    params->sw_mtu,
-			    mlx5e_xdp_max_mtu(params, NULL));
-		return false;
-	}
-	if (!is_linear && !params->xdp_prog->aux->xdp_has_frags) {
-		netdev_warn(netdev, "MTU(%d) > %d, too big for an XDP program not aware of multi buffer\n",
-			    params->sw_mtu,
-			    mlx5e_xdp_max_mtu(params, NULL));
-		return false;
+	if (!is_linear) {
+		if (!params->xdp_prog->aux->xdp_has_frags) {
+			netdev_warn(netdev, "MTU(%d) > %d, too big for an XDP program not aware of multi buffer\n",
+				    params->sw_mtu,
+				    mlx5e_xdp_max_mtu(params, NULL));
+			return false;
+		}
+		if (params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ &&
+		    !mlx5e_verify_params_rx_mpwqe_strides(mdev, params, NULL)) {
+			netdev_warn(netdev, "XDP is not allowed with striding RQ and MTU(%d) > %d\n",
+				    params->sw_mtu,
+				    mlx5e_xdp_max_mtu(params, NULL));
+			return false;
+		}
 	}
 
 	return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 2e99bef49dd6..a8c2ae389d6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1982,36 +1982,51 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 	struct skb_shared_info *sinfo;
 	struct mlx5e_xdp_buff mxbuf;
 	unsigned int truesize = 0;
+	struct bpf_prog *prog;
 	struct sk_buff *skb;
 	u32 linear_frame_sz;
 	u16 linear_data_len;
-	dma_addr_t addr;
 	u16 linear_hr;
 	void *va;
 
-	skb = napi_alloc_skb(rq->cq.napi,
-			     ALIGN(MLX5E_RX_MAX_HEAD, sizeof(long)));
-	if (unlikely(!skb)) {
-		rq->stats->buff_alloc_err++;
-		return NULL;
-	}
-
-	va = skb->head;
-	net_prefetchw(skb->data);
+	prog = rcu_dereference(rq->xdp_prog);
 
-	frag_offset += headlen;
-	byte_cnt -= headlen;
-	linear_hr = skb_headroom(skb);
-	linear_data_len = headlen;
-	linear_frame_sz = MLX5_SKB_FRAG_SZ(skb_end_offset(skb));
-	if (unlikely(frag_offset >= PAGE_SIZE)) {
-		frag_page++;
-		frag_offset -= PAGE_SIZE;
+	if (prog) {
+		/* area for bpf_xdp_[store|load]_bytes */
+		net_prefetchw(page_address(frag_page->page) + frag_offset);
+		if (unlikely(mlx5e_page_alloc_fragmented(rq, &wi->linear_page))) {
+			rq->stats->buff_alloc_err++;
+			return NULL;
+		}
+		va = page_address(wi->linear_page.page);
+		net_prefetchw(va); /* xdp_frame data area */
+		linear_hr = XDP_PACKET_HEADROOM;
+		linear_data_len = 0;
+		linear_frame_sz = MLX5_SKB_FRAG_SZ(linear_hr + MLX5E_RX_MAX_HEAD);
+	} else {
+		skb = napi_alloc_skb(rq->cq.napi,
+				     ALIGN(MLX5E_RX_MAX_HEAD, sizeof(long)));
+		if (unlikely(!skb)) {
+			rq->stats->buff_alloc_err++;
+			return NULL;
+		}
+		skb_mark_for_recycle(skb);
+		va = skb->head;
+		net_prefetchw(va); /* xdp_frame data area */
+		net_prefetchw(skb->data);
+
+		frag_offset += headlen;
+		byte_cnt -= headlen;
+		linear_hr = skb_headroom(skb);
+		linear_data_len = headlen;
+		linear_frame_sz = MLX5_SKB_FRAG_SZ(skb_end_offset(skb));
+		if (unlikely(frag_offset >= PAGE_SIZE)) {
+			frag_page++;
+			frag_offset -= PAGE_SIZE;
+		}
 	}
 
-	skb_mark_for_recycle(skb);
 	mlx5e_fill_mxbuf(rq, cqe, va, linear_hr, linear_frame_sz, linear_data_len, &mxbuf);
-	net_prefetch(mxbuf.xdp.data);
 
 	sinfo = xdp_get_shared_info_from_buff(&mxbuf.xdp);
 
@@ -2030,25 +2045,71 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 		frag_offset = 0;
 		frag_page++;
 	}
-	if (xdp_buff_has_frags(&mxbuf.xdp)) {
-		struct mlx5e_frag_page *pagep;
 
-		xdp_update_skb_shared_info(skb, sinfo->nr_frags,
-					   sinfo->xdp_frags_size, truesize,
-					   xdp_buff_is_frag_pfmemalloc(&mxbuf.xdp));
+	if (prog) {
+		if (mlx5e_xdp_handle(rq, prog, &mxbuf)) {
+			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
+				int i;
+
+				for (i = 0; i < sinfo->nr_frags; i++)
+					/* non-atomic */
+					__set_bit(page_idx + i, wi->skip_release_bitmap);
+				return NULL;
+			}
+			mlx5e_page_release_fragmented(rq, &wi->linear_page);
+			return NULL; /* page/packet was consumed by XDP */
+		}
+
+		skb = mlx5e_build_linear_skb(rq, mxbuf.xdp.data_hard_start,
+					     linear_frame_sz,
+					     mxbuf.xdp.data - mxbuf.xdp.data_hard_start, 0,
+					     mxbuf.xdp.data - mxbuf.xdp.data_meta);
+		if (unlikely(!skb)) {
+			mlx5e_page_release_fragmented(rq, &wi->linear_page);
+			return NULL;
+		}
 
-		pagep = frag_page - sinfo->nr_frags;
-		do
-			pagep->frags++;
-		while (++pagep < frag_page);
-	}
-	/* copy header */
-	addr = page_pool_get_dma_addr(head_page->page);
-	mlx5e_copy_skb_header(rq, skb, head_page->page, addr,
-			      head_offset, head_offset, headlen);
-	/* skb linear part was allocated with headlen and aligned to long */
-	skb->tail += headlen;
-	skb->len  += headlen;
+		skb_mark_for_recycle(skb);
+		wi->linear_page.frags++;
+		mlx5e_page_release_fragmented(rq, &wi->linear_page);
+
+		if (xdp_buff_has_frags(&mxbuf.xdp)) {
+			struct mlx5e_frag_page *pagep;
+
+			/* sinfo->nr_frags is reset by build_skb, calculate again. */
+			xdp_update_skb_shared_info(skb, frag_page - head_page,
+						   sinfo->xdp_frags_size, truesize,
+						   xdp_buff_is_frag_pfmemalloc(&mxbuf.xdp));
+
+			pagep = head_page;
+			do
+				pagep->frags++;
+			while (++pagep < frag_page);
+		}
+		__pskb_pull_tail(skb, headlen);
+	} else {
+		dma_addr_t addr;
+
+		if (xdp_buff_has_frags(&mxbuf.xdp)) {
+			struct mlx5e_frag_page *pagep;
+
+			xdp_update_skb_shared_info(skb, sinfo->nr_frags,
+						   sinfo->xdp_frags_size, truesize,
+						   xdp_buff_is_frag_pfmemalloc(&mxbuf.xdp));
+
+			pagep = frag_page - sinfo->nr_frags;
+			do
+				pagep->frags++;
+			while (++pagep < frag_page);
+		}
+		/* copy header */
+		addr = page_pool_get_dma_addr(head_page->page);
+		mlx5e_copy_skb_header(rq, skb, head_page->page, addr,
+				      head_offset, head_offset, headlen);
+		/* skb linear part was allocated with headlen and aligned to long */
+		skb->tail += headlen;
+		skb->len  += headlen;
+	}
 
 	return skb;
 }
-- 
2.34.1

