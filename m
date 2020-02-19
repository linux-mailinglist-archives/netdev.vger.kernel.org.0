Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEA016521C
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 23:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgBSWG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 17:06:59 -0500
Received: from mga03.intel.com ([134.134.136.65]:62535 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbgBSWG6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 17:06:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 14:06:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="239824833"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga006.jf.intel.com with ESMTP; 19 Feb 2020 14:06:54 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/13] ice: add support for E823 devices
Date:   Wed, 19 Feb 2020 14:06:51 -0800
Message-Id: <20200219220652.2255171-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
References: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Add E823 device ids and convert conditional expressions to a more
appropriate switch statement.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devids.h | 20 +++++++++++++
 drivers/net/ethernet/intel/ice/ice_main.c   | 10 +++++++
 drivers/net/ethernet/intel/ice/ice_nvm.c    | 32 +++++++++++++++------
 3 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devids.h b/drivers/net/ethernet/intel/ice/ice_devids.h
index 56952d89ada8..6fccb66ff43c 100644
--- a/drivers/net/ethernet/intel/ice/ice_devids.h
+++ b/drivers/net/ethernet/intel/ice/ice_devids.h
@@ -5,6 +5,16 @@
 #define _ICE_DEVIDS_H_
 
 /* Device IDs */
+/* Intel(R) Ethernet Connection E823-L for backplane */
+#define ICE_DEV_ID_E823L_BACKPLANE	0x124C
+/* Intel(R) Ethernet Connection E823-L for SFP */
+#define ICE_DEV_ID_E823L_SFP		0x124D
+/* Intel(R) Ethernet Connection E823-L/X557-AT 10GBASE-T */
+#define ICE_DEV_ID_E823L_10G_BASE_T	0x124E
+/* Intel(R) Ethernet Connection E823-L 1GbE */
+#define ICE_DEV_ID_E823L_1GBE		0x124F
+/* Intel(R) Ethernet Connection E823-L for QSFP */
+#define ICE_DEV_ID_E823L_QSFP		0x151D
 /* Intel(R) Ethernet Controller E810-C for backplane */
 #define ICE_DEV_ID_E810C_BACKPLANE	0x1591
 /* Intel(R) Ethernet Controller E810-C for QSFP */
@@ -13,6 +23,16 @@
 #define ICE_DEV_ID_E810C_SFP		0x1593
 /* Intel(R) Ethernet Controller E810-XXV for SFP */
 #define ICE_DEV_ID_E810_XXV_SFP		0x159B
+/* Intel(R) Ethernet Connection E823-C for backplane */
+#define ICE_DEV_ID_E823C_BACKPLANE	0x188A
+/* Intel(R) Ethernet Connection E823-C for QSFP */
+#define ICE_DEV_ID_E823C_QSFP		0x188B
+/* Intel(R) Ethernet Connection E823-C for SFP */
+#define ICE_DEV_ID_E823C_SFP		0x188C
+/* Intel(R) Ethernet Connection E823-C/X557-AT 10GBASE-T */
+#define ICE_DEV_ID_E823C_10G_BASE_T	0x188D
+/* Intel(R) Ethernet Connection E823-C 1GbE */
+#define ICE_DEV_ID_E823C_SGMII		0x188E
 /* Intel(R) Ethernet Connection E822-C for backplane */
 #define ICE_DEV_ID_E822C_BACKPLANE	0x1890
 /* Intel(R) Ethernet Connection E822-C for QSFP */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 1fa4904de7e6..3eef423226f7 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3553,6 +3553,11 @@ static const struct pci_device_id ice_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810C_QSFP), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810C_SFP), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810_XXV_SFP), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823C_BACKPLANE), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823C_QSFP), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823C_SFP), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823C_10G_BASE_T), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823C_SGMII), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822C_BACKPLANE), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822C_QSFP), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822C_SFP), 0 },
@@ -3562,6 +3567,11 @@ static const struct pci_device_id ice_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822L_SFP), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822L_10G_BASE_T), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822L_SGMII), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823L_BACKPLANE), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823L_SFP), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823L_10G_BASE_T), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823L_1GBE), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823L_QSFP), 0 },
 	/* required last entry */
 	{ 0, }
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 7525ac50742e..75cd4cbb473b 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -289,17 +289,31 @@ enum ice_status ice_init_nvm(struct ice_hw *hw)
 
 	nvm->eetrack = (eetrack_hi << 16) | eetrack_lo;
 
+	switch (hw->device_id) {
 	/* the following devices do not have boot_cfg_tlv yet */
-	if (hw->device_id == ICE_DEV_ID_E822C_BACKPLANE ||
-	    hw->device_id == ICE_DEV_ID_E822C_QSFP ||
-	    hw->device_id == ICE_DEV_ID_E822C_10G_BASE_T ||
-	    hw->device_id == ICE_DEV_ID_E822C_SGMII ||
-	    hw->device_id == ICE_DEV_ID_E822C_SFP ||
-	    hw->device_id == ICE_DEV_ID_E822X_BACKPLANE ||
-	    hw->device_id == ICE_DEV_ID_E822L_SFP ||
-	    hw->device_id == ICE_DEV_ID_E822L_10G_BASE_T ||
-	    hw->device_id == ICE_DEV_ID_E822L_SGMII)
+	case ICE_DEV_ID_E823C_BACKPLANE:
+	case ICE_DEV_ID_E823C_QSFP:
+	case ICE_DEV_ID_E823C_SFP:
+	case ICE_DEV_ID_E823C_10G_BASE_T:
+	case ICE_DEV_ID_E823C_SGMII:
+	case ICE_DEV_ID_E822C_BACKPLANE:
+	case ICE_DEV_ID_E822C_QSFP:
+	case ICE_DEV_ID_E822C_10G_BASE_T:
+	case ICE_DEV_ID_E822C_SGMII:
+	case ICE_DEV_ID_E822C_SFP:
+	case ICE_DEV_ID_E822X_BACKPLANE:
+	case ICE_DEV_ID_E822L_SFP:
+	case ICE_DEV_ID_E822L_10G_BASE_T:
+	case ICE_DEV_ID_E822L_SGMII:
+	case ICE_DEV_ID_E823L_BACKPLANE:
+	case ICE_DEV_ID_E823L_SFP:
+	case ICE_DEV_ID_E823L_10G_BASE_T:
+	case ICE_DEV_ID_E823L_1GBE:
+	case ICE_DEV_ID_E823L_QSFP:
 		return status;
+	default:
+		break;
+	}
 
 	status = ice_get_pfa_module_tlv(hw, &boot_cfg_tlv, &boot_cfg_tlv_len,
 					ICE_SR_BOOT_CFG_PTR);
-- 
2.24.1

