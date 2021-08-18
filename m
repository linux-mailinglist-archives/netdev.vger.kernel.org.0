Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296D93F087D
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 17:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240253AbhHRPxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:53:32 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:46849 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240117AbhHRPx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 11:53:26 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id 1B6AB582FFB;
        Wed, 18 Aug 2021 11:52:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 18 Aug 2021 11:52:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=QlCPYokOeVa5U2IFoO2iOQtdoH0BhMCMm1R6BOmmHgI=; b=q++x3xwb
        qUIfdYQtta/B2WVmwHzaIMAcIzlJzfz/khuYbHKkdcFBqR9wkkeJ9ItfarVgVMqR
        XgrHiGpeEgB4Q1ANdHyCrPA6mlaHQClEqgL60wdZbXA8F77FjjxPQvvjiLNp9/gA
        TS49pVhnxQUwZkII6txCuWscNrnlzP0uI3qOLeEFZIxLBDn7Pz9lIEsJd9X1+cuC
        woO27dR1MJeoGtd3ZFQHdxGXY+5OQgoILJ+/aqWuR6g8hFidSN027AGQhn7e8jPX
        /7CG24QFO7JWPWDLtzwk5lUcIf+vf0vFLVQo/K7gr2SnI8E14TW2UkDVIbFYKKDv
        OqjOBGKzJsgnaQ==
X-ME-Sender: <xms:0iwdYfJvs06H06SUM3Vv6YZUZnAWjGYx9_1j2PY4B1TBkB_mV5hI7g>
    <xme:0iwdYTIyCBB7rhZG8RTnXNdSCbHWSKkqiLGV5_el71rGHqT3PldejCl5YTeV-oJaD
    6JU04BKC1uXsgI>
X-ME-Received: <xmr:0iwdYXujDsoGBgqjt6UwAmjwTLFOgPMfRM0fysVwOebNIA3pOZziD0EQi_FN9fX2L9r2iKSGVNzV6r_CeN1jBlp19WLv_nnLrgowLIkW5KCbLQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleehgdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:0ywdYYaJY9Paky1ultwtUc1OQ3u-L9Lq0K-PvS5r4DkMuo1b3QMZ0Q>
    <xmx:0ywdYWa2u6YS5UmM8rNrgonBRSI62-tJYIssTJCinArdg3cQRAd8iA>
    <xmx:0ywdYcDpur6P5_X786ZscpxpPD-MJNqnnB6De_nLR_F_iP4tgP2yYQ>
    <xmx:0ywdYcNgadYsGgKDSDPwEpVMJe5xJa8eaDCeR_wPL2mEsGfhsjrF7w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Aug 2021 11:52:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v2 4/6] mlxsw: Add ability to control transceiver modules' power mode
Date:   Wed, 18 Aug 2021 18:52:00 +0300
Message-Id: <20210818155202.1278177-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818155202.1278177-1-idosch@idosch.org>
References: <20210818155202.1278177-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Implement support for ethtool_ops::.get_module_power_mode and
ethtool_ops::set_module_power_mode.

The get operation is implemented using the Management Cable IO and
Notifications (MCION) register that reports the operational power mode
of the module and its presence. In case a module is not present, its
operational power mode is not reported to ethtool and user space. If not
set before, the power mode policy is reported as "high", which is the
default on Mellanox systems.

The set operation is implemented using the Port Module Memory Map
Properties (PMMP) register. The register instructs the device's firmware
to transition a plugged-in module to / out of low power mode by writing
to its memory map.

