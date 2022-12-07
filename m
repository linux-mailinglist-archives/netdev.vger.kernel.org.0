Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434F2646300
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 22:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiLGVJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 16:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiLGVJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 16:09:44 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614C269305
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 13:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670447383; x=1701983383;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LHDhfKAhJWa1YeCsQLIXrbGz6ph4d9Vrhc7V8yMGRj0=;
  b=U8VR94ONbKiswazpFpm2BD5oQyz8qJ/XcfTNzVUzSycMoeVe2tRfp9Fl
   2X1KC8jzSAO8JKISgiAMBV5Tub/DW7FFsVXZUXW2yjj4KkGR7vxLHSka+
   7qCvl8ZrAU89qSBUbnHdxnMenUWOyNvuI1ntHFQmqhiEzzdJvYHEXbmY1
   ERX99XR1sfcSRCy/bO7nkJtj6CzneV4dv0FUgs1DM3jsdNEuWuZ1qUSyS
   r4B4UZy71XImmrWKMbdORmAia/iJOFT573FfHsc4jRn+07hKwKt7zLWKA
   /o6HDgH7WHw217rSB501Sy1Dtn4VwIwzFmWaDvnccy29ZW7Qa+BSyUyhZ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="296697029"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="296697029"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 13:09:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="677508806"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="677508806"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 07 Dec 2022 13:09:41 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sergey Temerkhanov <sergey.temerkhanov@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, leon@kernel.org,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next v2 01/15] ice: Use more generic names for ice_ptp_tx fields
Date:   Wed,  7 Dec 2022 13:09:23 -0800
Message-Id: <20221207210937.1099650-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221207210937.1099650-1-anthony.l.nguyen@intel.com>
References: <20221207210937.1099650-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Temerkhanov <sergey.temerkhanov@intel.com>

Some supported devices have per-port timestamp memory blocks while
others have shared ones within quads. Rename the struct ice_ptp_tx
fields to reflect the block entities it works with

