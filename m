Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D32D4142D0
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbhIVHjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:39:00 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60045 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233365AbhIVHi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:38:57 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 0EBFE5C00F0;
        Wed, 22 Sep 2021 03:37:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 22 Sep 2021 03:37:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=JSmCFA82SCSWncLsmnjE6bnAZrIp3XFkt4QT13BAGh4=; b=XpljMANw
        GT+a3hG7ZnfosUTPpekfqDY4AQnrgv6FXz8qOb+8ag7yKuslVrChP0+sWN+Uutok
        U26uQqOBzXHfNRSVLLRwXbZaDqhg1Rde3UlAnGqf1DgoX5HOnMKu8IB/keYiSOEQ
        05EebjZrL7ueTCIe0TyNvCtC1PVqYqWSmW8Ozqu5PyrDZe0c+Bp0szvo1ucU/v/e
        NmLoBwecia4lUC0PPLUc1E+U7/s7kwn/l3Q1R/QZ3BKaYl8FYOy1nA5037pALXZ9
        +2Z67fdYnikBHfLephgGYGKGmWpmHvTdIpBeMuOVnD32JDSwoYSiUywQ2oj+E/Xr
        uZuUYsyRbio9UA==
X-ME-Sender: <xms:Nt1KYUxfn7x23m18gHp3ynQPgrpZ7u9d8ZOW29Xwbawsx74fQe8WcQ>
    <xme:Nt1KYYT3f4m6_MItiGlKhm95j4gE8Mk_aJLp_MCBIxgkHURvs9IrXOvyympsLylCU
    IZHlRo2VEiOVTI>
X-ME-Received: <xmr:Nt1KYWVT7SCjfOY7HktrT0JZaWHNMp8hOGbUh8GbZQMJBpCaT5I4d6JUyEhQ8glfMIZ5rWjt7O6dsUxtGql4APqe4-CbqUiASjrhho4Vq-55fw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiiedgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeefgefhheevheevhfetkeeuheeffe
    efiedtvdffledtlefgfeffvdejudelfedufeenucffohhmrghinhepghhithhhuhgsrdgt
    ohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Nt1KYSis-Pnwv5H2vyU0X4fkY86bUgNnKIlAHY1daF8RVrTZuaTsGA>
    <xmx:Nt1KYWABsXpn-ceC9OXNspV8sl7W0pOVoBCk7GqWfm0IdX-Jcuev-Q>
    <xmx:Nt1KYTJyAEpy0w17H4r8lZyL2ZHrCUfMlUiEERPPhXHxT2zkIsRJVQ>
    <xmx:ON1KYRMs3kX4Aa60y-jxMtSawgy3GHxQCHNhWGELvgzy0fSf-TD3ew>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Sep 2021 03:37:24 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/2] mlxsw: spectrum_router: Add trap adjacency entry upon first nexthop group
Date:   Wed, 22 Sep 2021 10:36:41 +0300
Message-Id: <20210922073642.796559-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210922073642.796559-1-idosch@idosch.org>
References: <20210922073642.796559-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

In commit 0c3cbbf96def ("mlxsw: Add specific trap for packets routed via
invalid nexthops"), mlxsw started allocating a new adjacency entry
during driver initialization, to trap packets routed via invalid
nexthops.

This behavior was later altered in commit 983db6198f0d ("mlxsw:
spectrum_router: Allocate discard adjacency entry when needed") to only
allocate the entry upon the first route that requires it. The motivation
for the change is explained in the commit message.

The problem with the current behavior is that the entry shows up as a
"leak" in a new BPF resource monitoring tool [1]. This is caused by the
asymmetry of the allocation/free scheme. While the entry is allocated
upon the first route that requires it, it is only freed during
de-initialization of the driver.

Instead, track the number of active nexthop groups and allocate the
adjacency entry upon the creation of the first group. Free it when the
number of active groups reaches zero.

The next patch will convert mlxsw to start using the new entry and
remove the old one.

[1] https://github.com/Mellanox/mlxsw/tree/master/Debugging/libbpf-tools/resmon

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 78 +++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  2 +
 2 files changed, 80 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 19bb3ca0515e..00648e093351 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4376,6 +4376,66 @@ static void mlxsw_sp_nexthop_rif_gone_sync(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
+static int mlxsw_sp_adj_trap_entry_init(struct mlxsw_sp *mlxsw_sp)
+{
+	enum mlxsw_reg_ratr_trap_action trap_action;
+	char ratr_pl[MLXSW_REG_RATR_LEN];
+	int err;
+
+	err = mlxsw_sp_kvdl_alloc(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
+				  &mlxsw_sp->router->adj_trap_index);
+	if (err)
+		return err;
+
+	trap_action = MLXSW_REG_RATR_TRAP_ACTION_TRAP;
+	mlxsw_reg_ratr_pack(ratr_pl, MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY, true,
+			    MLXSW_REG_RATR_TYPE_ETHERNET,
+			    mlxsw_sp->router->adj_trap_index,
+			    mlxsw_sp->router->lb_rif_index);
+	mlxsw_reg_ratr_trap_action_set(ratr_pl, trap_action);
+	mlxsw_reg_ratr_trap_id_set(ratr_pl, MLXSW_TRAP_ID_RTR_EGRESS0);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ratr), ratr_pl);
+	if (err)
+		goto err_ratr_write;
+
+	return 0;
+
+err_ratr_write:
+	mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
+			   mlxsw_sp->router->adj_trap_index);
+	return err;
+}
+
+static void mlxsw_sp_adj_trap_entry_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
+			   mlxsw_sp->router->adj_trap_index);
+}
+
+static int mlxsw_sp_nexthop_group_inc(struct mlxsw_sp *mlxsw_sp)
+{
+	int err;
+
+	if (refcount_inc_not_zero(&mlxsw_sp->router->num_groups))
+		return 0;
+
+	err = mlxsw_sp_adj_trap_entry_init(mlxsw_sp);
+	if (err)
+		return err;
+
+	refcount_set(&mlxsw_sp->router->num_groups, 1);
+
+	return 0;
+}
+
+static void mlxsw_sp_nexthop_group_dec(struct mlxsw_sp *mlxsw_sp)
+{
+	if (!refcount_dec_and_test(&mlxsw_sp->router->num_groups))
+		return;
+
+	mlxsw_sp_adj_trap_entry_fini(mlxsw_sp);
+}
+
 static void
 mlxsw_sp_nh_grp_activity_get(struct mlxsw_sp *mlxsw_sp,
 			     const struct mlxsw_sp_nexthop_group *nh_grp,
@@ -4790,6 +4850,9 @@ mlxsw_sp_nexthop_obj_group_info_init(struct mlxsw_sp *mlxsw_sp,
 		if (err)
 			goto err_nexthop_obj_init;
 	}
+	err = mlxsw_sp_nexthop_group_inc(mlxsw_sp);
+	if (err)
+		goto err_group_inc;
 	err = mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh_grp);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(info->extack, "Failed to write adjacency entries to the device");
