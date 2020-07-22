Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F0022A16B
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 23:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733040AbgGVVcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 17:32:12 -0400
Received: from mga18.intel.com ([134.134.136.126]:4542 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733016AbgGVVcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 17:32:03 -0400
IronPort-SDR: uQK1ppAGB/U9gD6yNgo64OYHB0fBPIS/Dq5sZEkLL3zpq/YT8bBI5YIQnDA3FIia+Q9+Akdmwh
 9lcOBeIXumvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="137926761"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="137926761"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 14:32:00 -0700
IronPort-SDR: KwNMu6wfUdtqQ7lfAWzFcfoGNeOOQZl+sNaseVwj5j8fMGGifDBDKQXBNghbyA3RhV4Xsr5A5f
 mSv/e80yqkIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="284361367"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 22 Jul 2020 14:32:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 8/8] igc: Fix static checker warning
Date:   Wed, 22 Jul 2020 14:31:50 -0700
Message-Id: <20200722213150.383393-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200722213150.383393-1-anthony.l.nguyen@intel.com>
References: <20200722213150.383393-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

drivers/net/ethernet/intel/igc/igc_mac.c:424 igc_check_for_copper_link()
error: uninitialized symbol 'link'.
This patch come to fix this warning and initialize the 'link' symbol.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 707abf069548 ("igc: Add initial LTR support")
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index 674b8ad21fea..09cd0ec7ee87 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -355,8 +355,8 @@ void igc_rar_set(struct igc_hw *hw, u8 *addr, u32 index)
 s32 igc_check_for_copper_link(struct igc_hw *hw)
 {
 	struct igc_mac_info *mac = &hw->mac;
+	bool link = false;
 	s32 ret_val;
-	bool link;
 
 	/* We only want to go out to the PHY registers to see if Auto-Neg
 	 * has completed and/or if our link status has changed.  The
-- 
2.26.2

