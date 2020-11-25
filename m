Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2912C487B
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 20:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgKYTfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 14:35:52 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50107 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728521AbgKYTfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 14:35:52 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 03FA25C00AB;
        Wed, 25 Nov 2020 14:35:51 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 25 Nov 2020 14:35:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=MMcdZO0kt93T71BjpPiWk2XQjzHxtBT+eWLLPTXGMS8=; b=OWJfsR+y
        tHrK2RTT3Vpdku7S6aXQTYuOkiV/biU3PRq2diZ9fcjrAwlLr1ttJyQ9YF6/zK6l
        IBO55LBSwVOzCtieNWH/XtS1u0NmktH5XfaCQiMH/7AANjp6cwTeRrT1FCkunLJv
        PqpsT25kJ40Q4PNQ3rFM0c17Ox7vBFBmrdbWd2IrVU8O2Bb6j3zbNphmXLErS8ux
        9DXeD4gqA05zwGYum9z0WB9/wHLWbrRQ95Sz2yNDF9c3EkZ7bS+HhzSKhRhXNSLj
        YJ+ymSf9fZ0f93xeb7045nFKmdFIojEaz3Gv6ThPDOofCrqZDPRvyNrH6C0GdGCS
        hZIh4cxXfpah2A==
X-ME-Sender: <xms:FrK-X_S7RwzptTL8ctr78HLGud2bdEAXqjRyMtP5dtcOYstBH8T44g>
    <xme:FrK-XwxbTtJy8Z6OHiDqB9xO_DufTpQ3GH5j7quHY7uZIuBJePEaKKHzX5bYfHiJa
    bjToUiU_fu0YD8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehtddguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:FrK-X03kmT-58vMqhSZD3PBJhhAVJ31JLosO0lrnqqmKM1YfHiM4Yg>
    <xmx:FrK-X_DOgtnypCduCmYLSnspNAH_zMyhhJcb1O_Fq-A1GvILsQi6mg>
    <xmx:FrK-X4iAIUSRozzAt9NjCpmrZ9pb5l8OenRjp9qBIyjfQAJTs9fu-Q>
    <xmx:F7K-Xxu5_Wsj9bMRQ3HAmboiT-zqZSFvqF6U5ON4oiwE07GMMN7X2Q>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 93378328005D;
        Wed, 25 Nov 2020 14:35:49 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/5] mlxsw: spectrum_router: Pass virtual router parameters directly instead of pointer
Date:   Wed, 25 Nov 2020 21:35:02 +0200
Message-Id: <20201125193505.1052466-3-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201125193505.1052466-1-idosch@idosch.org>
References: <20201125193505.1052466-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

mlxsw_sp_adj_index_mass_update_vr() only needs the virtual router's
identifier and protocol, so pass them directly. In a subsequent patch
the caller will not have access to the pointer.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 118d48d9ff8e..b229f28f6209 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3243,7 +3243,8 @@ mlxsw_sp_nexthop_lookup(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_adj_index_mass_update_vr(struct mlxsw_sp *mlxsw_sp,
-					     const struct mlxsw_sp_fib *fib,
+					     enum mlxsw_sp_l3proto proto,
+					     u16 vr_id,
 					     u32 adj_index, u16 ecmp_size,
 					     u32 new_adj_index,
 					     u16 new_ecmp_size)
@@ -3251,8 +3252,8 @@ static int mlxsw_sp_adj_index_mass_update_vr(struct mlxsw_sp *mlxsw_sp,
 	char raleu_pl[MLXSW_REG_RALEU_LEN];
 
 	mlxsw_reg_raleu_pack(raleu_pl,
-			     (enum mlxsw_reg_ralxx_protocol) fib->proto,
-			     fib->vr->id, adj_index, ecmp_size, new_adj_index,
+			     (enum mlxsw_reg_ralxx_protocol) proto, vr_id,
+			     adj_index, ecmp_size, new_adj_index,
 			     new_ecmp_size);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(raleu), raleu_pl);
 }
@@ -3271,7 +3272,8 @@ static int mlxsw_sp_adj_index_mass_update(struct mlxsw_sp *mlxsw_sp,
 		if (fib == fib_entry->fib_node->fib)
 			continue;
 		fib = fib_entry->fib_node->fib;
-		err = mlxsw_sp_adj_index_mass_update_vr(mlxsw_sp, fib,
+		err = mlxsw_sp_adj_index_mass_update_vr(mlxsw_sp, fib->proto,
+							fib->vr->id,
 							old_adj_index,
 							old_ecmp_size,
 							nhgi->adj_index,
-- 
2.28.0

