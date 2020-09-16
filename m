Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5555E26BD47
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgIPGgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:36:10 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:41577 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726311AbgIPGgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:36:01 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 4FBCD779;
        Wed, 16 Sep 2020 02:36:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 16 Sep 2020 02:36:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=aTjjbmWpCK+e2ENBHY9LNA99265cLUhUE7LGNtZ5CeQ=; b=LDDNNRXk
        yEA6HAQdg2DRqSZOdvpWmdysCIw6Y7AcW5ASZddby+KHa15iDZnyjbxHgcwNCWxF
        MKWUBtJQqDSMj8iAK4G7COxrE0tnGpmoSHLS9YN36JBNx2+mcCODcvIwxDWV0n4U
        9312/m3B0BSLZQRbkEn3+4I5gMHpk06u1OgDsdrd4tcKUkjh9X96iAMEgM9A0Hqw
        71IaAvRgu3889tTNA2JnmAmUHCpKvaHoiXvonmGJtSi0SyL/8JZ64CBxUWecqnyl
        1m+WIQTjuHfTlkLa7gu6XZzx4gyMvXhfaCJ4mG9sJVg0YZ4cRDvBu+m+EKe+FOV1
        8N2jAnDdTTZ9mg==
X-ME-Sender: <xms:T7JhXzhZMV2JD2MlbeUNFMD_m0TU0TMPluUB9KvqsfyBpKeyRzUIuw>
    <xme:T7JhXwBpwRvaxvqLN4QLT04-cOjvlCnxF9U8SutdsQELeNc44YVBko-33fSq1xqqO
    x9Nab9E410uc3U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:T7JhXzENEFkrtrKo4rK9J8tn5sosOH7eCEsDJbrsS_NSn6GfcQHsIg>
    <xmx:T7JhXwQQv0PF0rPvNwXx26ffbL2Fq53KKwSuzUV0vmQ8QL_mY9EsQQ>
    <xmx:T7JhXwwusfgK7eTjHTxPxugIudxjveVTH2s4oUqysQ8ykQVuOo-r0Q>
    <xmx:T7JhX8-kuWOqyQtlS8rHOcNwT8GH4IFvMcGfHAiyhy1J5RYdeCRogQ>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 892D83064682;
        Wed, 16 Sep 2020 02:35:58 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/15] mlxsw: spectrum: Track lossiness in struct mlxsw_sp_hdroom
Date:   Wed, 16 Sep 2020 09:35:18 +0300
Message-Id: <20200916063528.116624-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916063528.116624-1-idosch@idosch.org>
References: <20200916063528.116624-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Client-side configuration has lossiness as an attribute of a priority.
Therefore add a "lossy" attribute to struct mlxsw_sp_hdroom_prio.

To a Spectrum ASIC, lossiness is a feature of a port buffer. Therefore add
struct mlxsw_sp_hdroom_buf, which in the following patches will get more
attributes, but right now only use it to track port buffer lossiness.

Instead of passing around the primary indicators of PFC and pause_en, add a
function mlxsw_sp_hdroom_bufs_reset_lossiness() to compute the buffer
lossiness from the priority map and priority lossiness. Change
mlxsw_sp_port_headroom_set() to take the buffer lossy flag from the
headroom configuration. Have the PFC and pause handlers configure priority
lossiness in mlxsw_sp_hdroom, from where it will propagate.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 54 +++++++------------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    | 19 ++++---
 .../mellanox/mlxsw/spectrum_buffers.c         | 14 +++++
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    | 15 ++++--
 .../mellanox/mlxsw/spectrum_ethtool.c         | 11 ++--
 5 files changed, 64 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index dee663229990..f891ddf19dbc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -644,16 +644,25 @@ static u16 mlxsw_sp_hdroom_buf_delay_get(const struct mlxsw_sp *mlxsw_sp,
 	return 2 * delay_cells + mlxsw_sp_bytes_cells(mlxsw_sp, hdroom->mtu);
 }
 
