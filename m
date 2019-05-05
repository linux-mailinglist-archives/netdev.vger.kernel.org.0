Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5D8D13DFD
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 08:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfEEGsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 02:48:40 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38479 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726443AbfEEGsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 02:48:39 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 634412151C;
        Sun,  5 May 2019 02:48:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 05 May 2019 02:48:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=KO3vZpyEEbtFo+KwYGJqOupAU7i/Dn5QNSz3OJcilqU=; b=ko+7OXjh
        Bbi26x2CK29TYiutxY/oedWdzHtuJviFzikeIPTqKvJui4rpEGuXdnnbX0PHV8ua
        tKeNr776k74+MscRdxVJbHMbKYlKpYzYH7n8Rh+YviNDQdT/XKAw8zlwfmISVtfe
        ipdW8Z45mUjaN4o0VtEqj7T2GqQNPL7pQDyiYHHheMAnbkNTQdOqdUghM0jk+Zi2
        D36WWyiymA9Dci0mCgmG2J8ZFVb9+XauebmsXVWIa2mFfsMpWStuoB7/wN6hrH0g
        7+oIXQH1U2Mk8vf/OiZu1yVv4oZu6Uo1HkNDfoLmXkQMmy0tw45GzHv76MTsiQL1
        ImKghra9wv0EOQ==
X-ME-Sender: <xms:RofOXEwfBEZNOaAKTtuxzClhAHTLyTSG7fgx7KazQFnhFr9sFyWaHQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrjeeggdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:RofOXNKOQEiDk0TQOH8-ODv3lTVL-sLxIKIg47wlhRT8OKbFPoqZvw>
    <xmx:RofOXD6MkeHyKa67-dHWWWe_I6tHe3fHNDe0llso2RbrmE7fSDVpNQ>
    <xmx:RofOXEk6w-hija1uASKvEPsETt5u1OhFDIOd4W6v6vl01poroKDlaQ>
    <xmx:RofOXJJk3Czo7La82YjvA44XeaDxzpKuMRot0w1k-HX7YoSCcFEU0w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1D2C9E40C3;
        Sun,  5 May 2019 02:48:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/3] mlxsw: spectrum: Implement loopback ethtool feature
Date:   Sun,  5 May 2019 09:48:06 +0300
Message-Id: <20190505064807.27925-3-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190505064807.27925-1-idosch@idosch.org>
References: <20190505064807.27925-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Allow user to enable loopback feature for individual ports using ethtool.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 35 +++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index a6c6d5ee9ead..cbb02e37ec41 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1669,6 +1669,25 @@ static int mlxsw_sp_feature_hw_tc(struct net_device *dev, bool enable)
 	return 0;
 }
 
+static int mlxsw_sp_feature_loopback(struct net_device *dev, bool enable)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	char pplr_pl[MLXSW_REG_PPLR_LEN];
+	int err;
+
+	if (netif_running(dev))
+		mlxsw_sp_port_admin_status_set(mlxsw_sp_port, false);
+
+	mlxsw_reg_pplr_pack(pplr_pl, mlxsw_sp_port->local_port, enable);
+	err = mlxsw_reg_write(mlxsw_sp_port->mlxsw_sp->core, MLXSW_REG(pplr),
+			      pplr_pl);
+
+	if (netif_running(dev))
+		mlxsw_sp_port_admin_status_set(mlxsw_sp_port, true);
+
+	return err;
+}
+
 typedef int (*mlxsw_sp_feature_handler)(struct net_device *dev, bool enable);
 
 static int mlxsw_sp_handle_feature(struct net_device *dev,
@@ -1700,8 +1719,20 @@ static int mlxsw_sp_handle_feature(struct net_device *dev,
 static int mlxsw_sp_set_features(struct net_device *dev,
 				 netdev_features_t features)
 {
-	return mlxsw_sp_handle_feature(dev, features, NETIF_F_HW_TC,
+	netdev_features_t oper_features = dev->features;
+	int err = 0;
+
+	err |= mlxsw_sp_handle_feature(dev, features, NETIF_F_HW_TC,
 				       mlxsw_sp_feature_hw_tc);
+	err |= mlxsw_sp_handle_feature(dev, features, NETIF_F_LOOPBACK,
+				       mlxsw_sp_feature_loopback);
+
+	if (err) {
+		dev->features = oper_features;
+		return -EINVAL;
+	}
+
+	return 0;
 }
 
 static struct devlink_port *
@@ -3452,7 +3483,7 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 
 	dev->features |= NETIF_F_NETNS_LOCAL | NETIF_F_LLTX | NETIF_F_SG |
 			 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
-	dev->hw_features |= NETIF_F_HW_TC;
+	dev->hw_features |= NETIF_F_HW_TC | NETIF_F_LOOPBACK;
 
 	dev->min_mtu = 0;
 	dev->max_mtu = ETH_MAX_MTU;
-- 
2.20.1

