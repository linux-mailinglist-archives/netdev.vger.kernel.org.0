Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9891B32ED16
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 15:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhCEOZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 09:25:42 -0500
Received: from mga17.intel.com ([192.55.52.151]:27033 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230412AbhCEOZ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 09:25:29 -0500
IronPort-SDR: RTfC759iLoxKC1cyrJHelMDhzJvQsMw7znutUcG5HLltLxSzQeC1uon0UFWNfTFMclwyuTWNu7
 eQ+moj4rKsoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9914"; a="167555564"
X-IronPort-AV: E=Sophos;i="5.81,225,1610438400"; 
   d="scan'208";a="167555564"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 06:25:29 -0800
IronPort-SDR: nckXKTnu4bFavss5OQj23qtOON7wZys2As4nZTPKLZ8KyOTjc+O5qwaRsMDuxuQ48l3adQderq
 DGbX27k7PY5w==
X-IronPort-AV: E=Sophos;i="5.81,225,1610438400"; 
   d="scan'208";a="408315642"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 06:25:26 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 1/3] vDPA/ifcvf: get_vendor_id returns a device specific vendor id
Date:   Fri,  5 Mar 2021 22:19:58 +0800
Message-Id: <20210305142000.18521-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210305142000.18521-1-lingshan.zhu@intel.com>
References: <20210305142000.18521-1-lingshan.zhu@intel.com>
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

