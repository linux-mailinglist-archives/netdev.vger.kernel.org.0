Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2712E26BD48
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgIPGgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:36:10 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:56889 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726309AbgIPGgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:36:00 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id CCB4B5E2;
        Wed, 16 Sep 2020 02:35:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 16 Sep 2020 02:35:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=aQHi0qK2UZfWYWAEXV2Sopgkb0ZqJd6E1j7kO3IQjsY=; b=kHOlCwLn
        YwNWLp7l9hPgxXnrv+3RD0CkMXlQxScbkMp/TNfxeChAhgjqK223rPYMnpsKYpik
        NO5WiyTcU5aEILz0Jm3Y8/BfqBBQtr+1U2/WxFtG0rorOUsvfYgYVboPZFfr5+SK
        LU2W8zGCergTUZJyHEJTmIIn3fK17UAkaVQ19Ax8ZS+XxVKdhDgGAdpluNIKtkp2
        xlyj2senqIBGXQOV0xYQQnR3bq9TCfXyWb0kWWdVl9DIxEaHpsf3i9StjH2cVx5z
        PQyBNP0zSI5Joc5n5uzQKOzmhImDctMGjaiBL7hRY9bKi0WiqKbxOuMnkZtmc5bA
        20/wVyP8CF5WVA==
X-ME-Sender: <xms:TrJhXzn-Io16ItzLg4qJks01sj8eBSdTPkoIpR93qQbkKv0vawS-VQ>
    <xme:TrJhX22Qz5phfj9nVvso0ahzkHgf9j5dDkttXgF7h0VtWQF041XEtPJnvOceiY2za
    e72GQ5ycltXGEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:TrJhX5rE_gfZM11S8StQDXF8uPIg-X4Mht0DDC-vQQf6TScki5YwBw>
    <xmx:TrJhX7l991qSgdJCGF3p-JwyVQGtR2a7quAW_INC5sEIQQasrMMuHA>
    <xmx:TrJhXx2CJKdFP_zsFwwmTs4Db4v8o8U0m_pDA7N_Ne7CqYbBrHANQQ>
    <xmx:TrJhX6zAT61z2nMnRiiErvz8fz5R5sR7aZUBcWtUMQ5Itnfkjv17Zg>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id F2B63306467D;
        Wed, 16 Sep 2020 02:35:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/15] mlxsw: spectrum: Track priorities in struct mlxsw_sp_hdroom
Date:   Wed, 16 Sep 2020 09:35:17 +0300
Message-Id: <20200916063528.116624-5-idosch@idosch.org>
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

The mapping from priorities to buffers determines which buffers should be
configured. Lossiness of these priorities combined with the mapping
determines whether a given buffer should be lossy.

Currently this configuration is stored implicitly in DCB ETS, PFC and
ethtool PAUSE configuration. Keeping it together with the rest of the
headroom configuration and deriving it as needed from PFC / ETS / PAUSE
will make things clearer. To that end, add a field "prios" to struct
mlxsw_sp_hdroom.

Previously, __mlxsw_sp_port_headroom_set() took prio_tc as an argument, and
assumed that the same mapping as we use on the egress should be used on
ingress as well. Instead, track this configuration at each priority, so
that it can be adjusted flexibly.

In the following patches, as dcbnl_setbuffer is implemented, it will need
to store its own mapping, and it will also be sometimes necessary to revert
back to the original ETS mapping. Therefore track two buffer indices: the
one for chip configuration (buf_idx), and the source one (ets_buf_idx).
Introduce a function to configure the chip-level buffer index, and for now
have it simply copy the ETS mapping over to the chip mapping.

Update the ETS handler to project prio_tc to the ets_buf_idx and invoke the
buf_idx recomputation.

