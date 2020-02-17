Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA5431614F8
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgBQOog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:44:36 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38863 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729225AbgBQOoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:44:25 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so20033930wrh.5;
        Mon, 17 Feb 2020 06:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=55+jCXznSnaNtoOYtenPXvWWJxRFxBzn8oIQT/+pmKQ=;
        b=IEO1x6jIiL5fv7pymUIo4YGVdelU2DfRSwlQhP89GEelxNSLcdR74/qJsvxAm2wyfv
         U1gveH+SC53Dztmyi/jxF9jntbHRiIvhjsM40XcxkmBhqf8InYOANGnnihHG8Jin96ZQ
         OfEds4XNuLIPl8Mnwr8pHpwmBP72bv+AES7fnqW8sZN/aIsfTDReB9lEt31E3b8xgn5s
         el55Y4AVika6FyhVCmT7MugDyhzTZK3ansJBX0KiRiOeBaUezaaDXJzqS2wFg5oJQiN6
         zuRC63oF0Oz/JUNoAqjMGdUcVDSq3btfxGAiZfP0VUlxOHDweWedZQIeckjbajprwit7
         pKiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=55+jCXznSnaNtoOYtenPXvWWJxRFxBzn8oIQT/+pmKQ=;
        b=kHkHY6FpNX1Wr8PpFOAEXBZUrVQGO44OTnmcGfPzTMvTC2DfRgddC1yGv4q4g7YXo5
         ZJnwf/GisoN3hew9oDPdJff7tVpGjo+GtTwkBfqfZD03cXyiH43E58N0cExW+aKesnsm
         aBHW/rw1jbyqf7rSyahhh8AK7NcytNDJUPebQc9qMcT9JskbhvPFUZSdE6TqD2EnCMp0
         EGhG3y2+fyhZzXE5YG+FR7Dh0nUPPm81zGfcCruwOQhgWHrgUGGMkarHZIDRGKUUamWA
         lTFIuqF4p1BtZvXy9kFCUj2A8xQ1AOMbOD8IWbQhTxGvJ6VFJW6jT2fWsyAyZO1MpWy/
         Hcbw==
X-Gm-Message-State: APjAAAV4rDlynhq8t7QId68ln64ei5LotnJHgu3IQ849YtnIm5qPV3Xn
        1BG2EsyzOMNUyA2dT/ZTEt8=
X-Google-Smtp-Source: APXvYqwNxJjGLPHfkM688cUQdzQj8jnGRaiYrgbsPYUypp7cIPEleaSWWMRQzVsbO/f4pne2mrw4gw==
X-Received: by 2002:adf:f707:: with SMTP id r7mr21879579wrp.194.1581950663245;
        Mon, 17 Feb 2020 06:44:23 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id j5sm1381699wrb.33.2020.02.17.06.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 06:44:22 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH devicetree 3/4] arm64: dts: fsl: ls1028a: add node for Felix switch
Date:   Mon, 17 Feb 2020 16:44:13 +0200
Message-Id: <20200217144414.409-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200217144414.409-1-olteanv@gmail.com>
References: <20200217144414.409-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

Add the switch device node, available on PF5, so that the switch port
sub-nodes (net devices) can be linked to corresponding board specific
phy nodes (external ports) or have their link mode defined (internal
ports).

The switch device features 6 ports, 4 with external links and 2
internally facing to the LS1028A SoC and connected via fixed links to 2
internal ENETC Ethernet controller ports.

Add the corresponding ENETC host port device nodes, mapped to PF2 and
PF6 PCIe functions. Since the switch only supports tagging on one CPU
port, only one port pair (swp4, eno2) is enabled by default and the
other, lower speed, port pair is disabled to prevent the PCI core from
probing them. If enabled, swp5 will be a fixed-link slave port.

DSA tagging can also be moved from the swp4-eno2 2.5G port pair to the
1G swp5-eno3 pair by changing the ethernet = <&enetc_port2> phandle to
<&enetc_port3> and moving it under port5, but in that case enetc_port2
should not be disabled, because it is the hardware owner of the Felix
PCS and disabling its memory would result in access faults in the Felix
DSA driver.

All ports are disabled by default, except one CPU port.

The switch's INTB interrupt line signals:
- PTP timestamp ready in timestamp FIFO
- TSN Frame Preemption

And don't forget to enable the 4MB BAR4 in the root complex ECAM space,
where the switch registers are mapped.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 84 ++++++++++++++++++-
 1 file changed, 83 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index dfead691e509..b35679dbcaa7 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -700,7 +700,9 @@
 				  /* PF1: VF0-1 BAR0 - non-prefetchable memory */
 				  0x82000000 0x0 0x00000000  0x1 0xf8210000  0x0 0x020000
 				  /* PF1: VF0-1 BAR2 - prefetchable memory */
-				  0xc2000000 0x0 0x00000000  0x1 0xf8230000  0x0 0x020000>;
+				  0xc2000000 0x0 0x00000000  0x1 0xf8230000  0x0 0x020000
+				  /* BAR4 (PF5) - non-prefetchable memory */
+				  0x82000000 0x0 0x00000000  0x1 0xfc000000  0x0 0x400000>;
 
 			enetc_port0: ethernet@0,0 {
 				compatible = "fsl,enetc";
@@ -710,6 +712,18 @@
 				compatible = "fsl,enetc";
 				reg = <0x000100 0 0 0 0>;
 			};
+
+			enetc_port2: ethernet@0,2 {
+				compatible = "fsl,enetc";
+				reg = <0x000200 0 0 0 0>;
+				phy-mode = "gmii";
+
+				fixed-link {
+					speed = <1000>;
+					full-duplex;
+				};
+			};
+
 			enetc_mdio_pf3: mdio@0,3 {
 				compatible = "fsl,enetc-mdio";
 				reg = <0x000300 0 0 0 0>;
@@ -722,6 +736,74 @@
 				clocks = <&clockgen 4 0>;
 				little-endian;
 			};
+
+			ethernet-switch@0,5 {
+				reg = <0x000500 0 0 0 0>;
+				/* IEP INT_B */
+				interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>;
+
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					/* external ports */
+					mscc_felix_port0: port@0 {
+						reg = <0>;
+						status = "disabled";
+					};
+
+					mscc_felix_port1: port@1 {
+						reg = <1>;
+						status = "disabled";
+					};
+
+					mscc_felix_port2: port@2 {
+						reg = <2>;
+						status = "disabled";
+					};
+
+					mscc_felix_port3: port@3 {
+						reg = <3>;
+						status = "disabled";
+					};
+
+					/* Internal port with DSA tagging */
+					mscc_felix_port4: port@4 {
+						reg = <4>;
+						phy-mode = "gmii";
+						ethernet = <&enetc_port2>;
+
+						fixed-link {
+							speed = <2500>;
+							full-duplex;
+						};
+					};
+
+					/* Internal port without DSA tagging */
+					mscc_felix_port5: port@5 {
+						reg = <5>;
+						phy-mode = "gmii";
+						status = "disabled";
+
+						fixed-link {
+							speed = <1000>;
+							full-duplex;
+						};
+					};
+				};
+			};
+
+			enetc_port3: ethernet@0,6 {
+				compatible = "fsl,enetc";
+				reg = <0x000600 0 0 0 0>;
+				status = "disabled";
+				phy-mode = "gmii";
+
+				fixed-link {
+					speed = <1000>;
+					full-duplex;
+				};
+			};
 		};
 	};
 
-- 
2.17.1

