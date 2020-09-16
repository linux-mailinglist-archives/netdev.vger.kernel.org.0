Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878BB26BD4C
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgIPGge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:36:34 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:55147 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726390AbgIPGgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:36:14 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 51DC67A2;
        Wed, 16 Sep 2020 02:36:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 16 Sep 2020 02:36:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=RmxUGrP8PYT0XipF7XmFYtwn6yA084YVRUnfJvOi30c=; b=RGyMgHDB
        rpq4NgI1/MULJpMh71wCbhTPZrn9dgV5IrGbCmz6gx85ivdrEI6QDR5j3kH9nZjx
        pLmpqXkjHAbGLX9iiU1OfhcyGGjqLcY39phhZ9NYm2XBeHbREGo7sTDO5CmrqaeR
        gDgFwol3i71PVyJjMk6zDAbKCQFvo3Cq7M1CigE6YlRhLe3tIyHdO2Axbw7zZbBp
        9x4OTTUSbMOoAy6b8AIDIClSG9GBpdVq0qYG8YMV8JVh/ROXbtj/SmDQDefFzQd9
        1XZ8bBg0TxHbHe0vxqyjsz2k6Y7tuhq+XmN7cFlrBFl6MKWBxBqdwz8L+Yd8AMO8
        zkbsP3IKOh5cgg==
X-ME-Sender: <xms:WbJhX3G3E5mook8fZfSM3x_tAcyN6njQZ5QzpQMg9akx0yl_OBchAQ>
    <xme:WbJhX0W9VkZi94difNGpkj9e3mkoYWgP2ZzAXO_8KefsqfaegQ2zyp0TJKyMYl497
    aYOGX9GySmb15Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpeelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:WbJhX5Ls9iknp_lFgpMk4bWiXJJ-dg99tlcZ7YpW93_vibqiSgLulQ>
    <xmx:WbJhX1FSKa4_LaVBlfFnOZP8sEzrHvS12b1JoLISuHPrn0Zfzamgdw>
    <xmx:WbJhX9WWfKTkNQl8DKREBdkt64gdaO7dke9u_tnYyGBWcPdTLV86PA>
    <xmx:WbJhXwTW3mX6GbntySIgQkt86R8TbOC_jA7O1dyU6qMyKdcI7x_ZoQ>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7F322306467E;
        Wed, 16 Sep 2020 02:36:08 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 11/15] mlxsw: spectrum_buffers: Move here the new headroom code
Date:   Wed, 16 Sep 2020 09:35:24 +0300
Message-Id: <20200916063528.116624-12-idosch@idosch.org>
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

Move all the headroom code to the spectrum_buffers module, where it
belongs.

Rename mlxsw_sp_pg_buf_threshold_get() and mlxsw_sp_pg_buf_pack() to
..._hdroom_... to match the naming convention of the new headroom code.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 201 ------------------
 .../mellanox/mlxsw/spectrum_buffers.c         | 199 +++++++++++++++++
 2 files changed, 199 insertions(+), 201 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 1f0e930d8a50..2c4cc985e1f8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -610,207 +610,6 @@ static int mlxsw_sp_port_set_mac_address(struct net_device *dev, void *p)
 	return 0;
 }
 
