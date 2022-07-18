Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6472557892A
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 20:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbiGRSEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 14:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbiGRSEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 14:04:20 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49B52CE0F
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 11:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658167458; x=1689703458;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BEQg0ya1X531uk5id/UNkM5Ogd6VxgfNVHlpx9pJ+KE=;
  b=S4LX/7DTTEl7YqLPw6BSw7MwBO/XD67EN00Ec8cpZxBGRMOl5JlvXMA7
   +mR4Cu413s1ouazZm0u40Nti0z72nNqJDt6F3fT5NurUxjZRDjKuXEtAv
   On/QFRVVe7fQbvFoFcviwjSRmoZRxQG45qBmKGDHQ/5n1xwN/Xc9oZGY4
   HfJm6CT3hEVTQCLglaIph+rFHmSY4LIt0MpBaePk5Qt6tqi6g20wHspOJ
   eZO+y1UXfHRk8UFkFZ4T5+LmA2sYMY0QvvfA2doPWaIH7cde0Rh4Crsdy
   8Gq8PUKSNjVHSgO4uYbU2R6+MwvqeneIee7YnbIVhgO+1Yf30jhvqXs06
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="287434732"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="287434732"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 11:04:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="655392516"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 18 Jul 2022 11:04:10 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 2/3] igc: Remove MSI-X PBA Clear register
Date:   Mon, 18 Jul 2022 11:01:08 -0700
Message-Id: <20220718180109.4114540-3-anthony.l.nguyen@intel.com>
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

MSI-X PBA Clear register is not used. This patch comes to tidy up the
driver code.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_regs.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index e197a33d93a0..d06018150764 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -59,9 +59,6 @@
 #define IGC_IVAR_MISC		0x01740  /* IVAR for "other" causes - RW */
 #define IGC_GPIE		0x01514  /* General Purpose Intr Enable - RW */
 
-/* MSI-X Table Register Descriptions */
-#define IGC_PBACL		0x05B68  /* MSIx PBA Clear - R/W 1 to clear */
-
 /* RSS registers */
 #define IGC_MRQC		0x05818 /* Multiple Receive Control - RW */
 
-- 
2.35.1

