Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7887344A15
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhCVQAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:00:38 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51493 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231329AbhCVQAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 12:00:05 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CDB7C5C01CA;
        Mon, 22 Mar 2021 12:00:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 22 Mar 2021 12:00:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=+kLiOUn0ZJSyfd9BFTF4HLs7+Psoo7fwOPQFDJmkK98=; b=WHXiv+61
        8rKuB7YlxOO9wLcPL8ab4B/4k3ENGDBhKanyNR7uxULdhkrq5NSLxsU+sxfN57bz
        /kfi3zhXzXqQLH/7DALDc4XI037o+RXJ2/zIEc60kadD3PRLlW3qOtK9csoiwhe0
        jceOzWGeZ8hrSlBBhHtIdbneVIw/nAQPPZ4iPYhqXSFvV9qPd0b68Qk0uXwIUBrI
        eGm4RUNAX7MSrQnrjbYYeKlZ/KRu7e3EVwpVGkU1yiaP4OB3YgCJ/7WRwb8EZgix
        puJChcf3VXqDX3YbJzCa7eA9DsTmLMpRLMupe/4jCV9FodtK1EsjXKf63TmNRU/0
        YCb5bGPm3JnelA==
X-ME-Sender: <xms:BL9YYA2rpE4NM9A75qWpa51P_FTJCx18DLTnoRwij2ysCyKjFbmGhA>
    <xme:BL9YYLGevKt4KCeLzHXpCTBv1YQ8VqLCuc6Q0cv0-kwKhHVrm6j4Kt5NKdpwlU-d-
    GdaMPUJAGs0ryc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepleenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:BL9YYI7vblY-IIKpMOkaFiJe7zIUIlxnvd87vwa0mSPtpD_CwVXJ0Q>
    <xmx:BL9YYJ3_QLh471COcgbrnRZegUziGYoDWMpLirCJrnMXICrSVqvbmA>
    <xmx:BL9YYDGoU-CIiuNGxo1qDK51osw3CKhuk3TAX6Zweq9aCGd7blPTqA>
    <xmx:BL9YYHip8fz3QeBWWHhAuyKX4YtGQmliNJyOCek3tSyHW9mNJ6A7Hg>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id A69F11080066;
        Mon, 22 Mar 2021 12:00:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 12/14] mlxsw: spectrum_router: Create per-ASIC router operations
Date:   Mon, 22 Mar 2021 17:58:53 +0200
Message-Id: <20210322155855.3164151-13-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322155855.3164151-1-idosch@idosch.org>
References: <20210322155855.3164151-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

There are several differences in the router module between Spectrum-1
and Spectrum-{2,3}. Currently, this is only apparent in the router
interface (RIF) operations that are split between these ASICs.

A subsequent patch is going to introduce another difference between
these ASICs.

