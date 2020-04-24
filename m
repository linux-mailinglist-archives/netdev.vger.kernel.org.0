Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADEA1B75DD
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 14:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgDXMr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 08:47:26 -0400
Received: from mail-am6eur05on2079.outbound.protection.outlook.com ([40.107.22.79]:27744
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726667AbgDXMrW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 08:47:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JzrrAxliVzcCQM9j1YlstvTExxUqeNkOg6Zxyr3Clg0h4sLixulbuXoIIeyA65XscDXP4tX6dI6X7NhRGTdu55U6mMxVrJI6S0sb78VFlTKVWPi2k9g/ylCtB64If12yz8KgZ+9WU9mVtYnZoaLJeV2zvhVbSBNlZyWFsyZ3sbSaiXN1m7nALkokV9RFlYSzVmEaisqf1yIuRI3N0Oon4u0oUcFNVnJwhvUT2nw2cdaKuA3IZSy9qbee9F4h9htbvPuPjC98Bd2Z96NORD7QFKMLQU4sRVp2PKpfvTQhFUHix/lg0q7GBGWP0IqRml9lo5tP4X0QbvuU+VK3x0C18w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fb8OdOA/ttaMyjLjBfBZogkyJHGdHS2EL8IQcHACve0=;
 b=jgX8MpPTzAAOl4D9L52PjVT/FrkhQLZz7E/KaPIila6BvfrKZsF6NAGkjl+Zat42DyRk/llobGP0pqmlLZJC2m5yU9VHdJ2eUNNowd9knwgDHPK5LVEZO/m9yiuKmhF7QyA311P4bDUXl/kG9TC6EDh/785LjRvWU9nrx4MT1C4tRJ8xkiMlhAHliIknIsdJuduCQykTwoIXVb5XMeI8VMxwHGvz75mWuhfudgl7TXIYAw4pwSJKqOYj2rkKRdjegUEoJKho/AJ5K/VUnLfceh1JZm0S5besn1T8fAJoL2j+j9xeCY3GZge/EEmNxAVRNG1gMJit1t+1VlEI+b16sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fb8OdOA/ttaMyjLjBfBZogkyJHGdHS2EL8IQcHACve0=;
 b=nvaVJW+LD5ePTwNJ2nMeVCGgW3VBhQ7dtlKioEil/xi5xpdYYk6Jhf+mifI4DpDGyXsUbz4A2QJaEfd9QT/PPjjOyMIM3QUUSbl/d+URMzO4fZ3n5bfyU3PO3BKFQfW/VkpJCGNsTBkxNZt8go6KQb3y4/CyvVjRh1X3ILjNMek=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5937.eurprd04.prod.outlook.com (2603:10a6:208:119::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 12:46:55 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860%2]) with mapi id 15.20.2937.012; Fri, 24 Apr 2020
 12:46:55 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next v2 9/9] arm64: dts: add serdes and mdio description
