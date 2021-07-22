Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0463D2287
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbhGVK0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:26:22 -0400
Received: from mail-dm6nam11on2060.outbound.protection.outlook.com ([40.107.223.60]:5409
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231634AbhGVK0U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:26:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xv3txadA6JLUb/jtsDplnK4ut7rrpc7hQF+/rIknn8cN5sNdiw40HXF6r0OiAigymjhH61OaTqi5Od5LM7Il/TcgBHzeLVw7C7ph0d8Jj4rlNsvbMDTpLeTPzD79M2bEYxodCih8024z0hE6ZAbbSVZiBQYhdmOj4eQpqXrq3SkjUBjqL9DKC/AfFzYhy7V36CPAOPscaavKaTfeA0ZMdcAgNGm4PAPoLqldcAUmkjParbGwbbQslm0C3elNByOSmxZs6vrEohEhc7RfSvEw5c6lJJhUvXfMAsUZt5seqenCyMKZaqynmzk08aukvLptfxcatAyv//26ddkakOtx5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BWC1042/NGaBW9CLIxVx6DTXYRtNGfao542cVCSd1jk=;
 b=VGuWjefNLJBHSONfBRAc6qwpC/z3A3L2LejvCT5qEX5G7NOvXLoBXoyFx80Pk7tZRQMXBzR3tIeD6/FCzrVLySGhdu/N3MAJP0iFsHT0RIwRQj/tmoerxIE4AmKOxowSW7giniayLEilpnFCDEqsE6cE4sXP62fP7XobkAdtncm8db93mmEOi0LRrYo2iRgoQtE7+v7AjNgljOj0qLf+BxUYjZ90NXYtiakMuf/wR0rKTUwk+MoyHlvNzzdsZi+YOWJ6JFaf0+9EoQLfZbVAiLigfngQt9j8TMOkeQDNed/9qhZWdMPXu23eM35CMIUECMQPJWbdzirHAxpg8k4/QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BWC1042/NGaBW9CLIxVx6DTXYRtNGfao542cVCSd1jk=;
 b=mS8hqJy3j7PTgcWD1BjfbKnpnnbO7yfGTqO2Y4k37/10+/RCGAnCJqaZ82hVKkcn+FwBP+z4Qn0KebFl6MWdhttg4ya7NxyMu41ORgZM5Re3Z2s7k/fmodcAe6qhwKbM8gEIUfEgjC4W5dFAGOOgh9LxaZa4khjQw0sabwO6yZqw0FgFSaS7TcocNvHKMoZXM3SlKOK5qgHPQnRzPUTaIgh6SdEgm8qfmlFIAoDTglB1j9j2dq0eXQwV3UPV7sBPAHWLh5JYg9cpnxyeD9WvpFeP4qMXTW46I3pjcZQxzVm4dTdz9Ld+sATqKBwH+jlzHHYqA00YOb2PNwbkEifH5w==
Received: from MWHPR2001CA0007.namprd20.prod.outlook.com
 (2603:10b6:301:15::17) by MWHPR1201MB0157.namprd12.prod.outlook.com
 (2603:10b6:301:55::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.30; Thu, 22 Jul
 2021 11:06:53 +0000
Received: from CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:15:cafe::60) by MWHPR2001CA0007.outlook.office365.com
 (2603:10b6:301:15::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT038.mail.protection.outlook.com (10.13.174.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:06:53 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:06:52 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:47 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>
Subject: [PATCH v5 net-next 32/36] net/mlx5e: NVMEoTCP DDGST TX BSF and PSV
Date:   Thu, 22 Jul 2021 14:03:21 +0300
Message-ID: <20210722110325.371-33-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8a2e30b-5da2-444f-b099-08d94d00d01a
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0157:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB015775F35123B88362DB8B03BDE49@MWHPR1201MB0157.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: epFaiSZBusXF0BexeSDABq3jlJU2j2ITe0/lnAmkYAucdzeYdzwUsLPRejlCWm+7b6l15NT7tmk+4h5pzI0z5N2L7DgzsxC4ENst823kolHPlYoKZWqlTcAggOdHS8fLpXJigzOMxBO4fN0efGF0el+v2Xesy7XfEDTGJMlDqnLMYcxZEZ3ReVZPHglxnrKS5tM+PR+QyWVP7vMF6Lyr5ldD2cAiVwDtNWoH677o9PdFhNdlaIvpmr81BqST14ko4IF2jBNeu8vkmyFI8A8zlJ06RACKus6K8rfCc2cQyE9A+gy1uYyhwSOKs8w6gDTw/Kp7HmsE9yH0JpZG5bi6TXxL7NvQv84cGknxtm1dwdeGoHd+05bOoAePVdVzC+PzKite2Kretfg61JgrLR0JG/66OhNFYgjS+dWd9Gk7Zrjo9ByEWMytqrH5sX84S4NxSxcOYKgnHV4gOxqzwt5/D8WDQLilA7i+0TtH6LurxmCKZ/ELWFHWK5f0oPXA5xLrdZcWBSZoAMMSMxnv+go5O0wLdnYXMDPJUowVHQIOGiou9YRfJ8bTW8sRNE+UjyNOhiivdgxtsWc78jDTzlYqjQWhXEOXQJs+70kuofd4F1i+QQ/oO2NbCWCevQjtydgxsV1fUGqQveTFSLPrXY2e13C/ZjC4nX/gbEC2vRuQCECJqRK4kK2xiyXtWQloDakCMQcTarckNe4M56v+vJ03FOmwqpzE5zEh+PoQhbM2VAs=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(39860400002)(136003)(46966006)(36840700001)(70206006)(70586007)(107886003)(5660300002)(7416002)(82310400003)(7636003)(8936002)(54906003)(36860700001)(4326008)(36906005)(478600001)(356005)(316002)(110136005)(82740400003)(186003)(47076005)(83380400001)(336012)(36756003)(2906002)(6666004)(921005)(8676002)(2616005)(26005)(86362001)(426003)(7696005)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:06:53.4505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8a2e30b-5da2-444f-b099-08d94d00d01a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0157
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoray Zack <yorayz@nvidia.com>

Change the function that build NVMEoTCP progress params and static params,
to work for Tx/Rx.

Signed-off-by: Yoray Zack <yorayz@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 130 ++++++++++++++----
 .../mlx5/core/en_accel/nvmeotcp_utils.h       |   4 +-
 2 files changed, 108 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index 6023e1ae7be4..624d8a28dc21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -155,8 +155,11 @@ static int mlx5e_nvmeotcp_create_tis(struct mlx5_core_dev *mdev, u32 *tisn)
 }
 
 #define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_TIR_PARAMS 0x2
+#define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_TIS_PARAMS 0x1
 #define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIR_STATIC_PARAMS 0x2
 #define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_UMR 0x0
+#define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIS_STATIC_PARAMS 0x1
+#define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIS_PROGRESS_PARAMS 0x3
 
 #define STATIC_PARAMS_DS_CNT \
 	DIV_ROUND_UP(MLX5E_NVMEOTCP_STATIC_PARAMS_WQE_SZ, MLX5_SEND_WQE_DS)
@@ -250,56 +253,75 @@ build_nvmeotcp_klm_umr(struct mlx5e_nvmeotcp_queue *queue,
 static void
 fill_nvmeotcp_progress_params(struct mlx5e_nvmeotcp_queue *queue,
 			      struct mlx5_seg_nvmeotcp_progress_params *params,
-			      u32 seq)
+			      u32 seq, bool is_tx)
 {
 	void *ctx = params->ctx;
 
-	params->tir_num = cpu_to_be32(queue->tirn);
+	params->tir_num = is_tx ? cpu_to_be32(queue->tisn) : cpu_to_be32(queue->tirn);
 
 	MLX5_SET(nvmeotcp_progress_params, ctx,
 		 next_pdu_tcp_sn, seq);
 	MLX5_SET(nvmeotcp_progress_params, ctx, pdu_tracker_state,
 		 MLX5E_NVMEOTCP_PROGRESS_PARAMS_PDU_TRACKER_STATE_START);
+	if (is_tx)
+		MLX5_SET(nvmeotcp_progress_params, ctx, offloading_state, 0);
+}
+
+static void nvme_tx_fill_wi(struct mlx5e_txqsq *sq,
+			    u16 pi, u8 num_wqebbs, u32 num_bytes,
+			    struct page *page, enum mlx5e_dump_wqe_type type)
+{
+	struct mlx5e_tx_wqe_info *wi = &sq->db.wqe_info[pi];
+
+	*wi = (struct mlx5e_tx_wqe_info) {
+		.num_wqebbs = num_wqebbs,
+		.num_bytes  = num_bytes,
+	};
 }
 
 void
 build_nvmeotcp_progress_params(struct mlx5e_nvmeotcp_queue *queue,
 			       struct mlx5e_set_nvmeotcp_progress_params_wqe *wqe,
-			       u32 seq)
+			       u32 seq, bool is_rx, bool resync, u16 pc, u32 sqn)
 {
 	struct mlx5_wqe_ctrl_seg *cseg = &wqe->ctrl;
-	u32 sqn = queue->sq->icosq.sqn;
-	u16 pc = queue->sq->icosq.pc;
-	u8 opc_mod;
+	u8 opc_mod = is_rx ?
+		MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIR_PROGRESS_PARAMS :
+		MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIS_PROGRESS_PARAMS;
 
 	memset(wqe, 0, MLX5E_NVMEOTCP_PROGRESS_PARAMS_WQE_SZ);
-	opc_mod = MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIR_PROGRESS_PARAMS;
+
 	cseg->opmod_idx_opcode = cpu_to_be32((pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
 					     MLX5_OPCODE_SET_PSV | (opc_mod << 24));
 	cseg->qpn_ds = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
 				   PROGRESS_PARAMS_DS_CNT);
-	fill_nvmeotcp_progress_params(queue, &wqe->params, seq);
+	fill_nvmeotcp_progress_params(queue, &wqe->params, seq, !is_rx);
 }
 
 static void
 fill_nvmeotcp_static_params(struct mlx5e_nvmeotcp_queue *queue,
 			    struct mlx5_seg_nvmeotcp_static_params *params,
-			    u32 resync_seq, bool zero_copy_en,
+			    u32 resync_seq, bool is_rx, bool zero_copy_en,
 			    bool ddgst_offload_en)
 {
 	void *ctx = params->ctx;
+	int pda = queue->pda;
+	bool hddgst_en = queue->dgst & NVME_TCP_HDR_DIGEST_ENABLE;
+	bool ddgst_en = queue->dgst & NVME_TCP_DATA_DIGEST_ENABLE;
+
+	if (!is_rx) {
+		pda = 0;
+	}
 
 	MLX5_SET(transport_static_params, ctx, const_1, 1);
 	MLX5_SET(transport_static_params, ctx, const_2, 2);
 	MLX5_SET(transport_static_params, ctx, acc_type,
 		 MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_NVMETCP);
 	MLX5_SET(transport_static_params, ctx, nvme_resync_tcp_sn, resync_seq);
-	MLX5_SET(transport_static_params, ctx, pda, queue->pda);
-	MLX5_SET(transport_static_params, ctx, ddgst_en,
-		 queue->dgst & NVME_TCP_DATA_DIGEST_ENABLE);
+	MLX5_SET(transport_static_params, ctx, pda, pda);
+	MLX5_SET(transport_static_params, ctx, ddgst_en, ddgst_en);
 	MLX5_SET(transport_static_params, ctx, ddgst_offload_en, ddgst_offload_en);
-	MLX5_SET(transport_static_params, ctx, hddgst_en,
-		 queue->dgst & NVME_TCP_HDR_DIGEST_ENABLE);
+	MLX5_SET(transport_static_params, ctx, hddgst_en, hddgst_en);
 	MLX5_SET(transport_static_params, ctx, hdgst_offload_en, 0);
 	MLX5_SET(transport_static_params, ctx, ti,
 		 MLX5_TRANSPORT_STATIC_PARAMS_TI_INITIATOR);
@@ -310,26 +332,31 @@ fill_nvmeotcp_static_params(struct mlx5e_nvmeotcp_queue *queue,
 void
 build_nvmeotcp_static_params(struct mlx5e_nvmeotcp_queue *queue,
 			     struct mlx5e_set_nvmeotcp_static_params_wqe *wqe,
-			     u32 resync_seq, bool zerocopy, bool crc_rx)
+			     u32 resync_seq, bool is_rx, u16 pc, u32 sqn,
+			     bool zerocopy, bool crc_rx)
 {
-	u8 opc_mod = MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIR_STATIC_PARAMS;
 	struct mlx5_wqe_umr_ctrl_seg *ucseg = &wqe->uctrl;
 	struct mlx5_wqe_ctrl_seg      *cseg = &wqe->ctrl;
-	u32 sqn = queue->sq->icosq.sqn;
-	u16 pc = queue->sq->icosq.pc;
+	int tirn_tisn = is_rx ? queue->tirn : queue->tisn;
+	u8 opc_mod = is_rx ?
+		MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIR_STATIC_PARAMS :
+		MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIS_STATIC_PARAMS;
+
 
 	memset(wqe, 0, MLX5E_NVMEOTCP_STATIC_PARAMS_WQE_SZ);
 
-	cseg->opmod_idx_opcode = cpu_to_be32((pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
-					     MLX5_OPCODE_UMR | (opc_mod) << 24);
+	cseg->opmod_idx_opcode  = cpu_to_be32((pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
+					      MLX5_OPCODE_UMR | (opc_mod) << 24);
 	cseg->qpn_ds = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
 				   STATIC_PARAMS_DS_CNT);
-	cseg->imm = cpu_to_be32(queue->tirn << MLX5_WQE_CTRL_TIR_TIS_INDEX_SHIFT);
+	cseg->imm = cpu_to_be32(tirn_tisn <<
+				MLX5_WQE_CTRL_TIR_TIS_INDEX_SHIFT);
 
 	ucseg->flags = MLX5_UMR_INLINE;
 	ucseg->bsf_octowords =
 		cpu_to_be16(MLX5E_NVMEOTCP_STATIC_PARAMS_OCTWORD_SIZE);
-	fill_nvmeotcp_static_params(queue, &wqe->params, resync_seq, zerocopy, crc_rx);
+	fill_nvmeotcp_static_params(queue, &wqe->params, resync_seq,
+				    is_rx, zerocopy, crc_rx);
 }
 
 static void
@@ -371,7 +398,8 @@ mlx5e_nvmeotcp_rx_post_static_params_wqe(struct mlx5e_nvmeotcp_queue *queue,
 	pi = mlx5e_icosq_get_next_pi(sq, wqe_bbs);
 	wqe = MLX5E_NVMEOTCP_FETCH_STATIC_PARAMS_WQE(sq, pi);
 	mlx5e_nvmeotcp_fill_wi(NULL, sq, wqe_bbs, pi, 0, BSF_UMR);
-	build_nvmeotcp_static_params(queue, wqe, resync_seq, queue->zerocopy, queue->crc_rx);
+	build_nvmeotcp_static_params(queue, wqe, resync_seq, true, sq->pc,
+				     sq->sqn, queue->zerocopy, queue->crc_rx);
 	sq->pc += wqe_bbs;
 	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
 	spin_unlock(&queue->nvmeotcp_icosq_lock);
@@ -389,7 +417,7 @@ mlx5e_nvmeotcp_rx_post_progress_params_wqe(struct mlx5e_nvmeotcp_queue *queue,
 	pi = mlx5e_icosq_get_next_pi(sq, wqe_bbs);
 	wqe = MLX5E_NVMEOTCP_FETCH_PROGRESS_PARAMS_WQE(sq, pi);
 	mlx5e_nvmeotcp_fill_wi(queue, sq, wqe_bbs, pi, 0, SET_PSV_UMR);
-	build_nvmeotcp_progress_params(queue, wqe, seq);
+	build_nvmeotcp_progress_params(queue, wqe, seq, true, false, sq->pc, sq->sqn);
 	sq->pc += wqe_bbs;
 	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
 }
@@ -1078,6 +1106,60 @@ int mlx5e_nvmeotcp_init(struct mlx5e_priv *priv)
 	return ret;
 }
 
+static
+void mlx5e_nvmeotcp_tx_post_static_params(struct mlx5e_nvmeotcp_queue *queue,
+					  struct mlx5e_txqsq *sq)
+{
+	struct mlx5e_set_nvmeotcp_static_params_wqe *wqe;
+	enum mlx5e_dump_wqe_type type = MLX5E_DUMP_WQE_NVMEOTCP;
+	u16 pi, wqe_bbs;
+
+	wqe_bbs = MLX5E_NVMEOTCP_STATIC_PARAMS_WQEBBS;
+	pi = mlx5e_txqsq_get_next_pi(sq, wqe_bbs);
+	wqe = MLX5E_NVMEOTCP_FETCH_STATIC_PARAMS_WQE(sq, pi);
+	nvme_tx_fill_wi(sq, pi, wqe_bbs, 0, NULL, type);
+	build_nvmeotcp_static_params(queue, wqe, 0, false,
+				     sq->pc, sq->sqn, false, true);
+	sq->pc += wqe_bbs;
+	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
+}
+
+static
+void mlx5e_nvmeotcp_tx_post_progress_params(struct mlx5e_nvmeotcp_queue *queue,
+					    struct mlx5e_txqsq *sq, u32 seq,
+					    bool resync)
+{
+	struct mlx5e_set_nvmeotcp_progress_params_wqe *wqe;
+	enum mlx5e_dump_wqe_type type = MLX5E_DUMP_WQE_NVMEOTCP;
+	u16 pi, wqe_bbs;
+
+	wqe_bbs = MLX5E_NVMEOTCP_PROGRESS_PARAMS_WQEBBS;
+	pi = mlx5e_txqsq_get_next_pi(sq, wqe_bbs);
+	wqe = MLX5E_NVMEOTCP_FETCH_PROGRESS_PARAMS_WQE(sq, pi);
+	nvme_tx_fill_wi(sq, pi, wqe_bbs, 0, NULL, type);
+	build_nvmeotcp_progress_params(queue, wqe, seq, false, resync, sq->pc, sq->sqn);
+	sq->pc += wqe_bbs;
+	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
+}
+
+static
+bool mlx5e_nvmeotcp_test_and_clear_pending(struct mlx5e_nvmeotcp_queue *ctx)
+{
+	bool ret = ctx->pending;
+
+	ctx->pending = false;
+
+	return ret;
+}
+
+static
+void mlx5e_nvmeotcp_tx_post_param_wqes(struct mlx5e_txqsq *sq, struct sock *sk,
+				       struct mlx5e_nvmeotcp_queue *ctx)
+{
+	mlx5e_nvmeotcp_tx_post_static_params(ctx, sq);
+	mlx5e_nvmeotcp_tx_post_progress_params(ctx, sq, tcp_sk(sk)->copied_seq, false);
+}
+
 void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv)
 {
 	struct mlx5e_nvmeotcp *nvmeotcp = priv->nvmeotcp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
index 44671e28a9ea..e7436aa01ad4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
@@ -69,12 +69,12 @@ struct mlx5e_get_psv_wqe {
 void
 build_nvmeotcp_progress_params(struct mlx5e_nvmeotcp_queue *queue,
 			       struct mlx5e_set_nvmeotcp_progress_params_wqe *wqe,
-			       u32 seq);
+			       u32 seq, bool is_rx, bool is_resync, u16 pc, u32 sqn);
 
 void
 build_nvmeotcp_static_params(struct mlx5e_nvmeotcp_queue *queue,
 			     struct mlx5e_set_nvmeotcp_static_params_wqe *wqe,
-			     u32 resync_seq,
+			     u32 resync_seq, bool is_rx, u16 pc, u32 sqn,
 			     bool zerocopy, bool crc_rx);
 
 #endif /* __MLX5E_NVMEOTCP_UTILS_H__ */
-- 
2.24.1

