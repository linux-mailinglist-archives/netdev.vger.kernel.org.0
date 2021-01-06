Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052462EBA85
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 08:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbhAFHds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 02:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbhAFHds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 02:33:48 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F58EC06134C
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 23:33:07 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id l11so4597140lfg.0
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 23:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BEuL7Mcv5vF5jn3mXUamMoLJAOdCdWStReCliC+M4H8=;
        b=a6JCGcvzfuc0uRX4R7JyXaymAudDk5I29pXXwChqqRRDEcPfOhmIAircTddraI4qi6
         y/VGDPOacwRlNQObsO/27OpiSfkb3wRoh0RzIigKq+JQ2B9oF/RpsBzEhrPsgQ5EcCx6
         Taswlpo1OskNNz7LVeiWQSJ9+8zHiEiUbPZdKsWnESZ0V0Sr9fHSgdYP7HC316wlNY5D
         ZkI66teADODJMPKXfrQIeBd9REdB8AeOdtvceB2Ae1TWnDt2JYbPu5t5AjdpoAW1CIZx
         YJffAy1q432XNlRjEOV8yJShg4xnIQS99lVc9gwqN+GJUErwm7+KWG0az0UfycfTcTNZ
         ABcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BEuL7Mcv5vF5jn3mXUamMoLJAOdCdWStReCliC+M4H8=;
        b=ZgyJ5q5rAzlHUlvpO0MXvmNTd7O3Fo/Oly5Md5Kpe6b0L6bN4nVTe+y8B6g4EmjyUJ
         6gpwpgoXINCOhodrdQzGFOFnm17DOEomyJa9JGpIvUMV6Cf2ktJ7qIGg9KcPnBKD4p2z
         MIwLPifCDeQPjFQ/kKxCq53G5+PYk90ip+9MNPiO6YSGXUvyYTVxmV9IUJUGocLTOg59
         hg0Tsp707zYa1xluUo4Pt6pm46tLD76I11VRzWf9PE8JC1lgqKBn3JxXeawlnE8xMqEK
         gHDJJBY13u3fl2ucLENFN7FVdQTkSdpGTGb6lQ5fzuk9DOvklnJzodt4YKife4XWIF10
         vI8Q==
X-Gm-Message-State: AOAM531KGmLHnMjNdPglmCF1cQQcdcRrxiz3I7Wky+L3yvqQYvESSwa0
        yTKMwNZeI2QsnkEzAL/56uY=
X-Google-Smtp-Source: ABdhPJxujz5T17C08CtBDVDTLstLXSQ19QvB4V/BFd/2R1kyZLBWrQg3d0DVB3Timl7ji6DCTJrrCQ==
X-Received: by 2002:a19:f249:: with SMTP id d9mr1365765lfk.158.1609918386139;
        Tue, 05 Jan 2021 23:33:06 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id q7sm205154ljp.77.2021.01.05.23.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 23:33:05 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Timur Tabi <timur@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next 1/2] bgmac: add bgmac_umac_*() helpers for accessing UniMAC registers
Date:   Wed,  6 Jan 2021 08:32:44 +0100
Message-Id: <20210106073245.32597-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

UniMAC is a hardware block commonly used in Broadcom Ethernet controllers
that should get its own header file. Not every controller has it mapped at
the 0x800 offset so add bgmac access helpers. They will allow using
shared register defines.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/ethernet/broadcom/bgmac.c | 80 +++++++++++++--------------
 drivers/net/ethernet/broadcom/bgmac.h | 15 +++++
 2 files changed, 55 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 98ec1b8a7d8e..b8b2538303ed 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -746,10 +746,10 @@ static int bgmac_dma_init(struct bgmac *bgmac)
 /* TODO: can we just drop @force? Can we don't reset MAC at all if there is
  * nothing to change? Try if after stabilizng driver.
  */
