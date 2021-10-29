Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68817440160
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 19:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhJ2Rpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 13:45:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:63747 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhJ2Rpi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 13:45:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10152"; a="210767093"
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="210767093"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 10:42:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="574760196"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Oct 2021 10:42:40 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 1/3] igc: Remove media type checking on the PHY initialization
Date:   Fri, 29 Oct 2021 10:40:59 -0700
Message-Id: <20211029174101.2970935-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029174101.2970935-1-anthony.l.nguyen@intel.com>
References: <20211029174101.2970935-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

i225 devices only have copper phy media type. There is no point in
checking phy media type during the phy initialization. This patch cleans
up a pointless check.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_base.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index 84f142f5e472..30b1f02cef15 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -158,11 +158,6 @@ static s32 igc_init_phy_params_base(struct igc_hw *hw)
 	struct igc_phy_info *phy = &hw->phy;
 	s32 ret_val = 0;
 
-	if (hw->phy.media_type != igc_media_type_copper) {
-		phy->type = igc_phy_none;
-		goto out;
-	}
-
 	phy->autoneg_mask	= AUTONEG_ADVERTISE_SPEED_DEFAULT_2500;
 	phy->reset_delay_us	= 100;
 
-- 
2.31.1