Now that there is a canonical place to look for this configuration,
mlxsw_sp_port_headroom_set() does not need to invent def_prio_tc to use if
DCB is compiled out.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c   |  9 +++------
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h   | 15 ++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_buffers.c   |  8 ++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum_dcb.c   | 16 ++++++++++------
 4 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index f3f8c025cc2d..dee663229990 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -646,7 +646,7 @@ static u16 mlxsw_sp_hdroom_buf_delay_get(const struct mlxsw_sp *mlxsw_sp,
 
 int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				 struct mlxsw_sp_hdroom *hdroom,
-				 u8 *prio_tc, bool pause_en, struct ieee_pfc *my_pfc)
+				 bool pause_en, struct ieee_pfc *my_pfc)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	u8 pfc_en = !!my_pfc ? my_pfc->pfc_en : 0;
@@ -671,7 +671,7 @@ int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
 		bool lossy;
 
 		for (j = 0; j < IEEE_8021QAZ_MAX_TCS; j++) {
-			if (prio_tc[j] == i) {
+			if (hdroom->prios.prio[j].buf_idx == i) {
 				pfc = pfc_en & BIT(j);
 				configure = true;
 				break;
@@ -708,15 +708,12 @@ int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			       struct mlxsw_sp_hdroom *hdroom,
 			       bool pause_en)
 {
-	u8 def_prio_tc[IEEE_8021QAZ_MAX_TCS] = {0};
 	bool dcb_en = !!mlxsw_sp_port->dcb.ets;
 	struct ieee_pfc *my_pfc;
-	u8 *prio_tc;
 
-	prio_tc = dcb_en ? mlxsw_sp_port->dcb.ets->prio_tc : def_prio_tc;
 	my_pfc = dcb_en ? mlxsw_sp_port->dcb.pfc : NULL;
 
-	return __mlxsw_sp_port_headroom_set(mlxsw_sp_port, hdroom, prio_tc, pause_en, my_pfc);
+	return __mlxsw_sp_port_headroom_set(mlxsw_sp_port, hdroom, pause_en, my_pfc);
 }
 
 static int mlxsw_sp_port_change_mtu(struct net_device *dev, int mtu)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index e2ac258ea9c7..b2677146a242 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -439,7 +439,19 @@ int mlxsw_sp_port_admin_status_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				   bool is_up);
 
 /* spectrum_buffers.c */
+struct mlxsw_sp_hdroom_prio {
+	/* Number of port buffer associated with this priority. This is the
+	 * actually configured value.
+	 */
+	u8 buf_idx;
+	/* Value of buf_idx deduced from the DCB ETS configuration. */
+	u8 ets_buf_idx;
+};
+
 struct mlxsw_sp_hdroom {
+	struct {
+		struct mlxsw_sp_hdroom_prio prio[IEEE_8021Q_MAX_PRIORITIES];
+	} prios;
 	int delay_bytes;
 	int mtu;
 };
@@ -484,6 +496,7 @@ int mlxsw_sp_sb_occ_tc_port_bind_get(struct mlxsw_core_port *mlxsw_core_port,
 u32 mlxsw_sp_cells_bytes(const struct mlxsw_sp *mlxsw_sp, u32 cells);
 u32 mlxsw_sp_bytes_cells(const struct mlxsw_sp *mlxsw_sp, u32 bytes);
 u32 mlxsw_sp_sb_max_headroom_cells(const struct mlxsw_sp *mlxsw_sp);
+void mlxsw_sp_hdroom_prios_reset_buf_idx(struct mlxsw_sp_hdroom *hdroom);
 
 extern const struct mlxsw_sp_sb_vals mlxsw_sp1_sb_vals;
 extern const struct mlxsw_sp_sb_vals mlxsw_sp2_sb_vals;
@@ -527,7 +540,7 @@ int mlxsw_sp_port_prio_tc_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			      u8 switch_prio, u8 tclass);
 int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				 struct mlxsw_sp_hdroom *hdroom,
-				 u8 *prio_tc, bool pause_en, struct ieee_pfc *my_pfc);
+				 bool pause_en, struct ieee_pfc *my_pfc);
 int mlxsw_sp_port_ets_maxrate_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				  enum mlxsw_reg_qeec_hr hr, u8 index,
 				  u8 next_index, u32 maxrate, u8 burst_size);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index d7a2c4981bcb..d029c873d63d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -332,6 +332,14 @@ static int mlxsw_sp_port_pb_prio_init(struct mlxsw_sp_port *mlxsw_sp_port)
 			       pptb_pl);
 }
 
+void mlxsw_sp_hdroom_prios_reset_buf_idx(struct mlxsw_sp_hdroom *hdroom)
+{
+	int prio;
+
+	for (prio = 0; prio < IEEE_8021QAZ_MAX_TCS; prio++)
+		hdroom->prios.prio[prio].buf_idx = hdroom->prios.prio[prio].ets_buf_idx;
+}
+
 static int mlxsw_sp_port_headroom_init(struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	int err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
index ccb86bc7ae26..e0b963bff8d4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -116,13 +116,19 @@ static int mlxsw_sp_port_headroom_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	bool pause_en = mlxsw_sp_port_is_pause_en(mlxsw_sp_port);
 	struct ieee_ets *my_ets = mlxsw_sp_port->dcb.ets;
 	struct net_device *dev = mlxsw_sp_port->dev;
+	struct mlxsw_sp_hdroom hdroom;
+	int prio;
 	int err;
 
+	hdroom = *mlxsw_sp_port->hdroom;
+	for (prio = 0; prio < IEEE_8021QAZ_MAX_TCS; prio++)
+		hdroom.prios.prio[prio].ets_buf_idx = ets->prio_tc[prio];
+	mlxsw_sp_hdroom_prios_reset_buf_idx(&hdroom);
+
 	/* Create the required PGs, but don't destroy existing ones, as
 	 * traffic is still directed to them.
 	 */
-	err = __mlxsw_sp_port_headroom_set(mlxsw_sp_port, mlxsw_sp_port->hdroom,
-					   ets->prio_tc, pause_en,
+	err = __mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom, pause_en,
 					   mlxsw_sp_port->dcb.pfc);
 	if (err) {
 		netdev_err(dev, "Failed to configure port's headroom\n");
@@ -622,8 +628,7 @@ static int mlxsw_sp_dcbnl_ieee_setpfc(struct net_device *dev,
 	else
 		hdroom.delay_bytes = 0;
 
-	err = __mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom, mlxsw_sp_port->dcb.ets->prio_tc,
-					   pause_en, pfc);
+	err = __mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom, pause_en, pfc);
 	if (err) {
 		netdev_err(dev, "Failed to configure port's headroom for PFC\n");
 		return err;
@@ -641,8 +646,7 @@ static int mlxsw_sp_dcbnl_ieee_setpfc(struct net_device *dev,
 	return 0;
 
 err_port_pfc_set:
-	__mlxsw_sp_port_headroom_set(mlxsw_sp_port, &orig_hdroom, mlxsw_sp_port->dcb.ets->prio_tc,
-				     pause_en, mlxsw_sp_port->dcb.pfc);
+	__mlxsw_sp_port_headroom_set(mlxsw_sp_port, &orig_hdroom, pause_en, mlxsw_sp_port->dcb.pfc);
 	return err;
 }
 
-- 
2.26.2

