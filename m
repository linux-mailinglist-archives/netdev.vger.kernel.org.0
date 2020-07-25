Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5B922D81D
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 16:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgGYOZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 10:25:12 -0400
Received: from mail-eopbgr30076.outbound.protection.outlook.com ([40.107.3.76]:49410
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726944AbgGYOZM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 10:25:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQ77VoUYpn3fhY1CeNPwOl4si3a6yI7BDYTvhX8gPUReBwWLHniyzhlKZBgisv18rFLrQrVbaf6VyHA3//LERJ0BGInV7WH5k/bJ9Kk2FHrGFoNR7TMD9j+llsycth0GuM0+yaoCDv7z4EW7IJtObGYec8xsbZT+BZZhy5mj3n0+JypCPFP1o+4ms1KQES/DhTnVX4RhxQRV3YgtxPuxNHIh7zyHj8ajguJRd6GU9SdZFAsFOJGzFyukzVEiKV87/vY1YKqGqGI+mdbV2eDCVT3wZzipS82GJhzvRXk0tlrI/SpKj+yOthOZFi/IW+bdzWawjyjL5kpCW3Gb43wKaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bCV7eZwrLmTtbw9JgaXnho/8k0YjV+s00K7ymt53Oc=;
 b=ctZhHSAh0uCASThko0V5ptTVAnB9FoU6W2seDZFdnTCq+HWVUsRPkMJwmTkvVoTfghrwlT9kotbMblFUdlcmVaJxPEvjQXYygAtjkbcdyX8QqLa5I6sxFP+VijZxE/8Xe99KTFY2zBHJg/3ws9KpdtPvspOjQs3v+VWSaHCW3tVZ/mzT3PD1IlqxuikGodw47fPvdwzKsgv8/dQi5QtQjY6b2OYeG8ezVQEJrGxwF6UHSfMiPOONYhCgWyfqkd7zQn2jAgIiMx4FmuQXUwT1Rm3nb5rlNkE+nqIIFCppdvbdMp8dhMSH/GzKr1PNP8yqcoDK9ULQ74sgW1Cya8mLBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bCV7eZwrLmTtbw9JgaXnho/8k0YjV+s00K7ymt53Oc=;
 b=g4ouGppVXcFBLoRo9zJ7+WAt6qVq03qNK+5bC05C/+DcQAtxEUzpCep2Bk5DWRHkqVeoqTrhIeW/AKk77QqtwCCSb6pAjhHQ0oJsToErkd3cAR6lcsqPMtnjo4WuNF0XU9VC+60xShPJ+aAWVIfARCbxRHJi+kCMK8v5QDrFFcY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4931.eurprd04.prod.outlook.com (2603:10a6:208:c1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Sat, 25 Jul
 2020 14:25:07 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::b1ae:d2cd:6170:bf76]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::b1ae:d2cd:6170:bf76%7]) with mapi id 15.20.3216.027; Sat, 25 Jul 2020
 14:25:07 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Al Stone <ahs3@redhat.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        linux.cj@gmail.com, Paul Yang <Paul.Yang@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v7 4/6] net: phy: introduce phy_find_by_mdio_handle()