Create per-ASIC router operations that will encapsulate all these
differences. For now, these operations are only used to set the per-ASIC
RIF operations in 'mlxsw_sp->router->rif_ops_arr'. Note that this fields
was unused since commit 1f5b23033937 ("mlxsw: spectrum: Set RIF ops per
ASIC type").

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  6 +--
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  8 ++--
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 37 +++++++++++++++++--
 3 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index df4ec063adcb..efc7acb4842c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2934,7 +2934,6 @@ static int mlxsw_sp1_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->acl_tcam_ops = &mlxsw_sp1_acl_tcam_ops;
 	mlxsw_sp->nve_ops_arr = mlxsw_sp1_nve_ops_arr;
 	mlxsw_sp->mac_mask = mlxsw_sp1_mac_mask;
-	mlxsw_sp->rif_ops_arr = mlxsw_sp1_rif_ops_arr;
 	mlxsw_sp->sb_vals = &mlxsw_sp1_sb_vals;
 	mlxsw_sp->sb_ops = &mlxsw_sp1_sb_ops;
 	mlxsw_sp->port_type_speed_ops = &mlxsw_sp1_port_type_speed_ops;
@@ -2943,6 +2942,7 @@ static int mlxsw_sp1_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->policer_core_ops = &mlxsw_sp1_policer_core_ops;
 	mlxsw_sp->trap_ops = &mlxsw_sp1_trap_ops;
 	mlxsw_sp->mall_ops = &mlxsw_sp1_mall_ops;
+	mlxsw_sp->router_ops = &mlxsw_sp1_router_ops;
 	mlxsw_sp->listeners = mlxsw_sp1_listener;
 	mlxsw_sp->listeners_count = ARRAY_SIZE(mlxsw_sp1_listener);
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP1;
@@ -2965,7 +2965,6 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->acl_tcam_ops = &mlxsw_sp2_acl_tcam_ops;
 	mlxsw_sp->nve_ops_arr = mlxsw_sp2_nve_ops_arr;
 	mlxsw_sp->mac_mask = mlxsw_sp2_mac_mask;
-	mlxsw_sp->rif_ops_arr = mlxsw_sp2_rif_ops_arr;
 	mlxsw_sp->sb_vals = &mlxsw_sp2_sb_vals;
 	mlxsw_sp->sb_ops = &mlxsw_sp2_sb_ops;
 	mlxsw_sp->port_type_speed_ops = &mlxsw_sp2_port_type_speed_ops;
@@ -2974,6 +2973,7 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->policer_core_ops = &mlxsw_sp2_policer_core_ops;
 	mlxsw_sp->trap_ops = &mlxsw_sp2_trap_ops;
 	mlxsw_sp->mall_ops = &mlxsw_sp2_mall_ops;
+	mlxsw_sp->router_ops = &mlxsw_sp2_router_ops;
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP2;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
@@ -2994,7 +2994,6 @@ static int mlxsw_sp3_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->acl_tcam_ops = &mlxsw_sp2_acl_tcam_ops;
 	mlxsw_sp->nve_ops_arr = mlxsw_sp2_nve_ops_arr;
 	mlxsw_sp->mac_mask = mlxsw_sp2_mac_mask;
-	mlxsw_sp->rif_ops_arr = mlxsw_sp2_rif_ops_arr;
 	mlxsw_sp->sb_vals = &mlxsw_sp2_sb_vals;
 	mlxsw_sp->sb_ops = &mlxsw_sp3_sb_ops;
 	mlxsw_sp->port_type_speed_ops = &mlxsw_sp2_port_type_speed_ops;
@@ -3003,6 +3002,7 @@ static int mlxsw_sp3_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->policer_core_ops = &mlxsw_sp2_policer_core_ops;
 	mlxsw_sp->trap_ops = &mlxsw_sp2_trap_ops;
 	mlxsw_sp->mall_ops = &mlxsw_sp2_mall_ops;
+	mlxsw_sp->router_ops = &mlxsw_sp2_router_ops;
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP3;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 03655e418edb..97d074d7b78d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -87,10 +87,10 @@ enum mlxsw_sp_rif_type {
 	MLXSW_SP_RIF_TYPE_MAX,
 };
 
-struct mlxsw_sp_rif_ops;
+struct mlxsw_sp_router_ops;
 
-extern const struct mlxsw_sp_rif_ops *mlxsw_sp1_rif_ops_arr[];
-extern const struct mlxsw_sp_rif_ops *mlxsw_sp2_rif_ops_arr[];
+extern const struct mlxsw_sp_router_ops mlxsw_sp1_router_ops;
+extern const struct mlxsw_sp_router_ops mlxsw_sp2_router_ops;
 
 struct mlxsw_sp_switchdev_ops;
 
@@ -180,7 +180,6 @@ struct mlxsw_sp {
 	const struct mlxsw_sp_acl_rulei_ops *acl_rulei_ops;
 	const struct mlxsw_sp_acl_tcam_ops *acl_tcam_ops;
 	const struct mlxsw_sp_nve_ops **nve_ops_arr;
-	const struct mlxsw_sp_rif_ops **rif_ops_arr;
 	const struct mlxsw_sp_sb_vals *sb_vals;
 	const struct mlxsw_sp_sb_ops *sb_ops;
 	const struct mlxsw_sp_port_type_speed_ops *port_type_speed_ops;
@@ -189,6 +188,7 @@ struct mlxsw_sp {
 	const struct mlxsw_sp_policer_core_ops *policer_core_ops;
 	const struct mlxsw_sp_trap_ops *trap_ops;
 	const struct mlxsw_sp_mall_ops *mall_ops;
+	const struct mlxsw_sp_router_ops *router_ops;
 	const struct mlxsw_listener *listeners;
 	size_t listeners_count;
 	u32 lowest_shaper_bs;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 4114f3b7d3cd..dd3fb5ca5c32 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -113,6 +113,10 @@ struct mlxsw_sp_rif_ops {
 	void (*fdb_del)(struct mlxsw_sp_rif *rif, const char *mac);
 };
 
+struct mlxsw_sp_router_ops {
+	int (*init)(struct mlxsw_sp *mlxsw_sp);
+};
+
 static struct mlxsw_sp_rif *
 mlxsw_sp_rif_find_by_dev(const struct mlxsw_sp *mlxsw_sp,
 			 const struct net_device *dev);
@@ -7712,7 +7716,7 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 	int i, err;
 
 	type = mlxsw_sp_dev_rif_type(mlxsw_sp, params->dev);
-	ops = mlxsw_sp->rif_ops_arr[type];
+	ops = mlxsw_sp->router->rif_ops_arr[type];
 
 	vr = mlxsw_sp_vr_get(mlxsw_sp, tb_id ? : RT_TABLE_MAIN, extack);
 	if (IS_ERR(vr))
@@ -8910,7 +8914,7 @@ static const struct mlxsw_sp_rif_ops mlxsw_sp1_rif_ipip_lb_ops = {
 	.deconfigure		= mlxsw_sp1_rif_ipip_lb_deconfigure,
 };
 
-const struct mlxsw_sp_rif_ops *mlxsw_sp1_rif_ops_arr[] = {
+static const struct mlxsw_sp_rif_ops *mlxsw_sp1_rif_ops_arr[] = {
 	[MLXSW_SP_RIF_TYPE_SUBPORT]	= &mlxsw_sp_rif_subport_ops,
 	[MLXSW_SP_RIF_TYPE_VLAN]	= &mlxsw_sp_rif_vlan_emu_ops,
 	[MLXSW_SP_RIF_TYPE_FID]		= &mlxsw_sp_rif_fid_ops,
@@ -9095,7 +9099,7 @@ static const struct mlxsw_sp_rif_ops mlxsw_sp2_rif_ipip_lb_ops = {
 	.deconfigure		= mlxsw_sp2_rif_ipip_lb_deconfigure,
 };
 
-const struct mlxsw_sp_rif_ops *mlxsw_sp2_rif_ops_arr[] = {
+static const struct mlxsw_sp_rif_ops *mlxsw_sp2_rif_ops_arr[] = {
 	[MLXSW_SP_RIF_TYPE_SUBPORT]	= &mlxsw_sp_rif_subport_ops,
 	[MLXSW_SP_RIF_TYPE_VLAN]	= &mlxsw_sp_rif_vlan_emu_ops,
 	[MLXSW_SP_RIF_TYPE_FID]		= &mlxsw_sp_rif_fid_ops,
@@ -9347,6 +9351,28 @@ static void mlxsw_sp_lb_rif_fini(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_sp_router_ul_rif_put(mlxsw_sp, mlxsw_sp->router->lb_rif_index);
 }
 
+static int mlxsw_sp1_router_init(struct mlxsw_sp *mlxsw_sp)
+{
+	mlxsw_sp->router->rif_ops_arr = mlxsw_sp1_rif_ops_arr;
+
+	return 0;
+}
+
+const struct mlxsw_sp_router_ops mlxsw_sp1_router_ops = {
+	.init = mlxsw_sp1_router_init,
+};
+
+static int mlxsw_sp2_router_init(struct mlxsw_sp *mlxsw_sp)
+{
+	mlxsw_sp->router->rif_ops_arr = mlxsw_sp2_rif_ops_arr;
+
+	return 0;
+}
+
+const struct mlxsw_sp_router_ops mlxsw_sp2_router_ops = {
+	.init = mlxsw_sp2_router_init,
+};
+
 int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 			 struct netlink_ext_ack *extack)
 {
@@ -9360,6 +9386,10 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp->router = router;
 	router->mlxsw_sp = mlxsw_sp;
 
+	err = mlxsw_sp->router_ops->init(mlxsw_sp);
+	if (err)
+		goto err_router_ops_init;
+
 	err = mlxsw_sp_router_xm_init(mlxsw_sp);
 	if (err)
 		goto err_xm_init;
@@ -9500,6 +9530,7 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 err_ll_op_ctx_init:
 	mlxsw_sp_router_xm_fini(mlxsw_sp);
 err_xm_init:
+err_router_ops_init:
 	mutex_destroy(&mlxsw_sp->router->lock);
 	kfree(mlxsw_sp->router);
 	return err;
-- 
2.29.2

