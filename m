Return-Path: <netdev+bounces-3976-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56782709EA5
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:57:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12413281DB2
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:57:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21C9D12B9D;
	Fri, 19 May 2023 17:56:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF7612B88
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA1CC433A8;
	Fri, 19 May 2023 17:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684518972;
	bh=kPHi/o3RZo3X2RoKt/73ztN8vt1JDfZw6NX+PWDcKxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/jbRhVkTPj+rDzcFG3iz56PJfU8mepcYu0b5GL5WVNfU/sMt7zMwBs6+BrMAfZ0c
	 WNLlO/x1mp5KCN3M/VsfmVu+aFVh2bmTCrJNI1eMxG2eFHsKBNCB6u1DFlSkr1NSVT
	 MA7uk6AaNMLn1PhlxpqVCT0ns40rhcmTefssyu1xyG23w4RsygBieEP/w4O5pGxX2e
	 r8lpOGAgg4ivFSKBqJbrXNL9Q36y7eMSf9JMPD1ffVoh69svXNeZAl1V83LLxeUggn
	 jBIop+mTSq0M4pEUxC/+UxZJzTfP7JsDonSk8k7oUlXy80UD19Z6qwaWGLSQhLMAHS
	 u0Dvpgj3MjsNQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Roi Dayan <roid@nvidia.com>
Subject: [net-next 04/15] net/mlx5e: Remove redundant __func__ arg from fs_err() calls
Date: Fri, 19 May 2023 10:55:46 -0700
Message-Id: <20230519175557.15683-5-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230519175557.15683-1-saeed@kernel.org>
References: <20230519175557.15683-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Roi Dayan <roid@nvidia.com>

fs_err() already logs the function name. remote the arg so the function
name will not be logged twice.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 33bfe4d7338b..934b0d5ce1b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -283,7 +283,7 @@ static int __mlx5e_add_vlan_rule(struct mlx5e_flow_steering *fs,
 	if (IS_ERR(*rule_p)) {
 		err = PTR_ERR(*rule_p);
 		*rule_p = NULL;
-		fs_err(fs, "%s: add rule failed\n", __func__);
+		fs_err(fs, "add rule failed\n");
 	}
 
 	return err;
@@ -395,8 +395,7 @@ int mlx5e_add_vlan_trap(struct mlx5e_flow_steering *fs, int trap_id, int tir_num
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		fs->vlan->trap_rule = NULL;
-		fs_err(fs, "%s: add VLAN trap rule failed, err %d\n",
-		       __func__, err);
+		fs_err(fs, "add VLAN trap rule failed, err %d\n", err);
 		return err;
 	}
 	fs->vlan->trap_rule = rule;
@@ -421,8 +420,7 @@ int mlx5e_add_mac_trap(struct mlx5e_flow_steering *fs, int trap_id, int tir_num)
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		fs->l2.trap_rule = NULL;
-		fs_err(fs, "%s: add MAC trap rule failed, err %d\n",
-		       __func__, err);
+		fs_err(fs, "add MAC trap rule failed, err %d\n", err);
 		return err;
 	}
 	fs->l2.trap_rule = rule;
@@ -763,7 +761,7 @@ static int mlx5e_add_promisc_rule(struct mlx5e_flow_steering *fs)
 	if (IS_ERR(*rule_p)) {
 		err = PTR_ERR(*rule_p);
 		*rule_p = NULL;
-		fs_err(fs, "%s: add promiscuous rule failed\n", __func__);
+		fs_err(fs, "add promiscuous rule failed\n");
 	}
 	kvfree(spec);
 	return err;
@@ -995,7 +993,7 @@ static int mlx5e_add_l2_flow_rule(struct mlx5e_flow_steering *fs,
 
 	ai->rule = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
 	if (IS_ERR(ai->rule)) {
-		fs_err(fs, "%s: add l2 rule(mac:%pM) failed\n", __func__, mv_dmac);
+		fs_err(fs, "add l2 rule(mac:%pM) failed\n", mv_dmac);
 		err = PTR_ERR(ai->rule);
 		ai->rule = NULL;
 	}
-- 
2.40.1


