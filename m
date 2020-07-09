Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFC321A0A7
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgGINTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:19:22 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:44417 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726852AbgGINTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:19:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id E87D65804CA;
        Thu,  9 Jul 2020 09:19:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 09 Jul 2020 09:19:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=SMdzsIJ2cj4OPxxSVGj9ED7RpccS9nbeo/VpWXDF96Q=; b=vFQRwPQU
        RS4yI3PIYukBk3MGHXXvpYOIoaMAreVJXMqLlf/HVk6N7gkpyf+OgQt22hwUNsVo
        t2Csq3BZhr7zw2MD242Mm+ASqPAiU8TY3t2a3iAfWhk3miU9Hp7EMnWyoeUcUxHh
        D8YHs/9d8v3bID3d096ATqHzGaWywqdG4foTXF8v9t3FYejPh6RNDmF7PkWYV9lJ
        y+BEWomI7h4m0J5fP+gpH/qnjo1qFBj0GBdzzpo1Iu3Ibpp1H980gf+ubajRGwH8
        y6G3WacPMuxwLdzWlbZSY929RLEtlGnjHhsXVObGPPcZa0+2+FIJJ9n2a12eQhqZ
        5WunjggaiBoIig==
X-ME-Sender: <xms:UhkHXznntMf95UoktuyecKgru1WAdVHX4dWn3aMITuOWaa02Id8C0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudelgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:UhkHX23FRW459EZV0HC23VQTie13tNGdXHXNOwasWK-Go4MWmT1vZg>
    <xmx:UhkHX5pV8SAi0TEnRJq1yB6zRrz6vE-WEFOCYCdhDf7ZIbQ7K98Jrg>
    <xmx:UhkHX7k6hZQXY89WO5ej-XSGl8UEiqioFTkq2TswNqybR-oy_RRz5Q>
    <xmx:UhkHX6uOy6BRc0233jsGGAb8YtcHwop_FjjBetU0QYTueBFH0r85Zg>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8F7EF328005A;
        Thu,  9 Jul 2020 09:19:11 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, snelson@pensando.io, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 4/9] mlxsw: Set number of port lanes attribute in driver
Date:   Thu,  9 Jul 2020 16:18:17 +0300
Message-Id: <20200709131822.542252-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200709131822.542252-1-idosch@idosch.org>
References: <20200709131822.542252-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

Currently, port attributes like flavour, port number and whether the
port was split are set when initializing a port.

Set the number of lanes of the port as well so that it could be easily
passed to devlink in the next patch.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c     | 6 ++++--
 drivers/net/ethernet/mellanox/mlxsw/core.h     | 1 +
 drivers/net/ethernet/mellanox/mlxsw/minimal.c  | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 +++-
 drivers/net/ethernet/mellanox/mlxsw/switchib.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c | 2 +-
 6 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index bbe7358d4ea5..f44cb1a537f3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2122,6 +2122,7 @@ static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 				  enum devlink_port_flavour flavour,
 				  u32 port_number, bool split,
 				  u32 split_port_subnumber,
+				  u32 lanes,
 				  const unsigned char *switch_id,
 				  unsigned char switch_id_len)
 {
@@ -2159,13 +2160,14 @@ static void __mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)
 int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 			 u32 port_number, bool split,
 			 u32 split_port_subnumber,
+			 u32 lanes,
 			 const unsigned char *switch_id,
 			 unsigned char switch_id_len)
 {
 	return __mlxsw_core_port_init(mlxsw_core, local_port,
 				      DEVLINK_PORT_FLAVOUR_PHYSICAL,
 				      port_number, split, split_port_subnumber,
-				      switch_id, switch_id_len);
+				      lanes, switch_id, switch_id_len);
 }
 EXPORT_SYMBOL(mlxsw_core_port_init);
 
@@ -2186,7 +2188,7 @@ int mlxsw_core_cpu_port_init(struct mlxsw_core *mlxsw_core,
 
 	err = __mlxsw_core_port_init(mlxsw_core, MLXSW_PORT_CPU_PORT,
 				     DEVLINK_PORT_FLAVOUR_CPU,
-				     0, false, 0,
+				     0, false, 0, 0,
 				     switch_id, switch_id_len);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 22b0dfa7cfae..b5c02e6e6865 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -193,6 +193,7 @@ void *mlxsw_core_port_driver_priv(struct mlxsw_core_port *mlxsw_core_port);
 int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 			 u32 port_number, bool split,
 			 u32 split_port_subnumber,
+			 u32 lanes,
 			 const unsigned char *switch_id,
 			 unsigned char switch_id_len);
 void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index c4caeeadcba9..f9c9d7baf3be 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -164,7 +164,7 @@ mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u8 local_port, u8 module)
 	int err;
 
 	err = mlxsw_core_port_init(mlxsw_m->core, local_port,
-				   module + 1, false, 0,
+				   module + 1, false, 0, 0,
 				   mlxsw_m->base_mac,
 				   sizeof(mlxsw_m->base_mac));
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 81bb9ea1479b..35d677e0911e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1733,12 +1733,14 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan;
 	bool split = !!split_base_local_port;
 	struct mlxsw_sp_port *mlxsw_sp_port;
+	u32 lanes = port_mapping->width;
 	struct net_device *dev;
 	int err;
 
 	err = mlxsw_core_port_init(mlxsw_sp->core, local_port,
 				   port_mapping->module + 1, split,
-				   port_mapping->lane / port_mapping->width,
+				   port_mapping->lane / lanes,
+				   lanes,
 				   mlxsw_sp->base_mac,
 				   sizeof(mlxsw_sp->base_mac));
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchib.c b/drivers/net/ethernet/mellanox/mlxsw/switchib.c
index 4ff1e623aa76..1b446e6071b2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchib.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchib.c
@@ -281,7 +281,7 @@ static int mlxsw_sib_port_create(struct mlxsw_sib *mlxsw_sib, u8 local_port,
 	int err;
 
 	err = mlxsw_core_port_init(mlxsw_sib->core, local_port,
-				   module + 1, false, 0,
+				   module + 1, false, 0, 0,
 				   mlxsw_sib->hw_id, sizeof(mlxsw_sib->hw_id));
 	if (err) {
 		dev_err(mlxsw_sib->bus_info->dev, "Port %d: Failed to init core port\n",
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index b438f5576e18..ac4cd7c23439 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -1107,7 +1107,7 @@ static int mlxsw_sx_port_eth_create(struct mlxsw_sx *mlxsw_sx, u8 local_port,
 	int err;
 
 	err = mlxsw_core_port_init(mlxsw_sx->core, local_port,
-				   module + 1, false, 0,
+				   module + 1, false, 0, 0,
 				   mlxsw_sx->hw_id, sizeof(mlxsw_sx->hw_id));
 	if (err) {
 		dev_err(mlxsw_sx->bus_info->dev, "Port %d: Failed to init core port\n",
-- 
2.26.2

