Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9AF1B1A40
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgDTXne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 19:43:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:14658 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726919AbgDTXn1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 19:43:27 -0400
IronPort-SDR: gn4clPodjew30V6UpCANnAbk+CqDW+nrgOfkCix/p2f/xQHtyT3h7Z8ZUiSEAyC/UGmBzPhpcR
 l7JbvEDvWgTA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 16:43:17 -0700
IronPort-SDR: jlXAoNXTzmb3lRUvI+8iwsscPNSKFD3qQSNFEx69FPtWr3er7iDotGYioTFxWml3ovgkjOYt+y
 ZUvwu+iKrCQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="300428873"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Apr 2020 16:43:17 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/13] igc: Remove '\n' from log messages in igc_nvm.c
Date:   Mon, 20 Apr 2020 16:43:10 -0700
Message-Id: <20200420234313.2184282-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420234313.2184282-1-jeffrey.t.kirsher@intel.com>
References: <20200420234313.2184282-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

To keep log strings in igc_nvm.c consistent with the rest of the driver
code, this patch removes the '\n' character at the end. The newline
character is automatically added by netdev_dbg() so there is no changes
in the output.

Note: hw_dbg() is a macro that expands to netdev_dbg().

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_nvm.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_nvm.c b/drivers/net/ethernet/intel/igc/igc_nvm.c
index 58f81aba0144..ac01330a8232 100644
--- a/drivers/net/ethernet/intel/igc/igc_nvm.c
+++ b/drivers/net/ethernet/intel/igc/igc_nvm.c
@@ -63,7 +63,7 @@ s32 igc_acquire_nvm(struct igc_hw *hw)
 	if (!timeout) {
 		eecd &= ~IGC_EECD_REQ;
 		wr32(IGC_EECD, eecd);
-		hw_dbg("Could not acquire NVM grant\n");
+		hw_dbg("Could not acquire NVM grant");
 		ret_val = -IGC_ERR_NVM;
 	}
 
@@ -105,7 +105,7 @@ s32 igc_read_nvm_eerd(struct igc_hw *hw, u16 offset, u16 words, u16 *data)
 	 */
 	if (offset >= nvm->word_size || (words > (nvm->word_size - offset)) ||
 	    words == 0) {
-		hw_dbg("nvm parameter(s) out of bounds\n");
+		hw_dbg("nvm parameter(s) out of bounds");
 		ret_val = -IGC_ERR_NVM;
 		goto out;
 	}
@@ -167,14 +167,14 @@ s32 igc_validate_nvm_checksum(struct igc_hw *hw)
 	for (i = 0; i < (NVM_CHECKSUM_REG + 1); i++) {
 		ret_val = hw->nvm.ops.read(hw, i, 1, &nvm_data);
 		if (ret_val) {
-			hw_dbg("NVM Read Error\n");
+			hw_dbg("NVM Read Error");
 			goto out;
 		}
 		checksum += nvm_data;
 	}
 
 	if (checksum != (u16)NVM_SUM) {
-		hw_dbg("NVM Checksum Invalid\n");
+		hw_dbg("NVM Checksum Invalid");
 		ret_val = -IGC_ERR_NVM;
 		goto out;
 	}
@@ -200,7 +200,7 @@ s32 igc_update_nvm_checksum(struct igc_hw *hw)
 	for (i = 0; i < NVM_CHECKSUM_REG; i++) {
 		ret_val = hw->nvm.ops.read(hw, i, 1, &nvm_data);
 		if (ret_val) {
-			hw_dbg("NVM Read Error while updating checksum.\n");
+			hw_dbg("NVM Read Error while updating checksum");
 			goto out;
 		}
 		checksum += nvm_data;
@@ -208,7 +208,7 @@ s32 igc_update_nvm_checksum(struct igc_hw *hw)
 	checksum = (u16)NVM_SUM - checksum;
 	ret_val = hw->nvm.ops.write(hw, NVM_CHECKSUM_REG, 1, &checksum);
 	if (ret_val)
-		hw_dbg("NVM Write Error while updating checksum.\n");
+		hw_dbg("NVM Write Error while updating checksum");
 
 out:
 	return ret_val;
-- 
2.25.3

