Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F4C188820
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 15:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgCQOxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 10:53:18 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40964 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgCQOxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 10:53:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PPvxJfz7fcMsqq7ucObIfV85gjZPQBTgrMZBZr7ovF4=; b=R5lO9zHklJzTmeXfqThKz6uqDz
        IfCgrFTcrE36gJOK7mzJ7ZAn7cfhh5RWNePIc/xK44PmEETriROAKeUjQH+1wCwG2a5wroudwW3qo
        0ZhiGJ/Mh48lIx4PrPX0Z+N2jaElfVRw9pLWj5JkGBEfaBBka0NVrK4cBezrxcNXJ0b99zn/6H5Lv
        f75HnNhPbfFsHPjgLx4SndSS6XU+5F/mUQDvdBmqy78Z0Yt16OCCv18F3BRIK3vIguorECenYWoCc
        /7aoUfGAMwJ1UVPxyVO9MoyBgKpNS3DXvh0UbNFW/xaXtJ8vYVAWfzG/suzt9TwvC4ofprth9DDPT
        GVxr/OYg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:44364 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jEDaU-0007iZ-Sc; Tue, 17 Mar 2020 14:52:59 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jEDaS-0008JO-Po; Tue, 17 Mar 2020 14:52:56 +0000
In-Reply-To: <20200317144944.GP25745@shell.armlinux.org.uk>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [RFC net-next 3/5] arm64: dts: lx2160a: add PCS MDIO nodes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jEDaS-0008JO-Po@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Mar 2020 14:52:56 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

*NOT FOR MERGING*

Add PCS MDIO nodes for the LX2160A, which will be used when the MAC
is in PHY mode and is using in-band negotiation.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 144 ++++++++++++++++++
 1 file changed, 144 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index e5ee5591e52b..732af33eec18 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -960,6 +960,132 @@
 			status = "disabled";
 		};
 
+		pcs_mdio1: mdio@8c07000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c07000 0x0 0x1000>;
+			little-endian;
+			status = "disabled";
+		};
+
+		pcs_mdio2: mdio@8c0b000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c0b000 0x0 0x1000>;
+			little-endian;
+			status = "disabled";
+		};
+
+		pcs_mdio3: mdio@8c0f000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c0f000 0x0 0x1000>;
+			little-endian;
+			status = "disabled";
+		};
+
+		pcs_mdio4: mdio@8c13000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c13000 0x0 0x1000>;
+			little-endian;
+			status = "disabled";
+		};
+
+		pcs_mdio5: mdio@8c17000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c17000 0x0 0x1000>;
+			little-endian;
+			status = "disabled";
+		};
+
+		pcs_mdio6: mdio@8c1b000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c1b000 0x0 0x1000>;
+			little-endian;
+			status = "disabled";
+		};
+
+		pcs_mdio7: mdio@8c1f000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c1f000 0x0 0x1000>;
+			little-endian;
+			status = "disabled";
+		};
+
+		pcs_mdio8: mdio@8c23000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c23000 0x0 0x1000>;
+			little-endian;
+			status = "disabled";
+		};
+
+		pcs_mdio9: mdio@8c27000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c27000 0x0 0x1000>;
+			little-endian;
+			status = "disabled";
+		};
+
+		pcs_mdio10: mdio@8c2b000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c2b000 0x0 0x1000>;
+			little-endian;
+			status = "disabled";
+		};
+
+		pcs_mdio11: mdio@8c2f000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c2f000 0x0 0x1000>;
+			little-endian;
+			status = "disabled";
+		};
+
+		pcs_mdio12: mdio@8c33000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c33000 0x0 0x1000>;
+			little-endian;
+			status = "disabled";
+		};
+
+		pcs_mdio13: mdio@8c37000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c37000 0x0 0x1000>;
+			little-endian;
+			status = "disabled";
+		};
+
+		pcs_mdio14: mdio@8c3b000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c3b000 0x0 0x1000>;
+			little-endian;
+			status = "disabled";
+		};
+
+		pcs_mdio15: mdio@8c3f000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c3f000 0x0 0x1000>;
+			little-endian;
+			status = "disabled";
+		};
+
+		pcs_mdio16: mdio@8c43000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c43000 0x0 0x1000>;
+			little-endian;
+			status = "disabled";
+		};
+
+		pcs_mdio17: mdio@8c47000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c47000 0x0 0x1000>;
+			little-endian;
+			status = "disabled";
+		};
+
+		pcs_mdio18: mdio@8c4b000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c4b000 0x0 0x1000>;
+			little-endian;
+			status = "disabled";
+		};
+
 		fsl_mc: fsl-mc@80c000000 {
 			compatible = "fsl,qoriq-mc";
 			reg = <0x00000008 0x0c000000 0 0x40>,
@@ -988,91 +1114,109 @@
 				dpmac1: dpmac@1 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x1>;
+					pcs-mdio = <&pcs_mdio1>;
 				};
 
 				dpmac2: dpmac@2 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x2>;
+					pcs-mdio = <&pcs_mdio2>;
 				};
 
 				dpmac3: dpmac@3 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x3>;
+					pcs-mdio = <&pcs_mdio3>;
 				};
 
 				dpmac4: dpmac@4 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x4>;
+					pcs-mdio = <&pcs_mdio4>;
 				};
 
 				dpmac5: dpmac@5 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x5>;
+					pcs-mdio = <&pcs_mdio5>;
 				};
 
 				dpmac6: dpmac@6 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x6>;
+					pcs-mdio = <&pcs_mdio6>;
 				};
 
 				dpmac7: dpmac@7 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x7>;
+					pcs-mdio = <&pcs_mdio7>;
 				};
 
 				dpmac8: dpmac@8 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x8>;
+					pcs-mdio = <&pcs_mdio8>;
 				};
 
 				dpmac9: dpmac@9 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x9>;
+					pcs-mdio = <&pcs_mdio9>;
 				};
 
 				dpmac10: dpmac@a {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0xa>;
+					pcs-mdio = <&pcs_mdio10>;
 				};
 
 				dpmac11: dpmac@b {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0xb>;
+					pcs-mdio = <&pcs_mdio11>;
 				};
 
 				dpmac12: dpmac@c {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0xc>;
+					pcs-mdio = <&pcs_mdio12>;
 				};
 
 				dpmac13: dpmac@d {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0xd>;
+					pcs-mdio = <&pcs_mdio13>;
 				};
 
 				dpmac14: dpmac@e {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0xe>;
+					pcs-mdio = <&pcs_mdio14>;
 				};
 
 				dpmac15: dpmac@f {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0xf>;
+					pcs-mdio = <&pcs_mdio15>;
 				};
 
 				dpmac16: dpmac@10 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x10>;
+					pcs-mdio = <&pcs_mdio16>;
 				};
 
 				dpmac17: dpmac@11 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x11>;
+					pcs-mdio = <&pcs_mdio17>;
 				};
 
 				dpmac18: dpmac@12 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x12>;
+					pcs-mdio = <&pcs_mdio18>;
 				};
 			};
 		};
-- 
2.20.1

