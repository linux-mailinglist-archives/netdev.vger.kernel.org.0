Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC08626BD46
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgIPGgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:36:07 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:38319 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726133AbgIPGf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:35:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 445FB608;
        Wed, 16 Sep 2020 02:35:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 16 Sep 2020 02:35:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=aVLPTD7J4BbYtNx40DSFzPrtB90lsHQXRTV4Og/YoUs=; b=WLcFwrNX
        bE+hMmkSQB/Eq79hTkBGbS30ChfvL7+RGZzcycIjeyVB1qr1dI1NLOb9htlAy9bs
        a7VqPWvuC8UeUXABWGMRkdO4KA54mz68N15IuOYJSE/IwdWdL8CCcZtFLW8Zd6QM
        dEp6YoTsf5cTUuCdYw1QWTPOIs3uOV1ApAMYWzEcGFFG+M/TgFHkMY5vEyNNw0Mk
        XgQKPT2jYq4fyVZUK+b+P4dknfwm+E7UGauXCnHP/A8ZYvaP38GnkNhlqoZCl7nk
        5X9P2siNlbi/NR93kESXCKuF88LYFA38WfnkYYMkuGYL/1DwNu39cUQh5Kz2oFyd
        dmxLn4qDmFlg2g==
X-ME-Sender: <xms:TLJhXzQwQdzt43JpNVHiD8vic9GXNjYV1xsfTwIKRtSYx3SIJOZX-A>
    <xme:TLJhX0xa9ijMRKK4bq0Zb4Sn5Dzth49c7oOhO_ui1gCWTv4CVy0iITD5Gab4ehiFu
    027fVJSLXcoT6E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:TLJhX40SdeO3Q_auXvDBAghGylirC3hjYGUWtbRne594565DPoUnbw>
    <xmx:TLJhXzAAY6yDykZeReS1SIfECG1MJS4VJ_p6hKd62uepZU1fiNjbEQ>
    <xmx:TLJhX8j41WDTAqGlX0YewwhMjS8qcCo7CyZ0P9c-AvzPb_sViBV1ag>
    <xmx:TLJhX1uUiVfnj4dLZrsExua_2PVwxUj7scETx2M_NI1yaihL6GYUug>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7CC573064683;
        Wed, 16 Sep 2020 02:35:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/15] mlxsw: spectrum: Track MTU in struct mlxsw_sp_hdroom
Date:   Wed, 16 Sep 2020 09:35:16 +0300
Message-Id: <20200916063528.116624-4-idosch@idosch.org>
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

MTU influences sizes of auto-allocated buffers. Make it a part of port
buffer configuration and have __mlxsw_sp_port_headroom_set() take it from
there, instead of as an argument.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 26 ++++++++++++-------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  5 ++--
 .../mellanox/mlxsw/spectrum_buffers.c         |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    | 10 +++----
 .../mellanox/mlxsw/spectrum_ethtool.c         |  4 +--
 5 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index e436640abd4e..f3f8c025cc2d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -627,7 +627,7 @@ static void mlxsw_sp_pg_buf_pack(char *pbmc_pl, int index, u16 size, u16 thres,
 }
 
 static u16 mlxsw_sp_hdroom_buf_delay_get(const struct mlxsw_sp *mlxsw_sp,
-					 const struct mlxsw_sp_hdroom *hdroom, int mtu)
+					 const struct mlxsw_sp_hdroom *hdroom)
 {
 	u16 delay_cells;
 
@@ -641,12 +641,12 @@ static u16 mlxsw_sp_hdroom_buf_delay_get(const struct mlxsw_sp *mlxsw_sp,
 	 * Another MTU is added in case the transmitting host already started
 	 * transmitting a maximum length frame when the PFC packet was received.
 	 */
-	return 2 * delay_cells + mlxsw_sp_bytes_cells(mlxsw_sp, mtu);
+	return 2 * delay_cells + mlxsw_sp_bytes_cells(mlxsw_sp, hdroom->mtu);
 }
 
 int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				 struct mlxsw_sp_hdroom *hdroom,
-				 int mtu, u8 *prio_tc, bool pause_en, struct ieee_pfc *my_pfc)
+				 u8 *prio_tc, bool pause_en, struct ieee_pfc *my_pfc)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	u8 pfc_en = !!my_pfc ? my_pfc->pfc_en : 0;
@@ -682,9 +682,9 @@ int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			continue;
 
 		lossy = !(pfc || pause_en);