Signed-off-by: Sergey Temerkhanov <sergey.temerkhanov@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 26 ++++++++++++------------
 drivers/net/ethernet/intel/ice/ice_ptp.h | 11 +++++-----
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 13e75279e71c..f41f4674cadd 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -651,14 +651,14 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 
 	for_each_set_bit(idx, tx->in_use, tx->len) {
 		struct skb_shared_hwtstamps shhwtstamps = {};
-		u8 phy_idx = idx + tx->quad_offset;
+		u8 phy_idx = idx + tx->offset;
 		u64 raw_tstamp, tstamp;
 		struct sk_buff *skb;
 		int err;
 
 		ice_trace(tx_tstamp_fw_req, tx->tstamps[idx].skb, idx);
 
-		err = ice_read_phy_tstamp(&pf->hw, tx->quad, phy_idx,
+		err = ice_read_phy_tstamp(&pf->hw, tx->block, phy_idx,
 					  &raw_tstamp);
 		if (err)
 			continue;
@@ -713,7 +713,7 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
  * @tx: Tx tracking structure to initialize
  *
  * Assumes that the length has already been initialized. Do not call directly,
- * use the ice_ptp_init_tx_e822 or ice_ptp_init_tx_e810 instead.
+ * use the ice_ptp_init_tx_* instead.
  */
 static int
 ice_ptp_alloc_tx_tracker(struct ice_ptp_tx *tx)
@@ -747,7 +747,7 @@ ice_ptp_flush_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 	u8 idx;
 
 	for (idx = 0; idx < tx->len; idx++) {
-		u8 phy_idx = idx + tx->quad_offset;
+		u8 phy_idx = idx + tx->offset;
 
 		spin_lock(&tx->lock);
 		if (tx->tstamps[idx].skb) {
@@ -760,7 +760,7 @@ ice_ptp_flush_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 
 		/* Clear any potential residual timestamp in the PHY block */
 		if (!pf->hw.reset_ongoing)
-			ice_clear_phy_tstamp(&pf->hw, tx->quad, phy_idx);
+			ice_clear_phy_tstamp(&pf->hw, tx->block, phy_idx);
 	}
 }
 
@@ -801,9 +801,9 @@ ice_ptp_release_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 static int
 ice_ptp_init_tx_e822(struct ice_pf *pf, struct ice_ptp_tx *tx, u8 port)
 {
-	tx->quad = port / ICE_PORTS_PER_QUAD;
-	tx->quad_offset = (port % ICE_PORTS_PER_QUAD) * INDEX_PER_PORT;
-	tx->len = INDEX_PER_PORT;
+	tx->block = port / ICE_PORTS_PER_QUAD;
+	tx->offset = (port % ICE_PORTS_PER_QUAD) * INDEX_PER_PORT_E822;
+	tx->len = INDEX_PER_PORT_E822;
 
 	return ice_ptp_alloc_tx_tracker(tx);
 }
@@ -819,9 +819,9 @@ ice_ptp_init_tx_e822(struct ice_pf *pf, struct ice_ptp_tx *tx, u8 port)
 static int
 ice_ptp_init_tx_e810(struct ice_pf *pf, struct ice_ptp_tx *tx)
 {
-	tx->quad = pf->hw.port_info->lport;
-	tx->quad_offset = 0;
-	tx->len = INDEX_PER_QUAD;
+	tx->block = pf->hw.port_info->lport;
+	tx->offset = 0;
+	tx->len = INDEX_PER_PORT_E810;
 
 	return ice_ptp_alloc_tx_tracker(tx);
 }
@@ -854,7 +854,7 @@ static void ice_ptp_tx_tstamp_cleanup(struct ice_pf *pf, struct ice_ptp_tx *tx)
 			continue;
 
 		/* Read tstamp to be able to use this register again */
-		ice_read_phy_tstamp(hw, tx->quad, idx + tx->quad_offset,
+		ice_read_phy_tstamp(hw, tx->block, idx + tx->offset,
 				    &raw_tstamp);
 
 		spin_lock(&tx->lock);
@@ -2359,7 +2359,7 @@ s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
 	if (idx >= tx->len)
 		return -1;
 	else
-		return idx + tx->quad_offset;
+		return idx + tx->offset;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 028349295b71..ca0fbfd71ed2 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -108,8 +108,8 @@ struct ice_tx_tstamp {
  * @lock: lock to prevent concurrent write to in_use bitmap
  * @tstamps: array of len to store outstanding requests
  * @in_use: bitmap of len to indicate which slots are in use
- * @quad: which quad the timestamps are captured in
- * @quad_offset: offset into timestamp block of the quad to get the real index
+ * @block: which memory block (quad or port) the timestamps are captured in
+ * @offset: offset into timestamp block to get the real index
  * @len: length of the tstamps and in_use fields.
  * @init: if true, the tracker is initialized;
  * @calibrating: if true, the PHY is calibrating the Tx offset. During this
@@ -119,8 +119,8 @@ struct ice_ptp_tx {
 	spinlock_t lock; /* lock protecting in_use bitmap */
 	struct ice_tx_tstamp *tstamps;
 	unsigned long *in_use;
-	u8 quad;
-	u8 quad_offset;
+	u8 block;
+	u8 offset;
 	u8 len;
 	u8 init;
 	u8 calibrating;
@@ -128,7 +128,8 @@ struct ice_ptp_tx {
 
 /* Quad and port information for initializing timestamp blocks */
 #define INDEX_PER_QUAD			64
-#define INDEX_PER_PORT			(INDEX_PER_QUAD / ICE_PORTS_PER_QUAD)
+#define INDEX_PER_PORT_E822		16
+#define INDEX_PER_PORT_E810		64
 
 /**
  * struct ice_ptp_port - data used to initialize an external port for PTP
-- 
2.35.1

