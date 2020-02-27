Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08ED917146A
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 10:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgB0JxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 04:53:08 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34930 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728454AbgB0JxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 04:53:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4Dp7mkcUtdW2tERi+jH4BIpeVDMyk4miuASJrf/8YYI=; b=ZwsjtKIX0ZT+IcOxljKyal2CwR
        C2FUBo2NgHHukysc80HVUWJ7AAd4iq/azt/ArgcRFaSGvYASo5/n12o5x1NYWFcOxv0USnb9auRbZ
        3aIJEi01oPcGdIu6G4pym/r2+fDYHVwTY2FBHtsJRaJVVPzh1L4LnOmTnuOK2HGuUcyImrcUFVhhg
        pvIll5zpXLaozd6Ap9ya1LnQZtdDwd49NVlgkDJCzJff5E1+b9YG0dLCeCrlwW9GRgv3xdNVe9K0q
        v7iipUkxTBrA4gbc9RY8fzcFpvwo+Xko5N1vsfqlMK3f8XXlSvAnBo/sWM35zmPe2W0Ks8L4COSbx
        f96g2NiA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:57842 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j7Fqc-0004kL-5v; Thu, 27 Feb 2020 09:52:50 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j7FqZ-0003tI-2A; Thu, 27 Feb 2020 09:52:47 +0000
In-Reply-To: <20200227095159.GJ25745@shell.armlinux.org.uk>
References: <20200227095159.GJ25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>
Subject: [PATCH net-next 3/3] arm64: dts: configure Macchiatobin 10G PHY LED
 modes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j7FqZ-0003tI-2A@rmk-PC.armlinux.org.uk>
Date:   Thu, 27 Feb 2020 09:52:47 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Configure the Macchiatobin 10G PHY LED modes to correct their polarity.
We keep the existing LED behaviours, but switch their polarity to
reflect how they are connected. Tweak the LED modes as well to be:

left:  off          = no link
       solid green  = RJ45 link up (not SFP+ cage)
       flash green  = traffic
right: off          = no link
       solid green  = 10G
       solid yellow = 1G
       flash green  = 100M
       flash yellow = 10M

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts b/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts
index d06f5ab7ddab..87a3149a4261 100644
--- a/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts
+++ b/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts
@@ -21,12 +21,14 @@
 		compatible = "ethernet-phy-ieee802.3-c45";
 		reg = <0>;
 		sfp = <&sfp_eth0>;
+		marvell,led-mode = /bits/ 16 <0x0129 0x095d 0x0855>;
 	};
 
 	phy8: ethernet-phy@8 {
 		compatible = "ethernet-phy-ieee802.3-c45";
 		reg = <8>;
 		sfp = <&sfp_eth1>;
+		marvell,led-mode = /bits/ 16 <0x0129 0x095d 0x0855>;
 	};
 };
 
-- 
2.20.1