-static void bgmac_cmdcfg_maskset(struct bgmac *bgmac, u32 mask, u32 set,
-				 bool force)
+static void bgmac_umac_cmd_maskset(struct bgmac *bgmac, u32 mask, u32 set,
+				   bool force)
 {
-	u32 cmdcfg = bgmac_read(bgmac, BGMAC_CMDCFG);
+	u32 cmdcfg = bgmac_umac_read(bgmac, BGMAC_CMDCFG);
 	u32 new_val = (cmdcfg & mask) | set;
 	u32 cmdcfg_sr;
 
@@ -758,13 +758,13 @@ static void bgmac_cmdcfg_maskset(struct bgmac *bgmac, u32 mask, u32 set,
 	else
 		cmdcfg_sr = BGMAC_CMDCFG_SR_REV0;
 
-	bgmac_set(bgmac, BGMAC_CMDCFG, cmdcfg_sr);
+	bgmac_umac_maskset(bgmac, BGMAC_CMDCFG, ~0, cmdcfg_sr);
 	udelay(2);
 
 	if (new_val != cmdcfg || force)
-		bgmac_write(bgmac, BGMAC_CMDCFG, new_val);
+		bgmac_umac_write(bgmac, BGMAC_CMDCFG, new_val);
 
-	bgmac_mask(bgmac, BGMAC_CMDCFG, ~cmdcfg_sr);
+	bgmac_umac_maskset(bgmac, BGMAC_CMDCFG, ~cmdcfg_sr, 0);
 	udelay(2);
 }
 
@@ -773,9 +773,9 @@ static void bgmac_write_mac_address(struct bgmac *bgmac, u8 *addr)
 	u32 tmp;
 
 	tmp = (addr[0] << 24) | (addr[1] << 16) | (addr[2] << 8) | addr[3];
-	bgmac_write(bgmac, BGMAC_MACADDR_HIGH, tmp);
+	bgmac_umac_write(bgmac, BGMAC_MACADDR_HIGH, tmp);
 	tmp = (addr[4] << 8) | addr[5];
-	bgmac_write(bgmac, BGMAC_MACADDR_LOW, tmp);
+	bgmac_umac_write(bgmac, BGMAC_MACADDR_LOW, tmp);
 }
 
 static void bgmac_set_rx_mode(struct net_device *net_dev)
@@ -783,9 +783,9 @@ static void bgmac_set_rx_mode(struct net_device *net_dev)
 	struct bgmac *bgmac = netdev_priv(net_dev);
 
 	if (net_dev->flags & IFF_PROMISC)
-		bgmac_cmdcfg_maskset(bgmac, ~0, BGMAC_CMDCFG_PROM, true);
+		bgmac_umac_cmd_maskset(bgmac, ~0, BGMAC_CMDCFG_PROM, true);
 	else
-		bgmac_cmdcfg_maskset(bgmac, ~BGMAC_CMDCFG_PROM, 0, true);
+		bgmac_umac_cmd_maskset(bgmac, ~BGMAC_CMDCFG_PROM, 0, true);
 }
 
 #if 0 /* We don't use that regs yet */
@@ -849,7 +849,7 @@ static void bgmac_mac_speed(struct bgmac *bgmac)
 	if (bgmac->mac_duplex == DUPLEX_HALF)
 		set |= BGMAC_CMDCFG_HD;
 
-	bgmac_cmdcfg_maskset(bgmac, mask, set, true);
+	bgmac_umac_cmd_maskset(bgmac, mask, set, true);
 }
 
 static void bgmac_miiconfig(struct bgmac *bgmac)
@@ -917,7 +917,7 @@ static void bgmac_chip_reset(struct bgmac *bgmac)
 		for (i = 0; i < BGMAC_MAX_TX_RINGS; i++)
 			bgmac_dma_tx_reset(bgmac, &bgmac->tx_ring[i]);
 
