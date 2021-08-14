Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75643EBFE7
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 04:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237079AbhHNCvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 22:51:04 -0400
Received: from mail-bn1nam07on2106.outbound.protection.outlook.com ([40.107.212.106]:10517
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236733AbhHNCuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 22:50:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MhVVPSl+cP7GwYZXpP5V1CBHOpc3S7ZVzQtN/XNknpQtRFE69AwC0DkDuhUGQu3yUWgf3farYXJTOcXPqDDIX5NoM+fqy31ST0kNhRbfZpv+x1y8iY8EFh92cV2rJubj37NimR8dhBL08FU0XYNiwpgflGdKjyLnLTq5Nso5qqSMX2J5MIYNYijDK8Wv0QnPrxP63tp9EpZLQp4/L0yEjzNRveo3CSxSlK3nFBzErybw7cHm9tYLzwgX7mWVghSZeGSH0/iCaLDfIlmnb9A0/YGnElyW55fkvSU0JXKJ6PDMCvcj0Tw/NlrpX04paGy4TPwJMYM0rF6hcq5InjMZsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jSACJlhlr4qGTGVyoTS8V6YouI90mtkDjr8RZ8wYXi4=;
 b=kJINfeVP9w+FTg/zs+FHoZuIrUiJdTKwtqNzmq8SR1SSAjxCuYUB5ioEF1Gu+JH+az8vvOy36WE01gyKqq412aUz4lyEDXDWG0nFTXWkGBxqzSAUwuJ/+XCcMIV15DR2oNgd4OJqbI+6iJ/vViAftAVpMx6RbsLlrBt743mSBPlvSy6ceaFz87aUKt3dIV3+s0jplcz8NX0xm/hX5cedyQvusYQ/6foYpSqlMgyh473cZJGW5JGfeQWov/6RcI8UosO56EcFesSEbr2ZSrDTfkLJy/reSKjxoiqJbiVr4LLGiw40gwAFDa2k6Vq0fv8Jnc9u7F0W0oVxinBiL0YEYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jSACJlhlr4qGTGVyoTS8V6YouI90mtkDjr8RZ8wYXi4=;
 b=WMTdE6LkRXJZ50Sh6sopxa3UvLe2Zm7H1pvXjDkRl92Rbh/S1A9SCmLo5QuvU8XbHofbDeI0HYZQc2hApJi4JXIm73nawAInV/amuNDiaQdpNZYPcxJBp5gqj43zGngx2ZoqxXRNvs/E8xf6cDHghCuwFHZvqNtUhV9z3XfRJjY=
Authentication-Results: in-advantage.com; dkim=none (message not signed)
 header.d=none;in-advantage.com; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB2030.namprd10.prod.outlook.com
 (2603:10b6:300:10d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Sat, 14 Aug
 2021 02:50:17 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4415.019; Sat, 14 Aug 2021
 02:50:17 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     colin.foster@in-advantage.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 net-next 03/10] net: dsa: ocelot: felix: switch to mdio-mscc-miim driver for indirect mdio access
Date:   Fri, 13 Aug 2021 19:49:56 -0700
Message-Id: <20210814025003.2449143-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210814025003.2449143-1-colin.foster@in-advantage.com>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::12) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.185.175.147) by MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Sat, 14 Aug 2021 02:50:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 160a890a-09c8-473f-560e-08d95ece3f87
X-MS-TrafficTypeDiagnostic: MWHPR10MB2030:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB203054EDE582804F82FE44C7A4FB9@MWHPR10MB2030.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CIY920MqIYUHAp2TPSyVhZT3SGSQzY4wCRTgmpyGVqtu6m5MGUWvqYblnFM4quL14JB2H3NJaVljq/OnHasRBAkpCOHTxyEzc3aWJhYbTrTyp5bPyZ1Zulz247mH9CMI7Uo9N/7PZg2UkFkVbv7F5gzj657IHu9b5h0SjL1HJs12s3mbtDWHYw6eG3fl7DoviOxLeCrlM5J2zcq1WMqF2tOYoHg9UCkMKmNmvQ5Zt7PxclCDKlW/g6XRAb0/dx9c0eTdGFcoP5L585dIr3kScTQEFb0GCXmj9rvKZ+JpRUfnq4dXNcNus5Fb4yxopwmvbP7lkwC3y+sFoHzag7OP2bVAXuzeqzEEVkJo6cttg6PMpqkqf9pkTM9b/kYOr5x5UuwL8+1I3MLi4Z4cfrBQg83oK98FRvNPxOfHunJj5jP19WJ7nU34EUXnhGMaNAiWZOFsmdwBAtITaoEryOT0jHnGjL4Dh6qHySUaDQxekfpCvDwLqsRGXgnMVmRZ+VnRwSketSN41dD6RysMybzNZ5VeOuWpn8f3YKb+JGJWXyoUsjwZMSC57ABsliUHCuYGD1BJtHGaNP8POHPn2u5+C42hymNqq3sIhtUok+cRhKKnVxwMBAKZ85a8IHqiqJR0MFmXO1mXQck0MVvSwPPB217HWNOG4KoPmJjmNVh7XWbS5hxyj+QaYziPHxmKDk070iyeBURaUfV/IsGKhqRM390ZdI9GEWQGIXks/6snqmI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39830400003)(136003)(376002)(186003)(5660300002)(30864003)(316002)(4326008)(8936002)(6486002)(2906002)(52116002)(66476007)(66556008)(44832011)(956004)(2616005)(66946007)(1076003)(921005)(36756003)(83380400001)(38100700002)(38350700002)(6512007)(6506007)(26005)(478600001)(8676002)(86362001)(6666004)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r2auc89r1AUNSyX8cvHWjgeLnpDaj9YuPkmanF3ccxN00xUELGUXPi81cuub?=
 =?us-ascii?Q?Uc0ux0eMsXIpxh4lOcUDuI6LOEYu4z2U+4sNinpTJkobKO0oOCD2SnS8uJm2?=
 =?us-ascii?Q?LzUAGkKosulerwV3IzrfFLxUuw0XiG4pj3eLlj/1+SKf0/l/HJ/9ex6ZABVW?=
 =?us-ascii?Q?82fa4/k5T8sdIYi6ooUssGqLdntVAF+WX934jDcd+eMGBiqoxweY2sIMupFx?=
 =?us-ascii?Q?Hfd4ijzIy25/DhgIBDGNotN3gvVzvto/m4vE839LM/vYf81tN40+XThrGpfE?=
 =?us-ascii?Q?czgwEee3KiAjhidmT0aRnhkKIqIGc/NSzCT1M4yV3zmM3hjLvWQdyrycYajC?=
 =?us-ascii?Q?ksc500RNgY+DegaNaGa8qTTTE/cwGvybecnZpPvDDRFTYDDkakjNl7gDZUua?=
 =?us-ascii?Q?fj0ufAysYqIWj98tzAVzfaC82BhMhxEMzc99VNu/xwmtIpiFg3Ci/KWi2lcJ?=
 =?us-ascii?Q?5W8DyNL61MFd96WQ/rNxqYZeRI6duFh3PlQdjCTaHr5N95+W5wvW50WUG6yr?=
 =?us-ascii?Q?t4rk9/TfPUdyW6PkAgLmWkYHe0lmFbjpWLrSvAvC628eblmc2Chjs7A3RzUm?=
 =?us-ascii?Q?LZaGZCFDCfgj25AeyCQ1E5VYLaNNv3SmHdbPKvdmlVIPs63yJyP5hmY0VI5X?=
 =?us-ascii?Q?5in2xy+INmAz3oHjgu3e9E78hxJttWcRuAcJX3TSoWm22aWa+x3JPVKGlQqE?=
 =?us-ascii?Q?s9/tLKApNdaXG6RVJH0/slKE3aGloedWyKx2g/CQsHw4rhg79xJQD55NDbiK?=
 =?us-ascii?Q?tewqnOA8G9fZoykFu24uPK9yRMcSxeCd0tQPvSdcjb2Vr/M6+mXB7l7TbbjR?=
 =?us-ascii?Q?rCzsmymGBnw6YyKIdrK0zY1eNH/vvdBKvOCRsdC4uzXph2tiHAscTuQavVIm?=
 =?us-ascii?Q?4V64TZ20mBcPXsV6WFz6s8xY/KruT0mko65Mhc3l7CRElVFUOl1THg3S3L5f?=
 =?us-ascii?Q?rGgj9DPyNldMl3tKRVaWpSvgqRO8Vkmjf75q2qgVcO11zv41Xs4tV3zs6ndL?=
 =?us-ascii?Q?ZkxvLysvjFiKb9aHF55x5GQxb0x5OZtR34Sh01VArmvLgoSHuJ3Def1E17q0?=
 =?us-ascii?Q?TcCxqTD6tAr495f9Xpy0dFvFD4cfbkVXVL3RCGvz2kQ04rDf6OOkcQD7sY1K?=
 =?us-ascii?Q?D8xqLKyhxZLPDUfB56MSDCX65WpYUzTksH/+etRsSho3aQddftKnyHKt5xBk?=
 =?us-ascii?Q?V5yaHeqN3vf4Oh4od38WgXm/pKnwfaEFVLHLKAUUqKcGTfvoxS4fM+IBnpCR?=
 =?us-ascii?Q?hxevyKN/X1mPJjpuWSwdh4EUIToMbATiHt4remNY+/J6sMfs9tVypgIfrFaV?=
 =?us-ascii?Q?eHdbGo55q4PW0n9UG81vB/2w?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 160a890a-09c8-473f-560e-08d95ece3f87
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2021 02:50:17.3542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x9o9GmiezuP3ZjVTDgB8DVjWQoiaXUChWMp2YOiQqd/UFVQLPnCvnEPyVFpLsUZH5fgvOOFkd5EyE14r7UU6J/12O++52yVAPRJn8QFwU34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB2030
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch to a shared MDIO access implementation now provided by
drivers/net/mdio/mdio-mscc-miim.c

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/Kconfig           |   1 +
 drivers/net/dsa/ocelot/Makefile          |   1 +
 drivers/net/dsa/ocelot/felix_mdio.c      |  52 +++++++++++
 drivers/net/dsa/ocelot/felix_mdio.h      |  12 +++
 drivers/net/dsa/ocelot/seville_vsc9953.c | 108 ++---------------------
 drivers/net/mdio/mdio-mscc-miim.c        |  39 +++++---
 include/linux/mdio/mdio-mscc-miim.h      |  19 ++++
 7 files changed, 119 insertions(+), 113 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/felix_mdio.c
 create mode 100644 drivers/net/dsa/ocelot/felix_mdio.h
 create mode 100644 include/linux/mdio/mdio-mscc-miim.h

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 932b6b6fe817..61bcc88ae4c1 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -19,6 +19,7 @@ config NET_DSA_MSCC_SEVILLE
 	depends on NET_DSA
 	depends on NET_VENDOR_MICROSEMI
 	depends on HAS_IOMEM
