Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521A226BD4D
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgIPGgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:36:35 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:37251 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726393AbgIPGgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:36:14 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 99F70608;
        Wed, 16 Sep 2020 02:36:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 16 Sep 2020 02:36:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=bsqv3EnacCdChzo3380y5l2zg3RrZ+YFYm5NEXUxT8M=; b=jEG/BY9L
        v1+35dmnlhMcvuY8ncXze93hOR4SnTpWM3JdlW1YiTfUZZ16XboxzgOxSFEnf/um
        w0JCqNegZR3FWlgcc0JyJbiq4CW/6j1kHpy3fcqE2zLp2Obtst4glT/8e9mF0TU5
        1u6u3Hd6h6WrM1wvOAqs7hSzOovm5mgrGTRvI9HPaJ/F5Yksl+cTvl/Xgm8NP1yy
        rUiYJWrGBgOyYX7w2RykgnrG0cZJt2qG5uAq42wEV/E04l/3aL1uP7LOV4R7b5vq
        akDvyVapC5qLZqI6WpewN0PKtwECG3lR2WtgTo2IUZmyjIspU2TOF5tASbfrMpX6
        Br2AZHc42s5mBw==
X-ME-Sender: <xms:XbJhX0k4XiF4qRxtBBkHE5ovxQDPP1feWbA047sYHoeKs6sfxvaCeA>
    <xme:XbJhXz2p8VTxEBnVwo8vHOhVqSJ9z48orcWvDz29HslZqZEXgKvdmG--qCcc-qMLp
    UgJxotANIzfJVM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpeduvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:XbJhXyo1jioQhxoLd37Ea9lmBidacNUDS_KtZSaz7ORuqxvL-PmpWw>
    <xmx:XbJhXwnL65WhlTjuSGdvyXVLmpe6hqGgrwcGJzCIoSPqcnt-TniMTw>
    <xmx:XbJhXy1NX-RhdeX6NP3WkO_PIes5Xim35xl9TCjOte3YMcukWWPdDg>
    <xmx:XbJhX3yAf-9b-rbt26zeobp6_B4UO77Ytm_znxxQyasT8Y8Ad64d3g>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 985CB306467E;
        Wed, 16 Sep 2020 02:36:11 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 13/15] mlxsw: spectrum_buffers: Convert mlxsw_sp_port_headroom_init()
Date:   Wed, 16 Sep 2020 09:35:26 +0300
Message-Id: <20200916063528.116624-14-idosch@idosch.org>
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

Currently mlxsw_sp_port_headroom_init() configures both priomap and buffers
by hand. Additionally, for port buffers, it configures buffer 0 with a size
that it will never again have if PFC configuration is touched.

Rewrite the init code to become a client of the new hdroom code. The only
difference in invocation is that the configuration is forced, so that it is
issued even if the desired configuration happens to match what is contained
in (hitherto not initialized with meaningful values) mlxsw_sp_port->hdroom.

Since now mlxsw_sp_port_headroom_init() initializes all the PG buffers to
meaningful values, mlxsw_sp_hdroom_configure_buffers() can avoid querying
the current configuration, and can fill the whole PBMC itself.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_buffers.c         | 75 ++++++-------------
 1 file changed, 23 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 3fdca44c5c56..2f1d09a40058 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -286,47 +286,6 @@ static int mlxsw_sp_sb_pm_occ_query(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 				     (unsigned long) pm);
 }
 
