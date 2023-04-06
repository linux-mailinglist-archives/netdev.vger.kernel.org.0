Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6698F6D8D36
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbjDFCDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbjDFCDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:03:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56E618E
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 19:02:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D34162CF0
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E137EC433D2;
        Thu,  6 Apr 2023 02:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680746577;
        bh=Mp4JWhUZ6F74lH15VPfH7WdDoKGkd0UFlnOOeL+PoXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6s19FQfqLXaC1LzVAe05VQ3uDesViy/Od9iPIZk/NndAdXADbFC0JZ2zjGGd9RTr
         JqVDuOALSLVhuP9UIbBkNFAvmYeqfDl36qxaoQP0NN8mcKxycQlWLrZfjDxYNcWnzk
         nzqt5PYt6nSbAKvVgEudTwFXTgXDQ+kOt3Or5DQgx4iTvyzNxG0SUxm8a3OL25j/k7
         YCHkQN4W/dVzBE2tvm/kppeBf6P5nE7gtJ/rstpB/nQl/Rsn3wVJMjuNM1pXI6NUW+
         HN45r5f8dI/0VrGd/r1qZk3CenSfoMmMkm12UZ0hCyAGd0QNnJ0wnTqj7aqDSqHtru
         2jiaSeZt+PJ1A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Adham Faris <afaris@nvidia.com>
Subject: [net-next 15/15] net/mlx5e: Fix SQ SW state layout in SQ devlink health diagnostics
Date:   Wed,  5 Apr 2023 19:02:32 -0700
Message-Id: <20230406020232.83844-16-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406020232.83844-1-saeed@kernel.org>
References: <20230406020232.83844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Adham Faris <afaris@nvidia.com>

Remove nesting level before SQ's SW state title and before SQ's SW
state capabilities line.

Preceding the SQ's SW state with a nameless nesting, wraps the inner SW
state map/dictionary with a nameless dictionary which is prohibited in
JSON file format.

Removing preceding SW state nest by removing function call
devlink_fmsg_obj_nest_start() and devlink_fmsg_obj_nest_end().

Signed-off-by: Adham Faris <afaris@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 44c1926843a1..b35ff289af49 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -57,10 +57,6 @@ static int mlx5e_health_sq_put_sw_state(struct devlink_fmsg *fmsg, struct mlx5e_
 
 	BUILD_BUG_ON_MSG(ARRAY_SIZE(sq_sw_state_type_name) != MLX5E_NUM_SQ_STATES,
 			 "sq_sw_state_type_name string array must be consistent with MLX5E_SQ_STATE_* enum in en.h");
-	err = devlink_fmsg_obj_nest_start(fmsg);
-	if (err)
-		return err;
-
 	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "SW State");
 	if (err)
 		return err;
@@ -72,11 +68,7 @@ static int mlx5e_health_sq_put_sw_state(struct devlink_fmsg *fmsg, struct mlx5e_
 			return err;
 	}
 
-	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
-	if (err)
-		return err;
-
-	return devlink_fmsg_obj_nest_end(fmsg);
+	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 }
 
 static int mlx5e_tx_reporter_err_cqe_recover(void *ctx)
-- 
2.39.2