-		thres_cells = mlxsw_sp_pg_buf_threshold_get(mlxsw_sp, mtu);
+		thres_cells = mlxsw_sp_pg_buf_threshold_get(mlxsw_sp, hdroom->mtu);
 		thres_cells = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, thres_cells);
-		delay_cells = mlxsw_sp_hdroom_buf_delay_get(mlxsw_sp, hdroom, mtu);
+		delay_cells = mlxsw_sp_hdroom_buf_delay_get(mlxsw_sp, hdroom);
 		delay_cells = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, delay_cells);
 		total_cells = thres_cells + delay_cells;
 
@@ -706,7 +706,7 @@ int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
 
 int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			       struct mlxsw_sp_hdroom *hdroom,
-			       int mtu, bool pause_en)
+			       bool pause_en)
 {
 	u8 def_prio_tc[IEEE_8021QAZ_MAX_TCS] = {0};
 	bool dcb_en = !!mlxsw_sp_port->dcb.ets;
@@ -716,19 +716,25 @@ int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	prio_tc = dcb_en ? mlxsw_sp_port->dcb.ets->prio_tc : def_prio_tc;
 	my_pfc = dcb_en ? mlxsw_sp_port->dcb.pfc : NULL;
 
-	return __mlxsw_sp_port_headroom_set(mlxsw_sp_port, hdroom, mtu, prio_tc,
-					    pause_en, my_pfc);
+	return __mlxsw_sp_port_headroom_set(mlxsw_sp_port, hdroom, prio_tc, pause_en, my_pfc);
 }
 
 static int mlxsw_sp_port_change_mtu(struct net_device *dev, int mtu)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	bool pause_en = mlxsw_sp_port_is_pause_en(mlxsw_sp_port);
+	struct mlxsw_sp_hdroom orig_hdroom;
+	struct mlxsw_sp_hdroom hdroom;
 	int err;
 
-	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, mlxsw_sp_port->hdroom, mtu, pause_en);
+	orig_hdroom = *mlxsw_sp_port->hdroom;
+
+	hdroom = orig_hdroom;
+	hdroom.mtu = mtu;
+	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom, pause_en);
 	if (err)
 		return err;
+
 	err = mlxsw_sp_port_mtu_set(mlxsw_sp_port, mtu);
 	if (err)
 		goto err_port_mtu_set;
@@ -736,7 +742,7 @@ static int mlxsw_sp_port_change_mtu(struct net_device *dev, int mtu)
 	return 0;
 
 err_port_mtu_set:
-	mlxsw_sp_port_headroom_set(mlxsw_sp_port, mlxsw_sp_port->hdroom, dev->mtu, pause_en);
+	mlxsw_sp_port_headroom_set(mlxsw_sp_port, &orig_hdroom, pause_en);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 6d69f191a3fe..e2ac258ea9c7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -432,7 +432,7 @@ enum mlxsw_sp_flood_type {
 
 int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			       struct mlxsw_sp_hdroom *hdroom,
-			       int mtu, bool pause_en);
+			       bool pause_en);
 int mlxsw_sp_port_get_stats_raw(struct net_device *dev, int grp,
 				int prio, char *ppcnt_pl);
 int mlxsw_sp_port_admin_status_set(struct mlxsw_sp_port *mlxsw_sp_port,
@@ -441,6 +441,7 @@ int mlxsw_sp_port_admin_status_set(struct mlxsw_sp_port *mlxsw_sp_port,
 /* spectrum_buffers.c */
 struct mlxsw_sp_hdroom {
 	int delay_bytes;
+	int mtu;
 };
 
 int mlxsw_sp_buffers_init(struct mlxsw_sp *mlxsw_sp);
@@ -526,7 +527,7 @@ int mlxsw_sp_port_prio_tc_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			      u8 switch_prio, u8 tclass);
 int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				 struct mlxsw_sp_hdroom *hdroom,
-				 int mtu, u8 *prio_tc, bool pause_en, struct ieee_pfc *my_pfc);
+				 u8 *prio_tc, bool pause_en, struct ieee_pfc *my_pfc);
 int mlxsw_sp_port_ets_maxrate_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				  enum mlxsw_reg_qeec_hr hr, u8 index,
 				  u8 next_index, u32 maxrate, u8 burst_size);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 54218e691408..d7a2c4981bcb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -998,6 +998,7 @@ int mlxsw_sp_port_buffers_init(struct mlxsw_sp_port *mlxsw_sp_port)
 	mlxsw_sp_port->hdroom = kzalloc(sizeof(*mlxsw_sp_port->hdroom), GFP_KERNEL);
 	if (!mlxsw_sp_port->hdroom)
 		return -ENOMEM;