Date:   Sat, 25 Jul 2020 19:54:02 +0530
Message-Id: <20200725142404.30634-5-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200725142404.30634-1-calvin.johnson@oss.nxp.com>
References: <20200725142404.30634-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0302CA0018.apcprd03.prod.outlook.com
 (2603:1096:3:2::28) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR0302CA0018.apcprd03.prod.outlook.com (2603:1096:3:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Sat, 25 Jul 2020 14:25:02 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e3354edb-3308-40db-9b68-08d830a6878b
X-MS-TrafficTypeDiagnostic: AM0PR04MB4931:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB493133D5236B3827B355C67FD2740@AM0PR04MB4931.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oR1SRbr3D+9Tsnp+LMU2sHy70eTeiup462Vinq1w8qIjBCt1BIDMMFRZymfIqlxRy9S5e9Ky4Rcb54yTkGIciuD72Hhd7jVLy8Fnk3KQ7kx74Qw2Q+S1fIuVrt1t1vwK2gTsCWmDdWLfj0nwY3+XtnnGVgGFwmpqnwX4qxUWGyXs+ARWkgL76rPB/UL86Zc6jXrdZna+iozg/HfFtLPSoMxyMgBttM7QnUJtui7hBihhXUWXK2xqgmXsdwOwxRthX7eXAJz0qmvzCEy4FIQAqZ5rPW9zZDV5G5q065l0edcIzNTx7NpjMMOCSjgGiTj3CtFdzbfhYVzkIitY5wXrIRSBPLuaetBtmVvQr8a+CScKnF5CTMuq6D9EtjI5vGlrSZUxezdgYM9/NGGcX2oPKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(66946007)(66476007)(5660300002)(6506007)(6512007)(86362001)(55236004)(52116002)(478600001)(44832011)(110136005)(8676002)(316002)(54906003)(1076003)(66556008)(4326008)(16526019)(956004)(2616005)(26005)(8936002)(6636002)(186003)(83380400001)(2906002)(6486002)(1006002)(7416002)(110426005)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rYaxVbLM/8OdbRmtk35R3G+n5y3PNyhJ1s7AetthYuUJTdZH0B4hiNbpIHKrq+gkAiYNY09ymqGVB/Q6HLCEv5nU8wipCINNLiM4hDmD9Eb6R5XJw7CHUJ7xXt2XK/iPJ5fHE0NK6k1QNDhhgBAXQqFRRG9Yhl7IaRjT1z63BKJFlsp3CC117Lz90yrGyTDEnsJ+FGE18ti9Q39pTBbvUIWoxdllQMZ+ajxUBQRWP9QtRiO24zDmrYnY9c/sGavz5XGkZFbujxxGmZK5KN/FBoTun9mw7k9n+4iCOUmv9wcfQmYhWdb45DYXsNXlhep+VpGlhYxu21mkBOM5hV9dBmyFX1dVdYV/IFC2yyb1ZuYCA/qk86sAfQPUuTNiB7EGswXaM1H0myhqNnypfr5i5aObf3VFr6u3nT1nweQUaYUbaY4nmdyXt6Dn5+id611RnEOmX6BsYNlCIWQypq1hS0w3jhFouI3uRe98BjikACc=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3354edb-3308-40db-9b68-08d830a6878b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2020 14:25:07.1102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EWhq1IS6JNu42i5BcmoWP5pYQIyWeZkWzqDB+8bWGai/t/Uu2nWcUaskmMKYyXpj5nk9qq8z9lCsHin6KgL2EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4931
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PHYs on an mdiobus are probed and registered using mdiobus_register().
Later, for connecting these PHYs to MAC, the PHYs registered on the
mdiobus have to be referenced.

For each MAC node, a property "mdio-handle" is used to reference the
MDIO bus on which the PHYs are registered. On getting hold of the MDIO
bus, use phy_find_by_fwnode() to get the PHY connected to the MAC.

Introduce fwnode_mdio_find_bus() to find the mii_bus that corresponds
to given mii_bus fwnode.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

---

Changes in v7:
- remove unnecessary -ve check for u32 var

Changes in v6: None
Changes in v5:
- rename phy_find_by_fwnode() to phy_find_by_mdio_handle()
- add docment for phy_find_by_mdio_handle()
- error out DT in phy_find_by_mdio_handle()
- clean up err return

Changes in v4:
- release fwnode_mdio after use
- return ERR_PTR instead of NULL

Changes in v3:
- introduce fwnode_mdio_find_bus()
- renamed and improved phy_find_by_fwnode()

Changes in v2: None

 drivers/net/phy/mdio_bus.c   | 25 ++++++++++++++++++++++
 drivers/net/phy/phy_device.c | 40 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          |  2 ++
 3 files changed, 67 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 8610f938f81f..d9597c5b55ae 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -435,6 +435,31 @@ struct mii_bus *of_mdio_find_bus(struct device_node *mdio_bus_np)
 }
 EXPORT_SYMBOL(of_mdio_find_bus);
 
