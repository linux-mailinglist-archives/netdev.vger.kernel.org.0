Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0D32C0080
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 08:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgKWHOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 02:14:10 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:39463 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726051AbgKWHOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 02:14:10 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id E9FADF40;
        Mon, 23 Nov 2020 02:14:08 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 23 Nov 2020 02:14:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=uKTUq5ePeJTFFQDAhk3mKssinKqlxVLKsSfPkxIYYEg=; b=PQCJQLle
        ObGS5Pr9DqHJCz7KqVjuZXlX1Cd+0y6yHKZPPdT4FXmOCCRsw1g01Ao0zUEJxo0+
        IA00D6SO1+t5RVr6we1DRmIY2kOfHTStmEr4ng3oc4WbSXydH6MPke7CYaADY/16
        GwxIIjShKe114Gok9Quy8OA2Ppc0e8klJFFaSE9RdQE826QBAGNruHLvUDze7tEB
        BNt4EZvZgl20wn1w/mqjMaREiN545fRK13fcaN+WKbBibeHPQ3AiakTPZ7MaP8yo
        FtDDM5p+9hz2NBkbIPaL7Lh3mlcvhlk7bsf9F6J1GSP9pZBY7VVT5yKeKhOeC7I7
        kAqxBauBXyxa5g==
X-ME-Sender: <xms:QGG7X8ZOSEPNOA2UraQpmDHLxOiOFPh1NWoQiBmUJUoCDpCoTC3ACg>
    <xme:QGG7X3aKDTfQgR8r2PvfbzJ8-RyMWws_LEJIz5s46sVg2pGNATMWsJ7skZNqQPs9g
    DoNLQ10Sofah_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeghedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:QGG7X29QUouUA9tAY7xgewn2UMPn3XqsJbrRcc3u1SAhoyfbE_7y8w>
    <xmx:QGG7X2plh_NP_sm5WrUkTbP1dWOllAbSC5lsgVeBPe-F_R9Qu59-qg>
    <xmx:QGG7X3ouv_vTHAmCelZy7oSeKMYE9otWOz99XsnjTrpgaMVqi2cfQA>
    <xmx:QGG7X2XsS5p-kTG7ukQpqnIGPZ4cVZ1XaMp57r7pLBiKdsfbsROT6g>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 302113280064;
        Mon, 23 Nov 2020 02:14:07 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/10] mlxsw: spectrum_router: Use different trap identifier for unresolved nexthops
Date:   Mon, 23 Nov 2020 09:12:22 +0200
Message-Id: <20201123071230.676469-3-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123071230.676469-1-idosch@idosch.org>
References: <20201123071230.676469-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Unresolved nexthops are currently written to the adjacency table with a
discard action. Packets hitting such entries are trapped to the CPU via
the 'DISCARD_ROUTER3' trap which can be enabled or disabled on demand,
but is always enabled in order to ensure the kernel can resolve the
unresolved neighbours.

This trap will be needed for blackhole nexthops support. Therefore, move
unresolved nexthops to explicitly program the adjacency entries with a
trap action and a different trap identifier, 'RTR_EGRESS0'.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 3 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c   | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/trap.h            | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index c61751e67750..84ed068d17f8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5008,11 +5008,12 @@ static int mlxsw_sp_adj_discard_write(struct mlxsw_sp *mlxsw_sp, u16 rif_index)
 	if (err)
 		return err;
 
-	trap_action = MLXSW_REG_RATR_TRAP_ACTION_DISCARD_ERRORS;
+	trap_action = MLXSW_REG_RATR_TRAP_ACTION_TRAP;
 	mlxsw_reg_ratr_pack(ratr_pl, MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY, true,
 			    MLXSW_REG_RATR_TYPE_ETHERNET,
 			    mlxsw_sp->router->adj_discard_index, rif_index);
 	mlxsw_reg_ratr_trap_action_set(ratr_pl, trap_action);
+	mlxsw_reg_ratr_trap_id_set(ratr_pl, MLXSW_TRAP_ID_RTR_EGRESS0);
 	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ratr), ratr_pl);
 	if (err)
 		goto err_ratr_write;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 433f14ade464..8fd7d858f3c8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -617,7 +617,7 @@ static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
 					       TRAP_TO_CPU),
 			MLXSW_SP_RXL_EXCEPTION(HOST_MISS_IPV6, L3_EXCEPTIONS,
 					       TRAP_TO_CPU),
-			MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER3, L3_EXCEPTIONS,
+			MLXSW_SP_RXL_EXCEPTION(RTR_EGRESS0, L3_EXCEPTIONS,
 					       TRAP_EXCEPTION_TO_CPU),
 		},
 	},
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 57f9e24602d0..9e070ab3ed76 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -52,6 +52,7 @@ enum {
 	MLXSW_TRAP_ID_RTR_INGRESS1 = 0x71,
 	MLXSW_TRAP_ID_IPV6_PIM = 0x79,
 	MLXSW_TRAP_ID_IPV6_VRRP = 0x7A,
+	MLXSW_TRAP_ID_RTR_EGRESS0 = 0x80,
 	MLXSW_TRAP_ID_IPV4_BGP = 0x88,
 	MLXSW_TRAP_ID_IPV6_BGP = 0x89,
 	MLXSW_TRAP_ID_L3_IPV6_ROUTER_SOLICITATION = 0x8A,
-- 
2.28.0

