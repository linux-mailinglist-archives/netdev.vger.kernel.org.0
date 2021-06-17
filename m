Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41833ABA24
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 18:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhFQRBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 13:01:34 -0400
Received: from mga18.intel.com ([134.134.136.126]:63640 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231572AbhFQRBS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 13:01:18 -0400
IronPort-SDR: NUrFZ3LqOE6XJq5XLGZX4/xS9lE3s/aR0DnLc1Mi/WXJAFZLdrdxWl2icV2BlojCg9vxAbV46q
 r69oEjFBBrpg==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="193723046"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="193723046"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 09:59:05 -0700
IronPort-SDR: lDx5BR/7xNZ3xdokQDKu7nHVMihEXtXqU3RbAVd2DJaDsiLjMkx2Mpl+D7apFmKkCiIBGSc7bk
 0nUaT3rG0nWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="404706796"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 17 Jun 2021 09:59:04 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 2/8] ice: mark PTYPE 2 as reserved
Date:   Thu, 17 Jun 2021 10:01:39 -0700
Message-Id: <20210617170145.4092904-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210617170145.4092904-1-anthony.l.nguyen@intel.com>
References: <20210617170145.4092904-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The entry for PTYPE 2 in the ice_ptype_lkup table incorrectly states
that this is an L2 packet with no payload. According to the datasheet,
this PTYPE is actually unused and reserved.

Fix the lookup entry to indicate this is an unused entry that is
reserved.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index fc3b56c13786..4238ab0433ee 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -630,7 +630,7 @@ static const struct ice_rx_ptype_decoded ice_ptype_lkup[] = {
 	/* L2 Packet types */
 	ICE_PTT_UNUSED_ENTRY(0),
 	ICE_PTT(1, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),
-	ICE_PTT(2, L2, NONE, NOF, NONE, NONE, NOF, NONE, NONE),
+	ICE_PTT_UNUSED_ENTRY(2),
 	ICE_PTT_UNUSED_ENTRY(3),
 	ICE_PTT_UNUSED_ENTRY(4),
 	ICE_PTT_UNUSED_ENTRY(5),
-- 
2.26.2

