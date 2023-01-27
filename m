Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9A267EE5F
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbjA0Tjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbjA0TjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:39:03 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20724.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::724])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DEC4B748;
        Fri, 27 Jan 2023 11:38:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bK2A6sgby0ITNHdZTsGZB9CyJ/tg4z8xz3yPT/HWKUamh25cKVwcztQb6dB0VJmI23hjvJpDS5AAkbv4YSp+lRpwOWVZPuY+SvARVCVxqHQkw9GVBi6SPWWXelFJJPBH4yWHZVuWVNvnP6V9wnG34wAUc9WiI+ETQBHZQRgw0pv4LVfpKTZwYkiJqK943qxLKGs97IyWPt3ss+x1DhVdZaBQ/6zr6xjyx1RCHOXgOn6K1Abk1O+1gdvH3M1Xz/ktC5Sg9I+jCEWkSZOghfFTZskzt2fGFGw5IDUcwfbunJqxWs7tzZ9pid1gooqF+Xl0sYgirjZbGX9r4tOWJ73IIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+RMh3NOewZuR53WQ3w+SK6hG+veBXtcC6V9fgHPJ+M=;
 b=VMU7UXJERqs+cbtB2Kt2aKinKhqb1b3vOfljxusVP1r7Pm/mWlcC6xCSWLOZ6oizdgtyG6tIBGYWdIY8QXqhELYOFzvRuKpxibcQENNY8Bm4LkNId4Ij496iUGH2qzOClzXK6ooHuyjU5OvZ3RlyEnAIK+XLxm7Xm7UwbY1r0NziTG3HBCzJ2Jsgo4/jPB22qmSziFsOcl9yf9QQyYi4nG1SRCPFFUEbqe5cSjBAV0yO/gqo8TJ6vLabH2kP04J3ZrHWPEgKBO1EAnNTtiAbGdiT2x5ktrHiA8h/Ohzc72bc6V74TgY4jGDNFNBluh89w/jAFfDhzv5i9YtcTBcqMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+RMh3NOewZuR53WQ3w+SK6hG+veBXtcC6V9fgHPJ+M=;
 b=z0gF06Q6NfPcTq1QkiQJLMZU7nQvnrHfzx7xFN95fuDfZzcBd0vCsAYMY9cOndXTag79XoTZ3Vaf7haYg2WiYerHdp7DY4TJnm4GTVGm+2Fu3uwQmhpZU4KQBwhp4dEg6p1e3OE//1KKgjjaEsDTjDftqNiozet3+jBR3YfGdEk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by SA2PR10MB4636.namprd10.prod.outlook.com (2603:10b6:806:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.13; Fri, 27 Jan
 2023 19:36:32 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097%7]) with mapi id 15.20.6064.010; Fri, 27 Jan 2023
 19:36:32 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [PATCH v5 net-next 12/13] net: dsa: ocelot: add external ocelot switch control
