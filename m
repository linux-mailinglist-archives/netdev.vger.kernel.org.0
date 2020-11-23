Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421822C0081
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 08:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgKWHOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 02:14:11 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:59289 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726051AbgKWHOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 02:14:11 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 6C0C3F51;
        Mon, 23 Nov 2020 02:14:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 23 Nov 2020 02:14:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=UFmzx6tFvpTBpyjJu+yOoKOprtF+9B/Bm4Ez81vL2hA=; b=b2XR5Y4z
        8fpUrCUG2wcYWVTmhzRd3Uv/ZVldKDOunZFUF9P9MqXNlbcFO5dYPnzziqNl6h5u
        ryOegviMAlgo90+ktO9BoY4XlPbT+lGUTlRkuXvlYlSipXN5vZ7K6f5+/rMdag92
        UTZ77qe5ESj9YvybOIeUZGuVFruYDS0sPN3KgQ6zNPQS47uhlP75BezvbnEcTq/q
        xri5O47AWQpikqlNHwmJ6nASO4Xa5fKC/Gs9IhP0PsPFFMWsitO/MVP8r+lJTOnl
        lJNNBgGwD6LglHfkpTGXa3si+HVHVLw9MnzjHY9hb4D8AOHjSTJsr4m+TXacwQMO
        1WImvjxEObYtYg==
X-ME-Sender: <xms:QWG7X8wdYiSeFMCnV0xdMspZglH9ix76_HcKkIHPZaA3CDLcz4Zwog>
    <xme:QWG7XwQUkkz2gw5MYYACZ13vxe--zREHBnf9WrLqIwtOcwQPnTfWumaGg75Bw3ZIn
    _tUjmaHK1WNvEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeghedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:QWG7X-V1Prtcen9Gxg050rL8VRoemzesEGKhuVwLFN4ZZZ6iPZ0D-A>
    <xmx:QWG7X6hcg2HAKasEVlcmvRof-DDB5Ge_fHdgLbn3WyKP4AebsnInBA>
    <xmx:QWG7X-AnUeGla1Uiy7hrtFSsGFxWKcuhPqsXRKpV166bI7Rv_b8YVA>
    <xmx:QmG7X5OgfY_H4muWKudAtx9FjHasTDxpiYzHy-PqhFdG2qAsGVzkaA>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id A6618328005E;
        Mon, 23 Nov 2020 02:14:08 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/10] mlxsw: spectrum_router: Use loopback RIF for unresolved nexthops
Date:   Mon, 23 Nov 2020 09:12:23 +0200
Message-Id: <20201123071230.676469-4-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123071230.676469-1-idosch@idosch.org>
References: <20201123071230.676469-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Now that the driver creates a loopback RIF during its initialization, it
can be used to program the adjacency entries for unresolved nexthops
instead of other RIFs. The loopback RIF is guaranteed to exist for the
entire life time of the driver, unlike other RIFs that come and go.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 84ed068d17f8..53d04e7993f6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4994,7 +4994,7 @@ int mlxsw_sp_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-static int mlxsw_sp_adj_discard_write(struct mlxsw_sp *mlxsw_sp, u16 rif_index)
+static int mlxsw_sp_adj_discard_write(struct mlxsw_sp *mlxsw_sp)
 {
 	enum mlxsw_reg_ratr_trap_action trap_action;
 	char ratr_pl[MLXSW_REG_RATR_LEN];
@@ -5011,7 +5011,8 @@ static int mlxsw_sp_adj_discard_write(struct mlxsw_sp *mlxsw_sp, u16 rif_index)
 	trap_action = MLXSW_REG_RATR_TRAP_ACTION_TRAP;
 	mlxsw_reg_ratr_pack(ratr_pl, MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY, true,
 			    MLXSW_REG_RATR_TYPE_ETHERNET,
-			    mlxsw_sp->router->adj_discard_index, rif_index);
+			    mlxsw_sp->router->adj_discard_index,
+			    mlxsw_sp->router->lb_rif_index);
 	mlxsw_reg_ratr_trap_action_set(ratr_pl, trap_action);
 	mlxsw_reg_ratr_trap_id_set(ratr_pl, MLXSW_TRAP_ID_RTR_EGRESS0);
 	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ratr), ratr_pl);
@@ -5051,8 +5052,7 @@ static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
 		adjacency_index = nhgi->adj_index;
 		ecmp_size = nhgi->ecmp_size;
 	} else if (!nhgi->adj_index_valid && nhgi->count && nhgi->nh_rif) {
-		err = mlxsw_sp_adj_discard_write(mlxsw_sp,
-						 nhgi->nh_rif->rif_index);
+		err = mlxsw_sp_adj_discard_write(mlxsw_sp);
 		if (err)
 			return err;
 		trap_action = MLXSW_REG_RALUE_TRAP_ACTION_NOP;
-- 
2.28.0

