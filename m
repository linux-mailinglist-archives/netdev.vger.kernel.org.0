Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B8326BD50
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgIPGgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:36:42 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:48449 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726359AbgIPGgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:36:04 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 538B6866;
        Wed, 16 Sep 2020 02:36:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 16 Sep 2020 02:36:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=JMiXcq8YTIXEIjfCX4i6mrq/dYpg8O02es9bX1aSII8=; b=SNZ2qKkV
        ZnY2esmV4S0Cbrm8yF2bs055rpablrrL/aWq5p84mUlYLPXYnfPFTGmHvavFnKQ7
        OlWUFaKVIW8BTpuQxQ6nRXHlDWSwiXgl16i5Dvjma+vs/vxQqC/sQ1MANUjW5NOo
        Q9cT+wCBpfIkn/FKG4oYJaSerH2BdrTSpiEw3FcBpk1lvNcHgWpDyycL7n1pbR0r
        1/DLig1+jI3Yc/aEBxDdL+arCwUmKEE/mXkACoUfdpZ1KOx3/J+2UgEfHcGyeslh
        b2I15tlhbVu6hndfMtDEZUpI42/6VLN470VBu5uOF+nsADburW0+GFlVLJ2B/5tB
        JjN9TXL/YKbxnA==
X-ME-Sender: <xms:UrJhX67ZwFLIxjRfrnk7P-GyXdLls-NGGonAeOd565QpMBvt7KQHZw>
    <xme:UrJhXz4fDVhyOOx1E-7pEMWX13wH2uwzMC10RaA80bE5IJRJXDDlGcErVlVBI7-jA
    3RRyKyaN1G1Ktc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:UrJhX5dZMNAoyZIHYB_-vixtVhTOnbblGfcgOuBU56XcCuZnZz4gWQ>
    <xmx:UrJhX3I7K-PmpG4P5Sm6NoAc0Fa755IPEKF0qmY9kft5ewS7Kz0u5w>
    <xmx:UrJhX-J_LHbXhOCURcxk7DbUxbY_bK-DJEEuMwOMW6uHX834B1Ed0g>
    <xmx:UrJhX63m2d94IU0llcVcesHd_RDpe1w0n_y5v9dVsfIZLBfidBMNFQ>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 823223064682;
        Wed, 16 Sep 2020 02:36:01 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/15] mlxsw: spectrum: Split headroom autoresize out of buffer configuration
Date:   Wed, 16 Sep 2020 09:35:20 +0300
Message-Id: <20200916063528.116624-8-idosch@idosch.org>
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

Split mlxsw_sp_port_headroom_set() to three functions.
mlxsw_sp_hdroom_bufs_reset_sizes() changes the sizes of the individual PG
buffers, and mlxsw_sp_hdroom_configure_buffers() will actually apply the
configuration. A third function, mlxsw_sp_hdroom_bufs_fit(), verifies that
the requested buffer configuration matches total headroom size
requirements.

Add wrappers, mlxsw_sp_hdroom_configure() and __..., that will eventually
perform full headroom configuration, but for now, only have them verify the
configured headroom size, and invoke mlxsw_sp_hdroom_configure_buffers().
Have them take the `force` argument to prepare for a later patch, even
though it is currently unused.

Note that the loop in mlxsw_sp_hdroom_configure_buffers() only goes through
DCBX_MAX_BUFFERS. Since there is no logic to configure the control buffer,
it needs to keep the values queried from the FW. Eventually this function
should configure all the PGs.

Note that conversion of __mlxsw_sp_dcbnl_ieee_setets() is not trivial. That
function performs the headroom configuration in three steps: first it
resizes the buffers and adds any new ones. Then it redirects priorities to
the new buffers. And finally it sets the size of the now-unused buffers to
zero. This way no packet drops are introduced.

So after invoking mlxsw_sp_hdroom_bufs_reset_sizes(), tweak the
configuration to keep the old sizes of PG buffers for those buffers whose
size was set to zero.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 92 ++++++++++++++-----
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  6 +-
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    | 25 ++++-
 .../mellanox/mlxsw/spectrum_ethtool.c         |  5 +-
 4 files changed, 97 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 533793a15621..48e48c398142 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -655,27 +655,16 @@ static bool mlxsw_sp_hdroom_buf_is_used(const struct mlxsw_sp_hdroom *hdroom, in
 	return false;
 }
 
