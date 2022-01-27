Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799B149E8CD
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244533AbiA0RVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:21:34 -0500
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:40513
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244500AbiA0RV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 12:21:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1I2pGFkCvm77KOKooVzhdpEqZ4+C4Ugd8wj7+8rdrBzfTjYW/QjpNcsTPwOQXW9H37ZpsCBPPn5fRcYyOspTETcpF6SP70koO4qOvC1X7AvO0TJ+mpOEXYnoBHKxRmmuMdN6gWHA1sIBEna/vkJA/EQzlcfL6phiL2LKXDbMtD6SxLQlS80wvMjeHAL1cMH1Xq6tGbIZkipLKr0IwJuaIHlJl6V+Wm4bhL0ZW9SHEj4W8tUphGgTm75Cc9qPhUn4DdImANVe7UmtUp//BH0WRfNHHK+z00X9kBoGcfKL2dmDmbYxoBdtJPLkES1vIjSqS10mlaAoNkKjG2NhUR+kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gTPqNIxX9YDHI0pNSJX9mQ8nJoxwj+zCU1B2nScMl9c=;
 b=TbiCSCOqD8oYFR5uPiODVeKz2z3P7HRom1BwfDCkGIuAmYY85H4rNQvaG1T3mRwviNFGiJ2873n3M2jBXH6MYMrrov4b/ywcJoRFi7y12desJLVtjeZ6uRql54oqOBHXrhyZ3vQz3/h4TrmTwURIUOGObH1JspnOR7Ffw1AkYKL6JkyTEMKIII8K1rkCOP6KZEzA6USF/5lpDfmfXxuOOYA3QMV/kO//88W8c41dlolg59nZXg+CYvT0bw4g1tUSneJTd6NSHz9Du8OcDoJR8zP0PBYQ0NTgqWvngltRRa/Ez/xDnPuc/aBpMQyeSql9X/OfKh38lMrOk/Cr7KfTTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gTPqNIxX9YDHI0pNSJX9mQ8nJoxwj+zCU1B2nScMl9c=;
 b=eCDWNH0PNTXXDzlK8dwDp0vtNyFCXdeFAyUKr1CO9bFzCvIi/N3QsxG8F6hFd5tZnVG8NUxpyhgNilfBuMSS68gT/rYw1Hji/F3Cp7CGVd0nnnRGLXIqeORLZMiqbRb7+QuIYhnodovHAscjb0pOt7AKFqgagnUri9GHr/cqvqc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB9017.eurprd04.prod.outlook.com (2603:10a6:10:2d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 27 Jan
 2022 17:21:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1%5]) with mapi id 15.20.4930.015; Thu, 27 Jan 2022
 17:21:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Shawn Guo <shawnguo@kernel.org>, Lee Jones <lee.jones@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/3] arm64: dts: ls1028a-qds: make the QIXIS CPLD use the simple-mfd-i2c.c driver
