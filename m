Return-Path: <netdev+bounces-9772-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A2F672A7BA
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:46:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB2DB281A89
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 01:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28F6A9479;
	Sat, 10 Jun 2023 01:43:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0BDA923
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79863C4339E;
	Sat, 10 Jun 2023 01:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686361397;
	bh=+knZYn8Ok7CXhEXd1SuaRScZw/nrwfydb1hrlZIsIho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBATmzIhwJgxJLlKiYtZpgi68fy2GukPgIRJM9s9VcheNLYFMLVH9qCDc+k7WRoNv
	 taobubDK/QQV/Xw5y8EXY7JCX8BYIPl2toVUPoQ98/XarHE0Rz6RHhf6FPtKDWju4b
	 q58NXodq9xu85zdx35fBxTVmTNBK0NsU0Pd1XB1U59e6ZTRNymVlkWyTKtd6HeSwuX
	 ajxmzzCmDcWeMfLN4nCX+ALTc7MSav8sCNxmChK+TgEZdsTC3kn+nKLh1DDmOei3Wt
	 AMsjxXpNYQQCbsrKO+baLZmNsMwHYzAsMNMXaQmdztp6klhqpHAJpn3QKxbzgL4pec
	 8QasBO3265Q8w==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Daniel Jurgens <danielj@nvidia.com>
Subject: [net-next 11/15] net/mlx5: Set max number of embedded CPU VFs
Date: Fri,  9 Jun 2023 18:42:50 -0700
Message-Id: <20230610014254.343576-12-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230610014254.343576-1-saeed@kernel.org>
References: <20230610014254.343576-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Daniel Jurgens <danielj@nvidia.com>

Set the maximum number of embedded cpu VF functions available.

Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index b73583b0a0fe..4e42a3b9b8ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -305,6 +305,7 @@ int mlx5_sriov_init(struct mlx5_core_dev *dev)
 	total_vfs = pci_sriov_get_totalvfs(pdev);
 	sriov->max_vfs = mlx5_get_max_vfs(dev);
 	sriov->num_vfs = pci_num_vf(pdev);
+	sriov->max_ec_vfs = mlx5_core_ec_sriov_enabled(dev) ? pci_sriov_get_totalvfs(dev->pdev) : 0;
 	sriov->vfs_ctx = kcalloc(total_vfs, sizeof(*sriov->vfs_ctx), GFP_KERNEL);
 	if (!sriov->vfs_ctx)
 		return -ENOMEM;
-- 
2.40.1


