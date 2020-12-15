Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A591D2DB20C
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbgLOQ55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:57:57 -0500
Received: from mail-eopbgr20071.outbound.protection.outlook.com ([40.107.2.71]:62181
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730262AbgLOQqP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 11:46:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0gMkmaBZUFi5d4ZKRpmaDMaz2Xy/5YDsWpA7Z3Fxy2m+CCh698My/b5vvK06LB0HKU2b/T1Bi/9RjIRGn2ai7kZNMWKPcL1Ezz8PWGAm1WgE/zCK8MtJ7S3uExH0cFgEeptM8T/y6xjt97CTd4hhGIcqSzS0n6G1ik9oxgGxSMl4D7R1cbj2N8EWNpHJWYWR4D8xZBbadk2uEtA1ZCrtFJGrUscVBTnwBXnUnAX92lp/CYrumO9Q9KWrJEklj55s75xiiJQQk7nExtbyglo0UpgrBZmPYQHvHlr5HFwBS75XMXesDh3dPim9IywBZnMZl32MaP2CZJiPt61KSG4vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aexVt/cpYazIPkDXQqEordDVbjaFJ0Sm/ZxGwEUD2fU=;
 b=KZwRk+uOs5npysyEn9VgOa7WiTyZC3DXocG3oEsII0W3OxUfLEa3G6GM/tNSsUIo4urUVRy/dftRdNmrwtmpVaG230/HHdm/t/Ty4OvRxP7ZVNpmWdBDfAqyfgkDTqLDfZkts0numWu9cO8BSVdyEiN1+2mF4dC45xZkJl+pqi7udjT2Dm4Kfb6Arpk9ZmRoQ9a6DqmhxTlE7dNGJQypNyu10vmaFf6vxqLJ7wD6SzqoxSLGouXSdPbPpymYzFFEKrUbjnJKhaswwSKHR8LpIlLqDSaguxocEtTVttCWpFKS9XiHUsRcRbjS5gjYdvQ8NbcCcz0rgxbhgS3zja3weA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aexVt/cpYazIPkDXQqEordDVbjaFJ0Sm/ZxGwEUD2fU=;
 b=GQIZFb26dqnxLr8qeUBNtJt6wue7WrtDHFVhxYNZbKa6oVVqNCNYBuohhEfj+bCeljd3HoUAaK5V8gzUAVB30IHINobvvE1qVZedZNl4HxRhsjmIOr3sub/pVZqyap2hXSGG0LTRjsEkCErcoXS/485Dv+rRXxuaONga22Tk9rQ=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6963.eurprd04.prod.outlook.com (2603:10a6:208:18b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Tue, 15 Dec
 2020 16:44:36 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Tue, 15 Dec 2020
 16:44:36 +0000
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
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [net-next PATCH v2 07/14] of: mdio: Refactor of_mdiobus_register_phy()
Date:   Tue, 15 Dec 2020 22:13:08 +0530
Message-Id: <20201215164315.3666-8-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0152.apcprd06.prod.outlook.com (2603:1096:1:1f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 16:44:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9fbe0371-ddc2-492e-ba0b-08d8a118b571
X-MS-TrafficTypeDiagnostic: AM0PR04MB6963:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB69633A170A91E9580A9CD248D2C60@AM0PR04MB6963.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZzHF/h6f9Fr7dlG2KDVnhWcxko8bDP9zEW+d+djh+eWHrNaOgQpgQS5en+/DUCyx1r+M9FsqE4KyGr/rdiR2yYZ/Ch/dc34o0s6HTqGvZ4M8101dkNYNHZSCpdYYnrNSU+z1Qpi7s90Wty6yH/IOJiFnvuD5B0a1Q+4JvsqIhpy0VCTd4IUlrDPubOPCBbJ/DgElMliFeFvAypBmGiO2IeQCD9jy+NKvrqOh3vLqphMNDwm/2aHpsx1FhgpfoFQikCq/DAxE2J40XDxPNG16h5JAC1373xjtdbkjfOZfjTSTdMeskTEeMTRD5pqr8Mh6RvcevLVQqq4MYGFN9D8rGs8zyDiINaT/VpXcm0ChJiD6Qxj8Ae+PzpP4ucNMQzHgEZ90NCQ7gn1NEn+bLVqXvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(8936002)(4326008)(6506007)(498600001)(83380400001)(66946007)(921005)(2616005)(956004)(86362001)(52116002)(16526019)(8676002)(2906002)(26005)(6512007)(44832011)(7416002)(186003)(5660300002)(55236004)(1006002)(1076003)(66476007)(110136005)(6486002)(66556008)(6666004)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pYsqc21oyGx5FX32P7f02PqHdtW39WGcV9BmQAr/36d+tkZePTOBcXBbZDVP?=
 =?us-ascii?Q?ZbUvsySUX+cuS+d73WdNuuSU6U3BzB+CNB4M7bC7ab6MKhF5rYl0wVnbek3W?=
 =?us-ascii?Q?ueFlSagmvr0J21jHblLAEBxpP2+QONFLLpUTnn6daHTMAhrWTmfi1nD+MVWv?=
 =?us-ascii?Q?z5MbbnVz2FDDEMgC/WH0sYGrJSFpjp/iCGVEonIjp/6CbElGa2gI5vq6P+tk?=
 =?us-ascii?Q?dajhSoaAJZa11iFJBx2GKK3mR0BlBKU44QAkXcXUaiI1xtqDtU7pxbYRbGxr?=
 =?us-ascii?Q?WcBrFz9+q9WWB0oxB+It/X4xPdCyHTEzZlVva1RfdhhsKsWnpUVKiDcWYA9v?=
 =?us-ascii?Q?loKmJIzpNNLR7Q3giNWKOEYet2l54LSmI13aS4ZPd+DMJzAinNTPnO75MX0o?=
 =?us-ascii?Q?eKkl+yNYiqBbLYsF32/WiRRZ3IMkRTG6q65KFzCPocCBGLMMQxa9Zrkp6jB2?=
 =?us-ascii?Q?7o6wa58VVlybTtziFLner07+CWgBws09WmmvLt6/GrRRtPH8wm1Grch0cATG?=
 =?us-ascii?Q?cf1oYKQB8U08m6H68OoT/3+/0O94MbgWP65etEpbmMjtEblIkCtlMV/yCy7S?=
 =?us-ascii?Q?m0iFNe6p6tyNcjoc9ZtGs2sSqxEkFjhVCP1KpUBb3DvR4g1jYiDW4/8g+v2C?=
 =?us-ascii?Q?zMqCULZv77G1DwFOt1UVy4UZ3Pd8H/0rM2XEVbTVP3ebsPzIbCcYlFHZeY7O?=
 =?us-ascii?Q?uZUNiY2Om4TOMjqPTkjFX5pbItGuCKgG/DZijVDwMkm/h8IerCT6Lz+UjjEO?=
 =?us-ascii?Q?smqn/Ro4LDbqTDCgTD/fX6L+7fzpl3Ai5wJtcIst7iqyTdecXPdaj4Oaxi+6?=
 =?us-ascii?Q?VDuM70xSz6/Ax8rzu+zqr7xFHxe1EHJVFJfh6Tq+jDwmqo4+DpUfhFdkP71X?=
 =?us-ascii?Q?oD4wueAaJJqh4Lb7NxK+Se/tJH/EqwIVYPrDDfDuVHMyNrVO8P5KfD2P6mwT?=
 =?us-ascii?Q?RNMIszYQafPuGGP8McunmUnaVjSNvqIykdsWmg/p5ar3PJ325SeKB7XNpJnC?=
 =?us-ascii?Q?D9Qa?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 16:44:36.6982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fbe0371-ddc2-492e-ba0b-08d8a118b571
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 147WMYDlvXP1ojhwdTpomqlED4NYNOsZ2qEwSiPFbowWX+sxTT9vzyJVGpp+Jn50peN0hdU8Mey+ziSdnChSWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor of_mdiobus_register_phy() to use fwnode_mdiobus_register_phy().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v2: None

 drivers/net/mdio/of_mdio.c | 43 +++-----------------------------------
 include/linux/of_mdio.h    |  6 +++++-
 2 files changed, 8 insertions(+), 41 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 31e6435dcc9f..fa914d285271 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -32,7 +32,7 @@ static int of_get_phy_id(struct device_node *device, u32 *phy_id)
 	return fwnode_get_phy_id(of_fwnode_handle(device), phy_id);
 }
 
-static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
+struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
 {
 	struct of_phandle_args arg;
 	int err;
@@ -49,6 +49,7 @@ static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
 
 	return register_mii_timestamper(arg.np, arg.args[0]);
 }
+EXPORT_SYMBOL(of_find_mii_timestamper);
 
 int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
 			      struct device_node *child, u32 addr)
@@ -97,45 +98,7 @@ EXPORT_SYMBOL(of_mdiobus_phy_device_register);
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
diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index cfe8c607a628..3b66016f18aa 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -34,6 +34,7 @@ struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np);
 int of_phy_register_fixed_link(struct device_node *np);
 void of_phy_deregister_fixed_link(struct device_node *np);
 bool of_phy_is_fixed_link(struct device_node *np);
+struct mii_timestamper *of_find_mii_timestamper(struct device_node *np);
 int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
 				   struct device_node *child, u32 addr);
 
@@ -128,7 +129,10 @@ static inline bool of_phy_is_fixed_link(struct device_node *np)
 {
 	return false;
 }
-
+static inline struct mii_timestamper *of_find_mii_timestamper(struct device_node *np)
+{
+	return NULL;
+}
 static inline int of_mdiobus_phy_device_register(struct mii_bus *mdio,
 					    struct phy_device *phy,
 					    struct device_node *child, u32 addr)
-- 
2.17.1

