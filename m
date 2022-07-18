Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D370157892B
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 20:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbiGRSE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 14:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234837AbiGRSEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 14:04:21 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3868D2DAAD
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 11:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658167460; x=1689703460;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sQftX9eKIE6cGK87Nt2PblBKDfc2zDMqzTAIW8idPVE=;
  b=gUhGmpQZI6FTFaIIWiXpwfORvqaLEI4fUudlbaGAj8UBdo1MNa5fO7Bd
   fcT1xYOnZrWxuUwO0wdNUTavLKNirJzzFkF50my7hoEKXRVvKoHeguTrb
   5glTWo6w3nvhCMknO61N/1DqelMPlXZgurmWgDz5aD2DF31/Dg2T4vhzR
   Z/0Z4NEGrE26s8Y84mb0JIU82f88MB4IjeXsfzdMeCAVOxidWSUYChzQh
   55Asg5hjm8HHjA6DR5FTz6EzNwnWOKIGhKyP+IPB79UTU41a6EQxGtto0
   dGHdA+prLwIsnqb43rD3jPoWGLCM7WNuGiiCnvT/+CzwSuXJq6DwtTAxG
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="287434735"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="287434735"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 11:04:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="655392519"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 18 Jul 2022 11:04:11 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 3/3] igc: Remove forced_speed_duplex value
Date:   Mon, 18 Jul 2022 11:01:09 -0700
Message-Id: <20220718180109.4114540-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220718180109.4114540-1-anthony.l.nguyen@intel.com>
References: <20220718180109.4114540-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

u8 forced_speed_duplex from value from igc_mac_info struct is not used.
This patch comes to tidy up the driver code.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_hw.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index 360644f33d5f..88680e3d613d 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -89,8 +89,6 @@ struct igc_mac_info {
 	u32 mta_shadow[MAX_MTA_REG];
 	u16 rar_entry_count;
 
-	u8 forced_speed_duplex;
-
 	bool asf_firmware_present;
 	bool arc_subsystem_valid;
 
-- 
2.35.1