+/**
+ * fwnode_mdio_find_bus - Given an mii_bus fwnode, find the mii_bus.
+ * @mdio_bus_fwnode: fwnode of the mii_bus.
+ *
+ * Returns a reference to the mii_bus, or NULL if none found.  The
+ * embedded struct device will have its reference count incremented,
+ * and this must be put once the bus is finished with.
+ *
+ * Because the association of a fwnode and mii_bus is made via
+ * mdiobus_register(), the mii_bus cannot be found before it is
+ * registered with mdiobus_register().
+ *
+ */
+struct mii_bus *fwnode_mdio_find_bus(struct fwnode_handle *mdio_bus_fwnode)
+{
+	struct device *d;
+
+	if (!mdio_bus_fwnode)
+		return NULL;
+
+	d = class_find_device_by_fwnode(&mdio_bus_class, mdio_bus_fwnode);
+	return d ? to_mii_bus(d) : NULL;
+}
+EXPORT_SYMBOL(fwnode_mdio_find_bus);
+
 /* Walk the list of subnodes of a mdio bus and look for a node that
  * matches the mdio device's address with its 'reg' property. If
  * found, set the of_node pointer for the mdio device. This allows
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1b9523595839..746755c086bf 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -23,8 +23,10 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/phy_led_triggers.h>
+#include <linux/platform_device.h>
 #include <linux/property.h>
 #include <linux/sfp.h>
 #include <linux/skbuff.h>
@@ -965,6 +967,44 @@ struct phy_device *phy_find_first(struct mii_bus *bus)
 }
 EXPORT_SYMBOL(phy_find_first);
 
+/**
+ * phy_find_by_mdio_handle - get phy device from mdio-handle and phy-channel
+ * @fwnode: a pointer to a &struct fwnode_handle  to get mdio-handle and
+ * phy-channel
+ *
+ * Find fwnode_mdio using mdio-handle reference. Using fwnode_mdio get the
+ * mdio bus. Property phy-channel provides the phy address on the mdio bus.
+ * Pass mdio bus and phy address to mdiobus_get_phy() and get corresponding
+ * phy_device. This method is used for ACPI and not for DT.
+ *
+ * Returns pointer to the phy device on success, else ERR_PTR.
+ */
+struct phy_device *phy_find_by_mdio_handle(struct fwnode_handle *fwnode)
+{
+	struct fwnode_handle *fwnode_mdio;
+	struct mii_bus *mdio;
+	int addr;
+	int err;
+
+	if (is_of_node(fwnode))
+		return ERR_PTR(-EINVAL);
+
+	fwnode_mdio = fwnode_find_reference(fwnode, "mdio-handle", 0);
+	mdio = fwnode_mdio_find_bus(fwnode_mdio);
+	fwnode_handle_put(fwnode_mdio);
+	if (!mdio)
+		return ERR_PTR(-ENODEV);
+
+	err = fwnode_property_read_u32(fwnode, "phy-channel", &addr);
+	if (err)
+		return ERR_PTR(err);
+	if (addr >= PHY_MAX_ADDR)
+		return ERR_PTR(-EINVAL);
+
+	return mdiobus_get_phy(mdio, addr);
+}
+EXPORT_SYMBOL(phy_find_by_mdio_handle);
+
 static void phy_link_change(struct phy_device *phydev, bool up)
 {
 	struct net_device *netdev = phydev->attached_dev;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 0403eb799913..fd383a22eb61 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -334,6 +334,7 @@ static inline struct mii_bus *devm_mdiobus_alloc(struct device *dev)
 }
 
 struct mii_bus *mdio_find_bus(const char *mdio_name);
+struct mii_bus *fwnode_mdio_find_bus(struct fwnode_handle *mdio_bus_fwnode);
 struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr);
 
 #define PHY_INTERRUPT_DISABLED	false
@@ -1245,6 +1246,7 @@ int phy_sfp_probe(struct phy_device *phydev,
 struct phy_device *phy_attach(struct net_device *dev, const char *bus_id,
 			      phy_interface_t interface);
 struct phy_device *phy_find_first(struct mii_bus *bus);
+struct phy_device *phy_find_by_mdio_handle(struct fwnode_handle *fwnode);
 int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 		      u32 flags, phy_interface_t interface);
 int phy_connect_direct(struct net_device *dev, struct phy_device *phydev,
-- 
2.17.1

