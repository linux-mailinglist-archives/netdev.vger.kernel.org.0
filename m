Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A4B26BD49
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgIPGgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:36:17 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:35377 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726373AbgIPGgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:36:10 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id C37937E3;
        Wed, 16 Sep 2020 02:36:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 16 Sep 2020 02:36:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=DoaiVRI1eYRieh7uSRV8qZAq/mmDDa18Hpk6qSkk4L4=; b=cUo23IRC
        I3FnPD8n8rlACD3k85T1hSJbGiUJqif5IXYSaPoFTYxVihNKBI4kHqTtcZKW/7xD
        UaGRd3JRJcFEz1v1ll9+mQa5ZYHV6kQaEfAQMutSK+Wrqs+V/HahZefwjtoQg2Hf
        mMK0STiKgCbA0gI9FrsW1jBFBtTVt1T6ZrPT+Iiq76Rwun5ephkVX6LfdbfKJQtY
        sRRytsM/AGMaG/brsFxsV/jhbzGKB1mA/UqjPBChu3q9nnnPA5Oj9ApPEn26Celi
        +ykbmH52A2Yb6z2ZXwhek9zzhm5GrnB5ck3Euav8+6+oYgstirN7eJGIWffQC8/Z
        ITkPD3kx0ixKUQ==
X-ME-Sender: <xms:WLJhX7QQ4sz04DbvmKpKJEN2M3t9nRpVEKWgfttj5aZqRwkdCfDQDw>
    <xme:WLJhX8zwKB0WBzBcw00kPnCsncFa9xX4s06MIaVBQnYorEM6LBlCk0ap1mP9bNXOu
    ZiCe23Y1-foa5o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpeelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:WLJhXw0nNg4ZkBmmKI6IH-Cae4F19_WCdxD3Z3OpmJMsFs6maKdtag>
    <xmx:WLJhX7C6Az-70mMCSz0D0MAuzxoVtVrL1vcAGX5YtMDO48yBIRW2EA>
    <xmx:WLJhX0hh1CT9nYM3Q5dc2o8eUycRs6QMPhsBJwBzseW32fMJ-rwctw>
    <xmx:WLJhX9tigBu-AP6MIOJcxCFuETLxTlxOdidVSiIyXh3H09UUE0XfxQ>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7C7A53064682;
        Wed, 16 Sep 2020 02:36:06 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/15] mlxsw: spectrum: Move here the three-step headroom configuration from DCB
Date:   Wed, 16 Sep 2020 09:35:23 +0300
Message-Id: <20200916063528.116624-11-idosch@idosch.org>
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

The ETS handler performs the headroom configuration in three steps: first
it resizes the buffers and adds any new ones. Then it redirects priorities
to the new buffers. And finally it sets the size of the now-unused buffers
to zero. This way no packet drops are introduced.

