Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7552EBA86
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 08:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbhAFHdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 02:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbhAFHdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 02:33:52 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3727AC06134D
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 23:33:11 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id a12so4500781lfl.6
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 23:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1r4N/FT6ypV/8853Y6kk/CyzuhzwDutZsGuiZbzWGWI=;
        b=ffyxRjrF89t8xmiRPWgK6N6ZsPxrkBQb8JpT/OND26Bga8Sin8ulLhjUzbTL+iqBE+
         4s7nbO9YF+NWe5rR/RpWI6xq71t3u7qip1wa7wZXwWVB9PMlD+Npna3blWnlrKOoLkf6
         fl2KLQ4qS47K4JUX+bn0nNGcdd8Y5LII7op13Z5ltUJf7anrevDbzQMvnSFuORTYv2ZV
         JP/q8+JM5vb7dK0nOQFlfOS9zBLFy65Eauet3cqAWFmtnDwrLhaPPO1FVqlUiR4h7tOr
         N1C/v8/GesDE0FtXHxusjIh0ObbL9dAEpOaQG0wRZPpSOF6oGG+nUQa6O6yQ3DSX1M6c
         ayWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1r4N/FT6ypV/8853Y6kk/CyzuhzwDutZsGuiZbzWGWI=;
        b=HRue10k1FVsEA/uogNl8JOvqiQAasua763HOYVvfm71X32YXtj3XvnmvGir/UkWEej
         R94nn3aOb9uAk+LQTZdqjEflVyfUNpqN1s2iQ4sCuOBgKM5YQfHmN5sco/Pdwgzw9FND
         hgYZ17cqh5JLmPp+eTmsJa8ZqshLVJMPvXaYGO0JhsH9XYbJKFtila/QrA5/qHh2VFkU
         vpSA1QYcb4CYpuCz+NVm3W0Vt4G7AKYHIciyIIzVJsv7rgo1UvRsjajyn9ZiUeFT04rW
         KaqTnrrUuiLOPT41Ti90k2RlkR9kFE0Bpj2gNwGaL1LhXLLb9yTOru8xbxBeGyDjzRMp
         2KTA==
X-Gm-Message-State: AOAM533224dj2+DIWUn3M1+0ikYuBn4CyYbgRi/Frw5TPL24PwQPh2Ll
        ClqFS8iwsPb4YgqCIaEN/Q8=
X-Google-Smtp-Source: ABdhPJzoVxpvhWOkx2mfg0PAlqBPKgTAudKs6QURnR0gtmHAOaj7TeYImaiHiQmHX4loVbzz5FzTZQ==
X-Received: by 2002:a2e:b88e:: with SMTP id r14mr1482303ljp.254.1609918389678;
        Tue, 05 Jan 2021 23:33:09 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id q7sm205154ljp.77.2021.01.05.23.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 23:33:09 -0800 (PST)
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
Subject: [PATCH net-next 2/2] net: broadcom: share header defining UniMAC registers
Date:   Wed,  6 Jan 2021 08:32:45 +0100
Message-Id: <20210106073245.32597-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106073245.32597-1-zajec5@gmail.com>
References: <20210106073245.32597-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

UniMAC is integrated into multiple Broadcom's Ethernet controllers so
use a shared header file for it and avoid some code duplication.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 MAINTAINERS                                   |  2 +
 drivers/net/ethernet/broadcom/bcmsysport.h    | 35 +------
 drivers/net/ethernet/broadcom/bgmac.c         | 98 +++++++++----------
 drivers/net/ethernet/broadcom/bgmac.h         | 50 ++--------
 .../net/ethernet/broadcom/genet/bcmgenet.h    | 59 +----------
 drivers/net/ethernet/broadcom/genet/bcmmii.c  |  6 +-
 drivers/net/ethernet/broadcom/unimac.h        | 68 +++++++++++++
 7 files changed, 132 insertions(+), 186 deletions(-)
 create mode 100644 drivers/net/ethernet/broadcom/unimac.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 7c1e45c416b1..3de86229b17c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3625,6 +3625,7 @@ S:	Supported
 F:	Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
 F:	Documentation/devicetree/bindings/net/brcm,unimac-mdio.txt
 F:	drivers/net/ethernet/broadcom/genet/
