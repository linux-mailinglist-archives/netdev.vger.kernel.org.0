Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5609A38B5D2
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 20:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhETSQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 14:16:54 -0400
Received: from mga17.intel.com ([192.55.52.151]:9099 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232129AbhETSQw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 14:16:52 -0400
IronPort-SDR: N3sNVnwSpU/txTx+khLpmSi63t9IMEax+GZospPtwrA8zSKq0W8Y3xynrfUm5mAvGQD6GbKw5I
 YCcCbyoTSl5w==
X-IronPort-AV: E=McAfee;i="6200,9189,9990"; a="181579452"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="181579452"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 11:15:31 -0700
IronPort-SDR: tLvqDL9IlXxS4uU5mo3vOD9D5tHbK5l2vCSh2eODbgumncJie7m0Ilqp/Ipo6uoNTaD/tOImYp
 wkR89kVtZzPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="440670732"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 20 May 2021 11:15:30 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next v2 1/9] igc: Move igc_xdp_is_enabled()
Date:   Thu, 20 May 2021 11:17:36 -0700
Message-Id: <20210520181744.2217191-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210520181744.2217191-1-anthony.l.nguyen@intel.com>
References: <20210520181744.2217191-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

Move the helper igc_xdp_is_enabled() to igc_xdp.h so it can be reused in
igc_xdp.c by upcoming patches that will introduce AF_XDP zero-copy
support to the driver.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Signed-off-by: Vedang Patel <vedang.patel@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 5 -----
 drivers/net/ethernet/intel/igc/igc_xdp.h  | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 92c0701e2a36..edfe9d492071 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -515,11 +515,6 @@ static int igc_setup_all_rx_resources(struct igc_adapter *adapter)
 	return err;
 }
 
-static bool igc_xdp_is_enabled(struct igc_adapter *adapter)
-{
-	return !!adapter->xdp_prog;
-}
-
 /**
  * igc_configure_rx_ring - Configure a receive ring after Reset
  * @adapter: board private structure
diff --git a/drivers/net/ethernet/intel/igc/igc_xdp.h b/drivers/net/ethernet/intel/igc/igc_xdp.h
index cfecb515b718..412aa369e6ba 100644
--- a/drivers/net/ethernet/intel/igc/igc_xdp.h
+++ b/drivers/net/ethernet/intel/igc/igc_xdp.h
@@ -10,4 +10,9 @@ int igc_xdp_set_prog(struct igc_adapter *adapter, struct bpf_prog *prog,
 int igc_xdp_register_rxq_info(struct igc_ring *ring);
 void igc_xdp_unregister_rxq_info(struct igc_ring *ring);
 
+static inline bool igc_xdp_is_enabled(struct igc_adapter *adapter)
+{
+	return !!adapter->xdp_prog;
+}
+
 #endif /* _IGC_XDP_H_ */
-- 
2.26.2

