Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B69672723
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjARSg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbjARSgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:36:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AF05AB77
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 10:36:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9B4F61944
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2580AC43398;
        Wed, 18 Jan 2023 18:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674066976;
        bh=MIgplyhi5304I6Yn0VGTh15eRsNFFU8iRTfxqOyqV2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PTyeATLE6wwdq8C0/1iXJqolNdAQAiHH4OtMxu9fMpoc3cohzTegJJ6MzPw7DkHfk
         38/nGQl1R/tSfR5+Vk3d2Cf75lJZvXFv2ujf25xrn2jYSkkAQyoyM1RETOCclp4ant
         BeQhgojOwJ5JWx7+E1NQhyzUg3qaxD03ZZnsH7/NLCoyXzwMJkUTp2j/ktrJq4ydU3
         J99VxoZO9FHtLYkPl2NzU0m6Ry2ZhdMiA8viTE29JZ6+Kr38EN/r6cqcnJ4P6yrIGB
         IRBYLX0B4FH8D88kY8G52zPfaJdlhu3JGJSH2RSw4sPtbXTX7MsU4N2FyAAKiA7BUN
         j3m0LeKV7Z0TA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: TC, Add tc prefix to attach/detach hdr functions
Date:   Wed, 18 Jan 2023 10:35:56 -0800
Message-Id: <20230118183602.124323-10-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118183602.124323-1-saeed@kernel.org>
References: <20230118183602.124323-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Currently there are confusing names for attach/detach functions.

mlx5e_attach_mod_hdr() vs mlx5e_mod_hdr_attach()
mlx5e_detach_mod_hdr() vs mlx5e_mod_hdr_detach()

Add tc prefix to the functions that are in en_tc.c to separate
from the functions in mod_hdr.c which has the mod_hdr prefix.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 455c178f4115..6a15d3e1741e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -646,9 +646,9 @@ get_mod_hdr_table(struct mlx5e_priv *priv, struct mlx5e_tc_flow *flow)
 		&tc->mod_hdr;
 }
 
-static int mlx5e_attach_mod_hdr(struct mlx5e_priv *priv,
-				struct mlx5e_tc_flow *flow,
-				struct mlx5_flow_attr *attr)
+static int mlx5e_tc_attach_mod_hdr(struct mlx5e_priv *priv,
+				   struct mlx5e_tc_flow *flow,
+				   struct mlx5_flow_attr *attr)
 {
 	struct mlx5e_mod_hdr_handle *mh;
 
@@ -665,9 +665,9 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *priv,
 	return 0;
 }
 
-static void mlx5e_detach_mod_hdr(struct mlx5e_priv *priv,
-				 struct mlx5e_tc_flow *flow,
-				 struct mlx5_flow_attr *attr)
+static void mlx5e_tc_detach_mod_hdr(struct mlx5e_priv *priv,
+				    struct mlx5e_tc_flow *flow,
+				    struct mlx5_flow_attr *attr)
 {
 	/* flow wasn't fully initialized */
 	if (!attr->mh)
@@ -1433,7 +1433,7 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
-		err = mlx5e_attach_mod_hdr(priv, flow, attr);
+		err = mlx5e_tc_attach_mod_hdr(priv, flow, attr);
 		if (err)
 			return err;
 	}
@@ -1493,7 +1493,7 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
 		mlx5e_mod_hdr_dealloc(&attr->parse_attr->mod_hdr_acts);
-		mlx5e_detach_mod_hdr(priv, flow, attr);
+		mlx5e_tc_detach_mod_hdr(priv, flow, attr);
 	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
@@ -1928,7 +1928,7 @@ post_process_attr(struct mlx5e_tc_flow *flow,
 			if (err)
 				goto err_out;
 		} else {
-			err = mlx5e_attach_mod_hdr(flow->priv, flow, attr);
+			err = mlx5e_tc_attach_mod_hdr(flow->priv, flow, attr);
 			if (err)
 				goto err_out;
 		}
@@ -2145,7 +2145,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 		if (vf_tun && attr->modify_hdr)
 			mlx5_modify_header_dealloc(priv->mdev, attr->modify_hdr);
 		else
-			mlx5e_detach_mod_hdr(priv, flow, attr);
+			mlx5e_tc_detach_mod_hdr(priv, flow, attr);
 	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
-- 
2.39.0

