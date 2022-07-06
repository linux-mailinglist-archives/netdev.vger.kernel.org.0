Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFA35695AA
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbiGFXNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbiGFXN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:13:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDC0CD1
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:13:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D936B81F3E
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CA5C341C6;
        Wed,  6 Jul 2022 23:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149201;
        bh=jjmyfuakRJrOZoFXwQTjdKv7Ya7CGxx+fo3Ss4mUAZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FATYCpiT9qwa9p2ImZQVPksBbKc1F7/Fx6BX4cmzR90PwWmI11wup1hPKFDOdh+hu
         BV/AGIXtUw/IN92eMgT6fK7E0Yxxdmxu4QTtXG/slcOyVIV074R87a7p+hz44tlLXA
         Ulw/rkwV7DhRNBIOHVP0FnW9gRiP3YqZopOkVA4cupdfwC8zyQzp3BY6S7+c5/VLKg
         afdSA1G+wfIlPmLdv/6xICupn2liO4uQq0w+D/WW7zfNEddls+uU/p+riLdTF+msnl
         bDdgkovBG1u7r59MuhYVVrEyrZvx6oSrRBzj3DZFOjHT5k1Ug4jFn6vIg8ydMDQGzG
         lqOSg/EC1nZuQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net 4/9] net/mlx5e: kTLS, Fix build time constant test in RX
Date:   Wed,  6 Jul 2022 16:13:04 -0700
Message-Id: <20220706231309.38579-5-saeed@kernel.org>
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

Use the correct constant (TLS_DRIVER_STATE_SIZE_RX) in the comparison
against the size of the private RX TLS driver context.

Fixes: 1182f3659357 ("net/mlx5e: kTLS, Add kTLS RX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 0bb0633b7542..27483aa7be8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -231,8 +231,7 @@ mlx5e_set_ktls_rx_priv_ctx(struct tls_context *tls_ctx,
 	struct mlx5e_ktls_offload_context_rx **ctx =
 		__tls_driver_ctx(tls_ctx, TLS_OFFLOAD_CTX_DIR_RX);
 
-	BUILD_BUG_ON(sizeof(struct mlx5e_ktls_offload_context_rx *) >
-		     TLS_OFFLOAD_CONTEXT_SIZE_RX);
+	BUILD_BUG_ON(sizeof(priv_rx) > TLS_DRIVER_STATE_SIZE_RX);
 
 	*ctx = priv_rx;
 }
-- 
2.36.1

