Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C2942173E
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239024AbhJDTSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:18:50 -0400
Received: from mail-am6eur05on2057.outbound.protection.outlook.com ([40.107.22.57]:12353
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238862AbhJDTSg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:18:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UxgKfNkogelYIifoAiDN6a9ZSePNLSgEtp/HBkMXnmAeB/aWTCGrrE5TNEA6Ydo/D/VkuFU1JQ3BOLnQDJWXRyCpq7J805QJreDBzTBsSPhCBZDNrRXUmsJXJm7T2l6fousy7WqGrFISnhUF6mbOlPRX6bLgkM2KT75wK2skhYJNC87GKf08SALFohB5QD5bDb0Ux7EsZaQfPEvNbTzWPXlB2T1ab8njJB9CxZDbIbProzA41mr9VLXb/8DhRX3BQwuiglEOPhDWFuLCUfGSSbf7N/p4HVIRpS8WZHpvjhITh2SYaTBQVPP532sS0qyN5KtOhQVYcJsXIAE6fHb1aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JM4Gz0V/pcZJ1u232n0DuEUc2N2uXYMdMrNM3a0f5e8=;
 b=McYWftkhlXAPPX9YxzfLUXtjMbKJr+MJIJPTUd4So56T/ECS9AcLiBqQY5xPiJIHuCSzTA5hSY+QtGoJeTySQXWFuAgu8E1R1lNgAS3plZuCtWGJ4MrUB14hSomEPrXjDWA8mcZHwzMAjB6mj347SO/iSJZPgN8qVuZN7aiEcT5JrPJ/8MVIukH6ntO5qehl1UBr6d6iwUJ9QS9QbvBdUZyFP/wQQ/cuTyb3P3gElph19+vPYJxsNOT8H6RASoBYEtnXGBQ/U3nY7kXhhwaOI2vQWpr+sroUIHIm5PdvDfszeomk4MwpkpFc9ZRU1PkuwyEh5lrzXfsvK28TIwYzEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JM4Gz0V/pcZJ1u232n0DuEUc2N2uXYMdMrNM3a0f5e8=;
 b=riCjBLJpjVkngevTME+BY/YfJs3Xd6X1yqWsSvSsuV0dv0bbF2Rxq+xd4QUsGz/i8IlFJtFfc2e+xpjB3j8Uw64EX2iuBI83jpwqD9QCjE7wu1i1Wox0GGhQdKPRKgqJ16ec4Vg/RXsUMALdKjiRgHcW+7C27aIayxB+odAzJVQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB6PR0301MB2183.eurprd03.prod.outlook.com (2603:10a6:4:47::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Mon, 4 Oct
 2021 19:16:12 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:16:12 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <robert.hancock@calian.com>
Subject: [RFC net-next PATCH 15/16] net: pcs: Add Xilinx PCS driver
Date:   Mon,  4 Oct 2021 15:15:26 -0400
Message-Id: <20211004191527.1610759-16-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004191527.1610759-1-sean.anderson@seco.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:208:239::28) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:208:239::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Mon, 4 Oct 2021 19:16:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5add22d-8bf8-4b1e-5083-08d9876b6d6d
X-MS-TrafficTypeDiagnostic: DB6PR0301MB2183:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0301MB2183DDD45D6E1F305940BFCE96AE9@DB6PR0301MB2183.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bb+Fz6IGRhNPFND9xnQljUau61KgCpdW9Y+reyXHJYkb7F9dE+0/rpNJceNXhXT1tgWb260n2TL+E+UrwSIvK+HyT0/ge2qO8hNJcjfjxYkmtmzco0UdS1+nU4TvQD51T/UnCF45grcP4nKUR3+fMV/Zdd055kwJ6QSVR6TGgIQrG/P2aIwSqanLIqBKIYSLy58vkGkw6gXHCBPekoyEvyxnAdFN3mOkxy2ChIThR60gZ4RcMa78K6mqTHyNwOLeOtTyP+edjYz5iN7SITSxAraQM8d5jOlbU8RLBKfc2AFbb3UyikVPwi3Yte+4/MlLtYwMdjYiGebBuCppKto6DPh7cMGuEDFjTZLhJeFUOp9a2VMmwO2URSs0i5JB56RpOuJn/05yLudmG5gGqLRR7yEiEWM+ZNq91s5MivDhEVgtJU/7zUHLLPGMnyTM+8sGSmxB+gEnZc0txhwzaQ3Day4k+nKBqRvJ99sHxuMI9Eamhvm15MOLFNVKPfE3eKqTJDWGBSnJ+8HgIhez4wKPBc3pyTZH/Hil9rO/TQ2Ni4wp6n7lNAGxv5YXeHkrNfgmvMkdocqPi0/hy5Z6hg3KTs/AR761xZ+M5rKvOnM7n2f0fjFAn71D/NHYvtvthKsd1kyoivJvtBT+zWGN/4pXtJDuFWbcsaerQWrYQicoEoaBY72T4nKiqtMenwjRh5I2srSolLFpTpZ1EezxFUUEAEvldfKN6JvUrOYuOqdNRC2yko5LIHVC2c3Y1Q9vC+Sd8sfTVxTl/rv3XE9EjoTTm4f4fuUaCU9FBh7qldfHRy8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(30864003)(83380400001)(2906002)(54906003)(5660300002)(1076003)(52116002)(26005)(66946007)(66476007)(66556008)(966005)(44832011)(8936002)(110136005)(6506007)(2616005)(316002)(6486002)(6666004)(36756003)(8676002)(4326008)(956004)(38350700002)(6512007)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?50G30l6XOwdgfXTKuiKyx9sLso7A8vA5AE32M9Ct9ET1TpOL15qufcbTbrUM?=
 =?us-ascii?Q?A3klbReWvUYXnexUp5h98rbpZI3Connvf99WilwxLI9yQh9BevkGwv7mKy9I?=
 =?us-ascii?Q?x035MricWSKxeIjcyt0JC/NtiYc+ocP7FsejSM+/D5VKWVhbg/6K2eKIrkXP?=
 =?us-ascii?Q?rZ13DcUM0aSM12RLgFGFY9bU+UIA04NRUSPr/k4g0JAF4Ykf3xMVKYM/DfnH?=
 =?us-ascii?Q?dDzAhSXGgDDq3l5ABMCv6x0iG7+ARuOEJZUgqR3lzlXYjx1kpK1/7G+FI1RJ?=
 =?us-ascii?Q?9YigalbrfqnPAhKjMp+4Qqhj2WwDLol1ugwKn992FSDNhEws6XJ0K8UyVA8v?=
 =?us-ascii?Q?jq5jcpmNCZqf5EDB8QAIjvOdmvh1Q6PzTPQeZXXoXEQg7JlEQ5Xu3IAyau0K?=
 =?us-ascii?Q?DG3EGeYTkGdBCg0Akyo8RgOYKnog3lUfBAM+WWseMZC5+/PFe1mRIA7eQAOA?=
 =?us-ascii?Q?l9bjbZYLmt/0Jhzj8TansvDky+67sZUOaVAVDp1+U5Tg9d5FoyX90xw13ULA?=
 =?us-ascii?Q?1RYWzoWw7AECkYvDSlpD0vrINFXZ9/TUwnco9821hSMUV6bByX8IAvkG8FKM?=
 =?us-ascii?Q?0Vp1IfNpanlbHtyxm0N90RiZZSMCbw53gXYPevxqv+rvfGmqY+/pPtIl9Lyt?=
 =?us-ascii?Q?6fAIJ1mxFh0PIBCQZK+QPUVd5+Tmms+P7vvqZAqlA31MayVIkBq74fPcu+dv?=
 =?us-ascii?Q?ELo2mtrKTyCN+nfVW49mTS1dI+thOPAMLx3dlob47B9Fvqu+M7zMFOa0gmFa?=
 =?us-ascii?Q?asIxl8Bk8X0ycIdUb5v6zo7U6sroJPqg7auFTBTCngS6ZnFV3VdD8mV0RgHR?=
 =?us-ascii?Q?fXMlcGGDP7815LvOb2ZH74lYCqXaiRD3wH1qUhuSSiO+tdejpo6Id8N6aH38?=
 =?us-ascii?Q?4suJaUJcIB60proVb8f9IP8A3gLBRT8JHvaDMqkva1BwYdQmBGdugQfLszDd?=
 =?us-ascii?Q?Fn7tjhSRA/78VWpBhDfP8Pu4J2OQ2HwvFrPE00YKOR7w8Cm6V7Vl/1rlmb4v?=
 =?us-ascii?Q?nmODJ0/Ofr06Pb6GWS+dIe4kW19SP8I666iZ/sotLNFdsHcjMwtKif5cOH2P?=
 =?us-ascii?Q?sCeYSihR103VKk1uWJpjH2taWRQZIrNhPr5/NELKmjejYu9AL3RSf9hFARHN?=
 =?us-ascii?Q?HzeOATMwcuO84FNzVnEMAuQgjbu9XgiwmrqHAgL4TyR4v8k4l7iIbSpzdIKP?=
 =?us-ascii?Q?Y8TykQfqnU/l9dUiiFZuml0P/Z5sssN/rUXJQ63+9jS8t2DkwjzG080GvYYo?=
 =?us-ascii?Q?qv4zJL33nsj1dwoXZEztTDOzVtTiT1nEVjsRAOsxbiUaMwPSaNp6mt95dDR0?=
 =?us-ascii?Q?e49o36QYFpDjIEPgh7tHizpx?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5add22d-8bf8-4b1e-5083-08d9876b6d6d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 19:16:11.8488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dDusAr09LsgmlAVIq/wxopcdyipnP5LVTZLUQRXhZ8KmMnPTKI/qvLxQB4RdKlcLZWz58/yksSDIEGzJv3IuEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0301MB2183
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for the Xilinx 1G/2.5G Ethernet PCS/PMA or SGMII
device. This is a soft device which converts between GMII and either
SGMII, 2.5G SGMII, 1000BASE-X, or 2500BASE-X. If configured correctly,
it can also switch between SGMII and 1000BASE-X at runtime. Internally,
these are referred to as the "standard" to match the terminology in the
datasheet. I am not sure how to handle the 2.5G SGMII case yet (since
AIUI Linux doesn't think it exists), and I do not have the hardware to
test it, so I have left out support.

This device has a c22-compliant PHY interface, so for the most part we
can just use the phylink helpers. Where we have to do things manually is
usually just to set the interface. We also set the speed and duplex when
the link comes up. I don't know what the permit_pause_to_mac parameter
is for in pcs_config, so I ignore it...

This device supports an interrupt which is triggered on link status
change. While according to Documentation/networking/sfp-phylink.rst the
mac should call phylink_mac_change on link state change, it is unclear
to me what the PCS should call. For now I have just set the PCS to
poll.

This device supports sharing some logic between different
implementations of the device. In this case, one device has the shared
logic, and several output (clocks, resets, etc.) are connected between
it and the consuming devices. I am not sure how to model this (create a
clock? add a devlink?) so I have left it out, but I would like to
include support for this use-case.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 MAINTAINERS                  |   6 +
 drivers/net/pcs/Kconfig      |  19 ++
 drivers/net/pcs/Makefile     |   1 +
 drivers/net/pcs/pcs-xilinx.c | 326 +++++++++++++++++++++++++++++++++++
 4 files changed, 352 insertions(+)
 create mode 100644 drivers/net/pcs/pcs-xilinx.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 7f4615336fa5..eaee1028a7ba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20591,6 +20591,12 @@ F:	Documentation/devicetree/bindings/gpio/gpio-zynq.yaml
 F:	drivers/gpio/gpio-xilinx.c
 F:	drivers/gpio/gpio-zynq.c
 
+XILINX PCS DRIVER
+M:	Sean Anderson <sean.anderso@seco.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/xilinx,pcs.yaml
+F:	drivers/net/pcs/pcs-xilinx.c
+
 XILINX SD-FEC IP CORES
 M:	Derek Kiernan <derek.kiernan@xilinx.com>
 M:	Dragan Cvetic <dragan.cvetic@xilinx.com>
diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 22ba7b0b476d..3ee415504eeb 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -18,4 +18,23 @@ config PCS_LYNX
 	  This module provides helpers to phylink for managing the Lynx PCS
 	  which is part of the Layerscape and QorIQ Ethernet SERDES.
 
+config PCS_XILINX
+	depends on OF
+	depends on GPIOLIB
+	depends on COMMON_CLK
+	depends on PHYLINK
+	tristate "Xilinx PCS driver"
+	help
+	  PCS driver for the Xilinx 1G/2.5G Ethernet PCS/PMA or SGMII device.
+	  This device can either act as a PCS+PMA for 1000BASE-X or 2500BASE-X,
+	  or as a GMII-to-SGMII bridge. It can also switch between 1000BASE-X
+	  and SGMII dynamically if configured correctly when synthesized.
+	  Typical applications use this device on an FPGA connected to a GEM or
+	  TEMAC on the GMII side. The other side is typically connected to
+	  on-device gigabit transceivers, off-device SERDES devices using TBI,
+	  or LVDS IO resources directly.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pcs-xilinx.
+
 endmenu
diff --git a/drivers/net/pcs/Makefile b/drivers/net/pcs/Makefile
index 0603d469bd57..4a8580ca4134 100644
--- a/drivers/net/pcs/Makefile
+++ b/drivers/net/pcs/Makefile
@@ -5,3 +5,4 @@ pcs_xpcs-$(CONFIG_PCS_XPCS)	:= pcs-xpcs.o pcs-xpcs-nxp.o
 
 obj-$(CONFIG_PCS_XPCS)		+= pcs_xpcs.o
 obj-$(CONFIG_PCS_LYNX)		+= pcs-lynx.o
+obj-$(CONFIG_PCS_XILINX)	+= pcs-xilinx.o
diff --git a/drivers/net/pcs/pcs-xilinx.c b/drivers/net/pcs/pcs-xilinx.c
new file mode 100644
index 000000000000..297c9881b401
--- /dev/null
+++ b/drivers/net/pcs/pcs-xilinx.c
@@ -0,0 +1,326 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2021 Sean Anderson <sean.anderson@seco.com>
+ *
+ * This is the driver for the Xilinx 1G/2.5G Ethernet PCS/PMA or SGMII LogiCORE
+ * IP. A typical setup will look something like
+ *
+ * MAC <--GMII--> PCS+PMA <--internal/TBI--> PMD (SERDES) <--SGMII/1000BASE-X
+ *
+ * The link to the PMD is not modeled by this driver, except for refclk. It is
+ * assumed that the SERDES needs no configuration. It is also possible to go
+ * from SGMII to GMII (PHY mode), but this is not supported.
+ *
+ * This driver was written with reference to PG047:
+ * https://www.xilinx.com/support/documentation/ip_documentation/gig_ethernet_pcs_pma/v16_2/pg047-gig-eth-pcs-pma.pdf
+ */
+
+#include <linux/clk.h>
+#include <linux/mdio.h>
+#include <linux/of.h>
+#include <linux/phylink.h>
+#include <linux/reset.h>
+
+/* Vendor-specific MDIO registers */
+#define XILINX_PCS_ANICR 16 /* Auto-Negotiation Interrupt Control Register */
+#define XILINX_PCS_SSR   17 /* Standard Selection Register */
+
+#define XILINX_PCS_ANICR_IE BIT(0) /* Interrupt Enable */
+#define XILINX_PCS_ANICR_IS BIT(1) /* Interrupt Status */
+
+#define XILINX_PCS_SSR_SGMII BIT(0) /* Select SGMII standard */
+
+/**
+ * enum xilinx_pcs_standard - Support for interface standards
+ * @XILINX_PCS_STD_SGMII: SGMII for 10/100/1000BASE-T
+ * @XILINX_PCS_STD_1000BASEX: 1000BASE-X PMD Support Interface
+ * @XILINX_PCS_STD_BOTH: Support for both SGMII and 1000BASE-X
+ * @XILINX_PCS_STD_2500BASEX: 2500BASE-X PMD Support Interface
+ * @XILINX_PCS_STD_2500SGMII: 2.5G SGMII for 2.5GBASE-T
+ */
+enum xilinx_pcs_standard {
+	XILINX_PCS_STD_SGMII,
+	XILINX_PCS_STD_1000BASEX,
+	XILINX_PCS_STD_BOTH,
+	XILINX_PCS_STD_2500BASEX,
+	XILINX_PCS_STD_2500SGMII,
+};
+
+/**
+ * struct xilinx_pcs - Private data for Xilinx PCS devices
+ * @pcs: The phylink PCS
+ * @mdiodev: The mdiodevice used to access the PCS
+ * @refclk: The reference clock for the PMD
+ * @reset: The reset controller for the PCS
+ * @standard: The supported interface standard
+ */
+struct xilinx_pcs {
+	struct phylink_pcs pcs;
+	struct mdio_device *mdiodev;
+	struct clk *refclk;
+	struct reset_control *reset;
+	enum xilinx_pcs_standard standard;
+};
+
+static inline struct xilinx_pcs *pcs_to_xilinx(struct phylink_pcs *pcs)
+{
+	return container_of(pcs, struct xilinx_pcs, pcs);
+}
+
+static void xilinx_pcs_get_state(struct phylink_pcs *pcs,
+				 struct phylink_link_state *state)
+{
+	struct xilinx_pcs *xp = pcs_to_xilinx(pcs);
+
+	switch (xp->standard) {
+	case XILINX_PCS_STD_SGMII:
+		state->interface = PHY_INTERFACE_MODE_SGMII;
+		break;
+	case XILINX_PCS_STD_1000BASEX:
+		state->interface = PHY_INTERFACE_MODE_1000BASEX;
+		break;
+	case XILINX_PCS_STD_BOTH: {
+		int ssr = mdiodev_read(xp->mdiodev, XILINX_PCS_SSR);
+
+		if (ssr < 0) {
+			dev_err(pcs->dev, "could not read SSR (err=%d)\n", ssr);
+			return;
+		}
+
+		if (ssr & XILINX_PCS_SSR_SGMII)
+			state->interface = PHY_INTERFACE_MODE_SGMII;
+		else
+			state->interface = PHY_INTERFACE_MODE_1000BASEX;
+		break;
+	}
+	case XILINX_PCS_STD_2500BASEX:
+		state->interface = PHY_INTERFACE_MODE_2500BASEX;
+		break;
+	default:
+		return;
+	}
+
+	phylink_mii_c22_pcs_get_state(xp->mdiodev, state);
+}
+
+static int xilinx_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+			     phy_interface_t interface,
+			     const unsigned long *advertising,
+			     bool permit_pause_to_mac)
+{
+	int ret;
+	bool changed = false;
+	struct xilinx_pcs *xp = pcs_to_xilinx(pcs);
+
+	switch (xp->standard) {
+	case XILINX_PCS_STD_SGMII:
+		if (interface != PHY_INTERFACE_MODE_SGMII)
+			return -EOPNOTSUPP;
+		break;
+	case XILINX_PCS_STD_1000BASEX:
+		if (interface != PHY_INTERFACE_MODE_1000BASEX)
+			return -EOPNOTSUPP;
+		break;
+	case XILINX_PCS_STD_BOTH: {
+		u16 ssr;
+
+		if (interface == PHY_INTERFACE_MODE_SGMII)
+			ssr = XILINX_PCS_SSR_SGMII;
+		else if (interface == PHY_INTERFACE_MODE_1000BASEX)
+			ssr = 0;
+		else
+			return -EOPNOTSUPP;
+
+		ret = mdiodev_read(xp->mdiodev, XILINX_PCS_SSR);
+		if (ret < 0)
+			return ret;
+
+		if (ret == ssr)
+			break;
+
+		changed = true;
+		ret = mdiodev_write(xp->mdiodev, XILINX_PCS_SSR, ssr);
+		if (ret)
+			return ret;
+		break;
+	}
+	case XILINX_PCS_STD_2500BASEX:
+		if (interface != PHY_INTERFACE_MODE_2500BASEX)
+			return -EOPNOTSUPP;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	ret = phylink_mii_c22_pcs_config(xp->mdiodev, mode, interface,
+					 advertising);
+	if (ret)
+		return ret;
+	return changed;
+}
+
+static void xilinx_pcs_an_restart(struct phylink_pcs *pcs)
+{
+	struct xilinx_pcs *xp = pcs_to_xilinx(pcs);
+
+	phylink_mii_c22_pcs_an_restart(xp->mdiodev);
+}
+
+static void xilinx_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
+			       phy_interface_t interface, int speed, int duplex)
+{
+	int bmcr;
+	struct xilinx_pcs *xp = pcs_to_xilinx(pcs);
+
+	if (phylink_autoneg_inband(mode))
+		return;
+
+	bmcr = mdiodev_read(xp->mdiodev, MII_BMCR);
+	if (bmcr < 0) {
+		dev_err(pcs->dev, "could not read BMCR (err=%d)\n", bmcr);
+		return;
+	}
+
+	bmcr &= ~BMCR_FULLDPLX;
+	if (duplex == DUPLEX_FULL)
+		bmcr |= BMCR_FULLDPLX;
+	else if (duplex != DUPLEX_HALF)
+		dev_err(pcs->dev, "unknown duplex %d\n", duplex);
+
+	bmcr &= ~(BMCR_SPEED1000 | BMCR_SPEED100);
+	switch (speed) {
+	case SPEED_2500:
+	case SPEED_1000:
+		bmcr |= BMCR_SPEED1000;
+		break;
+	case SPEED_100:
+		bmcr |= BMCR_SPEED100;
+		break;
+	case SPEED_10:
+		bmcr |= BMCR_SPEED10;
+		break;
+	default:
+		dev_err(pcs->dev, "invalid speed %d\n", speed);
+	}
+
+	bmcr = mdiodev_write(xp->mdiodev, MII_BMCR, bmcr);
+	if (bmcr < 0)
+		dev_err(pcs->dev, "could not write BMCR (err=%d)\n", bmcr);
+}
+
+static const struct phylink_pcs_ops xilinx_pcs_ops = {
+	.pcs_get_state = xilinx_pcs_get_state,
+	.pcs_config = xilinx_pcs_config,
+	.pcs_an_restart = xilinx_pcs_an_restart,
+	.pcs_link_up = xilinx_pcs_link_up,
+};
+
+static int xilinx_pcs_probe(struct mdio_device *mdiodev)
+{
+	const char *standard;
+	int ret;
+	struct xilinx_pcs *xp;
+	struct device *dev = &mdiodev->dev;
+	struct device_node *np = dev->of_node;
+	u32 phy_id;
+
+	xp = devm_kzalloc(dev, sizeof(*xp), GFP_KERNEL);
+	if (!xp)
+		return -ENOMEM;
+	xp->mdiodev = mdiodev;
+	dev_set_drvdata(dev, xp);
+
+	ret = of_property_read_string(np, "standard", &standard);
+	if (ret)
+		return dev_err_probe(dev, ret, "could not read standard\n");
+
+	if (!strncmp(standard, "1000base-x", 10))
+		xp->standard = XILINX_PCS_STD_1000BASEX;
+	else if (!strncmp(standard, "sgmii/1000base-x", 16))
+		xp->standard = XILINX_PCS_STD_BOTH;
+	else if (!strncmp(standard, "sgmii", 5))
+		xp->standard = XILINX_PCS_STD_SGMII;
+	else if (!strncmp(standard, "2500base-x", 10))
+		xp->standard = XILINX_PCS_STD_2500BASEX;
+	/* TODO: 2.5G SGMII support */
+	else
+		return dev_err_probe(dev, -EINVAL,
+				     "unknown/unsupported standard %s\n",
+				     standard);
+
+	xp->refclk = devm_clk_get(dev, "refclk");
+	if (IS_ERR(xp->refclk))
+		return dev_err_probe(dev, PTR_ERR(xp->refclk),
+				     "could not get reference clock\n");
+
+	xp->reset = devm_reset_control_get_exclusive(dev, "pcs");
+	if (IS_ERR(xp->reset))
+		return dev_err_probe(dev, PTR_ERR(xp->reset),
+				     "could not get reset\n");
+
+	ret = reset_control_assert(xp->reset);
+	if (ret)
+		return dev_err_probe(dev, ret, "could not enter reset\n");
+
+	ret = clk_prepare_enable(xp->refclk);
+	if (ret)
+		return dev_err_probe(dev, ret,
+				     "could not enable reference clock\n");
+
+	ret = reset_control_deassert(xp->reset);
+	if (ret) {
+		dev_err_probe(dev, ret, "could not exit reset\n");
+		goto err_unprepare;
+	}
+
+	/* Sanity check */
+	ret = get_phy_c22_id(mdiodev->bus, mdiodev->addr, &phy_id);
+	if (ret) {
+		dev_err_probe(dev, ret, "could not read id\n");
+		goto err_unprepare;
+	}
+	if ((phy_id & 0xfffffff0) != 0x01740c00)
+		dev_warn(dev, "unknown phy id %x\n", phy_id);
+
+	xp->pcs.dev = dev;
+	xp->pcs.ops = &xilinx_pcs_ops;
+	xp->pcs.poll = true;
+	ret = phylink_register_pcs(&xp->pcs);
+	if (ret)
+		return dev_err_probe(dev, ret, "could not register PCS\n");
+	dev_info(dev, "probed (standard=%s)\n", standard);
+	return 0;
+
+err_unprepare:
+	clk_disable_unprepare(xp->refclk);
+	return ret;
+}
+
+static void xilinx_pcs_remove(struct mdio_device *mdiodev)
+{
+	struct xilinx_pcs *xp = dev_get_drvdata(&mdiodev->dev);
+
+	phylink_unregister_pcs(&xp->pcs);
+	reset_control_assert(xp->reset);
+	clk_disable_unprepare(xp->refclk);
+}
+
+static const struct of_device_id xilinx_pcs_of_match[] = {
+	{ .compatible = "xlnx,pcs-16.2", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, xilinx_timer_of_match);
+
+static struct mdio_driver xilinx_pcs_driver = {
+	.probe = xilinx_pcs_probe,
+	.remove = xilinx_pcs_remove,
+	.mdiodrv.driver = {
+		.name = "xilinx-pcs",
+		.of_match_table = of_match_ptr(xilinx_pcs_of_match),
+	},
+};
+mdio_module_driver(xilinx_pcs_driver);
+
+MODULE_ALIAS("platform:xilinx-pcs");
+MODULE_DESCRIPTION("Xilinx PCS driver");
+MODULE_LICENSE("GPL v2");
-- 
2.25.1

