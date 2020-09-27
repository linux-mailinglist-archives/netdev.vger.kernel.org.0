Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6946279F67
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730538AbgI0HvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:51:05 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:41055 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730439AbgI0Hu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 03:50:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 6B1AB47B;
        Sun, 27 Sep 2020 03:50:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 27 Sep 2020 03:50:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Gdyfl/Znn7oJggCcoUjT/iiyaDBd/UOBnsoCzcwSnl4=; b=dXCfTI74
        dxLLJ0/9IwRZB7OJShXJVaQ3HbGe6gGKHhzH6pOo2zhaQai0qPtsc9TIoSkl3IVe
        XStS572oaK8T/EEUEHIV9LCmnG9Znb3hGu+ueFS1EGEI+QVnx+d2nsVLka5r0G/5
        jv/zgAlLtWcXdA5bE1x/cHB7StSg4zVqclRpPv2Dz919yvBN/JFKiTOMeyD4/KyV
        o7b5TURIrfI6H7W762TejmvQG1RrQN8sHDbLzHC/mpKOClBcQUH2ji9CyKGkGm6U
        FPQpkCldBTAkOYKcV3SsHWU491j1pez3ft70UgYmJiaX3l5If19VUsftHijRDu/B
        Z0Jo21Oy/pbghA==
X-ME-Sender: <xms:YERwX2X4HI68VwNFSHCp7O0qruKzE5YS8JwIPdKEWwpJSpGtjbvhaQ>
    <xme:YERwXymdkmT85mblrmKiKqeRKr1WUoJ5pQHTJAJQojcTdijxyPH-1i0jwjMebqpNC
    -_A-eT89wnC2q0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeejrddugeek
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:YERwX6YYzPILpcAhqbp_igHBC-7d27noSFtdIpThtZxzCbHNaAsh3A>
    <xmx:YERwX9UO97A8Opf2Havcnpz9t-b-JyMVcrNz4m9-4rGi9pzYALgHqA>
    <xmx:YERwXwlzJO_88Ang14aUs1QbQJTTgc1J3ktxjqfto3_moX7xVs8xiw>
    <xmx:YURwX6jwHa9xeduZz_DDaIcrh0tq_sWj1c1fY7KccGxpyNJP-p1uyQ>
Received: from shredder.lan (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 51E243280060;
        Sun, 27 Sep 2020 03:50:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/10] mlxsw: spectrum: Initialize netdev's module overheat counter
Date:   Sun, 27 Sep 2020 10:50:13 +0300
Message-Id: <20200927075015.1417714-9-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200927075015.1417714-1-idosch@idosch.org>
References: <20200927075015.1417714-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The overheat counter is a per-module counter, but it is exposed as part
of the corresponding netdev's statistics. It should therefore be
presented to user space relative to the netdev's lifetime.

Query the counter just before registering the netdev, so that the value
exposed to user space will be relative to this initial value.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 25 +++++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 2c9c836d45c5..25b1ab1cfa68 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1365,6 +1365,22 @@ static int mlxsw_sp_port_tc_mc_mode_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qtctm), qtctm_pl);
 }
 
+static int mlxsw_sp_port_overheat_init_val_set(struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 module = mlxsw_sp_port->mapping.module;
+	u64 overheat_counter;
+	int err;
+
+	err = mlxsw_env_module_overheat_counter_get(mlxsw_sp->core, module,
+						    &overheat_counter);
+	if (err)
+		return err;
+
+	mlxsw_sp_port->module_overheat_initial_val = overheat_counter;
+	return 0;
+}
+
 static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 				u8 split_base_local_port,
 				struct mlxsw_sp_port_mapping *port_mapping)
@@ -1575,6 +1591,14 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 			  mlxsw_sp->ptp_ops->shaper_work);
 
 	mlxsw_sp->ports[local_port] = mlxsw_sp_port;
+
+	err = mlxsw_sp_port_overheat_init_val_set(mlxsw_sp_port);
+	if (err) {
+		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Failed to set overheat initial value\n",
+			mlxsw_sp_port->local_port);
+		goto err_port_overheat_init_val_set;
+	}
+
 	err = register_netdev(dev);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Failed to register netdev\n",
@@ -1588,6 +1612,7 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	return 0;
 
 err_register_netdev:
+err_port_overheat_init_val_set:
 	mlxsw_sp->ports[local_port] = NULL;
 	mlxsw_sp_port_vlan_destroy(mlxsw_sp_port_vlan);
 err_port_vlan_create:
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index f0a4347acd25..3e26eb6cb140 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -319,6 +319,7 @@ struct mlxsw_sp_port {
 	int max_mtu;
 	u32 max_speed;
 	struct mlxsw_sp_hdroom *hdroom;
+	u64 module_overheat_initial_val;
 };
 
 struct mlxsw_sp_port_type_speed_ops {
-- 
2.26.2

