Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6A9681B23
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 21:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjA3UNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 15:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjA3UNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 15:13:46 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD1B34C27
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 12:13:45 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id ml19so11744657ejb.0
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 12:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VDvtBLAMLYFM9JI5LZF7w2Gj46DZ2vTo3Ifrp6sMWjE=;
        b=bXWqPUE94UkGeWW6EKWKeC9OACqqHO01O2UZdD7Y5RYS6YJlbzQ88eW+5Hm4G909iY
         YbU9eE6ymZhvAAK+jiOAWZLalsXBX+Ckn5+KCGF5l3GC8Ll05YF42D1oXN8g484a87hv
         lresGfLfPDrdipIHBH2Y9GFLMuaryCYCJ+sypFHo2V6R3JUwE8ZrG3zqYMh/+pV/K+vu
         L7LUpvacr5fEbSK79ruc4VoY1oXursu6S8fMizpPJ+SW3eGfq1gnApHjfWC+0rR6P10c
         BE657OKJTFf9VGEPfnywjqq1wuWecbFA6GhKYKGDqmNiBVFiBFWe0qd+waVk9tOrK5De
         jljg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VDvtBLAMLYFM9JI5LZF7w2Gj46DZ2vTo3Ifrp6sMWjE=;
        b=DZ5FoWIGzBOaSh0tvgkDm8eMtmE3ZGBK5LlVVWyda43ugW7dIZ836j+9zbVZfsng/N
         LvSrrMZZ57JBlRQoCLMObkvuG15cLvpXI05NwXD93Id2StfBkXj7r4r1CI/CJMxarsOq
         W65Nvc96UPCYT6hbY9Ped561qFzLgXfEEJRWceILTzaET+ibOJlhCotBU9EhMeSbLPU0
         oRI7qDXqtMtloS+7XxLfzdnLLro4GE2mi3n7KjT0OlK4MjLfEPjz7gimVehj7WaKxvJf
         GrCyLfPaYfFZh8OBivMSoy2iRQ7C1z5X+mccYR0TSDWL6qsUoiY58pdzMKmsym4ux+gk
         CJGg==
X-Gm-Message-State: AO0yUKWQsWQ8OxPYwaxY12ktogmTe+KdfkW2JBz9jLHXKshiGZe1wgwC
        0uUd7mCESMihMPMZj+BzinWEbPyWPlNbRSWcIvI=
X-Google-Smtp-Source: AK7set+CL3MurFsw7WQGOoFQYMLWhX7oRw6jap/fvivBDCe/3ipIZNkW+zH91EPX4fcjlM3kezpZiA==
X-Received: by 2002:a17:907:d085:b0:879:ec1a:4ac with SMTP id vc5-20020a170907d08500b00879ec1a04acmr14425408ejc.76.1675109623615;
        Mon, 30 Jan 2023 12:13:43 -0800 (PST)
Received: from localhost (onion.xor.sc. [185.56.83.83])
        by smtp.gmail.com with ESMTPSA id q5-20020a1709060f8500b00883ec4c63ddsm4052847ejj.146.2023.01.30.12.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 12:13:43 -0800 (PST)
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH net v2 1/2] net/mlx5e: XDP, Allow growing tail for XDP multi buffer
Date:   Mon, 30 Jan 2023 22:13:27 +0200
Message-Id: <20230130201328.132063-2-maxtram95@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130201328.132063-1-maxtram95@gmail.com>
References: <20230130201328.132063-1-maxtram95@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cited commits missed passing frag_size to __xdp_rxq_info_reg, which
is required by bpf_xdp_adjust_tail to support growing the tail pointer
in fragmented packets. Pass the missing parameter when the current RQ
mode allows XDP multi buffer.

Fixes: ea5d49bdae8b ("net/mlx5e: Add XDP multi buffer support to the non-linear legacy RQ")
Fixes: 9cb9482ef10e ("net/mlx5e: Use fragments of the same size in non-linear legacy RQ with XDP")
Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 9 +++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/params.h | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 7 ++++---
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 4ad19c981294..151585302cd1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -662,7 +662,8 @@ static int mlx5e_max_nonlinear_mtu(int first_frag_size, int frag_size, bool xdp)
 static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 				     struct mlx5e_params *params,
 				     struct mlx5e_xsk_param *xsk,
-				     struct mlx5e_rq_frags_info *info)
+				     struct mlx5e_rq_frags_info *info,
+				     u32 *xdp_frag_size)
 {
 	u32 byte_count = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	int frag_size_max = DEFAULT_FRAG_SIZE;
@@ -737,6 +738,9 @@ static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 	}
 	info->num_frags = i;
 
+	if (info->num_frags > 1 && params->xdp_prog)
+		*xdp_frag_size = PAGE_SIZE;
+
 	/* The last fragment of WQE with index 2*N may share the page with the
 	 * first fragment of WQE with index 2*N+1 in certain cases. If WQE 2*N+1
 	 * is not completed yet, WQE 2*N must not be allocated, as it's
@@ -917,7 +921,8 @@ int mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
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
index c9be6eb88012..e5930fe752e5 100644
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
index abcc614b6191..d02af93035b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -576,7 +576,7 @@ static void mlx5e_free_mpwqe_rq_drop_page(struct mlx5e_rq *rq)
 }
 
 static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
-			     struct mlx5e_rq *rq)
+			     u32 xdp_frag_size, struct mlx5e_rq *rq)
 {
 	struct mlx5_core_dev *mdev = c->mdev;
 	int err;
@@ -599,7 +599,8 @@ static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
 	if (err)
 		return err;
 
-	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id);
+	return __xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id,
+				  xdp_frag_size);
 }
 
 static int mlx5_rq_shampo_alloc(struct mlx5_core_dev *mdev,
@@ -2214,7 +2215,7 @@ static int mlx5e_open_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
 {
 	int err;
 
-	err = mlx5e_init_rxq_rq(c, params, &c->rq);
+	err = mlx5e_init_rxq_rq(c, params, rq_params->xdp_frag_size, &c->rq);
 	if (err)
 		return err;
 
-- 
2.39.1

