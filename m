Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEC633381D
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 10:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbhCJJGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 04:06:04 -0500
Received: from mga03.intel.com ([134.134.136.65]:64352 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230156AbhCJJGC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 04:06:02 -0500
IronPort-SDR: WvL3AhV9FgVx/hoshrlyhd91I235PLsrdaksrnIS19+GN3URZLZ4hfPpmRUYHLTnxJNaOW8NFL
 prDO9HYfdvxQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="188461255"
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="188461255"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 01:06:02 -0800
IronPort-SDR: T85nlmfwjxlaXG2m59tn8p4maoCvmhmQd7FB1coXIb4ARwEeWrdJ9rWgpFVopgmyCaROAlbsEa
 XWKyrHMlHHbQ==
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="410110283"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 01:06:00 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 1/6] vDPA/ifcvf: get_vendor_id returns a device specific vendor id
Date:   Wed, 10 Mar 2021 17:00:47 +0800
Message-Id: <20210310090052.4762-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210310090052.4762-1-lingshan.zhu@intel.com>
References: <20210310090052.4762-1-lingshan.zhu@intel.com>
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

