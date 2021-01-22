Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D6A3007DA
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbhAVPxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:53:24 -0500
Received: from mail-eopbgr20074.outbound.protection.outlook.com ([40.107.2.74]:61825
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729239AbhAVPsp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 10:48:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=huw7ZQKxFg2LSfvTD7BFhXP1LEL4W5t5C1oF+li6ySqTpXH2fXA+MpYXzPZU5qkUta/9hptUZ8qkD8Lxx1dc4olwMDMWhXy3+AYU+RaTFeTpV6BJca1EpBdvBLcHQUJtQRZdLlvPMxTGnQH8ZBjvgia2fCTCrNBBtYKWU67mgXBUo7Fuqj3pxvUt/imGO+4Ib+fUiaaq6Gqzlr6iaL5N0T1JsOJh7x64O5oemFcXB0RAbpQE+CxmUz7fxhQ8bcsdwQhkf6kvdJDRZcrCQEteE7JjxjoCAhfdXLoTrgmloyk93Eoc16pVek6apRgNmuGYNb1U75BsGabteB/VQ0v1WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XIZPm8Wbzo4S6GjGjJBsBmsy6E/bcbfutSud+kaCcRI=;
 b=evMFKyYqrFkehgHH8kxCGYkLEq+zfR0ur7FI7+9L/ejN6ZpPXpLLTsy7uqn7Oq6md9wy01qNSPxYlgpbYowQPrQI58shsmnDVjzn7N1yP17leD4hXUwE5rYy69iFGnIOLRscgpNlhVHPZ+AC0Fm4Zj/FRoDUOiTAp0odirS2NiJzBja2Z/L2ZwkJ3e81mMfV8YGcUL78AkkD2dCaEuv98ARL61L6TMZmdwpreTAOVeGdIVSTEqDjEbaicMyKYIpIrDPohjAdNZszw52t1H6gQWHUI1EUiFbPF7Dak2kl83Y8kxtQWJDm8PbMZNvEpgXQzE2a4WZ1WQ0C+K76TNZzeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XIZPm8Wbzo4S6GjGjJBsBmsy6E/bcbfutSud+kaCcRI=;
 b=Ch/ThyxkXl4Q/sFJwV8OcAmgAwQgE6GrO2KsP5GmastP76XaITdMV0ii5HbUNqxRQHuo+WtD8RHzqWGaavWGk0NsLIsx9HY7PYinGePfbkIlnObcV11624IwRFVQbRaBj3Ubm4pDvOod++AkDn4SJQc0Q702JtKCBCKo+NBEdU4=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3443.eurprd04.prod.outlook.com (2603:10a6:208:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 15:45:28 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%5]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 15:45:28 +0000
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
Cc:     linux.cj@gmail.com, Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v4 14/15] net: phylink: Refactor phylink_of_phy_connect()
Date:   Fri, 22 Jan 2021 21:12:59 +0530
Message-Id: <20210122154300.7628-15-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0117.apcprd06.prod.outlook.com
 (2603:1096:1:1d::19) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0117.apcprd06.prod.outlook.com (2603:1096:1:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 15:45:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 52418a10-41d8-4849-41e4-08d8beecbd8f
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3443:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB344387C38CCB5F5F0208C9C7D2A00@AM0PR0402MB3443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XZRA5Pmk7p3GzY3hFndeMQXC4W+Jh4piEOlzU4eYvI9fCbvu0DzaawWd8hBJXNu5WSEdSngxaSJQ/1qPC8BqVwPpwq7XtnlIvoeX2ZmCYiQ5cN2LqKyVe7YENBXEWpqAEnVhffX2IXTGco4p7M2waygj4pNlCUukBbn+7ty8ZgE1/+fkxkNDZvB1v+RktkwbhbRxUQ3DnkgD0w/sh+yuZ9DDpjSBufS8k+tKBqGVzbk2qwbU8lF6ZL1sebJkf7i3B3uA0Iw5ZfTnRLgAE4vR0P1GOs5P9y4zp+aPdcr+U8salI2q8+aZjvc6y9yhr2P+fU138HmBl2cl/S+nZyu0Znl87nzpzO6HlxNU4DOZyTDJFaR1y5d3FjHnWYUXeShU7XhB6r4kJuKxo0SVjhemfxsaluT2Dfq6WsUhRGHuTWYrGjVepbXoq+wIuw4I2dOKTcuGw06UShgUR6UfHHSF5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(2906002)(6506007)(921005)(6512007)(6666004)(186003)(5660300002)(1006002)(16526019)(52116002)(54906003)(956004)(55236004)(8676002)(66556008)(8936002)(83380400001)(66476007)(2616005)(66946007)(1076003)(478600001)(26005)(110136005)(86362001)(316002)(7416002)(4326008)(6486002)(44832011)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?AEKqyFQqFCaPC+LYH3wLekyKNAK9bgmpotbwpHKuJTr6CHsVAKcIHiQLdAkt?=
 =?us-ascii?Q?4X139E8SlxdHGW57AXzyn+We2aJ3HgtB72unRUEtcOEiH3f4e9tuNxs4Infk?=
 =?us-ascii?Q?FKnPbLymaKGvA/pOIPKJCP+DPeNLh+2dNUeJlWrpIMhuFcFPj4sZ9Nq9YQli?=
 =?us-ascii?Q?fZfAK8QSqUyYoh3Nv1KMfqdoKWa4NQ2ra3WZsc2aEdQMMcqVcL5pNJ9VThgC?=
 =?us-ascii?Q?ez3cnFmABsmGXKiOQsrmsCQfgMsNvdRPvdth9Jh7/7ktBJLc3Vzp20TDYX/I?=
 =?us-ascii?Q?qQBKEwP9zLedwuuKdk8JOGVrHIIJ26N5bxor4evLBKSGZw0MIhEXkCr55ZFW?=
 =?us-ascii?Q?uZlQYHUX82DrT5/E91lQ/J4ayTgBQVce76JgNXv8r+hoTFAVCC0xqBjBCFaR?=
 =?us-ascii?Q?cdVPiCTz1d2lEWlZfnqmwVRfgI6DgMq3qjaJVKFvAs4wrdmwmRNHaMRbYqyG?=
 =?us-ascii?Q?pYf3h42dRfX4sS2HpoBGSjvznrZ+O+Amjhvgj2P2ciPr3LDNX4SO4SURVvZO?=
 =?us-ascii?Q?ivg5VsOj4uWAGjgA062S3/9OUKb7KNx04rjtfIdprfmTFcGiwzHnvTdj40A7?=
 =?us-ascii?Q?wEHOrP5qx30wxYzBIki2kME3wG6XvmVwfx8cDpED+RkrVn5Dr0hdlLlx6xWC?=
 =?us-ascii?Q?0OTIC4c0YpmMnFIb1ocAe/f7ldW4s5j9Dnnt54UpkUSptf4Dc1jKYotMJgPn?=
 =?us-ascii?Q?9graUJ7S5lYJtaHaZiebndBDo2eUMFiCrW+1WZ0Cek5YQgkYWCOVWagWAS/c?=
 =?us-ascii?Q?uI9Pdr9B/Z7pcQe03HZg3N81xUErskqRvln1nW3gEknCBH5esL/DThBz4BJ9?=
 =?us-ascii?Q?6AxYPo2M9gsDIRKnH0Mv3ntdybtvwYQysEMi29m0UrNNHeBKJiblCC9C87S9?=
 =?us-ascii?Q?0OSl3x+YOal07+RmF0KVGA7PEwTZMwhJIPRBCDh0IZgY1KkJSfbRyjCX3Bgp?=
 =?us-ascii?Q?UqG4xdL4AnmYexVmAgpE0LzMDV03KCO4KF0xI5EjsMyFOwKFm+U8ZfTkDWrE?=
 =?us-ascii?Q?h48qCsWBub/VPmYw3xogvmoxruuJkOuEt4iwjLw07EinoWc4ACEvrWhgok4A?=
 =?us-ascii?Q?MgvTmVdo?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52418a10-41d8-4849-41e4-08d8beecbd8f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 15:45:27.8774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kCFAIV73rlT+G8sLsPpbQCXWiTu2HMobqYxmhboTkCBK6OgNpnXREoZX27rwk28KPicaG66yCWe9FIVgISIqIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3443
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor phylink_of_phy_connect() to use phylink_fwnode_phy_connect().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/phy/phylink.c | 39 +--------------------------------------
 1 file changed, 1 insertion(+), 38 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 5466e1e6272a..3d0dc53fd4f3 100644
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

