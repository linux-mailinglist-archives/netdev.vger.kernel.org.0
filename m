Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DD4300AA6
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbhAVR0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 12:26:21 -0500
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:4995
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729187AbhAVPrK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 10:47:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cCmkPMSu9OMkkSSx2ppXstXhYEVrKj9uWDiLUC9Mm+KVoWcHQ8IC1LXod6Q/kGe+fEG82RRub+uFiKYAph7orrRDrJQ0WFIwI3LEHQUEStKDIvY5oIidumtYA2TUylV1nKjZz59WQ/fW5mETE3A6BP1h2Q7y6X9OFH2Z+L+zeQC9oGCPVP5hTMSlnYDEYJTdmOPiZBV4clgKjOpeRUsMK+qqp2t5Co1bCQkFpWh2xDrh2DCriB6J0Ot6yIaYPZR5Yv34Dcel2ZPMVuAAitaR3bETyT9qMDv9QITAqggAtHrA166lcASJ+XIhUz0W5/ObBTMD/EcP2QGY7eqnzYOb0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXr0sTUw6cD7f1/N3YABnD3ONUkreuF7dIe4nUA9uEY=;
 b=JSiek0PXfWNmvixOmHOt62c52+o9CDgKGw+b65FN8rb6IRgJWUfPqAlmwHkabdrk1mLMyBQd0M6H7Dei9aljBaAn4KT5p5t4LXy9cRqlVVg/5ghv4iJur1suIUUMXiNhfSSP6QhxVsoLnWU5vehjpCvfR+C/J5uvXy4nPikWiyHfw25gZJI9o1HWmtEm5siL+p7mHwqFtr3zt8ufBZmePAbKsgJiqvlZey9iDlsvcz5JybxmcQI5JU+Mxcx4NstdYvJQ/UySDUv+BoTn4ebGy6/mRFKs4lQaYfI5mGmNy/X6lO6+l+cSaR5FNuortFiav6DYHEIdjLNNc670s9DmTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXr0sTUw6cD7f1/N3YABnD3ONUkreuF7dIe4nUA9uEY=;
 b=dbL3+hLET9ri+G8kPobVz9hc9uu3aJcTGsZgP+prVOmjzfZW3SjohpzDSwSqbx9ATSiQdOp+ec33bzg/O+m+hMhAeWckAQFZ2yDMh8ieTVVmPrmGWwR1eWcM5h4PMGvHYnqIreT3lK0XWPl49PNZAsjZGsJd0MrORLwtiT8IzQ0=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3443.eurprd04.prod.outlook.com (2603:10a6:208:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 15:45:02 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%5]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 15:45:02 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux.cj@gmail.com, Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v4 11/15] net: mdiobus: Introduce fwnode_mdiobus_register()
