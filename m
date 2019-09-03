Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 821E7A6E12
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 18:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbfICQYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 12:24:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729692AbfICQYg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 12:24:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCFAD23774;
        Tue,  3 Sep 2019 16:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527875;
        bh=tQYdSnR4RAFFHKgXxk0+4Ah5CW2SuX2RsiYvzji9Pww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SibseHw57bmkPv+NIC/xggxo17qyzOVZ7XVz/Q4DUPm2wWkKQmzFCfLa1j3QfgHSW
         pfYPJ5zUNznrqg7g56PuZliHWxM/DyjcQdbrNK/sYO4lhkjz482ldk/F9wj2eK+7mH
         JP0lmN/6ArZ5+UVqjm7IhnRG+nVIAJNPPV0CnylM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ihab Zhaika <ihab.zhaika@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 04/23] iwlwifi: add new cards for 22000 and fix struct name
Date:   Tue,  3 Sep 2019 12:24:05 -0400
Message-Id: <20190903162424.6877-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162424.6877-1-sashal@kernel.org>
References: <20190903162424.6877-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ihab Zhaika <ihab.zhaika@intel.com>

add few PCI ID'S for 22000 and fix the wrong name for one
of the structs

Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    | 20 ++++++++++++----
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  5 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 23 +++++++++++++------
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  4 ++--
 4 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index a9c846c59289e..650ca46efc48f 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -241,6 +241,18 @@ const struct iwl_cfg iwl_ax101_cfg_qu_hr = {
 	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
 };
 
+const struct iwl_cfg iwl_ax201_cfg_qu_hr = {
+	.name = "Intel(R) Wi-Fi 6 AX201 160MHz",
+	.fw_name_pre = IWL_22000_QU_B_HR_B_FW_PRE,
+	IWL_DEVICE_22500,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+};
+
 const struct iwl_cfg iwl_ax101_cfg_quz_hr = {
 	.name = "Intel(R) Wi-Fi 6 AX101",
 	.fw_name_pre = IWL_QUZ_A_HR_B_FW_PRE,
@@ -424,12 +436,12 @@ const struct iwl_cfg iwlax210_2ax_cfg_so_jf_a0 = {
 };
 
 const struct iwl_cfg iwlax210_2ax_cfg_so_hr_a0 = {
-	.name = "Intel(R) Wi-Fi 6 AX201 160MHz",
+	.name = "Intel(R) Wi-Fi 7 AX210 160MHz",
 	.fw_name_pre = IWL_22000_SO_A_HR_B_FW_PRE,
 	IWL_DEVICE_AX210,
 };
 
-const struct iwl_cfg iwlax210_2ax_cfg_so_gf_a0 = {
+const struct iwl_cfg iwlax211_2ax_cfg_so_gf_a0 = {
 	.name = "Intel(R) Wi-Fi 7 AX211 160MHz",
 	.fw_name_pre = IWL_22000_SO_A_GF_A_FW_PRE,
 	.uhb_supported = true,
@@ -443,8 +455,8 @@ const struct iwl_cfg iwlax210_2ax_cfg_ty_gf_a0 = {
 	IWL_DEVICE_AX210,
 };
 
-const struct iwl_cfg iwlax210_2ax_cfg_so_gf4_a0 = {
-	.name = "Intel(R) Wi-Fi 7 AX210 160MHz",
+const struct iwl_cfg iwlax411_2ax_cfg_so_gf4_a0 = {
+	.name = "Intel(R) Wi-Fi 7 AX411 160MHz",
 	.fw_name_pre = IWL_22000_SO_A_GF4_A_FW_PRE,
 	IWL_DEVICE_AX210,
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index f3e69edf89071..29aaf649c13c3 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -562,6 +562,7 @@ extern const struct iwl_cfg iwl_ax101_cfg_qu_hr;
 extern const struct iwl_cfg iwl_ax101_cfg_quz_hr;
 extern const struct iwl_cfg iwl22000_2ax_cfg_hr;
 extern const struct iwl_cfg iwl_ax200_cfg_cc;
+extern const struct iwl_cfg iwl_ax201_cfg_qu_hr;
 extern const struct iwl_cfg killer1650s_2ax_cfg_qu_b0_hr_b0;
 extern const struct iwl_cfg killer1650i_2ax_cfg_qu_b0_hr_b0;
 extern const struct iwl_cfg killer1650x_2ax_cfg;
@@ -580,9 +581,9 @@ extern const struct iwl_cfg iwl9560_2ac_cfg_qnj_jf_b0;
 extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_a0;
 extern const struct iwl_cfg iwlax210_2ax_cfg_so_jf_a0;
 extern const struct iwl_cfg iwlax210_2ax_cfg_so_hr_a0;
-extern const struct iwl_cfg iwlax210_2ax_cfg_so_gf_a0;
+extern const struct iwl_cfg iwlax211_2ax_cfg_so_gf_a0;
 extern const struct iwl_cfg iwlax210_2ax_cfg_ty_gf_a0;
-extern const struct iwl_cfg iwlax210_2ax_cfg_so_gf4_a0;
+extern const struct iwl_cfg iwlax411_2ax_cfg_so_gf4_a0;
 #endif /* CPTCFG_IWLMVM || CPTCFG_IWLFMAC */
 
 #endif /* __IWL_CONFIG_H__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index cd035061cdd55..2f3ee5769fdd3 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -897,6 +897,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x02F0, 0x0310, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x02F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0x02F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x2074, iwl_ax201_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x02F0, 0x4070, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x06F0, 0x0070, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x06F0, 0x0074, iwl_ax101_cfg_qu_hr)},
@@ -905,6 +906,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x06F0, 0x0310, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x06F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0x06F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
+	{IWL_PCI_DEVICE(0x06F0, 0x2074, iwl_ax201_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x06F0, 0x4070, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0000, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0040, iwl_ax101_cfg_qu_hr)},
@@ -918,6 +920,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2720, 0x1080, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0x2720, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
+	{IWL_PCI_DEVICE(0x2720, 0x2074, iwl_ax201_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x4070, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0040, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0070, iwl_ax101_cfg_qu_hr)},
@@ -927,6 +930,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x34F0, 0x0310, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x34F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x2074, iwl_ax201_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x34F0, 0x4070, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0040, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0070, iwl_ax101_cfg_qu_hr)},
@@ -935,6 +939,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x43F0, 0x007C, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x43F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0x43F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x2074, iwl_ax201_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x43F0, 0x4070, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0000, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0040, iwl_ax101_cfg_qu_hr)},
@@ -946,6 +951,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xA0F0, 0x0A10, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x2074, iwl_ax201_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x4070, iwl_ax101_cfg_qu_hr)},
 
 	{IWL_PCI_DEVICE(0x2723, 0x0080, iwl_ax200_cfg_cc)},
