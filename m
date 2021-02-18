Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332ED31E60F
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhBRFyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:54:32 -0500
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:33610
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230407AbhBRFop (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 00:44:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cH/j2RuxoRea0ndiEeMMM1FbaJfUf0dxB7wssa0P8bN3XSUhNdYbOI2/CsjaaEeWnZsmdHOmkzBZZZFjWT2WeTOdojCbyqHjgI4DON5IJ4VVfgAOmS54IdgvGk+bkZEEIfMM5nOhZoakGUBTFbhLyCmcbGkO3sz6fE3e9riR9TGjaxVlQf6Y4EB2hnpvCOFPjn+H2hq3n0Fjf9p5jHhnqiz6my/X+/NzxxjgI3ZEStJYTQem6/jVG04fgVeP2HqrVRpDW72uhzmXUUDKfis81LuQPZ/o9BwxTJpxxOyojUseYgMPWui3iYoqkpHaIAssAmMvGoBiFWk9NEjW519nkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESGZo8bqGib84VHyZ/HCjwvaf9VDwIETrOUyoP6oJNI=;
 b=kj+EBhBmiE8Ic82EK1L8AKXr3seUeDKNGFtNj8oYMe1GoKqp83A8OEHLuD9pr1mUqZorOwHULQesFOjWuPmZDn3ol5bHxLqyPjxjFwx1/st3zH4IT/9aWYM1Xc6/iVz5RUQkb6EzWowKcjQdgrxwID4ymh0GS7k1mlQh38FEftF35Eh3lMP6RmAWN0JcAfRL0oi8j9cHIdi/WXMobLSRMu8g66jmJXoKVoaOuC0rYcFa1RzD5PMmC/su7pV0/NTYHzhAUotAZl5FY5Z52j5t/8IkYQfCnGBWWnFAZMOg/6WqoflbTGiW152Nb+4/DdtrMEPrOZSdNT6ARknuX2b6SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESGZo8bqGib84VHyZ/HCjwvaf9VDwIETrOUyoP6oJNI=;
 b=a37BPUWO0jfLXi8Xmc06QtNS/QjtqVW3Wv6m24G3sbxR6P02Ohb+pYl4Ci1VUo4wZQ2W244oS4K9eHS6e/aJ4PW3j6U14ix4WDgz9mKmtfA6ceqi1nmImrXtROyc3SKCVu258jgQCXyocjx5lZTljUg0IDbO98Wli9Nhyk+o8QE=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7730.eurprd04.prod.outlook.com (2603:10a6:20b:242::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 05:28:08 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 05:28:08 +0000
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
Subject: [net-next PATCH v6 06/15] of: mdio: Refactor of_get_phy_id()
Date:   Thu, 18 Feb 2021 10:56:45 +0530
Message-Id: <20210218052654.28995-7-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0051.apcprd02.prod.outlook.com (2603:1096:4:54::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 05:28:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 540093a1-8761-4595-930d-08d8d3cdf934
X-MS-TrafficTypeDiagnostic: AM8PR04MB7730:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB7730BFF3F95BDF9A2A7BCED2D2859@AM8PR04MB7730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3zL425YfwdWp5JYFcNVRsSmc1LIqeLiI1BoSsN94pOsXPBOrWT3hr/s45CAIYzbgrEmm0bPlI49p29mU9X27R5lWFe1nY8qoXp0ej1rMxZ6XHWlOMXpE6pXXBOIAU5kcOFptF3+yk26NzqM6cHR61d9fKGZfZ8EiwJjCQD4m4Ej8KRzC612Gorb3UK4NWbP2MWTN++8bbggEU/NGMCP6nQQvSfsj2WxynsQh2z5JJdNR4EMFvmncjio3xU6BpmeMwUgsxmBtb0PZ9gLnihSih+OScn74QpHfDaNgHmux9Rrp1nvVzI1TDaghaVXd2FGs8JfRg5gAKpFx1lGVkjtKmi8y7pX4Bdxcp4+yxJ7Q1NmVVqOZHwhK5St1v9QhnRRvpBTBGZBFjcD20qUSUDld0TCPvaozCmG2t+/GxqkwMhvDNtmSblDDJN8/UeO7gSTOcpXI7EUDDTf3jBpVIQhgv0m0rc3Mrh1fr2EtaRP+JIVV3VeWd8XctoL+MB5LR/qXlH0k/sMvhX2Q9h6kJUPFgT+R230F0KcSHq9yzGsynjbV2D2CwxwyXw62YLqPpNVoW3OG2ncIPD1LI/41YWT9mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(26005)(8936002)(52116002)(16526019)(921005)(478600001)(1076003)(6486002)(8676002)(55236004)(83380400001)(5660300002)(186003)(44832011)(110136005)(6512007)(956004)(54906003)(316002)(66946007)(2906002)(2616005)(1006002)(66476007)(86362001)(7416002)(6506007)(6666004)(4326008)(66556008)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?v7HqfRrisP7kr2/6ZLUYsKTyuZEBAKkXqd+s76a33s/j0+Bki0MoG3wNHNMr?=
 =?us-ascii?Q?XIPJgyZGim1YWV2w6x4NiB0l2afOk/88H4A1vhykdT9eauJnojgIwtek56y9?=
 =?us-ascii?Q?J6oy1EL3F8Q5fJllIjn+9Wni8Uv0e4u59n64x7cr5RNvoNMkuwafsDeekn18?=
 =?us-ascii?Q?ZRCzEHe87CbPZVosZb7PjFQ9y4Shh+E3O8OD8mJJfW7F/HBjPHeUeza8F1X6?=
 =?us-ascii?Q?y2vsKI3YubcOHn4vF7IhEoqA/0sgVTkV/R6aU7ylcrIi3/dJjmmcqICPZz7J?=
 =?us-ascii?Q?VsMJsrMQmiZxbxbM+yBPPIEjUBY9PM9uA0YYkMY/XRKt55OKgsPstNEX3DUE?=
 =?us-ascii?Q?U+E6/0WKmWBenQsleW9VhAT4n/MkWJA/UUEyWK6eQiMcJ1sv1u2LMl8rH6/K?=
 =?us-ascii?Q?rgvWLs7G5Z+fAeaWlvxxLdA/N59a21lTPUOBJpenpTS44u7NBu1Mhga1u1Ru?=
 =?us-ascii?Q?fzT2PNoweaTnHSHfDMj3PDCxVw2HID42UlikY6+hLGZCITc3LP7GW34y4ydR?=
 =?us-ascii?Q?IFx8FRgKX3kqljtko0cSsxoRICKsYt9YGCH8ETxQWip6e7tD1Z+VeGzU2mN2?=
 =?us-ascii?Q?01f8P12obdJQPjWbfttxXtcn9Pil5Xa7aW+Plz0HMV1fwIyQokiP2S7gXMgE?=
 =?us-ascii?Q?RBi8CulClofT1ZcA4loBNId/MVdBzntfJiERhVcHiwg1pmZI5RDNirSuLLTH?=
 =?us-ascii?Q?Fm9BJ9ySHdi7XGNJj3n+2Kp/NtD+TsmdVWB/wrkHCF+BOl/8wyTD5dn55mtG?=
 =?us-ascii?Q?iQ4C7Sdpi0S3e+QahWmeTp54tvt85KvuQBQqC6naxJwvJ/9iQU0sMIUj6cR8?=
 =?us-ascii?Q?EzG1SeINAGzQ5Hh8AvqLPY3DC5Vfc2h9tH1R64wj+uqByghAU+aOLZn14C5u?=
 =?us-ascii?Q?igXoUiIfBeSvwRqSm4FToG3WxZxaLDV1fuAU1A/7l4zCbgmdSQBrHd4/twfm?=
 =?us-ascii?Q?vuAy6WJUrPZhvaAVhPiW1UwXH2+IfoOFIMT9wElI3qelMJLPaQlaOvo8kJiT?=
 =?us-ascii?Q?4aTFfrLkZCMlD3wNw6U8UkRxK8av0YBon6FhqoQG2r1NtDuf7eqLKcAsd05f?=
 =?us-ascii?Q?RpkhYFO1X2wEwwArXVGWiNJZbVsQUnCl6iktr6xldbRM69EFQTw6sUE1d4vn?=
 =?us-ascii?Q?ptH3Ci+qhhB8hbjhMjlQkOfLOLFPQzPdlnTaIGhWkj5X4mhoQI2VMLN/pYmN?=
 =?us-ascii?Q?ahqzq06a+tuDskx38Rwal3CbDeMol6ucQKU42krJLL1gf1FdMJvoLtj5FRht?=
 =?us-ascii?Q?uWzaHp2JGRAXc55t6/ioWLyQfkf78ouJWU75DP1GcvaqxsylTUQ51XjKE52H?=
 =?us-ascii?Q?XuTVhjuzuOvkORoV9p37GkvG?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 540093a1-8761-4595-930d-08d8d3cdf934
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 05:28:07.9971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: suJoJ2OZafhImMYwlB8APyPoe73gqMljDmFwynAdyeimiJJEk7+siXovy1mYdvesfMKViwouIPyDHYnmth+/Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7730
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the introduction of fwnode_get_phy_id(), refactor of_get_phy_id()
to use fwnode equivalent.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index b5e0b5b22f1a..612a37970f14 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -29,17 +29,7 @@ MODULE_LICENSE("GPL");
  * ethernet-phy-idAAAA.BBBB */
 static int of_get_phy_id(struct device_node *device, u32 *phy_id)
 {
-	struct property *prop;
-	const char *cp;
-	unsigned int upper, lower;
-
-	of_property_for_each_string(device, "compatible", prop, cp) {
-		if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) == 2) {
-			*phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
-			return 0;
-		}
-	}
-	return -EINVAL;
+	return fwnode_get_phy_id(of_fwnode_handle(device), phy_id);
 }
 
 static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
-- 
2.17.1

