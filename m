Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC67333839
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 10:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbhCJJGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 04:06:39 -0500
Received: from mga03.intel.com ([134.134.136.65]:64352 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230156AbhCJJGF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 04:06:05 -0500
IronPort-SDR: y6acT1VMJn0pRksLjzhqDg04jUsLAu+Rsu0VMq7vnUAg/R3ot5/w2KrsZeoNGPKc0nazLIqwJr
 UgxYBn9vL3UA==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="188461264"
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="188461264"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 01:06:05 -0800
IronPort-SDR: LcDcEoe2VRiZVEbPtnOAnpg1SJv/z/esnRnAuJrtgUw8NSE8NeQGHmPJUydsm2dahPd1Zt1xkH
 tMGOqtBWvycQ==
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="410110335"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 01:06:02 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 2/6] vDPA/ifcvf: enable Intel C5000X-PL virtio-net for vDPA
Date:   Wed, 10 Mar 2021 17:00:48 +0800
Message-Id: <20210310090052.4762-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210310090052.4762-1-lingshan.zhu@intel.com>
References: <20210310090052.4762-1-lingshan.zhu@intel.com>
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

