Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F91396DB3
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 09:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbhFAHEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 03:04:37 -0400
Received: from mga04.intel.com ([192.55.52.120]:1489 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233014AbhFAHEb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 03:04:31 -0400
IronPort-SDR: 3l/DxF3E8yF13Q43oH6Ln4mUFEe3ZyBJC0YPn18qy3+Pf/xL9SY4Jm6RHPi6yj5YKqhHuj20Ys
 HL0CcAhu+XQg==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="201619830"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="201619830"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 00:02:50 -0700
IronPort-SDR: mCw/I4r7R4M3EsBTEjFartncXX1LKelS0wpSp454fjNNzu7gCEghroZZseDV0XfCKQlDVbT9Fv
 KFcpnnpDi2XA==
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="445224695"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.107])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 00:02:48 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 2/2] vDPA/ifcvf: reuse pre-defined macros for device ids and vendor ids
Date:   Tue,  1 Jun 2021 14:57:10 +0800
Message-Id: <20210601065710.224300-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210601065710.224300-1-lingshan.zhu@intel.com>
References: <20210601065710.224300-1-lingshan.zhu@intel.com>
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

