Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1BE62D277D
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgLHJZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:25:22 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46067 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728587AbgLHJZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:25:21 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 6AFBA5C01EB;
        Tue,  8 Dec 2020 04:23:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 08 Dec 2020 04:23:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=oEpIkzu4XhnmcFZbDW6rpkwBaQDHzLWt29l+dLPPJTI=; b=KB4Buu8v
        gCl+00MnHjEGQ+sVd/9n7nGDcRcJpQbeMmkdk4wPFmSbcrvl8zFcgn+LfE/4BrDs
        svIpBS2Ez4kusa0hs5dOWp6ViK9OwAeXcrA+l7+lkacoCPzyZgqGuUVDnpT5FGa4
        ZYpuEwWAPCZdDQdbFrIc9XsJU4PiQBQulbsdz13+lHnwm/2JXevVX0yXWNpqer+v
        wFYoFN6E6fbHdCSpicS3EVj9NZlEvIRDKJVbta+//Qidq8hv5Xcdz4SU/YuC8eaT
        PFt4Vug/yzKksHGrAvi90Lb8hwC4OH4MCVtqBUp95YfJHP7wO1CxM0Zcg5m5k75b
        aSqXkc+sBiSUuw==
X-ME-Sender: <xms:L0bPX7cm9nfQ_J9IVQyJ6yPRCX4pZNGGS_wyrXI-9mM6o5_IsZ6GPg>
    <xme:L0bPX-zBjogB9tBtSml11AkV__crNF8Yu-8w9XNgdoeFBi9YnDYiTNcs0Au01yCtQ
    c9FHGy7MR2y3VY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejiedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:L0bPX68HQmOjPNTjxovsNaOy3zvoMuvQULwH08t6wpboiDFwjwypZg>
    <xmx:L0bPX-hTDbUWIlqbV1HpKn3jCuTj6nFYf6InJ7KXVKOPJm3iwOrJ8g>
    <xmx:L0bPX5GJPOxSVAdn3Rt1yLAXVm1sykZfEKwXxqjEzmL8BF1xfe6-Yg>
    <xmx:L0bPXzDbUf_U0hTQ36Rz1TfsgldEYQl2w1kwSaPAbmACgXWel-fZ5w>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id D860F1080069;
        Tue,  8 Dec 2020 04:23:57 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/13] mlxsw: Save EtherType as part of mlxsw_sp_nve_config
Date:   Tue,  8 Dec 2020 11:22:46 +0200
Message-Id: <20201208092253.1996011-7-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201208092253.1996011-1-idosch@idosch.org>
References: <20201208092253.1996011-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add EtherType field to mlxsw_sp_nve_config struct.
Set EtherType according to mlxsw_sp_nve_params.ethertype.

Pass 'mlxsw_sp_nve_params' instead of 'mlxsw_sp_nve_params->dev' to the
function which initializes mlxsw_sp_nve_config struct to know which
EtherType to use.

This field is needed to configure which EtherType will be used when
VLAN is pushed at ingress of the tunnel port.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c       | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h       | 3 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c | 5 +++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
index ed0d334b5fd1..adf499665f87 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
@@ -802,7 +802,7 @@ int mlxsw_sp_nve_fid_enable(struct mlxsw_sp *mlxsw_sp, struct mlxsw_sp_fid *fid,
 		return -EINVAL;
 
 	memset(&config, 0, sizeof(config));
-	ops->nve_config(nve, params->dev, &config);
+	ops->nve_config(nve, params, &config);
 	if (nve->num_nve_tunnels &&
 	    memcmp(&config, &nve->config, sizeof(config))) {
 		NL_SET_ERR_MSG_MOD(extack, "Conflicting NVE tunnels configuration");
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
index 12f664f42f21..68bd9422be2a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
@@ -18,6 +18,7 @@ struct mlxsw_sp_nve_config {
 	u32 ul_tb_id;
 	enum mlxsw_sp_l3proto ul_proto;
 	union mlxsw_sp_l3addr ul_sip;
+	u16 ethertype;
 };
 
 struct mlxsw_sp_nve {
@@ -38,7 +39,7 @@ struct mlxsw_sp_nve_ops {
 			    const struct net_device *dev,
 			    struct netlink_ext_ack *extack);
 	void (*nve_config)(const struct mlxsw_sp_nve *nve,
-			   const struct net_device *dev,
+			   const struct mlxsw_sp_nve_params *params,
 			   struct mlxsw_sp_nve_config *config);
 	int (*init)(struct mlxsw_sp_nve *nve,
 		    const struct mlxsw_sp_nve_config *config);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
index e9bff13ec264..f9a48a0109ff 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
@@ -87,10 +87,10 @@ static bool mlxsw_sp_nve_vxlan_can_offload(const struct mlxsw_sp_nve *nve,
 }
 
 static void mlxsw_sp_nve_vxlan_config(const struct mlxsw_sp_nve *nve,
-				      const struct net_device *dev,
+				      const struct mlxsw_sp_nve_params *params,
 				      struct mlxsw_sp_nve_config *config)
 {
-	struct vxlan_dev *vxlan = netdev_priv(dev);
+	struct vxlan_dev *vxlan = netdev_priv(params->dev);
 	struct vxlan_config *cfg = &vxlan->cfg;
 
 	config->type = MLXSW_SP_NVE_TYPE_VXLAN;
@@ -101,6 +101,7 @@ static void mlxsw_sp_nve_vxlan_config(const struct mlxsw_sp_nve *nve,
 	config->ul_proto = MLXSW_SP_L3_PROTO_IPV4;
 	config->ul_sip.addr4 = cfg->saddr.sin.sin_addr.s_addr;
 	config->udp_dport = cfg->dst_port;
+	config->ethertype = params->ethertype;
 }
 
 static int __mlxsw_sp_nve_parsing_set(struct mlxsw_sp *mlxsw_sp,
-- 
2.28.0

