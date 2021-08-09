Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261483E43D8
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbhHIKXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:23:03 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35949 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234600AbhHIKWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 06:22:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3D4095C0101;
        Mon,  9 Aug 2021 06:22:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 09 Aug 2021 06:22:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=GzlajbeI3bm43rJbD/jbWh989Jdxcvahoqk3zJHsb9A=; b=uf0qV7x6
        IlTGENlT+1Mvzgf46CedI9Px2k+JXQAsDF2c4Zg644YHTjzISN1J6hq0NXFDs/Ql
        sxBdpgJ8bQFfGYiieosEhgaeOhMsZmSWrDUt2E4HTBzb7iydOiCl/3Dz0M/j9J7G
        T0zLqF9G679kQVmadiHz6WZTWMuksZ7hHseEN2MilogqONvR8hTLSxScCmzL7vbm
        ZLE8weL0Ouf4AgB+bjEKsCsxuIUS3FcASVh9xC7M5PY3h6NK+yXd5pGBTQ42A5X6
        iwe85ZdYA9FB418/4kmDNU8Exj5kc0/uOsHp4LkjAc/VqbxXZWfLLoP763XniWWn
        DLeGUkxF2kzOlA==
X-ME-Sender: <xms:6gERYcRzIRLIoIna93FtD19BUDrmoI8uBW1CiiwX6vocuDvwqSjnGw>
    <xme:6gERYZx-5r6h_22HpIbFfWS2WtUDpCvisc7NmbBH3-tGOyUMyj94A4G1_HIvnIGZX
    m_dPFi81cKgHgI>
X-ME-Received: <xmr:6gERYZ1oFFUuiMSTGvOS2ce5e6Tfio65hkg5ZwvfZHMOsUvnEgtJOTsz4LAsRNRG1A1x4Chkm2V2pz3A78luVWhWPh32kIIYvOa9HWAfxQMTqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeejgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedunecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:6gERYQAFTWugoaa0n-BC_yQkMPs0rFanDPivUhvv-wrxI-HwqqEwQQ>
    <xmx:6gERYVjljLrjXegFHvEYqi4G0qyaXWMphu6aCodibUOaabz4FjidrQ>
    <xmx:6gERYcpSEUK_N9i-oCVr3GIYNd1G5adW3DCyDxVisR9OQtuJ0_UZLQ>
    <xmx:6gERYQVSo320zeC5MPtYysnK6BTfvabUbnoqBoElR2wacn8fayn1Fw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Aug 2021 06:22:31 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 7/8] mlxsw: Add ability to control transceiver modules' low power mode
Date:   Mon,  9 Aug 2021 13:21:51 +0300
Message-Id: <20210809102152.719961-8-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210809102152.719961-1-idosch@idosch.org>
References: <20210809102152.719961-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Implement support for ethtool_ops::.get_module_low_power and
ethtool_ops::set_module_low_power.

The get operation is implemented using the Management Cable IO and
Notifications (MCION) register that reports the low power mode status of
the module.

The set operation is implemented using the Port Module Memory Map
Properties (PMMP) register. The register instructs the device's firmware
to transition a plugged-in module to / out of low power mode by writing
to its memory map.

Before using the PMMP register, the module must be disabled by the PMAOS
register. All the ports mapped to the module are iterated to ensure they
are administratively down, so that their operational state will not
change during the operation.

After the operation is performed, the module is re-enabled and its
operational state is polled to ensure the module transitioned back to a
valid state. If not, an error is reported to user space via extack.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 198 ++++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/core_env.h    |   8 +
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  24 +++
 .../mellanox/mlxsw/spectrum_ethtool.c         |  49 +++++
 4 files changed, 279 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 32554910506e..1ae06730d374 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -5,6 +5,7 @@
 #include <linux/err.h>
 #include <linux/ethtool.h>
 #include <linux/sfp.h>
+#include <linux/jiffies.h>
 
 #include "core.h"
 #include "core_env.h"
@@ -389,6 +390,203 @@ mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
 }
 EXPORT_SYMBOL(mlxsw_env_get_module_eeprom_by_page);
 
