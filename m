Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0F12D2776
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgLHJYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:24:42 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37927 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726114AbgLHJYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:24:42 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 02E115C0135;
        Tue,  8 Dec 2020 04:23:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 08 Dec 2020 04:23:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=+FAmX1kon5nSPRvBvfqE9FZCV5ipbP3rriT8nrDjmFw=; b=EU0zu+PS
        gYqkPrUeXC2Zcvsryv6U6aGGS97cbOdg10JAwLtsZNQIbitgGaUEGfolBmvvO9hP
        AtzvZF63F6Cvq8hQ4zCyT7OzLvJ5aYv1VBACp7qiiv6CQENbzMX24CR/WuCIerMB
        QofcAv9H5gYhM0/ZfRQWRvftMB4Wc/B5Xv5emV/uk5LZy6dgZGMNlOD6bACA4d/X
        phWEC7iz0gsfa8oDgV5+6uujeRZnv3wJ4BBWQlyhrytLCD72xkxTIYec4TVr8W9i
        BEsDAWcS0pUgHqM2Vlath30bHPODkywSk0NO8zStjAXvB7CvLvAYBGoW6QJY2OHm
        UbupzwQz1jpe5A==
X-ME-Sender: <xms:K0bPX7GkOfbKXm9eU2MT3fu8Rrdp0cOYbcgMTooiPC2W2rgDp0Nopw>
    <xme:K0bPX_wcgKNKn6AjCK0c8FlDR1JjO15rgM1kt7vi_UjY6hgdXnKhtc19dA80yN8es
    PKXeqelpioqw-Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejiedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:K0bPX6jHZCwsDsP3ozC4fcnqjmRt0w7biQwkJ4c1rvsC8azm-_V7aA>
    <xmx:K0bPXyx29BkmvdBxbx5GKm4lGhsdt7sI7E7A2uHytD3yzMS7HXx4uA>
    <xmx:K0bPX1JUMzJZclUqRVhyQmE8cHepu_hHWeQSmEeuFpfbvZyXXbxmng>
    <xmx:K0bPX9KViyTY6UiJ7PZZtbbBSZ1RMerK3n_zYRa8rYBZl61J0DP8Ag>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id 82F481080069;
        Tue,  8 Dec 2020 04:23:54 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/13] mlxsw: spectrum_switchdev: Create common function for joining VxLAN to VLAN-aware bridge
Date:   Tue,  8 Dec 2020 11:22:44 +0200
Message-Id: <20201208092253.1996011-5-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201208092253.1996011-1-idosch@idosch.org>
References: <20201208092253.1996011-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The code in mlxsw_sp_bridge_8021q_vxlan_join() can be used also for
802.1ad bridge.

Move the code to function called mlxsw_sp_bridge_vlan_aware_vxlan_join()
and call it from mlxsw_sp_bridge_8021q_vxlan_join() to enable code
reuse.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c  | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 9c4e17607e6a..c53e0ab9f971 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2053,9 +2053,9 @@ mlxsw_sp_bridge_8021q_port_leave(struct mlxsw_sp_bridge_device *bridge_device,
 }
 
 static int
-mlxsw_sp_bridge_8021q_vxlan_join(struct mlxsw_sp_bridge_device *bridge_device,
-				 const struct net_device *vxlan_dev, u16 vid,
-				 struct netlink_ext_ack *extack)
+mlxsw_sp_bridge_vlan_aware_vxlan_join(struct mlxsw_sp_bridge_device *bridge_device,
+				      const struct net_device *vxlan_dev,
+				      u16 vid, struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_lower_get(bridge_device->dev);
 	struct vxlan_dev *vxlan = netdev_priv(vxlan_dev);
@@ -2101,6 +2101,15 @@ mlxsw_sp_bridge_8021q_vxlan_join(struct mlxsw_sp_bridge_device *bridge_device,
 	return err;
 }
 
+static int
+mlxsw_sp_bridge_8021q_vxlan_join(struct mlxsw_sp_bridge_device *bridge_device,
+				 const struct net_device *vxlan_dev, u16 vid,
+				 struct netlink_ext_ack *extack)
+{
+	return mlxsw_sp_bridge_vlan_aware_vxlan_join(bridge_device, vxlan_dev,
+						     vid, extack);
+}
+
 static struct net_device *
 mlxsw_sp_bridge_8021q_vxlan_dev_find(struct net_device *br_dev, u16 vid)
 {
-- 
2.28.0

