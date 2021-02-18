Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C75B31E58A
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhBRF3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:29:01 -0500
Received: from mail-am6eur05on2076.outbound.protection.outlook.com ([40.107.22.76]:48096
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230175AbhBRF2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 00:28:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XAeWtntu4jgIWImd62bTScVkx2ic8WAoIiuv44/jea0rAR//DUh36ogwBzxHo6qdPm4d543x7dOf6BagnrFHBbexi5NI7uPPOGDDc8NV/qWGwKrP7cJoEkPvt3judJmHAiYGv8A6P+GZev3cuRSplxzRrECj0/ffemP2c1Qw2LxsYCENvMHTTX7qG9Kn/vwo/BIPrIWFjgkWCecfNbJPjIYikXrfmkCo1OC74hoNtDSr/cnxO7VfcTEk0wy2DFC5VszlF6BFwJHGYjXsWhDlhMMo+YZFa397TSlI+3FzRrJWFOkpUdY0XBdxXnu0b6p3Y6LkEm6xlSq8vShxCCOTfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBeDkuzCmQMK4Qo7UTjtAPfm2bUt3Hpd3KuDb3+ywv4=;
 b=F+xmM8mnv3iTakxoH1iunOLItEza3XWYS5I8ocEb8C0LxXY9wt2lM3vHaLDffOZ8iKIdwm6X/CS05ChO8go2vMEdgvtuu6rdiH9ujFTI6vbEGd7bhQ81ovi0TRFRgSfknPvHx2RtjOwk+38X9sVowxnNHkHzGU+WFgiyMcePtnhU7XE/xU9nm6KnAq+vYs5vN9hxRAFvXlCqPZz1iZiRonc17C1rO4j7K+l/n2G9V/SzhqQ9EqzEZc/2mnDBUT4qREKKXR5AjBNdXbogoZO6LmKzOc1rw47fH7xXGuLFYWnBKqsmpyUuLY9u10D0drxY1D2/pDSRfN/C6JbgEKbuOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBeDkuzCmQMK4Qo7UTjtAPfm2bUt3Hpd3KuDb3+ywv4=;
 b=F2RaNgIMLmafjQvn4XhXlbNfx+d9p1Y0XNag8xhy3Yq55Jvt9tA49cBtQWdTFjM5F8Ny7AS/8zF+tsTnkP5nURltQcOYOWArTjwSG50QGubBCxFHzwXA4xSutAb5FUXop8zRWX0Vzj1TtI3xrZanNpzVwXf2vEImZDvTFKvBSxA=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3442.eurprd04.prod.outlook.com (2603:10a6:208:21::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.42; Thu, 18 Feb
 2021 05:27:39 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 05:27:39 +0000
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
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux.cj@gmail.com,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v6 02/15] net: phy: Introduce fwnode_mdio_find_device()
Date:   Thu, 18 Feb 2021 10:56:41 +0530
Message-Id: <20210218052654.28995-3-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
References: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:54::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0051.apcprd02.prod.outlook.com (2603:1096:4:54::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 05:27:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b664096e-4c90-431c-0fc1-08d8d3cde82e
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3442:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3442AE347A36BA266BBDB507D2859@AM0PR0402MB3442.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v81HzRA+wT4eR1b7kmK3QKUnnH6X7VF86bZjmihw4UURQaYKnUxnPwnT7tEQx7Y8vyWZg/cr5O0grApaZLsgdkP7gVB8X+Gzo+zeh362OYMPv7mENdBfreCE6WbUw5H0fMOC2JgRwEyprbwml6UT7bkeSZJuKBrMfZlCrGDCHmTNWRfaAbAPR2kk/xfTcpHjaEl+oV7p36easM26dUZlKqj6l1GnkrFTMaYUHbAEE/8w6aYW7y189RPZXAg4qYHQ268Q6goz2m7iy1utlt8uI3DocuewHcg8BnDULDNa891DkbPOVkG86KGOGI2/lZIDuFYCqBJ8Yi4l6AXImGlJYtFNczikQ+Nf0eHbY7vpxXA91oLGrKhr0ckiV7n38Mqodk0tH0P3hizePjozwMVQVIr3lUmxwVJmEZO4BMHwUtQKX4iQ4elcIdBtbsn0oNtSjK9ilDK29l1cyeXtFJknfxWIUOHpUErJbeddwlMgAb9/B8yASNuCOg2LATTI+ks9A0MrUscFF+JLlUpMdFcmdo6UJr47Qjg6orwyRhxvc32PvGLjTz2+XU+7/XCVsXDDf4LeWg6Q1yVrc7+nM9kPaacRXchOfGZFJdljl1AoP7c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(44832011)(6486002)(26005)(7416002)(16526019)(110136005)(956004)(2616005)(186003)(55236004)(83380400001)(1076003)(6666004)(4326008)(316002)(1006002)(54906003)(8936002)(5660300002)(921005)(2906002)(52116002)(478600001)(86362001)(8676002)(6512007)(66946007)(6506007)(66476007)(66556008)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JUGdmB0o8Duj/J8d2ewXZRi5hBeum2uuN5p+Hf0/1Wx30VcmuhgkD+d7XsWV?=
 =?us-ascii?Q?SBCfSO4Zby240aSfI6GiSW25NgTFSj21K8Uq7iwk/aaSuQNpBOrnK2fMflen?=
 =?us-ascii?Q?5HZZXoVLVIaSgart4bWveTrPFW/K4F+p4pri7/qzfeoiIBoh8s5k16ntPBn7?=
 =?us-ascii?Q?VziRC5uUbSX7pCcSuWZ/nj2x2H/4TnIb13X07UD+jEtJaXOYdXHuysyS4s0W?=
 =?us-ascii?Q?L+6frbeL45IHk1dEFBmSSnGFGwW2UAsauhyVn8NTotr3PUbzxnNvLdHgz/o+?=
 =?us-ascii?Q?ZbXM0SLJvJ/pJNh13Fm7NnYFjGYSNBRO9kN6WcZkA93Xvhx/9DgpyefZhUOr?=
 =?us-ascii?Q?V/ZX6d7iI3IaMk74vYT5p1coeEWwW8RGMkS9p6bEQQVfzPxwQcy8rG1SGFrG?=
 =?us-ascii?Q?W4NmUvJcIBWpJIy/bh292FuHxJ+x/ezyhGgyzYimpkZfDKznSj+XUnqVG4BF?=
 =?us-ascii?Q?8EcrSXy5cSHEA+szfyJ6o3md88GGrGtOQFmZcJsogNrOpy+Ayvd7EOweuKTK?=
 =?us-ascii?Q?k4WmAOYnrKJQqu1s3Y9aD2AixMbCw/AXYMsJaSdya4FBGJXAsRVYVnR7jiFk?=
 =?us-ascii?Q?srWnGDz4Pkpgdr1yBLl8qrSy/9csLqzdszTw+JxU95PZxa92PyTGPmrTZLPi?=
 =?us-ascii?Q?q70Laa+5y4h4lbVJlWQ8f8CaDp/TcrrEJvwe/f6CWb2cWdH6ZlHirhI3Rd+z?=
 =?us-ascii?Q?fE9d6wQF9xqG4Qn/lJo5H4A1/aA9t+aN+jp58gUESUd4/o3+O+Ci2XOAdCQD?=
 =?us-ascii?Q?y4vSj1JYqbZT2GHo9N9BQPvTvrZuzrKRs47wNQ4pz3OYg68ZtdNEsQ8xLw/o?=
 =?us-ascii?Q?w01Qj5LDJXhKJY0OPvFgy0g2sRgfKjmJxYFtRasiaPCxmLRJE/BE6//lqAn6?=
 =?us-ascii?Q?WWlgU3QhDNNvuo+0sNQVRBnofibsQJc5Tc9W60Pk28KZBB3ddSMh7YoVGblx?=
 =?us-ascii?Q?Ff4cOb10XZSQY6FgO9+JeavluuXP+CJmfIbz+DAQHAVOwcUQNzXWKVq3QAqN?=
 =?us-ascii?Q?R5vOVIdzoY4knA6cICshDtgd4VYsbW4ijaAegNYaQvJ4T9RN+8cAoVGYLCht?=
 =?us-ascii?Q?tplEhnHmuDmlJzUdMVYhIjoclU6W5lFBEMr5eD0y9eaoclG6PoJ0kiiW4Dpu?=
 =?us-ascii?Q?njhXT9ovwcrPXu9glWNRECbWEdlhUVlFaBpbyJ+DG1ayn7V9m5vmyiawBK7h?=
 =?us-ascii?Q?cs6Ww3HwIkKMTecvMEfvsUEfXonNMeW9zfeudrMaEN260lmBh4w3ZBMMeKQW?=
 =?us-ascii?Q?sgh2uOGSALD8qhP2GcOAwA+qwntDNM1sNZUVah3w/IX5eU41UJ1N8xD5Q9q6?=
 =?us-ascii?Q?EyYSuvZ0gps1hlAVXFSLIUFk?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b664096e-4c90-431c-0fc1-08d8d3cde82e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 05:27:39.6140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aBWaaSCsXuquNffhoYIcOVTT8keHyw+9zNtNKm0HLHUFs5xSSivWLIC4rT9NkMnEow+H3rTp1tzuIfN/h7Tbhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3442
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define fwnode_mdio_find_device() to get a pointer to the
mdio_device from fwnode passed to the function.

Refactor of_mdio_find_device() to use fwnode_mdio_find_device().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c   | 11 +----------
 drivers/net/phy/phy_device.c | 23 +++++++++++++++++++++++
 include/linux/phy.h          |  6 ++++++
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index ea9d5855fb52..d5e0970b2561 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -347,16 +347,7 @@ EXPORT_SYMBOL(of_mdiobus_register);
  */
 struct mdio_device *of_mdio_find_device(struct device_node *np)
 {
-	struct device *d;
-
-	if (!np)
-		return NULL;
-
-	d = bus_find_device_by_of_node(&mdio_bus_type, np);
-	if (!d)
-		return NULL;
-
-	return to_mdio_device(d);
+	return fwnode_mdio_find_device(of_fwnode_handle(np));
 }
 EXPORT_SYMBOL(of_mdio_find_device);
 
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ce495473cd5d..e673912e8938 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2821,6 +2821,29 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 	return phydrv->config_intr && phydrv->handle_interrupt;
 }
 
+/**
+ * fwnode_mdio_find_device - Given a fwnode, find the mdio_device
+ * @np: pointer to the mdio_device's fwnode
+ *
+ * If successful, returns a pointer to the mdio_device with the embedded
+ * struct device refcount incremented by one, or NULL on failure.
+ * The caller should call put_device() on the mdio_device after its use
+ */
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
+{
+	struct device *d;
+
+	if (!fwnode)
+		return NULL;
+
+	d = bus_find_device_by_fwnode(&mdio_bus_type, fwnode);
+	if (!d)
+		return NULL;
+
+	return to_mdio_device(d);
+}
+EXPORT_SYMBOL(fwnode_mdio_find_device);
+
 /**
  * phy_probe - probe and init a PHY device
  * @dev: device to probe and init
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 1a12e4436b5b..f5eb1e3981a1 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1366,11 +1366,17 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
 #else
 static inline
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
+{
+	return 0;
+}
+static inline
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 {
 	return NULL;
-- 
2.17.1

