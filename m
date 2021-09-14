Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F8840A693
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 08:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240137AbhINGPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 02:15:50 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56079 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240084AbhINGPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 02:15:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6D7ED5C0182;
        Tue, 14 Sep 2021 02:14:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 14 Sep 2021 02:14:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=xS3xlAxUW//YYfgUpBMATPmt06rrXFMy4gumBN9EO2A=; b=kedTbeF/
        fn5j2hko8rpABko6RvYz5REwJbw8Japh1afnDt5bnWP+Xukk7p8gvpgfh7Vo4YWj
        TaEa9pkOUOEK9g3OqpazWkNjUOdqyl34E8kbCzOxu12ePSZtfmNcZBdSCPshstd+
        LCVKUqQxEdZwsSxcxhNSRewnP4gOAo2SV2GIWNSu+PXi7tA97ZDdspFGG8o/yn5h
        C5gZm61LgSv8PC3rwr5qG/x088SuinVEef7vMlykjuJODSUZ8j/pBzjvePdd4h6g
        uBTVi+GVkZhm82OYA5rrEi2wrBTSJ0muYv5D9kULhG37m0nduieXsq+pbEs319ZH
        WQyncoVn+zQyNA==
X-ME-Sender: <xms:xT1AYUDhNnHuQMEb-AXoJhMeGgD06rRF9QGfs0yQTVJEqUc-BUvFSQ>
    <xme:xT1AYWiEs_GijTth-ZV5pYzdcUyjDP367N1ex0g7yx66qlO4Kj8quBZTQpqYKa3it
    xHQLoYo4VySd3Y>
X-ME-Received: <xmr:xT1AYXkopWmEeXW3uHguvep04Tu2yr2h6pMUsVsaE4RPMn9Vg8IrELHtbhuvDyNq6UTqOeOswtTswLV03cYvvV3Cm9c7Tp0NaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedunecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:xT1AYaxdHuDsLkO8JwK9ivqkGJicc-v_H6JivfiqMds9er8MF1-rTg>
    <xmx:xT1AYZQu6nP-yyvQBpdqb0LqCNgrSb1PCkX4uitagAqbVf32rCpuWQ>
    <xmx:xT1AYVZp5Yn3lcGDYs-kEfsQU-ooyZ-FfGS46IMGtTBQXR0Z3avS9g>
    <xmx:xT1AYbdjFcyaKsnvVzDx_CjNMjyKAnmLGdU3UUe-WVDAxtX4vAwq_w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Sep 2021 02:14:28 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/8] mlxsw: spectrum: Use PLLP to get front panel number and split number
Date:   Tue, 14 Sep 2021 09:13:27 +0300
Message-Id: <20210914061330.226000-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914061330.226000-1-idosch@idosch.org>
References: <20210914061330.226000-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Instead of relying on the values coming from the PMLP register, use PLLP
to get the information about port front panel number and split number.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 35 ++++++++++++++++---
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index e12232f371c8..c0e52afe1afd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1441,6 +1441,23 @@ mlxsw_sp_port_vlan_classification_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(spvc), spvc_pl);
 }
 
+static int mlxsw_sp_port_label_info_get(struct mlxsw_sp *mlxsw_sp,
+					u8 local_port, u8 *port_number,
+					u8 *split_port_subnumber,
+					u8 *slot_index)
+{
+	char pllp_pl[MLXSW_REG_PLLP_LEN];
+	int err;
+
+	mlxsw_reg_pllp_pack(pllp_pl, local_port);
+	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(pllp), pllp_pl);
+	if (err)
+		return err;
+	mlxsw_reg_pllp_unpack(pllp_pl, port_number,
+			      split_port_subnumber, slot_index);
+	return 0;
+}
+
 static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 				u8 split_base_local_port,
 				struct mlxsw_sp_port_mapping *port_mapping)
@@ -1449,7 +1466,10 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	bool split = !!split_base_local_port;
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	u32 lanes = port_mapping->width;
+	u8 split_port_subnumber;
 	struct net_device *dev;
+	u8 port_number;
+	u8 slot_index;
 	bool splittable;
 	int err;
 
@@ -1467,12 +1487,18 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 		goto err_port_swid_set;
 	}
 
+	err = mlxsw_sp_port_label_info_get(mlxsw_sp, local_port, &port_number,
+					   &split_port_subnumber, &slot_index);
+	if (err) {
+		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Failed to get port label information\n",
+			local_port);
+		goto err_port_label_info_get;
+	}
+
 	splittable = lanes > 1 && !split;
 	err = mlxsw_core_port_init(mlxsw_sp->core, local_port,
-				   port_mapping->module + 1, split,
-				   port_mapping->lane / lanes,
-				   splittable, lanes,
-				   mlxsw_sp->base_mac,
+				   port_number, split, split_port_subnumber,
+				   splittable, lanes, mlxsw_sp->base_mac,
 				   sizeof(mlxsw_sp->base_mac));
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Failed to init core port\n",
@@ -1717,6 +1743,7 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 err_alloc_etherdev:
 	mlxsw_core_port_fini(mlxsw_sp->core, local_port);
 err_core_port_init:
+err_port_label_info_get:
 	mlxsw_sp_port_swid_set(mlxsw_sp, local_port,
 			       MLXSW_PORT_SWID_DISABLED_PORT);
 err_port_swid_set:
-- 
2.31.1