+	select MDIO_MSCC_MIIM
 	select MSCC_OCELOT_SWITCH_LIB
 	select NET_DSA_TAG_OCELOT_8021Q
 	select NET_DSA_TAG_OCELOT
diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makefile
index f6dd131e7491..34b9b128efb8 100644
--- a/drivers/net/dsa/ocelot/Makefile
+++ b/drivers/net/dsa/ocelot/Makefile
@@ -8,4 +8,5 @@ mscc_felix-objs := \
 
 mscc_seville-objs := \
 	felix.o \
+	felix_mdio.o \
 	seville_vsc9953.o
diff --git a/drivers/net/dsa/ocelot/felix_mdio.c b/drivers/net/dsa/ocelot/felix_mdio.c
new file mode 100644
index 000000000000..aeb036dedd12
--- /dev/null
+++ b/drivers/net/dsa/ocelot/felix_mdio.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Distributed Switch Architecture VSC9953 driver
+ * Copyright (C) 2020, Maxim Kochetkov <fido_max@inbox.ru>
+ */
+#include <linux/types.h>
+#include <soc/mscc/ocelot.h>
+#include <linux/dsa/ocelot.h>
+#include <linux/mdio/mdio-mscc-miim.h>
+#include "felix.h"
+#include "felix_mdio.h"
+
+int felix_mdio_register(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct device *dev = ocelot->dev;
+	int rc;
+
+	/* Needed in order to initialize the bus mutex lock */
+	rc = mdiobus_register(felix->imdio);
+	if (rc < 0) {
+		dev_err(dev, "failed to register MDIO bus\n");
+		felix->imdio = NULL;
+	}
+
+	return rc;
+}
+
+int felix_mdio_bus_alloc(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct device *dev = ocelot->dev;
+	struct mii_bus *bus;
+	int err;
+
+	err = mscc_miim_setup(dev, &bus, ocelot->targets[GCB],
+			      ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK],
+			      ocelot->targets[GCB],
+			      ocelot->map[GCB][GCB_PHY_PHY_CFG & REG_MASK]);
+
+	if (!err)
+		felix->imdio = bus;
+
+	return err;
+}
+
+void felix_mdio_bus_free(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	if (felix->imdio)
+		mdiobus_unregister(felix->imdio);
+}
diff --git a/drivers/net/dsa/ocelot/felix_mdio.h b/drivers/net/dsa/ocelot/felix_mdio.h
new file mode 100644
index 000000000000..261e979e6955
--- /dev/null
+++ b/drivers/net/dsa/ocelot/felix_mdio.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/* Shared code for indirect MDIO access for Felix drivers
+ *
+ * Author: Colin Foster <colin.foster@in-advantage.com>
+ * Copyright (C) 2021 Innovative Advantage
+ */
+#include <linux/types.h>
+#include <soc/mscc/ocelot.h>
+
+int felix_mdio_bus_alloc(struct ocelot *ocelot);
+int felix_mdio_register(struct ocelot *ocelot);
+void felix_mdio_bus_free(struct ocelot *ocelot);
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 84f93a874d50..0e06750db264 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -11,13 +11,7 @@
 #include <linux/dsa/ocelot.h>
 #include <linux/iopoll.h>
 #include "felix.h"
