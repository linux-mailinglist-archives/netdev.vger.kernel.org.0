Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9624033AC9E
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 08:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhCOHuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 03:50:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:17801 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230283AbhCOHuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 03:50:18 -0400
IronPort-SDR: NWMJDcJWxKd/d8JKRjNviyoHRvVrrQ2sUK9bMv3kt5cGHfOerSLCojs5tp8szMKyPubWgnfXM2
 EeXGM/FfIanw==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="189140890"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="189140890"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 00:50:18 -0700
IronPort-SDR: u0C1Mn0NVo6rFpg6Kl9QP25v45SCOstNDc821jgk/4/qhv69HkOQ5whphsMPEcSUG1HNMK7pvD
 aH4Hc6cPvpJg==
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="411752202"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 00:50:15 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 2/7] vDPA/ifcvf: enable Intel C5000X-PL virtio-net for vDPA
Date:   Mon, 15 Mar 2021 15:44:56 +0800
Message-Id: <20210315074501.15868-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315074501.15868-1-lingshan.zhu@intel.com>
References: <20210315074501.15868-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit enabled Intel FPGA SmartNIC C5000X-PL virtio-net
for vDPA

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.h | 5 +++++
 drivers/vdpa/ifcvf/ifcvf_main.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 64696d63fe07..75d9a8052039 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -23,6 +23,11 @@
 #define IFCVF_SUBSYS_VENDOR_ID	0x8086
 #define IFCVF_SUBSYS_DEVICE_ID	0x001A
 
+#define C5000X_PL_VENDOR_ID		0x1AF4
+#define C5000X_PL_DEVICE_ID		0x1000
+#define C5000X_PL_SUBSYS_VENDOR_ID	0x8086
+#define C5000X_PL_SUBSYS_DEVICE_ID	0x0001
+
 #define IFCVF_SUPPORTED_FEATURES \
 		((1ULL << VIRTIO_NET_F_MAC)			| \
 		 (1ULL << VIRTIO_F_ANY_LAYOUT)			| \
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index e501ee07de17..26a2dab7ca66 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -484,6 +484,11 @@ static struct pci_device_id ifcvf_pci_ids[] = {
 		IFCVF_DEVICE_ID,
 		IFCVF_SUBSYS_VENDOR_ID,
 		IFCVF_SUBSYS_DEVICE_ID) },
+	{ PCI_DEVICE_SUB(C5000X_PL_VENDOR_ID,
+			 C5000X_PL_DEVICE_ID,
+			 C5000X_PL_SUBSYS_VENDOR_ID,
+			 C5000X_PL_SUBSYS_DEVICE_ID) },
+
 	{ 0 },
 };
 MODULE_DEVICE_TABLE(pci, ifcvf_pci_ids);
-- 
2.27.0

