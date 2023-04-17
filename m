Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2538A6E477D
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjDQMVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjDQMUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:20:52 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DFE1706
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:20:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jeQe4agStsEj2MdtkJ5CksvgH+o85/OckORrIcyv22bJDRo9Bqsoz046mRnS5CfuqNvUxfr9ln7MvDL++pPA+GsafhhN3F0/mp+A+3cDW8KaIVbYUNoprjX0F8W62K6Cyolfdf2o6KqQmD2xHQXXb5kUiL5RZwxeX2ADZZiA6PohbPevO49ORyKkhlluZ85qIUetvQ39V0LI3SsxZMl+H760bgTiZEj8mlEy5g374pNXbEBRHjTlHGHJsg9vK5Ae6vIj3UFzqMuh9mqqv8CubkAiwNfiSluYpNU++EvUdak0lYNmjLr0N6RfnrXyUhuDPsf0eKrmsoQjVNq5OMTyfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r5DUHPfGGDd8fi/6ZCgAiNy2dVbDmg8o/O1w73bVQ9E=;
 b=Ow7NykkbSWdirECwLOkY1EXQg8qRwpxs5sInkbp8++69mAzXN+6b/8VhgO1lAmN6Y/DO9mOD7yTI9+8KWt3hUgrMv2fBksrbqWCaufUHYtaMdofvSdr/iipRPBcW+tzvL4FeUsGIYLCVm6biSpSiVOlsVyn4j4sv17uh4mo6bQdg11p3Db4o1lAi1qtqAJkrO8/bXjDadmGr+zQ0ShRxCYVJWidBW1XF97FXkAFKnmSauoARrtbiElm5ffcPqgaOdljbGyOw7pXM3aYtvQ/nxA8+0/gjrAsKFiy2pfrEfQ/y3CPGBD+X88TcNUwkdZsixkuz4zchJtWlS88qdPs5vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5DUHPfGGDd8fi/6ZCgAiNy2dVbDmg8o/O1w73bVQ9E=;
 b=jZBAYS7wlbczNcKELazWZ1zRIPruDIp7FLjL8yctytnj6Ta/O9TqysKUuHlUWjNhWDYSko7mcJTJT+o7XdntoMX1FwjNMiJwo6Z4SvFvBApTI2oF5UCfwltQ+50zHla3NyzAJfX3AqYWghcsn2PbHAVAlfoUcJ6SFBBrvYCOiWqgdpaHhRuk6bhZHJFzJgIaeP/tGtqn+3Yltw1w8WQGYUPzpHaCfU4q9v1D08ZKdyo3TBecXcQ3OPESMyn+0gaZmi8iJiG6zuy80IebMWm726lPDf5xj7JCyW5v6qKqDYY/E+TUClPXpyyFUP4j0b6El4ljzMr5tl6oM+IToj+NjA==