@@ -958,13 +964,16 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2723, 0x4080, iwl_ax200_cfg_cc)},
 	{IWL_PCI_DEVICE(0x2723, 0x4088, iwl_ax200_cfg_cc)},
 
-	{IWL_PCI_DEVICE(0x2725, 0x0090, iwlax210_2ax_cfg_so_hr_a0)},
-	{IWL_PCI_DEVICE(0x7A70, 0x0090, iwlax210_2ax_cfg_so_hr_a0)},
-	{IWL_PCI_DEVICE(0x7A70, 0x0310, iwlax210_2ax_cfg_so_hr_a0)},
-	{IWL_PCI_DEVICE(0x2725, 0x0020, iwlax210_2ax_cfg_so_hr_a0)},
-	{IWL_PCI_DEVICE(0x2725, 0x0310, iwlax210_2ax_cfg_so_hr_a0)},
-	{IWL_PCI_DEVICE(0x2725, 0x0A10, iwlax210_2ax_cfg_so_hr_a0)},
-	{IWL_PCI_DEVICE(0x2725, 0x00B0, iwlax210_2ax_cfg_so_hr_a0)},
+	{IWL_PCI_DEVICE(0x2725, 0x0090, iwlax211_2ax_cfg_so_gf_a0)},
+	{IWL_PCI_DEVICE(0x2725, 0x0020, iwlax210_2ax_cfg_ty_gf_a0)},
+	{IWL_PCI_DEVICE(0x2725, 0x0310, iwlax210_2ax_cfg_ty_gf_a0)},
+	{IWL_PCI_DEVICE(0x2725, 0x0510, iwlax210_2ax_cfg_ty_gf_a0)},
+	{IWL_PCI_DEVICE(0x2725, 0x0A10, iwlax210_2ax_cfg_ty_gf_a0)},
+	{IWL_PCI_DEVICE(0x2725, 0x00B0, iwlax411_2ax_cfg_so_gf4_a0)},
+	{IWL_PCI_DEVICE(0x7A70, 0x0090, iwlax211_2ax_cfg_so_gf_a0)},
+	{IWL_PCI_DEVICE(0x7A70, 0x0310, iwlax211_2ax_cfg_so_gf_a0)},
+	{IWL_PCI_DEVICE(0x7A70, 0x0510, iwlax211_2ax_cfg_so_gf_a0)},
+	{IWL_PCI_DEVICE(0x7A70, 0x0A10, iwlax211_2ax_cfg_so_gf_a0)},
 
 #endif /* CONFIG_IWLMVM */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 199eddea82a9a..51a3f77474e66 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3569,10 +3569,10 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 			trans->cfg = &iwlax210_2ax_cfg_so_jf_a0;
 		} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 			   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_GF)) {
-			trans->cfg = &iwlax210_2ax_cfg_so_gf_a0;
+			trans->cfg = &iwlax211_2ax_cfg_so_gf_a0;
 		} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 			   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_GF4)) {
-			trans->cfg = &iwlax210_2ax_cfg_so_gf4_a0;
+			trans->cfg = &iwlax411_2ax_cfg_so_gf4_a0;
 		}
 	} else if (cfg == &iwl_ax101_cfg_qu_hr) {
 		if ((CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
-- 
2.20.1

