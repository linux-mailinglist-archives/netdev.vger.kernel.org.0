Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E485707F5
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 18:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbiGKQGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 12:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbiGKQGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 12:06:20 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2059.outbound.protection.outlook.com [40.107.22.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515D76E883;
        Mon, 11 Jul 2022 09:05:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbrexflZns6XiD1fTsrdBrvR+x8EDHizlKh1z69hN0gEDgNxRbz2phi20TQFS3H9HhNbIf1ETxk9M1wnZj/peZvCIPfAY804WlX210/x9SJ3C9DTJawlgCwIKSigQmYqytUMV76U3SH/bIwZxi40tDbiyUpWA2WC5XXk26b7RkqjqhdLFpPayhkIPcHnNL7GqvDlKygGJRRs+n9iAYgkOlupM2Y6xGzVpYfxJBks8dc+l+6DW5hgB9BntAOZVKyhIvFYDVnxEjmR+uH3+mmh1I60B7nBeHZOGuWmoS2RzdJ3wzyM/SvnT/NPqV314oOWN67+3B+n/pvW5GDh+2VkHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nXL9uU0jmBAUWk0tRM+f5NoyfnScEQTJlO7VAKcTK3E=;
 b=nTYgQwF2+cVwg3i4l4zcwZX+Gyf536xuUe8y/B69LblNtBXyA48mmEj0nuIcHvQh7yIWCGt0uhdR6HVDXSBJqIsbJrX5ZxILeCCVdBpz1AvIlkKyRtNuLq94z2EUdvhp3X4ZFtElVe0/b44xx9bgN/S4aYLDlt3/MF5G33Yw+8bWKQNuC4O6dmEZVuepViam3IAvDryR07jbUk+RO3Y3ruVoau92D+jTgIoeNNxB7S+D7tBwunQqrmZlYFW+UsY431u2JVa7HzdgrU8/ccZIN806DoGBQs7nfkl4WWcI64AVv3J+E2D0VbXM9bkV7UOMhSHM9L6S5PEz0+ViODgjcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXL9uU0jmBAUWk0tRM+f5NoyfnScEQTJlO7VAKcTK3E=;
 b=hbGLx1aYDRqp1EHx2kk3SHu/AZuHmbSov7RknSv8GC5CIywAfwR6ZitgKo79uNAXKNhen7B5kyewKE4T/Bd+v58zIDm/+XDsDliHnUE2f3wNxH0x/P2OFgt6e3p/xoP9Ao+TWGOWoDJFUDjSYYHX0VrzlaDOFXdnnvrSVuc00k49MO3R2YI+apSwhNeS+CiMY+fI6ot7rb4oOY5pap4cGqn+wPgYZG3Dcf3BNCfvnSVh99vVOIrILlpftlWTUMeI6i0/T/TjBoh0xEpPQVIVVDOUyg4l2pRTmfHmV4FSJErO5E/aDyodGT5dv6a3ZKvhDDRD2Ds6BJ9fEVeDoUHxKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB5113.eurprd03.prod.outlook.com (2603:10a6:10:77::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 16:05:55 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 16:05:54 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sean Anderson <sean.anderson@seco.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH net-next 7/9] arm64: dts: Add compatible strings for Lynx PCSs
Date:   Mon, 11 Jul 2022 12:05:17 -0400
Message-Id: <20220711160519.741990-8-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220711160519.741990-1-sean.anderson@seco.com>
References: <20220711160519.741990-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0056.namprd16.prod.outlook.com
 (2603:10b6:208:234::25) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a60f6f2d-6a13-4563-ef83-08da63573c11
X-MS-TrafficTypeDiagnostic: DB7PR03MB5113:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mHM2Lkl61Agt2nDZ3Zh5P3K61cJi+Wg/E+NobOwzElHE6RIMqLeR+qEzLGfiydjavhHMpbvbbhRlrUj56Wuz2sQ9XLeffJ13mklz6t+QwHD588C4p0YJ6VP/hYrbcPlzhSbVO7w7JwD73+vfWAVEGwdGXIcXt+ahqzRyGy3YzO+kEpZBbftTlwsCeuYkyRPuAZ34KFSRO9vE5zuzOei03nj0N7f8mi9CUWIuLPa7SwQfRQKV6bEFPufJdJoaRMgQp+48Bhu6pKasmoHlgpmKiZDgl84EbSv9iwMDpX+wkDEcEqciYqJmSWG5UdMojFuX2V2khnb1T2Cp8y6pzGi99bAvKtnS2YVdji1j2yV7TxeedSRchbqqW+yto0KtH1gyEPMbHlC4Zqx3NFc5h2+xzkECptbwdIc3CGAB8TPzc9G+Z0N05It3K8EhgCsjJQ/fWYvldG0pdR30i8JZ17SCpOPPVwjvMT9/wMsAN5XDDQtm0VUSDjCsScWxEC4zV4bQbsj+gClK94CB0WBM6jTPZlVRYcAZ0IkT/YvP7LEVKM4fw7moqYNLGHcS6L5PyiTjX3BICdasyZmV7gRhT/f6nHlD0I5yZ0pKr1+z84Rpvf4RvM/12tyKc3iU3jyeF+w4YAZcJElt5uBkh74VE/xjoC/UzVavWlsrWZ/OzGsd3RZogUlQXD8/PeH7rtP8qDfn0wnu+MY3gy4z6+VfCjy/qKtrNu76/YrdyDFsD8lMwGOKb9D6BDEuZYw8jfGnN2K0T4XrhddfpL+Axx77JKErbm9nmLycEYWhvAAXUhaELKKzG14KhFZQe7UsLfqTwUFK48TYzad+GVFguUyu8mouNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(376002)(39850400004)(366004)(83380400001)(86362001)(38350700002)(66946007)(38100700002)(4326008)(8936002)(66556008)(66476007)(8676002)(36756003)(6512007)(316002)(54906003)(30864003)(5660300002)(44832011)(6666004)(7416002)(2906002)(6506007)(41300700001)(26005)(6486002)(966005)(52116002)(478600001)(110136005)(186003)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c1tNPR6JmHP2bUJXyMaGFrPeGiAzVqlKfB+33PM/ps8lNsvlseSx//LYu4q3?=
 =?us-ascii?Q?BjjCWvno0Sh8Ya+rDHWSN8O7r1GDfSvu5+uV8g15x1WrfG0TzQFeWtT3vW+S?=
 =?us-ascii?Q?o7ngqB9vcdZ7Bi+oQ9sDGW9tOwjwEkwQbF8AmLe6v9E0043G/faCoIQ+9Zm4?=
 =?us-ascii?Q?EbAOTUleH3y6OJBIGbi8czJL6+KH9NSbMcjMJ1cqy0PkbyEvISp8nuaJqJQw?=
 =?us-ascii?Q?rqnA+n2oIoYEqOlBJ9iQhI38KQgfHdQcjxJq3APVc4ey59kWqSqF6ttQ33U+?=
 =?us-ascii?Q?EnAyemHMQ7WAgiWq1TvVqvoZR8OSIi1/QvPLoNN7W27I5KuBioVOdJX8XM1m?=
 =?us-ascii?Q?GM9e23EUEVI1SCcxKZMESWUwWTwok9NCLJR7I24EqYat8nMu7Bk42+QYwbAB?=
 =?us-ascii?Q?IHX74cj7Zrh2LshflgK20lbpBr5uVl2h5eG/VxlUVc0XvjvCX09j1xc1YhXS?=
 =?us-ascii?Q?hj6u6qP8+i3UXfp6dFAtht1r8W8ABq3IdEeqx51aQ4PCwYaEM9cfp8n5HK6F?=
 =?us-ascii?Q?oH0x395Lrca9OtG6kvT7zHA37EGzKQfZJX5kDL+GgsyzHZ9GiCPWnnG7MJTm?=
 =?us-ascii?Q?FPIh4fG1a3vb2ImMe8lGYrsgcQtcLnwuEljDT7DdUf+7Qs34Gn9KfoI1hsWV?=
 =?us-ascii?Q?8mFOIJelx5R1QoflwSSDFrCFYfM+Jug+vPrP+HRJAtGs4yO2/wVEfLmfPHte?=
 =?us-ascii?Q?y2dA+sbvfkEinhN4JfzFwl2B50FPmyznJ/Dk0witIfEJmx77ssGM+jmb9Qpf?=
 =?us-ascii?Q?lhF8KUJtQGczDKCk0cvMSiexQ1/FnJFrCZ1c17QL+sRkyzE+QZ1rqUoJt2rW?=
 =?us-ascii?Q?GH2OmuqVpDz1lXF0UYvdojb+Ch9AQxBw+e9BsOtGSAoqVaDueERwt8yfPMQ2?=
 =?us-ascii?Q?bxa+rVajq4JQkFtbGB4vZZpbVL9Ri0Rjst9TMxxQWTUzAWe3W/nfeM4GG5Cw?=
 =?us-ascii?Q?s/AP+BehUW2IHWKAZIU4Kkkuhn/Xxx87n5ZKMRJd4nCWVaCUJBfot2T8x80u?=
 =?us-ascii?Q?wddsuP+YsrmY8MmslhR3DF4VCf1PueTjB72ecUtqUVqCiFUXTnxgzT8Iyx/S?=
 =?us-ascii?Q?uLAxIk7yqMeLSLjLHlPPGm/ZG71MoGP+9U5sytTMmqHqqICF+RHszPVS4lFN?=
 =?us-ascii?Q?ofRFbLc2ubQopyGwzUs3wEUAsh280v+pR999rSyWlYB2RgCLr2SKHCvbzFby?=
 =?us-ascii?Q?W/+Bl1GIyBsjBy0JEe6mO6KVt3xs87wz+faC7FqrGxgFgMZuxhahbFXnUcdK?=
 =?us-ascii?Q?FJ7zR7uy1HzrI4Iu8ordAEZPOGzR2yvq9fHJtV2dStQxKcub/9/ZQ3nfPvRn?=
 =?us-ascii?Q?NLlJueFxyL4NTb3a0qYty6oU+pEBQ4pvxkks3MKIbG/L4O7/l793eUG0gSzL?=
 =?us-ascii?Q?xq9gbQnjueB42T++zaqCwZ7BTgp4RrHuDWCLsgwSsHYw7FznY13PiaKMeCNe?=
 =?us-ascii?Q?F/gR1vvCllzzQGLnauCsMtj/wk9WpWsUGFlW0fiR8APeTzMar1uuMFM0Vk/9?=
 =?us-ascii?Q?sTt1qxQqAwIZyUzv79M1sltu1wXvfzitGAnPatq5L/aXo1YKvJh7+w48N1Qv?=
 =?us-ascii?Q?NUYa+mB0DVquKuDevBSBRdbeGA7aDJ5w90vEhurSbHyBGAHXtFuhSD/IFkGT?=
 =?us-ascii?Q?DQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a60f6f2d-6a13-4563-ef83-08da63573c11
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 16:05:54.9178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5lsCSXXbcUV0c82qmBeiS/g1lOak9rnlw7Xme4vOEYUISnqo5ieN8HUkagEoJJF/mTNIR9PswBnygccQv6D+fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB5113
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds appropriate compatible strings for Lynx PCSs on arm64 QorIQ
platforms. This also changes the node name to avoid warnings from
ethernet-phy.yaml.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This will break mEMACs. The DPAA driver needs at least something like
[1] before this is applied. This is because adding a non-phy compatible
string to something on an MDIO bus makes it a regular MDIO device and
not a phy. This will break the existing code, which expects a phy and
not an MDIO device.

[1] https://lore.kernel.org/netdev/20220628221404.1444200-1-sean.anderson@seco.com/T/#md2dee008cbb0962bc9e943426b2c02d2e64b6e3b

 .../arm64/boot/dts/freescale/fsl-ls1088a.dtsi | 30 +++++++----
 .../arm64/boot/dts/freescale/fsl-ls208xa.dtsi | 48 +++++++++++------
 .../arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 54 ++++++++++++-------
 .../dts/freescale/qoriq-fman3-0-10g-0.dtsi    |  3 +-
 .../dts/freescale/qoriq-fman3-0-10g-1.dtsi    |  3 +-
 .../dts/freescale/qoriq-fman3-0-1g-0.dtsi     |  3 +-
 .../dts/freescale/qoriq-fman3-0-1g-1.dtsi     |  3 +-
 .../dts/freescale/qoriq-fman3-0-1g-2.dtsi     |  3 +-
 .../dts/freescale/qoriq-fman3-0-1g-3.dtsi     |  3 +-
 .../dts/freescale/qoriq-fman3-0-1g-4.dtsi     |  3 +-
 .../dts/freescale/qoriq-fman3-0-1g-5.dtsi     |  3 +-
 11 files changed, 104 insertions(+), 52 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
index f476b7d8b056..259ca8f3f44d 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
@@ -791,7 +791,8 @@ pcs_mdio1: mdio@8c07000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs1: ethernet-phy@0 {
+			pcs1: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -804,7 +805,8 @@ pcs_mdio2: mdio@8c0b000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs2: ethernet-phy@0 {
+			pcs2: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -817,19 +819,23 @@ pcs_mdio3: mdio@8c0f000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs3_0: ethernet-phy@0 {
+			pcs3_0: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 
-			pcs3_1: ethernet-phy@1 {
+			pcs3_1: ethernet-pcs@1 {
+				compatible = "fsl,lynx-pcs";
 				reg = <1>;
 			};
 
-			pcs3_2: ethernet-phy@2 {
+			pcs3_2: ethernet-pcs@2 {
+				compatible = "fsl,lynx-pcs";
 				reg = <2>;
 			};
 
-			pcs3_3: ethernet-phy@3 {
+			pcs3_3: ethernet-pcs@3 {
+				compatible = "fsl,lynx-pcs";
 				reg = <3>;
 			};
 		};
@@ -842,19 +848,23 @@ pcs_mdio7: mdio@8c1f000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs7_0: ethernet-phy@0 {
+			pcs7_0: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 
-			pcs7_1: ethernet-phy@1 {
+			pcs7_1: ethernet-pcs@1 {
+				compatible = "fsl,lynx-pcs";
 				reg = <1>;
 			};
 
-			pcs7_2: ethernet-phy@2 {
+			pcs7_2: ethernet-pcs@2 {
+				compatible = "fsl,lynx-pcs";
 				reg = <2>;
 			};
 
-			pcs7_3: ethernet-phy@3 {
+			pcs7_3: ethernet-pcs@3 {
+				compatible = "fsl,lynx-pcs";
 				reg = <3>;
 			};
 		};
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
index 4ba1e0499dfd..130a96054ff9 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
@@ -545,7 +545,8 @@ pcs_mdio1: mdio@8c07000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs1: ethernet-phy@0 {
+			pcs1: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -558,7 +559,8 @@ pcs_mdio2: mdio@8c0b000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs2: ethernet-phy@0 {
+			pcs2: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -571,7 +573,8 @@ pcs_mdio3: mdio@8c0f000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs3: ethernet-phy@0 {
+			pcs3: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -584,7 +587,8 @@ pcs_mdio4: mdio@8c13000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs4: ethernet-phy@0 {
+			pcs4: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -597,7 +601,8 @@ pcs_mdio5: mdio@8c17000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs5: ethernet-phy@0 {
+			pcs5: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -610,7 +615,8 @@ pcs_mdio6: mdio@8c1b000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs6: ethernet-phy@0 {
+			pcs6: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -623,7 +629,8 @@ pcs_mdio7: mdio@8c1f000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs7: ethernet-phy@0 {
+			pcs7: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -636,7 +643,8 @@ pcs_mdio8: mdio@8c23000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs8: ethernet-phy@0 {
+			pcs8: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -649,7 +657,8 @@ pcs_mdio9: mdio@8c27000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs9: ethernet-phy@0 {
+			pcs9: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -662,7 +671,8 @@ pcs_mdio10: mdio@8c2b000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs10: ethernet-phy@0 {
+			pcs10: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -675,7 +685,8 @@ pcs_mdio11: mdio@8c2f000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs11: ethernet-phy@0 {
+			pcs11: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -688,7 +699,8 @@ pcs_mdio12: mdio@8c33000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs12: ethernet-phy@0 {
+			pcs12: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -701,7 +713,8 @@ pcs_mdio13: mdio@8c37000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs13: ethernet-phy@0 {
+			pcs13: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -714,7 +727,8 @@ pcs_mdio14: mdio@8c3b000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs14: ethernet-phy@0 {
+			pcs14: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -727,7 +741,8 @@ pcs_mdio15: mdio@8c3f000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs15: ethernet-phy@0 {
+			pcs15: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -740,7 +755,8 @@ pcs_mdio16: mdio@8c43000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs16: ethernet-phy@0 {
+			pcs16: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index 47ea854720ce..b48b2d6acd3d 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -1398,7 +1398,8 @@ pcs_mdio1: mdio@8c07000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs1: ethernet-phy@0 {
+			pcs1: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1411,7 +1412,8 @@ pcs_mdio2: mdio@8c0b000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs2: ethernet-phy@0 {
+			pcs2: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1424,7 +1426,8 @@ pcs_mdio3: mdio@8c0f000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs3: ethernet-phy@0 {
+			pcs3: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1437,7 +1440,8 @@ pcs_mdio4: mdio@8c13000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs4: ethernet-phy@0 {
+			pcs4: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1450,7 +1454,8 @@ pcs_mdio5: mdio@8c17000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs5: ethernet-phy@0 {
+			pcs5: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1463,7 +1468,8 @@ pcs_mdio6: mdio@8c1b000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs6: ethernet-phy@0 {
+			pcs6: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1476,7 +1482,8 @@ pcs_mdio7: mdio@8c1f000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs7: ethernet-phy@0 {
+			pcs7: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1489,7 +1496,8 @@ pcs_mdio8: mdio@8c23000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs8: ethernet-phy@0 {
+			pcs8: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1502,7 +1510,8 @@ pcs_mdio9: mdio@8c27000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs9: ethernet-phy@0 {
+			pcs9: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1515,7 +1524,8 @@ pcs_mdio10: mdio@8c2b000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs10: ethernet-phy@0 {
+			pcs10: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1528,7 +1538,8 @@ pcs_mdio11: mdio@8c2f000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs11: ethernet-phy@0 {
+			pcs11: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1541,7 +1552,8 @@ pcs_mdio12: mdio@8c33000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs12: ethernet-phy@0 {
+			pcs12: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1554,7 +1566,8 @@ pcs_mdio13: mdio@8c37000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs13: ethernet-phy@0 {
+			pcs13: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1567,7 +1580,8 @@ pcs_mdio14: mdio@8c3b000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs14: ethernet-phy@0 {
+			pcs14: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1580,7 +1594,8 @@ pcs_mdio15: mdio@8c3f000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs15: ethernet-phy@0 {
+			pcs15: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1593,7 +1608,8 @@ pcs_mdio16: mdio@8c43000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs16: ethernet-phy@0 {
+			pcs16: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1606,7 +1622,8 @@ pcs_mdio17: mdio@8c47000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs17: ethernet-phy@0 {
+			pcs17: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1619,7 +1636,8 @@ pcs_mdio18: mdio@8c4b000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs18: ethernet-phy@0 {
+			pcs18: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi
index dbd2fc3ba790..4cf65e40126f 100644
--- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi
+++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi
@@ -35,7 +35,8 @@ mdio@f1000 {
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xf1000 0x1000>;
 
-		pcsphy6: ethernet-phy@0 {
+		pcsphy6: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi
index 6fc5d2560057..de483c7e9ae0 100644
--- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi
+++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi
@@ -35,7 +35,8 @@ mdio@f3000 {
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xf3000 0x1000>;
 
-		pcsphy7: ethernet-phy@0 {
+		pcsphy7: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-0.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-0.dtsi
index 4e02276fcf99..9c31b3b2292d 100644
--- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-0.dtsi
+++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-0.dtsi
@@ -34,7 +34,8 @@ mdio@e1000 {
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe1000 0x1000>;
 
-		pcsphy0: ethernet-phy@0 {
+		pcsphy0: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-1.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-1.dtsi
index 0312fa43fa77..72dbb26c7fd4 100644
--- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-1.dtsi
+++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-1.dtsi
@@ -34,7 +34,8 @@ mdio@e3000 {
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe3000 0x1000>;
 
-		pcsphy1: ethernet-phy@0 {
+		pcsphy1: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-2.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-2.dtsi
index af2df07971dd..e7aa07964d1c 100644
--- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-2.dtsi
+++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-2.dtsi
@@ -34,7 +34,8 @@ mdio@e5000 {
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe5000 0x1000>;
 
-		pcsphy2: ethernet-phy@0 {
+		pcsphy2: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-3.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-3.dtsi
index 4ac98dc8b227..fb6b8d4eb786 100644
--- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-3.dtsi
+++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-3.dtsi
@@ -34,7 +34,8 @@ mdio@e7000 {
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe7000 0x1000>;
 
-		pcsphy3: ethernet-phy@0 {
+		pcsphy3: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-4.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-4.dtsi
index bd932d8b0160..1d9cc79bf7e2 100644
--- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-4.dtsi
+++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-4.dtsi
@@ -34,7 +34,8 @@ mdio@e9000 {
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe9000 0x1000>;
 
-		pcsphy4: ethernet-phy@0 {
+		pcsphy4: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-5.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-5.dtsi
index 7de1c5203f3e..b6151d6f6859 100644
--- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-5.dtsi
+++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-5.dtsi
@@ -34,7 +34,8 @@ mdio@eb000 {
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xeb000 0x1000>;
 
-		pcsphy5: ethernet-phy@0 {
+		pcsphy5: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
-- 
2.35.1.1320.gc452695387.dirty

