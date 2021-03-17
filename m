Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A6333EE72
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 11:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhCQKjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 06:39:44 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51353 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230048AbhCQKj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 06:39:26 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C2E865C014E;
        Wed, 17 Mar 2021 06:39:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 17 Mar 2021 06:39:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=6lEocncU3MOnUJEuVq0pKfdAH7H3rYp4RpAjFyvyBDc=; b=eFrtYzwN
        XGz1gEkzA/g+gixLVkJ1pSdqISOudPVutj6egynm4euoGYUfa5P8hJxQdqPh6ecO
        +LQ0BdclRiYA2zQzzSAPBHAgbFuLhQBo7g8VTkJ5ocJ5Xu+huiBGYcka3lv3mu7c
        1um24mt4f7eZoz/3X33jNtzr58gEfGSa5ir5iz3dy7jfzR3uxlOYG4XIDhwzvG4D
        1R7Vb+kxz5JyTVyu1xrkn7KAy6AAd286FKNYfOoMZTXIDlJp0wDhsx184CWOko6k
        pgGn1GZz5pKMYbanFhIpFxU076genFvrfd5+lEAUjImvHps68f2U/R6tZbgwscf1
        a/3s9Jc/5e1vsQ==
X-ME-Sender: <xms:XdxRYH2zTIVYm9RT_8lL_1LZMDGR5SMSVB06CHDWKMw4tjARn763cw>
    <xme:XdxRYGHWHNAd5XBFUzEYRfhjlvUoq5PXphTkk_bFekdDhYQvbfmK3qHOyCCaJdQKh
    OYLbG6EhQlT1_I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefgedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:XdxRYH7FrjvfdNa9BcubzxDcb5HUm96Sbtw-R0zlZ5KNMx-QAp63AQ>
    <xmx:XdxRYM225Ac5HWXbWm6b7f_E76JIzhKWPKFwTNQ25DUV-m6l019LQg>
    <xmx:XdxRYKHH3V9oRmk0ApQsYIjqLDme06mz2_1nGzbws-XSm8Q_PhbErw>
    <xmx:XdxRYGicfAi3HW_JMTmiRTV1z3HrV17Na5Z_13A5eFqSTYVQRPKLPg>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id C16C7108005C;
        Wed, 17 Mar 2021 06:39:23 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/7] mlxsw: Allow 802.1d and .1ad VxLAN bridges to coexist on Spectrum>=2
Date:   Wed, 17 Mar 2021 12:35:27 +0200
Message-Id: <20210317103529.2903172-6-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210317103529.2903172-1-idosch@idosch.org>
References: <20210317103529.2903172-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently only one EtherType can be configured for pushing in tunnels
because EtherType is configured using SPVID.et_vlan for tunnel port.

This behavior is forbidden by comparing mlxsw_sp_nve_config struct for
each new tunnel, the struct contains 'ethertype' field which means that
only one EtherType is legal at any given time. Remove 'ethertype' field to
allow creating VxLAN devices with different bridges.

To allow using several types of VxLAN bridges at the same time, the
EtherType should be determined at the egress port. This behavior is
achieved by setting SPVID to decide which EtherType to push at egress and
for each local_port which is member in 802.1ad bridge, set SPEVET.et_vlan
to ether_type1 (i.e., 0x88A8).

Use switchdev_ops->init() to set different mlxsw_sp_bridge_ops for
different ASICs in order to be able to split the behavior when port joins /
leaves an 802.1ad bridge in different ASICs.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_nve.h    |  1 -
 .../mellanox/mlxsw/spectrum_nve_vxlan.c       | 15 ++----
 .../mellanox/mlxsw/spectrum_switchdev.c       | 52 ++++++++++++++++++-
 3 files changed, 53 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