@@ -4808,6 +4871,8 @@ mlxsw_sp_nexthop_obj_group_info_init(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_group_refresh:
+	mlxsw_sp_nexthop_group_dec(mlxsw_sp);
+err_group_inc:
 	i = nhgi->count;
 err_nexthop_obj_init:
 	for (i--; i >= 0; i--) {
@@ -4832,6 +4897,7 @@ mlxsw_sp_nexthop_obj_group_info_fini(struct mlxsw_sp *mlxsw_sp,
 			cancel_delayed_work(&router->nh_grp_activity_dw);
 	}
 
+	mlxsw_sp_nexthop_group_dec(mlxsw_sp);
 	for (i = nhgi->count - 1; i >= 0; i--) {
 		struct mlxsw_sp_nexthop *nh = &nhgi->nexthops[i];
 
@@ -5223,6 +5289,9 @@ mlxsw_sp_nexthop4_group_info_init(struct mlxsw_sp *mlxsw_sp,
 		if (err)
 			goto err_nexthop4_init;
 	}
+	err = mlxsw_sp_nexthop_group_inc(mlxsw_sp);
+	if (err)
+		goto err_group_inc;
 	err = mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh_grp);
 	if (err)
 		goto err_group_refresh;
@@ -5230,6 +5299,8 @@ mlxsw_sp_nexthop4_group_info_init(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_group_refresh:
+	mlxsw_sp_nexthop_group_dec(mlxsw_sp);
+err_group_inc:
 	i = nhgi->count;
 err_nexthop4_init:
 	for (i--; i >= 0; i--) {
@@ -5247,6 +5318,7 @@ mlxsw_sp_nexthop4_group_info_fini(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_nexthop_group_info *nhgi = nh_grp->nhgi;
 	int i;
 
+	mlxsw_sp_nexthop_group_dec(mlxsw_sp);
 	for (i = nhgi->count - 1; i >= 0; i--) {
 		struct mlxsw_sp_nexthop *nh = &nhgi->nexthops[i];
 
@@ -6641,6 +6713,9 @@ mlxsw_sp_nexthop6_group_info_init(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_rt6 = list_next_entry(mlxsw_sp_rt6, list);
 	}
 	nh_grp->nhgi = nhgi;
+	err = mlxsw_sp_nexthop_group_inc(mlxsw_sp);
+	if (err)
+		goto err_group_inc;
 	err = mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh_grp);
 	if (err)
 		goto err_group_refresh;
@@ -6648,6 +6723,8 @@ mlxsw_sp_nexthop6_group_info_init(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_group_refresh:
+	mlxsw_sp_nexthop_group_dec(mlxsw_sp);
+err_group_inc:
 	i = nhgi->count;
 err_nexthop6_init:
 	for (i--; i >= 0; i--) {
@@ -6665,6 +6742,7 @@ mlxsw_sp_nexthop6_group_info_fini(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_nexthop_group_info *nhgi = nh_grp->nhgi;
 	int i;
 
+	mlxsw_sp_nexthop_group_dec(mlxsw_sp);
 	for (i = nhgi->count - 1; i >= 0; i--) {
 		struct mlxsw_sp_nexthop *nh = &nhgi->nexthops[i];
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 25d3eae63501..0c4f5bf4efd9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -82,6 +82,8 @@ struct mlxsw_sp_router {
 	struct delayed_work nh_grp_activity_dw;
 	struct list_head nh_res_grp_list;
 	bool inc_parsing_depth;
+	refcount_t num_groups;
+	u32 adj_trap_index;
 };
 
 struct mlxsw_sp_fib_entry_priv {
-- 
2.31.1

