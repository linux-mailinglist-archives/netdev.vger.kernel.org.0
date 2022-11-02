Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE0D616EE7
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 21:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiKBUka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 16:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbiKBUkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 16:40:24 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4BE6554
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 13:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667421622; x=1698957622;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uLdBfwG/bSzba5n/63yBMla/yqLEzRfWJT6zy6l2eVs=;
  b=mfemYLvaOTPn3NfLe7YYbiaxnXxlL/yOPijdHuxfnBWVS2Phi7xTIODL
   ReVr4MqPnuE3bMxesg3kwLEft3s+Q1glmO1DhRl2+SkIl4aan+5rpTQex
   j4qoPq64s5fW36blHQ46p0Cd/urQkAS2URAtvFN2GLgUNk4NJE12qU3GH
   Y1Qi2XSVimkIQV5ZajC+XCravKKNe014N4CfodnqEXZh3uNiihqUgDKTS
   mRHfmH/11stt0OEw4uAD4n2Y4sQAMjPIX9odKKOwgQFrytx8ltYnb1lIY
   i+L+CigoiMqOmrW112QOr9nLiLzti6OS6VoJJtF2lxo0NKdrzwojUimc+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="336202183"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="336202183"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 13:40:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="612385321"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="612385321"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 02 Nov 2022 13:40:09 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 2/6] e1000e: Add support for the next LOM generation
Date:   Wed,  2 Nov 2022 13:39:53 -0700
Message-Id: <20221102203957.2944396-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221102203957.2944396-1-anthony.l.nguyen@intel.com>
References: <20221102203957.2944396-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Add devices IDs for the next LOM generations that will be available on the
next Intel Client platforms.
This patch provides the initial support for these devices.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ethtool.c |  2 ++
 drivers/net/ethernet/intel/e1000e/hw.h      |  9 +++++++++
 drivers/net/ethernet/intel/e1000e/ich8lan.c |  7 +++++++
 drivers/net/ethernet/intel/e1000e/netdev.c  | 10 ++++++++++
 drivers/net/ethernet/intel/e1000e/ptp.c     |  1 +
 5 files changed, 29 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 51a5afe9df2f..59e82d131d88 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -908,6 +908,7 @@ static int e1000_reg_test(struct e1000_adapter *adapter, u64 *data)
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
 	case e1000_pch_lnp:
+	case e1000_pch_ptp:
 		mask |= BIT(18);
 		break;
 	default:
@@ -1575,6 +1576,7 @@ static void e1000_loopback_cleanup(struct e1000_adapter *adapter)
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
 	case e1000_pch_lnp:
+	case e1000_pch_ptp:
 		fext_nvm11 = er32(FEXTNVM11);
 		fext_nvm11 &= ~E1000_FEXTNVM11_DISABLE_MULR_FIX;
 		ew32(FEXTNVM11, fext_nvm11);
diff --git a/drivers/net/ethernet/intel/e1000e/hw.h b/drivers/net/ethernet/intel/e1000e/hw.h
index bcf680e83811..29f9fae35f42 100644
--- a/drivers/net/ethernet/intel/e1000e/hw.h
+++ b/drivers/net/ethernet/intel/e1000e/hw.h
@@ -114,6 +114,14 @@ struct e1000_hw;
 #define E1000_DEV_ID_PCH_LNP_I219_V20		0x550F
 #define E1000_DEV_ID_PCH_LNP_I219_LM21		0x5510
 #define E1000_DEV_ID_PCH_LNP_I219_V21		0x5511
+#define E1000_DEV_ID_PCH_ARL_I219_LM24		0x57A0
+#define E1000_DEV_ID_PCH_ARL_I219_V24		0x57A1
+#define E1000_DEV_ID_PCH_PTP_I219_LM25		0x57B3
+#define E1000_DEV_ID_PCH_PTP_I219_V25		0x57B4
+#define E1000_DEV_ID_PCH_PTP_I219_LM26		0x57B5
+#define E1000_DEV_ID_PCH_PTP_I219_V26		0x57B6
+#define E1000_DEV_ID_PCH_PTP_I219_LM27		0x57B7
+#define E1000_DEV_ID_PCH_PTP_I219_V27		0x57B8
 
 #define E1000_REVISION_4	4
 
