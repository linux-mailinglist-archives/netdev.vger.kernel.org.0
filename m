Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5165E5A00
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 06:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiIVEEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 00:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiIVEDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 00:03:16 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2106.outbound.protection.outlook.com [40.107.223.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9ECAE217;
        Wed, 21 Sep 2022 21:02:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LUjK0JKTIW9m6XgMI2cl3ihhhVx1TE+l8JA/A5k3tr7VcYhBWUeO8i9txVNXrPo0auRC6IbBuMr05Tsy5d9Tw7L4wvKiiPtDHo5kVhwDebDDYZDLLhNOPowokrxEhsKnCMKTDc5R7BfeIq6RQttKYjS0E2zySnOW78z2Kyx0hPkWZ2LXdeMWBhbHDiUcImDhcJ2nB3BK8w4SsuxpAALmYzwJ6V6LEXB9ZF98pQCLTcIIyfqWco6eXr32CYYphilxYFVj1uIXQZBxiTrGDzInqd4/tYVHBTG8O2bwf7BLL4V74wspir8NcxRdmz1SffF9kAh2b7MCgSaUgmYQS1xtEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jHgzDR5G6kNB+IUJg2oz3zQaHP/FTuWOuq3MvpneilY=;
 b=RF1r2rTOmhCJkDh4+Dqo5Oovy0fMlCTnw7qvyk1y30RbXLUID17C29iHBG/a+DAUkvnMyB0H3rZbnfxCfaR2nd6uocS+xo1LD8QtC49ebw8oJ4B9UYsbLsmlt0wjiE4Q4QO1lT3bXyaiAvWQmutVd/9TtdGkVixkY2/VDiEemhvY97ifnxZinLxG6aCFc00abQPbHFYo/eJwAez6xYmcIxTKzIicS58xGi9xsVgv3nAVPAb6JFnXj84lplBsjAXtd482Na5zBfTjcuqA9MkOX8bZUh4nTFJXTkNTUlMVXGFxPNkvSI7dHym36TnTPMrDKWVdrzM0Z+0XgBvZLvaO3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHgzDR5G6kNB+IUJg2oz3zQaHP/FTuWOuq3MvpneilY=;
 b=XL6UUNs1q/nJqVvzM6DWGaEcuD4Xc7dIxIikAF+WDLhR13VjYT4oVubgqGudNzsK7Ubrn6bVRdWXlX8tO33SctC3hNs0UGr5CGAHUWYluXnAnqVsMAOWdlpQyjFF3A5DbmM/Qsg577TcTE6q6Ur0lS4/ap+SP3yQexjCd9cqHHw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by SA2PR10MB4412.namprd10.prod.outlook.com (2603:10b6:806:117::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 04:01:40 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e%5]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 04:01:39 +0000
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
Subject: [PATCH v2 net-next 13/14] net: dsa: ocelot: add external ocelot switch control
Date:   Wed, 21 Sep 2022 21:01:01 -0700
Message-Id: <20220922040102.1554459-14-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922040102.1554459-1-colin.foster@in-advantage.com>
References: <20220922040102.1554459-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|SA2PR10MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: 787fa305-b628-4fab-26a0-08da9c4f2702
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3UcN+2Mq6hhYKvHJVdp39WV2Phd3SChdhYb4JpaU2OCiFNrfsEsqmY0qqHedE9zwexZwWabODrcQ5g+/74yLPhyzVciSgFFNP1F3EVJh7s+L2nEynKsxqlbSzijrjFnb8+sX5Nw01Q4XbQsbbHyNt9354qOc8thHfBLpok6xHSOetDPEMpOyginovAUHYBSFQpRvnftby6ScI9d55K5zPtgX0+TzHn47d/QMYPvYfoQKEvIfqtdEPprubotzHIp5UrQAUVi1iHZ/ORj98t3VWys5f8uzNqf9eCAdL+N2SSkTjUjznOHUCb7h6H13dFzr+4sCYjHGlzcoFb0kDihFx9EREyEt3c5+skANzgy6QqTz9UriHAeF92JwnGPRgc1MBMtKl31ewftF3CFLuIGES3Jz7vdyCwnqcdUSEKufckKqe4BxrsLZy+2IZvZn1sXHFEsjSR2NEageskWfVyvJ/KJWrYFOvvjUdUTM1xzmlZ2i1YwbwgtKNKdr7BfUA0FTr+MPgGUZZGUzBodt0SKYqVRXO7bKtUtMkBd7J/aiUgpghw7p0rnN6ci+KCw5yq7MY176rOwNWW/xOUofzxwBClecCth2JI71CWTg7NpplI3KXAPoXdeCPEmkhW0VI2LD8jvPiv7r2IpD8PC6U3N49rogqpCU7T/0iiRZqvuSxV8C9KSpzLBnVXqAJ8BRnFI2D2tLjviGlITIcmtFIH8R2LsiMTKDblfhJ6CWyNTv2BNtqC2iNYg+4Ics+anYOEgoS/vzlbnrjzeDdYK2HGIjPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(396003)(346002)(136003)(39830400003)(451199015)(36756003)(6506007)(6666004)(52116002)(6512007)(26005)(86362001)(66476007)(66556008)(54906003)(4326008)(66946007)(41300700001)(8676002)(6486002)(38350700002)(38100700002)(83380400001)(2616005)(186003)(478600001)(1076003)(2906002)(316002)(5660300002)(7416002)(44832011)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nSCF3yf7Eh5ENprSLFPtNNF9Z5iN+iGVjugAbKuWA/EWQsEgyNLcI/18GIF4?=
 =?us-ascii?Q?/8h18ZxVFoaAfAZA9MGQdq0zrY9vCboACxxQ89QjfUntXSQY/1U4/t4RD2WM?=
 =?us-ascii?Q?Q4zET9Zi7qZ6iDjuvAHrEw59hqO6KbILCu6T1Eq2FyRBdleop4vpJGz6Cges?=
 =?us-ascii?Q?azD8ue6A/D5oN+GyWAUNExwCLLiRP3bUuVGfJYroHRVKeT93OwxYCppwiY1C?=
 =?us-ascii?Q?g+nK2u6ar8AynHGmItOf8nZfTzA18/PKM6DT4E94JXzO42HLLcAfewVaWz+6?=
 =?us-ascii?Q?bIZtfhJT2693TdcuvwM7KmY/GVIjKPez1DNAmMhVpY7KBKLtaQ7fTgIyTLvF?=
 =?us-ascii?Q?QSzphLy4LTLYKiNOp2UvL7Vcstgya2X8NM+EZzEFRrIdww0nLqcCn3orP2KX?=
 =?us-ascii?Q?TAUQuk0dmdd86tmktq30Tr8YE7EXf+8vMOYprGQbELcmvSNuFe8AXtda2qr0?=
 =?us-ascii?Q?jP7naOTuZl9ptv1SxUa//pSUY23b1mw4Et8A8fPMrqAI9Q54DobbsT7HAQ1R?=
 =?us-ascii?Q?9ULPQts9dZTlak55BEpUxbdBTOLOeGXl6HhBvRPqrZ62bn3T5GSQe0L2Ne73?=
 =?us-ascii?Q?tohpOHUy4NXtYsrdg0snjYZ8grQLbO+vBuwORpnQREWg5IaDOrtCDaFj8zGT?=
 =?us-ascii?Q?UkI29vZBKvl9Ofjblxo8zrvh1TYit7Mmeq4QbWllKeOVSADrnbZD/M0WArzg?=
 =?us-ascii?Q?/7L9qqUjw3tfRN/fbOIzdDxMSYl4k9yrah0AyFF+VPR8rR3id3K8XqyoYMGJ?=
 =?us-ascii?Q?Vitzlxn5BXrUCGEEAdKbbd+kZmUcpJ165TauSEV+YlIB0rcsO+ASzO0nydYA?=
 =?us-ascii?Q?4lA14g8hg7BgJkYrIlnJ7kkO8VEaO43lMJA4+B4qrtXQmspAUqoUPn9ttRDH?=
 =?us-ascii?Q?L03OkJXDv57Yw031mlbhYsSAXsw4xcgEkV0tm2cTXJWf7+YyY8VdKk52CoPp?=
 =?us-ascii?Q?FhCmbeQP/cZwx1yqNJ3qjb8xWCgR8CaGGBOFvHRlpfRxeGLIVhVsMufDFcV+?=
 =?us-ascii?Q?E5E2Y4PC9Ho0we8MJkutw9oamBEjJQbAOQaLYUcxoBPMTPXM8ysTAuJaQlgD?=
 =?us-ascii?Q?u1MQu4atnunoH5yPiMWkSK5Ons3ms/YAUNmposrDscrUgJ1jfPCvENuWhuwr?=
 =?us-ascii?Q?ZWKYmeKehSPt4//vUpXElPYMZBWXPYTDdRYLWergmxY6xuP4b++cGw2RDSxR?=
 =?us-ascii?Q?rkntEucpT2mC1BvQC0kWBCwSgd3HSsUL82mcbfqgKs9WCNe0VPUsfKs3mTAw?=
 =?us-ascii?Q?te3HtE/n/9pwTq2+gA7OowsaeXGdmBuLNhihmyUrJGVCU7wp/vRwk2JQu5+z?=
 =?us-ascii?Q?xECYSLnJJU6fixb4sjxQWVNBARCkQfDtx8fMrdnXZI8ZyJ0968phNErHl/Wk?=
 =?us-ascii?Q?whxVzB2ksWkM91pUB15zZ0QXcXPPkqrymuRqVz7A93lyrP0h4zqJ0mmzMfWb?=
 =?us-ascii?Q?rUrOSkX7HiV8Ph10LXt5l07z1EMFKQB4V4VlP4uQiGXEEJc9K5hWm4BIvcwy?=
 =?us-ascii?Q?gN8R2toU9bD8CnGBEGO9fb9m13Ca0JNfd88IyKY9BzUqM9WkUNQCsoexvKR4?=
 =?us-ascii?Q?Lg0x2+iwPSiXMUxUgeOPyOWHjQ4sp41fMwfoP2cMWDAu/n7q+R8UCr+G0KT/?=
 =?us-ascii?Q?pal/9MTy20i/u6gS+uYxYMs=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 787fa305-b628-4fab-26a0-08da9c4f2702
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 04:01:39.8710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IdWFxFfdT+YY9sml+cE1UovFLZXktlkeU4K+s0IE8I1mF70xa7+DTm1t9xP8hC0mPawdcsQZ7pECmN1ZI6K2hyAQuMopfv9uTmDEm+UwEIs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4412
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
index 6705fb8bfd3a..56192a218cb5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14751,6 +14751,7 @@ M:	Colin Foster <colin.foster@in-advantage.com>
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
index 000000000000..751e8b6a57a0
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
+	OCELOT_PORT_MODE_SERDES,
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
-- 
2.25.1