Date:   Fri, 27 Jan 2023 11:35:58 -0800
Message-Id: <20230127193559.1001051-13-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127193559.1001051-1-colin.foster@in-advantage.com>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::24) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|SA2PR10MB4636:EE_
X-MS-Office365-Filtering-Correlation-Id: d2a81cc9-676d-45a0-d4cf-08db009dcb00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c8FKH6mqV2OL1VdLBdsHFuD3BuuJ2IyiTBZbGPeA2x8GRRT9wHafeINJH98i9eG5eUJNWTh4h0ZxMWZVnrxT+iJjS2abqqWEg6+KF4tjX+RzK1kdIm2ni2k2yo8W4WRZTBJU12Idgu5aZqGg2q0dkznO26KcPXliVmp5rddCu2uGMoRc6kmR01yQZepLilyj8C/Mi0wTn3koE6QxMzF/JC2U0crZezzuArf//rsBWAOjG6tI4uBGBpVTt/XYU33wDOu/QAEv56MQV35wf1Lw9rdQE9HZxyzpJ3faXHS7+Kp0T162hyR043B817SLdBdOxexs+M+8AzKy6oh34Aj4ROUvk60dXnzmGgOuA/KF6j1DrYOF515fCahx/eO4r7bn+EoXFUh3dWLBeh1AviAmRu31fh1a/iWko51vyKkbKI8jvNmE5Pbn4lY8QpieI8atoVTHRP3ec4F1GOQFwf79+yFi9OVWIFM6DVY+Iu1J3dGwHg2FF6BzhKOBNm6E0/iTIrKX+Vnao9tAK2PF5MP4HgKLSjH7Oq1qrg2vZOgz8TWEtSuVMWm+/h2meO8Qv2N+bs3dc/LxhaJjVfa3gIcaNsGzGKrgDWq59IxlPDp/4KUI2pfQq6qErr4EH0DzkcpkU5JwP+DHjRa+DjI9FJJZKqHMGJQP3VvpHmMAxVdSBzucx6gYhbFCK7JwnABOURUFIVlTPWgH3FNqYHVXDIZXVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(39840400004)(396003)(346002)(366004)(451199018)(36756003)(86362001)(2906002)(2616005)(6512007)(26005)(186003)(66946007)(66556008)(8676002)(4326008)(66476007)(52116002)(316002)(54906003)(6666004)(1076003)(6506007)(6486002)(478600001)(38350700002)(38100700002)(5660300002)(44832011)(41300700001)(7416002)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LcVPDzfkveQ2vz8D1h36EMM8lCF+UYwV0RWmO4evQE6pKXjpbJHVHMH+g7Ss?=
 =?us-ascii?Q?XLbuQH2qLMEtDGAnE+6i581+ceHfS0mA5FHnY6zTZgfbXS8HEEw6UINN4aqH?=
 =?us-ascii?Q?SoS8H4fw4TM0y6ux+TqaplBam/vYV9xaBiGWtl9NtVqNS7sqczSPhrUIvc0r?=
 =?us-ascii?Q?zRPw9x5AcE6GfxP2sJg8wmiwbboTzueQloclJCkmOoRw1dnGjhK8t41RA7Q6?=
 =?us-ascii?Q?2GQbzyzRhwjxCcxhUOWaEdu0dbWcJItD3Z8z+NFpmv8kN7aQCg2DragzZH71?=
 =?us-ascii?Q?UqFYDXfpX20uM6pzqN2nSkxTqK/Mgbj9H+osd1w9f+14250Ga1gO6VapLBxU?=
 =?us-ascii?Q?IAxUkH8+nzGB+RMTFbTK5o69FaUlxHDnnfCXuPE7GlDk+DlEgq4FVdF7nyIx?=
 =?us-ascii?Q?Yf3goREFbrAj/AILuFo53bXzU6Ia5bI14sGw2SPmKdT/1yP/Z5oiOr34NSwp?=
 =?us-ascii?Q?co5QyvzjGt4spQgcQKLTTZ+7vL/VmlINVpBvY1mEZZSRm6JW5qfU/qrTZIXk?=
 =?us-ascii?Q?JS/omGMZAxUV6Ap2iKg8DiEkY6/gi8ZKOO2MPa8BrS3eSKaxCSGaHu8HoxK2?=
 =?us-ascii?Q?0hFBxjbs4CYQYKHzlvbFA4UHsMCo1Zl+LRQxtICeSsCngdlbNOB7bKWAGsNH?=
 =?us-ascii?Q?Y7qgbiE1wVt+J994cNMU/nysFZPqNt26NcnCbKqRh3pfPf3gqNuk+flTcqmh?=
 =?us-ascii?Q?/y8qc/fLmUpeVFBd4efek1U5qf6KB2BwdJ1iMkESOEqxTHTGrlATin+Szef1?=
 =?us-ascii?Q?5wBtzz9rjNy28AToc+ttMTm5RKUcSGWEU6kIPmk3VtdoRo4hTXuxy6H1qX5+?=
 =?us-ascii?Q?z5nUPTefZ6DXgAdR3KF+VD/O9y2ZSFxlNxGkl4+vQ6OKqo+xYNhyUnoJ/26E?=
 =?us-ascii?Q?/QJAQ6LVA9KDH24FalODs8KJj7C0okjj0ktS6znK/ooxr/y9wW5BPDhE3XtG?=
 =?us-ascii?Q?YcX/PR44fe/V4C3AxZvi1gdgn2y0mwOHCmmC3atau27JLsqaCi4DJodq6DGd?=
 =?us-ascii?Q?xo/qwUsk5teHYbhyA9WP0MpyrChN4ZzKrULWMxmQSxg3SIu53NpJX1XX0SP1?=
 =?us-ascii?Q?5F+rq9bYxeD5j/wRN3sCSWl71/eHs/ghuK0wK0KvqP6ww45pY/K6E2dsSSpi?=
 =?us-ascii?Q?BXMm2z5Oe6das0ZpIG5M1Imyb/iCE6IZvrUYAWL5tYjcA1z1jheWtrz2JZ6x?=
 =?us-ascii?Q?7CLeUTZD6OaCo3z/m7MDNGuXzo6M7cAvPbXcWAimxY//6NvdKGeV6yZbOTTN?=
 =?us-ascii?Q?7E0ElJYoxXFTYgPzEWCVcsCesjJOvyE+b7Cl4AP2P2Nm4k7WwjCe8BIflJJZ?=
 =?us-ascii?Q?R6/BEKQeh/dtCN0uaTYSDex/e75kNf4Djiy9PMJlVCA6CMUEVIlNWh0I8duf?=
 =?us-ascii?Q?x8eb8MPFl6wOy4HnD4Mgdq7k1aXcvEX0DMREi+CGJF+dIXAPKtpKWcz2sYSC?=
 =?us-ascii?Q?41bbqLgEoFsKb3VCrbREI1Uu5CCaOT1W+J+2gauHdE6Y24C4wXme4JvPfZRq?=
 =?us-ascii?Q?8/6+V6deB4w/nJneBp59tBAvQeD3TaXFJ5DXH8IDZLXTW4DGY4FcQj6rGsEo?=
 =?us-ascii?Q?wUN9qTiFmXlHO6G988TNUJJuDJ/52g5qMa5QidVnMgCLaEu2HOpZZ8Qi1hre?=
 =?us-ascii?Q?4L9aOCvihSGzAEJhc1KCWc8=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2a81cc9-676d-45a0-d4cf-08db009dcb00
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 19:36:32.0783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hvQErYTPUVTqwzdUlDYYKEtTmYtkX/cIJx7fGhviuTjMZoxj1rzSP0Sh1WJiEoMT3W2Ju1dQjBFIfhJ6EqY8wxfwDnHt5elPtAbyKnUPAp8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4636
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add control of an external VSC7512 chip.

