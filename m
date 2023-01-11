Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F91F6653D7
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 06:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbjAKFj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 00:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234505AbjAKFiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 00:38:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA47102E
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 21:31:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCF4A61A4F
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E44C433EF;
        Wed, 11 Jan 2023 05:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673415063;
        bh=FcJEgbWNRrrx6dCKtq3/3Twx4G8KtoejLubNthUBEG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrJNakEU86MDzbtCkJ9sUBVhgAyfaLag3JO8Fs+XZ9PcVQ24N8bPcd+Wz9lP5RvLT
         p8npKAy1hCpxuSDy7DEgH7fvyWWghhgvYMl+k/k3GraVtMqwMeScDatrjW4jnn9XvL
         DqnonqxbBkd4hK7KKgHpgkwHNMbi0kE1GGXjeHyBN5X935c42dMHBL+tnLSVfS02yo
         dlmwmmIPpDBnubyMxUOt3MlZ8U7e6Oj+DSO6TzX9/tByn98j6v9R6KtWBb3HJQNztD
         k6jrwRimUS85advA3wZT+vSs95iM3Lv/+1xn2KZr4jIyeusHFgMAQqx963mlK+08mf
         427MW1pXWiAVA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        zhang songyi <zhang.songyi@zte.com.cn>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [net-next 14/15] net/mlx5: remove redundant ret variable
Date:   Tue, 10 Jan 2023 21:30:44 -0800
Message-Id: <20230111053045.413133-15-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111053045.413133-1-saeed@kernel.org>
References: <20230111053045.413133-1-saeed@kernel.org>
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

From: zhang songyi <zhang.songyi@zte.com.cn>

Return value from mlx5dr_send_postsend_action() directly instead of taking
this in another redundant variable.

Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index a4476cb4c3b3..fd2d31cdbcf9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -724,7 +724,6 @@ int mlx5dr_send_postsend_action(struct mlx5dr_domain *dmn,
 				struct mlx5dr_action *action)
 {
 	struct postsend_info send_info = {};
-	int ret;
 
 	send_info.write.addr = (uintptr_t)action->rewrite->data;
 	send_info.write.length = action->rewrite->num_of_actions *
@@ -734,9 +733,7 @@ int mlx5dr_send_postsend_action(struct mlx5dr_domain *dmn,
 		mlx5dr_icm_pool_get_chunk_mr_addr(action->rewrite->chunk);
 	send_info.rkey = mlx5dr_icm_pool_get_chunk_rkey(action->rewrite->chunk);
 
-	ret = dr_postsend_icm_data(dmn, &send_info);
-
-	return ret;
+	return dr_postsend_icm_data(dmn, &send_info);
 }
 
 static int dr_modify_qp_rst2init(struct mlx5_core_dev *mdev,
-- 
2.39.0

