Return-Path: <netdev+bounces-7007-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA5977192F3
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:05:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 530C92816A4
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DA3C13AED;
	Thu,  1 Jun 2023 06:01:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16313154B9
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5AAC433A4;
	Thu,  1 Jun 2023 06:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685599303;
	bh=juDagYlYU30eGZirFDyoWFQUgAoaPa4vJ8ntIQUznW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSuM/Rie+dt9FWHPQ2iQvCF9l1zTP/OEuQIdlKrbA0sNQnYcR1uO7JA7UhUJ99z6W
	 2+D/VnDUVrJXQ87zeKjZh4LUcyq7YOSq6Z0eHZj9qj15udbPwwluasQdYNIgfwpL7U
	 +qbByZkwi9XTMgiy3dJlC5sc8zg2PsnkZrNci/Hid9tPwJDlZ3oIHFCla28BzMXmwH
	 4rot0J8/d9C3m08Ofo8gZ1JSnB1E9SCbrjZhvfD8XKphrlCrcZEs5jeYOXODuf+iBI
	 ZEv3Zk/zbpFc+sfvu9aaeGrhdWXuqXWf1NY+b8ggq5l5QxRby30UyEq9DFQYX9SW66
	 pHiIXn/EHVCKA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Roi Dayan <roid@nvidia.com>
Subject: [net-next 11/14] net/mlx5: Devcom, Rename paired to ready
Date: Wed, 31 May 2023 23:01:15 -0700
Message-Id: <20230601060118.154015-12-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601060118.154015-1-saeed@kernel.org>
References: <20230601060118.154015-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

In downstream patch devcom will provide support for more than two
devices. The term 'paired' will be renamed as 'ready' to convey a
more accurate meaning.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  4 ++--
 .../mellanox/mlx5/core/eswitch_offloads.c     |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c |  4 ++--
 .../ethernet/mellanox/mlx5/core/lib/devcom.c  | 20 +++++++++----------
 .../ethernet/mellanox/mlx5/core/lib/devcom.h  | 10 +++++-----
 6 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 13d69c5634ac..45e9e7b383dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -413,7 +413,7 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 		return 0;
 
 	rpriv = mlx5e_rep_to_rep_priv(rep);
-	if (mlx5_devcom_is_paired(esw->dev->priv.devcom, MLX5_DEVCOM_ESW_OFFLOADS))
+	if (mlx5_devcom_comp_is_ready(esw->dev->priv.devcom, MLX5_DEVCOM_ESW_OFFLOADS))
 		peer_esw = mlx5_devcom_get_peer_data(esw->dev->priv.devcom,
 						     MLX5_DEVCOM_ESW_OFFLOADS);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 13071d184d88..f4ab00d84691 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4293,8 +4293,8 @@ static bool is_peer_flow_needed(struct mlx5e_tc_flow *flow)
 		flow_flag_test(flow, INGRESS);
 	bool act_is_encap = !!(attr->action &
 			       MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT);
-	bool esw_paired = mlx5_devcom_is_paired(esw_attr->in_mdev->priv.devcom,
-						MLX5_DEVCOM_ESW_OFFLOADS);
+	bool esw_paired = mlx5_devcom_comp_is_ready(esw_attr->in_mdev->priv.devcom,
+						    MLX5_DEVCOM_ESW_OFFLOADS);
 
 	if (!esw_paired)
 		return false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 761278e1af5c..aeb15b10048e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2836,14 +2836,14 @@ static int mlx5_esw_offloads_devcom_event(int event,
 
 		esw->paired[mlx5_get_dev_index(peer_esw->dev)] = true;
 		peer_esw->paired[mlx5_get_dev_index(esw->dev)] = true;
-		mlx5_devcom_set_paired(devcom, MLX5_DEVCOM_ESW_OFFLOADS, true);
+		mlx5_devcom_comp_set_ready(devcom, MLX5_DEVCOM_ESW_OFFLOADS, true);
 		break;
 
 	case ESW_OFFLOADS_DEVCOM_UNPAIR:
 		if (!esw->paired[mlx5_get_dev_index(peer_esw->dev)])
 			break;
 
-		mlx5_devcom_set_paired(devcom, MLX5_DEVCOM_ESW_OFFLOADS, false);
+		mlx5_devcom_comp_set_ready(devcom, MLX5_DEVCOM_ESW_OFFLOADS, false);
 		esw->paired[mlx5_get_dev_index(peer_esw->dev)] = false;
 		peer_esw->paired[mlx5_get_dev_index(esw->dev)] = false;
 		mlx5_esw_offloads_unpair(peer_esw, esw);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 9bc2822881ca..c820f7d266de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -824,8 +824,8 @@ bool mlx5_shared_fdb_supported(struct mlx5_lag *ldev)
 	    is_mdev_switchdev_mode(dev1) &&
 	    mlx5_eswitch_vport_match_metadata_enabled(dev0->priv.eswitch) &&
 	    mlx5_eswitch_vport_match_metadata_enabled(dev1->priv.eswitch) &&
-	    mlx5_devcom_is_paired(dev0->priv.devcom,
-				  MLX5_DEVCOM_ESW_OFFLOADS) &&
+	    mlx5_devcom_comp_is_ready(dev0->priv.devcom,
+				      MLX5_DEVCOM_ESW_OFFLOADS) &&
 	    MLX5_CAP_GEN(dev1, lag_native_fdb_selection) &&
 	    MLX5_CAP_ESW(dev1, root_ft_on_other_esw) &&
 	    MLX5_CAP_ESW(dev0, esw_shared_ingress_acl))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
