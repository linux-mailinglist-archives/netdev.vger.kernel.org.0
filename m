Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF515695AE
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbiGFXN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234249AbiGFXNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:13:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67898B01
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:13:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BDB8B81F3C
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B018DC341CA;
        Wed,  6 Jul 2022 23:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149200;
        bh=utakQ0p2sxDH1imXF23ge4ge9iTf23cAUxFprcxX7XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qgr7NamQFqAEc0+qGmH+n+dQEOC1Qlr3h8E+gbnYM2bTHtTdWjIkp6n5M+uiJE1Tq
         vAsjaEyKyUkHQ0ObOk2nfVB6BO8QRJED4VYXBGJKExVA90U87N7jnd1rIbZAPLSEoP
         XFzTN7fkcQfygHOs3t3OwKJgSRU3ORgHaAO9UQ4h3Su74chhox9hyH5iaTMrfgwLVe
         Kv1LpBKTF30AVlYJ9hr88y8OmvCGFyG0VvcIcccRbzugbzwOhWeGQBAooW9zehurev
         cj70yWBjtOf7RX1ptJ7I2YwTCymStunWgGNGuGzOPkDMqx5kR4oqXgCxFrPs38aV6Z
         gsXk8O7SHRDlQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net 3/9] net/mlx5e: kTLS, Fix build time constant test in TX
Date:   Wed,  6 Jul 2022 16:13:03 -0700
Message-Id: <20220706231309.38579-4-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706231309.38579-1-saeed@kernel.org>
References: <20220706231309.38579-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Use the correct constant (TLS_DRIVER_STATE_SIZE_TX) in the comparison
against the size of the private TX TLS driver context.

Fixes: df8d866770f9 ("net/mlx5e: kTLS, Use kernel API to extract private offload context")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 4b6f0d1ea59a..f239fb2e832f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -68,8 +68,7 @@ mlx5e_set_ktls_tx_priv_ctx(struct tls_context *tls_ctx,
 	struct mlx5e_ktls_offload_context_tx **ctx =
 		__tls_driver_ctx(tls_ctx, TLS_OFFLOAD_CTX_DIR_TX);
 
-	BUILD_BUG_ON(sizeof(struct mlx5e_ktls_offload_context_tx *) >
-		     TLS_OFFLOAD_CONTEXT_SIZE_TX);
+	BUILD_BUG_ON(sizeof(priv_tx) > TLS_DRIVER_STATE_SIZE_TX);
 
 	*ctx = priv_tx;
 }
-- 
2.36.1