Currently the four copper phy ports are fully functional. Communication to
external phys is also functional, but the SGMII / QSGMII interfaces are
currently non-functional.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v5
    * Rebase to use NET_DSA_MSCC_FELIX_DSA_LIB
    * Remove ocelot_ext_phylink_validate as part of the rebase
    * Remove stats_layout reference as part of the rebase
    * Remove OCELOT_RES_NAME_* macros

v4
    * Add forward-compatibility for device trees that have ports 4-7
      defined by saying they are OCELOT_PORT_MODE_NONE
    * Utilize new "resource_names" instead of "*_io_res". Many thanks
      to Vladimir for making this possible.
      - Also remove ocelot_ext_regmap_init() function
    * Remove dev_set_drvdata(dev, NULL) from remove() to match other
      drivers

v3
    * Remove additional entry in vsc7512_port_modes array
    * Add MFD_OCELOT namespace import, which is needed for
      vsc7512_*_io_res

v2
    * Add MAINTAINERS update
    * Remove phrase "by way of the ocelot-mfd interface" from the commit
      message
    * Move MFD resource addition to a separate patch
    * Update Kconfig help
    * Remove "ocelot_ext_reset()" - it is now shared with ocelot_lib
    * Remove unnecessary includes
    * Remove "_EXT" from OCELOT_EXT_PORT_MODE_SERDES
    * Remove _ext from the compatible string
    * Remove no-longer-necessary GCB register definitions

