Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762D13562B9
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348540AbhDGEys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:54:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229691AbhDGEyp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:54:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2F13613D0;
        Wed,  7 Apr 2021 04:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617771276;
        bh=RdGfNKKX7S1ylIyFLvN12/Q813oOddQJKOb7Wce8zXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p2VgMi1dEwNNRITCOBK0lcrZKI7ddeih2t+YL1wQIZZjJhOgclGkcEDghaQVU7INh
         IRsVmyVF0rFbcQITBmjp2CqTJ4Tji/BGXYVEAjVPs7fkWIthzG9XFzxk89Z4vewmh7
         Q7Uvw8Ac6c7FCaovU6+pPzQQ1YfhgSvXM1FZ7YXpwuZGxFamlTlF2R2jMlcL+osZKz
         liOdYMw+PE6v2RUf8BkGsy5dHilAKh34l3GiXKv2m+0W12KNcqO+pzEuQXP3AJMdAv
         sDu9f0sbfl0jeZaeB44iwVr5tsXWI6P+BneBFsJ3mtfRep2fYk3SFO+q5Kp6QYJyPZ
         cUoNFp+AsaZag==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/13] net/mlx5: E-switch, Rename functions to follow naming convention.
Date:   Tue,  6 Apr 2021 21:54:10 -0700
Message-Id: <20210407045421.148987-3-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407045421.148987-1-saeed@kernel.org>
References: <20210407045421.148987-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Public api starts with mlx5 and remove mlx5 for non-public api.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/esw/vporttbl.c         |  4 +--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  4 +--
 .../mellanox/mlx5/core/eswitch_offloads.c     | 26 +++++++++----------
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c
index 8219c5d50db0..6c4246181615 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c
@@ -66,7 +66,7 @@ esw_vport_tbl_lookup(struct mlx5_eswitch *esw, struct mlx5_vport_key *skey, u32
 }
 
 struct mlx5_flow_table *
-esw_vport_tbl_get(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr)
+mlx5_esw_vporttbl_get(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr)
 {
 	struct mlx5_core_dev *dev = esw->dev;
 	struct mlx5_flow_namespace *ns;
@@ -116,7 +116,7 @@ esw_vport_tbl_get(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr)
 }
 
 void
