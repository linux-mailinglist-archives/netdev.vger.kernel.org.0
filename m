Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8107279F65
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730513AbgI0Hu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:50:59 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:52783 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730471AbgI0Huz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 03:50:55 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id CBBBD46D;
        Sun, 27 Sep 2020 03:50:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 27 Sep 2020 03:50:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=hO3ftEHZuQ67+9mIMnxEjG3e54Afqgj6HSjejuQ4hJ8=; b=efzqIpva
        AQnFdN2EM4M5VsAPvO90YsbptF6qhSH8MwPoaG4iaWAHtdZAzYLcBwuHdCY/e0dG
        +0nckypI1Y+ysZSUR2C0ady6/7NJe83VgKANYl4/3rZ37dA+m967k7YcOl/mKGUX
        A7a28PtCnBI7JUz1yCmloHxaJ67wK9X5UJqfJLZYdGC4HcECbGzqgDFXGU+cfQRD
        hKvRMz66334pm3K+H/G3cD39j/2CFKeo+xEhEbthPWfcZ4ZY5MtmAxBfJyY9tohm
        bw0SrmUKAn/zaU4Z2AsNnylTrNRsgoIwaCSgFg8UwKhhN94O3/Xtj1axtzcLhp90
        SwnO0T5XNH7o1Q==
X-ME-Sender: <xms:XURwX2cKgjdk2nWxhbGPyn7iGTozMoJZ8akYhdnFZ9G_mGBzWjCquQ>
    <xme:XURwXwMUoai6x7FViv0obKEfuWEY7aiuTj-VqIQlO0neQfdEtowcA3GyxuE3-g3HH
    IcfcrAUGgM9wBo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeejrddugeek
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:XURwX3iPtIjfzLg7epKzkuXFVOaJThd_CB52tycX1eJAZf8VAMA3iQ>
    <xmx:XURwXz9SSgUf0F9h-hslmjpKGvQiK9HfixJXrOZ8oUCzFXajQ3SC-w>
    <xmx:XURwXytj4bbA7id8VZarj7lg4J45hZQO1OcG9c6pTD2DYucEkSMLqA>
    <xmx:XURwX2LQIybiL3UHTO34yZm2kBqhpKnBgpaDKjTFeLy6p-a8xHldxw>
Received: from shredder.lan (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id C68743280065;
        Sun, 27 Sep 2020 03:50:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/10] mlxsw: Update transceiver_overheat counter according to MTWE
Date:   Sun, 27 Sep 2020 10:50:11 +0300
Message-Id: <20200927075015.1417714-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200927075015.1417714-1-idosch@idosch.org>
References: <20200927075015.1417714-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

MTWE (Management Temperature Warning Event) is triggered when module's
temperature is higher than its threshold.

Register for MTWE events and increase the module's overheat counter when
its corresponding sensor goes above the configured threshold.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  5 ++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  3 +
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 77 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  1 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 11 +++
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |  2 +
 6 files changed, 99 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 916c641b02e2..a21afa56e3f7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -136,6 +136,11 @@ bool mlxsw_core_res_query_enabled(const struct mlxsw_core *mlxsw_core)
 }
 EXPORT_SYMBOL(mlxsw_core_res_query_enabled);
 
+bool mlxsw_core_temp_warn_enabled(const struct mlxsw_core *mlxsw_core)
+{
+	return mlxsw_core->driver->temp_warn_enabled;
+}
+
 bool
 mlxsw_core_fw_rev_minor_subminor_validate(const struct mlxsw_fw_rev *rev,
 					  const struct mlxsw_fw_rev *req_rev)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 3948ad865aba..92f7398287be 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -32,6 +32,8 @@ void *mlxsw_core_driver_priv(struct mlxsw_core *mlxsw_core);
 
 bool mlxsw_core_res_query_enabled(const struct mlxsw_core *mlxsw_core);
 
+bool mlxsw_core_temp_warn_enabled(const struct mlxsw_core *mlxsw_core);
+
 bool
 mlxsw_core_fw_rev_minor_subminor_validate(const struct mlxsw_fw_rev *rev,
 					  const struct mlxsw_fw_rev *req_rev);
