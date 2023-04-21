Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1D66EA122
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbjDUBkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbjDUBkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:40:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD23423C
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:39:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78A046436C
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A254C433EF;
        Fri, 21 Apr 2023 01:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041193;
        bh=37og7yeXz6XB3Z4+nfUmrYasnJb6xL01InFO7WR8zu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvCLSnH9+iDk0OmEgWPkHYfvLe0rWsm5k0Jtib/fkNVHUljFqDJ78azzfyHchdtBL
         5p8B0JSLL65z/GEFtRrjDljQBrdYsh2UAxYtAP1QMcvTkpsM6Zh5LVXphGsM9GFkiS
         RRdg9NL8e47WlwpgblsJcunWpcxYkVgc/B3GWyDFUVwWsjF4XsNdjGrX+JXBZm9ylG
         EQ6nwlGqHG7iJnozboxrQnLH70fRcO7Mv92FLKIAkMmjqeAoFKA098rgfHfb1dotV4
         rZdhuo6fjU2Jmobx3w0U5FgIDabpC5ybNOB753jSE7Woi1d0P1aQTvJ2Di4DowBKzr
         cfhfB+e3xEQvQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 13/15] net/mlx5: E-Switch, Remove redundant dev arg from mlx5_esw_vport_alloc()
Date:   Thu, 20 Apr 2023 18:38:48 -0700
Message-Id: <20230421013850.349646-14-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421013850.349646-1-saeed@kernel.org>
References: <20230421013850.349646-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

The passded esw->dev is redundant as esw being passed and esw->dev being
used inside.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 8d63f5df7646..3f25fa2893fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1506,7 +1506,7 @@ int mlx5_esw_sf_max_hpf_functions(struct mlx5_core_dev *dev, u16 *max_sfs, u16 *
 	return err;
 }
 
-static int mlx5_esw_vport_alloc(struct mlx5_eswitch *esw, struct mlx5_core_dev *dev,
+static int mlx5_esw_vport_alloc(struct mlx5_eswitch *esw,
 				int index, u16 vport_num)
 {
 	struct mlx5_vport *vport;
@@ -1560,7 +1560,7 @@ static int mlx5_esw_vports_init(struct mlx5_eswitch *esw)
 
 	xa_init(&esw->vports);
 
-	err = mlx5_esw_vport_alloc(esw, dev, idx, MLX5_VPORT_PF);
+	err = mlx5_esw_vport_alloc(esw, idx, MLX5_VPORT_PF);
 	if (err)
 		goto err;
 	if (esw->first_host_vport == MLX5_VPORT_PF)
@@ -1568,7 +1568,7 @@ static int mlx5_esw_vports_init(struct mlx5_eswitch *esw)
 	idx++;
 
 	for (i = 0; i < mlx5_core_max_vfs(dev); i++) {
-		err = mlx5_esw_vport_alloc(esw, dev, idx, idx);
+		err = mlx5_esw_vport_alloc(esw, idx, idx);
 		if (err)
 			goto err;
 		xa_set_mark(&esw->vports, idx, MLX5_ESW_VPT_VF);
@@ -1577,7 +1577,7 @@ static int mlx5_esw_vports_init(struct mlx5_eswitch *esw)
 	}
 	base_sf_num = mlx5_sf_start_function_id(dev);
 	for (i = 0; i < mlx5_sf_max_functions(dev); i++) {
-		err = mlx5_esw_vport_alloc(esw, dev, idx, base_sf_num + i);
+		err = mlx5_esw_vport_alloc(esw, idx, base_sf_num + i);
 		if (err)
 			goto err;
 		xa_set_mark(&esw->vports, base_sf_num + i, MLX5_ESW_VPT_SF);
@@ -1588,7 +1588,7 @@ static int mlx5_esw_vports_init(struct mlx5_eswitch *esw)
 	if (err)
 		goto err;
 	for (i = 0; i < max_host_pf_sfs; i++) {
-		err = mlx5_esw_vport_alloc(esw, dev, idx, base_sf_num + i);
+		err = mlx5_esw_vport_alloc(esw, idx, base_sf_num + i);
 		if (err)
 			goto err;
 		xa_set_mark(&esw->vports, base_sf_num + i, MLX5_ESW_VPT_SF);
@@ -1596,12 +1596,12 @@ static int mlx5_esw_vports_init(struct mlx5_eswitch *esw)
 	}
 
 	if (mlx5_ecpf_vport_exists(dev)) {
-		err = mlx5_esw_vport_alloc(esw, dev, idx, MLX5_VPORT_ECPF);
+		err = mlx5_esw_vport_alloc(esw, idx, MLX5_VPORT_ECPF);
 		if (err)
 			goto err;
 		idx++;
 	}
-	err = mlx5_esw_vport_alloc(esw, dev, idx, MLX5_VPORT_UPLINK);
+	err = mlx5_esw_vport_alloc(esw, idx, MLX5_VPORT_UPLINK);
 	if (err)
 		goto err;
 	return 0;
-- 
2.39.2