Before setting the power mode, the per-module 'num_ports_up' counter is
consulted to ensure no ports mapped to the module are administratively
up, so that their operational state will not change during the
operation.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 193 +++++++++++++++++-
 .../net/ethernet/mellanox/mlxsw/core_env.h    |  10 +
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  26 +++
 .../mellanox/mlxsw/spectrum_ethtool.c         |  28 +++
 4 files changed, 254 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 9e367174743d..f7df37536ca4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -17,6 +17,7 @@ struct mlxsw_env_module_info {
 	bool is_overheat;
 	int num_ports_mapped;
 	int num_ports_up;
+	enum ethtool_module_power_mode_policy power_mode_policy;
 };
 
 struct mlxsw_env {
@@ -445,6 +446,152 @@ int mlxsw_env_reset_module(struct net_device *netdev,
 }
 EXPORT_SYMBOL(mlxsw_env_reset_module);
 
+int
+mlxsw_env_get_module_power_mode(struct mlxsw_core *mlxsw_core, u8 module,
+				struct ethtool_module_power_mode_params *params,
+				struct netlink_ext_ack *extack)
+{
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+	char mcion_pl[MLXSW_REG_MCION_LEN];
+	u32 status_bits;
+	int err;
+
+	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
+		return -EINVAL;
+
+	mutex_lock(&mlxsw_env->module_info_lock);
+
+	params->policy = mlxsw_env->module_info[module].power_mode_policy;
+
+	mlxsw_reg_mcion_pack(mcion_pl, module);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mcion), mcion_pl);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to retrieve module's power mode");
+		goto out;
+	}
+
+	status_bits = mlxsw_reg_mcion_module_status_bits_get(mcion_pl);
+	if (!(status_bits & MLXSW_REG_MCION_MODULE_STATUS_BITS_PRESENT_MASK))
+		goto out;
+
+	if (status_bits & MLXSW_REG_MCION_MODULE_STATUS_BITS_LOW_POWER_MASK)
+		params->mode = ETHTOOL_MODULE_POWER_MODE_LOW;
+	else
+		params->mode = ETHTOOL_MODULE_POWER_MODE_HIGH;
+
+	params->mode_valid = true;
+
+out:
+	mutex_unlock(&mlxsw_env->module_info_lock);
+	return err;
+}
+EXPORT_SYMBOL(mlxsw_env_get_module_power_mode);
+
+static int mlxsw_env_module_enable_set(struct mlxsw_core *mlxsw_core,
+				       u8 module, bool enable)
+{
+	enum mlxsw_reg_pmaos_admin_status admin_status;
+	char pmaos_pl[MLXSW_REG_PMAOS_LEN];
+
+	mlxsw_reg_pmaos_pack(pmaos_pl, module);
+	admin_status = enable ? MLXSW_REG_PMAOS_ADMIN_STATUS_ENABLED :
+				MLXSW_REG_PMAOS_ADMIN_STATUS_DISABLED;
+	mlxsw_reg_pmaos_admin_status_set(pmaos_pl, admin_status);
+	mlxsw_reg_pmaos_ase_set(pmaos_pl, true);
+
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(pmaos), pmaos_pl);
+}
+
+static int mlxsw_env_module_low_power_set(struct mlxsw_core *mlxsw_core,
+					  u8 module, bool low_power)
+{
+	u16 eeprom_override_mask, eeprom_override;
+	char pmmp_pl[MLXSW_REG_PMMP_LEN];
+
+	mlxsw_reg_pmmp_pack(pmmp_pl, module);
+	/* Mask all the bits except low power mode. */
+	eeprom_override_mask = ~MLXSW_REG_PMMP_EEPROM_OVERRIDE_LOW_POWER_MASK;
+	mlxsw_reg_pmmp_eeprom_override_mask_set(pmmp_pl, eeprom_override_mask);
+	eeprom_override = low_power ? MLXSW_REG_PMMP_EEPROM_OVERRIDE_LOW_POWER_MASK :
+				      0;
+	mlxsw_reg_pmmp_eeprom_override_set(pmmp_pl, eeprom_override);
+
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(pmmp), pmmp_pl);
+}
+
+static int __mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core,
+					     u8 module, bool low_power,
+					     struct netlink_ext_ack *extack)
+{
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+	int err;
+
+	if (mlxsw_env->module_info[module].num_ports_up) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot set module's power mode when ports using it are administratively up");
+		return -EINVAL;
+	}
+
+	err = mlxsw_env_module_enable_set(mlxsw_core, module, false);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to disable module");
+		return err;
+	}
+
+	err = mlxsw_env_module_low_power_set(mlxsw_core, module, low_power);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to set module's power mode");
+		goto err_module_low_power_set;
+	}
+
+	err = mlxsw_env_module_enable_set(mlxsw_core, module, true);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to enable module");
+		goto err_module_enable_set;
+	}
+
+	return 0;
+
+err_module_enable_set:
+	mlxsw_env_module_low_power_set(mlxsw_core, module, !low_power);
+err_module_low_power_set:
+	mlxsw_env_module_enable_set(mlxsw_core, module, true);
+	return err;
+}
+
+int
+mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core, u8 module,
+				enum ethtool_module_power_mode_policy policy,
+				struct netlink_ext_ack *extack)
+{
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+	bool low_power;
+	int err;
+
+	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
+		return -EINVAL;
+
+	if (policy != ETHTOOL_MODULE_POWER_MODE_POLICY_LOW &&
+	    policy != ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH &&
+	    policy != ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported power mode policy");
+		return -EOPNOTSUPP;
+	}
+
+	mutex_lock(&mlxsw_env->module_info_lock);
+
+	low_power = policy != ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH;
+	err = __mlxsw_env_set_module_power_mode(mlxsw_core, module, low_power,
+						extack);
+	if (err)
+		goto out;
+
+	mlxsw_env->module_info[module].power_mode_policy = policy;
+out:
+	mutex_unlock(&mlxsw_env->module_info_lock);
+	return err;
+}
+EXPORT_SYMBOL(mlxsw_env_set_module_power_mode);
+
 static int mlxsw_env_module_has_temp_sensor(struct mlxsw_core *mlxsw_core,
 					    u8 module,
 					    bool *p_has_temp_sensor)
