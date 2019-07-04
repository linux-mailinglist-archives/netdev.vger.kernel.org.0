Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3D75FCC6
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 20:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbfGDSQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 14:16:11 -0400
Received: from mail-eopbgr150077.outbound.protection.outlook.com ([40.107.15.77]:20736
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727229AbfGDSQJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 14:16:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=earehBUX682RzuSJs3Hjan/DQ6/Eul+suTEBbY+4Atg=;
 b=asY3MoAoLkqYDY1Dfrf3+CWKQYr8tQ8VhpA9u+9pmdMF6azlCUIcPf7tl4DoyMNILBkaixV8BzimaYTudFtJ8PhwFTU5gAFLeO03KVVj7GFfXbvTzbMzx4Fg11jb0JUgealoXpyXsquMwvLaKwArR3pdbz0DDf7+04rAH8DRjJI=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2584.eurprd05.prod.outlook.com (10.168.74.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 18:15:59 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 18:15:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/14] net/mlx5e: Move helper functions to a new txrx
 datapath header
Thread-Topic: [net-next 07/14] net/mlx5e: Move helper functions to a new txrx
 datapath header
Thread-Index: AQHVMpSI03yRPDMrNE6lEjOK4lPdWw==
Date:   Thu, 4 Jul 2019 18:15:59 +0000
Message-ID: <20190704181235.8966-8-saeedm@mellanox.com>
References: <20190704181235.8966-1-saeedm@mellanox.com>
In-Reply-To: <20190704181235.8966-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.148.53.10]
x-clientproxiedby: BYAPR06CA0061.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::38) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52f2eeae-8209-4326-75c2-08d700abaa3c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2584;
x-ms-traffictypediagnostic: DB6PR0501MB2584:
x-microsoft-antispam-prvs: <DB6PR0501MB2584D56DF8E7087573F8BAD0BEFA0@DB6PR0501MB2584.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(199004)(189003)(486006)(14454004)(186003)(305945005)(26005)(6916009)(71200400001)(6486002)(7736002)(86362001)(256004)(14444005)(8936002)(81156014)(386003)(76176011)(8676002)(81166006)(6116002)(52116002)(2906002)(6436002)(3846002)(102836004)(71190400001)(2616005)(476003)(446003)(11346002)(6506007)(99286004)(30864003)(73956011)(25786009)(1076003)(107886003)(66946007)(66556008)(66476007)(68736007)(66446008)(64756008)(5660300002)(478600001)(4326008)(50226002)(6512007)(54906003)(66066001)(316002)(36756003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2584;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TmnakEYrQ1+gK34tZyxmf/pJPL7+3mj2/+jhhV9sQwP13conVBSGaBCvbmEDO2LSlIjn3zR7pZq2/uLf7GogORBjUbZAXjxBaArfxuiytUpHedRR1GeddX6l9a1i90ifeizC/XqUCR+9vO6mYk8gRICnvI+q2HWJ8xXcIzJq0dfrhWYuPS0BIt3xSSy9T5yhMYOg6SBzIcGJhQlw/OA9LUVgV/qZ73RtVmtekxSr8LuL9c4tOD8OjNOutU6jVllfEfZnxBXGZRi0wmc6NDqmLDpFiEr1L3MyCd+rnfUEAP2BONNgayC1oKCyLNdNW7ueKrD4MObDHIuHK7qCE/5xOj9c2ln6ozAHDQL1rYQ7RdxA+2EKkKuZLOvVq5CQIIhUTIuEp5AjFaf7zktWqIR4z5QY1Ykb0I10OihMlOMlNDU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52f2eeae-8209-4326-75c2-08d700abaa3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 18:15:59.6755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2584
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Take datapath helper functions to a new header file en/txrx.h.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 102 -----------
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h | 163 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |   1 +
 .../mellanox/mlx5/core/en_accel/en_accel.h    |   1 +
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |   1 +
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h    |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  52 +-----
 8 files changed, 169 insertions(+), 153 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 6b85816c2f21..d618b3a01bee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -487,12 +487,6 @@ struct mlx5e_icosq {
 	struct mlx5e_channel      *channel;
 } ____cacheline_aligned_in_smp;
=20
-static inline bool
-mlx5e_wqc_has_room_for(struct mlx5_wq_cyc *wq, u16 cc, u16 pc, u16 n)
-{
-	return (mlx5_wq_cyc_ctr2ix(wq, cc - pc) >=3D n) || (cc =3D=3D pc);
-}
-
 struct mlx5e_wqe_frag_info {
 	struct mlx5e_dma_info *di;
 	u32 offset;
@@ -899,102 +893,6 @@ static inline bool mlx5_tx_swp_supported(struct mlx5_=
core_dev *mdev)
 		MLX5_CAP_ETH(mdev, swp_csum) && MLX5_CAP_ETH(mdev, swp_lso);
 }
=20
-struct mlx5e_swp_spec {
-	__be16 l3_proto;
-	u8 l4_proto;
-	u8 is_tun;
-	__be16 tun_l3_proto;
-	u8 tun_l4_proto;
-};
-
-static inline void
-mlx5e_set_eseg_swp(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg,
-		   struct mlx5e_swp_spec *swp_spec)
-{
-	/* SWP offsets are in 2-bytes words */
-	eseg->swp_outer_l3_offset =3D skb_network_offset(skb) / 2;
-	if (swp_spec->l3_proto =3D=3D htons(ETH_P_IPV6))
-		eseg->swp_flags |=3D MLX5_ETH_WQE_SWP_OUTER_L3_IPV6;
-	if (swp_spec->l4_proto) {
-		eseg->swp_outer_l4_offset =3D skb_transport_offset(skb) / 2;
-		if (swp_spec->l4_proto =3D=3D IPPROTO_UDP)
-			eseg->swp_flags |=3D MLX5_ETH_WQE_SWP_OUTER_L4_UDP;
-	}
-
-	if (swp_spec->is_tun) {
-		eseg->swp_inner_l3_offset =3D skb_inner_network_offset(skb) / 2;
-		if (swp_spec->tun_l3_proto =3D=3D htons(ETH_P_IPV6))
-			eseg->swp_flags |=3D MLX5_ETH_WQE_SWP_INNER_L3_IPV6;
-	} else { /* typically for ipsec when xfrm mode !=3D XFRM_MODE_TUNNEL */
-		eseg->swp_inner_l3_offset =3D skb_network_offset(skb) / 2;
-		if (swp_spec->l3_proto =3D=3D htons(ETH_P_IPV6))
-			eseg->swp_flags |=3D MLX5_ETH_WQE_SWP_INNER_L3_IPV6;
-	}
-	switch (swp_spec->tun_l4_proto) {
-	case IPPROTO_UDP:
-		eseg->swp_flags |=3D MLX5_ETH_WQE_SWP_INNER_L4_UDP;
-		/* fall through */
-	case IPPROTO_TCP:
-		eseg->swp_inner_l4_offset =3D skb_inner_transport_offset(skb) / 2;
-		break;
-	}
-}
-
-static inline void mlx5e_sq_fetch_wqe(struct mlx5e_txqsq *sq,
-				      struct mlx5e_tx_wqe **wqe,
-				      u16 *pi)
-{
-	struct mlx5_wq_cyc *wq =3D &sq->wq;
-
-	*pi  =3D mlx5_wq_cyc_ctr2ix(wq, sq->pc);
-	*wqe =3D mlx5_wq_cyc_get_wqe(wq, *pi);
-	memset(*wqe, 0, sizeof(**wqe));
-}
-
-static inline
-struct mlx5e_tx_wqe *mlx5e_post_nop(struct mlx5_wq_cyc *wq, u32 sqn, u16 *=
pc)
-{
-	u16                         pi   =3D mlx5_wq_cyc_ctr2ix(wq, *pc);
-	struct mlx5e_tx_wqe        *wqe  =3D mlx5_wq_cyc_get_wqe(wq, pi);
-	struct mlx5_wqe_ctrl_seg   *cseg =3D &wqe->ctrl;
-
-	memset(cseg, 0, sizeof(*cseg));
-
-	cseg->opmod_idx_opcode =3D cpu_to_be32((*pc << 8) | MLX5_OPCODE_NOP);
-	cseg->qpn_ds           =3D cpu_to_be32((sqn << 8) | 0x01);
-
-	(*pc)++;
-
-	return wqe;
-}
-
-static inline
-void mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc,
-		     void __iomem *uar_map,
-		     struct mlx5_wqe_ctrl_seg *ctrl)
-{
-	ctrl->fm_ce_se =3D MLX5_WQE_CTRL_CQ_UPDATE;
-	/* ensure wqe is visible to device before updating doorbell record */
-	dma_wmb();
-
-	*wq->db =3D cpu_to_be32(pc);
-
-	/* ensure doorbell record is visible to device before ringing the
-	 * doorbell
-	 */
-	wmb();
-
-	mlx5_write64((__be32 *)ctrl, uar_map);
-}
-
-static inline void mlx5e_cq_arm(struct mlx5e_cq *cq)
-{
-	struct mlx5_core_cq *mcq;
-
-	mcq =3D &cq->mcq;
-	mlx5_cq_arm(mcq, MLX5_CQ_DB_REQ_NOT, mcq->uar->map, cq->wq.cc);
-}
-
 extern const struct ethtool_ops mlx5e_ethtool_ops;
 #ifdef CONFIG_MLX5_CORE_EN_DCB
 extern const struct dcbnl_rtnl_ops mlx5e_dcbnl_ops;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
