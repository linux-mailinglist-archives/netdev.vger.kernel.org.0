Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA9A268002
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 17:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgIMPrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 11:47:05 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58941 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725950AbgIMPqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 11:46:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 258B65C0103;
        Sun, 13 Sep 2020 11:46:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 13 Sep 2020 11:46:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=B7R87O4LZ9hpRE8mNRsAZSD3nPFAilEkENCf3sMjB00=; b=d4HxoX+m
        wPjp2pg3HQkT3z74xwXsQjxAdbf1Gxv81F2tU5k4svgeiRDY4zEp/lzkX0uug3bz
        +xH7aEx8JEBJFrod0PGkUmfwMCwrSbjEHIMqDzguCgacGVBC/V8833H6EcutKj2m
        tnRPlrpRFLMhlKvJD2jkqS7Bwg8F8FRospwT5QIoWDn5EriPdX9PHFXKAuYp9a7w
        QPcioWVeA1/G+qTFXCNTS+mVUUMOgu2n7lCk0dtnIDIonFp1ltLqZF+bk8V45HGK
        TBIX9V/TY2If7TosJDo7vXRIBiPU+wH8lB5eaWlHEJb8VjZq8qlgLOwn1xskzSW3
        UOK8pGt5uWjTUg==
X-ME-Sender: <xms:5z5eX338UUHn0jVdpQco0J3yx_0BYBRoKCoJBCNob7s2yyuX12WZtA>
    <xme:5z5eX2Hr8uk9B2Ka-YM5eKwcKlAqEgBFQBFJ-KzNtb8ds4eQsubu510TTDKK6A7PX
    erePEKip0Zf2yA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeigedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:5z5eX362s-45U8FySYZV3uKkenanpe5DyceRDlBm1X6t6rvFGCJbsQ>
    <xmx:5z5eX81Thd2-rrytXCIdKN066KpnDcqECoGEuYRzSoTTyeuwL3Z_zA>
    <xmx:5z5eX6GgTl5tkhTKzuxgww8DXiHvFKDGzSLowcsEiui2vJGsZjXaSg>
    <xmx:5z5eX2BpWtIjSY-Gl1ILMb0eoNwYtKfYUixf2tpo82is6BH9Xl6zlQ>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 31CC4328005A;
        Sun, 13 Sep 2020 11:46:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/5] mlxsw: spectrum_ethtool: Introduce ptys_max_speed callback
Date:   Sun, 13 Sep 2020 18:46:06 +0300
Message-Id: <20200913154609.14870-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200913154609.14870-1-idosch@idosch.org>
References: <20200913154609.14870-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The SBIB register configures the size of an internal buffer that the
Spectrum ASICs use when mirroring traffic on egress. This size should be
taken into account when validating that the port headroom buffers are not
larger than the chip can handle. Up until now this was not done, which is
incidentally not a problem, because the priority group buffers that mlxsw
auto-configures are small enough that the boundary condition could not be
violated.

When dcbnl_setbuffer is implemented, the user gets control over sizes of PG
buffers, and they might overshoot the headroom capacity. However the size
of the SBIB buffer depends on port speed, which cannot be vetoed. There is
obviously no way to retroactively push back on requests for overlarge PG
buffers, or reject an overlarge MTU, or cancel losslessness of a certain
PG.

Therefore, instead of taking into account the current speed when
calculating SBIB buffer size, take into account the maximum speed that a
port with given Ethernet protocol capabilities can have.

