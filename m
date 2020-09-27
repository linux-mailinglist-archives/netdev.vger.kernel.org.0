Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECF9279F68
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730531AbgI0HvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:51:05 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:45303 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730471AbgI0HvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 03:51:01 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 5346946D;
        Sun, 27 Sep 2020 03:50:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 27 Sep 2020 03:50:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=SkEQ5kHgpdFkzdNTHguQb/+uZy/WdSg5+TMep1N7U9w=; b=kVr7RqoD
        sZw4q+Y8Yox/I5IQGM8XLCwQiIP9OvY9WiUlwJatgxWwyQR5gMxEiwf/G+FWGjbW
        1wCdMZ3JYTwEwfYuKaEmcGJYX0GWsPul85/LOjqMHVgw5QIeKlSuA/+m1KXK00BA
        /Koig5cvkNEGGI/zv82ckqDrhWKXTSoxCAV9pmnMAOw2+okPoPIiUHfgpHQfRsl7
        +kKX72m1XBKK0ONXNkITNtE73Ame5qzLOSk/4me+JtssfzIZgGO0xT6xEdEQkaNM
        w/AdlfI2tFpa4LBoHyL9V1Ayv8gNgQB7VRr38sOSGDurrPx32T1ILbOubKU47X76
        Egyc9Ql44V4Xcg==
X-ME-Sender: <xms:YkRwX55fUAZYho0ZKrtd_GtcOaRgKux0UhR11bBra7iNktThxxOyCQ>
    <xme:YkRwX27Gvlfp8JIj77FtEp9I0dlafJI2UZnuw_MVcLeBgnayIgqqtkv17syP8WzuN
    sEDLCmBQgTRsKI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeejrddugeek
    necuvehluhhsthgvrhfuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:YkRwXwepSQvA_UoYCyO8vLdd_zMAj-qq0mWXKuT1DcSkJxxtwf77CA>
    <xmx:YkRwXyKukCXTJ1yrOqJbTbtbzH7in2F2ccupj7v053Ff_hAx5_T88g>
    <xmx:YkRwX9J0qDr-ls5uRrwd1wEdo06L0Ee3e_WIyZMZjNUqB3FMqBZy_w>
    <xmx:YkRwX93mMTsehxkS8MGQZGqUMLo8aI4zWyjLs6TW2kuzQ7oYe6JbNA>
Received: from shredder.lan (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 297F73280059;
        Sun, 27 Sep 2020 03:50:57 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/10] mlxsw: Update module's settings when module is plugged in
Date:   Sun, 27 Sep 2020 10:50:14 +0300
Message-Id: <20200927075015.1417714-10-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200927075015.1417714-1-idosch@idosch.org>
References: <20200927075015.1417714-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Module temperature warning events are enabled for modules that have a
temperature sensor and configured according to the temperature
thresholds queried from the module.

When a module is unplugged we are guaranteed not to get temperature
warning events. However, when a module is plugged in we need to
potentially update its current settings (i.e., event enablement and
thresholds).

Register to port module plug/unplug events and update module's settings
upon plug in events.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 126 ++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   1 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   8 ++
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |   2 +
 4 files changed, 137 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 63dd1fb58381..dd26865bd587 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -467,6 +467,117 @@ static void mlxsw_env_temp_warn_event_unregister(struct mlxsw_env *mlxsw_env)
 				   &mlxsw_env_temp_warn_listener, mlxsw_env);
 }
 
