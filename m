Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E162DB1EF
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730393AbgLOQqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:46:22 -0500
Received: from mail-eopbgr20054.outbound.protection.outlook.com ([40.107.2.54]:56934
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725878AbgLOQqJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 11:46:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Epl/Z+2vAfICw2zoLgHXiTTSaduWRMJ47PGZZstm5WCmIhTF/Esdna1K/9Who5eiuqkPakrBZDmccPcTuo3YFyXeQPco7p7agQPma6GqjjYVXL1uT48juqJP5dPm9blzO/gzcCm1SNe8rflYW2gsmej0pPGDbbBAoLyM20WI74KkbfppeN9MOYUm0HK2ReiFYuzbaSJwVE/gwwqGuebxpTSq9QcXNq07rKkDTMT7sxrkk33jutVseAouCKb9EBkRhDx5Bv0Zt3GsoGJXqFnntfQ8vBGEdQLJHC6IBtNIEVsH+TUfBoP0u97MSCGsbFWzJzUVJSyR/oci7mARXrIA/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4AHKzV+1bGiW8uqR7tQ++4j7WdZj9FYiDJkFQfAZyo=;
 b=gp+pCV3onsIW9Q4AO0Fy8x81Yy8t8COBdbAi5DMhNlxE5ErfZ+ZLmRxYNK6Y2Vm9zfFcpe15nPtXdqM8IoIFSR2TmUDDGvigLc9EiJ5oiQ+Scm2cgSatorKtvsnYdPHP6ek23fGaGlr3nJzdY8FuCOx8CtUiJP37Y25wa31QiT+7m+9D1xWy2lcFTuGI3sCrYoI39/1wYqfuRngdOZXmnKDNhUOEmutlwXpCb6pIxgZ2Fc+foY9R77ZwtpJopSblG++b0xD+ZR+uu0c3cUVSreAkbJdf5uYEgM6ZR50XG66oDKc3wpcI0q5DyaHvOqKzNS/UMt9cpUmlajF3OBfL3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4AHKzV+1bGiW8uqR7tQ++4j7WdZj9FYiDJkFQfAZyo=;
 b=LYckWNdVfsdTpeWPySHI8tkWUCMW15EPQM41Q106bGsRr+9OCRAHYyZ6oOhKHeHntwfQyUiNpbilUQ7NUzNG+hZUR1hdzbH/jSl4dARDlVqvcPRh5lb3Ls26Z98mAmkTwjLCBbE1/JSs8zyMyI6+OpDDoxwF6M58QTslmLTUcTY=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6963.eurprd04.prod.outlook.com (2603:10a6:208:18b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Tue, 15 Dec
 2020 16:44:29 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Tue, 15 Dec 2020
 16:44:29 +0000
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
Cc:     linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v2 06/14] net: mdiobus: Introduce fwnode_mdiobus_register_phy()
Date:   Tue, 15 Dec 2020 22:13:07 +0530
Message-Id: <20201215164315.3666-7-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0152.apcprd06.prod.outlook.com
 (2603:1096:1:1f::30) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0152.apcprd06.prod.outlook.com (2603:1096:1:1f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 16:44:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5a8c0489-43fe-436c-b8e4-08d8a118b140
X-MS-TrafficTypeDiagnostic: AM0PR04MB6963:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6963C57D538EEC286F57B64ED2C60@AM0PR04MB6963.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u4dBRTpm7AbWUlWVooWouegBheOPmN9BgnvYjPx2acWAxF2WkFgcJmP2YNsOvoccuiPXJnU6B9JyX6RwAzOM39DTb5ZiWGvOz2IhK0nFAQ0ri7uCVLUJo1AvomvKsxlNsfYtHb7qh7g3F9QiBRDqXSmB5llDja3ucra97d/qy+M0ui7Ae6UkCB0CqEPxj6El6MF4vxzBNnKt1AOc53B2SFUgGeubRuN2Xa+kP/znu9RJmwI/owqNS9m3BGqb9r1dF21g8IPjVyWvHXJmEZ8R1MbSPFgjsEle82TWBbjgxYWYoq6+upGmS4iuYIR5yj8XCtrBtoWJQ9y/Cv68cP8lbxGJuSHwAvUk2rvzNgXrPqnQMcNX6ZopsVNDrsjOxqxkC5jaJgvf0KdKoKGvsFhZuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(8936002)(4326008)(6506007)(498600001)(66946007)(921005)(2616005)(956004)(86362001)(52116002)(16526019)(8676002)(2906002)(26005)(6512007)(44832011)(7416002)(186003)(5660300002)(55236004)(1006002)(1076003)(66476007)(110136005)(6486002)(66556008)(6666004)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rhwQ9jT9kWAn1ivonlt1f01UlYehhDE//ft+MiwHLCqiz2gCXgW1U3Z/0d5O?=
 =?us-ascii?Q?DeApJAMFTogfVH7EFm1qhPzFGYvW3NYNtpDpYR3iyXTu55FdgJLE3yHQFY5o?=
 =?us-ascii?Q?2tmf5o0jpp9+oeq0XZEHuC6F1d/K4e7A8Q4DiAg3WydCrG/cm4ZqLgWTHuhW?=
 =?us-ascii?Q?cJ6GsfdWG2VZxaZHELc2bMeIW/xp3HGjdAyUxbVP5Zq9Kgd3wTBbwwv1bIKK?=
 =?us-ascii?Q?LS3X3FZqf9FSYVgmS17i1shCiaYEH0V/E9LutLU0Fxx1L0UU5Ujohh69k6Oi?=
 =?us-ascii?Q?H5Kraf6da22nLRRiWMOFgVzaL9fIpPuqKkq8lbolDDEJd0bwj1cCZO9mGCg0?=
 =?us-ascii?Q?7yMRSKSH4tmAaORx7p7CPI3+ijmrnA+nVo4WLG74wpEYGCPOuJxDTPulvyCl?=
 =?us-ascii?Q?GiMYaofiaUcwdxRsKvMeLep+FKMG1vSUpm5MI6w2IEK6cwBqlN6bInuE+5xy?=
 =?us-ascii?Q?Z7CyGGL3y63i7PyxisH2fo3p8QKaCLngYKvDoT5X2HAz9DDjH07nCz8e86yM?=
 =?us-ascii?Q?A/xDDhiQpcuKRNGSeT1Wmy6aAOAK0R3DsA/TTMiZdQCvxdq5uHTqNxvjw9GR?=
 =?us-ascii?Q?zSsioHiPceolfUcH4fcZdT3+gUDQtsnYDml2n3xK7Lil5KodJK3crcJvBLuB?=
 =?us-ascii?Q?FnCfINrjjtpnFsCoWudrVgwy31D6gbfswmlOVIIXjHEjnQOK3ZK8KSxE/wMS?=
 =?us-ascii?Q?II0yT7TYXd0cWTWKDCACmAtnv6TGjc0b738/zz3MtwSBZmoJfxSqKaFhXHI2?=
 =?us-ascii?Q?ByYXWxJ6/6WgtsGH1ygQa0nQVzlPgFHgUFzUq4JJqw34tWyH7A/rroxR8fWl?=
 =?us-ascii?Q?BW7abKXRHNip10ZjIndSBYhYKyFo+SKjtnL5mXzRkoTDsfReawWekIzxoXgm?=
 =?us-ascii?Q?jXW9zYYV8vIVF3Fn9Q13fGPk3usKHB8ZiiqvtN7jEJa6fTyLN/3RzAdIPOBp?=
 =?us-ascii?Q?qoQKM2tLLCDyraSSrzYj/BmEzIlj+v57D4mEYoHi96FtZwbs9smWC9oKHmcn?=
 =?us-ascii?Q?JXAt?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 16:44:29.7351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a8c0489-43fe-436c-b8e4-08d8a118b140
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wtngo5gBbQqMBqWje2MWF0LU8imJbp2znKai1ISmTMCJwY3e0LJD7VgAcMsJaXj4YzkfGn506skb+Bb3hBZvhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce fwnode_mdiobus_register_phy() to register PHYs on the
mdiobus. From the compatible string, identify whether the PHY is
c45 and based on this create a PHY device instance which is
registered on the mdiobus.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v2: None

 drivers/net/phy/mdio_bus.c | 66 ++++++++++++++++++++++++++++++++++++++
 include/linux/mdio.h       |  2 ++
 2 files changed, 68 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 2b42e46066b4..3361a1a86e97 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -106,6 +106,72 @@ int mdiobus_unregister_device(struct mdio_device *mdiodev)
 }
 EXPORT_SYMBOL(mdiobus_unregister_device);
 
+int fwnode_mdiobus_register_phy(struct mii_bus *bus,
+				struct fwnode_handle *child, u32 addr)
+{
+	struct mii_timestamper *mii_ts;
+	struct phy_device *phy;
+	const char *cp;
+	bool is_c45;
+	u32 phy_id;
+	int rc;
+
+	if (is_of_node(child)) {
+		mii_ts = of_find_mii_timestamper(to_of_node(child));
+		if (IS_ERR(mii_ts))
+			return PTR_ERR(mii_ts);
+	}
+
+	rc = fwnode_property_read_string(child, "compatible", &cp);
+	is_c45 = !(rc || strcmp(cp, "ethernet-phy-ieee802.3-c45"));
+
+	if (is_c45 || fwnode_get_phy_id(child, &phy_id))
+		phy = get_phy_device(bus, addr, is_c45);
+	else
+		phy = phy_device_create(bus, addr, phy_id, 0, NULL);
+	if (IS_ERR(phy)) {
+		if (mii_ts && is_of_node(child))
+			unregister_mii_timestamper(mii_ts);
+		return PTR_ERR(phy);
+	}
+
+	if (is_acpi_node(child)) {
+		phy->irq = bus->irq[addr];
+
+		/* Associate the fwnode with the device structure so it
+		 * can be looked up later.
+		 */
+		phy->mdio.dev.fwnode = child;
+
+		/* All data is now stored in the phy struct, so register it */
+		rc = phy_device_register(phy);
+		if (rc) {
+			phy_device_free(phy);
+			fwnode_handle_put(phy->mdio.dev.fwnode);
+			return rc;
+		}
+
+		dev_dbg(&bus->dev, "registered phy at address %i\n", addr);
+	} else if (is_of_node(child)) {
+		rc = of_mdiobus_phy_device_register(bus, phy, to_of_node(child), addr);
+		if (rc) {
+			if (mii_ts)
+				unregister_mii_timestamper(mii_ts);
+			phy_device_free(phy);
+			return rc;
+		}
+
+		/* phy->mii_ts may already be defined by the PHY driver. A
+		 * mii_timestamper probed via the device tree will still have
+		 * precedence.
+		 */
+		if (mii_ts)
+			phy->mii_ts = mii_ts;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
+
 struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
 {
 	struct mdio_device *mdiodev = bus->mdio_map[addr];
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index dbd69b3d170b..f138ec333725 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -368,6 +368,8 @@ int mdiobus_register_device(struct mdio_device *mdiodev);
 int mdiobus_unregister_device(struct mdio_device *mdiodev);
 bool mdiobus_is_registered_device(struct mii_bus *bus, int addr);
 struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr);
+int fwnode_mdiobus_register_phy(struct mii_bus *bus,
+				      struct fwnode_handle *child, u32 addr);
 
 /**
  * mdio_module_driver() - Helper macro for registering mdio drivers
-- 
2.17.1