+F:	drivers/net/ethernet/broadcom/unimac.h
 F:	drivers/net/mdio/mdio-bcm-unimac.c
 F:	include/linux/platform_data/bcmgenet.h
 F:	include/linux/platform_data/mdio-bcm-unimac.h
@@ -3737,6 +3738,7 @@ L:	bcm-kernel-feedback-list@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/broadcom/bcmsysport.*
+F:	drivers/net/ethernet/broadcom/unimac.h
 
 BROADCOM TG3 GIGABIT ETHERNET DRIVER
 M:	Siva Reddy Kallam <siva.kallam@broadcom.com>
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.h b/drivers/net/ethernet/broadcom/bcmsysport.h
index 3a5cb6f128f5..a76c24c1af6d 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.h
+++ b/drivers/net/ethernet/broadcom/bcmsysport.h
@@ -13,6 +13,8 @@
 #include <linux/if_vlan.h>
 #include <linux/dim.h>
 
+#include "unimac.h"
+
 /* Receive/transmit descriptor format */
 #define DESC_ADDR_HI_STATUS_LEN	0x00
 #define  DESC_ADDR_HI_SHIFT	0
@@ -213,39 +215,6 @@ struct bcm_rsb {
 /* UniMAC offset and defines */
 #define SYS_PORT_UMAC_OFFSET		0x800
 
-#define UMAC_CMD			0x008
-#define  CMD_TX_EN			(1 << 0)
-#define  CMD_RX_EN			(1 << 1)
-#define  CMD_SPEED_SHIFT		2
-#define  CMD_SPEED_10			0
-#define  CMD_SPEED_100			1
-#define  CMD_SPEED_1000			2
-#define  CMD_SPEED_2500			3
-#define  CMD_SPEED_MASK			3
-#define  CMD_PROMISC			(1 << 4)
-#define  CMD_PAD_EN			(1 << 5)
-#define  CMD_CRC_FWD			(1 << 6)
-#define  CMD_PAUSE_FWD			(1 << 7)
-#define  CMD_RX_PAUSE_IGNORE		(1 << 8)
-#define  CMD_TX_ADDR_INS		(1 << 9)
-#define  CMD_HD_EN			(1 << 10)
-#define  CMD_SW_RESET			(1 << 13)
-#define  CMD_LCL_LOOP_EN		(1 << 15)
-#define  CMD_AUTO_CONFIG		(1 << 22)
-#define  CMD_CNTL_FRM_EN		(1 << 23)
-#define  CMD_NO_LEN_CHK			(1 << 24)
-#define  CMD_RMT_LOOP_EN		(1 << 25)
-#define  CMD_PRBL_EN			(1 << 27)
-#define  CMD_TX_PAUSE_IGNORE		(1 << 28)
-#define  CMD_TX_RX_EN			(1 << 29)
-#define  CMD_RUNT_FILTER_DIS		(1 << 30)
-
-#define UMAC_MAC0			0x00c
-#define UMAC_MAC1			0x010
-#define UMAC_MAX_FRAME_LEN		0x014
-
-#define UMAC_TX_FLUSH			0x334
-
 #define UMAC_MIB_START			0x400
 
 /* There is a 0xC gap between the end of RX and beginning of TX stats and then
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index b8b2538303ed..075f6e146b29 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -749,22 +749,22 @@ static int bgmac_dma_init(struct bgmac *bgmac)
 static void bgmac_umac_cmd_maskset(struct bgmac *bgmac, u32 mask, u32 set,
 				   bool force)
 {
-	u32 cmdcfg = bgmac_umac_read(bgmac, BGMAC_CMDCFG);
+	u32 cmdcfg = bgmac_umac_read(bgmac, UMAC_CMD);
 	u32 new_val = (cmdcfg & mask) | set;
 	u32 cmdcfg_sr;
 
 	if (bgmac->feature_flags & BGMAC_FEAT_CMDCFG_SR_REV4)
-		cmdcfg_sr = BGMAC_CMDCFG_SR_REV4;
+		cmdcfg_sr = CMD_SW_RESET;
 	else
-		cmdcfg_sr = BGMAC_CMDCFG_SR_REV0;
+		cmdcfg_sr = CMD_SW_RESET_OLD;
 
-	bgmac_umac_maskset(bgmac, BGMAC_CMDCFG, ~0, cmdcfg_sr);
+	bgmac_umac_maskset(bgmac, UMAC_CMD, ~0, cmdcfg_sr);
 	udelay(2);
 
 	if (new_val != cmdcfg || force)
-		bgmac_umac_write(bgmac, BGMAC_CMDCFG, new_val);
+		bgmac_umac_write(bgmac, UMAC_CMD, new_val);
 
-	bgmac_umac_maskset(bgmac, BGMAC_CMDCFG, ~cmdcfg_sr, 0);
+	bgmac_umac_maskset(bgmac, UMAC_CMD, ~cmdcfg_sr, 0);
 	udelay(2);
 }
 
@@ -773,9 +773,9 @@ static void bgmac_write_mac_address(struct bgmac *bgmac, u8 *addr)
 	u32 tmp;
 
 	tmp = (addr[0] << 24) | (addr[1] << 16) | (addr[2] << 8) | addr[3];
-	bgmac_umac_write(bgmac, BGMAC_MACADDR_HIGH, tmp);
+	bgmac_umac_write(bgmac, UMAC_MAC0, tmp);
 	tmp = (addr[4] << 8) | addr[5];
-	bgmac_umac_write(bgmac, BGMAC_MACADDR_LOW, tmp);
+	bgmac_umac_write(bgmac, UMAC_MAC1, tmp);
 }
 
 static void bgmac_set_rx_mode(struct net_device *net_dev)
@@ -783,9 +783,9 @@ static void bgmac_set_rx_mode(struct net_device *net_dev)
 	struct bgmac *bgmac = netdev_priv(net_dev);
 
 	if (net_dev->flags & IFF_PROMISC)
-		bgmac_umac_cmd_maskset(bgmac, ~0, BGMAC_CMDCFG_PROM, true);
+		bgmac_umac_cmd_maskset(bgmac, ~0, CMD_PROMISC, true);
 	else
-		bgmac_umac_cmd_maskset(bgmac, ~BGMAC_CMDCFG_PROM, 0, true);
+		bgmac_umac_cmd_maskset(bgmac, ~CMD_PROMISC, 0, true);
 }
 
 #if 0 /* We don't use that regs yet */
@@ -825,21 +825,21 @@ static void bgmac_clear_mib(struct bgmac *bgmac)
 /* http://bcm-v4.sipsolutions.net/mac-gbit/gmac/gmac_speed */
 static void bgmac_mac_speed(struct bgmac *bgmac)
 {
-	u32 mask = ~(BGMAC_CMDCFG_ES_MASK | BGMAC_CMDCFG_HD);
+	u32 mask = ~(CMD_SPEED_MASK << CMD_SPEED_SHIFT | CMD_HD_EN);
 	u32 set = 0;
 
 	switch (bgmac->mac_speed) {
 	case SPEED_10:
-		set |= BGMAC_CMDCFG_ES_10;
+		set |= CMD_SPEED_10 << CMD_SPEED_SHIFT;
 		break;
 	case SPEED_100:
-		set |= BGMAC_CMDCFG_ES_100;
+		set |= CMD_SPEED_100 << CMD_SPEED_SHIFT;
 		break;
 	case SPEED_1000:
-		set |= BGMAC_CMDCFG_ES_1000;
+		set |= CMD_SPEED_1000 << CMD_SPEED_SHIFT;
 		break;
 	case SPEED_2500:
-		set |= BGMAC_CMDCFG_ES_2500;
+		set |= CMD_SPEED_2500 << CMD_SPEED_SHIFT;
 		break;
 	default:
 		dev_err(bgmac->dev, "Unsupported speed: %d\n",
@@ -847,7 +847,7 @@ static void bgmac_mac_speed(struct bgmac *bgmac)
 	}
 
 	if (bgmac->mac_duplex == DUPLEX_HALF)
-		set |= BGMAC_CMDCFG_HD;
+		set |= CMD_HD_EN;
 
 	bgmac_umac_cmd_maskset(bgmac, mask, set, true);
 }
@@ -917,7 +917,7 @@ static void bgmac_chip_reset(struct bgmac *bgmac)
 		for (i = 0; i < BGMAC_MAX_TX_RINGS; i++)
 			bgmac_dma_tx_reset(bgmac, &bgmac->tx_ring[i]);
 
-		bgmac_umac_cmd_maskset(bgmac, ~0, BGMAC_CMDCFG_ML, false);
+		bgmac_umac_cmd_maskset(bgmac, ~0, CMD_LCL_LOOP_EN, false);
 		udelay(1);
 
 		for (i = 0; i < BGMAC_MAX_RX_RINGS; i++)
@@ -986,32 +986,32 @@ static void bgmac_chip_reset(struct bgmac *bgmac)
 	}
 
 	/* http://bcm-v4.sipsolutions.net/mac-gbit/gmac/gmac_reset
-	 * Specs don't say about using BGMAC_CMDCFG_SR, but in this routine
-	 * BGMAC_CMDCFG is read _after_ putting chip in a reset. So it has to
+	 * Specs don't say about using UMAC_CMD_SR, but in this routine
+	 * UMAC_CMD is read _after_ putting chip in a reset. So it has to
 	 * be keps until taking MAC out of the reset.
 	 */
 	if (bgmac->feature_flags & BGMAC_FEAT_CMDCFG_SR_REV4)
-		cmdcfg_sr = BGMAC_CMDCFG_SR_REV4;
+		cmdcfg_sr = CMD_SW_RESET;
 	else
-		cmdcfg_sr = BGMAC_CMDCFG_SR_REV0;
+		cmdcfg_sr = CMD_SW_RESET_OLD;
 
 	bgmac_umac_cmd_maskset(bgmac,
-			       ~(BGMAC_CMDCFG_TE |
-				 BGMAC_CMDCFG_RE |
-				 BGMAC_CMDCFG_RPI |
-				 BGMAC_CMDCFG_TAI |
-				 BGMAC_CMDCFG_HD |
-				 BGMAC_CMDCFG_ML |
-				 BGMAC_CMDCFG_CFE |
-				 BGMAC_CMDCFG_RL |
-				 BGMAC_CMDCFG_RED |
-				 BGMAC_CMDCFG_PE |
-				 BGMAC_CMDCFG_TPI |
-				 BGMAC_CMDCFG_PAD_EN |
-				 BGMAC_CMDCFG_PF),
-			       BGMAC_CMDCFG_PROM |
-			       BGMAC_CMDCFG_NLC |
-			       BGMAC_CMDCFG_CFE |
+			       ~(CMD_TX_EN |
+				 CMD_RX_EN |
+				 CMD_RX_PAUSE_IGNORE |
+				 CMD_TX_ADDR_INS |
+				 CMD_HD_EN |
+				 CMD_LCL_LOOP_EN |
+				 CMD_CNTL_FRM_EN |
+				 CMD_RMT_LOOP_EN |
+				 CMD_RX_ERR_DISC |
+				 CMD_PRBL_EN |
+				 CMD_TX_PAUSE_IGNORE |
+				 CMD_PAD_EN |
+				 CMD_PAUSE_FWD),
+			       CMD_PROMISC |
+			       CMD_NO_LEN_CHK |
+			       CMD_CNTL_FRM_EN |
 			       cmdcfg_sr,
 			       false);
 	bgmac->mac_speed = SPEED_UNKNOWN;
@@ -1049,16 +1049,16 @@ static void bgmac_enable(struct bgmac *bgmac)
 	u32 mode;
 
 	if (bgmac->feature_flags & BGMAC_FEAT_CMDCFG_SR_REV4)
-		cmdcfg_sr = BGMAC_CMDCFG_SR_REV4;
+		cmdcfg_sr = CMD_SW_RESET;
 	else
-		cmdcfg_sr = BGMAC_CMDCFG_SR_REV0;
+		cmdcfg_sr = CMD_SW_RESET_OLD;
 
-	cmdcfg = bgmac_umac_read(bgmac, BGMAC_CMDCFG);
-	bgmac_umac_cmd_maskset(bgmac, ~(BGMAC_CMDCFG_TE | BGMAC_CMDCFG_RE),
+	cmdcfg = bgmac_umac_read(bgmac, UMAC_CMD);
+	bgmac_umac_cmd_maskset(bgmac, ~(CMD_TX_EN | CMD_RX_EN),
 			       cmdcfg_sr, true);
 	udelay(2);
-	cmdcfg |= BGMAC_CMDCFG_TE | BGMAC_CMDCFG_RE;
-	bgmac_umac_write(bgmac, BGMAC_CMDCFG, cmdcfg);
+	cmdcfg |= CMD_TX_EN | CMD_RX_EN;
+	bgmac_umac_write(bgmac, UMAC_CMD, cmdcfg);
 
 	mode = (bgmac_read(bgmac, BGMAC_DEV_STATUS) & BGMAC_DS_MM_MASK) >>
 		BGMAC_DS_MM_SHIFT;
@@ -1078,7 +1078,7 @@ static void bgmac_enable(struct bgmac *bgmac)
 			fl_ctl = 0x03cb04cb;
 
 		bgmac_write(bgmac, BGMAC_FLOW_CTL_THRESH, fl_ctl);
-		bgmac_umac_write(bgmac, BGMAC_PAUSE_CTL, 0x27fff);
+		bgmac_umac_write(bgmac, UMAC_PAUSE_CTRL, 0x27fff);
 	}
 
 	if (bgmac->feature_flags & BGMAC_FEAT_SET_RXQ_CLK) {
@@ -1105,18 +1105,18 @@ static void bgmac_chip_init(struct bgmac *bgmac)
 	bgmac_write(bgmac, BGMAC_INT_RECV_LAZY, 1 << BGMAC_IRL_FC_SHIFT);
 
 	/* Enable 802.3x tx flow control (honor received PAUSE frames) */
-	bgmac_umac_cmd_maskset(bgmac, ~BGMAC_CMDCFG_RPI, 0, true);
+	bgmac_umac_cmd_maskset(bgmac, ~CMD_RX_PAUSE_IGNORE, 0, true);
 
 	bgmac_set_rx_mode(bgmac->net_dev);
 
 	bgmac_write_mac_address(bgmac, bgmac->net_dev->dev_addr);
 
 	if (bgmac->loopback)
-		bgmac_umac_cmd_maskset(bgmac, ~0, BGMAC_CMDCFG_ML, false);
+		bgmac_umac_cmd_maskset(bgmac, ~0, CMD_LCL_LOOP_EN, false);
 	else
-		bgmac_umac_cmd_maskset(bgmac, ~BGMAC_CMDCFG_ML, 0, false);
+		bgmac_umac_cmd_maskset(bgmac, ~CMD_LCL_LOOP_EN, 0, false);
 
-	bgmac_umac_write(bgmac, BGMAC_RXMAX_LENGTH, 32 + ETHER_MAX_LEN);
+	bgmac_umac_write(bgmac, UMAC_MAX_FRAME_LEN, 32 + ETHER_MAX_LEN);
 
 	bgmac_chip_intrs_on(bgmac);
 
@@ -1252,7 +1252,7 @@ static int bgmac_change_mtu(struct net_device *net_dev, int mtu)
 {
 	struct bgmac *bgmac = netdev_priv(net_dev);
 
-	bgmac_umac_write(bgmac, BGMAC_RXMAX_LENGTH, 32 + mtu);
+	bgmac_umac_write(bgmac, UMAC_MAX_FRAME_LEN, 32 + mtu);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bgmac.h b/drivers/net/ethernet/broadcom/bgmac.h
index c069107d0d95..110088e662ea 100644
--- a/drivers/net/ethernet/broadcom/bgmac.h
+++ b/drivers/net/ethernet/broadcom/bgmac.h
@@ -4,6 +4,8 @@
 
 #include <linux/netdevice.h>
 
+#include "unimac.h"
+
 #define BGMAC_DEV_CTL				0x000
 #define  BGMAC_DC_TSM				0x00000002
 #define  BGMAC_DC_CFCO				0x00000004
@@ -169,47 +171,7 @@
 #define BGMAC_RX_NONPAUSE_PKTS			0x420
 #define BGMAC_RX_SACHANGES			0x424
 #define BGMAC_RX_UNI_PKTS			0x428
-#define BGMAC_UNIMAC_VERSION			0x800
-#define BGMAC_HDBKP_CTL				0x804
-#define BGMAC_CMDCFG				0x808		/* Configuration */
-#define  BGMAC_CMDCFG_TE			0x00000001	/* Set to activate TX */
-#define  BGMAC_CMDCFG_RE			0x00000002	/* Set to activate RX */
-#define  BGMAC_CMDCFG_ES_MASK			0x0000000c	/* Ethernet speed see gmac_speed */
-#define   BGMAC_CMDCFG_ES_10			0x00000000
-#define   BGMAC_CMDCFG_ES_100			0x00000004
-#define   BGMAC_CMDCFG_ES_1000			0x00000008
-#define   BGMAC_CMDCFG_ES_2500			0x0000000C
-#define  BGMAC_CMDCFG_PROM			0x00000010	/* Set to activate promiscuous mode */
-#define  BGMAC_CMDCFG_PAD_EN			0x00000020
-#define  BGMAC_CMDCFG_CF			0x00000040
-#define  BGMAC_CMDCFG_PF			0x00000080
-#define  BGMAC_CMDCFG_RPI			0x00000100	/* Unset to enable 802.3x tx flow control */
-#define  BGMAC_CMDCFG_TAI			0x00000200
-#define  BGMAC_CMDCFG_HD			0x00000400	/* Set if in half duplex mode */
-#define  BGMAC_CMDCFG_HD_SHIFT			10
-#define  BGMAC_CMDCFG_SR_REV0			0x00000800	/* Set to reset mode, for core rev 0-3 */
-#define  BGMAC_CMDCFG_SR_REV4			0x00002000	/* Set to reset mode, for core rev >= 4 */
-#define  BGMAC_CMDCFG_ML			0x00008000	/* Set to activate mac loopback mode */
-#define  BGMAC_CMDCFG_AE			0x00400000
-#define  BGMAC_CMDCFG_CFE			0x00800000
-#define  BGMAC_CMDCFG_NLC			0x01000000
-#define  BGMAC_CMDCFG_RL			0x02000000
-#define  BGMAC_CMDCFG_RED			0x04000000
-#define  BGMAC_CMDCFG_PE			0x08000000
-#define  BGMAC_CMDCFG_TPI			0x10000000
-#define  BGMAC_CMDCFG_AT			0x20000000
-#define BGMAC_MACADDR_HIGH			0x80c		/* High 4 octets of own mac address */
-#define BGMAC_MACADDR_LOW			0x810		/* Low 2 octets of own mac address */
-#define BGMAC_RXMAX_LENGTH			0x814		/* Max receive frame length with vlan tag */
-#define BGMAC_PAUSEQUANTA			0x818
-#define BGMAC_MAC_MODE				0x844
-#define BGMAC_OUTERTAG				0x848
-#define BGMAC_INNERTAG				0x84c
-#define BGMAC_TXIPG				0x85c
-#define BGMAC_PAUSE_CTL				0xb30
-#define BGMAC_TX_FLUSH				0xb34
-#define BGMAC_RX_STATUS				0xb38
-#define BGMAC_TX_STATUS				0xb3c
+#define BGMAC_UNIMAC				0x800
 
 /* BCMA GMAC core specific IO Control (BCMA_IOCTL) flags */
 #define BGMAC_BCMA_IOCTL_SW_CLKEN		0x00000004	/* PHY Clock Enable */
@@ -558,12 +520,12 @@ static inline void bgmac_write(struct bgmac *bgmac, u16 offset, u32 value)
 
 static inline u32 bgmac_umac_read(struct bgmac *bgmac, u16 offset)
 {
-	return bgmac_read(bgmac, offset);
+	return bgmac_read(bgmac, BGMAC_UNIMAC + offset);
 }
 
 static inline void bgmac_umac_write(struct bgmac *bgmac, u16 offset, u32 value)
 {
-	bgmac_write(bgmac, offset, value);
+	bgmac_write(bgmac, BGMAC_UNIMAC + offset, value);
 }
 
 static inline u32 bgmac_idm_read(struct bgmac *bgmac, u16 offset)
@@ -621,7 +583,7 @@ static inline void bgmac_set(struct bgmac *bgmac, u16 offset, u32 set)
 
 static inline void bgmac_umac_maskset(struct bgmac *bgmac, u16 offset, u32 mask, u32 set)
 {
-	bgmac_maskset(bgmac, offset, mask, set);
+	bgmac_maskset(bgmac, BGMAC_UNIMAC + offset, mask, set);
 }
 
 static inline int bgmac_phy_connect(struct bgmac *bgmac)
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index f6ca01da141d..0a6d91b0f0aa 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -16,6 +16,8 @@
 #include <linux/dim.h>
 #include <linux/ethtool.h>
 
+#include "../unimac.h"
+
 /* total number of Buffer Descriptors, same for Rx/Tx */
 #define TOTAL_DESC				256
 
@@ -150,63 +152,6 @@ struct bcmgenet_mib_counters {
 	u32	tx_realloc_tsb_failed;
 };
 
-#define UMAC_HD_BKP_CTRL		0x004
-#define	 HD_FC_EN			(1 << 0)
-#define  HD_FC_BKOFF_OK			(1 << 1)
-#define  IPG_CONFIG_RX_SHIFT		2
-#define  IPG_CONFIG_RX_MASK		0x1F
-
-#define UMAC_CMD			0x008
-#define  CMD_TX_EN			(1 << 0)
-#define  CMD_RX_EN			(1 << 1)
-#define  UMAC_SPEED_10			0
-#define  UMAC_SPEED_100			1
-#define  UMAC_SPEED_1000		2
-#define  UMAC_SPEED_2500		3
-#define  CMD_SPEED_SHIFT		2
-#define  CMD_SPEED_MASK			3
-#define  CMD_PROMISC			(1 << 4)
-#define  CMD_PAD_EN			(1 << 5)
-#define  CMD_CRC_FWD			(1 << 6)
-#define  CMD_PAUSE_FWD			(1 << 7)
-#define  CMD_RX_PAUSE_IGNORE		(1 << 8)
-#define  CMD_TX_ADDR_INS		(1 << 9)
-#define  CMD_HD_EN			(1 << 10)
-#define  CMD_SW_RESET			(1 << 13)
-#define  CMD_LCL_LOOP_EN		(1 << 15)
-#define  CMD_AUTO_CONFIG		(1 << 22)
-#define  CMD_CNTL_FRM_EN		(1 << 23)
-#define  CMD_NO_LEN_CHK			(1 << 24)
-#define  CMD_RMT_LOOP_EN		(1 << 25)
-#define  CMD_PRBL_EN			(1 << 27)
-#define  CMD_TX_PAUSE_IGNORE		(1 << 28)
-#define  CMD_TX_RX_EN			(1 << 29)
-#define  CMD_RUNT_FILTER_DIS		(1 << 30)
-
-#define UMAC_MAC0			0x00C
-#define UMAC_MAC1			0x010
-#define UMAC_MAX_FRAME_LEN		0x014
-
-#define UMAC_MODE			0x44
-#define  MODE_LINK_STATUS		(1 << 5)
-
-#define UMAC_EEE_CTRL			0x064
-#define  EN_LPI_RX_PAUSE		(1 << 0)
-#define  EN_LPI_TX_PFC			(1 << 1)
-#define  EN_LPI_TX_PAUSE		(1 << 2)
-#define  EEE_EN				(1 << 3)
-#define  RX_FIFO_CHECK			(1 << 4)
-#define  EEE_TX_CLK_DIS			(1 << 5)
-#define  DIS_EEE_10M			(1 << 6)
-#define  LP_IDLE_PREDICTION_MODE	(1 << 7)
-
-#define UMAC_EEE_LPI_TIMER		0x068
-#define UMAC_EEE_WAKE_TIMER		0x06C
-#define UMAC_EEE_REF_COUNT		0x070
-#define  EEE_REFERENCE_COUNT_MASK	0xffff
-
-#define UMAC_TX_FLUSH			0x334
-
 #define UMAC_MIB_START			0x400
 
 #define UMAC_MDIO_CMD			0x614
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 6fb6c3556285..17f997ef950f 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -63,11 +63,11 @@ void bcmgenet_mii_setup(struct net_device *dev)
 
 		/* speed */
 		if (phydev->speed == SPEED_1000)
-			cmd_bits = UMAC_SPEED_1000;
+			cmd_bits = CMD_SPEED_1000;
 		else if (phydev->speed == SPEED_100)
-			cmd_bits = UMAC_SPEED_100;
+			cmd_bits = CMD_SPEED_100;
 		else
-			cmd_bits = UMAC_SPEED_10;
+			cmd_bits = CMD_SPEED_10;
 		cmd_bits <<= CMD_SPEED_SHIFT;
 
 		/* duplex */
diff --git a/drivers/net/ethernet/broadcom/unimac.h b/drivers/net/ethernet/broadcom/unimac.h
new file mode 100644
index 000000000000..4223a56b84d8
--- /dev/null
+++ b/drivers/net/ethernet/broadcom/unimac.h
@@ -0,0 +1,68 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __UNIMAC_H
+#define __UNIMAC_H
+
+#define UMAC_HD_BKP_CTRL		0x004
+#define  HD_FC_EN			BIT(0)
+#define  HD_FC_BKOFF_OK			BIT(1)
+#define  IPG_CONFIG_RX_SHIFT		2
+#define  IPG_CONFIG_RX_MASK		0x1F
+#define UMAC_CMD			0x008
+#define  CMD_TX_EN			BIT(0)
+#define  CMD_RX_EN			BIT(1)
+#define  CMD_SPEED_10			0
+#define  CMD_SPEED_100			1
+#define  CMD_SPEED_1000			2
+#define  CMD_SPEED_2500			3
+#define  CMD_SPEED_SHIFT		2
+#define  CMD_SPEED_MASK			3
+#define  CMD_PROMISC			BIT(4)
+#define  CMD_PAD_EN			BIT(5)
+#define  CMD_CRC_FWD			BIT(6)
+#define  CMD_PAUSE_FWD			BIT(7)
+#define  CMD_RX_PAUSE_IGNORE		BIT(8)
+#define  CMD_TX_ADDR_INS		BIT(9)
+#define  CMD_HD_EN			BIT(10)
+#define  CMD_SW_RESET_OLD		BIT(11)
+#define  CMD_SW_RESET			BIT(13)
+#define  CMD_LCL_LOOP_EN		BIT(15)
+#define  CMD_AUTO_CONFIG		BIT(22)
+#define  CMD_CNTL_FRM_EN		BIT(23)
+#define  CMD_NO_LEN_CHK			BIT(24)
+#define  CMD_RMT_LOOP_EN		BIT(25)
+#define  CMD_RX_ERR_DISC		BIT(26)
+#define  CMD_PRBL_EN			BIT(27)
+#define  CMD_TX_PAUSE_IGNORE		BIT(28)
+#define  CMD_TX_RX_EN			BIT(29)
+#define  CMD_RUNT_FILTER_DIS		BIT(30)
+#define UMAC_MAC0			0x00c
+#define UMAC_MAC1			0x010
+#define UMAC_MAX_FRAME_LEN		0x014
+#define UMAC_PAUSE_QUANTA		0x018
+#define UMAC_MODE			0x044
+#define  MODE_LINK_STATUS		BIT(5)
+#define UMAC_FRM_TAG0			0x048		/* outer tag */
+#define UMAC_FRM_TAG1			0x04c		/* inner tag */
+#define UMAC_TX_IPG_LEN			0x05c
+#define UMAC_EEE_CTRL			0x064
+#define  EN_LPI_RX_PAUSE		BIT(0)
+#define  EN_LPI_TX_PFC			BIT(1)
+#define  EN_LPI_TX_PAUSE		BIT(2)
+#define  EEE_EN				BIT(3)
+#define  RX_FIFO_CHECK			BIT(4)
+#define  EEE_TX_CLK_DIS			BIT(5)
+#define  DIS_EEE_10M			BIT(6)
+#define  LP_IDLE_PREDICTION_MODE	BIT(7)
+#define UMAC_EEE_LPI_TIMER		0x068
+#define UMAC_EEE_WAKE_TIMER		0x06C
+#define UMAC_EEE_REF_COUNT		0x070
+#define  EEE_REFERENCE_COUNT_MASK	0xffff
+#define UMAC_RX_IPG_INV			0x078
+#define UMAC_MACSEC_PROG_TX_CRC		0x310
+#define UMAC_MACSEC_CTRL		0x314
+#define UMAC_PAUSE_CTRL			0x330
+#define UMAC_TX_FLUSH			0x334
+#define UMAC_RX_FIFO_STATUS		0x338
+#define UMAC_TX_FIFO_STATUS		0x33c
+
+#endif
-- 
2.26.2

