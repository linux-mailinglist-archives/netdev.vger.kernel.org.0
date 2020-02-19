Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC82164801
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 16:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgBSPNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 10:13:22 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52316 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgBSPNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 10:13:12 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so1052834wmc.2;
        Wed, 19 Feb 2020 07:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/HfI8ls9yaExpXAUSxM0oRJsckXKm48g+Cf7wozzGRc=;
        b=kFojPlc1lR2eZ78XBFtHMTM7MhQwstbJTaN+47JsxYcY9KP5m2smvaMRt/DCHrJ4Dv
         Kg6/fRzwRAhjOKJEHFINmPQ1gkK240SAjPfT1Q97PNo1P0xFer8s6V+uDTU+3UgIArRI
         CclDLQzJw35rw870LKMs1IfBdmYxZ5eJCnm7E0bbxV8CHivEK1y563uHtvv1Qq1KlDfS
         ZtuBsHPs1sZhhodyuP2ROqKM3kZdXekcmiwPzm3BgARbdM980MCmMMxcI9ikh8Rnx4r3
         eBFugiclx+QVigLBSetaC6X5SXUpkEzyKJHvOzgSYO7I91N5EckmKjB3xPh6QeYBOr1E
         GM6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/HfI8ls9yaExpXAUSxM0oRJsckXKm48g+Cf7wozzGRc=;
        b=QsOKBBuiS/9Xh+xW5ZT7/4ms1LhDo7SV9dtesep22rMzBz+B400IUA3T7jC2WJSkTv
         s7V4mGRmTnuKR9jiHaKSBPD08fJIvUsxZbqvFQ6FJPwlG+yXIM3AmTOFQGHdkUeqAtZB
         lqMAYRy11cJeEly7uOypYmazyspl/73QGog6uxSEppf1RtKh8PS2jfQxSS9Ho3Y2wm+h
         7xMXVhFgt5MVKEJBpkynGer6Rg6btHYLeOqWH8pUKR6e6liGDBIZltP/fcbEpkyYzOCp
         uE9WbyjQ9GZ04Z4i9pxACyPxyTU7O96xfvfYJNCTkmgzIkdqdRrQDZftmAFjE0Jk/Dkv
         ju5Q==
X-Gm-Message-State: APjAAAXEBBsPkV1Cu8yntfmCI5oBI0Qg/fv7Okm8XjIkNEPbK2EiTPVR
        q37H6VVi+FFpyPzQlUHBjUo=
X-Google-Smtp-Source: APXvYqwEZ/nr6SECyFGGiqfJa98XhttqT07fPfQ2RGMYufabWUzBDQXYgbPPqcFqEZx2tWC1O5kTsg==
X-Received: by 2002:a1c:c209:: with SMTP id s9mr9761094wmf.156.1582125190248;
        Wed, 19 Feb 2020 07:13:10 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id b13sm83137wrq.48.2020.02.19.07.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 07:13:09 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next/devicetree 4/5] arm64: dts: fsl: ls1028a: add node for Felix switch
Date:   Wed, 19 Feb 2020 17:12:58 +0200
Message-Id: <20200219151259.14273-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200219151259.14273-1-olteanv@gmail.com>
References: <20200219151259.14273-1-olteanv@gmail.com>
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
Changes in v2:
Adapted phy-mode = "gmii" to phy-mode = "internal".

 .../arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 84 ++++++++++++++++++-
 1 file changed, 83 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index dfead691e509..a6b9c6d1eb5e 100644
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
+						phy-mode = "internal";
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
+						phy-mode = "internal";
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

