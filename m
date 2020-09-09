Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329902631D2
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731024AbgIIQ2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731022AbgIIQ0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:26:06 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA41C061795;
        Wed,  9 Sep 2020 09:26:05 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id D5423140A7D;
        Wed,  9 Sep 2020 18:25:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1599668755; bh=ETijTD2hHqyWxW2zwXhqdFU5Xk5g005codDN5mEO12w=;
        h=From:To:Date;
        b=fCs8lADvaSZx/tRW4It7vvjDQqLxXSf0ofh5ycAqs4qKwAnJ4M6nEOm7C/kWYjWzS
         ldSpXT1S247pBH6u+pIBV4mjNWMCYm3h+/2ed8WqrHa7K9IgMbq5PVpQOMQnqiu28j
         QeqYGFpVaS3hXsCIXMtHtGEsFgOywhS5gt+T5jio=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next + mvebu v2 7/7] arm64: dts: armada-3720-turris-mox: add nodes for ethernet PHY LEDs
Date:   Wed,  9 Sep 2020 18:25:52 +0200
Message-Id: <20200909162552.11032-8-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909162552.11032-1-marek.behun@nic.cz>
References: <20200909162552.11032-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add nodes for the green and yellow LEDs that are connected to the
ethernet PHY chip on Turris MOX A.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 .../dts/marvell/armada-3720-turris-mox.dts    | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
index f3a678e0fd99b..6da03b6c69c0a 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -9,6 +9,7 @@
 #include <dt-bindings/bus/moxtet.h>
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/input/input.h>
+#include <dt-bindings/leds/common.h>
 #include "armada-372x.dtsi"
 
 / {
@@ -273,6 +274,28 @@ &mdio {
 
 	phy1: ethernet-phy@1 {
 		reg = <1>;
+
+		leds {
+			compatible = "linux,hw-controlled-leds";
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			led@0 {
+				reg = <0>;
+				color = <LED_COLOR_ID_GREEN>;
+				function = LED_FUNCTION_STATUS;
+				linux,default-trigger = "dev-hw-mode";
+				linux,default-hw-mode = "1Gbps/100Mbps/10Mbps";
+			};
+
+			led@1 {
+				reg = <1>;
+				color = <LED_COLOR_ID_YELLOW>;
+				function = LED_FUNCTION_ACTIVITY;
+				linux,default-trigger = "dev-hw-mode";
+				linux,default-hw-mode = "blink-act";
+			};
+		};
 	};
 
 	/* switch nodes are enabled by U-Boot if modules are present */
-- 
2.26.2

