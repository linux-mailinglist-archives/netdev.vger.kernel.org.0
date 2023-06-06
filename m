Return-Path: <netdev+bounces-8289-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C710C723896
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:14:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AECA1C20E5F
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:14:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 098E0611C;
	Tue,  6 Jun 2023 07:12:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABAC3FDF
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81333C43443;
	Tue,  6 Jun 2023 07:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686035555;
	bh=FNM51TLwVFHesXXwp2j/Sy3SQ1DLOAGSc+DrGiAmQCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afxpEyQv3xx5K0hmMo1GN+LHudXxeXTZsNnD+yPM4y8Iy1/VxrXvzGBZO7s7u6bZp
	 LoMRbAwgxdf3TQjyEQV0DFdsiQsOoNEeTed7ybNTS2ZBfNPWZmOz8RWX9rNqRL7xZn
	 hrA2Lw1+75OULjcxzd/k0CYGyzBi+w+2Rlsn/spn+LqCLuwWLsiF61JGNYFQSA87aP
	 i1vfWVM9IcAew7goXkVzQNLdttLZ/xXIYTNdJ3dp0PEJHE5iBAjaHYviiJJoqiRaAc
	 Bxvncmkjkk+uE7ey4s75LEEb7+e0XQYYKeplUXgb/mrHR2FdpztapV5OqbfEJYDmMa
	 qFpSFbEHL8azw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	linux-rdma@vger.kernel.org,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Subject: [net-next 05/15] net/mlx5: LAG, change mlx5_shared_fdb_supported() to static
Date: Tue,  6 Jun 2023 00:12:09 -0700
Message-Id: <20230606071219.483255-6-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606071219.483255-1-saeed@kernel.org>
References: <20230606071219.483255-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

mlx5_shared_fdb_supported() is used only in a single file. Change the
function to be static.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 00773aab9d20..6ce71c42c755 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -815,7 +815,7 @@ void mlx5_disable_lag(struct mlx5_lag *ldev)
 				mlx5_eswitch_reload_reps(ldev->pf[i].dev->priv.eswitch);
 }
 
-bool mlx5_shared_fdb_supported(struct mlx5_lag *ldev)
+static bool mlx5_shared_fdb_supported(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev;
 	int i;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index bc1f1dd3e283..d7e7fa2348a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -111,7 +111,6 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 		      bool shared_fdb);
 int mlx5_lag_dev_get_netdev_idx(struct mlx5_lag *ldev,
 				struct net_device *ndev);
-bool mlx5_shared_fdb_supported(struct mlx5_lag *ldev);
 
 char *mlx5_get_str_port_sel_mode(enum mlx5_lag_mode mode, unsigned long flags);
 void mlx5_infer_tx_enabled(struct lag_tracker *tracker, u8 num_ports,
-- 
2.40.1


