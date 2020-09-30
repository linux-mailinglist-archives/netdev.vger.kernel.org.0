Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63AD327EE4D
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731153AbgI3QF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:05:59 -0400
Received: from mail-vi1eur05on2078.outbound.protection.outlook.com ([40.107.21.78]:4929
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725355AbgI3QFt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 12:05:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glA3pAeIa7y0jrOhNodRPEbZLfImljO1rGfjiYgXnXgEY09FDg9DYS/mLXM8+62B1xq3jfFDcPt4+yg6EVhClpevI1/1gWv1fSM+vOFUfYK+MFwxR0Y4ULJQg4pOCnzcQH9hHiqCgB4kpWIBPnChLrsUPZ+pY3zv7wiAFSqA/36TO5ziHjkQX8UF/Bgrx75kARn4Ov1WQmsi+xoC5RccKKr8gtBqLkVHGG9v29roT/Xanj4Sk0HfAd6TnnWFmT1+itcuvomUY1JeAQSDQKBpnFfiRl74VeutSjFhVhFx694DitC+zdI3L04JgiPc6RKxqaTBVLV+k29PGHUpGBeo3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eIXDmHS9ks/6wpJhz35sSqYKFvC6qQutKaOvCkH8Kb4=;
 b=GMGNWatp1hivAFOoSbPt9O/H5fGGfunCnJyZpkW2lyBP94dmXqPqBdjB/+CXnM32LC038+rI73DaqRr1aEA605ItWR7GS7nfT3N2+XS94W0dUnVVgZx+7/nLT9OobIb1Ythe+gt+jR6Q12Etib76MOeKvdKI7XykUh6oZUNUhtDbNJaOGt3bdqTf2VTX9BKgbuI56cWRz4STLn4P+uiOOu+Vyz40LTPXYNyczgfU86Qu2j/4X0g8G7hFdstymBbIqDPzJp7nXO+nbfrxz/UwJiJgpA6+2bdqnYHTghp4+GIo74cNKPHiOksbZrwEeIXUOkPrGK1L61hzjXOXcefyXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eIXDmHS9ks/6wpJhz35sSqYKFvC6qQutKaOvCkH8Kb4=;
 b=FcgL0HzMOG84HsMLW4anRsKtKizePlYzf/O+8Of/3E/nAtW3XrgjaFlBUOmcro3X/samgiag0KpCM0nwj+/Dgz7Jyiz9rRefx88zlo0PHPDBZsStHcJtOshHpi9woPgmJ90ttdSCrKJBlMzaXkltrFJM6p8h6K4qFhlSYAWeZiw=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4385.eurprd04.prod.outlook.com (2603:10a6:208:74::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Wed, 30 Sep
 2020 16:05:46 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3433.032; Wed, 30 Sep 2020
 16:05:46 +0000
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
Subject: [net-next PATCH v1 3/7] net: phy: Introduce fwnode_get_phy_id()
Date:   Wed, 30 Sep 2020 21:34:26 +0530
Message-Id: <20200930160430.7908-4-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0168.apcprd03.prod.outlook.com (2603:1096:4:c9::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.16 via Frontend Transport; Wed, 30 Sep 2020 16:05:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 13137ea6-e512-4183-3a5e-08d8655ab0ac
X-MS-TrafficTypeDiagnostic: AM0PR04MB4385:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4385C4845B7C7EF44AA10502D2330@AM0PR04MB4385.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0EWGBmYVE+ahIPF789tk3FMRNq20HXPS2PK8qInSI4w1OF5tXsN6YF0MC8CJDAZMVkrIyLntZQquvQQuuE0OajhRqlpdfT3xCjCl+BlAJXKgQGzvQLatSQPJ7G2yTPM3cjPJRYgb5vFANBQaoPvtkC5S5mTw3TtOLbyd0cqMqzL/RAan57PL53ZwcnoxLSgn2PqkwX76xa/RuO0ZrI+M63cbzbWjw6GVpZQSOE8GUti/r0jZ0j+lWecToGV9rJSk8PsAqielZfEdBVWsGqV2EQ8ETdx7cqHcmF4oaZtuCcQ5FxNELMd4u8vxhvXP14mtmtmMtn5WUt9yPU/5bVISngmFCwj6QjvY9Oot9U5a6xcLrSHZ1V4Gjv1KdwAg8c6eI56kDsSVLHvDtquPobZnNuql4didJvQoBOKCwVf+XN/4UcHvU1p3UZRdXRz9Rq7k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(4326008)(2906002)(16526019)(186003)(956004)(2616005)(86362001)(8936002)(55236004)(44832011)(7416002)(66556008)(66476007)(1076003)(26005)(66946007)(8676002)(1006002)(478600001)(6666004)(52116002)(6486002)(6512007)(5660300002)(83380400001)(54906003)(110136005)(316002)(6506007)(110426005)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1wFwIIcr0TcJjxTHBV9UGOKnkIGqHliko/Xr6/U/1iKhrVH6RNi7ei7uYHXTArZWy90CHsk8bQAXdMCGAGmXzRxMQ7i7WmkSPTJekTownPKXi9/ncsXq7LNFmg1F/FU+rBpW41VmHgklRfrOr7g+QRL8sqh80k5Dh0H6fGrJIKTGEur9PCrXO8iaKkL5CYnZ6RORYK1UsK6Ikwe6Zz+U0RU6SiM3leKRu/rPyWIM+fE2bByq370sz9Di4GYHUWhNP2JOFtDxXByEvBcNDQZieCMNVMtV2L68BC9RaRMuvqNPWkUs6X7N+Nz0K5k27Ew65tsxv8I4LrF8qP9HBsu8CKUO5i13mlVMJ33iigftYUDV4MFryldQyOTD5jsz0p4zWVtZM/HZNAOcahBnvDMLVLwgOhCvF+UlFhNxz3dzGm+dx1ZlEWOkqt7HuQ84HVnJJTdRyWkKcNUJ2tnNdPTRRFfLGuNMd6qHbV+ChO/3XNSMPd1OLbuX6XXdPbUJqicASXFHyYLPFgS4BGzkF0ijvgtU96iIGucsk2U9SnmfiqLxccPPikziqKf7B63wRluVx7UvFAW72YSpDu8fPqwVH3S1M0jAJ2x4nOxe2zldVtZ2YJACm6NYgC4Vviv9bA0cQ1gDqbsTbQhk7jg2O8wRAQ==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13137ea6-e512-4183-3a5e-08d8655ab0ac
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 16:05:46.0183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SHW4eILHgCGFi5JcoEjsQsxG9OCj0tYmsamJ9KAHyzhIgXrghtRfHCWLAcI7K3wr05E3NrJSroJqvXSIavdaew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4385
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract phy_id from compatible string. This will be used by
fwnode_mdiobus_register_phy() to create phy device using the
phy_id.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

 drivers/net/phy/phy_device.c | 32 +++++++++++++++++++++++++++++++-
 include/linux/phy.h          |  5 +++++
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index c4aec56d0a95..162abde6223d 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -9,6 +9,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/acpi.h>
 #include <linux/bitmap.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -845,6 +846,27 @@ static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
 	return 0;
 }
 
+/* Extract the phy ID from the compatible string of the form
+ * ethernet-phy-idAAAA.BBBB.
+ */
+int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
+{
+	unsigned int upper, lower;
+	const char *cp;
+	int ret;
+
+	ret = fwnode_property_read_string(fwnode, "compatible", &cp);
+	if (ret)
+		return ret;
+
+	if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) == 2) {
+		*phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
+		return 0;
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL(fwnode_get_phy_id);
+
 /**
  * get_phy_device - reads the specified PHY device and returns its @phy_device
  *		    struct
@@ -2866,7 +2888,15 @@ EXPORT_SYMBOL_GPL(device_phy_find_device);
  */
 struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
 {
-	return fwnode_find_reference(fwnode, "phy-handle", 0);
+	struct fwnode_handle *phy_node;
+
+	phy_node = fwnode_find_reference(fwnode, "phy-handle", 0);
+	if (is_acpi_node(fwnode) || !IS_ERR(phy_node))
+		return phy_node;
+	phy_node = fwnode_find_reference(fwnode, "phy", 0);
+	if (IS_ERR(phy_node))
+		phy_node = fwnode_find_reference(fwnode, "phy-device", 0);
+	return phy_node;
 }
 EXPORT_SYMBOL_GPL(fwnode_get_phy_node);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 7b1bf3d46fd3..b6814e04092f 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1378,6 +1378,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
+int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id);
 struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
 struct phy_device *device_phy_find_device(struct device *dev);
 struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode);
@@ -1385,6 +1386,10 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
 #else
+static inline int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
+{
+	return 0;
+}
 static inline
 struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
 {
-- 
2.17.1