-int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
-				 struct mlxsw_sp_hdroom *hdroom,
-				 bool pause_en, struct ieee_pfc *my_pfc)
+static bool mlxsw_sp_hdroom_buf_is_used(const struct mlxsw_sp_hdroom *hdroom, int buf)
+{
+	int prio;
+
+	for (prio = 0; prio < IEEE_8021QAZ_MAX_TCS; prio++) {
+		if (hdroom->prios.prio[prio].buf_idx == buf)
+			return true;
+	}
+	return false;
+}
+
+int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
+			       struct mlxsw_sp_hdroom *hdroom)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	u8 pfc_en = !!my_pfc ? my_pfc->pfc_en : 0;
 	char pbmc_pl[MLXSW_REG_PBMC_LEN];
 	u32 taken_headroom_cells = 0;
 	u32 max_headroom_cells;
-	int i, j, err;
+	int i, err;
 
 	max_headroom_cells = mlxsw_sp_sb_max_headroom_cells(mlxsw_sp);
 
@@ -663,25 +672,14 @@ int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
 		return err;
 
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
-		bool configure = false;
-		bool pfc = false;
+		struct mlxsw_sp_hdroom_buf *buf = &hdroom->bufs.buf[i];
 		u16 thres_cells;
 		u16 delay_cells;
 		u16 total_cells;
-		bool lossy;
-
-		for (j = 0; j < IEEE_8021QAZ_MAX_TCS; j++) {
-			if (hdroom->prios.prio[j].buf_idx == i) {
-				pfc = pfc_en & BIT(j);
-				configure = true;
-				break;
-			}
-		}
 
-		if (!configure)
+		if (!mlxsw_sp_hdroom_buf_is_used(hdroom, i))
 			continue;
 
-		lossy = !(pfc || pause_en);
 		thres_cells = mlxsw_sp_pg_buf_threshold_get(mlxsw_sp, hdroom->mtu);
 		thres_cells = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, thres_cells);
 		delay_cells = mlxsw_sp_hdroom_buf_delay_get(mlxsw_sp, hdroom);
@@ -692,8 +690,7 @@ int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
 		if (taken_headroom_cells > max_headroom_cells)
 			return -ENOBUFS;
 
-		mlxsw_sp_pg_buf_pack(pbmc_pl, i, total_cells,
-				     thres_cells, lossy);
+		mlxsw_sp_pg_buf_pack(pbmc_pl, i, total_cells, thres_cells, buf->lossy);
 	}
 
 	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pbmc), pbmc_pl);
@@ -704,22 +701,9 @@ int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return 0;
 }
 
-int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
-			       struct mlxsw_sp_hdroom *hdroom,
-			       bool pause_en)
-{
-	bool dcb_en = !!mlxsw_sp_port->dcb.ets;
-	struct ieee_pfc *my_pfc;
-
-	my_pfc = dcb_en ? mlxsw_sp_port->dcb.pfc : NULL;
-
-	return __mlxsw_sp_port_headroom_set(mlxsw_sp_port, hdroom, pause_en, my_pfc);
-}
-
 static int mlxsw_sp_port_change_mtu(struct net_device *dev, int mtu)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
-	bool pause_en = mlxsw_sp_port_is_pause_en(mlxsw_sp_port);
 	struct mlxsw_sp_hdroom orig_hdroom;
 	struct mlxsw_sp_hdroom hdroom;
 	int err;
@@ -728,7 +712,7 @@ static int mlxsw_sp_port_change_mtu(struct net_device *dev, int mtu)
 
 	hdroom = orig_hdroom;
 	hdroom.mtu = mtu;
-	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom, pause_en);
+	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom);
 	if (err)
 		return err;
 
@@ -739,7 +723,7 @@ static int mlxsw_sp_port_change_mtu(struct net_device *dev, int mtu)
 	return 0;
 
 err_port_mtu_set:
-	mlxsw_sp_port_headroom_set(mlxsw_sp_port, &orig_hdroom, pause_en);
+	mlxsw_sp_port_headroom_set(mlxsw_sp_port, &orig_hdroom);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index b2677146a242..5245367d6fb2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -430,9 +430,6 @@ enum mlxsw_sp_flood_type {
 	MLXSW_SP_FLOOD_TYPE_MC,
 };
 
