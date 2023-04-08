Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEC56DBBDF
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 17:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjDHP23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 11:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjDHP21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 11:28:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07811707
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 08:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dswgCTyQVXhgC3c9wzvYFYw3LU1vGeVN40KU37gkIyA=; b=ui/nlYbm9kEslT2bI/0SdksAUl
        J6qZ7bQw3BkIJvGLGPwtE2YaRzqCo5YD5+Qsu6Tb5z02l3gAWyW/TGgNdLSfkwdpzw+AhnIRkgHZu
        EH4wfQtU3VweDl64T8LQtI+/OrP493OegNk0ZLLNVNmVFEGUWhKKwZc/P7cX5IrOgcEQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1plAUD-009niK-Uz; Sat, 08 Apr 2023 17:28:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     shawnguo@kernel.org
Cc:     s.hauer@pengutronix.de, Russell King <rmk+kernel@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 1/3] ARM: dts: imx51: ZII: Add missing phy-mode
Date:   Sat,  8 Apr 2023 17:27:59 +0200
Message-Id: <20230408152801.2336041-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230408152801.2336041-1-andrew@lunn.ch>
References: <20230408152801.2336041-1-andrew@lunn.ch>
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
for the CPU port. The imx51 Ethernet supports MII, and RMII. Set the
switch phy-mode based on how the SoC Ethernet port has been
configured.

Additionally, the cpu label has never actually been used in the
binding, so remove it.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
v2: Use rev-mii for the side 'playing PHY'.
---
 arch/arm/boot/dts/imx51-zii-rdu1.dts      | 2 +-
 arch/arm/boot/dts/imx51-zii-scu2-mezz.dts | 2 +-
 arch/arm/boot/dts/imx51-zii-scu3-esb.dts  | 1 -
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/imx51-zii-rdu1.dts b/arch/arm/boot/dts/imx51-zii-rdu1.dts
index e537e06e11d7..ab539a68b9ac 100644
--- a/arch/arm/boot/dts/imx51-zii-rdu1.dts
+++ b/arch/arm/boot/dts/imx51-zii-rdu1.dts
@@ -181,7 +181,7 @@ ports {
 
 				port@0 {
 					reg = <0>;
-					label = "cpu";
+					phy-mode = "rev-mii";
 					ethernet = <&fec>;
 
 					fixed-link {
diff --git a/arch/arm/boot/dts/imx51-zii-scu2-mezz.dts b/arch/arm/boot/dts/imx51-zii-scu2-mezz.dts
index 21dd3f7abd48..625f9ac671ae 100644
--- a/arch/arm/boot/dts/imx51-zii-scu2-mezz.dts
+++ b/arch/arm/boot/dts/imx51-zii-scu2-mezz.dts
@@ -82,7 +82,7 @@ port@3 {
 
 				port@4 {
 					reg = <4>;
-					label = "cpu";
+					phy-mode = "rev-mii";
 					ethernet = <&fec>;
 
 					fixed-link {
diff --git a/arch/arm/boot/dts/imx51-zii-scu3-esb.dts b/arch/arm/boot/dts/imx51-zii-scu3-esb.dts
index 9f857eb44bf7..19a3b142c964 100644
--- a/arch/arm/boot/dts/imx51-zii-scu3-esb.dts
+++ b/arch/arm/boot/dts/imx51-zii-scu3-esb.dts
@@ -267,7 +267,6 @@ fixed-link {
 
 				port@6 {
 					reg = <6>;
-					label = "cpu";
 					phy-mode = "mii";
 					ethernet = <&fec>;
 
-- 
2.40.0

