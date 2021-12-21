Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACFC47CA01
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 00:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238631AbhLUX67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 18:58:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:34962 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238438AbhLUX6z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 18:58:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640131135; x=1671667135;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hwAfnUoUcPtbNb+Jf+zP6MleLGHe8+qzZXqQsGqVi34=;
  b=UGnziEqfy5qF2ubW4gq5Mfa88QDPPaRKA08/s7p8e/7y1MARQhtZOL1c
   ZXdOTOLUchrtj4jPaVmJYuRXwYS8aqLgFynyI+RZuk/rCG+IF0bM/oPts
   zgUEnTxbSup9wftHQdqIMOVccfKOPn6CgFHd4BZb//BOgooeoEkK8Ixca
   dp2u4VGH5c1BWbXcmnVlwUjKl2i/X3QI2Y3+4UKbPGdDEWHQBQrHOGoEZ
   GN3GmlEL+KUfJZ8/2gO2buwxTzYn0vEW0QZfAAMm01cB2+HL2TB0JScE3
   W/Rqz7Fwv+yAmsBHBBpOmT/Ol7YFYTKXmj7HjenPos81K2euh5IPaI8rw
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="238048970"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="238048970"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 15:58:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="616944343"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga004.jf.intel.com with ESMTP; 21 Dec 2021 15:58:54 -0800
Received: from debox1-desk4.intel.com (unknown [10.209.90.33])
        by linux.intel.com (Postfix) with ESMTP id 6F4CB5807C5;
        Tue, 21 Dec 2021 15:58:54 -0800 (PST)
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
Subject: [PATCH 4/4] vdpa/mlx5: Use auxiliary_device driver data helpers
Date:   Tue, 21 Dec 2021 15:58:52 -0800
Message-Id: <20211221235852.323752-5-david.e.box@linux.intel.com>
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
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 63813fbb5f62..cf59f7e17c6d 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2683,7 +2683,7 @@ static int mlx5v_probe(struct auxiliary_device *adev,
 	if (err)
 		goto reg_err;
 
-	dev_set_drvdata(&adev->dev, mgtdev);
+	auxiliary_set_drvdata(adev, mgtdev);
 
 	return 0;
 
@@ -2696,7 +2696,7 @@ static void mlx5v_remove(struct auxiliary_device *adev)
 {
 	struct mlx5_vdpa_mgmtdev *mgtdev;
 
-	mgtdev = dev_get_drvdata(&adev->dev);
+	mgtdev = auxiliary_get_drvdata(adev);
 	vdpa_mgmtdev_unregister(&mgtdev->mgtdev);
 	kfree(mgtdev);
 }
-- 
2.25.1