-esw_vport_tbl_put(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr)
+mlx5_esw_vporttbl_put(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr)
 {
 	struct mlx5_vport_table *e;
 	struct mlx5_vport_key key;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 70eeb8d1ae03..b7d1f8854ef4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -720,9 +720,9 @@ struct mlx5_vport_tbl_attr {
 };
 
 struct mlx5_flow_table *
-esw_vport_tbl_get(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr);
+mlx5_esw_vporttbl_get(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr);
 void
-esw_vport_tbl_put(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr);
+mlx5_esw_vporttbl_put(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr);
 
 struct mlx5_flow_handle *
 esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 3caf6c0b3296..63e22e9e5ad1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -483,7 +483,7 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 		fwd_attr.prio = attr->prio;
 		fwd_attr.vport = esw_attr->in_rep->vport;
 
-		fdb = esw_vport_tbl_get(esw, &fwd_attr);
+		fdb = mlx5_esw_vporttbl_get(esw, &fwd_attr);
 	} else {
 		if (attr->chain || attr->prio)
 			fdb = mlx5_chains_get_table(chains, attr->chain,
@@ -515,7 +515,7 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 
 err_add_rule:
 	if (split)
-		esw_vport_tbl_put(esw, &fwd_attr);
+		mlx5_esw_vporttbl_put(esw, &fwd_attr);
 	else if (attr->chain || attr->prio)
 		mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
 err_esw_get:
@@ -548,7 +548,7 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 	fwd_attr.chain = attr->chain;
 	fwd_attr.prio = attr->prio;
 	fwd_attr.vport = esw_attr->in_rep->vport;
-	fwd_fdb = esw_vport_tbl_get(esw, &fwd_attr);
+	fwd_fdb = mlx5_esw_vporttbl_get(esw, &fwd_attr);
 	if (IS_ERR(fwd_fdb)) {
 		rule = ERR_CAST(fwd_fdb);
 		goto err_get_fwd;
@@ -593,7 +593,7 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 	return rule;
 err_chain_src_rewrite:
 	esw_put_dest_tables_loop(esw, attr, 0, i);
-	esw_vport_tbl_put(esw, &fwd_attr);
+	mlx5_esw_vporttbl_put(esw, &fwd_attr);
 err_get_fwd:
 	mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
 err_get_fast:
@@ -631,12 +631,12 @@ __mlx5_eswitch_del_rule(struct mlx5_eswitch *esw,
 	}
 
 	if (fwd_rule)  {
-		esw_vport_tbl_put(esw, &fwd_attr);
+		mlx5_esw_vporttbl_put(esw, &fwd_attr);
 		mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
 		esw_put_dest_tables_loop(esw, attr, 0, esw_attr->split_count);
 	} else {
 		if (split)
-			esw_vport_tbl_put(esw, &fwd_attr);
+			mlx5_esw_vporttbl_put(esw, &fwd_attr);
 		else if (attr->chain || attr->prio)
 			mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
 		esw_cleanup_dests(esw, attr);
@@ -1335,7 +1335,7 @@ static void esw_set_flow_group_source_port(struct mlx5_eswitch *esw,
 }
 
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
-static void mlx5_esw_vport_tbl_put(struct mlx5_eswitch *esw)
+static void esw_vport_tbl_put(struct mlx5_eswitch *esw)
 {
 	struct mlx5_vport_tbl_attr attr;
 	struct mlx5_vport *vport;
@@ -1345,11 +1345,11 @@ static void mlx5_esw_vport_tbl_put(struct mlx5_eswitch *esw)
 	attr.prio = 1;
 	mlx5_esw_for_all_vports(esw, i, vport) {
 		attr.vport = vport->vport;
-		esw_vport_tbl_put(esw, &attr);
+		mlx5_esw_vporttbl_put(esw, &attr);
 	}
 }
 
-static int mlx5_esw_vport_tbl_get(struct mlx5_eswitch *esw)
+static int esw_vport_tbl_get(struct mlx5_eswitch *esw)
 {
 	struct mlx5_vport_tbl_attr attr;
 	struct mlx5_flow_table *fdb;
@@ -1360,14 +1360,14 @@ static int mlx5_esw_vport_tbl_get(struct mlx5_eswitch *esw)
 	attr.prio = 1;
 	mlx5_esw_for_all_vports(esw, i, vport) {
 		attr.vport = vport->vport;
-		fdb = esw_vport_tbl_get(esw, &attr);
+		fdb = mlx5_esw_vporttbl_get(esw, &attr);
 		if (IS_ERR(fdb))
 			goto out;
 	}
 	return 0;
 
 out:
-	mlx5_esw_vport_tbl_put(esw);
+	esw_vport_tbl_put(esw);
 	return PTR_ERR(fdb);
 }
 
@@ -1448,7 +1448,7 @@ esw_chains_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *miss_fdb)
 
 	/* Open level 1 for split fdb rules now if prios isn't supported  */
 	if (!mlx5_chains_prios_supported(chains)) {
-		err = mlx5_esw_vport_tbl_get(esw);
+		err = esw_vport_tbl_get(esw);
 		if (err)
 			goto level_1_err;
 	}
@@ -1472,7 +1472,7 @@ static void
 esw_chains_destroy(struct mlx5_eswitch *esw, struct mlx5_fs_chains *chains)
 {
 	if (!mlx5_chains_prios_supported(chains))
-		mlx5_esw_vport_tbl_put(esw);
+		esw_vport_tbl_put(esw);
 	mlx5_chains_put_table(chains, 0, 1, 0);
 	mlx5_chains_put_table(chains, mlx5_chains_get_nf_ft_chain(chains), 1, 0);
 	mlx5_chains_destroy(chains);
-- 
2.30.2