index b7d779d08d83..7446900a589e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
@@ -19,7 +19,7 @@ struct mlx5_devcom_component {
 
 	mlx5_devcom_event_handler_t handler;
 	struct rw_semaphore sem;
-	bool paired;
+	bool ready;
 };
 
 struct mlx5_devcom_list {
@@ -218,25 +218,25 @@ int mlx5_devcom_send_event(struct mlx5_devcom *devcom,
 	return err;
 }
 
-void mlx5_devcom_set_paired(struct mlx5_devcom *devcom,
-			    enum mlx5_devcom_components id,
-			    bool paired)
+void mlx5_devcom_comp_set_ready(struct mlx5_devcom *devcom,
+				enum mlx5_devcom_components id,
+				bool ready)
 {
 	struct mlx5_devcom_component *comp;
 
 	comp = &devcom->priv->components[id];
 	WARN_ON(!rwsem_is_locked(&comp->sem));
 
-	WRITE_ONCE(comp->paired, paired);
+	WRITE_ONCE(comp->ready, ready);
 }
 
-bool mlx5_devcom_is_paired(struct mlx5_devcom *devcom,
-			   enum mlx5_devcom_components id)
+bool mlx5_devcom_comp_is_ready(struct mlx5_devcom *devcom,
+			       enum mlx5_devcom_components id)
 {
 	if (IS_ERR_OR_NULL(devcom))
 		return false;
 
-	return READ_ONCE(devcom->priv->components[id].paired);
+	return READ_ONCE(devcom->priv->components[id].ready);
 }
 
 void *mlx5_devcom_get_peer_data(struct mlx5_devcom *devcom,
@@ -250,7 +250,7 @@ void *mlx5_devcom_get_peer_data(struct mlx5_devcom *devcom,
 
 	comp = &devcom->priv->components[id];
 	down_read(&comp->sem);
-	if (!READ_ONCE(comp->paired)) {
+	if (!READ_ONCE(comp->ready)) {
 		up_read(&comp->sem);
 		return NULL;
 	}
@@ -278,7 +278,7 @@ void *mlx5_devcom_get_peer_data_rcu(struct mlx5_devcom *devcom, enum mlx5_devcom
 	/* This can change concurrently, however 'data' pointer will remain
 	 * valid for the duration of RCU read section.
 	 */
-	if (!READ_ONCE(comp->paired))
+	if (!READ_ONCE(comp->ready))
 		return NULL;
 
 	return rcu_dereference(comp->device[i].data);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h
index 9a496f4722da..d465de8459b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h
@@ -33,11 +33,11 @@ int mlx5_devcom_send_event(struct mlx5_devcom *devcom,
 			   int event,
 			   void *event_data);
 
-void mlx5_devcom_set_paired(struct mlx5_devcom *devcom,
-			    enum mlx5_devcom_components id,
-			    bool paired);
-bool mlx5_devcom_is_paired(struct mlx5_devcom *devcom,
-			   enum mlx5_devcom_components id);
+void mlx5_devcom_comp_set_ready(struct mlx5_devcom *devcom,
+				enum mlx5_devcom_components id,
+				bool ready);
+bool mlx5_devcom_comp_is_ready(struct mlx5_devcom *devcom,
+			       enum mlx5_devcom_components id);
 
 void *mlx5_devcom_get_peer_data(struct mlx5_devcom *devcom,
 				enum mlx5_devcom_components id);
-- 
2.40.1


