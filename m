Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92DF13D2289
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhGVK0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:26:36 -0400
Received: from mail-dm6nam10on2070.outbound.protection.outlook.com ([40.107.93.70]:13857
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231634AbhGVK0g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:26:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TgpQGWDVc3QKCpPiF0+Kh8gPaOzXJymTWWZ6EJ4ki0JgXWTFGsNrxB6pdEsYo1mXcBUSQ75PSKrLjbMHD/Qfp8Ci//YyA5JYxj2ChzBisFNgQv/e/Za0BfhrF/FsTSSlW0luyDMx6F/b+gc5Y9FzvFBq1wzN/BNG1FxcqL1oPH4RKVaJwy5Vq1U+dy9TynvD33TxZDaasJ9oH2uC47H+rfT258t75sVVkmty4lpnP02YJ6WjpH5YYqgq0B01MQws5RGzE7nVoIJgBMJdDtbjSsUG7p2qJWNaWzBMb570GbOHv9PnyYRa0Cy8gS1YctWOGyodzlG3tmyQP/CasbkTiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ICNaHiF0X9S85BDGO3H6Y0pJMNddfvC8aK44dcQ8GFw=;
 b=ZX+IMVa3b6mkqFN6yQcu3i9cGA6gczV98iBhGjj+jgS8F1pTc8bjXH9k+PnxlZDgex85ivwmvY0G3FgWNoL/WMvxISrBO5HyC5TaS+xBqNFgar6+NopdT4dLFQodaZaZvEFmuvGGJxaOcU7P3jo9GAvkdYQ0atG5pEARDHIQOYoKMStsyiCHeEOEuG6Uxgq53R0PxZDTQQBQS3zfGpVh+aUOaH0Ao7+VmXlsncmkLrtGhQWpaNyKaASgyrOvWQGDckbTRx5KGftafvh5NFpU2WpIcwtJMcAWHGNOPsiKT0wUv0Modc1RosTGrV+pA7B/OOUPv430iTj+7LEGH8CG3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ICNaHiF0X9S85BDGO3H6Y0pJMNddfvC8aK44dcQ8GFw=;
 b=Ej3sovYcjPAI4NhsCy7/cBgL7MyrcrBEYDAZuDbB48wKppGBsZmpThuJas7VElsB1WNGybZuCim8pWNL2pLgD8SAJKh6b8Ud3JQ+RXmbjryetqhT9BJD084m2QJuKNfKtdpZino0eBigMtKeaLQUPqPBUDtFD9uXw8ir4H+YsAiWnLbDiW+s5WBLz2WuoLm3gMsC19LEmpxCum95Mt/8qx0EQGgOQoNvyuuF0qwzjQBSfab9EXdAl6jw3UpGneuJ24sxYKQCAjBp4Iecvy+fW2hNp0qq+SYw4ds++GWdjPZwoFKZEjvDWmgs+OYgY2WyrUw1eeavId7/QIW0NnM50A==
Received: from DM5PR13CA0022.namprd13.prod.outlook.com (2603:10b6:3:23::32) by
 MN2PR12MB4015.namprd12.prod.outlook.com (2603:10b6:208:16e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Thu, 22 Jul
 2021 11:07:09 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:23:cafe::36) by DM5PR13CA0022.outlook.office365.com
 (2603:10b6:3:23::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend
 Transport; Thu, 22 Jul 2021 11:07:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:07:09 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 04:07:07 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:07:01 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>
Subject: [PATCH v5 net-next 34/36] net/mlx5e: NVMEoTCP DDGST TX handle OOO packets
Date:   Thu, 22 Jul 2021 14:03:23 +0300
Message-ID: <20210722110325.371-35-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b12c94ab-eb95-4c2d-2f3d-08d94d00d9a2
X-MS-TrafficTypeDiagnostic: MN2PR12MB4015:
X-Microsoft-Antispam-PRVS: <MN2PR12MB40154FA8931DD34976CBE657BDE49@MN2PR12MB4015.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:330;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MXotzxsRtexz+2l9FSZ/XP/tscRXCm0Q/Pmrpm1WZRNb86HrPhHgfTaDBT8KY85WGfiLUv4ebMcio7nufc0ZrZjnP/nsXBIERKg3JqHgDZzp5ERkboMkNrpFoDUeGqIU4JTRvIJRk+CpovqxFufd4ohfsPyTdhQZ+U1UL5xpsSXUqysB3rCjPrMkA7rbTjmKLn6IL5j9Q7gNtSHmS7EUpN5RQ+bHHSxzxbpWVXRahKS9tfFF84hEAZlF7sgCvARb0p6Llx6IYKVheNe7RwuKHQZ0cZTq3rkPQIhWOlr2WA+2sFPjhgg62BmtGUdssgHxO/r7qfNOTi0jrgsLHdc5+HLPHzTGwPu6RFsV9rGi2OCZ5yjs1t5Z1not6ebjTlAj19SjOxkiDgJSl7AH2KsBbC83LbJRutEADY9M2g9wBJcNlumdrS+VuAU8gnZc/goazE611W4CWyIMSyrb/gAom+4CfYNET04gbt1QOavTIb+wRaY6Qn8SxVDUHiorZvctg6Mctq3BYPeP7NlcIhPe54ZKuSQe7J9khAfjF0zQeOWjP7dFqcgTy37Lz/4RBNLKAtud7NZyu5jk4OGg2/iphJHPOHHYOiS5T9ajQMLLyjKpRO99wnJYK/ZsFr+veX/C/u3NbXb46SnfZGTJh1Z86jxaqlozm7Ss9Sb/NZv10PrG9n2BNzfFvZk+TiA6BW02h6Td0zIzbq/OI0OUjGzLWR4uXvf5qEQJ6IWZW18Cl+4=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8676002)(8936002)(356005)(7416002)(26005)(2906002)(110136005)(30864003)(6666004)(70206006)(70586007)(36756003)(82310400003)(921005)(83380400001)(316002)(1076003)(86362001)(54906003)(7696005)(5660300002)(107886003)(7636003)(36860700001)(4326008)(426003)(186003)(508600001)(47076005)(336012)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:07:09.5289
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b12c94ab-eb95-4c2d-2f3d-08d94d00d9a2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4015
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoray Zack <yorayz@nvidia.com>

When the driver indicate an OOO NVMEoTCP Tx packet it starts OOO flow:

1. Get pdu_info from nvme-tcp.
2. Send indication to NIC (set psv)- NIC will rebuild the parse machine.
3. Send the data the NIC needs for computing the DDGST using DUMP wqes.

Signed-off-by: Yoray Zack <yorayz@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   2 +-
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 281 +++++++++++++++++-
 2 files changed, 280 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index c7f979dfdd69..1f4beaac488a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -142,7 +142,7 @@ struct mlx5e_tx_wqe_info {
 	u8 num_wqebbs;
 	u8 num_dma;
 	u8 num_fifo_pkts;
-#ifdef CONFIG_MLX5_EN_TLS
+#if defined CONFIG_MLX5_EN_TLS || defined CONFIG_MLX5_EN_NVMEOTCP
 	struct page *resync_dump_frag_page;
 	enum mlx5e_dump_wqe_type type;
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index d9f6125f5dbc..f8cba90679ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -3,6 +3,7 @@
 
 #include <linux/netdevice.h>
 #include <linux/idr.h>
+#include <linux/blk-mq.h>
 #include <linux/nvme-tcp.h>
 #include "en_accel/nvmeotcp.h"
 #include "en_accel/nvmeotcp_utils.h"
@@ -267,6 +268,18 @@ fill_nvmeotcp_progress_params(struct mlx5e_nvmeotcp_queue *queue,
 		MLX5_SET(nvmeotcp_progress_params, ctx, offloading_state, 0);
 }
 
+struct mlx5e_dump_wqe {
+	struct mlx5_wqe_ctrl_seg ctrl;
+	struct mlx5_wqe_data_seg data;
+};
+
+#define MLX5E_NVME_DUMP_WQEBBS\
+	(DIV_ROUND_UP(sizeof(struct mlx5e_dump_wqe), MLX5_SEND_WQE_BB))
+
+#define MLX5E_NVME_FETCH_DUMP_WQE(sq, pi) \
+	((struct mlx5e_dump_wqe *)\
+	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_dump_wqe)))
+
 static void nvme_tx_fill_wi(struct mlx5e_txqsq *sq,
 			    u16 pi, u8 num_wqebbs, u32 num_bytes,
 			    struct page *page, enum mlx5e_dump_wqe_type type)
