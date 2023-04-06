Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C646D8D32
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbjDFCDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234807AbjDFCDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:03:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBA58A79
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 19:02:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C337F62D38
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21267C433D2;
        Thu,  6 Apr 2023 02:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680746573;
        bh=+IH6p6vPg88vXL7iaPIgRrPsGsxsTHns+zN9dgfz2Xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IGy+Fy4crxlfknw41nug6IdhvFBbAEEQLvk2Xmm5XLtPRRSc6ZEcyEUdFvzWrDOsN
         FGNgISywRhOiTU0CmTNd6KJm+Lq9LDgOn5a+T7jFqitoPbCst5Cn2gN9Z/LKf+ITFH
         GECBOpX+oHSTz1CHRInPeOGvRtRmpr4X+P13xZVoPg6f5rp5WN95Nk9vyEDNDyOJjf
         WlftE0Wgo5tbjueN8jc6WIXzmPzQEhSgi2tnZWSQ8/bLvmMWMLZ6gKhmNirWwOvNDi
         E8EXyIlv9Y+I3r07ElehDdViODVCWRh6inNXOruJ39xTeYdzouUdGJrVVh1mxxyUjd
         qlz6ysxqHrEKw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: Remove redundant macsec code
Date:   Wed,  5 Apr 2023 19:02:28 -0700
Message-Id: <20230406020232.83844-12-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406020232.83844-1-saeed@kernel.org>
References: <20230406020232.83844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

Currently macsec_fs_tx_create uses memset to set
two parameters to zeros when they are already
initialized to zeros.

Don't pass macsec_ctx to mlx5e_macsec_fs_add_rule
since it's not used.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
index 5b658a5588c6..9173b67becef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
@@ -292,8 +292,6 @@ static int macsec_fs_tx_create(struct mlx5e_macsec_fs *macsec_fs)
 	}
 
 	/* Tx crypto table MKE rule - MKE packets shouldn't be offloaded */
-	memset(&flow_act, 0, sizeof(flow_act));
-	memset(spec, 0, sizeof(*spec));
 	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
 
 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ethertype);
@@ -1109,7 +1107,6 @@ static void macsec_fs_rx_setup_fte(struct mlx5_flow_spec *spec,
 
 static union mlx5e_macsec_rule *
 macsec_fs_rx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
-		      const struct macsec_context *macsec_ctx,
 		      struct mlx5_macsec_rule_attrs *attrs,
 		      u32 fs_id)
 {
@@ -1334,7 +1331,7 @@ mlx5e_macsec_fs_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 {
 	return (attrs->action == MLX5_ACCEL_MACSEC_ACTION_ENCRYPT) ?
 		macsec_fs_tx_add_rule(macsec_fs, macsec_ctx, attrs, sa_fs_id) :
-		macsec_fs_rx_add_rule(macsec_fs, macsec_ctx, attrs, *sa_fs_id);
+		macsec_fs_rx_add_rule(macsec_fs, attrs, *sa_fs_id);
 }
 
 void mlx5e_macsec_fs_del_rule(struct mlx5e_macsec_fs *macsec_fs,
-- 
2.39.2

