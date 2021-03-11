Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09729336C38
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhCKGXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:23:11 -0500
Received: from mail-am6eur05on2087.outbound.protection.outlook.com ([40.107.22.87]:58560
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231455AbhCKGWn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 01:22:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cgzDD08YUw/XA/un7rfP9PXH55srMugWSSbcV5kTLM0CHxWqsg8pniGABnrlWK73askXjeKdR1sZ932V59kkKMUWBH66cK+AIB43B6MT4+iOsLQLB+ECb7EKdoZSIBs/ieQ034lchPENhuVyxP7nalnIIxoiTz+K9BGTHXqAZaNVrVJGbh8bY2O7XUq+gFk4jUluFUFJNjRhMcb14YQtl6ydASBNKRh70qDZ69y3vI/IeIuB6sl2TryHKeEZfDRV4VKczv1ezPuQj/rbPMCvO8lipD8GYETiRMdiZq1VQmcWnZwHdOF6vgd0DxdpXs+mF9VjOhadRfSMHhbKoML22w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JRYSLoQWnWnrDWdjSSVe8XeC4AwOa3fG5xSoEWPqlQg=;
 b=jTgOP+6X0URNPlctdI6fd9sqnGsbVB0h5ICMcFTeKcCwPdWydzipAn2Gc1Tbf+YWSRWXH0Oix1TcG7pgaGRFnhuSBb+/X6Vall89fl0gPmEYOSPfRpD3XavGIej3DvOjTg5Cvqzst5TKwBx3FoVPi6vpLFf1Pf1f33SMk6nm6HA/imsCfwSWi0c6YWgQGJNUqSRHtaHStrJGS0ew3yBsscRrQoZbKJgC7Ij9CdILLYwAECV8CB+cSQWTX8ncAtUJbZ1Mrz4ws1Xh4Ol1qc6KNWTa+BQin2gRXldLGgKR/w8aoaM6o2LePcXuFDWeEBjN8ELbHWVnTwCARLoat1EIpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JRYSLoQWnWnrDWdjSSVe8XeC4AwOa3fG5xSoEWPqlQg=;
 b=lDFUu5ffTns/HCqFZLjuX8APwoPPH3eq90livlZ+qhZTys0u0u/OUacKWyBwtujkMKF8KdElVZV9+V6J7RTchESExe75MtUrabgRBQS+O3PAQ4uMK5Ij4Z0wM0dkYrDpW9jsNcpLfqveMyUwTj+dyblAmitVtU80rBQ9rwaxy+k=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6611.eurprd04.prod.outlook.com (2603:10a6:208:176::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 06:22:40 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 06:22:40 +0000
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
Cc:     linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamie Iles <jamie@nuviainc.com>
Subject: [net-next PATCH v7 13/16] net/fsl: Use fwnode_mdiobus_register()
Date:   Thu, 11 Mar 2021 11:50:08 +0530
Message-Id: <20210311062011.8054-14-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: HKAPR03CA0026.apcprd03.prod.outlook.com
 (2603:1096:203:c9::13) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HKAPR03CA0026.apcprd03.prod.outlook.com (2603:1096:203:c9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Thu, 11 Mar 2021 06:22:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b1fa9b67-3460-4608-1915-08d8e456126d
X-MS-TrafficTypeDiagnostic: AM0PR04MB6611:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6611D4B314B9EA8D355245FAD2909@AM0PR04MB6611.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HsIT2ZIye23GnY3ng2SbI6UHGM2cHFoZxHfoykxzldi3h7ij47DauGUaBkdGvFl9qeLQE29OhMTb6H5lrKnNmjl/bVuOtAbBll0wWMPDXkvv9C3vMH4CRLXZEw/7Mp7+CLZQMsEiTVL7SLlWNt392s03olWYvBLZKBrydDrrqZEqT85y+HfvGKKcsfNqJO+nG/KMI51dCZyOi4T23KGJXSnYtcqLvpA80ZJeaNf2QC9glSgu6Yt1QRTf1b8kFYPTUN69pBcxTo6XwIUsRi/JO4MTOsFkgDqwqIPJXlkckTzZFF8dQyy+RUSnHJEYRVV+uIc6DqQNTB+VaPjysH671GavJTidWDADdjk89iSD+QOMpgSgAvYJipX/6JHuYCM9PXFCxFeQxgL1vUlOXuQ7/4BqT7K9tYuRx9WCXYpwyfRYd/epr+LjqrQpVyCF02vFog+Nzh4tTTx/QwyixxBCeh9rsysKW5i2axxglgL7DqEEP4WGD74GgUpP5PfAQxuiUD+iAtpsbmqQlpZvPwQOIc+pNb39/xEmkz7ULx1mRJpfDPfX/RRt07mYxB7nWYWyfRcrMy13QU91uwavtLXqJl5tQUJUOCkStnGwobPbEZY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(2906002)(921005)(16526019)(26005)(186003)(83380400001)(6486002)(8936002)(6506007)(66556008)(66946007)(55236004)(66476007)(44832011)(478600001)(6512007)(2616005)(316002)(54906003)(5660300002)(956004)(1006002)(52116002)(8676002)(6666004)(110136005)(86362001)(4326008)(7416002)(1076003)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ngjW4FxRFlk47LpVIUOYqRezdj5/51C396RCTkPTxA7TYnI1rduydHp1JPAI?=
 =?us-ascii?Q?smfsFlZgkp/sOAnDdT71iisIjeIxu5MAd7/IAmNgMbk562Yrs1FFjDyhM+3h?=
 =?us-ascii?Q?ZxGWBYjrn+62jfoRe/ZVKwqh0oqbMsjhoYJxnjNAetuGp/m8LzA0eS0alZr6?=
 =?us-ascii?Q?EnV6IbnldzxWikRt9f8VTuGL68+j0E8lD1voRzUbh9sXe13BGcfmt3onp3sm?=
 =?us-ascii?Q?ddG1fw9ZAQ3MO9Q7QyuQIGMlKxbZB4OqYgj0nH6t7nEtKJ3QHaFMigqCfDsQ?=
 =?us-ascii?Q?G8tKw7ZAZU+eMi/ylV+lrEsSm1mlDnGn9w5rAMf3mKtwZOEyWw3MQGSyCNq3?=
 =?us-ascii?Q?OJp2EviRGQ3rZ5HSDDuyojVNPXYhIblqeM8e9hVy0NktSvve329HtKBPh9db?=
 =?us-ascii?Q?VULc7vcEKPhdhS+5EtjjTfbpH3tk/SC0cM5qGpQhT1nJ/jlIThT4kKmU2fQ+?=
 =?us-ascii?Q?Jbu9mEnIhH00VIjMs9ZOUjos1h9byff0P8rSZRMssJxQBkUYDvlud1vOOQjP?=
 =?us-ascii?Q?LX32Gw4fh2/r6ZDPLX/ZO5MIEz34ann9nGwE5AmWFrvzm2DI/pyNW2oe3n9N?=
 =?us-ascii?Q?ecwfbeUyGfyEqJbpt2oHjWnDAwe8p1xmHF7tIcd7UUWenKChdsFO2Qu2gr8o?=
 =?us-ascii?Q?+W4T/Rh8ZTP7G/FDs/nhbf7ZTg9cxLLuA+mdxs8y27UKhlp7sW8p+WXJBx+P?=
 =?us-ascii?Q?faKa9LZq5yjijTqoh+QuaIeixvUpYVorgkB+23QiCkO7NrxxlK9PWOOXQO5b?=
 =?us-ascii?Q?XiDfs/Y8r5Yn4Uop4OCSy2531kALl4uCtNbkEZb/3/61i1ar05tE7oxQB0Jp?=
 =?us-ascii?Q?05a3YwaFx9n+g1NlbcCe9RFFxUVoToKN2AzKJrn+TZHDDW2IV8JT1Vr6KSVk?=
 =?us-ascii?Q?I8t2DPg+gz3LH2OgxNupwdACCxR4/g+VZYPEDQEC9SZBT4SGcq4abMTvyUsv?=
 =?us-ascii?Q?a7wGkpqymp1d0SsEDjWrEp0oN1Xp+3zca1RglQvep786p0jKKtZ5X0iGLurA?=
 =?us-ascii?Q?bXKLkSpp7YZuCMJHNFWwOFQm9MxJwrCOWAgrjqayZQ5J9dUXBV1n5Srrfs5E?=
 =?us-ascii?Q?LAJ1OkRzhZYu/fIADRiDaBmtvGBK3EDw/63tVkTn8TdkS76AUDxe84ciE6Ey?=
 =?us-ascii?Q?Zes7Kg/n+SRAPzZ2vKSO5KrzKmdOFIN2oVnoSpsCzO97KvxXRqDn55rrF+a6?=
 =?us-ascii?Q?zqCXZUI9k8VwEf4Hi8lNpLtVWA9dH4rkzurumb0ku7ypt0myCicnTtSFf97b?=
 =?us-ascii?Q?BSC0E7Kks7c2czRFA3SJFTK/AxpHumFa+D2FsISZ9DShfLTmJXKWH3SpbSRe?=
 =?us-ascii?Q?AYErTCfyQW3j5unIAdK1IRKu?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1fa9b67-3460-4608-1915-08d8e456126d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 06:22:40.2853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FHiw9hl0zKFX+pSkvfT5evDoA7SNvRPK/IPzt+Cw9WwOuQlX2z4QjsANN4bp/7aYQwMJh+bwS9fjWBRbABEzAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6611
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fwnode_mdiobus_register() internally takes care of both DT
and ACPI cases to register mdiobus. Replace existing
of_mdiobus_register() with fwnode_mdiobus_register().

Note: For both ACPI and DT cases, endianness of MDIO controller
need to be specified using "little-endian" property.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v7:
- Include fwnode_mdio.h
- Alphabetically sort header inclusions

Changes in v6: None
Changes in v5: None
Changes in v4:
- Cleanup xgmac_mdio_probe()

Changes in v3:
- Avoid unnecessary line removal
- Remove unused inclusion of acpi.h

Changes in v2: None

 drivers/net/ethernet/freescale/xgmac_mdio.c | 22 ++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index bfa2826c5545..6daf1fb2e9ea 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -2,6 +2,7 @@
  * QorIQ 10G MDIO Controller
  *
  * Copyright 2012 Freescale Semiconductor, Inc.
+ * Copyright 2021 NXP
  *
  * Authors: Andy Fleming <afleming@freescale.com>
  *          Timur Tabi <timur@freescale.com>
@@ -11,15 +12,16 @@
  * kind, whether express or implied.
  */
 
-#include <linux/kernel.h>
-#include <linux/slab.h>
+#include <linux/fwnode_mdio.h>
 #include <linux/interrupt.h>
-#include <linux/module.h>
-#include <linux/phy.h>
+#include <linux/kernel.h>
 #include <linux/mdio.h>
+#include <linux/module.h>
 #include <linux/of_address.h>
-#include <linux/of_platform.h>
 #include <linux/of_mdio.h>
+#include <linux/of_platform.h>
+#include <linux/phy.h>
+#include <linux/slab.h>
 
 /* Number of microseconds to wait for a register to respond */
 #define TIMEOUT	1000
@@ -243,10 +245,9 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 
 static int xgmac_mdio_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
-	struct mii_bus *bus;
-	struct resource *res;
 	struct mdio_fsl_priv *priv;
+	struct resource *res;
+	struct mii_bus *bus;
 	int ret;
 
 	/* In DPAA-1, MDIO is one of the many FMan sub-devices. The FMan
@@ -279,13 +280,16 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
+	/* For both ACPI and DT cases, endianness of MDIO controller
+	 * needs to be specified using "little-endian" property.
+	 */
 	priv->is_little_endian = device_property_read_bool(&pdev->dev,
 							   "little-endian");
 
 	priv->has_a011043 = device_property_read_bool(&pdev->dev,
 						      "fsl,erratum-a011043");
 
-	ret = of_mdiobus_register(bus, np);
+	ret = fwnode_mdiobus_register(bus, pdev->dev.fwnode);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register MDIO bus\n");
 		goto err_registration;
-- 
2.17.1

