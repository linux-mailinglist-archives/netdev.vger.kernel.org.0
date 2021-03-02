Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5E232A2CB
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446334AbhCBIdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:33:00 -0500
Received: from mga05.intel.com ([192.55.52.43]:65115 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240262AbhCBBSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 20:18:46 -0500
IronPort-SDR: ACEssgvXcps3ESo418MylkrQWFMc3Wit3GPq+5om41Dg4yeVu22RYSK2Zq4LVrnXK6/hiaDibj
 E1Itm7zOjNfg==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="271650667"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="271650667"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 17:16:55 -0800
IronPort-SDR: HdRnrgj/a/lToZBkv9SNvWc5tXGaZn3OSd8PLODP3ozFiJQMP1S9JaQTs9+L8CvnjhS/ErUxzG
 Jq4/qkr1JGvw==
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="434492460"
Received: from dethomse-mob2.amr.corp.intel.com (HELO pbossart-mobl3.intel.com) ([10.213.173.10])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 17:16:55 -0800
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
To:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] iwlwifi: fix ARCH=i386 compilation warnings
Date:   Mon,  1 Mar 2021 19:16:37 -0600
Message-Id: <20210302011640.1276636-1-pierre-louis.bossart@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An unsigned long variable should rely on '%lu' format strings, not '%zd'

Fixes: a1a6a4cf49ece ("iwlwifi: pnvm: implement reading PNVM from UEFI")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
---
warnings found with v5.12-rc1 and next-20210301

 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index fd070ca5e517..40f2109a097f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -271,12 +271,12 @@ static int iwl_pnvm_get_from_efi(struct iwl_trans *trans,
 	err = efivar_entry_get(pnvm_efivar, NULL, &package_size, package);
 	if (err) {
 		IWL_DEBUG_FW(trans,
-			     "PNVM UEFI variable not found %d (len %zd)\n",
+			     "PNVM UEFI variable not found %d (len %lu)\n",
 			     err, package_size);
 		goto out;
 	}
 
-	IWL_DEBUG_FW(trans, "Read PNVM fro UEFI with size %zd\n", package_size);
+	IWL_DEBUG_FW(trans, "Read PNVM fro UEFI with size %lu\n", package_size);
 
 	*data = kmemdup(package->data, *len, GFP_KERNEL);
 	if (!*data)
-- 
2.25.1