-int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
-			       struct mlxsw_sp_hdroom *hdroom)
+void mlxsw_sp_hdroom_bufs_reset_sizes(struct mlxsw_sp_port *mlxsw_sp_port,
+				      struct mlxsw_sp_hdroom *hdroom)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	char pbmc_pl[MLXSW_REG_PBMC_LEN];
-	u32 taken_headroom_cells = 0;
-	u32 max_headroom_cells;
-	int i, err;
-
-	max_headroom_cells = mlxsw_sp_sb_max_headroom_cells(mlxsw_sp);
-
-	mlxsw_reg_pbmc_pack(pbmc_pl, mlxsw_sp_port->local_port, 0, 0);
-	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(pbmc), pbmc_pl);
-	if (err)
-		return err;
+	int i;
 
 	for (i = 0; i < DCBX_MAX_BUFFERS; i++) {
 		struct mlxsw_sp_hdroom_buf *buf = &hdroom->bufs.buf[i];
 		u16 thres_cells;
 		u16 delay_cells;
-		u16 total_cells;
 
 		if (!mlxsw_sp_hdroom_buf_is_used(hdroom, i)) {
 			thres_cells = 0;
@@ -693,23 +682,78 @@ int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
 
 		buf->thres_cells = thres_cells;
 		buf->size_cells = thres_cells + delay_cells;
-		total_cells = thres_cells + delay_cells;
+	}
+}
+
+static int mlxsw_sp_hdroom_configure_buffers(struct mlxsw_sp_port *mlxsw_sp_port,
+					     const struct mlxsw_sp_hdroom *hdroom, bool force)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	char pbmc_pl[MLXSW_REG_PBMC_LEN];
+	bool dirty;
+	int err;
+	int i;
+
+	dirty = memcmp(&mlxsw_sp_port->hdroom->bufs, &hdroom->bufs, sizeof(hdroom->bufs));
+	if (!dirty && !force)
+		return 0;
+
+	mlxsw_reg_pbmc_pack(pbmc_pl, mlxsw_sp_port->local_port, 0, 0);
+	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(pbmc), pbmc_pl);
+	if (err)
+		return err;
 
-		taken_headroom_cells += total_cells;
-		if (taken_headroom_cells > max_headroom_cells)
-			return -ENOBUFS;
+	for (i = 0; i < DCBX_MAX_BUFFERS; i++) {
+		const struct mlxsw_sp_hdroom_buf *buf = &hdroom->bufs.buf[i];
 
-		mlxsw_sp_pg_buf_pack(pbmc_pl, i, total_cells, thres_cells, buf->lossy);
+		mlxsw_sp_pg_buf_pack(pbmc_pl, i, buf->size_cells, buf->thres_cells, buf->lossy);
 	}
 
+	mlxsw_reg_pbmc_lossy_buffer_pack(pbmc_pl, MLXSW_REG_PBMC_PORT_SHARED_BUF_IDX, 0);
 	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pbmc), pbmc_pl);
 	if (err)
 		return err;
 
+	mlxsw_sp_port->hdroom->bufs = hdroom->bufs;
+	return 0;
+}
+
+static bool mlxsw_sp_hdroom_bufs_fit(struct mlxsw_sp *mlxsw_sp,
+				     const struct mlxsw_sp_hdroom *hdroom)
+{
+	u32 taken_headroom_cells = 0;
+	u32 max_headroom_cells;
+	int i;
+
+	for (i = 0; i < MLXSW_SP_PB_COUNT; i++)
+		taken_headroom_cells += hdroom->bufs.buf[i].size_cells;
+
+	max_headroom_cells = mlxsw_sp_sb_max_headroom_cells(mlxsw_sp);
+	return taken_headroom_cells <= max_headroom_cells;
+}
+
+static int __mlxsw_sp_hdroom_configure(struct mlxsw_sp_port *mlxsw_sp_port,
+				       const struct mlxsw_sp_hdroom *hdroom, bool force)
+{
+	int err;
+
+	if (!mlxsw_sp_hdroom_bufs_fit(mlxsw_sp_port->mlxsw_sp, hdroom))
+		return -ENOBUFS;
+
+	err = mlxsw_sp_hdroom_configure_buffers(mlxsw_sp_port, hdroom, false);
+	if (err)
+		return err;
+
 	*mlxsw_sp_port->hdroom = *hdroom;
 	return 0;
 }
 