-/* 1/4 of a headroom necessary for 100Gbps port and 100m cable. */
-#define MLXSW_SP_PB_HEADROOM 25632
-#define MLXSW_SP_PB_UNUSED 8
-
-static int mlxsw_sp_port_pb_init(struct mlxsw_sp_port *mlxsw_sp_port)
-{
-	const u32 pbs[] = {
-		[0] = MLXSW_SP_PB_HEADROOM * mlxsw_sp_port->mapping.width,
-		[9] = MLXSW_PORT_MAX_MTU,
-	};
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	char pbmc_pl[MLXSW_REG_PBMC_LEN];
-	int i;
-
-	mlxsw_reg_pbmc_pack(pbmc_pl, mlxsw_sp_port->local_port,
-			    0xffff, 0xffff / 2);
-	for (i = 0; i < ARRAY_SIZE(pbs); i++) {
-		u16 size = mlxsw_sp_bytes_cells(mlxsw_sp, pbs[i]);
-
-		if (i == MLXSW_SP_PB_UNUSED)
-			continue;
-		size = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, size);
-		mlxsw_reg_pbmc_lossy_buffer_pack(pbmc_pl, i, size);
-	}
-	mlxsw_reg_pbmc_lossy_buffer_pack(pbmc_pl,
-					 MLXSW_REG_PBMC_PORT_SHARED_BUF_IDX, 0);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pbmc), pbmc_pl);
-}
-
-static int mlxsw_sp_port_pb_prio_init(struct mlxsw_sp_port *mlxsw_sp_port)
-{
-	char pptb_pl[MLXSW_REG_PPTB_LEN];
-	int i;
-
-	mlxsw_reg_pptb_pack(pptb_pl, mlxsw_sp_port->local_port);
-	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++)
-		mlxsw_reg_pptb_prio_to_buff_pack(pptb_pl, i, 0);
-	return mlxsw_reg_write(mlxsw_sp_port->mlxsw_sp->core, MLXSW_REG(pptb),
-			       pptb_pl);
-}
-
 void mlxsw_sp_hdroom_prios_reset_buf_idx(struct mlxsw_sp_hdroom *hdroom)
 {
 	int prio;
@@ -422,6 +381,8 @@ void mlxsw_sp_hdroom_bufs_reset_sizes(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 }
 
+#define MLXSW_SP_PB_UNUSED 8
+
 static int mlxsw_sp_hdroom_configure_buffers(struct mlxsw_sp_port *mlxsw_sp_port,
 					     const struct mlxsw_sp_hdroom *hdroom, bool force)
 {
@@ -435,14 +396,13 @@ static int mlxsw_sp_hdroom_configure_buffers(struct mlxsw_sp_port *mlxsw_sp_port
 	if (!dirty && !force)
 		return 0;
 
-	mlxsw_reg_pbmc_pack(pbmc_pl, mlxsw_sp_port->local_port, 0, 0);
-	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(pbmc), pbmc_pl);
-	if (err)
-		return err;
-
-	for (i = 0; i < DCBX_MAX_BUFFERS; i++) {
+	mlxsw_reg_pbmc_pack(pbmc_pl, mlxsw_sp_port->local_port, 0xffff, 0xffff / 2);
+	for (i = 0; i < MLXSW_SP_PB_COUNT; i++) {
 		const struct mlxsw_sp_hdroom_buf *buf = &hdroom->bufs.buf[i];
 
+		if (i == MLXSW_SP_PB_UNUSED)
+			continue;
+
 		mlxsw_sp_hdroom_buf_pack(pbmc_pl, i, buf->size_cells, buf->thres_cells, buf->lossy);
 	}
 
@@ -548,12 +508,23 @@ int mlxsw_sp_hdroom_configure(struct mlxsw_sp_port *mlxsw_sp_port,
 
 static int mlxsw_sp_port_headroom_init(struct mlxsw_sp_port *mlxsw_sp_port)
 {
-	int err;
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_hdroom hdroom = {};
+	u32 size9;
+	int prio;
 
-	err = mlxsw_sp_port_pb_init(mlxsw_sp_port);
-	if (err)
-		return err;
-	return mlxsw_sp_port_pb_prio_init(mlxsw_sp_port);
+	hdroom.mtu = mlxsw_sp_port->dev->mtu;
+	for (prio = 0; prio < IEEE_8021QAZ_MAX_TCS; prio++)
+		hdroom.prios.prio[prio].lossy = true;
+
+	mlxsw_sp_hdroom_bufs_reset_lossiness(&hdroom);
+	mlxsw_sp_hdroom_bufs_reset_sizes(mlxsw_sp_port, &hdroom);
+
+	/* Buffer 9 is used for control traffic. */
+	size9 = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, mlxsw_sp_port->max_mtu);
+	hdroom.bufs.buf[9].size_cells = mlxsw_sp_bytes_cells(mlxsw_sp, size9);
+
+	return __mlxsw_sp_hdroom_configure(mlxsw_sp_port, &hdroom, true);
 }
 
 static int mlxsw_sp_sb_port_init(struct mlxsw_sp *mlxsw_sp,
-- 
2.26.2

