Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0A826A117
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 10:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgIOImS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 04:42:18 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36811 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726119AbgIOIl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 04:41:59 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 394645C0062;
        Tue, 15 Sep 2020 04:41:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 15 Sep 2020 04:41:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=zb+1FnOuIgc9DqdHcZK5iWKxKhoic+shO5P7fbKAwU4=; b=R5oIA30+
        yTiXIC8hSKsZNsbAoN+rr3VSLDbnbd6PJ7e3BMhPvstJ/UGtX1UaLfr+x2uVirZ9
        /In97KlBzrNv2Pg0VHTvgNTXydGZbegBjluLOjh7U5geVrxzJAvyuZSKWpejtufF
        bP2BAzAtCEKE5P+4J+z02n7raMje+8h//sSDehWwsP1v6cNlPrwcCyRoJj+qnluM
        c1GpZDmUFJy/qJdwgRGuskGyOnt5cjELDsHpAlalAAwMTibaVFq/o9zYsRLxsfiZ
        YqHRjN2lJBSyOx15iwO7NUbrLRR6+nPygYmhlchxKpAMyllFxdZ8M6Hzg/pKe5KR
        R/EJMRZtgxESHA==
X-ME-Sender: <xms:Vn5gX2bdHnm9mwlXxOMYwmhlIbC5waIk1MMIve7uJrHQdDRodlyE1Q>
    <xme:Vn5gX5YEDCNo0Osb4QN_-wQ3DKkjcGhlieQU1W45dRvArj1llQ88_E6-opPhB8Mcy
    UoH2a7jya5fyj8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeikedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Vn5gXw8Q5f3CC2R8_V8JsbwjuTFF4UbQj1fpHEed49MLr3-HBqpJ-w>
    <xmx:Vn5gX4q8rPseugLl7pxJSZdNvPozp5YickHBnaHKPqcZNDN7NNaWRA>
    <xmx:Vn5gXxoHbBF8oxT9iv6ZtWXPdNG9MBSXmW7FVto3Mkqyb1_Q-qaxRA>
    <xmx:Vn5gX40d40Ct-98Qo-6-wPpfglcsw2G8sys9cp3e2MSPv--Q8YGk3Q>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6059D306468D;
        Tue, 15 Sep 2020 04:41:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 8/8] mlxsw: core: Introduce fw_fatal health reporter
Date:   Tue, 15 Sep 2020 11:40:58 +0300
Message-Id: <20200915084058.18555-9-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915084058.18555-1-idosch@idosch.org>
References: <20200915084058.18555-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Introduce devlink health reporter to report FW fatal events. Implement
the event listener using MFDE trap and enable the events to be
propagated using MFGD register configuration.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 240 ++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   1 +
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   1 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  12 +
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |   2 +
 5 files changed, 256 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 7b5939e068d1..1bb21fe295b9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -84,6 +84,9 @@ struct mlxsw_core {
 	struct mlxsw_core_port *ports;
 	unsigned int max_ports;
 	bool fw_flash_in_progress;
+	struct {
+		struct devlink_health_reporter *fw_fatal;
+	} health;
 	unsigned long driver_priv[];
 	/* driver_priv has to be always the last item */
 };
@@ -1612,6 +1615,236 @@ static void mlxsw_core_params_unregister(struct mlxsw_core *mlxsw_core)
 		mlxsw_core->driver->params_unregister(mlxsw_core);
 }
 
