Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F35F61EB77
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbiKGHPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbiKGHP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:15:27 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFD013D23;
        Sun,  6 Nov 2022 23:15:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667805319; x=1699341319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Sl/UlFRbpxcj5h6u33oYEDFn2aAVCNO7qWFey/KR9RI=;
  b=Em6zC7UyGrWMBMBL0vWWCF4x+cWxITQVotc0v5qUv6s5Zb7iLhN8rAM2
   Dm9fseaqCJyIzGbVXzVZ8pYfjZFFxrW7r0Nv3Vdi/PPqmkkhBs7/fquee
   MGT9Rt68ONyV90WlxYnAR9Vshi7xyp31/sO0GKtT1z1G6ysTWXS+O3epN
   AvvK6sZHP2nnlNR6DYsUIAgrBujd1634BafwDKIYPB92hUWsrdVYwBf27
   /KsUDqxK52aItQQA/uQWjDq6esUiEblTYC0qJWqzHje2dhDNOexW9zLzv
   KiXU1QmyYR9o2hmn6nASv610CPmy88jshXBJJvEGoD7XP77XEJnzk2fra
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="187874939"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Nov 2022 00:15:18 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 7 Nov 2022 00:15:12 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 7 Nov 2022 00:15:08 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <pabeni@redhat.com>, <edumazet@google.com>, <olteanv@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V7 2/2] net: lan743x: Add support to SGMII register dump for PCI11010/PCI11414 chips
Date:   Mon, 7 Nov 2022 12:44:50 +0530
Message-ID: <20221107071450.669700-3-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221107071450.669700-1-Raju.Lakkaraju@microchip.com>
References: <20221107071450.669700-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to SGMII register dump

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
Change List:
============
V5 -> V6:
 - Split change in two patches (i.e. unused argument in lan743x_common_regs
   change and SGMII register dump)
 - Fix the "ARRAY_SIZE" issue

V4 -> V5:
 - Remove the debug read function macro
 - Add auto variable structure to handle register definitions

V3 -> V4:
 - No changes. Patch on tags 6.1-rc1

V2 -> V3:
 - Remove the private flag option.
   As per review comment, use -w/-W to configure dump flag.
   But, change to -w/-W option, EEPROM/OTP data might be corrupt
   in case of wrong flag input.
   Need to fix this properly in future development.

V1 -> V2:
 - Add set_dump and get_dump_flag functions

V0 -> V1:
 - Removed unwanted code

 .../net/ethernet/microchip/lan743x_ethtool.c  | 105 +++++++++++++++++-
 .../net/ethernet/microchip/lan743x_ethtool.h  |  71 +++++++++++-
 drivers/net/ethernet/microchip/lan743x_main.c |   2 +-
 drivers/net/ethernet/microchip/lan743x_main.h |   1 +
 4 files changed, 176 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index aa1d79a9a1f2..d96df107503c 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -1218,17 +1218,120 @@ static void lan743x_common_regs(struct net_device *dev, void *p)
 	rb[ETH_WK_SRC]     = lan743x_csr_read(adapter, MAC_WK_SRC);
 }
 
