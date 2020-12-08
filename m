Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D419A2D2789
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgLHJZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:25:49 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58703 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728889AbgLHJZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:25:48 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0D93D5C01DD;
        Tue,  8 Dec 2020 04:24:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 08 Dec 2020 04:24:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=cFB10lBXIky4qUAUGrnUKRDqjWrq8BbXmsW6WdGuT+4=; b=nAFXGtIX
        G1aUp+9owziOXIcWsJE+8MLV0vX5ViT4v/9T7nA/9XxOjMeYR71OPkyUXP19Tpzg
        Rr06W9QTtfv6L4WZo7fexGfXQJ83qY2ra0Ivlxoo3pWR4PVI+c2PAx71PJacZjVe
        lS+TmSjp64YDlVa9G1JS1FDUo4j5wiBj8cajD8UkU4D15hyObKvsbNtA7dJBCrKH
        p1QKoeqlI5JbrCM/lxyeXmEaI5uXoBPonY3thH86BZx5vQY+TaQoxQ/3SObajmeH
        ZoKMsChP1O6OV/pH8ydyUfilz1HauDLEI5r7BsigM4Q+YqVH16yY804fYpeY42aY
        jGo3M8RjnyPqNA==
X-ME-Sender: <xms:MkbPX8wHMxoWtO46hFRF_Nrdq7Cvntb3DWQCq319t8sw5zLbPh1eAg>
    <xme:MkbPXwS2wWAVTf0C6hGzu8adovoG3rJ8UbOUY6AVa70x_NlTnJ3qCTwHDgfOEyNmY
    KqcIX9-Ak9Ve0E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejiedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:MkbPX-VvEnf7oJire57XdFgjW6GWJfJdtJyDcRjXOBuNqF3-ZtA0Jw>
    <xmx:MkbPX6jOYEVFVFC-8ZXL4r42b0LdOwTyj0Mloq6jy5Qpqdvw_iB9ww>
    <xmx:MkbPX-CxBvNFWQwF_qJT2hRsi7n4YterrExhggwifgumFczOE8PRiQ>
    <xmx:M0bPXx_qiy8XkSzbApG0aSKmsqt1hi5_WM1jhEmMUCAU_bWXsx4Z9g>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id 31FF3108006D;
        Tue,  8 Dec 2020 04:24:01 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/13] mlxsw: spectrum_nve_vxlan: Add support for Q-in-VNI for Spectrum-2 ASIC
Date:   Tue,  8 Dec 2020 11:22:48 +0200
Message-Id: <20201208092253.1996011-9-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201208092253.1996011-1-idosch@idosch.org>
References: <20201208092253.1996011-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

On Spectrum-2, the default setting is not to push VLAN to the decapsulated
packet. This is controlled by SPVTR.ipvid_mode.
Set SPVTR.ipvid_mode to always push VLAN.
Without this setting, Spectrum-2 overtakes the VLAN tag of decapsulated
packet for bridging.

In addition, set SPVID register to use EtherType saved in
mlxsw_sp_nve_config when VLAN is pushed for the NVE tunnel.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_nve_vxlan.c       | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
index f9a48a0109ff..b586c8f34d49 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
@@ -305,11 +305,30 @@ static bool mlxsw_sp2_nve_vxlan_learning_set(struct mlxsw_sp *mlxsw_sp,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(tnpc), tnpc_pl);
 }
 
+static int
+mlxsw_sp2_nve_decap_ethertype_set(struct mlxsw_sp *mlxsw_sp, u16 ethertype)
+{
+	char spvid_pl[MLXSW_REG_SPVID_LEN] = {};
+	u8 sver_type;
+	int err;
+
+	mlxsw_reg_spvid_tport_set(spvid_pl, true);
+	mlxsw_reg_spvid_local_port_set(spvid_pl,
+				       MLXSW_REG_TUNNEL_PORT_NVE);
+	err = mlxsw_sp_ethtype_to_sver_type(ethertype, &sver_type);
+	if (err)
+		return err;
+
+	mlxsw_reg_spvid_et_vlan_set(spvid_pl, sver_type);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(spvid), spvid_pl);
+}
+
 static int
 mlxsw_sp2_nve_vxlan_config_set(struct mlxsw_sp *mlxsw_sp,
 			       const struct mlxsw_sp_nve_config *config)
 {
 	char tngcr_pl[MLXSW_REG_TNGCR_LEN];
+	char spvtr_pl[MLXSW_REG_SPVTR_LEN];
 	u16 ul_rif_index;
 	int err;
 
@@ -330,8 +349,25 @@ mlxsw_sp2_nve_vxlan_config_set(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_tngcr_write;
 
+	mlxsw_reg_spvtr_pack(spvtr_pl, true, MLXSW_REG_TUNNEL_PORT_NVE,
+			     MLXSW_REG_SPVTR_IPVID_MODE_ALWAYS_PUSH_VLAN);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(spvtr), spvtr_pl);
+	if (err)
+		goto err_spvtr_write;
+
+	err = mlxsw_sp2_nve_decap_ethertype_set(mlxsw_sp, config->ethertype);
+	if (err)
+		goto err_decap_ethertype_set;
+
 	return 0;
 
+err_decap_ethertype_set:
+	mlxsw_reg_spvtr_pack(spvtr_pl, true, MLXSW_REG_TUNNEL_PORT_NVE,
+			     MLXSW_REG_SPVTR_IPVID_MODE_IEEE_COMPLIANT_PVID);
+	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(spvtr), spvtr_pl);
+err_spvtr_write:
+	mlxsw_reg_tngcr_pack(tngcr_pl, MLXSW_REG_TNGCR_TYPE_VXLAN, false, 0);
+	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(tngcr), tngcr_pl);
 err_tngcr_write:
 	mlxsw_sp2_nve_vxlan_learning_set(mlxsw_sp, false);
 err_vxlan_learning_set:
@@ -341,8 +377,14 @@ mlxsw_sp2_nve_vxlan_config_set(struct mlxsw_sp *mlxsw_sp,
 
 static void mlxsw_sp2_nve_vxlan_config_clear(struct mlxsw_sp *mlxsw_sp)
 {
+	char spvtr_pl[MLXSW_REG_SPVTR_LEN];
 	char tngcr_pl[MLXSW_REG_TNGCR_LEN];
 
+	/* Set default EtherType */
+	mlxsw_sp2_nve_decap_ethertype_set(mlxsw_sp, ETH_P_8021Q);
+	mlxsw_reg_spvtr_pack(spvtr_pl, true, MLXSW_REG_TUNNEL_PORT_NVE,
+			     MLXSW_REG_SPVTR_IPVID_MODE_IEEE_COMPLIANT_PVID);
+	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(spvtr), spvtr_pl);
 	mlxsw_reg_tngcr_pack(tngcr_pl, MLXSW_REG_TNGCR_TYPE_VXLAN, false, 0);
 	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(tngcr), tngcr_pl);
 	mlxsw_sp2_nve_vxlan_learning_set(mlxsw_sp, false);
-- 
2.28.0