Received: from BN8PR04CA0005.namprd04.prod.outlook.com (2603:10b6:408:70::18)
 by MN2PR12MB4342.namprd12.prod.outlook.com (2603:10b6:208:264::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 12:20:18 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::d0) by BN8PR04CA0005.outlook.office365.com
 (2603:10b6:408:70::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Mon, 17 Apr 2023 12:20:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.31 via Frontend Transport; Mon, 17 Apr 2023 12:20:18 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 17 Apr 2023
 05:20:06 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 17 Apr
 2023 05:20:05 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 17 Apr
 2023 05:20:02 -0700
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
Subject: [PATCH net-next 05/15] net/mlx5e: XDP, Use multiple single-entry objects in xdpi_fifo
Date:   Mon, 17 Apr 2023 15:18:53 +0300
Message-ID: <20230417121903.46218-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230417121903.46218-1-tariqt@nvidia.com>
References: <20230417121903.46218-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT032:EE_|MN2PR12MB4342:EE_
X-MS-Office365-Filtering-Correlation-Id: e347950b-a071-45b9-47c5-08db3f3e1b5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Zay803WQpqDPEzwGau6LzMWMqoYSF0aAKGhHXLSNi3GpPFT9LTRKdzJxyI+FZU1TxsVLke3BLMsduylYBzTCr4C2YzlmjiKmwj7v740zvrnQKfCioj7aUQgSK//Zb8eGzkAo2NRiNaBlaqEdOMk2jwzRGRjJoXV1qTUTABBg3twr3M0tjivyjDWOuvd/SkJTH1DCudzjTAsmNG6o+Tq4hJiHZ/OgoTNCWKcvIddyN2B/fdq3L4ywbZvW17jYJJbPdwkEp3F2/4yNZWBozsFadKBTD12uKzTRwBCMpu61rJj4WzItWDshyS2DihlHkhkzvQsEd3Lgj86tV3o/qkTkas/SgjXAYqFV9XEOOK0ZUhGU1p9GZQPrDHazSqTUfloq9J7dYG8AhznasUl1SBK8gj+E9fVGOI4XMrE5klhh7lze1lQcVnMZQXYbQW6eVqMyQ4o0OY25mv5XPMK81Nv8eNU1l6W8cZw3zFRaeukuH0BYS2pLpXjZd7s1GnkuTUNm4rgvufa3qhS+TJttg0V2+R+VXq8M4h0bWAfRAdPr7PeH9KGcAe5u6auffzk70BSpuoMG2uvCJresVhC/m+xiKyHvaAECZ6yU9tMVMSAj1OXYcOtCcolk0Bkk/WUKMu/NSnTLAVhpxr3KMnEIwgQHl+Lukj5mRnsjoO+wHXMj1W38ViAbcnRJfdaBBbaIwIXYHLgBdl+yNPMKCTWFz6TkJwltW4i5O0XIqdOkoE8ru06bkVOCnbPigXGOWEQSoUiLPxnWi4wZwyeoHivPgGka3kC2/T1PtCL+vaUZz+CTJw=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(136003)(39860400002)(451199021)(40470700004)(36840700001)(46966006)(86362001)(36756003)(110136005)(316002)(4326008)(70586007)(54906003)(8676002)(70206006)(41300700001)(7696005)(478600001)(40480700001)(82310400005)(7416002)(5660300002)(8936002)(30864003)(2906002)(36860700001)(34020700004)(7636003)(356005)(82740400003)(186003)(107886003)(6666004)(1076003)(2616005)(26005)(336012)(426003)(47076005)(83380400001)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:20:18.0424
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e347950b-a071-45b9-47c5-08db3f3e1b5c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4342
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here we fix the current wi->num_pkts abuse, as it was used to indicate
multiple xdpi entries in the xdpi_fifo.

Instead, reduce mlx5e_xdp_info to the size of a single field, making it
a union of unions. Per packet, use as many instances as needed to
provide the information needed at the time of completion.

The sequence of xdpi instances pushed is well defined, derived by the
xmit_mode.

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 95 +++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  | 38 +++++---
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  8 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  8 +-
 5 files changed, 101 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 386f5a498e52..0e15afbe1673 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -476,7 +476,7 @@ struct mlx5e_txqsq {
 } ____cacheline_aligned_in_smp;
 
 struct mlx5e_xdp_info_fifo {
-	struct mlx5e_xdp_info *xi;
+	union mlx5e_xdp_info *xi;
 	u32 *cc;
 	u32 *pc;
 	u32 mask;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index dcae2d4e2c03..5dab9012dc2a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -63,7 +63,6 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 	struct page *page = virt_to_page(xdp->data);
 	struct mlx5e_xmit_data_frags xdptxdf = {};
 	struct mlx5e_xmit_data *xdptxd;
-	struct mlx5e_xdp_info xdpi;
 	struct xdp_frame *xdpf;
 	dma_addr_t dma_addr;
 	int i;
@@ -90,8 +89,6 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 		 */
 		__set_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags); /* non-atomic */
 
-		xdpi.mode = MLX5E_XDP_XMIT_MODE_FRAME;
-
 		if (unlikely(xdptxd->has_frags))
 			return false;
 
@@ -103,14 +100,18 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 		}
 
 		xdptxd->dma_addr = dma_addr;