+int mlxsw_sp_hdroom_configure(struct mlxsw_sp_port *mlxsw_sp_port,
+			      const struct mlxsw_sp_hdroom *hdroom)
+{
+	return __mlxsw_sp_hdroom_configure(mlxsw_sp_port, hdroom, false);
+}
+
 static int mlxsw_sp_port_change_mtu(struct net_device *dev, int mtu)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
@@ -721,9 +765,13 @@ static int mlxsw_sp_port_change_mtu(struct net_device *dev, int mtu)
 
 	hdroom = orig_hdroom;
 	hdroom.mtu = mtu;
-	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom);
-	if (err)
+	mlxsw_sp_hdroom_bufs_reset_sizes(mlxsw_sp_port, &hdroom);
+
+	err = mlxsw_sp_hdroom_configure(mlxsw_sp_port, &hdroom);
+	if (err) {
+		netdev_err(dev, "Failed to configure port's headroom\n");
 		return err;
+	}
 
 	err = mlxsw_sp_port_mtu_set(mlxsw_sp_port, mtu);
 	if (err)
@@ -732,7 +780,7 @@ static int mlxsw_sp_port_change_mtu(struct net_device *dev, int mtu)
 	return 0;
 
 err_port_mtu_set:
-	mlxsw_sp_port_headroom_set(mlxsw_sp_port, &orig_hdroom);
+	mlxsw_sp_hdroom_configure(mlxsw_sp_port, &orig_hdroom);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index b3c9cdcc7a06..06008a17ae64 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -507,6 +507,10 @@ u32 mlxsw_sp_bytes_cells(const struct mlxsw_sp *mlxsw_sp, u32 bytes);
 u32 mlxsw_sp_sb_max_headroom_cells(const struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_hdroom_prios_reset_buf_idx(struct mlxsw_sp_hdroom *hdroom);
 void mlxsw_sp_hdroom_bufs_reset_lossiness(struct mlxsw_sp_hdroom *hdroom);
+void mlxsw_sp_hdroom_bufs_reset_sizes(struct mlxsw_sp_port *mlxsw_sp_port,
+				      struct mlxsw_sp_hdroom *hdroom);
+int mlxsw_sp_hdroom_configure(struct mlxsw_sp_port *mlxsw_sp_port,
+			      const struct mlxsw_sp_hdroom *hdroom);
 
 extern const struct mlxsw_sp_sb_vals mlxsw_sp1_sb_vals;
 extern const struct mlxsw_sp_sb_vals mlxsw_sp2_sb_vals;
@@ -548,8 +552,6 @@ int mlxsw_sp_port_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			  bool dwrr, u8 dwrr_weight);
 int mlxsw_sp_port_prio_tc_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			      u8 switch_prio, u8 tclass);
-int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
-			       struct mlxsw_sp_hdroom *hdroom);
 int mlxsw_sp_port_ets_maxrate_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				  enum mlxsw_reg_qeec_hr hr, u8 index,
 				  u8 next_index, u32 maxrate, u8 burst_size);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
