Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B43020AC0C
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 08:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgFZGAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 02:00:23 -0400
Received: from mail-db8eur05on2067.outbound.protection.outlook.com ([40.107.20.67]:6064
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725801AbgFZGAW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 02:00:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=be2+XuDutyAqI2Vj5iQZ6RpTC4a6ikDmPvN0tlosurnR7VUORvDuHmaq02G2ZDAlHPgEusP7Tt3dvRKO9iAqx5qzKYDd2HiRHbhGFgMUSypipqk08WeoV7HGyOX+vmdRrKiYrx6BcSUf5oWWyDv96307hZIfgN7wH9Bi7ukSZyypCndzvwra/Yzu1GxpfvwI8MLl1iOotlb9d2+EEZVhmyjFmx/a4dS9qkyx8eY6g6DrOzNrkUneNV/s7Ui6gECnyK5LZ6pvC4dZYD6e0f5dU/4Td4I32tsOIf1AmpXhRj3wtOrH9Dr0ULzleKPS2gGktbrM+Tv25sOEbv5V+qjB1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0RaNN5JAWbvHb30cD2GU1sepgqIQz2DW61sOJ+JbeVc=;
 b=d61ZR9VUJBtQDbHHhPYCPCv/VkMDPXxXMyx5K97WWDZkV/l5R2bXwGSyQRYLQFLQC/pBZTNR0KWa66eLE3rmQpFRJtAZQxRgOptWKIkFadOqel1MvKAeBu0ZD7iZZaykMVTwGBi6scVQJ5ri21CKHiJmr2qMsFyPJj8H2LBkW2Tl1/Ww2bqXaYhNBF3sdkwGl7N0jgMiluiklXR0GmcNgXmDYVh9cB08pfiFw4JfvTpDKgnvoi2fP0fTT1Vzs5EQYCVFOsXpZwqEhJlzrm8TCkEBljOo9HPpY4JSjPCh871+fy8ytiOJYxAF8Qvww+G33tjQwCV4OKmwcuZH0ERlVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0RaNN5JAWbvHb30cD2GU1sepgqIQz2DW61sOJ+JbeVc=;
 b=Yt5OeDngM1l1FvtKIoOLu0USBYdLET0CEZbRM9LpVqw1wXE5ckHHt8LzK38rjD9XDDGSUUxL3UNxFjP3dR3u79mqugU2AxHq+9Fr60Qma4PwG+on65b6VvvioOgq0NBYJ5hgiMEUU6qnxAc+OZ7QlyTAfmoCxZ3MXELe99LLjT0=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2445.eurprd05.prod.outlook.com (2603:10a6:800:6a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Fri, 26 Jun
 2020 06:00:14 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Fri, 26 Jun 2020
 06:00:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH mlx5-next 3/3] net/mlx5: kTLS, Improve TLS params layout structures
Date:   Thu, 25 Jun 2020 22:59:43 -0700
Message-Id: <20200626055943.99943-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200626055943.99943-1-saeedm@mellanox.com>
References: <20200626055943.99943-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::35) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0025.namprd04.prod.outlook.com (2603:10b6:a03:1d0::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Fri, 26 Jun 2020 06:00:12 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 173d08de-1d1d-4608-87bf-08d8199631ba
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2445:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2445ACF4065F1CE4436F3857BE930@VI1PR0501MB2445.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5sEDA58VQU6kyZYIGVOVsLEv9doqnSvJEaokpYmTZAKf2ssQA8eCHNrGDoXdsYaj5LFsTZYTtSvi3t2tTbpaKO3wnaTDH5E28lrL7xCTC3F7BnvOrmAkEsNxnRLHZP6sAslBP90EEFCVJcHVw5ZXyaJPTE1IyEdEWr1qa+2xV7/n5p8M7pbABE/pvx+ZzIPY2tCqBdG01L0LsirN95rRjxKI3j6djX0RkilY0fMEspLwjgpC4wkkRmrvf2ZwKvhEwGxb0Gp4UryjX4BcA/+yvcNmZhcX1u1FXi3av2R9m9JjccNPXdsrdEEFtISHUw4AM3SWjvWx2WjC8lKrpmNHJNL/Qdq2jGDipYW11nkOYU2eOLnhx6jlQ6tyKm46wEg3kC9o2AcaBA627Poimg1izSFqc4fwVDUbIPCT6DAUnQc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(4326008)(8676002)(8936002)(52116002)(6486002)(186003)(1076003)(36756003)(107886003)(26005)(2906002)(83380400001)(66556008)(86362001)(6666004)(6512007)(110136005)(66476007)(5660300002)(16526019)(316002)(6506007)(6636002)(450100002)(66946007)(2616005)(478600001)(956004)(54420400002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Ado1iwaMeQFNBdHRPMv21lL2LG2yEtu5acYVcab0KhBOBZG4Pb7veMDgF4QCK3J+xvFW98H5fct4bf8sMKe1GmQE+otA++2vpYx4fj8a8MV6VQ+hVgYA832F8/W81J0+PCzfxEVnjRdckNw4eiLYnwoEsJfKQB8jgpkBXGqvdM9c/R1JnCAFN8DmaoYZdutml+Fg8WULD1UJt++aRccQdsnwyXWsEVDJTHIHyIHqlM9/4jn7sxgDAccau6r+pM9imu8htHFCp1CzcVwfb15uP6kV5UxzKdwar8e/46hQQSp4Y8qbyYoMsFvFcGGsHwcVEm2SFfv9vSkvCESGUzC9rzGAwM8W5ENUcT9tlPqtn2w6O34qRMBAa2JVWUDY4RH/lP92/S9x1amO4rDgJUIELc/ZHfP8F8Ot52bgaEUof+NOJMSy0X4Ns59FDIWJ8LYKgCiZQKwsf5UFOsbKSOVv51Ax+hQs7a/RaO6HrnZZuLE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 173d08de-1d1d-4608-87bf-08d8199631ba
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 06:00:14.4810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YD55sPBqKO/kRz3Ncc0Q5XTLnjrJd5g0hWm7wo4sQOJes8LdMDn0SeAGsCYybJW2zo6CxVHpCzvsTtVOUWr9jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2445
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Add explicit WQE segment structures for the TLS static and progress
params.
According to the HW spec, TISN is not part of the progress params context,
take it out of it.
Rename the control segment tisn field as it could hold either a TIS or
a TIR number.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |  2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 14 +++++++++-----
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |  2 +-
 include/linux/mlx5/device.h                        |  9 +++++++++
 include/linux/mlx5/mlx5_ifc.h                      |  5 +----
 include/linux/mlx5/qp.h                            |  2 +-
 7 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index bfd3e1161bc6..31cac239563d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -182,7 +182,7 @@ mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __iomem *uar_map,
 
 static inline bool mlx5e_transport_inline_tx_wqe(struct mlx5_wqe_ctrl_seg *cseg)
 {
-	return cseg && !!cseg->tisn;
+	return cseg && !!cseg->tis_tir_num;
 }
 
 static inline u8
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index c6180892cfcb..806ed185dd4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -19,7 +19,7 @@
 
 #define MLX5E_KTLS_PROGRESS_WQE_SZ \
 	(offsetof(struct mlx5e_tx_wqe, tls_progress_params_ctx) + \
-	 MLX5_ST_SZ_BYTES(tls_progress_params))
+	 sizeof(struct mlx5_wqe_tls_progress_params_seg))
 #define MLX5E_KTLS_PROGRESS_WQEBBS \
 	(DIV_ROUND_UP(MLX5E_KTLS_PROGRESS_WQE_SZ, MLX5_SEND_WQE_BB))
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 3cd78d9503c1..ad7300f19815 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -64,7 +64,7 @@ build_static_params(struct mlx5e_umr_wqe *wqe, u16 pc, u32 sqn,
 	cseg->qpn_ds           = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
 					     STATIC_PARAMS_DS_CNT);
 	cseg->fm_ce_se         = fence ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
-	cseg->tisn             = cpu_to_be32(priv_tx->tisn << 8);
+	cseg->tis_tir_num      = cpu_to_be32(priv_tx->tisn << 8);
 
 	ucseg->flags = MLX5_UMR_INLINE;
 	ucseg->bsf_octowords = cpu_to_be16(MLX5_ST_SZ_BYTES(tls_static_params) / 16);
@@ -75,10 +75,14 @@ build_static_params(struct mlx5e_umr_wqe *wqe, u16 pc, u32 sqn,
 static void
 fill_progress_params_ctx(void *ctx, struct mlx5e_ktls_offload_context_tx *priv_tx)
 {
-	MLX5_SET(tls_progress_params, ctx, tisn, priv_tx->tisn);
-	MLX5_SET(tls_progress_params, ctx, record_tracker_state,
+	struct mlx5_wqe_tls_progress_params_seg *params;
+
+	params = ctx;
+
+	params->tis_tir_num = cpu_to_be32(priv_tx->tisn);
+	MLX5_SET(tls_progress_params, params->ctx, record_tracker_state,
 		 MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_START);
-	MLX5_SET(tls_progress_params, ctx, auth_state,
+	MLX5_SET(tls_progress_params, params->ctx, auth_state,
 		 MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_NO_OFFLOAD);
 }
 
@@ -284,7 +288,7 @@ tx_post_resync_dump(struct mlx5e_txqsq *sq, skb_frag_t *frag, u32 tisn, bool fir
 
 	cseg->opmod_idx_opcode = cpu_to_be32((sq->pc << 8)  | MLX5_OPCODE_DUMP);
 	cseg->qpn_ds           = cpu_to_be32((sq->sqn << 8) | ds_cnt);
-	cseg->tisn             = cpu_to_be32(tisn << 8);
+	cseg->tis_tir_num      = cpu_to_be32(tisn << 8);
 	cseg->fm_ce_se         = first ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
 
 	fsz = skb_frag_size(frag);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index 05454a843b28..72d26fbc8d5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -305,7 +305,7 @@ bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 void mlx5e_tls_handle_tx_wqe(struct mlx5e_txqsq *sq, struct mlx5_wqe_ctrl_seg *cseg,
 			     struct mlx5e_accel_tx_tls_state *state)
 {
-	cseg->tisn = cpu_to_be32(state->tls_tisn << 8);
+	cseg->tis_tir_num = cpu_to_be32(state->tls_tisn << 8);
 }
 
 static int tls_update_resync_sn(struct net_device *netdev,
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 1bc27aca648b..57db125e5802 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -458,6 +458,15 @@ enum {
 	MLX5_OPC_MOD_TLS_TIR_PROGRESS_PARAMS = 0x2,
 };
 
+struct mlx5_wqe_tls_static_params_seg {
+	u8     ctx[MLX5_ST_SZ_BYTES(tls_static_params)];
+};
+
+struct mlx5_wqe_tls_progress_params_seg {
+	__be32 tis_tir_num;
+	u8     ctx[MLX5_ST_SZ_BYTES(tls_progress_params)];
+};
+
 enum {
 	MLX5_SET_PORT_RESET_QKEY	= 0,
 	MLX5_SET_PORT_GUID0		= 16,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 116bd9bb347f..a227518c70cf 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -10638,16 +10638,13 @@ struct mlx5_ifc_tls_static_params_bits {
 };
 
 struct mlx5_ifc_tls_progress_params_bits {
-	u8         reserved_at_0[0x8];
-	u8         tisn[0x18];
-
 	u8         next_record_tcp_sn[0x20];
 
 	u8         hw_resync_tcp_sn[0x20];
 
 	u8         record_tracker_state[0x2];
 	u8         auth_state[0x2];
-	u8         reserved_at_64[0x4];
+	u8         reserved_at_44[0x4];
 	u8         hw_offset_record_number[0x18];
 };
 
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index b8992b861ae6..36492a1342cf 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -209,7 +209,7 @@ struct mlx5_wqe_ctrl_seg {
 		__be32		general_id;
 		__be32		imm;
 		__be32		umr_mkey;
-		__be32		tisn;
+		__be32		tis_tir_num;
 	};
 };
 
-- 
2.26.2

