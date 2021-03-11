Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E435336C12
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhCKGVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:21:44 -0500
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:35293
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230050AbhCKGVb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 01:21:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxwmEyvZn4xfoIzKr86eTES8d06eeKFExu1+B2+iSVFxTOhJP7AxbKrEnuZSEk9bFW7mssdvp8LG3moRv9rh+//clbPJrzSy4dAzzz/xz7YlSQWwitUunnRB+kJ9eoicK7AUiIdKW2rYGTTn396mEM4A/z+VJRGnwqvNGBqqsGyc4idkEWrApuik/IlJt7r1z7TH+o0P/4n5VEWHH8radWlzUXAv6d9KgQSjIA8L4ZWzY7DsBwiazEltR27rYh7DtMA0/5M2wCKqEJjY8AcrN68z1TzfqmMZGQK8m6LIoKqa3/ZBEY8S1MeWZAAfmST70JLwAIFhU44RuFYU1pCEug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=un4R9JdbKhqc6uwju51tCK1kzB2hi4fAlPAvZdr+0KU=;
 b=XuF55AHuulYJDuYRcaBS2LqE9nDQUuXApbd7ZqL+nHIhRnI2GHevDbVlFjyttwV3nYZhyYhrnaQqRw6wC1/5RdPX7Vnvo08bv+/phTfwt31Bfz1CAXCggS76Hi3bGyPFDamiSEakdde3KKF79YnoH/L5GKuUZPGE80bjS8KGZBSCWvjmGKIMbNnBICrbIRQRVSOlgUTsWcA1gEOeyG94FRM/ErGszeHJYKh1MDhK77X5VI4ucE2kRe4rs4OA266RtVOd2cJY7/q5N3K//D6qnMn0r1VJYucewLz1R79p21UnTtmcY2vhBdYZE0dKlsw5kIDZqkTq/HAPCjheeHllyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=un4R9JdbKhqc6uwju51tCK1kzB2hi4fAlPAvZdr+0KU=;
 b=IxWVW6y0sxWXuCumzjb9kH3LVBtcgki+MEpMHjyUXeapclCDmHP5zXuyJtLWp8QImnh+OyAezLaInB5TcfKgu0lW/jXIcqDIE9S/EZiRtIaWW5p2+3SvBmr6phos6ocvAY43T4kqRqtIkJTT2Do0yr652kLOJQ8/oU+v+QP4a10=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3442.eurprd04.prod.outlook.com (2603:10a6:208:21::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.27; Thu, 11 Mar
 2021 06:21:28 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 06:21:28 +0000
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
Subject: [net-next PATCH v7 05/16] net: phy: Introduce fwnode_get_phy_id()
Date:   Thu, 11 Mar 2021 11:50:00 +0530
Message-Id: <20210311062011.8054-6-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HKAPR03CA0026.apcprd03.prod.outlook.com (2603:1096:203:c9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Thu, 11 Mar 2021 06:21:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a4502523-694c-4fc9-0197-08d8e455e74d
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3442:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3442932E6858EDD39B713BF7D2909@AM0PR0402MB3442.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NJp02gUTeriC1VC8D6YOhP1i28rNkheiM2aq+PYLdAakJbUdCCEccnyv9SpiCWapgelCbkXGwhAKxLPoLeew5MVcHuET8PSA/CtGTMaOtkNSWTZefJEKbd7ADqXDiBY4Y+RsaGwrZ9iiWxO3bi1CZmlLXbba5ZHickJSseaokh+yuHzrEXmwlynVlFwfrxvHoCV2UY0huDoZCR1XzQvWyQWSgWfTxIbNOh5BQ7+QZMnwfxbQxnTabhBfeo6wevv5txUI4Kv19VpmPgZ2w5lTpslZadayeJlEC0/AP0ahDXzLKzeU6c4IfwfXT6H4b8KaTkLsu3N8tVNLR770KzmlTXygLlfUVp0ITijTOg3kr7sSgksra1SuFOkVyYKHbfBaIkOnfIt8LxfxA2wJNQCKw65cNB3DXgmZVFh0ajIchG537lwrVxmas+Y8zj7VHPbwdi3yoZs0/ygMQup6SS3MCMF6rLkc8c5SV0qgrBrhqs55TsFrNwQgX6wwUAxyUiknmVDcE/obrTjmlUWm0y2049r4trcGf88M7HJvsudUFRKYE14kqHQSbYVHW/JCOCSuvKRAYPG7j9b+Yq1EbTo75wRkGgPhtFbR9Egp3ziJ52Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(6512007)(2906002)(7416002)(8676002)(6486002)(2616005)(186003)(6506007)(86362001)(26005)(921005)(110136005)(16526019)(956004)(55236004)(316002)(66556008)(44832011)(66476007)(8936002)(1006002)(4326008)(1076003)(6666004)(66946007)(478600001)(52116002)(54906003)(5660300002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nzvWrD8+qVI99h7iEomCvmYK/qXqMOamALkKu6beXYxvkKpCDhaDtXOy5p1q?=
 =?us-ascii?Q?iJynGKPKQ5ZdOuTP68TI8gtDB6YlGHg8NvGwQv3BpZfDjYIB9BOf0eN6rQ4C?=
 =?us-ascii?Q?+97kqkpWM60drC1VhQWcU+026vibImSvRl7o0JUt3c1yGR0y5rmfXjzkYp1F?=
 =?us-ascii?Q?orN2MTYkGN9xKO/UuuYNRmTaCDvVsy/jz8sh80GrpRI31JMabCl/jdGzvWWv?=
 =?us-ascii?Q?I7S3Ma+EK5H+BFCsMvfoju5HHg781ueKRIl6QkfLkzR0i/gMkvRPtANQ40JJ?=
 =?us-ascii?Q?CqFF/Dnm+NTg7gcODdGY3UdiYLBQLwImKiVg1vA8pJGJfZD5AKAii9sxwkB6?=
 =?us-ascii?Q?eDnSz9/jEAIICVfPwzCrUpWl+fLc/PV3oo77O/51IvUdp9W7x1nTzHa2Y7e3?=
 =?us-ascii?Q?SYRspDesYdE5jsFRsL78E9O5NKy6BLVte2PnTagAr2zYdIs6pagNKZZPwG3K?=
 =?us-ascii?Q?XeLFGQl+T9J+HOWY9LDigu0AchKBfONil3yXIPxwoToU7SfkDjagXXy8NhAb?=
 =?us-ascii?Q?KY3f+blYgzbRYZSLXgE7KcihQbiJpCydPnL3gPqg83zbxoncbZUWmznj7JWU?=
 =?us-ascii?Q?ivxzmtUHT9hBzPbb2z+QhwmoiWDXw7ouz0jK6IDLIC5aWOloIEf1OHN6EbBX?=
 =?us-ascii?Q?4jwtDP69hPT85uX+bOTLXW7jUK6Bk2dGK+zDjOdXV+0A35sDTpn5CKTD57i4?=
 =?us-ascii?Q?ITDFetZpU2HegCqa5fida9URkk7w0GisH87d+zh2Tov/GGxeCnyehsw3O2Hp?=
 =?us-ascii?Q?7fHuW1JHSAHmdIPoj8T7BbbPkAUFAfs8Z9/sktJivMI2cAYORwT33Z21aylu?=
 =?us-ascii?Q?VX9EAbvQW7V2SCx1xWVhTjtqJsTyVRbITMwvlsXy9hGA0G33vsIEym5r4VUK?=
 =?us-ascii?Q?2216HlRn9QLk66StmdtnqsyOya2ljzsDxYkIzC6Dlo6lSh6bilfEPQDOUX4V?=
 =?us-ascii?Q?LK4WB/zIGF38cwOCeE6A4TBnIPi9+/R1/vR2CZEsh/jTrQ82j33bW0weqori?=
 =?us-ascii?Q?fKlRWcq0BAopZwgbQuKEl1TSc6paZF9NbXvabRskjYBdntlI1LDrAGiCkDgT?=
 =?us-ascii?Q?3hJHE4RaZZ2zsA/ca22jJjSN7l6cXxgbf7qYKedbtpKNN9ZzEC3ZhzpXexQN?=
 =?us-ascii?Q?Ao3JcIvAvMBQPwoyCh0jidnpiLqFk0ljlaPQzUb8aHJJoeecqgPTaVuExawP?=
 =?us-ascii?Q?4vIeJxMXbyVpQ/aNBtQgnbR9C+ZAv1tJINcH0KALz+0syTwifbTp93Oq5WRH?=
 =?us-ascii?Q?OBnKjsjef1ucQgtv2eDEMfN+T2LnIt7KHLmgbTog7zY2QoBiw5/Opd4k20kZ?=
 =?us-ascii?Q?JpttXkod4vALs7Kcwml8zmGs?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4502523-694c-4fc9-0197-08d8e455e74d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 06:21:28.0519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y+rX6NmPlXrrqKfY8A+yg9EyX6QjKU3ySYfafqJyT5KBjhY4voMX4dIvhPXFRJj5DWzQdctpKOYx/TInnB3K8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3442
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract phy_id from compatible string. This will be used by
fwnode_mdiobus_register_phy() to create phy device using the
phy_id.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3:
- Use traditional comparison pattern
- Use GENMASK

Changes in v2: None

 drivers/net/phy/phy_device.c | 21 +++++++++++++++++++++
 include/linux/phy.h          |  5 +++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index aec8dadf5d8b..f875efe7b4d1 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -817,6 +817,27 @@ static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
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
+	if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) != 2)
+		return -EINVAL;
+
+	*phy_id = ((upper & GENMASK(15, 0)) << 16) | (lower & GENMASK(15, 0));
+	return 0;
+}
+EXPORT_SYMBOL(fwnode_get_phy_id);
+
 /**
  * get_phy_device - reads the specified PHY device and returns its @phy_device
  *		    struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 720a2a8cf355..4b004a65762e 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1366,6 +1366,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
+int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id);
 struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
 struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
 struct phy_device *device_phy_find_device(struct device *dev);
@@ -1374,6 +1375,10 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
 #else
+static inline int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
+{
+	return 0;
+}
 static inline
 struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
 {
-- 
2.17.1

