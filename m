Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E226558A17E
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 21:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239802AbiHDTsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 15:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239784AbiHDTsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 15:48:45 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130085.outbound.protection.outlook.com [40.107.13.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38866E8B0;
        Thu,  4 Aug 2022 12:47:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqQ8WKnDGMnVv1R9/xMB15oBmF23BprWgLMXMXh8fx9Yk63Wj/F13BR0vFC/FumOfuQJDxjof2g7w5qkLGt7LgHZ+e+MgRJTW5311hIXNwhixSJYDWKJ3JRsFrYfFUJuB40hT4TKFTAhUOft8+Hz2DHp82RBOA8ZasUdqF9m4jR/gQOsY0/WIBPX1USWVnPckj2URXJsTc9weK9LpNeLZKTUC8uDhWMToHh9xOhFlBhBLwvVz9G4ZQRoUGXkS78SGQHodhI8C6aGwq0ezcRiSemmcavyRc5Cn5QMew111XEjBUIAziFHhIL0lTW1easO1i5GRuXBHtuWtIPMfrIo6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LCObfj5r2OYfyyq3F8oPQDtQfbz5yer0yn3O4thUwSM=;
 b=l5qw2BVPks1Otrx0NIkNNE6rqn08bWA5IyPgpsjlyTdSIHmoeerWbZZ855Jqqu+ijQipf9Jt4pmGZIMVyNtlnoKSD5aATTQ5yCH/f7cfsBijLI5YVoHjUog33kB+7yljTxzMLMGYnOkPB3xWtCVyygYnqi2F2wsUSeyq0wsJoJ2CDBXb6AVYBN5oYJkG74wWh6da1TG6OshKThX89sQg/mzCzt3hrjpZe08D8AofL2GinSrlWvb6BPpAwfruqZVh7Dlw2ZXM65sRoe15lpCpPEVejYAUP6xdp2ZlwYKJhynCbJnnm02KUitTycKczp86uqkwUMTPxOsfceV1eh9Xyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCObfj5r2OYfyyq3F8oPQDtQfbz5yer0yn3O4thUwSM=;
 b=OFwY8YMaYrFAd0tE1sA14t5tYLqJUatz3CkVwqwE6hHZg75+5iMgI4G5I7QETi023yknwYAvnZLB0qpMypbLpDAcbr59iS6Aa5LuusCTojjrI3ZebmzNeV4Wfo9pbCnlx2cKI3VXyy4NQ2s8JiRifCrgoO37bvBonVV9J2z/RahZpDWZe5K9u8hvCtcfZIjOhuNqYwiBNQEvkQ6TICfIorN6iaJKJeInah8QUHtK4ZmDf3wFHAeE7T0zkzAOdbaPcg9nmKFj1XlkVC2AgwSSNTYyPzxj3RceRFYSty8c5A7aqZ29D0Vz/MbHZEmYs9WL2lDRmeRggPrOwy9R9FcsRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by HE1PR0301MB2297.eurprd03.prod.outlook.com (2603:10a6:3:25::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 19:47:34 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 19:47:34 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v4 6/8] powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G
Date:   Thu,  4 Aug 2022 15:47:03 -0400
Message-Id: <20220804194705.459670-7-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220804194705.459670-1-sean.anderson@seco.com>
References: <20220804194705.459670-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0012.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::17) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 681d5b4a-2cb3-461e-58c0-08da76522d53
X-MS-TrafficTypeDiagnostic: HE1PR0301MB2297:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YBgo/JNdCcemIDbdCADk2xytrlJZwmqmFbf5oEnnlLbzAAaeWM14HH/FtK9GQu8N+Goxsgn95+f6QSi1UKh2KD1W9lRCsz4aatlYzNXj9psA4U7ckLoUajNfbyyK397E3BLbQrXt7iv3nXnywot97Sm0O+pY1eiSXvu6YTbeFf3aZTV+gPVqNewow+yii0uAiw4EOiw1yzAL3UkgLx6yxwEoRkpsYAf/+fthsYKsiJt81ftH3PbNTPcIh68j+lUPHCGCCT5allz0Za7tEiehKYjnzfkbhABkNHCP59sJ6RmHtr33UmVDSAJX+8JRJvB+LW8HJ7N7+UAbEeskvAYJzKaFvSth63XcY6aUWeKLdMi3Tt+WKlnS0R3CaJKQKrH2MoSdNhTE/I813lAnaPOiMcYwb+SXwUu7lOqWttGaUIbkW8Jtmugy9gD/t3tw5Bf7lxryKJHAbd+dolhTHHMoeSPg6fzCowjdy/gnB5xRuPnBq0wt49MmqXwJeHJ2nWN5vH9Tq3MHiu5T9k2tqZqInTOigNBCi6dFBJaI0+z86erHUk5t8wtZIHeCDPxOJGwVd0dhB9U9HSA1mO1p1tCLmZyWqIQ3BWv4BL2beQbmeP2zUM2xu+Pw5bQ3l132V308hhoLnskvKlq/wMr/KCMUAs9bPkqgj4JfdtEJ7Va9HGq440GxxrQrvtzhpsj9GjEioqBIzLHLmxYyG45kK1tSk/Fm7HXamKJc6l30KCxlFgJUnxX1iVJ5qnlxG7klqWaefLgAsBpY4vLV26rQ0eJXvQj92SinFNAtiLmiLDPJnkM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(366004)(346002)(376002)(136003)(396003)(6486002)(478600001)(186003)(1076003)(26005)(7416002)(6506007)(6666004)(2906002)(6512007)(8936002)(83380400001)(44832011)(41300700001)(38350700002)(110136005)(38100700002)(86362001)(316002)(5660300002)(54906003)(8676002)(36756003)(66946007)(66556008)(4326008)(2616005)(66476007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fYu6L3x6qWm/vFvx6EGpMwbllSNfoC6l0r/Fdcx55i5Ekj3vAfI0wMjzSGSZ?=
 =?us-ascii?Q?d9RQOF+VA2NQll6yOfM2k5qIBNueApcjFI5i2IsGpcdRn+vtpWGO3WL7cU5l?=
 =?us-ascii?Q?qVzQcqaBi/5tt63W4GUbXxD4x7wBXqH7qhZr98M6U7J9eMY75xJeL7Rh8LMY?=
 =?us-ascii?Q?mv13/4jRkJHIMICiW+CY/7y3dr+WpKKl1/uBS//4j/DjvcbhzhBdXSLJy4Sb?=
 =?us-ascii?Q?nyFbovcu3qG75bmTns+8PnxRx200r/FLdYLIwdLy1GDkWOz+6zQyNRhToeit?=
 =?us-ascii?Q?OCRqeb91IqWnWnMGjK10ZkZQjL+7aBfAPHlEKTlp+Op5kCSmjqhWyiRWMIqd?=
 =?us-ascii?Q?Z1/rNU0ThxiXrHh4iGKPygERs2Y77+yZSOpNGCXfC1UB/bdqhwxtpYogXl80?=
 =?us-ascii?Q?aBET+G++3iMQVaSK/hgcens4LaSQIy/7nU7kq2K2VigJbFthAwk08CYoimPP?=
 =?us-ascii?Q?CoWSgAqlKKJFm+oHyXl7AaIMVY4Iv7J9m/XnaIVwW5imDhk1Jij9Yl06oXHf?=
 =?us-ascii?Q?6GCMg5mbj3t7Cff/f0haqPbbg9/Nj8UbhY8oMsJtQjryrMAAUGZqSCY/iUbE?=
 =?us-ascii?Q?Ik7YMN7lOLpoibliDNPSShD06WzikAdxrnep9hMrnntieV+Bofc6cvE+IfFk?=
 =?us-ascii?Q?XvTnHG0jhE63dlTu0mXkBXOKQlcUcLPOHQKlccnE31Bq4cvBwPWDQyj0QJoY?=
 =?us-ascii?Q?y5FSNfL06jaZF1aZ1gDp+cao4ynbaawa0YYE8U5o6bki1XsS11BNU5zWp2do?=
 =?us-ascii?Q?t/kk59ztqip5zp3KQt/7DtzhVX0vnfB5FzmSMlUnp67mmz0lsy8EWtHoalOZ?=
 =?us-ascii?Q?mEa8acAzHeCB7u2E548cwnIy3VyCatfQJCRcy26vGFox3zoHQ3dkSK1wyNI+?=
 =?us-ascii?Q?ZGg7PV0hHsFVMvXyEqk6FP8ntGtjQJBXe5DIaHpApJPNZXogr5fjxQCpDQB1?=
 =?us-ascii?Q?55hN52F+aYtSZwVc1gpVtPp4uYrfwhiUQPpjFhonARDlBWqOTl6zITszGVOa?=
 =?us-ascii?Q?PEENnHkAUx+/PsNxK4seIZqwErtZ3oopOJGn3IXBDzf3j6P2/RafEP0swDGq?=
 =?us-ascii?Q?ryo14lBnGGDA4PIs1PEKFVhBZFuUop3HClPTiIgka6LXRhIOr8IkpjIwNpQg?=
 =?us-ascii?Q?Vlb/G4/kGS6xon37eg9mo0B5C+ViIzZvVx7crGXU2CR6n6lpwTOIYW7dRpaC?=
 =?us-ascii?Q?Oyu65020fc1yaTVslwxacFELmhB+ORRqGiAmafaxHQwawElE0z+aDckQvLOp?=
 =?us-ascii?Q?AbY7Xjg10AkzzhPqubz98oMI526fwoD902PO7rCgXjjWkfnnzoWHo4pR8GQQ?=
 =?us-ascii?Q?M+S3IfgmgEJDfApR+OKKmvOpvPpuadD9eXrSBCXOdkDablZ7Li682ZvasAdQ?=
 =?us-ascii?Q?cuDlYgigMvekerVmOW7wllbwqEZ2qGeFEePS5iTV67xZfQx5z7udDBbcB6+o?=
 =?us-ascii?Q?ftR3YgDHryg9vAiPoCvHzmUKFvQQErN3MmlczebhGyGewY0vUjWJgqXwzn8r?=
 =?us-ascii?Q?n8C+UrSPyjt7G1DRRhqgZVyjxch3p2fpW43d3Gyh26sVr8sO9+DbvCoTt047?=
 =?us-ascii?Q?WryfmpCEXRkWanWlbLCgHB4Tm4uxoRe/ewNZYXdg2ak4uNbcSCNc4LnmayrV?=
 =?us-ascii?Q?Vg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 681d5b4a-2cb3-461e-58c0-08da76522d53
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:47:34.7585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AMzIhOrqC6BxnY0VGkU+ouFwaySHmktzUQ/y+ax7RDzPOYCrEVFwzBFlcS9Mk1MocxiwJlgOSFt8gKKQLU/MxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2297
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the T208X SoCs, MAC1 and MAC2 support XGMII. Add some new MAC dtsi
fragments, and mark the QMAN ports as 10G.

Fixes: da414bb923d9 ("powerpc/mpc85xx: Add FSL QorIQ DPAA FMan support to the SoC device tree(s)")
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v4:
- New

 .../boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi     | 44 +++++++++++++++++++
 .../boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi     | 44 +++++++++++++++++++
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi   |  4 +-
 3 files changed, 90 insertions(+), 2 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi

diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
new file mode 100644
index 000000000000..437dab3fc017
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
+/*
+ * QorIQ FMan v3 10g port #2 device tree stub [ controller @ offset 0x400000 ]
+ *
+ * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
+ * Copyright 2012 - 2015 Freescale Semiconductor Inc.
+ */
+
+fman@400000 {
+	fman0_rx_0x08: port@88000 {
+		cell-index = <0x8>;
+		compatible = "fsl,fman-v3-port-rx";
+		reg = <0x88000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	fman0_tx_0x28: port@a8000 {
+		cell-index = <0x28>;
+		compatible = "fsl,fman-v3-port-tx";
+		reg = <0xa8000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	ethernet@e0000 {
+		cell-index = <0>;
+		compatible = "fsl,fman-memac";
+		reg = <0xe0000 0x1000>;
+		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
+		ptp-timer = <&ptp_timer0>;
+		pcsphy-handle = <&pcsphy0>;
+	};
+
+	mdio@e1000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
+		reg = <0xe1000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
+
+		pcsphy0: ethernet-phy@0 {
+			reg = <0x0>;
+		};
+	};
+};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
new file mode 100644
index 000000000000..ad116b17850a
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
+/*
+ * QorIQ FMan v3 10g port #3 device tree stub [ controller @ offset 0x400000 ]
+ *
+ * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
+ * Copyright 2012 - 2015 Freescale Semiconductor Inc.
+ */
+
+fman@400000 {
+	fman0_rx_0x09: port@89000 {
+		cell-index = <0x9>;
+		compatible = "fsl,fman-v3-port-rx";
+		reg = <0x89000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	fman0_tx_0x29: port@a9000 {
+		cell-index = <0x29>;
+		compatible = "fsl,fman-v3-port-tx";
+		reg = <0xa9000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	ethernet@e2000 {
+		cell-index = <1>;
+		compatible = "fsl,fman-memac";
+		reg = <0xe2000 0x1000>;
+		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
+		ptp-timer = <&ptp_timer0>;
+		pcsphy-handle = <&pcsphy1>;
+	};
+
+	mdio@e3000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
+		reg = <0xe3000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
+
+		pcsphy1: ethernet-phy@0 {
+			reg = <0x0>;
+		};
+	};
+};
diff --git a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
index ecbb447920bc..74e17e134387 100644
--- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
@@ -609,8 +609,8 @@ usb1: usb@211000 {
 /include/ "qoriq-bman1.dtsi"
 
 /include/ "qoriq-fman3-0.dtsi"
-/include/ "qoriq-fman3-0-1g-0.dtsi"
-/include/ "qoriq-fman3-0-1g-1.dtsi"
+/include/ "qoriq-fman3-0-10g-2.dtsi"
+/include/ "qoriq-fman3-0-10g-3.dtsi"
 /include/ "qoriq-fman3-0-1g-2.dtsi"
 /include/ "qoriq-fman3-0-1g-3.dtsi"
 /include/ "qoriq-fman3-0-1g-4.dtsi"
-- 
2.35.1.1320.gc452695387.dirty

