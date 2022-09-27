Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793785ECEB7
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbiI0UhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233227AbiI0Ugo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:36:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0245FF40
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:36:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD89761BA0
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3038FC433D6;
        Tue, 27 Sep 2022 20:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664311002;
        bh=akGVSuYreNoIdKxE3nW/jdyScRqugFcegdYJXR1dekQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PduajGSfOawH2m9E+REspzFxbOEGMvMLp3WCAxmNklot5cHatNIZny9f9fy/f+J56
         QNjzLWeLrfMwQe7rhpqtBCANBQA+oechXShfyXUR7AFiIVU5VhgmJj/NjVegiks9Kt
         uf1jUz53H7M4FWd2tEN6fGByfV2IrO/k2u0GZ1LQntFE5HNXAImcl0furpV7t4hITb
         H86nND2CPoEeRodfcZFsf6/L6KVPe4GLKEU3EACL/Sxd6aKSxAHUIpMB4urotOgz3z
         7F/+6w6YgeY1U5UhEYJ7q8+Rf4hXlyLQhD5e7rIchNsMSKFKZPAMwWcsz5XiWhKMQV
         qDIMTolGz3G3g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 04/16] net/mlx5e: Make mlx5e_verify_rx_mpwqe_strides static
Date:   Tue, 27 Sep 2022 13:35:59 -0700
Message-Id: <20220927203611.244301-5-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220927203611.244301-1-saeed@kernel.org>
References: <20220927203611.244301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

mlx5e_verify_rx_mpwqe_strides is only used in en/params.c, so it can be
made static and removed from en/params.h.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/params.h | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index e025040350ba..8b54fec04fef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -90,8 +90,8 @@ bool mlx5e_rx_is_linear_skb(struct mlx5e_params *params,
 		linear_frag_sz <= PAGE_SIZE;
 }
 
-bool mlx5e_verify_rx_mpwqe_strides(struct mlx5_core_dev *mdev,
-				   u8 log_stride_sz, u8 log_num_strides)
+static bool mlx5e_verify_rx_mpwqe_strides(struct mlx5_core_dev *mdev,
+					  u8 log_stride_sz, u8 log_num_strides)
 {
 	if (log_stride_sz + log_num_strides != MLX5_MPWRQ_LOG_WQE_SZ)
 		return false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index f5c46e78eebc..3cc1c6b16444 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -97,8 +97,6 @@ void mlx5e_build_rq_params(struct mlx5_core_dev *mdev, struct mlx5e_params *para
 void mlx5e_set_rq_type(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
 void mlx5e_init_rq_type_params(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
 
-bool mlx5e_verify_rx_mpwqe_strides(struct mlx5_core_dev *mdev,
-				   u8 log_stride_sz, u8 log_num_strides);
 u16 mlx5e_get_linear_rq_headroom(struct mlx5e_params *params,
 				 struct mlx5e_xsk_param *xsk);
 u32 mlx5e_rx_get_min_frag_sz(struct mlx5e_params *params,
-- 
2.37.3

