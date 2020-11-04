Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EBD2A6050
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 10:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgKDJKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 04:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728586AbgKDJG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 04:06:26 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDB1C040203
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 01:06:25 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id d142so1607917wmd.4
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 01:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D0aje7znnyCcuhdDe70XckIGCUNEYtXa5x7TCAbIvC0=;
        b=i1auLP28ZX6Tx2Qq8HzP8vgzDZtmIvoGS7mqjS9UiN11JzcSzmGfV6/P/Hy5qEB/wa
         c2fRKcRdOkKBdDLbrfyBUD0gc5ONavKPWObTXJczemN9TbWFZkperGQ8Qr8CYsp2guLb
         UASYdrAsLMLA5CApazgLRBvBMQuznz8QKFq4SM4MyrPWtDi/h2Hilig6JgeWCvbPXnU2
         NwcBv7DTKEeAH/yHjM/xD/VM4h3bfhwL90j8v4tvZkPJxOzuVgc3mUYnSA+Fbj5wz1Kc
         TbQcoS5UKMmbHEUGQD8qSZXrCXQd971A5NywK5poBzU5ER8FQMmAs3W/LQ2DPcnsSdky
         1K8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D0aje7znnyCcuhdDe70XckIGCUNEYtXa5x7TCAbIvC0=;
        b=VQgQBRvCwDBJAbpqVaE8QMPA9Ul/DzuVbHkgoTEKLrduWsHtJUhWjgJOmOAaLwCkdv
         r6n001BZVwOTUYvXMarAnsipbCrk/tFXgQD3yxOEnGFOc/VXqCNu/FyR72XnJbUFWxyn
         C8E8VyXX+ZOn4lmlOC9sfhuplq/fR9x357hSrWvwU85MFB3J4s93cDUv9JM2RjzCawv0
         1+OmqrWSCCL4xlt79IgAXMXD7QPmKhpO6FD8GNCIs3XZJ2RsI4o/oJ9G5bI+gynGpCCL
         iewmEttemCO6qqy50Zi/cwlgW7Yy3mnfu8QH9jV8N2k9RCo8DrXhjD6cAP1SGWo7IYMy
         BoQQ==
X-Gm-Message-State: AOAM5308grR7Np8tqoqN6zUACm2GkMhVtQhkPBg9PX9N/7ihslpURYhd
        a0DOKblHz7MV36jsNXcmxuVhdg==
X-Google-Smtp-Source: ABdhPJyo3VvPetZlt2jTbqUfxgx2y301ZcEN0ty1/357xm3X60va5Wyl1ikPvzMi4j80HQz1wfalJA==
X-Received: by 2002:a1c:20c6:: with SMTP id g189mr3590255wmg.6.1604480784359;
        Wed, 04 Nov 2020 01:06:24 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id e25sm1607823wrc.76.2020.11.04.01.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 01:06:23 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 01/12] net: usb: lan78xx: Remove lots of set but unused 'ret' variables
Date:   Wed,  4 Nov 2020 09:05:59 +0000
Message-Id: <20201104090610.1446616-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201104090610.1446616-1-lee.jones@linaro.org>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/usb/lan78xx.c: In function ‘lan78xx_read_raw_otp’:
 drivers/net/usb/lan78xx.c:825:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
 drivers/net/usb/lan78xx.c: In function ‘lan78xx_write_raw_otp’:
 drivers/net/usb/lan78xx.c:879:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
 drivers/net/usb/lan78xx.c: In function ‘lan78xx_deferred_multicast_write’:
 drivers/net/usb/lan78xx.c:1041:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
 drivers/net/usb/lan78xx.c: In function ‘lan78xx_update_flowcontrol’:
 drivers/net/usb/lan78xx.c:1127:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
 drivers/net/usb/lan78xx.c: In function ‘lan78xx_init_mac_address’:
 drivers/net/usb/lan78xx.c:1666:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
 drivers/net/usb/lan78xx.c: In function ‘lan78xx_link_status_change’:
 drivers/net/usb/lan78xx.c:1841:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
 drivers/net/usb/lan78xx.c: In function ‘lan78xx_irq_bus_sync_unlock’:
 drivers/net/usb/lan78xx.c:1920:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
 drivers/net/usb/lan78xx.c: In function ‘lan8835_fixup’:
 drivers/net/usb/lan78xx.c:1994:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
 drivers/net/usb/lan78xx.c: In function ‘lan78xx_set_rx_max_frame_length’:
 drivers/net/usb/lan78xx.c:2192:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
 drivers/net/usb/lan78xx.c: In function ‘lan78xx_change_mtu’:
 drivers/net/usb/lan78xx.c:2270:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
 drivers/net/usb/lan78xx.c: In function ‘lan78xx_set_mac_addr’:
 drivers/net/usb/lan78xx.c:2299:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
 drivers/net/usb/lan78xx.c: In function ‘lan78xx_set_features’:
 drivers/net/usb/lan78xx.c:2333:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
 drivers/net/usb/lan78xx.c: In function ‘lan78xx_set_suspend’:
 drivers/net/usb/lan78xx.c:3807:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]