+int mlxsw_env_get_module_low_power(struct mlxsw_core *mlxsw_core, u8 module,
+				   bool *p_low_power,
+				   struct netlink_ext_ack *extack)
+{
+	char mcion_pl[MLXSW_REG_MCION_LEN];
+	u16 status_bits;
+	int err;
+
+	mlxsw_reg_mcion_pack(mcion_pl, module);
+
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mcion), mcion_pl);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to retrieve module's low power mode");
+		return err;
+	}
+
+	status_bits = mlxsw_reg_mcion_module_status_bits_get(mcion_pl);
+	*p_low_power =
+		status_bits & MLXSW_REG_MCION_MODULE_STATUS_BITS_LOW_POWER_MASK;
+
+	return 0;
+}
+EXPORT_SYMBOL(mlxsw_env_get_module_low_power);
+
+static int mlxsw_env_module_enable_set(struct mlxsw_core *mlxsw_core, u8 module,
+				       bool enable)
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
+static int mlxsw_env_module_error_process(const char *pmaos_pl,
+					  struct netlink_ext_ack *extack)
+{
+	enum mlxsw_reg_pmaos_error_type error_type;
+
+	error_type = mlxsw_reg_pmaos_error_type_get(pmaos_pl);
+	switch (error_type) {
+	case MLXSW_REG_PMAOS_ERROR_TYPE_POWER_BUDGET_EXCEEDED:
+		NL_SET_ERR_MSG_MOD(extack, "Module's power budget exceeded");
+		return -EINVAL;
+	case MLXSW_REG_PMAOS_ERROR_TYPE_BUS_STUCK:
+		NL_SET_ERR_MSG_MOD(extack, "Module's I2C bus is stuck. Data or clock shorted");
+		return -EIO;
+	case MLXSW_REG_PMAOS_ERROR_TYPE_BAD_UNSUPPORTED_EEPROM:
+		NL_SET_ERR_MSG_MOD(extack, "Bad or unsupported module EEPROM");
+		return -EOPNOTSUPP;
+	case MLXSW_REG_PMAOS_ERROR_TYPE_UNSUPPORTED_CABLE:
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported cable");
+		return -EOPNOTSUPP;
+	case MLXSW_REG_PMAOS_ERROR_TYPE_HIGH_TEMP:
+		NL_SET_ERR_MSG_MOD(extack, "Module's temperature is too high");
+		return -EINVAL;
+	case MLXSW_REG_PMAOS_ERROR_TYPE_BAD_CABLE:
+		NL_SET_ERR_MSG_MOD(extack, "Bad module. Module / cable is shorted");
+		return -EINVAL;
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Encountered unknown module error type");
+		return -EINVAL;
+	}
+}
+
+static bool mlxsw_env_module_oper_should_wait(const char *pmaos_pl)
+{
+	enum mlxsw_reg_pmaos_oper_status oper_status;
+
+	oper_status = mlxsw_reg_pmaos_oper_status_get(pmaos_pl);
+	switch (oper_status) {
+	case MLXSW_REG_PMAOS_OPER_STATUS_PLUGGED_ENABLED:
+	case MLXSW_REG_PMAOS_OPER_STATUS_UNPLUGGED:
+		return false;
+	default:
+		/* Module might not be accessible just after its re-enablement,
+		 * so ignore errors or unknown states during this time period.
+		 */
+		return true;
+	}
+}
+
+static int mlxsw_env_module_oper_status_process(const char *pmaos_pl,
+						struct netlink_ext_ack *extack)
+{
+	enum mlxsw_reg_pmaos_oper_status oper_status;
+
+	oper_status = mlxsw_reg_pmaos_oper_status_get(pmaos_pl);
+	switch (oper_status) {
+	case MLXSW_REG_PMAOS_OPER_STATUS_INITIALIZING:
+		NL_SET_ERR_MSG_MOD(extack, "Module is still initializing");
+		return -EBUSY;
+	case MLXSW_REG_PMAOS_OPER_STATUS_PLUGGED_ENABLED:
+	case MLXSW_REG_PMAOS_OPER_STATUS_UNPLUGGED:
+		return 0;
+	case MLXSW_REG_PMAOS_OPER_STATUS_PLUGGED_ERROR:
+		return mlxsw_env_module_error_process(pmaos_pl, extack);
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Encountered unknown module operational status");
+		return -EINVAL;
+	}
+}
+
+/* Firmware should take about 2-3 seconds to initialize the module. */
+#define MLXSW_ENV_MODULE_TIMEOUT_MSECS		5000
+#define MLXSW_ENV_MODULE_WAIT_INTERVAL_MSECS	100
+
+static int mlxsw_env_module_oper_wait(struct mlxsw_core *mlxsw_core, u8 module,
+				      struct netlink_ext_ack *extack)
+{
+	char pmaos_pl[MLXSW_REG_PMAOS_LEN];
+	unsigned long end;
+
+	end = jiffies + msecs_to_jiffies(MLXSW_ENV_MODULE_TIMEOUT_MSECS);
+	do {
+		int err;
+
+		mlxsw_reg_pmaos_pack(pmaos_pl, module);
+		err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(pmaos), pmaos_pl);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to query module's operational status");
+			return err;
+		}
+
+		if (!mlxsw_env_module_oper_should_wait(pmaos_pl))
+			break;
+		msleep(MLXSW_ENV_MODULE_WAIT_INTERVAL_MSECS);
+	} while (time_before(jiffies, end));
+
+	return mlxsw_env_module_oper_status_process(pmaos_pl, extack);
+}
+
+int mlxsw_env_set_module_low_power(struct mlxsw_core *mlxsw_core, u8 module,
+				   bool low_power,
+				   struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = mlxsw_env_module_enable_set(mlxsw_core, module, false);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to disable module");
+		return err;
+	}
+
+	err = mlxsw_env_module_low_power_set(mlxsw_core, module, low_power);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to set module's low power mode");
+		goto err_module_low_power_set;
+	}
+
+	err = mlxsw_env_module_enable_set(mlxsw_core, module, true);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to enable module");
+		goto err_module_enable_set;
+	}
+
+	/* Wait for the module to reach a valid operational state following its
+	 * re-enablement.
+	 */
+	err = mlxsw_env_module_oper_wait(mlxsw_core, module, extack);
+	if (err)
+		goto err_module_oper_wait;
+
+	return 0;
+
+err_module_oper_wait:
+	mlxsw_env_module_enable_set(mlxsw_core, module, false);
+err_module_enable_set:
+	mlxsw_env_module_low_power_set(mlxsw_core, module, !low_power);
+err_module_low_power_set:
+	mlxsw_env_module_enable_set(mlxsw_core, module, true);
+	return err;
+}
+EXPORT_SYMBOL(mlxsw_env_set_module_low_power);
+
 static int mlxsw_env_module_has_temp_sensor(struct mlxsw_core *mlxsw_core,
 					    u8 module,
 					    bool *p_has_temp_sensor)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.h b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
