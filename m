Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 920519C53B
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 19:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbfHYRn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 13:43:57 -0400
Received: from mx.0dd.nl ([5.2.79.48]:38734 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728660AbfHYRn5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Aug 2019 13:43:57 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 5BA3E5FD28;
        Sun, 25 Aug 2019 19:43:55 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="nro0kzTL";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id 1FFD71D8E168;
        Sun, 25 Aug 2019 19:43:55 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 1FFD71D8E168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1566755035;
        bh=6lat4PIPVb1cltboLCPg5/gDn73phY2LzDM8oNuT0Ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nro0kzTLs7e2U41CqK11e9uw/2xPpBR6Jjz8+4Gy4czDwpbnP1ZdVdilnLHkeHags
         MJ1ZnbghbRGVjntOFriY22pAsP0TnchYwwU4tgqtAFBIk6A+wZZJilXR4eRr3Ii75y
         ovjKiQCmdHk19S5xjxLTk3ke3L4dD1rMVlGuULzlCpwVPBCD93isymHA2Lx7gFclsv
         R4NGXUTX39J1IdzCWHC4RNcbFq5aP1EIFIoX9jgLqdgA6WKgMJim6IKQ3vpnnhGZb7
         yftwEGwFfj1/iBZ1WdFthOwjnYQ052rb+y0NayqmGtos/Eaw9ZJaW9u3YSDHwBuTCa
         YS2ukcEQYA/1Q==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Frank Wunderlich <frank-w@public-files.de>,
        Stefan Roese <sr@denx.de>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next v4 3/3] dt-bindings: net: ethernet: Update mt7622 docs and dts to reflect the new phylink API
Date:   Sun, 25 Aug 2019 19:43:41 +0200
Message-Id: <20190825174341.20750-4-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190825174341.20750-1-opensource@vdorst.com>
References: <20190825174341.20750-1-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch the removes the recently added mediatek,physpeed property.
Use the fixed-link property speed = <2500> to set the phy in 2.5Gbit.
See mt7622-bananapi-bpi-r64.dts for a working example.

Signed-off-by: René van Dorst <opensource@vdorst.com>
--
v3->v4:
* no change
v2->v3:
* no change
v1->v2:
* SGMII port only support BASE-X at 2.5Gbit.
---
 .../arm/mediatek/mediatek,sgmiisys.txt        |  2 --
 .../dts/mediatek/mt7622-bananapi-bpi-r64.dts  | 28 +++++++++++++------
 arch/arm64/boot/dts/mediatek/mt7622.dtsi      |  1 -
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
index f5518f26a914..30cb645c0e54 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
@@ -9,8 +9,6 @@ Required Properties:
 	- "mediatek,mt7622-sgmiisys", "syscon"
 	- "mediatek,mt7629-sgmiisys", "syscon"
 - #clock-cells: Must be 1
-- mediatek,physpeed: Should be one of "auto", "1000" or "2500" to match up
-		     the capability of the target PHY.
 
 The SGMIISYS controller uses the common clk binding from
 Documentation/devicetree/bindings/clock/clock-bindings.txt
diff --git a/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts b/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts
index 710c5c3d87d3..83e10591e0e5 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts
+++ b/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts
@@ -115,24 +115,34 @@
 };
 
 &eth {
-	pinctrl-names = "default";
-	pinctrl-0 = <&eth_pins>;
 	status = "okay";
+	gmac0: mac@0 {
+		compatible = "mediatek,eth-mac";
+		reg = <0>;
+		phy-mode = "2500base-x";
+
+		fixed-link {
+			speed = <2500>;
+			full-duplex;
+			pause;
+		};
+	};
 
 	gmac1: mac@1 {
 		compatible = "mediatek,eth-mac";
 		reg = <1>;
-		phy-handle = <&phy5>;
+		phy-mode = "rgmii";
+
+		fixed-link {
+			speed = <1000>;
+			full-duplex;
+			pause;
+		};
 	};
 
-	mdio-bus {
+	mdio: mdio-bus {
 		#address-cells = <1>;
 		#size-cells = <0>;
-
-		phy5: ethernet-phy@5 {
-			reg = <5>;
-			phy-mode = "sgmii";
-		};
 	};
 };
 
diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index d1e13d340e26..dac51e98204c 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -931,6 +931,5 @@
 			     "syscon";
 		reg = <0 0x1b128000 0 0x3000>;
 		#clock-cells = <1>;
-		mediatek,physpeed = "2500";
 	};
 };
-- 
2.20.1

