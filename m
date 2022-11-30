Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A298D63CE9C
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbiK3FNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233383AbiK3FMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:12:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB827615F
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:12:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7A55B81A37
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 05:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B606C433D6;
        Wed, 30 Nov 2022 05:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669785130;
        bh=ncNlw+O42Nf+UkNdsDRACsWyHfRIYRyVZRtEpnXk3Sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ceDQeq/tQOCTG7sE8yAF1b8MneK9rafpoO5ZlWjM9kx0fj35/k8u1Aa8VheRXZ4h1
         cmne4RrpejiHcTmf770utcC8bZ8zDgKWRwMqLrU7h2AamNIvWw1dc38nv17pDyEr+W
         Mb+UGprBrtFmCp2KHgLLuvLzP1ENY6nrBG3ruyLMI0Ywo8d17g68/jvhcAOW3nHxY7
         ayVEOYIoL07NOKHxKN2QkKGSNLeax6BVrvJX8VKhd6UVe4b5PdvyUBdDnT+CnDuV2O
         xaDPzXGX1takfYIC4/diS4rQ1lFKpV9cl1vzoNYeeiU7ZuEXIYGsyIddJJRY7kY8To
         wvgYnSMut0q3Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: Delete always true DMA check
Date:   Tue, 29 Nov 2022 21:11:48 -0800
Message-Id: <20221130051152.479480-12-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130051152.479480-1-saeed@kernel.org>
References: <20221130051152.479480-1-saeed@kernel.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

DMA address always exists for MACsec ASO object.

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec.c  | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 7d5a27f7423f..9369a580743e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -1299,12 +1299,12 @@ static void macsec_aso_build_wqe_ctrl_seg(struct mlx5e_macsec_aso *macsec_aso,
 					  struct mlx5_wqe_aso_ctrl_seg *aso_ctrl,
 					  struct mlx5_aso_ctrl_param *param)
 {
+	struct mlx5e_macsec_umr *umr = macsec_aso->umr;
+
 	memset(aso_ctrl, 0, sizeof(*aso_ctrl));
-	if (macsec_aso->umr->dma_addr) {
-		aso_ctrl->va_l  = cpu_to_be32(macsec_aso->umr->dma_addr | ASO_CTRL_READ_EN);
-		aso_ctrl->va_h  = cpu_to_be32((u64)macsec_aso->umr->dma_addr >> 32);
-		aso_ctrl->l_key = cpu_to_be32(macsec_aso->umr->mkey);
-	}
+	aso_ctrl->va_l = cpu_to_be32(umr->dma_addr | ASO_CTRL_READ_EN);
+	aso_ctrl->va_h = cpu_to_be32((u64)umr->dma_addr >> 32);
+	aso_ctrl->l_key = cpu_to_be32(umr->mkey);
 
 	if (!param)
 		return;
-- 
2.38.1