Date:   Fri, 24 Apr 2020 15:46:31 +0300
Message-Id: <1587732391-3374-10-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
References: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0025.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::35) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0P190CA0025.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 12:46:52 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 17956fd8-33ba-4438-adf0-08d7e84d90e4
X-MS-TrafficTypeDiagnostic: AM0PR04MB5937:|AM0PR04MB5937:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5937927C0760BFBE286DDE38FBD00@AM0PR04MB5937.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(52116002)(2616005)(86362001)(44832011)(6486002)(2906002)(30864003)(8676002)(4326008)(66476007)(66946007)(6666004)(66556008)(8936002)(5660300002)(81156014)(6512007)(3450700001)(16526019)(956004)(186003)(6506007)(36756003)(316002)(26005)(7416002)(478600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NwWucsirjY+xnEsOm1kJ5ByeL+xnfNYWjj8R93ZgxRzNGjtrv72S1XMoF3ifgARueCVL7plEWhRs7LbRBTB4eT0sQSFexcSUKHRoo3dCDWAOTgxakYQcZphmBYx93zH586ZHbqyLX1N4MzQqtJxT5EAfn8Kk8B1edEj736shfi/5CKaflFB9FxdriPEcygemNQYVUi/q/qXGIPcTzfLSyuz8qs62JlBwavNFsT3RzQq/8gbj4+eGpsJ+Y6BIGqxKEJxzZP6du/qcuoGhrgHddNShSVoP5HXRtOqS6Li5S2x/rN7Ctbl71dKvCtauPj2CRuGcS4QNVQRn0w0dKa6wUUDqCMK6Gnp1j2d+f5Wzvht6FVdNHB97Bmdv7JpngoXNgw3dnxIHAIa18CKNsJw1uGZvV3WUuR6mjdgQdZkQugszaqFVP3xz4iAhnI80DN/t
X-MS-Exchange-AntiSpam-MessageData: l//TB0fWMVPQHA/6YedIgBynrmIPInC3kxzyAx/Vu1a2q/C2YDYvULCkOOE6O5Tlswc2EsayTgAbfK0yazvUWY4VXAWTEhpESPYOR6b0pODAbXXF5vdPzssqBIVJhghIHoFNknC4ZI/AQjLt5XA1EQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17956fd8-33ba-4438-adf0-08d7e84d90e4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 12:46:53.8505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SA4dX64aKmybN01omXh++OWmM0tA2q9ABqXT/G25VWLJufKy0uUE5HPSHPjP1VIvqTMbdRVfyqneBCcg7NbNNjpHxGXD4DBPf695aFlC26U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5937
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dt nodes with serdes, lanes, mdio generic description for supported
platforms: ls1046, ls1088, ls2088, lx2160. This is a prerequisite to
enable backplane on device tree for these platforms.

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi     |  33 ++++-
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi     |  97 ++++++++++++-
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi     | 160 ++++++++++++++++++++-
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi     | 128 ++++++++++++++++-
 .../boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi    |   5 +-
 .../boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi    |   5 +-
 6 files changed, 418 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
index d4c1da3..c7d845f 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
@@ -3,7 +3,7 @@
  * Device Tree Include file for Freescale Layerscape-1046A family SoC.
  *
  * Copyright 2016 Freescale Semiconductor, Inc.
- * Copyright 2018 NXP
+ * Copyright 2018, 2020 NXP
  *
  * Mingkai Hu <mingkai.hu@nxp.com>
  */
@@ -735,6 +735,37 @@
 			status = "disabled";
 		};
 
+		serdes1: serdes@1ea0000 {
+			compatible = "serdes-10g";
+			reg = <0x0 0x1ea0000 0 0x00002000>;
+			reg-names = "serdes", "serdes-10g";
+			big-endian;
+
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0x0 0x00 0x1ea0000 0x00002000>;
+			lane_a: lane@800 {
+				compatible = "lane-10g";
+				reg = <0x800 0x40>;
+				reg-names = "lane", "serdes-lane";
+			};
+			lane_b: lane@840 {
+				compatible = "lane-10g";
+				reg = <0x840 0x40>;
+				reg-names = "lane", "serdes-lane";
+			};
+			lane_c: lane@880 {
+				compatible = "lane-10g";
+				reg = <0x880 0x40>;
+				reg-names = "lane", "serdes-lane";
+			};
+			lane_d: lane@8c0 {
+				compatible = "lane-10g";
+				reg = <0x8c0 0x40>;
+				reg-names = "lane", "serdes-lane";
+			};
+		};
+
 		pcie_ep@3600000 {
 			compatible = "fsl,ls1046a-pcie-ep", "fsl,ls-pcie-ep";
 			reg = <0x00 0x03600000 0x0 0x00100000
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
index 36a7995..5a3ef5d 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
@@ -2,7 +2,7 @@
 /*
  * Device Tree Include file for NXP Layerscape-1088A family SoC.
  *
- * Copyright 2017 NXP
+ * Copyright 2017, 2020 NXP
  *
  * Harninder Rai <harninder.rai@nxp.com>
  *
@@ -325,6 +325,69 @@
 			#interrupt-cells = <2>;
 		};
 
+		/* WRIOP0: 0x8B8_0000, E-MDIO1: 0x1_6000 */
+		emdio1: mdio@8B96000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8B96000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;	/* force the driver in LE mode */
+
+			/* Not necessary on the QDS, but needed on the RDB */
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		/* WRIOP0: 0x8B8_0000, E-MDIO2: 0x1_7000 */
+		emdio2: mdio@8B97000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8B97000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;	/* force the driver in LE mode */
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		pcs_mdio1: mdio@0x8c07000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c07000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		pcs_mdio2: mdio@0x8c0b000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c0b000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		pcs_mdio3: mdio@0x8c0f000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c0f000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		pcs_mdio4: mdio@0x8c13000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c13000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
 		ifc: ifc@2240000 {
 			compatible = "fsl,ifc", "simple-bus";
 			reg = <0x0 0x2240000 0x0 0x20000>;
@@ -781,6 +844,38 @@
 				};
 			};
 		};
