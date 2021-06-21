Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD55A3AE462
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 09:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhFUHx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 03:53:56 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40377 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230157AbhFUHxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 03:53:55 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 14BAC5C00EF;
        Mon, 21 Jun 2021 03:51:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 21 Jun 2021 03:51:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=6p/StMXboIAg7jqu380mvcof9Sg6eZG5FarLaVS9wkg=; b=EsjYS9g7
        +NWVv0HzSoUMs3t5ZZTn5FIKdUWLtJulql2MXnlRMpz9ur6g2cqQ5jw66gcXniJw
        7cn9/+Vs+6+cp91vCdCOGr/DhJyd17GZi1JDuC88uG0M94aeXJ1925tz6NDkbRkx
        rykRNKizVBu4Btr7Rgk9wNd922zlSvDp5GQA3/zZqMgvE1gOyi7cJqb60PIBnWQ1
        UkfglalNjauybdncYDD2z2CUPZ/9xm/mALa4oF7OLO2uddn23e4HUCj9PZWGIN84
        yHOTQKHhk+ZoHT4sRyxogHRMr0N3jsuXhDTsV3zIcisjI0PlT34kMGF+GAHFpGLj
        HOG3MqzJ05+qEQ==
X-ME-Sender: <xms:DEXQYODsa12yjUHLVu8oOAH4wmL8porCbC3SCvO1x89FQ3WJEboTGw>
    <xme:DEXQYIg3O6QQhH5xtdK48pcT8It6Uel-i3nKiOnYvJMyf2d2rLXlnPC4rEsm_mY7i
    rl-nX2Im1a8hRk>
X-ME-Received: <xmr:DEXQYBkt2znsomigvWZRfb6nAyWiKDly2N9tsB8t9RlT_gSNWzIIN9Ad1cCFaqPejCMIr7uaJxm-UjSv72X57NMktIt-SXQP1WvPW-ld87szGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefkedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:DEXQYMwVxhLfupSS3wd5iumwgJ-72bzkRVQP7hTdm28MT2jbkixW6A>
    <xmx:DEXQYDRUQDLpkA2H1WsjHR1VzeA9UrswMJkye__9UoihRTRuEWSLqA>
    <xmx:DEXQYHYu4WmJQQmcZsHMinzd3YVzJVy7s_QUPDPKlbPpvi5YtLZC9w>
    <xmx:DUXQYBNhElXfIk_sNA5vtkmFiPbe8tIDnbbOsGpldNA3WPc-o7byrA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 03:51:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/3] mlxsw: core: Add support for module EEPROM read by page
Date:   Mon, 21 Jun 2021 10:50:41 +0300
Message-Id: <20210621075041.2502416-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210621075041.2502416-1-idosch@idosch.org>
References: <20210621075041.2502416-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add support for ethtool_ops::get_module_eeprom_by_page() which allows
user space to read transceiver module EEPROM based on passed parameters.

The I2C address is not validated in order to avoid module-specific code.
In case of wrong address, error will be returned from device's firmware.

Tested by comparing output with legacy method (ioctl) output.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 74 +++++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/core_env.h    |  7 ++
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 13 ++++
 .../mellanox/mlxsw/spectrum_ethtool.c         | 14 ++++
 4 files changed, 108 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index b3ca5bd33a7f..4a0dbdb6730b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -3,6 +3,7 @@
 
 #include <linux/kernel.h>
 #include <linux/err.h>
+#include <linux/ethtool.h>
 #include <linux/sfp.h>
 
 #include "core.h"
@@ -315,6 +316,79 @@ int mlxsw_env_get_module_eeprom(struct net_device *netdev,
 }
 EXPORT_SYMBOL(mlxsw_env_get_module_eeprom);
 
