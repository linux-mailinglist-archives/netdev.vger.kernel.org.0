Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F143228724
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730307AbgGURSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:18:16 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:65129 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729583AbgGURSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:18:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595351894; x=1626887894;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qmXSt7D14ySY6HyhmSqPw8nvb2IeYDotRIoEDXfC9yk=;
  b=1Zq3e0dIGz/+ZUjVHlx4VrPg/4AzJB89lf2L+f5sO1CjjovQgVKCKTK4
   6QUTgrn/6i3xjD6bfySWVs/IIZ4st2yvE25DeTDXx6LCC3r9wYjwYX3Jj
   hUSKPcta70R48gbw28HgxdI3L8Z+Ak6dNTNWMwiTQ3n+ltHK9SqDGQumJ
   vrTeqONOxot/yHZu1cd2Bn/IEgJ1kDWfiMEfgy9IsOT8kOb0VdS/6T1N4
   +ezmOdla7+0PpxTYcCrgn9FFf6J6wcoMWBcENgs2Ftzb4xV0zN7+Rbrif
   WFmhFC26w44fRxtRiAzzc2attnbbwNzerBl5na98MV1AWjI5j3sVnabdF
   Q==;
IronPort-SDR: ke/FzcX5XDYZXmJmoP4GTJX8QRZ0WNSUwXovaCyIJ2Wcc6jKmmBvLciVdNUNBMoRYPdG8OeAQZ
 ZlnS+Z7D8dZPf+qEllAMQEX3PHAeoPtAvSC3//rel6R8DwEjSxHAzByPkFGvscRt8EYuBPEjeK
 6HKQnr4J/782e1vgym8B4L67coZu+sSemYMt/UBjO+CMznml4nX30wOXQkUaMCxWgj4LLhVKL/
 XWuR0XDJHPEQEZXD9OUAxusvAF0NF/sCyVJbueXAQKSZ4q8o/gpTeySBFHBh9jG7GRcz6R9iab
 Ni0=
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="84812037"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jul 2020 10:18:14 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 10:18:13 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 21 Jul 2020 10:15:20 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next v2 2/7] dt-bindings: net: macb: use an MDIO node as a container for PHY nodes
Date:   Tue, 21 Jul 2020 20:13:11 +0300
Message-ID: <20200721171316.1427582-3-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721171316.1427582-1-codrin.ciubotariu@microchip.com>
References: <20200721171316.1427582-1-codrin.ciubotariu@microchip.com>
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
---

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

