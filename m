Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068B12DB1C8
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730214AbgLOQqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:46:42 -0500
Received: from mail-eopbgr20074.outbound.protection.outlook.com ([40.107.2.74]:21124
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730338AbgLOQqX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 11:46:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N18v9Qt75fz91SxDFqfv1FVfxuS83qLsBRTbSBEhCigKWmVkmLAicaQN1BDrg2GERJ6ejgAbgZoiHL4YfDEZ3peWhO6g5XzLk9wsav/GUpdMf1n8YbxJWSSH2RG43ZLyyp9XoitqEkYwXifWz/IO7z5A6t8ab+x9TOSOjfrkqoQVtQ1x70E5iM6Ms9RXsbfrqSEgFkL7uggvlfZUUsW2K6ct9ll1PB4ZPUOSbVhMGJyJ/HML3h1Jx0IuF8U5VBrTiGOBWtPoNwexsWS5U9++Zsq96AvB1hV4WKB4rYF/XRcPVBfOu3BQdk6xWi0NOBZSLyQudMEMQP9HVLG4qdAVrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHbCuoxmfnEibEpVrFYAQn7nvS884hvxUBnc2q6VQHg=;
 b=O/sjVRychL8DLmoOU4VezSyL5jSbx1WCr0yRxmA3CigRmdjyJpUm+Ym4iOMy8YB2R/Pc7GN1GMDf8YyR1lKNwBvQOYM+NGUUoLFJRGlrZPwQ6PoCFCHqhob9exVFsrQiS22Qvfkip169HyPBD7c9fWjx46VAdXfsYAjS9V2Q+g311TCZ+VcSgoET5Bpg6kozc7nCgj1jHqfietr33wKTwjcs4bLUKE5B8uRRzHwvU3z+mQILuoR2nBLJSQ2+9VUxfKQhNxASCgek9zgeoWeSbI+DyIxwGGvKpFWIyCV/GN43e1MRhPN4Oq8nMhDfC9+yDHh4cmbNXn1Dsnl74JZ7AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHbCuoxmfnEibEpVrFYAQn7nvS884hvxUBnc2q6VQHg=;
 b=CmjX0VvwvH8Y7Qq7cZTgQtU5eVZCYmv0f7w18mM2TLrGl1uxir5tWAJMPAbN0JuRUMOx7OK8SYyG7PfnTwdCSg7a/5EGBv21YPiWH8w/e3zJYV7RVI3q6Reu+IPDDKjYOVQ0n4EFs5OJ/B6KRf+s1kYYQKaVYHHlu7TXTIHOe9c=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6963.eurprd04.prod.outlook.com (2603:10a6:208:18b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Tue, 15 Dec
 2020 16:44:43 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Tue, 15 Dec 2020
 16:44:43 +0000
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
        Jon <jon@solid-run.com>
Cc:     linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v2 08/14] net: mdiobus: Introduce fwnode_mdiobus_register()
Date:   Tue, 15 Dec 2020 22:13:09 +0530
Message-Id: <20201215164315.3666-9-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0152.apcprd06.prod.outlook.com
 (2603:1096:1:1f::30) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0152.apcprd06.prod.outlook.com (2603:1096:1:1f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 16:44:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9e0b2ea9-85ec-42db-8483-08d8a118b949
X-MS-TrafficTypeDiagnostic: AM0PR04MB6963:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6963E8785C9A462065984BF3D2C60@AM0PR04MB6963.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hr6OcMjCFPxYLUYuK1jyIbhPBChf/RBwfT8rVdsPZMlhlKuf2P1kn3kwL2QyuRKfV2dmnNIr5bqL9wfin90isxFjQjJKb1NZ0AVcX4GFqrL5wWw5Be2OX1F39g5gEj1Xg90RCkFVc659v4JELDP0gUCOGCladOokBZ7Gu4iLDDjcAGHiKj61iR6n9cISKbGU0G3ATCQMgDgzxkPDABvYSKVV4VTbACxWZTThdivPmXCLraBWi2BNHU8f46vNqUAqFMhHioZ1p7yLmio9d7wd/jdcqzZs4/SVM4S/iAWqVKzAHceW5rHWm8C+Q5YC8GfCDNO6umsgcxyI1v+KhDbpeYhE6qS3ocAXCgWV3OulrINIFCseDhN7iwlujkB4+mNppoiUsRieCBzKoMhsTny7YQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(8936002)(4326008)(6506007)(498600001)(83380400001)(66946007)(921005)(2616005)(956004)(86362001)(52116002)(16526019)(8676002)(2906002)(26005)(6512007)(44832011)(7416002)(186003)(5660300002)(55236004)(1006002)(1076003)(66476007)(110136005)(6486002)(66556008)(6666004)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IskicbV8uy7tPwMaWewdy4OB/TodnmaYra1vsxh8PgOw1+GzEDuikjYlq+r9?=
 =?us-ascii?Q?4plLSOW/PQHV3ed+WXX7CpV4NImsDGj433m+45xQD6DdFSUOj/uKGpf+IUUH?=
 =?us-ascii?Q?v8ESdatPykWLoXWJdrVehjGdaFLXV0Z7TN3wzk1FkJGvvSuQWPJQTldlt8li?=
 =?us-ascii?Q?7aaiwVDeY742KKmozwdpPv+Bq18sHBRF+H4n9q796mEIWwPTLLDMH9PgCCUL?=
 =?us-ascii?Q?nBZ7YVfwHg/KQ9ADOJ5/42p9GuADaccunWC12KpRHIuydEMlDy3JzD+Z260S?=
 =?us-ascii?Q?2OVIzYczXSPCT61/4FgThytj2ePb5vOv6RafujbdTBJg8DT9zd9kjy7iqNzC?=
 =?us-ascii?Q?5ToBYUxmiUoLhN5oW4Lzwj4FiKvbtN1vg2wdQtpISGXSnXndqfD/xgo0GHZy?=
 =?us-ascii?Q?RkxrdQw2zyp5HlkRmeQ5DejBj3YvID0KWQ41m3OCLvckVWYwI/OpCBbVTSDp?=
 =?us-ascii?Q?toTlFCjc8qlqoswn7VxokdZ/6foduPeLte6hjmDsLftpMRoiFjbLa77nqZ7C?=
 =?us-ascii?Q?QHJ/k57DmwvluuXgwazr7xO/GjmN03pW5WzeSzXlKFJb8K0/l1QhRxvUd611?=
 =?us-ascii?Q?Oe6YzsJ1k/35KvAjyNbZ2SfieIEpnNP7/z4F9dHqqQEVEF6vuvwwlDkqQFdH?=
 =?us-ascii?Q?rBVtaPKmS+8goz/FIWQnSQvVu0saxCRwvOHvqgVFcytMMwPfsdWS+TgeJR3g?=
 =?us-ascii?Q?C03l32Jylh78JZnNR9IYxAb4Ej/Xfx9ZPBp6ZFs1a56GvNte18OOoAHCob75?=
 =?us-ascii?Q?9Z3EyX4974sDoLvdS+Gi6yi7MRk75DMYQ4L2q5XGr0Zzg2Dgh3fNv7P9lvNr?=
 =?us-ascii?Q?aG6pycM7kUAUd4CQPsOhHkTNQsYScRdFhvKm7VzUbYiSaXgWZvpyrQjWV+TK?=
 =?us-ascii?Q?jj92MSPxSMN5/HzIVV/V0mxwDwt2eJnNZy241u+KRe85/Se3OPNq/P7hAAkl?=
 =?us-ascii?Q?G6ysgRjQoB/2KT+pTxyij68XW3tLrOSQ9/YV0twmb7V7MYe7bSGKDUmxiOZQ?=
 =?us-ascii?Q?+Gu/?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 16:44:43.2235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e0b2ea9-85ec-42db-8483-08d8a118b949
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LB90F5j+BKGGLiV3lQcMdciHV7ITcW68xIPU9yb/kL54UkMY+k1aWBbBC5h76lliuoM31RInpb34eYUoYW5udg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce fwnode_mdiobus_register() to register PHYs on the  mdiobus.
If the fwnode is DT node, then call of_mdiobus_register().
If it is an ACPI node, then:
	- disable auto probing of mdiobus
	- register mdiobus
	- save fwnode to mdio structure
	- loop over child nodes & register a phy_device for each PHY

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v2: None

 drivers/net/phy/mdio_bus.c | 50 ++++++++++++++++++++++++++++++++++++++
 include/linux/phy.h        |  1 +
 2 files changed, 51 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 3361a1a86e97..e7ad34908936 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -8,6 +8,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/acpi.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/errno.h>
@@ -567,6 +568,55 @@ static int mdiobus_create_device(struct mii_bus *bus,
 	return ret;
 }
 
+/**
+ * fwnode_mdiobus_register - Register mii_bus and create PHYs from fwnode
+ * @mdio: pointer to mii_bus structure
+ * @fwnode: pointer to fwnode of MDIO bus.
+ *
+ * This function registers the mii_bus structure and registers a phy_device
+ * for each child node of @fwnode.
+ */
+int fwnode_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
+{
+	struct fwnode_handle *child;
+	unsigned long long addr;
+	acpi_status status;
+	int ret;
+
+	if (is_of_node(fwnode)) {
+		return of_mdiobus_register(mdio, to_of_node(fwnode));
+	} else if (is_acpi_node(fwnode)) {
+		/* Mask out all PHYs from auto probing. */
+		mdio->phy_mask = ~0;
+		ret = mdiobus_register(mdio);
+		if (ret)
+			return ret;
+
+		mdio->dev.fwnode = fwnode;
+	/* Loop over the child nodes and register a phy_device for each PHY */
+		fwnode_for_each_child_node(fwnode, child) {
+			status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(child),
+						       "_ADR", NULL, &addr);
+			if (ACPI_FAILURE(status)) {
+				pr_debug("_ADR returned %d\n", status);
+				continue;
+			}
+
+			if (addr < 0 || addr >= PHY_MAX_ADDR)
+				continue;
+
+			ret = fwnode_mdiobus_register_phy(mdio, child, addr);
+			if (ret == -ENODEV)
+				dev_err(&mdio->dev,
+					"MDIO device at address %lld is missing.\n",
+					addr);
+		}
+		return 0;
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_register);
+
 /**
  * __mdiobus_register - bring up all the PHYs on a given bus and attach them to bus
  * @bus: target mii_bus
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 10a66b65a008..67ea4ca6f76f 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -383,6 +383,7 @@ static inline struct mii_bus *mdiobus_alloc(void)
 	return mdiobus_alloc_size(0);
 }
 
+int fwnode_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode);
 int __mdiobus_register(struct mii_bus *bus, struct module *owner);
 int __devm_mdiobus_register(struct device *dev, struct mii_bus *bus,
 			    struct module *owner);
-- 
2.17.1

