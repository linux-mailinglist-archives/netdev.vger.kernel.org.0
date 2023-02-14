Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D49B69707D
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 23:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbjBNWO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 17:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233409AbjBNWOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 17:14:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3862ED77
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 14:14:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35528B81F5F
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 22:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36A5C433EF;
        Tue, 14 Feb 2023 22:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676412853;
        bh=t0vlKMUsUEcYnMO8POCrxw+Tw4YjI+5qpNVwiavMMIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTAB3DcsOrl1+SlVwdn/LDluexIMDLyPVpI91zBmJgWk1WeGpj3Pjrg3bQ0XMm/id
         mhVFFE1TdRB45J14/a50QhHBacZCTMXh6vznRsh/lekSGMNLlBRzA/upUvzM8mY6S+
         r6naDRzJ7rM81+rVBSJwZoiDLWeMjVTAeLTAcPsID0EolA8H9GL0aWHvcp6fgEFY1U
         XE+sCUoqxb8hxsdiSFWgEx1fUgx2+Xca9QfI2CUa+/enTFrwzEKl8TacawfATw2pLS
         r1Hy5iGrSNXGKgcQPacxZt5cZJcPOUHnE+IYe9nL5PnFx9yYdUsEeh6JsRWGWAwTOh
         1W9WD9zDX0oxw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: [net-next V2 07/15] net/mlx5e: TC, Remove redundant parse_attr argument
Date:   Tue, 14 Feb 2023 14:12:31 -0800
Message-Id: <20230214221239.159033-8-saeed@kernel.org>
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

From: Roi Dayan <roid@nvidia.com>

The parse_attr argument is not being used in
actions_match_supported_fdb(). remove it.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index fd2a0b431f3d..9bbd31e304be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3678,7 +3678,6 @@ static bool modify_header_match_supported(struct mlx5e_priv *priv,
 
 static bool
 actions_match_supported_fdb(struct mlx5e_priv *priv,
-			    struct mlx5e_tc_flow_parse_attr *parse_attr,
 			    struct mlx5e_tc_flow *flow,
 			    struct netlink_ext_ack *extack)
 {
@@ -3727,7 +3726,7 @@ actions_match_supported(struct mlx5e_priv *priv,
 		return false;
 
 	if (mlx5e_is_eswitch_flow(flow) &&
-	    !actions_match_supported_fdb(priv, parse_attr, flow, extack))
+	    !actions_match_supported_fdb(priv, flow, extack))
 		return false;
 
 	return true;
-- 
2.39.1

