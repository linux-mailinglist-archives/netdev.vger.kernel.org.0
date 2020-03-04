Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 400D8178F17
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 12:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387912AbgCDLAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 06:00:13 -0500
Received: from mx009.vodafonemail.xion.oxcs.net ([153.92.174.39]:54557 "EHLO
        mx009.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387774AbgCDLAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 06:00:13 -0500
Received: from vsmx002.vodafonemail.xion.oxcs.net (unknown [192.168.75.192])
        by mta-6-out.mta.xion.oxcs.net (Postfix) with ESMTP id 17BA76052E8;
        Wed,  4 Mar 2020 10:52:21 +0000 (UTC)
Received: from app-31.app.xion.oxcs.net (app-31.app.xion.oxcs.net [10.10.1.31])
        by mta-6-out.mta.xion.oxcs.net (Postfix) with ESMTPA id E6EFA6047BC;
        Wed,  4 Mar 2020 10:52:06 +0000 (UTC)
Date:   Wed, 4 Mar 2020 11:52:06 +0100 (CET)
From:   Markus Moll <moll.markus@arcor.de>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Message-ID: <2045683506.315295.1583319126809@mail.vodafone.de>
Subject: [PATCH 1/3] dt-bindings: net: Add dp83867 LED mode constants
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev66
X-Originating-Client: open-xchange-appsuite
X-VADE-STATUS: LEGIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These values reflect the register settings of LEDCR1, which maps PHY
status signals to LED pins.

Signed-off-by: Markus Moll <moll.markus@arcor.de>
---

This is the first of three patches that adds led configuration support
to the TI DP83867 driver. The DP83867 PHY has four LED output pins
(three of which are dedicated pins, one is muxed) whose functions are
configurable. To let system designers statically configure the LED
output functions, a devicetree property "ti,led-modes" is added. The
four entries of ti,led-modes correspond to the four LED settings in the
LEDCR1 register of the PHY.

The new led_modes field of dp83867_private is initialized only if
CONFIG_OF_MDIO is set. This is consistent with how all other fields of
that structure are currently initialized (e.g. tx_id_delay).

 include/dt-bindings/net/ti-dp83867.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/dt-bindings/net/ti-dp83867.h b/include/dt-bindings/net/ti-dp83867.h
index 6fc4b445d3a..53a33956b63 100644
--- a/include/dt-bindings/net/ti-dp83867.h
+++ b/include/dt-bindings/net/ti-dp83867.h
@@ -50,4 +50,21 @@
 #define DP83867_CLK_O_SEL_REF_CLK		0xC
 /* Special flag to indicate clock should be off */
 #define DP83867_CLK_O_SEL_OFF			0xFFFFFFFF
+
+/* LEDCR LED modes */
+#define DP83867_LED_LINK			0x0
+#define DP83867_LED_ACT_RX_TX			0x1
+#define DP83867_LED_ACT_TX			0x2
+#define DP83867_LED_ACT_RX			0x3
+#define DP83867_LED_COLLISION			0x4
+#define DP83867_LED_LINK_1000_BT		0x5
+#define DP83867_LED_LINK_100_BTX		0x6
+#define DP83867_LED_LINK_10_BT			0x7
+#define DP83867_LED_LINK_10_100_BT		0x8
+#define DP83867_LED_LINK_100_1000_BT		0x9
+#define DP83867_LED_FULL_DUPLEX			0xA
+#define DP83867_LED_LINK_AND_ACT		0xB
+#define DP83867_LED_RX_TX_ERROR			0xD
+#define DP83867_LED_RX_ERROR			0xE
+
 #endif
-- 
2.25.0