-static u16 mlxsw_sp_pg_buf_threshold_get(const struct mlxsw_sp *mlxsw_sp,
-					 int mtu)
-{
-	return 2 * mlxsw_sp_bytes_cells(mlxsw_sp, mtu);
-}
-
-static void mlxsw_sp_pg_buf_pack(char *pbmc_pl, int index, u16 size, u16 thres,
-				 bool lossy)
-{
-	if (lossy)
-		mlxsw_reg_pbmc_lossy_buffer_pack(pbmc_pl, index, size);
-	else
-		mlxsw_reg_pbmc_lossless_buffer_pack(pbmc_pl, index, size,
-						    thres);
-}
-
-static u16 mlxsw_sp_hdroom_buf_delay_get(const struct mlxsw_sp *mlxsw_sp,
-					 const struct mlxsw_sp_hdroom *hdroom)
-{
-	u16 delay_cells;
-
-	delay_cells = mlxsw_sp_bytes_cells(mlxsw_sp, hdroom->delay_bytes);
-
-	/* In the worst case scenario the delay will be made up of packets that
-	 * are all of size CELL_SIZE + 1, which means each packet will require
-	 * almost twice its true size when buffered in the switch. We therefore
-	 * multiply this value by the "cell factor", which is close to 2.
-	 *
-	 * Another MTU is added in case the transmitting host already started
-	 * transmitting a maximum length frame when the PFC packet was received.
-	 */
-	return 2 * delay_cells + mlxsw_sp_bytes_cells(mlxsw_sp, hdroom->mtu);
-}
-
-static bool mlxsw_sp_hdroom_buf_is_used(const struct mlxsw_sp_hdroom *hdroom, int buf)
-{
-	int prio;
-
-	for (prio = 0; prio < IEEE_8021QAZ_MAX_TCS; prio++) {
-		if (hdroom->prios.prio[prio].buf_idx == buf)
-			return true;
-	}
-	return false;
-}
-
-void mlxsw_sp_hdroom_bufs_reset_sizes(struct mlxsw_sp_port *mlxsw_sp_port,
-				      struct mlxsw_sp_hdroom *hdroom)
-{
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	int i;
-
-	for (i = 0; i < DCBX_MAX_BUFFERS; i++) {
-		struct mlxsw_sp_hdroom_buf *buf = &hdroom->bufs.buf[i];
-		u16 thres_cells;
-		u16 delay_cells;
-
-		if (!mlxsw_sp_hdroom_buf_is_used(hdroom, i)) {
-			thres_cells = 0;
-			delay_cells = 0;
-		} else if (buf->lossy) {
-			thres_cells = mlxsw_sp_pg_buf_threshold_get(mlxsw_sp, hdroom->mtu);
-			delay_cells = 0;
-		} else {
-			thres_cells = mlxsw_sp_pg_buf_threshold_get(mlxsw_sp, hdroom->mtu);
-			delay_cells = mlxsw_sp_hdroom_buf_delay_get(mlxsw_sp, hdroom);
-		}
-
-		thres_cells = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, thres_cells);
-		delay_cells = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, delay_cells);
-
-		buf->thres_cells = thres_cells;
-		buf->size_cells = thres_cells + delay_cells;
-	}
-}
-
-static int mlxsw_sp_hdroom_configure_buffers(struct mlxsw_sp_port *mlxsw_sp_port,
-					     const struct mlxsw_sp_hdroom *hdroom, bool force)
-{
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	char pbmc_pl[MLXSW_REG_PBMC_LEN];
-	bool dirty;
-	int err;
-	int i;
-
-	dirty = memcmp(&mlxsw_sp_port->hdroom->bufs, &hdroom->bufs, sizeof(hdroom->bufs));
-	if (!dirty && !force)
-		return 0;
-
-	mlxsw_reg_pbmc_pack(pbmc_pl, mlxsw_sp_port->local_port, 0, 0);
-	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(pbmc), pbmc_pl);
-	if (err)
-		return err;
-
-	for (i = 0; i < DCBX_MAX_BUFFERS; i++) {
-		const struct mlxsw_sp_hdroom_buf *buf = &hdroom->bufs.buf[i];
-
-		mlxsw_sp_pg_buf_pack(pbmc_pl, i, buf->size_cells, buf->thres_cells, buf->lossy);
-	}
-
-	mlxsw_reg_pbmc_lossy_buffer_pack(pbmc_pl, MLXSW_REG_PBMC_PORT_SHARED_BUF_IDX, 0);
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pbmc), pbmc_pl);
-	if (err)
-		return err;
-
-	mlxsw_sp_port->hdroom->bufs = hdroom->bufs;
-	return 0;
-}
-
-static int mlxsw_sp_hdroom_configure_priomap(struct mlxsw_sp_port *mlxsw_sp_port,
-					     const struct mlxsw_sp_hdroom *hdroom, bool force)
-{
-	char pptb_pl[MLXSW_REG_PPTB_LEN];
-	bool dirty;
-	int prio;
-	int err;
-
-	dirty = memcmp(&mlxsw_sp_port->hdroom->prios, &hdroom->prios, sizeof(hdroom->prios));
-	if (!dirty && !force)
-		return 0;
-
-	mlxsw_reg_pptb_pack(pptb_pl, mlxsw_sp_port->local_port);
-	for (prio = 0; prio < IEEE_8021QAZ_MAX_TCS; prio++)
-		mlxsw_reg_pptb_prio_to_buff_pack(pptb_pl, prio, hdroom->prios.prio[prio].buf_idx);
-
-	err = mlxsw_reg_write(mlxsw_sp_port->mlxsw_sp->core, MLXSW_REG(pptb), pptb_pl);
-	if (err)
-		return err;
-
-	mlxsw_sp_port->hdroom->prios = hdroom->prios;
-	return 0;
-}
-
-static bool mlxsw_sp_hdroom_bufs_fit(struct mlxsw_sp *mlxsw_sp,
-				     const struct mlxsw_sp_hdroom *hdroom)
-{
-	u32 taken_headroom_cells = 0;
-	u32 max_headroom_cells;
-	int i;
-
-	for (i = 0; i < MLXSW_SP_PB_COUNT; i++)
-		taken_headroom_cells += hdroom->bufs.buf[i].size_cells;
-
-	max_headroom_cells = mlxsw_sp_sb_max_headroom_cells(mlxsw_sp);
-	return taken_headroom_cells <= max_headroom_cells;
-}
-
-static int __mlxsw_sp_hdroom_configure(struct mlxsw_sp_port *mlxsw_sp_port,
-				       const struct mlxsw_sp_hdroom *hdroom, bool force)
-{
-	struct mlxsw_sp_hdroom orig_hdroom;
-	struct mlxsw_sp_hdroom tmp_hdroom;
-	int err;
-	int i;
-
-	/* Port buffers need to be configured in three steps. First, all buffers
-	 * with non-zero size are configured. Then, prio-to-buffer map is
-	 * updated, allowing traffic to flow to the now non-zero buffers.
-	 * Finally, zero-sized buffers are configured, because now no traffic
-	 * should be directed to them anymore. This way, in a non-congested
-	 * system, no packet drops are introduced by the reconfiguration.
-	 */
-
-	orig_hdroom = *mlxsw_sp_port->hdroom;
-	tmp_hdroom = orig_hdroom;
-	for (i = 0; i < MLXSW_SP_PB_COUNT; i++) {
-		if (hdroom->bufs.buf[i].size_cells)
-			tmp_hdroom.bufs.buf[i] = hdroom->bufs.buf[i];
-	}
-
-	if (!mlxsw_sp_hdroom_bufs_fit(mlxsw_sp_port->mlxsw_sp, &tmp_hdroom) ||
-	    !mlxsw_sp_hdroom_bufs_fit(mlxsw_sp_port->mlxsw_sp, hdroom))
-		return -ENOBUFS;
-
-	err = mlxsw_sp_hdroom_configure_buffers(mlxsw_sp_port, &tmp_hdroom, force);
-	if (err)
-		return err;
-
-	err = mlxsw_sp_hdroom_configure_priomap(mlxsw_sp_port, hdroom, force);
-	if (err)
-		goto err_configure_priomap;
-
-	err = mlxsw_sp_hdroom_configure_buffers(mlxsw_sp_port, hdroom, false);
-	if (err)
-		goto err_configure_buffers;
-
-	*mlxsw_sp_port->hdroom = *hdroom;
-	return 0;
-
-err_configure_buffers:
-	mlxsw_sp_hdroom_configure_priomap(mlxsw_sp_port, &tmp_hdroom, false);
-err_configure_priomap:
-	mlxsw_sp_hdroom_configure_buffers(mlxsw_sp_port, &orig_hdroom, false);
-	return err;
-}
-
-int mlxsw_sp_hdroom_configure(struct mlxsw_sp_port *mlxsw_sp_port,
-			      const struct mlxsw_sp_hdroom *hdroom)
-{
-	return __mlxsw_sp_hdroom_configure(mlxsw_sp_port, hdroom, false);
-}
-
 static int mlxsw_sp_port_change_mtu(struct net_device *dev, int mtu)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index c30bbc62e7b0..1f44add89a6c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -354,6 +354,205 @@ void mlxsw_sp_hdroom_bufs_reset_lossiness(struct mlxsw_sp_hdroom *hdroom)
 	}
 }
 