@@ -141,6 +149,7 @@ enum e1000_mac_type {
 	e1000_pch_adp,
 	e1000_pch_mtp,
 	e1000_pch_lnp,
+	e1000_pch_ptp,
 };
 
 enum e1000_media_type {
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index e8f7cb9d8724..0c7fd10312c8 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -322,6 +322,7 @@ static s32 e1000_init_phy_workarounds_pchlan(struct e1000_hw *hw)
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
 	case e1000_pch_lnp:
+	case e1000_pch_ptp:
 		if (e1000_phy_is_accessible_pchlan(hw))
 			break;
 
@@ -468,6 +469,7 @@ static s32 e1000_init_phy_params_pchlan(struct e1000_hw *hw)
 		case e1000_pch_adp:
 		case e1000_pch_mtp:
 		case e1000_pch_lnp:
+		case e1000_pch_ptp:
 			/* In case the PHY needs to be in mdio slow mode,
 			 * set slow mode and try to get the PHY id again.
 			 */
@@ -714,6 +716,7 @@ static s32 e1000_init_mac_params_ich8lan(struct e1000_hw *hw)
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
 	case e1000_pch_lnp:
+	case e1000_pch_ptp:
 	case e1000_pchlan:
 		/* check management mode */
 		mac->ops.check_mng_mode = e1000_check_mng_mode_pchlan;
@@ -1681,6 +1684,7 @@ static s32 e1000_get_variants_ich8lan(struct e1000_adapter *adapter)
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
 	case e1000_pch_lnp:
+	case e1000_pch_ptp:
 		rc = e1000_init_phy_params_pchlan(hw);
 		break;
 	default:
@@ -2137,6 +2141,7 @@ static s32 e1000_sw_lcd_config_ich8lan(struct e1000_hw *hw)
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
 	case e1000_pch_lnp:
+	case e1000_pch_ptp:
 		sw_cfg_mask = E1000_FEXTNVM_SW_CONFIG_ICH8M;
 		break;
 	default:
@@ -3182,6 +3187,7 @@ static s32 e1000_valid_nvm_bank_detect_ich8lan(struct e1000_hw *hw, u32 *bank)
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
 	case e1000_pch_lnp:
+	case e1000_pch_ptp:
 		bank1_offset = nvm->flash_bank_size;
 		act_offset = E1000_ICH_NVM_SIG_WORD;
 
@@ -4122,6 +4128,7 @@ static s32 e1000_validate_nvm_checksum_ich8lan(struct e1000_hw *hw)
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
 	case e1000_pch_lnp:
+	case e1000_pch_ptp:
 		word = NVM_COMPAT;
 		valid_csum_mask = NVM_COMPAT_VALID_CSUM;
 		break;
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 4dc862399f0c..edc8aa9822ee 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -3553,6 +3553,7 @@ s32 e1000e_get_base_timinca(struct e1000_adapter *adapter, u32 *timinca)
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
 	case e1000_pch_lnp:
+	case e1000_pch_ptp:
 		if (er32(TSYNCRXCTL) & E1000_TSYNCRXCTL_SYSCFI) {
 			/* Stable 24MHz frequency */
 			incperiod = INCPERIOD_24MHZ;
@@ -4068,6 +4069,7 @@ void e1000e_reset(struct e1000_adapter *adapter)
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
 	case e1000_pch_lnp:
+	case e1000_pch_ptp:
 		fc->refresh_time = 0xFFFF;
 		fc->pause_time = 0xFFFF;
 
@@ -7914,6 +7916,14 @@ static const struct pci_device_id e1000_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_V20), board_pch_mtp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_LM21), board_pch_mtp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_V21), board_pch_mtp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ARL_I219_LM24), board_pch_mtp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ARL_I219_V24), board_pch_mtp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_PTP_I219_LM25), board_pch_mtp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_PTP_I219_V25), board_pch_mtp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_PTP_I219_LM26), board_pch_mtp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_PTP_I219_V26), board_pch_mtp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_PTP_I219_LM27), board_pch_mtp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_PTP_I219_V27), board_pch_mtp },
 
 	{ 0, 0, 0, 0, 0, 0, 0 }	/* terminate list */
 };
diff --git a/drivers/net/ethernet/intel/e1000e/ptp.c b/drivers/net/ethernet/intel/e1000e/ptp.c
index 6e5a1720e6cd..def4566a916f 100644
--- a/drivers/net/ethernet/intel/e1000e/ptp.c
+++ b/drivers/net/ethernet/intel/e1000e/ptp.c
@@ -287,6 +287,7 @@ void e1000e_ptp_init(struct e1000_adapter *adapter)
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
 	case e1000_pch_lnp:
+	case e1000_pch_ptp:
 		if ((hw->mac.type < e1000_pch_lpt) ||
 		    (er32(TSYNCRXCTL) & E1000_TSYNCRXCTL_SYSCFI)) {
 			adapter->ptp_clock_info.max_adj = 24000000 - 1;
-- 
2.35.1

