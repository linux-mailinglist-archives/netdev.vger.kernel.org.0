Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7E52D82B
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfE2Iro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:47:44 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43497 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbfE2Irm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 04:47:42 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D3E7021FC3;
        Wed, 29 May 2019 04:47:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 29 May 2019 04:47:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=PF4vszq8FXx8mZwTJfhRFVUPdbZySysDQTq6HuGonzc=; b=lQ6lPhRH
        O2ID0oy9gC0LwR1kOdealjxx5FwOUYaIo1dxCHFopXkszoWoLhPkfk2xAvzZKzN2
        HL3PS2VQii9F7QbDNSRA5q3fmqTIV8gaQnh/YyRKyS6dlcAXcxkmz6ZLGItXQOSW
        dpztluO7JDhtTGay4/saaFzZRl9dLjNvA7tOb5kvRWXfB7p0Uv5i9oPk4ybwdo2P
        HV0L+xfzau8AypLatHUf0qj/nb6uy7DqNof/S7WMd/HIbseR0bC+9/GA8T0ePCIB
        MJf8V0FwyhBZtylICunpa7owaQUayMgrAMUs7ukeKpuWOijYBwkBIPa9yBi/vdYK
        oCk88k9+hWHJzQ==
X-ME-Sender: <xms:LEfuXNy7anL7dHD1HZ9jdjN2NCX-y8aIwetUdvkz_-ltUuno8yrX3g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvjedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:LEfuXH99r7W7y2u8LqfySYX8gkL2PvjfDT7Wwu0sfU5tNzRjJLhsqA>
    <xmx:LEfuXN87TOa43c4qMKmTgW4ff5_ggWpvTGww9wQ2kmURcNDEYOaohA>
    <xmx:LEfuXKdz_Lzb5VsvTupLAjedHSzGhvowVhKNspZgDcUBnP2kxe3bsA>
    <xmx:LEfuXFopu0mV8Ivpp7-ib46urZAfVBjJJNLvWMK1dLxIBAeS4ms9jQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6E6FD80061;
        Wed, 29 May 2019 04:47:39 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/8] mlxsw: i2c: Extend initialization with querying firmware info
Date:   Wed, 29 May 2019 11:47:15 +0300
Message-Id: <20190529084722.22719-2-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190529084722.22719-1-idosch@idosch.org>
References: <20190529084722.22719-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

Extend initialization flow with query request for firmware info in
order to obtain firmware version info.
This info is to be provided to minimal driver to support ethtool
get_drvinfo() interface.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/i2c.c     | 12 ++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 18 ++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/i2c.c b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
index 06aea1999518..803ce9623205 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/i2c.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
@@ -509,8 +509,20 @@ mlxsw_i2c_init(void *bus_priv, struct mlxsw_core *mlxsw_core,
 	if (!mbox)
 		return -ENOMEM;
 
+	err = mlxsw_cmd_query_fw(mlxsw_core, mbox);
+	if (err)
+		goto mbox_put;
+
+	mlxsw_i2c->bus_info.fw_rev.major =
+		mlxsw_cmd_mbox_query_fw_fw_rev_major_get(mbox);
+	mlxsw_i2c->bus_info.fw_rev.minor =
+		mlxsw_cmd_mbox_query_fw_fw_rev_minor_get(mbox);
+	mlxsw_i2c->bus_info.fw_rev.subminor =
+		mlxsw_cmd_mbox_query_fw_fw_rev_subminor_get(mbox);
+
 	err = mlxsw_core_resources_query(mlxsw_core, mbox, res);
 
+mbox_put:
 	mlxsw_cmd_mbox_free(mbox);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index cf2114273b72..471b0ca6d69a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -67,6 +67,23 @@ static const struct net_device_ops mlxsw_m_port_netdev_ops = {
 	.ndo_get_devlink_port	= mlxsw_m_port_get_devlink_port,
 };
 
+static void mlxsw_m_module_get_drvinfo(struct net_device *dev,
+				       struct ethtool_drvinfo *drvinfo)
+{
+	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(dev);
+	struct mlxsw_m *mlxsw_m = mlxsw_m_port->mlxsw_m;
+
+	strlcpy(drvinfo->driver, mlxsw_m->bus_info->device_kind,
+		sizeof(drvinfo->driver));
+	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
+		 "%d.%d.%d",
+		 mlxsw_m->bus_info->fw_rev.major,
+		 mlxsw_m->bus_info->fw_rev.minor,
+		 mlxsw_m->bus_info->fw_rev.subminor);
+	strlcpy(drvinfo->bus_info, mlxsw_m->bus_info->device_name,
+		sizeof(drvinfo->bus_info));
+}
+
 static int mlxsw_m_get_module_info(struct net_device *netdev,
 				   struct ethtool_modinfo *modinfo)
 {
@@ -88,6 +105,7 @@ mlxsw_m_get_module_eeprom(struct net_device *netdev, struct ethtool_eeprom *ee,
 }
 
 static const struct ethtool_ops mlxsw_m_port_ethtool_ops = {
+	.get_drvinfo		= mlxsw_m_module_get_drvinfo,
 	.get_module_info	= mlxsw_m_get_module_info,
 	.get_module_eeprom	= mlxsw_m_get_module_eeprom,
 };
-- 
2.20.1

