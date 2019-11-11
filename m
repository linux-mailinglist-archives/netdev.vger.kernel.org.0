Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD7F8F8385
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 00:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbfKKXer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 18:34:47 -0500
Received: from correo.us.es ([193.147.175.20]:43018 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbfKKXeq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 18:34:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 387FD2A2BC4
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:34:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27AF1B8001
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:34:42 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1D55CB7FF9; Tue, 12 Nov 2019 00:34:42 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16CA5DA72F;
        Tue, 12 Nov 2019 00:34:40 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 00:34:40 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CC67842EF4E0;
        Tue, 12 Nov 2019 00:34:39 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     saeedm@mellanox.com
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH mlx5-next 2/7] net/mlx5: Rename FDB_* tc related defines to FDB_TC_* defines
Date:   Tue, 12 Nov 2019 00:34:25 +0100
Message-Id: <20191111233430.25120-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191111233430.25120-1-pablo@netfilter.org>
References: <20191111233430.25120-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Rename it to prepare for next patch that will add a
different type of offload to the FDB.

Issue: 1929510
Change-Id: I4f3102a689e092e19b53861be7db531b56b37b37
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h          |  8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 10 +++++-----
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c          |  8 ++++----
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index bb970b2ebf8a..0c1022cda128 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1074,7 +1074,7 @@ mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
 	memcpy(slow_attr, flow->esw_attr, sizeof(*slow_attr));
 	slow_attr->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	slow_attr->split_count = 0;
-	slow_attr->dest_chain = FDB_SLOW_PATH_CHAIN;
+	slow_attr->dest_chain = FDB_TC_SLOW_PATH_CHAIN;
 
 	rule = mlx5e_tc_offload_fdb_rules(esw, flow, spec, slow_attr);
 	if (!IS_ERR(rule))
@@ -1091,7 +1091,7 @@ mlx5e_tc_unoffload_from_slow_path(struct mlx5_eswitch *esw,
 	memcpy(slow_attr, flow->esw_attr, sizeof(*slow_attr));
 	slow_attr->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	slow_attr->split_count = 0;
-	slow_attr->dest_chain = FDB_SLOW_PATH_CHAIN;
+	slow_attr->dest_chain = FDB_TC_SLOW_PATH_CHAIN;
 	mlx5e_tc_unoffload_fdb_rules(esw, flow, slow_attr);
 	flow_flag_clear(flow, SLOW);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 25ecf0c516d6..b54c30c33113 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -43,9 +43,9 @@
 #include <linux/mlx5/fs.h>
 #include "lib/mpfs.h"
 
-#define FDB_MAX_CHAIN 3
-#define FDB_SLOW_PATH_CHAIN (FDB_MAX_CHAIN + 1)
-#define FDB_MAX_PRIO 16
+#define FDB_TC_MAX_CHAIN 3
+#define FDB_TC_SLOW_PATH_CHAIN (FDB_TC_MAX_CHAIN + 1)
+#define FDB_TC_MAX_PRIO 16
 
 #ifdef CONFIG_MLX5_ESWITCH
 
@@ -166,7 +166,7 @@ struct mlx5_eswitch_fdb {
 			struct {
 				struct mlx5_flow_table *fdb;
 				u32 num_rules;
-			} fdb_prio[FDB_MAX_CHAIN + 1][FDB_MAX_PRIO + 1][PRIO_LEVELS];
+			} fdb_prio[FDB_TC_MAX_CHAIN + 1][FDB_TC_MAX_PRIO + 1][PRIO_LEVELS];
 			/* Protects fdb_prio table */
 			struct mutex fdb_prio_lock;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 6d781c2ed103..e22366ecdf6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -75,7 +75,7 @@ bool mlx5_eswitch_prios_supported(struct mlx5_eswitch *esw)
 u32 mlx5_eswitch_get_chain_range(struct mlx5_eswitch *esw)
 {
 	if (esw->fdb_table.flags & ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED)
-		return FDB_MAX_CHAIN;
+		return FDB_TC_MAX_CHAIN;
 
 	return 0;
 }
@@ -83,7 +83,7 @@ u32 mlx5_eswitch_get_chain_range(struct mlx5_eswitch *esw)
 u16 mlx5_eswitch_get_prio_range(struct mlx5_eswitch *esw)
 {
 	if (esw->fdb_table.flags & ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED)
-		return FDB_MAX_PRIO;
+		return FDB_TC_MAX_PRIO;
 
 	return 1;
 }
@@ -927,7 +927,7 @@ esw_get_prio_table(struct mlx5_eswitch *esw, u32 chain, u16 prio, int level)
 	int table_prio, l = 0;
 	u32 flags = 0;
 
-	if (chain == FDB_SLOW_PATH_CHAIN)
+	if (chain == FDB_TC_SLOW_PATH_CHAIN)
 		return esw->fdb_table.offloads.slow_fdb;
 
 	mutex_lock(&esw->fdb_table.offloads.fdb_prio_lock);
@@ -952,7 +952,7 @@ esw_get_prio_table(struct mlx5_eswitch *esw, u32 chain, u16 prio, int level)
 		flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
 			  MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
 
-	table_prio = (chain * FDB_MAX_PRIO) + prio - 1;
+	table_prio = (chain * FDB_TC_MAX_PRIO) + prio - 1;
 
 	/* create earlier levels for correct fs_core lookup when
 	 * connecting tables
@@ -989,7 +989,7 @@ esw_put_prio_table(struct mlx5_eswitch *esw, u32 chain, u16 prio, int level)
 {
 	int l;
 
-	if (chain == FDB_SLOW_PATH_CHAIN)
+	if (chain == FDB_TC_SLOW_PATH_CHAIN)
 		return;
 
 	mutex_lock(&esw->fdb_table.offloads.fdb_prio_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 0246f5cdd355..c9b023a99ba6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2606,7 +2606,7 @@ static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 		return -ENOMEM;
 
 	steering->fdb_sub_ns = kzalloc(sizeof(steering->fdb_sub_ns) *
-				       (FDB_MAX_CHAIN + 1), GFP_KERNEL);
+				       (FDB_TC_MAX_CHAIN + 1), GFP_KERNEL);
 	if (!steering->fdb_sub_ns)
 		return -ENOMEM;
 
@@ -2617,7 +2617,7 @@ static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 		goto out_err;
 	}
 
-	levels = 2 * FDB_MAX_PRIO * (FDB_MAX_CHAIN + 1);
+	levels = 2 * FDB_TC_MAX_PRIO * (FDB_TC_MAX_CHAIN + 1);
 	maj_prio = fs_create_prio_chained(&steering->fdb_root_ns->ns,
 					  FDB_FAST_PATH,
 					  levels);
@@ -2626,14 +2626,14 @@ static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 		goto out_err;
 	}
 
-	for (chain = 0; chain <= FDB_MAX_CHAIN; chain++) {
+	for (chain = 0; chain <= FDB_TC_MAX_CHAIN; chain++) {
 		ns = fs_create_namespace(maj_prio, MLX5_FLOW_TABLE_MISS_ACTION_DEF);
 		if (IS_ERR(ns)) {
 			err = PTR_ERR(ns);
 			goto out_err;
 		}
 
-		for (prio = 0; prio < FDB_MAX_PRIO * (chain + 1); prio++) {
+		for (prio = 0; prio < FDB_TC_MAX_PRIO * (chain + 1); prio++) {
 			min_prio = fs_create_prio(ns, prio, 2);
 			if (IS_ERR(min_prio)) {
 				err = PTR_ERR(min_prio);
-- 
2.11.0

