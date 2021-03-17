Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7719A33ED83
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 10:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbhCQJy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 05:54:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:59767 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhCQJyr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 05:54:47 -0400
IronPort-SDR: pE7lyYHctKO/nK2+tSp6Vxi+quGk7y73N4Y+s2zo3pE+HaJfTknT6Jwjq9ZXk4YdxekGM7YGMD
 /blqwBXv+21Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="187058672"
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="187058672"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 02:54:46 -0700
IronPort-SDR: v7rbfeQNjfOOZzs59JqaFbIQooeylMPxipVAVs1nU0DYF6lUOWPS1aETIOmmTiou54adstgP/o
 YaXD74wdqHhw==
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="405873183"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 02:54:44 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V5 2/7] vDPA/ifcvf: enable Intel C5000X-PL virtio-net for vDPA
Date:   Wed, 17 Mar 2021 17:49:28 +0800
Message-Id: <20210317094933.16417-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317094933.16417-1-lingshan.zhu@intel.com>
References: <20210317094933.16417-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit enabled Intel FPGA SmartNIC C5000X-PL virtio-net
for vDPA

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Acked-by: Jason Wang <jasowang@redhat.com>
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

