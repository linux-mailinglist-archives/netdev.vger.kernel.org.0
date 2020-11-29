Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98B42C7929
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 13:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387432AbgK2Mz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 07:55:56 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:58845 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387411AbgK2Mzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 07:55:55 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 1379A5806C5;
        Sun, 29 Nov 2020 07:54:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 29 Nov 2020 07:54:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=DiRbdTs7WQxon9fAX7daVlgR40z9HvnDPEM/WIWV2hw=; b=VLIO6L8G
        KGul0TSBqVcqKsJMgzFAuWN8kVbPNBUAgp4rakgx3u0ysYPUm2qTGXLPRuj+LcqX
        P17iSxJqWMHLYE1o13ZrbF/2UlgLAvuM3uPtA4pH9Ai7hjQ0hR0+b8WDuhr1Ty4L
        /zXwyJnz6XqjR8pVO7SG36PlkR2miGduzovSMnXkuMOsrnP1mNuh47CZqpB0io/3
        2LC86c2OV0VQaWoSoSFA7cELM0PbF6grHPcKTDRFIdy6+cpYfx86xByC/6+wyC9i
        XbnTr3+lXyBE+0BV3B9dYqjcsbMvfDVPpRXKGpmq47meO/ypS7unTaOKDNH7m68l
        lD66uclLuuUi4Q==
X-ME-Sender: <xms:GJrDX1UIkHglL8-f-7BlZNlZ1IYwDrmaI8mT1Wc70V1I157neC52fg>
    <xme:GJrDX1kGImlMEqBLkvpMzWbii-mhgGg5w24QnabfNa69yeefCMelZUOwieqxvLLlF
    os2s7jd8bpx5Kk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehkedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:GJrDXxYCnVShTUmUGtBpVl-Jc-9Wx76GuUQA6Cqs6Z8LNnxDZHRCMQ>
    <xmx:GJrDX4UT5VsSLyoJgf-e9fMcmuuEj53JeGKrwXnbhCj-opXjIlZ4Pw>
    <xmx:GJrDX_mR8oAKiGtXYQ8ucsSz5A0Qymi7quJMQeUQDzIZjn9XBpDQ5w>
    <xmx:GZrDX4gfqvQuHgx4lCsuTuu6hoCQklCHoTTWQFShS-vu-ls-MlgUCA>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id E53143064AAE;
        Sun, 29 Nov 2020 07:54:46 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, nikolay@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/9] mlxsw: Make EtherType configurable when pushing VLAN at ingress
Date:   Sun, 29 Nov 2020 14:54:02 +0200
Message-Id: <20201129125407.1391557-5-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201129125407.1391557-1-idosch@idosch.org>
References: <20201129125407.1391557-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently, when pushing a PVID at ingress, mlxsw always uses 802.1q
EtherType.

Make this EtherType configurable by extending mlxsw_sp_port_pvid_set()
with an EtherType argument.

This is a preparation for QinQ support, that needs to push a PVID with
802.1ad EtherType.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 41 +++++++++++++++----
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  3 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       | 13 ++++--
 4 files changed, 48 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index bea919b92f76..1077ed2046fe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -851,11 +851,13 @@ MLXSW_ITEM32(reg, spvid, et_vlan, 0x04, 16, 2);
  */
 MLXSW_ITEM32(reg, spvid, pvid, 0x04, 0, 12);
 
-static inline void mlxsw_reg_spvid_pack(char *payload, u8 local_port, u16 pvid)
+static inline void mlxsw_reg_spvid_pack(char *payload, u8 local_port, u16 pvid,
+					u8 et_vlan)
 {
 	MLXSW_REG_ZERO(spvid, payload);
 	mlxsw_reg_spvid_local_port_set(payload, local_port);
 	mlxsw_reg_spvid_pvid_set(payload, pvid);
+	mlxsw_reg_spvid_et_vlan_set(payload, et_vlan);
 }
 
 /* SPVM - Switch Port VLAN Membership
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index ee0c4d098c78..6ecd9a4dceee 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -384,13 +384,37 @@ int mlxsw_sp_port_vid_learning_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid,
 	return err;
 }
 
+static int mlxsw_sp_ethtype_to_sver_type(u16 ethtype, u8 *p_sver_type)
+{
+	switch (ethtype) {
+	case ETH_P_8021Q:
+		*p_sver_type = 0;
+		break;
+	case ETH_P_8021AD:
+		*p_sver_type = 1;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int __mlxsw_sp_port_pvid_set(struct mlxsw_sp_port *mlxsw_sp_port,
-				    u16 vid)
+				    u16 vid, u16 ethtype)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	char spvid_pl[MLXSW_REG_SPVID_LEN];
+	u8 sver_type;
+	int err;
+
+	err = mlxsw_sp_ethtype_to_sver_type(ethtype, &sver_type);
+	if (err)
+		return err;
+
+	mlxsw_reg_spvid_pack(spvid_pl, mlxsw_sp_port->local_port, vid,
+			     sver_type);
 
-	mlxsw_reg_spvid_pack(spvid_pl, mlxsw_sp_port->local_port, vid);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(spvid), spvid_pl);
 }
 
@@ -404,7 +428,8 @@ static int mlxsw_sp_port_allow_untagged_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(spaft), spaft_pl);
 }
 
-int mlxsw_sp_port_pvid_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid)
+int mlxsw_sp_port_pvid_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid,
+			   u16 ethtype)
 {
 	int err;
 
@@ -413,7 +438,7 @@ int mlxsw_sp_port_pvid_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid)
 		if (err)
 			return err;
 	} else {
-		err = __mlxsw_sp_port_pvid_set(mlxsw_sp_port, vid);
+		err = __mlxsw_sp_port_pvid_set(mlxsw_sp_port, vid, ethtype);
 		if (err)
 			return err;
 		err = mlxsw_sp_port_allow_untagged_set(mlxsw_sp_port, true);
@@ -425,7 +450,7 @@ int mlxsw_sp_port_pvid_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid)
 	return 0;
 
 err_port_allow_untagged_set:
-	__mlxsw_sp_port_pvid_set(mlxsw_sp_port, mlxsw_sp_port->pvid);
+	__mlxsw_sp_port_pvid_set(mlxsw_sp_port, mlxsw_sp_port->pvid, ethtype);
 	return err;
 }
 
@@ -1588,7 +1613,8 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 		goto err_port_nve_init;
 	}
 
-	err = mlxsw_sp_port_pvid_set(mlxsw_sp_port, MLXSW_SP_DEFAULT_VID);
+	err = mlxsw_sp_port_pvid_set(mlxsw_sp_port, MLXSW_SP_DEFAULT_VID,
+				     ETH_P_8021Q);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Failed to set PVID\n",
 			mlxsw_sp_port->local_port);
@@ -3644,7 +3670,8 @@ static void mlxsw_sp_port_lag_leave(struct mlxsw_sp_port *mlxsw_sp_port,
 	lag->ref_count--;
 
 	/* Make sure untagged frames are allowed to ingress */
