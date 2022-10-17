Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F01360195F
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiJQUYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbiJQUXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:23:40 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60071.outbound.protection.outlook.com [40.107.6.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6F94F678;
        Mon, 17 Oct 2022 13:23:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kt4QhSSuaEEntwazCp4EzbpOwXrj6eYGc5DSrvv+Ae41rcw9RE7PUTHgwcg+xhBYVwXm3zgSM3qG3aE+WgNdYzUt0uoogSCRgcFnnsItpYIWF2ND2dKWskTG9gG/23vn14OCe5FqDn0XrsCMT0LNAA49Nc5JtHwiL2cqT60XydmC6LJZvWYV5IsEDZr6Gxb+6DOg1Sp/Ey9PeSMva41lunwdgou1o2w0IE+VtJODjyc0Y359CnlohgeX8/eh2J9vhfHAPPhD6Q0iYgu/08RQN2gsnRyID+7prPvlTvOgDFgMYJNBQ4+gmOKgvLbVovOZ3pQ1Lb6Za4W2Mf4E+/a7bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EsdQEjx1Q6EFZ03LnTaNDwQemvWxkp4ZfpwjAwz4KCo=;
 b=AIQOVlhsUL+bA2q77/1+tMBaWV6T8amuExke8GkWapEPy+twVMf5lMtRkEMArNr2XoB0vBbFwJDUGQOUTqmdlAgTpvjnVFYU/vIIii+4bIvxG4wEXJ2NA39wiDPJoVFYbBuqP9g9CuM6JS0BnUXol6K9KyPPVu6UefiGy1f6WDOcu/3TwVj8zUA5RL+1wFukYM3mxtmagyJYCnecDcFUye2LEKWWW2mtZ2YotUvAmyQOmdNxm1KZVLVBJcXxPHN3Y66TZ+eY5vJu3LndItoQZ9JCVEAtXJlNtxYm4x+w8QOWIRoHK5UpsQiSjsZotXaDC1YMV/Yg26xMCsBaPjD5Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EsdQEjx1Q6EFZ03LnTaNDwQemvWxkp4ZfpwjAwz4KCo=;
 b=PH4vr8sK6zDYdTwMqukYjgqiJx0BoIBZpcxoWwOmNx6K1t/FhX4kBWWBsCdzHbInxWpaOWnYRb0vhnhV+kbpacg+JsrKu5CJwSDCF2W3VXFS8YeH6/b/VzRBIN2kIipoXZsIJh2ox0O43HPdr5ApaMPKDfbgTswTe/NgirL2yKGdwRQt3HiTYhKYZdT3Vylw7Ix8nmr4jqjZ4Al3qIMQUbfrTKJ05jmCa5Q6U0iUqxmEW98eNRH1Y3xYZhshyv5Z5olJksK4fJmy4phu12rVzPtpO6v3ffPWReaMm+wMz4AHO8pacNqOiQoK5CUKKJc+38krNz6a0gIvdlJHTAvJlw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by GV1PR03MB8406.eurprd03.prod.outlook.com (2603:10a6:150:55::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Mon, 17 Oct
 2022 20:23:33 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 20:23:33 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v7 08/10] powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G
Date:   Mon, 17 Oct 2022 16:22:39 -0400
Message-Id: <20221017202241.1741671-9-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221017202241.1741671-1-sean.anderson@seco.com>
References: <20221017202241.1741671-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0251.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|GV1PR03MB8406:EE_
X-MS-Office365-Filtering-Correlation-Id: d675a9f4-500f-41f7-07b0-08dab07d7671
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ULOJ4rjPcy8o+bNJr19jdx2RGpBvIIZoYuLZYVWmh0Cj2ZVehQD8ejX8u7oZtBkInfY0MOCuKCsTQbhC57GiRY6kZtG/yKJP2rViJOz5jtw55QQbxpIEU7Fhj9A+bkdWO8nSP8zKcBs2KTgDOxodv5YIeg85ZAYinMdL1DNpMAGicIQUrHxHiXMryj1eCQROvzPMCtYOtirr8xzbvxwJMB0dJwXRnbzRBGpgWNB/nLbB7suUtHZDf1bty1/w+OSm41ILQtx/G3Lp9+k1AH/XqrW3Wm6W4yPPoEQaWM/rGCzJuhQE38BFgHsjU6XsvwegZYmNsEI5IZFQjCzHi/oHQaiQcxas9w3Mo4pBmbDqeQ5roSe3tLASHfjOp1l5GEuNQPLpbxpX+GaABA8s9GPhQ5f5lVfBuGVuRdpsLtMiU9dmvZWXBVh/AmI7rejRBOHntwxPEIPp6MY0DNkdeg8K3D+5m6DSR0wKPiePgaT647/lcOzaKx8psJf9GHlL6iYsYyu/8AIiGcgt+8QagmB95N0yTgxrSfOfVFQgXwFDDsCs/itk1rBqqLQKvDXGB8y6Dyy7+IaWQE5fJkva53LOFlvYEW5h0NJtG0qKxvPzG/7v8tutA4A5j0q79sJ9yKWFLclRkq9C94AIotYQ6zr2XA6im/nLGEM0dcfCM5psLgjFERDxdm+wMFDGPnP/FnLak1WLTIfbjD5iXC2XcvHk9xaQyL0xcGMLTlEZbISmwacXn5F0NfvXoTwpZzHKvnXBB92W8RYGsQVCCOtzR7/ExQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(396003)(366004)(136003)(346002)(376002)(451199015)(36756003)(38350700002)(38100700002)(8936002)(5660300002)(44832011)(83380400001)(86362001)(26005)(6512007)(110136005)(54906003)(186003)(2616005)(1076003)(478600001)(6486002)(316002)(66476007)(66946007)(66556008)(4326008)(8676002)(41300700001)(52116002)(6506007)(2906002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sEGvWZv0+6W3pdoK05nx1t7LhjTBUvsHzihZ43rK3/0+dnBOnMtak3GCbR9i?=
 =?us-ascii?Q?AsFu95+rnfRLk4E2rKnPn3R06qJS6HbrJy6a3+o8WwLxPtYdh90Zsd7ert1R?=
 =?us-ascii?Q?YAze0TODyinyWolUNzF4rxlT5O1tKgON70zb+s4ObxjBPIkUJ2pknMlztTXj?=
 =?us-ascii?Q?omqOnzIMBLN27gCStSRtBICo4OD2GQP0uxHO/2Y1zuvKiTAknMQH4nf3muXm?=
 =?us-ascii?Q?gVFtYLpQ3q68DKCEdJFhnydGVtwb7MHbSgMPurfKgeC/o2gL0kxc6u43tNb+?=
 =?us-ascii?Q?tGOYxY2pVG6qz8Z3syKAhNx1KEAOTG6+tfd9uONQaE4uC52OAxixiQSy3Xsa?=
 =?us-ascii?Q?GWL7gPOoVM7BP9o31fyGWurlAA962SxcmcidlFXzOhwFdb9GYjippDvPPQAU?=
 =?us-ascii?Q?KjC7aoAQ0n0cYugV2MCqSn7byimX4SHV55Eu7PpiypyUWOeRlcTp+ovzaTlI?=
 =?us-ascii?Q?ZBw4tL7eidmijVXhmewLnFeGEa9Hp7Rqt9DbuMnIZcy+SpcHUO+XgdNIU4VL?=
 =?us-ascii?Q?jGE3bwPtQIZYG7TCV3OOEXNdX4cuGZR/JtgNNYjmBsoHF8WxKDWXy8x+6/hJ?=
 =?us-ascii?Q?hcu+1b/ZDuGDLDP0YWp/59sBPFBg6AuHu2FtcY0r0/lEhryjPM2Lyf91nkI1?=
 =?us-ascii?Q?tdM4KlylKsByNBNZkqiArTsu2kLkc6TDFqPlhVgCdcIsYF9L9N0mkx66p2in?=
 =?us-ascii?Q?OZpoZUXgo4JyfzKaBOAQvTOHHg1IW/AJK6L2KUiAStmJApNVm5Un55SoAr3u?=
 =?us-ascii?Q?FSNMIoNBvpmiUlw4zTTOdlm9aNwxwpXTFw2hAGuo4EOD5jLQA9JXIIvH5cOm?=
 =?us-ascii?Q?bVJC73SejiTg01njMA3DWs77JVuykLYboF47Yyp3SnrUPwuc8rDIYqCjO+DQ?=
 =?us-ascii?Q?7ljkL5k7K1mfwmaveiMCfs1h1cmr3jHPIlE9aK3BNx7jDpFYuh7XM7aGWfOM?=
 =?us-ascii?Q?fbX41clFTZ8Yo0VqsVsVwi1K9Ogqh52+rfOyIb7fXcgzIZK/PUAkou1UmnZ0?=
 =?us-ascii?Q?37GWuy0DL6OVffpgItNomqOIaxItAY+mm1Rga1YJy1j4ACjDML3J7A7eLIQx?=
 =?us-ascii?Q?NfM/hbmnG053/G0Fl7ZTTD4I6ypmyhqqyuJ0x6iWqWAvdT9ICaLmcFr4S/lc?=
 =?us-ascii?Q?CVdmMWjtxTok3Vr0mLiwmq6IdWxPfedfvXWP3oLYHXVsEaybQI1iGXgsTJ6I?=
 =?us-ascii?Q?6+5ujxGJ3igbxXyoPaOT8rM/k4e+Po1IPRV5jJJ45lihao3Vsovf00xLk4kH?=
 =?us-ascii?Q?gcqjJZ4JQ9ll/FgSFNBDUw7Nxtd6T/qkQb0dsG8akz5x2Ber7N4UfvXyJRI8?=
 =?us-ascii?Q?YV4EnGbd6YAmgzuaVb3Mz/fFUU1F/YznSvQ7b4HMkquynXAmcOMWiM5ACUOZ?=
 =?us-ascii?Q?tqfYl/q5mePt5tmc1RbpRBYhSgpOJwoqeyx9cu5iRPoenr6Ovi2sbHJxSOEf?=
 =?us-ascii?Q?vl0laR4YKdQw9a8ji5bZy56KDXDOhMvMoQSgl6jC6W0VX6A2TkIyzka7R/uq?=
 =?us-ascii?Q?tlLOxZ6dKJwc3s+5mpDz8OB3uQxA/XpkYtjSy7AdR7F/GUHd+jZGa/7BBOHt?=
 =?us-ascii?Q?89Tqb7BJ05Ncpu0JH9t1kBhT1LdrdcgXaEmb/34qrM9IBnQ19i2c3sT9XxIh?=
 =?us-ascii?Q?1Q=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d675a9f4-500f-41f7-07b0-08dab07d7671
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 20:23:33.2428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HuDfRfnQYzCvk8brAeOWuPfznQajZG2CVkvWaL9W/5SHOjALLrtviWj0ntLREtHdymBj0zUMjcvSkaN3IqyKgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR03MB8406
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

(no changes since v4)

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