+static u16 mlxsw_sp_hdroom_buf_threshold_get(const struct mlxsw_sp *mlxsw_sp, int mtu)
+{
+	return 2 * mlxsw_sp_bytes_cells(mlxsw_sp, mtu);
+}
+
+static void mlxsw_sp_hdroom_buf_pack(char *pbmc_pl, int index, u16 size, u16 thres, bool lossy)
+{
+	if (lossy)
+		mlxsw_reg_pbmc_lossy_buffer_pack(pbmc_pl, index, size);
+	else
+		mlxsw_reg_pbmc_lossless_buffer_pack(pbmc_pl, index, size,
+						    thres);
+}
+
+static u16 mlxsw_sp_hdroom_buf_delay_get(const struct mlxsw_sp *mlxsw_sp,
+					 const struct mlxsw_sp_hdroom *hdroom)
+{
+	u16 delay_cells;
+
+	delay_cells = mlxsw_sp_bytes_cells(mlxsw_sp, hdroom->delay_bytes);
+
+	/* In the worst case scenario the delay will be made up of packets that
+	 * are all of size CELL_SIZE + 1, which means each packet will require
+	 * almost twice its true size when buffered in the switch. We therefore
+	 * multiply this value by the "cell factor", which is close to 2.
+	 *
+	 * Another MTU is added in case the transmitting host already started
+	 * transmitting a maximum length frame when the PFC packet was received.
+	 */
+	return 2 * delay_cells + mlxsw_sp_bytes_cells(mlxsw_sp, hdroom->mtu);
+}
+
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
+void mlxsw_sp_hdroom_bufs_reset_sizes(struct mlxsw_sp_port *mlxsw_sp_port,
+				      struct mlxsw_sp_hdroom *hdroom)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	int i;
+
+	for (i = 0; i < DCBX_MAX_BUFFERS; i++) {
+		struct mlxsw_sp_hdroom_buf *buf = &hdroom->bufs.buf[i];
+		u16 thres_cells;
+		u16 delay_cells;
+
+		if (!mlxsw_sp_hdroom_buf_is_used(hdroom, i)) {
+			thres_cells = 0;
+			delay_cells = 0;
+		} else if (buf->lossy) {
+			thres_cells = mlxsw_sp_hdroom_buf_threshold_get(mlxsw_sp, hdroom->mtu);
+			delay_cells = 0;
+		} else {
+			thres_cells = mlxsw_sp_hdroom_buf_threshold_get(mlxsw_sp, hdroom->mtu);
+			delay_cells = mlxsw_sp_hdroom_buf_delay_get(mlxsw_sp, hdroom);
+		}
+
+		thres_cells = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, thres_cells);
+		delay_cells = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, delay_cells);
+
+		buf->thres_cells = thres_cells;
+		buf->size_cells = thres_cells + delay_cells;
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
+
+	for (i = 0; i < DCBX_MAX_BUFFERS; i++) {
+		const struct mlxsw_sp_hdroom_buf *buf = &hdroom->bufs.buf[i];
+
+		mlxsw_sp_hdroom_buf_pack(pbmc_pl, i, buf->size_cells, buf->thres_cells, buf->lossy);
+	}
+
+	mlxsw_reg_pbmc_lossy_buffer_pack(pbmc_pl, MLXSW_REG_PBMC_PORT_SHARED_BUF_IDX, 0);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pbmc), pbmc_pl);
+	if (err)
+		return err;
+
+	mlxsw_sp_port->hdroom->bufs = hdroom->bufs;
+	return 0;
+}
+
+static int mlxsw_sp_hdroom_configure_priomap(struct mlxsw_sp_port *mlxsw_sp_port,
+					     const struct mlxsw_sp_hdroom *hdroom, bool force)
+{
+	char pptb_pl[MLXSW_REG_PPTB_LEN];
+	bool dirty;
+	int prio;
+	int err;
+
+	dirty = memcmp(&mlxsw_sp_port->hdroom->prios, &hdroom->prios, sizeof(hdroom->prios));
+	if (!dirty && !force)
+		return 0;
+
+	mlxsw_reg_pptb_pack(pptb_pl, mlxsw_sp_port->local_port);
+	for (prio = 0; prio < IEEE_8021QAZ_MAX_TCS; prio++)
+		mlxsw_reg_pptb_prio_to_buff_pack(pptb_pl, prio, hdroom->prios.prio[prio].buf_idx);
+
+	err = mlxsw_reg_write(mlxsw_sp_port->mlxsw_sp->core, MLXSW_REG(pptb), pptb_pl);
+	if (err)
+		return err;
+
+	mlxsw_sp_port->hdroom->prios = hdroom->prios;
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
+	struct mlxsw_sp_hdroom orig_hdroom;
+	struct mlxsw_sp_hdroom tmp_hdroom;
+	int err;
+	int i;
+
+	/* Port buffers need to be configured in three steps. First, all buffers
+	 * with non-zero size are configured. Then, prio-to-buffer map is
+	 * updated, allowing traffic to flow to the now non-zero buffers.
+	 * Finally, zero-sized buffers are configured, because now no traffic
+	 * should be directed to them anymore. This way, in a non-congested
+	 * system, no packet drops are introduced by the reconfiguration.
+	 */
+
+	orig_hdroom = *mlxsw_sp_port->hdroom;
+	tmp_hdroom = orig_hdroom;
+	for (i = 0; i < MLXSW_SP_PB_COUNT; i++) {
+		if (hdroom->bufs.buf[i].size_cells)
+			tmp_hdroom.bufs.buf[i] = hdroom->bufs.buf[i];
+	}
+
+	if (!mlxsw_sp_hdroom_bufs_fit(mlxsw_sp_port->mlxsw_sp, &tmp_hdroom) ||
+	    !mlxsw_sp_hdroom_bufs_fit(mlxsw_sp_port->mlxsw_sp, hdroom))
+		return -ENOBUFS;
+
+	err = mlxsw_sp_hdroom_configure_buffers(mlxsw_sp_port, &tmp_hdroom, force);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_hdroom_configure_priomap(mlxsw_sp_port, hdroom, force);
+	if (err)
+		goto err_configure_priomap;
+
+	err = mlxsw_sp_hdroom_configure_buffers(mlxsw_sp_port, hdroom, false);
+	if (err)
+		goto err_configure_buffers;
+
+	*mlxsw_sp_port->hdroom = *hdroom;
+	return 0;
+
+err_configure_buffers:
+	mlxsw_sp_hdroom_configure_priomap(mlxsw_sp_port, &tmp_hdroom, false);
+err_configure_priomap:
+	mlxsw_sp_hdroom_configure_buffers(mlxsw_sp_port, &orig_hdroom, false);
+	return err;
+}
+
+int mlxsw_sp_hdroom_configure(struct mlxsw_sp_port *mlxsw_sp_port,
+			      const struct mlxsw_sp_hdroom *hdroom)
+{
+	return __mlxsw_sp_hdroom_configure(mlxsw_sp_port, hdroom, false);
+}
+
 static int mlxsw_sp_port_headroom_init(struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	int err;
-- 
2.26.2

