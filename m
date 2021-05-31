Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67ED0395630
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 09:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhEaHfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 03:35:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:35474 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230338AbhEaHfd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 03:35:33 -0400
IronPort-SDR: 3WPJXLrY1Q9FhLPhqqWGBS/mG9gOdSCwH+yp6Ux3sVvuak9HeCS5XQ8DuKAw3qRkECjGGhLT4o
 40RbvSTUAU+w==
X-IronPort-AV: E=McAfee;i="6200,9189,10000"; a="203316630"
X-IronPort-AV: E=Sophos;i="5.83,236,1616482800"; 
   d="scan'208";a="203316630"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 00:33:54 -0700
IronPort-SDR: MccCIduNF7x0t0En4OVg3YEQp38Xbwn+mrZyMUmL7YYKRQXgYkiz8STgsTPCA7dKXqeEH7OYg6
 06DS7wUpNrmQ==
X-IronPort-AV: E=Sophos;i="5.83,236,1616482800"; 
   d="scan'208";a="478809831"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.107])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 00:33:52 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH RESEND 2/2] vDPA/ifcvf: reuse pre-defined macros for device ids and vendor ids
Date:   Mon, 31 May 2021 15:27:43 +0800
Message-Id: <20210531072743.363171-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210531072743.363171-1-lingshan.zhu@intel.com>
References: <20210531072743.363171-1-lingshan.zhu@intel.com>
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

