Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EBA30E8CD
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbhBDApn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:45:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:40026 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234544AbhBDApa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:45:30 -0500
IronPort-SDR: gBq5+ztzBvabFFcHnHfrsXbuWJjpol+3pTi7MNVdCITmbo8DPpiNAFe4jB60dwDThldR3hPRHJ
 FRjIocDsmLvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="177638238"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="177638238"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:42:15 -0800
IronPort-SDR: vhTz0YvzWnZiWNuupDZkU8emnOjqFn/9sz6A6c/IUzqypF6MYg1vQuS1pVyqioYUlDBGAyNzuJ
 YjBoW4cW6RHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="579687522"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2021 16:42:14 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Kaixu Xia <kaixuxia@tencent.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tosk Robot <tencent_os_robot@tencent.com>
Subject: [PATCH net-next 14/15] e1000e: remove the redundant value assignment in e1000_update_nvm_checksum_spt
Date:   Wed,  3 Feb 2021 16:42:58 -0800
Message-Id: <20210204004259.3662059-15-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
References: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Both of the statements are value assignment of the variable act_offset.
The first value assignment is overwritten by the second and is useless.
Remove it.

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 6fb46682b058..0ac8d79a7987 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -3886,13 +3886,6 @@ static s32 e1000_update_nvm_checksum_spt(struct e1000_hw *hw)
 	if (ret_val)
 		goto release;
 
-	/* And invalidate the previously valid segment by setting
-	 * its signature word (0x13) high_byte to 0b. This can be
-	 * done without an erase because flash erase sets all bits
-	 * to 1's. We can write 1's to 0's without an erase
-	 */
-	act_offset = (old_bank_offset + E1000_ICH_NVM_SIG_WORD) * 2 + 1;
-
 	/* offset in words but we read dword */
 	act_offset = old_bank_offset + E1000_ICH_NVM_SIG_WORD - 1;
 	ret_val = e1000_read_flash_dword_ich8lan(hw, act_offset, &dword);
-- 
2.26.2

