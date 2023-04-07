Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7754C6DAF95
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjDGPSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbjDGPSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:18:33 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94625246
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 08:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=rSXuKt5AGHxRCopVo4s6kYiRr4uNDVmXQ+8Y8rwwfwM=; b=VrsatUQeP0NsxOlaYTqw6HEvnY
        xW+Yxv9m0gQVRRyTlX09Ks3onOV7GGwlSw5U2MptjwhW91Aly38/M1JNBpc/o2wPFCOlGIcNCvbxO
        eth+sRmHWo1y95ijkUTdfXqh4gnlsVdVrzjpgyiDTbyqudozqN85Rs5A6NRksMZg1CTQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pknrA-009jfz-7I; Fri, 07 Apr 2023 17:18:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gregory Clement <gregory.clement@bootlin.com>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 2/3] ARM: dts: orion5: Add missing phy-mode and fixed links
Date:   Fri,  7 Apr 2023 17:17:21 +0200
Message-Id: <20230407151722.2320481-3-andrew@lunn.ch>
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
for the CPU port. The Orion5x Ethernet is an RGMII port. Set the
switch to impose the RGMII delays.

Additionally, the cpu label has never actually been used in the
binding, so remove it.

Lastly, add a fixed-link node indicating the expected speed/duplex of
the link to the SoC.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/boot/dts/orion5x-netgear-wnr854t.dts | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/orion5x-netgear-wnr854t.dts b/arch/arm/boot/dts/orion5x-netgear-wnr854t.dts
index 4f4888ec9138..fb203e7d37f5 100644
--- a/arch/arm/boot/dts/orion5x-netgear-wnr854t.dts
+++ b/arch/arm/boot/dts/orion5x-netgear-wnr854t.dts
@@ -137,8 +137,12 @@ port@2 {
 
 			port@3 {
 				reg = <3>;
-				label = "cpu";
 				ethernet = <&ethport>;
+				phy-mode = "rgmii-id";
+				fixed-link {
+					speed = <1000>;
+					full-duplex;
+				};
 			};
 
 			port@5 {
@@ -208,6 +212,7 @@ ethernet-port@0 {
 		/* Hardwired to DSA switch */
 		speed = <1000>;
 		duplex = <1>;
+		phy-mode = "rgmii";
 	};
 };
 
-- 
2.40.0