@@ -794,15 +941,33 @@ EXPORT_SYMBOL(mlxsw_env_module_port_unmap);
 int mlxsw_env_module_port_up(struct mlxsw_core *mlxsw_core, u8 module)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+	int err = 0;
 
 	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
 		return -EINVAL;
 
 	mutex_lock(&mlxsw_env->module_info_lock);
+
+	if (mlxsw_env->module_info[module].power_mode_policy !=
+	    ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP)
+		goto out_inc;
+
+	if (mlxsw_env->module_info[module].num_ports_up != 0)
+		goto out_inc;
+
+	/* Transition to high power mode following first port using the module
+	 * being put administratively up.
+	 */
+	err = __mlxsw_env_set_module_power_mode(mlxsw_core, module, false,
+						NULL);
+	if (err)
+		goto out_unlock;
+
+out_inc:
 	mlxsw_env->module_info[module].num_ports_up++;
+out_unlock:
 	mutex_unlock(&mlxsw_env->module_info_lock);
-
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL(mlxsw_env_module_port_up);
 
@@ -814,7 +979,22 @@ void mlxsw_env_module_port_down(struct mlxsw_core *mlxsw_core, u8 module)
 		return;
 
 	mutex_lock(&mlxsw_env->module_info_lock);
+
 	mlxsw_env->module_info[module].num_ports_up--;
+
+	if (mlxsw_env->module_info[module].power_mode_policy !=
+	    ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP)
+		goto out_unlock;
+
+	if (mlxsw_env->module_info[module].num_ports_up != 0)
+		goto out_unlock;
+
+	/* Transition to low power mode following last port using the module
+	 * being put administratively down.
+	 */
+	__mlxsw_env_set_module_power_mode(mlxsw_core, module, true, NULL);
+
+out_unlock:
 	mutex_unlock(&mlxsw_env->module_info_lock);
 }
 EXPORT_SYMBOL(mlxsw_env_module_port_down);
@@ -824,7 +1004,7 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
 	struct mlxsw_env *env;
 	u8 module_count;
-	int err;
+	int i, err;
 
 	mlxsw_reg_mgpir_pack(mgpir_pl);
 	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mgpir), mgpir_pl);
@@ -837,6 +1017,13 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 	if (!env)
 		return -ENOMEM;
 
