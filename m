Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6252031F2
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 10:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgFVIUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 04:20:16 -0400
Received: from mail-eopbgr140084.outbound.protection.outlook.com ([40.107.14.84]:64487
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726459AbgFVIUO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 04:20:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BIhNaNrrBcaoTJctQaJCab03c/x3PSGSX+VuteV3oZXt5r3/6f5VPXxV6bJGC0zrjRJVCGfkHgiitoV4UXugHhoW8Fm6EnwZuevD6E02BTU9PYnfoXAOzKLEwfjfzNMVISEFUBWTAkIW+PON79FL4NVCiVLBHbuyzTuYNtNc5PKzErGOBiLWBi3CJ5LOo+8XFPvKgRWE5/s72wTL+BtaqvJBMzpFMTrO6DqQT4qn716sitq1WKX+7g/xulS6alJHA9BYtXEJXyvgynrEdvkehoLdGeDMICDFtr0Lk6teb4YqTANS0OHJv/y69BOiM+HzArjop38yl0Eve4r+zEJE2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MdXrf3B7jXtCp9ePlyoUBxNRhxhHmmd8MtH0ZOd19Mc=;
 b=YMaKloRciWTds+V5qZCclKbbo5lO+rbs+qndi8cOtlVOctqj+6C5Io+AJMiVN9p4kCUz8RKfw6enA9WtBzVKQ1HYNNFwQTkdRxFs5GLg2NnMvU9rw9Hs0fmkciJUXsTl2KJ+KzylpJ76QDxMvp38PT0qIIJoXTQm6Uk3cUPqjcUIzd8b7c74F/RWab8nIzyJZGftBRSYs28F7jUuwAjHpGFeFpqPATK/SOcoxSIrsAPZ5FH919AW2B+yl0Vu2KuLuf0jBlDeu/fK2YgXte6rNPKryA+H3cI9UjY9sAc8HHVcV2YCNJy7aYgxr/KpoDpl5DJY7p+9BIhj9kpj9KDcmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MdXrf3B7jXtCp9ePlyoUBxNRhxhHmmd8MtH0ZOd19Mc=;
 b=HWQagWxOMdiePkjOaqFogAscqP4Lv8VaBbVctIDMcBTGldDSoJoHOOSF30J1CG8jLMETPKWyg/fRtX0zdufRllZaRE1RW926YgA/2+ajxnPuvzGhZExDvGBTQKAz7Iy031GZlPqHl5WZ0/s967w85JQhUypL/0bgrO+o95W7OsI=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4371.eurprd04.prod.outlook.com (2603:10a6:208:72::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Mon, 22 Jun
 2020 08:20:03 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 08:20:03 +0000
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
Cc:     linux.cj@gmail.com, netdev@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v2 1/3] net: phy: Allow mdio buses to auto-probe c45 devices
Date:   Mon, 22 Jun 2020 13:49:12 +0530
Message-Id: <20200622081914.2807-2-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200622081914.2807-1-calvin.johnson@oss.nxp.com>
References: <20200622081914.2807-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0220.apcprd06.prod.outlook.com
 (2603:1096:4:68::28) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0220.apcprd06.prod.outlook.com (2603:1096:4:68::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23 via Frontend Transport; Mon, 22 Jun 2020 08:20:00 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 76616bc9-07c6-4584-7dee-08d816851043
X-MS-TrafficTypeDiagnostic: AM0PR04MB4371:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4371C535EE36D44A5CB00C81D2970@AM0PR04MB4371.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UMApVIf6ptpzrTaVyLH9f1YKmffOTzXav7B4gwieGHMbPdxlxG9XCg+G0hdzeuKPa9FQA+o6AY0DnHOJVNvGQIrZulGYcoYH79Woi75xAP+bxndvdChAEl9N8G6DbPaUafB8oIRkmYLLFiZZQyu+OA8Dj8Mecw6iApMG98M+Wekj/ny8JaoMFM+MLxU5dkReSxOjEawP1vOMMQs8dWUZlMbgbRJd1cm91tGmSntavaHfTuBd7QwA3iPIRRItWJeKfgK53304u3kH0hr36jD/H2xv3o/7CDBVNHQeONHwLpPzTW6LUd8HXzx5+28+fQ/rMIHjLBzrxImeKam0EjZnc6jNYCCU5cLVNDKMKcYq9fVxpqWmO8YLNquw9EX1eKjL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(366004)(136003)(396003)(346002)(16526019)(186003)(1076003)(2906002)(44832011)(478600001)(8936002)(8676002)(2616005)(1006002)(6666004)(316002)(956004)(66946007)(6512007)(66476007)(6636002)(66556008)(26005)(110136005)(83380400001)(4326008)(6506007)(55236004)(52116002)(6486002)(86362001)(5660300002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: sMzJzvCpayYayx+q5IfJN0DQQQpA2Tosdrw2a7kpAaKZOoP8UXNRCeIFuxpgRDw7Wq80gQ76ohi/nwtqsD2lkrJh1rfkFSwWDe4yHxzlo1s3AVj/l7yBkrX+yt9YXLEM9J5OBT5wqkgPMSSAvPqeEtLLQahL/yJiCZ4srPZY2xL5KyMcovw4rF3Zsamr/o6xzklqk42Nqyb9wYWzau7yMHYma5qHi6XNzm8XR8QwfYIaYbWbaSgGKdGzUlN4JyTQKzkjyX4dAAz3uyE8XsI69/tDJeCM9jJqp9Cy7X9gukkerj2rtK4Ib2NFvPV7ke2uORHY9x6qy32RaxBXYYqp27Sf/IYDUz8LueAbPhOPWiZ3ZeBYpz9WWxpDa7br8c9vbn8MOWwHdFlyKQSmln8qTn8Sm/as0nnTwO6qhMA2VSJto63RvIxlz6hrdX6ViNJZo47quBV2+nStp/ym9yRZ4a4wBD28BPJvZj30rXvRkNs=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76616bc9-07c6-4584-7dee-08d816851043
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 08:20:03.6952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rc/NGxe64wEo2V1tAqwyHAj9qEE0mV+Vtl3HvzvZ95XWW0jl8899WTB7NnoHBdGCvYBUNa6XbvphoppMcFu8Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4371
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

The mdiobus_scan logic is currently hardcoded to only
work with c22 devices. This works fairly well in most
cases, but its possible that a c45 device doesn't respond
despite being a standard phy. If the parent hardware
is capable, it makes sense to scan for c22 devices before
falling back to c45.

As we want this to reflect the capabilities of the STA,
lets add a field to the mii_bus structure to represent
the capability. That way devices can opt into the extended
scanning. Existing users should continue to default to c22
only scanning as long as they are zero'ing the structure
before use.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

---

Changes in v2:
- Reserve "0" to mean that no mdiobus capabilities have been declared.

 drivers/net/phy/mdio_bus.c | 17 +++++++++++++++--
 include/linux/phy.h        |  8 ++++++++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 6ceee82b2839..e6c179b89907 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -739,10 +739,23 @@ EXPORT_SYMBOL(mdiobus_free);
  */
 struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr)
 {
-	struct phy_device *phydev;
+	struct phy_device *phydev = ERR_PTR(-ENODEV);
 	int err;
 
-	phydev = get_phy_device(bus, addr, false);
+	switch (bus->probe_capabilities) {
+	case MDIOBUS_C22:
+		phydev = get_phy_device(bus, addr, false);
+		break;
+	case MDIOBUS_C45:
+		phydev = get_phy_device(bus, addr, true);
+		break;
+	case MDIOBUS_C22_C45:
+		phydev = get_phy_device(bus, addr, false);
+		if (IS_ERR(phydev))
+			phydev = get_phy_device(bus, addr, true);
+		break;
+	}
+
 	if (IS_ERR(phydev))
 		return phydev;
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 9248dd2ce4ca..7860d56c6bf5 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -298,6 +298,14 @@ struct mii_bus {
 	/* RESET GPIO descriptor pointer */
 	struct gpio_desc *reset_gpiod;
 
+	/* bus capabilities, used for probing */
+	enum {
+		MDIOBUS_NO_CAP = 0,
+		MDIOBUS_C22,
+		MDIOBUS_C45,
+		MDIOBUS_C22_C45,
+	} probe_capabilities;
+
 	/* protect access to the shared element */
 	struct mutex shared_lock;
 
-- 
2.17.1

