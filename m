Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242F852261C
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 23:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiEJVKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 17:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiEJVKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 17:10:03 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2281B293B6A
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 14:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652217002; x=1683753002;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZXxZnuypUquviZ7wwl6CaNSlga6qs9GxadrTc5G6ZSQ=;
  b=nTs9AcNo8kX902TWTPA6SGKbriM2GsjKq5clRXrpemXbHlfvcokjeFVk
   b4BV7kDLK1lghcNCjSL6NAhA1D+damPrQ7b6NzRNMUU6DOab3lPz4YQeb
   +YutFMXstWQlspy3NNzMnWHbotXTyV4T3BN7HxYugFvARbDhUoaXTggqc
   G4OiSkhzBDjRYyUzZFP9F41iq/eeu6MPHckqWPB2QuUl6Vt0v4NmEZV2R
   OHQLnXPM7pBhD4gqmDvPboJCHYhXPzvoaEY+SxM/sHV4oKUfkaf81EjnC
   5RpdlI/p1DBCPbeqvkec26QmE8+daz6oaOHnhg+LW7tZTaTeJV8RKlCYX
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="267096323"
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="267096323"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 14:10:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="623648429"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 10 May 2022 14:10:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 2/3] igc: Remove unused phy_type enum
Date:   Tue, 10 May 2022 14:06:55 -0700
Message-Id: <20220510210656.2168393-3-anthony.l.nguyen@intel.com>
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

Complete to commit 8e153faf5827 ("igc: Remove unused phy type")
i225 parts have only one PHY. There is no point to use phy_type enum.
Clean up the code accordingly, and get rid of the unused enum lines.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_base.c |  2 --
 drivers/net/ethernet/intel/igc/igc_hw.h   |  7 -------
 drivers/net/ethernet/intel/igc/igc_phy.c  | 12 +++---------
 3 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index f068b66b8025..a15927e77272 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -182,8 +182,6 @@ static s32 igc_init_phy_params_base(struct igc_hw *hw)
 
 	igc_check_for_copper_link(hw);
 
-	phy->type = igc_phy_i225;
-
 out:
 	return ret_val;
 }
diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index b1e72ec5f131..360644f33d5f 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -53,11 +53,6 @@ enum igc_mac_type {
 	igc_num_macs  /* List is 1-based, so subtract 1 for true count. */
 };
 
-enum igc_phy_type {
-	igc_phy_unknown = 0,
-	igc_phy_i225,
-};
-
 enum igc_media_type {
 	igc_media_type_unknown = 0,
 	igc_media_type_copper = 1,
@@ -138,8 +133,6 @@ struct igc_nvm_info {
 struct igc_phy_info {
 	struct igc_phy_operations ops;
 
-	enum igc_phy_type type;
-
 	u32 addr;
 	u32 id;
 	u32 reset_delay_us; /* in usec */
diff --git a/drivers/net/ethernet/intel/igc/igc_phy.c b/drivers/net/ethernet/intel/igc/igc_phy.c
index 6961f65d36b9..2140ad1e8443 100644
--- a/drivers/net/ethernet/intel/igc/igc_phy.c
+++ b/drivers/net/ethernet/intel/igc/igc_phy.c
@@ -148,17 +148,11 @@ void igc_power_down_phy_copper(struct igc_hw *hw)
 s32 igc_check_downshift(struct igc_hw *hw)
 {
 	struct igc_phy_info *phy = &hw->phy;
-	s32 ret_val;
 
-	switch (phy->type) {
-	case igc_phy_i225:
-	default:
-		/* speed downshift not supported */
-		phy->speed_downgraded = false;
-		ret_val = 0;
-	}
+	/* speed downshift not supported */
+	phy->speed_downgraded = false;
 
-	return ret_val;
+	return 0;
 }
 
 /**
-- 
2.35.1