-int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
-			       struct mlxsw_sp_hdroom *hdroom,
-			       bool pause_en);
 int mlxsw_sp_port_get_stats_raw(struct net_device *dev, int grp,
 				int prio, char *ppcnt_pl);
 int mlxsw_sp_port_admin_status_set(struct mlxsw_sp_port *mlxsw_sp_port,
@@ -446,12 +443,22 @@ struct mlxsw_sp_hdroom_prio {
 	u8 buf_idx;
 	/* Value of buf_idx deduced from the DCB ETS configuration. */
 	u8 ets_buf_idx;
+	bool lossy;
+};
+
+struct mlxsw_sp_hdroom_buf {
+	bool lossy;
 };
 
+#define MLXSW_SP_PB_COUNT 10
+
 struct mlxsw_sp_hdroom {
 	struct {
 		struct mlxsw_sp_hdroom_prio prio[IEEE_8021Q_MAX_PRIORITIES];
 	} prios;
+	struct {
+		struct mlxsw_sp_hdroom_buf buf[MLXSW_SP_PB_COUNT];
+	} bufs;
 	int delay_bytes;
 	int mtu;
 };
@@ -497,6 +504,7 @@ u32 mlxsw_sp_cells_bytes(const struct mlxsw_sp *mlxsw_sp, u32 cells);
 u32 mlxsw_sp_bytes_cells(const struct mlxsw_sp *mlxsw_sp, u32 bytes);
 u32 mlxsw_sp_sb_max_headroom_cells(const struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_hdroom_prios_reset_buf_idx(struct mlxsw_sp_hdroom *hdroom);
+void mlxsw_sp_hdroom_bufs_reset_lossiness(struct mlxsw_sp_hdroom *hdroom);
 
 extern const struct mlxsw_sp_sb_vals mlxsw_sp1_sb_vals;
 extern const struct mlxsw_sp_sb_vals mlxsw_sp2_sb_vals;
@@ -538,9 +546,8 @@ int mlxsw_sp_port_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			  bool dwrr, u8 dwrr_weight);
 int mlxsw_sp_port_prio_tc_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			      u8 switch_prio, u8 tclass);
-int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
-				 struct mlxsw_sp_hdroom *hdroom,
-				 bool pause_en, struct ieee_pfc *my_pfc);
+int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
+			       struct mlxsw_sp_hdroom *hdroom);
 int mlxsw_sp_port_ets_maxrate_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				  enum mlxsw_reg_qeec_hr hr, u8 index,
 				  u8 next_index, u32 maxrate, u8 burst_size);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index d029c873d63d..c30bbc62e7b0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -340,6 +340,20 @@ void mlxsw_sp_hdroom_prios_reset_buf_idx(struct mlxsw_sp_hdroom *hdroom)
 		hdroom->prios.prio[prio].buf_idx = hdroom->prios.prio[prio].ets_buf_idx;
 }
 
