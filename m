Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33BE356241
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhDGEGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229546AbhDGEGu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:06:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CB6E613C6;
        Wed,  7 Apr 2021 04:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617768401;
        bh=IMH8PP2g+fobN5lolsG7smKdlXewvp8fWX2WsyFdit8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IlWLhh0bu3sjNbDTaaKZf5imIE73TpGO0zuZWZGcqTpcqT6+/AMEx00j87e0sPeYz
         K53fR4g2Uh5QXdQal1cyGBF+gPVDec4/eEIRajk6HK2m9zVUOmLER26yGp2WfcrrMN
         8FirHeOA7DHsYCSRvWlfADd8kP0znD404flxmdxKT5Jn+TiHQzDPedXPf0xUGOfULO
         JciFqNKZACw4d3i66Aw0UHw5XYMpWO1CU67nZANnUas/vbUIeIybQKW7bdbPq2VQIn
         L0rgVsFdM/2yIIPwd22dexTUpgypIeOu6OY1G+XiVR7JbNc7i2nax+HjA13BfsPXQL
         LBPxwNWZFC11Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 2/5] net/mlx5: Fix placement of log_max_flow_counter
Date:   Tue,  6 Apr 2021 21:06:17 -0700
Message-Id: <20210407040620.96841-3-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407040620.96841-1-saeed@kernel.org>
References: <20210407040620.96841-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

The cited commit wrongly placed log_max_flow_counter field of
mlx5_ifc_flow_table_prop_layout_bits, align it to the HW spec intended
placement.

Fixes: 16f1c5bb3ed7 ("net/mlx5: Check device capability for maximum flow counters")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index df5d91c8b2d4..1ccedb7816d0 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -437,11 +437,11 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8         reserved_at_60[0x18];
 	u8         log_max_ft_num[0x8];
 
-	u8         reserved_at_80[0x18];
+	u8         reserved_at_80[0x10];
+	u8         log_max_flow_counter[0x8];
 	u8         log_max_destination[0x8];
 
-	u8         log_max_flow_counter[0x8];
-	u8         reserved_at_a8[0x10];
+	u8         reserved_at_a0[0x18];
 	u8         log_max_flow[0x8];
 
 	u8         reserved_at_c0[0x40];
-- 
2.30.2

