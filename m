Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE255EB0D1
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 21:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiIZTEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 15:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiIZTDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 15:03:49 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2042.outbound.protection.outlook.com [40.107.21.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAF2915DA;
        Mon, 26 Sep 2022 12:03:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MhCaVmLiFXA3bb/AzVREUZIECZTsQ05X4udGs3Sxx76Ln4nzJkH7ZXM3ibv1AiRdrReEWCnm8LzGLYg3q2aMTQI52vHZDz3EpowNXe6/YrNbTeVz40gipT9+jxqw5Rxwvi36v233ZDHGeDzqQvp79J2flLNJq6TNLmyGfOdOb32jXR9H1JIwOBANI4TS0MmeIn/enGNruKHMhL8jjHIuW/3j8mm6QcK7e2RTmI591AqRedo0eBmpB6dZ3C1XJOMPWYTphjw6WtdoIK9Wyb6b5AckFVvOE6+ktqivaESPqb+CIwrpvRt/z/6wKyMkTW+Z+sLF+BQ9Pkd+8VRkl5OJnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EsdQEjx1Q6EFZ03LnTaNDwQemvWxkp4ZfpwjAwz4KCo=;
 b=RYh+QTT28nDnjvhX6dsWh1O6ux5Iyd8REx0YMYfv/N2F3HcL3g61LPnv7Cqf45Vh4AiL/AM+IsPQ1KQKwXn7paityJ/KSpoWMQEf83IHcJqcOrcN3Y7pd/QKIij7hP8X5l6/WM1CJOrXVHB1vZEX/HxCZBIyhvPCWVsKOfggjLG9cIBDtW27yLYVcbkg1CsO1DV6A06htnIykkz03GbtwX0GhocxqVssMmcorQaMkBU6lMi4NKyZ5Wsfa9giMw3YGUgI74vYd8bTRLarq4u9UUn664449gXypxccBEro3RCPa9R12W9iolP3Yx9Dq4Vr6t/vdAANlqVdj1Y1R8H/Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EsdQEjx1Q6EFZ03LnTaNDwQemvWxkp4ZfpwjAwz4KCo=;
 b=QEz+OzqPlZzwJLJnZoiiGVmJWdAywsuba9Zz23Ru7slbGDUW64gUfbmIdJrV/qlc9jkdvrjLmYB+tiYiLNqLtASaXpHPcXvxsiC7fEAJfmHkOEaPusClAb7l3OMSysEE0d9j1bcxKP3luGDsolM8SYHZi1Sr3xy2uxGdjLaOOE7tK3whYY955BhffWOTcSwiu3jqaiMs6EdaBlSs7ZrMtJU6ic9ka/gyrarhJltQNKlWF071hKw2efGfxUOpcCjUtNypE/au4jqlDCJq3Gh/omJYH2Hr66+S/tSLz+pwdAQF0Bzn7vIsEIXTe7kcC8xyaPfV4lOAzcpXyLDBkkg+vw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAWPR03MB9246.eurprd03.prod.outlook.com (2603:10a6:102:342::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 19:03:43 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5654.014; Mon, 26 Sep 2022
 19:03:43 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v5 7/9] powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G
Date:   Mon, 26 Sep 2022 15:03:19 -0400
Message-Id: <20220926190322.2889342-8-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220926190322.2889342-1-sean.anderson@seco.com>
References: <20220926190322.2889342-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0019.namprd15.prod.outlook.com
 (2603:10b6:207:17::32) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAWPR03MB9246:EE_
X-MS-Office365-Filtering-Correlation-Id: c30052e6-75e6-4df7-d2ff-08da9ff1d4f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vvGxOg0mCo6kl7sC1k86O919TUAPisT/U2nPUTmkKL8i56FVC5uSedCsB4ayBC+gh+vlnvcr7vcmtwpzxGrO3vpaQ9O80MWH9QtSvLWiFQTDKgMBJZVah12NYXVJ5qDhxrommJC2DZ2w7NOZKBTCffWYkE/lNU3a5Lh13i1BKadc4lIt6iFj+ab1urXB1lhtfF9zg5JFql1plAU1dY4f2fRRHGX+F+mo8kn9JFipwrS/sTKVwXYAodFvBNqIgxTGxEfu15vV+EyZfEKCcFZm2MrtumumxJY2OcyIZTHwa0hmbTDbOlpgmzQBOYSkof/NOwJmV2ZY2h+g3usCYtd9ol1yZP3y8k5JqXs7rQuybk9LlvjncFKuYDnrepjE6SbYq36h+h9GNJmJC5MFvWMX8+42S61TxIHXQqRLdPBxf/zp7CnsSBkCBO6R998zuszyW6XZTz4+uP+8LtXUi80p9D+cWENraRlY647Cqt3rH4G7JvaE4i6+MrrHgc4TQ46lFJwAAI+eSl3q81KmaT82q9rWPHoDouzkITHwGaN1UZ2GWW/vqFbr2wCb0FdkLw+emgXs1iG2PPUwTvhGBS9CLZ17EM9tXBg4Q8py5mitCpjFh3VV5nzFuFbenoHrGV+3Ubg+bo2ffKXRUfYFnyNwHnz5MQNf17mlooOnQwGLbynMa8gBuWj3DBUgidClRptGw/I6LDn0MUYhTqt18jZIBGtuIk+gus9xBSLKlZl5nKwIxwm4B7P809decugxl43VwNeG3/NHE8nm+UHNg5asQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(39850400004)(346002)(451199015)(36756003)(86362001)(66946007)(66476007)(66556008)(6486002)(110136005)(54906003)(4326008)(316002)(478600001)(38350700002)(38100700002)(41300700001)(6666004)(8676002)(5660300002)(7416002)(44832011)(6512007)(26005)(2616005)(2906002)(1076003)(186003)(83380400001)(8936002)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rG5U4Ibq4TNGoPK1W23YDCws1ofNUb3GUuOt+HMASCDGHx1s0BsoVm9X7J9u?=
 =?us-ascii?Q?IlkTL+pfpTstuze4RoVXh+tOa8ix0M8ajWnKmhi7Jcj8jAFePD4o7nfRx7qG?=
 =?us-ascii?Q?5GVKebKL9d+wA/2fXqnik4Ims3t1SUXs5ZA1EmvCnO1rGDYlb/QUXh0/5NOS?=
 =?us-ascii?Q?mCuVeueUI8sV9HJehBG0zWWLasoLKKbLavL0Wqv57A79+sk8ck8C6vOONB4T?=
 =?us-ascii?Q?B0RR1wx9ACSZc97d/l82TtlFKgPZm9r2U94rtn5FUdYPRV1cxVpwYziLmHOT?=
 =?us-ascii?Q?yC5E/eEkGrXljISsNhann3wk6JZFXgLotMQxxkQsOUvhHujE0lL/zhyk/Iwh?=
 =?us-ascii?Q?EgzvTYmQshAVNLKeOpHxIcPaDlbyhmMKVvpJs3ZpT7wn0wmTlcOddcsXEESf?=
 =?us-ascii?Q?C2fz53LU+HJfm9PXnbvMz+f9vIPQ0alkPta9aHE8ZRHxuPiRZt2/lQJpLQmR?=
 =?us-ascii?Q?Y9xi8zWACln4YMItjdXTNT5B+o4Zg5Wg4vdcM1p5krhkHBpHY1WApnQ7tUzK?=
 =?us-ascii?Q?yUWcVltZBlyJ6S3x8YZYVRUvTfjgSeqlchhmzwXCydVVi7wL3l8ORXTcTUQw?=
 =?us-ascii?Q?+k1ZBpxZJ7Dg3UfQ3w3Up1O8/K2nI/S7VCvC5iRsQl8M42AwcYszxoKxfZlG?=
 =?us-ascii?Q?ALDKikessEaOaAGLdOSi4vPeT/o5gEu2jVmD+iOORDBggsZP2MCCjpiwTKw8?=
 =?us-ascii?Q?/8u0K7FKmXNRbyRFeDUG+p+kNbYx2vz8meaA5afy5c5Le/nTLXCqrPV+o6Xn?=
 =?us-ascii?Q?uE3VBA7wuouvVI7vA/okLGpJafHxEaW5YFGI3SQSK2nSnYfk7fSg9h3yd/Y7?=
 =?us-ascii?Q?YrmyttHzmEQxAgLVenmtTxwIaLSuq+T9aTMQjmP5pwPGc/YvGUZZSQqpatLY?=
 =?us-ascii?Q?GlDEYLE1hHGYQyCf7bbhEVG35hGII2VvYm/85/Qq/ZcYmG/HGz2I9JY2mQjK?=
 =?us-ascii?Q?GNWEHmKEKCIMz/O+wJPp31WOjdsJ4naVtRLiC6CiFVuNA3Uc4ZkcY5SDfidN?=
 =?us-ascii?Q?V0YoPNno0pisJMkKimHtbDIdwM81ezURbB0JqCjfcHHMjMyoWGC2sSaFjlra?=
 =?us-ascii?Q?AMzZquY87ObN6u5LQH3ViqHem5FLPmCP7U/n02KVERjGvcplxW/qWDY2knmh?=
 =?us-ascii?Q?MBqh+HD06W7dri1nR7uoUSy3LM//ncUA8a4mB30aJ+bPX9Ycw7nh3Zjn+x+5?=
 =?us-ascii?Q?pyoj5jwYCzv4nhiRACWpxAglI/lAjnsXjdnPKH39TasSoIt0xeIy9CSsRy8P?=
 =?us-ascii?Q?erOdWlQRo10OwTkNzHKkx/bJxvnT/iNTesLoqowlkOrTTFSdECm0GU2VJALq?=
 =?us-ascii?Q?i8YqcYvr9jsNbE9WvQLBUn725YUHQzGNYliRFGJZKOyiGPE2Z2/p7L1Q6c+U?=
 =?us-ascii?Q?rN/gdYP7o7pCR77rrid/XxwR3anFLtKEOj1ruGu7p3I/MBWerG81L6t5lm7Z?=
 =?us-ascii?Q?IiEhrbhXQXfITqWA54xGOfWg3WizFK4d69Hb/o6WjRB0ZTClREdQPFDEv6qi?=
 =?us-ascii?Q?A7HznBBdowIl686+4maWcGul9v/XG2WYb9+vGFSF3QiasdGohP/aQ2Uu0bKI?=
 =?us-ascii?Q?0jRjcSxYrkil9g8eNF3nuayRGlCaEl9grKCpWvVrrVBBSyluHaYN07Fhg6v0?=
 =?us-ascii?Q?qg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c30052e6-75e6-4df7-d2ff-08da9ff1d4f1
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 19:03:43.6305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N527S0yg+rH4hGHOQ8yDIwst3sTqCHUxNMWE12HDbDqy5wXcTfWW+PGXcHPKXOUXaf2/UR1TJckGiW8vlWClHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR03MB9246
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

