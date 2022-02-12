Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7179D4B361A
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 16:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236645AbiBLPyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 10:54:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236493AbiBLPyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 10:54:01 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F56B20E
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 07:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644681238; x=1676217238;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2Dp91ojd+miutSFLMxVq5bYEvnOPXs6wGqevFR5lUpU=;
  b=CRbajgKWHJx0LAO3fRdELmGkTqEjWURQcJsfc6ZDSexuWehcgFdeU43a
   oUZ57PjnXsCXroY3Oy/UletJVZg2gA1N6stu5hLqhAELfvpqyNIG2T5Xo
   zDloOEE9VEk28vIvVhtBCLXVPSymE65JF10KNMdN46BM89DANdo42Tv/l
   II2LiZfAkRDdC4108AEKUdyokJsgUnIvJKGqLxxNgi4iC15oytUN9HLm1
   BsV0p51ROYUX/QXRiQ1dHXYgnsxhT3hllY4sexClbeR81Bh1GwMuJHQOj
   w8xBovHcCkFIgK6NAFILqdOWQeQixaVElIUV1aQC60dlHvsCC8lHg8vNc
   A==;
IronPort-SDR: JTkUKKtwx6ckvQuf8yvvcjdnO107nU1FKijDxPGNWMoeIZQj/XYGSFekwW0PLFdlx95lyN8bJY
 yy2SZgPZXm2AM88rzrzmp5JVPoCoABgFc+JzBbooWBS3kWHEy8gjiqpd6K8zpoeuwFg4DCXT/6
 Mf0MZ7dn+HXLheYfPiXxW6kr/BlSEnqVIHCl3PWHeuRdBa4JmXkU0SPuEZoe3TZB+Z2J1RuC5D
 7WsoDZAbo/qAEv7a+jkTZ2kE9hcvBgyjD5V91bmBNEN3tW3tBYwwqZCBHOQuqJzbTxozTKkySL
 VdKiF9g6y8A++oJIhYqyaZWm
X-IronPort-AV: E=Sophos;i="5.88,363,1635231600"; 
   d="scan'208";a="152858653"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Feb 2022 08:53:57 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 12 Feb 2022 08:53:33 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 12 Feb 2022 08:53:31 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next V1 4/5] net: lan743x: Add support for SGMII interface
Date:   Sat, 12 Feb 2022 21:23:14 +0530
Message-ID: <20220212155315.340359-5-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220212155315.340359-1-Raju.Lakkaraju@microchip.com>
References: <20220212155315.340359-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change facilitates the selection between SGMII and (R)GIII
interfaces

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
Changes:
 V1: 1. Replace "netif_info" with "netif_dbg"
     2. Add strap check for ASIC and FPGA device configuration
     3. Based on review comments, optimise the code

 drivers/net/ethernet/microchip/lan743x_main.c | 48 +++++++++++++++++++
 drivers/net/ethernet/microchip/lan743x_main.h | 17 +++++++
 2 files changed, 65 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 814d825e3deb..8b0890aa66fa 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -18,6 +18,34 @@
 #include "lan743x_main.h"
 #include "lan743x_ethtool.h"
 