-
-#define MSCC_MIIM_CMD_OPR_WRITE			BIT(1)
-#define MSCC_MIIM_CMD_OPR_READ			BIT(2)
-#define MSCC_MIIM_CMD_WRDATA_SHIFT		4
-#define MSCC_MIIM_CMD_REGAD_SHIFT		20
-#define MSCC_MIIM_CMD_PHYAD_SHIFT		25
-#define MSCC_MIIM_CMD_VLD			BIT(31)
+#include "felix_mdio.h"
 
 static const u32 vsc9953_ana_regmap[] = {
 	REG(ANA_ADVLEARN,			0x00b500),
@@ -857,7 +851,6 @@ static struct vcap_props vsc9953_vcap_props[] = {
 #define VSC9953_INIT_TIMEOUT			50000
 #define VSC9953_GCB_RST_SLEEP			100
 #define VSC9953_SYS_RAMINIT_SLEEP		80
-#define VCS9953_MII_TIMEOUT			10000
 
 static int vsc9953_gcb_soft_rst_status(struct ocelot *ocelot)
 {
@@ -877,82 +870,6 @@ static int vsc9953_sys_ram_init_status(struct ocelot *ocelot)
 	return val;
 }
 
-static int vsc9953_gcb_miim_pending_status(struct ocelot *ocelot)
-{
-	int val;
-
-	ocelot_field_read(ocelot, GCB_MIIM_MII_STATUS_PENDING, &val);
-
-	return val;
-}
-
-static int vsc9953_gcb_miim_busy_status(struct ocelot *ocelot)
-{
-	int val;
-
-	ocelot_field_read(ocelot, GCB_MIIM_MII_STATUS_BUSY, &val);
-
-	return val;
-}
-
-static int vsc9953_mdio_write(struct mii_bus *bus, int phy_id, int regnum,
-			      u16 value)
-{
-	struct ocelot *ocelot = bus->priv;
-	int err, cmd, val;
-
-	/* Wait while MIIM controller becomes idle */
-	err = readx_poll_timeout(vsc9953_gcb_miim_pending_status, ocelot,
-				 val, !val, 10, VCS9953_MII_TIMEOUT);
-	if (err) {
-		dev_err(ocelot->dev, "MDIO write: pending timeout\n");
-		goto out;
-	}
-
-	cmd = MSCC_MIIM_CMD_VLD | (phy_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
-	      (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
-	      (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
-	      MSCC_MIIM_CMD_OPR_WRITE;
-
-	ocelot_write(ocelot, cmd, GCB_MIIM_MII_CMD);
-
-out:
-	return err;
-}
-
-static int vsc9953_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
-{
-	struct ocelot *ocelot = bus->priv;
-	int err, cmd, val;
-
-	/* Wait until MIIM controller becomes idle */
-	err = readx_poll_timeout(vsc9953_gcb_miim_pending_status, ocelot,
-				 val, !val, 10, VCS9953_MII_TIMEOUT);
-	if (err) {
-		dev_err(ocelot->dev, "MDIO read: pending timeout\n");
-		goto out;
-	}
-
-	/* Write the MIIM COMMAND register */
-	cmd = MSCC_MIIM_CMD_VLD | (phy_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
-	      (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) | MSCC_MIIM_CMD_OPR_READ;
-
-	ocelot_write(ocelot, cmd, GCB_MIIM_MII_CMD);
-
-	/* Wait while read operation via the MIIM controller is in progress */
-	err = readx_poll_timeout(vsc9953_gcb_miim_busy_status, ocelot,
-				 val, !val, 10, VCS9953_MII_TIMEOUT);
-	if (err) {
-		dev_err(ocelot->dev, "MDIO read: busy timeout\n");
-		goto out;
-	}
-
-	val = ocelot_read(ocelot, GCB_MIIM_MII_DATA);
-
-	err = val & 0xFFFF;
-out:
-	return err;
-}
 
 /* CORE_ENA is in SYS:SYSTEM:RESET_CFG
  * MEM_INIT is in SYS:SYSTEM:RESET_CFG
@@ -1086,7 +1003,6 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 {
 	struct felix *felix = ocelot_to_felix(ocelot);
 	struct device *dev = ocelot->dev;
-	struct mii_bus *bus;
 	int port;
 	int rc;
 
@@ -1098,26 +1014,18 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 		return -ENOMEM;
 	}
 
-	bus = devm_mdiobus_alloc(dev);
-	if (!bus)
-		return -ENOMEM;
-
-	bus->name = "VSC9953 internal MDIO bus";
-	bus->read = vsc9953_mdio_read;
-	bus->write = vsc9953_mdio_write;
-	bus->parent = dev;
-	bus->priv = ocelot;
-	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-imdio", dev_name(dev));
+	rc = felix_mdio_bus_alloc(ocelot);
+	if (rc < 0) {
+		dev_err(dev, "failed to allocate MDIO bus\n");
+		return rc;
+	}
 
-	/* Needed in order to initialize the bus mutex lock */
-	rc = mdiobus_register(bus);
+	rc = felix_mdio_register(ocelot);
 	if (rc < 0) {
 		dev_err(dev, "failed to register MDIO bus\n");
 		return rc;
 	}
 
-	felix->imdio = bus;
-
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
 		int addr = port + 4;
@@ -1162,7 +1070,7 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
 		mdio_device_free(pcs->mdio);
 		lynx_pcs_destroy(pcs);
 	}
-	mdiobus_unregister(felix->imdio);
+	felix_mdio_bus_free(ocelot);
 }
 
 static const struct felix_info seville_info_vsc9953 = {
diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index e1849e25c9ca..9a1f5ef2409f 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -10,6 +10,7 @@
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
+#include <linux/mdio/mdio-mscc-miim.h>
 #include <linux/module.h>
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
@@ -37,7 +38,9 @@
 
 struct mscc_miim_dev {
 	struct regmap *regs;
+	int mii_status_offset;
 	struct regmap *phy_regs;
+	int phy_reset_offset;
 };
 
 /* When high resolution timers aren't built-in: we can't use usleep_range() as
@@ -56,7 +59,8 @@ static int mscc_miim_status(struct mii_bus *bus)
 	struct mscc_miim_dev *miim = bus->priv;
 	int val;
 
-	regmap_read(miim->regs, MSCC_MIIM_REG_STATUS, &val);
+	regmap_read(miim->regs, MSCC_MIIM_REG_STATUS + miim->mii_status_offset,
+		    &val);
 
 	return val;
 }
@@ -89,8 +93,8 @@ static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
 	if (ret)
 		goto out;
 
-	regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
-		     (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
+	regmap_write(miim->regs, miim->mii_status_offset + MSCC_MIIM_REG_CMD,
+		     MSCC_MIIM_CMD_VLD | (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
 		     (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
 		     MSCC_MIIM_CMD_OPR_READ);
 
@@ -98,7 +102,8 @@ static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
 	if (ret)
 		goto out;
 
-	regmap_read(miim->regs, MSCC_MIIM_REG_DATA, &val);
+	regmap_read(miim->regs, miim->mii_status_offset + MSCC_MIIM_REG_DATA,
+		    &val);
 	if (val & MSCC_MIIM_DATA_ERROR) {
 		ret = -EIO;
 		goto out;
@@ -119,8 +124,8 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
 	if (ret < 0)
 		goto out;
 
-	regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
-		     (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
+	regmap_write(miim->regs, miim->mii_status_offset + MSCC_MIIM_REG_CMD,
+		     MSCC_MIIM_CMD_VLD | (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
 		     (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
 		     (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
 		     MSCC_MIIM_CMD_OPR_WRITE);
@@ -134,8 +139,11 @@ static int mscc_miim_reset(struct mii_bus *bus)
 	struct mscc_miim_dev *miim = bus->priv;
 
 	if (miim->phy_regs) {
-		regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0);
-		regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0x1ff);
+		regmap_write(miim->phy_regs,
+			     miim->phy_reset_offset + MSCC_PHY_REG_PHY_CFG, 0);
+		regmap_write(miim->phy_regs,
+			     miim->phy_reset_offset + MSCC_PHY_REG_PHY_CFG,
+			     0x1ff);
 		mdelay(500);
 	}
 
@@ -148,10 +156,12 @@ static const struct regmap_config mscc_miim_regmap_config = {
 	.reg_stride	= 4,
 };
 
-static int mscc_miim_setup(struct device *dev, struct mii_bus *bus,
-			   struct regmap *mii_regmap, struct regmap *phy_regmap)
+int mscc_miim_setup(struct device *dev, struct mii_bus **pbus,
+		    struct regmap *mii_regmap, int status_offset,
+		    struct regmap *phy_regmap, int reset_offset)
 {
 	struct mscc_miim_dev *miim;
+	struct mii_bus *bus;
 
 	bus = devm_mdiobus_alloc_size(dev, sizeof(*miim));
 	if (!bus)
@@ -167,10 +177,15 @@ static int mscc_miim_setup(struct device *dev, struct mii_bus *bus,
 	miim = bus->priv;
 
 	miim->regs = mii_regmap;
+	miim->mii_status_offset = status_offset;
 	miim->phy_regs = phy_regmap;
+	miim->phy_reset_offset = reset_offset;
+
+	*pbus = bus;
 
 	return 0;
 }
+EXPORT_SYMBOL(mscc_miim_setup);
 
 static int mscc_miim_probe(struct platform_device *pdev)
 {
@@ -185,8 +200,6 @@ static int mscc_miim_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENODEV;
 
-	dev = bus->priv;
-
 	regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(regs)) {
 		dev_err(&pdev->dev, "Unable to map MIIM registers\n");
@@ -218,7 +231,7 @@ static int mscc_miim_probe(struct platform_device *pdev)
 		}
 	}
 
-	mscc_miim_setup(&pdev->dev, bus, mii_regmap, phy_regmap);
+	mscc_miim_setup(&pdev->dev, &bus, mii_regmap, 0, phy_regmap, 0);
 
 	ret = of_mdiobus_register(bus, pdev->dev.of_node);
 	if (ret < 0) {
diff --git a/include/linux/mdio/mdio-mscc-miim.h b/include/linux/mdio/mdio-mscc-miim.h
new file mode 100644
index 000000000000..3ceab7b6ffc1
--- /dev/null
+++ b/include/linux/mdio/mdio-mscc-miim.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+/*
+ * Driver for the MDIO interface of Microsemi network switches.
+ *
+ * Author: Colin Foster <colin.foster@in-advantage.com>
+ * Copyright (C) 2021 Innovative Advantage
+ */
+#ifndef MDIO_MSCC_MIIM_H
+#define MDIO_MSCC_MIIM_H
+
+#include <linux/device.h>
+#include <linux/phy.h>
+#include <linux/regmap.h>
+
+int mscc_miim_setup(struct device *device, struct mii_bus **bus,
+		    struct regmap *mii_regmap, int status_offset,
+		    struct regmap *phy_regmap, int reset_offset);
+
+#endif
-- 
2.25.1

