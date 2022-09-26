Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484F15E9765
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 02:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbiIZAdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 20:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233420AbiIZAcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 20:32:23 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2103.outbound.protection.outlook.com [40.107.96.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32EC2E698;
        Sun, 25 Sep 2022 17:30:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFJnWiSyGzaO5rbNFq9KbjmGBxJ3/QsFbNkzN1OEORl6RS7D4EDShGqZsR7I06pTFK/XjbguY8Qe/cCDG3McX1+YdWdkAWCK+QI1jtB2eO0fIBPkym6w1xhqmTnrXI9k9eci5rEM8jKeI5wuF+RqdLs3F8Xjit5ZV7kE2PRPUtjFYhdaeKS9QZso1vi+5z8eEBru2vY6DvgaPs4m9gHPOMzR/xi15XnNLpC/6LoqMspIFG4dmMUn0HZYLkxyubQP0f1c+rnYq3gSB8AeC2hIY9s/94SsuWjCeTFG6FbamHgMX4DbirJZ+M00NtK1XzCFYwNU3EErtLbusLio1S66Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8G+Y8Y69mawiZ3jyxZ+YrijN9pffWSRlzViWHi8/5Q=;
 b=hYUnX0bA9FVtyHpW+odTExEeS3KmZFUaWOXQ+uMgPgw4ZB9xAEX/P1JChO9JmQPwRmyIo9VA9UK6J1TS3TV0UbLfCjDjJwVcYXMR83jXrjEjffmcNlFW0T/pu7OiGuIALtY3it68CEvlmWI8Dd1wwhflkN3d1YKrkM4TQmcE0DAZLXXFAT7WQOGlKrL44LP38fVBWmZWAyjblG6PeeB/gY7Q9rXdrJ0rWrEOJ4KbIMYAPpRuVSSSDT3wrhMVaSywzftm1w+g4+Gn54A6CX/2EaYBoQ+Q1f4iJ66UCB1M47wtMbK4lflxb8w5fbktbOSK4IIiyytwqFIX8iuJ8uihcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8G+Y8Y69mawiZ3jyxZ+YrijN9pffWSRlzViWHi8/5Q=;
 b=H+3ve4Hl7W8WosxrBQiBD1+4cPuSbmjb2R1QbQyzpfyKkWzXpYzEPwlN78APSOUZlY6/RtRl8ruEDmX8KIwj4UlR7KOu+5HIv2QUG7kzDMil8pGpnE6Hlw+iOF6cmSPKKEzOFm/s1iNGqBk0a0d+BveDl6TdmmS9Vf0NEWyx9Cs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB4849.namprd10.prod.outlook.com
 (2603:10b6:208:321::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 00:30:27 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69%4]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 00:30:27 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 13/14] net: dsa: ocelot: add external ocelot switch control
