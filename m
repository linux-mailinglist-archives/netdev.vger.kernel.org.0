Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3C92D4CA1
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 22:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388001AbgLIVPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 16:15:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:24062 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387956AbgLIVPL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 16:15:11 -0500
IronPort-SDR: kLHZDpzo3GlEeCbDpVCb3VLtulPd2ZLXZsqrIzZsDRyma19jO3QsDTVByd1/a3ffQpTGT1j23F
 SI8CgVlzDTRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="170641631"
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="170641631"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 13:13:54 -0800
IronPort-SDR: 3bUWUKCBeJwrwv31+nBeMWBOeQSEihbjM45tI0HU1gbA+LCVVIkFBvHRYjYj02vTpoGB13xZjo
 NBzD/eg1jRmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="408228648"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 09 Dec 2020 13:13:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jeb Cramer <jeb.j.cramer@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v4 3/9] ice: Enable Support for FW Override (E82X)
Date:   Wed,  9 Dec 2020 13:13:06 -0800
Message-Id: <20201209211312.3850588-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201209211312.3850588-1-anthony.l.nguyen@intel.com>
References: <20201209211312.3850588-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeb Cramer <jeb.j.cramer@intel.com>

The driver is able to override the firmware when it comes to supporting
a more lenient link mode.  This feature was limited to E810 devices.  It
is now extended to E82X devices.

Signed-off-by: Jeb Cramer <jeb.j.cramer@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index ab9d7ae93706..18720c6fbfd9 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -4262,10 +4262,6 @@ ice_sched_query_elem(struct ice_hw *hw, u32 node_teid,
  */
 bool ice_fw_supports_link_override(struct ice_hw *hw)
 {
-	/* Currently, only supported for E810 devices */
-	if (hw->mac_type != ICE_MAC_E810)
-		return false;
-
 	if (hw->api_maj_ver == ICE_FW_API_LINK_OVERRIDE_MAJ) {
 		if (hw->api_min_ver > ICE_FW_API_LINK_OVERRIDE_MIN)
 			return true;
-- 
2.26.2

