Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B1C68E516
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjBHAiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjBHAil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:38:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847494109A
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:38:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C1EDB81B84
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC9AC433EF;
        Wed,  8 Feb 2023 00:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675816648;
        bh=Zbz/A5kHKHJqS2EkNP7ZxzlT1AgAZi4b0Sq94NlOHto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EegGAiSUhq2nBXp6fg5t+lvTV4Ri7WUSjLmuJSrqIGS7+35YVyq5k/Tz2XIQLnpop
         nnPHDVzkINUXUOsYgwxEEP5e8HYhxLwspfz5KTw93ZAsOJBnE1y5kbbydEFtGmThsh
         cA6JSvx/O8zOl8/xB99U5xNbS00+AxnUkqaqSd1SAgIZg4EVt7ILVjH8kQ+ELH0J5w
         2duILmKwuzZBerNxi0gYIXK/wYzrfE6i0oO/tWx3hLVVgPAO6O4OAHnOeorP7mOAPt
         A3EWTBLfePMM2VIWT+ffhfUdZ9xgR/IPAinxrwtaYREiyHW4bsFdqtpMINLyEdcx+8
         eYTwhy3CLXLig==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 11/15] net/mlx5: fs, Remove redundant assignment of size
Date:   Tue,  7 Feb 2023 16:37:08 -0800
Message-Id: <20230208003712.68386-12-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208003712.68386-1-saeed@kernel.org>
References: <20230208003712.68386-1-saeed@kernel.org>
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

From: Roi Dayan <roid@nvidia.com>

size is being reassigned in the line after.
remove the redundant assignment.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index e6874298ba92..374c17445e54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -272,8 +272,6 @@ static int mlx5_cmd_create_flow_table(struct mlx5_flow_root_namespace *ns,
 	unsigned int size;
 	int err;
 
-	if (ft_attr->max_fte != POOL_NEXT_SIZE)
-		size = roundup_pow_of_two(ft_attr->max_fte);
 	size = mlx5_ft_pool_get_avail_sz(dev, ft->type, ft_attr->max_fte);
 	if (!size)
 		return -ENOSPC;
-- 
2.39.1