Date:   Sun, 25 Sep 2022 17:29:27 -0700
Message-Id: <20220926002928.2744638-14-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220926002928.2744638-1-colin.foster@in-advantage.com>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0260.namprd04.prod.outlook.com
 (2603:10b6:303:88::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BLAPR10MB4849:EE_
X-MS-Office365-Filtering-Correlation-Id: 071a9def-53eb-4dae-350d-08da9f564ef4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gqfvoPDOrmMRr1HkSVFnbUi+kRuZ3jid2sfqp+W9lLTO8PNY46TjmWm+MAQqLA1FnE4tlx58RHnSwI+PrZAGHAlWWKITA2pcSrlQO/FyC3kxYyDTgtuXtfwGPq/XS1l4OZon0KWwH7jYSnJMonW79CkhTi5cipjR5AAeG4cvl0CTJnI/31xNcDsD0h/gdAi/iO3tOeuMpUzuy2/ikihRnqkQi4SwyZcH52Qc0patkbfyNxJqTkmUMpjEuMV8dO9vp+cBqErFnpEgnhpQKlLfHncWco7/TNyCXMZMLKX4GTKy1H/ysMkjXMHRmRD7TUk+0+WiNjaZ5LpAWhdSUSHAD6dFZlQ8JWj2kAaWZXLWE7IWpAT3R8qvDiHI78V8KpLFgH61S4jdqK4I7EIAwEpIFQSJPuVDcowY0Ig1VZuVusX3OQfWwDJAWZ0NdkegXe8HznJzM5DCY7ZpBwg5ZCBKlLNTAEpCqvt7/CIbR0FwrPw+IgjGXFwCG7chXKZAbtJEsA52zZO8OrqRGCdTSjmst4wppIgqmbutGhmf/jl37pQ8ClCAkT1BwHTrJ4lToXqENeO1CzIeD8TPmqesEMU+hsgQaPJOPlD+6XRU1ptDb/+L7UpCZlkhRYJXblEfqG23NwIfqdbuoHU9gNvWpAi21wOuRf0+VZzKxaTh668laNZYqW7QPMJEFDnX+lAOg9Hn5JbJkTQGoBk240HV9UX2GTaSNT+lLE/W9uqPe+KmAunORtdsZHXk0ijpauA06ZHT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(39830400003)(366004)(136003)(451199015)(54906003)(38100700002)(478600001)(6486002)(316002)(2906002)(2616005)(6506007)(6512007)(26005)(5660300002)(1076003)(8936002)(7416002)(186003)(52116002)(86362001)(8676002)(38350700002)(36756003)(44832011)(41300700001)(83380400001)(66946007)(66556008)(4326008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?077m6cTFLBFdeFnC1YpCPtygOlw1GbXSrSE4IhrgZW6irT9bxiVDiY15rVGm?=
 =?us-ascii?Q?l4k458/DjwtW23maquw2s3SneQ9vQa1vMWDUtjw+c+dp44dk6XM5miXTFvTp?=
 =?us-ascii?Q?JpADxW+f4fqqmcma9Msj2wgzWgbVknmHvtZEBJ0FBqYVOJbmjyyesKIwT+Dm?=
 =?us-ascii?Q?b1+aiuAzOz5a5BTK9VqYLdItZuYidQTP2c+H7YcqpG4ojqTN7L20188nfrfk?=
 =?us-ascii?Q?mNEDUZDaugnLCDADWlSXopMweLKlmd0ny7esvE6U2WXngVQPeEBrte4AHfvK?=
 =?us-ascii?Q?d8wqDjmoGnKqKytRhO1OanBPTOSM9VRA5mbObk1eddS1IHBcTt1UJtEIeGS3?=
 =?us-ascii?Q?jKMNIse920uePOHlvOAJgrJuIoN/NNU2V9sw//Khg7IHr/wbmPbvzNw2NZFB?=
 =?us-ascii?Q?FXYS/PPk+bxv69/0hqT4qm/GzJ++JjyLpeAq1VSwpDFOMBDC7zCcPHlWx50A?=
 =?us-ascii?Q?3mBaF+7bXok5ryI3fPqwBCDznxVigxbIzuXWQlezYG4snh/xNsas1TLPwk3n?=
 =?us-ascii?Q?z8aYURsla2u0RXvQjkNxXhSozQX8tclu6qO/tLL79JMmX5BrAz4F6vhen1G3?=
 =?us-ascii?Q?80n/R7ub3KqvaGnK6UywDWicnE4a2b6v/rIHOnkMK1hrLMITs5sjE6FE9vc8?=
 =?us-ascii?Q?RLkPfz3X9/7t+ZkH+XvwfFvW8hYw8ufwL8Uoml9+6PlSF7kXDiw1asa/t84u?=
 =?us-ascii?Q?bzovsvukzcEgk1kWSGpvMBRazSSVTJmPVrTea8QJjk/gNuZsrfYN3+kArOb4?=
 =?us-ascii?Q?fgidA19xH1cymR6wGO498nBUnDuNZY1wnKmVh7UVwwDXngkECu6U5j1UDMrO?=
 =?us-ascii?Q?PyOvtu4bjhMAxCWU/50Xex2Hw3CK96U8MgbdUwAL4uvDcrzwOROC6EVHa0aP?=
 =?us-ascii?Q?b4ks+XwQQ31UV9zc3ZCl/OX7mJSLkBuCU+WnzUfuAPLNXfvEP4swO6yLGP5N?=
 =?us-ascii?Q?x8HzNAbxMpQHcAxN8Y//WI78fqVS5/Ms5Z1lAkbNRe9EXB9JaOsv7vw4HKZB?=
 =?us-ascii?Q?U/U1rg0UzXxstfhBH5dPz5GvT3QPRekVW/FgES99IVKcXlwnuv7bv1Mbs7We?=
 =?us-ascii?Q?2Pg3UIhSPg3vRnwip8XbGR3LWco2W/IR5WPn2RNSkDPHjIbSfKppvK/x1ASs?=
 =?us-ascii?Q?0H/+uQ+MINIccxdFPODw72dOPgPkNoMBnlA6Fxn7zGzPtKeh8rjx2EyQjPwL?=
 =?us-ascii?Q?Xw0N7QGbJUcsqfCIHtu1w/WufyQ+yhz96wgbKfMvfUQt8Koobo9LJd8waDTH?=
 =?us-ascii?Q?MqtYUnCTw1AOLbLqN2jJ7oyS8LT5uG7GzbgPg0FPb02HLXxxsPfdCfPX0xcL?=
 =?us-ascii?Q?yleUNpp+QisdlkF/B+/oUJnO9dTsBn4bsX5isr/ePUra7fS+jFaL1KA3tx6s?=
 =?us-ascii?Q?HBHN3eQbTvKvFsVRpf1+THIZNJohCDDqrP4JXHp+vATNupEJNef15Pjcb8Tn?=
 =?us-ascii?Q?7rBOqRE9eBbe3BZ1PF5G4O/j3fycZ8Pda02ijtxPQtkZvsBKBSkYzTxe7L6I?=
 =?us-ascii?Q?Qd/OxgBae4de6sD1MarfyI+p2qpAyCYJMBJDpIFhzAMK0Sdep2CynqEXR5ak?=
 =?us-ascii?Q?fjxv7P4z3rIDpbcpT4HVMQ87tM9WNu3zie6GtuK1V3PLZKB6R0DEhYyGXRgd?=
 =?us-ascii?Q?GtHT/tlEnvz3k3Wc16vmMpE=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 071a9def-53eb-4dae-350d-08da9f564ef4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 00:30:26.8852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q3bywajhAf3N7hH/wdgxyHiNkA80LlS5XUQwunOxG+4D1tppC/HL7ULVOr9VG1dnvE/c1XBKyvKh4t1VwpK1YYKP2SBmrUhiSobzW1fmNxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/dsa/ocelot/Kconfig      |  19 +++
 drivers/net/dsa/ocelot/Makefile     |   5 +
 drivers/net/dsa/ocelot/ocelot_ext.c | 194 ++++++++++++++++++++++++++++
 4 files changed, 219 insertions(+)
 create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 1415a1498d68..214b3f836446 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14752,6 +14752,7 @@ M:	Colin Foster <colin.foster@in-advantage.com>
 S:	Supported
 F:	Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 F:	drivers/mfd/ocelot*
+F:	drivers/net/dsa/ocelot/ocelot_ext.c
 F:	include/linux/mfd/ocelot.h
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 08db9cf76818..74a900e16d76 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -1,4 +1,23 @@
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
index 000000000000..fb9dbb31fea1
--- /dev/null
+++ b/drivers/net/dsa/ocelot/ocelot_ext.c
@@ -0,0 +1,194 @@
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
+#define VSC7512_NUM_PORTS		11
+
+#define OCELOT_PORT_MODE_SERDES		(OCELOT_PORT_MODE_SGMII | \
+					 OCELOT_PORT_MODE_QSGMII)
+
+static const u32 vsc7512_port_modes[VSC7512_NUM_PORTS] = {
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_SERDES,
+	OCELOT_PORT_MODE_SERDES,
+	OCELOT_PORT_MODE_SERDES,
+	OCELOT_PORT_MODE_SERDES,
+	OCELOT_PORT_MODE_SERDES,
+	OCELOT_PORT_MODE_SERDES,
+	OCELOT_PORT_MODE_SGMII,
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
+	[DEV_GMII] = vsc7514_dev_gmii_regmap,
+};
+
+static void ocelot_ext_phylink_validate(struct ocelot *ocelot, int port,
+					unsigned long *supported,
+					struct phylink_link_state *state)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct dsa_switch *ds = felix->ds;
+	struct dsa_port *dp;
+
+	dp = dsa_to_port(ds, port);
+
+	phylink_generic_validate(&dp->pl_config, supported, state);
+}
+
+static struct regmap *ocelot_ext_regmap_init(struct ocelot *ocelot,
+					     const char *name)
+{
+	/* In the ocelot-mfd configuration, regmaps are attached to the device
+	 * by name alone, so dev_get_regmap will return the requested regmap
+	 * without the need to fully define the resource
+	 */
+	return dev_get_regmap(ocelot->dev->parent, name);
+}
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
+static const struct felix_info vsc7512_info = {
+	.target_io_res			= vsc7512_target_io_res,
+	.port_io_res			= vsc7512_port_io_res,
+	.regfields			= vsc7514_regfields,
+	.map				= vsc7512_regmap,
+	.ops				= &ocelot_ext_ops,
+	.stats_layout			= vsc7514_stats_layout,
+	.vcap				= vsc7514_vcap_props,
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

