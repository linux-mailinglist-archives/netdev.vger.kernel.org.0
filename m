Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBD826BD44
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgIPGf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:35:56 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:58545 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726133AbgIPGfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:35:55 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 0C1F3891;
        Wed, 16 Sep 2020 02:35:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 16 Sep 2020 02:35:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=X9Wy0JkcZn+gU+GnW2LpTmDsQ+miDyhHyyiJVGoNmAI=; b=YmG2m1fj
        j3TqHXhZUItjIhBx3CVx1dkwEQEfvd3JPnDB+AfBdgpZ8vZljOdSO6rWFAu1lZ1Y
        SWWdHosTIbs20Ln25Z8+QHeYmK5Wj9yj8SWTzlPQSIHFcxey8UPyqcAgq6M4RUft
        9SiLvZmWuN5XslFgWozzTVL1HIqlUDuxUwHjoauSawt9JsDSBRsVY+jTvwk3HINy
        XtZ7OagHkgwMMaVmIPdcymM1spgs/TDoMuKMUjgxX0OA9WeizlErzU44xZKXLchq
        TRE3vKjNmCTi7NxhHYyjlT4VB2uGVND382lDtaTnd4p6q05kLWWeNLopTW0psQWW
        1qzscqHFRgTZbA==
X-ME-Sender: <xms:SbJhX6UVdrD_tJ2YVOHyUQ6lnp2DYeaZBI3GfQIap_DqqKmL0I87PA>
    <xme:SbJhX2mRy4uFfwuNc_M8jp7Cmy0YPqXcfRm1MqMPPdVNU1G_Z1OGPvg7mC2YVcWQZ
    czmt3TsuVm3kkk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:SbJhX-aXfXyrPSpHVkv70ZHzuwFnNtuLa52Me24xz7DvzJdZwtk4kg>
    <xmx:SbJhXxW93ZhZJIWUQpI-7esJLlvLXAewdI7ALgy3uTeUErlRoykmXA>
    <xmx:SbJhX0kk6g9NkEATksStBy2rcHBW9Rs6WYLojdnL32KsEKCopdsDMw>
    <xmx:SbJhX-iweOWISteUVdo_wJZSGaZaUIzGGCAA7R2HjzZcwXryiU_f_Q>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 20E583064680;
        Wed, 16 Sep 2020 02:35:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/15] mlxsw: spectrum_buffers: Add struct mlxsw_sp_hdroom
Date:   Wed, 16 Sep 2020 09:35:14 +0300
Message-Id: <20200916063528.116624-2-idosch@idosch.org>
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

The port headroom handling is currently strewn across several modules and
tricky to follow: MTU, DCB PFC, DCB ETS and ethtool pause all influence the
settings, and then there is the completely separate initial configuraion in
spectrum_buffers. A following patch will implement the dcbnl_setbuffer
callback, which is going to further complicate the landscape.

In order to simplify work with port buffers, the following patches are
going to centralize all port-buffer handling in spectrum_buffers. As a
first step, introduce a (currently empty) struct mlxsw_sp_hdroom that will
keep the configuration parameters, and allocate and free it in appropriate
places.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  2 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  5 +++++
 .../mellanox/mlxsw/spectrum_buffers.c         | 20 +++++++++++++++++--
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 351d385158e6..ffb0e483d9cd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1709,6 +1709,7 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	mlxsw_sp_port_tc_mc_mode_set(mlxsw_sp_port, false);
 err_port_tc_mc_mode:
 err_port_ets_init:
+	mlxsw_sp_port_buffers_fini(mlxsw_sp_port);
 err_port_buffers_init:
 err_port_admin_status_set:
 err_port_mtu_set:
@@ -1745,6 +1746,7 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u8 local_port)
 	mlxsw_sp_port_fids_fini(mlxsw_sp_port);
 	mlxsw_sp_port_dcb_fini(mlxsw_sp_port);
 	mlxsw_sp_port_tc_mc_mode_set(mlxsw_sp_port, false);
+	mlxsw_sp_port_buffers_fini(mlxsw_sp_port);
 	mlxsw_sp_port_swid_set(mlxsw_sp_port, MLXSW_PORT_SWID_DISABLED_PORT);
 	mlxsw_sp_port_module_unmap(mlxsw_sp_port);
 	free_percpu(mlxsw_sp_port->pcpu_stats);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index a23b677d2144..7441f14101ff 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -316,6 +316,7 @@ struct mlxsw_sp_port {
 	u8 split_base_local_port;
 	int max_mtu;
 	u32 max_speed;
+	struct mlxsw_sp_hdroom *hdroom;
 };
 
 struct mlxsw_sp_port_type_speed_ops {
@@ -437,9 +438,13 @@ int mlxsw_sp_port_admin_status_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				   bool is_up);
 
 /* spectrum_buffers.c */
+struct mlxsw_sp_hdroom {
+};
+
 int mlxsw_sp_buffers_init(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_buffers_fini(struct mlxsw_sp *mlxsw_sp);
 int mlxsw_sp_port_buffers_init(struct mlxsw_sp_port *mlxsw_sp_port);
+void mlxsw_sp_port_buffers_fini(struct mlxsw_sp_port *mlxsw_sp_port);
 int mlxsw_sp_sb_pool_get(struct mlxsw_core *mlxsw_core,
 			 unsigned int sb_index, u16 pool_index,
 			 struct devlink_sb_pool_info *pool_info);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 6f84557a5a6f..54218e691408 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -995,17 +995,33 @@ int mlxsw_sp_port_buffers_init(struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	int err;
 
+	mlxsw_sp_port->hdroom = kzalloc(sizeof(*mlxsw_sp_port->hdroom), GFP_KERNEL);
+	if (!mlxsw_sp_port->hdroom)
+		return -ENOMEM;
+
 	err = mlxsw_sp_port_headroom_init(mlxsw_sp_port);
 	if (err)
-		return err;
+		goto err_headroom_init;
 	err = mlxsw_sp_port_sb_cms_init(mlxsw_sp_port);
 	if (err)
-		return err;
+		goto err_port_sb_cms_init;
 	err = mlxsw_sp_port_sb_pms_init(mlxsw_sp_port);
+	if (err)
+		goto err_port_sb_pms_init;
+	return 0;
 
+err_port_sb_pms_init:
+err_port_sb_cms_init:
+err_headroom_init:
+	kfree(mlxsw_sp_port->hdroom);
 	return err;
 }
 
+void mlxsw_sp_port_buffers_fini(struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	kfree(mlxsw_sp_port->hdroom);
+}
+
 int mlxsw_sp_sb_pool_get(struct mlxsw_core *mlxsw_core,
 			 unsigned int sb_index, u16 pool_index,
 			 struct devlink_sb_pool_info *pool_info)
-- 
2.26.2

