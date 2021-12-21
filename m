Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A6C47C9F7
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 00:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238351AbhLUX6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 18:58:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:30626 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230020AbhLUX6y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 18:58:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640131134; x=1671667134;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fzwnxaM8qEVZ+xGKSxQj2nrNO5stVmeCjjZyJxAa/8U=;
  b=Th1kLWblK/ct+zPjoGnP061/RvHeQ4tlh0MZCLm0+U7f+gfb1Ke72P3F
   KdV0RHKYLQMmQkJ3BYpVA6Ocmy54IlTMypF0vQDhkTHS7f+dN8nLDHja6
   6LUC2ikQXLaVxlN6IK97SZ4MII+gxn/kQmnDBvRz0tMM4BhsprMbUb2M0
   pTrYLzZA2nZTNJW2PIYI0qGxC5VS/r/Mgz6GVGVDTTZs5PTRN++5p0Afc
   jqr+3tNFFMZ9+9/oZut2UZBpWWI0y9g88QuAsMD4GWpRI08y1I+KBNwca
   EJbHqhtYVeQjTg0xBMXjccqrwGQWW2h7S3lDaaPOTy1TBnhH2BGqj2fY1
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="264706230"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="264706230"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 15:58:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="521457295"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga008.jf.intel.com with ESMTP; 21 Dec 2021 15:58:53 -0800
Received: from debox1-desk4.intel.com (unknown [10.209.90.33])
        by linux.intel.com (Postfix) with ESMTP id EC2F2580684;
        Tue, 21 Dec 2021 15:58:52 -0800 (PST)
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
Subject: [PATCH 1/4] RDMA/irdma: Use auxiliary_device driver data helpers
Date:   Tue, 21 Dec 2021 15:58:49 -0800
Message-Id: <20211221235852.323752-2-david.e.box@linux.intel.com>
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
 drivers/infiniband/hw/irdma/main.c | 4 ++--
 drivers/infiniband/hw/mlx5/main.c  | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/main.c b/drivers/infiniband/hw/irdma/main.c
index 51a41359e0b4..9ccf4d683f8a 100644
--- a/drivers/infiniband/hw/irdma/main.c
+++ b/drivers/infiniband/hw/irdma/main.c
@@ -207,7 +207,7 @@ static void irdma_remove(struct auxiliary_device *aux_dev)
 							    struct iidc_auxiliary_dev,
 							    adev);
 	struct ice_pf *pf = iidc_adev->pf;
-	struct irdma_device *iwdev = dev_get_drvdata(&aux_dev->dev);
+	struct irdma_device *iwdev = auxiliary_get_drvdata(aux_dev);
 
 	irdma_ib_unregister_device(iwdev);
 	ice_rdma_update_vsi_filter(pf, iwdev->vsi_num, false);
@@ -294,7 +294,7 @@ static int irdma_probe(struct auxiliary_device *aux_dev, const struct auxiliary_
 	ice_rdma_update_vsi_filter(pf, iwdev->vsi_num, true);
 
 	ibdev_dbg(&iwdev->ibdev, "INIT: Gen2 PF[%d] device probe success\n", PCI_FUNC(rf->pcidev->devfn));
-	dev_set_drvdata(&aux_dev->dev, iwdev);
+	auxiliary_set_drvdata(aux_dev, iwdev);
 
 	return 0;
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5ec8bd2f0b2f..85f526c861e9 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4422,7 +4422,7 @@ static int mlx5r_mp_probe(struct auxiliary_device *adev,
 	}
 	mutex_unlock(&mlx5_ib_multiport_mutex);
 
-	dev_set_drvdata(&adev->dev, mpi);
+	auxiliary_set_drvdata(adev, mpi);
 	return 0;
 }
 
@@ -4430,7 +4430,7 @@ static void mlx5r_mp_remove(struct auxiliary_device *adev)
 {
 	struct mlx5_ib_multiport_info *mpi;
 
-	mpi = dev_get_drvdata(&adev->dev);
+	mpi = auxiliary_get_drvdata(adev);
 	mutex_lock(&mlx5_ib_multiport_mutex);
 	if (mpi->ibdev)
 		mlx5_ib_unbind_slave_port(mpi->ibdev, mpi);
@@ -4480,7 +4480,7 @@ static int mlx5r_probe(struct auxiliary_device *adev,
 		return ret;
 	}
 
-	dev_set_drvdata(&adev->dev, dev);
+	auxiliary_set_drvdata(adev, dev);
 	return 0;
 }
 
@@ -4488,7 +4488,7 @@ static void mlx5r_remove(struct auxiliary_device *adev)
 {
 	struct mlx5_ib_dev *dev;
 
-	dev = dev_get_drvdata(&adev->dev);
+	dev = auxiliary_get_drvdata(adev);
 	__mlx5_ib_remove(dev, dev->profile, MLX5_IB_STAGE_MAX);
 }
 
-- 
2.25.1

