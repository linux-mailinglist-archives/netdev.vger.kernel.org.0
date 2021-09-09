Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8670405067
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351121AbhIIM1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:27:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350593AbhIIMWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:22:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 903ED61AEC;
        Thu,  9 Sep 2021 11:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188259;
        bh=X+FLbjA7aUy6pDS2PfreaYIzs44DNysFpu7NLz6bn04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gr2uoiNj9ogFWgjCFdHFHh4s7E2Z/nN2lz9Mz4rYq+FvqXb68N6n6+7ikqyJIwdxd
         QkgG5ds90N1TEq3yS4xaObVHco0OfAUMCqQsSg7VwEOQ7ws+4iq7v7aQlr7cjTjuq1
         4MycI/0DvvK+aapcbhDFTTpnoE8hjaDosaw5EuxSsTj6PzUMRbZIF7sQLDe+OGTVKb
         PUIxITp44mpTgAqLsW5zMzC0F3rLIls2/NsroHU3YzrC9bYkZLjBD+cmixcvL3nkHZ
         rui3q59Q09O2PEcqyFQyB4MoxdVw/+QzD4ZghCs1zJvv/BAk+6boFf8PkDJ/wIPiQO
         dbhn+qVMIYeqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 205/219] iwlwifi: mvm: Fix umac scan request probe parameters
Date:   Thu,  9 Sep 2021 07:46:21 -0400
Message-Id: <20210909114635.143983-205-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 35fc5feca7b24b97e828e6e6a4243b4b9b0131f8 ]

Both 'iwl_scan_probe_params_v3' and 'iwl_scan_probe_params_v4'
wrongly addressed the 'bssid_array' field which should supposed
to be any array of BSSIDs each of size ETH_ALEN and not the
opposite. Fix it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210802215208.04146f24794f.I90726440ddff75013e9fecbe9fa1a05c69e3f17b@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
index b2605aefc290..8b200379f7c2 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2012-2014, 2018-2020 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2021 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -874,7 +874,7 @@ struct iwl_scan_probe_params_v3 {
 	u8 reserved;
 	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX];
 	__le32 short_ssid[SCAN_SHORT_SSID_MAX_SIZE];
-	u8 bssid_array[ETH_ALEN][SCAN_BSSID_MAX_SIZE];
+	u8 bssid_array[SCAN_BSSID_MAX_SIZE][ETH_ALEN];
 } __packed; /* SCAN_PROBE_PARAMS_API_S_VER_3 */
 
 /**
@@ -894,7 +894,7 @@ struct iwl_scan_probe_params_v4 {
 	__le16 reserved;
 	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX];
 	__le32 short_ssid[SCAN_SHORT_SSID_MAX_SIZE];
-	u8 bssid_array[ETH_ALEN][SCAN_BSSID_MAX_SIZE];
+	u8 bssid_array[SCAN_BSSID_MAX_SIZE][ETH_ALEN];
 } __packed; /* SCAN_PROBE_PARAMS_API_S_VER_4 */
 
 #define SCAN_MAX_NUM_CHANS_V3 67
-- 
2.30.2

