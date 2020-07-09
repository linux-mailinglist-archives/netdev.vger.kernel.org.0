Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EAA21A667
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 19:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgGIR6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 13:58:04 -0400
Received: from mail-db8eur05on2077.outbound.protection.outlook.com ([40.107.20.77]:27872
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726758AbgGIR6E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 13:58:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWsrxFoK1RS/SihpHc4/9wD1q1zCEiDw/EFcOYCYezPvhxGawyMreya3K+iGymzPeucfQ6iw0j7pdnmwoV+oBnPw+HacHmbKuAkZvCHf024zxKVWR13yiO2MR02ZB/81gjsEAQNAuJRQgN32xedBiPrEW5ZjtyDBy1AK6eq3cmGqCXsQOCbSwo/JWh2o+jn6R6mdyZZPajvsymhPPQe3vDBxoIv1PjN7dIHPUnE31LtKRMX0TX6KtdfT6hQeaVCrUENwnnxw6kCruQ46ULndIQhJ1nXH5S2Wjt0G99pyu0c0SDaaKmfOX3s8DVtFrh8n6Mcu/82AiUnCTZifIb5Jpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bk9p6H8qNbcCUkvmOrxI5CZ3cWq403VPhMDFnqXj33Y=;
 b=PPVt8yb3Sbau1WqZt5IKLXxHoob0mAPWM1+BFzisnYpmjYuv1Ws2TzWlp4kMwzUeDtBd6mm85nCd4okyeHKbqUgXgae8l/tbolXdkRSSgdyKvK/9ohj5ymWlGX6CNgpzIi1oza82rxzF2GG2Zknax2V8RrerHSA6BhUwXYL9JPmHt9bAns0siXFFCCoVtCNYFrUzrhKFYf6W1xxHCaspqKVbMP5ORxvmSA1gMIaYl1Rtn1Ab/pZ63j/w1U1/UYLbJzJxrKFs3g4wmx1+EpJHeQmje7PJ7Qa6u7QQoqwmw8A9/KsyRWt58g7iueG1yYrOpkA9L3AdA0yNpgRxEGTo3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bk9p6H8qNbcCUkvmOrxI5CZ3cWq403VPhMDFnqXj33Y=;
 b=FkMGwFO1dvMT8scf8CGkZL3B319h5ecSO6KcezqgY+SZTVBwbnuD5FOIxxCEuQiHnYnRIXsBx7j1drVlDpv/5euLzv1QxVULUjg4lRvtxxpKqpTfj9+OiMr0y/Mh53tyPsFh3mP2PIcM9mE/RvOSYCX0nY9kKg5gGBFrqq16zRU=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6898.eurprd04.prod.outlook.com (2603:10a6:208:185::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Thu, 9 Jul
 2020 17:57:50 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.021; Thu, 9 Jul 2020
 17:57:50 +0000
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
Cc:     linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v4 2/6] net: phy: introduce device_mdiobus_register()
Date:   Thu,  9 Jul 2020 23:27:18 +0530
Message-Id: <20200709175722.5228-3-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200709175722.5228-1-calvin.johnson@oss.nxp.com>
References: <20200709175722.5228-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0151.apcprd04.prod.outlook.com (2603:1096:4::13)
 To AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0151.apcprd04.prod.outlook.com (2603:1096:4::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Thu, 9 Jul 2020 17:57:47 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 19c04bef-a3ed-4876-52cf-08d8243198a5
X-MS-TrafficTypeDiagnostic: AM0PR04MB6898:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6898A7F8EB148DE3A32396AED2640@AM0PR04MB6898.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mO0T9M9WxpR09pWOyVvz1mkuSo+LEJmoQlaH7ZtrXl0+cuL7uNVs+xEMK/x/LOH3ilkBY6g1UfnID84xzpHff79aq46ivlNsH4jN2uEPHtgNiZtNPnbpXDWzAFTnKBkbjd0WS37BP8piuiencQAS0j+PCupO40IK4X1PZIFb5FeYcQ8JmxLwyPjyFvmH7ggQBGeS0Nbtk3nqK65HmZdBSqQ83chsYRj06tFxwCEn8h/LsQv+8RRbDv2idHzlnz08g86hkl8oQMqYnOzvMjvijxMh+0kjCvzxqzHbu+2uJcLEnxXcJG0M3bAQkI254K+AMNKmZbM+uvsOwc9FZAU6qU4QEvW46ACdg4AQw6cnbZy9iLECqjGK2MBHoiZhkEv8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(6666004)(44832011)(1006002)(8936002)(2906002)(52116002)(2616005)(956004)(110136005)(4326008)(316002)(6512007)(66476007)(8676002)(66946007)(86362001)(66556008)(6636002)(16526019)(26005)(5660300002)(478600001)(55236004)(6506007)(6486002)(186003)(1076003)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Z5UaiH+iHAB2xJrUQEJF6m3Ty6tbBach7vIAmertpwmu6USVyysYojuvVro97kdAREJSpegWHxn1h5vnDmjCVhhjxC8jfHnP9m6FQl2bLuTQyGS41vb+o9kINPGYDWfIno5S8BPBaJ/hpzqyJjMiGtrpLrUv/9RGGZO1DIpCsSB6k4SR9JLYm4UyJZdy7pgDt4Jh8Uk9tZDo4bKSSpmo5jpiUvmT+qL+UxvSRMXtr4EFhJ7UdfMhWUfWGuAw3Ea88A0gLQ15qKn5mSlz/AcnOhmpHTr2D7mHuvyHfVIqANdwZIDKjMN3+rte+rVeZdojpOyS4oeeN1x25GOgaDtbRn/Jckr/WaGdEtrZPeehbQuxDLecs+vBcnmYd65ZBciwGl6fZz6OfWCg7qXTOmoxwY+93bi5txbLF6R9zUO1H93WrteBkDYNKSagAkJrLhilFMZ+8X17hqXx693MRwR9gwfbB5QVBKK5umrr2zTvNwFvIQ28uC+kf9ny3sdPP2YE
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19c04bef-a3ed-4876-52cf-08d8243198a5
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 17:57:50.8822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iTNSZe8hea+cTCFeGcOxMI4mAZ3aJfwznOwXz84VBMGt6c1NhkRfi8xjbqvCTQLqFK4+aw9keEYl0ZYamuMW7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6898
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce device_mdiobus_register() to register mdiobus
in cases of either DT or ACPI.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/phy/mdio_bus.c | 22 ++++++++++++++++++++++
 include/linux/mdio.h       |  1 +
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 46b33701ad4b..3c2749e84f74 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -501,6 +501,28 @@ static int mdiobus_create_device(struct mii_bus *bus,
 	return ret;
 }
 
+/**
+ * device_mdiobus_register - bring up all the PHYs on a given bus and
+ * attach them to bus. This handles both DT and ACPI methods.
+ * @bus: target mii_bus
+ * @dev: given MDIO device
+ *
+ * Returns 0 on success or < 0 on error.
+ */
+int device_mdiobus_register(struct mii_bus *bus,
+			    struct device *dev)
+{
+	if (dev->of_node) {
+		return of_mdiobus_register(bus, dev->of_node);
+	} else if (dev_fwnode(dev)) {
+		bus->dev.fwnode = dev_fwnode(dev);
+		return mdiobus_register(bus);
+	} else {
+		return -ENODEV;
+	}
+}
+EXPORT_SYMBOL(device_mdiobus_register);
+
 /**
  * __mdiobus_register - bring up all the PHYs on a given bus and attach them to bus
  * @bus: target mii_bus
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 898cbf00332a..f78c6a7f8eb7 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -358,6 +358,7 @@ static inline int mdiobus_c45_read(struct mii_bus *bus, int prtad, int devad,
 	return mdiobus_read(bus, prtad, mdiobus_c45_addr(devad, regnum));
 }
 
+int device_mdiobus_register(struct mii_bus *bus, struct device *dev);
 int mdiobus_register_device(struct mdio_device *mdiodev);
 int mdiobus_unregister_device(struct mdio_device *mdiodev);
 bool mdiobus_is_registered_device(struct mii_bus *bus, int addr);
-- 
2.17.1

