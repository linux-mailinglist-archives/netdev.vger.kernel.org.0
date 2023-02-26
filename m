Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A56C6A31C3
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 16:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbjBZPDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 10:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbjBZPDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 10:03:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9D39EC7;
        Sun, 26 Feb 2023 06:54:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 384DE60C41;
        Sun, 26 Feb 2023 14:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CD5C433D2;
        Sun, 26 Feb 2023 14:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677423172;
        bh=H5qQtPQraXVrRYOrS3GKBgnyOo2ecO5HI/VgcC2jAE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZP4GlTnsMZ6ggtOjcI49sIp0shCcSIvNW9xgSmJZS9i2PBjY8E/X6OlLFwghlnJn
         ictrR/Xy+lGKCMlbcPcelgPrcp5ij1dIYmwY8ZS+B9L/+cvFTJNd0tAaASl614r/IF
         sDSRHiXx7DV7aH8a+u5XhUHLFn3ZUI6cZ3IXJFDOlP4cIebsE8wuK3Q9bK/a4sV72k
         JGF9NZUy0lNWPxwU0MqpsiSa77B0xhdMu1kDaOZdXY94SNy+HIofo7Ham46B6RULv+
         FmZq58Iu7zZTTy0MOrNtVEqw1TRw7fb+qccbjpR1sMXU3EcuBZ7AuIKBbH0VkeepKc
         RHwewSQ/bOpGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ferasda@nvidia.com, royno@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/13] net/mlx5: fw_tracer: Fix debug print
Date:   Sun, 26 Feb 2023 09:52:15 -0500
Message-Id: <20230226145217.829485-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226145217.829485-1-sashal@kernel.org>
References: <20230226145217.829485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 988c2352273997a242f15c4fc3711773515006a2 ]

The debug message specify tdsn, but takes as an argument the
tmsn. The correct argument is tmsn, hence, fix the print.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index ef9f932f02263..5a2feadd80f08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -564,7 +564,7 @@ static int mlx5_tracer_handle_string_trace(struct mlx5_fw_tracer *tracer,
 	} else {
 		cur_string = mlx5_tracer_message_get(tracer, tracer_event);
 		if (!cur_string) {
-			pr_debug("%s Got string event for unknown string tdsm: %d\n",
+			pr_debug("%s Got string event for unknown string tmsn: %d\n",
 				 __func__, tracer_event->string_event.tmsn);
 			return -1;
 		}
-- 
2.39.0

