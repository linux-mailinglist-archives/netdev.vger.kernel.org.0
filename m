Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64FF40C377
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 12:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237562AbhIOKPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 06:15:11 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56745 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237517AbhIOKPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 06:15:05 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id ED8485C019C;
        Wed, 15 Sep 2021 06:13:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 15 Sep 2021 06:13:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=sKyijMCe6aAeeVBJA1hDgmIN0xrQYHQcy9HeuRG36aE=; b=MGsrur+D
        gcMbD3db9rmrnrcRa5h/2ofUKaMxvX0Xo+xZ29visLMJ+pOIogvJkymO0zpiCKmq
        Q+xdgZgA7mDGNqmBpjxtLCAv1jqCXMSjwj/fWkLUiZheKgl+tj1cCzm2/dWSIUNp
        AernvBqz6qJnCfWTgJAYOBOUofDS81+xQVeJp4ACpiNazNJkWtYidJQierIBDqu1
        t3sTykcN3h9fYKjMIGc5Hc7tAtH/N73kmRNtskoi2zCrsb9Yf8SYTJpDyiKm4efY
        DIDkjyY3xZwuO8HOlXgxy9Tdzkvhb24vgJLahCb28hR7h5wYKlm8EX8o6qokPEr+
        pR6WezsO3bgaug==
X-ME-Sender: <xms:WsdBYaKpQcz9-c7nxfoVCSw2edAZpSwQQXOTXnI8tYViJG_z7SMTEA>
    <xme:WsdBYSLiqhtC9jZsqfsUKdIyfAReyZgu8afqWzRRqijj5dcTZiJBEpY36gJi9LSqn
    FLTHcpNUtBKGes>
X-ME-Received: <xmr:WsdBYasspTnz7sUmO_cafcf_MFHPvnocIqAgHyxBYuuBmQjLuU1SK5vGp1TiwGjJ7pPTwOzRsx3FFxl06QdZJhEIfRSgNOfBgg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehuddgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:WsdBYfYS_a0NKvb5QkR7dJbwSkt7IaPfLoyyXkPYfuO5bxggKRINtw>
    <xmx:WsdBYRbb1X4dfEpYlcTGidW8rV5bN9Aa4MoVitoeJKgut4AmgXzlFQ>
    <xmx:WsdBYbCoErFTv0tkqrgQLUI_zWD1v0lv8arGA15iugUu2-WnxWwbOA>
    <xmx:WsdBYUzyP9xaG4Np6WLTux-_NsUA0M2TZ6NVSyOXeKiWiaaFwUyhOg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Sep 2021 06:13:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/10] mlxsw: Add support for transceiver modules reset
Date:   Wed, 15 Sep 2021 13:13:14 +0300
Message-Id: <20210915101314.407476-11-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915101314.407476-1-idosch@idosch.org>
References: <20210915101314.407476-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Implement support for ethtool_ops::reset in order to reset transceiver
modules. The module backing the netdev is reset when the 'ETH_RESET_PHY'
flag is set. After a successful reset, the flag is cleared by the driver
and other flags are ignored. This is in accordance with the interface
documentation:

"The reset() operation must clear the flags for the components which
were actually reset. On successful return, the flags indicate the
components which were not reset, either because they do not exist in the
hardware or because they cannot be reset independently. The driver must
never reset any components that were not requested."

Reset is useful in order to allow a module to transition out of a fault
state. From section 6.3.2.12 in CMIS 5.0: "Except for a power cycle, the
only exit path from the ModuleFault state is to perform a module reset
by taking an action that causes the ResetS transition signal to become
TRUE (see Table 6-11)".

An error is returned when the netdev is administratively up:

 # ip link set dev swp11 up

 # ethtool --reset swp11 phy
 ETHTOOL_RESET 0x40
 Cannot issue ETHTOOL_RESET: Invalid argument

 # ip link set dev swp11 down

 # ethtool --reset swp11 phy
 ETHTOOL_RESET 0x40
 Components reset:     0x40

An error is returned when the module is shared by multiple ports (split
ports) and the "phy-shared" flag is not set:

 # devlink port split swp11 count 4

 # ethtool --reset swp11s0 phy
 ETHTOOL_RESET 0x40
 Cannot issue ETHTOOL_RESET: Invalid argument

 # ethtool --reset swp11s0 phy-shared
 ETHTOOL_RESET 0x400000
 Components reset:     0x400000

 # devlink port unsplit swp11s0

 # ethtool --reset swp11 phy
 ETHTOOL_RESET 0x40
 Components reset:     0x40

An error is also returned when one of the ports using the module is
administratively up:

 # devlink port split swp11 count 4

 # ip link set dev swp11s1 up

 # ethtool --reset swp11s0 phy-shared
 ETHTOOL_RESET 0x400000
 Cannot issue ETHTOOL_RESET: Invalid argument

 # ip link set dev swp11s1 down

 # ethtool --reset swp11s0 phy-shared
 ETHTOOL_RESET 0x400000
 Components reset:     0x400000

