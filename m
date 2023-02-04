Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082F668AAD7
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 16:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbjBDPMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 10:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbjBDPMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 10:12:06 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCF334C04
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 07:12:05 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id e10-20020a17090a630a00b0022bedd66e6dso11419484pjj.1
        for <netdev@vger.kernel.org>; Sat, 04 Feb 2023 07:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gxsPT5eRKr12rPfAVAG1xFDQ/VYIU7NK8gPw8e56mo0=;
        b=HKZAwhjsD9DOsRDSSuB8p7un1mmIfFK/YnwEwdQTxyMPKsSEqpJeQEfIeGsyGqjvq/
         wIlynYNmk06gkGukkgcf7lZhVlbPkFGTXP+SZ+HkuPCeuiuig9Eeam4vjR4HJcu+VfU3
         ZN6gLE+KA+6s3ckfO3+yibAV/WlOi4BWaE+XmvgZNCpHcNolg5q/O0ULKhYPIpeuV9t5
         6siPB92/54JrVX/tzhTB+CGS8ZaQMWpwP3dSjl0eNHdbDgWvj0T378x4e1kJnq3xC3Sx
         g4bGrOlxx28/glFq8iOb9Yd6sXD7HWSafCrlXqFSRFD4+dQHD1z6h3kysMjS+pKnnL4U
         9Ffg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gxsPT5eRKr12rPfAVAG1xFDQ/VYIU7NK8gPw8e56mo0=;
        b=4kZpDwwWSivEtX5/gHRYzAdT41rvJzIh5zrBRGkzW3qNc0LNpZbxD1KCRuL7EzzvE2
         GO+mQblFeLblOgLnR5KnHWSYgf5ncqLm1hSEwwHSoIqOTegYZoSlu9kPox5uunUhuwTi
         exfi/dOmK0k3BOdByPkb6fpCGeFY32N7eB4mrKcDbpG1SE0L/JRrb4tZXFGv7cXAFSWi
         eK5z+9t6VX6X4Kdp8ustvBlUHXYNUj9cMhdahu5i8SYTb3fOqnqg6fx97ZkhUWNwGlO3
         TXTGOOamQDp0HMmE602lrbsbbwKI5rt7weyYE3BqAjrqxqVDuWkdgppd9DenpGm2zZ1Y
         Hm7A==
X-Gm-Message-State: AO0yUKUUJyuhojON4EZ3DA7LSsq6BWgQYFsYXJnrWuXLuw8l7YpWETv9
        r90kCetFMTG7YIXzv0s5VvzCphdM55y4BAp0
X-Google-Smtp-Source: AK7set9kSvGCpQgV78DJQYCU3ZTGEZXYG197HEsp03Oud8PDs/GTyOYjDwr//UDbIyVipYd02cQqVA==
X-Received: by 2002:a17:903:283:b0:196:d035:73bb with SMTP id j3-20020a170903028300b00196d03573bbmr16894386plr.66.1675523524552;
        Sat, 04 Feb 2023 07:12:04 -0800 (PST)
Received: from localhost ([23.129.64.145])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902ce1200b00196251ca124sm3556922plg.75.2023.02.04.07.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 07:12:04 -0800 (PST)
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH net v3 1/2] net/mlx5e: XDP, Allow growing tail for XDP multi buffer
Date:   Sat,  4 Feb 2023 17:11:38 +0200
Message-Id: <20230204151139.222900-2-maxtram95@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230204151139.222900-1-maxtram95@gmail.com>
References: <20230204151139.222900-1-maxtram95@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,
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
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 8 ++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/params.h | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 7 ++++---
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 4ad19c981294..857cb4e59050 100644
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
@@ -772,6 +773,8 @@ static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 
 	info->log_num_frags = order_base_2(info->num_frags);
 
+	*xdp_frag_size = info->num_frags > 1 && params->xdp_prog ? PAGE_SIZE : 0;
+
 	return 0;
 }
 
@@ -917,7 +920,8 @@ int mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
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

