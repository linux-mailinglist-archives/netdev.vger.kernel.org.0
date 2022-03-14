Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53C64D8B6B
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243668AbiCNSL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243626AbiCNSLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:11:14 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A923F896
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647281404; x=1678817404;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C6pzZYfoYD8xX3pYgZYQFyj8GYQv0uNq5oT1LTxInKI=;
  b=PkMaJ0qfSWT+cQnKcuB6Ww4CMPAfaN3NFAfB2TTIlD1CbRe1dhhf+av7
   fd+MIKmE1JA1jixtVcPoQ/OkCkKmgtpJ9eg6GXK7ZKdlo7+9Te5nRvCDg
   kAKInlg3kCojBRG8+6Mv3FDStUniP353ppgxHGuCwRd9IfQPpduPou+xY
   5nCWnBNCiGN0/JWmmDL7xGq9Rkx9PmjBRdTOm0yXZ0lF6DMxejyfZVD7e
   GakbB9/SOtVSgE3jBL6PK422mJjZ7ySMFlqzLSuz9KrwOTnC2/RotJakp
   Qq36hyOJhbwN3qcB05aHIfRNIzi9gaxyV3rkh3s3N2eZWkjOHJ8mAHdgg
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="238275397"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="238275397"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 11:10:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="634297688"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2022 11:10:02 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 18/25] ice: make ice_reset_all_vfs void
Date:   Mon, 14 Mar 2022 11:10:09 -0700
Message-Id: <20220314181016.1690595-19-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
References: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_reset_all_vfs function returns true if any VFs were reset, and
false otherwise. However, no callers check the return value.

Drop this return value and make the function void since the callers do
not care about this.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 8 +++-----
 drivers/net/ethernet/intel/ice/ice_vf_lib.h | 5 ++---
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 996d84a3303d..6f9e8383c69b 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -364,7 +364,7 @@ ice_vf_clear_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m)
  *
  * Returns true if any VFs were reset, and false otherwise.
  */
-bool ice_reset_all_vfs(struct ice_pf *pf)
+void ice_reset_all_vfs(struct ice_pf *pf)
 {
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
@@ -373,7 +373,7 @@ bool ice_reset_all_vfs(struct ice_pf *pf)
 
 	/* If we don't have any VFs, then there is nothing to reset */
 	if (!ice_has_vfs(pf))
-		return false;
+		return;
 
 	mutex_lock(&pf->vfs.table_lock);
 
@@ -387,7 +387,7 @@ bool ice_reset_all_vfs(struct ice_pf *pf)
 	/* If VFs have been disabled, there is no need to reset */
 	if (test_and_set_bit(ICE_VF_DIS, pf->state)) {
 		mutex_unlock(&pf->vfs.table_lock);
-		return false;
+		return;
 	}
 
 	/* Begin reset on all VFs at once */
@@ -439,8 +439,6 @@ bool ice_reset_all_vfs(struct ice_pf *pf)
 	clear_bit(ICE_VF_DIS, pf->state);
 
 	mutex_unlock(&pf->vfs.table_lock);
-
-	return true;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index 69c6eba408f3..f7906111aeb3 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -213,7 +213,7 @@ ice_vf_set_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m);
 int
 ice_vf_clear_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m);
 bool ice_reset_vf(struct ice_vf *vf, bool is_vflr);
-bool ice_reset_all_vfs(struct ice_pf *pf);
+void ice_reset_all_vfs(struct ice_pf *pf);
 #else /* CONFIG_PCI_IOV */
 static inline struct ice_vf *ice_get_vf_by_id(struct ice_pf *pf, u16 vf_id)
 {
@@ -275,9 +275,8 @@ static inline bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	return true;
 }
 
-static inline bool ice_reset_all_vfs(struct ice_pf *pf)
+static inline void ice_reset_all_vfs(struct ice_pf *pf)
 {
-	return true;
 }
 #endif /* !CONFIG_PCI_IOV */
 
-- 
2.31.1

