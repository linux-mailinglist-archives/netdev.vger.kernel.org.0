Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA2C52261B
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 23:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiEJVKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 17:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiEJVKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 17:10:03 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7D6293B6E
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 14:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652217002; x=1683753002;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JZAB70xJ71lxcQV7ylcziFQ0h73DL/5cJEHymtIOupY=;
  b=SwdZc96ES5iRs4RALJ8WwEE4KJ94WGIsIgW6ysocYFN0Qh7d0fNWczyZ
   eTAh4RRwSwJqvVRj0Ra5ahilVVL9KivOcEXy4KGSDWQLPB45CfkYE/Y/E
   SHEcHCvv/7Lcg6op8/I1OgJ3c9XZbPzgAg8xjAdlN1VU6P8ylDedVhi7D
   QscRglKIKIxt1LySj99VSKoY4GHcrK4BVKjiboQLB2snNOKy6L8ihoOrX
   4rybbCGCPbnLtNvLuQMn8C9HdYlkcsm/Kg+JyuUcC3rgboh/pRcf68k4S
   XSHE/us09tHVpLpOCx5DnljrlkBDXMTxtX4gVOD8itUDllfWQD2a/zECL
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="267096327"
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="267096327"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 14:10:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="623648434"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 10 May 2022 14:10:01 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 3/3] igc: Change type of the 'igc_check_downshift' method
Date:   Tue, 10 May 2022 14:06:56 -0700
Message-Id: <20220510210656.2168393-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510210656.2168393-1-anthony.l.nguyen@intel.com>
References: <20220510210656.2168393-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

The 'igc_check_downshift' method always returns 0; there is no need
for a return value so change the type of this method to void.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_phy.c | 6 +-----
 drivers/net/ethernet/intel/igc/igc_phy.h | 2 +-
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_phy.c b/drivers/net/ethernet/intel/igc/igc_phy.c
index 2140ad1e8443..53b77c969c85 100644
--- a/drivers/net/ethernet/intel/igc/igc_phy.c
+++ b/drivers/net/ethernet/intel/igc/igc_phy.c
@@ -141,18 +141,14 @@ void igc_power_down_phy_copper(struct igc_hw *hw)
  * igc_check_downshift - Checks whether a downshift in speed occurred
  * @hw: pointer to the HW structure
  *
- * Success returns 0, Failure returns 1
- *
  * A downshift is detected by querying the PHY link health.
  */
-s32 igc_check_downshift(struct igc_hw *hw)
+void igc_check_downshift(struct igc_hw *hw)
 {
 	struct igc_phy_info *phy = &hw->phy;
 
 	/* speed downshift not supported */
 	phy->speed_downgraded = false;
-
-	return 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/igc/igc_phy.h b/drivers/net/ethernet/intel/igc/igc_phy.h
index 1b031372d206..832a7e359f18 100644
--- a/drivers/net/ethernet/intel/igc/igc_phy.h
+++ b/drivers/net/ethernet/intel/igc/igc_phy.h
@@ -11,7 +11,7 @@ s32 igc_phy_hw_reset(struct igc_hw *hw);
 s32 igc_get_phy_id(struct igc_hw *hw);
 s32 igc_phy_has_link(struct igc_hw *hw, u32 iterations,
 		     u32 usec_interval, bool *success);
-s32 igc_check_downshift(struct igc_hw *hw);
+void igc_check_downshift(struct igc_hw *hw);
 s32 igc_setup_copper_link(struct igc_hw *hw);
 void igc_power_up_phy_copper(struct igc_hw *hw);
 void igc_power_down_phy_copper(struct igc_hw *hw);
-- 
2.35.1

