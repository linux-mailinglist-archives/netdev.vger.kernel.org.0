Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9BA2D052A
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 14:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgLFN3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 08:29:24 -0500
Received: from mx4.wp.pl ([212.77.101.12]:33790 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbgLFN3X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 08:29:23 -0500
Received: (wp-smtpd smtp.wp.pl 31589 invoked from network); 6 Dec 2020 14:28:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1607261310; bh=1v7Ikvo5U6Dc6D8OwUMg28BDg5V8SVqWfPaZSgUddhQ=;
          h=From:To:Cc:Subject;
          b=Y843vYs710uQiIQuWLq3xLRw7amrx+cQJHL/iVkrejyQEJL6dXLTKuZJCw52NS38G
           sx0fpX+6FQpHV0Var0xCny3xR0NL9Yw/q9VR+dfznMJehlXkV9ka68EDc1ILdhZnG9
           KKzK7wOP5rKOuVY6gWfKhXuPzVcqQ3PPU1x6X1kw=
Received: from riviera.nat.student.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 6 Dec 2020 14:28:30 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH v2 2/2] dt-bindings: net: dsa: lantiq, lantiq-gswip: add example for xRX330
Date:   Sun,  6 Dec 2020 14:27:13 +0100
Message-Id: <20201206132713.13452-3-olek2@wp.pl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201206132713.13452-1-olek2@wp.pl>
References: <20201206132713.13452-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: d071ba2a14f55086f348850311d986d1
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000002 [ERHV]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatible string and example for xRX300 and xRX330.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 .../bindings/net/dsa/lantiq-gswip.txt         | 110 +++++++++++++++++-
 1 file changed, 109 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt b/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt
index 886cbe8ffb38..7a90a6a1b065 100644
--- a/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt
+++ b/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt
@@ -3,7 +3,8 @@ Lantiq GSWIP Ethernet switches
 
 Required properties for GSWIP core:
 
-- compatible	: "lantiq,xrx200-gswip" for the embedded GSWIP in the
+- compatible	: "lantiq,xrx200-gswip", "lantiq,xrx300-gswip" or
+		  "lantiq,xrx330-gswip" for the embedded GSWIP in the
 		  xRX200 SoC
 - reg		: memory range of the GSWIP core registers
 		: memory range of the GSWIP MDIO registers
@@ -141,3 +142,110 @@ switch@e108000 {
 		};
 	};
 };
+
+Ethernet switch on the GRX330 SoC:
+
+switch@e108000 {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	compatible = "lantiq,xrx300-gswip";
+	reg = <	0xe108000 0x3100	/* switch */
+		0xe10b100 0xd8		/* mdio */
+		0xe10b1d8 0x130		/* mii */
+		>;
+	dsa,member = <0 0>;
+
+	ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@1 {
+			reg = <1>;
+			label = "lan1";
+			phy-mode = "internal";
+			phy-handle = <&phy1>;
+		};
+
+		port@2 {
+			reg = <2>;
+			label = "lan2";
+			phy-mode = "internal";
+			phy-handle = <&phy2>;
+		};
+
+		port@3 {
+			reg = <3>;
+			label = "lan3";
+			phy-mode = "internal";
+			phy-handle = <&phy3>;
+		};
+
+		port@4 {
+			reg = <4>;
+			label = "lan4";
+			phy-mode = "internal";
+			phy-handle = <&phy4>;
+		};
+
+		port@6 {
+			reg = <0x6>;
+			label = "cpu";
+			ethernet = <&eth0>;
+		};
+	};
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "lantiq,xrx200-mdio";
+		reg = <0>;
+
+		phy1: ethernet-phy@1 {
+			reg = <0x1>;
+		};
+		phy2: ethernet-phy@2 {
+			reg = <0x2>;
+		};
+		phy3: ethernet-phy@3 {
+			reg = <0x3>;
+		};
+		phy4: ethernet-phy@4 {
+			reg = <0x4>;
+		};
+	};
+
+	gphy-fw {
+		compatible = "lantiq,xrx330-gphy-fw", "lantiq,gphy-fw";
+		lantiq,rcu = <&rcu0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		gphy@20 {
+			reg = <0x20>;
+
+			resets = <&reset0 31 30>;
+			reset-names = "gphy";
+		};
+
+		gphy@68 {
+			reg = <0x68>;
+
+			resets = <&reset0 29 28>;
+			reset-names = "gphy";
+		};
+
+		gphy@ac {
+			reg = <0xac>;
+
+			resets = <&reset0 28 13>;
+			reset-names = "gphy";
+		};
+
+		gphy@264 {
+			reg = <0x264>;
+
+			resets = <&reset0 10 10>;
+			reset-names = "gphy";
+		};
+	};
+};
-- 
2.20.1