-		bgmac_cmdcfg_maskset(bgmac, ~0, BGMAC_CMDCFG_ML, false);
+		bgmac_umac_cmd_maskset(bgmac, ~0, BGMAC_CMDCFG_ML, false);
 		udelay(1);
 
 		for (i = 0; i < BGMAC_MAX_RX_RINGS; i++)
@@ -995,25 +995,25 @@ static void bgmac_chip_reset(struct bgmac *bgmac)
 	else
 		cmdcfg_sr = BGMAC_CMDCFG_SR_REV0;
 
-	bgmac_cmdcfg_maskset(bgmac,
-			     ~(BGMAC_CMDCFG_TE |
-			       BGMAC_CMDCFG_RE |
-			       BGMAC_CMDCFG_RPI |
-			       BGMAC_CMDCFG_TAI |
-			       BGMAC_CMDCFG_HD |
-			       BGMAC_CMDCFG_ML |
+	bgmac_umac_cmd_maskset(bgmac,
+			       ~(BGMAC_CMDCFG_TE |
+				 BGMAC_CMDCFG_RE |
+				 BGMAC_CMDCFG_RPI |
+				 BGMAC_CMDCFG_TAI |
+				 BGMAC_CMDCFG_HD |
+				 BGMAC_CMDCFG_ML |
+				 BGMAC_CMDCFG_CFE |
+				 BGMAC_CMDCFG_RL |
+				 BGMAC_CMDCFG_RED |
+				 BGMAC_CMDCFG_PE |
+				 BGMAC_CMDCFG_TPI |
+				 BGMAC_CMDCFG_PAD_EN |
+				 BGMAC_CMDCFG_PF),
+			       BGMAC_CMDCFG_PROM |
+			       BGMAC_CMDCFG_NLC |
 			       BGMAC_CMDCFG_CFE |
-			       BGMAC_CMDCFG_RL |
-			       BGMAC_CMDCFG_RED |
-			       BGMAC_CMDCFG_PE |
-			       BGMAC_CMDCFG_TPI |
-			       BGMAC_CMDCFG_PAD_EN |
-			       BGMAC_CMDCFG_PF),
-			     BGMAC_CMDCFG_PROM |
-			     BGMAC_CMDCFG_NLC |
-			     BGMAC_CMDCFG_CFE |
-			     cmdcfg_sr,
-			     false);
+			       cmdcfg_sr,
+			       false);
 	bgmac->mac_speed = SPEED_UNKNOWN;
 	bgmac->mac_duplex = DUPLEX_UNKNOWN;
 
@@ -1053,12 +1053,12 @@ static void bgmac_enable(struct bgmac *bgmac)
 	else
 		cmdcfg_sr = BGMAC_CMDCFG_SR_REV0;
 
-	cmdcfg = bgmac_read(bgmac, BGMAC_CMDCFG);
-	bgmac_cmdcfg_maskset(bgmac, ~(BGMAC_CMDCFG_TE | BGMAC_CMDCFG_RE),
-			     cmdcfg_sr, true);
+	cmdcfg = bgmac_umac_read(bgmac, BGMAC_CMDCFG);
+	bgmac_umac_cmd_maskset(bgmac, ~(BGMAC_CMDCFG_TE | BGMAC_CMDCFG_RE),
+			       cmdcfg_sr, true);
 	udelay(2);
 	cmdcfg |= BGMAC_CMDCFG_TE | BGMAC_CMDCFG_RE;
-	bgmac_write(bgmac, BGMAC_CMDCFG, cmdcfg);
+	bgmac_umac_write(bgmac, BGMAC_CMDCFG, cmdcfg);
 
 	mode = (bgmac_read(bgmac, BGMAC_DEV_STATUS) & BGMAC_DS_MM_MASK) >>
 		BGMAC_DS_MM_SHIFT;
@@ -1078,7 +1078,7 @@ static void bgmac_enable(struct bgmac *bgmac)
 			fl_ctl = 0x03cb04cb;
 
 		bgmac_write(bgmac, BGMAC_FLOW_CTL_THRESH, fl_ctl);
