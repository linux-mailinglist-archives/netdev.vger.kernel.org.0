Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA83E64C3EE
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 07:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237366AbiLNGn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 01:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237364AbiLNGny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 01:43:54 -0500
X-Greylist: delayed 86754 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 13 Dec 2022 22:43:52 PST
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABB610B65
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 22:43:51 -0800 (PST)
X-QQ-mid: bizesmtp70t1671000226tp28165l
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 14 Dec 2022 14:43:45 +0800 (CST)
X-QQ-SSF: 01400000000000H0X000B00A0000000
X-QQ-FEAT: Fc2LLDWeHZ+cS+suY5PRNWaUW9nTRDFqBJJ0J2lZ97pJvqQZLD5lfcAKJx+Mu
        prODVFfsp7+NppUTz7hnu6svo2ISx0iCwF2kRIJjnFvaNulA2oAhujrkRvCzyE79s54xR9y
        qW+WC7NiI5xA+e9w04GENRWaxQS2SQgkFqo7BJKlaL0A3esD66W5FlLqutaXdyWh9It7dET
        D+ifM83IqyI3R455w956T+49i+A6LZVmzbr6cR7xO9JMk+JEtB1Qd1LwWR/DQdhtuz6hUNG
        M/tkfs0VEwkivwQWpOHBUyn0zjSrisUMFx0Fk8bDppQmw9TM+9QEH5+Crt4maPHqVYg5ZaU
        JZnV97GS2/6cpfUGYlGGjj14y4WebuXJfUpgXZyXfYHbMVAipN9wd7FaXLw0C3XqFUOJClv
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net v2 1/5] net: txgbe: Remove structure txgbe_hw
Date:   Wed, 14 Dec 2022 14:41:29 +0800
Message-Id: <20221214064133.2424570-2-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221214064133.2424570-1-jiawenwu@trustnetic.com>
References: <20221214064133.2424570-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove useless structure txgbe_hw to make the codes clear.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    | 20 ----------
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 35 +++++++----------
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |  6 +--
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 38 ++++++++-----------
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 16 +++++++-
 5 files changed, 48 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 19e61377bd00..629c139926c5 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -14,30 +14,10 @@
 #define TXGBE_SP_RAR_ENTRIES    128
 #define TXGBE_SP_MC_TBL_SIZE    128
 
-struct txgbe_mac_addr {
-	u8 addr[ETH_ALEN];
-	u16 state; /* bitmask */
-	u64 pools;
-};
-
 #define TXGBE_MAC_STATE_DEFAULT         0x1
 #define TXGBE_MAC_STATE_MODIFIED        0x2
 #define TXGBE_MAC_STATE_IN_USE          0x4
 
-/* board specific private data structure */
-struct txgbe_adapter {
-	u8 __iomem *io_addr;    /* Mainly for iounmap use */
-	/* OS defined structs */
-	struct net_device *netdev;
-	struct pci_dev *pdev;
-
-	/* structs defined in txgbe_type.h */
-	struct txgbe_hw hw;
-	u16 msg_enable;
-	struct txgbe_mac_addr *mac_table;
-	char eeprom_id[32];
-};
-
 extern char txgbe_driver_name[];
 
 #endif /* _TXGBE_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 167f7ff73192..9b8826a29981 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -16,14 +16,13 @@
 
 /**
  *  txgbe_init_thermal_sensor_thresh - Inits thermal sensor thresholds
- *  @hw: pointer to hardware structure
+ *  @wxhw: pointer to hardware structure
  *
  *  Inits the thermal sensor thresholds according to the NVM map
  *  and save off the threshold and location values into mac.thermal_sensor_data
  **/