+void mlxsw_sp_hdroom_bufs_reset_lossiness(struct mlxsw_sp_hdroom *hdroom)
+{
+	int prio;
+	int i;
+
+	for (i = 0; i < DCBX_MAX_BUFFERS; i++)
+		hdroom->bufs.buf[i].lossy = true;
+
+	for (prio = 0; prio < IEEE_8021Q_MAX_PRIORITIES; prio++) {
+		if (!hdroom->prios.prio[prio].lossy)
+			hdroom->bufs.buf[hdroom->prios.prio[prio].buf_idx].lossy = false;
+	}
+}
+
 static int mlxsw_sp_port_headroom_init(struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	int err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
index e0b963bff8d4..6327a840f5e9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -113,7 +113,6 @@ static int mlxsw_sp_port_pg_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 static int mlxsw_sp_port_headroom_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 					  struct ieee_ets *ets)
 {
-	bool pause_en = mlxsw_sp_port_is_pause_en(mlxsw_sp_port);
 	struct ieee_ets *my_ets = mlxsw_sp_port->dcb.ets;
 	struct net_device *dev = mlxsw_sp_port->dev;
 	struct mlxsw_sp_hdroom hdroom;
@@ -124,12 +123,12 @@ static int mlxsw_sp_port_headroom_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	for (prio = 0; prio < IEEE_8021QAZ_MAX_TCS; prio++)
 		hdroom.prios.prio[prio].ets_buf_idx = ets->prio_tc[prio];
 	mlxsw_sp_hdroom_prios_reset_buf_idx(&hdroom);
+	mlxsw_sp_hdroom_bufs_reset_lossiness(&hdroom);
 
 	/* Create the required PGs, but don't destroy existing ones, as
 	 * traffic is still directed to them.
 	 */
-	err = __mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom, pause_en,
-					   mlxsw_sp_port->dcb.pfc);
+	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom);
 	if (err) {
 		netdev_err(dev, "Failed to configure port's headroom\n");
 		return err;
@@ -613,6 +612,7 @@ static int mlxsw_sp_dcbnl_ieee_setpfc(struct net_device *dev,
 	bool pause_en = mlxsw_sp_port_is_pause_en(mlxsw_sp_port);
 	struct mlxsw_sp_hdroom orig_hdroom;
 	struct mlxsw_sp_hdroom hdroom;
+	int prio;
 	int err;
 
 	if (pause_en && pfc->pfc_en) {
@@ -628,7 +628,12 @@ static int mlxsw_sp_dcbnl_ieee_setpfc(struct net_device *dev,
 	else
 		hdroom.delay_bytes = 0;
 
-	err = __mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom, pause_en, pfc);
+	for (prio = 0; prio < IEEE_8021QAZ_MAX_TCS; prio++)
+		hdroom.prios.prio[prio].lossy = !(pfc->pfc_en & BIT(prio));
+
+	mlxsw_sp_hdroom_bufs_reset_lossiness(&hdroom);
+
+	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom);
 	if (err) {
 		netdev_err(dev, "Failed to configure port's headroom for PFC\n");
 		return err;
@@ -646,7 +651,7 @@ static int mlxsw_sp_dcbnl_ieee_setpfc(struct net_device *dev,
 	return 0;
 
 err_port_pfc_set:
-	__mlxsw_sp_port_headroom_set(mlxsw_sp_port, &orig_hdroom, pause_en, mlxsw_sp_port->dcb.pfc);
+	mlxsw_sp_port_headroom_set(mlxsw_sp_port, &orig_hdroom);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 36c02c66bb14..b527391860bf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -204,6 +204,7 @@ static int mlxsw_sp_port_set_pauseparam(struct net_device *dev,
 	bool pause_en = pause->tx_pause || pause->rx_pause;
 	struct mlxsw_sp_hdroom orig_hdroom;
 	struct mlxsw_sp_hdroom hdroom;
+	int prio;
 	int err;
 
 	if (mlxsw_sp_port->dcb.pfc && mlxsw_sp_port->dcb.pfc->pfc_en) {
@@ -224,7 +225,12 @@ static int mlxsw_sp_port_set_pauseparam(struct net_device *dev,
 	else
 		hdroom.delay_bytes = 0;
 
-	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom, pause_en);
+	for (prio = 0; prio < IEEE_8021QAZ_MAX_TCS; prio++)
+		hdroom.prios.prio[prio].lossy = !pause_en;
+
+	mlxsw_sp_hdroom_bufs_reset_lossiness(&hdroom);
+
+	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom);
 	if (err) {
 		netdev_err(dev, "Failed to configure port's headroom\n");
 		return err;
@@ -242,8 +248,7 @@ static int mlxsw_sp_port_set_pauseparam(struct net_device *dev,
 	return 0;
 
 err_port_pause_configure:
-	pause_en = mlxsw_sp_port_is_pause_en(mlxsw_sp_port);
-	mlxsw_sp_port_headroom_set(mlxsw_sp_port, &orig_hdroom, pause_en);
+	mlxsw_sp_port_headroom_set(mlxsw_sp_port, &orig_hdroom);
 	return err;
 }
 
-- 
2.26.2