@@ -276,9 +289,65 @@ static void nvme_tx_fill_wi(struct mlx5e_txqsq *sq,
 	*wi = (struct mlx5e_tx_wqe_info) {
 		.num_wqebbs = num_wqebbs,
 		.num_bytes  = num_bytes,
+		.resync_dump_frag_page = page,
+		.type = type,
 	};
 }
 
+static void mlx5e_nvmeotcp_tx_post_fence_nop(struct mlx5e_txqsq *sq)
+{
+	struct mlx5_wq_cyc *wq = &sq->wq;
+	u16 pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+
+	nvme_tx_fill_wi(sq, pi, 1, 0, NULL, MLX5E_DUMP_WQE_NVMEOTCP);
+
+	mlx5e_post_nop_fence(wq, sq->sqn, &sq->pc);
+}
+
+static int
+nvmeotcp_post_resync_dump(struct mlx5e_txqsq *sq, skb_frag_t *frag,
+			  u32 tisn, bool first, enum mlx5e_dump_wqe_type type)
+{
+	struct mlx5_wqe_ctrl_seg *cseg;
+	struct mlx5_wqe_data_seg *dseg;
+	struct mlx5e_dump_wqe *wqe;
+	dma_addr_t dma_addr;
+	u16 ds_cnt;
+	int fsz;
+	u16 pi;
+
+	BUILD_BUG_ON(MLX5E_NVME_DUMP_WQEBBS != 1);
+	pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+	wqe = MLX5E_NVME_FETCH_DUMP_WQE(sq, pi);
+
+	ds_cnt = sizeof(*wqe) / MLX5_SEND_WQE_DS;
+
+	cseg = &wqe->ctrl;
+	dseg = &wqe->data;
+
+	cseg->opmod_idx_opcode = cpu_to_be32((sq->pc << 8)  | MLX5_OPCODE_DUMP);
+	cseg->qpn_ds           = cpu_to_be32((sq->sqn << 8) | ds_cnt);
+	cseg->tis_tir_num      = cpu_to_be32(tisn << 8);
+	cseg->fm_ce_se         = first ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
+
+	fsz = skb_frag_size(frag);
+	dma_addr = skb_frag_dma_map(sq->pdev, frag, 0, fsz,
+				    DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(sq->pdev, dma_addr)))
+		return -ENOMEM;
+
+	dseg->addr       = cpu_to_be64(dma_addr);
+	dseg->lkey       = sq->mkey_be;
+	dseg->byte_count = cpu_to_be32(fsz);
+	mlx5e_dma_push(sq, dma_addr, fsz, MLX5E_DMA_MAP_PAGE);
+
+	nvme_tx_fill_wi(sq, pi, MLX5E_NVME_DUMP_WQEBBS,
+			fsz, skb_frag_page(frag), type);
+	sq->pc +=  MLX5E_NVME_DUMP_WQEBBS;
+	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
+	return 0;
+}
+
 void
 build_nvmeotcp_progress_params(struct mlx5e_nvmeotcp_queue *queue,
 			       struct mlx5e_set_nvmeotcp_progress_params_wqe *wqe,
@@ -295,6 +364,7 @@ build_nvmeotcp_progress_params(struct mlx5e_nvmeotcp_queue *queue,
 					     MLX5_OPCODE_SET_PSV | (opc_mod << 24));
 	cseg->qpn_ds = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
 				   PROGRESS_PARAMS_DS_CNT);