Cc: Woojung Huh <woojung.huh@microchip.com>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/usb/lan78xx.c | 212 ++++++++++++++++++--------------------
 1 file changed, 100 insertions(+), 112 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 65b315bc60abd..5517d0555ef22 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -822,20 +822,19 @@ static int lan78xx_read_raw_otp(struct lan78xx_net *dev, u32 offset,
 				u32 length, u8 *data)
 {
 	int i;
-	int ret;
 	u32 buf;
 	unsigned long timeout;
 
-	ret = lan78xx_read_reg(dev, OTP_PWR_DN, &buf);
+	lan78xx_read_reg(dev, OTP_PWR_DN, &buf);
 
 	if (buf & OTP_PWR_DN_PWRDN_N_) {
 		/* clear it and wait to be cleared */
-		ret = lan78xx_write_reg(dev, OTP_PWR_DN, 0);
+		lan78xx_write_reg(dev, OTP_PWR_DN, 0);
 
 		timeout = jiffies + HZ;
 		do {
 			usleep_range(1, 10);
-			ret = lan78xx_read_reg(dev, OTP_PWR_DN, &buf);
+			lan78xx_read_reg(dev, OTP_PWR_DN, &buf);
 			if (time_after(jiffies, timeout)) {
 				netdev_warn(dev->net,
 					    "timeout on OTP_PWR_DN");
@@ -845,18 +844,18 @@ static int lan78xx_read_raw_otp(struct lan78xx_net *dev, u32 offset,
 	}
 
 	for (i = 0; i < length; i++) {
-		ret = lan78xx_write_reg(dev, OTP_ADDR1,
-					((offset + i) >> 8) & OTP_ADDR1_15_11);
-		ret = lan78xx_write_reg(dev, OTP_ADDR2,
-					((offset + i) & OTP_ADDR2_10_3));
+		lan78xx_write_reg(dev, OTP_ADDR1,
+				  ((offset + i) >> 8) & OTP_ADDR1_15_11);
+		lan78xx_write_reg(dev, OTP_ADDR2,
+				  ((offset + i) & OTP_ADDR2_10_3));
 
-		ret = lan78xx_write_reg(dev, OTP_FUNC_CMD, OTP_FUNC_CMD_READ_);
-		ret = lan78xx_write_reg(dev, OTP_CMD_GO, OTP_CMD_GO_GO_);
+		lan78xx_write_reg(dev, OTP_FUNC_CMD, OTP_FUNC_CMD_READ_);
+		lan78xx_write_reg(dev, OTP_CMD_GO, OTP_CMD_GO_GO_);
 
 		timeout = jiffies + HZ;
 		do {
 			udelay(1);
-			ret = lan78xx_read_reg(dev, OTP_STATUS, &buf);
+			lan78xx_read_reg(dev, OTP_STATUS, &buf);
 			if (time_after(jiffies, timeout)) {
 				netdev_warn(dev->net,
 					    "timeout on OTP_STATUS");
@@ -864,7 +863,7 @@ static int lan78xx_read_raw_otp(struct lan78xx_net *dev, u32 offset,
 			}
 		} while (buf & OTP_STATUS_BUSY_);
 
-		ret = lan78xx_read_reg(dev, OTP_RD_DATA, &buf);
+		lan78xx_read_reg(dev, OTP_RD_DATA, &buf);
 
 		data[i] = (u8)(buf & 0xFF);
 	}
@@ -876,20 +875,19 @@ static int lan78xx_write_raw_otp(struct lan78xx_net *dev, u32 offset,
 				 u32 length, u8 *data)
 {
 	int i;
-	int ret;
 	u32 buf;
 	unsigned long timeout;
 
-	ret = lan78xx_read_reg(dev, OTP_PWR_DN, &buf);
+	lan78xx_read_reg(dev, OTP_PWR_DN, &buf);
 
 	if (buf & OTP_PWR_DN_PWRDN_N_) {
 		/* clear it and wait to be cleared */
-		ret = lan78xx_write_reg(dev, OTP_PWR_DN, 0);
+		lan78xx_write_reg(dev, OTP_PWR_DN, 0);
 
 		timeout = jiffies + HZ;
 		do {
 			udelay(1);
-			ret = lan78xx_read_reg(dev, OTP_PWR_DN, &buf);
+			lan78xx_read_reg(dev, OTP_PWR_DN, &buf);
 			if (time_after(jiffies, timeout)) {
 				netdev_warn(dev->net,
 					    "timeout on OTP_PWR_DN completion");
@@ -899,21 +897,21 @@ static int lan78xx_write_raw_otp(struct lan78xx_net *dev, u32 offset,
 	}
 
 	/* set to BYTE program mode */
-	ret = lan78xx_write_reg(dev, OTP_PRGM_MODE, OTP_PRGM_MODE_BYTE_);
+	lan78xx_write_reg(dev, OTP_PRGM_MODE, OTP_PRGM_MODE_BYTE_);
 
 	for (i = 0; i < length; i++) {
-		ret = lan78xx_write_reg(dev, OTP_ADDR1,
-					((offset + i) >> 8) & OTP_ADDR1_15_11);
-		ret = lan78xx_write_reg(dev, OTP_ADDR2,
-					((offset + i) & OTP_ADDR2_10_3));
-		ret = lan78xx_write_reg(dev, OTP_PRGM_DATA, data[i]);
-		ret = lan78xx_write_reg(dev, OTP_TST_CMD, OTP_TST_CMD_PRGVRFY_);
-		ret = lan78xx_write_reg(dev, OTP_CMD_GO, OTP_CMD_GO_GO_);
+		lan78xx_write_reg(dev, OTP_ADDR1,
+				  ((offset + i) >> 8) & OTP_ADDR1_15_11);
+		lan78xx_write_reg(dev, OTP_ADDR2,
+				  ((offset + i) & OTP_ADDR2_10_3));
+		lan78xx_write_reg(dev, OTP_PRGM_DATA, data[i]);
+		lan78xx_write_reg(dev, OTP_TST_CMD, OTP_TST_CMD_PRGVRFY_);
+		lan78xx_write_reg(dev, OTP_CMD_GO, OTP_CMD_GO_GO_);
 
 		timeout = jiffies + HZ;
 		do {
 			udelay(1);
-			ret = lan78xx_read_reg(dev, OTP_STATUS, &buf);
+			lan78xx_read_reg(dev, OTP_STATUS, &buf);
 			if (time_after(jiffies, timeout)) {
 				netdev_warn(dev->net,
 					    "Timeout on OTP_STATUS completion");
@@ -1038,7 +1036,6 @@ static void lan78xx_deferred_multicast_write(struct work_struct *param)
 			container_of(param, struct lan78xx_priv, set_multicast);
 	struct lan78xx_net *dev = pdata->dev;
 	int i;
-	int ret;
 
 	netif_dbg(dev, drv, dev->net, "deferred multicast write 0x%08x\n",
 		  pdata->rfe_ctl);
@@ -1047,14 +1044,14 @@ static void lan78xx_deferred_multicast_write(struct work_struct *param)
 			       DP_SEL_VHF_HASH_LEN, pdata->mchash_table);
 
 	for (i = 1; i < NUM_OF_MAF; i++) {
-		ret = lan78xx_write_reg(dev, MAF_HI(i), 0);
-		ret = lan78xx_write_reg(dev, MAF_LO(i),
-					pdata->pfilter_table[i][1]);
-		ret = lan78xx_write_reg(dev, MAF_HI(i),
-					pdata->pfilter_table[i][0]);
+		lan78xx_write_reg(dev, MAF_HI(i), 0);
+		lan78xx_write_reg(dev, MAF_LO(i),
+				  pdata->pfilter_table[i][1]);
+		lan78xx_write_reg(dev, MAF_HI(i),
+				  pdata->pfilter_table[i][0]);
 	}
 
-	ret = lan78xx_write_reg(dev, RFE_CTL, pdata->rfe_ctl);
+	lan78xx_write_reg(dev, RFE_CTL, pdata->rfe_ctl);
 }
 
 static void lan78xx_set_multicast(struct net_device *netdev)
@@ -1124,7 +1121,6 @@ static int lan78xx_update_flowcontrol(struct lan78xx_net *dev, u8 duplex,
 				      u16 lcladv, u16 rmtadv)
 {
 	u32 flow = 0, fct_flow = 0;
-	int ret;
 	u8 cap;
 
 	if (dev->fc_autoneg)
@@ -1147,10 +1143,10 @@ static int lan78xx_update_flowcontrol(struct lan78xx_net *dev, u8 duplex,
 		  (cap & FLOW_CTRL_RX ? "enabled" : "disabled"),
 		  (cap & FLOW_CTRL_TX ? "enabled" : "disabled"));
 
-	ret = lan78xx_write_reg(dev, FCT_FLOW, fct_flow);
+	lan78xx_write_reg(dev, FCT_FLOW, fct_flow);
 
 	/* threshold value should be set before enabling flow */
-	ret = lan78xx_write_reg(dev, FLOW, flow);
+	lan78xx_write_reg(dev, FLOW, flow);
 
 	return 0;
 }
@@ -1663,11 +1659,10 @@ static const struct ethtool_ops lan78xx_ethtool_ops = {
 static void lan78xx_init_mac_address(struct lan78xx_net *dev)
 {
 	u32 addr_lo, addr_hi;
-	int ret;
 	u8 addr[6];
 
-	ret = lan78xx_read_reg(dev, RX_ADDRL, &addr_lo);
-	ret = lan78xx_read_reg(dev, RX_ADDRH, &addr_hi);
+	lan78xx_read_reg(dev, RX_ADDRL, &addr_lo);
+	lan78xx_read_reg(dev, RX_ADDRH, &addr_hi);
 
 	addr[0] = addr_lo & 0xFF;
 	addr[1] = (addr_lo >> 8) & 0xFF;
@@ -1700,12 +1695,12 @@ static void lan78xx_init_mac_address(struct lan78xx_net *dev)
 			  (addr[2] << 16) | (addr[3] << 24);
 		addr_hi = addr[4] | (addr[5] << 8);
 
-		ret = lan78xx_write_reg(dev, RX_ADDRL, addr_lo);
-		ret = lan78xx_write_reg(dev, RX_ADDRH, addr_hi);
+		lan78xx_write_reg(dev, RX_ADDRL, addr_lo);
+		lan78xx_write_reg(dev, RX_ADDRH, addr_hi);
 	}
 
-	ret = lan78xx_write_reg(dev, MAF_LO(0), addr_lo);
-	ret = lan78xx_write_reg(dev, MAF_HI(0), addr_hi | MAF_HI_VALID_);
+	lan78xx_write_reg(dev, MAF_LO(0), addr_lo);
+	lan78xx_write_reg(dev, MAF_HI(0), addr_hi | MAF_HI_VALID_);
 
 	ether_addr_copy(dev->net->dev_addr, addr);
 }
@@ -1838,7 +1833,7 @@ static void lan78xx_remove_mdio(struct lan78xx_net *dev)
 static void lan78xx_link_status_change(struct net_device *net)
 {
 	struct phy_device *phydev = net->phydev;
-	int ret, temp;
+	int temp;
 
 	/* At forced 100 F/H mode, chip may fail to set mode correctly
 	 * when cable is switched between long(~50+m) and short one.
@@ -1849,7 +1844,7 @@ static void lan78xx_link_status_change(struct net_device *net)
 		/* disable phy interrupt */
 		temp = phy_read(phydev, LAN88XX_INT_MASK);
 		temp &= ~LAN88XX_INT_MASK_MDINTPIN_EN_;
-		ret = phy_write(phydev, LAN88XX_INT_MASK, temp);
+		phy_write(phydev, LAN88XX_INT_MASK, temp);
 
 		temp = phy_read(phydev, MII_BMCR);
 		temp &= ~(BMCR_SPEED100 | BMCR_SPEED1000);
@@ -1863,7 +1858,7 @@ static void lan78xx_link_status_change(struct net_device *net)
 		/* enable phy interrupt back */
 		temp = phy_read(phydev, LAN88XX_INT_MASK);
 		temp |= LAN88XX_INT_MASK_MDINTPIN_EN_;
-		ret = phy_write(phydev, LAN88XX_INT_MASK, temp);
+		phy_write(phydev, LAN88XX_INT_MASK, temp);
 	}
 }
 
@@ -1917,14 +1912,13 @@ static void lan78xx_irq_bus_sync_unlock(struct irq_data *irqd)
 	struct lan78xx_net *dev =
 			container_of(data, struct lan78xx_net, domain_data);
 	u32 buf;
-	int ret;
 
 	/* call register access here because irq_bus_lock & irq_bus_sync_unlock
 	 * are only two callbacks executed in non-atomic contex.
 	 */
-	ret = lan78xx_read_reg(dev, INT_EP_CTL, &buf);
+	lan78xx_read_reg(dev, INT_EP_CTL, &buf);
 	if (buf != data->irqenable)
-		ret = lan78xx_write_reg(dev, INT_EP_CTL, data->irqenable);
+		lan78xx_write_reg(dev, INT_EP_CTL, data->irqenable);
 
 	mutex_unlock(&data->irq_lock);
 }
@@ -1991,7 +1985,6 @@ static void lan78xx_remove_irq_domain(struct lan78xx_net *dev)
 static int lan8835_fixup(struct phy_device *phydev)
 {
 	int buf;
-	int ret;
 	struct lan78xx_net *dev = netdev_priv(phydev->attached_dev);
 
 	/* LED2/PME_N/IRQ_N/RGMII_ID pin to IRQ_N mode */
@@ -2001,11 +1994,11 @@ static int lan8835_fixup(struct phy_device *phydev)
 	phy_write_mmd(phydev, MDIO_MMD_PCS, 0x8010, buf);
 
 	/* RGMII MAC TXC Delay Enable */
-	ret = lan78xx_write_reg(dev, MAC_RGMII_ID,
-				MAC_RGMII_ID_TXC_DELAY_EN_);
+	lan78xx_write_reg(dev, MAC_RGMII_ID,
+			  MAC_RGMII_ID_TXC_DELAY_EN_);
 
 	/* RGMII TX DLL Tune Adjust */
-	ret = lan78xx_write_reg(dev, RGMII_TX_BYP_DLL, 0x3D00);
+	lan78xx_write_reg(dev, RGMII_TX_BYP_DLL, 0x3D00);
 
 	dev->interface = PHY_INTERFACE_MODE_RGMII_TXID;
 
@@ -2189,28 +2182,27 @@ static int lan78xx_phy_init(struct lan78xx_net *dev)
 
 static int lan78xx_set_rx_max_frame_length(struct lan78xx_net *dev, int size)
 {
-	int ret = 0;
 	u32 buf;
 	bool rxenabled;
 
-	ret = lan78xx_read_reg(dev, MAC_RX, &buf);
+	lan78xx_read_reg(dev, MAC_RX, &buf);
 
 	rxenabled = ((buf & MAC_RX_RXEN_) != 0);
 
 	if (rxenabled) {
 		buf &= ~MAC_RX_RXEN_;
-		ret = lan78xx_write_reg(dev, MAC_RX, buf);
+		lan78xx_write_reg(dev, MAC_RX, buf);
 	}
 
 	/* add 4 to size for FCS */
 	buf &= ~MAC_RX_MAX_SIZE_MASK_;
 	buf |= (((size + 4) << MAC_RX_MAX_SIZE_SHIFT_) & MAC_RX_MAX_SIZE_MASK_);
 
-	ret = lan78xx_write_reg(dev, MAC_RX, buf);
+	lan78xx_write_reg(dev, MAC_RX, buf);
 
 	if (rxenabled) {
 		buf |= MAC_RX_RXEN_;
-		ret = lan78xx_write_reg(dev, MAC_RX, buf);
+		lan78xx_write_reg(dev, MAC_RX, buf);
 	}
 
 	return 0;
@@ -2267,13 +2259,12 @@ static int lan78xx_change_mtu(struct net_device *netdev, int new_mtu)
 	int ll_mtu = new_mtu + netdev->hard_header_len;
 	int old_hard_mtu = dev->hard_mtu;
 	int old_rx_urb_size = dev->rx_urb_size;
-	int ret;
 
 	/* no second zero-length packet read wanted after mtu-sized packets */
 	if ((ll_mtu % dev->maxpacket) == 0)
 		return -EDOM;
 
-	ret = lan78xx_set_rx_max_frame_length(dev, new_mtu + VLAN_ETH_HLEN);
+	lan78xx_set_rx_max_frame_length(dev, new_mtu + VLAN_ETH_HLEN);
 
 	netdev->mtu = new_mtu;
 
@@ -2296,7 +2287,6 @@ static int lan78xx_set_mac_addr(struct net_device *netdev, void *p)
 	struct lan78xx_net *dev = netdev_priv(netdev);
 	struct sockaddr *addr = p;
 	u32 addr_lo, addr_hi;
-	int ret;
 
 	if (netif_running(netdev))
 		return -EBUSY;
@@ -2313,12 +2303,12 @@ static int lan78xx_set_mac_addr(struct net_device *netdev, void *p)
 	addr_hi = netdev->dev_addr[4] |
 		  netdev->dev_addr[5] << 8;
 
-	ret = lan78xx_write_reg(dev, RX_ADDRL, addr_lo);
-	ret = lan78xx_write_reg(dev, RX_ADDRH, addr_hi);
+	lan78xx_write_reg(dev, RX_ADDRL, addr_lo);
+	lan78xx_write_reg(dev, RX_ADDRH, addr_hi);
 
 	/* Added to support MAC address changes */
-	ret = lan78xx_write_reg(dev, MAF_LO(0), addr_lo);
-	ret = lan78xx_write_reg(dev, MAF_HI(0), addr_hi | MAF_HI_VALID_);
+	lan78xx_write_reg(dev, MAF_LO(0), addr_lo);
+	lan78xx_write_reg(dev, MAF_HI(0), addr_hi | MAF_HI_VALID_);
 
 	return 0;
 }
@@ -2330,7 +2320,6 @@ static int lan78xx_set_features(struct net_device *netdev,
 	struct lan78xx_net *dev = netdev_priv(netdev);
 	struct lan78xx_priv *pdata = (struct lan78xx_priv *)(dev->data[0]);
 	unsigned long flags;
-	int ret;
 
 	spin_lock_irqsave(&pdata->rfe_ctl_lock, flags);
 
@@ -2354,7 +2343,7 @@ static int lan78xx_set_features(struct net_device *netdev,
 
 	spin_unlock_irqrestore(&pdata->rfe_ctl_lock, flags);
 
-	ret = lan78xx_write_reg(dev, RFE_CTL, pdata->rfe_ctl);
+	lan78xx_write_reg(dev, RFE_CTL, pdata->rfe_ctl);
 
 	return 0;
 }
@@ -3804,7 +3793,6 @@ static u16 lan78xx_wakeframe_crc16(const u8 *buf, int len)
 static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 {
 	u32 buf;
-	int ret;
 	int mask_index;
 	u16 crc;
 	u32 temp_wucsr;
@@ -3813,26 +3801,26 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 	const u8 ipv6_multicast[3] = { 0x33, 0x33 };
 	const u8 arp_type[2] = { 0x08, 0x06 };
 
-	ret = lan78xx_read_reg(dev, MAC_TX, &buf);
+	lan78xx_read_reg(dev, MAC_TX, &buf);
 	buf &= ~MAC_TX_TXEN_;
-	ret = lan78xx_write_reg(dev, MAC_TX, buf);
-	ret = lan78xx_read_reg(dev, MAC_RX, &buf);
+	lan78xx_write_reg(dev, MAC_TX, buf);
+	lan78xx_read_reg(dev, MAC_RX, &buf);
 	buf &= ~MAC_RX_RXEN_;
-	ret = lan78xx_write_reg(dev, MAC_RX, buf);
+	lan78xx_write_reg(dev, MAC_RX, buf);
 
-	ret = lan78xx_write_reg(dev, WUCSR, 0);
-	ret = lan78xx_write_reg(dev, WUCSR2, 0);
-	ret = lan78xx_write_reg(dev, WK_SRC, 0xFFF1FF1FUL);
+	lan78xx_write_reg(dev, WUCSR, 0);
+	lan78xx_write_reg(dev, WUCSR2, 0);
+	lan78xx_write_reg(dev, WK_SRC, 0xFFF1FF1FUL);
 
 	temp_wucsr = 0;
 
 	temp_pmt_ctl = 0;
-	ret = lan78xx_read_reg(dev, PMT_CTL, &temp_pmt_ctl);
+	lan78xx_read_reg(dev, PMT_CTL, &temp_pmt_ctl);
 	temp_pmt_ctl &= ~PMT_CTL_RES_CLR_WKP_EN_;
 	temp_pmt_ctl |= PMT_CTL_RES_CLR_WKP_STS_;
 
 	for (mask_index = 0; mask_index < NUM_OF_WUF_CFG; mask_index++)
-		ret = lan78xx_write_reg(dev, WUF_CFG(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_CFG(mask_index), 0);
 
 	mask_index = 0;
 	if (wol & WAKE_PHY) {
@@ -3861,30 +3849,30 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 
 		/* set WUF_CFG & WUF_MASK for IPv4 Multicast */
 		crc = lan78xx_wakeframe_crc16(ipv4_multicast, 3);
-		ret = lan78xx_write_reg(dev, WUF_CFG(mask_index),
-					WUF_CFGX_EN_ |
-					WUF_CFGX_TYPE_MCAST_ |
-					(0 << WUF_CFGX_OFFSET_SHIFT_) |
-					(crc & WUF_CFGX_CRC16_MASK_));
-
-		ret = lan78xx_write_reg(dev, WUF_MASK0(mask_index), 7);
-		ret = lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
-		ret = lan78xx_write_reg(dev, WUF_MASK2(mask_index), 0);
-		ret = lan78xx_write_reg(dev, WUF_MASK3(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_CFG(mask_index),
+				  WUF_CFGX_EN_ |
+				  WUF_CFGX_TYPE_MCAST_ |
+				  (0 << WUF_CFGX_OFFSET_SHIFT_) |
+				  (crc & WUF_CFGX_CRC16_MASK_));
+
+		lan78xx_write_reg(dev, WUF_MASK0(mask_index), 7);
+		lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_MASK2(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_MASK3(mask_index), 0);
 		mask_index++;
 
 		/* for IPv6 Multicast */
 		crc = lan78xx_wakeframe_crc16(ipv6_multicast, 2);
-		ret = lan78xx_write_reg(dev, WUF_CFG(mask_index),
-					WUF_CFGX_EN_ |
-					WUF_CFGX_TYPE_MCAST_ |
-					(0 << WUF_CFGX_OFFSET_SHIFT_) |
-					(crc & WUF_CFGX_CRC16_MASK_));
-
-		ret = lan78xx_write_reg(dev, WUF_MASK0(mask_index), 3);
-		ret = lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
-		ret = lan78xx_write_reg(dev, WUF_MASK2(mask_index), 0);
-		ret = lan78xx_write_reg(dev, WUF_MASK3(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_CFG(mask_index),
+				  WUF_CFGX_EN_ |
+				  WUF_CFGX_TYPE_MCAST_ |
+				  (0 << WUF_CFGX_OFFSET_SHIFT_) |
+				  (crc & WUF_CFGX_CRC16_MASK_));
+
+		lan78xx_write_reg(dev, WUF_MASK0(mask_index), 3);
+		lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_MASK2(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_MASK3(mask_index), 0);
 		mask_index++;
 
 		temp_pmt_ctl |= PMT_CTL_WOL_EN_;
@@ -3905,16 +3893,16 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 		 * for packettype (offset 12,13) = ARP (0x0806)
 		 */
 		crc = lan78xx_wakeframe_crc16(arp_type, 2);
-		ret = lan78xx_write_reg(dev, WUF_CFG(mask_index),
-					WUF_CFGX_EN_ |
-					WUF_CFGX_TYPE_ALL_ |
-					(0 << WUF_CFGX_OFFSET_SHIFT_) |
-					(crc & WUF_CFGX_CRC16_MASK_));
-
-		ret = lan78xx_write_reg(dev, WUF_MASK0(mask_index), 0x3000);
-		ret = lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
-		ret = lan78xx_write_reg(dev, WUF_MASK2(mask_index), 0);
-		ret = lan78xx_write_reg(dev, WUF_MASK3(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_CFG(mask_index),
+				  WUF_CFGX_EN_ |
+				  WUF_CFGX_TYPE_ALL_ |
+				  (0 << WUF_CFGX_OFFSET_SHIFT_) |
+				  (crc & WUF_CFGX_CRC16_MASK_));
+
+		lan78xx_write_reg(dev, WUF_MASK0(mask_index), 0x3000);
+		lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_MASK2(mask_index), 0);
+		lan78xx_write_reg(dev, WUF_MASK3(mask_index), 0);
 		mask_index++;
 
 		temp_pmt_ctl |= PMT_CTL_WOL_EN_;
@@ -3922,7 +3910,7 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 		temp_pmt_ctl |= PMT_CTL_SUS_MODE_0_;
 	}
 
-	ret = lan78xx_write_reg(dev, WUCSR, temp_wucsr);
+	lan78xx_write_reg(dev, WUCSR, temp_wucsr);
 
 	/* when multiple WOL bits are set */
 	if (hweight_long((unsigned long)wol) > 1) {
@@ -3930,16 +3918,16 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 		temp_pmt_ctl &= ~PMT_CTL_SUS_MODE_MASK_;
 		temp_pmt_ctl |= PMT_CTL_SUS_MODE_0_;
 	}
-	ret = lan78xx_write_reg(dev, PMT_CTL, temp_pmt_ctl);
+	lan78xx_write_reg(dev, PMT_CTL, temp_pmt_ctl);
 
 	/* clear WUPS */
-	ret = lan78xx_read_reg(dev, PMT_CTL, &buf);
+	lan78xx_read_reg(dev, PMT_CTL, &buf);
 	buf |= PMT_CTL_WUPS_MASK_;
-	ret = lan78xx_write_reg(dev, PMT_CTL, buf);
+	lan78xx_write_reg(dev, PMT_CTL, buf);
 
-	ret = lan78xx_read_reg(dev, MAC_RX, &buf);
+	lan78xx_read_reg(dev, MAC_RX, &buf);
 	buf |= MAC_RX_RXEN_;
-	ret = lan78xx_write_reg(dev, MAC_RX, buf);
+	lan78xx_write_reg(dev, MAC_RX, buf);
 
 	return 0;
 }
-- 
2.25.1