+static void lan743x_sgmii_regs(struct net_device *dev, void *p)
+{
+	struct lan743x_adapter *adp = netdev_priv(dev);
+	u32 *rb = p;
+	u16 idx;
+	int val;
+	struct {
+		u8 id;
+		u8 dev;
+		u16 addr;
+	} regs[] = {
+		{ ETH_SR_VSMMD_DEV_ID1,                MDIO_MMD_VEND1, 0x0002},
+		{ ETH_SR_VSMMD_DEV_ID2,                MDIO_MMD_VEND1, 0x0003},
+		{ ETH_SR_VSMMD_PCS_ID1,                MDIO_MMD_VEND1, 0x0004},
+		{ ETH_SR_VSMMD_PCS_ID2,                MDIO_MMD_VEND1, 0x0005},
+		{ ETH_SR_VSMMD_STS,                    MDIO_MMD_VEND1, 0x0008},
+		{ ETH_SR_VSMMD_CTRL,                   MDIO_MMD_VEND1, 0x0009},
+		{ ETH_SR_MII_CTRL,                     MDIO_MMD_VEND2, 0x0000},
+		{ ETH_SR_MII_STS,                      MDIO_MMD_VEND2, 0x0001},
+		{ ETH_SR_MII_DEV_ID1,                  MDIO_MMD_VEND2, 0x0002},
+		{ ETH_SR_MII_DEV_ID2,                  MDIO_MMD_VEND2, 0x0003},
+		{ ETH_SR_MII_AN_ADV,                   MDIO_MMD_VEND2, 0x0004},
+		{ ETH_SR_MII_LP_BABL,                  MDIO_MMD_VEND2, 0x0005},
+		{ ETH_SR_MII_EXPN,                     MDIO_MMD_VEND2, 0x0006},
+		{ ETH_SR_MII_EXT_STS,                  MDIO_MMD_VEND2, 0x000F},
+		{ ETH_SR_MII_TIME_SYNC_ABL,            MDIO_MMD_VEND2, 0x0708},
+		{ ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_LWR, MDIO_MMD_VEND2, 0x0709},
+		{ ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_UPR, MDIO_MMD_VEND2, 0x070A},
+		{ ETH_SR_MII_TIME_SYNC_TX_MIN_DLY_LWR, MDIO_MMD_VEND2, 0x070B},
+		{ ETH_SR_MII_TIME_SYNC_TX_MIN_DLY_UPR, MDIO_MMD_VEND2, 0x070C},
+		{ ETH_SR_MII_TIME_SYNC_RX_MAX_DLY_LWR, MDIO_MMD_VEND2, 0x070D},
+		{ ETH_SR_MII_TIME_SYNC_RX_MAX_DLY_UPR, MDIO_MMD_VEND2, 0x070E},
+		{ ETH_SR_MII_TIME_SYNC_RX_MIN_DLY_LWR, MDIO_MMD_VEND2, 0x070F},
+		{ ETH_SR_MII_TIME_SYNC_RX_MIN_DLY_UPR, MDIO_MMD_VEND2, 0x0710},
+		{ ETH_VR_MII_DIG_CTRL1,                MDIO_MMD_VEND2, 0x8000},
+		{ ETH_VR_MII_AN_CTRL,                  MDIO_MMD_VEND2, 0x8001},
+		{ ETH_VR_MII_AN_INTR_STS,              MDIO_MMD_VEND2, 0x8002},
+		{ ETH_VR_MII_TC,                       MDIO_MMD_VEND2, 0x8003},
+		{ ETH_VR_MII_DBG_CTRL,                 MDIO_MMD_VEND2, 0x8005},
+		{ ETH_VR_MII_EEE_MCTRL0,               MDIO_MMD_VEND2, 0x8006},
+		{ ETH_VR_MII_EEE_TXTIMER,              MDIO_MMD_VEND2, 0x8008},
+		{ ETH_VR_MII_EEE_RXTIMER,              MDIO_MMD_VEND2, 0x8009},
+		{ ETH_VR_MII_LINK_TIMER_CTRL,          MDIO_MMD_VEND2, 0x800A},
+		{ ETH_VR_MII_EEE_MCTRL1,               MDIO_MMD_VEND2, 0x800B},
+		{ ETH_VR_MII_DIG_STS,                  MDIO_MMD_VEND2, 0x8010},
+		{ ETH_VR_MII_ICG_ERRCNT1,              MDIO_MMD_VEND2, 0x8011},
+		{ ETH_VR_MII_GPIO,                     MDIO_MMD_VEND2, 0x8015},
+		{ ETH_VR_MII_EEE_LPI_STATUS,           MDIO_MMD_VEND2, 0x8016},
+		{ ETH_VR_MII_EEE_WKERR,                MDIO_MMD_VEND2, 0x8017},
+		{ ETH_VR_MII_MISC_STS,                 MDIO_MMD_VEND2, 0x8018},
+		{ ETH_VR_MII_RX_LSTS,                  MDIO_MMD_VEND2, 0x8020},
+		{ ETH_VR_MII_GEN2_GEN4_TX_BSTCTRL0,    MDIO_MMD_VEND2, 0x8038},
+		{ ETH_VR_MII_GEN2_GEN4_TX_LVLCTRL0,    MDIO_MMD_VEND2, 0x803A},
+		{ ETH_VR_MII_GEN2_GEN4_TXGENCTRL0,     MDIO_MMD_VEND2, 0x803C},
+		{ ETH_VR_MII_GEN2_GEN4_TXGENCTRL1,     MDIO_MMD_VEND2, 0x803D},
+		{ ETH_VR_MII_GEN4_TXGENCTRL2,          MDIO_MMD_VEND2, 0x803E},
+		{ ETH_VR_MII_GEN2_GEN4_TX_STS,         MDIO_MMD_VEND2, 0x8048},
+		{ ETH_VR_MII_GEN2_GEN4_RXGENCTRL0,     MDIO_MMD_VEND2, 0x8058},
+		{ ETH_VR_MII_GEN2_GEN4_RXGENCTRL1,     MDIO_MMD_VEND2, 0x8059},
+		{ ETH_VR_MII_GEN4_RXEQ_CTRL,           MDIO_MMD_VEND2, 0x805B},
+		{ ETH_VR_MII_GEN4_RXLOS_CTRL0,         MDIO_MMD_VEND2, 0x805D},
+		{ ETH_VR_MII_GEN2_GEN4_MPLL_CTRL0,     MDIO_MMD_VEND2, 0x8078},
+		{ ETH_VR_MII_GEN2_GEN4_MPLL_CTRL1,     MDIO_MMD_VEND2, 0x8079},
+		{ ETH_VR_MII_GEN2_GEN4_MPLL_STS,       MDIO_MMD_VEND2, 0x8088},
+		{ ETH_VR_MII_GEN2_GEN4_LVL_CTRL,       MDIO_MMD_VEND2, 0x8090},
+		{ ETH_VR_MII_GEN4_MISC_CTRL2,          MDIO_MMD_VEND2, 0x8093},
+		{ ETH_VR_MII_GEN2_GEN4_MISC_CTRL0,     MDIO_MMD_VEND2, 0x8099},
+		{ ETH_VR_MII_GEN2_GEN4_MISC_CTRL1,     MDIO_MMD_VEND2, 0x809A},
+		{ ETH_VR_MII_SNPS_CR_CTRL,             MDIO_MMD_VEND2, 0x80A0},
+		{ ETH_VR_MII_SNPS_CR_ADDR,             MDIO_MMD_VEND2, 0x80A1},
+		{ ETH_VR_MII_SNPS_CR_DATA,             MDIO_MMD_VEND2, 0x80A2},
+		{ ETH_VR_MII_DIG_CTRL2,                MDIO_MMD_VEND2, 0x80E1},
+		{ ETH_VR_MII_DIG_ERRCNT,               MDIO_MMD_VEND2, 0x80E2},
+	};
+
+	for (idx = 0; idx < ARRAY_SIZE(regs); idx++) {
+		val = lan743x_sgmii_read(adp, regs[idx].dev, regs[idx].addr);
+		if (val < 0)
+			rb[regs[idx].id] = 0xFFFF;
+		else
+			rb[regs[idx].id] = val;
+	}
+}
+
 static int lan743x_get_regs_len(struct net_device *dev)
 {
-	return MAX_LAN743X_ETH_REGS * sizeof(u32);
+	struct lan743x_adapter *adapter = netdev_priv(dev);
+	u32 num_regs = MAX_LAN743X_ETH_COMMON_REGS;
+
+	if (adapter->is_sgmii_en)
+		num_regs += MAX_LAN743X_ETH_SGMII_REGS;
+
+	return num_regs * sizeof(u32);
 }
 
 static void lan743x_get_regs(struct net_device *dev,
 			     struct ethtool_regs *regs, void *p)
 {
+	struct lan743x_adapter *adapter = netdev_priv(dev);
+	int regs_len;
+
+	regs_len = lan743x_get_regs_len(dev);
+	memset(p, 0, regs_len);
+
 	regs->version = LAN743X_ETH_REG_VERSION;
+	regs->len = regs_len;
 
 	lan743x_common_regs(dev, p);
+	p = (u32 *)p + MAX_LAN743X_ETH_COMMON_REGS;
+
+	if (adapter->is_sgmii_en) {
+		lan743x_sgmii_regs(dev, p);
+		p = (u32 *)p + MAX_LAN743X_ETH_SGMII_REGS;
+	}
 }
 
 static void lan743x_get_pauseparam(struct net_device *dev,
diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.h b/drivers/net/ethernet/microchip/lan743x_ethtool.h
index 7f5996a52488..267d5035b8ad 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.h
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.h
@@ -29,7 +29,76 @@ enum {
 	ETH_WK_SRC,
 
 	/* Add new registers above */
-	MAX_LAN743X_ETH_REGS
+	MAX_LAN743X_ETH_COMMON_REGS
+};
+
+enum {
+	/* SGMII Register */
+	ETH_SR_VSMMD_DEV_ID1,
+	ETH_SR_VSMMD_DEV_ID2,
+	ETH_SR_VSMMD_PCS_ID1,
+	ETH_SR_VSMMD_PCS_ID2,
+	ETH_SR_VSMMD_STS,
+	ETH_SR_VSMMD_CTRL,
+	ETH_SR_MII_CTRL,
+	ETH_SR_MII_STS,
+	ETH_SR_MII_DEV_ID1,
+	ETH_SR_MII_DEV_ID2,
+	ETH_SR_MII_AN_ADV,
+	ETH_SR_MII_LP_BABL,
+	ETH_SR_MII_EXPN,
+	ETH_SR_MII_EXT_STS,
+	ETH_SR_MII_TIME_SYNC_ABL,
+	ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_LWR,
+	ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_UPR,
+	ETH_SR_MII_TIME_SYNC_TX_MIN_DLY_LWR,
+	ETH_SR_MII_TIME_SYNC_TX_MIN_DLY_UPR,
+	ETH_SR_MII_TIME_SYNC_RX_MAX_DLY_LWR,
+	ETH_SR_MII_TIME_SYNC_RX_MAX_DLY_UPR,
+	ETH_SR_MII_TIME_SYNC_RX_MIN_DLY_LWR,
+	ETH_SR_MII_TIME_SYNC_RX_MIN_DLY_UPR,
+	ETH_VR_MII_DIG_CTRL1,
+	ETH_VR_MII_AN_CTRL,
+	ETH_VR_MII_AN_INTR_STS,
+	ETH_VR_MII_TC,
+	ETH_VR_MII_DBG_CTRL,
+	ETH_VR_MII_EEE_MCTRL0,
+	ETH_VR_MII_EEE_TXTIMER,
+	ETH_VR_MII_EEE_RXTIMER,
+	ETH_VR_MII_LINK_TIMER_CTRL,
+	ETH_VR_MII_EEE_MCTRL1,
+	ETH_VR_MII_DIG_STS,
+	ETH_VR_MII_ICG_ERRCNT1,
+	ETH_VR_MII_GPIO,
+	ETH_VR_MII_EEE_LPI_STATUS,
+	ETH_VR_MII_EEE_WKERR,
+	ETH_VR_MII_MISC_STS,
+	ETH_VR_MII_RX_LSTS,
+	ETH_VR_MII_GEN2_GEN4_TX_BSTCTRL0,
+	ETH_VR_MII_GEN2_GEN4_TX_LVLCTRL0,
+	ETH_VR_MII_GEN2_GEN4_TXGENCTRL0,
+	ETH_VR_MII_GEN2_GEN4_TXGENCTRL1,
+	ETH_VR_MII_GEN4_TXGENCTRL2,
+	ETH_VR_MII_GEN2_GEN4_TX_STS,
+	ETH_VR_MII_GEN2_GEN4_RXGENCTRL0,
+	ETH_VR_MII_GEN2_GEN4_RXGENCTRL1,
+	ETH_VR_MII_GEN4_RXEQ_CTRL,
+	ETH_VR_MII_GEN4_RXLOS_CTRL0,
+	ETH_VR_MII_GEN2_GEN4_MPLL_CTRL0,
+	ETH_VR_MII_GEN2_GEN4_MPLL_CTRL1,
+	ETH_VR_MII_GEN2_GEN4_MPLL_STS,
+	ETH_VR_MII_GEN2_GEN4_LVL_CTRL,
+	ETH_VR_MII_GEN4_MISC_CTRL2,
+	ETH_VR_MII_GEN2_GEN4_MISC_CTRL0,
+	ETH_VR_MII_GEN2_GEN4_MISC_CTRL1,
+	ETH_VR_MII_SNPS_CR_CTRL,
+	ETH_VR_MII_SNPS_CR_ADDR,
+	ETH_VR_MII_SNPS_CR_DATA,
+	ETH_VR_MII_DIG_CTRL2,
+	ETH_VR_MII_DIG_ERRCNT,
+
+	/* Add new registers above */
+	MAX_LAN743X_ETH_SGMII_REGS
 };
 
 extern const struct ethtool_ops lan743x_ethtool_ops;
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index c0f8ba601c01..534840f9a7ca 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -939,7 +939,7 @@ static int lan743x_sgmii_wait_till_not_busy(struct lan743x_adapter *adapter)
 	return ret;
 }
 
-static int lan743x_sgmii_read(struct lan743x_adapter *adapter, u8 mmd, u16 addr)
+int lan743x_sgmii_read(struct lan743x_adapter *adapter, u8 mmd, u16 addr)
 {
 	u32 mmd_access;
 	int ret;
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index bc5eea4c7b40..8438c3dbcf36 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -1161,5 +1161,6 @@ int lan743x_hs_syslock_acquire(struct lan743x_adapter *adapter, u16 timeout);
 void lan743x_hs_syslock_release(struct lan743x_adapter *adapter);
 void lan743x_mac_flow_ctrl_set_enables(struct lan743x_adapter *adapter,
 				       bool tx_enable, bool rx_enable);
+int lan743x_sgmii_read(struct lan743x_adapter *adapter, u8 mmd, u16 addr);
 
 #endif /* _LAN743X_H */
-- 
2.25.1