Date:   Fri, 22 Jan 2021 21:12:56 +0530
Message-Id: <20210122154300.7628-12-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0117.apcprd06.prod.outlook.com
 (2603:1096:1:1d::19) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0117.apcprd06.prod.outlook.com (2603:1096:1:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 15:44:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9d0033f9-b158-4fb5-0fb9-08d8beecaeb7
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3443:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB344342149CFE39D5769125D5D2A00@AM0PR0402MB3443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tyq5vs8gwa8tFGCTqdW4OevcWwA9EIXKFLyEUJk233oem+0ydFU2mAiL7SnnFtn1/UbkQFV8qZ/klJ3YnVKsZ8E5vdHzxaGKrGGzFqhAUV2tDBYBW7gtfVSN0D8Y2YVIpIv88HCn/6U2eB0tnT+Nhf3yazFGHwY47Ek785WKJqMQkRuF9j34xx3qglaMAqtbj/HhzvMUpH+9ulEWvISnPcdz9U3TsXbRqiZWxOSrytw1Rnl5PlEt0l0+5Cc+V3jpBJBVbMSzH+CNNGomqn7bf3KKNe3gGnY+zcgREn05O41HOWoKQH7EMs0sn2b8hpWoqTMyTe57dKTXeS1UBNOJk8/xMaZEoJyVXIrT3d9AjOaTJDZCmhm87/5uS/+iS8UJNjihfo7Zlaw9qCmFlPA3FxqmS9EZ48bnDkYCAdIHmejI/w2rqGJuyziL+9VFfsvTMvOMnbuiC+pXnH1hDHAKBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(2906002)(6506007)(921005)(6512007)(186003)(5660300002)(1006002)(16526019)(52116002)(54906003)(956004)(55236004)(8676002)(66556008)(8936002)(66476007)(2616005)(66946007)(1076003)(478600001)(26005)(110136005)(86362001)(316002)(7416002)(4326008)(6486002)(44832011)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QwnU5+aJv6z9jj2qq67ZCCKXBuOuRU/JDiHcEJWz5h0w1Mls/C896Enmm16V?=
 =?us-ascii?Q?SHIO1MlU68FbNRWmx0L5RxU3PWA1x5CL1ZuXFhekSw9yI6YslpvqIJQzXpEr?=
 =?us-ascii?Q?d/hmphKrvdFzeoQrl9396iBVVvYSwTkooy9HZtCU4DmOFkIbeBsqCcI5KaDc?=
 =?us-ascii?Q?m/LmO9GxqLmzuLtBZ/4W/Nz9pGl8tNSdLb7dZ4y4EXQd3qlmj5aCtf1dVdj2?=
 =?us-ascii?Q?uKDs95awmrDUhaLCEdSvXriL1LDxZUVRps1yu3IyXoVaci/TVbJEmMwvfYJr?=
 =?us-ascii?Q?O0lMU+alKzHkYtLlEup9VdoW7xXOGFd821M9FOU+8kUecXcEjwg+IUVJkblq?=
 =?us-ascii?Q?JJyh4RLFbXgP1nOz93i+ARRvjHGTFwA5pamcxFR3MnTuPjoLIckkaGoYR6wU?=
 =?us-ascii?Q?ReU6VdPBoOWoCnb7FeMk3LLskwIPzdv3elKnrE3+oRfj7WTNQaNFg9DDlZnH?=
 =?us-ascii?Q?+d5nfszi+oyO/1ZzD7rmUXQobD1uSTTxvtEGbJ44DMNyRaPZShBWMhEkr0Hx?=
 =?us-ascii?Q?5Bi7ngyhrwbrMUfddCjVFpnTIW46naGaaxiBhIoEIm2llJJbUP8sbsUH3zUc?=
 =?us-ascii?Q?hCdAfDKTs4JpHd1oC4WxjiLSxZl8E5Gou7BfXc/s6AU4rjKEa/sIKOSDL8/B?=
 =?us-ascii?Q?OUljBJ9R4C0jiWxxHizxM7xhQEqGevVTgb2YKXUB7BGHrtbeiiZz0DXhGIUc?=
 =?us-ascii?Q?KXRemQmSYfp/spMJlKQwwqeqIQ+GoEOLUPZ0vBf3F9xldO9BDFFXgKSDxmyy?=
 =?us-ascii?Q?L710lKndsTEyHsaJbbithYAtoye7lZQARmdYu0INu9D7sjbQeTu5hjongai4?=
 =?us-ascii?Q?FjTEKqwUD29FXzfofsdNz8KerVS9fdSbhU79NKaaG7xg6Ukq6ifn9FIe1nYX?=
 =?us-ascii?Q?VByJ+zx0Og9dcUbhEmBU1oRRXQ1HN/LDs6u8UE6nN+L0+hrQqeZLFNmfH3bt?=
 =?us-ascii?Q?hih25uL0IzqgEuC8ilDMc7q99D50huTYr6wJAdo21GN9Z/TRAYhpKE93FXNy?=
 =?us-ascii?Q?bOuvfUB9UquRWOC19+tB0dBbw5ZOuub8OwQkXhuURr+sDJEXIdg0acSGEjws?=
 =?us-ascii?Q?K6DclfbX?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d0033f9-b158-4fb5-0fb9-08d8beecaeb7
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 15:45:02.7756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UnDDkIoZLZh/QPzNSMOIyz0aSYa+90gIyUUue5W1BA3XIUWNwHvlkVASup4emJiDxeB3kEJHi+wVNjJ0ln9fHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3443
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce fwnode_mdiobus_register() to register PHYs on the  mdiobus.
If the fwnode is DT node, then call of_mdiobus_register().
If it is an ACPI node, then call acpi_mdiobus_register().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v4:
- Remove redundant else from fwnode_mdiobus_register()

Changes in v3:
- Use acpi_mdiobus_register()

Changes in v2: None

 drivers/net/phy/mdio_bus.c | 21 +++++++++++++++++++++
 include/linux/phy.h        |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 44ddfb0ba99f..362e12853f30 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -9,6 +9,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/acpi.h>
+#include <linux/acpi_mdio.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/errno.h>
@@ -568,6 +569,26 @@ static int mdiobus_create_device(struct mii_bus *bus,
 	return ret;
 }
 
+/**
+ * fwnode_mdiobus_register - Register mii_bus and create PHYs from fwnode
+ * @mdio: pointer to mii_bus structure
+ * @fwnode: pointer to fwnode of MDIO bus.
+ *
+ * This function returns of_mdiobus_register() for DT and
+ * acpi_mdiobus_register() for ACPI.
+ */
+int fwnode_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
+{
+	if (is_of_node(fwnode))
+		return of_mdiobus_register(mdio, to_of_node(fwnode));
+
+	if (is_acpi_node(fwnode))
+		return acpi_mdiobus_register(mdio, fwnode);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_register);
+
 /**
  * __mdiobus_register - bring up all the PHYs on a given bus and attach them to bus
  * @bus: target mii_bus
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 957ce3c9b058..765e1844cfdb 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -387,6 +387,7 @@ static inline struct mii_bus *mdiobus_alloc(void)
 	return mdiobus_alloc_size(0);
 }
 
+int fwnode_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode);
 int __mdiobus_register(struct mii_bus *bus, struct module *owner);
 int __devm_mdiobus_register(struct device *dev, struct mii_bus *bus,
 			    struct module *owner);
-- 
2.17.1