index 2796d3659979..d8104fc6c900 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
@@ -18,7 +18,6 @@ struct mlxsw_sp_nve_config {
 	u32 ul_tb_id;
 	enum mlxsw_sp_l3proto ul_proto;
 	union mlxsw_sp_l3addr ul_sip;
-	u16 ethertype;
 };
 
 struct mlxsw_sp_nve {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
index 3e2bb22e9ca6..b84bb4b65098 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
@@ -113,7 +113,6 @@ static void mlxsw_sp_nve_vxlan_config(const struct mlxsw_sp_nve *nve,
 	config->ul_proto = MLXSW_SP_L3_PROTO_IPV4;
 	config->ul_sip.addr4 = cfg->saddr.sin.sin_addr.s_addr;
 	config->udp_dport = cfg->dst_port;
-	config->ethertype = params->ethertype;
 }
 
 static int __mlxsw_sp_nve_parsing_set(struct mlxsw_sp *mlxsw_sp,
@@ -318,20 +317,14 @@ static bool mlxsw_sp2_nve_vxlan_learning_set(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int
-mlxsw_sp2_nve_decap_ethertype_set(struct mlxsw_sp *mlxsw_sp, u16 ethertype)
+mlxsw_sp2_nve_decap_ethertype_set(struct mlxsw_sp *mlxsw_sp)
 {
 	char spvid_pl[MLXSW_REG_SPVID_LEN] = {};
-	u8 sver_type;
-	int err;
 
 	mlxsw_reg_spvid_tport_set(spvid_pl, true);
 	mlxsw_reg_spvid_local_port_set(spvid_pl,
 				       MLXSW_REG_TUNNEL_PORT_NVE);
-	err = mlxsw_sp_ethtype_to_sver_type(ethertype, &sver_type);
-	if (err)
-		return err;
-
-	mlxsw_reg_spvid_et_vlan_set(spvid_pl, sver_type);
+	mlxsw_reg_spvid_egr_et_set_set(spvid_pl, true);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(spvid), spvid_pl);
 }
 
@@ -367,7 +360,7 @@ mlxsw_sp2_nve_vxlan_config_set(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_spvtr_write;
 
-	err = mlxsw_sp2_nve_decap_ethertype_set(mlxsw_sp, config->ethertype);
+	err = mlxsw_sp2_nve_decap_ethertype_set(mlxsw_sp);
 	if (err)
 		goto err_decap_ethertype_set;
 
@@ -392,8 +385,6 @@ static void mlxsw_sp2_nve_vxlan_config_clear(struct mlxsw_sp *mlxsw_sp)
 	char spvtr_pl[MLXSW_REG_SPVTR_LEN];
 	char tngcr_pl[MLXSW_REG_TNGCR_LEN];
 
-	/* Set default EtherType */
-	mlxsw_sp2_nve_decap_ethertype_set(mlxsw_sp, ETH_P_8021Q);
 	mlxsw_reg_spvtr_pack(spvtr_pl, true, MLXSW_REG_TUNNEL_PORT_NVE,
 			     MLXSW_REG_SPVTR_IPVID_MODE_IEEE_COMPLIANT_PVID);
 	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(spvtr), spvtr_pl);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 51fdbdc8ac66..c1f05c17557d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2300,7 +2300,7 @@ mlxsw_sp_bridge_8021ad_vxlan_join(struct mlxsw_sp_bridge_device *bridge_device,
 						     vid, ETH_P_8021AD, extack);
 }
 
-static const struct mlxsw_sp_bridge_ops mlxsw_sp_bridge_8021ad_ops = {
+static const struct mlxsw_sp_bridge_ops mlxsw_sp1_bridge_8021ad_ops = {
 	.port_join	= mlxsw_sp_bridge_8021ad_port_join,
 	.port_leave	= mlxsw_sp_bridge_8021ad_port_leave,
 	.vxlan_join	= mlxsw_sp_bridge_8021ad_vxlan_join,
@@ -2309,6 +2309,53 @@ static const struct mlxsw_sp_bridge_ops mlxsw_sp_bridge_8021ad_ops = {
 	.fid_vid	= mlxsw_sp_bridge_8021q_fid_vid,
 };
 
+static int
+mlxsw_sp2_bridge_8021ad_port_join(struct mlxsw_sp_bridge_device *bridge_device,
+				  struct mlxsw_sp_bridge_port *bridge_port,
+				  struct mlxsw_sp_port *mlxsw_sp_port,
+				  struct netlink_ext_ack *extack)
+{
+	int err;
+
+	/* The EtherType of decapsulated packets is determined at the egress
+	 * port to allow 802.1d and 802.1ad bridges with VXLAN devices to
+	 * co-exist.
+	 */
+	err = mlxsw_sp_port_egress_ethtype_set(mlxsw_sp_port, ETH_P_8021AD);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_bridge_8021ad_port_join(bridge_device, bridge_port,
+					       mlxsw_sp_port, extack);
+	if (err)
+		goto err_bridge_8021ad_port_join;
+
+	return 0;
+
+err_bridge_8021ad_port_join:
+	mlxsw_sp_port_egress_ethtype_set(mlxsw_sp_port, ETH_P_8021Q);
+	return err;
+}
+
+static void
+mlxsw_sp2_bridge_8021ad_port_leave(struct mlxsw_sp_bridge_device *bridge_device,
+				   struct mlxsw_sp_bridge_port *bridge_port,
+				   struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	mlxsw_sp_bridge_8021ad_port_leave(bridge_device, bridge_port,
+					  mlxsw_sp_port);
+	mlxsw_sp_port_egress_ethtype_set(mlxsw_sp_port, ETH_P_8021Q);
+}
+
+static const struct mlxsw_sp_bridge_ops mlxsw_sp2_bridge_8021ad_ops = {
+	.port_join	= mlxsw_sp2_bridge_8021ad_port_join,
+	.port_leave	= mlxsw_sp2_bridge_8021ad_port_leave,
+	.vxlan_join	= mlxsw_sp_bridge_8021ad_vxlan_join,
+	.fid_get	= mlxsw_sp_bridge_8021q_fid_get,
+	.fid_lookup	= mlxsw_sp_bridge_8021q_fid_lookup,
+	.fid_vid	= mlxsw_sp_bridge_8021q_fid_vid,
+};
+
 int mlxsw_sp_port_bridge_join(struct mlxsw_sp_port *mlxsw_sp_port,
 			      struct net_device *brport_dev,
 			      struct net_device *br_dev,
@@ -3541,6 +3588,7 @@ static void mlxsw_sp_fdb_fini(struct mlxsw_sp *mlxsw_sp)
 
 static void mlxsw_sp1_switchdev_init(struct mlxsw_sp *mlxsw_sp)
 {
+	mlxsw_sp->bridge->bridge_8021ad_ops = &mlxsw_sp1_bridge_8021ad_ops;
 }
 
 const struct mlxsw_sp_switchdev_ops mlxsw_sp1_switchdev_ops = {
@@ -3549,6 +3597,7 @@ const struct mlxsw_sp_switchdev_ops mlxsw_sp1_switchdev_ops = {
 
 static void mlxsw_sp2_switchdev_init(struct mlxsw_sp *mlxsw_sp)
 {
+	mlxsw_sp->bridge->bridge_8021ad_ops = &mlxsw_sp2_bridge_8021ad_ops;
 }
 
 const struct mlxsw_sp_switchdev_ops mlxsw_sp2_switchdev_ops = {
@@ -3569,7 +3618,6 @@ int mlxsw_sp_switchdev_init(struct mlxsw_sp *mlxsw_sp)
 
 	bridge->bridge_8021q_ops = &mlxsw_sp_bridge_8021q_ops;
 	bridge->bridge_8021d_ops = &mlxsw_sp_bridge_8021d_ops;
-	bridge->bridge_8021ad_ops = &mlxsw_sp_bridge_8021ad_ops;
 
 	mlxsw_sp->switchdev_ops->init(mlxsw_sp);
 
-- 
2.29.2

