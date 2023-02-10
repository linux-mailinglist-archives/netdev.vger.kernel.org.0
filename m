Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5009A6929FD
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 23:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbjBJWTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 17:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233851AbjBJWS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 17:18:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2B37F830
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 14:18:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BDC2B82601
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 22:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015A6C4339E;
        Fri, 10 Feb 2023 22:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676067516;
        bh=6bJKvFvr3Qq0tPvu98Yp2L9XKmAesI2rpOttjS3XrsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YU70B/nVk53ew+e8rOj9sAmDOzfiNdfzmLE9edS85d+QRfx7q/3Q85BHlUOMB/NzG
         fD99+ENO92cnFO+KH+l7I3D+PTL8bzSMLTtYJwRPIhSrIryUT56JiblRIClCexE3aX
         FK/qNq6zfEwHBDYLfr+a7J8ibNO5ftWCzL1UkIbt2F+r9HBjKuf9KZ74yUcvTFHUDk
         zUJepEDyLgMb/e6mrHbEwi2L5rCxsFIWEsdFBlbkbwiQyhOsq9OdDkr9ZGpcF539+3
         CyP5nZmEZBKOFSbX1GWRKEKdJdjOW70GbYu0YYw7se3wu/Gdv6DRC6FNMh91oE6uki
         I/pM8WgYkvzSw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [net-next 08/15] net/mlx5: Remove outdated comment
Date:   Fri, 10 Feb 2023 14:18:14 -0800
Message-Id: <20230210221821.271571-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210221821.271571-1-saeed@kernel.org>
References: <20230210221821.271571-1-saeed@kernel.org>
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

