Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45894194082
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 14:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgCZNww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 09:52:52 -0400
Received: from mail-eopbgr60089.outbound.protection.outlook.com ([40.107.6.89]:57111
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727771AbgCZNwu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 09:52:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJeoLCAtvg9CrywoqFxc/bZ++DC/xFVfHyBziN68WDK1PU+ZkwtOS/zXLoWyx/Lmyx3veqPjTnzMt6XlRRO+fZ0kpSmvfMsKHndO4hNzg79YMlXwlfuhXsy8V+3Vgkt2kcbgBavCS7r/hstB/ap77lQnNnsxNxfDn0CLGhGkX39rfO2DSrHbVjtVPK6sTkfRsiZ3kOXAz1CDo90c8j5UA2cvySODAE23S3iV2uk4ePx4ydTJGmXGqhpSTlgv9GfhVqatGx4hnhE9bCxVAQgBdJNKHR5KvC16trOZBiWjJFjofMgBPA2DcF5+5jhG08EEy3SIHHxEx9SPiVd8YCslnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vzia31wwMREO0iGK9LHLrdOHEkjh6lJ8Fm6evrVJtS8=;
 b=noEaGr12CXK1FObbrbVZg3UAbCDgTlUXhpfLmgWWPE27clYBNx1GLBNBnCNSQuzfQLEjuavEEU7daer9DTJMCFRQqSfRkZgd2FH/fX+YV2ZDQVnSmlXqvhOt56BmX3fysNxx6Frr+ZeEoYpGJzqrQJrzij2OwBapd4MPLIJb4ZhzSf4x00P1QumSfanNi3Yeb+mNNhF9VG9w002Wy0RQeA8+5tl8vy5ibccVLptPkniDs9hlG1hECF+f45MGK4JtNuXsbQn7eml6Z0Py/6bGRcvUXh1mGyn+bs8RQMAH5QGdF+HTky/4Q7IlQnGtvLuyp0uePqstZJMoRzY0reRyzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vzia31wwMREO0iGK9LHLrdOHEkjh6lJ8Fm6evrVJtS8=;
 b=I1G+to0ShLSWnEOh7l1O1XM18VBK9nuKmaqHx68xG+E0Gf1Ly5sB4J1cSuy+zHfboQQzBP1DYWYJBA+WFSH9oGvAwIeO7x6RGdn0U/kAW74+5nJjYHby1NT4d5UmvmfZHbIi7s5yJHn6ThUWKTLrgMNstfhQLMCgMAS/r3MbSlc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com (20.178.122.87) by
 VI1PR04MB4272.eurprd04.prod.outlook.com (10.171.182.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Thu, 26 Mar 2020 13:52:22 +0000
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8]) by VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8%3]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 13:52:22 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next 9/9] arm64: dts: add serdes and mdio description
Date:   Thu, 26 Mar 2020 15:51:22 +0200
Message-Id: <1585230682-24417-10-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0142.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::47) To VI1PR04MB5454.eurprd04.prod.outlook.com
 (2603:10a6:803:d1::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (89.37.124.34) by AM0PR01CA0142.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2835.20 via Frontend Transport; Thu, 26 Mar 2020 13:52:21 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [89.37.124.34]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 83692443-297e-4d08-8a06-08d7d18ce8a2
X-MS-TrafficTypeDiagnostic: VI1PR04MB4272:|VI1PR04MB4272:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB42724ABF53163F381AFCB99AFBCF0@VI1PR04MB4272.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(26005)(478600001)(186003)(16526019)(956004)(81166006)(3450700001)(36756003)(81156014)(8936002)(44832011)(4326008)(8676002)(5660300002)(2616005)(7416002)(2906002)(66946007)(86362001)(6486002)(30864003)(66556008)(316002)(6506007)(6512007)(66476007)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4272;H:VI1PR04MB5454.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OsqFsruZBZcNKffM0YujYqCLmvVWIcuxgQB1zyZhNWv35AMeNtlc3ta3vOZ9NVDVfeqMyfRN/jWGWxcMs0BORDzx7++ImXVzwGfA3sGrcka7HXAj1Co7LTTMDK4tpcyfXzRCIPMTIPLjBrnrAN9bZLcye29bl9lnzhJo3+wm9BqZhnEqWqN7Z+k+U7yulGSjF6qhMSsOXfDgz1WLUPGCtkdSYvMfp5VNbY4SSX8oBW+EVsINwnOop//rwA/dCadKW2MPHKk/8pWADS/lRDL169GqWU1nNw6W7P4oMextRx7qzyW3YZXA++3QtocfdPpzceFFngGJWKaRFbfa5UL65InEIgVLqrTp873nuQQdogAFm0SuZ+V5fbC5CsRDzQFleQusrk1pjmebIjKqnf70T5sflGFXybZ9GGbvp6yJCpNFgVBEopLVCP0YYEEEsmyT
X-MS-Exchange-AntiSpam-MessageData: YaAeoHgwUxYIQVltskfX3MScf2t8OlC8vAQaPurrj54bWhibPhu3dICDWWiI9hrd3D3W7FPFejC/GMnr7IMWXklWEWiqiVIb60etHkw8IbDAnljnxJLQ38I5HyHa3eB1p62q9JQpmMNmURG1Fn7T2A==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83692443-297e-4d08-8a06-08d7d18ce8a2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 13:52:22.6496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cwYY28niTqwbFfoa2MB5tBrQlqj4udESkIPlrdLWrSyQApi5JliQPNNobk3g2NWPo/2+3BAHvQGZuvauynZzls2xoK53xx7gk3MjTRZ+QJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4272
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
index 5945662..474464e 100644
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
@@ -777,6 +840,38 @@
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
index f96d06d..e8f3026 100644
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
@@ -754,6 +861,57 @@
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
index e5ee559..2815908 100644
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
@@ -947,9 +947,9 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			little-endian;
-			status = "disabled";
 		};
 
+		/* WRIOP0: 0x8b8_0000, E-MDIO2: 0x1_7000 */
 		emdio2: mdio@8b97000 {
 			compatible = "fsl,fman-memac-mdio";
 			reg = <0x0 0x8b97000 0x0 0x1000>;
@@ -957,7 +957,129 @@
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