+
+		serdes1: serdes@1ea0000 {
+				compatible = "serdes-10g";
+				reg = <0x0 0x1ea0000 0 0x00002000>;
+				reg-names = "serdes", "serdes-10g";
+				little-endian;
+
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0x0 0x00 0x1ea0000 0x00002000>;
+				lane_a: lane@800 {
+					compatible = "lane-10g";
+					reg = <0x800 0x40>;
+					reg-names = "lane", "serdes-lane";
+				};
+				lane_b: lane@840 {
+					compatible = "lane-10g";
+					reg = <0x840 0x40>;
+					reg-names = "lane", "serdes-lane";
+				};
+				lane_c: lane@880 {
+					compatible = "lane-10g";
+					reg = <0x880 0x40>;
+					reg-names = "lane", "serdes-lane";
+				};
+				lane_d: lane@8c0 {
+					compatible = "lane-10g";
+					reg = <0x8c0 0x40>;
+					reg-names = "lane", "serdes-lane";
+				};
+		};
+
 	};
 
 	firmware {
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
index 3944ef1..99ae937 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
@@ -3,7 +3,7 @@
  * Device Tree Include file for Freescale Layerscape-2080A family SoC.
  *
  * Copyright 2016 Freescale Semiconductor, Inc.
- * Copyright 2017 NXP
+ * Copyright 2017, 2020 NXP
  *
  * Abhimanyu Saini <abhimanyu.saini@nxp.com>
  *
@@ -560,6 +560,113 @@
 			#interrupt-cells = <2>;
 		};
 
