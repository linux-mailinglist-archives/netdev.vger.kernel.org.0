Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76FCF6EA124
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbjDUBkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbjDUBkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1BD6A71
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:40:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CA726440A
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F4CC433D2;
        Fri, 21 Apr 2023 01:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041202;
        bh=+o0D7mT4MzPZcWnXVQvbZJ5TpCjiQSJ0dWsUNu/ltP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWIkYISYOhNhEPMZ/MSyUJoVwEK1ED1ptJ+R8KzdLZEB+ZS079Lg3UYhcaXeuuc/6
         aNhDM+dUA0PWaoN8i7+DbDova+T/uRKooIAlPocXdsAIbwghXtZK8ShFFb3ogWsXu4
         aGm++Rvl3MfLJk00sGm2AObUSiwtvv15A4K66ADLiHpsqWefZK8hZoMsG+cuUtviSh
         7o82a60lgYq5IcpSz2DcLbla0go5O/8kW5G6EBYUKTNVagBnkaqK4ZATq4McFAQJoB
         VaOeavrQw2J8dARSM5b5JrXPVQxP8JuUjqtnCimBa5RPrKKNJ1zJdoReZHJDltlXf8
         IKuZn5iHypAuA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 15/15] net/mlx5: Update op_mode to op_mod for port selection
Date:   Thu, 20 Apr 2023 18:38:50 -0700
Message-Id: <20230421013850.349646-16-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421013850.349646-1-saeed@kernel.org>
References: <20230421013850.349646-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

To be consistent with the other enum keys use OP_MOD
instead of OP_MODE.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 +-
 include/linux/mlx5/mlx5_ifc.h                  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index a95d1218def9..89a65779494e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -717,7 +717,7 @@ static int handle_hca_cap_port_selection(struct mlx5_core_dev *dev,
 	       MLX5_ST_SZ_BYTES(port_selection_cap));
 	MLX5_SET(port_selection_cap, set_hca_cap, port_select_flow_table_bypass, 1);
 
-	err = set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MODE_PORT_SELECTION);
+	err = set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_PORT_SELECTION);
 
 	return err;
 }
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 20d00e09b168..b42696d74c9f 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -69,7 +69,7 @@ enum {
 	MLX5_SET_HCA_CAP_OP_MOD_ATOMIC                = 0x3,
 	MLX5_SET_HCA_CAP_OP_MOD_ROCE                  = 0x4,
 	MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE2       = 0x20,
-	MLX5_SET_HCA_CAP_OP_MODE_PORT_SELECTION       = 0x25,
+	MLX5_SET_HCA_CAP_OP_MOD_PORT_SELECTION        = 0x25,
 };
 
 enum {
-- 
2.39.2

