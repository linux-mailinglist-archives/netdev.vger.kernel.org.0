Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B49B203A45
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 17:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbgFVPGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 11:06:15 -0400
Received: from mail-am6eur05on2079.outbound.protection.outlook.com ([40.107.22.79]:46017
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729091AbgFVPGN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 11:06:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOCyyX6vOl76/WudDwO1//5YCMrEgHwL751QJYCtySjnj6bPx+r5FrxibRi9tfGo3mezqA4HE8o0TU523p9Y3UNIyMvsIvZl96wF9Ks9yeeCWmJ83TaPAFDiWdZQzz8hEen9OQjEDSj0juBiO6LvJ2GdOn9+l34uWa9UGl63ykIThLEKfRZRf/ovzLBvSXmdSFQ6jQxL8khegQr4V6e2nv6QYNrCVH5WB6dfiqCHREEdNfHEmr+5oAbI3mn9z2/iM63t9rXxePqqz2MX66YL2ahIb7ES7pNPfhXJUAJfWT5sOOUm8mgzVREwuNfXZn9A1ohR9WyiSm+sBfVb1J41sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPcvZ8L5+NEUyg3bjO/eVqGHmJB14JSN8xERKbWt9To=;
 b=Ssj0PcMq8YVXoTc0f2eFOah6HcM8IiWSywJJPGUZAp0a67zxczZh3A6jtWuT1b1JVgdtsxEYfWoqGaJYLtg/meMFruGAUVqqN3HTJ0+2dCxh9NFBdIosbfABeA+5rSykOM/rk0rDLvhAijjgSZG0EeYC2rT0LiVf3aai6Vy1ijks+o6vyujpVLg0Ito1ZPetu634jP9mj5VniGJ+Qwf43eYtopKGr7mmeTXY3Ak2DlzxO1f7Is0tDIBsOZAARqZ2lyp1kNsJj74KjhyctEf12PSI1H0/4CEzXPfOTRg8VmoXSiAe2DunoPawGA5WkZSXPOT3hV63bIVpTdlGYwVo7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPcvZ8L5+NEUyg3bjO/eVqGHmJB14JSN8xERKbWt9To=;
 b=J5k/m7zplKsFT5lZ1/MVOKBpHDlR5EELmkIQrVZDcHlpJcdAo8+I6KaRdZA2fJSGBAIwGM4lLb7QA5o+T+FU/GTCQDnhD5SPs57nwbEjTTcD9wfRi7PFISxC1eJgs/Wk4eF25vC41Ntk2Xf+qC7d0bjn4FOXKroVY3EC81Izl6w=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4289.eurprd04.prod.outlook.com (2603:10a6:208:62::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 15:06:09 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 15:06:09 +0000
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
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v3 1/3] net: phy: Allow mdio buses to auto-probe c45 devices
Date:   Mon, 22 Jun 2020 20:35:32 +0530
Message-Id: <20200622150534.27482-2-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200622150534.27482-1-calvin.johnson@oss.nxp.com>
References: <20200622150534.27482-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0115.apcprd03.prod.outlook.com
 (2603:1096:4:91::19) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0115.apcprd03.prod.outlook.com (2603:1096:4:91::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.10 via Frontend Transport; Mon, 22 Jun 2020 15:06:05 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 72507728-4bbb-429b-6da6-08d816bdcb8b
X-MS-TrafficTypeDiagnostic: AM0PR04MB4289:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4289A7FB2304935B86006D91D2970@AM0PR04MB4289.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vwBPGTkukYV2S3qnCPZyleoEkP50vj4BO6BBCilam1xgWUB/qrnSiiMbNkEcEcaUDvQFiFBacq/MihGflRl+1c7yBph5wiJJI5WQ5lezH+yCcam5kzK1rhIzAuY+u4L2eAGCM2UYEP+ZGQgpYa3fIU/4WY+89XPcPSXFjbJ/3iCgUiG0C9zORIVY8EEXQS2pyqUbNPOb/5aoUIImwp4vzgO/4CyKGjDUMc71cBnroH100CeUrQNn45xh8n/sacclq+UZB5tZLOPcIgr3HYTAB6Z+eSyx4tl8GfXtuwlJLZXkdFuwliTbz6NfPziRl9+FwXbiWKV2ZF/kMKKHORtDsSocc21/5umNEnvshtYZX3MSbRLUJB1bR9C7VAxk6IDI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(366004)(136003)(39860400002)(346002)(6506007)(478600001)(26005)(16526019)(52116002)(186003)(55236004)(316002)(8936002)(2616005)(1076003)(5660300002)(110136005)(66476007)(44832011)(66556008)(6636002)(6512007)(2906002)(66946007)(6666004)(6486002)(86362001)(4326008)(83380400001)(956004)(8676002)(1006002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3Z1ZMh/wF/uN/ldNnBhZxScExSVNt5krZEP4jrZEAMmfqLVMQNxbC0GNx6snQ6nRaLgLzBpJjFcYDgFl2XCu32ucGUHNMTQZFyuBa9dcLe2USGxnDAe10Z24JR0UZAnkLBXX3IbkGBdMUXSeyGjk16XYPvP5wTFp/aNm2vcIjkgW3jJTeBXX+k96UqpzpqRNr1zBYTfmh7wZ/L87uTzd4gXtdg9vG1dzSqFy/+sRRkYlMfgKPRL6OZ4sWRGVgcO+EYo2Bt7jqjgPFbWTVz6ZqATn95DMZNaksT8QN0fxpvx/03UJISKrL9rJw1Sf1Q+KlfQWnvVWeAaW1/4hvIHzUHpYPt9akNv/YA9ASr9aFNTBHDIvit8ypUYzRf8BuihdtRGqMt/8JJN0/uY4QJcA3K1A/l4xTvHsOtpvrwSenxXzsWSqkvQYzGUZjM9Ek3w9Htbec1oNswiqqDxOG+k1W+Gf/aLKmd6ym5uqRxz/f92eA2LaxuEUvUofy4qyUp0X
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72507728-4bbb-429b-6da6-08d816bdcb8b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 15:06:09.5565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6R5CBo20ohhJk4UysjQzfpPrd8+tiYSSl6rSyCT7ehZoURcvh6aQPuqI+PiXq0yqZ7WyYKSx33+ZyY/E4R8C2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4289
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

Changes in v3:
- handle case MDIOBUS_NO_CAP

Changes in v2:
- Reserve "0" to mean that no mdiobus capabilities have been declared.

 drivers/net/phy/mdio_bus.c | 18 ++++++++++++++++--
 include/linux/phy.h        |  8 ++++++++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 6ceee82b2839..ab9233c558d8 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -739,10 +739,24 @@ EXPORT_SYMBOL(mdiobus_free);
  */
 struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr)
 {
-	struct phy_device *phydev;
+	struct phy_device *phydev = ERR_PTR(-ENODEV);
 	int err;
 
-	phydev = get_phy_device(bus, addr, false);
+	switch (bus->probe_capabilities) {
+	case MDIOBUS_NO_CAP:
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