+static int mlxsw_env_mcia_status_process(const char *mcia_pl,
+					 struct netlink_ext_ack *extack)
+{
+	u8 status = mlxsw_reg_mcia_status_get(mcia_pl);
+
+	switch (status) {
+	case MLXSW_REG_MCIA_STATUS_GOOD:
+		return 0;
+	case MLXSW_REG_MCIA_STATUS_NO_EEPROM_MODULE:
+		NL_SET_ERR_MSG_MOD(extack, "No response from module's EEPROM");
+		return -EIO;
+	case MLXSW_REG_MCIA_STATUS_MODULE_NOT_SUPPORTED:
+		NL_SET_ERR_MSG_MOD(extack, "Module type not supported by the device");
+		return -EOPNOTSUPP;
+	case MLXSW_REG_MCIA_STATUS_MODULE_NOT_CONNECTED:
+		NL_SET_ERR_MSG_MOD(extack, "No module present indication");
+		return -EIO;
+	case MLXSW_REG_MCIA_STATUS_I2C_ERROR:
+		NL_SET_ERR_MSG_MOD(extack, "Error occurred while trying to access module's EEPROM using I2C");
+		return -EIO;
+	case MLXSW_REG_MCIA_STATUS_MODULE_DISABLED:
+		NL_SET_ERR_MSG_MOD(extack, "Module is disabled");
+		return -EIO;
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Unknown error");
+		return -EIO;
+	}
+}
+
+int
+mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
+				    const struct ethtool_module_eeprom *page,
+				    struct netlink_ext_ack *extack)
+{
+	u32 bytes_read = 0;
+	u16 device_addr;
+
+	/* Offset cannot be larger than 2 * ETH_MODULE_EEPROM_PAGE_LEN */
+	device_addr = page->offset;
+
+	while (bytes_read < page->length) {
+		char eeprom_tmp[MLXSW_REG_MCIA_EEPROM_SIZE];
+		char mcia_pl[MLXSW_REG_MCIA_LEN];
+		u8 size;
+		int err;
+
+		size = min_t(u8, page->length - bytes_read,
+			     MLXSW_REG_MCIA_EEPROM_SIZE);
+
+		mlxsw_reg_mcia_pack(mcia_pl, module, 0, page->page,
+				    device_addr + bytes_read, size,
+				    page->i2c_address);
+		mlxsw_reg_mcia_bank_number_set(mcia_pl, page->bank);
+
+		err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mcia), mcia_pl);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to access module's EEPROM");
+			return err;
+		}
+
+		err = mlxsw_env_mcia_status_process(mcia_pl, extack);
+		if (err)
+			return err;
+
+		mlxsw_reg_mcia_eeprom_memcpy_from(mcia_pl, eeprom_tmp);
+		memcpy(page->data + bytes_read, eeprom_tmp, size);
+		bytes_read += size;
+	}
+
+	return bytes_read;
+}
+EXPORT_SYMBOL(mlxsw_env_get_module_eeprom_by_page);
+
 static int mlxsw_env_module_has_temp_sensor(struct mlxsw_core *mlxsw_core,
 					    u8 module,
 					    bool *p_has_temp_sensor)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.h b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
index 2b23f8a87862..0bf5bd0f8a7e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
@@ -4,6 +4,8 @@
 #ifndef _MLXSW_CORE_ENV_H
 #define _MLXSW_CORE_ENV_H
 
+#include <linux/ethtool.h>
+
 struct ethtool_modinfo;
 struct ethtool_eeprom;
 
@@ -17,6 +19,11 @@ int mlxsw_env_get_module_eeprom(struct net_device *netdev,
 				struct mlxsw_core *mlxsw_core, int module,
 				struct ethtool_eeprom *ee, u8 *data);
 
+int
+mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
+				    const struct ethtool_module_eeprom *page,
+				    struct netlink_ext_ack *extack);
+
 int
 mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 module,
 				      u64 *p_counter);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index 68102726c6a7..d9d56c44e994 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -112,10 +112,23 @@ mlxsw_m_get_module_eeprom(struct net_device *netdev, struct ethtool_eeprom *ee,
 					   ee, data);
 }
 
+static int
+mlxsw_m_get_module_eeprom_by_page(struct net_device *netdev,
+				  const struct ethtool_module_eeprom *page,
+				  struct netlink_ext_ack *extack)
+{
+	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
+	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
+
+	return mlxsw_env_get_module_eeprom_by_page(core, mlxsw_m_port->module,
+						   page, extack);
+}
+
 static const struct ethtool_ops mlxsw_m_port_ethtool_ops = {
 	.get_drvinfo		= mlxsw_m_module_get_drvinfo,
 	.get_module_info	= mlxsw_m_get_module_info,
 	.get_module_eeprom	= mlxsw_m_get_module_eeprom,
+	.get_module_eeprom_by_page = mlxsw_m_get_module_eeprom_by_page,
 };
 
 static int
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index c8061beed6db..267590a0eee7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1050,6 +1050,19 @@ static int mlxsw_sp_get_module_eeprom(struct net_device *netdev,
 	return err;
 }
 
+static int
+mlxsw_sp_get_module_eeprom_by_page(struct net_device *dev,
+				   const struct ethtool_module_eeprom *page,
+				   struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 module = mlxsw_sp_port->mapping.module;
+
+	return mlxsw_env_get_module_eeprom_by_page(mlxsw_sp->core, module, page,
+						   extack);
+}
+
 static int
 mlxsw_sp_get_ts_info(struct net_device *netdev, struct ethtool_ts_info *info)
 {
@@ -1199,6 +1212,7 @@ const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.set_link_ksettings		= mlxsw_sp_port_set_link_ksettings,
 	.get_module_info		= mlxsw_sp_get_module_info,
 	.get_module_eeprom		= mlxsw_sp_get_module_eeprom,
+	.get_module_eeprom_by_page	= mlxsw_sp_get_module_eeprom_by_page,
 	.get_ts_info			= mlxsw_sp_get_ts_info,
 	.get_eth_phy_stats		= mlxsw_sp_get_eth_phy_stats,
 	.get_eth_mac_stats		= mlxsw_sp_get_eth_mac_stats,
-- 
2.31.1

