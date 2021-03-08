Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAF2330993
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 09:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhCHIld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 03:41:33 -0500
Received: from mga03.intel.com ([134.134.136.65]:40492 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231815AbhCHIk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 03:40:57 -0500
IronPort-SDR: /7yKqrChUE0RRSvjvsgSwfXo1GiOmGwgTDiALBONrLo5/xiNagHkQuk35lcJd8nfufhHOCMsmL
 cGzUlx968QoQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9916"; a="188041996"
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="188041996"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 00:40:57 -0800
IronPort-SDR: +lomRZTYn8sthZUKc9Eu9w4ZsdhNt8LjkjWkTx7SbD0Rt8PUY/Ay7pWcgfBknFfKviEzpKUr4M
 OaUB7rfKgi6g==
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="508855653"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 00:40:55 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 2/4] vDPA/ifcvf: enable Intel C5000X-PL virtio-net for vDPA
Date:   Mon,  8 Mar 2021 16:35:23 +0800
Message-Id: <20210308083525.382514-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210308083525.382514-1-lingshan.zhu@intel.com>
References: <20210308083525.382514-1-lingshan.zhu@intel.com>
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

