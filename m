Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB8B3E9775
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhHKSSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:18:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230147AbhHKSSj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 14:18:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2814360FC0;
        Wed, 11 Aug 2021 18:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628705895;
        bh=+gLBsaeX05sEeyg5BLxDymx4buW/8oSFn+AyuHy/x6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxTKfdGYMN4c5dMhp1ucnKp8fPdzFK/HXUU5kTiHOQxrCMWLmT+NBdM02Zg5Nh+Wj
         3o8/mRW4RKuqpY6NwLAo4StEi4A2oCpFDEWkK370mI3Y6cv/7wl+DfEM1ob7uiobN6
         s1c6SLG3yl0Sp5pVY3owc6b0FEnMbShxVgkUBhmelXdQfzIAm7tAPf8cL/RzB9dm2Y
         pVpLFrm+YC6XxKXoupOpG03InwOsw8njyxtjADEH0kOz4dYfjj0ey3xMngFX0LTRWE
         yc04p9Mtxlp/rFkjcLBDWavUeztiHI+oFokY4fapjfgmwerVC2AFR96rp3cbQkuba6
         CQjJNJO0DXKxA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/12] net/mlx5: SF, use recent sysfs api
Date:   Wed, 11 Aug 2021 11:16:53 -0700
Message-Id: <20210811181658.492548-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811181658.492548-1-saeed@kernel.org>
References: <20210811181658.492548-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Use sysfs_emit() which is aware of PAGE_SIZE buffer.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
index fa0288afc0dd..871c2fbe18d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
@@ -39,7 +39,7 @@ static ssize_t sfnum_show(struct device *dev, struct device_attribute *attr, cha
 	struct auxiliary_device *adev = container_of(dev, struct auxiliary_device, dev);
 	struct mlx5_sf_dev *sf_dev = container_of(adev, struct mlx5_sf_dev, adev);
 
-	return scnprintf(buf, PAGE_SIZE, "%u\n", sf_dev->sfnum);
+	return sysfs_emit(buf, "%u\n", sf_dev->sfnum);
 }
 static DEVICE_ATTR_RO(sfnum);
 
-- 
2.31.1