-		xdpi.frame.xdpf     = xdpf;
-		xdpi.frame.dma_addr = dma_addr;
 
 		if (unlikely(!INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
 					      mlx5e_xmit_xdp_frame, sq, xdptxd, 0)))
 			return false;
 
-		mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, &xdpi);
+		/* xmit_mode == MLX5E_XDP_XMIT_MODE_FRAME */
+		mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo,
+				     (union mlx5e_xdp_info) { .mode = MLX5E_XDP_XMIT_MODE_FRAME });
+		mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo,
+				     (union mlx5e_xdp_info) { .frame.xdpf = xdpf });
+		mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo,
+				     (union mlx5e_xdp_info) { .frame.dma_addr = dma_addr });
 		return true;
 	}
 
@@ -120,9 +121,6 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 	 * mode.
 	 */
 
-	xdpi.mode = MLX5E_XDP_XMIT_MODE_PAGE;
-	xdpi.page.rq = rq;
-
 	dma_addr = page_pool_get_dma_addr(page) + (xdpf->data - (void *)xdpf);
 	dma_sync_single_for_device(sq->pdev, dma_addr, xdptxd->len, DMA_BIDIRECTIONAL);
 
@@ -148,16 +146,28 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 				      mlx5e_xmit_xdp_frame, sq, xdptxd, 0)))
 		return false;
 
-	xdpi.page.page = page;
-	mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, &xdpi);
+	/* xmit_mode == MLX5E_XDP_XMIT_MODE_PAGE */
+	mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo,
+			     (union mlx5e_xdp_info) { .mode = MLX5E_XDP_XMIT_MODE_PAGE });
 
 	if (xdptxd->has_frags) {
+		mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo,
+				     (union mlx5e_xdp_info)
+				     { .page.num = 1 + xdptxdf.sinfo->nr_frags });
+		mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo,
+				     (union mlx5e_xdp_info) { .page.page = page });
 		for (i = 0; i < xdptxdf.sinfo->nr_frags; i++) {
 			skb_frag_t *frag = &xdptxdf.sinfo->frags[i];
 
-			xdpi.page.page = skb_frag_page(frag);
-			mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, &xdpi);
+			mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo,
+					     (union mlx5e_xdp_info)
+					     { .page.page = skb_frag_page(frag) });
 		}
+	} else {
+		mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo,
+				     (union mlx5e_xdp_info) { .page.num = 1 });
+		mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo,
+				     (union mlx5e_xdp_info) { .page.page = page });
 	}
 
 	return true;
