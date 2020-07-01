Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCFC2103B2
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 08:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgGAGNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 02:13:23 -0400
Received: from mail-eopbgr30050.outbound.protection.outlook.com ([40.107.3.50]:52900
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726615AbgGAGNV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 02:13:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JHEbLntu97Cgc3j7wlsZabxCCKNpPaQdLH7vmi9hKs4C+s1tffxc9cpgvFSiwQX0GN3iABRP7VsRX36gGfhib8jVXzyDT5i7YCNhgNREXUqPY9fsHZZ2rzixOTzDjm5Ldvpdg3Zij7nIN8oAlxccLiMxPsl59Q+4Y2NFPfZF55dPZvrV3tMNxRbpw3t5UMsrjNjl1shzZyz+cLQ+TRp5yLJL7MdXYQu6BXqIDxKZhEOnf9mKOXR1B9xSg0q9nLp672ieBoAAWrPNMSFw+ItVzzch3P7eeXDyzRAc4GVp2ZuXgAkKiobHAgkrA5PXKZPHjOVM2qWDZQHojPyDDUZIkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUjv+vktLgapsb4KaKUbBlwzkLzBzn1qoBM+j3UNPxY=;
 b=KcqafK+WeVVLiMVgqXTF6h6ylQ6lDyYmo3wykP+695I8xt8x/xrffbZESaxFAMg2z/x83iqd6QJwNw6KRV9zMn2lR4Adp0bt4q7F2QW7/fbbz6cG/CiHR0Uf8y6li5nEEMRIocQ4Qf4TEkg9S8mvKvvgjhydUSfUV0oECbC5u0lKJ07K9QWTXRLdK0C6W0Xzyt8o9oTzzMbcxwlzWvYuvfKQmcOow9fZldy8FjDzp8b3eMgxHnbze+VclCrw0rKAida+HeGk93YWC/rh9/gKk+O653Onxyy6O7fKdLqsmWxtqm4KHuT3Popr9Z/aJlEw7ExNP77m9rT1Fe79nNZ9fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUjv+vktLgapsb4KaKUbBlwzkLzBzn1qoBM+j3UNPxY=;
 b=U5/C3xh0FHIu/0yAoWSpb8iFtnjJqICjHpoFlYivmkUfkalDlhLc+nPx28kfy+oeLMHIyv+vvvX6+OAdoliJ13wGe9nbQYZQyFfVSW8n5dp+iBpqwVJlQ7GQZuWBNsyOPiYjZvkXJHzR27dGoPj42eUjJLKuIlqTkRETsnwbKwg=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6066.eurprd04.prod.outlook.com (2603:10a6:208:13e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Wed, 1 Jul
 2020 06:13:17 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3131.026; Wed, 1 Jul 2020
 06:13:17 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux.cj@gmail.com, Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [net-next PATCH v2 1/3] net: phy: introduce find_phy_device()
Date:   Wed,  1 Jul 2020 11:42:31 +0530
Message-Id: <20200701061233.31120-2-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200701061233.31120-1-calvin.johnson@oss.nxp.com>
References: <20200701061233.31120-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0230.apcprd06.prod.outlook.com
 (2603:1096:4:ac::14) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0230.apcprd06.prod.outlook.com (2603:1096:4:ac::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Wed, 1 Jul 2020 06:13:13 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a73cf0e4-0900-4c91-b989-08d81d85d852
X-MS-TrafficTypeDiagnostic: AM0PR04MB6066:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB60665DAA53188F41E301DCE3D26C0@AM0PR04MB6066.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uu1oS4my4DSyZWAZeloPw/DPKwPPu+BKJrNRK6ivSJ+C3pRSRaBXoodj+XA+yZpXftuY6/4Zw0qMULx0yTzFcGuOeU0GcS9xr3O4aw+jKBlvvF2B0eNGV2kdlkc7SswWu6ImzqqaUPu3xBDbcTqUlGUFIfqkCRMbGThAK7crzQx1VWOzQNcIvBYQiePDu7VGgmwOn2MrVRlN0Y/3Oq5/F8vdD7c8eXspiWivl7XM+J25Yriqf2cSutzQvWD0IuGNuH7Ch4qw2zEveBCUUxVbFjViLreU3n2eKh6c13XbzktTRm7seqKr6CrOqVz/EYQ+86uaNMPVBaetNYiQuAmzK0vnfzbREuqpjglkldeL4nXAj7FaX0AImYQmjSiE23xG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(2906002)(6666004)(4326008)(7416002)(6512007)(316002)(110136005)(54906003)(86362001)(1006002)(8676002)(478600001)(66556008)(55236004)(8936002)(5660300002)(186003)(26005)(52116002)(6506007)(44832011)(16526019)(2616005)(956004)(66946007)(66476007)(1076003)(6486002)(6636002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7TDYPFb4njh8B9jQeKqcy1vFkya4a8105K+sem5LBRXaVDqimV5tmI/qagDGsXjb2hIq9IlUrGj36v+JdctqYMeMf4SCFQYTy6AEvfcJSm8abTuFTiIg0F1fEX0xxruUqaGBOJJlVrh4zHZIktJMS5+JfJVm0iM/mkGjuaYDACu6lT+yZ0tYjnNHBHS5t7Ba47zKRi5kSrMvr9XifH0IkJ4eAQtvROLScJjz7OCX6+NRE+iL1den1lYEzCThbYNccXjkiyc/qXOOEZAwa1SebHmA4JlmmnWwojo3OI1EcqqKOXQhpgLklSaKKyUb8SaWwhWwcz4Xp+Hamcpfc3IptpeUnlVnlh3cNxHTACFxuV/fJ7cPlsiAL23Wnlf81T2AlpQHn5eG6IA41JZF1h+uFFjYJSkRfj07P5HeHX3EqPXnfDZck7puTc64EPw6Fy6ctJTOrm4uQF81RybE2OF2aeT57xAF9o7Uv5td/0jOqwbz2nsuH2TX3StgB0kNP1sg
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a73cf0e4-0900-4c91-b989-08d81d85d852
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 06:13:17.1890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cFymC/F81otse+m7DIuKRc4uLhU7rSK16pxT6aaUuYpq6V13XnK8N+M77fIUUXFvaf5SpLJsGjtoC4W2lq8GHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PHYs on a mdiobus are probed and registered using mdiobus_register().
Later, for connecting these PHYs to MAC, the PHYs registered on the
mdiobus have to be referenced.

For each MAC node, a property "mdio-handle" is used to reference the
MDIO bus on which the PHYs are registered. On getting hold of the MDIO
bus, use find_phy_device() to get the PHY connected to the MAC.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v2: None

 drivers/net/phy/phy_device.c | 25 +++++++++++++++++++++++++
 include/linux/phy.h          |  1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index eb1068a77ce1..417000197ab1 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -25,6 +25,7 @@
 #include <linux/netdevice.h>
 #include <linux/phy.h>
 #include <linux/phy_led_triggers.h>
+#include <linux/platform_device.h>
 #include <linux/property.h>
 #include <linux/sfp.h>
 #include <linux/skbuff.h>
@@ -966,6 +967,30 @@ struct phy_device *phy_find_first(struct mii_bus *bus)
 }
 EXPORT_SYMBOL(phy_find_first);
 
+struct phy_device *find_phy_device(struct fwnode_handle *fwnode)
+{
+	struct fwnode_handle *fwnode_mdio;
+	struct platform_device *pdev;
+	struct mii_bus *mdio;
+	struct device *dev;
+	int addr;
+	int err;
+
+	fwnode_mdio = fwnode_find_reference(fwnode, "mdio-handle", 0);
+	dev = bus_find_device_by_fwnode(&platform_bus_type, fwnode_mdio);
+	if (IS_ERR_OR_NULL(dev))
+		return NULL;
+	pdev =  to_platform_device(dev);
+	mdio = platform_get_drvdata(pdev);
+
+	err = fwnode_property_read_u32(fwnode, "phy-channel", &addr);
+	if (err < 0 || addr < 0 || addr >= PHY_MAX_ADDR)
+		return NULL;
+
+	return mdiobus_get_phy(mdio, addr);
+}
+EXPORT_SYMBOL(find_phy_device);
+
 static void phy_link_change(struct phy_device *phydev, bool up)
 {
 	struct net_device *netdev = phydev->attached_dev;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 101a48fa6750..ef9d7ca5d7ba 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1245,6 +1245,7 @@ int phy_sfp_probe(struct phy_device *phydev,
 struct phy_device *phy_attach(struct net_device *dev, const char *bus_id,
 			      phy_interface_t interface);
 struct phy_device *phy_find_first(struct mii_bus *bus);
+struct phy_device *find_phy_device(struct fwnode_handle *fwnode);
 int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 		      u32 flags, phy_interface_t interface);
 int phy_connect_direct(struct net_device *dev, struct phy_device *phydev,
-- 
2.17.1