v1 from previous RFC:
    * Remove unnecessary byteorder and kconfig header includes.
    * Create OCELOT_EXT_PORT_MODE_SERDES macro to match vsc9959.
    * Utilize readx_poll_timeout for SYS_RESET_CFG_MEM_INIT.
    * *_io_res struct arrays have been moved to the MFD files.
    * Changes to utilize phylink_generic_validate() have been squashed.
    * dev_err_probe() is used in the probe function.
    * Make ocelot_ext_switch_of_match static.
    * Relocate ocelot_ext_ops structure to be next to vsc7512_info, to
      match what was done in other felix drivers.
    * Utilize dev_get_regmap() instead of the obsolete
      ocelot_init_regmap_from_resource() routine.

---
 MAINTAINERS                         |   1 +
 drivers/net/dsa/ocelot/Kconfig      |  20 ++++
 drivers/net/dsa/ocelot/Makefile     |   2 +
 drivers/net/dsa/ocelot/ocelot_ext.c | 163 ++++++++++++++++++++++++++++
 4 files changed, 186 insertions(+)
 create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 6e85524a7443..733e311ee9c6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15157,6 +15157,7 @@ M:	Colin Foster <colin.foster@in-advantage.com>
 S:	Supported
 F:	Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 F:	drivers/mfd/ocelot*
+F:	drivers/net/dsa/ocelot/ocelot_ext.c
 F:	include/linux/mfd/ocelot.h
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 60f1f7ada465..640725524d0c 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -8,6 +8,26 @@ config NET_DSA_MSCC_FELIX_DSA_LIB
 	  Its name comes from the first hardware chip to make use of it
 	  (VSC9959), code named Felix.
 
+config NET_DSA_MSCC_OCELOT_EXT
+	tristate "Ocelot External Ethernet switch support"
+	depends on NET_DSA && SPI
+	depends on NET_VENDOR_MICROSEMI
+	select MDIO_MSCC_MIIM
+	select MFD_OCELOT_CORE
+	select MSCC_OCELOT_SWITCH_LIB
+	select NET_DSA_MSCC_FELIX_DSA_LIB
+	select NET_DSA_TAG_OCELOT_8021Q
+	select NET_DSA_TAG_OCELOT
+	help
+	  This driver supports the VSC7511, VSC7512, VSC7513 and VSC7514 chips
+	  when controlled through SPI.
+
+	  The Ocelot switch family is a set of multi-port networking chips. All
+	  of these chips have the ability to be controlled externally through
+	  SPI or PCIe interfaces.
+
+	  Say "Y" here to enable external control to these chips.
+
 config NET_DSA_MSCC_FELIX
 	tristate "Ocelot / Felix Ethernet switch support"
 	depends on NET_DSA && PCI
diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makefile
index fd7dde570d4e..ead868a293e3 100644
--- a/drivers/net/dsa/ocelot/Makefile
+++ b/drivers/net/dsa/ocelot/Makefile
@@ -1,8 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NET_DSA_MSCC_FELIX_DSA_LIB) += mscc_felix_dsa_lib.o
 obj-$(CONFIG_NET_DSA_MSCC_FELIX) += mscc_felix.o
+obj-$(CONFIG_NET_DSA_MSCC_OCELOT_EXT) += mscc_ocelot_ext.o
 obj-$(CONFIG_NET_DSA_MSCC_SEVILLE) += mscc_seville.o
 
 mscc_felix_dsa_lib-objs := felix.o
 mscc_felix-objs := felix_vsc9959.o