@@ -373,6 +375,7 @@ struct mlxsw_driver {
 	const struct mlxsw_config_profile *profile;
 	bool res_query_enabled;
 	bool fw_fatal_enabled;
+	bool temp_warn_enabled;
 };
 
 int mlxsw_core_kvd_sizes_get(struct mlxsw_core *mlxsw_core,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 35ea4d519046..06c04175878b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -306,6 +306,74 @@ int mlxsw_env_get_module_eeprom(struct net_device *netdev,
 }
 EXPORT_SYMBOL(mlxsw_env_get_module_eeprom);
 
+static void mlxsw_env_mtwe_event_func(const struct mlxsw_reg_info *reg,
+				      char *mtwe_pl, void *priv)
+{
+	struct mlxsw_env *mlxsw_env = priv;
+	int i, sensor_warning;
+	bool is_overheat;
+
+	for (i = 0; i < mlxsw_env->module_count; i++) {
+		/* 64-127 of sensor_index are mapped to the port modules
+		 * sequentially (module 0 is mapped to sensor_index 64,
+		 * module 1 to sensor_index 65 and so on)
+		 */
+		sensor_warning =
+			mlxsw_reg_mtwe_sensor_warning_get(mtwe_pl,
+							  i + MLXSW_REG_MTMP_MODULE_INDEX_MIN);
+		spin_lock(&mlxsw_env->module_info_lock);
+		is_overheat =
+			mlxsw_env->module_info[i].is_overheat;
+
+		if ((is_overheat && sensor_warning) ||
+		    (!is_overheat && !sensor_warning)) {
+			/* Current state is "warning" and MTWE still reports
+			 * warning OR current state in "no warning" and MTWE
+			 * does not report warning.
+			 */
+			spin_unlock(&mlxsw_env->module_info_lock);
+			continue;
+		} else if (is_overheat && !sensor_warning) {
+			/* MTWE reports "no warning", turn is_overheat off.
+			 */
+			mlxsw_env->module_info[i].is_overheat = false;
+			spin_unlock(&mlxsw_env->module_info_lock);
+		} else {
+			/* Current state is "no warning" and MTWE reports
+			 * "warning", increase the counter and turn is_overheat
+			 * on.
+			 */
+			mlxsw_env->module_info[i].is_overheat = true;
+			mlxsw_env->module_info[i].module_overheat_counter++;
+			spin_unlock(&mlxsw_env->module_info_lock);
+		}
+	}
+}
+
+static const struct mlxsw_listener mlxsw_env_temp_warn_listener =
+	MLXSW_EVENTL(mlxsw_env_mtwe_event_func, MTWE, MTWE);
+
+static int mlxsw_env_temp_warn_event_register(struct mlxsw_core *mlxsw_core)
+{
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+
+	if (!mlxsw_core_temp_warn_enabled(mlxsw_core))
+		return 0;
+
+	return mlxsw_core_trap_register(mlxsw_core,
+					&mlxsw_env_temp_warn_listener,
+					mlxsw_env);
+}
+
+static void mlxsw_env_temp_warn_event_unregister(struct mlxsw_env *mlxsw_env)
+{
+	if (!mlxsw_core_temp_warn_enabled(mlxsw_env->core))
+		return;
+
+	mlxsw_core_trap_unregister(mlxsw_env->core,
+				   &mlxsw_env_temp_warn_listener, mlxsw_env);
+}
+
 int
 mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 module,
 				      u64 *p_counter)
@@ -352,10 +420,19 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 	env->module_count = module_count;
 	*p_env = env;
 
+	err = mlxsw_env_temp_warn_event_register(mlxsw_core);
+	if (err)
+		goto err_temp_warn_event_register;
+
 	return 0;
+
+err_temp_warn_event_register:
+	kfree(env);
+	return err;
 }
 
 void mlxsw_env_fini(struct mlxsw_env *env)
 {
+	mlxsw_env_temp_warn_event_unregister(env);
 	kfree(env);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 5fb76448ab76..827906c9fdeb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5682,6 +5682,7 @@ MLXSW_ITEM32(reg, htgt, type, 0x00, 8, 4);
 enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_EMAD,
 	MLXSW_REG_HTGT_TRAP_GROUP_MFDE,
+	MLXSW_REG_HTGT_TRAP_GROUP_MTWE,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_STP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_LACP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_LLDP,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 9d5a6f8d7438..2c9c836d45c5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2440,6 +2440,14 @@ static int mlxsw_sp_basic_trap_groups_set(struct mlxsw_core *mlxsw_core)
 			    MLXSW_REG_HTGT_INVALID_POLICER,
 			    MLXSW_REG_HTGT_DEFAULT_PRIORITY,
 			    MLXSW_REG_HTGT_DEFAULT_TC);
+	err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_htgt_pack(htgt_pl, MLXSW_REG_HTGT_TRAP_GROUP_MTWE,
+			    MLXSW_REG_HTGT_INVALID_POLICER,
+			    MLXSW_REG_HTGT_DEFAULT_PRIORITY,
+			    MLXSW_REG_HTGT_DEFAULT_TC);
 	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
 }
 
@@ -3197,6 +3205,7 @@ static struct mlxsw_driver mlxsw_sp1_driver = {
 	.profile			= &mlxsw_sp1_config_profile,
 	.res_query_enabled		= true,
 	.fw_fatal_enabled		= true,
+	.temp_warn_enabled		= true,
 };
 
 static struct mlxsw_driver mlxsw_sp2_driver = {
@@ -3237,6 +3246,7 @@ static struct mlxsw_driver mlxsw_sp2_driver = {
 	.profile			= &mlxsw_sp2_config_profile,
 	.res_query_enabled		= true,
 	.fw_fatal_enabled		= true,
+	.temp_warn_enabled		= true,
 };
 
 static struct mlxsw_driver mlxsw_sp3_driver = {
@@ -3277,6 +3287,7 @@ static struct mlxsw_driver mlxsw_sp3_driver = {
 	.profile			= &mlxsw_sp2_config_profile,
 	.res_query_enabled		= true,
 	.fw_fatal_enabled		= true,
+	.temp_warn_enabled		= true,
 };
 
 bool mlxsw_sp_port_dev_check(const struct net_device *dev)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index fe0b8af287a7..8d73e54f6c29 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -124,6 +124,8 @@ enum mlxsw_event_trap_id {
 	MLXSW_TRAP_ID_MFDE = 0x3,
 	/* Port Up/Down event generated by hardware */
 	MLXSW_TRAP_ID_PUDE = 0x8,
+	/* Temperature Warning event generated by hardware */
+	MLXSW_TRAP_ID_MTWE = 0xC,
 	/* PTP Ingress FIFO has a new entry */
 	MLXSW_TRAP_ID_PTP_ING_FIFO = 0x2D,
 	/* PTP Egress FIFO has a new entry */
-- 
2.26.2

