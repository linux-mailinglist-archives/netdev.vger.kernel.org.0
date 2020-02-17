Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2A911614BA
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgBQObY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:31:24 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55921 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727448AbgBQObX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:31:23 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 686BA201E3;
        Mon, 17 Feb 2020 09:31:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 17 Feb 2020 09:31:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=/HSGrKBijbsTzFdMNu5An1d5GjYFYFIfSaO3tKnS1j8=; b=ybanfPWt
        ygjiwtUidsTuO20rvAggIYtgsZcM5pD9DmB27JmQx31Gq3qqxThb2PLQrfc/Zry1
        SrTtTK8LDJQCud2UR0Q87UyNn4wRAUScr+T333hhPWow+Yhs+rPGikfMxhNIEHIX
        fHim5UBsZgSqzx8VDjxOG0makHKuy7E0VvGPBHMmXtglmursAC7/LI1kpMmVYER7
        3hF6J6xyA4xz8eK09tGhbJBkhG8iGOakeR8uCo15w/UW/xQEf17YonLXUlwDScil
        UzD0hZYOkaGWL3DaF9CWU83kFTPjsp1Xml7tYKJ0i44lTdZyZpIBYG8+o2QokUve
        aRr8+zcp/9cHhQ==
X-ME-Sender: <xms:uaNKXjHM-OWieM6sLMGdz6WExOnbh5yJMtEkT2tg8V-bxxGKgig7RQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsthgvrh
    fuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:uaNKXiY6Y33RBjxnRu-gzN-Vu2WDbIn2W-Tscy8HMZWMi0VKcL_rig>
    <xmx:uaNKXjTsWpFMZzhZWnA263SfaOSW42PUQGbDHnvvsQU5ft0BQx9iew>
    <xmx:uaNKXmC-shfSqvf5jh5wmDH-fanFBB0UTOunQdgQejogEimg3AJjLw>
    <xmx:uaNKXn2GrGMKjtGU3YRHcPGhBjGB43-hlompnI6D6eTKjQQW-AUtig>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4EB073060C28;
        Mon, 17 Feb 2020 09:31:20 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/10] mlxsw: spectrum_switchdev: Remove VXLAN checks during FID membership
Date:   Mon, 17 Feb 2020 16:29:34 +0200
Message-Id: <20200217142940.307014-5-idosch@idosch.org>
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

As explained in previous patch, VXLAN devices now take a reference on
the FID and not only local ports. Therefore, there is no need for local
ports to check if they need to set a VNI on the FID when they join the
FID.

Remove these unnecessary checks.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../mellanox/mlxsw/spectrum_switchdev.c       | 60 +------------------
 1 file changed, 2 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 3ba07233d400..c3a890e0bba1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2108,38 +2108,8 @@ mlxsw_sp_bridge_8021q_fid_get(struct mlxsw_sp_bridge_device *bridge_device,
 			      u16 vid, struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_lower_get(bridge_device->dev);
-	struct net_device *vxlan_dev;
-	struct mlxsw_sp_fid *fid;
-	int err;
-
-	fid = mlxsw_sp_fid_8021q_get(mlxsw_sp, vid);
-	if (IS_ERR(fid))
-		return fid;
-
-	if (mlxsw_sp_fid_vni_is_set(fid))
-		return fid;
-
-	/* Find the VxLAN device that has the specified VLAN configured as
-	 * PVID and egress untagged. There can be at most one such device
-	 */
-	vxlan_dev = mlxsw_sp_bridge_8021q_vxlan_dev_find(bridge_device->dev,
-							 vid);
-	if (!vxlan_dev)
-		return fid;
-
-	if (!netif_running(vxlan_dev))
-		return fid;
 
-	err = mlxsw_sp_bridge_8021q_vxlan_join(bridge_device, vxlan_dev, vid,
-					       extack);
-	if (err)
-		goto err_vxlan_join;
-
-	return fid;
-
-err_vxlan_join:
-	mlxsw_sp_fid_put(fid);
-	return ERR_PTR(err);
+	return mlxsw_sp_fid_8021q_get(mlxsw_sp, vid);
 }
 
 static struct mlxsw_sp_fid *
@@ -2273,34 +2243,8 @@ mlxsw_sp_bridge_8021d_fid_get(struct mlxsw_sp_bridge_device *bridge_device,
 			      u16 vid, struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_lower_get(bridge_device->dev);
-	struct net_device *vxlan_dev;
-	struct mlxsw_sp_fid *fid;
-	int err;
-
-	fid = mlxsw_sp_fid_8021d_get(mlxsw_sp, bridge_device->dev->ifindex);
-	if (IS_ERR(fid))
-		return fid;
-
-	if (mlxsw_sp_fid_vni_is_set(fid))
-		return fid;
-
-	vxlan_dev = mlxsw_sp_bridge_vxlan_dev_find(bridge_device->dev);
-	if (!vxlan_dev)
-		return fid;
-
-	if (!netif_running(vxlan_dev))
-		return fid;
-
-	err = mlxsw_sp_bridge_8021d_vxlan_join(bridge_device, vxlan_dev, 0,
-					       extack);
-	if (err)
-		goto err_vxlan_join;
 
-	return fid;
-
-err_vxlan_join:
-	mlxsw_sp_fid_put(fid);
-	return ERR_PTR(err);
+	return mlxsw_sp_fid_8021d_get(mlxsw_sp, bridge_device->dev->ifindex);
 }
 
 static struct mlxsw_sp_fid *
-- 
2.24.1

