Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804295769A6
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbiGOWHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbiGOWG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:06:26 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10040.outbound.protection.outlook.com [40.107.1.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304CE8FD68;
        Fri, 15 Jul 2022 15:02:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIi7gqC7F3KM0dRR8LsqKJUuzP8mhXv00czkvVHawCBpgDNbsj4k3sqE7fv1WzGYvaDKYIeSuPysovA0KdBFRCSg0PpxQfroOL4CYqRhwr7GemxoqULZfeBlNM4EkxWLYcddiA7xIv/4iuH9/hiIEI3J0BXfpaQXcACy7/0TYlHMYJx+p9vcOxny45fzH2SIS0uFgek/pbIGTH2u+eH5XrBmjKJhivKWD0F6mxi34NrqwvmMvtSMkekkhRS1k38mujbkchJm7g+1S9KGxI9xMBHNKF1vrdr+bj9gtbrmTLuNK2QaOLQV0wwOKeZ6eTrv3D0Tl/H40329VG3nRomiyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ggxjBqUodEZrSQgczGpk+1ARLDmIKnK96MUj+WVBXf4=;
 b=hHRPGFB1HSUlLxU9jwCewYk9EW6gT411GMc9bKHWVasi+19Dqg/k2Ux54WKklY3MKKAhSoP3SzF4LEmwDldR+6HxmXPh8xviTpzKFw1JoliPKDaYnCfbcQobxCoualyrZgdAK198ghoAZOmXjihqFoOoZ/yaMRg9Nvkp7Nt6SFKVIXhGgLELdUu+74eVLgQhPuHmtxWeVNtQJsEj45cUuoDQAkrz494gsk3jEE9qa0QrLTp7+JYp2ScAxdMKQJPYY7FPA2tXYu4e53wMfOgjvtYsRCStlR1tABfi+ZlkWeKHvv6XWnoSeV1q1RhrPI2dg4NK7u1fTTwYOqKIUCwdiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggxjBqUodEZrSQgczGpk+1ARLDmIKnK96MUj+WVBXf4=;
 b=kXKJ7U1g2MFxGb3EPLbvBqTevpbaKbngjvDxRuQ5Qr7D8Y5SCrlW5jpD1bnfJHp7RWCKoHvfi2709JsnZDiToPq+2duwtAVafCV5P6h3NUaQiEV8WBY+mdZsDjNS+0qWpDe7Y/PVpsT/eEGZxerclRjiGjikwK5kwPngo56DCpItdJEBCzck178XFC5Pmdy56kcnRZfWD2bwMNkWmDlUxv1kCcvhKu/AlB7uiCW8GpiDf6C+XlEWAwH4wHF4ZmyECzOMgkSzxqQIa7Qb2+e4oF6UKkr0mzXUEO+vPAOxz2rt4V64ozM2sdVax0pnLX0kYI+k33R1H9qmAfe5j/gBEw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DB8PR03MB6251.eurprd03.prod.outlook.com (2603:10a6:10:137::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 22:02:03 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:02:03 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        devicetree@vger.kernel.org, linux-phy@lists.infradead.org
Subject: [PATCH net-next v3 47/47] [WIP] arm64: dts: ls1088ardb: Add serdes bindings
Date:   Fri, 15 Jul 2022 17:59:54 -0400
Message-Id: <20220715215954.1449214-48-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e351ccaa-60d5-4e74-33cd-08da66ada69d
X-MS-TrafficTypeDiagnostic: DB8PR03MB6251:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8+wQUpFfK8IQMiiJacDmmwyqWGt3FWI3bIuWGtAGAwrx9is23PJraQhCa71rQdagqQZKeXrCqtC93d1emlfeUgTRkThFwlaKJw7PydR8uLCnpB62jn0rr+0QfRiTvJvMgavffL1w4MI2mppdTLVTciIl572X9vIcNH1T3JrHDpkc3VHcu8Oiz8WkKeH23o3ggm8oM8BbxLQ/EoLza+9V2ai66AKNlhCDsylcun0SSeK2nLcHYAfy6kc3zzQrgKUG9JI1po2ciVw3q4FNBGiX9FaF64HoDz0+SnoHn8KeUAfjwuUSAij+r/L3av7jL2maHA7d12lQKuivXDe2X0MumdwGufzIbFE8ZZrpBxuQqzi0553soxfmjlCfexy5w62mfQQa2QC1aUkIqtdp5sGcts24KwR9X+3vZaBHyQLrlDaAWy9iuV5LLDADDaSdPPmZc2V5aOc8PLyk84EMARqi8X2ByKfIw2f2I6VMu9bY5eOGDToUZemWoC6d3vSNs5ANxxZGd1srIeP67jp9WWic8oyvCAGtNPCR0BS5nsxCFS7ekqPvqY+Pc7IdTcAgm3kZQFE1jfb6a/mwXcI6GpVLmeWeYpxDDukQRF9TOA20nUgrFiATyrDY2fzF8BzLWPkXmQ/sD/8bc6aPOMCon7/MkKzSVl7ZSStKo7bxQm0nc74Z0ROOXTWU6oWCSVi+TMOt3wbkZPpBjjofdaMJAGtmvOR1L1OVoXidl92t01pSVjwT0ws09/Hnl8HIam+U041JKTHjJuhRcc4zbQcSZgILTWW99sGarNc5eB9ujOOqCstBl1b6Rwm7157T7JNBf97P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(366004)(346002)(396003)(376002)(136003)(38100700002)(4326008)(38350700002)(2616005)(54906003)(66946007)(66556008)(83380400001)(5660300002)(7416002)(1076003)(8936002)(44832011)(8676002)(66476007)(186003)(2906002)(478600001)(6666004)(41300700001)(36756003)(6512007)(316002)(6506007)(52116002)(110136005)(6486002)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f01Ruxp/x1j/tS+GCCIBOCE4CADy5a5jnx7ImntooAguqWODLmZWMTuIxEYV?=
 =?us-ascii?Q?xaRM9ndnxBVOKjJEewozd+bXQGiQA2W4+XOIkdH5GvOrMXjwRSbL5D8wri0T?=
 =?us-ascii?Q?2G+eeRzJ/PYPOz36VAq7SctP7K+Q0EocKo2+zQMflUb7zcTY6VNEYdTS/46f?=
 =?us-ascii?Q?WrKuer9L5SkWYOU1mHrDHrYilQv/9jbpxIole0Tlb0/KSqFE44046TmzuvUf?=
 =?us-ascii?Q?H9fH0fPY0tfT28wKKAxxdwNB+qZW7JoC2R5K8fPrlCMTPHqrDI9Cv/AqOU/M?=
 =?us-ascii?Q?f3jB233xQsJYewiyhg85SLzX3Ws2k2OD1Kz5ucKcu8JgUPnmyo+E9wMSvKNO?=
 =?us-ascii?Q?5oVWDMBrzbuNM3VI+aH2euUgVjWbhIYWwElai4jrf/N07NsdhykpJU+mDhrx?=
 =?us-ascii?Q?qfgSluJ8rQmpkxRVm9xkvBl5Rr1h3Re/C61sxATZgP5QXKBwo3fvzJJm9rQU?=
 =?us-ascii?Q?TlXvXlqf3A0gDl5lqEIyFurMUqWMIlkuxoCVi+AePHu0x3k8bHmBusO1IxKR?=
 =?us-ascii?Q?c19fV7Ldi6DtWCiD2jY/fBX4V7pVdE0pYQWyuxDhBUeDVuRXOoQjffN27bfA?=
 =?us-ascii?Q?iZ425F10oqLWH7jSV1z2UFrN0IfHwvB9RWQy68eO5wBn4gWYWIa8cfhg7Tn/?=
 =?us-ascii?Q?MjsEjJiQmDLP0yO1lZKLGrxfAavPvTze9MgIy5E+zboKEwWhLaQpC3Imc20C?=
 =?us-ascii?Q?HNwkE610qcFxPSn0kqY9huN9A8Gj2KCdM8vEabhhRzixkJOoPgth4OQvLma0?=
 =?us-ascii?Q?fFAUX3Vu03qYpx3UrRqQDVujzKTUkYwfN/oSwGLcuJcIHhoap8UOz3SERCN/?=
 =?us-ascii?Q?CpK9whDBB6ECx634e7MFuiKrzTEpj6N6tmcemod2MIzjNdQQzSLwChhulzY8?=
 =?us-ascii?Q?77k/PxxebvuMyXbzuIEStxeqETWyIsR/FHCu6q2y/FvXZwmvGClRXw8Bnp8u?=
 =?us-ascii?Q?qi4m12P65zcAODpTEqN68tN7bKqAesheSf+Mbm6dM5HszB6KS6enB1AMsFAv?=
 =?us-ascii?Q?e2uBvYF7n5sdPl5sL9AJsUVc6d1qoM5ZRqUQJHJyOQmSJ+rGeCDElbzgigp+?=
 =?us-ascii?Q?iMDYNH6ACDrU/o9m5Qc8iBspazhq48+io2mod/WJzMCVgFR0zCCMAtZIsnyz?=
 =?us-ascii?Q?c5YYfT1JzBADKwrh0FelL+3VfLgvou9Rq6nVFyaMi584o0HL7GXFQ/5rUbGT?=
 =?us-ascii?Q?UHVA1K1aW6FofMZ89i/a7mhUwK0k4nT/drRaYWVZThakbOkGf+Ea9xbeUKjR?=
 =?us-ascii?Q?NPsHOJBQOZ1KJKQNYf03VGoxpis25sdND9MbsE+g3xIASx/SNf5Wx5yf9cQF?=
 =?us-ascii?Q?tw/tz9C1uekOdsbx12f58udmauOvzMo/GOv+wb/qX7lFCVZH2bcnOWgmizjU?=
 =?us-ascii?Q?QMwDjdJlHXnegbxQO6CBwr2sUFLoXviXZtAK96HqAGPwshziVVd9ri8HJt9v?=
 =?us-ascii?Q?13aOFcqJifEXOVXzO1zQwbQWohYeUH2zMcoeSPnM1mGzulmem3AZWAU9rah0?=
 =?us-ascii?Q?k+s5rd0RD/kJxBzyccne1TKJ1JI5pTEpiFVc4UGxf9TFneyb6EEPjbSEIx8r?=
 =?us-ascii?Q?mi/HWC3Sy5S8VYiRaxbG+XEIWatQjiADCFWnKfi+70XWbA5lXtIGTp+kJzYV?=
 =?us-ascii?Q?QQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e351ccaa-60d5-4e74-33cd-08da66ada69d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:02:03.8135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +cBPn4b4d37LTn3cq1D2iU79wFFBkGmaEf9Qz4rbdPCAcxk6jkUa7iqRYKc/hp49ksubcXmvzqdiBhLaOgdMEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB6251
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a first stab at adding serdes support on the LS1088A. Linux hangs
around when the serdes is initialized if the si5341 is enabled, so it's
commented out. I also discovered that I have too old MC firmware to
reconfigure the phy interface mode. Consider all the LS1088A parts of
this series to be untested, but hopefully they can be a good starting
point.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 .../boot/dts/freescale/fsl-ls1088a-rdb.dts    | 87 +++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
index 1bfbce69cc8b..5875709f7f8b 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
@@ -15,12 +15,59 @@
 / {
 	model = "LS1088A RDB Board";
 	compatible = "fsl,ls1088a-rdb", "fsl,ls1088a";
+
+	clocks {
+		si5341_xtal: clock-48mhz {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <48000000>;
+		};
+
+		clk_100mhz: clock-100mhz {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <100000000>;
+		};
+
+		clk_156mhz: clock-156mhz {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <156250000>;
+		};
+	};
+
+	ovdd: regulator-1v8 {
+		compatible = "regulator-fixed";
+		regulator-name = "ovdd";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+	};
+
+	dvdd: regulator-3v3 {
+		compatible = "regulator-fixed";
+		regulator-name = "dvdd";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+	};
+
+};
+
+&serdes1 {
+	//clocks = <&si5341 0 8>, <&si5341 0 9>;
+	clocks = <&clk_100mhz>, <&clk_156mhz>;
+	clock-names = "ref0", "ref1";
+	status = "okay";
+};
+
+&dpmac1 {
+	phys = <&serdes1 1>;
 };
 
 &dpmac2 {
 	phy-handle = <&mdio2_aquantia_phy>;
 	phy-connection-type = "10gbase-r";
 	pcs-handle = <&pcs2>;
+	phys = <&serdes1 0>;
 };
 
 &dpmac3 {
@@ -28,6 +75,7 @@ &dpmac3 {
 	phy-connection-type = "qsgmii";
 	managed = "in-band-status";
 	pcs-handle = <&pcs3_0>;
+	phys = <&serdes1 3>;
 };
 
 &dpmac4 {
@@ -35,6 +83,7 @@ &dpmac4 {
 	phy-connection-type = "qsgmii";
 	managed = "in-band-status";
 	pcs-handle = <&pcs3_1>;
+	phys = <&serdes1 3>;
 };
 
 &dpmac5 {
@@ -42,6 +91,7 @@ &dpmac5 {
 	phy-connection-type = "qsgmii";
 	managed = "in-band-status";
 	pcs-handle = <&pcs3_2>;
+	phys = <&serdes1 3>;
 };
 
 &dpmac6 {
@@ -49,6 +99,7 @@ &dpmac6 {
 	phy-connection-type = "qsgmii";
 	managed = "in-band-status";
 	pcs-handle = <&pcs3_3>;
+	phys = <&serdes1 3>;
 };
 
 &dpmac7 {
@@ -56,6 +107,7 @@ &dpmac7 {
 	phy-connection-type = "qsgmii";
 	managed = "in-band-status";
 	pcs-handle = <&pcs7_0>;
+	phys = <&serdes1 2>;
 };
 
 &dpmac8 {
@@ -63,6 +115,7 @@ &dpmac8 {
 	phy-connection-type = "qsgmii";
 	managed = "in-band-status";
 	pcs-handle = <&pcs7_1>;
+	phys = <&serdes1 2>;
 };
 
 &dpmac9 {
@@ -70,6 +123,7 @@ &dpmac9 {
 	phy-connection-type = "qsgmii";
 	managed = "in-band-status";
 	pcs-handle = <&pcs7_2>;
+	phys = <&serdes1 2>;
 };
 
 &dpmac10 {
@@ -77,6 +131,7 @@ &dpmac10 {
 	phy-connection-type = "qsgmii";
 	managed = "in-band-status";
 	pcs-handle = <&pcs7_3>;
+	phys = <&serdes1 2>;
 };
 
 &emdio1 {
@@ -142,6 +197,38 @@ i2c-switch@77 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 
+		i2c@1 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x1>;
+
+			si5341: clock-generator@74 {
+				#address-cells = <1>;
+				#clock-cells = <2>;
+				#size-cells = <0>;
+				compatible = "silabs,si5341";
+				reg = <0x74>;
+				clocks = <&si5341_xtal>;
+				clock-names = "xtal";
+				vdd-supply = <&ovdd>;
+				vdda-supply = <&dvdd>;
+				vddo8-supply = <&ovdd>;
+				vddo9-supply = <&ovdd>;
+				silabs,iovdd-33;
+				status = "disabled";
+
+				out@8 {
+					reg = <8>;
+					silabs,format = <1>;
+				};
+
+				out@9 {
+					reg = <9>;
+					silabs,format = <1>;
+				};
+			};
+		};
+
 		i2c@2 {
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.35.1.1320.gc452695387.dirty

