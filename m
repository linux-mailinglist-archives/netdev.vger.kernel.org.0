Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147D02D2785
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgLHJZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:25:43 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51181 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727187AbgLHJZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:25:42 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A2B535C0209;
        Tue,  8 Dec 2020 04:23:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 08 Dec 2020 04:23:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=mVlRGCqJiQPunvYY8Rm5JcFgJ6TzpaSGpgBYZHy7140=; b=akXZXDUm
        Elo2bR/cJ3ZK9LqZTgxW6w01Fy8N/DbabVcDwTQe8MsAjF0vt8TFwuHgFWyOlwlY
        hA20bNKl3oY1HKzl5JfvTd6npU2/wsZ0JXEm0RxE5GiMa+ZKx5f59tfeiqgoMHBa
        WIWiU/5Tamx4qtYGk03f3NpovhM5SAg7K/2Dv9qUHu0D2iXYinag4Ywu3Dgd0g4J
        4aux94XgBMe7fZXLhEwmAQ8uG/QclDDVArwnrdSMOrAB9MnKB8vfM+T+men006mH
        gZ8gbazpL01GsZELsIBZqXCQbAd3asyNUs9KrWT5w7XX0H2nLHFRKpPVEz9onJLQ
        ulrzEvLofhsXsA==
X-ME-Sender: <xms:LUbPXxaMsrxYryQFNqKYpJ9mA8wlXOQt_PYtXeaAc6AL75MCmjeMog>
    <xme:LUbPX40fywuR31k7-eo4zsxP3zm_7qmvf-MhB9SijeRNJ23gd_M29zY30F98bPzm_
    FKQp3jO6CkWZlk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejiedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepveejkeetffefudfgleeijeefffelfe
    dvkeefueefjeefudekffeiteefueetheefnecuffhomhgrihhnpehvnhhirdguvghvnecu
    kfhppeekgedrvddvledrudehfedrjeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:LUbPX0oZ2Ki90Tor_mluzqSQMuDk7MmChdZ6QMWsNNu_4kpErQeQPg>
    <xmx:LUbPX3Mnv_75g1iyiNaIScJnkJK74RrYxDh_b7wQJDsMdob4sPLzJw>
    <xmx:LUbPX9pWf8BSF2l1AdiNR1KUqVkszEsNR9Sx-2hL7fFT_clJVibHWA>
    <xmx:LUbPXzyz6cnAhHAuO6_73h4oUhBoBLsKOAYUvdZ5Wlh4625mLd0XbQ>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id 367DC108006A;
        Tue,  8 Dec 2020 04:23:56 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/13] mlxsw: Save EtherType as part of mlxsw_sp_nve_params
Date:   Tue,  8 Dec 2020 11:22:45 +0200
Message-Id: <20201208092253.1996011-6-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201208092253.1996011-1-idosch@idosch.org>
References: <20201208092253.1996011-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add EtherType field to mlxsw_sp_nve_params struct.
Set it when VxLAN device is added to bridge device.

This field is needed to configure which EtherType will be used when
VLAN is pushed at ingress of the tunnel port.

Use ETH_P_8021Q for tunnel port enslaved to 802.1d and 802.1q bridges.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h           | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c | 7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 6092243a69cb..7e728a8a9fb3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -1202,6 +1202,7 @@ struct mlxsw_sp_nve_params {
 	enum mlxsw_sp_nve_type type;
 	__be32 vni;
 	const struct net_device *dev;
+	u16 ethertype;
 };
 
 extern const struct mlxsw_sp_nve_ops *mlxsw_sp1_nve_ops_arr[];
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index c53e0ab9f971..051a77440afe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2055,7 +2055,8 @@ mlxsw_sp_bridge_8021q_port_leave(struct mlxsw_sp_bridge_device *bridge_device,
 static int
 mlxsw_sp_bridge_vlan_aware_vxlan_join(struct mlxsw_sp_bridge_device *bridge_device,
 				      const struct net_device *vxlan_dev,
-				      u16 vid, struct netlink_ext_ack *extack)
+				      u16 vid, u16 ethertype,
+				      struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_lower_get(bridge_device->dev);
 	struct vxlan_dev *vxlan = netdev_priv(vxlan_dev);
@@ -2063,6 +2064,7 @@ mlxsw_sp_bridge_vlan_aware_vxlan_join(struct mlxsw_sp_bridge_device *bridge_devi
 		.type = MLXSW_SP_NVE_TYPE_VXLAN,
 		.vni = vxlan->cfg.vni,
 		.dev = vxlan_dev,
+		.ethertype = ethertype,
 	};
 	struct mlxsw_sp_fid *fid;
 	int err;
@@ -2107,7 +2109,7 @@ mlxsw_sp_bridge_8021q_vxlan_join(struct mlxsw_sp_bridge_device *bridge_device,
 				 struct netlink_ext_ack *extack)
 {
 	return mlxsw_sp_bridge_vlan_aware_vxlan_join(bridge_device, vxlan_dev,
-						     vid, extack);
+						     vid, ETH_P_8021Q, extack);
 }
 
 static struct net_device *
@@ -2240,6 +2242,7 @@ mlxsw_sp_bridge_8021d_vxlan_join(struct mlxsw_sp_bridge_device *bridge_device,
 		.type = MLXSW_SP_NVE_TYPE_VXLAN,
 		.vni = vxlan->cfg.vni,
 		.dev = vxlan_dev,
+		.ethertype = ETH_P_8021Q,
 	};
 	struct mlxsw_sp_fid *fid;
 	int err;
-- 
2.28.0

