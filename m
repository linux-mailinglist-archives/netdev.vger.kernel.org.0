Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F87917784D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 15:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbgCCOIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 09:08:50 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41229 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729466AbgCCOIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 09:08:50 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 3 Mar 2020 16:08:46 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 023E8fBj019613;
        Tue, 3 Mar 2020 16:08:44 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     parav@mellanox.com, jiri@mellanox.com, moshe@mellanox.com,
        vladyslavt@mellanox.com, saeedm@mellanox.com, leon@kernel.org
Subject: [PATCH] IB/mlx5: Fix missing debugfs entries
Date:   Tue,  3 Mar 2020 08:08:31 -0600
Message-Id: <20200303140834.7501-2-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200303140834.7501-1-parav@mellanox.com>
References: <20200303140834.7501-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cited commit missed to include congestion control related debugfs
stage initialization.
This resulted in missing debugfs entries for cc_params.

Add them back.

issue: 2084629
Fixes: b5ca15ad7e61 ("IB/mlx5: Add proper representors support")
Change-Id: I435f03f117d44107f032800442b0dc9e5a15fe06
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e4bcfa81b70a..e54661d3b37c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -7077,6 +7077,9 @@ const struct mlx5_ib_profile raw_eth_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_COUNTERS,
 		     mlx5_ib_stage_counters_init,
 		     mlx5_ib_stage_counters_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_CONG_DEBUGFS,
+		     mlx5_ib_stage_cong_debugfs_init,
+		     mlx5_ib_stage_cong_debugfs_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_UAR,
 		     mlx5_ib_stage_uar_init,
 		     mlx5_ib_stage_uar_cleanup),
-- 
2.19.2

