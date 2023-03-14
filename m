Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C2E6B8AB8
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjCNFnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbjCNFnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:43:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2792B81CFC
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:42:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB01FB81890
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0D2C433EF;
        Tue, 14 Mar 2023 05:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678772566;
        bh=vhgDuvNGifQ90JHyia6QTeoM3JYV5eLTvDWnUYbiVZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=avV5R2zVU3qnwpkkgwTYpyCjrNvO/LTyAXnJ6YkAtabAgMAJDxiUOGoMNCjya8a4b
         JAKxWDoCIKqOHKVuzlNLL03eXuf2OnjSg7WYmJ02H4CWqcqml1o4HogNglqoGulEVb
         f9gbpmzAiA9x61WCEO5lDnj+svqBfPWt4/nqkSv2TyOrt8XU0Et1HPe8uHHQA1j0sC
         koj6LuQl5za6mznr7Lt5dW31JRd1XRHrLOg3mXCS0uLYG6rI1sClgGvBTVv8xzxuVl
         aJveWFx89bdc3LchXjm4W4ODAk/fBIpHRVIx4Q2MbueIRxcr7Q8MU6O8nbTCLGCf1v
         tvucfXfdX8guw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [net-next 03/15] net/mlx5: Add comment to mlx5_devlink_params_register()
Date:   Mon, 13 Mar 2023 22:42:22 -0700
Message-Id: <20230314054234.267365-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314054234.267365-1-saeed@kernel.org>
References: <20230314054234.267365-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Add comment to mlx5_devlink_params_register() functions so it is clear
that only driver init params should be registered here.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index c5d2fdcabd56..b7784e02c2dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -805,6 +805,11 @@ int mlx5_devlink_params_register(struct devlink *devlink)
 {
 	int err;
 
+	/* Here only the driver init params should be registered.
+	 * Runtime params should be registered by the code which
+	 * behaviour they configure.
+	 */
+
 	err = devl_params_register(devlink, mlx5_devlink_params,
 				   ARRAY_SIZE(mlx5_devlink_params));
 	if (err)
-- 
2.39.2

