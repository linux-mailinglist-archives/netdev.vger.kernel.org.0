Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7AE1E881F
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgE2TrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:47:12 -0400
Received: from mail-eopbgr20072.outbound.protection.outlook.com ([40.107.2.72]:57981
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726866AbgE2TrL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 15:47:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c6V5CRaxZRF4vj2eaQAx14ZuUBd6wMuwIludPu+arWtS17SWz36e2/ZDBg3Wgt4x4s4hCxwNHTMfoeW669N1W6GacxxYMRWiH8b4YQf7jGsQuaOZxF+QmioqT5HDHh2I3D3vAN6tGYkiEm3H6ob7yUaTeI9vjmBqxmL/iDW7euge8hVyqfegnpAMdORTCgTwuX5Ne/1nqDvk9TnT7/WbuTq92c3DDvMzZPfjnI1ePpsNfsqGtVsuct8tBUM1o8fXvp2+jU7t6DHlBgzRT5VGDWs+mAzdpPsaXwlFpIDv6r8ad1JzOstudy7cliXaV1kHjdNDLnxeMO1FMl5o+5Pcow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=No9Yhw+lK12bPOEUD7YvCVVjc0aqC3RZEyP0a1wpIR4=;
 b=IRItCgEJJ8jnULAdua1M2BtyVFc+5xwKQlEfRfwmuhDuH6Y/tg7XABwtLlKBYihgSuzCme0SWG9SmjPH2bUBOTuL09e7iNvNQPZ8gDgalEbygqztW8wApNgXewtd2VEqM5jV0oNPPICtgJu/KdBnRUNOoQDzDSFApU9iZFpnWMCeEWClNSLHcOc9SMX3PFtSmPvgBagc1Py1+1edZ6H6emxddGc0zwSUbvCXA+Uvb9xo9jWZVBOhdSyN980XwfKbDU8EQHEk7iASRkxp98eOuqRUnRhtkNNJBCsBgvAKevfCbAjw6Xhu9RelzneX8Eugcq7FVB6FohMhOTL/svzvGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=No9Yhw+lK12bPOEUD7YvCVVjc0aqC3RZEyP0a1wpIR4=;
 b=hHzyZ+f4jY1Ny8cV7oQc9h0njbdHaURd5mEVhw92SgBQf+fdoPLUGh6qs3Q7KqFiZsAQbWdFoczAmzUAnsUBbtJ15S+ku0rFJde5UohV7MucnSyKW5Y988rjAVKrAQEqf7f+UM6Sj1NvAyZ9J1HqJQ6Vq/eu540gt7KAKVKUoTQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6589.eurprd05.prod.outlook.com (2603:10a6:803:f7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 19:47:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 19:47:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/11] net/mlx5: kTLS, Improve TLS params layout structures
Date:   Fri, 29 May 2020 12:46:31 -0700
Message-Id: <20200529194641.243989-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529194641.243989-1-saeedm@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0010.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::23) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0010.namprd16.prod.outlook.com (2603:10b6:a03:1a0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 19:47:02 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 28de66e8-0829-4892-dd7c-08d804090f93
X-MS-TrafficTypeDiagnostic: VI1PR05MB6589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB65895C1627B3DBFB2ABCA1FCBE8F0@VI1PR05MB6589.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FaFV9q6HHfry0oP8Z3Nzq1lcZILyQ/bjlLvJ8vRTio+RtG6VKcqLYvlL4oLDJfSOCS9Io1UcXdX8BGM/z5O+oJXksQPvxZ2KJvEDpw/z4chc/5P+G7HsAFw0aDmVVgMI9+QAVVsuH4nHq4z8tLi9YlwblDP6baxFPGZDm29eVgTgf5VD9j2ZewiBuD2K0j24jkKgirWgq7pa1NpQIEq/EcPW4WewxSgsHVWfQOfHcmOPpOL29T0aU4BajHu2vwtvLvlHKMC51sV99uCKqAp/DTbPp+YLmgdCLTP6gjJmHRy76/Txhwlv5dM6OjyFyWC9Mu7cqCluahfUf7i+LiPwZDK0qSn0B9CvFKApxPxDObf0AbLZDtsICKxjLDB9g/Syz/I6jrnBYSZbbSDl8i/fzmA/8pwHG5gFIfRAY9MJgXo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(6512007)(83380400001)(36756003)(186003)(4326008)(86362001)(8936002)(26005)(107886003)(16526019)(6506007)(316002)(52116002)(8676002)(2616005)(956004)(54906003)(6666004)(478600001)(66556008)(5660300002)(2906002)(6486002)(1076003)(66476007)(66946007)(54420400002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Ci31iOqyriw17ax+ryciqIUIS3J471QaG57vP0gxyUjqdZWR/tbR0BIrD+h7GcK/GvX8xn/DUjLD2vW18I3Ygf5wKB+cAPPHjU9liYd24azqaV15rBv/5Roc5EOQDxSATQu1wX1IZtDGpyJZu9Ncei8LB3xKftIOnnxh6qMIuHh4XLwyfs2CiweizulNhsH8YHgClvWdElwxiFT8ayuloIO5wl5FWeQqaGDFnN+O/hFY8oBvsZlBgMgLp3ss/WY1DWUnSEf8DODNNWefRqU1ce1eJWzIep9KOEuy42A61P7gzi+XrsevY+fphlrkZ+i4QxL0vKD4G9+WO60eN3UpDcS+om0PW6rC3s04nkL8mMx7pt9CqDPmqmEP5Tgpy/c551kiROIIR7vj/IAi5s0Y7nWLw1SWrULnBwrbj8bpPBFSyVYQtv/0z1Tln+f3+XQ1Hg32F+5taJhSvEmAwxcjdb8cLl6+TsAipTFpW6wgbEU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28de66e8-0829-4892-dd7c-08d804090f93
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 19:47:03.9378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y+YB70pP6FX9k8U1uZOp/mmULwrBYB7Uxq2uJjjudZ8u84pgiTz4vb+XOn6u2nfw64ZF/swIt1oSBD8a6Vb+1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6589
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Add explicit WQE segment structures for the TLS static and progress
params.
According to the HW spec, TISN is not part of the progress params context,
take it out of it.
Rename the control segment tisn field as it could hold either a TIS
or a TIR number.

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
index bfd3e1161bc66..31cac239563de 100644
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
index c6180892cfcba..806ed185dd4cf 100644
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
index 3cd78d9503c12..ad7300f198157 100644
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
index 05454a843b289..72d26fbc8d5bf 100644
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
index 1bc27aca648bb..57db125e58021 100644
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
index fb243848132d5..e9c3c09f974f3 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -10631,16 +10631,13 @@ struct mlx5_ifc_tls_static_params_bits {
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
index f23eb18526fe7..a635b38e48559 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -208,7 +208,7 @@ struct mlx5_wqe_ctrl_seg {
 		__be32		general_id;
 		__be32		imm;
 		__be32		umr_mkey;
-		__be32		tisn;
+		__be32		tis_tir_num;
 	};
 };
 
-- 
2.26.2

