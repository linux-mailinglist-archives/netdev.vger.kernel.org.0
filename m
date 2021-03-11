Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D202B336C2B
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbhCKGWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:22:38 -0500
Received: from mail-eopbgr20085.outbound.protection.outlook.com ([40.107.2.85]:25790
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230280AbhCKGWI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 01:22:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehcJodcgysLkFIjF8dJrff3uwygR3nuaC3zLeemdzypL0cBipoEeFhPvjtsHOlDjdHZ6WDBOP/02Wr8lmIL39UPo7pNTgiGq9ctrEsC7q0EXoIsiC92s+H3VkVbArRRnvugGZNHK7TlI4g0vqFgNZrVi7S2pybrCYlAWX8xE63gMCIBMyp+AsgrQwFLYTCn+cSzpaH1+I4eQWFW5ZU/4wVcJ9DS5A/fEli2grKZnDzOr5cJCUikKLQ8Tba/fL2N8E/ENGJ1iiC/Bx8S2ZrCmGCnEF+GadCdHhYmc4KawC3ixmduez2WuT27PHLg9klp7BLx9URm13f+Wfsf7KTXwuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TCNvfizjWrO5Sn821EUj0HeifNRRaWcvF9O4nLZwNDU=;
 b=Ahlde0XKwFoiiP5PpxLYSUN+Syh79tyEh8xo2BFR3rsG6eLOeHhjZZgge60recn5FCM+VLPnrVyuH7jFYaSamHAMJvPx0TBiaOzwxJrKSCAU7tSljUgKR900UMLY50SacS43dueQtQ8ztqDbJeEpeifvbFcG19phv7EVmsWJqZjlBpGL7pHaw4crojNovxFFBvTrhN4JW5l0mPeZ5suz7sNT39y9T2ioikBTeKw2FeEMDMDrIZP9GF+Znd+xlzkPJc2t52gSRSGGPbRhaCg9yIfMRcHkmg1fGazR/fuloAnBqmhyJvsxptaX67m2b0rwpU2zfpBz2eEeBF6odE0vAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TCNvfizjWrO5Sn821EUj0HeifNRRaWcvF9O4nLZwNDU=;
 b=GhVg4Uoi2sFscONMyz5FX3u7PK1ui530U4OTjSfLaj/modk7B9gqG0uN3y1WBpr6BALxfgI+Idm7e9lwR3+R9gxL86T3iXy2wjQ4i2r+dPLp8SlgfPQieRmYcb2SwgZ851xEVzbpq3XS3OleGaA90SU2Rxl6rHP8SZuovECpzbI=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6611.eurprd04.prod.outlook.com (2603:10a6:208:176::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 06:22:05 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 06:22:05 +0000
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
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v7 09/16] of: mdio: Refactor of_mdiobus_register_phy()
Date:   Thu, 11 Mar 2021 11:50:04 +0530
Message-Id: <20210311062011.8054-10-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HKAPR03CA0026.apcprd03.prod.outlook.com (2603:1096:203:c9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Thu, 11 Mar 2021 06:21:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 631dbef7-000a-47c9-cf4f-08d8e455fd4f
X-MS-TrafficTypeDiagnostic: AM0PR04MB6611:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6611300BA61317F5F77156E7D2909@AM0PR04MB6611.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R5xX7DXyoBxPMBb7da6uwPP0yGXn56U/dhaCdLPfzIo4Nj7mooHkw9HCEezaSd2wlbnYEJjlSuxRMESgQR22RX82kwgsvYVxhNSL0ZNr4v2lJPbiC+XZYphRYJmLcZoZi8w3EXTXJ1AWvNy43PZ+XqWV1f34OOkwG5YJTQvcsXe6lH92sqSuZSQYzNmoooOXxTk+QCEg8SWoMysxMLgi66d3iuEKuSBAWrLkYp5sPiTkM2oTZ5tQGwDw+BkMqiSaPGtxDd2roSJCJ0NejWvnmuJRuC8gsqJv7AwuWGCkAMDe29Wr/03ExfyySnFSOzPURuSIAY+5U7Znv7LW1Msw9YD2X1+Snpf9e4lPnKLxi/tNTOqHAwbsLV+jOGJzUy90apwZn9IVpnB7PwU0e5sSzCoPh/dG9HeNwbt2MNWUXNLFB2q80d/pgfNKq5+SWNzjQDpZlZgLf4IptUdltmNmn7i5UaJfNGo+kJCS2Djuk6vP+3pHyTJ83GvBfimo6F4MIPRPIxxGVo0cu9Za7AIClkeL+9EkW3CrgqQmlqq4GbCPlSLqfDB0mAelXVZBQiFvjGaGbjupPylWlBHLiZttV+kp+2CHpdFapSvUq24v4jU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(2906002)(921005)(16526019)(26005)(186003)(83380400001)(6486002)(8936002)(6506007)(66556008)(66946007)(55236004)(66476007)(44832011)(478600001)(6512007)(2616005)(316002)(54906003)(5660300002)(956004)(1006002)(52116002)(8676002)(6666004)(110136005)(86362001)(4326008)(7416002)(1076003)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?90h7gksaSkjnNbXPlC3glYRLurun7+jE5oYfmdoWCeF9FyaHnLz4MG80OK/Z?=
 =?us-ascii?Q?KVkgtNxy0zxsLMjOyYuedQ2lNBFCX+jdwE1c94CbSzURfuhoYHV6cbfXigst?=
 =?us-ascii?Q?Wd3rFzXGgE6pJTj1G/zAEHovqCCDq7A7hAUeGYeF/ooBaHVm+vXF8CXoM7SG?=
 =?us-ascii?Q?oV34JPULYgYrOk2Q3WerLUq8kK/sBBBg1k6r3O6WmNVCzlAWuBnJv+uu5X+Q?=
 =?us-ascii?Q?ieavN2nRusnwkqHmQ9h5KPIk3u3jNV/KVFT+Wt6EKUgijcEV/qhtQE/4q6/7?=
 =?us-ascii?Q?jwhTGdbF+FjkFeorSYuot3/sCkaS4baHfF1BqA3bCwTu+oj3wlh42fmIq5wV?=
 =?us-ascii?Q?PqfrX2XVXx3Hqua7FIuCeaW+DOp29A5cB9OinatDXj+a0LVnqGkVx/PX7DIK?=
 =?us-ascii?Q?IEu8c7SbThpF2egE0wAaiT5ToVGxrsnCoiQWtvfSB1WQOeIPzr/0rsdvPoLG?=
 =?us-ascii?Q?rURMQL+H+7rjxaBg+1gKoC4WptQQAHTy9j1nOY4Lmw1roeeofsUVPf0C8iDQ?=
 =?us-ascii?Q?vhhaUW3LhWp/pcnr6cEEBRiXk8gAm0ny99lLqbxNJGz5W0bd04jnO8P5FCDs?=
 =?us-ascii?Q?D+FJKyLhzmo/rHWJ+cVbTRk3vG92CIeMjvKFwQPjYO9QmJi4YfdcUvlEfz5J?=
 =?us-ascii?Q?z5XAbt7EK0xqXSrqXzb2pUJFYKBVI9bX09E6zB0K8cx+Dp111Xys8ILQWfGw?=
 =?us-ascii?Q?vEaWqeDpbdtolJKqLgnr65vAOq7EwvGblRRolKwuEjSmdDGk6+6ECyH0bj3C?=
 =?us-ascii?Q?tUe67SKXGPxAqDjroBhkQxKbHIS24kS7rIh7NP92slc7ORkV6qupKkYkbze2?=
 =?us-ascii?Q?EvPSBHjjKM/5KlkPlJor5iExSh3sIKu9Y3tXZjvRZhXtKObVugtYnswJog2i?=
 =?us-ascii?Q?W2tBMxM9dy5o6KXeCL6jv1aPRv8jTS5TGYCEEvxRQpxv4l1VXOT7Tm7Ts3ws?=
 =?us-ascii?Q?JEBzy6uKGetv4we3U+CX0iwj8l2QwCKh/+ykO2fxJHbdVa6CMeUDsD0cJB8t?=
 =?us-ascii?Q?sT5ghywJofVqQLELcNZJTffCfJhtpxYzSH07sYRfnEgO2eDNbnsHkP/3aTFX?=
 =?us-ascii?Q?buPw7sobDThtkyUlaumFeIdTK/wjn5pLkYN8S/ZxzsBnDzadqWUG5GexI2hh?=
 =?us-ascii?Q?7ORiEISHGfPQvph8/OJ+6mSDoJOV3JyOT3q7dFHUR4ruNna1hdb1k6pCx1rC?=
 =?us-ascii?Q?nL/JP/5Pui57K2aaMKxP2PIoKwc4xGRprj8cqsGoyERKBXcRjL97RiF2k2q/?=
 =?us-ascii?Q?01jvQKkAyFcyG7OVnjIKrehUVLu9sm6nQ54x26U9WGZNg9UXO/Q0xp9QdcBJ?=
 =?us-ascii?Q?CarK0hjI49nFwT2jDmVrTwu+?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 631dbef7-000a-47c9-cf4f-08d8e455fd4f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 06:22:04.8433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SKxgqg42Vpj7esG0mb8cAlYLAKBGCxic5D9eZmMTFE8hzQ+tQSqYbfih6NAXMNwSA7nW5HB/XU8/1MkafUYEWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6611
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor of_mdiobus_register_phy() to use fwnode_mdiobus_register_phy().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v7:
- include fwnode_mdio.h

Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c | 39 ++------------------------------------
 1 file changed, 2 insertions(+), 37 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index db293e0b8249..eebd4d9e1656 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -12,6 +12,7 @@
 #include <linux/device.h>
 #include <linux/netdevice.h>
 #include <linux/err.h>
+#include <linux/fwnode_mdio.h>
 #include <linux/phy.h>
 #include <linux/phy_fixed.h>
 #include <linux/of.h>
@@ -98,43 +99,7 @@ EXPORT_SYMBOL(of_mdiobus_phy_device_register);
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
-		unregister_mii_timestamper(mii_ts);
-		return PTR_ERR(phy);
-	}
-
-	rc = of_mdiobus_phy_device_register(mdio, phy, child, addr);
-	if (rc) {
-		unregister_mii_timestamper(mii_ts);
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