-static void txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw)
+static void txgbe_init_thermal_sensor_thresh(struct wx_hw *wxhw)
 {
-	struct wx_hw *wxhw = &hw->wxhw;
 	struct wx_thermal_sensor_data *data = &wxhw->mac.sensor;
 
 	memset(data, 0, sizeof(struct wx_thermal_sensor_data));
@@ -46,16 +45,15 @@ static void txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw)
 
 /**
  *  txgbe_read_pba_string - Reads part number string from EEPROM
- *  @hw: pointer to hardware structure
+ *  @wxhw: pointer to hardware structure
  *  @pba_num: stores the part number string from the EEPROM
  *  @pba_num_size: part number string buffer length
  *
  *  Reads the part number string from the EEPROM.
  **/
-int txgbe_read_pba_string(struct txgbe_hw *hw, u8 *pba_num, u32 pba_num_size)
+int txgbe_read_pba_string(struct wx_hw *wxhw, u8 *pba_num, u32 pba_num_size)
 {
 	u16 pba_ptr, offset, length, data;
-	struct wx_hw *wxhw = &hw->wxhw;
 	int ret_val;
 
 	if (!pba_num) {
@@ -155,14 +153,13 @@ int txgbe_read_pba_string(struct txgbe_hw *hw, u8 *pba_num, u32 pba_num_size)
 
 /**
  *  txgbe_calc_eeprom_checksum - Calculates and returns the checksum
- *  @hw: pointer to hardware structure
+ *  @wxhw: pointer to hardware structure
  *  @checksum: pointer to cheksum
  *
  *  Returns a negative error code on error
  **/
-static int txgbe_calc_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum)
+static int txgbe_calc_eeprom_checksum(struct wx_hw *wxhw, u16 *checksum)
 {
-	struct wx_hw *wxhw = &hw->wxhw;
 	u16 *eeprom_ptrs = NULL;
 	u32 buffer_size = 0;
 	u16 *buffer = NULL;
@@ -210,15 +207,14 @@ static int txgbe_calc_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum)
 
 /**
  *  txgbe_validate_eeprom_checksum - Validate EEPROM checksum
- *  @hw: pointer to hardware structure
+ *  @wxhw: pointer to hardware structure
  *  @checksum_val: calculated checksum
  *
  *  Performs checksum calculation and validates the EEPROM checksum.  If the
  *  caller does not need checksum_val, the value can be NULL.
  **/
-int txgbe_validate_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum_val)
+int txgbe_validate_eeprom_checksum(struct wx_hw *wxhw, u16 *checksum_val)
 {
-	struct wx_hw *wxhw = &hw->wxhw;
 	u16 read_checksum = 0;
 	u16 checksum;
 	int status;
@@ -234,7 +230,7 @@ int txgbe_validate_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum_val)
 	}
 
 	checksum = 0;
-	status = txgbe_calc_eeprom_checksum(hw, &checksum);
+	status = txgbe_calc_eeprom_checksum(wxhw, &checksum);
 	if (status != 0)
 		return status;
 
@@ -258,25 +254,22 @@ int txgbe_validate_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum_val)
 	return status;
 }
 
-static void txgbe_reset_misc(struct txgbe_hw *hw)
+static void txgbe_reset_misc(struct wx_hw *wxhw)
 {
-	struct wx_hw *wxhw = &hw->wxhw;
-
 	wx_reset_misc(wxhw);
-	txgbe_init_thermal_sensor_thresh(hw);
+	txgbe_init_thermal_sensor_thresh(wxhw);
 }
 
 /**
  *  txgbe_reset_hw - Perform hardware reset
- *  @hw: pointer to hardware structure
+ *  @wxhw: pointer to hardware structure
  *
  *  Resets the hardware by resetting the transmit and receive units, masks
  *  and clears all interrupts, perform a PHY reset, and perform a link (MAC)
  *  reset.
  **/
