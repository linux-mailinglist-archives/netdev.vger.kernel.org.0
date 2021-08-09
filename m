Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2983E43DA
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbhHIKXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:23:20 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39615 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234585AbhHIKW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 06:22:57 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id BE8E25C00E4;
        Mon,  9 Aug 2021 06:22:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 09 Aug 2021 06:22:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Q/lnHpXsuuGGhgH7J2OtinC7PqY0h8vrUQbYPdx9ov0=; b=q7/BJvQg
        jilz1LoRSgot7dE3YBuqU/vA8q8x1udYHPinobKvxWyBE7gPks8zw6WVrQGJh3c1
        H9pQD4mJjrXrhwpYLww9k6YQsRzqMWQeHHGKwF1NVKNIqQbbYQTZA9TcGUTsQ5cS
        nP63f6hZqNttZ/52v1SdWODXH74VjAqW6oP7oi92b4+UzW5ioDVA9YBjQXIHkLDq
        +ueg6JiJSNC1pvyGm3YtGXIxIMwEWlD8sC8HHFdJ28ytCykft7X11/mfwAmbLtjK
        NgrwFMb4qxLlRVEipgpcj5EVOtGnBNpwX5239Qh5ObAPLSt6yEzD/PB6ueFfx0b3
        zH+ns7Lb8KB65Q==
X-ME-Sender: <xms:7AERYaFnckPeMpb2QAf6t48SC_-OkSd-NeSJOSd5ZV9BfFRh3MUwqg>
    <xme:7AERYbXhMu9w1En2JDQM28LWw99hoJD6Nb0iBDH5HE17Bfi5aRzr7FPoRIHUugr63
    w-6zNMDnOA9csw>
X-ME-Received: <xmr:7AERYUIQr4-3bJACL_FM57kjPxFKtlJo_fCbJokU_tgg2_ubKjy-f6CNegihvo-QuNBIfX2_zGvDPghGMNxq35bdUObXnN8koIhscKpVIdFxzQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeejgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedunecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:7AERYUGk4PPaC-yGcE1gs8dkGrqzBPJLDC8zXzHXq3qrfJl7VakEsw>
    <xmx:7AERYQUaaLBLi5DP__X6O1xt6HkrQeGvCQeVtqF0W5XQP3v1T9EQFQ>
    <xmx:7AERYXMuNnc8AgMsv4hLTbQm1J9MHV0qpzJ4wnc1L0xVf6aCGacvLw>
    <xmx:7AERYSL3PAV4iwcBkP98jmiuV6nCmc8kR3Hx4QxqHiCw-Q4YZZ2YQw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Aug 2021 06:22:34 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 8/8] mlxsw: Add ability to reset transceiver modules
Date:   Mon,  9 Aug 2021 13:21:52 +0300
Message-Id: <20210809102152.719961-9-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210809102152.719961-1-idosch@idosch.org>
References: <20210809102152.719961-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Implement support for ethtool_ops::reset_module. This is done by writing
to the "rst" bit of the PMAOS register and waiting for the module to
reach a valid operational state. If the module does not transition to a
valid state, an error is reported to user space via extack.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 28 +++++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/core_env.h    |  3 ++
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 10 +++++++
 .../mellanox/mlxsw/spectrum_ethtool.c         | 19 +++++++++++++
 4 files changed, 60 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 1ae06730d374..df578ef3319c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -587,6 +587,34 @@ int mlxsw_env_set_module_low_power(struct mlxsw_core *mlxsw_core, u8 module,
 }
 EXPORT_SYMBOL(mlxsw_env_set_module_low_power);
 
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
+int mlxsw_env_reset_module(struct mlxsw_core *mlxsw_core, u8 module,
+			   struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = mlxsw_env_module_reset(mlxsw_core, module);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to reset module");
+		return err;
+	}
+
+	/* Wait for the module to reach a valid operational state following its
+	 * reset.
+	 */
+	return mlxsw_env_module_oper_wait(mlxsw_core, module, extack);
+}
+EXPORT_SYMBOL(mlxsw_env_reset_module);
+
 static int mlxsw_env_module_has_temp_sensor(struct mlxsw_core *mlxsw_core,
 					    u8 module,
 					    bool *p_has_temp_sensor)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.h b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
index 32960de96674..465a095e6a3e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
@@ -32,6 +32,9 @@ int mlxsw_env_set_module_low_power(struct mlxsw_core *mlxsw_core, u8 module,
 				   bool low_power,
 				   struct netlink_ext_ack *extack);
 
+int mlxsw_env_reset_module(struct mlxsw_core *mlxsw_core, u8 module,
+			   struct netlink_ext_ack *extack);
+
 int
 mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 module,
 				      u64 *p_counter);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index 6fb8204c4d8a..d206442270df 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -146,6 +146,15 @@ static int mlxsw_m_set_module_low_power(struct net_device *netdev,
 					      low_power, extack);
 }
 
+static int mlxsw_m_reset_module(struct net_device *netdev,
+				struct netlink_ext_ack *extack)
+{
+	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
+	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
+
+	return mlxsw_env_reset_module(core, mlxsw_m_port->module, extack);
+}
+
 static const struct ethtool_ops mlxsw_m_port_ethtool_ops = {
 	.get_drvinfo		= mlxsw_m_module_get_drvinfo,
 	.get_module_info	= mlxsw_m_get_module_info,
@@ -153,6 +162,7 @@ static const struct ethtool_ops mlxsw_m_port_ethtool_ops = {
 	.get_module_eeprom_by_page = mlxsw_m_get_module_eeprom_by_page,
 	.get_module_low_power	= mlxsw_m_get_module_low_power,
 	.set_module_low_power	= mlxsw_m_set_module_low_power,
+	.reset_module		= mlxsw_m_reset_module,
 };
 
 static int
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index fb6256f16c50..9526ef71e513 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1244,6 +1244,24 @@ static int mlxsw_sp_set_module_low_power(struct net_device *dev, bool low_power,
 					      extack);
 }
 
+static int mlxsw_sp_reset_module(struct net_device *dev,
+				 struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 module = mlxsw_sp_port->mapping.module;
+
+	/* We are going to take the module down, so no port using it can be
+	 * administratively up.
+	 */
+	if (mlxsw_sp_module_ports_up_check(mlxsw_sp, module)) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot reset module when ports using it are administratively up");
+		return -EINVAL;
+	}
+
+	return mlxsw_env_reset_module(mlxsw_sp->core, module, extack);
+}
+
 const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.cap_link_lanes_supported	= true,
 	.get_drvinfo			= mlxsw_sp_port_get_drvinfo,
@@ -1267,6 +1285,7 @@ const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.get_rmon_stats			= mlxsw_sp_get_rmon_stats,
 	.get_module_low_power		= mlxsw_sp_get_module_low_power,
 	.set_module_low_power		= mlxsw_sp_set_module_low_power,
+	.reset_module			= mlxsw_sp_reset_module,
 };
 
 struct mlxsw_sp1_port_link_mode {
-- 
2.31.1

