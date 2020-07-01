Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D3D210DCA
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731529AbgGAOdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:33:31 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:37467 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730852AbgGAOd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:33:29 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7911B5801C9;
        Wed,  1 Jul 2020 10:33:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 01 Jul 2020 10:33:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=SMdzsIJ2cj4OPxxSVGj9ED7RpccS9nbeo/VpWXDF96Q=; b=YBObD/bk
        MnZFfbzWRdorfmYWRvHPTzB3lETNXGejFxZIPHeBpGKMOms90bQqzJ2MgT+13gE6
        PDL+NeZPGA8eHcdEuS+TC3+XlDe7XYmvKERip8Fa9DuGPUjupWd28vwoA0b0cTpG
        Gm3XPI3DmowzevLFd0ndYpzSfBYEL0Nyv/lYGxaJBj/KTbGOY7NyD6IoBJpSX3nu
        CKq+DLLK5VOnVMi91xRVO6/6F7iIYLZFqhY7wjG5eQdetciA+DiQklIgSipeYByR
        /1YsS3Au8+fnxqTBU8ROpyLNKolJwxCfK0u7g0JFENkR505PYw5CRhKhohwTCmEA
        xaDVvW8bxgXMrw==
X-ME-Sender: <xms:uJ78Xh0w_A2dg_odS-B9FxjItLtkOKQQ7xIeTxorP0bbcd1OO2Eosg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrtddvgdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepudelfedrgeejrdduieehrddvhedu
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:uJ78XoGmTFA82-Kykq1BQUUBxGUw8SYFxgfIhaHsFYX-COnMr_MX6g>
    <xmx:uJ78Xh4jh2IZVDRDxbe0sA8JcpQ3FgjSEIQ4RCX2JYCqqh90JzaTEQ>
    <xmx:uJ78Xu1TogVf1gkcQfio613TZnkhE4WEPv8qnLgjXJkGyr-Dr1Vvig>
    <xmx:uJ78Xs8SF17Enwv9yk1s3gTMHWAxRKMvWHGqp5dnSmwjfmNdhLCqzg>
Received: from shredder.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0701C3280060;
        Wed,  1 Jul 2020 10:33:24 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, snelson@pensando.io, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 4/9] mlxsw: Set number of port lanes attribute in driver
Date:   Wed,  1 Jul 2020 17:32:46 +0300
Message-Id: <20200701143251.456693-5-idosch@idosch.org>
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

