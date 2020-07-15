Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A712220819
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 11:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbgGOJEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 05:04:42 -0400
Received: from mail-eopbgr60086.outbound.protection.outlook.com ([40.107.6.86]:24900
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730412AbgGOJEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 05:04:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ss+HzU9JWlz/J6nCuautPtWIBpKEbvGbNQEqcIe+P3PrW5ZMZt21W59zdp5p53h1exGx/IHFTCsN8Ct7/QhBO/AKpjiog7u9Q/FCZqrNsQFtYWycnZnIB4O0CJOf4C5mKXQ5hWrf3YdSelv8fPnFQhspxi3yeaC4s9osXwvrTIUdVmy6dylEJYv9Jg9Qag89v0ZK7UBIYnebA2hPnh0kRVqoj1PbT2ACCxjL+s+SCV0JGT9+ljoyvvrfNBqPGwC20TbuyiefbgzSKYGO0jh4/IddwAXV8Di/HpfgxLVGVtd5iuOJU9Oiiu2117imzzmQhVpWHw8Za1g5B8KFf0+M7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3kdm1lDYjdzIJwkMrYd/NBbXanHVS+ZY/kzco22Wpw=;
 b=catEqQAf+clxN+gIYKZFL76P8UPz2f++EVpTefAP0uMC+z5VBbTTMxCfePxB3OiNLQ+MZGn9lWrDjXqSP403pEsT6jy4EIvelK9kypX0B1DDx8MkZYtFf9ZbzYmyHAsCsS8pdGLsRp0lEXQb5OHbsVrm+Bm0RvM21v1c0sTMRn4ghA2cqrmxxBZ3C1ZWPtqJ6ZAA0TqjnhpqlfylnnV1EURP938s0C+Z6ztKclWoVI88EP3zMRPmo9ZQjKPVqvjy/EUcSUsQp0uAs0H3PLW7m6slLX8a5Ut17dm3/slIM3mf/779Hxy9rQNUt0+qvKD6PS2r2ZJSRI6p3Ovqqpf3kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3kdm1lDYjdzIJwkMrYd/NBbXanHVS+ZY/kzco22Wpw=;
 b=Pxg5WXtq7uSA0QW0HG52rI+vUTbTkoIHaloVHRZ1dT62pY/aBR+fbMi9YFN5Rj5sc8BDligl70Q64zU8pfb0JmTo0Kfac4zKMRgjqJsBEb3VA5+Xzu/87QNEweeqahrK3DO0JOKwypDPkdZDTjosLAy2no54/GzVbBqkR+Rmsq0=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3763.eurprd04.prod.outlook.com (2603:10a6:208:e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.23; Wed, 15 Jul
 2020 09:04:37 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 09:04:37 +0000
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
Subject: [net-next PATCH v7 2/6] net: phy: introduce device_mdiobus_register()
Date:   Wed, 15 Jul 2020 14:33:56 +0530
Message-Id: <20200715090400.4733-3-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0070.apcprd02.prod.outlook.com
 (2603:1096:4:54::34) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0070.apcprd02.prod.outlook.com (2603:1096:4:54::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Wed, 15 Jul 2020 09:04:34 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 86710861-b159-41dc-6aa5-08d8289e19bc
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3763:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3763CD5E2DE6FCEC512270A5D27E0@AM0PR0402MB3763.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vuo1QGClgtZo+p9c/sdL178DbMpg39awxTubZa1f2FLVe7D2T3AlDvV0vqpNLyZI7g26nU14IsonSRkQxGbhq7DwdszwXwYdvtai4nf/7OU8yTlm/YK0JshYm7f8kbrhD+TP0hEt31Jt0+BIALsVHX0taAyVhi8OhWeYfMtn4kJKLApWE2m1Bwt02d4Te2khBbgZXM+UZQgYTHRtPlPWJuybMVVB9kEkr6hxaDsQC6FP3vEZmXt+g/YOI/a9Weh6/GvD0W6Bgmm6GxsGOA3+OgRvY7m31mPCpLBLK8u1EuCnOsRg9W13WHosBd0jk78AfPnZ/XxGvCHAFdIQu5RShFgf+hHV4MbD1oIUHHMmUpBRA/Hmg6s1zY3vHBzXw/Zh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(5660300002)(110136005)(2906002)(6512007)(66946007)(6666004)(66476007)(86362001)(1006002)(4326008)(66556008)(52116002)(44832011)(316002)(956004)(83380400001)(26005)(6486002)(2616005)(6636002)(6506007)(55236004)(1076003)(186003)(16526019)(8676002)(8936002)(478600001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: iT4TRdtar11Te06A3N6lJbU5fjQa8g3Mm/xmp8oeRUhl+tbgJUktXozfSdWJ1Vz5VL9He3K/QW80g9Ug8JaXrho9ATaHystDSIIjJ39yv9+z2bICiOLfect6OSyQspPM0h/S4S6jQbmTNB6Hb6omiAj5KVtAlJtbbKpXU1tQ83MhDivZs2FxApRQXvlzW1GgBvILSQiZ3Vu7sulkmbghX3/lmvbRGHLdol451F7Z5Xz74rGQ2uucZ65DDZJXbwmjxRg2YDI4U1/bT54X5GoEv014ogFJ77j4ce1E60MkjSOpj4AHIJtUgqvG8OqrLz7CLWuNpz9WR+rWzTo6l2mPyxLFX5C6x71sBYfyF9n+tvr4L9jTO6ygQmi4C5anZeqackgjjNPgjNiOmFfQycfJNLzmExvckurxAk7VFruX7XTpJSchX5epqDL+mjJ2GuVNqpFszg/EAD/C8KVl1lEttoGyXBHgYKoP03bQ7+mi2epx1pu2HHyEZKySRyoppbkf
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86710861-b159-41dc-6aa5-08d8289e19bc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 09:04:37.6436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Trsy4b5wqWuge9sERsPtjSw508hpQIR+sCCpvkBVMorAhk5E9C252zQmghf6/irLVpQRH5BteKBvYXdrJ9wT/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3763
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce device_mdiobus_register() to register mdiobus
in cases of either DT or ACPI.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

---

Changes in v7: None
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

