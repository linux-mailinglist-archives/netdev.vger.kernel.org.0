Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9912B6C28
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbgKQRrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:47:39 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:59651 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729008AbgKQRri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 12:47:38 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 50E80E18;
        Tue, 17 Nov 2020 12:47:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 17 Nov 2020 12:47:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=O4ZFVmpXBmR3G3oOHtqg8EEXOZ4X2qO/9wRdWskbtfQ=; b=P1K21lN+
        fE+zGuraCCjoytYi0tiZB7xEetcU/W+EBh0iycgFVmbBtB4rmrAgz7/LNIlumcxX
        TuzsooxDwT9IdP7VwhmLUtkYnWr5Cxy3BOQFRrpJdxd7olsrfdOtn/ycfgS4Vj52
        90kfgqvGRK0tcajZxkg90DUBDF85AmqxeCCyMCLt3tYrTZrr2hhsdaxU3OZeh/4K
        7F2pVKj5vdGTWQsHMT/Y8BlxJklNhOBx8PRdZ3IHccPZhITHzzHP7q+IsJh/xGXO
        +ieJ7Ku2rVfcZGeIATHxDZUHT+Cr0iTsOX19GdshBfrIVSoHOQiKA340jayX2gft
        knHl93i7/CBNiw==
X-ME-Sender: <xms:uAy0X3-3Z0rWzZqNRMq7MhH6RsiEHoeL9kurA072_NKF4tpwJ_iU3g>
    <xme:uAy0XztXD3BcNw0FBNBvEblci-E3zjdikTR70Yc23HbvtwY3-wItuLXC4T-VchldL
    CQUM-r6ImhNA9E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:uAy0X1B-qwpFYabJLJfbWt38E7k8c_k6lz4M1KJrvGpX3F4NLTkCig>
    <xmx:uAy0XzcUJLXdwCHGh4OY69hmXPi7N82jl5rpTPyHsZxRnTGChy9_og>
    <xmx:uAy0X8PJfRv8Rzw1y7TF8HypGIQfY8Nw2KIEpkhb5ZQw0-5UnCk0pQ>
    <xmx:uAy0XxouHN0tydpZKoZ_v56PaBUHT6DYc370ucdWV9KjMLyBJyFihg>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 85707328005E;
        Tue, 17 Nov 2020 12:47:35 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/9] mlxsw: spectrum_router: Set FIB entry's type after creating nexthop group
Date:   Tue, 17 Nov 2020 19:46:59 +0200
Message-Id: <20201117174704.291990-5-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117174704.291990-1-idosch@idosch.org>
References: <20201117174704.291990-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Each FIB entry has a type (e.g., remote, local) that determines how the
entry is programmed to the device. In order to determine if the entry is
local (directly connected) or remote (has a gateway) the relevant FIB
info structures (e.g., 'struct fib_info') are checked.

When entries that use nexthop objects are supported, these checks will
need to be changed to take into account 'struct nexthop'.

Instead, first associate the entry with a nexthop group so that the next
patch could determine the entry's type based on the associated nexthop
group's type.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c  | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 89b44dc543a5..c791e7f75cca 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4864,14 +4864,14 @@ mlxsw_sp_fib4_entry_create(struct mlxsw_sp *mlxsw_sp,
 		goto err_fib_entry_priv_create;
 	}
 
-	err = mlxsw_sp_fib4_entry_type_set(mlxsw_sp, fen_info, fib_entry);
-	if (err)
-		goto err_fib4_entry_type_set;
-
 	err = mlxsw_sp_nexthop4_group_get(mlxsw_sp, fib_entry, fen_info->fi);
 	if (err)
 		goto err_nexthop4_group_get;
 
+	err = mlxsw_sp_fib4_entry_type_set(mlxsw_sp, fen_info, fib_entry);
+	if (err)
+		goto err_fib4_entry_type_set;
+
 	fib4_entry->fi = fen_info->fi;
 	fib_info_hold(fib4_entry->fi);
 	fib4_entry->tb_id = fen_info->tb_id;
@@ -4882,9 +4882,9 @@ mlxsw_sp_fib4_entry_create(struct mlxsw_sp *mlxsw_sp,
 
 	return fib4_entry;
 
-err_nexthop4_group_get:
-	mlxsw_sp_fib4_entry_type_unset(mlxsw_sp, fib_entry);
 err_fib4_entry_type_set:
+	mlxsw_sp_nexthop4_group_put(mlxsw_sp, &fib4_entry->common);
+err_nexthop4_group_get:
 	mlxsw_sp_fib_entry_priv_put(fib_entry->priv);
 err_fib_entry_priv_create:
 	kfree(fib4_entry);
@@ -4895,8 +4895,8 @@ static void mlxsw_sp_fib4_entry_destroy(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_fib4_entry *fib4_entry)
 {
 	fib_info_put(fib4_entry->fi);
-	mlxsw_sp_nexthop4_group_put(mlxsw_sp, &fib4_entry->common);
 	mlxsw_sp_fib4_entry_type_unset(mlxsw_sp, &fib4_entry->common);
+	mlxsw_sp_nexthop4_group_put(mlxsw_sp, &fib4_entry->common);
 	mlxsw_sp_fib_entry_priv_put(fib4_entry->common.priv);
 	kfree(fib4_entry);
 }
@@ -5692,12 +5692,12 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 		fib6_entry->nrt6++;
 	}
 
-	mlxsw_sp_fib6_entry_type_set(mlxsw_sp, fib_entry, rt_arr[0]);
-
 	err = mlxsw_sp_nexthop6_group_get(mlxsw_sp, fib6_entry);
 	if (err)
 		goto err_nexthop6_group_get;
 
+	mlxsw_sp_fib6_entry_type_set(mlxsw_sp, fib_entry, rt_arr[0]);
+
 	fib_entry->fib_node = fib_node;
 
 	return fib6_entry;
-- 
2.28.0

