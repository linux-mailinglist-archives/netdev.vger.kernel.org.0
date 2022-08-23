Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D56459D2E3
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 10:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241564AbiHWIC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 04:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241532AbiHWICz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 04:02:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768FF659D3
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 01:02:54 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oQOrt-0002vg-O2; Tue, 23 Aug 2022 10:02:38 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oQOrr-001Sv2-8I; Tue, 23 Aug 2022 10:02:35 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oQOrp-00ALa6-Ao; Tue, 23 Aug 2022 10:02:33 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3 17/17] net: dsa: microchip: remove IS_9893 flag
Date:   Tue, 23 Aug 2022 10:02:31 +0200
Message-Id: <20220823080231.2466017-18-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220823080231.2466017-1-o.rempel@pengutronix.de>
References: <20220823080231.2466017-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use chip_id as other places of this code do it

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz9477.c    | 3 ---
 drivers/net/dsa/microchip/ksz_common.c | 3 ++-
 drivers/net/dsa/microchip/ksz_common.h | 4 ----
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 1dae75af8e1b9..6f857922eb3e2 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1165,9 +1165,6 @@ int ksz9477_switch_init(struct ksz_device *dev)
 	if (ret)
 		return ret;
 
-	if (dev->chip_id == KSZ9893_CHIP_ID)
-		dev->features |= IS_9893;
-
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index a863d4feb4135..08491a67dc359 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1865,7 +1865,8 @@ static void ksz_set_xmii(struct ksz_device *dev, int port,
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 		data8 |= bitval[P_RGMII_SEL];
 		/* On KSZ9893, disable RGMII in-band status support */
-		if (dev->features & IS_9893)
+		if (dev->chip_id == KSZ9893_CHIP_ID ||
+		    dev->chip_id == KSZ8563_CHIP_ID)
 			data8 &= ~P_MII_MAC_MODE;
 		break;
 	default:
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 1b327bca1fb88..54c1cba35a9d8 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -118,7 +118,6 @@ struct ksz_device {
 	unsigned long mib_read_interval;
 	u16 mirror_rx;
 	u16 mirror_tx;
-	u32 features;			/* chip specific features */
 	u16 port_mask;
 };
 
@@ -541,9 +540,6 @@ static inline int is_lan937x(struct ksz_device *dev)
 
 #define SW_START			0x01
 
-/* Used with variable features to indicate capabilities. */
-#define IS_9893				BIT(2)
-
 /* xMII configuration */
 #define P_MII_DUPLEX_M			BIT(6)
 #define P_MII_100MBIT_M			BIT(4)
-- 
2.30.2

