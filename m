Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271E927EE48
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731093AbgI3QF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:05:58 -0400
Received: from mail-eopbgr150071.outbound.protection.outlook.com ([40.107.15.71]:60926
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731103AbgI3QFz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 12:05:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MgXuj3gRiG/oXKx0hw3r5x+aiC8Wrm0L/hKGDkPHhL+TrWThbOe35fQ5lzhIoIrdddbFcc4KRieng1CZyMk6vuNWsoKH65KIaJNi1B3m5vtLsk9NgD9f4wfRaVOHZ+FUqWldXviiT2m1mYq0aWndXn79Kyq+I/grVOU4xoU/Mu4ukdY83aJjkSaKoicFTxptY8kOfyFOCbBvrv42weU1s2pPWRhBfOojsdnKB7gWEyal29OKWrJ2gaNnNO3OQFsviPQ+uCYfjwHF0i46n4WaY1DCWUQWSi1bCC/QijNmYFq0IdnGy/QiOKAckdaddjNIT1mHX6vSgaDvHUkvmB7xcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ECb2GyBugw5snyNW/PRg8YO/P7eoSKSgffoQ/QXTua4=;
 b=avqCdujzzYWN5U5AJuorySqsRUjQgfLq0rfZBFpzNPE5XKh8nJsW3ZBHft1a04EvdSr1FmtmmbQpmvJVpyw3wIWUZfySvy9v9e3F26P+Qn7TTSyJKqUce39crmpfTD4WEU6TQVTx/Rc8+hFvquuMw4vfG666OvxYdySgua6UzFZ8xET2mGL7snvUjoRkqwPSzKwHVRX1EBNM2c2tWHYrfwinHAMNZVqzGO060IKc1PZDWOKOUTA+HbOvTHz4n05i4g+2XxhuB2zUfv0O/T+JXU9yp1PaLRgMr/GuDLccGQVbRewihyvcxOXifGtRfuRXm1Il71Ku/O+eJ7q0v7Aykw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ECb2GyBugw5snyNW/PRg8YO/P7eoSKSgffoQ/QXTua4=;
 b=MaDeF1PExqLNbxgpvhKRG8bkhChuHO+iEv4IznTnqSA2mNemuLIOZIDRK4ihGT1/7I6dGGV+NB30bBi0pB+ml1WtRk6yKrrhlR4nB4FWH81SUCLpP9cVYqpLD9k1vWmDhBcn9INeQT3GTRTXoQtMgPzuPYA7V+QUulBbzYf67v0=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4225.eurprd04.prod.outlook.com (2603:10a6:208:59::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Wed, 30 Sep
 2020 16:05:51 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3433.032; Wed, 30 Sep 2020
 16:05:51 +0000
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
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v1 4/7] net: mdiobus: Introduce fwnode_mdiobus_register_phy()
Date:   Wed, 30 Sep 2020 21:34:27 +0530
Message-Id: <20200930160430.7908-5-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR03CA0168.apcprd03.prod.outlook.com
 (2603:1096:4:c9::23) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0168.apcprd03.prod.outlook.com (2603:1096:4:c9::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.16 via Frontend Transport; Wed, 30 Sep 2020 16:05:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 00e5a9e9-7c77-452c-a341-08d8655ab401
X-MS-TrafficTypeDiagnostic: AM0PR04MB4225:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB422550384151A0F6DAD03D05D2330@AM0PR04MB4225.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QyCFf+9xlUDSg34y1rl48368mpaEEi0SFjuhS5Op1vkappbebVARvnr5sWjblYQ0k5ia45ejTnKWbiB//T3VTs1p1aAHma0TstNP31uykEIL29hE4snQRaG4UBjhdbmRnC8ggKeM4mmA6f53EbKwSWbIyjeH5vwl3bL/va0V1qFX/3krCDDOT9SvFIZWrMO2gCmALN/ZQrXUTQltD5lTsGUWl5MZUnGf6NllOS91ralgd85Szh24N50+BVS9v6AGyQwG90YDe/Cna2uJRCQQflDlc/nXbaeYfXtK1hDDpA8GknkxfZxkdf8YsxPFqXMnwdwnnhGpPCTzt/maFAPUFRWNy9+gvG5dj4vfblyh+IESSMMrENfSTfaFnVaF2Hw3rhLg0gcFw4xf47pps/VDxOaJDyS3QRbzjH/Xqk2FCcUh/0tfiuGzPT37mNF/uqo6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(2906002)(8676002)(1076003)(26005)(4326008)(54906003)(6506007)(316002)(478600001)(8936002)(6512007)(55236004)(86362001)(66556008)(66476007)(5660300002)(956004)(52116002)(44832011)(1006002)(6666004)(110136005)(7416002)(2616005)(66946007)(186003)(16526019)(6486002)(110426005)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qF0bpZoqNwSNsGBLagmpedbSO8LttvqRoOoXb+Kq9Wh+Qh2Y+SBgPzJSTfwwnqRGk0rBHqIA8jb+yXdB1D6AKgmne916eg7H6RZXfVO5OJqGdMSx2IrIez5YJPtF6lX+12U+T1rh3UKYQMQjqlYUuzsG+uLJh9PzI+Z20HAsBOmBbDe4+Ox3rYTtTLw4nLpeL07L2CtSFuERmS+YMYqnHr+i5DHQy3t2vk40Cio0CXIiD0sH1+o1lwVRaoL9pjxznW0TsA8IHiE/TufDxAODcleKUuFZleST9LpQUqg6Ffscpm9/GGb0oO5otyWK3AEni9RxUHnMk5JZU+w4Qca0zsUuLoZocVq24RnNFHjFKm25RaT23L6mc8JlOX55VwwII0f3mEg/Ro9OIdSGS0nrd9fxtQC9mBT5vEop60kPsO+tfqVcgsT/1A86OZj16CKK2wcNKAi2NfGCyysUCHk9MOu/AGTsfz08X/VKTqoU2nOeiXSOptDe+JQCBalTbC7m0WfLuGDs1p7Cb1E6iwAilTuagTIOrQXTcGbaQPKm3kUH8nJU1nZyS2nUfteaqhnkUZ3aJCjDDGY1VJR4paQSZUMAqbnpdsThwzfVfLVCjLxU8MxOhaB1TRJfiPFQ5yZcs347Kb6ycjuXm0roeipC9g==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00e5a9e9-7c77-452c-a341-08d8655ab401
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 16:05:51.6092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eKR9Ux5Kb3Ra8HgjLTXWpoQfdhzcnY82J0Mud3YWONKSzi8Ty0nvhmTwSG/KN4BORDS0bo4CVD8bUJOFkfIk5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4225
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce fwnode_mdiobus_register_phy() to register PHYs on the
mdiobus. From the compatible string, identify whether the PHY is
c45 and based on this create a PHY device instance which is
registered on the mdiobus.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

 drivers/net/phy/mdio_bus.c | 40 ++++++++++++++++++++++++++++++++++++++
 include/linux/mdio.h       |  2 ++
 2 files changed, 42 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 0af20faad69d..693eb752cbf7 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -106,6 +106,46 @@ int mdiobus_unregister_device(struct mdio_device *mdiodev)
 }
 EXPORT_SYMBOL(mdiobus_unregister_device);
 
+int fwnode_mdiobus_register_phy(struct mii_bus *bus,
+				struct fwnode_handle *child, u32 addr)
+{
+	struct phy_device *phy;
+	bool is_c45;
+	const char *cp;
+	u32 phy_id;
+	int rc;
+
+	rc = fwnode_property_read_string(child, "compatible", &cp);
+	is_c45 = !(rc || strcmp(cp, "ethernet-phy-ieee802.3-c45"));
+
+	if (is_c45 || fwnode_get_phy_id(child, &phy_id))
+		phy = get_phy_device(bus, addr, is_c45);
+	else
+		phy = phy_device_create(bus, addr, phy_id, 0, NULL);
+	if (IS_ERR(phy))
+		return PTR_ERR(phy);
+
+	phy->irq = bus->irq[addr];
+
+	/* Associate the fwnode with the device structure so it
+	 * can be looked up later.
+	 */
+	phy->mdio.dev.fwnode = child;
+
+	/* All data is now stored in the phy struct, so register it */
+	rc = phy_device_register(phy);
+	if (rc) {
+		phy_device_free(phy);
+		fwnode_handle_put(phy->mdio.dev.fwnode);
+		return rc;
+	}
+
+	dev_dbg(&bus->dev, "registered phy at address %i\n", addr);
+
+	return 0;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
+
 struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
 {
 	struct mdio_device *mdiodev = bus->mdio_map[addr];
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index dbd69b3d170b..f138ec333725 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -368,6 +368,8 @@ int mdiobus_register_device(struct mdio_device *mdiodev);
 int mdiobus_unregister_device(struct mdio_device *mdiodev);
 bool mdiobus_is_registered_device(struct mii_bus *bus, int addr);
 struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr);
+int fwnode_mdiobus_register_phy(struct mii_bus *bus,
+				      struct fwnode_handle *child, u32 addr);
 
 /**
  * mdio_module_driver() - Helper macro for registering mdio drivers
-- 
2.17.1

