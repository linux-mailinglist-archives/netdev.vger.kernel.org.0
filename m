Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E953377DCA
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 10:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhEJIQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 04:16:54 -0400
Received: from mga18.intel.com ([134.134.136.126]:57585 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230238AbhEJIQv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 04:16:51 -0400
IronPort-SDR: tyr7/+J11/kcEkr+9Psm9bAX2kBqhcnIBy2fCHDnZ1rO39Wz59jO2yfUVm/O2SyyhqAXoWl0HT
 0UW7XBc5KIhg==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="186587929"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="186587929"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 01:15:47 -0700
IronPort-SDR: DXO8kTfUesPnHkzUDVaiwI5pu8nDY0ieuvPZd4UKW4SWbAMrPm8stG9XRjYye+89DZyo/G3B/m
 1f/aZl84ys+Q==
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="436040641"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 01:15:45 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 2/2] vDPA/ifcvf: reuse pre-defined macros for device ids and vendor ids
Date:   Mon, 10 May 2021 16:10:15 +0800
Message-Id: <20210510081015.4212-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210510081015.4212-1-lingshan.zhu@intel.com>
References: <20210510081015.4212-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit would reuse pre-defined macros for ifcvf device ids
and vendor ids

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.h | 12 ------------
 drivers/vdpa/ifcvf/ifcvf_main.c | 23 +++++++++++++----------
 2 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 0111bfdeb342..ded1b1b5fb13 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -19,21 +19,9 @@
 #include <uapi/linux/virtio_config.h>
 #include <uapi/linux/virtio_pci.h>
 
-#define N3000_VENDOR_ID		0x1AF4
 #define N3000_DEVICE_ID		0x1041
-#define N3000_SUBSYS_VENDOR_ID	0x8086
 #define N3000_SUBSYS_DEVICE_ID	0x001A
 
-#define C5000X_PL_VENDOR_ID		0x1AF4
-#define C5000X_PL_DEVICE_ID		0x1000
-#define C5000X_PL_SUBSYS_VENDOR_ID	0x8086
-#define C5000X_PL_SUBSYS_DEVICE_ID	0x0001
-
-#define C5000X_PL_BLK_VENDOR_ID		0x1AF4
-#define C5000X_PL_BLK_DEVICE_ID		0x1001
-#define C5000X_PL_BLK_SUBSYS_VENDOR_ID	0x8086
-#define C5000X_PL_BLK_SUBSYS_DEVICE_ID	0x0002
-
 #define IFCVF_NET_SUPPORTED_FEATURES \
 		((1ULL << VIRTIO_NET_F_MAC)			| \
 		 (1ULL << VIRTIO_F_ANY_LAYOUT)			| \
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index ab0ab5cf0f6e..bc1d59f316d1 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -536,18 +536,21 @@ static void ifcvf_remove(struct pci_dev *pdev)
 }
 
 static struct pci_device_id ifcvf_pci_ids[] = {
-	{ PCI_DEVICE_SUB(N3000_VENDOR_ID,
+	/* N3000 network device */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_REDHAT_QUMRANET,
 			 N3000_DEVICE_ID,
-			 N3000_SUBSYS_VENDOR_ID,
+			 PCI_VENDOR_ID_INTEL,
 			 N3000_SUBSYS_DEVICE_ID) },
-	{ PCI_DEVICE_SUB(C5000X_PL_VENDOR_ID,
-			 C5000X_PL_DEVICE_ID,
-			 C5000X_PL_SUBSYS_VENDOR_ID,
-			 C5000X_PL_SUBSYS_DEVICE_ID) },
-	{ PCI_DEVICE_SUB(C5000X_PL_BLK_VENDOR_ID,
-			 C5000X_PL_BLK_DEVICE_ID,
-			 C5000X_PL_BLK_SUBSYS_VENDOR_ID,
-			 C5000X_PL_BLK_SUBSYS_DEVICE_ID) },
+	/* C5000X-PL network device */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_REDHAT_QUMRANET,
+			 VIRTIO_TRANS_ID_NET,
+			 PCI_VENDOR_ID_INTEL,
+			 VIRTIO_ID_NET) },
+	/* C5000X-PL block device */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_REDHAT_QUMRANET,
+			 VIRTIO_TRANS_ID_BLOCK,
+			 PCI_VENDOR_ID_INTEL,
+			 VIRTIO_ID_BLOCK) },
 
 	{ 0 },
 };
-- 
2.27.0

