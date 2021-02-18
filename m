Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCCF31E5B7
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhBRFgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbhBRFaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 00:30:52 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0603.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43ADAC061786;
        Wed, 17 Feb 2021 21:30:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HhP/t4jI1NgNF8XY2HPoe3z/3QyS4prd5DYQXrQJk3HFVx/ry0q+WVZNnh7/Ihwf4veBrXKrhNh5fPW/9MOAe4+lsg4549cyfyXfpMbO0SbsuKg2zpNnJHXcLIdN4yDD6PQHRqF7kJWsaWuzR6tQfPnyVZDJZ1z8sZXwxxFntKPvUq3Vv4TBjyef4K8isIW3MVWyzfvCUVTKMPR7Qc5wDT5hA2D9lnf7npe+b5ZhPxMWi+fWh1NETFrw2px7HROvUFkdWI6Pls8HVdN+W0N4PNhU+5da4/ulh694QJbo8cglDmwLtmSQNEFufe6/dS9L7F7fr82fqZZadu7XlefXZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uN7QBtA3OsLSFhhd/c8bKjZiewNLFfEzjrd4DhdtXzk=;
 b=J6DXVWn5TpRtHUleTLBoemBxoTqU6dnGIAOzt3S+d5Htm2P7jk+7/1rD17koC9/mFbgmVs5jtJKd7vWg9wrxaIsGpAthzAXnK7aW+2riM0CEL40p98o6Goh4Qw5hzT7r91Nh4+1uUF+UQNJHxB/2/l5JrC42//+PUFRK9T0a+hC2C1FToKETL3UKEHGAagykt7fHQDP+6N/QTT8h9DaddYXxs5naeLlW9cuVdFnM2K6X+V6+hXaageCdwPkBqzXge4dz3xz0PDm1JdALW0jl0wzAknBnWLPczAgsNhyiJ++4UQvP0Oocy28fddE0ORxvUgE4TwSMDQn03YJv0t7LJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uN7QBtA3OsLSFhhd/c8bKjZiewNLFfEzjrd4DhdtXzk=;
 b=B2wmEjBGA6JGWWdFMsNzFRpWEes63dQemr68h2Vl4UsTJ6g6AzyKB/LDF31FO9vWQd4qs13h2dydWxxEevPz7iKqDXs/uUCnfS+WQm60mL18dAzJNpG0kGl5frVqEQQHZO2zIlrKfJjBwA+TqEb5rzKTwvI6mP7wfyskhM3OKBI=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7730.eurprd04.prod.outlook.com (2603:10a6:20b:242::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 05:28:43 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 05:28:42 +0000
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
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux.cj@gmail.com,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v6 11/15] net: mdiobus: Introduce fwnode_mdiobus_register()
Date:   Thu, 18 Feb 2021 10:56:50 +0530
Message-Id: <20210218052654.28995-12-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
References: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:54::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0051.apcprd02.prod.outlook.com (2603:1096:4:54::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 05:28:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0c317ac2-a7d6-47f7-51ba-08d8d3ce0e15
X-MS-TrafficTypeDiagnostic: AM8PR04MB7730:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB7730FF8CD246DB7EA21F8F96D2859@AM8PR04MB7730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5eJEMpaXi71ZgzzY+xEYQcwDoxwwdgked+Z0wZxBXWFxN9O5eYO4O88Jx9YShPOPu0cQSwB32U5WeDqF6FUA3hXNzP/qPCy7pQzWHSh5rukIUKLOWkk74I+JzIHVdm677LZJY81G6TFeG98xA0pRS2Ju2i/nIhIAoXwfkH7rOG2m8zDUo0K0S7LHGTGPWGqBAkPQPqqsOj3B+g+6rb/21lQHC3Kh2C5Xx9JlzMpQ0JgsrtVnVfAg74P7jmdKDg44XySbxCk1p7U1XqC2TnmwStwAOra0TvgPbHZl0/ChXslVgUBXWzXdbmcAVI8gpsPTEau1N24ITQInEmA2l/NQVIj1fGAmc3FunEKR6grcwI+930895ktsrxt+24qxbfP6NjOzzyjCpTlDJEqctEAaftUBfCxTHZaqOwnN0qS1nrWLwYugUSq9wqTZk9IqGPaFwn2EfXYJ7vkT3ck/SuoolrZN8Av6W/TPoa8Pbym4QpBFatkM0dAZtehXGjHEAwCLw+2MLMIeDwScz2SrFSTD7SPv+VKOafLIfzuQhCAq+4AOpZbrteqDiwa59hb6rY/l+RA+jMXv3PnntKUedIqY/Ofb53SeP3ZnEgg/VcnJL6s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(26005)(8936002)(52116002)(16526019)(921005)(478600001)(1076003)(6486002)(8676002)(55236004)(5660300002)(186003)(44832011)(110136005)(6512007)(956004)(54906003)(316002)(66946007)(2906002)(2616005)(1006002)(66476007)(86362001)(7416002)(6506007)(6666004)(4326008)(66556008)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VJkfa67FfBFRboBMuWpACA0V1sBIEBUww4jexLPtak+7KD+JjXGyzDaTQayC?=
 =?us-ascii?Q?b/GUFHZG7ws4MBigDR7ZUYYevyegdk6vbtQ2HLWA1wsT7MJtNFGpSpJYFVcW?=
 =?us-ascii?Q?3Ec9o714lF69LwF7CZKMcLI/m2PLjQjUDj+fRDLybr+p1tBYAKYmifrfkFBd?=
 =?us-ascii?Q?q8+gD7HzMWNer3MWWp59WZrT/t4Efyn9hK5q0HU4Ay2RvsefQopgTEKzWu50?=
 =?us-ascii?Q?jBJR3zrND7TIgdLx0i/i4aznTYcT9hNGkdNrs93pXApObnJG38DcJe4X/m4K?=
 =?us-ascii?Q?nuhgYZY9AOgP4tf8OZ9l+n7SY3DeQVUoU6zADvpXQEtthZC9BJnruUF2VFrG?=
 =?us-ascii?Q?LYRjKGj0LH23Xw0am9WKSlFj4Wd2lCZJoPBNDXdb+qO8wEDNoI7QOtPMNBus?=
 =?us-ascii?Q?UAkJ3ScDpJ6VHInitX8tXirTWNd1A5HoOLgEuZuU0pV/IzE2YbfRAMNbHNzW?=
 =?us-ascii?Q?blOWZmcEmvqQR0YOPnPBaTO2hTUf4ObbubuOVBHEgsk+r86e4ECMTKTKwZMu?=
 =?us-ascii?Q?35iZiFduk1vCCsgi2eRUuqltW2NxWG3YyQgkoZhGeRq9EvateI4P+3LiUDq6?=
 =?us-ascii?Q?H3NRCp5eOMRcfuWNGERrruAUFnn+IvEeh2a6Dn7Z520/JSz5moCMQQnNgoGi?=
 =?us-ascii?Q?pKiGvHWqW21Agl7Reuw+CPpvhGFczT+9vJQ0Q2FGFIvrUY+OfabbWyd76i5T?=
 =?us-ascii?Q?8cKOtQq9lBZNd/u7Q6xdt7pV/DnOhxFSPtXPn+vNUQgufZDQpULXtQ5oyM3N?=
 =?us-ascii?Q?jkYT6ruyZr2HBcOyARWy2vzsLMzmZzWEx964Aw5q6iFGZQnJ4XQ4XjpVmUqA?=
 =?us-ascii?Q?NH5ylN8o5kU5a4xFXNp+W2MUma8r/vXI6TRwGzv/xkdZDyhlayZ5d+6UKsAk?=
 =?us-ascii?Q?+aWbHgl3pfrCMPg0Fv/SUX1AXSWHOlUOppmHmgNvRO2+XQJBJg1crf5E53ei?=
 =?us-ascii?Q?nd3vewsjRBCp9i35G1jjfaTYFp0zQjFJCVjYYx/CiK7xFwG71kzQbiTjKCz6?=
 =?us-ascii?Q?BU8t7iGerqUfy6X8q1vyIwCKoYpQo9wZRyXU/V7KoOAARoXc3jLdXBlY+efD?=
 =?us-ascii?Q?o93rDbUb2nYw4ujGoRvvwYoY7jlMW0JXz98meEfPD5DQ3Q0ns+hywCXKVF2z?=
 =?us-ascii?Q?hxh9AcldCJ6NYD2I6muQtXSEAOVkxiyixO3b0STFrNY8tgaGpF6W6i/W6rwu?=
 =?us-ascii?Q?klW6/QHzgj9Ov0l6LgKWcFJZBY9y0awzl56k4169dWAuw7v/F4s3UGq0RBCB?=
 =?us-ascii?Q?Z++98EkWHz4t1gRRlr3WTJiwPrPTePjemyaUtRevwmfKpzuWXZs4c2MBepyc?=
 =?us-ascii?Q?fTKZKziLRnX2SirT8VZYQByN?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c317ac2-a7d6-47f7-51ba-08d8d3ce0e15
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 05:28:42.8465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wM5cJQiE4FQWeYtAKQroqTQ+smMxxXctw6ZMY0KZgoVJcTFc5WAsMQso+P/YtIsDmC7ccsyvReqtHLJzS/g8uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7730
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce fwnode_mdiobus_register() to register PHYs on the  mdiobus.
If the fwnode is DT node, then call of_mdiobus_register().
If it is an ACPI node, then call acpi_mdiobus_register().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v6: None
Changes in v5: None
Changes in v4:
- Remove redundant else from fwnode_mdiobus_register()

Changes in v3:
- Use acpi_mdiobus_register()

Changes in v2: None

 drivers/net/phy/mdio_bus.c | 21 +++++++++++++++++++++
 include/linux/phy.h        |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 6158ea6e350b..4264053fdd14 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -9,6 +9,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/acpi.h>
+#include <linux/acpi_mdio.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/errno.h>
@@ -566,6 +567,26 @@ static int mdiobus_create_device(struct mii_bus *bus,
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
index 4b004a65762e..85a09703f251 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -391,6 +391,7 @@ static inline struct mii_bus *mdiobus_alloc(void)
 	return mdiobus_alloc_size(0);
 }
 
+int fwnode_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode);
 int __mdiobus_register(struct mii_bus *bus, struct module *owner);
 int __devm_mdiobus_register(struct device *dev, struct mii_bus *bus,
 			    struct module *owner);
-- 
2.17.1

