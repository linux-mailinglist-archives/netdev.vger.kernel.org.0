Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4077821A0A8
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgGINTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:19:41 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:33977 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726874AbgGINTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:19:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id D9CC25804CA;
        Thu,  9 Jul 2020 09:19:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 09 Jul 2020 09:19:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=HCpzzRCZrdEpg8MSd1C+6PECzgZQklCT45ikPFxw74g=; b=XvuVKPeP
        yOLkcTCnqWF7so/FWEHCWybV5pDW6RfuCEu16KkXQA3T5pVJh2nskVTYWUKvwMLC
        O4a8UPELxV38eFmviCNujdb9k7nyQuy9aW+b28JlHjUy5OlOCp8aCWKWGjDXRU+P
        yQI5jvCHtbR/dpvolKUZ8gulmlKcxu5cr+kd6uK3O81vDmO/74YpktJDM4B43U5c
        6QGYA+J0RFZOfsc4sbYF2s0qzQ91rKi17j7p1CmNKbQMFKKOALegZdPMbh+HG+hX
        nK/KGWWITw8a4hGoVPkRvLg2/s6p8M+WiUEA023Jb6jEJuT6hHdJ7WcPmVPxxB9C
        KDtx/vIUa4AJvQ==
X-ME-Sender: <xms:WBkHX79BOp1O_nCLA5Xs6xj1-QGFBTe8OSlIpRDMT88Q7180lpHvQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudelgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:WBkHX3u06c4T73JmewoXLq8_idZYro_vprqA7aO4rx5in6WmF1dDCw>
    <xmx:WBkHX5CybBQ4E7qGcl6QZAWILdhkAcqu6UsQ_TRMZ88_s-4uYmYN9Q>
    <xmx:WBkHX3fTWByD5yFgGhTAqwJfsth4DZ-Hgw-aYWuah1-iogcj6O81pg>
    <xmx:WBkHXxFRp9CZujeDG02gzpUmX9HP9XURp6gPIdkj4L4aXaKRr4kaRQ>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0E803328005E;
        Thu,  9 Jul 2020 09:19:17 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, snelson@pensando.io, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 6/9] mlxsw: Set port split ability attribute in driver
Date:   Thu,  9 Jul 2020 16:18:19 +0300
Message-Id: <20200709131822.542252-7-idosch@idosch.org>
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

Currently, port attributes like flavour, port number and whether the port
was split are set when initializing a port.

Set the split ability of the port as well, based on port_mapping->width
field and split attribute of devlink port in spectrum, so that it could be
easily passed to devlink in the next patch.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c     | 9 +++++----
 drivers/net/ethernet/mellanox/mlxsw/core.h     | 5 ++---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c  | 4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 +++-
 drivers/net/ethernet/mellanox/mlxsw/switchib.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c | 2 +-
 6 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 6cde196f6b70..f85f5d88d331 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2122,7 +2122,7 @@ static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 				  enum devlink_port_flavour flavour,
 				  u32 port_number, bool split,
 				  u32 split_port_subnumber,
-				  u32 lanes,
+				  bool splittable, u32 lanes,
 				  const unsigned char *switch_id,
 				  unsigned char switch_id_len)
 {
@@ -2161,14 +2161,15 @@ static void __mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)
 int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 			 u32 port_number, bool split,
 			 u32 split_port_subnumber,
-			 u32 lanes,
+			 bool splittable, u32 lanes,
 			 const unsigned char *switch_id,
 			 unsigned char switch_id_len)
 {
 	return __mlxsw_core_port_init(mlxsw_core, local_port,
 				      DEVLINK_PORT_FLAVOUR_PHYSICAL,
 				      port_number, split, split_port_subnumber,
-				      lanes, switch_id, switch_id_len);
+				      splittable, lanes,
+				      switch_id, switch_id_len);
 }
 EXPORT_SYMBOL(mlxsw_core_port_init);
 
@@ -2189,7 +2190,7 @@ int mlxsw_core_cpu_port_init(struct mlxsw_core *mlxsw_core,
 
 	err = __mlxsw_core_port_init(mlxsw_core, MLXSW_PORT_CPU_PORT,
 				     DEVLINK_PORT_FLAVOUR_CPU,
-				     0, false, 0, 0,
+				     0, false, 0, false, 0,
 				     switch_id, switch_id_len);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index b5c02e6e6865..7d6b0a232789 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -191,9 +191,8 @@ void mlxsw_core_lag_mapping_clear(struct mlxsw_core *mlxsw_core,
 
 void *mlxsw_core_port_driver_priv(struct mlxsw_core_port *mlxsw_core_port);
 int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
-			 u32 port_number, bool split,
-			 u32 split_port_subnumber,
-			 u32 lanes,
+			 u32 port_number, bool split, u32 split_port_subnumber,
+			 bool splittable, u32 lanes,
 			 const unsigned char *switch_id,
 			 unsigned char switch_id_len);
 void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index f9c9d7baf3be..c010db2c9dba 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -164,8 +164,8 @@ mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u8 local_port, u8 module)
 	int err;
 
 	err = mlxsw_core_port_init(mlxsw_m->core, local_port,
-				   module + 1, false, 0, 0,
-				   mlxsw_m->base_mac,
+				   module + 1, false, 0, false,
+				   0, mlxsw_m->base_mac,
 				   sizeof(mlxsw_m->base_mac));
 	if (err) {
 		dev_err(mlxsw_m->bus_info->dev, "Port %d: Failed to init core port\n",
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 35d677e0911e..9cd2dc3afb13 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1735,12 +1735,14 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	u32 lanes = port_mapping->width;
 	struct net_device *dev;
+	bool splittable;
 	int err;
 
+	splittable = lanes > 1 && !split;
 	err = mlxsw_core_port_init(mlxsw_sp->core, local_port,
 				   port_mapping->module + 1, split,
 				   port_mapping->lane / lanes,
-				   lanes,
+				   splittable, lanes,
 				   mlxsw_sp->base_mac,
 				   sizeof(mlxsw_sp->base_mac));
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchib.c b/drivers/net/ethernet/mellanox/mlxsw/switchib.c
index 1b446e6071b2..1e561132eb1e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchib.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchib.c
@@ -281,7 +281,7 @@ static int mlxsw_sib_port_create(struct mlxsw_sib *mlxsw_sib, u8 local_port,
 	int err;
 
 	err = mlxsw_core_port_init(mlxsw_sib->core, local_port,
-				   module + 1, false, 0, 0,
+				   module + 1, false, 0, false, 0,
 				   mlxsw_sib->hw_id, sizeof(mlxsw_sib->hw_id));
 	if (err) {
 		dev_err(mlxsw_sib->bus_info->dev, "Port %d: Failed to init core port\n",
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index ac4cd7c23439..6f9a725662fb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -1107,7 +1107,7 @@ static int mlxsw_sx_port_eth_create(struct mlxsw_sx *mlxsw_sx, u8 local_port,
 	int err;
 
 	err = mlxsw_core_port_init(mlxsw_sx->core, local_port,
-				   module + 1, false, 0, 0,
+				   module + 1, false, 0, false, 0,
 				   mlxsw_sx->hw_id, sizeof(mlxsw_sx->hw_id));
 	if (err) {
 		dev_err(mlxsw_sx->bus_info->dev, "Port %d: Failed to init core port\n",
-- 
2.26.2

