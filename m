Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7AA3FA090
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 22:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhH0U2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 16:28:34 -0400
Received: from mail-vi1eur05on2069.outbound.protection.outlook.com ([40.107.21.69]:32769
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230171AbhH0U2b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 16:28:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bO5L97AU1DkQD7l+YeWJnUPriPQ+snE5B5jqAGSNC9krgr1NEayy0keLa7C3zcoKa2mDKnsH9DS+PQJzuxwVxaoy37z9s38Y5UHNnMpgjn52owO9iERcAwFfYdw6wvw8Au1Q82V9bLgC/NVGxAqeXQsGz5dVcaP397nicnkKVNpSKY+hWExo22saudr5X/VUMp54laCTpgKivXLwgW9NIye8QVK+0dZa+Nbd4uvIi888ym4P+msvxO9DA3daDGV5lzhjDeygxMSfv1Vk3lC5WHlpixdTBfMYvMxv3TF+xJkHoUMxmqvW3IyMEy1Qh7z0WkloN884ueabZbc5dRNqbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+ZF+s7CFVjgjT0/7UH1ahzVkV6Z2zUxukSCilgRu1U=;
 b=DiTUi4b2yiEUfpJuxBUYV+c8+gEdvrQ0kUCpKGM7ozhNO3ETD59U6JrUkIiGoBAqqqQ0RfhhN4QKVk9QSm9W+xAtAVVxKhB8z8cOLJPpuc79tg3y8xuPXKr5MzX+AM0dhzKqEOKPwQPyU/7ZuXDkRidBawTIKer+rbBcwntqA5qruC4tYw0UvHzHvDQ2AMfylhwa7Nz0DRZND97w4tTt3V59KNFDxZGivn8RZvB/pQoFBlUatplGuNgiJyEzkrbo8HNkUHsjEnoUX0C+Zp48mybZr9L+KclNuZVtWernNc4NpfjzfMk4pirAZzxVHGvR2QMLFLg4WjhPnjhaFfRT4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+ZF+s7CFVjgjT0/7UH1ahzVkV6Z2zUxukSCilgRu1U=;
 b=VERhAVECQLkwcmniojLucWGWezt2GRkGCxNXMTh74PnO3Jvldt216lVTPbikOJU+KHicgfjStSt+9JgvdbOh75VLcI/1GxZvpY6ZR/QnWIpEVkBpInEl5/pAmdAz9wYBmob6VzmOz0b/p0FuJhdY2L7wRflhIdCfSbEZbCsSM5c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7374.eurprd04.prod.outlook.com (2603:10a6:800:1ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Fri, 27 Aug
 2021 20:27:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.027; Fri, 27 Aug 2021
 20:27:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, Wasim Khan <wasim.khan@nxp.com>,
        Vabhav Sharma <vabhav.sharma@nxp.com>,
        Kuldeep Singh <kuldeep.singh@nxp.com>,
        Florin Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Biwen Li <biwen.li@nxp.com>,
        Heinz Wrobel <Heinz.Wrobel@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH devicetree 2/2] arm64: dts: add device tree for the LX2160A on the NXP BlueBox3 board
Date:   Fri, 27 Aug 2021 23:27:22 +0300
Message-Id: <20210827202722.2567687-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210827202722.2567687-1-vladimir.oltean@nxp.com>
References: <20210827202722.2567687-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0051.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::40) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by VI1P194CA0051.EURP194.PROD.OUTLOOK.COM (2603:10a6:803:3c::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Fri, 27 Aug 2021 20:27:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db791792-11fe-4f8d-81b1-08d969991c99
X-MS-TrafficTypeDiagnostic: VE1PR04MB7374:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB737480C7549D381367C3EBA6E0C89@VE1PR04MB7374.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rXMrU4ojS1Qo4Q2F9R91VpkSCyzUu6syi89UiY6pwO50QWdPJkITA2Z5NxeTIFaKgcW82009Vp6OacRKNlcfJ57ubwS7i7dzK2ZlBMqQrNRiFALPbFWVmOAkfeDEiHOk15HRZyqTcEbJAaAlqMkfSQCBysBABzjBW5aoak9YDJtYbPTm4TT7MLS7EKpdSOHM8RivqUbmy4oQa726Wl0NxEyuifKwdZhLAJ+JtZriTObtJQJr1YiLNBRzS2yxWW5/zaxBqS17mVmS7QhNvKVQRZLb9e0jVPWL3zPxy8vzqPV3psS/HhUCnR0e+r7jTU8MY2SJjfM1DmEVZjYfzAGYhklt/XFJ9o8/RYnJj+GFFAo867tJS3mHsN+yP9JGVyLWNWCDAeKdyY15BaOL01AKL8P32NQHav89Rd9g1bAbO2OGa8DI3Sb+eRPVa4QEK0o12KLF+En46f81Iy8Ygij93pwkui0JOBK4DK3VBEnVdskA2wp2kplhoo3Hd5gBvvdehm6EIioGfAmtsCJ5BvGu1vEG5sH3FOx8OKY4C3cZ3rHTTEp6ogu1ukIxhuFL83oTh5OAPhvpLZNFhcA85MDzcAh51k+Lh4/2tzJOkUenyGlCcgtcBuMTlKlwWzeMhtYBQikmlVnPNtv+QMqcK4vB28OR0rqIQlnnAIz4hAZnrejWRbIQDKwOTcQ5wKLAPeZmxm1g1gyv15mxtmCIQ63hcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(376002)(136003)(346002)(366004)(2616005)(38100700002)(38350700002)(66556008)(8936002)(66946007)(956004)(6486002)(1076003)(26005)(316002)(4326008)(5660300002)(54906003)(8676002)(66476007)(44832011)(478600001)(186003)(83380400001)(36756003)(30864003)(86362001)(2906002)(6512007)(6666004)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FDi+9w4SsZz6ilU1ZmpDHuHL1OWImiuT1hOfbdyNadPLTJMQJhDDPzAgpRrp?=
 =?us-ascii?Q?3CpXl8mKGdaUdK98nv3hIw6yzcg41gNpa3Q/bAPpm2IKNNqhVivWGwcNLDlX?=
 =?us-ascii?Q?His37AdxNfOnuxWjMdNH3tAlJsHYZjSsUKVAGi6HdJTbUGGUrBNResRlDzFR?=
 =?us-ascii?Q?wOMwfXC9TWq1qUR2gkBFsIQtdKqzM98VL1EjrzHTRW3iZaw2aFCKlI9objkZ?=
 =?us-ascii?Q?Ilaqs5PK842v2BxEbdO41UNjzpsp872aSakxknCRB/mC4Oa+Ed06p0gIuABi?=
 =?us-ascii?Q?LMkpjI4Xhaxz/NCczTVkJfMs1yuLEGKaB321zLj1ar9OXKjz/6HC9LTAJ2Ce?=
 =?us-ascii?Q?N5vA1l1jU3B0zhh0VYUWCxjh56AkIErFDGHxNmBCFvU65t0zNTJ9xM+jP4Nc?=
 =?us-ascii?Q?+T6yYM66BTtdEqsgAuC+oLIHZSiY4fo5MKzwt0dTowsrFtEsWAlIHacfmoma?=
 =?us-ascii?Q?TGKuv+7Jcq2bGSPI9ECHHsVAMzwMmTeXknEEye8zIqU/kL7Zq/IaCq9xjX9w?=
 =?us-ascii?Q?vNvGr/oP7FMrdX2RTzbzAUMTM7uxW5tO8ihTC+PVyUUnaX79ZT0NbJNis7ex?=
 =?us-ascii?Q?Pm8hd3A8G8sLnRBXQfgVAdEfM34NiV5izd+xPEXBQHpUDCQgFZVwzhaaNpx3?=
 =?us-ascii?Q?OmYhZ8oY+QSwNjkgVAJchFsyGoYm7z9h9SjAVhrKdmZF6RBp0AhzfcMxnL87?=
 =?us-ascii?Q?chY3ecoBKct0TNgUQrhBVdTN4H7ng8UnDtQTtH2v8RUTQhPEaIMe3fJL7y5P?=
 =?us-ascii?Q?6KIv2JoWw7x66rCnPZv36/Ycuj3P4P7qUhBRRvFeMbqAxU4+OToEbqLJuoG5?=
 =?us-ascii?Q?KHLlJ1UjSymGgth+V37BgM6kl3BKrdUaqLbF5MNY/8IyxyD+LfQW6XE598D9?=
 =?us-ascii?Q?KS6BZiIxDArUIuZMx7xmXJ+Zzlew+Go781PjvB2huUsFnISJKUxWvDLFnjg1?=
 =?us-ascii?Q?NOJ0YOBkW0m3wXhK9LaoJMjlJ5N6fBpCiZHbXmjD+Xm0i8vRRspBTCpuBuar?=
 =?us-ascii?Q?uSz3X2d7xbWzrWh87Uh3v/UlehcpxUEBi0m2rN8/l0Mld2NZGizNZRyLnwVn?=
 =?us-ascii?Q?+wfBo1updiwLHuVetHTgAtPHbyGL8vCsRyu6rNxPSyOLhJ93EG0r89YEZelG?=
 =?us-ascii?Q?wwjLGtJcGU+Io9Arl03MxArGzfr9ew+QVOpwy7JSY5kwoBtpTpUziojGKD6c?=
 =?us-ascii?Q?zAOb0CMLyY0oihFbcfI9rtBBVJCsoBydndRX1G/gUwfi4f7zv3+so4XRz/2O?=
 =?us-ascii?Q?6F18LY0Z6pMNIY34R2XSL5Ejm35PXaCnVEW56B8tcLtuyTDFUVaMLZBMf+xu?=
 =?us-ascii?Q?PJ7ss09LxW1RTA4n5BY0Dn4L?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db791792-11fe-4f8d-81b1-08d969991c99
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 20:27:38.3209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jAg86JJWgscrl7JMQPa+6o5lxfsFBKaBEBKx8H5mqkTyMWqZAbuteTLM8tax9IXkA0g3APX160EaAVzcAKd9Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7374
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wasim Khan <wasim.khan@nxp.com>

The NXP BlueBox3 is a prototyping board for high-performance autonomous
driving systems. It contains two Linux systems, on running on the
LX2160A and the other on the S32G2 SoC. This patch adds the device tree
support for the LX2160A SoC.

In terms of networking from the LX2160A's perspective, there are:

- 4 RJ45 10G ports using Aquantia copper PHYs which are attached
  directly to DPAA2 ports on the LX2160A

- 3 NXP SJA1110 automotive Ethernet switches. First two are managed by
  the LX2160A (each switch has a host port towards a dpmac), the third
  switch is managed by the S32G2. All 3 switches are interconnected
  through on-board SERDES lanes. The cascade ports between the 2
  switches managed by LX2160A form a DSA link, the cascade ports between
  the LX2160A and the S32G2 domain form user ports (the "to_sw3" net
  device).

- 2 RJ45 1G ports using Atheros copper PHYs which are attached directly
  to NXP SJA1110 switches

- 12 automotive 100base-T1 single-pair Ethernet ports routed from the
  SJA1110 internal PHY ports (TJA1103)

- One SGMII SERDES lane towards an internal connector, attached to one
  of the SJA1110 switch ports

On board rev A, the AR8035 RGMII PHY addresses were different than on
rev B and later. This patch introduces a separate device tree for rev A.
The main device tree is supposed to cover rev B and later.

Signed-off-by: Wasim Khan <wasim.khan@nxp.com>
Co-developed-by: Vabhav Sharma <vabhav.sharma@nxp.com>
Signed-off-by: Vabhav Sharma <vabhav.sharma@nxp.com>
Co-developed-by: Kuldeep Singh <kuldeep.singh@nxp.com>
Signed-off-by: Kuldeep Singh <kuldeep.singh@nxp.com>
Co-developed-by: Florin Chiculita <florinlaurentiu.chiculita@nxp.com>
Signed-off-by: Florin Chiculita <florinlaurentiu.chiculita@nxp.com>
Co-developed-by: Biwen Li <biwen.li@nxp.com>
Signed-off-by: Biwen Li <biwen.li@nxp.com>
Co-developed-by: Heinz Wrobel <Heinz.Wrobel@nxp.com>
Signed-off-by: Heinz Wrobel <Heinz.Wrobel@nxp.com>
Co-developed-by: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Co-developed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 arch/arm64/boot/dts/freescale/Makefile        |   2 +
 .../freescale/fsl-lx2160a-bluebox3-rev-a.dts  |  34 +
 .../dts/freescale/fsl-lx2160a-bluebox3.dts    | 658 ++++++++++++++++++
 3 files changed, 694 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3-rev-a.dts
 create mode 100644 arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts

diff --git a/arch/arm64/boot/dts/freescale/Makefile b/arch/arm64/boot/dts/freescale/Makefile
index db9e36ebe932..ecf74464705f 100644
--- a/arch/arm64/boot/dts/freescale/Makefile
+++ b/arch/arm64/boot/dts/freescale/Makefile
@@ -25,6 +25,8 @@ dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls2080a-rdb.dtb
 dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls2080a-simu.dtb
 dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls2088a-qds.dtb
 dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls2088a-rdb.dtb
+dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-lx2160a-bluebox3.dtb
+dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-lx2160a-bluebox3-rev-a.dtb
 dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-lx2160a-clearfog-cx.dtb
 dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-lx2160a-honeycomb.dtb
 dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-lx2160a-qds.dtb
diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3-rev-a.dts b/arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3-rev-a.dts
new file mode 100644
index 000000000000..15d273c93154
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3-rev-a.dts
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+//
+// Device Tree file for LX2160A BLUEBOX3
+//
+// Copyright 2020-2021 NXP
+
+/dts-v1/;
+
+#include "fsl-lx2160a-bluebox3.dts"
+
+/ {
+	compatible = "fsl,lx2160a-bluebox3-rev-a", "fsl,lx2160a";
+};
+
+/* The RGMII PHYs have a different MDIO address */
+&emdio1 {
+	/delete-node/ ethernet-phy@5;
+
+	sw1_mii3_phy: ethernet-phy@1 {
+		/* AR8035 */
+		compatible = "ethernet-phy-id004d.d072";
+		reg = <0x1>;
+		interrupts-extended = <&extirq 6 IRQ_TYPE_LEVEL_LOW>;
+	};
+
+	/delete-node/ ethernet-phy@6;
+
+	sw2_mii3_phy: ethernet-phy@2 {
+		/* AR8035 */
+		compatible = "ethernet-phy-id004d.d072";
+		reg = <0x2>;
+		interrupts-extended = <&extirq 7 IRQ_TYPE_LEVEL_LOW>;
+	};
+};
diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts b/arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts
new file mode 100644
index 000000000000..be7d01630a6f
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts
@@ -0,0 +1,658 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+//
+// Device Tree file for LX2160A BLUEBOX3
+//
+// Copyright 2020-2021 NXP
+
+/dts-v1/;
+
+#include "fsl-lx2160a.dtsi"
+
+/ {
+	model = "NXP Layerscape LX2160ABLUEBOX3";
+	compatible = "fsl,lx2160a-bluebox3", "fsl,lx2160a";
+
+	aliases {
+		crypto = &crypto;
+		serial0 = &uart0;
+		mmc0 = &esdhc0;
+		mmc1 = &esdhc1;
+	};
+
+	chosen {
+		stdout-path = "serial0:115200n8";
+	};
+
+	sb_3v3: regulator-sb3v3 {
+		compatible = "regulator-fixed";
+		regulator-name = "MC34717-3.3VSB";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-boot-on;
+		regulator-always-on;
+	};
+};
+
+&can0 {
+	status = "okay";
+
+	can-transceiver {
+		max-bitrate = <5000000>;
+	};
+};
+
+&can1 {
+	status = "okay";
+
+	can-transceiver {
+		max-bitrate = <5000000>;
+	};
+};
+
+&crypto {
+	status = "okay";
+};
+
+&dpmac5 {
+	phy-handle = <&aqr113c_phy1>;
+	phy-mode = "usxgmii";
+	managed = "in-band-status";
+};
+
+&dpmac6 {
+	phy-handle = <&aqr113c_phy2>;
+	phy-mode = "usxgmii";
+	managed = "in-band-status";
+};
+
+&dpmac9 {
+	phy-handle = <&aqr113c_phy3>;
+	phy-mode = "usxgmii";
+	managed = "in-band-status";
+};
+
+&dpmac10 {
+	phy-handle = <&aqr113c_phy4>;
+	phy-mode = "usxgmii";
+	managed = "in-band-status";
+};
+
+&dpmac17 {
+	phy-mode = "rgmii";
+	status = "okay";
+
+	fixed-link {
+		speed = <1000>;
+		full-duplex;
+	};
+};
+
+&dpmac18 {
+	phy-mode = "rgmii";
+	status = "okay";
+
+	fixed-link {
+		speed = <1000>;
+		full-duplex;
+	};
+};
+
+&emdio1 {
+	status = "okay";
+
+	aqr113c_phy2: ethernet-phy@0 {
+		compatible = "ethernet-phy-ieee802.3-c45";
+		reg = <0x0>;
+		/* IRQ_10G_PHY2 */
+		interrupts-extended = <&extirq 3 IRQ_TYPE_LEVEL_LOW>;
+	};
+
+	aqr113c_phy1: ethernet-phy@8 {
+		compatible = "ethernet-phy-ieee802.3-c45";
+		reg = <0x8>;
+		/* IRQ_10G_PHY1 */
+		interrupts-extended = <&extirq 2 IRQ_TYPE_LEVEL_LOW>;
+	};
+
+	sw1_mii3_phy: ethernet-phy@5 {
+		/* AR8035 */
+		compatible = "ethernet-phy-id004d.d072";
+		reg = <0x5>;
+		interrupts-extended = <&extirq 6 IRQ_TYPE_LEVEL_LOW>;
+	};
+
+	sw2_mii3_phy: ethernet-phy@6 {
+		/* AR8035 */
+		compatible = "ethernet-phy-id004d.d072";
+		reg = <0x6>;
+		interrupts-extended = <&extirq 7 IRQ_TYPE_LEVEL_LOW>;
+	};
+};
+
+&emdio2 {
+	status = "okay";
+
+	aqr113c_phy4: ethernet-phy@0 {
+		compatible = "ethernet-phy-ieee802.3-c45";
+		reg = <0x0>;
+		/* IRQ_10G_PHY4 */
+		interrupts-extended = <&extirq 5 IRQ_TYPE_LEVEL_LOW>;
+	};
+
+	aqr113c_phy3: ethernet-phy@8 {
+		compatible = "ethernet-phy-ieee802.3-c45";
+		reg = <0x8>;
+		/* IRQ_10G_PHY3 */
+		interrupts-extended = <&extirq 4 IRQ_TYPE_LEVEL_LOW>;
+	};
+};
+
+&esdhc0 {
+	sd-uhs-sdr104;
+	sd-uhs-sdr50;
+	sd-uhs-sdr25;
+	sd-uhs-sdr12;
+	status = "okay";
+};
+
+&esdhc1 {
+	mmc-hs200-1_8v;
+	mmc-hs400-1_8v;
+	bus-width = <8>;
+	status = "okay";
+};
+
+&fspi {
+	status = "okay";
+
+	mt35xu512aba0: flash@0 {
+		compatible = "jedec,spi-nor";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0>;
+		m25p,fast-read;
+		spi-max-frequency = <50000000>;
+		spi-rx-bus-width = <8>;
+		spi-tx-bus-width = <8>;
+	};
+
+	mt35xu512aba1: flash@1 {
+		compatible = "jedec,spi-nor";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <1>;
+		m25p,fast-read;
+		spi-max-frequency = <50000000>;
+		spi-rx-bus-width = <8>;
+		spi-tx-bus-width = <8>;
+	};
+};
+
+&i2c0 {
+	status = "okay";
+
+	i2c-mux@77 {
+		compatible = "nxp,pca9547";
+		reg = <0x77>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		i2c@2 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x2>;
+
+			power-monitor@40 {
+				compatible = "ti,ina220";
+				reg = <0x40>;
+				shunt-resistor = <500>;
+			};
+		};
+
+		i2c@3 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x3>;
+
+			temp2: temperature-sensor@48 {
+				compatible = "nxp,sa56004";
+				reg = <0x48>;
+				vcc-supply = <&sb_3v3>;
+				#thermal-sensor-cells = <1>;
+			};
+
+			temp1: temperature-sensor@4c {
+				compatible = "nxp,sa56004";
+				reg = <0x4c>;
+				vcc-supply = <&sb_3v3>;
+				#thermal-sensor-cells = <1>;
+			};
+		};
+
+		i2c@4 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x4>;
+
+			rtc@51 {
+				compatible = "nxp,pcf2129";
+				reg = <0x51>;
+				interrupts-extended = <&extirq 11 IRQ_TYPE_LEVEL_LOW>;
+			};
+		};
+
+		i2c@7 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x7>;
+
+			i2c-mux@75 {
+				compatible = "nxp,pca9547";
+				reg = <0x75>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				i2c@0 {
+					#address-cells = <1>;
+					#size-cells = <0>;
+					reg = <0x0>;
+
+					spi_bridge: spi@28 {
+						compatible = "nxp,sc18is602b";
+						reg = <0x28>;
+						#address-cells = <1>;
+						#size-cells = <0>;
+					};
+				};
+			};
+		};
+	};
+};
+
+&i2c5 {
+	status = "okay";
+
+	i2c-mux@77 {
+		compatible = "nxp,pca9846";
+		reg = <0x77>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		i2c@1 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x1>;
+
+			/* The I2C multiplexer and temperature sensors are on
+			 * the T6 riser card.
+			 */
+			i2c-mux@70 {
+				compatible = "nxp,pca9548";
+				reg = <0x70>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				i2c@6 {
+					#address-cells = <1>;
+					#size-cells = <0>;
+					reg = <0x6>;
+
+					q12: temperature-sensor@4c {
+						compatible = "nxp,sa56004";
+						reg = <0x4c>;
+						vcc-supply = <&sb_3v3>;
+						#thermal-sensor-cells = <1>;
+					};
+				};
+
+				i2c@7 {
+					#address-cells = <1>;
+					#size-cells = <0>;
+					reg = <0x7>;
+
+					q11: temperature-sensor@4c {
+						compatible = "nxp,sa56004";
+						reg = <0x4c>;
+						vcc-supply = <&sb_3v3>;
+						#thermal-sensor-cells = <1>;
+					};
+
+					q13: temperature-sensor@48 {
+						compatible = "nxp,sa56004";
+						reg = <0x48>;
+						vcc-supply = <&sb_3v3>;
+						#thermal-sensor-cells = <1>;
+					};
+
+					q14: temperature-sensor@4a {
+						compatible = "nxp,sa56004";
+						reg = <0x4a>;
+						vcc-supply = <&sb_3v3>;
+						#thermal-sensor-cells = <1>;
+					};
+				};
+			};
+		};
+	};
+};
+
+&pcs_mdio5 {
+	status = "okay";
+};
+
+&pcs_mdio6 {
+	status = "okay";
+};
+
+&pcs_mdio9 {
+	status = "okay";
+};
+
+&pcs_mdio10 {
+	status = "okay";
+};
+
+&spi_bridge {
+	sw1: ethernet-switch@0 {
+		compatible = "nxp,sja1110a";
+		reg = <0>;
+		spi-max-frequency = <4000000>;
+		spi-cpol;
+		dsa,member = <0 0>;
+
+		ethernet-ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			/* Microcontroller port */
+			port@0 {
+				reg = <0>;
+				status = "disabled";
+			};
+
+			/* SW1_P1 */
+			port@1 {
+				reg = <1>;
+				label = "con_2x20";
+				phy-mode = "sgmii";
+
+				fixed-link {
+					speed = <1000>;
+					full-duplex;
+				};
+			};
+
+			port@2 {
+				reg = <2>;
+				ethernet = <&dpmac17>;
+				phy-mode = "rgmii-id";
+
+				fixed-link {
+					speed = <1000>;
+					full-duplex;
+				};
+			};
+
+			port@3 {
+				reg = <3>;
+				label = "1ge_p1";
+				phy-mode = "rgmii-id";
+				phy-handle = <&sw1_mii3_phy>;
+			};
+
+			sw1p4: port@4 {
+				reg = <4>;
+				link = <&sw2p1>;
+				phy-mode = "sgmii";
+
+				fixed-link {
+					speed = <1000>;
+					full-duplex;
+				};
+			};
+
+			port@5 {
+				reg = <5>;
+				label = "trx1";
+				phy-mode = "internal";
+				phy-handle = <&sw1_port5_base_t1_phy>;
+			};
+
+			port@6 {
+				reg = <6>;
+				label = "trx2";
+				phy-mode = "internal";
+				phy-handle = <&sw1_port6_base_t1_phy>;
+			};
+
+			port@7 {
+				reg = <7>;
+				label = "trx3";
+				phy-mode = "internal";
+				phy-handle = <&sw1_port7_base_t1_phy>;
+			};
+
+			port@8 {
+				reg = <8>;
+				label = "trx4";
+				phy-mode = "internal";
+				phy-handle = <&sw1_port8_base_t1_phy>;
+			};
+
+			port@9 {
+				reg = <9>;
+				label = "trx5";
+				phy-mode = "internal";
+				phy-handle = <&sw1_port9_base_t1_phy>;
+			};
+
+			port@a {
+				reg = <10>;
+				label = "trx6";
+				phy-mode = "internal";
+				phy-handle = <&sw1_port10_base_t1_phy>;
+			};
+		};
+
+		mdios {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			mdio@0 {
+				compatible = "nxp,sja1110-base-t1-mdio";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0>;
+
+				sw1_port5_base_t1_phy: ethernet-phy@1 {
+					compatible = "ethernet-phy-ieee802.3-c45";
+					reg = <0x1>;
+				};
+
+				sw1_port6_base_t1_phy: ethernet-phy@2 {
+					compatible = "ethernet-phy-ieee802.3-c45";
+					reg = <0x2>;
+				};
+
+				sw1_port7_base_t1_phy: ethernet-phy@3 {
+					compatible = "ethernet-phy-ieee802.3-c45";
+					reg = <0x3>;
+				};
+
+				sw1_port8_base_t1_phy: ethernet-phy@4 {
+					compatible = "ethernet-phy-ieee802.3-c45";
+					reg = <0x4>;
+				};
+
+				sw1_port9_base_t1_phy: ethernet-phy@5 {
+					compatible = "ethernet-phy-ieee802.3-c45";
+					reg = <0x5>;
+				};
+
+				sw1_port10_base_t1_phy: ethernet-phy@6 {
+					compatible = "ethernet-phy-ieee802.3-c45";
+					reg = <0x6>;
+				};
+			};
+		};
+	};
+
+	sw2: ethernet-switch@2 {
+		compatible = "nxp,sja1110a";
+		reg = <2>;
+		spi-max-frequency = <4000000>;
+		spi-cpol;
+		dsa,member = <0 1>;
+
+		ethernet-ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			/* Microcontroller port */
+			port@0 {
+				reg = <0>;
+				status = "disabled";
+			};
+
+			sw2p1: port@1 {
+				reg = <1>;
+				link = <&sw1p4>;
+				phy-mode = "sgmii";
+
+				fixed-link {
+					speed = <1000>;
+					full-duplex;
+				};
+			};
+
+			port@2 {
+				reg = <2>;
+				ethernet = <&dpmac18>;
+				phy-mode = "rgmii-id";
+
+				fixed-link {
+					speed = <1000>;
+					full-duplex;
+				};
+			};
+
+			port@3 {
+				reg = <3>;
+				label = "1ge_p2";
+				phy-mode = "rgmii-id";
+				phy-handle = <&sw2_mii3_phy>;
+			};
+
+			port@4 {
+				reg = <4>;
+				label = "to_sw3";
+				phy-mode = "2500base-x";
+
+				fixed-link {
+					speed = <2500>;
+					full-duplex;
+				};
+			};
+
+			port@5 {
+				reg = <5>;
+				label = "trx7";
+				phy-mode = "internal";
+				phy-handle = <&sw2_port5_base_t1_phy>;
+			};
+
+			port@6 {
+				reg = <6>;
+				label = "trx8";
+				phy-mode = "internal";
+				phy-handle = <&sw2_port6_base_t1_phy>;
+			};
+
+			port@7 {
+				reg = <7>;
+				label = "trx9";
+				phy-mode = "internal";
+				phy-handle = <&sw2_port7_base_t1_phy>;
+			};
+
+			port@8 {
+				reg = <8>;
+				label = "trx10";
+				phy-mode = "internal";
+				phy-handle = <&sw2_port8_base_t1_phy>;
+			};
+
+			port@9 {
+				reg = <9>;
+				label = "trx11";
+				phy-mode = "internal";
+				phy-handle = <&sw2_port9_base_t1_phy>;
+			};
+
+			port@a {
+				reg = <10>;
+				label = "trx12";
+				phy-mode = "internal";
+				phy-handle = <&sw2_port10_base_t1_phy>;
+			};
+		};
+
+		mdios {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			mdio@0 {
+				compatible = "nxp,sja1110-base-t1-mdio";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0>;
+
+				sw2_port5_base_t1_phy: ethernet-phy@1 {
+					compatible = "ethernet-phy-ieee802.3-c45";
+					reg = <0x1>;
+				};
+
+				sw2_port6_base_t1_phy: ethernet-phy@2 {
+					compatible = "ethernet-phy-ieee802.3-c45";
+					reg = <0x2>;
+				};
+
+				sw2_port7_base_t1_phy: ethernet-phy@3 {
+					compatible = "ethernet-phy-ieee802.3-c45";
+					reg = <0x3>;
+				};
+
+				sw2_port8_base_t1_phy: ethernet-phy@4 {
+					compatible = "ethernet-phy-ieee802.3-c45";
+					reg = <0x4>;
+				};
+
+				sw2_port9_base_t1_phy: ethernet-phy@5 {
+					compatible = "ethernet-phy-ieee802.3-c45";
+					reg = <0x5>;
+				};
+
+				sw2_port10_base_t1_phy: ethernet-phy@6 {
+					compatible = "ethernet-phy-ieee802.3-c45";
+					reg = <0x6>;
+				};
+			};
+		};
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&uart1 {
+	status = "okay";
+};
+
+&usb0 {
+	status = "okay";
+};
+
+&usb1 {
+	status = "okay";
+};
-- 
2.25.1

