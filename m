Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6D66DE887
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 02:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjDLAiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 20:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDLAiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 20:38:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8AD52134
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 17:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=2E8v5Hf8ehg+o5T3PX9YfzM4fwVvcJud+5jTfxBINVc=; b=FoDfbQijnp4W9CuKi7yoK5Coij
        T1iYYyP23CIjJ2LsHRRGxEVVmu4n9wN34iBW5caCpEdtVvsZVotwXtgK4iOXNCDSYKcTwkncX+G4E
        y6cmNpvSt3+L6dE9ILvloP1BCzwU8eW4BBem9BIn7CpVopapD+jZKW9dZgazFj6G/jEc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pmOUk-00A2PM-H9; Wed, 12 Apr 2023 02:37:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     shawnguo@kernel.org
Cc:     s.hauer@pengutronix.de, Russell King <rmk+kernel@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH] ARM: dts: vf610: ZII: Add missing phy-mode and fixed links
Date:   Wed, 12 Apr 2023 02:37:46 +0200
Message-Id: <20230412003746.2392518-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA framework has got more picky about always having a phy-mode
for the CPU port. The Vybrid FEC is a Fast Ethrnet using RMII.

Additionally, the cpu label has never actually been used in the
binding, so remove it.

Lastly, for DSA links between switches, add a fixed-link node
indicating the expected speed/duplex of the link.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/boot/dts/vf610-zii-cfu1.dts      |  2 +-
 arch/arm/boot/dts/vf610-zii-dev-rev-b.dts |  2 +-
 arch/arm/boot/dts/vf610-zii-dev-rev-c.dts | 10 ++++++++-
 arch/arm/boot/dts/vf610-zii-scu4-aib.dts  | 26 ++++++++++++++++++++++-
 arch/arm/boot/dts/vf610-zii-spb4.dts      |  2 +-
 arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts  |  2 +-
 arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts |  2 +-
 7 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/vf610-zii-cfu1.dts b/arch/arm/boot/dts/vf610-zii-cfu1.dts
index 96495d965163..b7bb2d6b3721 100644
--- a/arch/arm/boot/dts/vf610-zii-cfu1.dts
+++ b/arch/arm/boot/dts/vf610-zii-cfu1.dts
@@ -202,7 +202,7 @@ port@5 {
 
 				port@6 {
 					reg = <6>;
-					label = "cpu";
+					phy-mode = "rev-rmii";
 					ethernet = <&fec1>;
 
 					fixed-link {
diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
index 6280c5e86a12..3f1bc7fc8526 100644
--- a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
+++ b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
@@ -75,7 +75,7 @@ fixed-link {
 
 					port@6 {
 						reg = <6>;
-						label = "cpu";
+						phy-mode = "rev-rmii";
 						ethernet = <&fec1>;
 
 						fixed-link {
diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
index c00d39562a10..811745077d2b 100644
--- a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
+++ b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
@@ -44,7 +44,7 @@ ports {
 
 					port@0 {
 						reg = <0>;
-						label = "cpu";
+						phy-mode = "rev-rmii";
 						ethernet = <&fec1>;
 
 						fixed-link {
@@ -82,6 +82,10 @@ switch0port10: port@10 {
 						label = "dsa";
 						phy-mode = "xaui";
 						link = <&switch1port10>;
+						fixed-link {
+							speed = <10000>;
+							full-duplex;
+						};
 					};
 				};
 
@@ -174,6 +178,10 @@ switch1port10: port@10 {
 						label = "dsa";
 						phy-mode = "xaui";
 						link = <&switch0port10>;
+						fixed-link {
+							speed = <10000>;
+							full-duplex;
+						};
 					};
 				};
 				mdio {
diff --git a/arch/arm/boot/dts/vf610-zii-scu4-aib.dts b/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
index 7b3276cd470f..7959307f7d13 100644
--- a/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
+++ b/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
@@ -59,7 +59,7 @@ ports {
 
 					port@0 {
 						reg = <0>;
-						label = "cpu";
+						phy-mode = "rev-rmii";
 						ethernet = <&fec1>;
 
 						fixed-link {
@@ -115,6 +115,10 @@ switch0port10: port@10 {
 						link = <&switch1port10
 							&switch3port10
 							&switch2port10>;
+						fixed-link {
+							speed = <10000>;
+							full-duplex;
+						};
 					};
 				};
 			};
@@ -156,6 +160,10 @@ switch1port9: port@9 {
 						phy-mode = "xgmii";
 						link = <&switch3port10
 							&switch2port10>;
+						fixed-link {
+							speed = <10000>;
+							full-duplex;
+						};
 					};
 
 					switch1port10: port@10 {
@@ -163,6 +171,10 @@ switch1port10: port@10 {
 						label = "dsa";
 						phy-mode = "xgmii";
 						link = <&switch0port10>;
+						fixed-link {
+							speed = <10000>;
+							full-duplex;
+						};
 					};
 				};
 			};
@@ -246,6 +258,10 @@ switch2port10: port@10 {
 						link = <&switch3port9
 							&switch1port9
 							&switch0port10>;
+						fixed-link {
+							speed = <2500>;
+							full-duplex;
+						};
 					};
 				};
 			};
@@ -295,6 +311,10 @@ switch3port9: port@9 {
 						label = "dsa";
 						phy-mode = "2500base-x";
 						link = <&switch2port10>;
+						fixed-link {
+							speed = <2500>;
+							full-duplex;
+						};
 					};
 
 					switch3port10: port@10 {
@@ -303,6 +323,10 @@ switch3port10: port@10 {
 						phy-mode = "xgmii";
 						link = <&switch1port9
 							&switch0port10>;
+						fixed-link {
+							speed = <10000>;
+							full-duplex;
+						};
 					};
 				};
 			};
diff --git a/arch/arm/boot/dts/vf610-zii-spb4.dts b/arch/arm/boot/dts/vf610-zii-spb4.dts
index 180acb0795b9..3f9687953f57 100644
--- a/arch/arm/boot/dts/vf610-zii-spb4.dts
+++ b/arch/arm/boot/dts/vf610-zii-spb4.dts
@@ -140,7 +140,7 @@ ports {
 
 				port@0 {
 					reg = <0>;
-					label = "cpu";
+					phy-mode = "rev-rmii";
 					ethernet = <&fec1>;
 
 					fixed-link {
diff --git a/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts b/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
index 73fdace4cb42..d06a074bfe21 100644
--- a/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
+++ b/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
@@ -129,7 +129,7 @@ ports {
 
 				port@0 {
 					reg = <0>;
-					label = "cpu";
+					phy-mode = "rev-rmii";
 					ethernet = <&fec1>;
 
 					fixed-link {
diff --git a/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts b/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
index 20beaa8433b6..c60639beda40 100644
--- a/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
+++ b/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
@@ -154,7 +154,7 @@ ports {
 
 				port@0 {
 					reg = <0>;
-					label = "cpu";
+					phy-mode = "rev-rmii";
 					ethernet = <&fec1>;
 
 					fixed-link {
-- 
2.40.0

