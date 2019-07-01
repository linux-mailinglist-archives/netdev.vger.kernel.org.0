Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14CCD5C116
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfGAQ1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:27:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54314 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727387AbfGAQ1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:27:03 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hhz8r-000310-TS; Mon, 01 Jul 2019 16:26:58 +0000
From:   Colin King <colin.king@canonical.com>
To:     Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.or, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] iwlwifi: mvm: fix comparison of u32 variable with less than zero
Date:   Mon,  1 Jul 2019 17:26:57 +0100
Message-Id: <20190701162657.15174-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The comparison of the u32 variable wgds_tbl_idx with less than zero is
always going to be false because it is unsigned.  Fix this by making
wgds_tbl_idx a plain signed int.

Addresses-Coverity: ("Unsigned compared against 0")
Fixes: 4fd445a2c855 ("iwlwifi: mvm: Add log information about SAR status")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index 719f793b3487..a9bb43a2f27b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -620,7 +620,7 @@ void iwl_mvm_rx_chub_update_mcc(struct iwl_mvm *mvm,
 	enum iwl_mcc_source src;
 	char mcc[3];
 	struct ieee80211_regdomain *regd;
-	u32 wgds_tbl_idx;
+	int wgds_tbl_idx;
 
 	lockdep_assert_held(&mvm->mutex);
 
-- 
2.20.1