new file mode 100644
index 000000000000..7fdf69e08d58
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -0,0 +1,163 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#ifndef __MLX5_EN_TXRX_H___
+#define __MLX5_EN_TXRX_H___
+
+#include "en.h"
+
+#define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline=
_hdr.start))
+
+static inline bool
+mlx5e_wqc_has_room_for(struct mlx5_wq_cyc *wq, u16 cc, u16 pc, u16 n)
+{
+	return (mlx5_wq_cyc_ctr2ix(wq, cc - pc) >=3D n) || (cc =3D=3D pc);
+}
+
+static inline void mlx5e_sq_fetch_wqe(struct mlx5e_txqsq *sq,
+				      struct mlx5e_tx_wqe **wqe,
+				      u16 *pi)
+{
+	struct mlx5_wq_cyc *wq =3D &sq->wq;
+
+	*pi  =3D mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+	*wqe =3D mlx5_wq_cyc_get_wqe(wq, *pi);
+	memset(*wqe, 0, sizeof(**wqe));
+}
+
+static inline struct mlx5e_tx_wqe *
+mlx5e_post_nop(struct mlx5_wq_cyc *wq, u32 sqn, u16 *pc)
+{
+	u16                         pi   =3D mlx5_wq_cyc_ctr2ix(wq, *pc);
+	struct mlx5e_tx_wqe        *wqe  =3D mlx5_wq_cyc_get_wqe(wq, pi);
+	struct mlx5_wqe_ctrl_seg   *cseg =3D &wqe->ctrl;
+
+	memset(cseg, 0, sizeof(*cseg));
+
+	cseg->opmod_idx_opcode =3D cpu_to_be32((*pc << 8) | MLX5_OPCODE_NOP);
+	cseg->qpn_ds           =3D cpu_to_be32((sqn << 8) | 0x01);
+
+	(*pc)++;
+
+	return wqe;
+}
+
+static inline void
+mlx5e_fill_sq_frag_edge(struct mlx5e_txqsq *sq, struct mlx5_wq_cyc *wq,
+			u16 pi, u16 nnops)
+{
+	struct mlx5e_tx_wqe_info *edge_wi, *wi =3D &sq->db.wqe_info[pi];
+
+	edge_wi =3D wi + nnops;
+
+	/* fill sq frag edge with nops to avoid wqe wrapping two pages */
+	for (; wi < edge_wi; wi++) {
+		wi->skb        =3D NULL;
+		wi->num_wqebbs =3D 1;
+		mlx5e_post_nop(wq, sq->sqn, &sq->pc);
+	}
+	sq->stats->nop +=3D nnops;
+}
+
+static inline void
+mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __iomem *uar_map,
+		struct mlx5_wqe_ctrl_seg *ctrl)
+{
+	ctrl->fm_ce_se =3D MLX5_WQE_CTRL_CQ_UPDATE;
+	/* ensure wqe is visible to device before updating doorbell record */
+	dma_wmb();
+
+	*wq->db =3D cpu_to_be32(pc);
+
+	/* ensure doorbell record is visible to device before ringing the
+	 * doorbell
+	 */
+	wmb();
+
+	mlx5_write64((__be32 *)ctrl, uar_map);
+}
+
+static inline void mlx5e_cq_arm(struct mlx5e_cq *cq)
+{
+	struct mlx5_core_cq *mcq;
+
+	mcq =3D &cq->mcq;
+	mlx5_cq_arm(mcq, MLX5_CQ_DB_REQ_NOT, mcq->uar->map, cq->wq.cc);
+}
+
+static inline struct mlx5e_sq_dma *
+mlx5e_dma_get(struct mlx5e_txqsq *sq, u32 i)
+{
+	return &sq->db.dma_fifo[i & sq->dma_fifo_mask];
+}
+
+static inline void
+mlx5e_dma_push(struct mlx5e_txqsq *sq, dma_addr_t addr, u32 size,
+	       enum mlx5e_dma_map_type map_type)
+{
+	struct mlx5e_sq_dma *dma =3D mlx5e_dma_get(sq, sq->dma_fifo_pc++);
+
+	dma->addr =3D addr;
+	dma->size =3D size;
+	dma->type =3D map_type;
+}
+
+static inline void
+mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_sq_dma *dma)
+{
+	switch (dma->type) {
+	case MLX5E_DMA_MAP_SINGLE:
+		dma_unmap_single(pdev, dma->addr, dma->size, DMA_TO_DEVICE);
+		break;
+	case MLX5E_DMA_MAP_PAGE:
+		dma_unmap_page(pdev, dma->addr, dma->size, DMA_TO_DEVICE);
+		break;
+	default:
+		WARN_ONCE(true, "mlx5e_tx_dma_unmap unknown DMA type!\n");
+	}
+}
+
+/* SW parser related functions */
+
+struct mlx5e_swp_spec {
+	__be16 l3_proto;
+	u8 l4_proto;
+	u8 is_tun;
+	__be16 tun_l3_proto;
+	u8 tun_l4_proto;
+};
+
+static inline void
+mlx5e_set_eseg_swp(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg,
+		   struct mlx5e_swp_spec *swp_spec)
+{
+	/* SWP offsets are in 2-bytes words */
+	eseg->swp_outer_l3_offset =3D skb_network_offset(skb) / 2;
+	if (swp_spec->l3_proto =3D=3D htons(ETH_P_IPV6))
+		eseg->swp_flags |=3D MLX5_ETH_WQE_SWP_OUTER_L3_IPV6;
+	if (swp_spec->l4_proto) {
+		eseg->swp_outer_l4_offset =3D skb_transport_offset(skb) / 2;
+		if (swp_spec->l4_proto =3D=3D IPPROTO_UDP)
+			eseg->swp_flags |=3D MLX5_ETH_WQE_SWP_OUTER_L4_UDP;
+	}
+
+	if (swp_spec->is_tun) {
+		eseg->swp_inner_l3_offset =3D skb_inner_network_offset(skb) / 2;
+		if (swp_spec->tun_l3_proto =3D=3D htons(ETH_P_IPV6))
+			eseg->swp_flags |=3D MLX5_ETH_WQE_SWP_INNER_L3_IPV6;
+	} else { /* typically for ipsec when xfrm mode !=3D XFRM_MODE_TUNNEL */
+		eseg->swp_inner_l3_offset =3D skb_network_offset(skb) / 2;
+		if (swp_spec->l3_proto =3D=3D htons(ETH_P_IPV6))
+			eseg->swp_flags |=3D MLX5_ETH_WQE_SWP_INNER_L3_IPV6;
+	}
+	switch (swp_spec->tun_l4_proto) {
+	case IPPROTO_UDP:
+		eseg->swp_flags |=3D MLX5_ETH_WQE_SWP_INNER_L4_UDP;
+		/* fall through */
+	case IPPROTO_TCP:
+		eseg->swp_inner_l4_offset =3D skb_inner_transport_offset(skb) / 2;
+		break;
+	}
+}
+
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.h
index 8b537a4b0840..f56ccedcdd56 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -33,6 +33,7 @@
 #define __MLX5_EN_XDP_H__
