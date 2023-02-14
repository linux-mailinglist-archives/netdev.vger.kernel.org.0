Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2565C69707C
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 23:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbjBNWOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 17:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbjBNWOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 17:14:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94D930E81
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 14:14:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6724C61946
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 22:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80A6C433D2;
        Tue, 14 Feb 2023 22:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676412854;
        bh=6bJKvFvr3Qq0tPvu98Yp2L9XKmAesI2rpOttjS3XrsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBbhCP0TiEfeAX4NX1lqbCg/nNoWdk5L6UnPm5SmhzRzQK5cEuCC376PAdxpBw9uV
         BmfODDfS2tQXsvc7mFvvVEpLlGi3qz2UixPdVX+QCPPYnYKuaFh56HpKt8F3poxTLA
         w9fbmEMikNwqnOwyZDmY6QqiqSbzkPflmcl0OJLnnZlj9ArWI/nqJXj3K7GSbHoduG
         467NZ21We6feg8Z+EQOpBzpd864NN4tF78NcRvaQuFg5V7Eq4gKwMiUKMoLVJoDcaq
         xRxfZ5UZNRPzzY5ILDC0F7cuYwpmQwtp/mPj4tAUXi6hIAezL8Vxg54wDu6wQZh7al
         B80NGbpqEONCg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [net-next V2 08/15] net/mlx5: Remove outdated comment
Date:   Tue, 14 Feb 2023 14:12:32 -0800
Message-Id: <20230214221239.159033-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214221239.159033-1-saeed@kernel.org>
References: <20230214221239.159033-1-saeed@kernel.org>
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

From: Jiri Pirko <jiri@nvidia.com>

The comment is no longer applicable, as the devlink reload and instance
cleanup are both protected with devlink instance lock, therefore no race
can happen.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 17ae9b4ec794..49bbfadc8c64 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -377,10 +377,6 @@ int mlx5_attach_device(struct mlx5_core_dev *dev)
 
 			/* Pay attention that this is not PCI driver that
 			 * mlx5_core_dev is connected, but auxiliary driver.
-			 *
-			 * Here we can race of module unload with devlink
-			 * reload, but we don't need to take extra lock because
-			 * we are holding global mlx5_intf_mutex.
 			 */
 			if (!adev->dev.driver)
 				continue;
-- 
2.39.1

