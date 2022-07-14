Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A064575464
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 20:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240011AbiGNSGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 14:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiGNSGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 14:06:14 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC54474DB
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 11:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657821973; x=1689357973;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vPIhBV10naq8rFeaypLmqxGLSuAWAPPtaJvevmWxZQs=;
  b=IoJDpAZAKy7PupqL2CUkvTQPHTCeUViHHU98YQ6qN3PnZ5CCECx63Yn3
   6P0LJpjp9ykhg3Mc3nKBv+u5VeCGGZPlze+6lZ/zJrt5WzagruQCliP/k
   E9rSpOVAoCaguF3CKnW5K5crcKC5auIcd5NPUsN75mcLXzGezW3ykCJ6/
   9EcGood6iZobPZUnGhUoRKhkVS4ze9Sv8i+3fBbi9K4kaY5cVi7o13Jqw
   1wFLgXhhXY5aLolwPMDnx9+Gv6OVP34TShNhruyNuKjzG1DE5rrqDV6wQ
   /YHyQ/Ezoa23IqEuNz1Z5Ak8B/YxuicdLhgDRseD+vvoetXHZB4U1MdNz
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="286336085"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="286336085"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 11:06:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="685666829"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Jul 2022 11:06:11 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Maciej Machnikowski <maciej.machnikowski@intel.com>,
        Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 2/3] ice: Add EXTTS feature to the feature bitmap
Date:   Thu, 14 Jul 2022 11:03:10 -0700
Message-Id: <20220714180311.933648-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714180311.933648-1-anthony.l.nguyen@intel.com>
References: <20220714180311.933648-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

External time stamp sources are supported only on certain devices. Enforce
the right support matrix by adding the ICE_F_PTP_EXTTS bit to the feature
bitmap set.

Co-developed-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h     |  1 +
 drivers/net/ethernet/intel/ice/ice_lib.c |  1 +
 drivers/net/ethernet/intel/ice/ice_ptp.c | 18 +++++++++++++-----
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 70ed8afdbf2b..2bdd97b73108 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -181,6 +181,7 @@
 
 enum ice_feature {
 	ICE_F_DSCP,
+	ICE_F_PTP_EXTTS,
 	ICE_F_SMA_CTRL,
 	ICE_F_GNSS,
 	ICE_F_MAX
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index a6c4be5e5566..bc357dfae306 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -4182,6 +4182,7 @@ void ice_init_feature_support(struct ice_pf *pf)
 	case ICE_DEV_ID_E810C_QSFP:
 	case ICE_DEV_ID_E810C_SFP:
 		ice_set_feature_support(pf, ICE_F_DSCP);
+		ice_set_feature_support(pf, ICE_F_PTP_EXTTS);
 		if (ice_is_e810t(&pf->hw)) {
 			ice_set_feature_support(pf, ICE_F_SMA_CTRL);
 			if (ice_gnss_is_gps_present(&pf->hw))
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index ef9344ef0d8e..29c7a0ccb3c4 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1900,9 +1900,12 @@ ice_ptp_setup_pins_e810t(struct ice_pf *pf, struct ptp_clock_info *info)
 	}
 
 	info->n_per_out = N_PER_OUT_E810T;
-	info->n_ext_ts = N_EXT_TS_E810;
-	info->n_pins = NUM_PTP_PINS_E810T;
-	info->verify = ice_verify_pin_e810t;
+
+	if (ice_is_feature_supported(pf, ICE_F_PTP_EXTTS)) {
+		info->n_ext_ts = N_EXT_TS_E810;
+		info->n_pins = NUM_PTP_PINS_E810T;
+		info->verify = ice_verify_pin_e810t;
+	}
 
 	/* Complete setup of the SMA pins */
 	ice_ptp_setup_sma_pins_e810t(pf, info);
@@ -1910,11 +1913,16 @@ ice_ptp_setup_pins_e810t(struct ice_pf *pf, struct ptp_clock_info *info)
 
 /**
  * ice_ptp_setup_pins_e810 - Setup PTP pins in sysfs
+ * @pf: pointer to the PF instance
  * @info: PTP clock capabilities
  */
-static void ice_ptp_setup_pins_e810(struct ptp_clock_info *info)
+static void ice_ptp_setup_pins_e810(struct ice_pf *pf, struct ptp_clock_info *info)
 {
 	info->n_per_out = N_PER_OUT_E810;
+
+	if (!ice_is_feature_supported(pf, ICE_F_PTP_EXTTS))
+		return;
+
 	info->n_ext_ts = N_EXT_TS_E810;
 }
 
@@ -1956,7 +1964,7 @@ ice_ptp_set_funcs_e810(struct ice_pf *pf, struct ptp_clock_info *info)
 	if (ice_is_e810t(&pf->hw))
 		ice_ptp_setup_pins_e810t(pf, info);
 	else
-		ice_ptp_setup_pins_e810(info);
+		ice_ptp_setup_pins_e810(pf, info);
 }
 
 /**
-- 
2.35.1