@@ -526,7 +536,6 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 	cseg->opmod_idx_opcode = cpu_to_be32((sq->pc << 8) | MLX5_OPCODE_SEND);
 
 	if (test_bit(MLX5E_SQ_STATE_XDP_MULTIBUF, &sq->state)) {
-		u8 num_pkts = 1 + num_frags;
 		int i;
 
 		memset(&cseg->trailer, 0, sizeof(cseg->trailer));
@@ -552,7 +561,7 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 
 		sq->db.wqe_info[pi] = (struct mlx5e_xdp_wqe_info) {
 			.num_wqebbs = num_wqebbs,
-			.num_pkts = num_pkts,
+			.num_pkts = 1,
 		};
 
 		sq->pc += num_wqebbs;
@@ -577,20 +586,46 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 	u16 i;
 
 	for (i = 0; i < wi->num_pkts; i++) {
-		struct mlx5e_xdp_info xdpi = mlx5e_xdpi_fifo_pop(xdpi_fifo);
+		union mlx5e_xdp_info xdpi = mlx5e_xdpi_fifo_pop(xdpi_fifo);
 
 		switch (xdpi.mode) {
-		case MLX5E_XDP_XMIT_MODE_FRAME:
+		case MLX5E_XDP_XMIT_MODE_FRAME: {
 			/* XDP_TX from the XSK RQ and XDP_REDIRECT */
-			dma_unmap_single(sq->pdev, xdpi.frame.dma_addr,
-					 xdpi.frame.xdpf->len, DMA_TO_DEVICE);
-			xdp_return_frame_bulk(xdpi.frame.xdpf, bq);
+			struct xdp_frame *xdpf;
+			dma_addr_t dma_addr;
+
+			xdpi = mlx5e_xdpi_fifo_pop(xdpi_fifo);
+			xdpf = xdpi.frame.xdpf;
+			xdpi = mlx5e_xdpi_fifo_pop(xdpi_fifo);
+			dma_addr = xdpi.frame.dma_addr;
+
+			dma_unmap_single(sq->pdev, dma_addr,
+					 xdpf->len, DMA_TO_DEVICE);
+			xdp_return_frame_bulk(xdpf, bq);
 			break;
-		case MLX5E_XDP_XMIT_MODE_PAGE:
+		}
+		case MLX5E_XDP_XMIT_MODE_PAGE: {
 			/* XDP_TX from the regular RQ */
-			page_pool_put_defragged_page(xdpi.page.rq->page_pool,
-						     xdpi.page.page, -1, true);
+			u8 num, n = 0;
+
+			xdpi = mlx5e_xdpi_fifo_pop(xdpi_fifo);
+			num = xdpi.page.num;
+
+			do {
+				struct page *page;
+
+				xdpi = mlx5e_xdpi_fifo_pop(xdpi_fifo);
+				page = xdpi.page.page;
+
+				/* No need to check ((page->pp_magic & ~0x3UL) == PP_SIGNATURE)
+				 * as we know this is a page_pool page.
+				 */
+				page_pool_put_defragged_page(page->pp,
+							     page, -1, true);
+			} while (++n < num);
+
 			break;
+		}
 		case MLX5E_XDP_XMIT_MODE_XSK:
 			/* AF_XDP send */
 			(*xsk_frames)++;
@@ -726,7 +761,6 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	for (i = 0; i < n; i++) {
 		struct xdp_frame *xdpf = frames[i];
 		struct mlx5e_xmit_data xdptxd = {};
-		struct mlx5e_xdp_info xdpi;
 		bool ret;
 
 		xdptxd.data = xdpf->data;
@@ -737,10 +771,6 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		if (unlikely(dma_mapping_error(sq->pdev, xdptxd.dma_addr)))
 			break;
 
-		xdpi.mode           = MLX5E_XDP_XMIT_MODE_FRAME;
-		xdpi.frame.xdpf     = xdpf;
-		xdpi.frame.dma_addr = xdptxd.dma_addr;
-
 		ret = INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
 				      mlx5e_xmit_xdp_frame, sq, &xdptxd, 0);
 		if (unlikely(!ret)) {
@@ -748,7 +778,14 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 					 xdptxd.len, DMA_TO_DEVICE);
 			break;
 		}
-		mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, &xdpi);
+
+		/* xmit_mode == MLX5E_XDP_XMIT_MODE_FRAME */
+		mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo,
+				     (union mlx5e_xdp_info) { .mode = MLX5E_XDP_XMIT_MODE_FRAME });
+		mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo,
+				     (union mlx5e_xdp_info) { .frame.xdpf = xdpf });
+		mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo,
+				     (union mlx5e_xdp_info) { .frame.dma_addr = xdptxd.dma_addr });
 		nxmit++;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 8e97c68d11f4..9e8e6184f9e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -71,18 +71,30 @@ enum mlx5e_xdp_xmit_mode {
 	MLX5E_XDP_XMIT_MODE_XSK,
 };
 
-struct mlx5e_xdp_info {
+/* xmit_mode entry is pushed to the fifo per packet, followed by multiple
+ * entries, as follows:
+ *
+ * MLX5E_XDP_XMIT_MODE_FRAME:
+ *    xdpf, dma_addr_1, dma_addr_2, ... , dma_addr_num.
+ *    'num' is derived from xdpf.
+ *
+ * MLX5E_XDP_XMIT_MODE_PAGE:
+ *    num, page_1, page_2, ... , page_num.
+ *
+ * MLX5E_XDP_XMIT_MODE_XSK:
+ *    none.
+ */
+union mlx5e_xdp_info {
 	enum mlx5e_xdp_xmit_mode mode;
 	union {
-		struct {
-			struct xdp_frame *xdpf;
-			dma_addr_t dma_addr;
-		} frame;
-		struct {
-			struct mlx5e_rq *rq;
-			struct page *page;
-		} page;
-	};
+		struct xdp_frame *xdpf;
+		dma_addr_t dma_addr;
+	} frame;
+	union {
+		struct mlx5e_rq *rq;
+		u8 num;
+		struct page *page;
+	} page;
 };
 
 struct mlx5e_xsk_param;
