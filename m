Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3C71FD340
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgFQRQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:16:26 -0400
Received: from mail-vi1eur05on2064.outbound.protection.outlook.com ([40.107.21.64]:6163
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726879AbgFQRQV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 13:16:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKWb2OtRi1ylFP/ael2+MvtTlqnaXWYBPo5OfgbK9n7w9g+LdiEdZ11dZ5IcHMIKsWfj1kFPTqCEqps4BXOrepUu0f8zuuCZOq0AbagzVRuurnvBnDHMdWfE5jAuES6KPY0oaufDJp7a4NWlAoCBudmU1/4ppSOmez0YEXCK93JiEWPjnN+fYUz+N9H9SCobQX0Lyv9rVLNt1qO7nZqe5StQxmff16pvDP4m16ldEiuxVNnrKPzaSuijBRoxi+CJcBnLoba/U9NrcHPqT1N6xH96n0z/IhvbNDkyLE9jEYl2MFuh6BHasVAVEnBhz0lDT5swkHUxIw3PGO/VRcPbtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1k+krpDRXlb26S+5XedzSQ0OLeX/vd/QhA6No3c7uZU=;
 b=Gbeh8z977PuVBCAvFcgi9/Kq0aBZcQoef5wB9iFE+zzGGfxxn8R901gQXUYMLF1YjewPkbgMDmma/jBbF9sshRgr7bxiq/Fki5AXvhAlhpHKhUSmklEbEZDSnhRrKw+CZ6dkQ1X6a588IVyOUxciRuaaQXP1f04GGhgqK8pCTwxYEczGxNafCc6kktyALEwIq3ptM+0i59vkGm51crpI2GZ2vHHSVDmPjC4xWWXxRjz0Wn3Oj27C1Of7q8QViHbw+fL1MqCQDtnqdIsCAQd8BYk4TcQQ1fYmsGxZXiR6nyK6ec2yz8XSHQ8R+FN3gI7idA9jCs/Zc/UKUMbOhX5A5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1k+krpDRXlb26S+5XedzSQ0OLeX/vd/QhA6No3c7uZU=;
 b=eVYYOlalCuOVtjeGceqP3KWIveduSptHPLCz5FNzkyWlF+DHcCvmymZyt4Eqw59jGb2ySCS19ldijQhP6F/18M9msRxzIKw1Hfj9wg6MjuCEXFc8fJcgmc+x0dwZY8gFIShnEKJyFyQS177uIIF1Osw6nnNnWnQmkAN9q6G/Hxk=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5427.eurprd04.prod.outlook.com (2603:10a6:208:119::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.24; Wed, 17 Jun
 2020 17:16:18 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3088.028; Wed, 17 Jun 2020
 17:16:18 +0000
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
Subject: [PATCH v1 1/3] net: phy: Allow mdio buses to auto-probe c45 devices
Date:   Wed, 17 Jun 2020 22:45:33 +0530
Message-Id: <20200617171536.12014-2-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
References: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0146.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::26) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0146.apcprd01.prod.exchangelabs.com (2603:1096:4:8f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Wed, 17 Jun 2020 17:16:14 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6923cab3-1242-4be7-b4e6-08d812e225ba
X-MS-TrafficTypeDiagnostic: AM0PR04MB5427:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5427A30C3E07E71EA13F80BED29A0@AM0PR04MB5427.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04371797A5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ugjnj5x8wfeQr+d9flvk9Q1OeSoQoYyfLhAH3EOMjixeIf/EsAexgV3NA+ITlqUDtklHW9JTe6moVYhNYaCZQX88c90Hc9Y5If0FmsMhqbLgxlCUR/3HD+mPRx4KiORNppX0A1SKnR6Nj2U7L9nNWDYaU6om+w2NpZVVEN4raDpUQlFhVcbz5K31QMzBU5wLID/nK8/pbPBNqx6gkUEe3E8BRw/HoHH3cATpUTCqsHRBxIK2uqs1y9x2Ru44vxyA2pIVpp7d+xoV0LlLKiNJxviCWO3qfqUrKsFy6yFmX7e1y4tggFdNrpH4kMB4ri5CUfwjIfssak9ScnPfLnCeuRsSACIoYt7X52n6952Ie73g/LHBpdLFDexVpTY+eAbI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(6512007)(52116002)(6486002)(26005)(6666004)(1076003)(478600001)(8936002)(1006002)(66946007)(2906002)(66476007)(86362001)(66556008)(956004)(44832011)(316002)(186003)(8676002)(55236004)(110136005)(83380400001)(16526019)(6636002)(5660300002)(4326008)(6506007)(2616005)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: iqo9vA/A6gFukOzyhNffqN92ZTLKnhUpDgf2QXRpqZee2CTAH/LLkTPf3VQndVnPn+HLxzYB4Bn+GCzlVQjdO5q1qjtgkeCjkKKVhond9CgP3OXfRASLU2RpP9kV0oZUEtJWAERuR4Ubnd6Lxmiqbkw+YuzJPtc87ir1svoJIMt9afUgBlSrJ/6KIAa1X/OzZZYAUsADtOYBpJGI0+ji52UGFr9Vwv/R1NmlMfgvAy2oxhVG9RH1H/8p7jpfQ+eCeum7Kpx9/DOUVBVnv2ThzGdJ0jIrWRECsUwA/XaxECEsm3UFfnP1YhWROATiZTVCRxjM9s1zcNfsKxeq0gqLmOM7TdgR+PXklO8TBKMxVKSXaGtGrFqHFh5zirj/7/2qgO/tpxOYyhL0AkQ+7wHeyjztRwGU6Jror5eT6n+YhEVEbtp/M9LYHY8vGhz9CWWMGY4xeTG0R+/ofqJ2xc/FLDlpRXk7041+9pQNCRxVpybuzFpSEHEg1h0mXWSUbvL1
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6923cab3-1242-4be7-b4e6-08d812e225ba
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2020 17:16:17.9915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KHm0wJatozB8FxkrakUJRsESc6rEvOIHCncUUIss0GOz+KSopMkQ2A2d43jMwVxiyERPnDC3FfTFRPU+zNpTLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5427
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

The mdiobus_scan logic is currently hardcoded to only
work with c22 devices. This works fairly well in most
cases, but its possible a c45 device doesn't respond
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

 drivers/net/phy/mdio_bus.c | 17 +++++++++++++++--
 include/linux/phy.h        |  7 +++++++
 2 files changed, 22 insertions(+), 2 deletions(-)

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
index 9248dd2ce4ca..50e5312b2304 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -298,6 +298,13 @@ struct mii_bus {
 	/* RESET GPIO descriptor pointer */
 	struct gpio_desc *reset_gpiod;
 
+	/* bus capabilities, used for probing */
+	enum {
+		MDIOBUS_C22 = 0,
+		MDIOBUS_C45,
+		MDIOBUS_C22_C45,
+	} probe_capabilities;
+
 	/* protect access to the shared element */
 	struct mutex shared_lock;
 
-- 
2.17.1

