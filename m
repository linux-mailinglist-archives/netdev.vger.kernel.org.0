Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A1A34D8F2
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhC2USN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:18:13 -0400
Received: from mga18.intel.com ([134.134.136.126]:19968 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231319AbhC2UR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:17:28 -0400
IronPort-SDR: SSALLQ4otDTp1OEdBcp7aTvXVd+1wYuuAWDaJ/pY9MU9eKRHnKlMzEevqWAF7nlrfYX6ctuabW
 e9YzEs4Bd0yg==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="179160820"
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="179160820"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 13:17:26 -0700
IronPort-SDR: HS6DgxQRFwsnayL+AlT13iXrP+2l9vkMqt+5ezX+HNyzASD66gBaLW5eG5wrQ1erBaF37H8Ioo
 Y6nbqkaw00Kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="454700545"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 29 Mar 2021 13:17:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 5/9] ice: fix memory allocation call
Date:   Mon, 29 Mar 2021 13:18:53 -0700
Message-Id: <20210329201857.3509461-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210329201857.3509461-1-anthony.l.nguyen@intel.com>
References: <20210329201857.3509461-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Fix the order of number of array members and member size parameters in a
*calloc() call.

Fixes: b3c3890489f6 ("ice: avoid unnecessary single-member variable-length structs")
Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 3d9475e222cd..a20edf1538a0 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -717,8 +717,8 @@ static enum ice_status ice_cfg_fw_log(struct ice_hw *hw, bool enable)
 
 			if (!data) {
 				data = devm_kcalloc(ice_hw_to_dev(hw),
-						    sizeof(*data),
 						    ICE_AQC_FW_LOG_ID_MAX,
+						    sizeof(*data),
 						    GFP_KERNEL);
 				if (!data)
 					return ICE_ERR_NO_MEMORY;
-- 
2.26.2

