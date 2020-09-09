Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BB126247A
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 03:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbgIIB2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 21:28:39 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19436 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728350AbgIIB2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 21:28:25 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f582fa90003>; Tue, 08 Sep 2020 18:28:09 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 08 Sep 2020 18:28:23 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 08 Sep 2020 18:28:23 -0700
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 9 Sep
 2020 01:28:16 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Tariq Toukan" <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 10/12] net/mlx5e: Rename xmit-related structs to generalize them
Date:   Tue, 8 Sep 2020 18:27:55 -0700
Message-ID: <20200909012757.32677-11-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909012757.32677-1-saeedm@nvidia.com>
References: <20200909012757.32677-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599614889; bh=Pr30K67HrdO5zOhSFBtL5VY3BqG5T3wb8xL7paETGU8=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=LJ/BrKhvUjpiv2LA8dl6xo/XaWI2WktYhWMyCQYccHEIUd0a3g0QYZqH/5khzYgNJ
         OrDGAXsb1Y6AjpcZzbU4Fz61qCQn66O9kNdb0BaVxdhplJBwQZFOs0d2trYf/z+Buu
         i2XLAAIEPUc8HHguEAk8XfAIDpamUbi5JF9NNjL87CEEy54YJf/U9Sb8RL2B7gAmEk
         xSX+cdqgT6tgsKVmWHrdOdULoKdr1oULP8QJ6EhFmfJWYfYEMKmnXVoos1S6/1HuRA
         Q1jnFotGDBenOKryDU0Q4QcwkKo8hXzo+lPFOcJB9I8uy5NEzyaKS0VPtiDrmLkvPQ
         t3HmijS5e9rsA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

As preparation for the upcoming TX MPWQE support for SKBs, rename struct
mlx5e_xdp_mpwqe to mlx5e_tx_mpwqe and move it above struct mlx5e_txqsq.
This structure will be reused in the regular SQ and in the regular TX
data path. Also rename mlx5e_xdp_xmit_data to mlx5e_xmit_data - it will
be used in the upcoming TX MPWQE flow.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 22 +++++++++----------
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 16 +++++++-------
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  | 10 ++++-----
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  2 +-
 5 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 6ab60074fca9..3511836f0f4a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -312,6 +312,14 @@ enum {
 	MLX5E_SQ_STATE_PENDING_XSK_TX,
 };
=20
+struct mlx5e_tx_mpwqe {
+	/* Current MPWQE session */
+	struct mlx5e_tx_wqe *wqe;
+	u8 ds_count;
+	u8 pkt_count;
+	u8 inline_on;
+};
+
 struct mlx5e_txqsq {
 	/* data path */
=20
@@ -402,7 +410,7 @@ struct mlx5e_xdp_info {
 	};
 };
