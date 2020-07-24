Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5622C22C3B6
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 12:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgGXKuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 06:50:52 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:55265 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgGXKuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 06:50:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595587850; x=1627123850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JPT5jZOsGT2B+NINcpYtfUVeN8a8QBU08K/b7FI06Ag=;
  b=ARChtt8i9sM9PEQwDxw3rEtHD56t8zMA3Fp3+2bod+q+zY119Lu1+v3E
   SffmOFCEYrxv/qGU3pc71WQzc798KmjRe770m2zAKrDOYKajIDnG7WUrz
   BaIVV45qXdKgEClLAsy2BGQCPEWlaz4aqjd9quwqFuZWduUUFZAkb74x+
   y6NvOblnU3oo86rD8nAKYBz/+ZhbusslSFEmGxuRXrN9zLTRsPeWjJqnN
   eFZmdNJeaSYjxqAZfxo4cge3O6yYvSE1p1N9pz5E3KsX+GdKmlopmmMcd
   7HuyNYK/Gc9rMjhRCmszM4CJbbtuV4UCHmE9DZR+M3M3XXpqgVAYxDelq
   w==;
IronPort-SDR: HMa1ZH+s2UPSueHBq/YbryWGwsGb4XlE0+ZGEj1fYkPuDlK33ldhzzEZKMN7Q3+Yt6KmPQZzIx
 HWMqVsGKzEsu0eaVdtDVaiEuR8H2gpKTI2SPVxaDzp+zCGrq1LRxQ+nspTrxtD7ZsdJpuPVMYT
 w1YPz5a1yLtRalBoAjU7+hfn6dtJFE+2Xy2E7/JTabTm9u0cY+S4pdwG2ElAAPjn8g5+3bbsD2
 JEenuwmUK7QLkH1cBS+79Igwmu/QxgnDV/nWhjDN9gqZdGmwF0ai44elw6CbQzzTeNA/VqGIqR
 lPA=
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="83152928"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2020 03:50:49 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 03:50:06 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 24 Jul 2020 03:50:04 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v3 2/7] dt-bindings: net: macb: use an MDIO node as a container for PHY nodes
Date:   Fri, 24 Jul 2020 13:50:28 +0300
Message-ID: <20200724105033.2124881-3-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200724105033.2124881-1-codrin.ciubotariu@microchip.com>
References: <20200724105033.2124881-1-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MACB driver embeds an MDIO bus controller and for this reason there
was no need for an MDIO sub-node present to contain the PHY nodes. Adding
MDIO devies directly under an Ethernet node is deprecated, so an MDIO node
is included to contain of the PHY nodes (and other MDIO devices' nodes).

Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Acked-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---

Changes in v3:
 - Added tags from Claudiu, Rob and Florian

Changes in v2:
 - patch renamed from "macb: bindings doc: use an MDIO node as a
   container for PHY nodes" to "dt-bindings: net: macb: use an MDIO
   node as a container for PHY nodes" 

 Documentation/devicetree/bindings/net/macb.txt | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index 0b61a90f1592..88d5199c2279 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -32,6 +32,11 @@ Required properties:
 The MAC address will be determined using the optional properties
 defined in ethernet.txt.
 
+Optional subnodes:
+- mdio : specifies the MDIO bus in the MACB, used as a container for PHY nodes or other
+  nodes of devices present on the MDIO bus. Please see ethernet-phy.yaml in the same
+  directory for more details.
+
 Optional properties for PHY child node:
 - reset-gpios : Should specify the gpio for phy reset
 - magic-packet : If present, indicates that the hardware supports waking
@@ -48,8 +53,12 @@ Examples:
 		local-mac-address = [3a 0e 03 04 05 06];
 		clock-names = "pclk", "hclk", "tx_clk";
 		clocks = <&clkc 30>, <&clkc 30>, <&clkc 13>;
-		ethernet-phy@1 {
-			reg = <0x1>;
-			reset-gpios = <&pioE 6 1>;
+		mdio {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			ethernet-phy@1 {
+				reg = <0x1>;
+				reset-gpios = <&pioE 6 1>;
+			};
 		};
 	};
-- 
2.25.1

