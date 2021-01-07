Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94812EE6DC
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbhAGU3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:29:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:55484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbhAGU3n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:29:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED94C23443;
        Thu,  7 Jan 2021 20:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610051342;
        bh=vVxSkaNkTKVQmD4U1jZYy7qcSZQ+cAOXi1gwCh1jATs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FtgciulamXw152R4RgI5yOSOWqkAKK19SHjVAM+XiAYSkSgjP/7rkv7XR3vrnyvU6
         cdRXLou+W8mUhFu03CcCSHZY0VlAKo0C7kMKU7dfqKOvA6+daxBScY/EjApexgzedT
         /HIb0yJR3ivdV6NQwZB2Rq70Ga3L3RpNhTnljH286HgEoRgIkDRVDdL7z7yKU9bIui
         PqMTXhtvC6nO6acF4iv6nhdkgPodm7mRMgxr9/wzS0mw2yI15pRyxiSLDno2LwunDf
         vizfJbCTcY3npi08MoLW0ip/3/uiUcR3nSxZUkKbzXsF2WSw7+j4MoL9kUopil2Uli
         9wiHQtkbmQ9EQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 03/11] net/mlx5: Use port_num 1 instead of 0 when delete a RoCE address
Date:   Thu,  7 Jan 2021 12:28:37 -0800
Message-Id: <20210107202845.470205-4-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107202845.470205-1-saeed@kernel.org>
References: <20210107202845.470205-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markzhang@nvidia.com>

In multi-port mode, FW reports syndrome 0x2ea48 (invalid vhca_port_number)
if the port_num is not 1 or 2.

Fixes: 80f09dfc237f ("net/mlx5: Eswitch, enable RoCE loopback traffic")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
index 0fc7de4aa572..8e0dddc6383f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
@@ -116,7 +116,7 @@ static int mlx5_rdma_enable_roce_steering(struct mlx5_core_dev *dev)
 static void mlx5_rdma_del_roce_addr(struct mlx5_core_dev *dev)
 {
 	mlx5_core_roce_gid_set(dev, 0, 0, 0,
-			       NULL, NULL, false, 0, 0);
+			       NULL, NULL, false, 0, 1);
 }
 
 static void mlx5_rdma_make_default_gid(struct mlx5_core_dev *dev, union ib_gid *gid)
-- 
2.26.2

