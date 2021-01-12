Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09982F3204
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387622AbhALNn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:43:26 -0500
Received: from mail-eopbgr00075.outbound.protection.outlook.com ([40.107.0.75]:21226
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728021AbhALNnW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:43:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RptJw/x3iK0+LUVz8GR0loPHMeik7BWHXb51t/80wjoFRh1FXlI5rDc05ntLRMpueWYH6Ahe8ie4DaRzTruqrONuKysSr0WtqONbY3ip+jX2Bx/PWksEXfSC0wSwx5RCEm/6i0RzKtznq8Rq8Nyjuug44Z12ZZV5RqefD+8GUk2ndzrv8vfjNBUhO1w5t0o0LC2GlrBTQlNiqc6pP7T94pkH2XELM112QENyq/JhkwcwqAJ4UsnKbTxzGGF0q2kaWtZch/L6j+tPdmMHmnUkd/b6JaRU1Yg9PWQGP1vRh/SlDulC5PIFVwrBIos1K6uCKGcHTWnPZ1oHizXfIF8Kfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W9F9yZ8Ze53QqqBBVeIkf8/Lnyv/w5MBJCzNaUfT1Wk=;
 b=i1X5KSKoLQn7qIjHNPUvRresCnu70QxJWls/+O29JhSyO/mLsjl5HksDqnIPnqkcSude53QnFBQIxiEML7fgYK7nAlnXbVt7/1OToppa1aD8pJo0JnO7nY6KAU09CJbg5u+PhZc1JXBysgj8oBBl8aoKtaqNCMWWvbhKwx6WNFb9TfWIn8NivSoBBl1Ad178wVyHEaFb1GF/AmV2JUyWeVi0brvsln03qUt8JiqZyR5Wd3QKpwEvR0QhDvMk6QmUvdRA9WbPKbLZBeQD17mDe4ovsffM+s1Xi5sj6w4txHu9DJtjxeXYo27/Gn1PibM6L5aKNP/+rkt2ZRYlt0me4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W9F9yZ8Ze53QqqBBVeIkf8/Lnyv/w5MBJCzNaUfT1Wk=;
 b=azDlMxMHhzBFxgeahMw+u22X8lSmFYSVR5y1TuKCNLJ2WPhx+EX7BhhhnVYiyI+bimyvD0rvPsydmSDpNFPUb7Rxk26gzJQPpi1iowf/M+0wF+u33CZmcceOvksT+K0NOSSjw7uaReTJ98G6DuLUpOVBslXws61jPXN+duJ3Kdg=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6436.eurprd04.prod.outlook.com (2603:10a6:208:16b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 12 Jan
 2021 13:41:58 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 13:41:58 +0000
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
        Jon <jon@solid-run.com>
Cc:     Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v3 04/15] of: mdio: Refactor of_phy_find_device()
Date:   Tue, 12 Jan 2021 19:10:43 +0530
Message-Id: <20210112134054.342-5-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:3:18::35) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0047.apcprd02.prod.outlook.com (2603:1096:3:18::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 13:41:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 58a6ad76-afed-4198-f4a4-08d8b6ffd563
X-MS-TrafficTypeDiagnostic: AM0PR04MB6436:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB64366F168CFD6001A25A7342D2AA0@AM0PR04MB6436.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w5g8eneNNFMD04cOz0tkXL4S8y87nz+a6kmqmAAyyq4ZmPDz50qe5UPw5ojwdF6JteSExQGX/gbSqmfdWXkYtkp4e6XHpK4d0TByHpOjLGF3cUy6gx5m72qaJuAne59lh6pTHOfKnAJcVzimz20WpY1DfyEVwWPBvZPjWIyJFIDvGN4FKPsriO6bV4PHmkThqn6o10OuC+B0Srf1O21zdJT3xXj4VKGj3YTxSFhvzpbKmSqaXM5vWWkjcGWiCTVEl6puWGZP+0bBxcQNj8t+7cCSSqDq75H11aGYBKsE40pUNIW0un2ECYnR5om9icw4vh3ntgNT+D2eCmfyIEl0cHNMrnjnrCl+JmU1Wgf+oD6AnGotSeomRR1aPEM+uvZIrk/CppsfoRccHIQ+fTz92ATEAtj3y5Dj8xH/cumyI3dqGh1OlaTvBofXv5DQp0KzLET4weT+mNQpJjET2V/rXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39850400004)(366004)(4744005)(8676002)(956004)(83380400001)(921005)(6506007)(66556008)(478600001)(66476007)(66946007)(6486002)(8936002)(55236004)(26005)(2616005)(52116002)(16526019)(44832011)(4326008)(316002)(5660300002)(1076003)(54906003)(2906002)(186003)(6666004)(1006002)(86362001)(110136005)(6512007)(7416002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?B+IUVBDX7VbuSMWKELXrvIgQ0BKnhB3eGAx6TGF9955WKRYnJjcRR8xcEUp3?=
 =?us-ascii?Q?G0pDvpnty499+PbmhadSTWnzNnZfIZHh5/5nu7vg/h6LgGj4lFpOZ/F3LQg+?=
 =?us-ascii?Q?BQbphKmjuOQGU4JvBNf63lzS73R2Xd2Svnay87m6I1A3TtLhCSk8SZjflcMW?=
 =?us-ascii?Q?KWiqUe4SOFt0oxIhRJPO5KxwDc3nH4vHghWIUiuQpwPIUr+asF6pk76DsLYd?=
 =?us-ascii?Q?tDcmw4lC3j50p+TSY2Lbkg8Z2szRl2jVaWE9FLjJij9/1XbG3o/pa+SSKmjS?=
 =?us-ascii?Q?rI5I+SxRyLFk/4JzGS4VVmk5I5AE6yC8wLQVExiKbYrEyvjNTcghGOQxegMI?=
 =?us-ascii?Q?amVouw/WBLw+cqxVpi+YqOwpGNq0UsWRIGbWMDkpNnKad7M0T2Ibi7OrhPCd?=
 =?us-ascii?Q?rC5Hqbr8ZpDyeK0jMO29cutbVvYEJghGYefuCJ3Th3szuV33JqZ0hg5fWfIW?=
 =?us-ascii?Q?MjXSEJTwlEsp2W/DSzj4tgigQuzIERPYhmaLD2okEyJeDXj799wOlo9zlRWx?=
 =?us-ascii?Q?jO1REcXDjtGVzUiBKezqcv8s4HRa/9L+/aein9gIn5gy+dTS7nVDGMsZCJQB?=
 =?us-ascii?Q?u4LOykgp0wn+jkqYU+pJTYWpCg9QGk+yUe5NdlCyew5OcnyxsO6p43Nt0SYw?=
 =?us-ascii?Q?MwkoStTdHxpM0UzSOlT4EAWtyodncFYws3UTP7EwC8RTBoVLmDoXiCnV6LbS?=
 =?us-ascii?Q?786aX/Wjw7VOFPvzBL3SswwR/V1KBzFFBdnSjEo7P0t/ZpAALVoLInuwMI/d?=
 =?us-ascii?Q?jZRjZ2tuTHKn45ok7FJkBfEdpY3ztQmZ3feBi7a6IWjUDdmj4EEa29xKIa+t?=
 =?us-ascii?Q?/ttkdBwFiOMb98V5HxGwZ0w/mPjPW0mmuAXlr0mUuAOoAL5enmCWGEf5vG0Z?=
 =?us-ascii?Q?60yWeRNv0qeec9Q6YdiWK7idrSLVcRcqSTosTW5cjn+y4T6O1l59SgMu0wry?=
 =?us-ascii?Q?HtDCRcjOZqdpKfyA8m/qNGUurzVJlCKSueNrq6AJXyuMctg/HGeS4l9FlCUI?=
 =?us-ascii?Q?zfw/?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 13:41:58.4419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 58a6ad76-afed-4198-f4a4-08d8b6ffd563
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /qkZIHxChpDC5RssiWw9gEW42OB3myj4ZH/YLS1p+I2pfNd9Kz4lnV9OjHvLJVh1CHKLgTo0arDQnjoyWXKeHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6436
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor of_phy_find_device() to use fwnode_phy_find_device().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 7bd33b930116..94ec421dd91b 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -360,18 +360,7 @@ EXPORT_SYMBOL(of_mdio_find_device);
  */
 struct phy_device *of_phy_find_device(struct device_node *phy_np)
 {
-	struct mdio_device *mdiodev;
-
-	mdiodev = of_mdio_find_device(phy_np);
-	if (!mdiodev)
-		return NULL;
-
-	if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
-		return to_phy_device(&mdiodev->dev);
-
-	put_device(&mdiodev->dev);
-
-	return NULL;
+	return fwnode_phy_find_device(of_fwnode_handle(phy_np));
 }
 EXPORT_SYMBOL(of_phy_find_device);
 
-- 
2.17.1