-		bgmac_write(bgmac, BGMAC_PAUSE_CTL, 0x27fff);
+		bgmac_umac_write(bgmac, BGMAC_PAUSE_CTL, 0x27fff);
 	}
 
 	if (bgmac->feature_flags & BGMAC_FEAT_SET_RXQ_CLK) {
@@ -1105,18 +1105,18 @@ static void bgmac_chip_init(struct bgmac *bgmac)
 	bgmac_write(bgmac, BGMAC_INT_RECV_LAZY, 1 << BGMAC_IRL_FC_SHIFT);
 
 	/* Enable 802.3x tx flow control (honor received PAUSE frames) */
-	bgmac_cmdcfg_maskset(bgmac, ~BGMAC_CMDCFG_RPI, 0, true);
+	bgmac_umac_cmd_maskset(bgmac, ~BGMAC_CMDCFG_RPI, 0, true);
 
 	bgmac_set_rx_mode(bgmac->net_dev);
 
 	bgmac_write_mac_address(bgmac, bgmac->net_dev->dev_addr);
 
 	if (bgmac->loopback)
-		bgmac_cmdcfg_maskset(bgmac, ~0, BGMAC_CMDCFG_ML, false);
+		bgmac_umac_cmd_maskset(bgmac, ~0, BGMAC_CMDCFG_ML, false);
 	else
-		bgmac_cmdcfg_maskset(bgmac, ~BGMAC_CMDCFG_ML, 0, false);
+		bgmac_umac_cmd_maskset(bgmac, ~BGMAC_CMDCFG_ML, 0, false);
 
-	bgmac_write(bgmac, BGMAC_RXMAX_LENGTH, 32 + ETHER_MAX_LEN);
+	bgmac_umac_write(bgmac, BGMAC_RXMAX_LENGTH, 32 + ETHER_MAX_LEN);
 
 	bgmac_chip_intrs_on(bgmac);
 
@@ -1252,7 +1252,7 @@ static int bgmac_change_mtu(struct net_device *net_dev, int mtu)
 {
 	struct bgmac *bgmac = netdev_priv(net_dev);
 
-	bgmac_write(bgmac, BGMAC_RXMAX_LENGTH, 32 + mtu);
+	bgmac_umac_write(bgmac, BGMAC_RXMAX_LENGTH, 32 + mtu);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bgmac.h b/drivers/net/ethernet/broadcom/bgmac.h
index 351c598a3ec6..c069107d0d95 100644
--- a/drivers/net/ethernet/broadcom/bgmac.h
+++ b/drivers/net/ethernet/broadcom/bgmac.h
@@ -556,6 +556,16 @@ static inline void bgmac_write(struct bgmac *bgmac, u16 offset, u32 value)
 	bgmac->write(bgmac, offset, value);
 }
 
+static inline u32 bgmac_umac_read(struct bgmac *bgmac, u16 offset)
+{
+	return bgmac_read(bgmac, offset);
+}
+
+static inline void bgmac_umac_write(struct bgmac *bgmac, u16 offset, u32 value)
+{
+	bgmac_write(bgmac, offset, value);
+}
+
 static inline u32 bgmac_idm_read(struct bgmac *bgmac, u16 offset)
 {
 	return bgmac->idm_read(bgmac, offset);
@@ -609,6 +619,11 @@ static inline void bgmac_set(struct bgmac *bgmac, u16 offset, u32 set)
 	bgmac_maskset(bgmac, offset, ~0, set);
 }
 
+static inline void bgmac_umac_maskset(struct bgmac *bgmac, u16 offset, u32 mask, u32 set)
+{
+	bgmac_maskset(bgmac, offset, mask, set);
+}
+
 static inline int bgmac_phy_connect(struct bgmac *bgmac)
 {
 	return bgmac->phy_connect(bgmac);
-- 
2.26.2

