Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D455BBCEF
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiIRJuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiIRJtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:49:55 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C5711A3B
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:49 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MVjbr6YPsz14QMv;
        Sun, 18 Sep 2022 17:45:44 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:47 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 06/55] iwlwifi: replace const features initialization with NETDEV_FEATURE_SET
Date:   Sun, 18 Sep 2022 09:42:47 +0000
Message-ID: <20220918094336.28958-7-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The iwlwifi driver use netdev features in global structure
initialization. Changed the netdev_features_t memeber to
netdev_features_t *, and make it refer to a global constant
netdev_features_t variable.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/1000.c |  2 ++
 drivers/net/wireless/intel/iwlwifi/cfg/2000.c |  4 +++
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  4 +--
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c |  3 ++
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c |  7 +++++
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c |  1 +
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |  2 +-
 .../net/wireless/intel/iwlwifi/iwl-config.h   | 15 +++++-----
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  | 29 +++++++++++++++++++
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  8 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  | 23 +++++++++++++++
 13 files changed, 90 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/1000.c b/drivers/net/wireless/intel/iwlwifi/cfg/1000.c
index 116defb15afb..6d172f4d085c 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/1000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/1000.c
@@ -67,6 +67,7 @@ static const struct iwl_eeprom_params iwl1000_eeprom_params = {
 	.trans.device_family = IWL_DEVICE_FAMILY_1000,		\
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
+	.features = &netdev_empty_features,			\
 	.nvm_ver = EEPROM_1000_EEPROM_VERSION,		\
 	.nvm_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
 	.trans.base_params = &iwl1000_base_params,		\
@@ -91,6 +92,7 @@ const struct iwl_cfg iwl1000_bg_cfg = {
 	.trans.device_family = IWL_DEVICE_FAMILY_100,		\
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
+	.features = &netdev_empty_features,			\
 	.nvm_ver = EEPROM_1000_EEPROM_VERSION,		\
 	.nvm_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
 	.trans.base_params = &iwl1000_base_params,		\
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/2000.c b/drivers/net/wireless/intel/iwlwifi/cfg/2000.c
index ab2038a3fbe2..1757e823d883 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/2000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/2000.c
@@ -93,6 +93,7 @@ static const struct iwl_eeprom_params iwl20x0_eeprom_params = {
 	.trans.device_family = IWL_DEVICE_FAMILY_2000,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
+	.features = &netdev_empty_features,			\
 	.nvm_ver = EEPROM_2000_EEPROM_VERSION,			\
 	.nvm_calib_ver = EEPROM_2000_TX_POWER_VERSION,		\
 	.trans.base_params = &iwl2000_base_params,		\
@@ -119,6 +120,7 @@ const struct iwl_cfg iwl2000_2bgn_d_cfg = {
 	.trans.device_family = IWL_DEVICE_FAMILY_2030,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
+	.features = &netdev_empty_features,			\
 	.nvm_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.nvm_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.trans.base_params = &iwl2030_base_params,		\
@@ -138,6 +140,7 @@ const struct iwl_cfg iwl2030_2bgn_cfg = {
 	.trans.device_family = IWL_DEVICE_FAMILY_105,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
+	.features = &netdev_empty_features,			\
 	.nvm_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.nvm_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.trans.base_params = &iwl2000_base_params,		\
@@ -164,6 +167,7 @@ const struct iwl_cfg iwl105_bgn_d_cfg = {
 	.trans.device_family = IWL_DEVICE_FAMILY_135,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
+	.features = &netdev_empty_features,			\
 	.nvm_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.nvm_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.trans.base_params = &iwl2030_base_params,		\
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 8ff967edc8f0..a1e953c99254 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -175,7 +175,7 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
 	.dccm2_len = IWL_22000_DCCM2_LEN,				\
 	.smem_offset = IWL_22000_SMEM_OFFSET,				\
 	.smem_len = IWL_22000_SMEM_LEN,					\
-	.features = IWL_TX_CSUM_NETIF_FLAGS | NETIF_F_RXCSUM,		\
+	.features = &iwl_dev_22000_comm_features,			\
 	.apmg_not_supported = true,					\
 	.trans.mq_rx_supported = true,					\
 	.vht_mu_mimo_supported = true,					\
@@ -252,7 +252,7 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
 	.dccm2_len = IWL_22000_DCCM2_LEN,				\
 	.smem_offset = IWL_22000_SMEM_OFFSET,				\
 	.smem_len = IWL_22000_SMEM_LEN,					\
-	.features = IWL_TX_CSUM_NETIF_FLAGS_BZ | NETIF_F_RXCSUM,	\
+	.features = &iwl_dev_bz_comm_features,				\
 	.apmg_not_supported = true,					\
 	.trans.mq_rx_supported = true,					\
 	.vht_mu_mimo_supported = true,					\
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/5000.c b/drivers/net/wireless/intel/iwlwifi/cfg/5000.c
index e2e23d2bc1fe..8efd018e5e2a 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/5000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/5000.c
@@ -65,6 +65,7 @@ static const struct iwl_eeprom_params iwl5000_eeprom_params = {
 	.trans.device_family = IWL_DEVICE_FAMILY_5000,		\
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
+	.features = &netdev_empty_features,			\
 	.nvm_ver = EEPROM_5000_EEPROM_VERSION,		\
 	.nvm_calib_ver = EEPROM_5000_TX_POWER_VERSION,	\
 	.trans.base_params = &iwl5000_base_params,		\
@@ -111,6 +112,7 @@ const struct iwl_cfg iwl5350_agn_cfg = {
 	.trans.device_family = IWL_DEVICE_FAMILY_5000,
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,
+	.features = &netdev_empty_features,
 	.nvm_ver = EEPROM_5050_EEPROM_VERSION,
 	.nvm_calib_ver = EEPROM_5050_TX_POWER_VERSION,
 	.trans.base_params = &iwl5000_base_params,
@@ -127,6 +129,7 @@ const struct iwl_cfg iwl5350_agn_cfg = {
 	.trans.device_family = IWL_DEVICE_FAMILY_5150,		\
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
+	.features = &netdev_empty_features,			\
 	.nvm_ver = EEPROM_5050_EEPROM_VERSION,		\
 	.nvm_calib_ver = EEPROM_5050_TX_POWER_VERSION,	\
 	.trans.base_params = &iwl5000_base_params,		\
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/6000.c b/drivers/net/wireless/intel/iwlwifi/cfg/6000.c
index 20929e59c2f4..a682eaf35142 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/6000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/6000.c
@@ -114,6 +114,7 @@ static const struct iwl_eeprom_params iwl6000_eeprom_params = {
 	.trans.device_family = IWL_DEVICE_FAMILY_6005,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
+	.features = &netdev_empty_features,			\
 	.nvm_ver = EEPROM_6005_EEPROM_VERSION,		\
 	.nvm_calib_ver = EEPROM_6005_TX_POWER_VERSION,	\
 	.trans.base_params = &iwl6000_g2_base_params,		\
@@ -167,6 +168,7 @@ const struct iwl_cfg iwl6005_2agn_mow2_cfg = {
 	.trans.device_family = IWL_DEVICE_FAMILY_6030,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
+	.features = &netdev_empty_features,			\
 	.nvm_ver = EEPROM_6030_EEPROM_VERSION,		\
 	.nvm_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\
 	.trans.base_params = &iwl6000_g2_base_params,		\
@@ -202,6 +204,7 @@ const struct iwl_cfg iwl6030_2bg_cfg = {
 	.trans.device_family = IWL_DEVICE_FAMILY_6030,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
+	.features = &netdev_empty_features,			\
 	.nvm_ver = EEPROM_6030_EEPROM_VERSION,		\
 	.nvm_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\
 	.trans.base_params = &iwl6000_g2_base_params,		\
@@ -254,6 +257,7 @@ const struct iwl_cfg iwl130_bg_cfg = {
 	.trans.device_family = IWL_DEVICE_FAMILY_6000i,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
+	.features = &netdev_empty_features,			\
 	.valid_tx_ant = ANT_BC,		/* .cfg overwrite */	\
 	.valid_rx_ant = ANT_BC,		/* .cfg overwrite */	\
 	.nvm_ver = EEPROM_6000_EEPROM_VERSION,		\
@@ -285,6 +289,7 @@ const struct iwl_cfg iwl6000i_2bg_cfg = {
 	.trans.device_family = IWL_DEVICE_FAMILY_6050,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
+	.features = &netdev_empty_features,			\
 	.valid_tx_ant = ANT_AB,		/* .cfg overwrite */	\
 	.valid_rx_ant = ANT_AB,		/* .cfg overwrite */	\
 	.nvm_ver = EEPROM_6050_EEPROM_VERSION,		\
@@ -312,6 +317,7 @@ const struct iwl_cfg iwl6050_2abg_cfg = {
 	.trans.device_family = IWL_DEVICE_FAMILY_6150,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
+	.features = &netdev_empty_features,			\
 	.nvm_ver = EEPROM_6150_EEPROM_VERSION,		\
 	.nvm_calib_ver = EEPROM_6150_TX_POWER_VERSION,	\
 	.trans.base_params = &iwl6050_base_params,		\
@@ -338,6 +344,7 @@ const struct iwl_cfg iwl6000_3agn_cfg = {
 	.trans.device_family = IWL_DEVICE_FAMILY_6000,
 	.max_inst_size = IWL60_RTC_INST_SIZE,
 	.max_data_size = IWL60_RTC_DATA_SIZE,
+	.features = &netdev_empty_features,
 	.nvm_ver = EEPROM_6000_EEPROM_VERSION,
 	.nvm_calib_ver = EEPROM_6000_TX_POWER_VERSION,
 	.trans.base_params = &iwl6000_base_params,
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/7000.c b/drivers/net/wireless/intel/iwlwifi/cfg/7000.c
index b24dc5523a52..1bbad301118a 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/7000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/7000.c
@@ -92,6 +92,7 @@ static const struct iwl_ht_params iwl7000_ht_params = {
 #define IWL_DEVICE_7000_COMMON					\
 	.trans.device_family = IWL_DEVICE_FAMILY_7000,		\
 	.trans.base_params = &iwl7000_base_params,		\
+	.features = &netdev_empty_features,			\
 	.led_mode = IWL_LED_RF_STATE,				\
 	.nvm_hw_section_num = 0,				\
 	.non_shared_ant = ANT_A,				\
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
index a6454287d506..7535832599e8 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
@@ -81,7 +81,7 @@ static const struct iwl_tt_params iwl8000_tt_params = {
 	.trans.base_params = &iwl8000_base_params,			\
 	.led_mode = IWL_LED_RF_STATE,					\
 	.nvm_hw_section_num = 10,					\
-	.features = NETIF_F_RXCSUM,					\
+	.features = &iwl_dev_8000_comm_features,			\
 	.non_shared_ant = ANT_A,					\
 	.dccm_offset = IWL8260_DCCM_OFFSET,				\
 	.dccm_len = IWL8260_DCCM_LEN,					\
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index 7a7ca06d46c1..0a89c6fb8048 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -84,7 +84,7 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 	.dccm2_len = IWL9000_DCCM2_LEN,					\
 	.smem_offset = IWL9000_SMEM_OFFSET,				\
 	.smem_len = IWL9000_SMEM_LEN,					\
-	.features = IWL_TX_CSUM_NETIF_FLAGS | NETIF_F_RXCSUM,		\
+	.features = &iwl_dev_9000_comm_features,			\
 	.thermal_params = &iwl9000_tt_params,				\
 	.apmg_not_supported = true,					\
 	.num_rbds = 512,						\
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index f5b556a103e8..fbec4e130e88 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -82,12 +82,13 @@ enum iwl_nvm_type {
 #define IWL_MAX_WD_TIMEOUT	120000
 
 #define IWL_DEFAULT_MAX_TX_POWER 22
-#define IWL_TX_CSUM_NETIF_FLAGS (NETIF_F_IPV6_CSUM | NETIF_F_IP_CSUM |\
-				 NETIF_F_TSO | NETIF_F_TSO6)
-#define IWL_TX_CSUM_NETIF_FLAGS_BZ (NETIF_F_HW_CSUM | NETIF_F_TSO | NETIF_F_TSO6)
-#define IWL_CSUM_NETIF_FLAGS_MASK (IWL_TX_CSUM_NETIF_FLAGS | \
-				   IWL_TX_CSUM_NETIF_FLAGS_BZ | \
-				   NETIF_F_RXCSUM)
+
+extern netdev_features_t iwl_tx_csum_features __ro_after_init;
+extern netdev_features_t iwl_tx_csum_bz_features __ro_after_init;
+extern netdev_features_t iwl_dev_22000_comm_features __ro_after_init;
+extern netdev_features_t iwl_dev_bz_comm_features __ro_after_init;
+extern netdev_features_t iwl_dev_8000_comm_features __ro_after_init;
+extern netdev_features_t iwl_dev_9000_comm_features __ro_after_init;
 
 /* Antenna presence definitions */
 #define	ANT_NONE	0x0
@@ -371,7 +372,7 @@ struct iwl_cfg {
 	enum iwl_nvm_type nvm_type;
 	u32 max_data_size;
 	u32 max_inst_size;
-	netdev_features_t features;
+	const netdev_features_t *features;
 	u32 dccm_offset;
 	u32 dccm_len;
 	u32 dccm2_offset;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index a2203f661321..e8588fa8e5df 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -8,6 +8,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/firmware.h>
 #include <linux/module.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/vmalloc.h>
 
 #include "iwl-drv.h"
@@ -89,6 +90,13 @@ static struct iwlwifi_opmode_table {
 
 #define IWL_DEFAULT_SCAN_CHANNELS 40
 
+netdev_features_t iwl_tx_csum_features __ro_after_init;
+netdev_features_t iwl_tx_csum_bz_features __ro_after_init;
+netdev_features_t iwl_dev_22000_comm_features __ro_after_init;
+netdev_features_t iwl_dev_bz_comm_features __ro_after_init;
+netdev_features_t iwl_dev_8000_comm_features __ro_after_init;
+netdev_features_t iwl_dev_9000_comm_features __ro_after_init;
+
 /*
  * struct fw_sec: Just for the image parsing process.
  * For the fw storage we are using struct fw_desc.
@@ -1829,6 +1837,25 @@ void iwl_opmode_deregister(const char *name)
 }
 IWL_EXPORT_SYMBOL(iwl_opmode_deregister);
 
+static void __init iwl_features_init(void)
+{
+	netdev_features_set_set(iwl_tx_csum_features,
+				NETIF_F_IPV6_CSUM_BIT,
+				NETIF_F_IP_CSUM_BIT,
+				NETIF_F_TSO_BIT,
+				NETIF_F_TSO6_BIT);
+	netdev_features_set_set(iwl_tx_csum_bz_features,
+				NETIF_F_HW_CSUM_BIT,
+				NETIF_F_TSO_BIT,
+				NETIF_F_TSO6_BIT);
+	iwl_dev_22000_comm_features = iwl_tx_csum_features;
+	netdev_feature_add(NETIF_F_RXCSUM_BIT, iwl_dev_22000_comm_features);
+	iwl_dev_bz_comm_features = iwl_tx_csum_bz_features;
+	netdev_feature_add(NETIF_F_RXCSUM_BIT, iwl_dev_bz_comm_features);
+	netdev_feature_add(NETIF_F_RXCSUM_BIT, iwl_dev_8000_comm_features);
+	iwl_dev_9000_comm_features = iwl_dev_22000_comm_features;
+}
+
 static int __init iwl_drv_init(void)
 {
 	int i, err;
@@ -1847,6 +1874,8 @@ static int __init iwl_drv_init(void)
 	if (err)
 		goto cleanup_debugfs;
 
+	iwl_features_init();
+
 	return 0;
 
 cleanup_debugfs:
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index c8d523acec7d..25176f5cf94d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -615,7 +615,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->wiphy->features |= NL80211_FEATURE_TDLS_CHANNEL_SWITCH;
 	}
 
-	hw->netdev_features |= mvm->cfg->features;
+	hw->netdev_features |= *mvm->cfg->features;
 	if (!iwl_mvm_is_csum_supported(mvm))
 		hw->netdev_features &= ~IWL_CSUM_NETIF_FLAGS_MASK;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index bf35e130c876..a50d85b7050b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -73,6 +73,14 @@
 
 extern const struct ieee80211_ops iwl_mvm_hw_ops;
 
+extern netdev_features_t mvm_tx_csum_features __ro_after_init;
+extern netdev_features_t mvm_tx_csum_bz_features __ro_after_init;
+extern netdev_features_t mvm_csum_features_mask __ro_after_init;
+
+#define IWL_TX_CSUM_NETIF_FLAGS mvm_tx_csum_features
+#define IWL_TX_CSUM_NETIF_FLAGS_BZ mvm_tx_csum_bz_features
+#define IWL_CSUM_NETIF_FLAGS_MASK mvm_csum_features_mask
+
 /**
  * struct iwl_mvm_mod_params - module parameters for iwlmvm
  * @init_dbg: if true, then the NIC won't be stopped if the INIT fw asserted.
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index db43c8a83a31..091c52378a95 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
 #include <linux/module.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/rtnetlink.h>
 #include <linux/vmalloc.h>
 #include <net/mac80211.h>
@@ -50,6 +51,26 @@ module_param_named(power_scheme, iwlmvm_mod_params.power_scheme, int, 0444);
 MODULE_PARM_DESC(power_scheme,
 		 "power management scheme: 1-active, 2-balanced, 3-low power, default: 2");
 
+netdev_features_t mvm_tx_csum_features __ro_after_init;
+netdev_features_t mvm_tx_csum_bz_features __ro_after_init;
+netdev_features_t mvm_csum_features_mask __ro_after_init;
+
+static void __init iwl_mvm_features_init(void)
+{
+	netdev_features_set_set(mvm_tx_csum_features,
+				NETIF_F_IPV6_CSUM_BIT,
+				NETIF_F_IP_CSUM_BIT,
+				NETIF_F_TSO_BIT,
+				NETIF_F_TSO6_BIT);
+	netdev_features_set_set(mvm_tx_csum_bz_features,
+				NETIF_F_HW_CSUM_BIT,
+				NETIF_F_TSO_BIT,
+				NETIF_F_TSO6_BIT);
+	netdev_features_or(mvm_csum_features_mask, mvm_tx_csum_features,
+			   mvm_tx_csum_bz_features);
+	netdev_feature_add(NETIF_F_RXCSUM_BIT, mvm_csum_features_mask);
+}
+
 /*
  * module init and exit functions
  */
@@ -67,6 +88,8 @@ static int __init iwl_mvm_init(void)
 	if (ret)
 		pr_err("Unable to register MVM op_mode: %d\n", ret);
 
+	iwl_mvm_features_init();
+
 	return ret;
 }
 module_init(iwl_mvm_init);
-- 
2.33.0

