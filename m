Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBAED598616
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343593AbiHROdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343552AbiHROdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:33:40 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60047.outbound.protection.outlook.com [40.107.6.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82965B05
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 07:33:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UAxrDKWQAB5lthyS4O+o2csDNpCoGMlr+8hrV9QnegSuhQcyejLAfaLnkPwiqbN5JD2k7ARYp4XId6j2tz062bO35ZoeGvbTEbZqDnjfVqIVen4mWMJbr3D3WgkCNHgojCgpJC2L9zPT/B91UP8fAi5nnNZOnhcfPYAx5jD72TsLRxEz7Eixv9I/wKOkwkKfCyLBQVtUHLzHqT2g0vhkUTj/PdIVoUyxMKpHIIrGLZ3EymEl5RBNjTeXi7Fag4nEX8gU19wnzDRPMjx0Pr6dLi7cPr9W0l/R+nZDwRqqKtpPOQRzpfR83k3tMVcX5Log8FXRnCl+05K1YHRxMrM8lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xdrdNKg/BE3OUa3tal8c1cXRB6dzE2dp6VWWFqvPe7s=;
 b=Ze5BCx4NekfAKf8WdFz8reDEniFi3M0ML8gJ4fPCEhXNE53osxrym1htXFjvLL6+pqxjwMA01i4b6ya8yWPBnN30QRF+cOxvsWKxmk6HsIRim7SARAd98wmcBfo6hrvDBO7ytZm1P52WvKSM7sJrBk3pZyQm5iYaDskE3ymKwQUQZj7nfjKowtFxdHlePAUP+BOuWfufDjNwe0w75cs9Nh41O8bV67TibXNiy+lu7iOfCOCe/S1HtKo5R9ZN7qm10IYTQkuSc9NMYv7Yfae9Xy46gS8HETGEQns2HgCDfE7JO7Xs4YJOfzBFLx8bzq5neoFvACdu1GpbV8Y9cEcK1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xdrdNKg/BE3OUa3tal8c1cXRB6dzE2dp6VWWFqvPe7s=;
 b=Hsk3QB/4agYBcfDNj4ZPkqQebaQRDdp8DOaWUv6NIhBOJOMebg750cO8C/jXjAqnLBxT1kEGwrBm8z8eU/igxb8wxBYSd0lNmaNXY/xe3HD/ghV87bNyQY6vmbP6H3YvcqQkqXUF36/dqgZ52qgsgJJq78QWjEIDzkbgY8v0ad8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4805.eurprd04.prod.outlook.com (2603:10a6:20b:d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 18 Aug
 2022 14:33:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 14:33:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Craig McQueen <craig@mcqueen.id.au>
Subject: [PATCH net] net: dsa: microchip: keep compatibility with device tree blobs with no phy-mode
Date:   Thu, 18 Aug 2022 17:32:50 +0300
Message-Id: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0007.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8598c3a2-1994-4f90-fc98-08da81269304
X-MS-TrafficTypeDiagnostic: AM6PR04MB4805:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dq1UsjrfiTxvozWPnZIvmIUW11pFZNlGxHsvtFj+hKbG9OX65pZ752OkiXZhi6JhV0HT+shOzA15IfSJV6RfLt7jwSb67KFvGROwhvfYbAvE5eE0E2Ir4/OQga1v8yVHKwMC01yIgNX/GvLbdjR0OtOVBYzb2DWwAm//fUAowPqqpsUz6j15mNTKBunmHVLCwLLiqzvhhYhQUIqHeOEtIEs4vQmd9o3mUdaHtzmewd7ld655IKSxfq5jEni3weItpicIyTbFhsYkHR9nfrZArB9DP6nIjAWIKJgyLwXRUl4QL9DWGUtW0wGaIKM7u6VRT5FSmJTsxFgHrntiBI4idUKNyLBjM9mH/wiclZ21xexO1wjiQDXZn6GTWQTc9ySmx3oUUEludM+8OHpxO7smmSlmi03WFGj61Q1RCHYPE7HnDhCpT6XAVYVZVaTqSW+FFaJs68xL3Xxw8+xKAI7DltQ2+FBVIQS+7aDt4gxetbzy3hR8kUKAEq64wL7pc0CrRNBan9sWxejbUmCbguGkYxNf+c/+5XoIdbyRthEFXYnoGSEDJUtvjdHyeKyfplYf7t69l9xCZAAZYBsa7tacRalh0vfDx0gbAJt2L2522vdJZ219n5lyeNy2tGlkZih/abfAdHMNG1GiB0ONhMXMP4WmyNxPCUq+ywcZPFqqemBbx1aw8GmygO8EBrLgjiBgfXeAwt0MZarcYeHzK9Sz0YGQh6V5x5AY4AD7BliTFY1UsXOt8eH3hdi0kYgipU1l9K8QOHzi+LtOD2pHbkXOKuoI/WUmuNYXcQj/+Jttpxs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(54906003)(38100700002)(41300700001)(1076003)(2616005)(186003)(478600001)(6486002)(38350700002)(6916009)(316002)(26005)(966005)(86362001)(6666004)(83380400001)(66556008)(6506007)(8936002)(6512007)(4326008)(52116002)(2906002)(7416002)(44832011)(66946007)(8676002)(5660300002)(66476007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IwDTt0kNh0Ir4C5hLElkSWd8DzBkhyTwRs3Vvm+l/QTzh3QqWYpkYOMJuTBT?=
 =?us-ascii?Q?E9CXovvWxDxyl3JSDaDIiVHslKcchROJ9MtwrObUfKlTUg7SSH0M1DZpz8Eb?=
 =?us-ascii?Q?BAeHZ1HZIQdkCkvAHroRB+tPtG5y0cHDA8QIz8ORarVpulDwMW5nUOnYPWlo?=
 =?us-ascii?Q?Cir6+eiUkSvvk1h11FmdtPXaH9chBWA1BcgXU3keeNAnIfVx5O3dWXiou0zN?=
 =?us-ascii?Q?qREoSSJP/rYCu+adzV0KKMAaD9r9uyOQHzVxCeBvohTPfueg0O7XUTvpjbMl?=
 =?us-ascii?Q?a8FBlHDJ4HOgv0flkYiaQPzVsG/T5MANt80aPH2wGg2XxSmaYPsEBI5DaZcW?=
 =?us-ascii?Q?KvG+s/3npXaBd4EvU8RDig7/yKxpLYmKUyWcUr9gDDbB3FyWam4IxJGiEgig?=
 =?us-ascii?Q?ah3m+D52W+kBcnYi36nIRZ3wyZcLOkw526EdgdcMXn6Ppr9CNIsAs1j+0Rwx?=
 =?us-ascii?Q?7IYQRHgvH0gJzu8GmEGWkNrFg/OApJH3z2ygApvwh27vHJL0r14unldjKIFO?=
 =?us-ascii?Q?uqZerW0etyKiuOjU0h0+tLznB0JB8MQWlmmBaGkN6Doc54XRhGEutQ9gwrYY?=
 =?us-ascii?Q?ObjBaThW0T9JPQuWWSXTRbm3zPDdd0hLtcshIeZQe5+Pyo9oNbEg7I6bW3VS?=
 =?us-ascii?Q?driX5TJj/+9OnUjWUFQNrsM2HMmdsus1nqYr266sgKBU4z+pCV+ul8Tvm0jb?=
 =?us-ascii?Q?U4B7rsyXqiM5kBYfyrqdfrgWvHKoqGPs5eFsY9JCO8kSDyX8+zHkIWr3lkf/?=
 =?us-ascii?Q?zCw8Unj/UbvBW0qV0LJPdx+saYDHdeN6+xInJpHkB2W/NfIPlQuJpDiWdrgf?=
 =?us-ascii?Q?PbqjLjja6SUgkJr5uP2tKduu5vgLaPeUuoadnEOUiflBle+p3iu1DevDPJhJ?=
 =?us-ascii?Q?GhcaepEgUj+AKCt/pvigXPKUtw20vSy3gXHGCP6mf5z/TvdMqqJDQwzWQ9Lv?=
 =?us-ascii?Q?jR2OFBRCIJzU/Vk00aPZVdZZVt9tBN57ksc0Ym8aOAkk3HJERYD+h6+XQC5G?=
 =?us-ascii?Q?5Kc6HYFY12nWIaybVdKNo1gkWUYCBQKTab28uQLTxFPIZZsjTtdMPVvD3r1/?=
 =?us-ascii?Q?e2TRQBHhWhrdDUMFNH0hK6z1SIpUxrkt1INlftbg9DpMA6DS5p43TXs5qn9j?=
 =?us-ascii?Q?pqHV1TazqOc6Ok5lLx3I4jpmYoxVuiEjX9bOv6o6t69K5LdJUcuDvRBzj++C?=
 =?us-ascii?Q?rXNEzgBO4ZGHr3JzGOIOeKHzS+ictsTs/mGm9bOmW2/4pOU+vcciTj5R+3Pg?=
 =?us-ascii?Q?aW2BHzzrJ1embRbimoKm8c6w2y+3OPwSSnPk9Bf4rOl1HNtVA9fQ3vPzHn45?=
 =?us-ascii?Q?3oUbNFNJrS5jhkTpNnKRUUmhFdTC8CB774FaBQsQ+X2NOLMlTr3MHFqZbm+g?=
 =?us-ascii?Q?xNJoZE+12Dr0kopOLPpsvyW2jwq2mmrxaHEzIfuUtD9fDEFfoDbeYdGah0i9?=
 =?us-ascii?Q?NhfcUGvoThuoYWBEsFK7z0zI8TVnuQXAGfk5TmfdpsHf+0ThnealAk8y8f+Z?=
 =?us-ascii?Q?/gdO+r8UJ0K9g2oVAv9nAkdPRkKOo05WZig2Z9BHxq0xalkGEMZMTAgGKct/?=
 =?us-ascii?Q?+NX1qa5DhTbfE4RVwDDCM5KDd9861bEyf4gouXN5GZk7ImQxZcuxWNije1ze?=
 =?us-ascii?Q?Og=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8598c3a2-1994-4f90-fc98-08da81269304
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 14:33:10.3383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gWmiec9QacqEq6nAv/wbZpKmtp3W1qhgPZjW1IeYNP7HktTf9a/9LAPlTPnT5TQ7oGLxQLO3E1xKJTR0rNUbog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4805
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA has multiple ways of specifying a MAC connection to an internal PHY.
One requires a DT description like this:

	port@0 {
		reg = <0>;
		phy-handle = <&internal_phy>;
		phy-mode = "internal";
	};

(which is IMO the recommended approach, as it is the clearest
description)

but it is also possible to leave the specification as just:

	port@0 {
		reg = <0>;
	}

and if the driver implements ds->ops->phy_read and ds->ops->phy_write,
the DSA framework "knows" it should create a ds->slave_mii_bus, and it
should connect to a non-OF-based internal PHY on this MDIO bus, at an
MDIO address equal to the port address.

There is also an intermediary way of describing things:

	port@0 {
		reg = <0>;
		phy-handle = <&internal_phy>;
	};

In case 2, DSA calls phylink_connect_phy() and in case 3, it calls
phylink_of_phy_connect(). In both cases, phylink_create() has been
called with a phy_interface_t of PHY_INTERFACE_MODE_NA, and in both
cases, PHY_INTERFACE_MODE_NA is translated into phy->interface.

It is important to note that phy_device_create() initializes
dev->interface = PHY_INTERFACE_MODE_GMII, and so, when we use
phylink_create(PHY_INTERFACE_MODE_NA), no one will override this, and we
will end up with a PHY_INTERFACE_MODE_GMII interface inherited from the
PHY.

All this means that in order to maintain compatibility with device tree
blobs where the phy-mode property is missing, we need to allow the
"gmii" phy-mode and treat it as "internal".

Fixes: 2c709e0bdad4 ("net: dsa: microchip: ksz8795: add phylink support")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216320
Reported-by: Craig McQueen <craig@mcqueen.id.au>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index ed7d137cba99..7461272a6d41 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -803,9 +803,15 @@ static void ksz_phylink_get_caps(struct dsa_switch *ds, int port,
 	if (dev->info->supports_rgmii[port])
 		phy_interface_set_rgmii(config->supported_interfaces);
 
-	if (dev->info->internal_phy[port])
+	if (dev->info->internal_phy[port]) {
 		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
 			  config->supported_interfaces);
+		/* Compatibility for phylib's default interface type when the
+		 * phy-mode property is absent
+		 */
+		__set_bit(PHY_INTERFACE_MODE_GMII,
+			  config->supported_interfaces);
+	}
 
 	if (dev->dev_ops->get_caps)
 		dev->dev_ops->get_caps(dev, port, config);
-- 
2.34.1

