Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B475A453AEA
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhKPU0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:26:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230107AbhKPU0i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 15:26:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D7566321A;
        Tue, 16 Nov 2021 20:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637094219;
        bh=j9W5vwxXIfvTcyPazazaV+Vxv+J/2ngBGAjuzVJaHI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHz/2yBa5+Su3uOqOGZb//53GW/zGS4OMRFb7NSAmYEVvlMIssRVrPPhCUf1o8B3o
         E/Yu2ly67cakbu7zi5Vo2T/6THfPkx67yykKJR2X//tyWnBMUfD6lrxSkb1QZ61Yzr
         zuvIsfDSm6ZD1QPg7LcJKOHUZ625cyU15hK7kTWmy+Dgl5RzMgz9zUl6pbUEAL0JPB
         E9X8APzO5DEK6GVLwsMWKtMXcAedeZiHGlGCWITKrWyOa0kDaMXlO0x6TWnhuM2el1
         JMIVBoKpYoSPbfjdKw0vcJbm5gGfQAqcnG1jAjWdv6PU8VPQT92BGuoSf0Y534WPVH
         btdcdGqhZHoRQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Avihai Horon <avihaih@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 09/12] net/mlx5: Fix flow counters SF bulk query len
Date:   Tue, 16 Nov 2021 12:23:18 -0800
Message-Id: <20211116202321.283874-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211116202321.283874-1-saeed@kernel.org>
References: <20211116202321.283874-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avihai Horon <avihaih@nvidia.com>

When doing a flow counters bulk query, the number of counters to query
must be aligned to 4. Current SF bulk query len is not aligned to 4,
which leads to an error when trying to query more than 4 counters.

Fix it by aligning SF bulk query len to 4.

Fixes: 2fdeb4f4c2ae ("net/mlx5: Reduce flow counters bulk query buffer size for SFs")
Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
index 31c99d53faf7..7e0e04cf26f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -40,7 +40,7 @@
 #define MLX5_FC_STATS_PERIOD msecs_to_jiffies(1000)
 /* Max number of counters to query in bulk read is 32K */
 #define MLX5_SW_MAX_COUNTERS_BULK BIT(15)
-#define MLX5_SF_NUM_COUNTERS_BULK 6
+#define MLX5_SF_NUM_COUNTERS_BULK 8
 #define MLX5_FC_POOL_MAX_THRESHOLD BIT(18)
 #define MLX5_FC_POOL_USED_BUFF_RATIO 10
 
-- 
2.31.1

