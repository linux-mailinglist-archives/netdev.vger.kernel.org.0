Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E842B2765
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgKMVp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:45:58 -0500
Received: from mga06.intel.com ([134.134.136.31]:18968 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726394AbgKMVpL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 16:45:11 -0500
IronPort-SDR: 9wWD/g7+Vh0f0zGnspjnjCEpdNWjYBbq3qubSxPmWt1QPIp4cmDyb4ACY0I5OWU7f/9L19P2+H
 sNPkQrfcx6EA==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="232153158"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="232153158"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 13:44:57 -0800
IronPort-SDR: aOnDqnupz1Kqc/82wbjexjb6FmsnwLyhDsdrbD7iNfdmsyxo23iIAiEpOAYqv//l/+PpwcouE4
 VACZPInSpZjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="532715887"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 13 Nov 2020 13:44:57 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jeb Cramer <jeb.j.cramer@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v3 09/15] ice: Enable Support for FW Override (E82X)
Date:   Fri, 13 Nov 2020 13:44:23 -0800
Message-Id: <20201113214429.2131951-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201113214429.2131951-1-anthony.l.nguyen@intel.com>
References: <20201113214429.2131951-1-anthony.l.nguyen@intel.com>
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