Date:   Thu, 27 Jan 2022 19:21:05 +0200
Message-Id: <20220127172105.4085950-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220127172105.4085950-1-vladimir.oltean@nxp.com>
References: <20220127172105.4085950-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0047.eurprd05.prod.outlook.com
 (2603:10a6:200:68::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51551422-bee0-41d9-5c96-08d9e1b972d3
X-MS-TrafficTypeDiagnostic: DU2PR04MB9017:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB9017279C1C5A9C0CE751493EE0219@DU2PR04MB9017.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z9vMnLYXQuV6tT4iBRSkqTriyu6BjYg7QVkt8TMqSxCIaJGYP7B6Smf/cxn+f/isNy8ikE886Y0MXziOzmT6DZSGl2OUCAJcXJ+2VMBxdcOlYUaph6LdRYv71hH9o/oknr2Eh+lFg4aPqPPfrZ5ShiBogcrhOEEv3Nf4EAlLLtnrDNsenBYeNItGF7bL2my/xZFNSrpqy+cjbEyVGKBaA6dsbclxUFBG4m3MQFNVlWW5c3RLJ7JyIL2OQUDjoZEhzQOAbZyPYTi6xglKTPKyCzqLR/ER0L9b0spNg0BCG+s/DQKZzPMvFTpNjlunrn2m21nAH86qQ16wHbcoXqV6XV4oMq7HhAes+Wm6c3M6ReLJ+Jg4fNnuKD6xOb34yJaOgzRkZTB2XW+hZrIehGUccZ+KAAVPxDUxy8KshXx++VxLDB2sILrCNMnLU/EwDJJzM9NosmMe/wplDZ2ymQKHGKSj1lwKw2gNaws2mEhkraBUo3ajczFNLGk6hg6xjepsNGWiKMNBw55g21UYRgfL2/vwsUPu4BkOwhZ3XEPKOeVskqdneOltnbkJ9hmRyLDVqTgQScKnRw+ZahD4c1s9mFaV/RpqgkuBDG/n0xrCWKJtBA9IuGMJDiObU5RRLv8xQLISwBA17ueeI5S5BVxQVPIGmwSeFIZwpeipeZzPoXbvJLQJvHXUd5tqk9kwCTBvhlBLl5TgSb0g+8FEQvoUH+nZlgDcVyl7ohV/7xhx9wWkfo8q9uUmxhV/4eGBdEvMBIXK8Xdb4f+ANTAN7fv7l4GFNe6bhKc6gC3waG+W9pg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(38100700002)(83380400001)(6512007)(38350700002)(52116002)(186003)(66556008)(66946007)(1076003)(2616005)(6666004)(6506007)(26005)(66476007)(966005)(54906003)(44832011)(7416002)(4326008)(8936002)(5660300002)(8676002)(316002)(6486002)(110136005)(36756003)(508600001)(86362001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o5RhQtfCA6xZI05QztNtIaIMe1UNzzdI2hsikfWg5ycMKs3LE0OEBPb3h7/1?=
 =?us-ascii?Q?shJU400uWndeXEZq01ATLE2HMNvwguVd9cl6RMIIU9Kqr/m2HxLzKdil0nIX?=
 =?us-ascii?Q?9Dr4opXmq3NivNfAeXBtsNA19BvkBAA7UJ1K9tDsp5fKp1H9mrIq1LQg12JW?=
 =?us-ascii?Q?65HwIncJbxAQiAJT2rFRKkZRTSgbQc4uaw7XVz+P+YZWAMaBrkPvP6GBzCl3?=
 =?us-ascii?Q?wvZAgsdVdmTI/0KCWKR8av2Q1wPF1UW8qBHAZC47nwUQW/miSzAFeVPZZHyZ?=
 =?us-ascii?Q?n/VKhAZlElXUgEKxzletFDwMa4mJzq0ajXHpEOimilR9TlWnlHve5Lnso71Z?=
 =?us-ascii?Q?EtND7Fqd80/zfc5tk+1uyGnDkxOWtFSf4sfHjh+aB54m0Lj6R+psZqYC0ECx?=
 =?us-ascii?Q?ORL/5gPMnfU7IP3BL9UFUbUImcqzpgRoxYoTHGB2/3+6LDSnyh7imgGS/9IV?=
 =?us-ascii?Q?ef5Qo1nCUBADoPClrWWY3eF4r0rJFYKRJR2tDGB3PQVZQzM6xl9DcR4rYhWY?=
 =?us-ascii?Q?DqrdXE/+fWiSp9dmhXY3MBidVmt9Z9ytIQUGLCs+fvfX0vt+4R/pYGtMSdAa?=
 =?us-ascii?Q?TjXr6aeOofFxluLqNnP5vS1v9b82x2flzY1UKjMC/L6fulnH+8QOrRyajbAQ?=
 =?us-ascii?Q?6Qfid0qpvs25JtcKijuHOu+5d5cz1c/1CmetHuZes1sRSr0bZkN4VW+tVz4m?=
 =?us-ascii?Q?EvK1DQUwDqRoY967Q7V44XegZnHa5F8mNQLz3eGSo3TrIbnoc+jFrTkyryYS?=
 =?us-ascii?Q?E/8vJr8sGLu9M29GVJzjBQ2pp/YTgTGi5oBmnrfnIijXTSoxeqUA9phl8Mx+?=
 =?us-ascii?Q?3ct9QAB9e4UmJCyV8X8Ao7QX9cjmv2T9g9qzH0QMNo6y1htESCj6bTKI6UbS?=
 =?us-ascii?Q?vUjM5BmQ68n9fAUM8MrZMU4nJQbIyj1z6s7FMuO5tTbPsjHJHShvi38S0Ig1?=
 =?us-ascii?Q?vEnDn+OoypATou96EbPWvUjT8bYwCpmXkTBd9uGtHTdY7r9t4DEpH06oFuhI?=
 =?us-ascii?Q?hI+WGJGLYYFxXuAj7JCpmz9kQdGXcKb09J41hUsw9G9gPCpOcD+MpeMued3G?=
 =?us-ascii?Q?rJgotYf5/WCD7vmAooZw2w4uKWHxYD3wJlxg4KSrkWhFQUx1XwHW7LEmnato?=
 =?us-ascii?Q?NXhwx4LacRzjQrfUp33iM108/tNfeCktkHy+TdCKfBiXJYdiUZt1NmtK+m35?=
 =?us-ascii?Q?vqIZ6HyyEybJYQmN0RJ59+m5i7VMMUo1PYuu3bbEnl7YeDIttFw/xGo1GVIk?=
 =?us-ascii?Q?k01G/Ype3OS2ilhFIGUkT3EEGLq0COQRp7Sf9NC7nPmpAeZ6dM49166eVyTn?=
 =?us-ascii?Q?UBhhhvdy9SSwlGyW6T0d22MON6XEcIIz8/K7Ah+CzIUJ8WuUDZh12U+KMX4C?=
 =?us-ascii?Q?k1zQSGOJg5IV5Tt35YCO3v8lL8Nb0jWhsAcrdRivpZNGPzfyowJhZPrN81tv?=
 =?us-ascii?Q?0HywPKBt0rcET9CSrVr0VKJ/c7rOflk+UhDKpgOmYfycRpIAb4vUYR6oUaH5?=
 =?us-ascii?Q?VhmwSomDTXOTxXFysG/QYvOY0z3BAcal0hk0ZMbTu7y33D1mdEW7cLNEXK1Q?=
 =?us-ascii?Q?TUGQGwWOwoxgk2AoeyuhSrR/kAOtMkn1623q/a1Mn5Cfy2jixg5SqVq8XCBV?=
 =?us-ascii?Q?IITNGxuhNIEl08WdQJ1y1h8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51551422-bee0-41d9-5c96-08d9e1b972d3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 17:21:26.3008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XxgW+nfGGSPG99jjzoEVtbRcXZ3d4DsKs0giV1UswEVtkUxZd9ibRFQVQ1ysQKlE9JkcN7GIfi79xdwrrhbImA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9017
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MDIO mux on the LS1028A-QDS never worked in mainline. The device
tree was submitted as-is, and there is a downstream driver for the QIXIS
FPGA:
https://source.codeaurora.org/external/qoriq/qoriq-components/linux/tree/drivers/soc/fsl/qixis_ctrl.c?h=lf-5.10.72-2.2.0

That driver is very similar to the already existing drivers/mfd/simple-mfd-i2c.c,
and the hardware works with the simple-mfd-i2c driver, so there isn't
any reason to upstream the other one.

This change adapts the compatible string and child node format of the
FPGA node, so that the simple-mfd-i2c driver accepts it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
index 177bc1405f0f..6bd58fd9c90f 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
@@ -314,17 +314,18 @@ sgtl5000: audio-codec@a {
 	};
 
 	fpga@66 {
-		compatible = "fsl,ls1028aqds-fpga", "fsl,fpga-qixis-i2c",
-			     "simple-mfd";
+		compatible = "fsl,ls1028a-qds-qixis-i2c";
 		reg = <0x66>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 
-		mux: mux-controller {
+		mux: mux-controller@54 {
 			compatible = "reg-mux";
+			reg = <0x54>;
 			#mux-control-cells = <1>;
 			mux-reg-masks = <0x54 0xf0>; /* 0: reg 0x54, bits 7:4 */
 		};
 	};
-
 };
 
 &i2c1 {
-- 
2.25.1

