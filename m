Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB44D64C3EF
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 07:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237364AbiLNGoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 01:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLNGn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 01:43:58 -0500
X-Greylist: delayed 86690 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 13 Dec 2022 22:43:55 PST
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B308910B63
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 22:43:55 -0800 (PST)
X-QQ-mid: bizesmtp70t1671000229tq522o7x
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 14 Dec 2022 14:43:48 +0800 (CST)
X-QQ-SSF: 01400000000000H0X000B00A0000000
X-QQ-FEAT: pmyeiOl6PGls08DyVwSQmE1OieplW4y7i1nTLgcrp2dwy+6MyyzvCORKaefFN
        dw8K3BGyfPPjhrkTB3Bb4utq8K6vTka4dxudLWn6u9dknkmzrUCyS5PoUFwo1D8u8BD0xPv
        MU1RMaYe6ZrDnJ/3VEFwmDuhnGSy24pD53itXT+3+ZJD3LnbX6vxslu+hjQHFji/3qKp1uP
        kbDlno/Tl2Puyq5jCl4K5N5u/lkuJZadADWCZIuy09zoBOwhuGanSNtUV0wdk1xjbZCezUd
        iZXVm0zeED7T1PVynOEax00YGvZBaegsNOeanOjwLN5sK4Di27b7WIq4b176cZHkw+A/jvI
        c2dvQEvY3nNWNkes7x0pUNEUFv9CmFXSfYCS9+ZnRqdpMRPr0nj769QkEyydmasTuO9F1sm
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net v2 2/5] net: ngbe: Remove structure ngbe_hw
Date:   Wed, 14 Dec 2022 14:41:30 +0800
Message-Id: <20221214064133.2424570-3-jiawenwu@trustnetic.com>
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

Remove useless structure ngbe_hw to make the codes clear.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/ngbe/ngbe.h      | 46 -------------
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   | 20 +++---
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h   |  4 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 66 +++++++++----------
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h | 43 +++++++++++-
 5 files changed, 84 insertions(+), 95 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe.h b/drivers/net/ethernet/wangxun/ngbe/ngbe.h
index af147ca8605c..ed832ab3e5ed 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe.h
@@ -4,8 +4,6 @@
 #ifndef _NGBE_H_
 #define _NGBE_H_
 
-#include "ngbe_type.h"
-
 #define NGBE_MAX_FDIR_INDICES		7
 
 #define NGBE_MAX_RX_QUEUES		(NGBE_MAX_FDIR_INDICES + 1)
@@ -30,50 +28,6 @@
 #define NGBE_MAC_STATE_MODIFIED		0x2
 #define NGBE_MAC_STATE_IN_USE		0x4
 
-struct ngbe_mac_addr {
-	u8 addr[ETH_ALEN];
-	u16 state; /* bitmask */
-	u64 pools;
-};
-
-/* board specific private data structure */
-struct ngbe_adapter {
-	u8 __iomem *io_addr;    /* Mainly for iounmap use */
-	/* OS defined structs */
-	struct net_device *netdev;
-	struct pci_dev *pdev;
-
-	/* structs defined in ngbe_hw.h */
-	struct ngbe_hw hw;
-	struct ngbe_mac_addr *mac_table;
-	u16 msg_enable;
-
-	/* Tx fast path data */
-	int num_tx_queues;
-	u16 tx_itr_setting;
-	u16 tx_work_limit;
-
-	/* Rx fast path data */
-	int num_rx_queues;
-	u16 rx_itr_setting;
-	u16 rx_work_limit;
-
-	int num_q_vectors;      /* current number of q_vectors for device */
-	int max_q_vectors;      /* upper limit of q_vectors for device */
-
-	u32 tx_ring_count;
-	u32 rx_ring_count;
-
-#define NGBE_MAX_RETA_ENTRIES 128
-	u8 rss_indir_tbl[NGBE_MAX_RETA_ENTRIES];
-
-#define NGBE_RSS_KEY_SIZE     40  /* size of RSS Hash Key in bytes */
-	u32 *rss_key;
-	u32 wol;
-
-	u16 bd_number;
-};
-
 extern char ngbe_driver_name[];
 
 #endif /* _NGBE_H_ */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
index 0e3923b3737e..d54e22ce7c31 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
@@ -11,10 +11,10 @@
 #include "ngbe_hw.h"
 #include "ngbe.h"
 
-int ngbe_eeprom_chksum_hostif(struct ngbe_hw *hw)
+int ngbe_eeprom_chksum_hostif(struct ngbe_adapter *adapter)
 {
 	struct wx_hic_read_shadow_ram buffer;
-	struct wx_hw *wxhw = &hw->wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 	int status;
 	int tmp;
 
@@ -38,14 +38,14 @@ int ngbe_eeprom_chksum_hostif(struct ngbe_hw *hw)
 	return -EIO;
 }
 