This sort of careful approach will also be useful for configuring port
buffer sizes and priority map by hand, through dcbnl_setbuffer. Therefore
move the code from the DCB handler to the generic headroom function.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 61 ++++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    | 61 +------------------
 2 files changed, 61 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 48e48c398142..1f0e930d8a50 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -718,6 +718,30 @@ static int mlxsw_sp_hdroom_configure_buffers(struct mlxsw_sp_port *mlxsw_sp_port
 	return 0;
 }
 
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
 static bool mlxsw_sp_hdroom_bufs_fit(struct mlxsw_sp *mlxsw_sp,
 				     const struct mlxsw_sp_hdroom *hdroom)
 {
@@ -735,17 +759,50 @@ static bool mlxsw_sp_hdroom_bufs_fit(struct mlxsw_sp *mlxsw_sp,
 static int __mlxsw_sp_hdroom_configure(struct mlxsw_sp_port *mlxsw_sp_port,
 				       const struct mlxsw_sp_hdroom *hdroom, bool force)
 {
+	struct mlxsw_sp_hdroom orig_hdroom;
+	struct mlxsw_sp_hdroom tmp_hdroom;
 	int err;
+	int i;
+
+	/* Port buffers need to be configured in three steps. First, all buffers
+	 * with non-zero size are configured. Then, prio-to-buffer map is
+	 * updated, allowing traffic to flow to the now non-zero buffers.
+	 * Finally, zero-sized buffers are configured, because now no traffic
+	 * should be directed to them anymore. This way, in a non-congested
+	 * system, no packet drops are introduced by the reconfiguration.
+	 */
 
-	if (!mlxsw_sp_hdroom_bufs_fit(mlxsw_sp_port->mlxsw_sp, hdroom))
+	orig_hdroom = *mlxsw_sp_port->hdroom;
+	tmp_hdroom = orig_hdroom;
+	for (i = 0; i < MLXSW_SP_PB_COUNT; i++) {
+		if (hdroom->bufs.buf[i].size_cells)
+			tmp_hdroom.bufs.buf[i] = hdroom->bufs.buf[i];
+	}
+
+	if (!mlxsw_sp_hdroom_bufs_fit(mlxsw_sp_port->mlxsw_sp, &tmp_hdroom) ||
+	    !mlxsw_sp_hdroom_bufs_fit(mlxsw_sp_port->mlxsw_sp, hdroom))
 		return -ENOBUFS;
 
-	err = mlxsw_sp_hdroom_configure_buffers(mlxsw_sp_port, hdroom, false);
+	err = mlxsw_sp_hdroom_configure_buffers(mlxsw_sp_port, &tmp_hdroom, force);
 	if (err)
 		return err;
 
+	err = mlxsw_sp_hdroom_configure_priomap(mlxsw_sp_port, hdroom, force);
+	if (err)
+		goto err_configure_priomap;
+
+	err = mlxsw_sp_hdroom_configure_buffers(mlxsw_sp_port, hdroom, false);
+	if (err)
+		goto err_configure_buffers;
+
 	*mlxsw_sp_port->hdroom = *hdroom;
 	return 0;
+
+err_configure_buffers:
+	mlxsw_sp_hdroom_configure_priomap(mlxsw_sp_port, &tmp_hdroom, false);
+err_configure_priomap:
+	mlxsw_sp_hdroom_configure_buffers(mlxsw_sp_port, &orig_hdroom, false);
+	return err;
 }
 
 int mlxsw_sp_hdroom_configure(struct mlxsw_sp_port *mlxsw_sp_port,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
index 098432c881c2..d9a556dbe85e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -64,85 +64,28 @@ static int mlxsw_sp_port_ets_validate(struct mlxsw_sp_port *mlxsw_sp_port,
 	return 0;
 }
 
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
 static int mlxsw_sp_port_headroom_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 					  struct ieee_ets *ets)
 {
 	struct net_device *dev = mlxsw_sp_port->dev;
-	struct mlxsw_sp_hdroom orig_hdroom;
-	struct mlxsw_sp_hdroom tmp_hdroom;
 	struct mlxsw_sp_hdroom hdroom;
 	int prio;
 	int err;
-	int i;
 
-	orig_hdroom = *mlxsw_sp_port->hdroom;
-
-	hdroom = orig_hdroom;
+	hdroom = *mlxsw_sp_port->hdroom;
 	for (prio = 0; prio < IEEE_8021QAZ_MAX_TCS; prio++)
 		hdroom.prios.prio[prio].ets_buf_idx = ets->prio_tc[prio];
 	mlxsw_sp_hdroom_prios_reset_buf_idx(&hdroom);
 	mlxsw_sp_hdroom_bufs_reset_lossiness(&hdroom);
 	mlxsw_sp_hdroom_bufs_reset_sizes(mlxsw_sp_port, &hdroom);
 
-	/* Create the required PGs, but don't destroy existing ones, as
-	 * traffic is still directed to them.
-	 */
-	tmp_hdroom = hdroom;
-	for (i = 0; i < DCBX_MAX_BUFFERS; i++) {
-		if (!tmp_hdroom.bufs.buf[i].size_cells)
-			tmp_hdroom.bufs.buf[i].size_cells =
-				mlxsw_sp_port->hdroom->bufs.buf[i].size_cells;
-	}
-
-	err = mlxsw_sp_hdroom_configure(mlxsw_sp_port, &tmp_hdroom);
+	err = mlxsw_sp_hdroom_configure(mlxsw_sp_port, &hdroom);
 	if (err) {
 		netdev_err(dev, "Failed to configure port's headroom\n");
 		return err;
 	}
 
-	err = mlxsw_sp_hdroom_configure_priomap(mlxsw_sp_port, &hdroom, false);
-	if (err) {
-		netdev_err(dev, "Failed to set PG-priority mapping\n");
-		goto err_port_prio_pg_map;
-	}
-
-	err = mlxsw_sp_hdroom_configure(mlxsw_sp_port, &hdroom);
-	if (err) {
-		netdev_warn(dev, "Failed to remove unused PGs\n");
-		goto err_configure_buffers;
-	}
-
 	return 0;
-
-err_configure_buffers:
-	mlxsw_sp_hdroom_configure_priomap(mlxsw_sp_port, &tmp_hdroom, false);
-err_port_prio_pg_map:
-	mlxsw_sp_hdroom_configure(mlxsw_sp_port, &orig_hdroom);
-	return err;
 }
 
 static int __mlxsw_sp_dcbnl_ieee_setets(struct mlxsw_sp_port *mlxsw_sp_port,
-- 
2.26.2

