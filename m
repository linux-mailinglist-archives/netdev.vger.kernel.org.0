Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE8E21C2E8
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 08:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgGKG4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 02:56:43 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:21075
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728197AbgGKG4n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 02:56:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRxK6ZVeD5WPum2Vrp1Sx0rDaLFpx9ia53y/YAlqFwxIxCBIfSU3OuKbYFI0rzQ+Wi0wEufZYJ/gD3tyfZZ1tR3Ph0KSQ93IHDCrpBRzUFIDhLmtzxyHSSjxK3rErjDYIkxEySBmvseHs9aCcDPVHaSzFD3qSpWnTTPuXzgLOgEjnvLlAFML4OryRZbjYiY1uc4I6OFhHVvR9OlK8pv+0eXbnjZHCcuoYaxN0rK5XuIHYt+1LdyUByh1JNXtqRqy1d+KnWuWMBt+gxEbyHE0IZAheS2eg0h3WVElJHiZ6hYoRZugQeSmCQRGtD7kdFSSVhTc06+jGprzQlG5GQTLFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rd9pjwtQykPg77RQKXK1jd95xsuDQdncec7PnQTk6no=;
 b=c8hSR66ze1Hy9QzCjm7rQ5xwevFJksvLZ4h2n7ZX7oS79nwPNiWSESb9P0i1CTdWkCvKaY+kDDheYNPAEZYZz7hYrVA+jQgCkKqNIbPnsKHcPM/BpUKjEJCKUw0itXwngR4FwZdsMQggJgN/NDEJXWjdSPwgdZhliHZWGE2KJ52G/A52CMUnDVTFbPSNv/hgWrxsVAyQr9Gk4zp3mqwtHbogzTahsiRwnygRxWwJYlfU8v8S3mhuQZYJZq5zDDRWSM6QchorL5YvHprwUmDCvhtjBE2lVpHZCAw9L3RPjBdWKRmJic9kCGHjlghTeeGtEDFjIYCAGDFQ9ZCqCHPB2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rd9pjwtQykPg77RQKXK1jd95xsuDQdncec7PnQTk6no=;
 b=foBcYbtmP/GdjXgdDPoogM7wmg3E1PUFwpRn0CqXSsd3UKvlgFjoQSAHX5y3AtD98nqMoLd/VLZEqBs2ykYbixDfSrAcVX4hdt0PjSIY0p2kNormiwikNoy4Pm2b6NIECJVtGFiMwlGGNsbYGg4RQCKQBHf5701y6jsUlCu/vHw=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6961.eurprd04.prod.outlook.com (2603:10a6:208:180::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Sat, 11 Jul
 2020 06:56:39 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.023; Sat, 11 Jul 2020
 06:56:39 +0000
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
Subject: [net-next PATCH v6 2/6] net: phy: introduce device_mdiobus_register()
Date:   Sat, 11 Jul 2020 12:25:56 +0530
Message-Id: <20200711065600.9448-3-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200711065600.9448-1-calvin.johnson@oss.nxp.com>
References: <20200711065600.9448-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0132.apcprd06.prod.outlook.com
 (2603:1096:1:1d::34) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0132.apcprd06.prod.outlook.com (2603:1096:1:1d::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Sat, 11 Jul 2020 06:56:36 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7c009677-9c1d-43be-4514-08d825678f76
X-MS-TrafficTypeDiagnostic: AM0PR04MB6961:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB69612D3088618F8DC36A051CD2620@AM0PR04MB6961.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tRqYrF8v9mFQGjAJ+WwWLIzXciEGT1rJIRs7lu7tpimUc4yw6Ld9aRbR4zQrYvlMyAuJWNcXDUpOOXnuRW59t/S1h04QSzVVxWcMEPbP3cvxEI3AOIJyt+6H0AmF2Lqslh0NPSzg8QvBeli8BomQOKhPOrnb3OxaRDs/7jIyeIGZqdZJFcVeT+Um+YuPEvsL2dHCQirjwedQunE84GdhiMUsByZVJA0xGo+V2LMAsbFV5xbLYgrnnDpoJT/muXiJWdUmrFLDxSP8Wl4FIQvP7S0PYzVZbxj6kV8Rfd1lmA6XaFbVZLoy8XZXC2WtpQqweXbOPckvY7L7PWmfwBAd5VWE167wBw24WW8Cx+k8I3vQCydGvvPJENvoR7AU5C1N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(26005)(6636002)(16526019)(186003)(110136005)(55236004)(66476007)(44832011)(6666004)(66946007)(66556008)(5660300002)(2616005)(8676002)(52116002)(1006002)(6512007)(316002)(6486002)(6506007)(956004)(1076003)(4326008)(2906002)(83380400001)(478600001)(8936002)(86362001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rv4YzlaPSNNygLNMUaMUFBUFeoFu3eeiQzN/XrK46iOvQ8gQBkaZydewOvtsSw9hRmAj7j16gLFJKGLyblsagyYs9wzfaIvii+XIPPw0AuIvXXEUokDyxxiSmDNMIOoRRMKkMhRXEYfSupIs4NJm31Iw8OMdoJozhsuJ7hq6cRaAGfuMdXsPyjspLX8+izREY5QcUILxrqtXsuMTV3JOxz4DssSEycW06rBRn74Ryz7pb8p9erwBU+m8F+GKZiKNfURcYfDCqzdRMXh8fIEnMeI4vwMNSF1xmMCYyvczRHeyVE87IqsUjP8zXYmNa5Zn4RPar0GWeg55SipgUxcnBCDteV9Hq4yknH3p3IyRuE72cIKEgX7TK+h5QGYXNNsEFXkUwRYfcCpRdtncB8iVpKXK6Uca15tivaI/GKHfzu8SRXUYLGtOYulYtBsJ6mmHaRauc1KGKKgldqGEcVEw6sHdMVX1G6Oe7XBPx4IrXKC23fysn58swIdOJdKJ2+4p
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c009677-9c1d-43be-4514-08d825678f76
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2020 06:56:39.4605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t1l53Y4TMdxePpSjFLkR2gY6u7QlSN2DWbQz4Q4v3D2lLSVm1Tv+1oUsWBP1ylVI8fWC+7hrfU9nCs785J6p2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6961
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce device_mdiobus_register() to register mdiobus
in cases of either DT or ACPI.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

---

Changes in v6:
- change device_mdiobus_register() parameter position
- improve documentation

Changes in v5:
- add description
- clean up if else

Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/phy/mdio_bus.c | 26 ++++++++++++++++++++++++++
 include/linux/mdio.h       |  1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 46b33701ad4b..8610f938f81f 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -501,6 +501,32 @@ static int mdiobus_create_device(struct mii_bus *bus,
 	return ret;
 }
 
+/**
+ * device_mdiobus_register - register mdiobus for either DT or ACPI
+ * @bus: target mii_bus
+ * @dev: given MDIO device
+ *
+ * Description: Given an MDIO device and target mii bus, this function
+ * calls of_mdiobus_register() for DT node and mdiobus_register() in
+ * case of ACPI.
+ *
+ * Returns 0 on success or negative error code on failure.
+ */
+int device_mdiobus_register(struct device *dev,
+			    struct mii_bus *bus)
+{
+	struct fwnode_handle *fwnode = dev_fwnode(dev);
+
+	if (is_of_node(fwnode))
+		return of_mdiobus_register(bus, to_of_node(fwnode));
+	if (fwnode) {
+		bus->dev.fwnode = fwnode;
+		return mdiobus_register(bus);
+	}
+	return -ENODEV;
+}
+EXPORT_SYMBOL(device_mdiobus_register);
+
 /**
  * __mdiobus_register - bring up all the PHYs on a given bus and attach them to bus
  * @bus: target mii_bus
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 898cbf00332a..f454c5435101 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -358,6 +358,7 @@ static inline int mdiobus_c45_read(struct mii_bus *bus, int prtad, int devad,
 	return mdiobus_read(bus, prtad, mdiobus_c45_addr(devad, regnum));
 }
 
+int device_mdiobus_register(struct device *dev, struct mii_bus *bus);
 int mdiobus_register_device(struct mdio_device *mdiodev);
 int mdiobus_unregister_device(struct mdio_device *mdiodev);
 bool mdiobus_is_registered_device(struct mii_bus *bus, int addr);
-- 
2.17.1

