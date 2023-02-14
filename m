Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B699697079
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 23:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbjBNWOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 17:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbjBNWOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 17:14:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275C928841
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 14:14:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 773C7CE22D5
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 22:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD40C4339C;
        Tue, 14 Feb 2023 22:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676412849;
        bh=PLZIpzCuLVXXU4D0Fd2wlZ9zBsKP4bzUKBxlYhSTVrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gihbpftz7Px4FfnEvr9QmVyxr1A5Tm3fw8QCuKn/lYcyeWVqlfrgQGN/KdwNDs/OK
         FviM31kgKXgR9qFQfaOh2WIeUdkFKDNhO8bqoUuXvg8B3YkVbWrtGG4fS7jlKkQITd
         1Q/Mm1/7sPHMCnF9PLxgvCJfc1HTeUEr1QbnRDcJsNkX0Uj2foac45KvnPRSLXAMVp
         fqMH8GIjSPCOyZB/oTaGRxv3Rzd99N8vjCu/6ghSYYD5wqEg2IIkO19S5LZBl8Ud8v
         Lug3RiDzPSaYkI/XlTWoQ5ZBrUzWuVkhbVSeznAa7HGKa636rErA5u5Anf+UDVR+gs
         +k5cTXNek8Fzg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next V2 03/15] net/mlx5: E-Switch, rename bond update function to be reused
Date:   Tue, 14 Feb 2023 14:12:27 -0800
Message-Id: <20230214221239.159033-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214221239.159033-1-saeed@kernel.org>
References: <20230214221239.159033-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

The vport bond update function is really updating the vport metadata
and there is no direct relation to bond. Rename the function
to vport metadata update to be used a followup commit.
This commit doesn't change any functionality.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c       | 6 +++---
 .../net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c  | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h      | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
index b6f5c1bcdbcd..016a61c52c45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
@@ -120,8 +120,8 @@ int mlx5e_rep_bond_enslave(struct mlx5_eswitch *esw, struct net_device *netdev,
 	priv = netdev_priv(netdev);
 	rpriv = priv->ppriv;
 
-	err = mlx5_esw_acl_ingress_vport_bond_update(esw, rpriv->rep->vport,
-						     mdata->metadata_reg_c_0);
+	err = mlx5_esw_acl_ingress_vport_metadata_update(esw, rpriv->rep->vport,
+							 mdata->metadata_reg_c_0);
 	if (err)
 		goto ingress_err;
 
@@ -167,7 +167,7 @@ void mlx5e_rep_bond_unslave(struct mlx5_eswitch *esw,
 	/* Reset bond_metadata to zero first then reset all ingress/egress
 	 * acls and rx rules of unslave representor's vport
 	 */
-	mlx5_esw_acl_ingress_vport_bond_update(esw, rpriv->rep->vport, 0);
+	mlx5_esw_acl_ingress_vport_metadata_update(esw, rpriv->rep->vport, 0);
 	mlx5_esw_acl_egress_vport_unbond(esw, rpriv->rep->vport);
 	mlx5e_rep_bond_update(priv, false);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
index a994e71e05c1..d55775627a47 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
@@ -356,8 +356,8 @@ void esw_acl_ingress_ofld_cleanup(struct mlx5_eswitch *esw,
 }
 
 /* Caller must hold rtnl_lock */
-int mlx5_esw_acl_ingress_vport_bond_update(struct mlx5_eswitch *esw, u16 vport_num,
-					   u32 metadata)
+int mlx5_esw_acl_ingress_vport_metadata_update(struct mlx5_eswitch *esw, u16 vport_num,
+					       u32 metadata)
 {
 	struct mlx5_vport *vport = mlx5_eswitch_get_vport(esw, vport_num);
 	int err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
index 11d3d3978848..c9f8469e9a47 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
@@ -24,8 +24,8 @@ static inline bool mlx5_esw_acl_egress_fwd2vport_supported(struct mlx5_eswitch *
 /* Eswitch acl ingress external APIs */
 int esw_acl_ingress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 void esw_acl_ingress_ofld_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
-int mlx5_esw_acl_ingress_vport_bond_update(struct mlx5_eswitch *esw, u16 vport_num,
-					   u32 metadata);
+int mlx5_esw_acl_ingress_vport_metadata_update(struct mlx5_eswitch *esw, u16 vport_num,
+					       u32 metadata);
 void mlx5_esw_acl_ingress_vport_drop_rule_destroy(struct mlx5_eswitch *esw, u16 vport_num);
 int mlx5_esw_acl_ingress_vport_drop_rule_create(struct mlx5_eswitch *esw, u16 vport_num);
 
-- 
2.39.1