-int txgbe_reset_hw(struct txgbe_hw *hw)
+int txgbe_reset_hw(struct wx_hw *wxhw)
 {
-	struct wx_hw *wxhw = &hw->wxhw;
 	int status;
 
 	/* Call adapter stop to disable tx/rx and clear interrupts */
@@ -294,7 +287,7 @@ int txgbe_reset_hw(struct txgbe_hw *hw)
 	if (status != 0)
 		return status;
 
-	txgbe_reset_misc(hw);
+	txgbe_reset_misc(wxhw);
 
 	/* Store the permanent mac address */
 	wx_get_mac_addr(wxhw, wxhw->mac.perm_addr);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index 6a751a69177b..b4f34ab91a38 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -4,8 +4,8 @@
 #ifndef _TXGBE_HW_H_
 #define _TXGBE_HW_H_
 
-int txgbe_read_pba_string(struct txgbe_hw *hw, u8 *pba_num, u32 pba_num_size);
-int txgbe_validate_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum_val);
-int txgbe_reset_hw(struct txgbe_hw *hw);
+int txgbe_read_pba_string(struct wx_hw *wxhw, u8 *pba_num, u32 pba_num_size);
+int txgbe_validate_eeprom_checksum(struct wx_hw *wxhw, u16 *checksum_val);
+int txgbe_reset_hw(struct wx_hw *wxhw);
 
 #endif /* _TXGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 36780e7f05b7..980523e29f01 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -75,8 +75,7 @@ static int txgbe_enumerate_functions(struct txgbe_adapter *adapter)
 
 static void txgbe_sync_mac_table(struct txgbe_adapter *adapter)
 {
-	struct txgbe_hw *hw = &adapter->hw;
-	struct wx_hw *wxhw = &hw->wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 	int i;
 
 	for (i = 0; i < wxhw->mac.num_rar_entries; i++) {
@@ -98,7 +97,7 @@ static void txgbe_sync_mac_table(struct txgbe_adapter *adapter)
 static void txgbe_mac_set_default_filter(struct txgbe_adapter *adapter,
 					 u8 *addr)
 {
-	struct wx_hw *wxhw = &adapter->hw.wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 
 	memcpy(&adapter->mac_table[0].addr, addr, ETH_ALEN);
 	adapter->mac_table[0].pools = 1ULL;
@@ -111,7 +110,7 @@ static void txgbe_mac_set_default_filter(struct txgbe_adapter *adapter,
 
 static void txgbe_flush_sw_mac_table(struct txgbe_adapter *adapter)
 {
-	struct wx_hw *wxhw = &adapter->hw.wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 	u32 i;
 
 	for (i = 0; i < wxhw->mac.num_rar_entries; i++) {
@@ -125,7 +124,7 @@ static void txgbe_flush_sw_mac_table(struct txgbe_adapter *adapter)
 
 static int txgbe_del_mac_filter(struct txgbe_adapter *adapter, u8 *addr, u16 pool)
 {
-	struct wx_hw *wxhw = &adapter->hw.wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 	u32 i;
 
 	if (is_zero_ether_addr(addr))
@@ -160,8 +159,7 @@ static int txgbe_del_mac_filter(struct txgbe_adapter *adapter, u8 *addr, u16 poo
 
 static void txgbe_up_complete(struct txgbe_adapter *adapter)
 {
-	struct txgbe_hw *hw = &adapter->hw;
-	struct wx_hw *wxhw = &hw->wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 
 	wx_control_hw(wxhw, true);
 }
@@ -169,11 +167,11 @@ static void txgbe_up_complete(struct txgbe_adapter *adapter)
 static void txgbe_reset(struct txgbe_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
-	struct txgbe_hw *hw = &adapter->hw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 	u8 old_addr[ETH_ALEN];
 	int err;
 
-	err = txgbe_reset_hw(hw);
+	err = txgbe_reset_hw(wxhw);
 	if (err != 0)
 		dev_err(&adapter->pdev->dev, "Hardware Error: %d\n", err);
 
@@ -186,7 +184,7 @@ static void txgbe_reset(struct txgbe_adapter *adapter)
 static void txgbe_disable_device(struct txgbe_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
-	struct wx_hw *wxhw = &adapter->hw.wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 
 	wx_disable_pcie_master(wxhw);
 	/* disable receives */
@@ -225,8 +223,7 @@ static void txgbe_down(struct txgbe_adapter *adapter)
 static int txgbe_sw_init(struct txgbe_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
-	struct txgbe_hw *hw = &adapter->hw;
-	struct wx_hw *wxhw = &hw->wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 	int err;
 
 	wxhw->hw_addr = adapter->io_addr;
@@ -313,7 +310,7 @@ static int txgbe_close(struct net_device *netdev)
 	struct txgbe_adapter *adapter = netdev_priv(netdev);
 
 	txgbe_down(adapter);
-	wx_control_hw(&adapter->hw.wxhw, false);
+	wx_control_hw(&adapter->wxhw, false);
 
 	return 0;
 }
@@ -322,8 +319,7 @@ static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
 	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev = adapter->netdev;
-	struct txgbe_hw *hw = &adapter->hw;
-	struct wx_hw *wxhw = &hw->wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 
 	netif_device_detach(netdev);
 
@@ -365,7 +361,7 @@ static netdev_tx_t txgbe_xmit_frame(struct sk_buff *skb,
 static int txgbe_set_mac(struct net_device *netdev, void *p)
 {
 	struct txgbe_adapter *adapter = netdev_priv(netdev);
-	struct wx_hw *wxhw = &adapter->hw.wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 	struct sockaddr *addr = p;
 	int retval;
 
@@ -405,7 +401,6 @@ static int txgbe_probe(struct pci_dev *pdev,
 		       const struct pci_device_id __always_unused *ent)
 {
 	struct txgbe_adapter *adapter = NULL;
-	struct txgbe_hw *hw = NULL;
 	struct wx_hw *wxhw = NULL;
 	struct net_device *netdev;
 	int err, expected_gts;
@@ -453,8 +448,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	adapter = netdev_priv(netdev);
 	adapter->netdev = netdev;
 	adapter->pdev = pdev;
-	hw = &adapter->hw;
-	wxhw = &hw->wxhw;
+	wxhw = &adapter->wxhw;
 	adapter->msg_enable = (1 << DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
 
 	adapter->io_addr = devm_ioremap(&pdev->dev,
@@ -486,7 +480,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 		goto err_free_mac_table;
 	}
 
-	err = txgbe_reset_hw(hw);
+	err = txgbe_reset_hw(wxhw);
 	if (err) {
 		dev_err(&pdev->dev, "HW Init failed: %d\n", err);
 		goto err_free_mac_table;
@@ -495,7 +489,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	netdev->features |= NETIF_F_HIGHDMA;
 
 	/* make sure the EEPROM is good */
-	err = txgbe_validate_eeprom_checksum(hw, NULL);
+	err = txgbe_validate_eeprom_checksum(wxhw, NULL);
 	if (err != 0) {
 		dev_err(&pdev->dev, "The EEPROM Checksum Is Not Valid\n");
 		wr32(wxhw, WX_MIS_RST, WX_MIS_RST_SW_RST);
@@ -565,7 +559,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 		dev_warn(&pdev->dev, "Failed to enumerate PF devices.\n");
 
 	/* First try to read PBA as a string */
-	err = txgbe_read_pba_string(hw, part_str, TXGBE_PBANUM_LENGTH);
+	err = txgbe_read_pba_string(wxhw, part_str, TXGBE_PBANUM_LENGTH);
 	if (err)
 		strncpy(part_str, "Unknown", TXGBE_PBANUM_LENGTH);
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 740a1c447e20..0cc333a11cab 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -67,8 +67,22 @@
 #define TXGBE_PBANUM1_PTR                       0x06
 #define TXGBE_PBANUM_PTR_GUARD                  0xFAFA
 
-struct txgbe_hw {
+struct txgbe_mac_addr {
+	u8 addr[ETH_ALEN];
+	u16 state; /* bitmask */
+	u64 pools;
+};
+
+/* board specific private data structure */
+struct txgbe_adapter {
+	u8 __iomem *io_addr;
+	/* OS defined structs */
+	struct net_device *netdev;
+	struct pci_dev *pdev;
 	struct wx_hw wxhw;
+	u16 msg_enable;
+	struct txgbe_mac_addr *mac_table;
+	char eeprom_id[32];
 };
 
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0