+	cseg->fm_ce_se         = resync ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
 	fill_nvmeotcp_progress_params(queue, &wqe->params, seq, !is_rx);
 }
 
@@ -1160,6 +1230,202 @@ void mlx5e_nvmeotcp_tx_post_param_wqes(struct mlx5e_txqsq *sq, struct sock *sk,
 	mlx5e_nvmeotcp_tx_post_progress_params(ctx, sq, tcp_sk(sk)->copied_seq, false);
 }
 
+enum mlx5e_nvmeotcp_resync_retval {
+	MLX5E_NVMEOTCP_RESYNC_DONE,
+	MLX5E_NVMEOTCP_RESYNC_FAIL,
+	MLX5E_NVMEOTCP_RESYNC_SKIP,
+};
+
+static
+int mlx5e_nvmeotcp_resync_frag(struct mlx5e_nvmeotcp_queue *queue,
+			       struct mlx5e_txqsq *sq, struct sk_buff *skb,
+			       int i, skb_frag_t *frag, u32  seq)
+{
+	unsigned int orig_fsz, frag_offset = 0, n = 0;
+	enum mlx5e_dump_wqe_type type = MLX5E_DUMP_WQE_NVMEOTCP;
+
+	orig_fsz = skb_frag_size(frag);
+
+	do {
+		bool fence = !(i || frag_offset);
+		unsigned int fsz;
+
+		n++;
+		fsz = min_t(unsigned int, sq->hw_mtu, orig_fsz - frag_offset);
+		skb_frag_size_set(frag, fsz);
+		if (nvmeotcp_post_resync_dump(sq, frag, queue->tisn, fence, type)) {
+			page_ref_add(compound_head(skb_frag_page(frag)), n - 1);
+			return -1;
+		}
+
+		skb_frag_off_add(frag, fsz);
+		frag_offset += fsz;
+	} while (frag_offset < orig_fsz);
+
+	page_ref_add(compound_head(skb_frag_page(frag)), n);
+
+	return 0;
+}
+
+static int mlx5e_nvmeotcp_resync_hdr(struct mlx5e_nvmeotcp_queue *queue,
+				     struct mlx5e_txqsq *sq, u32 seq,
+				     struct sk_buff *skb, int remaining,
+				     struct ulp_ddp_pdu_info *pdu_info)
+{
+	skb_frag_t pdu_frag;
+	int size = min_t(int, remaining, pdu_info->hdr_len);
+
+	__skb_frag_set_page(&pdu_frag, virt_to_page(pdu_info->hdr));
+	skb_frag_off_set(&pdu_frag, offset_in_page(pdu_info->hdr));
+	skb_frag_size_set(&pdu_frag, size);
+
+	return mlx5e_nvmeotcp_resync_frag(queue, sq, skb, 0, &pdu_frag, seq);
+}
+
+static void mlx5e_nvmeotcp_init_iter(struct iov_iter *iter, struct bio *bio)
+{
+	unsigned int bio_size;
+	struct bio_vec *vec;
+	int nsegs;
+
+	vec = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
+	nsegs = bio_segments(bio);
+	bio_size = bio->bi_iter.bi_size;
+	iov_iter_bvec(iter, 1, vec, nsegs, bio_size);
+	iter->iov_offset = 0;
+}
+
+static int mlx5e_nvmeotcp_resync_data(struct mlx5e_nvmeotcp_queue *queue,
+				      struct mlx5e_txqsq *sq, u32 seq,
+				      struct sk_buff *skb, int remaining,
+				      struct ulp_ddp_pdu_info *pdu_info)
+{
+	struct request *req = pdu_info->req;
+	struct bio *bio = req->bio;
+	struct iov_iter iter;
+	int data_remaining;
+	size_t data_sent = 0;
+
+	mlx5e_nvmeotcp_init_iter(&iter, bio);
+
+	data_remaining = min_t(int, remaining, pdu_info->data_len);
+
+	while (data_remaining > 0) {
+		skb_frag_t frag;
+		size_t size = min_t(size_t,
+				    iter.bvec->bv_len - iter.iov_offset
+				    , data_remaining);
+
+		__skb_frag_set_page(&frag, iter.bvec->bv_page);
+		skb_frag_off_set(&frag, iter.bvec->bv_offset + iter.iov_offset);
+		skb_frag_size_set(&frag, size);
+		data_remaining -= size;
+
+		if (mlx5e_nvmeotcp_resync_frag(queue, sq, skb, 1, &frag, seq))
+			goto err_out;
+
+		if (!data_remaining)
+			break;
+
+		data_sent += size;
+		iov_iter_advance(&iter, size);
+		if (!iov_iter_count(&iter) && data_sent < pdu_info->data_len) {
+			bio = bio->bi_next;
+			mlx5e_nvmeotcp_init_iter(&iter, bio);
+		}
+	}
+
+	return 0;
+err_out:
+	return -1;
+}
+
+static int mlx5e_nvmeotcp_resync_crc(struct mlx5e_nvmeotcp_queue *queue,
+				     struct mlx5e_txqsq *sq, u32 seq,
+				     struct sk_buff *skb, int remaining,
+				     struct ulp_ddp_pdu_info *pdu_info)
+{
+	skb_frag_t crc_frag;
+	u32 dummy_ddigest = 0;
+
+	__skb_frag_set_page(&crc_frag, virt_to_page(&dummy_ddigest));
+	skb_frag_off_set(&crc_frag, offset_in_page(&dummy_ddigest));
+	skb_frag_size_set(&crc_frag, remaining);
+	return mlx5e_nvmeotcp_resync_frag(queue, sq, skb, 1, &crc_frag, seq);
+}
+
+/* for a pdu info mapping [--------seq----] capsule
+ ******* send to HW [-------|seq *******************/
+static
+bool mlx5e_nvmeotcp_resync_cap(struct mlx5e_nvmeotcp_queue *queue,
+			       struct mlx5e_txqsq *sq, struct sk_buff *skb,
+			       struct ulp_ddp_pdu_info *pdu_info,
+			       u32  seq)
+{
+	int remaining = seq - pdu_info->start_seq;
+	int ret;
+
+	ret = mlx5e_nvmeotcp_resync_hdr(queue, sq, seq, skb, remaining,
+					pdu_info);
+	if (unlikely(ret))
+		goto err_out;
+
+	remaining -= pdu_info->hdr_len;
+	if (remaining <= 0)
+		goto out;
+
+	ret = mlx5e_nvmeotcp_resync_data(queue, sq, seq, skb, remaining,
+					 pdu_info);
+	if (unlikely(ret))
+		goto err_out;
+
+	remaining -= pdu_info->data_len;
+	if (remaining <= 0)
+		goto out;
+
+	ret = mlx5e_nvmeotcp_resync_crc(queue, sq, seq, skb, remaining,
+					pdu_info);
+	if (unlikely(ret))
+		goto err_out;
+out:
+	return true;
+err_out:
+	return false;
+}
+
+static enum mlx5e_nvmeotcp_resync_retval
+mlx5e_nvmeotcp_handle_ooo_skb(struct mlx5e_nvmeotcp_queue *queue,
+			      struct mlx5e_txqsq *sq, struct sk_buff *skb,
+			      u32  seq, int datalen)
+{
+	struct ulp_ddp_pdu_info *pdu_info = NULL;
+
+	/* ask for pdu_info that includes the tcp_seq */
+	pdu_info = ulp_ddp_get_pdu_info(skb->sk, seq);
+
+	if (!pdu_info)
+		return MLX5E_NVMEOTCP_RESYNC_SKIP;
+
+	/*update NIC about resync - he will rebuild parse machine
+	 *send psv with small fence
+	 */
+	mlx5e_nvmeotcp_tx_post_progress_params(queue, sq, pdu_info->start_seq, true);
+
+	if (seq == pdu_info->start_seq || seq == pdu_info->end_seq) {
+		mlx5e_nvmeotcp_tx_post_fence_nop(sq);
+		return MLX5E_NVMEOTCP_RESYNC_DONE;
+	}
+
+	/* post dump wqes -
+	 * transfer the needed data to NIC HW using DUMP WQE with data [*,^]
+	 * saved in pdu_info
+	 */
+	if (unlikely(!mlx5e_nvmeotcp_resync_cap(queue, sq, skb, pdu_info, seq)))
+		return MLX5E_NVMEOTCP_RESYNC_FAIL;
+
+	return MLX5E_NVMEOTCP_RESYNC_DONE;
+}
+
 static inline bool mlx5e_is_sk_tx_device_offloaded(struct sock *sk)
 {
 	/* Return True after smp_store_release assing in
@@ -1199,8 +1465,19 @@ bool mlx5e_nvmeotcp_handle_tx_skb(struct net_device *netdev,
 		mlx5e_nvmeotcp_tx_post_param_wqes(sq, skb->sk, ctx);
 
 	seq = ntohl(tcp_hdr(skb)->seq);
-	if (unlikely(ctx->ulp_ddp_ctx.expected_seq != seq))
-		goto err_out;
+	if (unlikely(ctx->ulp_ddp_ctx.expected_seq != seq)) {
+		enum mlx5e_nvmeotcp_resync_retval ret =
+			mlx5e_nvmeotcp_handle_ooo_skb(ctx, sq, skb,
+						      seq, datalen);
+		switch (ret) {
+		case MLX5E_NVMEOTCP_RESYNC_DONE:
+			break;
+		case MLX5E_NVMEOTCP_RESYNC_SKIP:
+			goto out;
+		case MLX5E_NVMEOTCP_RESYNC_FAIL:
+			goto err_out;
+		}
+	}
 
 	*nvmeotcp_tisn = ctx->tisn;
 	ctx->ulp_ddp_ctx.expected_seq = seq + datalen;
-- 
2.24.1

