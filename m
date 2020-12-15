Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE982DB1D6
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730338AbgLOQrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:47:09 -0500
Received: from mail-eopbgr20054.outbound.protection.outlook.com ([40.107.2.54]:56934
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731008AbgLOQq5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 11:46:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPLD+y3g6ZN3IaoXtsSAw9nhiEOzucBOajEr/ebKrk9a7XvYzlC+EoCkgcc2JaOA9pOdmKSjAplXgvIKHbVOy/IDbD7ciO7U1PuqhQR7x7ROo8RDPEaHSNZ9uEuYO5RgcrXXyfGKTfnF+NRrjRK4IAgc5eZvOG/PijeMk/bcGNRvBIia2rpwSdR4sA5bNIBqDYN08th+3JO+3I0cYdyDC0Ls4Te8D+GVq1FG/yJwqIbB0PMj6IgBTdXyjMOCCHE/IvJqrRwSd94ovQydws1oFxdDJVIbu2nZcYSrngYLusqT+jzWlg87SOf634zfm5gdeyeI8FzIPmQKL5L4BF1Mmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yIDn0BW1D9Z1aLCgK/7Y9oGXzsNuSW4w10DVYjjodg=;
 b=U0ebrjGMFJjQChRSCI/eGwN8KnTpiygKS2ANxJQXJh2krkfuwA177i4yVCLCjRi0BuQAQwp8ImEYoAgnYA5pnKbw2F8B2h5zVU22KHyYcsrffYc3QjPrArXcGgcw7ntpi4oUEmeeEKPhHoPv3YXWCo3MELQHkpACAqJBWp4br0kd1FuWb/E+famwWY4KYTHX3dKcWFR5KONO+s/XEgAPAATyvC3xIYhpA/+djVRsdrRR1ft5lvMHHzGa9lE0MJQP2qRhtqJFf6Kw/Jpc16A5gIT+UoTIqmg/s58MbpL67GuJHVeXOJRmtCjwMWcZ1VxTIpj2HfuZ1hefcJNz5Qubww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yIDn0BW1D9Z1aLCgK/7Y9oGXzsNuSW4w10DVYjjodg=;
 b=CbPCS/roNhdX33vw6cTvsQHm6R/xyacxyiilcwbJHMUqhfGAtFxttpxR9QxV8a+yyUv04jqc46ctN85esZcJRGEdEsfaU9h0UIP8OJ3sAgPWaHtcngNj/2Lwzdesb8R7bJbd+E0RQeeh/0D1A2L69SuliweLvSiVVns8P18feJY=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6963.eurprd04.prod.outlook.com (2603:10a6:208:18b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Tue, 15 Dec
 2020 16:45:09 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Tue, 15 Dec 2020
 16:45:09 +0000
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
Subject: [net-next PATCH v2 12/14] net: phylink: Refactor phylink_of_phy_connect()
Date:   Tue, 15 Dec 2020 22:13:13 +0530
Message-Id: <20201215164315.3666-13-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0152.apcprd06.prod.outlook.com (2603:1096:1:1f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 16:45:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2c4a2bdf-c5e3-447f-9771-08d8a118c8bb
X-MS-TrafficTypeDiagnostic: AM0PR04MB6963:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB696317B3AC3DFC0E51EC1CDCD2C60@AM0PR04MB6963.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xUHl1ggdPvyJagLz15cW9dZSPE2WKQbXM+oD+N7QsS57yXWOmELi3OohfxMJPc8B/NJbAlR+f47aujZHLO97/54Ws9kP1Zho1/oJQp7F1lBXRyspHW/AKQrkzE0Kzv80B65vLh92FwploK6hwPdLDBlP80F/mb3MAgAHobmBa4zy4EB3QsWTWy3SsGgsXXbcIfpnTz3xuouWNo8j5JS6jUdoGTXqb+sgomMeZvAwD1B6Cnn7DgMdpxwED3NlNXvW8HTG1qm/xmGAKHWLQuWKudlbvQc/TyOL9A1rw2PXssRMEKtZd194YC6LdHdCPUNd5yIh+LXoLewujKeKxZEQzDrIH4N+Sd0OV+XknG8TDKlPvpfH8K/VBRQ/T60sspz9LDqFojU0Rd8B7ESHGT8HtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(8936002)(4326008)(6506007)(498600001)(83380400001)(66946007)(921005)(2616005)(956004)(86362001)(52116002)(16526019)(8676002)(2906002)(26005)(6512007)(44832011)(7416002)(186003)(5660300002)(55236004)(1006002)(1076003)(66476007)(110136005)(6486002)(66556008)(6666004)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1sd1QQFk46NJrXb3/pZn9svsbTj6BMl8VEDsfiDvuNJ4wXmq+3ojxNigsTPL?=
 =?us-ascii?Q?7ilUUCIEHlW7OscsLKk1aXPU2AXojjb4hsv7r6U97bYcbqQEaIzmyDPB1/PP?=
 =?us-ascii?Q?3CEud3ASsffRfCJNHSdyz9YxWpo8daWk7Tqrftnhsl77zrxlL+9dOhKuXdeU?=
 =?us-ascii?Q?pfAu0Y/PBCzzrjHqVAQeJgDokbfLJYC9Dc0sy0/BmwQHThVNlOufGTytWa6m?=
 =?us-ascii?Q?BwlI0nVhZGhAOcW7WRTsfH9eLEUI4ZxBTLPIlaE/3l/eB8vnWT4wHPAzrH0t?=
 =?us-ascii?Q?sBVjKd36iZfg0afPDcx1fmeHDQRKtorww3jgzIfKtg4o+AM4nADnTFxgA+tG?=
 =?us-ascii?Q?GWbHoP0bQkODLAlfM8KfDRMo0hzDTJaeNFAGao/ySY5gi3eOswaDOW1waeuj?=
 =?us-ascii?Q?9+tl0MMkVpX48C4hL87W9ZH3vol1Jju+IYNP4FvSXh+XH4eBDF2vRlIS00OB?=
 =?us-ascii?Q?X9Z9N5LF268z1GJH/bsduMImQRhCBg2t9ctF0YiRtuXsSbUpH7AzI9g0Wjux?=
 =?us-ascii?Q?xqNTE6WGVl94JuJqZSRB3CTqhNBTq9206pVcL/AR+5JM3TICsCJL6/YddJCC?=
 =?us-ascii?Q?ueW/4A2KvXHVHu+l9J9APhfwIMBfbbwi3RXwupkWphbYARuPcU/czQ6BkBe5?=
 =?us-ascii?Q?BdYvuTUyilgNqhe6Ko+mmaBIT8tLO3aab7ip5UuqwZ6OYvy6UsaeKDgViMOT?=
 =?us-ascii?Q?1fSXp0Z5kKccdndwzgxibPE4lnZgfgSN2bY2BWjiUGRsLP8ZgBEz+uSYePxO?=
 =?us-ascii?Q?+Y64U9BeSDfZoLbQzWdjOWTFc/kSBzYEE1CHmUBxcrN/D3vQ+hjblr29c5mC?=
 =?us-ascii?Q?qkSIwI2G162pwrflIhuoLhPo9nWMaXvcj6TGQZS5uMJOlc4YB3IE2krRpOsQ?=
 =?us-ascii?Q?zQ7wtABULQ5n/Rj+ke0at4aib+Sf9Ec746curP/H4F8Dh/JfCVhV5ZxNzK1j?=
 =?us-ascii?Q?WWmQReGe2nE9RjghhC07vRLsvfdCLVoHFSzMXjGBiht+Hk5GMddEjBbkEGJh?=
 =?us-ascii?Q?WTJE?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 16:45:09.1259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c4a2bdf-c5e3-447f-9771-08d8a118c8bb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z2rAORW8WHDQXnaZHQ+3UA2U1/9Ec1DT1/3VeTJZd81h+L7T7BFvR4dKOJhwzHRFGibtARbqMnO7QLkTZvj+aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor phylink_of_phy_connect() to use phylink_fwnode_phy_connect().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v2: None

 drivers/net/phy/phylink.c | 39 +--------------------------------------
 1 file changed, 1 insertion(+), 38 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 389dc3ec165e..26f014f0ad42 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1080,44 +1080,7 @@ EXPORT_SYMBOL_GPL(phylink_connect_phy);
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

