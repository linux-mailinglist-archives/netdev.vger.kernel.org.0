Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D2F268004
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 17:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgIMPrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 11:47:39 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40107 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725967AbgIMPqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 11:46:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id CCEE55C0121;
        Sun, 13 Sep 2020 11:46:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 13 Sep 2020 11:46:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=f+Ggdpha2cGJrwlHiMR5v63bosUDC76Ha7J8kzfuPpw=; b=A4lO4+G6
        HqaTv2Lq2207/QEdIAKym1WwySsdNJ2VYNbSigYD85WsdCOwEhTmuPfJ0osSgMpA
        w9pXnlEYtF9JAAzeMBHQYoUOZjdTg8VrVLunwDtC5l9quDCoY130r7RsJECL13z3
        obQikY7AzXPJ8UPTcRJ/6yeaOZYPCmoovU4zmh96VMGjyI8N66bVGJV0mYtd05mR
        1MyNLrpcusytVOiyF3hHf3EN8ii7JpY/jcI/yepWRCE8fk5Qjcw6onBsARi9pIlE
        GFEhLK/hmNymr6uqgiE6SZQ2AZvY/famxmjobkahFGxkZ+uNR1WpoUkmrperzziT
        3b45aghbEczJtg==
X-ME-Sender: <xms:7D5eX1RQvWN-HKLfVs7V_lDehlKAwamPvCZGAoPEGWqArGfbmVTvkw>
    <xme:7D5eX-zHLLuUrpt9Kc0qWUQ0JC58iLXOPbxOtzNI5adKgPyeZSLGT_5Rye6_SxzXr
    GNXOamyWd6ss-Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeigedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:7D5eX61_n9oCNCOXVQYphtXYu2-jjGPBOgO_2UFSiilTd0GDWbscLg>
    <xmx:7D5eX9A2_mDdZchVnrRFMJnh414IFiW7RPMziLOJ9BLY2Fs0URzfdA>
    <xmx:7D5eX-j6f9Ui1sreUyDyoRl_SRsdn3CB51jCfZuZoSvXHzaMpM59jQ>
    <xmx:7D5eX_uPBoi36OrEJf6U9GRCOIjtywgdilfuv-cWYt63YPMzeDGM1Q>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3FAA2328005A;
        Sun, 13 Sep 2020 11:46:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/5] mlxsw: spectrum_span: Derive SBIB from maximum port speed & MTU
Date:   Sun, 13 Sep 2020 18:46:09 +0300
Message-Id: <20200913154609.14870-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200913154609.14870-1-idosch@idosch.org>
References: <20200913154609.14870-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The SBIB register configures the size of an internal buffer that the
Spectrum ASICs use when mirroring traffic on egress. This size should be
taken into account when validating that the port headroom buffers are not
larger than the chip can handle. Up until now this was not done, which is
incidentally not a problem, because the priority group buffers that mlxsw
auto-configures are small enough that the boundary condition could not be
violated.

However when dcbnl_setbuffer is implemented, the user has control over
sizes of PG buffers, and they might overshoot the headroom capacity.
However the size of the SBIB buffer depends on port speed, and that cannot
be vetoed. Therefore SBIB size should be deduced from maximum port speed.

Additionally, once the buffers are configured by hand, the user could get
into an uncomfortable situation where their MTU change requests get vetoed,
because the SBIB does not fit anymore. Therefore derive SBIB size from
maximum permissible MTU as well.

Remove all the code that adjusted the SBIB size whenever speed or MTU
changed.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  9 ---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  3 -
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 59 ++-----------------
 3 files changed, 4 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 439f3302c4ff..0097c18d0d67 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1003,9 +1003,6 @@ static int mlxsw_sp_port_change_mtu(struct net_device *dev, int mtu)
 	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, mtu, pause_en);
 	if (err)
 		return err;
-	err = mlxsw_sp_span_port_mtu_update(mlxsw_sp_port, mtu);
-	if (err)
-		goto err_span_port_mtu_update;
 	err = mlxsw_sp_port_mtu_set(mlxsw_sp_port, mtu);
 	if (err)
 		goto err_port_mtu_set;
@@ -1013,8 +1010,6 @@ static int mlxsw_sp_port_change_mtu(struct net_device *dev, int mtu)
 	return 0;
 
 err_port_mtu_set:
-	mlxsw_sp_span_port_mtu_update(mlxsw_sp_port, dev->mtu);
-err_span_port_mtu_update:
 	mlxsw_sp_port_headroom_set(mlxsw_sp_port, dev->mtu, pause_en);
 	return err;
 }
@@ -1952,8 +1947,6 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 
 	INIT_DELAYED_WORK(&mlxsw_sp_port->ptp.shaper_dw,
 			  mlxsw_sp->ptp_ops->shaper_work);
-	INIT_DELAYED_WORK(&mlxsw_sp_port->span.speed_update_dw,
-			  mlxsw_sp_span_speed_update_work);
 
 	mlxsw_sp->ports[local_port] = mlxsw_sp_port;
 	err = register_netdev(dev);
@@ -2010,7 +2003,6 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u8 local_port)
 	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp->ports[local_port];
 
 	cancel_delayed_work_sync(&mlxsw_sp_port->periodic_hw_stats.update_dw);
