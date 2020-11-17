Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7050D2B6C2C
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729985AbgKQRr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:47:56 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:45953 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729936AbgKQRrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 12:47:47 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 1D75DE1E;
        Tue, 17 Nov 2020 12:47:46 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 17 Nov 2020 12:47:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=V++mJsmjxNjF8/uG6SPoOH9lMGYdR9c+sVAUILav868=; b=CHsmvq5j
        wjkx6gb0N/uOOwabdVfM9DsA4yNxbRikIgkHKkBN6ZkEzexryQTxsi/ijJlP/Dx0
        UDor7U550WSspvhAI8Wbbw27WLCSnJxWuHQ0JcVZf20BN3IRVI4SVvGjlWZREZYZ
        5OotCp6W4IKtbwEm0XoSBikz3KpcqWQVW3uuQrIq7Y1Nb0If1jmQNqUJ5MnXKTRg
        hZKKf17TY2sgPIKPBEftyBJTtyue/iMvZiDkmoUYuvH/zHme0WWT6d0GddUBIEgk
        m9s+BUEbRtK4igwvDFJd93IwYxTXjXqieo5AEJU69mLa3mPCoS8C8WIZyaY7iI7P
        AfanNMJ9+hggHQ==
X-ME-Sender: <xms:wQy0X_tJGOvU4xTOMPdnbUMpnzjLnGy237tMFQJ0VaWpV0M8ggdtvA>
    <xme:wQy0XwceKRE2_93bbhjxq9gLHcqunn7slh1-fP7hJ_re3WRtYKYKwsR9-70Xwp-Ru
    a_j0Z5qF1MbjEY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgepkeenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:wQy0XyxrUPcMJsp_ZDt07b3UMixsvE_M_aIsjkS1ujqnKEKP_2l24Q>
    <xmx:wQy0X-OV-sbOOSdqL0gTYpX0Wc-vwYuNjD5L_fQD-0MdCAnAocA4Ew>
    <xmx:wQy0X_-H4x6BYiq73fJWy6SlgIV4O6iRCqcT57fgvzYJHwaV9tIphA>
    <xmx:wQy0Xyb7MMHCrR6mAiyBSu_AJiGABEmR2v8d4X0dgoa7c6NVsDfG6A>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 088453280060;
        Tue, 17 Nov 2020 12:47:43 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 9/9] mlxsw: spectrum_router: Allow returning errors from mlxsw_sp_nexthop_group_refresh()
Date:   Tue, 17 Nov 2020 19:47:04 +0200
Message-Id: <20201117174704.291990-10-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117174704.291990-1-idosch@idosch.org>
References: <20201117174704.291990-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The function is responsible for allocating the adjacency entries used by
the nexthop group and populating them with the adjacency information
such as egress RIF and MAC address.

Allow the function to return an error when it encounters a problem and
have the relevant call sites check it.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 30 ++++++++++++-------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 87b8c8db688b..147dd8fab2af 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3552,7 +3552,7 @@ mlxsw_sp_nexthop_group_offload_refresh(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
-static void
+static int
 mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 			       struct mlxsw_sp_nexthop_group *nh_grp)
 {
@@ -3562,13 +3562,12 @@ mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 	bool offload_change = false;
 	u32 adj_index;
 	bool old_adj_index_valid;
+	int i, err2, err = 0;
 	u32 old_adj_index;
-	int i;
-	int err;
 
 	if (!nhgi->gateway) {
 		mlxsw_sp_nexthop_fib_entries_update(mlxsw_sp, nh_grp);
-		return;
+		return 0;
 	}
 
 	for (i = 0; i < nhgi->count; i++) {
@@ -3589,7 +3588,7 @@ mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 			dev_warn(mlxsw_sp->bus_info->dev, "Failed to update neigh MAC in adjacency table.\n");
 			goto set_trap;
 		}
-		return;
+		return 0;
 	}
 	mlxsw_sp_nexthop_group_normalize(nhgi);
 	if (!nhgi->sum_norm_weight)
@@ -3637,7 +3636,7 @@ mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 			dev_warn(mlxsw_sp->bus_info->dev, "Failed to add adjacency index to fib entries.\n");
 			goto set_trap;
 		}
-		return;
+		return 0;
 	}
 
 	err = mlxsw_sp_adj_index_mass_update(mlxsw_sp, nh_grp,
@@ -3649,7 +3648,7 @@ mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 		goto set_trap;
 	}
 
-	return;
+	return 0;
 
 set_trap:
 	old_adj_index_valid = nhgi->adj_index_valid;
@@ -3658,13 +3657,14 @@ mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 		nh = &nhgi->nexthops[i];
 		nh->offloaded = 0;
 	}
-	err = mlxsw_sp_nexthop_fib_entries_update(mlxsw_sp, nh_grp);
-	if (err)
+	err2 = mlxsw_sp_nexthop_fib_entries_update(mlxsw_sp, nh_grp);
+	if (err2)
 		dev_warn(mlxsw_sp->bus_info->dev, "Failed to set traps for fib entries.\n");
 	mlxsw_sp_nexthop_group_offload_refresh(mlxsw_sp, nh_grp);
 	if (old_adj_index_valid)
 		mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ,
 				   nhgi->ecmp_size, nhgi->adj_index);
+	return err;
 }
 
 static void __mlxsw_sp_nexthop_neigh_update(struct mlxsw_sp_nexthop *nh,
@@ -4122,10 +4122,14 @@ mlxsw_sp_nexthop4_group_info_init(struct mlxsw_sp *mlxsw_sp,
 		if (err)
 			goto err_nexthop4_init;
 	}
-	mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh_grp);
+	err = mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh_grp);
+	if (err)
+		goto err_group_refresh;
 
 	return 0;
 
+err_group_refresh:
+	i = nhgi->count;
 err_nexthop4_init:
 	for (i--; i >= 0; i--) {
 		nh = &nhgi->nexthops[i];
@@ -5433,10 +5437,14 @@ mlxsw_sp_nexthop6_group_info_init(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_rt6 = list_next_entry(mlxsw_sp_rt6, list);
 	}
 	nh_grp->nhgi = nhgi;
-	mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh_grp);
+	err = mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh_grp);
+	if (err)
+		goto err_group_refresh;
 
 	return 0;
 
+err_group_refresh:
+	i = nhgi->count;
 err_nexthop6_init:
 	for (i--; i >= 0; i--) {
 		nh = &nhgi->nexthops[i];
-- 
2.28.0

