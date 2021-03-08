Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC58C33098A
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 09:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbhCHIlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 03:41:00 -0500
Received: from mga03.intel.com ([134.134.136.65]:40492 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231793AbhCHIk4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 03:40:56 -0500
IronPort-SDR: Fh1rKVVCjRwayOg+CIcXzjakuhmSsS+CRYrlMv+dprL4YOeyBHbUJmA0+uTdZdWw32BYSxBuI4
 A9hECJXwBwYQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9916"; a="188041992"
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="188041992"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 00:40:53 -0800
IronPort-SDR: fbjU80Wk7p4LMwQS/SuXMdGxXRYRoiNL0xim2NGxWGi9raFKzzit0u0/RXJ+llK6R4torCfREr
 9jsW/BosW2PA==
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="508855638"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 00:40:51 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 1/4] vDPA/ifcvf: get_vendor_id returns a device specific vendor id
Date:   Mon,  8 Mar 2021 16:35:22 +0800
Message-Id: <20210308083525.382514-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210308083525.382514-1-lingshan.zhu@intel.com>
References: <20210308083525.382514-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this commit, ifcvf_get_vendor_id() will return
a device specific vendor id of the probed pci device
than a hard code.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index fa1af301cf55..e501ee07de17 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -324,7 +324,10 @@ static u32 ifcvf_vdpa_get_device_id(struct vdpa_device *vdpa_dev)
 
 static u32 ifcvf_vdpa_get_vendor_id(struct vdpa_device *vdpa_dev)
 {
-	return IFCVF_SUBSYS_VENDOR_ID;
+	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
+	struct pci_dev *pdev = adapter->pdev;
+
+	return pdev->subsystem_vendor;
 }
 
 static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
-- 
2.27.0