Reset is performed by writing to the "rst" bit of the PMAOS register,
which instructs the firmware to assert the reset signal connected to the
module for a fixed amount of time.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 53 +++++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/core_env.h    |  4 ++
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 10 ++++
 .../mellanox/mlxsw/spectrum_ethtool.c         | 10 ++++
 4 files changed, 77 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index a474629643aa..9e367174743d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -392,6 +392,59 @@ mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
 }
 EXPORT_SYMBOL(mlxsw_env_get_module_eeprom_by_page);
 
+static int mlxsw_env_module_reset(struct mlxsw_core *mlxsw_core, u8 module)
+{
+	char pmaos_pl[MLXSW_REG_PMAOS_LEN];
+
+	mlxsw_reg_pmaos_pack(pmaos_pl, module);
+	mlxsw_reg_pmaos_rst_set(pmaos_pl, true);
+
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(pmaos), pmaos_pl);
+}
+
+int mlxsw_env_reset_module(struct net_device *netdev,
+			   struct mlxsw_core *mlxsw_core, u8 module, u32 *flags)
+{
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+	u32 req = *flags;
+	int err;
+
+	if (!(req & ETH_RESET_PHY) &&
+	    !(req & (ETH_RESET_PHY << ETH_RESET_SHARED_SHIFT)))
+		return 0;
+
+	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
+		return -EINVAL;
+
+	mutex_lock(&mlxsw_env->module_info_lock);
+
+	if (mlxsw_env->module_info[module].num_ports_up) {
+		netdev_err(netdev, "Cannot reset module when ports using it are administratively up\n");
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (mlxsw_env->module_info[module].num_ports_mapped > 1 &&
+	    !(req & (ETH_RESET_PHY << ETH_RESET_SHARED_SHIFT))) {
+		netdev_err(netdev, "Cannot reset module without \"phy-shared\" flag when shared by multiple ports\n");
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = mlxsw_env_module_reset(mlxsw_core, module);
+	if (err) {
+		netdev_err(netdev, "Failed to reset module\n");
+		goto out;
+	}
+
+	*flags &= ~(ETH_RESET_PHY | (ETH_RESET_PHY << ETH_RESET_SHARED_SHIFT));
+
+out:
+	mutex_unlock(&mlxsw_env->module_info_lock);
+	return err;
+}
+EXPORT_SYMBOL(mlxsw_env_reset_module);
+
 static int mlxsw_env_module_has_temp_sensor(struct mlxsw_core *mlxsw_core,
 					    u8 module,
 					    bool *p_has_temp_sensor)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.h b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
index ba9269f12cb8..c486397f5dfe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
@@ -24,6 +24,10 @@ mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
 				    const struct ethtool_module_eeprom *page,
 				    struct netlink_ext_ack *extack);
 
+int mlxsw_env_reset_module(struct net_device *netdev,
+			   struct mlxsw_core *mlxsw_core, u8 module,
+			   u32 *flags);
+
 int
 mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 module,
 				      u64 *p_counter);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index a3eca0b56bbe..9644e9c486b8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -136,11 +136,21 @@ mlxsw_m_get_module_eeprom_by_page(struct net_device *netdev,
 						   page, extack);
 }
 
+static int mlxsw_m_reset(struct net_device *netdev, u32 *flags)
+{
+	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
+	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
+
+	return mlxsw_env_reset_module(netdev, core, mlxsw_m_port->module,
+				      flags);
+}
+
 static const struct ethtool_ops mlxsw_m_port_ethtool_ops = {
 	.get_drvinfo		= mlxsw_m_module_get_drvinfo,
 	.get_module_info	= mlxsw_m_get_module_info,
 	.get_module_eeprom	= mlxsw_m_get_module_eeprom,
 	.get_module_eeprom_by_page = mlxsw_m_get_module_eeprom_by_page,
+	.reset			= mlxsw_m_reset,
 };
 
 static int
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 267590a0eee7..06f1645561c6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1197,6 +1197,15 @@ mlxsw_sp_get_rmon_stats(struct net_device *dev,
 	*ranges = mlxsw_rmon_ranges;
 }
 
+static int mlxsw_sp_reset(struct net_device *dev, u32 *flags)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 module = mlxsw_sp_port->mapping.module;
+
+	return mlxsw_env_reset_module(dev, mlxsw_sp->core, module, flags);
+}
+
 const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.cap_link_lanes_supported	= true,
 	.get_drvinfo			= mlxsw_sp_port_get_drvinfo,
@@ -1218,6 +1227,7 @@ const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.get_eth_mac_stats		= mlxsw_sp_get_eth_mac_stats,
 	.get_eth_ctrl_stats		= mlxsw_sp_get_eth_ctrl_stats,
 	.get_rmon_stats			= mlxsw_sp_get_rmon_stats,
+	.reset				= mlxsw_sp_reset,
 };
 
 struct mlxsw_sp1_port_link_mode {
-- 
2.31.1