+		/* WRIOP0: 0x8B8_0000, E-MDIO1: 0x1_6000 */
+		emdio1: mdio@8B96000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8B96000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;	/* force the driver in LE mode */
+
+			/* Not necessary on the QDS, but needed on the RDB */
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		/* WRIOP0: 0x8B8_0000, E-MDIO2: 0x1_7000 */
+		emdio2: mdio@8B97000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8B97000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;	/* force the driver in LE mode */
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		pcs_mdio1: mdio@0x8c07000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c07000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		pcs_mdio2: mdio@0x8c0b000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c0b000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		pcs_mdio3: mdio@0x8c0f000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c0f000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		pcs_mdio4: mdio@0x8c13000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c13000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		pcs_mdio5: mdio@0x8c17000 {
+			status = "disabled";
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c17000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		pcs_mdio6: mdio@0x8c1b000 {
+			status = "disabled";
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c1b000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		pcs_mdio7: mdio@0x8c1f000 {
+			status = "disabled";
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c1f000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		pcs_mdio8: mdio@0x8c23000 {
+			status = "disabled";
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c23000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
 		i2c0: i2c@2000000 {
 			status = "disabled";
 			compatible = "fsl,vf610-i2c";
@@ -758,6 +865,57 @@
 			snps,incr-burst-type-adjustment = <1>, <4>, <8>, <16>;
 		};
 
+		serdes1: serdes@1ea0000 {
+				compatible = "serdes-10g";
+				reg = <0x0 0x1ea0000 0 0x00002000>;
+				reg-names = "serdes", "serdes-10g";
+				little-endian;
+
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0x0 0x00 0x1ea0000 0x00002000>;
+				lane_a: lane@800 {
+					compatible = "lane-10g";
+					reg = <0x800 0x40>;
+					reg-names = "lane", "serdes-lane";
+				};
+				lane_b: lane@840 {
+					compatible = "lane-10g";
+					reg = <0x840 0x40>;
+					reg-names = "lane", "serdes-lane";
+				};
+				lane_c: lane@880 {
+					compatible = "lane-10g";
+					reg = <0x880 0x40>;
+					reg-names = "lane", "serdes-lane";
+				};
+				lane_d: lane@8c0 {
+					compatible = "lane-10g";
+					reg = <0x8c0 0x40>;
+					reg-names = "lane", "serdes-lane";
+				};
+				lane_e: lane@900 {
+					compatible = "lane-10g";
+					reg = <0x900 0x40>;
+					reg-names = "lane", "serdes-lane";
+				};
+				lane_f: lane@940 {
+					compatible = "lane-10g";
+					reg = <0x940 0x40>;
+					reg-names = "lane", "serdes-lane";
+				};
+				lane_g: lane@980 {
+					compatible = "lane-10g";
+					reg = <0x980 0x40>;
+					reg-names = "lane", "serdes-lane";
+				};
+				lane_h: lane@9c0 {
+					compatible = "lane-10g";
+					reg = <0x9c0 0x40>;
+					reg-names = "lane", "serdes-lane";
+				};
+		};
+
 		ccn@4000000 {
 			compatible = "arm,ccn-504";
 			reg = <0x0 0x04000000 0x0 0x01000000>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index ae1b113..395fcf6 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -2,7 +2,7 @@
 //
 // Device Tree Include file for Layerscape-LX2160A family SoC.
 //
-// Copyright 2018 NXP
+// Copyright 2018, 2020 NXP
 
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
@@ -1115,9 +1115,9 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			little-endian;
-			status = "disabled";
 		};
 
+		/* WRIOP0: 0x8b8_0000, E-MDIO2: 0x1_7000 */
 		emdio2: mdio@8b97000 {
 			compatible = "fsl,fman-memac-mdio";
 			reg = <0x0 0x8b97000 0x0 0x1000>;
@@ -1125,7 +1125,129 @@
 			little-endian;
 			#address-cells = <1>;
 			#size-cells = <0>;
-			status = "disabled";
+		};
+
+		pcs_mdio1: mdio@0x8c07000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c07000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		pcs_mdio2: mdio@0x8c0b000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c0b000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		pcs_mdio3: mdio@0x8c0f000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c0f000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		pcs_mdio4: mdio@0x8c13000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c13000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		pcs_mdio5: mdio@0x8c17000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c17000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		pcs_mdio6: mdio@0x8c1b000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c1b000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		pcs_mdio7: mdio@0x8c1f000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c1f000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		pcs_mdio8: mdio@0x8c23000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c23000 0x0 0x1000>;
+			device_type = "mdio";
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		serdes1: serdes@1ea0000 {
+			compatible = "serdes-28g";
+			reg = <0x0 0x1ea0000 0 0x00002000>;
+			reg-names = "serdes", "serdes-28g";
+			little-endian;
+
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0x0 0x00 0x1ea0000 0x00002000>;
+			lane_a: lane@800 {
+				compatible = "lane-28g";
+				reg = <0x800 0x100>;
+				reg-names = "lane", "serdes-lane";
+			};
+			lane_b: lane@900 {
+				compatible = "lane-28g";
+				reg = <0x900 0x100>;
+				reg-names = "lane", "serdes-lane";
+			};
+			lane_c: lane@a00 {
+				compatible = "lane-28g";
+				reg = <0xa00 0x100>;
+				reg-names = "lane", "serdes-lane";
+			};
+			lane_d: lane@b00 {
+				compatible = "lane-28g";
+				reg = <0xb00 0x100>;
+				reg-names = "lane", "serdes-lane";
+			};
+			lane_e: lane@c00 {
+				compatible = "lane-28g";
+				reg = <0xc00 0x100>;
+				reg-names = "lane", "serdes-lane";
+			};
+			lane_f: lane@d00 {
+				compatible = "lane-28g";
+				reg = <0xd00 0x100>;
+				reg-names = "lane", "serdes-lane";
+			};
+			lane_g: lane@e00 {
+				compatible = "lane-28g";
+				reg = <0xe00 0x100>;
+				reg-names = "lane", "serdes-lane";
+			};
+			lane_h: lane@f00 {
+				compatible = "lane-28g";
+				reg = <0xf00 0x100>;
+				reg-names = "lane", "serdes-lane";
+			};
 		};
 
 		fsl_mc: fsl-mc@80c000000 {
diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi
index dbd2fc3..d6191f1 100644
--- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi
+++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi
@@ -3,6 +3,7 @@
  * QorIQ FMan v3 10g port #0 device tree
  *
  * Copyright 2012-2015 Freescale Semiconductor Inc.
+ * Copyright 2020 NXP
  *
  */
 
@@ -21,7 +22,7 @@ fman@1a00000 {
 		fsl,fman-10g-port;
 	};
 
-	ethernet@f0000 {
+	mac9: ethernet@f0000 {
 		cell-index = <0x8>;
 		compatible = "fsl,fman-memac";
 		reg = <0xf0000 0x1000>;
@@ -29,7 +30,7 @@ fman@1a00000 {
 		pcsphy-handle = <&pcsphy6>;
 	};
 
-	mdio@f1000 {
+	mdio9: mdio@f1000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi
index 6fc5d25..1f6f28f 100644
--- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi
+++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi
@@ -3,6 +3,7 @@
  * QorIQ FMan v3 10g port #1 device tree
  *
  * Copyright 2012-2015 Freescale Semiconductor Inc.
+ * Copyright 2020 NXP
  *
  */
 
@@ -21,7 +22,7 @@ fman@1a00000 {
 		fsl,fman-10g-port;
 	};
 
-	ethernet@f2000 {
+	mac10: ethernet@f2000 {
 		cell-index = <0x9>;
 		compatible = "fsl,fman-memac";
 		reg = <0xf2000 0x1000>;
@@ -29,7 +30,7 @@ fman@1a00000 {
 		pcsphy-handle = <&pcsphy7>;
 	};
 
-	mdio@f3000 {
+	mdio10: mdio@f3000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
-- 
1.9.1

