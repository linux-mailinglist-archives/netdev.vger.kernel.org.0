Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABA430C349
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbhBBPN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:13:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:39218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235184AbhBBPL4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:11:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F8D364F6D;
        Tue,  2 Feb 2021 15:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278400;
        bh=4bRU53ZaSAJGof+8oWQuQkJLZDarDJ1g+PAbUUX5Tz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1tNoUUnV9hUpNWzsFMHn54qp+0iOgQZl93Z46i+/CBr93ihJaCF4p7NhNvjcx0NL
         ooew9jMGv9cRGKAbjGBM6PfmI8ZG8sb513bwXA4AXOj742mfDK2DIEp3wdwrUxkfsp
         0LBwsv8VbCqQrECGaKhPw4DhlIGuncxTnLK4RO3MLwoxJ/n/Iz3CJS5UwLD1WMvOSX
         NzEEGxcCMaPXRAnECGxNZl30IFgnj+CPFKmeOLULPfJZyUYV+WPnZe4uQ4KQzQvk9l
         70etFK32gkhPKZ8hZGx6GYFeZPqom/foCa6Xn/wYx9FVW7Cw75dl2ryCk04DbC+pfp
         Th0SWp0H+kfjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 18/25] iwlwifi: pcie: add rules to match Qu with Hr2
Date:   Tue,  2 Feb 2021 10:06:08 -0500
Message-Id: <20210202150615.1864175-18-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150615.1864175-1-sashal@kernel.org>
References: <20210202150615.1864175-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 16062c12edb8ed2dfb15e6a914ff4edf858ab9e0 ]

Until now we have been relying on matching the PCI ID and subsystem
device ID in order to recognize Qu devices with Hr2.  Add rules to
match these devices, so that we don't have to add a new rule for every
new ID we get.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210122144849.591ce253ddd8.Ia4b9cc2c535625890c6d6b560db97ee9f2d5ca3b@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    | 25 +++++++++++++++++++
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  3 +++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 10 ++++++++
 3 files changed, 38 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index d2bbe6a735142..92c50efd48fc3 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -358,6 +358,7 @@ const struct iwl_cfg_trans_params iwl_ma_trans_cfg = {
 const char iwl_ax101_name[] = "Intel(R) Wi-Fi 6 AX101";
 const char iwl_ax200_name[] = "Intel(R) Wi-Fi 6 AX200 160MHz";
 const char iwl_ax201_name[] = "Intel(R) Wi-Fi 6 AX201 160MHz";
+const char iwl_ax203_name[] = "Intel(R) Wi-Fi 6 AX203";
 const char iwl_ax211_name[] = "Intel(R) Wi-Fi 6 AX211 160MHz";
 const char iwl_ax411_name[] = "Intel(R) Wi-Fi 6 AX411 160MHz";
 const char iwl_ma_name[] = "Intel(R) Wi-Fi 6";
@@ -384,6 +385,18 @@ const struct iwl_cfg iwl_qu_b0_hr1_b0 = {
 	.num_rbds = IWL_NUM_RBDS_22000_HE,
 };
 
+const struct iwl_cfg iwl_qu_b0_hr_b0 = {
+	.fw_name_pre = IWL_QU_B_HR_B_FW_PRE,
+	IWL_DEVICE_22500,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+	.num_rbds = IWL_NUM_RBDS_22000_HE,
+};
+
 const struct iwl_cfg iwl_ax201_cfg_qu_hr = {
 	.name = "Intel(R) Wi-Fi 6 AX201 160MHz",
 	.fw_name_pre = IWL_QU_B_HR_B_FW_PRE,
@@ -410,6 +423,18 @@ const struct iwl_cfg iwl_qu_c0_hr1_b0 = {
 	.num_rbds = IWL_NUM_RBDS_22000_HE,
 };
 
+const struct iwl_cfg iwl_qu_c0_hr_b0 = {
+	.fw_name_pre = IWL_QU_C_HR_B_FW_PRE,
+	IWL_DEVICE_22500,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+	.num_rbds = IWL_NUM_RBDS_22000_HE,
+};
+
 const struct iwl_cfg iwl_ax201_cfg_qu_c0_hr_b0 = {
 	.name = "Intel(R) Wi-Fi 6 AX201 160MHz",
 	.fw_name_pre = IWL_QU_C_HR_B_FW_PRE,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 580b07a43856d..52fb9963d7cf8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -544,6 +544,7 @@ extern const char iwl9260_killer_1550_name[];
 extern const char iwl9560_killer_1550i_name[];
 extern const char iwl9560_killer_1550s_name[];
 extern const char iwl_ax200_name[];
+extern const char iwl_ax203_name[];
 extern const char iwl_ax201_name[];
 extern const char iwl_ax101_name[];
 extern const char iwl_ax200_killer_1650w_name[];
@@ -627,6 +628,8 @@ extern const struct iwl_cfg iwl9560_2ac_cfg_soc;
 extern const struct iwl_cfg iwl_qu_b0_hr1_b0;
 extern const struct iwl_cfg iwl_qu_c0_hr1_b0;
 extern const struct iwl_cfg iwl_quz_a0_hr1_b0;
+extern const struct iwl_cfg iwl_qu_b0_hr_b0;
+extern const struct iwl_cfg iwl_qu_c0_hr_b0;
 extern const struct iwl_cfg iwl_ax200_cfg_cc;
 extern const struct iwl_cfg iwl_ax201_cfg_qu_hr;
 extern const struct iwl_cfg iwl_ax201_cfg_qu_hr;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 7b5ece380fbfb..2823a1e81656d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -966,6 +966,11 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 		      IWL_CFG_RF_TYPE_HR1, IWL_CFG_ANY,
 		      IWL_CFG_ANY, IWL_CFG_ANY,
 		      iwl_qu_b0_hr1_b0, iwl_ax101_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_QU, SILICON_C_STEP,
+		      IWL_CFG_RF_TYPE_HR2, IWL_CFG_ANY,
+		      IWL_CFG_ANY, IWL_CFG_ANY,
+		      iwl_qu_b0_hr_b0, iwl_ax203_name),
 
 	/* Qu C step */
 	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
@@ -973,6 +978,11 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 		      IWL_CFG_RF_TYPE_HR1, IWL_CFG_ANY,
 		      IWL_CFG_ANY, IWL_CFG_ANY,
 		      iwl_qu_c0_hr1_b0, iwl_ax101_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_QU, SILICON_C_STEP,
+		      IWL_CFG_RF_TYPE_HR2, IWL_CFG_ANY,
+		      IWL_CFG_ANY, IWL_CFG_ANY,
+		      iwl_qu_c0_hr_b0, iwl_ax203_name),
 
 	/* QuZ */
 	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
-- 
2.27.0

