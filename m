Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4131E6DAFA4
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbjDGPZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233032AbjDGPZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:25:31 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D749EE5
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 08:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WM2tDHH9rXY0X0+Xk8mi6u7u0H/XcHl0OImH+M9gYQ8=; b=5MBVPgq/PW14mhfhOYwQOtxZ1h
        lsn6IZJGqHhJVkQUMT6A1ngy8MHZzY/SVE/bOU9TUgdlpyOURHkhSeZ+Pc5/nydKevYDlp9HOfcwS
        ckBCtYtxJFZ7L4Zc6eXTkIW1up+hT7bZ+00fscPXzhYTrrwVbR4WUp2zoqojfsaCMiig=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pknxp-009jjb-PB; Fri, 07 Apr 2023 17:25:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     shawnguo@kernel.org
Cc:     s.hauer@pengutronix.de, Russell King <rmk+kernel@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 1/3] ARM: dts: imx51: ZII: Add missing phy-mode
Date:   Fri,  7 Apr 2023 17:25:01 +0200
Message-Id: <20230407152503.2320741-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230407152503.2320741-1-andrew@lunn.ch>
References: <20230407152503.2320741-1-andrew@lunn.ch>
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
 arch/arm/boot/dts/imx51-zii-rdu1.dts      | 2 +-
 arch/arm/boot/dts/imx51-zii-scu2-mezz.dts | 2 +-
 arch/arm/boot/dts/imx51-zii-scu3-esb.dts  | 1 -
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/imx51-zii-rdu1.dts b/arch/arm/boot/dts/imx51-zii-rdu1.dts
index e537e06e11d7..8621760af1af 100644
--- a/arch/arm/boot/dts/imx51-zii-rdu1.dts
+++ b/arch/arm/boot/dts/imx51-zii-rdu1.dts
@@ -181,7 +181,7 @@ ports {
 
 				port@0 {
 					reg = <0>;
-					label = "cpu";
+					phy-mode = "mii";
 					ethernet = <&fec>;
 
 					fixed-link {
diff --git a/arch/arm/boot/dts/imx51-zii-scu2-mezz.dts b/arch/arm/boot/dts/imx51-zii-scu2-mezz.dts
index 21dd3f7abd48..883e80d92ef0 100644
--- a/arch/arm/boot/dts/imx51-zii-scu2-mezz.dts
+++ b/arch/arm/boot/dts/imx51-zii-scu2-mezz.dts
@@ -82,7 +82,7 @@ port@3 {
 
 				port@4 {
 					reg = <4>;
-					label = "cpu";
+					phy-mode = "mii";
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