+	mlxsw_sp_port->hdroom->mtu = mlxsw_sp_port->dev->mtu;
 
 	err = mlxsw_sp_port_headroom_init(mlxsw_sp_port);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
index 65fcd043d96e..ccb86bc7ae26 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -121,7 +121,7 @@ static int mlxsw_sp_port_headroom_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	/* Create the required PGs, but don't destroy existing ones, as
 	 * traffic is still directed to them.
 	 */
-	err = __mlxsw_sp_port_headroom_set(mlxsw_sp_port, mlxsw_sp_port->hdroom, dev->mtu,
+	err = __mlxsw_sp_port_headroom_set(mlxsw_sp_port, mlxsw_sp_port->hdroom,
 					   ets->prio_tc, pause_en,
 					   mlxsw_sp_port->dcb.pfc);
 	if (err) {
@@ -622,8 +622,7 @@ static int mlxsw_sp_dcbnl_ieee_setpfc(struct net_device *dev,
 	else
 		hdroom.delay_bytes = 0;
 
-	err = __mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom, dev->mtu,
-					   mlxsw_sp_port->dcb.ets->prio_tc,
+	err = __mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom, mlxsw_sp_port->dcb.ets->prio_tc,
 					   pause_en, pfc);
 	if (err) {
 		netdev_err(dev, "Failed to configure port's headroom for PFC\n");
@@ -642,9 +641,8 @@ static int mlxsw_sp_dcbnl_ieee_setpfc(struct net_device *dev,
 	return 0;
 
 err_port_pfc_set:
-	__mlxsw_sp_port_headroom_set(mlxsw_sp_port, &orig_hdroom, dev->mtu,
-				     mlxsw_sp_port->dcb.ets->prio_tc, pause_en,
-				     mlxsw_sp_port->dcb.pfc);
+	__mlxsw_sp_port_headroom_set(mlxsw_sp_port, &orig_hdroom, mlxsw_sp_port->dcb.ets->prio_tc,
+				     pause_en, mlxsw_sp_port->dcb.pfc);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 8048a8b82d02..36c02c66bb14 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -224,7 +224,7 @@ static int mlxsw_sp_port_set_pauseparam(struct net_device *dev,
 	else
 		hdroom.delay_bytes = 0;
 
-	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom, dev->mtu, pause_en);
+	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom, pause_en);
 	if (err) {
 		netdev_err(dev, "Failed to configure port's headroom\n");
 		return err;
@@ -243,7 +243,7 @@ static int mlxsw_sp_port_set_pauseparam(struct net_device *dev,
 
 err_port_pause_configure:
 	pause_en = mlxsw_sp_port_is_pause_en(mlxsw_sp_port);
-	mlxsw_sp_port_headroom_set(mlxsw_sp_port, &orig_hdroom, dev->mtu, pause_en);
+	mlxsw_sp_port_headroom_set(mlxsw_sp_port, &orig_hdroom, pause_en);
 	return err;
 }
 
-- 
2.26.2

