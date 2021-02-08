Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2081313748
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbhBHPXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:23:00 -0500
Received: from mail-db8eur05on2041.outbound.protection.outlook.com ([40.107.20.41]:54497
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233414AbhBHPRj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 10:17:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TKU0Dkr2OAwzcSJxYoQEedSvAurNqRMgmhJ9zGEuqOyHUrwoK8BpXINv8uCdR/o8wP3WmWeJIGmHA0lsJYGnnW16DYmPqvSXDJC5jpked/Bv+p2VZrIGiisxi42eSDVvRFyLQ2qmSrA/slLyzTyMtsc4Eb4IR4E/XezfSPml2sbISPvXAV6oAtvUlgrDsm0Gf/4qj4lzq7YN4QHT5rpSjl9liDHSTCxoj2a3LXMl+Z3u9Zd4jCnbdV1EBCvt1PcLgnC3hDdZH4Qxycw4eQdQNUNoFa7bANl0CkOmDnNP/s0dnUdfLmSRE1T2RGbpVle42UMRsLFoBGM0VEKpPchk8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ETB8+V+4Gpm18tAYRLC3Fvpu7R7EaJlh09wSYLgAhZQ=;
 b=EjuIEBr92PJGzaNeotFt5aZtgDfbN2nTU8T9QPW4Hmkgqzry9RW3vefzPmcpgEWKiYEyauBvi/r0j7Na0CEK2o0E+COP7kav+NnHixVzeTudaYZcPNL/T2P56qbQRmqPGWUKbyjxTSPCPiCAa8JlvIH0roTu3Cmx1/3UcPkgKc6jqgNuo34v4IaximiuhrwWSrOVkUce1xT7/ErvVbBSH+mDv/xvWXPll1MRUgvBINpWutmwucaM6tpb6aRCzWcgom0U43g6t5xCla0FiRHh+Q7ncRFB/MVoEq0aGM4R5rionXqVkjU5f4IL3lWXQ96uDAgAbVaalsrVnKfDwTFNcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ETB8+V+4Gpm18tAYRLC3Fvpu7R7EaJlh09wSYLgAhZQ=;
 b=PZnAJW8rU+xiBTuxJAZ3HTHQuKBqoCxeMQpfAdYIkh3oTrP9dGqfUaudObic+LGZuDWYsuQ29Wh1upO6IwAjCmeBwaCfpUezmGQoxHtjfcwNKmBwSm6/hm1wtatLOngAdn033Y7OGROUkknfqn8Im71TK08VAHQhzQ8lbqZwQgg=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6435.eurprd04.prod.outlook.com (2603:10a6:208:176::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Mon, 8 Feb
 2021 15:14:13 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 15:14:13 +0000
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
Cc:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v5 08/15] of: mdio: Refactor of_mdiobus_register_phy()
Date:   Mon,  8 Feb 2021 20:42:37 +0530
Message-Id: <20210208151244.16338-9-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR04CA0176.apcprd04.prod.outlook.com
 (2603:1096:4:14::14) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0176.apcprd04.prod.outlook.com (2603:1096:4:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 15:14:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e0547086-c34c-4da5-7179-08d8cc443176
X-MS-TrafficTypeDiagnostic: AM0PR04MB6435:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6435954A01D77A02D1DA0878D28F9@AM0PR04MB6435.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZPD3075oLNeDzu7MTCCs77+aW1RpbKo/RzpgZ/74VMIYwfVBaIefeYqjw64ZCyIQ372sXKfoLJLxlvKAFZot1F1E0vHadCScCDxMbeGDcteTxuBzq9r6WZEK+4dZ8ozN1ZkpXLXtBlAxpt7v+bkn9GK6EWOH+8xraCCxZKjfZOwHWCV0pHn8hVzf3ypakXqozDy4F/BIGcahuV7d+bVZXAce1VFI3XoOoZGpoWKHs5IH8U4Xm8SOKANT/4DTJxl74VlbAR4KPYVdDE2fs+SXsh9E59zi3oBqlFiIfhDcGgmNJKM02NuKBqT+eBbeRhoQYbuu5RzlnmbGQ9TMo9rDooCxj+muq8KGiRG/39PEuMS8yEGWjqvA6QgPiyTcuvvtbjPpBeSteKkOnNcDWwIpKD7/MIscThxjFMuCDx4KOkF0gaDE4mkCKjUW3AQoOXuZb6CBIXLh2cNCdC6tNJW6j7RWvOVHSVQUczYBqRV2Fnjjc0ModZPNIaYT1gazCjhamjEdGVkTHMbunnT+Z7deo/FFaDCdvi6J7uvqAN1roJtdBwH47dH78R0BdiJxDsdbKayeHv8RfKY5f/8SKo6k/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(8936002)(54906003)(7416002)(52116002)(110136005)(186003)(16526019)(316002)(55236004)(956004)(6486002)(6666004)(1006002)(4326008)(2906002)(478600001)(6512007)(1076003)(6506007)(5660300002)(921005)(44832011)(83380400001)(86362001)(66556008)(26005)(2616005)(66476007)(66946007)(8676002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Xf2AchzxsG+mG8VofkFSrfW0Ix4/KY7MU5zb3CTA1a8Sfhy2R0v0e16g3qEK?=
 =?us-ascii?Q?u34eutcJ98mTZ04lCvg63Rwhv+HrCVuf/IQE+97GG3UDB4tciu4dW+S7hPly?=
 =?us-ascii?Q?Cun2CZaG8U8LmVS/sLx0GJLd+XfDb+vYvY3ne+9MWCI3ZUwA0u5G3ynrrLqK?=
 =?us-ascii?Q?PY+9CgZJ3qhB02G4FSZ8+EAEsH/jXN5mOS8Jxyo5mGa9p5uowYMftnlAIUCw?=
 =?us-ascii?Q?eMtMS/V3/quPTFKiuoos6rjc/L5qCvvJDnmCUIh81Hg8su6IPV4LyyKuBKIa?=
 =?us-ascii?Q?Ss8dBDi5MdzzfRqEsK0lmGTY4oIDj0dyCn2RAFi2THBDfOWiVzqvG2owqePf?=
 =?us-ascii?Q?L107Om8jYwAsT8E0Rr1hnJ+FvzBiqzcKH+Z3KwGuqCbop+SlyScfXcUCdhhB?=
 =?us-ascii?Q?XuplbtH+tSeDzEgk4VtKG2MG7pdX2o5oW2M/J8EFYy686rvkGha4fbuNC754?=
 =?us-ascii?Q?PPeNSIPHgfPkPEGSFhwi/yvYunJhi2u4LKmnVMqKT2Awdj49XZc8TAUKbEqd?=
 =?us-ascii?Q?KlHa8qqfgyK7FXUha2ibhQaXGDwhaaxsF1UHEZ6vRA0sbMs5TyV6CWz8rtUw?=
 =?us-ascii?Q?tPN7aw7xFE2ycXarmSgDDYhggcE002SjDSbmhycpIqaf9IYg0PibLW2Gifbl?=
 =?us-ascii?Q?Hrw7yPtKGLwSYREEUVPcAbyn8Hhkd5WFU2Bci9zGwc+Z0E5eUYdHLdYA9lDI?=
 =?us-ascii?Q?v+9q+J8NyPNX4CVmFeqa0hCGIg2GlNtZCky6Y6t2uxr6sZAXXrAzZc7UxMjl?=
 =?us-ascii?Q?6NLLlsjjTe97mTcOBLCo2ikJrKEPvDyS8PiC2mmuKCWn/JFVL87cSbE2f0Wl?=
 =?us-ascii?Q?MwH7ogmIxtl5PQQVEQP5dAKSikwhZwgZF7A454/I0/RZ9CdGAeqdsoBo1NYp?=
 =?us-ascii?Q?dHNePTyxzBqhaCW3wLmarQ8JP55PXtlndy5n+RDdNk/Z2zKjCxOEew9hCGrx?=
 =?us-ascii?Q?wfEWW2872pJQUw5IdwJLmKhJqybJJVmE1B9FwB+CyCLEJL0s7Ho0uFhEGH0Y?=
 =?us-ascii?Q?aQM9iTEekD8OS4uw7Kcg3R00AkYHe7W8JMHNg86vu5Wl4w9InHFNCrRBwbAx?=
 =?us-ascii?Q?XwsQ4VgiklV8uRXfIdaWfSVJUb1j4pJi24nJIQaNmfIDTIBOO7snh2xYjN/4?=
 =?us-ascii?Q?ZnPBH0RAkmJkq/F5X4MQiM11gGl+tWwD6tDQSojjRg0sD/X5Mr5u92Xem17V?=
 =?us-ascii?Q?T/gRNFw2t9VZE/vmiEbRjPOSYimxpjXnEQ/qdKZRgmXz7TUMZxKMGE6C4/1c?=
 =?us-ascii?Q?nlecfS5Lc3nKDUw8MUTBex+wVejDyNpGhyZNxP06J2KbLXv9OHjqph0UK0eG?=
 =?us-ascii?Q?UluxukI+r6t3J2pXTZfIXIN7?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0547086-c34c-4da5-7179-08d8cc443176
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 15:14:13.4582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: plm7j+3BeUXT6bJG891A8UA7nRj8060EqkJruFpOfhgxl5bkZvnenLu1cKz2Bkoq6EyF+hW3BNM1VWzTevPo/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6435
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor of_mdiobus_register_phy() to use fwnode_mdiobus_register_phy().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c | 40 +-------------------------------------
 1 file changed, 1 insertion(+), 39 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index cd7da38ae763..1b561849269e 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -98,45 +98,7 @@ EXPORT_SYMBOL(of_mdiobus_phy_device_register);
 static int of_mdiobus_register_phy(struct mii_bus *mdio,
 				    struct device_node *child, u32 addr)
 {
-	struct mii_timestamper *mii_ts;
-	struct phy_device *phy;
-	bool is_c45;
-	int rc;
-	u32 phy_id;
-
-	mii_ts = of_find_mii_timestamper(child);
-	if (IS_ERR(mii_ts))
-		return PTR_ERR(mii_ts);
-
-	is_c45 = of_device_is_compatible(child,
-					 "ethernet-phy-ieee802.3-c45");
-
-	if (!is_c45 && !of_get_phy_id(child, &phy_id))
-		phy = phy_device_create(mdio, addr, phy_id, 0, NULL);
-	else
-		phy = get_phy_device(mdio, addr, is_c45);
-	if (IS_ERR(phy)) {
-		if (mii_ts)
-			unregister_mii_timestamper(mii_ts);
-		return PTR_ERR(phy);
-	}
-
-	rc = of_mdiobus_phy_device_register(mdio, phy, child, addr);
-	if (rc) {
-		if (mii_ts)
-			unregister_mii_timestamper(mii_ts);
-		phy_device_free(phy);
-		return rc;
-	}
-
-	/* phy->mii_ts may already be defined by the PHY driver. A
-	 * mii_timestamper probed via the device tree will still have
-	 * precedence.
-	 */
-	if (mii_ts)
-		phy->mii_ts = mii_ts;
-
-	return 0;
+	return fwnode_mdiobus_register_phy(mdio, of_fwnode_handle(child), addr);
 }
 
 static int of_mdiobus_register_device(struct mii_bus *mdio,
-- 
2.17.1

