Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34873313770
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbhBHPZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:25:24 -0500
Received: from mail-db8eur05on2066.outbound.protection.outlook.com ([40.107.20.66]:10180
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233410AbhBHPSt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 10:18:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZ9OiMKVzkCuDsA6U21UDCp39Kyg6EOnqHI2ksWryDWd/0PI/kaQ+Zgeap/tyFEAnwqFwTdyVkOR2iEhZNz5ActGvk3y5CY9I5Rm2MaYVSVhElINmKSZwFsLiPzHcHPgt6gRxNhbzpU6cNy33jVxM8Z+qidaNYjAjHQQg4IeG53whVGjQDdKXGMtdlFSPWzUIlf6JoXF63Km3WmCF5Iys65lzCNDoKGdlMBjcvhFb7cc6jw71/goM5EyiP448PP70I1TEv3+R0fYlcSj6wyNch3Lphj+Qo5VezyOYrB26h+ffTtdGvM5LpqTTh35kFx/xmvFUdscdXm3DB5aBnrH8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZ96Hd2ZfTaA4os9q6G6MW/XA9I0btG2XfLGGuywU6o=;
 b=ZOuf+KkE2AqrUkzYCkdj4fkyvi7H7YB8H5CLwW0lBN6QGJpTyX95QUO/lZX1TMY3mMx0y76D2hdH9jrnQqs2Eb1AGCWsudNtPtAVH3WbU00T1ieklSPrDi2AsP9WaKgVT26bUT8yFnFXWYoUM2qSeber7yewZne59Q9vrj2GpxZj9c1ZPyCPoyTWzch2Ix6+GgK277LUr8rfgWl/IfLl89ZO/l4l9jHuyQqz67H94TmrJkS/l8C8HyyjgdKQiFuBAxxMimJijfLSWBE5wEBiXK+pEtAHhiTAi9JD6zYZSttJyriBH+TSKdJo4S9UxEluR+VWxs4ekazaoggAosovUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZ96Hd2ZfTaA4os9q6G6MW/XA9I0btG2XfLGGuywU6o=;
 b=EWglQ7v8TKdcr/JBtqV7mchf7/SX92bo3Ta8mmbIAwtygai4cXsdVlX8zuWdrL/iEBfzzZO0VWR/CBTZuDWGPVpD/cIQvrpR6MJ4eUubrFy8xccvLDNt8FS5cm6rFVdZyXYeRBVelG+g2EsP229NUD8M1Bnqu+N52GwI6xAfAjE=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6435.eurprd04.prod.outlook.com (2603:10a6:208:176::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Mon, 8 Feb
 2021 15:14:54 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 15:14:54 +0000
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
Subject: [net-next PATCH v5 14/15] net: phylink: Refactor phylink_of_phy_connect()
Date:   Mon,  8 Feb 2021 20:42:43 +0530
Message-Id: <20210208151244.16338-15-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0176.apcprd04.prod.outlook.com (2603:1096:4:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 15:14:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0237ae97-942f-47ca-9bd2-08d8cc4449de
X-MS-TrafficTypeDiagnostic: AM0PR04MB6435:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB643592BAD10BA10E456C3947D28F9@AM0PR04MB6435.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ADCgCacO/cv8tbHnydBHZF0r7/oKo+fj6rCzuRZVqix+w9bf/FOuVJKSv5Vtjy3CFcij5ABxNRJ3KhiOfCP4RlM6KNKz/nhEgtSMihy7K+Jzn+lx4Das7Fa1pDxjG1JcjbHkRryk/hPqmrHVbJFhJYZql3BKYwjBmNhhblZvEESxcIVwoKgNGdYX199fm0zjnuMq2kSDaAyH90FbiwLeBOdwgmUahGWZvlR2q6OxrxugYIvBYr1phZIEEII+fTLsbOA8VL8p0W0kFZl7hA+ykB2klgoiPWlTEs3P/W2eu82uO9AJPCqmzAX+Z+JFOuVi+ZApJAzIyXJ3l/6GdyfBjRfpvDl0LrspnShV96GKfx/RqPMKzrcbZk5uTobqtgM9fMlfaCc7HnySr5klnjlIc4xzIYvXtTjcVqEWi2soLWJW2XwoUhlfVVA4WI/dYtWVsb62AyMVY9G+KGXP/WPCmXt3tS+ygfIktI6aJkSoLsC0hJyjNpU3YqkXR5P4PkQVB635zfG4dyzh8ffGf0daSAUMuXGRtKcuq/Zp3fu5+4CqUNsNBUv3u+XnlBACoAtLD7eIxz4qsVkljjBLyaeLPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(44832011)(86362001)(83380400001)(6506007)(5660300002)(921005)(8676002)(66946007)(2616005)(66556008)(26005)(66476007)(1076003)(52116002)(316002)(110136005)(186003)(16526019)(8936002)(54906003)(7416002)(55236004)(2906002)(4326008)(478600001)(6512007)(1006002)(956004)(6486002)(6666004)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tcfNCyMFCMO2D5yHbWq8p5pvgDfA2CU/4gBWPFjNfLAAQ+oNQkHiRYkTgU+W?=
 =?us-ascii?Q?t05cNS7ncxkSYkr5qrKJEfs/YhqZobXapBDGHAzrVsSAlusulTKPpqDvot70?=
 =?us-ascii?Q?oRHmHhKOZT/9Xi10NQusdvABKsOK6rUjLiDBG5RYlQNvvg9XP4ozqqpYW94B?=
 =?us-ascii?Q?HjVIACtL3L+nJcUX7GaEi9SeTVEQ+NgBZPcR2Hxov4OLdkuaoIgN8q7eq1m8?=
 =?us-ascii?Q?FOaP2mIZqWf9NT6MslVwKduAoK0ZfL9aZl5TViTxf0WTatSrKZv7kUlas2q1?=
 =?us-ascii?Q?Crjlc5abopHD64N2AUKyN0uuN294VEnIcXLaT8lzMsXszsPXJ24dcRaYbwgk?=
 =?us-ascii?Q?GieY/G5s+7Wcl0YhBh6WYxdk4GIltIkRyZ1Vmazwpnb0OaSu5Jj5o3i0u/kd?=
 =?us-ascii?Q?qjRkjOWPApEzKf2i9iLZs+7l3ywc6I3CQKX5RWkh+xLPXMkCkn3KAq4CLSwi?=
 =?us-ascii?Q?cUcCmHzXlA59Wi2FtPQkKmae2Dooyl31p2v1UnQ8j5ZMBFokCmhvWDvWS48I?=
 =?us-ascii?Q?Lj2h6SVWNwT+L8PJlQ1iubrTCbKVbTwrhN5BHgBPkXiu5qp7HKjr2LyqyYcR?=
 =?us-ascii?Q?+L/dAdJkh5ZBX+IFdj9TDZKERfiww2ZpiNRXtnjkntolm86yIcV78XOAf7EV?=
 =?us-ascii?Q?zLEIMHnlkJSM1Zp2kJDtFD7Un9gh7LchiV8pQAk5bTc+v5vG2AChla2ggE4o?=
 =?us-ascii?Q?7UaGyIYmG3FIPjyti0HnontpFzDEFT7PeU8MA0SQKbJgf0rxKAD4r7SIKxqD?=
 =?us-ascii?Q?eireCntKEIbuS9bhhTh0TfLPqjDreGJYYMOUs5RxXuvl5De9bTwLprfNq9S9?=
 =?us-ascii?Q?+Q+ecZx2ONMnUn/ibCOgoSWhwO8UTLolwiqXclja29ma0IcAVXItgsy8j0GC?=
 =?us-ascii?Q?qoikq8qhQe3uD4FXarjpj1kqMydhekKhkgySr2b3hDJi2ukk2ZPn8ZqCAVOB?=
 =?us-ascii?Q?QTWbMgTxGgSxZM5pN4k7BN8QO1kenFV8fTf96HhsthfrVyxj985PTgIB//Fr?=
 =?us-ascii?Q?yfyDqQ64zaS2QZ3OtdRm3pu83OI2NMoRK8U8H3A3IyFyMUXlDZcTjYV+j8uS?=
 =?us-ascii?Q?dwveM4JTgA9zdN011i16cteJbLNcJwtwr320d0B85dLZzDVTpVftx18GMpxe?=
 =?us-ascii?Q?fiQsUmLda+pPy1ThD3UYaf871E/68GM9vmFbSLuBbeeze0M+VHGmUAAgfzoR?=
 =?us-ascii?Q?uQncRGj4N8UFzuoQHzN9nUL/Gh2Q3jL55C4lom/EPqAgKgj+aHtba2egkGXs?=
 =?us-ascii?Q?x2gCkNhQpbC7zbffjfvXd81MrtSOcNI8EwR8N4T/BZU80ok/w4Mt2h7BXSYS?=
 =?us-ascii?Q?6RDKKPw765wl2FWSn3YEHZ40?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0237ae97-942f-47ca-9bd2-08d8cc4449de
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 15:14:54.4212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ik6IBrcEIgIH2FQYKUMRhRcv5XuMhF34Wds1k39p+aGJMj2KgizpRcpiEdLuv13GsxzwHjlPFTNhDXOerP/7Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6435
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor phylink_of_phy_connect() to use phylink_fwnode_phy_connect().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v5: None
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

