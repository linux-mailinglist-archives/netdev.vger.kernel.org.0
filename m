Return-Path: <netdev+bounces-3980-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFE0D709EA9
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:58:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B212281DC2
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CCF813AE6;
	Fri, 19 May 2023 17:56:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D26913AC2
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331A5C4331D;
	Fri, 19 May 2023 17:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684518976;
	bh=yTgI09Dcr25tKywleNGrT9S8EVXBc47i+rpmYP129yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7MsfoZ2JDyJOj1a006gk1uMqwsM/W831Q+K//jE6BtoVTXN0isFkZpBp3OBZlvbb
	 dk4hHgmC6VKa3bdXdyZN01TAZGGgnR+LyoyOrONU9p09mrDQZkXR3OEAAi2cDD+VQQ
	 CDxiLXDs6CpPko3OdYUnYCEg0OLxyIl1HZp0UqFjLB7rd3KdPi+pa2rwwwEg0RXSAz
	 t2AKq1qo280IMAVfj7MCSbtGLEdN9fG63Dj7xKHLl6GR9A/nPA5SC50M3sOmf/7OEW
	 NmB1VJ0y5tBom/SOs6UdtK3/079COJV5KaDMZzMPdxgcPBftDrdm9nrxiSPvWmMzkQ
	 Al8P9Y7ti++Xw==
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
Subject: [net-next 08/15] net/mlx5: Remove redundant vport_group_manager cap check
Date: Fri, 19 May 2023 10:55:50 -0700
Message-Id: <20230519175557.15683-9-saeed@kernel.org>
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

It's enough to check for esw_manager cap for get the esw flow table
caps.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 7bb7be01225a..fb2035a5ec99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -196,14 +196,11 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 			return err;
 	}
 
-	if (MLX5_CAP_GEN(dev, vport_group_manager) &&
-	    MLX5_ESWITCH_MANAGER(dev)) {
+	if (MLX5_ESWITCH_MANAGER(dev)) {
 		err = mlx5_core_get_caps(dev, MLX5_CAP_ESWITCH_FLOW_TABLE);
 		if (err)
 			return err;
-	}
 
-	if (MLX5_ESWITCH_MANAGER(dev)) {
 		err = mlx5_core_get_caps(dev, MLX5_CAP_ESWITCH);
 		if (err)
 			return err;
-- 
2.40.1