=20
-struct mlx5e_xdp_xmit_data {
+struct mlx5e_xmit_data {
 	dma_addr_t  dma_addr;
 	void       *data;
 	u32         len;
@@ -415,18 +423,10 @@ struct mlx5e_xdp_info_fifo {
 	u32 mask;
 };
=20
-struct mlx5e_xdp_mpwqe {
-	/* Current MPWQE session */
-	struct mlx5e_tx_wqe *wqe;
-	u8                   ds_count;
-	u8                   pkt_count;
-	u8                   inline_on;
-};
-
 struct mlx5e_xdpsq;
 typedef int (*mlx5e_fp_xmit_xdp_frame_check)(struct mlx5e_xdpsq *);
 typedef bool (*mlx5e_fp_xmit_xdp_frame)(struct mlx5e_xdpsq *,
-					struct mlx5e_xdp_xmit_data *,
+					struct mlx5e_xmit_data *,
 					struct mlx5e_xdp_info *,
 					int);
=20
@@ -441,7 +441,7 @@ struct mlx5e_xdpsq {
 	u32                        xdpi_fifo_pc ____cacheline_aligned_in_smp;
 	u16                        pc;
 	struct mlx5_wqe_ctrl_seg   *doorbell_cseg;
-	struct mlx5e_xdp_mpwqe     mpwqe;
+	struct mlx5e_tx_mpwqe      mpwqe;
=20
 	struct mlx5e_cq            cq;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index b4ee1f2f1746..06dbfd6cd82a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -279,7 +279,7 @@ mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_sq=
_dma *dma)
=20
 void mlx5e_sq_xmit_simple(struct mlx5e_txqsq *sq, struct sk_buff *skb, boo=
l xmit_more);
=20
-static inline bool mlx5e_tx_mpwqe_is_full(struct mlx5e_xdp_mpwqe *session)
+static inline bool mlx5e_tx_mpwqe_is_full(struct mlx5e_tx_mpwqe *session)
 {
 	return session->ds_count =3D=3D MLX5E_TX_MPW_MAX_NUM_DS;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.c
index 2a72496ceda9..f0a102763de6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -59,7 +59,7 @@ static inline bool
 mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 		    struct mlx5e_dma_info *di, struct xdp_buff *xdp)
 {
-	struct mlx5e_xdp_xmit_data xdptxd;
+	struct mlx5e_xmit_data xdptxd;
 	struct mlx5e_xdp_info xdpi;
 	struct xdp_frame *xdpf;
 	dma_addr_t dma_addr;
@@ -194,7 +194,7 @@ static u16 mlx5e_xdpsq_get_next_pi(struct mlx5e_xdpsq *=
sq, u16 size)
=20
 static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_xdpsq *sq)
 {
-	struct mlx5e_xdp_mpwqe *session =3D &sq->mpwqe;
+	struct mlx5e_tx_mpwqe *session =3D &sq->mpwqe;
 	struct mlx5e_xdpsq_stats *stats =3D sq->stats;
 	struct mlx5e_tx_wqe *wqe;
 	u16 pi;
@@ -203,7 +203,7 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_=
xdpsq *sq)
 	wqe =3D MLX5E_TX_FETCH_WQE(sq, pi);
 	net_prefetchw(wqe->data);
=20
-	*session =3D (struct mlx5e_xdp_mpwqe) {
+	*session =3D (struct mlx5e_tx_mpwqe) {
 		.wqe =3D wqe,
 		.ds_count =3D MLX5E_TX_WQE_EMPTY_DS_COUNT,
 		.pkt_count =3D 0,
@@ -216,7 +216,7 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_=
xdpsq *sq)
 void mlx5e_xdp_mpwqe_complete(struct mlx5e_xdpsq *sq)
 {
 	struct mlx5_wq_cyc       *wq    =3D &sq->wq;
-	struct mlx5e_xdp_mpwqe *session =3D &sq->mpwqe;
+	struct mlx5e_tx_mpwqe *session =3D &sq->mpwqe;
 	struct mlx5_wqe_ctrl_seg *cseg =3D &session->wqe->ctrl;
 	u16 ds_count =3D session->ds_count;
 	u16 pi =3D mlx5_wq_cyc_ctr2ix(wq, sq->pc);
@@ -261,10 +261,10 @@ INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_chec=
k_mpwqe(struct mlx5e_xdpsq
 }
=20
 INDIRECT_CALLABLE_SCOPE bool
-mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xdp_xmit_d=
ata *xdptxd,
+mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data =
*xdptxd,
 			   struct mlx5e_xdp_info *xdpi, int check_result)
 {
-	struct mlx5e_xdp_mpwqe *session =3D &sq->mpwqe;
+	struct mlx5e_tx_mpwqe *session =3D &sq->mpwqe;
 	struct mlx5e_xdpsq_stats *stats =3D sq->stats;
=20
 	if (unlikely(xdptxd->len > sq->hw_mtu)) {
@@ -308,7 +308,7 @@ INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check(=
struct mlx5e_xdpsq *sq)
 }
=20
 INDIRECT_CALLABLE_SCOPE bool
-mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xdp_xmit_data *x=
dptxd,
+mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptx=
d,
 		     struct mlx5e_xdp_info *xdpi, int check_result)
 {
 	struct mlx5_wq_cyc       *wq   =3D &sq->wq;
@@ -505,7 +505,7 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struc=
t xdp_frame **frames,
=20
 	for (i =3D 0; i < n; i++) {
 		struct xdp_frame *xdpf =3D frames[i];
-		struct mlx5e_xdp_xmit_data xdptxd;
+		struct mlx5e_xmit_data xdptxd;
 		struct mlx5e_xdp_info xdpi;
 		bool ret;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.h
index 0dc38acab5a8..4bd8af478a4a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -58,11 +58,11 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struc=
t xdp_frame **frames,
 		   u32 flags);
=20
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdp=
sq *sq,
-							  struct mlx5e_xdp_xmit_data *xdptxd,
+							  struct mlx5e_xmit_data *xdptxd,
 							  struct mlx5e_xdp_info *xdpi,
 							  int check_result));
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq=
,
-						    struct mlx5e_xdp_xmit_data *xdptxd,
+						    struct mlx5e_xmit_data *xdptxd,
 						    struct mlx5e_xdp_info *xdpi,
 						    int check_result));
 INDIRECT_CALLABLE_DECLARE(int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5=
e_xdpsq *sq));
@@ -123,7 +123,7 @@ static inline bool mlx5e_xdp_get_inline_state(struct ml=
x5e_xdpsq *sq, bool cur)
 	return cur;
 }
=20
-static inline bool mlx5e_xdp_mpqwe_is_full(struct mlx5e_xdp_mpwqe *session=
)
+static inline bool mlx5e_xdp_mpqwe_is_full(struct mlx5e_tx_mpwqe *session)
 {
 	if (session->inline_on)
 		return session->ds_count + MLX5E_XDP_INLINE_WQE_MAX_DS_CNT >
@@ -138,10 +138,10 @@ struct mlx5e_xdp_wqe_info {
=20
 static inline void
 mlx5e_xdp_mpwqe_add_dseg(struct mlx5e_xdpsq *sq,
-			 struct mlx5e_xdp_xmit_data *xdptxd,
+			 struct mlx5e_xmit_data *xdptxd,
 			 struct mlx5e_xdpsq_stats *stats)
 {
-	struct mlx5e_xdp_mpwqe *session =3D &sq->mpwqe;
+	struct mlx5e_tx_mpwqe *session =3D &sq->mpwqe;
 	struct mlx5_wqe_data_seg *dseg =3D
 		(struct mlx5_wqe_data_seg *)session->wqe + session->ds_count;
 	u32 dma_len =3D xdptxd->len;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index aa91cbdfe969..fb671a457129 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -67,8 +67,8 @@ static void mlx5e_xsk_tx_post_err(struct mlx5e_xdpsq *sq,
 bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 {
 	struct xsk_buff_pool *pool =3D sq->xsk_pool;
+	struct mlx5e_xmit_data xdptxd;
 	struct mlx5e_xdp_info xdpi;
-	struct mlx5e_xdp_xmit_data xdptxd;
 	bool work_done =3D true;
 	bool flush =3D false;
=20
--=20
2.26.2