+struct mlxsw_core_health_event {
+	struct mlxsw_core *mlxsw_core;
+	char mfde_pl[MLXSW_REG_MFDE_LEN];
+	struct work_struct work;
+};
+
+static void mlxsw_core_health_event_work(struct work_struct *work)
+{
+	struct mlxsw_core_health_event *event;
+	struct mlxsw_core *mlxsw_core;
+
+	event = container_of(work, struct mlxsw_core_health_event, work);
+	mlxsw_core = event->mlxsw_core;
+	devlink_health_report(mlxsw_core->health.fw_fatal, "FW fatal event occurred",
+			      event->mfde_pl);
+	kfree(event);
+}
+
+static void mlxsw_core_health_listener_func(const struct mlxsw_reg_info *reg,
+					    char *mfde_pl, void *priv)
+{
+	struct mlxsw_core_health_event *event;
+	struct mlxsw_core *mlxsw_core = priv;
+
+	event = kmalloc(sizeof(*event), GFP_ATOMIC);
+	if (!event)
+		return;
+	event->mlxsw_core = mlxsw_core;
+	memcpy(event->mfde_pl, mfde_pl, sizeof(event->mfde_pl));
+	INIT_WORK(&event->work, mlxsw_core_health_event_work);
+	mlxsw_core_schedule_work(&event->work);
+}
+
+static const struct mlxsw_listener mlxsw_core_health_listener =
+	MLXSW_EVENTL(mlxsw_core_health_listener_func, MFDE, MFDE);
+
+static int mlxsw_core_health_fw_fatal_dump(struct devlink_health_reporter *reporter,
+					   struct devlink_fmsg *fmsg, void *priv_ctx,
+					   struct netlink_ext_ack *extack)
+{
+	char *mfde_pl = priv_ctx;
+	char *val_str;
+	u8 event_id;
+	u32 val;
+	int err;
+
+	if (!priv_ctx)
+		/* User-triggered dumps are not possible */
+		return -EOPNOTSUPP;
+
+	val = mlxsw_reg_mfde_irisc_id_get(mfde_pl);
+	err = devlink_fmsg_u8_pair_put(fmsg, "irisc_id", val);
+	if (err)
+		return err;
+	err = devlink_fmsg_arr_pair_nest_start(fmsg, "event");
+	if (err)
+		return err;
+
+	event_id = mlxsw_reg_mfde_event_id_get(mfde_pl);
+	err = devlink_fmsg_u8_pair_put(fmsg, "id", event_id);
+	if (err)
+		return err;
+	switch (event_id) {
+	case MLXSW_REG_MFDE_EVENT_ID_CRSPACE_TO:
+		val_str = "CR space timeout";
+		break;
+	case MLXSW_REG_MFDE_EVENT_ID_KVD_IM_STOP:
+		val_str = "KVD insertion machine stopped";
+		break;
+	default:
+		val_str = NULL;
+	}
+	if (val_str) {
+		err = devlink_fmsg_string_pair_put(fmsg, "desc", val_str);
+		if (err)
+			return err;
+	}
+	err = devlink_fmsg_arr_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	val = mlxsw_reg_mfde_method_get(mfde_pl);
+	switch (val) {
+	case MLXSW_REG_MFDE_METHOD_QUERY:
+		val_str = "query";
+		break;
+	case MLXSW_REG_MFDE_METHOD_WRITE:
+		val_str = "write";
+		break;
+	default:
+		val_str = NULL;
+	}
+	if (val_str) {
+		err = devlink_fmsg_string_pair_put(fmsg, "method", val_str);
+		if (err)
+			return err;
+	}
+
+	val = mlxsw_reg_mfde_long_process_get(mfde_pl);
+	err = devlink_fmsg_bool_pair_put(fmsg, "long_process", val);
+	if (err)
+		return err;
+
+	val = mlxsw_reg_mfde_command_type_get(mfde_pl);
+	switch (val) {
+	case MLXSW_REG_MFDE_COMMAND_TYPE_MAD:
+		val_str = "mad";
+		break;
+	case MLXSW_REG_MFDE_COMMAND_TYPE_EMAD:
+		val_str = "emad";
+		break;
+	case MLXSW_REG_MFDE_COMMAND_TYPE_CMDIF:
+		val_str = "cmdif";
+		break;
+	default:
+		val_str = NULL;
+	}
+	if (val_str) {
+		err = devlink_fmsg_string_pair_put(fmsg, "command_type", val_str);
+		if (err)
+			return err;
+	}
+
+	val = mlxsw_reg_mfde_reg_attr_id_get(mfde_pl);
+	err = devlink_fmsg_u32_pair_put(fmsg, "reg_attr_id", val);
+	if (err)
+		return err;
+
+	if (event_id == MLXSW_REG_MFDE_EVENT_ID_CRSPACE_TO) {
+		val = mlxsw_reg_mfde_log_address_get(mfde_pl);
+		err = devlink_fmsg_u32_pair_put(fmsg, "log_address", val);
+		if (err)
+			return err;
+		val = mlxsw_reg_mfde_log_id_get(mfde_pl);
+		err = devlink_fmsg_u8_pair_put(fmsg, "log_irisc_id", val);
+		if (err)
+			return err;
+	} else if (event_id == MLXSW_REG_MFDE_EVENT_ID_KVD_IM_STOP) {
+		val = mlxsw_reg_mfde_pipes_mask_get(mfde_pl);
+		err = devlink_fmsg_u32_pair_put(fmsg, "pipes_mask", val);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int
+mlxsw_core_health_fw_fatal_test(struct devlink_health_reporter *reporter,
+				struct netlink_ext_ack *extack)
+{
+	struct mlxsw_core *mlxsw_core = devlink_health_reporter_priv(reporter);
+	char mfgd_pl[MLXSW_REG_MFGD_LEN];
+	int err;
+
+	/* Read the register first to make sure no other bits are changed. */
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mfgd), mfgd_pl);
+	if (err)
+		return err;
+	mlxsw_reg_mfgd_trigger_test_set(mfgd_pl, true);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mfgd), mfgd_pl);
+}
+
+static const struct devlink_health_reporter_ops
+mlxsw_core_health_fw_fatal_ops = {
+	.name = "fw_fatal",
+	.dump = mlxsw_core_health_fw_fatal_dump,
+	.test = mlxsw_core_health_fw_fatal_test,
+};
+
+static int mlxsw_core_health_fw_fatal_config(struct mlxsw_core *mlxsw_core,
+					     bool enable)
+{
+	char mfgd_pl[MLXSW_REG_MFGD_LEN];
+	int err;
+
+	/* Read the register first to make sure no other bits are changed. */
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mfgd), mfgd_pl);
+	if (err)
+		return err;
+	mlxsw_reg_mfgd_fatal_event_mode_set(mfgd_pl, enable);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mfgd), mfgd_pl);
+}
+
+static int mlxsw_core_health_init(struct mlxsw_core *mlxsw_core)
+{
+	struct devlink *devlink = priv_to_devlink(mlxsw_core);
+	struct devlink_health_reporter *fw_fatal;
+	int err;
+
+	if (!mlxsw_core->driver->fw_fatal_enabled)
+		return 0;
+
+	fw_fatal = devlink_health_reporter_create(devlink, &mlxsw_core_health_fw_fatal_ops,
+						  0, mlxsw_core);
+	if (IS_ERR(fw_fatal)) {
+		dev_err(mlxsw_core->bus_info->dev, "Failed to create fw fatal reporter");
+		return PTR_ERR(fw_fatal);
+	}
+	mlxsw_core->health.fw_fatal = fw_fatal;
+
+	err = mlxsw_core_trap_register(mlxsw_core, &mlxsw_core_health_listener, mlxsw_core);
+	if (err)
+		goto err_trap_register;
+
+	err = mlxsw_core_health_fw_fatal_config(mlxsw_core, true);
+	if (err)
+		goto err_fw_fatal_config;
+
+	return 0;
+
+err_fw_fatal_config:
+	mlxsw_core_trap_unregister(mlxsw_core, &mlxsw_core_health_listener, mlxsw_core);
+err_trap_register:
+	devlink_health_reporter_destroy(mlxsw_core->health.fw_fatal);
+	return err;
+}
+
+static void mlxsw_core_health_fini(struct mlxsw_core *mlxsw_core)
+{
+	if (!mlxsw_core->driver->fw_fatal_enabled)
+		return;
+
+	mlxsw_core_health_fw_fatal_config(mlxsw_core, false);
+	mlxsw_core_trap_unregister(mlxsw_core, &mlxsw_core_health_listener, mlxsw_core);
+	/* Make sure there is no more event work scheduled */
+	mlxsw_core_flush_owq();
+	devlink_health_reporter_destroy(mlxsw_core->health.fw_fatal);
+}
+
 static int
 __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 				 const struct mlxsw_bus *mlxsw_bus,
