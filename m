Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B688A336C3D
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhCKGXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:23:18 -0500
Received: from mail-eopbgr20082.outbound.protection.outlook.com ([40.107.2.82]:36174
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231617AbhCKGXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 01:23:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i54lwoEgzMD+1NVQ+cJso1uOa7ewEG45bjBTh4Sh5WoUSWZJctzfcu7Dao+TbUhcEi80qcV7b/09YHl7809YLwVqkt46N1AWWOlljrz4Apdun9uOdoJvmZp+YTvhTVEFVI4JZZCOvpq4tv9F593Fi8qaNejEwVDIrIYEU+/WPLWcs4Nf7/WlvRw8NZ9nE/3pvJiLmCyj0wTQ0yJWaNjBtVf/9dCnbPVhMvQMmCyIOj68XouwFxElGtgP+Ouq+PvvKsaL7tY0fuctVFJ1on9s2//Z8Qsok7TXE39qrpgphzDVo143U0P4/ht7r23Wlig544wONKQFYBdZe/WprpuuOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7SN/BUqBAwlVBwCfUUBNaCGolKQ5r3lhz3ovvjZzX4=;
 b=jytBh1biAmfOYcuL16vTFtN+B6KnPyVUSmS7RTkb794Y1UjaSA1Xwe1shocGyvzG2QWMPjn/m2P9zQ5ZKb77DdGrdjx5CMpQLbkOELr+mxfXZeLSyJoebmIMuUZqFojow8FS8UhHYxQHAfngFawzpcTmE5PFb2fPYfNfZAwbaRwpdZLPn6Urq2X6FmKzu192zexsS0sPZbs9KRtGjNtJWyQ9YAcYF6igbOP5HZtsumWhHiUHX1NdRVTH3oi9HZeENzDA7N0+UmCVuqWiRXZKUrp4c26S/uNiecV6BUkxcGn8C+JHAMZXoGcAGKG9aMX5+8ilVrxo8ks1Ars3J+RBAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7SN/BUqBAwlVBwCfUUBNaCGolKQ5r3lhz3ovvjZzX4=;
 b=lpEii64k19K/Yx4KKHY3U9HPganetcobnJGDqQnQjlwRKpMfN5uGYquOo1Vv/TdVYiiD/iWucyHLK6oeJpZ6onuBo4mXdqHEwmD+h/mUj6tKt4UIoRBYl7FVD94lxk2wndFwx22gQeSoIPfqj+L+hefSWr9ErbmM7IPd+odf3fM=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6611.eurprd04.prod.outlook.com (2603:10a6:208:176::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 06:22:58 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 06:22:58 +0000
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
Subject: [net-next PATCH v7 15/16] net: phylink: Refactor phylink_of_phy_connect()
Date:   Thu, 11 Mar 2021 11:50:10 +0530
Message-Id: <20210311062011.8054-16-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HKAPR03CA0026.apcprd03.prod.outlook.com (2603:1096:203:c9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Thu, 11 Mar 2021 06:22:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0dbe97bd-b4de-4518-17b2-08d8e4561d11
X-MS-TrafficTypeDiagnostic: AM0PR04MB6611:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6611B19C3E969B7DE339D219D2909@AM0PR04MB6611.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bmqrx5P/bX8EvYENr7SB0hGx6pfRSwAxNmVXA1lbA6dfdDq2dIsA8TedGZ50mo2agj60sNSqrRbh/5rTK7ld4ZZRboVhY1YMBVFCuXC2jyTK7bWyHoDtfreAbTtEud6c/xt/U0Uyx471rcbs2k391Npy9A+FBmAY3kfo15Vqfb0KUg6J6zhPH5KcR3Ab1LVAwFYQ8FSVHxR2tOkaGKZCYsosklZloIHqVE/mmG7T5GKsEsUO3Llk7FKmRNID8snMfgm+iseHJXdl065dBmwy2geTDEzerFQD3obX2mFDj58xi+mY00ZECVRrW/JLOp4u3Kh7xktiJAMXZpuZCeQUBfm/nEerIj+dmJVbUsnkCkZQhzbl68vzMvQWOpydDnaqtypvFsH9VWToCYK8zFLm9i7bpSj08T9HZK8aq16gP1Mon7NQOW82Sxf28N51gKMjTvTknS6bPywdCLHFe0JWshhwmN6N4qFoUMHo++eKz/efrr8cc6aaGnBqinIn+KA9UepKLpJQLyN7mF5JzHAYF6x18Lxa0TuLzcsgXko87KgO8KeHiXKrJIjxf7wWRVj/WVahEfKHESuDMXLGVh//Dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(2906002)(921005)(16526019)(26005)(186003)(83380400001)(6486002)(8936002)(6506007)(66556008)(66946007)(55236004)(66476007)(44832011)(478600001)(6512007)(2616005)(316002)(54906003)(5660300002)(956004)(1006002)(52116002)(8676002)(6666004)(110136005)(86362001)(4326008)(7416002)(1076003)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?p47z3aLYbeTyC8gzslFz7KGpTaJ792nXyAXkPF1ljyMYxM3gR3Y95gUlROhR?=
 =?us-ascii?Q?tPaC8EDvek1ZLYO5JNr1SVfVBQJMERM0TEUvYxtenFLFkYzaIw2F3GOCF57T?=
 =?us-ascii?Q?81m+AMxdjg3WM5TfKSpxU3jOQcHxoNOhao1cyjsWELPVz79Pee7ubFr11e2L?=
 =?us-ascii?Q?K6fCldOpiAxK/Ik3jez6pdSFY656iSGPpvkEEt5hOIFrC2lM4h6d74/JLUid?=
 =?us-ascii?Q?D6PpfjwBFgosDHSlYQpuEOcrwM8unsK2DwWyn43p7UVWt9+p7z5S2/sH+hAo?=
 =?us-ascii?Q?NdnBYG2a3gMjvZwUBG8bZh9sMg1ojU8QgG+r2a2i8jy+/C6+KmwpHxLhRFlt?=
 =?us-ascii?Q?MqNFtaC2wutpJgpYBg2gg7Eus+1Lk7UjQ2SBUWFzR/w48D4sXI04GmF3B2pe?=
 =?us-ascii?Q?FkpACmS0EWBCc5sTABbA/DsGVGKiab97+NYyrhr/EKH3wxjLTHNojTMjYug6?=
 =?us-ascii?Q?1myevaGrWpbm9Q9WAbrQGJN2NjZMVGg9MAFUTHgxXPFAiOA02V62Ybr5B/KO?=
 =?us-ascii?Q?ts4NbUbMllizjBB1th2O2wWSqw3+wb0zp4kXYfP3W0xORPG5XNuWWsl1fI2C?=
 =?us-ascii?Q?4x3amGL3LTRoE+yIB2MRld6+PGRzgx4ajtm16/VfsyKFFpmLLh3FSJYciD/l?=
 =?us-ascii?Q?NK+x8U6vsP2DSbdX+8ox2hDYjbKvrjnJ+RFBKISqLQCFyLqvwKnuf+acAG4J?=
 =?us-ascii?Q?cM/uYRUkQxyLkyJPQ8/KrI6Sw50VPjmfPV7ldR6Y0uMMuSOgHMVDTMkkJRHv?=
 =?us-ascii?Q?8EdmlFbZKeyvPYXLQ35QZJa2qY2Y1AVTlrkRLdLsb1LFM0MagTjm4xFyEKTN?=
 =?us-ascii?Q?Ybw6Nd+T1gvkQd1RJDEYhtTeVVOOHvAFynKjTS8OMiT7uZD9cfMRArNzXmYD?=
 =?us-ascii?Q?WF+EQxtT3OhvnReq+2vkfZGPiNdLvP054ndlRW94dCN3QxE+DtAQwqb7AWqT?=
 =?us-ascii?Q?KG0aorgBtNJ5lZnflB3vTTo69XMG1Mhbpx6skwxunYGdjQWKiOi6ojT9FkHC?=
 =?us-ascii?Q?Y1KqeLop8Y5tIi3sE6XMcwGnOP6fUl5ehVgaNxi1lNSmW73sv1OVKp6+7AmR?=
 =?us-ascii?Q?6/oz+Z7K8NupekeQeWPppY+Ek68kKTlHEViEDTAk4iCUf63u/XqiKKuwQWP6?=
 =?us-ascii?Q?qhxZNYycDUHec9LJy4edlHEkFjpphj/HOTYvts7/naKRbPwrqTJAl+deMf7C?=
 =?us-ascii?Q?ydMe1DwanE9XY/5Z8SoNWU95/rn9aalHBPKyTnIeqQJGrKtNgSgURPV3+a6l?=
 =?us-ascii?Q?ca3hs4vBJ8YzWGA8QgSuI0YJF7EPpZcezOwMakA3vorhGteeEVJE7vIFO1z3?=
 =?us-ascii?Q?vljU1gtnYqk3PnaEE7Xp68IF?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dbe97bd-b4de-4518-17b2-08d8e4561d11
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 06:22:58.1273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: odbnNfMVhlbFGoXuNZqM24PONPzfORyTA7AHfxgVcoDTve8tWcldaWvjEcu9xpuhUuNL2gQ3Ljp9wCBhqvqxmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6611
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor phylink_of_phy_connect() to use phylink_fwnode_phy_connect().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/phy/phylink.c | 39 +--------------------------------------
 1 file changed, 1 insertion(+), 38 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 23753f92e0a6..ce7e918430c8 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1084,44 +1084,7 @@ EXPORT_SYMBOL_GPL(phylink_connect_phy);
 int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
 			   u32 flags)
 {
-	struct device_node *phy_node;
-	struct phy_device *phy_dev;
-	int ret;
-
-	/* Fixed links and 802.3z are handled without needing a PHY */
-	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
-	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
-	     phy_interface_mode_is_8023z(pl->link_interface)))
-		return 0;
-
-	phy_node = of_parse_phandle(dn, "phy-handle", 0);
-	if (!phy_node)
-		phy_node = of_parse_phandle(dn, "phy", 0);
-	if (!phy_node)
-		phy_node = of_parse_phandle(dn, "phy-device", 0);
-
-	if (!phy_node) {
-		if (pl->cfg_link_an_mode == MLO_AN_PHY)
-			return -ENODEV;
-		return 0;
-	}
-
-	phy_dev = of_phy_find_device(phy_node);
-	/* We're done with the phy_node handle */
-	of_node_put(phy_node);
-	if (!phy_dev)
-		return -ENODEV;
-
-	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
-				pl->link_interface);
-	if (ret)
-		return ret;
-
-	ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
-	if (ret)
-		phy_detach(phy_dev);
-
-	return ret;
+	return phylink_fwnode_phy_connect(pl, of_fwnode_handle(dn), flags);
 }
 EXPORT_SYMBOL_GPL(phylink_of_phy_connect);
 
-- 
2.17.1

