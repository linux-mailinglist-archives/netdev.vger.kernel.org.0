Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29038298BCB
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 12:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773488AbgJZLUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 07:20:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1773319AbgJZLTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 07:19:12 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56E1822403;
        Mon, 26 Oct 2020 11:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603711151;
        bh=qk8PmsDBuQCH8e0JRhhBr0jHNe14EM3J0vorow/ddL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XLs6d8Mf5LX6XFU31dV/4/bDbXn33Z42d2Ah4RJkXbB6UcGjLa05Lmfc4RxJoSmSI
         /EHigOIQLe1vrOEB2DqTOxLB7MWB4bzAmVlIginBv8eyv2L1UKur3TdyoWkr+OUchn
         2wJRMI7RdeUXqv+mKJCTN59l23Em6gSy/QhgCHaE=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-rdma@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        shiraz.saleem@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH mlx5-next 04/11] vdpa/mlx5: Make hardware definitions visible to all mlx5 devices
Date:   Mon, 26 Oct 2020 13:18:42 +0200
Message-Id: <20201026111849.1035786-5-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201026111849.1035786-1-leon@kernel.org>
References: <20201026111849.1035786-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Move mlx5_vdpa IFC header file to the general include folder, so
mlx5_core will be able to reuse it to check if VDPA is supported
prior to creating an auxiliary device.

As part of this move, update the header file name to mlx5 general
naming scheme.

Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vdpa/mlx5/net/main.c                                | 2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                           | 2 +-
 .../mlx5_vdpa_ifc.h => include/linux/mlx5/mlx5_ifc_vdpa.h   | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)
 rename drivers/vdpa/mlx5/core/mlx5_vdpa_ifc.h => include/linux/mlx5/mlx5_ifc_vdpa.h (97%)

diff --git a/drivers/vdpa/mlx5/net/main.c b/drivers/vdpa/mlx5/net/main.c
index 838cd98386ff..4dd3f00f2306 100644
--- a/drivers/vdpa/mlx5/net/main.c
+++ b/drivers/vdpa/mlx5/net/main.c
@@ -4,7 +4,7 @@
 #include <linux/module.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/device.h>
-#include "mlx5_vdpa_ifc.h"
+#include <linux/mlx5/mlx5_ifc_vdpa.h>
 #include "mlx5_vnet.h"

 MODULE_AUTHOR("Eli Cohen <eli@mellanox.com>");
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 1fa6fcac8299..6c218b47b9f1 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -9,8 +9,8 @@
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/device.h>
+#include <linux/mlx5/mlx5_ifc_vdpa.h>
 #include "mlx5_vnet.h"
-#include "mlx5_vdpa_ifc.h"
 #include "mlx5_vdpa.h"

 #define to_mvdev(__vdev) container_of((__vdev), struct mlx5_vdpa_dev, vdev)
diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa_ifc.h b/include/linux/mlx5/mlx5_ifc_vdpa.h
similarity index 97%
rename from drivers/vdpa/mlx5/core/mlx5_vdpa_ifc.h
rename to include/linux/mlx5/mlx5_ifc_vdpa.h
index f6f57a29b38e..97784098a992 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc_vdpa.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
 /* Copyright (c) 2020 Mellanox Technologies Ltd. */

-#ifndef __MLX5_VDPA_IFC_H_
-#define __MLX5_VDPA_IFC_H_
+#ifndef __MLX5_IFC_VDPA_H_
+#define __MLX5_IFC_VDPA_H_

 #include <linux/mlx5/mlx5_ifc.h>

@@ -165,4 +165,4 @@ struct mlx5_ifc_modify_virtio_net_q_out_bits {
 	struct mlx5_ifc_general_obj_out_cmd_hdr_bits general_obj_out_cmd_hdr;
 };

-#endif /* __MLX5_VDPA_IFC_H_ */
+#endif /* __MLX5_IFC_VDPA_H_ */
--
2.26.2

