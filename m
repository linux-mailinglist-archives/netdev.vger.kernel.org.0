Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E784142D1
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbhIVHjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:39:09 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41029 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233378AbhIVHi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:38:59 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 3F71D5C00F4;
        Wed, 22 Sep 2021 03:37:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 22 Sep 2021 03:37:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=T9ccrDsLvXdzPp69PBVosKBStq4hMuqrDBunQ3KTFc4=; b=pb3lHYGc
        v84di4Blub31I9stfeMuanWRvVlGT5AeyVR/bLebSSwv+SrSZgeF2KtB40vOfPxr
        a0XikEcCwqJkVF2sJzkIHmuI8DE/+WVBLvxVOGsQ/NxymXQ+kDWm6SDIwSA1ALoZ
        tVERryyt2QORL8QAEF2JaKKSYQg82K+JeZ3pdRFIwN7zyav8Qo9ifBCvPQwfWVEm
        KmgT5iM+iYd6mcfHUwyI8ROUpKysXdq0A4nVD6bSCo89twyoQ7++s4g0W0Vqyuum
        eaAfsHFmOv++UrKN2yGP7Kij/KB+LDC4exX07YIDqWM7wFIat8ZW4fW8xhAoMmHT
        RHYPW7DsE+y30w==
X-ME-Sender: <xms:Ot1KYaKKSExyhXAmryJkfzHjLEGsTbBBzBHrdPotNef8gCFn-Ygrdg>
    <xme:Ot1KYSKvvjhpu4T6yDSXvAikgjQLneysDnzA8XxHfR6eXeoll7kB0V5oPhi5WQAxg
    hOr0xzUoXWatdM>
X-ME-Received: <xmr:Ot1KYat1QWF3QPgmTl49bJ4XhrvzejOQvx6sBqRHuDOqGzuxr-NLRFQZekayyFYdKC7GaIDLkjiiBwgJsGhFsK2UTKy0a-dMzXLW8xq1DvxLjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiiedgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Ot1KYfYnHkGuTqQzn5eit5-g5OBLAceQ0-xMYiOKEC7VTjYIVTR0Bg>
    <xmx:Ot1KYRbMyTjqfCB_5YCYHnC804KZJUVzJzu5bt21eTNcUpGk4y9rPQ>
    <xmx:Ot1KYbBFdjSym2xZOUXyB2dHrLI3jii1neVVD7yV_B9K8Db6v420eA>
    <xmx:Ot1KYVGxn4CtYv0Wv38gYaUXcSYin13VTCbLsGMAnA3pLe1VUBJyLw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Sep 2021 03:37:28 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/2] mlxsw: spectrum_router: Start using new trap adjacency entry
Date:   Wed, 22 Sep 2021 10:36:42 +0300
Message-Id: <20210922073642.796559-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210922073642.796559-1-idosch@idosch.org>
References: <20210922073642.796559-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Start using the trap adjacency entry that was added in the previous
patch and remove the existing one which is no longer needed.

Note that the name of the old entry was inaccurate as the entry did not
discard packets, but trapped them.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 51 +------------------
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  2 -
 2 files changed, 1 insertion(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 00648e093351..331d26c1181e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5797,41 +5797,6 @@ static int mlxsw_sp_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-static int mlxsw_sp_adj_discard_write(struct mlxsw_sp *mlxsw_sp)
-{
-	enum mlxsw_reg_ratr_trap_action trap_action;
-	char ratr_pl[MLXSW_REG_RATR_LEN];
-	int err;
-
-	if (mlxsw_sp->router->adj_discard_index_valid)
-		return 0;
-
-	err = mlxsw_sp_kvdl_alloc(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
-				  &mlxsw_sp->router->adj_discard_index);
-	if (err)
-		return err;
-
-	trap_action = MLXSW_REG_RATR_TRAP_ACTION_TRAP;
-	mlxsw_reg_ratr_pack(ratr_pl, MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY, true,
-			    MLXSW_REG_RATR_TYPE_ETHERNET,
-			    mlxsw_sp->router->adj_discard_index,
-			    mlxsw_sp->router->lb_rif_index);
-	mlxsw_reg_ratr_trap_action_set(ratr_pl, trap_action);
-	mlxsw_reg_ratr_trap_id_set(ratr_pl, MLXSW_TRAP_ID_RTR_EGRESS0);
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ratr), ratr_pl);
-	if (err)
-		goto err_ratr_write;
-
-	mlxsw_sp->router->adj_discard_index_valid = true;
-
-	return 0;
-
-err_ratr_write:
-	mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
-			   mlxsw_sp->router->adj_discard_index);
-	return err;
-}
-
 static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 					struct mlxsw_sp_fib_entry *fib_entry,
@@ -5844,7 +5809,6 @@ static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
 	u16 trap_id = 0;
 	u32 adjacency_index = 0;
 	u16 ecmp_size = 0;
-	int err;
 
 	/* In case the nexthop group adjacency index is valid, use it
 	 * with provided ECMP size. Otherwise, setup trap and pass
@@ -5855,11 +5819,8 @@ static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
 		adjacency_index = nhgi->adj_index;
 		ecmp_size = nhgi->ecmp_size;
 	} else if (!nhgi->adj_index_valid && nhgi->count && nhgi->nh_rif) {
-		err = mlxsw_sp_adj_discard_write(mlxsw_sp);
-		if (err)
-			return err;
 		trap_action = MLXSW_REG_RALUE_TRAP_ACTION_NOP;
-		adjacency_index = mlxsw_sp->router->adj_discard_index;
+		adjacency_index = mlxsw_sp->router->adj_trap_index;
 		ecmp_size = 1;
 	} else {
 		trap_action = MLXSW_REG_RALUE_TRAP_ACTION_TRAP;
@@ -7418,16 +7379,6 @@ static void mlxsw_sp_router_fib_flush(struct mlxsw_sp *mlxsw_sp)
 			continue;
 		mlxsw_sp_vr_fib_flush(mlxsw_sp, vr, MLXSW_SP_L3_PROTO_IPV6);
 	}
-
-	/* After flushing all the routes, it is not possible anyone is still
-	 * using the adjacency index that is discarding packets, so free it in
-	 * case it was allocated.
-	 */
-	if (!mlxsw_sp->router->adj_discard_index_valid)
-		return;
-	mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
-			   mlxsw_sp->router->adj_discard_index);
-	mlxsw_sp->router->adj_discard_index_valid = false;
 }
 
 struct mlxsw_sp_fib6_event {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 0c4f5bf4efd9..cc32d25c3bb2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -65,8 +65,6 @@ struct mlxsw_sp_router {
 	struct notifier_block inet6addr_nb;
 	const struct mlxsw_sp_rif_ops **rif_ops_arr;
 	const struct mlxsw_sp_ipip_ops **ipip_ops_arr;
-	u32 adj_discard_index;
-	bool adj_discard_index_valid;
 	struct mlxsw_sp_router_nve_decap nve_decap_config;
 	struct mutex lock; /* Protects shared router resources */
 	struct work_struct fib_event_work;
-- 
2.31.1

