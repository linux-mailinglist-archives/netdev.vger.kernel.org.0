Return-Path: <netdev+bounces-10646-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6761972F88F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:01:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 951241C20C2C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FABC5258;
	Wed, 14 Jun 2023 09:01:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B455681;
	Wed, 14 Jun 2023 09:01:14 +0000 (UTC)
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F5410E9;
	Wed, 14 Jun 2023 02:01:12 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-4f649db9b25so8077789e87.0;
        Wed, 14 Jun 2023 02:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686733270; x=1689325270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=16nsX0+9N3hRh738OBEyt4yBOSc7ZXuiX6hwR3DgKkk=;
        b=beD1yzLP/Zxi0B+E4FAM41gdyriLUS8Ue+MbUfsxbGewuiu2TeeZ2jG5ynRPdZjlqM
         BJ3uFI/tilPioj5m953DDJ5BWLToL/GRB4FCc8H1tZaiec5hDap+gqm1+kzGUcmgEkT2
         HPncxRxBWHim+aIkPiq4++v8JarRsgTnbGMA+xyq4RPVkE8UOYTiEOJhrGcUgq8kuhN7
         XgHper3O89ck8mIG47vKIL3Mgl4kvMeqXTH7o8PBX/Kh0R2wN9xbDLhVIlJ8fy6MdZ8l
         RmwimY/wetE8d63f2W2SEMRnMwCfxDCutC4wr4dZFcglucz01Uxj4CIVr25N6CGwQChG
         U3ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686733270; x=1689325270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=16nsX0+9N3hRh738OBEyt4yBOSc7ZXuiX6hwR3DgKkk=;
        b=mIGCIxz+OFdyh5O6hugilV5/78MfzTtAsZaOk4mWZkJK8/4QK3BPjlRW41SRArN2MI
         /N11ehN7lG3+/AbJr3ZrKAEeBumrnS2VNjt5c5TXQ3aStjxlvpvCRJMKaeVFKN+4d6LD
         xFVeJHUZqPeBV4+Bso/+dHYLFis4b1MxkD7ysfQHyjQc6sKfem2aHeZBn6yEAr8MXQ6j
         jmHm8m6uFPvkCGGgIswNHtlcRhdcSU6OTUdPZrLkHtV5EAtrIeVhyT4ETPMk8m1YogKu
         1PHXxssFQ9rvqVfvd3oSSCL2nQ/9TArRlbPrFUspDCKVYC0NeCvMQBYFMtD/mLg+5oKO
         VRAg==
X-Gm-Message-State: AC+VfDzjXZzXX39NKleqwZ9Cz/yMWTaSY6EM0vn/xLTy7h5uV06cR8Tz
	pgRz5Ev5kfqm870yuOvhFS2//IzsnEg56QcF
X-Google-Smtp-Source: ACHHUZ5xdQKq8pO+87nB+XkUsNYT5BVWdaf8OGpbPq/ce+CHTDp8Xcp5UVou/kk8qKZsTYb9TY9BVw==
X-Received: by 2002:a19:7101:0:b0:4f3:b61a:a94b with SMTP id m1-20020a197101000000b004f3b61aa94bmr6943226lfc.53.1686733270436;
        Wed, 14 Jun 2023 02:01:10 -0700 (PDT)
Received: from localhost (tor-project-exit5.dotsrc.org. [185.129.61.5])
        by smtp.gmail.com with ESMTPSA id u7-20020ac243c7000000b004f42718cbb1sm2036467lfl.292.2023.06.14.02.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 02:01:10 -0700 (PDT)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	bpf@vger.kernel.org,
	Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH net-next v4 1/2] net/mlx5e: XDP, Allow growing tail for XDP multi buffer
Date: Wed, 14 Jun 2023 12:00:05 +0300
Message-ID: <20230614090006.594909-2-maxtram95@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230614090006.594909-1-maxtram95@gmail.com>
References: <20230614090006.594909-1-maxtram95@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The cited commits missed passing frag_size to __xdp_rxq_info_reg, which
is required by bpf_xdp_adjust_tail to support growing the tail pointer
in fragmented packets. Pass the missing parameter when the current RQ
mode allows XDP multi buffer.

Fixes: ea5d49bdae8b ("net/mlx5e: Add XDP multi buffer support to the non-linear legacy RQ")
Fixes: 9cb9482ef10e ("net/mlx5e: Use fragments of the same size in non-linear legacy RQ with XDP")
Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 8 ++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/params.h | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 7 ++++---
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 9c94807097cb..5ce28ff7685f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -732,7 +732,8 @@ static void mlx5e_rx_compute_wqe_bulk_params(struct mlx5e_params *params,
 static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 				     struct mlx5e_params *params,
 				     struct mlx5e_xsk_param *xsk,
-				     struct mlx5e_rq_frags_info *info)
+				     struct mlx5e_rq_frags_info *info,
+				     u32 *xdp_frag_size)
 {
 	u32 byte_count = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	int frag_size_max = DEFAULT_FRAG_SIZE;
@@ -845,6 +846,8 @@ static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 
 	info->log_num_frags = order_base_2(info->num_frags);
 
+	*xdp_frag_size = info->num_frags > 1 && params->xdp_prog ? PAGE_SIZE : 0;
+
 	return 0;
 }
 
@@ -989,7 +992,8 @@ int mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
 	}
 	default: /* MLX5_WQ_TYPE_CYCLIC */
 		MLX5_SET(wq, wq, log_wq_sz, params->log_rq_mtu_frames);
-		err = mlx5e_build_rq_frags_info(mdev, params, xsk, &param->frags_info);
+		err = mlx5e_build_rq_frags_info(mdev, params, xsk, &param->frags_info,
+						&param->xdp_frag_size);
 		if (err)
 			return err;
 		ndsegs = param->frags_info.num_frags;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index a5d20f6d6d9c..6800949dafbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -24,6 +24,7 @@ struct mlx5e_rq_param {
 	u32                        rqc[MLX5_ST_SZ_DW(rqc)];
 	struct mlx5_wq_param       wq;
 	struct mlx5e_rq_frags_info frags_info;
+	u32                        xdp_frag_size;
 };
 
 struct mlx5e_sq_param {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a7c526ee5024..a5bdf78955d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -641,7 +641,7 @@ static void mlx5e_free_mpwqe_rq_drop_page(struct mlx5e_rq *rq)
 }
 
 static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
-			     struct mlx5e_rq *rq)
+			     u32 xdp_frag_size, struct mlx5e_rq *rq)
 {
 	struct mlx5_core_dev *mdev = c->mdev;
 	int err;
@@ -665,7 +665,8 @@ static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
 	if (err)
 		return err;
 
-	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id);
+	return __xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id,
+				  xdp_frag_size);
 }
 
 static int mlx5_rq_shampo_alloc(struct mlx5_core_dev *mdev,
@@ -2240,7 +2241,7 @@ static int mlx5e_open_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
 {
 	int err;
 
-	err = mlx5e_init_rxq_rq(c, params, &c->rq);
+	err = mlx5e_init_rxq_rq(c, params, rq_params->xdp_frag_size, &c->rq);
 	if (err)
 		return err;
 
-- 
2.41.0