+struct mlxsw_env_module_plug_unplug_event {
+	struct mlxsw_env *mlxsw_env;
+	u8 module;
+	struct work_struct work;
+};
+
+static void mlxsw_env_pmpe_event_work(struct work_struct *work)
+{
+	struct mlxsw_env_module_plug_unplug_event *event;
+	struct mlxsw_env *mlxsw_env;
+	bool has_temp_sensor;
+	u16 sensor_index;
+	int err;
+
+	event = container_of(work, struct mlxsw_env_module_plug_unplug_event,
+			     work);
+	mlxsw_env = event->mlxsw_env;
+
+	spin_lock_bh(&mlxsw_env->module_info_lock);
+	mlxsw_env->module_info[event->module].is_overheat = false;
+	spin_unlock_bh(&mlxsw_env->module_info_lock);
+
+	err = mlxsw_env_module_has_temp_sensor(mlxsw_env->core, event->module,
+					       &has_temp_sensor);
+	/* Do not disable events on modules without sensors or faulty sensors
+	 * because FW returns errors.
+	 */
+	if (err)
+		goto out;
+
+	if (!has_temp_sensor)
+		goto out;
+
+	sensor_index = event->module + MLXSW_REG_MTMP_MODULE_INDEX_MIN;
+	mlxsw_env_temp_event_set(mlxsw_env->core, sensor_index, true);
+
+out:
+	kfree(event);
+}
+
+static void
+mlxsw_env_pmpe_listener_func(const struct mlxsw_reg_info *reg, char *pmpe_pl,
+			     void *priv)
+{
+	struct mlxsw_env_module_plug_unplug_event *event;
+	enum mlxsw_reg_pmpe_module_status module_status;
+	u8 module = mlxsw_reg_pmpe_module_get(pmpe_pl);
+	struct mlxsw_env *mlxsw_env = priv;
+
+	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
+		return;
+
+	module_status = mlxsw_reg_pmpe_module_status_get(pmpe_pl);
+	if (module_status != MLXSW_REG_PMPE_MODULE_STATUS_PLUGGED_ENABLED)
+		return;
+
+	event = kmalloc(sizeof(*event), GFP_ATOMIC);
+	if (!event)
+		return;
+
+	event->mlxsw_env = mlxsw_env;
+	event->module = module;
+	INIT_WORK(&event->work, mlxsw_env_pmpe_event_work);
+	mlxsw_core_schedule_work(&event->work);
+}
+
+static const struct mlxsw_listener mlxsw_env_module_plug_listener =
+	MLXSW_EVENTL(mlxsw_env_pmpe_listener_func, PMPE, PMPE);
+
+static int
+mlxsw_env_module_plug_event_register(struct mlxsw_core *mlxsw_core)
+{
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+
+	if (!mlxsw_core_temp_warn_enabled(mlxsw_core))
+		return 0;
+
+	return mlxsw_core_trap_register(mlxsw_core,
+					&mlxsw_env_module_plug_listener,
+					mlxsw_env);
+}
+
+static void
+mlxsw_env_module_plug_event_unregister(struct mlxsw_env *mlxsw_env)
+{
+	if (!mlxsw_core_temp_warn_enabled(mlxsw_env->core))
+		return;
+
+	mlxsw_core_trap_unregister(mlxsw_env->core,
+				   &mlxsw_env_module_plug_listener,
+				   mlxsw_env);
+}
+
+static int
+mlxsw_env_module_oper_state_event_enable(struct mlxsw_core *mlxsw_core,
+					 u8 module_count)
+{
+	int i, err;
+
+	for (i = 0; i < module_count; i++) {
+		char pmaos_pl[MLXSW_REG_PMAOS_LEN];
+
+		mlxsw_reg_pmaos_pack(pmaos_pl, i,
+				     MLXSW_REG_PMAOS_E_GENERATE_EVENT);
+		err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(pmaos), pmaos_pl);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 int
 mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 module,
 				      u64 *p_counter)
@@ -517,6 +628,15 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 	if (err)
 		goto err_temp_warn_event_register;
 
+	err = mlxsw_env_module_plug_event_register(mlxsw_core);
+	if (err)
+		goto err_module_plug_event_register;
+
+	err = mlxsw_env_module_oper_state_event_enable(mlxsw_core,
+						       env->module_count);
+	if (err)
+		goto err_oper_state_event_enable;
+
 	err = mlxsw_env_module_temp_event_enable(mlxsw_core, env->module_count);
 	if (err)
 		goto err_temp_event_enable;
@@ -524,6 +644,9 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 	return 0;
 
 err_temp_event_enable:
+err_oper_state_event_enable:
+	mlxsw_env_module_plug_event_unregister(env);
+err_module_plug_event_register:
 	mlxsw_env_temp_warn_event_unregister(env);
 err_temp_warn_event_register:
 	kfree(env);
@@ -532,6 +655,9 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 
 void mlxsw_env_fini(struct mlxsw_env *env)
 {
+	mlxsw_env_module_plug_event_unregister(env);
+	/* Make sure there is no more event work scheduled. */
+	mlxsw_core_flush_owq();
 	mlxsw_env_temp_warn_event_unregister(env);
 	kfree(env);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index e8415589d4fb..39eff6a57ba2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5683,6 +5683,7 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_EMAD,
 	MLXSW_REG_HTGT_TRAP_GROUP_MFDE,
 	MLXSW_REG_HTGT_TRAP_GROUP_MTWE,
+	MLXSW_REG_HTGT_TRAP_GROUP_PMPE,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_STP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_LACP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_LLDP,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 25b1ab1cfa68..ab7d12aad880 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2473,6 +2473,14 @@ static int mlxsw_sp_basic_trap_groups_set(struct mlxsw_core *mlxsw_core)
 			    MLXSW_REG_HTGT_INVALID_POLICER,
 			    MLXSW_REG_HTGT_DEFAULT_PRIORITY,
 			    MLXSW_REG_HTGT_DEFAULT_TC);
+	err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_htgt_pack(htgt_pl, MLXSW_REG_HTGT_TRAP_GROUP_PMPE,
+			    MLXSW_REG_HTGT_INVALID_POLICER,
+			    MLXSW_REG_HTGT_DEFAULT_PRIORITY,
+			    MLXSW_REG_HTGT_DEFAULT_TC);
 	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 8d73e54f6c29..57f9e24602d0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -124,6 +124,8 @@ enum mlxsw_event_trap_id {
 	MLXSW_TRAP_ID_MFDE = 0x3,
 	/* Port Up/Down event generated by hardware */
 	MLXSW_TRAP_ID_PUDE = 0x8,
+	/* Port Module Plug/Unplug Event generated by hardware */
+	MLXSW_TRAP_ID_PMPE = 0x9,
 	/* Temperature Warning event generated by hardware */
 	MLXSW_TRAP_ID_MTWE = 0xC,
 	/* PTP Ingress FIFO has a new entry */
-- 
2.26.2