To that end, add a new ethtool callback, ptys_max_speed, which determines
this maximum speed.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  1 +
 .../mellanox/mlxsw/spectrum_ethtool.c         | 44 +++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 5240bf11b6c4..007e97e99ec8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -331,6 +331,7 @@ struct mlxsw_sp_port_type_speed_ops {
 	void (*from_ptys_speed_duplex)(struct mlxsw_sp *mlxsw_sp,
 				       bool carrier_ok, u32 ptys_eth_proto,
 				       struct ethtool_link_ksettings *cmd);
+	int (*ptys_max_speed)(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_max_speed);
 	u32 (*to_ptys_advert_link)(struct mlxsw_sp *mlxsw_sp, u8 width,
 				   const struct ethtool_link_ksettings *cmd);
 	u32 (*to_ptys_speed)(struct mlxsw_sp *mlxsw_sp, u8 width, u32 speed);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index f007e58950da..6ee0479b189f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1162,6 +1162,27 @@ mlxsw_sp1_from_ptys_speed_duplex(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
 		cmd->base.duplex = DUPLEX_FULL;
 }
 
+static int mlxsw_sp1_ptys_max_speed(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_max_speed)
+{
+	u32 eth_proto_cap;
+	u32 max_speed = 0;
+	int err;
+	int i;
+
+	err = mlxsw_sp_port_ptys_query(mlxsw_sp_port, &eth_proto_cap, NULL, NULL, NULL);
+	if (err)
+		return err;
+
+	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
+		if ((eth_proto_cap & mlxsw_sp1_port_link_mode[i].mask) &&
+		    mlxsw_sp1_port_link_mode[i].speed > max_speed)
+			max_speed = mlxsw_sp1_port_link_mode[i].speed;
+	}
+
+	*p_max_speed = max_speed;
+	return 0;
+}
+
 static u32
 mlxsw_sp1_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp, u8 width,
 			      const struct ethtool_link_ksettings *cmd)
@@ -1211,6 +1232,7 @@ const struct mlxsw_sp_port_type_speed_ops mlxsw_sp1_port_type_speed_ops = {
 	.from_ptys_link			= mlxsw_sp1_from_ptys_link,
 	.from_ptys_speed		= mlxsw_sp1_from_ptys_speed,
 	.from_ptys_speed_duplex		= mlxsw_sp1_from_ptys_speed_duplex,
+	.ptys_max_speed			= mlxsw_sp1_ptys_max_speed,
 	.to_ptys_advert_link		= mlxsw_sp1_to_ptys_advert_link,
 	.to_ptys_speed			= mlxsw_sp1_to_ptys_speed,
 	.reg_ptys_eth_pack		= mlxsw_sp1_reg_ptys_eth_pack,
@@ -1548,6 +1570,27 @@ mlxsw_sp2_from_ptys_speed_duplex(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
 		cmd->base.duplex = DUPLEX_FULL;
 }
 
+static int mlxsw_sp2_ptys_max_speed(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_max_speed)
+{
+	u32 eth_proto_cap;
+	u32 max_speed = 0;
+	int err;
+	int i;
+
+	err = mlxsw_sp_port_ptys_query(mlxsw_sp_port, &eth_proto_cap, NULL, NULL, NULL);
+	if (err)
+		return err;
+
+	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
+		if ((eth_proto_cap & mlxsw_sp2_port_link_mode[i].mask) &&
+		    mlxsw_sp2_port_link_mode[i].speed > max_speed)
+			max_speed = mlxsw_sp2_port_link_mode[i].speed;
+	}
+
+	*p_max_speed = max_speed;
+	return 0;
+}
+
 static bool
 mlxsw_sp2_test_bit_ethtool(const struct mlxsw_sp2_port_link_mode *link_mode,
 			   const unsigned long *mode)
@@ -1617,6 +1660,7 @@ const struct mlxsw_sp_port_type_speed_ops mlxsw_sp2_port_type_speed_ops = {
 	.from_ptys_link			= mlxsw_sp2_from_ptys_link,
 	.from_ptys_speed		= mlxsw_sp2_from_ptys_speed,
 	.from_ptys_speed_duplex		= mlxsw_sp2_from_ptys_speed_duplex,
+	.ptys_max_speed			= mlxsw_sp2_ptys_max_speed,
 	.to_ptys_advert_link		= mlxsw_sp2_to_ptys_advert_link,
 	.to_ptys_speed			= mlxsw_sp2_to_ptys_speed,
 	.reg_ptys_eth_pack		= mlxsw_sp2_reg_ptys_eth_pack,
-- 
2.26.2

