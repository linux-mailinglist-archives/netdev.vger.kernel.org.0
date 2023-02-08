Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A743568E50A
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjBHAh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjBHAhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:37:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811239762
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:37:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E4E96145B
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB549C4339C;
        Wed,  8 Feb 2023 00:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675816643;
        bh=FZOvYWyZNhaY/bh03uxex8MdtpcWA1M/4LumRiR+/cU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YuTmmn/XJwaUhhL1s2wzXbQxUbFg5EWaju7XqWLgJMNC/5NTUroaOkh8+8BfPZBoW
         t19Psgi4dYEhDgdNWRitnBQ4gNxvcLxa7YrAiDGoIhCn66iNDZUbfcxmsO4uBpp//U
         4VjShlJrcCzp0ESPHHNnetXoc5g8QFH8PlMO4+QdZpkqXs8b6bHa2jERVPfM+08QoY
         2UP5COSXwk1mMOdRxNeYpngE80gqWPSgIIeA6VqtqOzdl3L/7PVIoxSzIwD95dHxuj
         vC6otmNl4bfZXo7gFCQwKmUBM6+ODSbku8rcwMLaFHRKbLvNzarajLVzi0QzSq/fHy
         nGTkxHTwH0BVg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 06/15] net/mlx5: fs, Remove redundant vport_number assignment
Date:   Tue,  7 Feb 2023 16:37:03 -0800
Message-Id: <20230208003712.68386-7-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208003712.68386-1-saeed@kernel.org>
References: <20230208003712.68386-1-saeed@kernel.org>
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

From: Roi Dayan <roid@nvidia.com>

vport_number and other_vport being reassigned outside the if clause anyway.
remove the redundant assignment.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 32d4c967469c..e6874298ba92 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -412,11 +412,6 @@ static int mlx5_cmd_create_flow_group(struct mlx5_flow_root_namespace *ns,
 		 MLX5_CMD_OP_CREATE_FLOW_GROUP);
 	MLX5_SET(create_flow_group_in, in, table_type, ft->type);
 	MLX5_SET(create_flow_group_in, in, table_id, ft->id);
-	if (ft->vport) {
-		MLX5_SET(create_flow_group_in, in, vport_number, ft->vport);
-		MLX5_SET(create_flow_group_in, in, other_vport, 1);
-	}
-
 	MLX5_SET(create_flow_group_in, in, vport_number, ft->vport);
 	MLX5_SET(create_flow_group_in, in, other_vport,
 		 !!(ft->flags & MLX5_FLOW_TABLE_OTHER_VPORT));
-- 
2.39.1

