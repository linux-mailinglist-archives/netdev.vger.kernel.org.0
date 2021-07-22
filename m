Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5125C3D2277
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhGVKZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:25:10 -0400
Received: from mail-mw2nam10on2089.outbound.protection.outlook.com ([40.107.94.89]:6036
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231792AbhGVKY6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:24:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffVuBqpp+kQF+OnYLMhvZtHfkuxwNIrSN12sgAh9oEhGdOosp22TWC0vpXBlJKEAlW3RKYPYwOYC3Oyjo8qsv8njWz/nI7ebGQQK+p2H0f55/y5GkbxUe4sJe9JojVZrxO5HMXe1+REt317RqQAboLfdkkPfP4Hov21PqiKzR1GaOLpbVGaGjE5SDukQrY98yYdiNQi/VYRYYveOjjLx8YB3u+HO+BpKWcPGOmzNPTL607qBTWTJguK0PGZV9SzMjKfVPBuOd0fNbkd6VAWb0RatMe+cbeOtCrwTLQVpBjlpPP/55gnenW4AumJwD1AuLbQuvY1eNvuAAALAIRus5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMx4bzyWhN3mUnVBY0T21dP6NBiwPhfcJ9AdYIPXP/4=;
 b=ZRCDLBRRw6cUwaLlr8BNK7Ymv9ewkFOKvT4kXVQ61a3X2uvNI1WJGO6vlr725u8dZWWeLC9yy9uISBNUYUVob3i++vQVSSdMti+B2VzU1mj0ZXP15HdM273HG5XkoBLMvMwfvHAOJhDbbVnQMQNWh+qkfmFkAqp8kuZxDdcs6Rr7WaalWkypIJF2z0u/HjsdBiC+Zco5u3/Hy3PZKzNmAdE3QWmkmgjOZdNgczx5/iRF5QCBb0vfSKtyPSowGaMd1RRbTVS67wBGUgCuxCQQeYsiS2uM/TcDzEmqh1us7HqMswUe1UIBS6+wvbNZEbaSMiEUSBRjg4lpisYsUd0Fwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMx4bzyWhN3mUnVBY0T21dP6NBiwPhfcJ9AdYIPXP/4=;
 b=LuglwbwmEgPARS68eMulEv+Thu5Dx0TMOmR8fQMRk1JWHt0nUb2uwNS9TqFO3c2XRuQ0pTd16eYVueL1hfOlDQMSaMKQU4qeWhDKUy9QuyvruFRm30K3+vPN6UZ3t5E5w2oEjjyTwDpg5pYBZaFE0Ri+PfqMWixJjw8BJvQd/lmEz8kaQxsY2iJ0iv0l1oUDx9O7gppLADzB1U/Xqr+KqvOPOauhBR1zoAtCnsECyNVSN84WZzPVV2s9tb1wB7f+PWq5CFLCoQneXW3nvq0IinqQAf+ZjDY2SKT6FzkfsvPwjxp0y898IP+UWR3h5FH/yyAPsG8Qt23rTh8724rNJw==
Received: from BN9PR03CA0205.namprd03.prod.outlook.com (2603:10b6:408:f9::30)
 by DM6PR12MB3785.namprd12.prod.outlook.com (2603:10b6:5:1cd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Thu, 22 Jul
 2021 11:05:32 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::4c) by BN9PR03CA0205.outlook.office365.com
 (2603:10b6:408:f9::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Thu, 22 Jul 2021 11:05:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:05:32 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:05:31 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:05:26 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v5 net-next 16/36] net/mlx5e: NVMEoTCP async ddp invalidation
Date:   Thu, 22 Jul 2021 14:03:05 +0300
Message-ID: <20210722110325.371-17-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9da7b07-05d4-4584-ba1e-08d94d009fb7
X-MS-TrafficTypeDiagnostic: DM6PR12MB3785:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3785109E9632B39C6DF24FDBBDE49@DM6PR12MB3785.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Vc4xO6iJk2yYwUZebADIJTboKj2XWdS31d3kHyKS9bHZ6pjfD3/If0iQbLcitJ2O15PrchNQeZcsXa6H9ss2trHdID44Rig+MWrpYG3d6QTVAKLRCJ5/GfF2SHeWA7V9ErB7XrBqz0LZcLec8vq0BOHr/1+ZyGyuVLrwWLLz1HZyxnNdH1+N2jnEHxnf1DLl0NJq2O1/e6Lc2F7s6c74JE5xRSlwxhZVGEOi9A3Od7AuLBXh/bz1mv7LzrvM+HtoX45oaxxKk2oyY4O+0xGtJPIP5VDpODrgn39YsEpoSCMdd7gffzMz0vs3BYB06kFWAfImpC9xhmUFJU/ic7PxPl9qr3EI2NAIzxuIQoFbrA3xpv37aSs1OfASMVuPMo41yA0MLfZpWyRzFqNkpayGybA/K93gR+MZ5q9KM0OlIGthY0i5+oirpI0KGaK3t0iBZ0v1AGKeXhtL3zhZBHNhqRAmMAMKyI0Fqv2DIr4WM5ZcPh8NC4/W2GylPuYPmcJQi8SS87MyZ1VYh4DJFn5xvyXex5p3u/LrWxy/b73ulqupwp3Tl5tHi2spIVlAhDZ9DxThEg7NDmYXNZJKSZJ0+DHojxU3DKn35ybn3YyBGv8o0iId+XEYmENcE9KzaH3TlZEKmJj5kGvcRxFF1d7Zwtnj81sbKCKHYPam7M4S3DglqT2TV9E7+fZofvjqXG1nbeGObw4LZIRCftCnG0Ci5zygKMBIt5vnkALxtNkk5c=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(36840700001)(46966006)(36756003)(83380400001)(26005)(426003)(54906003)(82740400003)(36906005)(110136005)(1076003)(36860700001)(316002)(8676002)(2906002)(7416002)(478600001)(4326008)(8936002)(82310400003)(86362001)(107886003)(5660300002)(47076005)(6666004)(70586007)(186003)(336012)(7696005)(921005)(2616005)(7636003)(356005)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:05:32.3033
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9da7b07-05d4-4584-ba1e-08d94d009fb7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3785
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

Teardown ddp contexts asynchronously by posting a WQE, and calling back
to nvme-tcp when the corresponding CQE is received.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  4 ++
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 66 ++++++++++++++++---
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  6 ++
 4 files changed, 69 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 497c49f28d8a..f0190ee6e42c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -43,6 +43,7 @@ enum mlx5e_icosq_wqe_type {
 #endif
 #ifdef CONFIG_MLX5_EN_NVMEOTCP
 	MLX5E_ICOSQ_WQE_UMR_NVME_TCP,
+	MLX5E_ICOSQ_WQE_UMR_NVME_TCP_INVALIDATE,
 	MLX5E_ICOSQ_WQE_SET_PSV_NVME_TCP,
 #endif
 };
@@ -191,6 +192,9 @@ struct mlx5e_icosq_wqe_info {
 		struct {
 			struct mlx5e_nvmeotcp_queue *queue;
 		} nvmeotcp_q;
+		struct {
+			struct nvmeotcp_queue_entry *entry;
+		} nvmeotcp_qe;
 #endif
 	};
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index 2283b2a799f8..864b080cc8fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -152,6 +152,7 @@ enum wqe_type {
 	BSF_KLM_UMR = 1,
 	SET_PSV_UMR = 2,
 	BSF_UMR = 3,
+	KLM_INV_UMR = 4,
 };
 
 static void
@@ -208,6 +209,13 @@ build_nvmeotcp_klm_umr(struct mlx5e_nvmeotcp_queue *queue,
 				   MLX5E_KLM_UMR_DS_CNT(ALIGN(klm_entries, KLM_ALIGNMENT)));
 	cseg->general_id = cpu_to_be32(id);
 
+	if (!klm_entries) { /* this is invalidate */
+		ucseg->mkey_mask = cpu_to_be64(MLX5_MKEY_MASK_FREE);
+		ucseg->flags = MLX5_UMR_INLINE;
+		mkc->status = MLX5_MKEY_STATUS_FREE;
+		return;
+	}
+
 	if (klm_type == KLM_UMR && !klm_offset) {
 		ucseg->mkey_mask |= cpu_to_be64(MLX5_MKEY_MASK_XLT_OCT_SIZE |
 						MLX5_MKEY_MASK_LEN | MLX5_MKEY_MASK_FREE);
@@ -309,8 +317,8 @@ build_nvmeotcp_static_params(struct mlx5e_nvmeotcp_queue *queue,
 
 static void
 mlx5e_nvmeotcp_fill_wi(struct mlx5e_nvmeotcp_queue *nvmeotcp_queue,
-		       struct mlx5e_icosq *sq, u32 wqe_bbs, u16 pi,
-		       enum wqe_type type)
+		       struct mlx5e_icosq *sq, u32 wqe_bbs,
+		       u16 pi, u16 ccid, enum wqe_type type)
 {
 	struct mlx5e_icosq_wqe_info *wi = &sq->db.wqe_info[pi];
 
@@ -319,12 +327,17 @@ mlx5e_nvmeotcp_fill_wi(struct mlx5e_nvmeotcp_queue *nvmeotcp_queue,
 	case SET_PSV_UMR:
 		wi->wqe_type = MLX5E_ICOSQ_WQE_SET_PSV_NVME_TCP;
 		break;
+	case KLM_INV_UMR:
+		wi->wqe_type = MLX5E_ICOSQ_WQE_UMR_NVME_TCP_INVALIDATE;
+		break;
 	default:
 		wi->wqe_type = MLX5E_ICOSQ_WQE_UMR_NVME_TCP;
 		break;
 	}
 
-	if (type == SET_PSV_UMR)
+	if (type == KLM_INV_UMR)
+		wi->nvmeotcp_qe.entry = &nvmeotcp_queue->ccid_table[ccid];
+	else if (type == SET_PSV_UMR)
 		wi->nvmeotcp_q.queue = nvmeotcp_queue;
 }
 
@@ -340,7 +353,7 @@ mlx5e_nvmeotcp_rx_post_static_params_wqe(struct mlx5e_nvmeotcp_queue *queue,
 	wqe_bbs = MLX5E_NVMEOTCP_STATIC_PARAMS_WQEBBS;
 	pi = mlx5e_icosq_get_next_pi(sq, wqe_bbs);
 	wqe = MLX5E_NVMEOTCP_FETCH_STATIC_PARAMS_WQE(sq, pi);
-	mlx5e_nvmeotcp_fill_wi(NULL, sq, wqe_bbs, pi, BSF_UMR);
+	mlx5e_nvmeotcp_fill_wi(NULL, sq, wqe_bbs, pi, 0, BSF_UMR);
 	build_nvmeotcp_static_params(queue, wqe, resync_seq, queue->zerocopy, queue->crc_rx);
 	sq->pc += wqe_bbs;
 	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
@@ -358,7 +371,7 @@ mlx5e_nvmeotcp_rx_post_progress_params_wqe(struct mlx5e_nvmeotcp_queue *queue,
 	wqe_bbs = MLX5E_NVMEOTCP_PROGRESS_PARAMS_WQEBBS;
 	pi = mlx5e_icosq_get_next_pi(sq, wqe_bbs);
 	wqe = MLX5E_NVMEOTCP_FETCH_PROGRESS_PARAMS_WQE(sq, pi);
-	mlx5e_nvmeotcp_fill_wi(queue, sq, wqe_bbs, pi, SET_PSV_UMR);
+	mlx5e_nvmeotcp_fill_wi(queue, sq, wqe_bbs, pi, 0, SET_PSV_UMR);
 	build_nvmeotcp_progress_params(queue, wqe, seq);
 	sq->pc += wqe_bbs;
 	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
@@ -382,7 +395,8 @@ post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
 	wqe_bbs = DIV_ROUND_UP(wqe_sz, MLX5_SEND_WQE_BB);
 	pi = mlx5e_icosq_get_next_pi(sq, wqe_bbs);
 	wqe = MLX5E_NVMEOTCP_FETCH_KLM_WQE(sq, pi);
-	mlx5e_nvmeotcp_fill_wi(queue, sq, wqe_bbs, pi, wqe_type);
+	mlx5e_nvmeotcp_fill_wi(queue, sq, wqe_bbs, pi, ccid,
+			       klm_length ? KLM_UMR : KLM_INV_UMR);
 	build_nvmeotcp_klm_umr(queue, wqe, ccid, cur_klm_entries, *klm_offset,
 			       klm_length, wqe_type);
 	*klm_offset += cur_klm_entries;
@@ -400,8 +414,13 @@ mlx5e_nvmeotcp_post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
 	struct mlx5e_icosq *sq = &queue->sq->icosq;
 
 	/* TODO: set stricter wqe_sz; using max for now */
-	wqes = DIV_ROUND_UP(klm_length, queue->max_klms_per_wqe);
-	wqe_sz = MLX5E_KLM_UMR_WQE_SZ(queue->max_klms_per_wqe);
+	if (klm_length == 0) {
+		wqes = 1;
+		wqe_sz = MLX5E_NVMEOTCP_STATIC_PARAMS_WQEBBS;
+	} else {
+		wqes = DIV_ROUND_UP(klm_length, queue->max_klms_per_wqe);
+		wqe_sz = MLX5E_KLM_UMR_WQE_SZ(queue->max_klms_per_wqe);
+	}
 
 	max_wqe_bbs = DIV_ROUND_UP(wqe_sz, MLX5_SEND_WQE_BB);
 
@@ -746,6 +765,24 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
 	return 0;
 }
 
+void mlx5e_nvmeotcp_ddp_inv_done(struct mlx5e_icosq_wqe_info *wi)
+{
+	struct nvmeotcp_queue_entry *q_entry = wi->nvmeotcp_qe.entry;
+	struct mlx5e_nvmeotcp_queue *queue = q_entry->queue;
+	struct mlx5_core_dev *mdev = queue->priv->mdev;
+	struct ulp_ddp_io *ddp = q_entry->ddp;
+	const struct ulp_ddp_ulp_ops *ulp_ops;
+
+	dma_unmap_sg(mdev->device, ddp->sg_table.sgl,
+		     q_entry->sgl_length, DMA_FROM_DEVICE);
+
+	q_entry->sgl_length = 0;
+
+	ulp_ops = inet_csk(queue->sk)->icsk_ulp_ddp_ops;
+	if (ulp_ops && ulp_ops->ddp_teardown_done)
+		ulp_ops->ddp_teardown_done(q_entry->ddp_ctx);
+}
+
 void mlx5e_nvmeotcp_ctx_comp(struct mlx5e_icosq_wqe_info *wi)
 {
 	struct mlx5e_nvmeotcp_queue *queue = wi->nvmeotcp_q.queue;
@@ -762,6 +799,19 @@ mlx5e_nvmeotcp_ddp_teardown(struct net_device *netdev,
 			    struct ulp_ddp_io *ddp,
 			    void *ddp_ctx)
 {
+	struct mlx5e_nvmeotcp_queue *queue;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct nvmeotcp_queue_entry *q_entry;
+
+	queue = container_of(ulp_ddp_get_ctx(sk), struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
+	q_entry  = &queue->ccid_table[ddp->command_id];
+	WARN_ON(q_entry->sgl_length == 0);
+
+	q_entry->ddp_ctx = ddp_ctx;
+	q_entry->queue = queue;
+
+	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, 0);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
index 20141010817d..b9642e130b97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
@@ -105,6 +105,7 @@ void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv);
 struct mlx5e_nvmeotcp_queue *
 mlx5e_nvmeotcp_get_queue(struct mlx5e_nvmeotcp *nvmeotcp, int id);
 void mlx5e_nvmeotcp_put_queue(struct mlx5e_nvmeotcp_queue *queue);
+void mlx5e_nvmeotcp_ddp_inv_done(struct mlx5e_icosq_wqe_info *wi);
 void mlx5e_nvmeotcp_ctx_comp(struct mlx5e_icosq_wqe_info *wi);
 int mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv);
 void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index bc7b19974ed9..e92dd4666955 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -628,6 +628,9 @@ void mlx5e_free_icosq_descs(struct mlx5e_icosq *sq)
 #ifdef CONFIG_MLX5_EN_NVMEOTCP
 		case MLX5E_ICOSQ_WQE_UMR_NVME_TCP:
 			break;
+		case MLX5E_ICOSQ_WQE_UMR_NVME_TCP_INVALIDATE:
+			mlx5e_nvmeotcp_ddp_inv_done(wi);
+			break;
 		case MLX5E_ICOSQ_WQE_SET_PSV_NVME_TCP:
 			mlx5e_nvmeotcp_ctx_comp(wi);
 			break;
@@ -706,6 +709,9 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 #ifdef CONFIG_MLX5_EN_NVMEOTCP
 			case MLX5E_ICOSQ_WQE_UMR_NVME_TCP:
 				break;
+			case MLX5E_ICOSQ_WQE_UMR_NVME_TCP_INVALIDATE:
+				mlx5e_nvmeotcp_ddp_inv_done(wi);
+				break;
 			case MLX5E_ICOSQ_WQE_SET_PSV_NVME_TCP:
 				mlx5e_nvmeotcp_ctx_comp(wi);
 				break;
-- 
2.24.1

