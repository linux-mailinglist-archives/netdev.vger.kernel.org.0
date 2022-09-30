Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC685F1351
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbiI3UL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiI3UK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:10:58 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2041.outbound.protection.outlook.com [40.107.104.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5613511C157;
        Fri, 30 Sep 2022 13:10:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e9D8TuDAYrtBtheNv2wAJVCTMFummK1pmD/O0p0uuMvbTDfsRaFQT0w7jhgKAcLkr+4XqnIehv4vpx2v9fs+tXrlDZFTWRNzcCNJ9Y0PZ5Xcq43fV3sxhLVH3hs2qQAEv4Vdsvwj8ScGMftbI+8KiBqH6mvhgKBTQJhsBYGT11Zp2qG0gbZFJh93ib+gR8HIDH4hb7B2YC7wleKEjurHA8WuZq5dAj9dC7+cVXj1mDnXRGTwChbkrcuSuHGh3SEwB1xMjuClMGkO70mnJl+A/rNzCCcZTq1Mpej7w2ZYT1r6dkPskPvvnBnCRtY6m8qvMh8BHdYhU1SVRasLdETXSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EsdQEjx1Q6EFZ03LnTaNDwQemvWxkp4ZfpwjAwz4KCo=;
 b=JH87ZaO96/UwvMikxzj9qaHx3ktT2JubN4v0GvY5g27WLBaiHe4xIZ4PkKge6XYHMjTYR2dloadZPBNcftrNJAlmd6+ELIlsmIP8l1od1F+iSidq+SV1WM4DjExSJHC1qM3br7gUtYsUhH9ifo4g6zRTaQ+AFQJ1P6DemUF/5fH5+qhdIqK00yOEAFVapC7sYluEoqqWfjLsynUkGETn/20gK/QqorBRIw0qX83KlJV0Cuao3DEMVSXEbJOdb6DEHpxPNWw5b5BLqoPOPzn0j1zrh4X/K7vUmwHSw/6s32Y5pjTVzm1Oi8CK89KhQXX+6eRSnlJw1GIAXKOcPROpsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EsdQEjx1Q6EFZ03LnTaNDwQemvWxkp4ZfpwjAwz4KCo=;
 b=ZGxaBrbR3vkk/Z3Ycv/3ay/y76tKbTfXsQI//eUknJf3/jJxY5q/GwKt3VFW3ryKv+mq/e88Rwj5leBut7w64npVyXOvO3yRJwU2bThH78L41v0nnJrVlcM2DEmo+xQ5hQ6sRSn63qaZzIrXJ0bKK6eoYHL/Ms5JI6x8KEWn18cf0+oeAHBx2na2T7UVXi2ksmLZT6VyOq585uiVDIJGzQp7mDwO6x4eQ9G+moosvofAcq3iFcGTbAtBWoB2/R/YQv34XNYrawywPwqKttJ1zIkCNYue+rJebuTLD5y2FL2NaO4wMPUEsyGBmbTxguJJvnkI5aT1U6u7pMOWF6a3Tw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7749.eurprd03.prod.outlook.com (2603:10a6:20b:404::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 20:09:58 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 20:09:58 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v6 7/9] powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G
Date:   Fri, 30 Sep 2022 16:09:31 -0400
Message-Id: <20220930200933.4111249-8-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220930200933.4111249-1-sean.anderson@seco.com>
References: <20220930200933.4111249-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0144.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS8PR03MB7749:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a8b79d6-beca-4957-e11d-08daa31fbfdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cn0AzZh3uYJruMJeFp/9rJTLW/DfVkuxluazXsYdWZZ0Ct95KIbUxZhntICmkOL+L8GEy78L4T0tXhv8/yl3C/IUMEKYWeFxMlKTc6sEUdBktC280Dzvb03+FaNxJhzMkEI+FzAHEV2dS2qBIbgRthdsPwdNf1NHVrrfL/XjP17CMmK8LFW/myI6wR6OXite5EykN/qtEnmja68ji2s/vIuknxkvoBTw1NKwlVBqOkZcCVsweFvZlT1vDl1BnzFEvoFE6khwkx5+XDx84Wwf4ytQ70nxHo8yPqLIr4JiTb6MPwpDUZbhUcQsYlAXnJ1LRWte18cWg3w2n0qs8olRXsR1nt6D8awLGh5kBplh5f0wbmMr+iH9ZUVxHrGtJ49kRPvQQPcunW1xkALx05zQSYFtdXH/IOmS3jJYME/f9/nVVPI3jHZgMqJDCj9aIgMKS1kq+IKS6upho/rKCBQvwqAYS+ij6FQEejZNf7gFmU7j8ssfiHSf7534Hg2NmxANmXTfb7wR88VxlJMS4YrbnnRcUMqADZqg3xnPKUe/Fy2UPjiD0a6sbqHgBFGygu8aUW+eHvGwVQz6L07CAV0tjN5dofI+/DPfPDZoWB50oExAWzLAIazg7x51Rw3drwe034/7jC8YSOJ1xzG2ODaSiq3we9BbomlZpzOOr8KanHcc5RL4QpiKVuJirgj/arRzH3uOO8Uk8jNWXmCcIB2+Mlk9KnKibAYE6evpuCyS4hq3NyIZBlZ/2/oMMAqm84nung1qOLkzyaUbGgXOaZUjKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(396003)(346002)(39850400004)(451199015)(66946007)(2906002)(6666004)(38350700002)(38100700002)(8676002)(66476007)(66556008)(4326008)(83380400001)(41300700001)(36756003)(6486002)(6512007)(478600001)(6506007)(52116002)(26005)(110136005)(316002)(54906003)(186003)(1076003)(2616005)(86362001)(8936002)(7416002)(44832011)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j3aojaxRKeI0mcCk8vLMldJFpzxQ822xvvIbqnIK4xTbnmpGuvAecg5gWWqh?=
 =?us-ascii?Q?eaIyFJKYN5IT3tTeZRSQfuTSNREi8Ef7L0dXw/hr8GbO/+o12NlIx1SU/rLS?=
 =?us-ascii?Q?aiSk+qZiZplHP/9NYF04YZh+lreMjywwz2FkkNEmZPWW+8lTDX5kNRyQr9tC?=
 =?us-ascii?Q?5R1xKx2lq7jJHgfVDsnOWSHYwm2uDU4P8qq2uSn1sKc1y6iBht2bGDs1op+8?=
 =?us-ascii?Q?1aFdAlMz0gfzIso39i6+4p651jKOSlXT8wNOFxj5Rb3m7wC5/ZM/fE36LPfp?=
 =?us-ascii?Q?EmnQ3B77xB+Mg6gmxBR4E3oA8gizgo10+002szq9P6GL/IpyUA1GpHMQ69hY?=
 =?us-ascii?Q?lOB+GwVD1i+IC/OmliNhpPKf6ozVSPMU87GcJYhhLcQbYCpShvhKdZNC4cCQ?=
 =?us-ascii?Q?2kqFQx5TmvsCIP9vuMYz+6au99LEor8kY4AZeVuiuzSmjWoJN8BZvPVrIH6n?=
 =?us-ascii?Q?fudQHAsemyFtxKt9Cg/9FF9hc4h1V0sSKKx9+Slr1KLLk8xQLWRF9tPZK9U1?=
 =?us-ascii?Q?r6L/N+xRi0k1BNWVV1eO571IiNwYWwEUyhrlXqVu1EjVgzO/zEymfTotIIGj?=
 =?us-ascii?Q?bApt4NJ0zefErRawIbquIwqdknKUUMS9ZyE6cYwWoFVkNvZQ30AzNeuwoJoL?=
 =?us-ascii?Q?U2pvqLowUbpCwgwKjgS64FsVrlEEyMnLx3DxiO1/uyvO+OAMWzNccOSo7CAE?=
 =?us-ascii?Q?DzJuQDUD74ioEr5zFIqA8KCOfg5FOy/yrHtesGwizcoSkO68CLd5K3vxDcNv?=
 =?us-ascii?Q?dI5e/4bpYd2KgQ9etTTWtZ1wA+yyTLwjxq64tkxzH2EX1BDWnTo5zVPLYWRK?=
 =?us-ascii?Q?Zg8C96d5rxZ1c0XUMFWQsoebwfsPcOL0JXGN5D0Wx/jVcaZV7nSiK0SneDt8?=
 =?us-ascii?Q?4IgEaQHHfO/eB99i6cnDZTn81mNzQdoW6qpq67bR6Cj7veP1lxn4B89QXGyD?=
 =?us-ascii?Q?LOgEuEHbgaSNOHTi6xGFYWY9KqxmeoYNKHsj+FnSsAHZRMIo6qgO5NdVu1Zy?=
 =?us-ascii?Q?CotIUHIB/dAb8Q5Gv3Ip7th9/KKmpf6cI+5Wo+WRIB5JLZtXMxpQ+ZsGnuHK?=
 =?us-ascii?Q?2G5dekGeZpke7Lx5Dtq06nqMJhUUamf+4K87Gv/FFI2Yqbni8eH3SkYHSWVD?=
 =?us-ascii?Q?4LKKbE/wY4HcngByh5DcBt4xo7d05RgC58KifEgDgUr8wrxZVr9R6wuScjJp?=
 =?us-ascii?Q?iyiWSmTYsafccxGQi1l0UH2+Ge5z7iks6QHNJhGBaH+qwj+4Z99wJQQD0GNT?=
 =?us-ascii?Q?K3OL87Oy0qjUh6oVB6Yg8nOdNxUmJ/yvhSw4nSE6e9cLJMrVWuXgpyxV/1bJ?=
 =?us-ascii?Q?KkcVdHHhf8grVua4WlqRCK8t0QDmUctcHCqPgOo3QRTw3oH+N5YDQUYmf7J3?=
 =?us-ascii?Q?mb8RH57Bg3yQkJmI5lEn7wm6e/KydqWs3Me5HBzgvR/ng5inqk1fOr1T+Ws+?=
 =?us-ascii?Q?H/vFv/1pmLrirY1VZcMYrViorGEZR4w+94XwdbVSs1wI7j2wz53n7mc1t241?=
 =?us-ascii?Q?JnSAvbF2gaUQtc217fgAQAIbT3dT+PlRIzGSLE+1zaolhOEwg1FZognsC7Sm?=
 =?us-ascii?Q?IWQ+Rq/sJCBA8fUkOXlMAD1kfWqIXwH4rFuV1IySCeHG4bMK9jDA/VDJG3Gr?=
 =?us-ascii?Q?YA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a8b79d6-beca-4957-e11d-08daa31fbfdf
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 20:09:58.6499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FIRKc+m7iWdx47p/NG0KYI7oE9aE8T2kxo/Wbxxyl/PSwptAoISvhiP+orMJwPQ25MZseMcrV37PCPwPbwIJ5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7749
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
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

