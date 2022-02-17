Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916424B9A49
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236773AbiBQH4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:56:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236745AbiBQH4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:56:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF917654
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 23:56:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E5FD61B4A
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1D8C340F6;
        Thu, 17 Feb 2022 07:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645084596;
        bh=RcIIwCFZ1eAO0EgdzyQqdY9DnUeukkygmzNCS+2FuzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdZrnS8nmPZxnWQ6vM9n1h9PVC2PO+lPuDdkfLzVYLY3DjUk2ozsnKEv2oDbTOPn5
         /GfcooaDJLEkkvwj58Q1dajlXUI1hmQMmvwyK4sQ5THcoJZvwsdw+P7icsUKY+59YH
         c8TNKt43deUFE5mOjsGkC9nFpWh7QE8Php3wpREQELEr7YezxbBzBpapsEXyJic2Ce
         jEcpFJmA3EsJnlTGrnyB5FA9iZvD7oAzXQ3bFfBx7fIYDUJMGA3Rd4aMIX0paOIMtV
         J3K7u0eSQiyffmnMLVfmMihasZnGyXziyUMsG0Xw6sX8G5L4HXkw1TeUcrY/H/3OR+
         qFNtcQttGIHXg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Khalid Manaa <khalidm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/15] net/mlx5e: Generalize packet merge error message
Date:   Wed, 16 Feb 2022 23:56:20 -0800
Message-Id: <20220217075632.831542-4-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217075632.831542-1-saeed@kernel.org>
References: <20220217075632.831542-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Update the old error message for LRO state modify with the new
general name.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Khalid Manaa <khalidm@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rss.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rss.c
index c1cdd8c2e37a..7f93426b88b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rss.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rss.c
@@ -442,7 +442,7 @@ int mlx5e_rss_packet_merge_set_param(struct mlx5e_rss *rss,
 			goto inner_tir;
 		err = mlx5e_tir_modify(tir, builder);
 		if (err) {
-			mlx5e_rss_warn(rss->mdev, "Failed to update LRO state of indirect TIR %#x for traffic type %d: err = %d\n",
+			mlx5e_rss_warn(rss->mdev, "Failed to update packet merge state of indirect TIR %#x for traffic type %d: err = %d\n",
 				       mlx5e_tir_get_tirn(tir), tt, err);
 			if (!final_err)
 				final_err = err;
@@ -457,7 +457,7 @@ int mlx5e_rss_packet_merge_set_param(struct mlx5e_rss *rss,
 			continue;
 		err = mlx5e_tir_modify(tir, builder);
 		if (err) {
-			mlx5e_rss_warn(rss->mdev, "Failed to update LRO state of inner indirect TIR %#x for traffic type %d: err = %d\n",
+			mlx5e_rss_warn(rss->mdev, "Failed to update packet merge state of inner indirect TIR %#x for traffic type %d: err = %d\n",
 				       mlx5e_tir_get_tirn(tir), tt, err);
 			if (!final_err)
 				final_err = err;
-- 
2.34.1