index 0bf5bd0f8a7e..32960de96674 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
@@ -24,6 +24,14 @@ mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
 				    const struct ethtool_module_eeprom *page,
 				    struct netlink_ext_ack *extack);
 
+int mlxsw_env_get_module_low_power(struct mlxsw_core *mlxsw_core, u8 module,
+				   bool *p_low_power,
+				   struct netlink_ext_ack *extack);
+
+int mlxsw_env_set_module_low_power(struct mlxsw_core *mlxsw_core, u8 module,
+				   bool low_power,
+				   struct netlink_ext_ack *extack);
+
 int
 mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 module,
 				      u64 *p_counter);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index d9d56c44e994..6fb8204c4d8a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -124,11 +124,35 @@ mlxsw_m_get_module_eeprom_by_page(struct net_device *netdev,
 						   page, extack);
 }
 
+static int mlxsw_m_get_module_low_power(struct net_device *netdev,
+					bool *p_low_power,
+					struct netlink_ext_ack *extack)
+{
+	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
+	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
+
+	return mlxsw_env_get_module_low_power(core, mlxsw_m_port->module,
+					      p_low_power, extack);
+}
+
+static int mlxsw_m_set_module_low_power(struct net_device *netdev,
+					bool low_power,
+					struct netlink_ext_ack *extack)
+{
+	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
+	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
+
+	return mlxsw_env_set_module_low_power(core, mlxsw_m_port->module,
+					      low_power, extack);
+}
+
 static const struct ethtool_ops mlxsw_m_port_ethtool_ops = {
 	.get_drvinfo		= mlxsw_m_module_get_drvinfo,
 	.get_module_info	= mlxsw_m_get_module_info,
 	.get_module_eeprom	= mlxsw_m_get_module_eeprom,
 	.get_module_eeprom_by_page = mlxsw_m_get_module_eeprom_by_page,
+	.get_module_low_power	= mlxsw_m_get_module_low_power,
+	.set_module_low_power	= mlxsw_m_set_module_low_power,
 };
 
 static int
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 267590a0eee7..fb6256f16c50 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1197,6 +1197,53 @@ mlxsw_sp_get_rmon_stats(struct net_device *dev,
 	*ranges = mlxsw_rmon_ranges;
 }
 
+static int mlxsw_sp_get_module_low_power(struct net_device *dev,
+					 bool *p_low_power,
+					 struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 module = mlxsw_sp_port->mapping.module;
+
+	return mlxsw_env_get_module_low_power(mlxsw_sp->core, module,
+					      p_low_power, extack);
+}
+
+static bool mlxsw_sp_module_ports_up_check(struct mlxsw_sp *mlxsw_sp, u8 module)
+{
+	int i;
+
+	for (i = 1; i < mlxsw_core_max_ports(mlxsw_sp->core); i++) {
+		if (!mlxsw_sp->ports[i])
+			continue;
+		if (mlxsw_sp->ports[i]->mapping.module != module)
+			continue;
+		if (netif_running(mlxsw_sp->ports[i]->dev))
+			return true;
+	}
+
+	return false;
+}
+
+static int mlxsw_sp_set_module_low_power(struct net_device *dev, bool low_power,
+					 struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 module = mlxsw_sp_port->mapping.module;
+
+	/* We are going to take the module down, so no port using it can be
+	 * administratively up.
+	 */
+	if (mlxsw_sp_module_ports_up_check(mlxsw_sp, module)) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot set low power mode when ports using the module are administratively up");
+		return -EINVAL;
+	}
+
+	return mlxsw_env_set_module_low_power(mlxsw_sp->core, module, low_power,
+					      extack);
+}
+
 const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.cap_link_lanes_supported	= true,
 	.get_drvinfo			= mlxsw_sp_port_get_drvinfo,
@@ -1218,6 +1265,8 @@ const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.get_eth_mac_stats		= mlxsw_sp_get_eth_mac_stats,
 	.get_eth_ctrl_stats		= mlxsw_sp_get_eth_ctrl_stats,
 	.get_rmon_stats			= mlxsw_sp_get_rmon_stats,
+	.get_module_low_power		= mlxsw_sp_get_module_low_power,
+	.set_module_low_power		= mlxsw_sp_set_module_low_power,
 };
 
 struct mlxsw_sp1_port_link_mode {
-- 
2.31.1