+	/* Firmware defaults to high power mode policy where modules are
+	 * transitioned to high power mode following plug-in.
+	 */
+	for (i = 0; i < module_count; i++)
+		env->module_info[i].power_mode_policy =
+			ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH;
+
 	mutex_init(&env->module_info_lock);
 	env->core = mlxsw_core;
 	env->module_count = module_count;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.h b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
index c486397f5dfe..da121b1a84b4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
@@ -28,6 +28,16 @@ int mlxsw_env_reset_module(struct net_device *netdev,
 			   struct mlxsw_core *mlxsw_core, u8 module,
 			   u32 *flags);
 
+int
+mlxsw_env_get_module_power_mode(struct mlxsw_core *mlxsw_core, u8 module,
+				struct ethtool_module_power_mode_params *params,
+				struct netlink_ext_ack *extack);
+
+int
+mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core, u8 module,
+				enum ethtool_module_power_mode_policy policy,
+				struct netlink_ext_ack *extack);
+
 int
 mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 module,
 				      u64 *p_counter);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index 9644e9c486b8..e0892f259adf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -145,12 +145,38 @@ static int mlxsw_m_reset(struct net_device *netdev, u32 *flags)
 				      flags);
 }
 
+static int
+mlxsw_m_get_module_power_mode(struct net_device *netdev,
+			      struct ethtool_module_power_mode_params *params,
+			      struct netlink_ext_ack *extack)
+{
+	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
+	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
+
+	return mlxsw_env_get_module_power_mode(core, mlxsw_m_port->module,
+					       params, extack);
+}
+
+static int
+mlxsw_m_set_module_power_mode(struct net_device *netdev,
+			      const struct ethtool_module_power_mode_params *params,
+			      struct netlink_ext_ack *extack)
+{
+	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
+	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
+
+	return mlxsw_env_set_module_power_mode(core, mlxsw_m_port->module,
+					       params->policy, extack);
+}
+
 static const struct ethtool_ops mlxsw_m_port_ethtool_ops = {
 	.get_drvinfo		= mlxsw_m_module_get_drvinfo,
 	.get_module_info	= mlxsw_m_get_module_info,
 	.get_module_eeprom	= mlxsw_m_get_module_eeprom,
 	.get_module_eeprom_by_page = mlxsw_m_get_module_eeprom_by_page,
 	.reset			= mlxsw_m_reset,
+	.get_module_power_mode	= mlxsw_m_get_module_power_mode,
+	.set_module_power_mode	= mlxsw_m_set_module_power_mode,
 };
 
 static int
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 06f1645561c6..7329bc84a8ee 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1206,6 +1206,32 @@ static int mlxsw_sp_reset(struct net_device *dev, u32 *flags)
 	return mlxsw_env_reset_module(dev, mlxsw_sp->core, module, flags);
 }
 
+static int
+mlxsw_sp_get_module_power_mode(struct net_device *dev,
+			       struct ethtool_module_power_mode_params *params,
+			       struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 module = mlxsw_sp_port->mapping.module;
+
+	return mlxsw_env_get_module_power_mode(mlxsw_sp->core, module, params,
+					       extack);
+}
+
+static int
+mlxsw_sp_set_module_power_mode(struct net_device *dev,
+			       const struct ethtool_module_power_mode_params *params,
+			       struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 module = mlxsw_sp_port->mapping.module;
+
+	return mlxsw_env_set_module_power_mode(mlxsw_sp->core, module,
+					       params->policy, extack);
+}
+
 const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.cap_link_lanes_supported	= true,
 	.get_drvinfo			= mlxsw_sp_port_get_drvinfo,
@@ -1228,6 +1254,8 @@ const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.get_eth_ctrl_stats		= mlxsw_sp_get_eth_ctrl_stats,
 	.get_rmon_stats			= mlxsw_sp_get_rmon_stats,
 	.reset				= mlxsw_sp_reset,
+	.get_module_power_mode		= mlxsw_sp_get_module_power_mode,
+	.set_module_power_mode		= mlxsw_sp_set_module_power_mode,
 };
 
 struct mlxsw_sp1_port_link_mode {
-- 
2.31.1

