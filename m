Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B244DA54A
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 23:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352207AbiCOWXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 18:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352191AbiCOWXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 18:23:14 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDE55C671
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 15:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647382922; x=1678918922;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C6pzZYfoYD8xX3pYgZYQFyj8GYQv0uNq5oT1LTxInKI=;
  b=BOW7xO6HYcj09WSzRBNXG8xsOGjJ6ohxk/gPo0PzoE4ENf+yQai1ZKmy
   kU88T5j8uJjISGcrno69S31ANbyyclx7/Y9sFN/mHsl0OOJezyKqEkTGy
   LuMhOlU2NwsfqvCjLtnxqamh0R8yhIMCn9JKCWf04ovYQJDlT5zGbsbOZ
   fIlxoSNAs+LU0xCi2WGOhkTAXwnRT0ORtIOm2O/NpRAYTjIO009DmJN0W
   FDo3XhpzrCzLLkC9U2zbVjbUDVbnMEKUtNN3DlnWhiNyxC1dHzfaaLLbo
   OSElmyTZPLMkD46ogUrRQ2pncPWFtV2rury9szJE1cbSAzAj3LIzKQr6i
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="255264554"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="255264554"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 15:22:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="690362224"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 15 Mar 2022 15:21:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 07/14] ice: make ice_reset_all_vfs void
Date:   Tue, 15 Mar 2022 15:22:13 -0700
Message-Id: <20220315222220.2925324-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220315222220.2925324-1-anthony.l.nguyen@intel.com>
References: <20220315222220.2925324-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

