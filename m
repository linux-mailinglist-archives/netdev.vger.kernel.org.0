Return-Path: <netdev+bounces-3975-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C50B6709EA4
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:57:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 821FD281B17
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D7AC12B93;
	Fri, 19 May 2023 17:56:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042E312B7C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB5AC433EF;
	Fri, 19 May 2023 17:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684518971;
	bh=KrRSPf8Irs35yflSipHgmQjfCQqs22/gKZaVL50i+rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJ7wK+Z/BXcVfaTK9podZYM3vZJfMu/zZYfa2/kcrfvsx33QPGKEOzyKNiFbUPPt+
	 JmxRhM4mVJbw9hltRgXEBt0H4F5MAqm2uhYq1JPQyxsuNUYlbSBxwZl1jv4E0JJULg
	 pGhL0h3ZqQC+shS14MVr0wpBL/fEsgur1Sxm8x9eS/k7KIV3jOj06ey/r1L57HmFzX
	 k7KwuXVZDm2mHBl3vZTJdOMXUn0BeTqdbetkQVKGKIBCkCjK2xtIYCj4KLuzHQb+Td
	 fUM2VTRvmrYUmXE1yM6GtT+7qBlyQWW5kuP1LLkz7v0X8nEEaPlXBV72j5p1nVYgRT
	 cGQqgzed/Bs3g==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Maor Dickman <maord@nvidia.com>
Subject: [net-next 03/15] net/mlx5e: E-Switch, Remove flow_source check for metadata matching
Date: Fri, 19 May 2023 10:55:45 -0700
Message-Id: <20230519175557.15683-4-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230519175557.15683-1-saeed@kernel.org>
References: <20230519175557.15683-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Roi Dayan <roid@nvidia.com>

There is no reason to check for flow_source cap to allow metadata
matching. When flow_source match is being used the flow_source cap
is being checked.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 69215ffb9999..ecd12a0c6f07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2827,9 +2827,6 @@ bool mlx5_esw_vport_match_metadata_supported(const struct mlx5_eswitch *esw)
 	      MLX5_FDB_TO_VPORT_REG_C_0))
 		return false;
 
-	if (!MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source))
-		return false;
-
 	return true;
 }
 
-- 
2.40.1


