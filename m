Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D95091614C1
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgBQObg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:31:36 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56105 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727421AbgBQObU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:31:20 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 05F1D22050;
        Mon, 17 Feb 2020 09:31:19 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 17 Feb 2020 09:31:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=lMVF5D49BmyWx7rWinrK/PwUbUx0fCBL09PBBD8Npzk=; b=KKGTyPj1
        IDX6I66u4fzDiZBBPzh2GwW2Xhp2BQtN/BrqibjPf/qVdARnTNR7OuVS0ElGOUP8
        GPldQp+HlgBxxcrVLe6IY9rRREDpQPlU8OQz6fpE5iNfnUXedi1yuonfXvCnzdRv
        URn7eEYRH7SHaNE0epQ5koKU9nJhDWv2qM2pqW4va9oXtXgwvMOhEPgknerepRJj
        i4Jiil5KimTcgZw7AA7UZmzqsez13qKoKXNZ3NvjUNDqs4T0PKPmHUB7YkYQdecq
        Y3piZiuqPJEbbz4iZehU7u1f/x2pbjyVlJpqEmtNSKCdcWqjrCIjbDN5rd3/uEyD
        qiKkwRfuxLKR6Q==
X-ME-Sender: <xms:tqNKXmXyQszRa0NoSTz6inxcq3SemKleaPlsTEj0vKPUUHjvwvYToA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:tqNKXpitOCveHyV5Pr1Ujoq1_bnjSJymWAIEL2zkucIU4OHpBUl-rg>
    <xmx:tqNKXjWvq_WPQTYr0VsXIqGJA1GKHrIPwG9UGQNbWVObAm4S4nJB9A>
    <xmx:tqNKXlIvLbEuFqmgC9lzbsKdW7xmGuYg1LxG3vMRd8-KCGNzlChJeg>
    <xmx:t6NKXrcM5Sqej5qFiUsP91hN--mCpLv1h4Y4v98xlmI6k4qqKgRQyQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id DF6583060C28;
        Mon, 17 Feb 2020 09:31:17 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 02/10] mlxsw: spectrum_switchdev: Propagate extack to bridge creation function
Date:   Mon, 17 Feb 2020 16:29:32 +0200
Message-Id: <20200217142940.307014-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200217142940.307014-1-idosch@idosch.org>
References: <20200217142940.307014-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Propagate extack to bridge creation function so that error messages
could be passed to user space via netlink instead of printing them to
kernel log.

A subsequent patch will pass the new extack argument to more functions.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../mellanox/mlxsw/spectrum_switchdev.c       | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index a3af171c6358..798aefd3e3b6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -155,7 +155,8 @@ static void mlxsw_sp_bridge_device_rifs_destroy(struct mlxsw_sp *mlxsw_sp,
 
 static struct mlxsw_sp_bridge_device *
 mlxsw_sp_bridge_device_create(struct mlxsw_sp_bridge *bridge,
-			      struct net_device *br_dev)
+			      struct net_device *br_dev,
+			      struct netlink_ext_ack *extack)
 {
 	struct device *dev = bridge->mlxsw_sp->bus_info->dev;
 	struct mlxsw_sp_bridge_device *bridge_device;
@@ -163,6 +164,7 @@ mlxsw_sp_bridge_device_create(struct mlxsw_sp_bridge *bridge,
 
 	if (vlan_enabled && bridge->vlan_enabled_exists) {
 		dev_err(dev, "Only one VLAN-aware bridge is supported\n");
+		NL_SET_ERR_MSG_MOD(extack, "Only one VLAN-aware bridge is supported");
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -203,7 +205,8 @@ mlxsw_sp_bridge_device_destroy(struct mlxsw_sp_bridge *bridge,
 
 static struct mlxsw_sp_bridge_device *
 mlxsw_sp_bridge_device_get(struct mlxsw_sp_bridge *bridge,
-			   struct net_device *br_dev)
+			   struct net_device *br_dev,
+			   struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_bridge_device *bridge_device;
 
@@ -211,7 +214,7 @@ mlxsw_sp_bridge_device_get(struct mlxsw_sp_bridge *bridge,
 	if (bridge_device)
 		return bridge_device;
 
-	return mlxsw_sp_bridge_device_create(bridge, br_dev);
+	return mlxsw_sp_bridge_device_create(bridge, br_dev, extack);
 }
 
 static void
@@ -292,7 +295,8 @@ mlxsw_sp_bridge_port_destroy(struct mlxsw_sp_bridge_port *bridge_port)
 
 static struct mlxsw_sp_bridge_port *
 mlxsw_sp_bridge_port_get(struct mlxsw_sp_bridge *bridge,
-			 struct net_device *brport_dev)
+			 struct net_device *brport_dev,
+			 struct netlink_ext_ack *extack)
 {
 	struct net_device *br_dev = netdev_master_upper_dev_get(brport_dev);
 	struct mlxsw_sp_bridge_device *bridge_device;
@@ -305,7 +309,7 @@ mlxsw_sp_bridge_port_get(struct mlxsw_sp_bridge *bridge,
 		return bridge_port;
 	}
 
-	bridge_device = mlxsw_sp_bridge_device_get(bridge, br_dev);
+	bridge_device = mlxsw_sp_bridge_device_get(bridge, br_dev, extack);
 	if (IS_ERR(bridge_device))
 		return ERR_CAST(bridge_device);
 
@@ -1000,7 +1004,7 @@ mlxsw_sp_port_vlan_bridge_join(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan,
 		 &bridge_vlan->port_vlan_list);
 
 	mlxsw_sp_bridge_port_get(mlxsw_sp_port->mlxsw_sp->bridge,
-				 bridge_port->dev);
+				 bridge_port->dev, extack);
 	mlxsw_sp_port_vlan->bridge_port = bridge_port;
 
 	return 0;
@@ -2287,7 +2291,8 @@ int mlxsw_sp_port_bridge_join(struct mlxsw_sp_port *mlxsw_sp_port,
 	struct mlxsw_sp_bridge_port *bridge_port;
 	int err;
 
-	bridge_port = mlxsw_sp_bridge_port_get(mlxsw_sp->bridge, brport_dev);
+	bridge_port = mlxsw_sp_bridge_port_get(mlxsw_sp->bridge, brport_dev,
+					       extack);
 	if (IS_ERR(bridge_port))
 		return PTR_ERR(bridge_port);
 	bridge_device = bridge_port->bridge_device;
-- 
2.24.1

