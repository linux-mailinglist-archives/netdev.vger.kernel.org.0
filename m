Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED312D2787
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgLHJZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:25:45 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37725 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728874AbgLHJZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:25:43 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BB9195C01FA;
        Tue,  8 Dec 2020 04:24:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 08 Dec 2020 04:24:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=qARjGeYESIyNzjbi90pUgpMWrsOEmIVcMPuMvq2ONTM=; b=haMc5Y0Y
        LcIGDas7JFqxcvLYVm7Ee1cszFRN5SEtGyvzbWMEguq3NDPqv2/dOnyROcTTXfIH
        DkXDeUfaNtzbtiDqYt6dz7Q3OSnS+6OmEyj3m9eCflY7e1dLncW55jLP6ogZUqnx
        zCWigNwS8Tule6i/xjqjviVrX0+/+Z1YzmqheQDZCrbClwQt/1XAEQ41f7oKhs0S
        jKJUStk3IW/Ga77UNKRORrlp+cMFyVIxTYKKx2qt2UTAdsECIwuE2+y0JBMBy3s1
        E7EbGdO6EUOVDm++kJZBlrZAhvKKDn+sr5hvdkTHVjxn5O0+GcYegssYuGne4/WO
        EkfdtjU3odt0KA==
X-ME-Sender: <xms:NEbPXxmONVQRe_zWskSTITJ5R0_eGWXLEM0tUXUrJLM2YOkjosKHtQ>
    <xme:NEbPX80Seu23gKQ0IyRqNxwLZwHKocd5Df3zRyRfu3iPBdTTfeDT5KGBKmxVhuYrJ
    O84QQ4z_tOlols>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejiedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:NEbPX3qHOtwWH6pplMIZ2eGV5swF20ALEJVMYJsjUeW9swc-IFkvkw>
    <xmx:NEbPXxm3_k_akimWwuONhGsDdf3q4sPNWNSRWhPvZD9i2PulbwAG0Q>
    <xmx:NEbPX_0vRJ269z57zv_79Zg-JF64mXaiAOBMjMX1hq7glsJk-Cwlcw>
    <xmx:NEbPX6R9-d8Jb_0XGCX3_r0lAHJf6ePFykQsFqlo5eDwlwcdGmY-Aw>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2CDF91080066;
        Tue,  8 Dec 2020 04:24:03 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/13] mlxsw: spectrum_switchdev: Use ops->vxlan_join() when adding VLAN to VxLAN device
Date:   Tue,  8 Dec 2020 11:22:49 +0200
Message-Id: <20201208092253.1996011-10-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201208092253.1996011-1-idosch@idosch.org>
References: <20201208092253.1996011-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently mlxsw_sp_switchdev_vxlan_vlan_add() always calls
mlxsw_sp_bridge_8021q_vxlan_join() because VLANs were only ever added to
a VLAN-filtering bridge, which is only 802.1q bridge.

This set adds support for VxLAN with 802.1ad bridge, so VLAN-filtering
bridge is not only 802.1q.

Call ops->vxlan_join(), so mlxsw_sp_bridge_802{1q, 1ad}_vxlan_join()
will be called according to bridge type.

This is needed to ensure that VxLAN with 802.1ad bridge will be vetoed
in Spectrum-1 with the next patch.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_switchdev.c   | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 051a77440afe..73290f71eb9c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -3320,8 +3320,8 @@ mlxsw_sp_switchdev_vxlan_vlan_add(struct mlxsw_sp *mlxsw_sp,
 	if (!fid) {
 		if (!flag_untagged || !flag_pvid)
 			return 0;
-		return mlxsw_sp_bridge_8021q_vxlan_join(bridge_device,
-							vxlan_dev, vid, extack);
+		return bridge_device->ops->vxlan_join(bridge_device, vxlan_dev,
+						      vid, extack);
 	}
 
 	/* Second case: FID is associated with the VNI and the VLAN associated
@@ -3360,16 +3360,14 @@ mlxsw_sp_switchdev_vxlan_vlan_add(struct mlxsw_sp *mlxsw_sp,
 	if (!flag_untagged)
 		return 0;
 
-	err = mlxsw_sp_bridge_8021q_vxlan_join(bridge_device, vxlan_dev, vid,
-					       extack);
+	err = bridge_device->ops->vxlan_join(bridge_device, vxlan_dev, vid, extack);
 	if (err)
 		goto err_vxlan_join;
 
 	return 0;
 
 err_vxlan_join:
-	mlxsw_sp_bridge_8021q_vxlan_join(bridge_device, vxlan_dev, old_vid,
-					 NULL);
+	bridge_device->ops->vxlan_join(bridge_device, vxlan_dev, old_vid, NULL);
 	return err;
 }
 
-- 
2.28.0