-static int ngbe_reset_misc(struct ngbe_hw *hw)
+static int ngbe_reset_misc(struct ngbe_adapter *adapter)
 {
-	struct wx_hw *wxhw = &hw->wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 
 	wx_reset_misc(wxhw);
-	if (hw->mac_type == ngbe_mac_type_rgmii)
+	if (adapter->mac_type == ngbe_mac_type_rgmii)
 		wr32(wxhw, NGBE_MDIO_CLAUSE_SELECT, 0xF);
-	if (hw->gpio_ctrl) {
+	if (adapter->gpio_ctrl) {
 		/* gpio0 is used to power on/off control*/
 		wr32(wxhw, NGBE_GPIO_DDR, 0x1);
 		wr32(wxhw, NGBE_GPIO_DR, NGBE_GPIO_DR_0);
@@ -55,15 +55,15 @@ static int ngbe_reset_misc(struct ngbe_hw *hw)
 
 /**
  *  ngbe_reset_hw - Perform hardware reset
- *  @hw: pointer to hardware structure
+ *  @adapter: pointer to hardware structure
  *
  *  Resets the hardware by resetting the transmit and receive units, masks
  *  and clears all interrupts, perform a PHY reset, and perform a link (MAC)
  *  reset.
  **/
-int ngbe_reset_hw(struct ngbe_hw *hw)
+int ngbe_reset_hw(struct ngbe_adapter *adapter)
 {
-	struct wx_hw *wxhw = &hw->wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 	int status = 0;
 	u32 reset = 0;
 
@@ -73,7 +73,7 @@ int ngbe_reset_hw(struct ngbe_hw *hw)
 		return status;
 	reset = WX_MIS_RST_LAN_RST(wxhw->bus.func);
 	wr32(wxhw, WX_MIS_RST, reset | rd32(wxhw, WX_MIS_RST));
-	ngbe_reset_misc(hw);
+	ngbe_reset_misc(adapter);
 
 	/* Store the permanent mac address */
 	wx_get_mac_addr(wxhw, wxhw->mac.perm_addr);
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
index 42476a3fe57c..0683aefab0d9 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
@@ -7,6 +7,6 @@
 #ifndef _NGBE_HW_H_
 #define _NGBE_HW_H_
 
-int ngbe_eeprom_chksum_hostif(struct ngbe_hw *hw);
-int ngbe_reset_hw(struct ngbe_hw *hw);
+int ngbe_eeprom_chksum_hostif(struct ngbe_adapter *adapter);
+int ngbe_reset_hw(struct ngbe_adapter *adapter);
 #endif /* _NGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index f0b24366da18..5d679c39f451 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -41,25 +41,23 @@ static const struct pci_device_id ngbe_pci_tbl[] = {
 
 static void ngbe_mac_set_default_filter(struct ngbe_adapter *adapter, u8 *addr)
 {
-	struct ngbe_hw *hw = &adapter->hw;
-
 	memcpy(&adapter->mac_table[0].addr, addr, ETH_ALEN);
 	adapter->mac_table[0].pools = 1ULL;
 	adapter->mac_table[0].state = (NGBE_MAC_STATE_DEFAULT |
 				       NGBE_MAC_STATE_IN_USE);
-	wx_set_rar(&hw->wxhw, 0, adapter->mac_table[0].addr,
+	wx_set_rar(&adapter->wxhw, 0, adapter->mac_table[0].addr,
 		   adapter->mac_table[0].pools,
 		   WX_PSR_MAC_SWC_AD_H_AV);
 }
 
 /**
  *  ngbe_init_type_code - Initialize the shared code
- *  @hw: pointer to hardware structure
+ *  @adapter: pointer to hardware structure
  **/
-static void ngbe_init_type_code(struct ngbe_hw *hw)
+static void ngbe_init_type_code(struct ngbe_adapter *adapter)
 {
+	struct wx_hw *wxhw = &adapter->wxhw;
 	int wol_mask = 0, ncsi_mask = 0;
-	struct wx_hw *wxhw = &hw->wxhw;
 	u16 type_mask = 0;
 
 	wxhw->mac.type = wx_mac_em;
@@ -70,39 +68,39 @@ static void ngbe_init_type_code(struct ngbe_hw *hw)
 	switch (type_mask) {
 	case NGBE_SUBID_M88E1512_SFP:
 	case NGBE_SUBID_LY_M88E1512_SFP:
-		hw->phy.type = ngbe_phy_m88e1512_sfi;
+		adapter->phy.type = ngbe_phy_m88e1512_sfi;
 		break;
 	case NGBE_SUBID_M88E1512_RJ45:
-		hw->phy.type = ngbe_phy_m88e1512;
+		adapter->phy.type = ngbe_phy_m88e1512;
 		break;
 	case NGBE_SUBID_M88E1512_MIX:
-		hw->phy.type = ngbe_phy_m88e1512_unknown;
+		adapter->phy.type = ngbe_phy_m88e1512_unknown;
 		break;
 	case NGBE_SUBID_YT8521S_SFP:
 	case NGBE_SUBID_YT8521S_SFP_GPIO:
 	case NGBE_SUBID_LY_YT8521S_SFP:
-		hw->phy.type = ngbe_phy_yt8521s_sfi;
+		adapter->phy.type = ngbe_phy_yt8521s_sfi;
 		break;
 	case NGBE_SUBID_INTERNAL_YT8521S_SFP:
 	case NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO:
-		hw->phy.type = ngbe_phy_internal_yt8521s_sfi;
+		adapter->phy.type = ngbe_phy_internal_yt8521s_sfi;
 		break;
 	case NGBE_SUBID_RGMII_FPGA:
 	case NGBE_SUBID_OCP_CARD:
 		fallthrough;
 	default:
-		hw->phy.type = ngbe_phy_internal;
+		adapter->phy.type = ngbe_phy_internal;
 		break;
 	}
 
-	if (hw->phy.type == ngbe_phy_internal ||
-	    hw->phy.type == ngbe_phy_internal_yt8521s_sfi)
-		hw->mac_type = ngbe_mac_type_mdi;
+	if (adapter->phy.type == ngbe_phy_internal ||
+	    adapter->phy.type == ngbe_phy_internal_yt8521s_sfi)
+		adapter->mac_type = ngbe_mac_type_mdi;
 	else
-		hw->mac_type = ngbe_mac_type_rgmii;
+		adapter->mac_type = ngbe_mac_type_rgmii;
 
-	hw->wol_enabled = (wol_mask == NGBE_WOL_SUP) ? 1 : 0;
-	hw->ncsi_enabled = (ncsi_mask == NGBE_NCSI_MASK ||
+	adapter->wol_enabled = (wol_mask == NGBE_WOL_SUP) ? 1 : 0;
+	adapter->ncsi_enabled = (ncsi_mask == NGBE_NCSI_MASK ||
 			   type_mask == NGBE_SUBID_OCP_CARD) ? 1 : 0;
 
 	switch (type_mask) {
@@ -110,10 +108,10 @@ static void ngbe_init_type_code(struct ngbe_hw *hw)
 	case NGBE_SUBID_LY_M88E1512_SFP:
 	case NGBE_SUBID_YT8521S_SFP_GPIO:
 	case NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO:
-		hw->gpio_ctrl = 1;
+		adapter->gpio_ctrl = 1;
 		break;
 	default:
-		hw->gpio_ctrl = 0;
+		adapter->gpio_ctrl = 0;
 		break;
 	}
 }
@@ -147,8 +145,7 @@ static inline int ngbe_init_rss_key(struct ngbe_adapter *adapter)
 static int ngbe_sw_init(struct ngbe_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
-	struct ngbe_hw *hw = &adapter->hw;
-	struct wx_hw *wxhw = &hw->wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 	u16 msix_count = 0;
 	int err = 0;
 
@@ -164,7 +161,7 @@ static int ngbe_sw_init(struct ngbe_adapter *adapter)
 	}
 
 	/* mac type, phy type , oem type */
-	ngbe_init_type_code(hw);
+	ngbe_init_type_code(adapter);
 
 	wxhw->mac.max_rx_queues = NGBE_MAX_RX_QUEUES;
 	wxhw->mac.max_tx_queues = NGBE_MAX_TX_QUEUES;
@@ -221,8 +218,7 @@ static void ngbe_down(struct ngbe_adapter *adapter)
 static int ngbe_open(struct net_device *netdev)
 {
 	struct ngbe_adapter *adapter = netdev_priv(netdev);
-	struct ngbe_hw *hw = &adapter->hw;
-	struct wx_hw *wxhw = &hw->wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 
 	wx_control_hw(wxhw, true);
 
@@ -245,7 +241,7 @@ static int ngbe_close(struct net_device *netdev)
 	struct ngbe_adapter *adapter = netdev_priv(netdev);
 
 	ngbe_down(adapter);
-	wx_control_hw(&adapter->hw.wxhw, false);
+	wx_control_hw(&adapter->wxhw, false);
 
 	return 0;
 }
@@ -266,7 +262,7 @@ static netdev_tx_t ngbe_xmit_frame(struct sk_buff *skb,
 static int ngbe_set_mac(struct net_device *netdev, void *p)
 {
 	struct ngbe_adapter *adapter = netdev_priv(netdev);
-	struct wx_hw *wxhw = &adapter->hw.wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 	struct sockaddr *addr = p;
 
 	if (!is_valid_ether_addr(addr->sa_data))
@@ -291,7 +287,7 @@ static void ngbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 	if (netif_running(netdev))
 		ngbe_down(adapter);
 	rtnl_unlock();
-	wx_control_hw(&adapter->hw.wxhw, false);
+	wx_control_hw(&adapter->wxhw, false);
 
 	pci_disable_device(pdev);
 }
@@ -334,7 +330,6 @@ static int ngbe_probe(struct pci_dev *pdev,
 		      const struct pci_device_id __always_unused *ent)
 {
 	struct ngbe_adapter *adapter = NULL;
-	struct ngbe_hw *hw = NULL;
 	struct wx_hw *wxhw = NULL;
 	struct net_device *netdev;
 	u32 e2rom_cksum_cap = 0;
@@ -381,8 +376,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 	adapter = netdev_priv(netdev);
 	adapter->netdev = netdev;
 	adapter->pdev = pdev;
-	hw = &adapter->hw;
-	wxhw = &hw->wxhw;
+	wxhw = &adapter->wxhw;
 	adapter->msg_enable = BIT(3) - 1;
 
 	adapter->io_addr = devm_ioremap(&pdev->dev,
@@ -417,7 +411,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 		goto err_free_mac_table;
 	}
 
-	err = ngbe_reset_hw(hw);
+	err = ngbe_reset_hw(adapter);
 	if (err) {
 		dev_err(&pdev->dev, "HW Init failed: %d\n", err);
 		goto err_free_mac_table;
@@ -434,7 +428,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 	wx_init_eeprom_params(wxhw);
 	if (wxhw->bus.func == 0 || e2rom_cksum_cap == 0) {
 		/* make sure the EEPROM is ready */
-		err = ngbe_eeprom_chksum_hostif(hw);
+		err = ngbe_eeprom_chksum_hostif(adapter);
 		if (err) {
 			dev_err(&pdev->dev, "The EEPROM Checksum Is Not Valid\n");
 			err = -EIO;
@@ -443,10 +437,10 @@ static int ngbe_probe(struct pci_dev *pdev,
 	}
 
 	adapter->wol = 0;
-	if (hw->wol_enabled)
+	if (adapter->wol_enabled)
 		adapter->wol = NGBE_PSR_WKUP_CTL_MAG;
 
-	hw->wol_enabled = !!(adapter->wol);
+	adapter->wol_enabled = !!(adapter->wol);
 	wr32(wxhw, NGBE_PSR_WKUP_CTL, adapter->wol);
 
 	device_set_wakeup_enable(&pdev->dev, adapter->wol);
@@ -479,7 +473,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 
 	netif_info(adapter, probe, netdev,
 		   "PHY: %s, PBA No: Wang Xun GbE Family Controller\n",
-		   hw->phy.type == ngbe_phy_internal ? "Internal" : "External");
+		   adapter->phy.type == ngbe_phy_internal ? "Internal" : "External");
 	netif_info(adapter, probe, netdev, "%pM\n", netdev->dev_addr);
 
 	return 0;
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
index 39f6c03f1a54..5a64ce6ded8f 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
@@ -127,7 +127,19 @@ struct ngbe_phy_info {
 
 };
 
-struct ngbe_hw {
+struct ngbe_mac_addr {
+	u8 addr[ETH_ALEN];
+	u16 state; /* bitmask */
+	u64 pools;
+};
+
+/* board specific private data structure */
+struct ngbe_adapter {
+	u8 __iomem *io_addr;    /* Mainly for iounmap use */
+	/* OS defined structs */
+	struct net_device *netdev;
+	struct pci_dev *pdev;
+
 	struct wx_hw wxhw;
 	struct ngbe_phy_info phy;
 	enum ngbe_mac_type mac_type;
@@ -135,5 +147,34 @@ struct ngbe_hw {
 	bool wol_enabled;
 	bool ncsi_enabled;
 	bool gpio_ctrl;
+
+	struct ngbe_mac_addr *mac_table;
+	u16 msg_enable;
+
+	/* Tx fast path data */
+	int num_tx_queues;
+	u16 tx_itr_setting;
+	u16 tx_work_limit;
+
+	/* Rx fast path data */
+	int num_rx_queues;
+	u16 rx_itr_setting;
+	u16 rx_work_limit;
+
+	int num_q_vectors;      /* current number of q_vectors for device */
+	int max_q_vectors;      /* upper limit of q_vectors for device */
+
+	u32 tx_ring_count;
+	u32 rx_ring_count;
+
+#define NGBE_MAX_RETA_ENTRIES 128
+	u8 rss_indir_tbl[NGBE_MAX_RETA_ENTRIES];
+
+#define NGBE_RSS_KEY_SIZE     40  /* size of RSS Hash Key in bytes */
+	u32 *rss_key;
+	u32 wol;
+
+	u16 bd_number;
 };
+
 #endif /* _NGBE_TYPE_H_ */
-- 
2.27.0