index 6327a840f5e9..87465f8304c1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -115,20 +115,33 @@ static int mlxsw_sp_port_headroom_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 {
 	struct ieee_ets *my_ets = mlxsw_sp_port->dcb.ets;
 	struct net_device *dev = mlxsw_sp_port->dev;
+	struct mlxsw_sp_hdroom orig_hdroom;
+	struct mlxsw_sp_hdroom tmp_hdroom;
 	struct mlxsw_sp_hdroom hdroom;
 	int prio;
 	int err;
+	int i;
+
+	orig_hdroom = *mlxsw_sp_port->hdroom;
 
-	hdroom = *mlxsw_sp_port->hdroom;
+	hdroom = orig_hdroom;
 	for (prio = 0; prio < IEEE_8021QAZ_MAX_TCS; prio++)
 		hdroom.prios.prio[prio].ets_buf_idx = ets->prio_tc[prio];
 	mlxsw_sp_hdroom_prios_reset_buf_idx(&hdroom);
 	mlxsw_sp_hdroom_bufs_reset_lossiness(&hdroom);
+	mlxsw_sp_hdroom_bufs_reset_sizes(mlxsw_sp_port, &hdroom);
 
 	/* Create the required PGs, but don't destroy existing ones, as
 	 * traffic is still directed to them.
 	 */
-	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom);
+	tmp_hdroom = hdroom;
+	for (i = 0; i < DCBX_MAX_BUFFERS; i++) {
+		if (!tmp_hdroom.bufs.buf[i].size_cells)
+			tmp_hdroom.bufs.buf[i].size_cells =
+				mlxsw_sp_port->hdroom->bufs.buf[i].size_cells;
+	}
+
+	err = mlxsw_sp_hdroom_configure(mlxsw_sp_port, &tmp_hdroom);
 	if (err) {
 		netdev_err(dev, "Failed to configure port's headroom\n");
 		return err;
@@ -145,10 +158,11 @@ static int mlxsw_sp_port_headroom_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (err)
 		netdev_warn(dev, "Failed to remove unused PGs\n");
 
+	*mlxsw_sp_port->hdroom = hdroom;
 	return 0;
 
 err_port_prio_pg_map:
-	mlxsw_sp_port_pg_destroy(mlxsw_sp_port, ets->prio_tc, my_ets->prio_tc);
+	mlxsw_sp_hdroom_configure(mlxsw_sp_port, &orig_hdroom);
 	return err;
 }
 
@@ -632,8 +646,9 @@ static int mlxsw_sp_dcbnl_ieee_setpfc(struct net_device *dev,
 		hdroom.prios.prio[prio].lossy = !(pfc->pfc_en & BIT(prio));
 
 	mlxsw_sp_hdroom_bufs_reset_lossiness(&hdroom);
+	mlxsw_sp_hdroom_bufs_reset_sizes(mlxsw_sp_port, &hdroom);
 
-	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom);
+	err = mlxsw_sp_hdroom_configure(mlxsw_sp_port, &hdroom);
 	if (err) {
 		netdev_err(dev, "Failed to configure port's headroom for PFC\n");
 		return err;
@@ -651,7 +666,7 @@ static int mlxsw_sp_dcbnl_ieee_setpfc(struct net_device *dev,
 	return 0;
 
 err_port_pfc_set:
-	mlxsw_sp_port_headroom_set(mlxsw_sp_port, &orig_hdroom);
+	mlxsw_sp_hdroom_configure(mlxsw_sp_port, &orig_hdroom);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index b527391860bf..6045d3df00ef 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -229,8 +229,9 @@ static int mlxsw_sp_port_set_pauseparam(struct net_device *dev,
 		hdroom.prios.prio[prio].lossy = !pause_en;
 
 	mlxsw_sp_hdroom_bufs_reset_lossiness(&hdroom);
+	mlxsw_sp_hdroom_bufs_reset_sizes(mlxsw_sp_port, &hdroom);
 
-	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom);
+	err = mlxsw_sp_hdroom_configure(mlxsw_sp_port, &hdroom);
 	if (err) {
 		netdev_err(dev, "Failed to configure port's headroom\n");
 		return err;
@@ -248,7 +249,7 @@ static int mlxsw_sp_port_set_pauseparam(struct net_device *dev,
 	return 0;
 
 err_port_pause_configure:
-	mlxsw_sp_port_headroom_set(mlxsw_sp_port, &orig_hdroom);
+	mlxsw_sp_hdroom_configure(mlxsw_sp_port, &orig_hdroom);
 	return err;
 }
 
-- 
2.26.2