-	cancel_delayed_work_sync(&mlxsw_sp_port->span.speed_update_dw);
 	cancel_delayed_work_sync(&mlxsw_sp_port->ptp.shaper_dw);
 	mlxsw_sp_port_ptp_clear(mlxsw_sp_port);
 	mlxsw_core_port_clear(mlxsw_sp->core, local_port, mlxsw_sp);
@@ -2414,7 +2406,6 @@ static void mlxsw_sp_pude_event_func(const struct mlxsw_reg_info *reg,
 		netdev_info(mlxsw_sp_port->dev, "link up\n");
 		netif_carrier_on(mlxsw_sp_port->dev);
 		mlxsw_core_schedule_dw(&mlxsw_sp_port->ptp.shaper_dw, 0);
-		mlxsw_core_schedule_dw(&mlxsw_sp_port->span.speed_update_dw, 0);
 	} else {
 		netdev_info(mlxsw_sp_port->dev, "link down\n");
 		netif_carrier_off(mlxsw_sp_port->dev);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 824ca4507c7e..c8077eddf0a8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -316,9 +316,6 @@ struct mlxsw_sp_port {
 		struct mlxsw_sp_ptp_port_stats stats;
 	} ptp;
 	u8 split_base_local_port;
-	struct {
-		struct delayed_work speed_update_dw;
-	} span;
 	int max_mtu;
 	u32 max_speed;
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 1d18e41ab255..38b3131c4027 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -977,21 +977,14 @@ static u32 mlxsw_sp_span_buffsize_get(struct mlxsw_sp *mlxsw_sp, int mtu,
 }
 
 static int
-mlxsw_sp_span_port_buffer_update(struct mlxsw_sp_port *mlxsw_sp_port, u16 mtu)
+mlxsw_sp_span_port_buffer_enable(struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	char sbib_pl[MLXSW_REG_SBIB_LEN];
 	u32 buffsize;
-	u32 speed;
-	int err;
-
-	err = mlxsw_sp_port_speed_get(mlxsw_sp_port, &speed);
-	if (err)
-		return err;
-	if (speed == SPEED_UNKNOWN)
-		speed = 0;
 
-	buffsize = mlxsw_sp_span_buffsize_get(mlxsw_sp, speed, mtu);
+	buffsize = mlxsw_sp_span_buffsize_get(mlxsw_sp, mlxsw_sp_port->max_speed,
+					      mlxsw_sp_port->max_mtu);
 	buffsize = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, buffsize);
 	mlxsw_reg_sbib_pack(sbib_pl, mlxsw_sp_port->local_port, buffsize);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sbib), sbib_pl);
@@ -1021,48 +1014,6 @@ mlxsw_sp_span_analyzed_port_find(struct mlxsw_sp_span *span, u8 local_port,
 	return NULL;
 }
 
-int mlxsw_sp_span_port_mtu_update(struct mlxsw_sp_port *port, u16 mtu)
-{
-	struct mlxsw_sp *mlxsw_sp = port->mlxsw_sp;
-	int err = 0;
-
-	/* If port is egress mirrored, the shared buffer size should be
-	 * updated according to the mtu value
-	 */
-	mutex_lock(&mlxsw_sp->span->analyzed_ports_lock);
-
-	if (mlxsw_sp_span_analyzed_port_find(mlxsw_sp->span, port->local_port,
-					     false))
-		err = mlxsw_sp_span_port_buffer_update(port, mtu);
-
-	mutex_unlock(&mlxsw_sp->span->analyzed_ports_lock);
-
-	return err;
-}
-
-void mlxsw_sp_span_speed_update_work(struct work_struct *work)
-{
-	struct delayed_work *dwork = to_delayed_work(work);
-	struct mlxsw_sp_port *mlxsw_sp_port;
-	struct mlxsw_sp *mlxsw_sp;
-
-	mlxsw_sp_port = container_of(dwork, struct mlxsw_sp_port,
-				     span.speed_update_dw);
-
-	/* If port is egress mirrored, the shared buffer size should be
-	 * updated according to the speed value.
-	 */
-	mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	mutex_lock(&mlxsw_sp->span->analyzed_ports_lock);
-
-	if (mlxsw_sp_span_analyzed_port_find(mlxsw_sp->span,
-					     mlxsw_sp_port->local_port, false))
-		mlxsw_sp_span_port_buffer_update(mlxsw_sp_port,
-						 mlxsw_sp_port->dev->mtu);
-
-	mutex_unlock(&mlxsw_sp->span->analyzed_ports_lock);
-}
-
 static const struct mlxsw_sp_span_entry_ops *
 mlxsw_sp_span_entry_ops(struct mlxsw_sp *mlxsw_sp,
 			const struct net_device *to_dev)
@@ -1180,9 +1131,7 @@ mlxsw_sp_span_analyzed_port_create(struct mlxsw_sp_span *span,
 	 * does the mirroring.
 	 */
 	if (!ingress) {
-		u16 mtu = mlxsw_sp_port->dev->mtu;
-
-		err = mlxsw_sp_span_port_buffer_update(mlxsw_sp_port, mtu);
+		err = mlxsw_sp_span_port_buffer_enable(mlxsw_sp_port);
 		if (err)
 			goto err_buffer_update;
 	}
-- 
2.26.2