=20
 #include "en.h"
+#include "en/txrx.h"
=20
 #define MLX5E_XDP_MIN_INLINE (ETH_HLEN + VLAN_HLEN)
 #define MLX5E_XDP_TX_EMPTY_DS_COUNT \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/=
drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 6da7c88742dc..3022463f2284 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -39,6 +39,7 @@
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/tls_rxtx.h"
 #include "en.h"
+#include "en/txrx.h"
=20
 #if IS_ENABLED(CONFIG_GENEVE)
 static inline bool mlx5_geneve_tx_allowed(struct mlx5_core_dev *mdev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h =
b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index ca47c0540904..db84500b024f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -39,6 +39,7 @@
 #include <linux/skbuff.h>
 #include <net/xfrm.h>
 #include "en.h"
+#include "en/txrx.h"
=20
 struct sk_buff *mlx5e_ipsec_handle_rx_skb(struct net_device *netdev,
 					  struct sk_buff *skb, u32 *cqe_bcnt);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h b/=
drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
index 311667ec71b8..90bc1f2384c8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
@@ -38,6 +38,7 @@
=20
 #include <linux/skbuff.h>
 #include "en.h"
+#include "en/txrx.h"
=20
 struct sk_buff *mlx5e_tls_handle_tx_skb(struct net_device *netdev,
 					struct mlx5e_txqsq *sq,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index afbc1e81f36a..cfeeb734ae8f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -56,6 +56,7 @@
 #include "en/monitor_stats.h"
 #include "en/reporter.h"
 #include "en/params.h"
+#include "en/txrx.h"
=20
 struct mlx5e_rq_param {
 	u32			rqc[MLX5_ST_SZ_DW(rqc)];
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index 9048faa4bfcf..dc77fe9ae367 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -35,6 +35,7 @@
 #include <net/geneve.h>
 #include <net/dsfield.h>
 #include "en.h"
+#include "en/txrx.h"
 #include "ipoib/ipoib.h"
 #include "en_accel/en_accel.h"
 #include "lib/clock.h"
@@ -52,38 +53,6 @@
 			    MLX5E_SQ_NOPS_ROOM)
 #endif
=20
-static inline void mlx5e_tx_dma_unmap(struct device *pdev,
-				      struct mlx5e_sq_dma *dma)
-{
-	switch (dma->type) {
-	case MLX5E_DMA_MAP_SINGLE:
-		dma_unmap_single(pdev, dma->addr, dma->size, DMA_TO_DEVICE);
-		break;
-	case MLX5E_DMA_MAP_PAGE:
-		dma_unmap_page(pdev, dma->addr, dma->size, DMA_TO_DEVICE);
-		break;
-	default:
-		WARN_ONCE(true, "mlx5e_tx_dma_unmap unknown DMA type!\n");
-	}
-}
-
-static inline struct mlx5e_sq_dma *mlx5e_dma_get(struct mlx5e_txqsq *sq, u=
32 i)
-{
-	return &sq->db.dma_fifo[i & sq->dma_fifo_mask];
-}
-
-static inline void mlx5e_dma_push(struct mlx5e_txqsq *sq,
-				  dma_addr_t addr,
-				  u32 size,
-				  enum mlx5e_dma_map_type map_type)
-{
-	struct mlx5e_sq_dma *dma =3D mlx5e_dma_get(sq, sq->dma_fifo_pc++);
-
-	dma->addr =3D addr;
-	dma->size =3D size;
-	dma->type =3D map_type;
-}
-
 static void mlx5e_dma_unmap_wqe_err(struct mlx5e_txqsq *sq, u8 num_dma)
 {
 	int i;
@@ -277,23 +246,6 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct=
 sk_buff *skb,
 	return -ENOMEM;
 }
=20
-static inline void mlx5e_fill_sq_frag_edge(struct mlx5e_txqsq *sq,
-					   struct mlx5_wq_cyc *wq,
-					   u16 pi, u16 nnops)
-{
-	struct mlx5e_tx_wqe_info *edge_wi, *wi =3D &sq->db.wqe_info[pi];
-
-	edge_wi =3D wi + nnops;
-
-	/* fill sq frag edge with nops to avoid wqe wrapping two pages */
-	for (; wi < edge_wi; wi++) {
-		wi->skb        =3D NULL;
-		wi->num_wqebbs =3D 1;
-		mlx5e_post_nop(wq, sq->sqn, &sq->pc);
-	}
-	sq->stats->nop +=3D nnops;
-}
-
 static inline void
 mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		     u8 opcode, u16 ds_cnt, u8 num_wqebbs, u32 num_bytes, u8 num_dma,
@@ -326,8 +278,6 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_=
buff *skb,
 		mlx5e_notify_hw(wq, sq->pc, sq->uar_map, cseg);
 }
=20
-#define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline=
_hdr.start))
-
 netdev_tx_t mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 			  struct mlx5e_tx_wqe *wqe, u16 pi, bool xmit_more)
 {
--=20
2.21.0

