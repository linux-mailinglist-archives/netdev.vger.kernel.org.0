Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B9A47CA03
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 00:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238730AbhLUX7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 18:59:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:33887 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230020AbhLUX6z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 18:58:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640131135; x=1671667135;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HmRnjSHEImGDIXi5qjv2Qcg1JIBqpB9eFo+S1hSnOUM=;
  b=kmo5lYdC8o3K1lTpp5ZKefvL1TSIE54N0fPlb1rVGrJgJDJ003IBYEol
   8ekqhPWzruUHMeq0vMpeL96eo20u/FOjQTOOMxhg97X2IM+uBAZrn0j/u
   8/bin3aXbQ7NEQJ6vIEBvQwbcYmjDeE4Rk42YzgSEyW61ypJToiHjmNmA
   6y2+Yy3kuPoXPIfOvPa01dxbGNWizKhFdWXuJ2dUSZ5VMXhj0ifD132v/
   p+TBfViJ28qSnJHEA4K9aXnSwVFMFw/cNbzzpqKvPYcS/qWjWtGhutdYl
   ob9DEd7qI8Eqrpw2QfVTWwZJji+OZ9Wxlz69sd9+XREfDftD2d3GZ1XSa
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="227808274"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="227808274"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 15:58:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="756027347"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga006.fm.intel.com with ESMTP; 21 Dec 2021 15:58:54 -0800
Received: from debox1-desk4.intel.com (unknown [10.209.90.33])
        by linux.intel.com (Postfix) with ESMTP id ECAF4580684;
        Tue, 21 Dec 2021 15:58:53 -0800 (PST)
From:   "David E. Box" <david.e.box@linux.intel.com>
To:     gregkh@linuxfoundation.org, mustafa.ismail@intel.com,
        shiraz.saleem@intel.com, dledford@redhat.com, jgg@ziepe.ca,
        leon@kernel.org, saeedm@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, vkoul@kernel.org, yung-chuan.liao@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, mst@redhat.com,
        jasowang@redhat.com
Cc:     "David E. Box" <david.e.box@linux.intel.com>,
        andriy.shevchenko@linux.intel.com, hdegoede@redhat.com,
        virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH 3/4] net/mlx5e: Use auxiliary_device driver data helpers
Date:   Tue, 21 Dec 2021 15:58:51 -0800
Message-Id: <20211221235852.323752-4-david.e.box@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211221235852.323752-1-david.e.box@linux.intel.com>
References: <20211221235852.323752-1-david.e.box@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use auxiliary_get_drvdata and auxiliary_set_drvdata helpers.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 65571593ec5c..244ce8f4e286 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5389,7 +5389,7 @@ void mlx5e_destroy_netdev(struct mlx5e_priv *priv)
 static int mlx5e_resume(struct auxiliary_device *adev)
 {
 	struct mlx5_adev *edev = container_of(adev, struct mlx5_adev, adev);
-	struct mlx5e_priv *priv = dev_get_drvdata(&adev->dev);
+	struct mlx5e_priv *priv = auxiliary_get_drvdata(adev);
 	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = edev->mdev;
 	int err;
@@ -5412,7 +5412,7 @@ static int mlx5e_resume(struct auxiliary_device *adev)
 
 static int mlx5e_suspend(struct auxiliary_device *adev, pm_message_t state)
 {
-	struct mlx5e_priv *priv = dev_get_drvdata(&adev->dev);
+	struct mlx5e_priv *priv = auxiliary_get_drvdata(adev);
 	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
 
@@ -5456,7 +5456,7 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	mlx5e_build_nic_netdev(netdev);
 
 	priv = netdev_priv(netdev);
-	dev_set_drvdata(&adev->dev, priv);
+	auxiliary_set_drvdata(adev, priv);
 
 	priv->profile = profile;
 	priv->ppriv = NULL;
@@ -5504,7 +5504,7 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 
 static void mlx5e_remove(struct auxiliary_device *adev)
 {
-	struct mlx5e_priv *priv = dev_get_drvdata(&adev->dev);
+	struct mlx5e_priv *priv = auxiliary_get_drvdata(adev);
 	pm_message_t state = {};
 
 	mlx5e_dcbnl_delete_app(priv);
-- 
2.25.1

