Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58DB20383A
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729226AbgFVNgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:36:45 -0400
Received: from mail-db8eur05on2051.outbound.protection.outlook.com ([40.107.20.51]:36110
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729158AbgFVNgh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:36:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVo37QscCTOvWF+F8WyZIoL9xljLDVuQHZjabLBcnWmjNGwQqyiNQIDYtZHWnr4MPCImfGzXsZhmMu4qFV5aOBWiROwXC/jOhTp0GasCs4dHWOQ3fl+/z72osekYc3F9FMjMzvzFLemf7E+vUi/2ob5qyApy1asLMDKQqfNNfiDjicFqDbgdP3qx5pEoAsUXD205tCP2wYnEhnafIKHKhBbiqFQv/rfgndP/TH0bsjkVJCtZ8XrhbBdYbU9fmbJDhVrLwIi/mF865lJn6XMgpiqlylPIrAVC750idsiUMcSFm1jQXlxSkoHPF2oEhOQxOoV/5/yJI67YIgQRckB9qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKDxXahmHd8WA0gzvjyKltxkC7me2NihuwXiLDSDprc=;
 b=mpJxE30W/Ibb6/+JUT6DqUuI5kLK/vbo6CcIilkUmrXzokscw9tfoUdWjfPIpNKSM2u0YFUtWaq1U4uWKe1pMkupV52Iwnke4tqODCpKBzv5i2eI9ML6mXzRMgGmgNSZ+VeMBxl5ZKTwvP+PthEuifZ08FqJkAIpwv96+gdjtugdAUzistGDC/FFic2PI5FAEvSm4CNAGwBi4t0mzbX8FWZgYk02IO3kYG7WnGKm1V84MW3kdO8gm/1cZ+i2BInYIKqM8MBb/CU91SqQKMtI9K9TwbiIgI8pxEl9CJ6ki0kWAJZ6VmStqMzVW3C6j0uZthv3JL+GZWBp9lqw6F1gQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKDxXahmHd8WA0gzvjyKltxkC7me2NihuwXiLDSDprc=;
 b=sm2LpHtVu9Xz/1qrmei8UuCHLHO5RjZug4iFOLb/JYmr3b5r98rhBDsnO0xN076DJyxeXjIXNxYAm8NSE7ABQ5XHkxWCV2tKlKDVlW4M/bci9nbAc32ticg40S+o2E6wDF/RiHbZuLEgJWKn4AY05nzPzvkZRsrLsP/XB+b1q5k=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5075.eurprd04.prod.outlook.com (2603:10a6:208:bf::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 13:35:59 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 13:35:59 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next v3 7/7] arm64: dts: add serdes and mdio description
Date:   Mon, 22 Jun 2020 16:35:24 +0300
Message-Id: <1592832924-31733-8-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
References: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0086.eurprd07.prod.outlook.com
 (2603:10a6:207:6::20) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM3PR07CA0086.eurprd07.prod.outlook.com (2603:10a6:207:6::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3131.12 via Frontend Transport; Mon, 22 Jun 2020 13:35:58 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fb135e35-9328-4138-1634-08d816b13323
X-MS-TrafficTypeDiagnostic: AM0PR04MB5075:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5075F29E1FA8C89989701EC8FB970@AM0PR04MB5075.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6uRXHoynWBMBfpFGU8T/GHZt3SfBQWEya9B8JgIVTKepxB8WruWfkv62TOJ6uh0cGkL4eMbbFT+gKG4uKzajDAZ9hvYRlyFS6jFbZFui9GCgYESHKcVff/zD1WV3EuGcrEXwTPpIze2QAshjR+WcKn5S80McYhgB/PI5tXN/uPioluTn+BteylLM1CewRWAkbSjdK766wsHHfIBZFN2TyGCt3sfEiLAYfRTXFibEUiIouwzCxrQqfHWueSxElOdtsq6OUmQIOW1Ppn40OYPO+O9c3auKJgMfb7DV6v0Q8mJSeTVf2b6metdsvloM6KKgBBzM1DEo48YhaB92FuLp1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(66476007)(66556008)(66946007)(83380400001)(5660300002)(2616005)(956004)(44832011)(86362001)(6666004)(2906002)(8676002)(6512007)(52116002)(16526019)(186003)(26005)(3450700001)(6506007)(4326008)(6486002)(316002)(478600001)(8936002)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /i290F4x2zvapUVJdMk9tysCL2+UrzHcKaysZpvhjzXaC75gEKbEXs1DLv6vgS8VNMtPJ/5INrbNAGh6MGBmfPvcaoacsJeGKEvI6up2eDPwBcLURmlM+mvtOx2PLfDlHDfg2jjkM7F+0s87xNF1F8q2VXWKdeI6GSXw9NaUsLGTMqQXVSxzHbrhYwmVBvxHK/HvWAZSN4bR1PoQvL4sb+HkCeVljY0rloPiindV7o28sjulbaTdWR4N5WBNrDPj9Wc6KN6QbLO7En133v3gNWAqx+V42SySZtaBY6KGhHBsBcNClXOcWG8DMEZd6m5CfIQtLqWdY4d0kaznR9N0pUduwj3WpKqEW6lbPBhtc3x+EslhHgFGKzDTYHlMxUGiclZ/wjncUwVcWBLJlm3zIbBTu9f9Pyq1+RFPpcD6L9LzBhRUu+ntFod4kAkeUmmb4GMxXQcMx3ShsEe3VX5aHwrX1sFKAXcjmbHi/oe0Qyc=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb135e35-9328-4138-1634-08d816b13323
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 13:35:59.7574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 84dh5N35B/WbdW+MsfkBFPD9tIYuf57M3I4rWw+g2ufwQ+onqnUoE/JD//qG6BG4sLBc/b/gn6j1M0oFP/rBsAc+HxlbA/B1ohY/y+QHBRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5075
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dt nodes with serdes, lanes, mdio generic description for supported
platform: ls1046. This is a prerequisite to enable backplane on device
tree for these platforms.

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi     | 33 +++++++++++++++++++++-
 .../boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi    |  5 ++--
 .../boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi    |  5 ++--
 3 files changed, 38 insertions(+), 5 deletions(-)

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

