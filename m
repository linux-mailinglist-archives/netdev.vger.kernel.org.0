Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6751F210DCC
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731473AbgGAOdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:33:37 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:35193 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730852AbgGAOdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:33:37 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 872C95801C9;
        Wed,  1 Jul 2020 10:33:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 01 Jul 2020 10:33:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=HCpzzRCZrdEpg8MSd1C+6PECzgZQklCT45ikPFxw74g=; b=Yr2W+zjQ
        3MINU2T20YT6Fsh/RfEApDQN3EXppUmzISeeMSKt2DSYj7HivPON2kO4XkyeCB1A
        u4NL6p+XaEITDM4XyXaNjg1TjjIhob6PDLQfnhEEj148idG/YYTALCe3oF7dZY72
        Q9yVEF24KGgqZfUB95sm4vsPrRrXYlNW3fETrZ6W0D7dPI3/1eeWfvGuThYLDEJh
        pBw55mT9J/vT3iGsHymt9IKyJ9hJBqtAMJoU+bgM6NrS0YLezp1E0boSglg+2WjK
        sFHOO3t4QtcvwY01oSAuKRsLFQwSmeaT2pUCmR/IByIwsOh5s1LMq/YYtlM9ovoB
        I+W1gvfoLTxaHQ==
X-ME-Sender: <xms:v578Xn6FxzkD4-lPceUGGPXHPhvoDMmwJkfxymTchEt8RvFO7I3JhQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrtddvgdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepudelfedrgeejrdduieehrddvhedu
    necuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:v578Xs4mAXjjRghqvLNI2-Dvk8EB0MIZAkeYV2luplo8zfTVGOw72A>
    <xmx:v578XufxooKYOKhrySay0f1KrMgN87CT7oplvl1h6P5SuGkTt6KCRQ>
    <xmx:v578XoL1jZyKV1LGT8imQM5g_k1JOJ7IfSTl9TmbXLuUK1rQc_BdlA>
    <xmx:v578XoA7ZgiquQNswsVK_nPDu7PwBKTFBVu--toiYPYKElNVjfUkBg>
Received: from shredder.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 395BF3280065;
        Wed,  1 Jul 2020 10:33:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, snelson@pensando.io, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 6/9] mlxsw: Set port split ability attribute in driver
Date:   Wed,  1 Jul 2020 17:32:48 +0300
Message-Id: <20200701143251.456693-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701143251.456693-1-idosch@idosch.org>
References: <20200701143251.456693-1-idosch@idosch.org>
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

