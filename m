Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874246DAF98
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240412AbjDGPSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbjDGPSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:18:33 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003365253
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 08:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pj4xucn+RthAXJf56RvQsq8JmBebrB1XnmSsb7NxgiU=; b=HnbHm3DrwEpqnW9pqgGjbpdEMN
        MVa2yhXEEMJScKDTsBRr16hQ1ZcWS33euh1N96/WEtJOXqFT50MplTg2IC60lfkoymQDojxz23Swm
        gakKDRhVscF/UzcOkCZZ9e+2k/Y94IpSRqrObHilV2o/rIUfeM/pEYwep6dV2xajZztg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pknrA-009jfw-6L; Fri, 07 Apr 2023 17:18:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gregory Clement <gregory.clement@bootlin.com>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 1/3] ARM: dts: kirkwood: Add missing phy-mode and fixed links
Date:   Fri,  7 Apr 2023 17:17:20 +0200
Message-Id: <20230407151722.2320481-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230407151722.2320481-1-andrew@lunn.ch>
References: <20230407151722.2320481-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA framework has got more picky about always having a phy-mode
for the CPU port. The Kirkwood Ethernet is an RGMII port. Set the
switch to impose the RGMII delays.

Additionally, the cpu label has never actually been used in the
binding, so remove it.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/boot/dts/kirkwood-dir665.dts          | 3 ++-
 arch/arm/boot/dts/kirkwood-l-50.dts            | 2 +-
 arch/arm/boot/dts/kirkwood-linksys-viper.dts   | 3 ++-
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts | 3 ++-
 arch/arm/boot/dts/kirkwood-rd88f6281.dtsi      | 2 +-
 5 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/kirkwood-dir665.dts b/arch/arm/boot/dts/kirkwood-dir665.dts
index f9f4b0143ba8..0c0851cd9bec 100644
--- a/arch/arm/boot/dts/kirkwood-dir665.dts
+++ b/arch/arm/boot/dts/kirkwood-dir665.dts
@@ -232,7 +232,7 @@ port@4 {
 
 			port@6 {
 				reg = <6>;
-				label = "cpu";
+				phy-mode = "rgmii-id";
 				ethernet = <&eth0port>;
 				fixed-link {
 					speed = <1000>;
@@ -251,6 +251,7 @@ &eth0 {
 	ethernet0-port@0 {
 		speed = <1000>;
 		duplex = <1>;
+		phy-mode = "rgmii";
 	};
 };
 
diff --git a/arch/arm/boot/dts/kirkwood-l-50.dts b/arch/arm/boot/dts/kirkwood-l-50.dts
index 60c1e94f5dd3..9fd3581bb24b 100644
--- a/arch/arm/boot/dts/kirkwood-l-50.dts
+++ b/arch/arm/boot/dts/kirkwood-l-50.dts
@@ -254,7 +254,6 @@ fixed-link {
 
 			port@6 {
 				reg = <6>;
-				label = "cpu";
 				phy-mode = "rgmii-id";
 				ethernet = <&eth1port>;
 				fixed-link {
@@ -330,6 +329,7 @@ &eth1 {
 	ethernet1-port@0 {
 		speed = <1000>;
 		duplex = <1>;
+		phy-mode = "rgmii";
 	};
 };
 
diff --git a/arch/arm/boot/dts/kirkwood-linksys-viper.dts b/arch/arm/boot/dts/kirkwood-linksys-viper.dts
index 2f9660f3b457..27fd6e2337d5 100644
--- a/arch/arm/boot/dts/kirkwood-linksys-viper.dts
+++ b/arch/arm/boot/dts/kirkwood-linksys-viper.dts
@@ -198,7 +198,7 @@ port@4 {
 
 			port@5 {
 				reg = <5>;
-				label = "cpu";
+				phy-mode = "rgmii-id";
 				ethernet = <&eth0port>;
 				fixed-link {
 					speed = <1000>;
@@ -221,6 +221,7 @@ &eth0 {
 	ethernet0-port@0 {
 		speed = <1000>;
 		duplex = <1>;
+		phy-mode = "rgmii";
 	};
 };
 
diff --git a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts b/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
index ced576acfb95..5a77286136c7 100644
--- a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
+++ b/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
@@ -149,7 +149,7 @@ port@4 {
 
 			port@5 {
 				reg = <5>;
-				label = "cpu";
+				phy-mode = "rgmii-id";
 				ethernet = <&eth0port>;
 				fixed-link {
 					speed = <1000>;
@@ -166,6 +166,7 @@ &eth0 {
 	ethernet0-port@0 {
 		speed = <1000>;
 		duplex = <1>;
+		phy-mode = "rgmii";
 	};
 };
 
diff --git a/arch/arm/boot/dts/kirkwood-rd88f6281.dtsi b/arch/arm/boot/dts/kirkwood-rd88f6281.dtsi
index e21aa674945d..9d62f910cddf 100644
--- a/arch/arm/boot/dts/kirkwood-rd88f6281.dtsi
+++ b/arch/arm/boot/dts/kirkwood-rd88f6281.dtsi
@@ -105,7 +105,7 @@ port@3 {
 
 			port@5 {
 				reg = <5>;
-				label = "cpu";
+				phy-mode = "rgmii-id";
 				ethernet = <&eth0port>;
 				fixed-link {
 					speed = <1000>;
-- 
2.40.0

