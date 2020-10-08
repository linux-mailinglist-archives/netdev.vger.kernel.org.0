Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64531287659
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 16:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730691AbgJHOrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 10:47:45 -0400
Received: from mail-am6eur05on2040.outbound.protection.outlook.com ([40.107.22.40]:7425
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729833AbgJHOro (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 10:47:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8hM/8PxCOwnO0aMzuNz9vfJUFgeJTSPsbYWlwcGSBrsSQZjJ6bvgrFrPGwYymChU8ggP2+Ip0cJUMhW6u9LfBx9kx9wXiBpJeAhU2VjMvnTR+VIVS3SL5O8hWWotS60Bs2yjBPe5BGccwmPbOUj8kzHkpJ+qsBl4Rv0vneSy7KD8+FhhqoVh/is6vpuuuWsPQyTMZLGdE8kuYxAg4Yey572V5XkKwuHtYTeQEMuud1LG5LnQEZPfBwtWUa+Xla3sbH9+Dnz0IdIboRNdL4T8QnN9IFoNi3wj/bhamRoqOheXMkxSjHOUaitlOo9HtgocvArELTInDqXFFYlOmYjeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdCNsU4q/POmNYx+UunAa3H3EaTU4014uF4QCZDA4tA=;
 b=N36CmQ7wN4jQMlk/vDyYLUNK8IxGWCE5lUtW+kXIO5Y3Wd21QGMWX3+jLXYH/EIpdQyE8m6x/jwgPPWAq239YaqFPbsQVh1xJ5oyKrieJJNiTI3MLfUQe+6+G5aYaLAqfrKFlP7jiel9tboriV6OMipqg4yY5xAyfJcL/Ugdms8OD3NqQXZn1pM6Z8UUe/A+1ezYJQNG4OPo/Z1NHurMzKapAvy4fVF3zttxYyCCpcT2Q0CbxrOfcUuxyfJoNoU83VgIzG0p5a9BrF3BFehaooq6FQN1Bl4vwO9HbHaCYH/fVXBjifFp/IulqkD7TIAbou1aYV3eIiasDdOI3q4SOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdCNsU4q/POmNYx+UunAa3H3EaTU4014uF4QCZDA4tA=;
 b=b0rm8ArYZD2ujrT6qNDw7ZBMcFcmPSXQMJw/e5bJhBIcgw79qWntV0iqFvOxZFd+UOavNmBRpcs4jEPHtbfCycUTZnKgLzce8zS+2uyYp/KEkPF39QharU4BkseJSWmGqWaBd8KulqjXBbCKh9cDmsb8R/kS2lXrYvzsDhT1b0M=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4129.eurprd04.prod.outlook.com (2603:10a6:208:61::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Thu, 8 Oct
 2020 14:47:39 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3433.044; Thu, 8 Oct 2020
 14:47:39 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Grant Likely <grant.likely@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        robh+dt@kernel.org
Cc:     Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        devicetree@vger.kernel.org
Subject: [net-next PATCH v1] net: phy: Move of_mdio from drivers/of to drivers/net/mdio
Date:   Thu,  8 Oct 2020 20:17:06 +0530
Message-Id: <20201008144706.8212-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0248.apcprd06.prod.outlook.com
 (2603:1096:4:ac::32) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0248.apcprd06.prod.outlook.com (2603:1096:4:ac::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23 via Frontend Transport; Thu, 8 Oct 2020 14:47:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 60d02408-cfd6-455c-cdd7-08d86b991a5e
X-MS-TrafficTypeDiagnostic: AM0PR04MB4129:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB412975B7B58732BAE198BFEBD20B0@AM0PR04MB4129.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:272;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/PeOFqGMp48AOhH14dpLdHNEqccjg/2V9tDFi/hyDFQR2JBqoFkq6niZkpEcJVt021n6mvaDu4B/E6W/YkE3M7+hOUNbaZV9r4O2y2Sm12fQRHrRgd2RtK4/VUICp+VDzgiXmRInZsQDh+Y6UGV/zz+vgdOjIM5zM+dhEoaqXscmNsxGSQDMCbVswsvM8t9oiDIZDpky9JmcAwbv57gSe/4ZY1jeB3mi4rNTosmVljhmcgWv6awJeLZnlKM8LdUnxiV9d19n4Y7hQQZlYuIvi2mVXuSAdFsfgkiJdiNAOEzhh+QtEqkt+/SlaLgiPntQydDNbtQ0RZvPRclx/ure6d3OXMeKzoI55hGcgQSlP7rnh6tKLwNiADIn7u3qRt3guoQCKhblmlYcZXp+gPHcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(376002)(346002)(366004)(6512007)(5660300002)(54906003)(478600001)(956004)(7416002)(2616005)(44832011)(186003)(55236004)(2906002)(16526019)(4326008)(83380400001)(52116002)(6506007)(316002)(66476007)(6666004)(66556008)(8676002)(8936002)(66946007)(1006002)(1076003)(86362001)(6486002)(110136005)(26005)(110426005)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fK+Mo85E7z8ttbNmfL8Ata5MLaJEPbOByccaXLBCR8gDc2AWsI4KjOda8gOimnXUHbCcObV7pVR0bpnYwqNyQMBMgoUej1qd6fQkP00zAgnGSgRpZda2AtAp5nC83iqpNdDMUFEn3QJUJJhc8hJDwmlIPgx2v1CIbVhuTuUPj/PLodkjRs2XKWyxvcv4hmZbOUQ5unBExVUyAcOCSYkye2diOaV5snHM4HTLiXaWY8DmWbfMk5ac/wyVFGwKbDihwVPn863vBVC3MSHatf8lrYYjWpXlFYqd0TgJ65VM+d0MOzeyE01G9MB7bcs7C5IwiTKQiIMo8uZkG4iY3//mXnNYQ9I7DDzKBDP2mi4t112Wa0GQce/At6NQ1GzjZGKhBkDbDJE5Ezd9ZePjRbE+cDTqsSvaQDKCWC9Ffx7Kej+JdmRLuPo63qdwj1Ug1krn2DvcIodC7bUfq4HXd2zXrqtz0nLcgHDPxG+G1i0Ydjsih4NWjVBF0Sr6w2FHIVvqA2en/hVqWRlN+yzYqqN9LOhcfkX/V9QlggEi4WplEbcYEgwDyB93B1PGc5IZnStwIKjk5WOtnDSH5+bqLPkenV+GtPP53tVGBpK6DqucWKYaYP8mmlJzSUpeHdn8MK8u3Do4m3w5iqnglJjGnr+2Lw==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60d02408-cfd6-455c-cdd7-08d86b991a5e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2020 14:47:39.2392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R+EV1MJWXbw8a5/ppSmqNvXbLxOS0zoNm6bmQPFex0hKk3sNiZjdQpXFgvOCefUehvxli9JbFB7c+sCTbSJOiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Better place for of_mdio.c is drivers/net/mdio.
Move of_mdio.c from drivers/of to drivers/net/mdio

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

 MAINTAINERS                        | 2 +-
 drivers/net/mdio/Kconfig           | 8 ++++++++
 drivers/net/mdio/Makefile          | 2 ++
 drivers/{of => net/mdio}/of_mdio.c | 0
 drivers/of/Kconfig                 | 7 -------
 drivers/of/Makefile                | 1 -
 6 files changed, 11 insertions(+), 9 deletions(-)
 rename drivers/{of => net/mdio}/of_mdio.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8ff71b1a4a99..d1b82a3a1843 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6525,9 +6525,9 @@ F:	Documentation/devicetree/bindings/net/mdio*
 F:	Documentation/devicetree/bindings/net/qca,ar803x.yaml
 F:	Documentation/networking/phy.rst
 F:	drivers/net/mdio/
+F:	drivers/net/mdio/of_mdio.c
 F:	drivers/net/pcs/
 F:	drivers/net/phy/
-F:	drivers/of/of_mdio.c
 F:	drivers/of/of_net.c
 F:	include/dt-bindings/net/qca-ar803x.h
 F:	include/linux/*mdio*.h
diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index 27a2a4a3d943..a10cc460d7cf 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -19,6 +19,14 @@ config MDIO_BUS
 	  reflects whether the mdio_bus/mdio_device code is built as a
 	  loadable module or built-in.
 
+config OF_MDIO
+	def_tristate PHYLIB
+	depends on OF
+	depends on PHYLIB
+	select FIXED_PHY
+	help
+	  OpenFirmware MDIO bus (Ethernet PHY) accessors
+
 if MDIO_BUS
 
 config MDIO_DEVRES
diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
index 14d1beb633c9..5c498dde463f 100644
--- a/drivers/net/mdio/Makefile
+++ b/drivers/net/mdio/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for Linux MDIO bus drivers
 
+obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
+
 obj-$(CONFIG_MDIO_ASPEED)		+= mdio-aspeed.o
 obj-$(CONFIG_MDIO_BCM_IPROC)		+= mdio-bcm-iproc.o
 obj-$(CONFIG_MDIO_BCM_UNIMAC)		+= mdio-bcm-unimac.o
diff --git a/drivers/of/of_mdio.c b/drivers/net/mdio/of_mdio.c
similarity index 100%
rename from drivers/of/of_mdio.c
rename to drivers/net/mdio/of_mdio.c
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index d91618641be6..18450437d5d5 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -74,13 +74,6 @@ config OF_NET
 	depends on NETDEVICES
 	def_bool y
 
-config OF_MDIO
-	def_tristate PHYLIB
-	depends on PHYLIB
-	select FIXED_PHY
-	help
-	  OpenFirmware MDIO bus (Ethernet PHY) accessors
-
 config OF_RESERVED_MEM
 	bool
 	depends on OF_EARLY_FLATTREE
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index 663a4af0cccd..6e1e5212f058 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -9,7 +9,6 @@ obj-$(CONFIG_OF_ADDRESS)  += address.o
 obj-$(CONFIG_OF_IRQ)    += irq.o
 obj-$(CONFIG_OF_NET)	+= of_net.o
 obj-$(CONFIG_OF_UNITTEST) += unittest.o
-obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
 obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
 obj-$(CONFIG_OF_RESOLVE)  += resolver.o
 obj-$(CONFIG_OF_OVERLAY) += overlay.o
-- 
2.17.1

