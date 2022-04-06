Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 875B94F5C44
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbiDFLiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiDFLgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:36:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E61455F37D;
        Wed,  6 Apr 2022 01:26:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4673CB81FEA;
        Wed,  6 Apr 2022 08:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9812BC385A1;
        Wed,  6 Apr 2022 08:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649233570;
        bh=pyc7EWF/jh+O9uVsRJZpJVTAYB1Lz3EXiMObbhSxT3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXZwAPKGu7PinCuJgw1aDuXT01In3mcMiS5iOtL4fwsyajQ7MLEyTSlltdhCJoEEX
         dU+577n1A0nC86DWwkZRBneLLXHAZLMW4e4R0QUMvNOuTwm3Z4I1CRkjAH4yx4DpkD
         wh4midoyg8zZkXvJeIyizWM8NxC1c403LNPdxFMMx8TNw6xxSHokbjZyMbb3g3cm3r
         VfIANR/L17Knw95XGQL41vsnrga0Vnht2wFLXin8jKUmvO8Tz75k46Mk5J5d0+yxxG
         ATcAnknsqqY6wFqUmHaeL+bc3LlBWUY/2LCYTSyqK1zDTc/1Vxnw3V9QIE3J2TsY8p
         fHQRrte+lsj1w==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 03/17] net/mlx5: Remove not-used IDA field from IPsec struct
Date:   Wed,  6 Apr 2022 11:25:38 +0300
Message-Id: <cbecfbe01621e1b8bde746aa7f6c08497e656a25.1649232994.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649232994.git.leonro@nvidia.com>
References: <cover.1649232994.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The IDA halloc variable is not needed and can be removed.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h | 3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 299e3f0fcb5c..213fbf63dde9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -425,7 +425,6 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 
 	hash_init(ipsec->sadb_rx);
 	spin_lock_init(&ipsec->sadb_rx_lock);
-	ida_init(&ipsec->halloc);
 	ipsec->en_priv = priv;
 	ipsec->no_trailer = !!(mlx5_accel_ipsec_device_caps(priv->mdev) &
 			       MLX5_ACCEL_IPSEC_CAP_RX_NO_TRAILER);
@@ -452,7 +451,6 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
 	mlx5e_accel_ipsec_fs_cleanup(priv);
 	destroy_workqueue(ipsec->wq);
 
-	ida_destroy(&ipsec->halloc);
 	kfree(ipsec);
 	priv->ipsec = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 282d3abab8c5..51ae6145b6fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -82,8 +82,7 @@ struct mlx5e_ipsec {
 	struct mlx5e_priv *en_priv;
 	DECLARE_HASHTABLE(sadb_rx, MLX5E_IPSEC_SADB_RX_BITS);
 	bool no_trailer;
-	spinlock_t sadb_rx_lock; /* Protects sadb_rx and halloc */
-	struct ida halloc;
+	spinlock_t sadb_rx_lock; /* Protects sadb_rx */
 	struct mlx5e_ipsec_sw_stats sw_stats;
 	struct mlx5e_ipsec_stats stats;
 	struct workqueue_struct *wq;
-- 
2.35.1

