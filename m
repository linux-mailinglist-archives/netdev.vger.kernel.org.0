Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970B92AA25E
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 04:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbgKGDyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 22:54:43 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:35928 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727298AbgKGDyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 22:54:43 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yanjunz@mellanox.com)
        with SMTP; 7 Nov 2020 05:54:40 +0200
Received: from bc-vnc02.mtbc.labs.mlnx (bc-vnc02.mtbc.labs.mlnx [10.75.68.111])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0A73seBn000983;
        Sat, 7 Nov 2020 05:54:40 +0200
Received: from bc-vnc02.mtbc.labs.mlnx (localhost [127.0.0.1])
        by bc-vnc02.mtbc.labs.mlnx (8.14.4/8.14.4) with ESMTP id 0A73sdRU023367;
        Sat, 7 Nov 2020 11:54:39 +0800
Received: (from yanjunz@localhost)
        by bc-vnc02.mtbc.labs.mlnx (8.14.4/8.14.4/Submit) id 0A73sdP9023347;
        Sat, 7 Nov 2020 11:54:39 +0800
From:   Zhu Yanjun <yanjunz@nvidia.com>
To:     saeedm@nvidia.com, leon@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     Zhu Yanjun <yanjunz@nvidia.com>
Subject: [PATCH 1/1] net/mlx5e: remove unnecessary memset
Date:   Sat,  7 Nov 2020 11:54:32 +0800
Message-Id: <1604721272-23314-1-git-send-email-yanjunz@nvidia.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since kvzalloc will initialize the allocated memory, it is not
necessary to initialize it once again.

Fixes: 11b717d61526 ("net/mlx5: E-Switch, Get reg_c0 value on CQE")
Signed-off-by: Zhu Yanjun <yanjunz@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 1bcf260..35c5629 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1528,7 +1528,6 @@ static int esw_create_restore_table(struct mlx5_eswitch *esw)
 		goto out_free;
 	}
 
-	memset(flow_group_in, 0, inlen);
 	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in,
 				      match_criteria);
 	misc = MLX5_ADDR_OF(fte_match_param, match_criteria,
-- 
1.7.1

