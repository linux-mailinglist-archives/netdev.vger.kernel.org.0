Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062442A3678
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 23:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgKBWY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 17:24:26 -0500
Received: from mga05.intel.com ([192.55.52.43]:16123 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgKBWYU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 17:24:20 -0500
IronPort-SDR: 1j8hhY5OehY0syHpMPnj7QOEt08NkL6rwZp/LwLR1yfeVedtPiH/k6dc8hsERTunyvTwhS+FXp
 yKLdNvY1rvbQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="253670976"
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="253670976"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 14:24:19 -0800
IronPort-SDR: K//06WmE7fwEHRhz220Vwt8K63f+KCqUyRTc29V9XCO7ZPUwUW/hJkHIm9Apm+LFRgSy9E84hy
 knfrnKEDNkiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="305591790"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 02 Nov 2020 14:24:19 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jeb Cramer <jeb.j.cramer@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 10/15] ice: Remove gate to OROM init
Date:   Mon,  2 Nov 2020 14:23:33 -0800
Message-Id: <20201102222338.1442081-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
References: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeb Cramer <jeb.j.cramer@intel.com>

Remove the gate that prevents the OROM and netlist info from being
populated.  The NVM now has the appropriate section for software to
reference the versioning info.

Signed-off-by: Jeb Cramer <jeb.j.cramer@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_nvm.c | 26 ------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 5903a36763de..cd442a5415d1 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -634,32 +634,6 @@ enum ice_status ice_init_nvm(struct ice_hw *hw)
 		return status;
 	}
 
-	switch (hw->device_id) {
-	/* the following devices do not have boot_cfg_tlv yet */
-	case ICE_DEV_ID_E823C_BACKPLANE:
-	case ICE_DEV_ID_E823C_QSFP:
-	case ICE_DEV_ID_E823C_SFP:
-	case ICE_DEV_ID_E823C_10G_BASE_T:
-	case ICE_DEV_ID_E823C_SGMII:
-	case ICE_DEV_ID_E822C_BACKPLANE:
-	case ICE_DEV_ID_E822C_QSFP:
-	case ICE_DEV_ID_E822C_10G_BASE_T:
-	case ICE_DEV_ID_E822C_SGMII:
-	case ICE_DEV_ID_E822C_SFP:
-	case ICE_DEV_ID_E822L_BACKPLANE:
-	case ICE_DEV_ID_E822L_SFP:
-	case ICE_DEV_ID_E822L_10G_BASE_T:
-	case ICE_DEV_ID_E822L_SGMII:
-	case ICE_DEV_ID_E823L_BACKPLANE:
-	case ICE_DEV_ID_E823L_SFP:
-	case ICE_DEV_ID_E823L_10G_BASE_T:
-	case ICE_DEV_ID_E823L_1GBE:
-	case ICE_DEV_ID_E823L_QSFP:
-		return status;
-	default:
-		break;
-	}
-
 	status = ice_get_orom_ver_info(hw);
 	if (status) {
 		ice_debug(hw, ICE_DBG_INIT, "Failed to read Option ROM info.\n");
-- 
2.26.2