+static void pci11x1x_strap_get_status(struct lan743x_adapter *adapter)
+{
+	u32 chip_rev;
+	u32 strap;
+
+	strap = lan743x_csr_read(adapter, STRAP_READ);
+	if (strap & STRAP_READ_USE_SGMII_EN_) {
+		if (strap & STRAP_READ_SGMII_EN_)
+			adapter->is_sgmii_en = true;
+		else
+			adapter->is_sgmii_en = false;
+		netif_dbg(adapter, drv, adapter->netdev,
+			  "STRAP_READ: 0x%08X\n", strap);
+	} else {
+		chip_rev = lan743x_csr_read(adapter, FPGA_REV);
+		if (chip_rev) {
+			if (chip_rev & FPGA_SGMII_OP)
+				adapter->is_sgmii_en = true;
+			else
+				adapter->is_sgmii_en = false;
+			netif_dbg(adapter, drv, adapter->netdev,
+				  "FPGA_REV: 0x%08X\n", chip_rev);
+		} else {
+			adapter->is_sgmii_en = false;
+		}
+	}
+}
+
 static bool is_pci11x1x_chip(struct lan743x_adapter *adapter)
 {
 	struct lan743x_csr *csr = &adapter->csr;
@@ -2744,6 +2772,7 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 		adapter->max_tx_channels = PCI11X1X_MAX_TX_CHANNELS;
 		adapter->used_tx_channels = PCI11X1X_USED_TX_CHANNELS;
 		adapter->max_vector_count = PCI11X1X_MAX_VECTOR_COUNT;
+		pci11x1x_strap_get_status(adapter);
 	} else {
 		adapter->max_tx_channels = LAN743X_MAX_TX_CHANNELS;
 		adapter->used_tx_channels = LAN743X_USED_TX_CHANNELS;
@@ -2792,6 +2821,7 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 
 static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 {
+	u32 sgmii_ctl;
 	int ret;
 
 	adapter->mdiobus = devm_mdiobus_alloc(&adapter->pdev->dev);
@@ -2801,6 +2831,24 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 	}
 
 	adapter->mdiobus->priv = (void *)adapter;
+	if (adapter->is_pci11x1x) {
+		if (adapter->is_sgmii_en) {
+			sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
+			sgmii_ctl |= SGMII_CTL_SGMII_ENABLE_;
+			sgmii_ctl &= ~SGMII_CTL_SGMII_POWER_DN_;
+			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
+			netif_dbg(adapter, drv, adapter->netdev,
+				  "SGMII operation\n");
+		} else {
+			sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
+			sgmii_ctl &= ~SGMII_CTL_SGMII_ENABLE_;
+			sgmii_ctl |= SGMII_CTL_SGMII_POWER_DN_;
+			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
+			netif_dbg(adapter, drv, adapter->netdev,
+					  "(R)GMII operation\n");
+		}
+	}
+
 	adapter->mdiobus->read = lan743x_mdiobus_read;
 	adapter->mdiobus->write = lan743x_mdiobus_write;
 	adapter->mdiobus->name = "lan743x-mdiobus";
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 9a3ac9df4209..7c387ca2d25c 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -30,6 +30,17 @@
 #define FPGA_REV			(0x04)
 #define FPGA_REV_GET_MINOR_(fpga_rev)	(((fpga_rev) >> 8) & 0x000000FF)
 #define FPGA_REV_GET_MAJOR_(fpga_rev)	((fpga_rev) & 0x000000FF)
+#define FPGA_SGMII_OP			BIT(24)
+
+#define STRAP_READ			(0x0C)
+#define STRAP_READ_USE_SGMII_EN_	BIT(22)
+#define STRAP_READ_SGMII_EN_		BIT(6)
+#define STRAP_READ_SGMII_REFCLK_	BIT(5)
+#define STRAP_READ_SGMII_2_5G_		BIT(4)
+#define STRAP_READ_BASE_X_		BIT(3)
+#define STRAP_READ_RGMII_TXC_DELAY_EN_	BIT(2)
+#define STRAP_READ_RGMII_RXC_DELAY_EN_	BIT(1)
+#define STRAP_READ_ADV_PM_DISABLE_	BIT(0)
 
 #define HW_CFG					(0x010)
 #define HW_CFG_RELOAD_TYPE_ALL_			(0x00000FC0)
@@ -219,6 +230,11 @@
 
 #define MAC_WUCSR2			(0x600)
 
+#define SGMII_CTL			(0x728)
+#define SGMII_CTL_SGMII_ENABLE_		BIT(31)
+#define SGMII_CTL_LINK_STATUS_SOURCE_	BIT(8)
+#define SGMII_CTL_SGMII_POWER_DN_	BIT(1)
+
 #define INT_STS				(0x780)
 #define INT_BIT_DMA_RX_(channel)	BIT(24 + (channel))
 #define INT_BIT_ALL_RX_			(0x0F000000)
@@ -739,6 +755,7 @@ struct lan743x_adapter {
 	struct lan743x_tx       tx[PCI11X1X_USED_TX_CHANNELS];
 	struct lan743x_rx       rx[LAN743X_USED_RX_CHANNELS];
 	bool			is_pci11x1x;
+	bool			is_sgmii_en;
 	u8			max_tx_channels;
 	u8			used_tx_channels;
 	u8			max_vector_count;
-- 
2.25.1

