Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9369F21BB03
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 18:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgGJQcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 12:32:06 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:61635
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728317AbgGJQcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 12:32:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/nog/8k+L1YQa05tzGq4k2LxhJ1lUvOF0EqlWPGLP7ZfTGidMPFkFUtdcFJIXN676ZMfFjH8sL6zFaPixevnicShFQz76cktn00+RiqHhkUmND7hZ8rJ8UQQNlpCZHCEDEBM4AhPAzSL5QT+SLTMrMlDppOBbKLyoYZO3gIaNQ/8nH2rEpdIolQjKGs0VbNQPsMn2sABmkzSfx2LDxRLFvdQj3JHn7WKMdJRTGbxt4S7wNjBuFlr/1hpj9NVtL6dgC7euj1WnpP4ea8vf4rCsPB2knjcfwCbcI/WkEqE1bneua1OSt2U2NjatYlEqS8OtPcjg3a9OCY9JL74wumOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KAP1FSM8UbZ7E+Yk+SxIt3zesPC4XgBjnFn4USSUQUw=;
 b=XpdUXOFa5dVYF0OEbc0mThXBizR8fDyEu47pzNzCdrw+Rj0xlsOf9/EERTsUBW+WQvX7jtevE+ZpKbiWuXeZhv891skS0glsG/9T9dPGev5WE5locTqe/76iJ2aBqIx3CehixNv1lSh2ZLThkJNU1ni+Usb7ZPS1cSzQgSnIcU2IbxwvPmKs2vhScV3FWOmII1ZVlg7J8V6+dgbJ8bk5+jS6BTmwQHUhTH585TLk7SaVMxkCeZsjVTs2kr8jj5VtQYGt1JrmbYARR0aiCSkMQNg20sQcdBciqSOiTt8JUqLDSFV4UmhSN5/u3JdpEc492dw7HcLDlBSU/94fEF/zbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KAP1FSM8UbZ7E+Yk+SxIt3zesPC4XgBjnFn4USSUQUw=;
 b=lJuT581UddlrGPbvNJXbPv8IDgme2A6jhHsj9acRtXu781tinGvqkEOrAS6q3DqePbsGE/HPChJd3L22+UQwLDoMS6Qb/UHDlKSaBrNkb12DBjD8CIN+rjkDkFQnggDfuXC5TtoL3zzBEg5nXZAv0HiqB3hXKSpXbdJlStWL014=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3908.eurprd04.prod.outlook.com (2603:10a6:208:f::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 16:31:58 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 16:31:58 +0000
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
Cc:     netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v5 4/6] net: phy: introduce phy_find_by_mdio_handle()
Date:   Fri, 10 Jul 2020 22:01:13 +0530
Message-Id: <20200710163115.2740-5-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200710163115.2740-1-calvin.johnson@oss.nxp.com>
References: <20200710163115.2740-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0137.apcprd06.prod.outlook.com
 (2603:1096:1:1f::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0137.apcprd06.prod.outlook.com (2603:1096:1:1f::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Fri, 10 Jul 2020 16:31:55 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c179e68f-e1ed-419f-41a4-08d824eec42b
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3908:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB39085F1E343716075E05B802D2650@AM0PR0402MB3908.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: asb/k2XvAtzhqZzFj0XXg/Lu+938BBDXWWS7ytAJtnokYk4Vj8RpgpXvzCqML3ZkO5cjpEgavHlcEhcNYamHz4HyKORrpt4Q8RLeOC7yieXZeLDSM87RxlvIrNMf7afbdUUXT6tcxDaoWOnA5uK+84l6i+u9GkDChgpv/TAS5sWN8JaArSG19L9B8HELd/8k3zftt10ZFVSsAetSugORFFGI1iK1YrJBoc5Au3AtEO0uYzngVm7DAL+JYic6jAAG949hbBwUaxXdJheEpWb8rlezxo4+VkxjzEbKwUBffatb8kr9YPNBinFV8AX/72VsCO+EJt3omVe37p5dyQ4rSf7G4qTFjA9D+LA6cNyk2mSoomIbY/UK/KlXHrND701h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(4326008)(8676002)(2906002)(8936002)(86362001)(26005)(6512007)(52116002)(83380400001)(1076003)(6486002)(316002)(16526019)(110136005)(1006002)(66476007)(66556008)(6666004)(478600001)(956004)(66946007)(44832011)(5660300002)(186003)(6506007)(6636002)(55236004)(2616005)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YtBi9HnxeIj6Q+sjQtdhgdmd8id6r3gp8jYJNSTCaXr1hCdPrQIffO2DiU692VnaBLsQI2/FEc3o/zS1OAGiWA5bweH/inJR1056pAqn8T3DanlVdDEzufpXRdyUdVjjDRd2F2P3K1H+LAoHw9oIj1ldpA1BXreYXbeDV/jGsrUrp97z8KfEkvGWsnlMlQ5Jx5HRHJp+wPe7AlfFfjgH+TOu8DXi/mxhUnKD3Nnoddt462izP0NLadvlfuVKclr2WkKlOvbbbVQHcg/hFt/AKYBVk2aAbVA8kx8nuAr8P7WUMq8NgCUZxxV+zi9Ss6UwidopQWDQTf2sGCiM5lpSgw+iSvLSi9hnSDtx+hN5NSQSQqb0aMxKeifzH2e1YcL18ZfsQVdQBXnEmQG34zOiCe774ipYPDAtf57hiu/9GeM3siN7y3ZDEqr3Dh/25xcYO3Nu1M2wb2VAIcAy0J8j2OD+h6Idksm7yLl5gka8T3Y3hc7MVj+/P3wROEsFUVRw
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c179e68f-e1ed-419f-41a4-08d824eec42b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 16:31:58.6669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tDBuPn65VUs7Dbb+i4MAmxNRIQrXJjIr7RKrpiut1whOMc8uQalejofB0XHSdwbG4z+qw17em2wKzKBvadSqVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3908
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
index 2b6f22e64ad1..e87da427fdcd 100644
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
index 7cda95330aea..00b2ade9714f 100644
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
@@ -964,6 +966,44 @@ struct phy_device *phy_find_first(struct mii_bus *bus)
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
+	if (addr < 0 || addr >= PHY_MAX_ADDR)
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

