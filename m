Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E112A4F5C2E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiDFLlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbiDFLjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:39:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5161C578E8A;
        Wed,  6 Apr 2022 01:27:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E128460B5C;
        Wed,  6 Apr 2022 08:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F05C385A3;
        Wed,  6 Apr 2022 08:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649233623;
        bh=Ae3dks8iD/kIl3ERAKIdLoK88RU26+MC3X73BL0O6cU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mb3gs6uNGRaSV7tb6SnwKS7kBbpKzRtKqJOUxTykGyH6SGoiEiKfNcwN6JZLh2c35
         SK66nkpV3ogntuSFPovP4QUV+b5QVzBqTgA7wfaRW2Nx3mbCQ8rW4pQwphUNf9tfuY
         pEeBXtrgIuzhschSVCFmJYlUzQrUv/HAB/MozndYN7tlTplgaY5r+kbtUFZmG5Z3Ud
         c/IMeAF4Yi4mN1nbZ0eCXZaYz/uXReTpFjN9/zj5Ae0cnENVwwGjoIfEXn7EN2ShcZ
         3FvCqVL0zuqlU02QlJppmSavWowhuF1VN9UNhetOu4T1gV/3489k/Thiu8JILffg/q
         6bVY0hjYCb+LQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 17/17] net/mlx5: Remove not-implemented IPsec capabilities
Date:   Wed,  6 Apr 2022 11:25:52 +0300
Message-Id: <1044bb7b779107ff38e48e3f6553421104f3f819.1649232994.git.leonro@nvidia.com>
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

Clean a capabilities enum to remove not-implemented bits.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c       |  4 +---
 include/linux/mlx5/accel.h                            | 11 ++++-------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index f0f44bd95cc9..37c9880719cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -51,10 +51,8 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 	    MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_decrypt))
 		caps |= MLX5_ACCEL_IPSEC_CAP_ESP;
 
-	if (MLX5_CAP_IPSEC(mdev, ipsec_esn)) {
+	if (MLX5_CAP_IPSEC(mdev, ipsec_esn))
 		caps |= MLX5_ACCEL_IPSEC_CAP_ESN;
-		caps |= MLX5_ACCEL_IPSEC_CAP_TX_IV_IS_ESN;
-	}
 
 	/* We can accommodate up to 2^24 different IPsec objects
 	 * because we use up to 24 bit in flow table metadata
diff --git a/include/linux/mlx5/accel.h b/include/linux/mlx5/accel.h
index 73e4d50a9f02..0f2596297f6a 100644
--- a/include/linux/mlx5/accel.h
+++ b/include/linux/mlx5/accel.h
@@ -113,13 +113,10 @@ struct mlx5_accel_esp_xfrm {
 
 enum mlx5_accel_ipsec_cap {
 	MLX5_ACCEL_IPSEC_CAP_DEVICE		= 1 << 0,
-	MLX5_ACCEL_IPSEC_CAP_REQUIRED_METADATA	= 1 << 1,
-	MLX5_ACCEL_IPSEC_CAP_ESP		= 1 << 2,
-	MLX5_ACCEL_IPSEC_CAP_IPV6		= 1 << 3,
-	MLX5_ACCEL_IPSEC_CAP_LSO		= 1 << 4,
-	MLX5_ACCEL_IPSEC_CAP_RX_NO_TRAILER	= 1 << 5,
-	MLX5_ACCEL_IPSEC_CAP_ESN		= 1 << 6,
-	MLX5_ACCEL_IPSEC_CAP_TX_IV_IS_ESN	= 1 << 7,
+	MLX5_ACCEL_IPSEC_CAP_ESP		= 1 << 1,
+	MLX5_ACCEL_IPSEC_CAP_IPV6		= 1 << 2,
+	MLX5_ACCEL_IPSEC_CAP_LSO		= 1 << 3,
+	MLX5_ACCEL_IPSEC_CAP_ESN		= 1 << 4,
 };
 
 #ifdef CONFIG_MLX5_EN_IPSEC
-- 
2.35.1