@@ -212,14 +224,14 @@ mlx5e_xdp_mpwqe_add_dseg(struct mlx5e_xdpsq *sq,
 
 static inline void
 mlx5e_xdpi_fifo_push(struct mlx5e_xdp_info_fifo *fifo,
-		     struct mlx5e_xdp_info *xi)
+		     union mlx5e_xdp_info xi)
 {
 	u32 i = (*fifo->pc)++ & fifo->mask;
 
-	fifo->xi[i] = *xi;
+	fifo->xi[i] = xi;
 }
 
-static inline struct mlx5e_xdp_info
+static inline union mlx5e_xdp_info
 mlx5e_xdpi_fifo_pop(struct mlx5e_xdp_info_fifo *fifo)
 {
 	return fifo->xi[(*fifo->cc)++ & fifo->mask];
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index b370a4daddfd..597f319d4770 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -44,7 +44,7 @@ int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
  * same.
  */
 static void mlx5e_xsk_tx_post_err(struct mlx5e_xdpsq *sq,
-				  struct mlx5e_xdp_info *xdpi)
+				  union mlx5e_xdp_info *xdpi)
 {
 	u16 pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
 	struct mlx5e_xdp_wqe_info *wi = &sq->db.wqe_info[pi];
@@ -54,14 +54,14 @@ static void mlx5e_xsk_tx_post_err(struct mlx5e_xdpsq *sq,
 	wi->num_pkts = 1;
 
 	nopwqe = mlx5e_post_nop(&sq->wq, sq->sqn, &sq->pc);
-	mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, xdpi);
+	mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, *xdpi);
 	sq->doorbell_cseg = &nopwqe->ctrl;
 }
 
 bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 {
 	struct xsk_buff_pool *pool = sq->xsk_pool;
-	struct mlx5e_xdp_info xdpi;
+	union mlx5e_xdp_info xdpi;
 	bool work_done = true;
 	bool flush = false;
 
@@ -105,7 +105,7 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 
 			mlx5e_xsk_tx_post_err(sq, &xdpi);
 		} else {
-			mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, &xdpi);
+			mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, xdpi);
 		}
 
 		flush = true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ec72743b64e2..0b5aafaefe4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1300,17 +1300,19 @@ static int mlx5e_alloc_xdpsq_fifo(struct mlx5e_xdpsq *sq, int numa)
 {
 	struct mlx5e_xdp_info_fifo *xdpi_fifo = &sq->db.xdpi_fifo;
 	int wq_sz        = mlx5_wq_cyc_get_size(&sq->wq);
-	int dsegs_per_wq = wq_sz * MLX5_SEND_WQEBB_NUM_DS;
+	int entries = wq_sz * MLX5_SEND_WQEBB_NUM_DS * 2; /* upper bound for maximum num of
+							   * entries of all xmit_modes.
+							   */
 	size_t size;
 
-	size = array_size(sizeof(*xdpi_fifo->xi), dsegs_per_wq);
+	size = array_size(sizeof(*xdpi_fifo->xi), entries);
 	xdpi_fifo->xi = kvzalloc_node(size, GFP_KERNEL, numa);
 	if (!xdpi_fifo->xi)
 		return -ENOMEM;
 
 	xdpi_fifo->pc   = &sq->xdpi_fifo_pc;
 	xdpi_fifo->cc   = &sq->xdpi_fifo_cc;
-	xdpi_fifo->mask = dsegs_per_wq - 1;
+	xdpi_fifo->mask = entries - 1;
 
 	return 0;
 }
-- 
2.34.1

