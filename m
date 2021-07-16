Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96983CBE61
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 23:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235782AbhGPVYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 17:24:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:9335 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235198AbhGPVYT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 17:24:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10047"; a="197980601"
X-IronPort-AV: E=Sophos;i="5.84,246,1620716400"; 
   d="scan'208";a="197980601"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 14:21:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,246,1620716400"; 
   d="scan'208";a="574434572"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 16 Jul 2021 14:21:23 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 3/5] igc: Allow for Flex Filters to be installed
Date:   Fri, 16 Jul 2021 14:24:25 -0700
Message-Id: <20210716212427.821834-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Allows Flex Filters to be installed.

The previous restriction to the types of filters that can be installed
can now be lifted.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 3d46eff87638..5a7b27b2a95c 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1300,12 +1300,6 @@ static int igc_ethtool_add_nfc_rule(struct igc_adapter *adapter,
 		return -EOPNOTSUPP;
 	}
 
-	if ((fsp->flow_type & FLOW_EXT) &&
-	    fsp->m_ext.vlan_tci != htons(VLAN_PRIO_MASK)) {
-		netdev_dbg(netdev, "VLAN mask not supported\n");
-		return -EOPNOTSUPP;
-	}
-
 	if (fsp->ring_cookie >= adapter->num_rx_queues) {
 		netdev_dbg(netdev, "Invalid action\n");
 		return -EINVAL;
-- 
2.26.2