+mscc_ocelot_ext-objs := ocelot_ext.o
 mscc_seville-objs := seville_vsc9953.o
diff --git a/drivers/net/dsa/ocelot/ocelot_ext.c b/drivers/net/dsa/ocelot/ocelot_ext.c
new file mode 100644
index 000000000000..14efa6387bd7
--- /dev/null
+++ b/drivers/net/dsa/ocelot/ocelot_ext.c
@@ -0,0 +1,163 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Copyright 2021-2022 Innovative Advantage Inc.
+ */
+
+#include <linux/mfd/ocelot.h>
+#include <linux/phylink.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <soc/mscc/ocelot.h>
+#include <soc/mscc/vsc7514_regs.h>
+#include "felix.h"
+
+#define VSC7514_NUM_PORTS		11
+
+#define OCELOT_PORT_MODE_SERDES		(OCELOT_PORT_MODE_SGMII | \
+					 OCELOT_PORT_MODE_QSGMII)
+
+static const u32 vsc7512_port_modes[VSC7514_NUM_PORTS] = {
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_NONE,
+	OCELOT_PORT_MODE_NONE,
+	OCELOT_PORT_MODE_NONE,
+	OCELOT_PORT_MODE_NONE,
+	OCELOT_PORT_MODE_NONE,
+	OCELOT_PORT_MODE_NONE,
+	OCELOT_PORT_MODE_NONE,
+};
+
+static const struct ocelot_ops ocelot_ext_ops = {
+	.reset		= ocelot_reset,
+	.wm_enc		= ocelot_wm_enc,
+	.wm_dec		= ocelot_wm_dec,
+	.wm_stat	= ocelot_wm_stat,
+	.port_to_netdev	= felix_port_to_netdev,
+	.netdev_to_port	= felix_netdev_to_port,
+};
+
+static const char * const vsc7512_resource_names[TARGET_MAX] = {
+	[SYS] = "sys",
+	[REW] = "rew",
+	[S0] = "s0",
+	[S1] = "s1",
+	[S2] = "s2",
+	[QS] = "qs",
+	[QSYS] = "qsys",
+	[ANA] = "ana",
+};
+
+static const struct felix_info vsc7512_info = {
+	.resource_names			= vsc7512_resource_names,
+	.regfields			= vsc7514_regfields,
+	.map				= vsc7514_regmap,
+	.ops				= &ocelot_ext_ops,
+	.vcap				= vsc7514_vcap_props,
+	.num_mact_rows			= 1024,
+	.num_ports			= VSC7514_NUM_PORTS,
+	.num_tx_queues			= OCELOT_NUM_TC,
+	.port_modes			= vsc7512_port_modes,
+};
+
+static int ocelot_ext_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct dsa_switch *ds;
+	struct ocelot *ocelot;
+	struct felix *felix;
+	int err;
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
+		dev_err_probe(dev, err, "Failed to allocate DSA switch\n");
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
+		dev_err_probe(dev, err, "Failed to register DSA switch\n");
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
+static const struct of_device_id ocelot_ext_switch_of_match[] = {
+	{ .compatible = "mscc,vsc7512-switch" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ocelot_ext_switch_of_match);
+
+static struct platform_driver ocelot_ext_switch_driver = {
+	.driver = {
+		.name = "ocelot-switch",
+		.of_match_table = of_match_ptr(ocelot_ext_switch_of_match),
+	},
+	.probe = ocelot_ext_probe,
+	.remove = ocelot_ext_remove,
+	.shutdown = ocelot_ext_shutdown,
+};
+module_platform_driver(ocelot_ext_switch_driver);
+
+MODULE_DESCRIPTION("External Ocelot Switch driver");
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(MFD_OCELOT);
-- 
2.25.1

