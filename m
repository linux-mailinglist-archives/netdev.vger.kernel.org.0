Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058902B2709
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgKMVfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:35:13 -0500
Received: from mga06.intel.com ([134.134.136.31]:18348 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbgKMVew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 16:34:52 -0500
IronPort-SDR: yzY4nnXuC4ZibYlasp5pArRFKp8B8/PDNAunNV2bsbNCNcZeGSEdJ+n9CrQySyQRLqcqRS0Gaz
 ZkdW1i3QRElg==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="232152358"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="232152358"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 13:34:40 -0800
IronPort-SDR: hhdx7FeG5MPK2WWT038bFedDhQ/g41eFKQYwhYSsXbwtVjxFqweQHY6y4oexo9jHFQYzeUk1bf
 +li1CO2vZmGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="366861613"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Nov 2020 13:34:39 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.neti, kuba@kernel.org
Cc:     Jeb Cramer <jeb.j.cramer@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 09/15] ice: Enable Support for FW Override (E82X)
Date:   Fri, 13 Nov 2020 13:34:01 -0800
Message-Id: <20201113213407.2131340-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201113213407.2131340-1-anthony.l.nguyen@intel.com>
References: <20201113213407.2131340-1-anthony.l.nguyen@intel.com>
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
index 3c600808d0da..59459b6ccb9c 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -4261,10 +4261,6 @@ ice_sched_query_elem(struct ice_hw *hw, u32 node_teid,
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