-	mlxsw_sp_port_pvid_set(mlxsw_sp_port, MLXSW_SP_DEFAULT_VID);
+	mlxsw_sp_port_pvid_set(mlxsw_sp_port, MLXSW_SP_DEFAULT_VID,
+			       ETH_P_8021Q);
 }
 
 static int mlxsw_sp_lag_dist_port_add(struct mlxsw_sp_port *mlxsw_sp_port,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 642099fee380..338a4c9e329c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -580,7 +580,8 @@ int mlxsw_sp_port_vid_stp_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid,
 int mlxsw_sp_port_vp_mode_set(struct mlxsw_sp_port *mlxsw_sp_port, bool enable);
 int mlxsw_sp_port_vid_learning_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid,
 				   bool learn_enable);
-int mlxsw_sp_port_pvid_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid);
+int mlxsw_sp_port_pvid_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid,
+			   u16 ethtype);
 struct mlxsw_sp_port_vlan *
 mlxsw_sp_port_vlan_create(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid);
 void mlxsw_sp_port_vlan_destroy(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 6501ce94ace5..a4aa2f620066 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1129,6 +1129,7 @@ mlxsw_sp_bridge_port_vlan_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	u16 pvid = mlxsw_sp_port_pvid_determine(mlxsw_sp_port, vid, is_pvid);
 	struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan;
 	u16 old_pvid = mlxsw_sp_port->pvid;
+	u16 proto;
 	int err;
 
 	/* The only valid scenario in which a port-vlan already exists, is if
@@ -1152,7 +1153,8 @@ mlxsw_sp_bridge_port_vlan_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (err)
 		goto err_port_vlan_set;
 
-	err = mlxsw_sp_port_pvid_set(mlxsw_sp_port, pvid);
+	br_vlan_get_proto(bridge_port->bridge_device->dev, &proto);
+	err = mlxsw_sp_port_pvid_set(mlxsw_sp_port, pvid, proto);
 	if (err)
 		goto err_port_pvid_set;
 
@@ -1164,7 +1166,7 @@ mlxsw_sp_bridge_port_vlan_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	return 0;
 
 err_port_vlan_bridge_join:
-	mlxsw_sp_port_pvid_set(mlxsw_sp_port, old_pvid);
+	mlxsw_sp_port_pvid_set(mlxsw_sp_port, old_pvid, proto);
 err_port_pvid_set:
 	mlxsw_sp_port_vlan_set(mlxsw_sp_port, vid, vid, false, false);
 err_port_vlan_set:
@@ -1821,13 +1823,15 @@ mlxsw_sp_bridge_port_vlan_del(struct mlxsw_sp_port *mlxsw_sp_port,
 {
 	u16 pvid = mlxsw_sp_port->pvid == vid ? 0 : mlxsw_sp_port->pvid;
 	struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan;
+	u16 proto;
 
 	mlxsw_sp_port_vlan = mlxsw_sp_port_vlan_find_by_vid(mlxsw_sp_port, vid);
 	if (WARN_ON(!mlxsw_sp_port_vlan))
 		return;
 
 	mlxsw_sp_port_vlan_bridge_leave(mlxsw_sp_port_vlan);
-	mlxsw_sp_port_pvid_set(mlxsw_sp_port, pvid);
+	br_vlan_get_proto(bridge_port->bridge_device->dev, &proto);
+	mlxsw_sp_port_pvid_set(mlxsw_sp_port, pvid, proto);
 	mlxsw_sp_port_vlan_set(mlxsw_sp_port, vid, vid, false, false);
 	mlxsw_sp_port_vlan_destroy(mlxsw_sp_port_vlan);
 }
@@ -1998,7 +2002,8 @@ mlxsw_sp_bridge_8021q_port_leave(struct mlxsw_sp_bridge_device *bridge_device,
 				 struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	/* Make sure untagged frames are allowed to ingress */
-	mlxsw_sp_port_pvid_set(mlxsw_sp_port, MLXSW_SP_DEFAULT_VID);
+	mlxsw_sp_port_pvid_set(mlxsw_sp_port, MLXSW_SP_DEFAULT_VID,
+			       ETH_P_8021Q);
 }
 
 static int
-- 
2.28.0

