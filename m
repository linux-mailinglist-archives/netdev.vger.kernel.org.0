Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACAA3D053A
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 01:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234507AbhGTWjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 18:39:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:50230 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233710AbhGTWhd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 18:37:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="211341484"
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="211341484"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 16:17:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="415407157"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 20 Jul 2021 16:17:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 11/12] igc: Set QBVCYCLET_S to 0 for TSN Basic Scheduling
Date:   Tue, 20 Jul 2021 16:21:00 -0700
Message-Id: <20210720232101.3087589-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
References: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

According to datasheet section 8.12.19, when there's no TSN offloading
Shadow_QbvCycle bit[29:0] must be set to zero for basic scheduling.

Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_tsn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 174103c4bea6..4dbbb8a32ce9 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -52,7 +52,7 @@ static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 		wr32(IGC_ENDQT(i), NSEC_PER_SEC);
 	}
 
-	wr32(IGC_QBVCYCLET_S, NSEC_PER_SEC);
+	wr32(IGC_QBVCYCLET_S, 0);
 	wr32(IGC_QBVCYCLET, NSEC_PER_SEC);
 
 	adapter->flags &= ~IGC_FLAG_TSN_QBV_ENABLED;
-- 
2.26.2

