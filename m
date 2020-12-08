Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819462D2786
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgLHJZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:25:44 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39691 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728878AbgLHJZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:25:43 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 588FC5C01E7;
        Tue,  8 Dec 2020 04:24:06 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 08 Dec 2020 04:24:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=KzZ9fuezIKgPr9liWBau5JjrSUVWp29t4hpsdCZwq7Y=; b=mkoYj3Ux
        UltPTmGfZ6YY0KckuXmuc3BDeVJWWOIrR6LZxwpE5nEx8q7/e0n7/p+p2XnHodpT
        hTxxa+WY/+/HQlyx3Ofo/5UJGouHQJze2TBvHi2MD12lX8WzQ6RRe8C8MLBM0RAT
        WrnhpaRlc7voGIMxXLb9n5BUt6KKMAEBeXYlBvfljTTAFjC4lY1zfVqeOv9fNfwT
        Dh5UE43/BcKgqe5M1Sn7hzAz+LoyrpOYZu6vulGyueqQgiM2QSLDqVOZ89Sf7OHk
        6FpASeLT7Pdcrd0Xfsa3ufP+ihq1ftlZ4tLBY3zSgf5SDzn3hv+o9Mw0pZDAOUd4
        ODyIdnvag16qyQ==
X-ME-Sender: <xms:NkbPXyb7JcTZmGgkw14pCmeXMxqE5ACcPGkU9s4jeP2jrpHdpnl7ag>
    <xme:NkbPX1YvzmbQeWVncALLd11i0RAni_L3IJ8Nx3AvgomQpTuOgTC6yArAqKrsmRm3H
    XRaFeptPQKdttM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejiedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:NkbPX8_D-TL-RPvplReK-JE8jh7GzpJuUODoccx4Cm2Uq-_fdYGgzQ>
    <xmx:NkbPX0rF-2P4iHlzNDw6oYzpTM2t7uYAMnw4yjxPUHzf-hRT9JvFng>
    <xmx:NkbPX9pA7w2jNM4dOtFkKRh0zOahG4763CJLA60a6teHzRjsXJ0OsA>
    <xmx:NkbPX-kZMaZTgv0h3M0QRqPW2FB_N1il_oceNBhicrCowerEXr6GZg>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id DB5FA1080064;
        Tue,  8 Dec 2020 04:24:04 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/13] mlxsw: Veto Q-in-VNI for Spectrum-1 ASIC
Date:   Tue,  8 Dec 2020 11:22:50 +0200
Message-Id: <20201208092253.1996011-11-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201208092253.1996011-1-idosch@idosch.org>
References: <20201208092253.1996011-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Implementation of Q-in-VNI is different between ASIC types, this set adds
support only for Spectrum-2.

Return an error when trying to create VxLAN device and enslave it to
802.1ad bridge in Spectrum-1.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_nve.c |  2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_nve.h |  2 +-
 .../mellanox/mlxsw/spectrum_nve_vxlan.c        | 18 +++++++++++++++---
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
index adf499665f87..e5ec595593f4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
@@ -798,7 +798,7 @@ int mlxsw_sp_nve_fid_enable(struct mlxsw_sp *mlxsw_sp, struct mlxsw_sp_fid *fid,
 
 	ops = nve->nve_ops_arr[params->type];
 
-	if (!ops->can_offload(nve, params->dev, extack))
+	if (!ops->can_offload(nve, params, extack))
 		return -EINVAL;
 
 	memset(&config, 0, sizeof(config));
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
index 68bd9422be2a..2796d3659979 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
@@ -36,7 +36,7 @@ struct mlxsw_sp_nve {
 struct mlxsw_sp_nve_ops {
 	enum mlxsw_sp_nve_type type;
 	bool (*can_offload)(const struct mlxsw_sp_nve *nve,
-			    const struct net_device *dev,
+			    const struct mlxsw_sp_nve_params *params,
 			    struct netlink_ext_ack *extack);
 	void (*nve_config)(const struct mlxsw_sp_nve *nve,
 			   const struct mlxsw_sp_nve_params *params,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
index b586c8f34d49..3e2bb22e9ca6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
@@ -22,10 +22,10 @@
 						 VXLAN_F_LEARN)
 
 static bool mlxsw_sp_nve_vxlan_can_offload(const struct mlxsw_sp_nve *nve,
-					   const struct net_device *dev,
+					   const struct mlxsw_sp_nve_params *params,
 					   struct netlink_ext_ack *extack)
 {
-	struct vxlan_dev *vxlan = netdev_priv(dev);
+	struct vxlan_dev *vxlan = netdev_priv(params->dev);
 	struct vxlan_config *cfg = &vxlan->cfg;
 
 	if (cfg->saddr.sa.sa_family != AF_INET) {
@@ -86,6 +86,18 @@ static bool mlxsw_sp_nve_vxlan_can_offload(const struct mlxsw_sp_nve *nve,
 	return true;
 }
 
+static bool mlxsw_sp1_nve_vxlan_can_offload(const struct mlxsw_sp_nve *nve,
+					    const struct mlxsw_sp_nve_params *params,
+					    struct netlink_ext_ack *extack)
+{
+	if (params->ethertype == ETH_P_8021AD) {
+		NL_SET_ERR_MSG_MOD(extack, "VxLAN: 802.1ad bridge is not supported with VxLAN");
+		return false;
+	}
+
+	return mlxsw_sp_nve_vxlan_can_offload(nve, params, extack);
+}
+
 static void mlxsw_sp_nve_vxlan_config(const struct mlxsw_sp_nve *nve,
 				      const struct mlxsw_sp_nve_params *params,
 				      struct mlxsw_sp_nve_config *config)
@@ -287,7 +299,7 @@ mlxsw_sp_nve_vxlan_clear_offload(const struct net_device *nve_dev, __be32 vni)
 
 const struct mlxsw_sp_nve_ops mlxsw_sp1_nve_vxlan_ops = {
 	.type		= MLXSW_SP_NVE_TYPE_VXLAN,
-	.can_offload	= mlxsw_sp_nve_vxlan_can_offload,
+	.can_offload	= mlxsw_sp1_nve_vxlan_can_offload,
 	.nve_config	= mlxsw_sp_nve_vxlan_config,
 	.init		= mlxsw_sp1_nve_vxlan_init,
 	.fini		= mlxsw_sp1_nve_vxlan_fini,
-- 
2.28.0