@@ -1695,6 +1928,10 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (err)
 		goto err_fw_rev_validate;
 
+	err = mlxsw_core_health_init(mlxsw_core);
+	if (err)
+		goto err_health_init;
+
 	if (mlxsw_driver->init) {
 		err = mlxsw_driver->init(mlxsw_core, mlxsw_bus_info, extack);
 		if (err)
@@ -1723,6 +1960,8 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (mlxsw_core->driver->fini)
 		mlxsw_core->driver->fini(mlxsw_core);
 err_driver_init:
+	mlxsw_core_health_fini(mlxsw_core);
+err_health_init:
 err_fw_rev_validate:
 	if (!reload)
 		mlxsw_core_params_unregister(mlxsw_core);
@@ -1795,6 +2034,7 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 	mlxsw_hwmon_fini(mlxsw_core->hwmon);
 	if (mlxsw_core->driver->fini)
 		mlxsw_core->driver->fini(mlxsw_core);
+	mlxsw_core_health_fini(mlxsw_core);
 	if (!reload)
 		mlxsw_core_params_unregister(mlxsw_core);
 	if (!reload)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 6ec769906637..2ca085a44774 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -370,6 +370,7 @@ struct mlxsw_driver {
 	u8 txhdr_len;
 	const struct mlxsw_config_profile *profile;
 	bool res_query_enabled;
+	bool fw_fatal_enabled;
 };
 
 int mlxsw_core_kvd_sizes_get(struct mlxsw_core *mlxsw_core,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 421f02eac20f..6e3d55006089 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5579,6 +5579,7 @@ MLXSW_ITEM32(reg, htgt, type, 0x00, 8, 4);
 
 enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_EMAD,
+	MLXSW_REG_HTGT_TRAP_GROUP_MFDE,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_STP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_LACP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_LLDP,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 18d2eacfae83..351d385158e6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2529,11 +2529,20 @@ static void mlxsw_sp_lag_fini(struct mlxsw_sp *mlxsw_sp)
 static int mlxsw_sp_basic_trap_groups_set(struct mlxsw_core *mlxsw_core)
 {
 	char htgt_pl[MLXSW_REG_HTGT_LEN];
+	int err;
 
 	mlxsw_reg_htgt_pack(htgt_pl, MLXSW_REG_HTGT_TRAP_GROUP_EMAD,
 			    MLXSW_REG_HTGT_INVALID_POLICER,
 			    MLXSW_REG_HTGT_DEFAULT_PRIORITY,
 			    MLXSW_REG_HTGT_DEFAULT_TC);
+	err =  mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_htgt_pack(htgt_pl, MLXSW_REG_HTGT_TRAP_GROUP_MFDE,
+			    MLXSW_REG_HTGT_INVALID_POLICER,
+			    MLXSW_REG_HTGT_DEFAULT_PRIORITY,
+			    MLXSW_REG_HTGT_DEFAULT_TC);
 	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
 }
 
@@ -3287,6 +3296,7 @@ static struct mlxsw_driver mlxsw_sp1_driver = {
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp1_config_profile,
 	.res_query_enabled		= true,
+	.fw_fatal_enabled		= true,
 };
 
 static struct mlxsw_driver mlxsw_sp2_driver = {
@@ -3326,6 +3336,7 @@ static struct mlxsw_driver mlxsw_sp2_driver = {
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp2_config_profile,
 	.res_query_enabled		= true,
+	.fw_fatal_enabled		= true,
 };
 
 static struct mlxsw_driver mlxsw_sp3_driver = {
@@ -3365,6 +3376,7 @@ static struct mlxsw_driver mlxsw_sp3_driver = {
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp2_config_profile,
 	.res_query_enabled		= true,
+	.fw_fatal_enabled		= true,
 };
 
 bool mlxsw_sp_port_dev_check(const struct net_device *dev)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 33909887d0ac..fe0b8af287a7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -120,6 +120,8 @@ enum {
 };
 
 enum mlxsw_event_trap_id {
+	/* Fatal Event generated by FW */
+	MLXSW_TRAP_ID_MFDE = 0x3,
 	/* Port Up/Down event generated by hardware */
 	MLXSW_TRAP_ID_PUDE = 0x8,
 	/* PTP Ingress FIFO has a new entry */
-- 
2.26.2

