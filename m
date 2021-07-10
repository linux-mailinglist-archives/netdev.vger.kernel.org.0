Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2D33C366F
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 21:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhGJT3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 15:29:19 -0400
Received: from mail-bn7nam10on2107.outbound.protection.outlook.com ([40.107.92.107]:9249
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231124AbhGJT3K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 15:29:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DxqX3/blZh9JMs2NKjdbf3UZwgCQ6H36Bak9syw/ydIGj6PUQBBliqAJ/PZRaffTz13D5HyKGWc4iKVOo92ebwcqqPIlUqPNhAcx2cj1LY3JPa2jD4weL/jyqDC8zfq0zEtkgDRYjNWLOBWR9axW9nUAsHeLZNUgNQLEZ4b8TikhW169S8TR5nrUtdWcjSKHFLv8ZxGVaCCrciSOhbw2T4yW+KgM4gor8/PYTTAx0kBDGoQ5JiIST6W6asBXpyCw+gty2mxWA8q8nDlWjjnddamH/KjtXnB0HF2ZBuPEnA8NtIXEyOfBy2R63BSIgEJMfuT9RRVFKiFF4iUPLIIQug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUzr8oJMlUBhLd8/2h0ql3LcVVMC6AyLgA5o8dxo9RI=;
 b=TZ1hIOx5kfN0nabjl2smJHuPUXL+Bzcrt/Xtec1Uw+AkXbKgXfusuaJ1lryWs9y7DYcx54F5ttb+BPiGSZGlbpEbIvhb3g+vCJuFAbwdaacpUnfIU5ZWI1AcZhGrZggXWvlRomTxkGl0u9Il58xOCj1AANoeeYVQuBF+TQFAwI++n5ubgY/sVBKWUOM4QZoKaz7VhRBxNLzPCTwZhGIr1NeSVV7zisFliku0tBiAmk4xTQmRRiwJvUKTRr6XZ+CnQ1+eKnpAs5CiZhdNxV0/Afvn18CZBWrmPaUUySkgUTdCRBRB3byVANC04Iuu8OgzqeOYVCf9506DoIvtkmSJOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUzr8oJMlUBhLd8/2h0ql3LcVVMC6AyLgA5o8dxo9RI=;
 b=CrOKZS+JY13Ge+xZOyVBvR9KFntXbS1KfdW6/nsmMEY3HxL3IhOKoiAtNdnEzZ9LF+KQuPaOunQleBf6CbJIqKt9QgaEF4eeoQn6DYrQqYxsgFDPugMPzOLA1P3ttvwA17ED1IDpuVkWGObWTxsK6o2trqAfHoz4UHlLrqvvwxE=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1709.namprd10.prod.outlook.com
 (2603:10b6:301:7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Sat, 10 Jul
 2021 19:26:18 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4287.033; Sat, 10 Jul 2021
 19:26:18 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 net-next 2/8] net: dsa: ocelot: felix: move MDIO access to a common location
Date:   Sat, 10 Jul 2021 12:25:56 -0700
Message-Id: <20210710192602.2186370-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210710192602.2186370-1-colin.foster@in-advantage.com>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR12CA0042.namprd12.prod.outlook.com
 (2603:10b6:301:2::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.185.175.147) by MWHPR12CA0042.namprd12.prod.outlook.com (2603:10b6:301:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Sat, 10 Jul 2021 19:26:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 487a1e4b-9225-4d6e-96a8-08d943d8970c
X-MS-TrafficTypeDiagnostic: MWHPR10MB1709:
X-Microsoft-Antispam-PRVS: <MWHPR10MB17091A6958E896AA1BE32133A4179@MWHPR10MB1709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:352;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rhhSaV0y+IfhXuTeNXayXw1Sc8o6OgIFK/1jWWi0MtzTjyfgIiNGNEmTPRYNQEQ7Ccoql1+jVuI5WYYlKNj/K9Xo3u3GnS8fpf4je4oNpEktbZzA82aGDsusxolRowCLDRrQFMDJ0RnkF4WxZtXQzIbpd03sA7Rrk3K+u7n/PH1Oq6qSp+sKW2+iZgTtfSveLX7LPs3byCKMc1tlQOmRMH2mo+LpZQ+6ZtEaGsL250BoJ5pvXUeds2S/gbKgXKdPPV7az1I0R9T/OZ82Nq9kpOTV7yod9fYpTNKCrVL7DgFZ79GmcUBvHLlscd++alTcHqnQcQd65QyufVRfx/JQh4EZ2M9yomDF7lSsyHSwKW4jWCFIvUWR3i5isWd2yyW8XBeSjgiF5OOYujOMkFirprbqQ9dy18NhCyUnlglX8ntRJJd9hDHp5xr2X56+i455x93L2rPa0yycQKwwHOsOopf1KN2mUtKzP1Jwj6lVxzM5/JpQi95OIIAM7sK6I40i4fiXBSt1/6ykwkZ8H82bw4cBx5m4ysZGvBniZn1cWU8o/FoJbRLGbswckSOWY/0zeVV/vEn89ezImv/Ck95iGLft40f5sobug1d8RwxVERW+z1ag0yGOo3hty1lAEyTI7wheSpXsM6VjJDUR9mH1h77heyHu8bUJ8sWh/3Xp7kl0YYBf7/IhzXfluSg9wsYOPQzt57agKdwabZOF+Av5tqiwpty94aTOhCKYQFLA78Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(39830400003)(136003)(366004)(8936002)(7416002)(6506007)(5660300002)(2906002)(66556008)(26005)(2616005)(8676002)(44832011)(6486002)(6512007)(66476007)(6666004)(38100700002)(38350700002)(52116002)(66946007)(921005)(4326008)(956004)(83380400001)(1076003)(316002)(36756003)(86362001)(186003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1LaP3zl82at/tAY/q+Gc9onUJYSbA5+D3XdDbf+zFQGGuVeuqhLtOm2I6B4S?=
 =?us-ascii?Q?fqnwCJxW93X/1DHs4uNYSiRA1jK7pReNRMtXtrtFWUo3n/e67+ufr4QTon1W?=
 =?us-ascii?Q?P9l9ej3DXwziXhXxRKkGKtvkQaMoySs7zbFAzH/SHJdE9kioDLgD1YKymcCa?=
 =?us-ascii?Q?1AxjAReO/cZA8PrPSsF/3gmwTt5G91A4c0PMFxvoTuDvYLa0JzQBUyeM6EjY?=
 =?us-ascii?Q?p4ptIrG+FTgZJZ1GET+j6O6LF/OCXOrulNNm5WSFMXIcw3KKb7WJknCwFGs4?=
 =?us-ascii?Q?uu0F/kS/5LWXEfQK23S/S2RasarA/b8nZFPZPagpj8QzCLA6OVFIqR896kWZ?=
 =?us-ascii?Q?S8uEbJSrhIXUEzGj/6XOXAH5fZng7cp2a2qQgkTLHH72TalSPHIDyj1cd0Ue?=
 =?us-ascii?Q?+qMgDmhb5u4A675rqcBTw2WZEAWTyB332uKeSjkZZPm5EYftybNGqx0Kzqc/?=
 =?us-ascii?Q?eb84+mf93fowqhvpKjgXsnsRD93QptnAZtbwdyCvMlNkAsXMvA+lsalU+iSG?=
 =?us-ascii?Q?h1HirHzeCptbBAsNVihn2tFfPDCWCKzU722XbNH3SwQvtJ/1VGmlQxIcQjBb?=
 =?us-ascii?Q?5N64UBzln/dEqwnzz18YL/FaDoF24XlE8dOY4H3+b6+Fmgl8jB/jEoq1UMzG?=
 =?us-ascii?Q?pbIiGuhrDUebtWLSw7F1wncdjK/mpuuaABAxWN0TuboAICLQ8dC5XYtEjEhu?=
 =?us-ascii?Q?HGr1mKEIrtNsBvTHFOYnat974Q9+OyfZeBhAwthWHPMtDP1kQJUhmWQrvR11?=
 =?us-ascii?Q?XzCpkTeg13oIm8jLw1x7XDieZb8Bm+ao97/Tc2GGAeuxe0N5Bms+ZSMkMEq/?=
 =?us-ascii?Q?3uLRhWj8BGHMg3YcuHRtdNz0P2NgXOMll4BS9g2gdWgu+ngVQfU8GVoyzext?=
 =?us-ascii?Q?J7+5XZ7OkbnQwGwnhljZW7YWbytpqpbljkyE7+UcK/ScRzcgTzG+bG63zsr+?=
 =?us-ascii?Q?CDrbZh1K593iNmtq2Qx1gqK6MDCe//QTYsL3bimmVC3a08fZn1Gqkzj3iB6z?=
 =?us-ascii?Q?jiHhAMFvUXxv5WT03v2UGsiE2Z0AT8sWq3OFRT1Qv5CQGOMkcSYCAqsQTUaW?=
 =?us-ascii?Q?XqVm74eqTsN+YDfB5idBm+xK0Yxicz854ypQ0zIaLttMYPEpSHf9Ud+7BOni?=
 =?us-ascii?Q?4yBpsbW1VqZhQ+m67dQH//btATSOeV8okFtLj0NGs61WR55HCfd+IeQ2Y194?=
 =?us-ascii?Q?ewMrbfXFGFg2+jTVAifeEKxxbjJXQ2TF5bHVxyj7fqY3u/McyYozTgc0aMc8?=
 =?us-ascii?Q?jWFxGJXBjru+zL/L23kxF6w3dszU06jDkU/UbfDMXUu2Rpzup8bUenM7VPze?=
 =?us-ascii?Q?b68o0GVgGa690nTHxmLx0l8U?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 487a1e4b-9225-4d6e-96a8-08d943d8970c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2021 19:26:17.7896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4rTCVV+t8UCeedk8bZfoCp56AUha1q8w9Ya8lgvv1PfML5EwIlvhw8VpgumyGamFDdu7tpU8j5qYInDhXFIpBMCtr1Gb0KWIszUDDtGGAmM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Indirect MDIO access is a feature that doesn't need to be specific to the
Seville driver. Separate the feature to a common file so it can be shared.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/Makefile          |   1 +
 drivers/net/dsa/ocelot/felix_mdio.c      | 145 +++++++++++++++++++++++
 drivers/net/dsa/ocelot/felix_mdio.h      |  11 ++
 drivers/net/dsa/ocelot/seville_vsc9953.c | 108 ++---------------
 4 files changed, 165 insertions(+), 100 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/felix_mdio.c
 create mode 100644 drivers/net/dsa/ocelot/felix_mdio.h

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
index 000000000000..d58583311c9a
--- /dev/null
+++ b/drivers/net/dsa/ocelot/felix_mdio.c
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Distributed Switch Architecture VSC9953 driver
+ * Copyright (C) 2020, Maxim Kochetkov <fido_max@inbox.ru>
+ */
+#include <linux/types.h>
+#include <soc/mscc/ocelot.h>
+#include <linux/dsa/ocelot.h>
+#include <linux/iopoll.h>
+#include "felix.h"
+
+#define MSCC_MIIM_CMD_OPR_WRITE			BIT(1)
+#define MSCC_MIIM_CMD_OPR_READ			BIT(2)
+#define MSCC_MIIM_CMD_WRDATA_SHIFT		4
+#define MSCC_MIIM_CMD_REGAD_SHIFT		20
+#define MSCC_MIIM_CMD_PHYAD_SHIFT		25
+#define MSCC_MIIM_CMD_VLD			BIT(31)
+
+#define FELIX_MDIO_MII_TIMEOUT			10000
+#define FELIX_MDIO_MII_RETRY			10
+
+static int felix_gcb_miim_pending_status(struct ocelot *ocelot)
+{
+	int val;
+
+	ocelot_field_read(ocelot, GCB_MIIM_MII_STATUS_PENDING, &val);
+
+	return val;
+}
+
+static int felix_gcb_miim_busy_status(struct ocelot *ocelot)
+{
+	int val;
+
+	ocelot_field_read(ocelot, GCB_MIIM_MII_STATUS_BUSY, &val);
+
+	return val;
+}
+
+static int felix_mdio_write(struct mii_bus *bus, int phy_id, int regnum,
+			    u16 value)
+{
+	struct ocelot *ocelot = bus->priv;
+	int err, cmd, val;
+
+	/* Wait while MIIM controller becomes idle */
+	err = readx_poll_timeout(felix_gcb_miim_pending_status, ocelot, val,
+				 !val, FELIX_MDIO_MII_RETRY,
+				 FELIX_MDIO_MII_TIMEOUT);
+	if (err) {
+		dev_err(ocelot->dev, "MDIO write: pending timeout\n");
+		goto out;
+	}
+
+	cmd = MSCC_MIIM_CMD_VLD | (phy_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
+	      (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
+	      (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
+	      MSCC_MIIM_CMD_OPR_WRITE;
+
+	ocelot_write(ocelot, cmd, GCB_MIIM_MII_CMD);
+
+out:
+	return err;
+}
+
+static int felix_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
+{
+	struct ocelot *ocelot = bus->priv;
+	int err, cmd, val;
+
+	/* Wait until MIIM controller becomes idle */
+	err = readx_poll_timeout(felix_gcb_miim_pending_status, ocelot, val,
+				 !val, FELIX_MDIO_MII_RETRY,
+				 FELIX_MDIO_MII_TIMEOUT);
+	if (err) {
+		dev_err(ocelot->dev, "MDIO read: pending timeout\n");
+		goto out;
+	}
+
+	/* Write the MIIM COMMAND register */
+	cmd = MSCC_MIIM_CMD_VLD | (phy_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
+	      (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) | MSCC_MIIM_CMD_OPR_READ;
+
+	ocelot_write(ocelot, cmd, GCB_MIIM_MII_CMD);
+
+	/* Wait while read operation via the MIIM controller is in progress */
+	err = readx_poll_timeout(felix_gcb_miim_busy_status, ocelot, val, !val,
+				 FELIX_MDIO_MII_RETRY, FELIX_MDIO_MII_TIMEOUT);
+	if (err) {
+		dev_err(ocelot->dev, "MDIO read: busy timeout\n");
+		goto out;
+	}
+
+	val = ocelot_read(ocelot, GCB_MIIM_MII_DATA);
+
+	err = val & 0xFFFF;
+out:
+	return err;
+}
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
+
+	bus = devm_mdiobus_alloc(dev);
+	if (!bus)
+		return -ENOMEM;
+
+	bus->name = "Felix internal MDIO bus";
+	bus->read = felix_mdio_read;
+	bus->write = felix_mdio_write;
+	bus->parent = dev;
+	bus->priv = ocelot;
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-imdio", dev_name(dev));
+
+	felix->imdio = bus;
+
+	return 0;
+}
+
+void felix_mdio_bus_free(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	if (felix->imdio)
+		mdiobus_unregister(felix->imdio);
+}
+
diff --git a/drivers/net/dsa/ocelot/felix_mdio.h b/drivers/net/dsa/ocelot/felix_mdio.h
new file mode 100644
index 000000000000..46fd41f605a9
--- /dev/null
+++ b/drivers/net/dsa/ocelot/felix_mdio.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Distributed Switch Architecture VSC9953 driver
+ * Copyright (C) 2020, Maxim Kochetkov <fido_max@inbox.ru>
+ */
+#include <linux/types.h>
+#include <soc/mscc/ocelot.h>
+
+int felix_mdio_bus_alloc(struct ocelot *ocelot);
+int felix_mdio_register(struct ocelot *ocelot);
+void felix_mdio_bus_free(struct ocelot *ocelot);
+
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
-- 
2.25.1

