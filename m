Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D8235FEE7
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhDOA3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:29:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:27426 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231610AbhDOA24 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 20:28:56 -0400
IronPort-SDR: Kl70mXw/vSSFur3ZTn55NHA4hRF+zT26kmtF6p1RlM7cvJqYV12wvEr3smGHtCui1zoyend3os
 ibNPpszdTD2Q==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="174262251"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="174262251"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 17:28:27 -0700
IronPort-SDR: +AOMpxrTiHkbYAf2Rs8u8sRy8L1mjWm4zhcyjLfXOYvsUEdCYUlBGREr+SGWItH5U/Wmsxglld
 zJGJLESU3w1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="399379545"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2021 17:28:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 15/15] ice: reduce scope of variable
Date:   Wed, 14 Apr 2021 17:30:13 -0700
Message-Id: <20210415003013.19717-16-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

The scope of this variable can be reduced so do that.

Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index a3d8d06b1e3f..e38d4adc5b8d 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -4234,7 +4234,6 @@ void ice_print_vfs_mdd_events(struct ice_pf *pf)
  */
 void ice_restore_all_vfs_msi_state(struct pci_dev *pdev)
 {
-	struct pci_dev *vfdev;
 	u16 vf_id;
 	int pos;
 
@@ -4243,6 +4242,8 @@ void ice_restore_all_vfs_msi_state(struct pci_dev *pdev)
 
 	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_SRIOV);
 	if (pos) {
+		struct pci_dev *vfdev;
+
 		pci_read_config_word(pdev, pos + PCI_SRIOV_VF_DID,
 				     &vf_id);
 		vfdev = pci_get_device(pdev->vendor, vf_id, NULL);
-- 
2.26.2

