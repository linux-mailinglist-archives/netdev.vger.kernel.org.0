Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3494CEF77
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbiCGCN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234726AbiCGCNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:13:44 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2104.outbound.protection.outlook.com [40.107.93.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AE21CFD8;
        Sun,  6 Mar 2022 18:12:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hoWrC8Xkve2otf/PvYdrZ0Qevx1ueMBrtesrxJpwZ15H0q0rd/eq3ES99seXWISUwgWbJPLc10nldq5ZCCLJ1/+Rp1G65aHP23eEEVLFryiXyet4CnfS7JN+FHjGAJHpad6wZ3DfQI2pP7MgDOmBfyOUJyU7kh06fchUDeALtXqsow4pURs/53tHQBVUeA0soLCL1zCDyjFDrcKNiiOUgZeqdblRkgcSROSGO1s3YIny3ngBpX9wivSEmITZgYuJQf7BS5Rz09j6kQPsJ3+lIw+wQ0A7V6bjpv2MONhHOuQXvreMcJgoYM6/Oi7OkdRbrBiYIMrF43os9nzxWm6c8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qi/FmM0G0Nd7ekIq0XaLfOfTIkmAheq5hxfI40rby/E=;
 b=AWZ98A8KzIkippzp06IP1iBnzyv5foAmpmA+3dNEB3QUkauTzMwMjhqE1yV4eYpC9hZyecJqyPr8aHpYsqtKxyl6oVSCYGzf2DMESstVO4TTrBbSjuLUTByuEsjOFRng9qpW+naoZC0rhHJLLjGJk2TEeLkQLDRypmdOI3jX/px7WqxgWnv7gKZGytqMTftlu3QMbb1x7Lsdyvt3/Ovq2fCvG/6uSmAKMA/8A+d7aQnXVwNac8pDm20kNMrg86w4jBeTgmwyyecsvIBOKbX27usjytLgxXCg1M4XxOBnog5r3ua0ckVdXA0H13wGeyHOC2Bfn9vw64wYA3swr9OZQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qi/FmM0G0Nd7ekIq0XaLfOfTIkmAheq5hxfI40rby/E=;
 b=lIF++gG2KDM1gPPM3VxeK45cd+Z3v6ypElG1vKXXkYjZBwS5eEDostCXtgRyuQnUu5lJMc8g/fyx75YUax8GPBg1+Z5N1mp2+EgoWuVNHuMx1eyfL401W+ogOkawm3zMA1NWOcYjb1rSOMCXSrZeeDHHfb1XVoeP06bp2RICsEI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4553.namprd10.prod.outlook.com
 (2603:10b6:806:11a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 02:12:36 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 02:12:36 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Hector Martin <marcan@marcan.st>,
        Angela Czubak <acz@semihalf.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [RFC v7 net-next 13/13] net: dsa: ocelot: add external ocelot switch control
Date:   Sun,  6 Mar 2022 18:12:08 -0800
Message-Id: <20220307021208.2406741-14-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220307021208.2406741-1-colin.foster@in-advantage.com>
References: <20220307021208.2406741-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0174.namprd04.prod.outlook.com
 (2603:10b6:303:85::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9febf3dc-fa5a-4811-e6d1-08d9ffdff235
X-MS-TrafficTypeDiagnostic: SA2PR10MB4553:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB45538A887B14C71514381184A4089@SA2PR10MB4553.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c3XiLuddeFrp7J4yfXqo+tocCudxwA4HFInCihYR07nhUAW4iib7bXgYlFYl9ihXm5U5UygaprP1OImh+rb5Lms6jMnKjlyGvqHQYtElR8FfGb2RcfKcBjJ/13/ECFVwaI1hS6SHuTA0TIzNPxurP4brxCG5hsy5fMDogQ5PoI+Lq72DIsllb0cpAJmI1eIL9+o2VcrGedbWittwhA7SKJMhZjcLIvmKamAnEhX28CzBRZcH152vv5gDN3xW7uzv8pagJHhbwa2vbcwpOoaTK/ZTm22Ggc16uxCsQdYRJ2cwLLSDHnVqKyTk0mHrkSkPzGeAtKVCAjhGicQaRlUBiDWSqQzoKlQO/7dmol6lB8b7pk6xh5MfWnVSrYnw0xvfYCN5YlwCqPNYbaEENV5cpBaxHtEnDRLIvNDGKvz8oLa0g6gOGhvDyKq52FF54+ifRnYoULZojvGBQL0mOBPtGoQxflWjqpUFf2nY9mQ9qA1drRU9QlD00513JE+92YIzkbOOM8XZjLa1IoQPd+hw1lpmYEElE01NOVj9s0628PYHwa0RtZtcko7mprzy9orZPmr8HllcKdt7M0ZTxfxgusMxHdE0eVKomUkNyb4XjmhuKWGwAxSVdZsRjQQjD72eIY+5RrMvSaCTVryUHdiF2+32x0ZbRBu+4PJFVA8Mx6Rw1TMRqLnHlpw/M4ApwSSXzw9EfbxtJghUDv+sGcXk4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(376002)(42606007)(396003)(136003)(39840400004)(346002)(38350700002)(86362001)(508600001)(107886003)(38100700002)(6486002)(54906003)(36756003)(44832011)(30864003)(6666004)(6506007)(66556008)(66946007)(4326008)(316002)(66476007)(8676002)(6512007)(26005)(186003)(8936002)(83380400001)(52116002)(1076003)(5660300002)(7416002)(2616005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rZu4Qi9elkAFMEfL2WsaxF/TmBGWNdsoJuzt/16SS7vK3soLRHWbeH/4c4bu?=
 =?us-ascii?Q?/ax6NWS6yveE7bHQRyFevEDD7yUaHSBeJ38mvC3ygIlcRlTDGRXXLqgI9zVY?=
 =?us-ascii?Q?1kptAWIQvxsftuDLqPStaB+4PODgHZz7YvkhDKn4IcrTJm1naWjvMhbTIYD9?=
 =?us-ascii?Q?BHT4X1PhM9rbYW7eULFQfI63R+SEdcuTdiU70h7URGHKvLiBUXez1BZ6THJo?=
 =?us-ascii?Q?UN9Vz+niRDlURguOmCeBxjspbpOXj8jVDQ9IEY2sPdCIYQTb4MG3gdJaVBU0?=
 =?us-ascii?Q?GggIm1ac9QUszegX62G742tSBCc57cJVKh2/ER/JmS+R/Cc+6xcTHHHVV+IX?=
 =?us-ascii?Q?sW2R8dhhNBzDqmxv0JK3Kg7vVPTPRZ9kQDmeltbCjlNxSocySpdk82GhkQhI?=
 =?us-ascii?Q?MqTqmjxhVXbZ32U9xrrjlOZUI2fg2/W5TIkwzIEGzpAFNoqwUSU8yIaxHeUm?=
 =?us-ascii?Q?G5lB/FPavlBOm7g4E2GBXEVaQPVO3FwQ/vlwa5D4rzFeNVNFdjOWS5alrbfW?=
 =?us-ascii?Q?adhgyuNaowk80R5f/kSJSDP88oRmB44hGCRDOFNirqxCMisYFtgfhzs8s9Dc?=
 =?us-ascii?Q?0y1hUhqa8cmVdvUIjyJUkJ0EOBpQPwR5rxZ/WTluO/5lTFa9O8vvq/DsOU0p?=
 =?us-ascii?Q?3DU4OG5mtr9NV/OgwvfAqZr/FreS5zkySb1WQ6lqhdrsc4D2U8W6VZgcxecn?=
 =?us-ascii?Q?+c3g05DjZGe3oDfoHUq4JJNICt6eJfmPSZNDnBjzgvoDEMY0H4QHEuNgpCIG?=
 =?us-ascii?Q?v1Oa9DZphrYMNhs0HduOFUpOEtBub/NomAbpd5CQdOXLJ9Xvk41PvSuDHkzK?=
 =?us-ascii?Q?Mdd9F231M+7njNuBinAj1ut4yRqG+kBVvlKpcAx51b4HzeHXusdzwQ51jWJk?=
 =?us-ascii?Q?0Xu6kVTcQ8qX6Pr6OnYkErGY4IvB09jtniNTpQk2nCS41Lbzabm3zDk69l9U?=
 =?us-ascii?Q?Rm4DvZrbvxbtslO66LshOlm738kBFU+uNUJENqSil2bWdQgStd/yokDZEoG3?=
 =?us-ascii?Q?wi7WYtMIs8/AHW+YEou3ZT4kXYDnMHPICw1u1JHq4dfhykz+RowmcN38inoE?=
 =?us-ascii?Q?umjFecBJswbEluIaStK1rPu2zVxvSuH4LQ9XTzgeS3se8IMXlqYdgQWs56Ku?=
 =?us-ascii?Q?k4SKcP6AP3zwdjlChYujWCTu4EoFxwEq9kuYyztB52clWXZ4S1VsswW23eXy?=
 =?us-ascii?Q?3PYguOqpv+ItQH8lBKAdkLi6Dr1lvpYCFC2ITfR9dnMc+3dI2yse6/SFqoqX?=
 =?us-ascii?Q?e6ltimS9z5Z6tzz/uh3mSuSkb7a9Rx7R1xjopOcZlseYb/nze2nsydr0g1NJ?=
 =?us-ascii?Q?FabKKcDkfvCad5oD75/svoH6HWikCmPoYy6foRwLg18/DYMRl9nquDLiw971?=
 =?us-ascii?Q?nP8fGiH+i6Z5P8abZHpJx4dmmfjht37/z295w+NKoPg7cYuoj47SC8Au+c7x?=
 =?us-ascii?Q?uefh9bVooPWBi11mDoThqf0zw7b1dNJg3wNp58wg81JW41lt3g3Rr2XU07P1?=
 =?us-ascii?Q?jgNx8kn1VXOF+XNOCbqGmwz+/wgIkNF220OLEQ+wG9lh39pOMbS1LSGRd/Bl?=
 =?us-ascii?Q?9vKi9Cv84iyfH4v7TcwxecZjolA3dXMtVktRU84Q+X7G1WiKRicBIGnMz8gw?=
 =?us-ascii?Q?Qh7Z5wkeHXygWhY1K3vczJTAUZ/93KR28ZyJq9SOrCekgpxluUOpqJc7yE7r?=
 =?us-ascii?Q?BjkG0XT6Yb8Zv31YnLTL3CgFI9g=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9febf3dc-fa5a-4811-e6d1-08d9ffdff235
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 02:12:35.8856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yTqOVTEpyGBYrm1pIooWL0ZCGhQDX7Ta3+0O5Ovm5qK94sAotpX7gBKsqRVMjESI8ztjK4JnMa9KYLESmXym9C+pta694CPbwAujyS6MTfs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4553
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add control of an external VSC7512 chip by way of the ocelot-mfd interface.

Currently the four copper phy ports are fully functional. Communication to
external phys is also functional, but the SGMII / QSGMII interfaces are
currently non-functional.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/mfd/ocelot-core.c           |   3 +
 drivers/net/dsa/ocelot/Kconfig      |  14 +
 drivers/net/dsa/ocelot/Makefile     |   5 +
 drivers/net/dsa/ocelot/ocelot_ext.c | 567 ++++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h           |   2 +
 5 files changed, 591 insertions(+)
 create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index 36e4326a853a..c6afe1791ecc 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -142,6 +142,9 @@ static const struct mfd_cell vsc7512_devs[] = {
 		.of_compatible = "mscc,vsc7514-serdes",
 		.num_resources = ARRAY_SIZE(vsc7512_hsio_resources),
 		.resources = vsc7512_hsio_resources,
+	}, {
+		.name = "ocelot-ext-switch",
+		.of_compatible = "mscc,vsc7512-ext-switch",
 	},
 };
 
diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 220b0b027b55..f40b2c7171ad 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -1,4 +1,18 @@
 # SPDX-License-Identifier: GPL-2.0-only
+config NET_DSA_MSCC_OCELOT_EXT
+	tristate "Ocelot External Ethernet switch support"
+	depends on NET_DSA && SPI
+	depends on NET_VENDOR_MICROSEMI
+	select MDIO_MSCC_MIIM
+	select MFD_OCELOT_CORE
+	select MSCC_OCELOT_SWITCH_LIB
+	select NET_DSA_TAG_OCELOT_8021Q
+	select NET_DSA_TAG_OCELOT
+	help
+	  This driver supports the VSC7511, VSC7512, VSC7513 and VSC7514 chips
+	  when controlled through SPI. It can be used with the Microsemi dev
+	  boards and an external CPU or custom hardware.
+
 config NET_DSA_MSCC_FELIX
 	tristate "Ocelot / Felix Ethernet switch support"
 	depends on NET_DSA && PCI
diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makefile
index f6dd131e7491..d7f3f5a4461c 100644
--- a/drivers/net/dsa/ocelot/Makefile
+++ b/drivers/net/dsa/ocelot/Makefile
@@ -1,11 +1,16 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NET_DSA_MSCC_FELIX) += mscc_felix.o
+obj-$(CONFIG_NET_DSA_MSCC_OCELOT_EXT) += mscc_ocelot_ext.o
 obj-$(CONFIG_NET_DSA_MSCC_SEVILLE) += mscc_seville.o
 
 mscc_felix-objs := \
 	felix.o \
 	felix_vsc9959.o
 
+mscc_ocelot_ext-objs := \
+	felix.o \
+	ocelot_ext.o
+
 mscc_seville-objs := \
 	felix.o \
 	seville_vsc9953.o
diff --git a/drivers/net/dsa/ocelot/ocelot_ext.c b/drivers/net/dsa/ocelot/ocelot_ext.c
new file mode 100644
index 000000000000..9755b13573c9
--- /dev/null
+++ b/drivers/net/dsa/ocelot/ocelot_ext.c
@@ -0,0 +1,567 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Copyright 2021 Innovative Advantage Inc.
+ */
+
+#include <asm/byteorder.h>
+#include <linux/iopoll.h>
+#include <linux/kconfig.h>
+#include <linux/phylink.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <soc/mscc/ocelot_ana.h>
+#include <soc/mscc/ocelot_dev.h>
+#include <soc/mscc/ocelot_qsys.h>
+#include <soc/mscc/ocelot_vcap.h>
+#include <soc/mscc/ocelot_ptp.h>
+#include <soc/mscc/ocelot_sys.h>
+#include <soc/mscc/ocelot.h>
+#include <soc/mscc/vsc7514_regs.h>
+#include "felix.h"
+
+#define VSC7512_NUM_PORTS		11
+
+static const u32 vsc7512_port_modes[VSC7512_NUM_PORTS] = {
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
+	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
+	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
+	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
+	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
+	OCELOT_PORT_MODE_SGMII,
+	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
+};
+
+static const u32 vsc7512_gcb_regmap[] = {
+	REG(GCB_SOFT_RST,			0x0008),
+	REG(GCB_MIIM_MII_STATUS,		0x009c),
+	REG(GCB_PHY_PHY_CFG,			0x00f0),
+	REG(GCB_PHY_PHY_STAT,			0x00f4),
+};
+
+static const u32 *vsc7512_regmap[TARGET_MAX] = {
+	[ANA] = vsc7514_ana_regmap,
+	[QS] = vsc7514_qs_regmap,
+	[QSYS] = vsc7514_qsys_regmap,
+	[REW] = vsc7514_rew_regmap,
+	[SYS] = vsc7514_sys_regmap,
+	[S0] = vsc7514_vcap_regmap,
+	[S1] = vsc7514_vcap_regmap,
+	[S2] = vsc7514_vcap_regmap,
+	[PTP] = vsc7514_ptp_regmap,
+	[GCB] = vsc7512_gcb_regmap,
+	[DEV_GMII] = vsc7514_dev_gmii_regmap,
+};
+
+static void ocelot_ext_reset_phys(struct ocelot *ocelot)
+{
+	ocelot_write(ocelot, 0, GCB_PHY_PHY_CFG);
+	ocelot_write(ocelot, 0x1ff, GCB_PHY_PHY_CFG);
+	mdelay(500);
+}
+
+static int ocelot_ext_reset(struct ocelot *ocelot)
+{
+	int retries = 100;
+	int err, val;
+
+	ocelot_ext_reset_phys(ocelot);
+
+	/* Initialize chip memories */
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
+	if (err)
+		return err;
+
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
+	if (err)
+		return err;
+
+	/* MEM_INIT is a self-clearing bit. Wait for it to be clear (should be
+	 * 100us) before enabling the switch core
+	 */
+	do {
+		msleep(1);
+		err = regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
+					&val);
+		if (err)
+			return err;
+	} while (val && --retries);
+
+	if (!retries)
+		return -ETIMEDOUT;
+
+	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
+}
+
+static const struct ocelot_ops ocelot_ext_ops = {
+	.reset		= ocelot_ext_reset,
+	.wm_enc		= ocelot_wm_enc,
+	.wm_dec		= ocelot_wm_dec,
+	.wm_stat	= ocelot_wm_stat,
+	.port_to_netdev	= felix_port_to_netdev,
+	.netdev_to_port	= felix_netdev_to_port,
+};
+
+static const struct resource vsc7512_target_io_res[TARGET_MAX] = {
+	[ANA] = {
+		.start	= 0x71880000,
+		.end	= 0x7188ffff,
+		.name	= "ana",
+	},
+	[QS] = {
+		.start	= 0x71080000,
+		.end	= 0x710800ff,
+		.name	= "qs",
+	},
+	[QSYS] = {
+		.start	= 0x71800000,
+		.end	= 0x719fffff,
+		.name	= "qsys",
+	},
+	[REW] = {
+		.start	= 0x71030000,
+		.end	= 0x7103ffff,
+		.name	= "rew",
+	},
+	[SYS] = {
+		.start	= 0x71010000,
+		.end	= 0x7101ffff,
+		.name	= "sys",
+	},
+	[S0] = {
+		.start	= 0x71040000,
+		.end	= 0x710403ff,
+		.name	= "s0",
+	},
+	[S1] = {
+		.start	= 0x71050000,
+		.end	= 0x710503ff,
+		.name	= "s1",
+	},
+	[S2] = {
+		.start	= 0x71060000,
+		.end	= 0x710603ff,
+		.name	= "s2",
+	},
+	[GCB] =	{
+		.start	= 0x71070000,
+		.end	= 0x7107022b,
+		.name	= "devcpu_gcb",
+	},
+};
+
+static const struct resource vsc7512_port_io_res[] = {
+	{
+		.start	= 0x711e0000,
+		.end	= 0x711effff,
+		.name	= "port0",
+	},
+	{
+		.start	= 0x711f0000,
+		.end	= 0x711fffff,
+		.name	= "port1",
+	},
+	{
+		.start	= 0x71200000,
+		.end	= 0x7120ffff,
+		.name	= "port2",
+	},
+	{
+		.start	= 0x71210000,
+		.end	= 0x7121ffff,
+		.name	= "port3",
+	},
+	{
+		.start	= 0x71220000,
+		.end	= 0x7122ffff,
+		.name	= "port4",
+	},
+	{
+		.start	= 0x71230000,
+		.end	= 0x7123ffff,
+		.name	= "port5",
+	},
+	{
+		.start	= 0x71240000,
+		.end	= 0x7124ffff,
+		.name	= "port6",
+	},
+	{
+		.start	= 0x71250000,
+		.end	= 0x7125ffff,
+		.name	= "port7",
+	},
+	{
+		.start	= 0x71260000,
+		.end	= 0x7126ffff,
+		.name	= "port8",
+	},
+	{
+		.start	= 0x71270000,
+		.end	= 0x7127ffff,
+		.name	= "port9",
+	},
+	{
+		.start	= 0x71280000,
+		.end	= 0x7128ffff,
+		.name	= "port10",
+	},
+};
+
+static const struct reg_field vsc7512_regfields[REGFIELD_MAX] = {
+	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 11, 11),
+	[ANA_ADVLEARN_LEARN_MIRROR] = REG_FIELD(ANA_ADVLEARN, 0, 10),
+	[ANA_ANEVENTS_MSTI_DROP] = REG_FIELD(ANA_ANEVENTS, 27, 27),
+	[ANA_ANEVENTS_ACLKILL] = REG_FIELD(ANA_ANEVENTS, 26, 26),
+	[ANA_ANEVENTS_ACLUSED] = REG_FIELD(ANA_ANEVENTS, 25, 25),
+	[ANA_ANEVENTS_AUTOAGE] = REG_FIELD(ANA_ANEVENTS, 24, 24),
+	[ANA_ANEVENTS_VS2TTL1] = REG_FIELD(ANA_ANEVENTS, 23, 23),
+	[ANA_ANEVENTS_STORM_DROP] = REG_FIELD(ANA_ANEVENTS, 22, 22),
+	[ANA_ANEVENTS_LEARN_DROP] = REG_FIELD(ANA_ANEVENTS, 21, 21),
+	[ANA_ANEVENTS_AGED_ENTRY] = REG_FIELD(ANA_ANEVENTS, 20, 20),
+	[ANA_ANEVENTS_CPU_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 19, 19),
+	[ANA_ANEVENTS_AUTO_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 18, 18),
+	[ANA_ANEVENTS_LEARN_REMOVE] = REG_FIELD(ANA_ANEVENTS, 17, 17),
+	[ANA_ANEVENTS_AUTO_LEARNED] = REG_FIELD(ANA_ANEVENTS, 16, 16),
+	[ANA_ANEVENTS_AUTO_MOVED] = REG_FIELD(ANA_ANEVENTS, 15, 15),
+	[ANA_ANEVENTS_DROPPED] = REG_FIELD(ANA_ANEVENTS, 14, 14),
+	[ANA_ANEVENTS_CLASSIFIED_DROP] = REG_FIELD(ANA_ANEVENTS, 13, 13),
+	[ANA_ANEVENTS_CLASSIFIED_COPY] = REG_FIELD(ANA_ANEVENTS, 12, 12),
+	[ANA_ANEVENTS_VLAN_DISCARD] = REG_FIELD(ANA_ANEVENTS, 11, 11),
+	[ANA_ANEVENTS_FWD_DISCARD] = REG_FIELD(ANA_ANEVENTS, 10, 10),
+	[ANA_ANEVENTS_MULTICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 9, 9),
+	[ANA_ANEVENTS_UNICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 8, 8),
+	[ANA_ANEVENTS_DEST_KNOWN] = REG_FIELD(ANA_ANEVENTS, 7, 7),
+	[ANA_ANEVENTS_BUCKET3_MATCH] = REG_FIELD(ANA_ANEVENTS, 6, 6),
+	[ANA_ANEVENTS_BUCKET2_MATCH] = REG_FIELD(ANA_ANEVENTS, 5, 5),
+	[ANA_ANEVENTS_BUCKET1_MATCH] = REG_FIELD(ANA_ANEVENTS, 4, 4),
+	[ANA_ANEVENTS_BUCKET0_MATCH] = REG_FIELD(ANA_ANEVENTS, 3, 3),
+	[ANA_ANEVENTS_CPU_OPERATION] = REG_FIELD(ANA_ANEVENTS, 2, 2),
+	[ANA_ANEVENTS_DMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 1, 1),
+	[ANA_ANEVENTS_SMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 0, 0),
+	[ANA_TABLES_MACACCESS_B_DOM] = REG_FIELD(ANA_TABLES_MACACCESS, 18, 18),
+	[ANA_TABLES_MACTINDX_BUCKET] = REG_FIELD(ANA_TABLES_MACTINDX, 10, 11),
+	[ANA_TABLES_MACTINDX_M_INDEX] = REG_FIELD(ANA_TABLES_MACTINDX, 0, 9),
+	[GCB_SOFT_RST_SWC_RST] = REG_FIELD(GCB_SOFT_RST, 1, 1),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_VLD] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 20, 20),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_FP] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 8, 19),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_PORTNO] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 4, 7),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_SEL] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 1, 3),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_T] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 0, 0),
+	[SYS_RESET_CFG_CORE_ENA] = REG_FIELD(SYS_RESET_CFG, 2, 2),
+	[SYS_RESET_CFG_MEM_ENA] = REG_FIELD(SYS_RESET_CFG, 1, 1),
+	[SYS_RESET_CFG_MEM_INIT] = REG_FIELD(SYS_RESET_CFG, 0, 0),
+	/* Replicated per number of ports (12), register size 4 per port */
+	[QSYS_SWITCH_PORT_MODE_PORT_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 14, 14, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 11, 13, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_YEL_RSRVD] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 10, 10, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 9, 9, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_TX_PFC_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 1, 8, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_TX_PFC_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 0, 0, 12, 4),
+	[SYS_PORT_MODE_DATA_WO_TS] = REG_FIELD_ID(SYS_PORT_MODE, 5, 6, 12, 4),
+	[SYS_PORT_MODE_INCL_INJ_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 3, 4, 12, 4),
+	[SYS_PORT_MODE_INCL_XTR_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 1, 2, 12, 4),
+	[SYS_PORT_MODE_INCL_HDR_ERR] = REG_FIELD_ID(SYS_PORT_MODE, 0, 0, 12, 4),
+	[SYS_PAUSE_CFG_PAUSE_START] = REG_FIELD_ID(SYS_PAUSE_CFG, 10, 18, 12, 4),
+	[SYS_PAUSE_CFG_PAUSE_STOP] = REG_FIELD_ID(SYS_PAUSE_CFG, 1, 9, 12, 4),
+	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 12, 4),
+};
+
+static const struct ocelot_stat_layout vsc7512_stats_layout[] = {
+	{ .offset = 0x00,	.name = "rx_octets", },
+	{ .offset = 0x01,	.name = "rx_unicast", },
+	{ .offset = 0x02,	.name = "rx_multicast", },
+	{ .offset = 0x03,	.name = "rx_broadcast", },
+	{ .offset = 0x04,	.name = "rx_shorts", },
+	{ .offset = 0x05,	.name = "rx_fragments", },
+	{ .offset = 0x06,	.name = "rx_jabbers", },
+	{ .offset = 0x07,	.name = "rx_crc_align_errs", },
+	{ .offset = 0x08,	.name = "rx_sym_errs", },
+	{ .offset = 0x09,	.name = "rx_frames_below_65_octets", },
+	{ .offset = 0x0A,	.name = "rx_frames_65_to_127_octets", },
+	{ .offset = 0x0B,	.name = "rx_frames_128_to_255_octets", },
+	{ .offset = 0x0C,	.name = "rx_frames_256_to_511_octets", },
+	{ .offset = 0x0D,	.name = "rx_frames_512_to_1023_octets", },
+	{ .offset = 0x0E,	.name = "rx_frames_1024_to_1526_octets", },
+	{ .offset = 0x0F,	.name = "rx_frames_over_1526_octets", },
+	{ .offset = 0x10,	.name = "rx_pause", },
+	{ .offset = 0x11,	.name = "rx_control", },
+	{ .offset = 0x12,	.name = "rx_longs", },
+	{ .offset = 0x13,	.name = "rx_classified_drops", },
+	{ .offset = 0x14,	.name = "rx_red_prio_0", },
+	{ .offset = 0x15,	.name = "rx_red_prio_1", },
+	{ .offset = 0x16,	.name = "rx_red_prio_2", },
+	{ .offset = 0x17,	.name = "rx_red_prio_3", },
+	{ .offset = 0x18,	.name = "rx_red_prio_4", },
+	{ .offset = 0x19,	.name = "rx_red_prio_5", },
+	{ .offset = 0x1A,	.name = "rx_red_prio_6", },
+	{ .offset = 0x1B,	.name = "rx_red_prio_7", },
+	{ .offset = 0x1C,	.name = "rx_yellow_prio_0", },
+	{ .offset = 0x1D,	.name = "rx_yellow_prio_1", },
+	{ .offset = 0x1E,	.name = "rx_yellow_prio_2", },
+	{ .offset = 0x1F,	.name = "rx_yellow_prio_3", },
+	{ .offset = 0x20,	.name = "rx_yellow_prio_4", },
+	{ .offset = 0x21,	.name = "rx_yellow_prio_5", },
+	{ .offset = 0x22,	.name = "rx_yellow_prio_6", },
+	{ .offset = 0x23,	.name = "rx_yellow_prio_7", },
+	{ .offset = 0x24,	.name = "rx_green_prio_0", },
+	{ .offset = 0x25,	.name = "rx_green_prio_1", },
+	{ .offset = 0x26,	.name = "rx_green_prio_2", },
+	{ .offset = 0x27,	.name = "rx_green_prio_3", },
+	{ .offset = 0x28,	.name = "rx_green_prio_4", },
+	{ .offset = 0x29,	.name = "rx_green_prio_5", },
+	{ .offset = 0x2A,	.name = "rx_green_prio_6", },
+	{ .offset = 0x2B,	.name = "rx_green_prio_7", },
+	{ .offset = 0x40,	.name = "tx_octets", },
+	{ .offset = 0x41,	.name = "tx_unicast", },
+	{ .offset = 0x42,	.name = "tx_multicast", },
+	{ .offset = 0x43,	.name = "tx_broadcast", },
+	{ .offset = 0x44,	.name = "tx_collision", },
+	{ .offset = 0x45,	.name = "tx_drops", },
+	{ .offset = 0x46,	.name = "tx_pause", },
+	{ .offset = 0x47,	.name = "tx_frames_below_65_octets", },
+	{ .offset = 0x48,	.name = "tx_frames_65_to_127_octets", },
+	{ .offset = 0x49,	.name = "tx_frames_128_255_octets", },
+	{ .offset = 0x4A,	.name = "tx_frames_256_511_octets", },
+	{ .offset = 0x4B,	.name = "tx_frames_512_1023_octets", },
+	{ .offset = 0x4C,	.name = "tx_frames_1024_1526_octets", },
+	{ .offset = 0x4D,	.name = "tx_frames_over_1526_octets", },
+	{ .offset = 0x4E,	.name = "tx_yellow_prio_0", },
+	{ .offset = 0x4F,	.name = "tx_yellow_prio_1", },
+	{ .offset = 0x50,	.name = "tx_yellow_prio_2", },
+	{ .offset = 0x51,	.name = "tx_yellow_prio_3", },
+	{ .offset = 0x52,	.name = "tx_yellow_prio_4", },
+	{ .offset = 0x53,	.name = "tx_yellow_prio_5", },
+	{ .offset = 0x54,	.name = "tx_yellow_prio_6", },
+	{ .offset = 0x55,	.name = "tx_yellow_prio_7", },
+	{ .offset = 0x56,	.name = "tx_green_prio_0", },
+	{ .offset = 0x57,	.name = "tx_green_prio_1", },
+	{ .offset = 0x58,	.name = "tx_green_prio_2", },
+	{ .offset = 0x59,	.name = "tx_green_prio_3", },
+	{ .offset = 0x5A,	.name = "tx_green_prio_4", },
+	{ .offset = 0x5B,	.name = "tx_green_prio_5", },
+	{ .offset = 0x5C,	.name = "tx_green_prio_6", },
+	{ .offset = 0x5D,	.name = "tx_green_prio_7", },
+	{ .offset = 0x5E,	.name = "tx_aged", },
+	{ .offset = 0x80,	.name = "drop_local", },
+	{ .offset = 0x81,	.name = "drop_tail", },
+	{ .offset = 0x82,	.name = "drop_yellow_prio_0", },
+	{ .offset = 0x83,	.name = "drop_yellow_prio_1", },
+	{ .offset = 0x84,	.name = "drop_yellow_prio_2", },
+	{ .offset = 0x85,	.name = "drop_yellow_prio_3", },
+	{ .offset = 0x86,	.name = "drop_yellow_prio_4", },
+	{ .offset = 0x87,	.name = "drop_yellow_prio_5", },
+	{ .offset = 0x88,	.name = "drop_yellow_prio_6", },
+	{ .offset = 0x89,	.name = "drop_yellow_prio_7", },
+	{ .offset = 0x8A,	.name = "drop_green_prio_0", },
+	{ .offset = 0x8B,	.name = "drop_green_prio_1", },
+	{ .offset = 0x8C,	.name = "drop_green_prio_2", },
+	{ .offset = 0x8D,	.name = "drop_green_prio_3", },
+	{ .offset = 0x8E,	.name = "drop_green_prio_4", },
+	{ .offset = 0x8F,	.name = "drop_green_prio_5", },
+	{ .offset = 0x90,	.name = "drop_green_prio_6", },
+	{ .offset = 0x91,	.name = "drop_green_prio_7", },
+};
+
+static void ocelot_ext_phylink_validate(struct ocelot *ocelot, int port,
+				     unsigned long *supported,
+				     struct phylink_link_state *state)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	if (state->interface != PHY_INTERFACE_MODE_NA &&
+	    state->interface != ocelot_port->phy_mode) {
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		return;
+	}
+
+	phylink_set_port_modes(mask);
+
+	phylink_set(mask, Pause);
+	phylink_set(mask, Autoneg);
+	phylink_set(mask, Asym_Pause);
+	phylink_set(mask, 10baseT_Half);
+	phylink_set(mask, 10baseT_Full);
+	phylink_set(mask, 100baseT_Half);
+	phylink_set(mask, 100baseT_Full);
+	phylink_set(mask, 1000baseT_Half);
+	phylink_set(mask, 1000baseT_Full);
+
+	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static struct vcap_props vsc7512_vcap_props[] = {
+	[VCAP_ES0] = {
+		.action_type_width = 0,
+		.action_table = {
+			[ES0_ACTION_TYPE_NORMAL] = {
+				.width = 73,
+				.count = 1,
+			},
+		},
+		.target = S0,
+		.keys = vsc7514_vcap_es0_keys,
+		.actions = vsc7514_vcap_es0_actions,
+	},
+	[VCAP_IS1] = {
+		.action_type_width = 0,
+		.action_table = {
+			[IS1_ACTION_TYPE_NORMAL] = {
+				.width = 78,
+				.count = 4,
+			},
+		},
+		.target = S1,
+		.keys = vsc7514_vcap_is1_keys,
+		.actions = vsc7514_vcap_is1_actions,
+	},
+	[VCAP_IS2] = {
+		.action_type_width = 1,
+		.action_table = {
+			[IS2_ACTION_TYPE_NORMAL] = {
+				.width = 49,
+				.count = 2,
+			},
+			[IS2_ACTION_TYPE_SMAC_SIP] = {
+				.width = 6,
+				.count = 4,
+			},
+		},
+		.target = S2,
+		.keys = vsc7514_vcap_is2_keys,
+		.actions = vsc7514_vcap_is2_actions,
+	},
+};
+
+static struct regmap *ocelot_ext_regmap_init(struct ocelot *ocelot,
+					  struct resource *res)
+{
+	return ocelot_get_regmap_from_resource(ocelot->dev, res);
+}
+
+static const struct felix_info vsc7512_info = {
+	.target_io_res			= vsc7512_target_io_res,
+	.port_io_res			= vsc7512_port_io_res,
+	.regfields			= vsc7512_regfields,
+	.map				= vsc7512_regmap,
+	.ops				= &ocelot_ext_ops,
+	.stats_layout			= vsc7512_stats_layout,
+	.num_stats			= ARRAY_SIZE(vsc7512_stats_layout),
+	.vcap				= vsc7512_vcap_props,
+	.num_mact_rows			= 1024,
+	.num_ports			= VSC7512_NUM_PORTS,
+	.num_tx_queues			= OCELOT_NUM_TC,
+	.phylink_validate		= ocelot_ext_phylink_validate,
+	.port_modes			= vsc7512_port_modes,
+	.init_regmap			= ocelot_ext_regmap_init,
+};
+
+static int ocelot_ext_probe(struct platform_device *pdev)
+{
+	struct dsa_switch *ds;
+	struct ocelot *ocelot;
+	struct felix *felix;
+	struct device *dev;
+	int err;
+
+	dev = &pdev->dev;
+
+	felix = kzalloc(sizeof(*felix), GFP_KERNEL);
+	if (!felix)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, felix);
+
+	ocelot = &felix->ocelot;
+	ocelot->dev = dev;
+
+	ocelot->num_flooding_pgids = 1;
+
+	felix->info = &vsc7512_info;
+
+	ds = kzalloc(sizeof(*ds), GFP_KERNEL);
+	if (!ds) {
+		err = -ENOMEM;
+		dev_err(dev, "Failed to allocate DSA switch\n");
+		goto err_free_felix;
+	}
+
+	ds->dev = dev;
+	ds->num_ports = felix->info->num_ports;
+	ds->num_tx_queues = felix->info->num_tx_queues;
+
+	ds->ops = &felix_switch_ops;
+	ds->priv = ocelot;
+	felix->ds = ds;
+	felix->tag_proto = DSA_TAG_PROTO_OCELOT;
+
+	err = dsa_register_switch(ds);
+	if (err) {
+		dev_err(dev, "Failed to register DSA switch: %d\n", err);
+		goto err_free_ds;
+	}
+
+	return 0;
+
+err_free_ds:
+	kfree(ds);
+err_free_felix:
+	kfree(felix);
+	return err;
+}
+
+static int ocelot_ext_remove(struct platform_device *pdev)
+{
+	struct felix *felix = dev_get_drvdata(&pdev->dev);
+
+	if (!felix)
+		return 0;
+
+	dsa_unregister_switch(felix->ds);
+
+	kfree(felix->ds);
+	kfree(felix);
+
+	dev_set_drvdata(&pdev->dev, NULL);
+
+	return 0;
+}
+
+static void ocelot_ext_shutdown(struct platform_device *pdev)
+{
+	struct felix *felix = dev_get_drvdata(&pdev->dev);
+
+	if (!felix)
+		return;
+
+	dsa_switch_shutdown(felix->ds);
+
+	dev_set_drvdata(&pdev->dev, NULL);
+}
+
+const struct of_device_id ocelot_ext_switch_of_match[] = {
+	{ .compatible = "mscc,vsc7512-ext-switch" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ocelot_ext_switch_of_match);
+
+static struct platform_driver ocelot_ext_switch_driver = {
+	.driver = {
+		.name = "ocelot-ext-switch",
+		.of_match_table = of_match_ptr(ocelot_ext_switch_of_match),
+	},
+	.probe = ocelot_ext_probe,
+	.remove = ocelot_ext_remove,
+	.shutdown = ocelot_ext_shutdown,
+};
+module_platform_driver(ocelot_ext_switch_driver);
+
+MODULE_DESCRIPTION("External Ocelot Switch driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 480bf21da404..da028c28a103 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -397,6 +397,8 @@ enum ocelot_reg {
 	GCB_MIIM_MII_STATUS,
 	GCB_MIIM_MII_CMD,
 	GCB_MIIM_MII_DATA,
+	GCB_PHY_PHY_CFG,
+	GCB_PHY_PHY_STAT,
 	DEV_CLOCK_CFG = DEV_GMII << TARGET_OFFSET,
 	DEV_PORT_MISC,
 	DEV_EVENTS,
-- 
2.25.1

