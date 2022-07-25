Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A54580212
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236462AbiGYPkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235752AbiGYPjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:39:42 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2061.outbound.protection.outlook.com [40.107.20.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCBA1DA78;
        Mon, 25 Jul 2022 08:38:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMZJDF7NCtv8HqC22Xchz9dNC0w+svIQzbFzGT9GlKWUAjc7xiaBpDPhlpEe4R016qrk8DlQu8YeYxVAjkFsUZJ4ydDPXky9a9qSs5dUh0SKUglg70oceiFwCLPg9rzWG7eUpUUbOYuq/FUC7msuMK26EZpaT8+gxgeuUywajv+8zk/on2g6jS6pNKHO/Z0gXXYnhJbzUx8G5ouFiSD+YKDIcYJRvVzLEt/6E5CaP0FVW+pDPL7arWTB4IPG3LtaYwncM7RxIiKx0drW1u7zmXxt4uSm1NzQkc4aIigUU5YXWmYVTh63IxMNicrsb14bOoHQ/2HrZ/0jCDc+Vvx/FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NsV7YGT9vGnTEtFTU15G2k9BWfNRzFNNm89ghHTwVzc=;
 b=BNj0pPcaCn8iQv/B0lm9XL96hgjp/kwrWfzp3FTRRZja1AdzXlSAFI5mYWdTFTK8H582M7VdiZcPNL26J9288YlnvXDUvP+0r3cMmHNKCrLTKkm8nuvMZW2vskdpu8b0rCGUsB1zOBWQVFyMcKBDOL2dxXgS+ot7z7IT5fEDhSWmzubHOwJOLJjQ1ekzF5xu2oKYwtm3KVvbY+9wWAB6C6BKJDlxdkkDVVFz3riZeUAp5j4qQS7ZjRZHLOYEID8qZyeGRkbfhr/O72FBGgmx6u1Pgdl2Zw2W73LXkR7yVK9rEpkEeoMSYgrVw0UvkbQxs/ke1f0IQwyLmY2ZJNnSag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NsV7YGT9vGnTEtFTU15G2k9BWfNRzFNNm89ghHTwVzc=;
 b=TvopKscid26EgKPN7om7j0h+n47/FT2UgTWxGOeGvTo+9iHoz0OHgMQsFUz/J7uoBpnFgWq3C8QSA6qHYg8uLxOfO1ahB67qUFkJugcVxdt6LrUpP/1ihYvirnh8IWNkHxCqFvH7TjC2qPpaPYmC/pbNH08/Qq3PdnPSSay+LhhLLLPuJ8vg19utJ/zlS12cIxtuRiZiC/Id4KYMfgeEO3IqgJht4AuaEgzOTmxbt8lpnoeeSnH9kOa7xL4SX5LtDadwuN3F/UXh3Rz8/ZVIgGnp0tjpj/iwYunyQ1BJABpbM9A3A2dNmX32yoJRdzXmgBGTw3t6ro3lBH6pqe5HFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR03MB6464.eurprd03.prod.outlook.com (2603:10a6:800:19e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 15:38:00 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:38:00 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v3 11/11] net: phy: aquantia: Add support for rate adaptation
Date:   Mon, 25 Jul 2022 11:37:29 -0400
Message-Id: <20220725153730.2604096-12-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725153730.2604096-1-sean.anderson@seco.com>
References: <20220725153730.2604096-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:208:32e::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 448eb526-a181-42b8-96c1-08da6e53a793
X-MS-TrafficTypeDiagnostic: VI1PR03MB6464:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SU4jqoYZX4dTn56EnBy8WJfKnaNZ3B2PFqCf/9VxpeA22k6B3prvtxvYprxSS9QCacUqRHQmHWZH9ZZz+FhNqu7cmjk3R6VRj4byovxLYCsJR0VGdvtX/BqHL4uHFCHor23sbniQF4Qpnjbhj5/pt6+JdqOWU5k7qkOVUCWv/3L4yagR3Hzfqn7w+vIWiYy9cR1sO5y4W8wPjARwrdQn5ZR1/b+GCADkKkE8wWcJgugUKpMb4SFmF9S/WL8ZxjFHjk0cVi3Y2pROJrm7qZ62c8nMTHST3nZt7KwiAC4Y7j8ASCsTstH8dMVD4bGu4CKlp3G8KEh3/fUnvUyIh2JPcJBeNymfR446ouxKKuYUeiya9mARLK7GLEpxfSCr4m2tdXxNz3VuvGFmHuu3ZAGyiR39La2/unckGFW4diRbpHZN+2hm2FYujIkExAMQoJjJBSxbE7yyDv2MlvaH0XFl+Y0o7rchUz4XDazcklQ72depJMnP0+5v+aJ2vlGet+TPaGmbAaCf2R77PtC5FO5GQ0vWjTiGeYtPeFpbDog3Y827aas56bqNigQU0NSHz4eUdPowni4dVB5/3Ni1vX6YYIa2TDtWqzDtQ+LEoFgXBwIkZjRMkMAak4U+xDvKBeSoWTG0Gh9RCc8FB6dyq6ofXQpc4HD3fQJ3rQmmNWBQnTiCUzHbmYx8rjXxTc1Xzf82ofxtST8nUI1jU1Njy6vy57yB5+bvb3gvOVDVemVFYHnFK2j2K4Ftx/JXCzXszGX2p4wLAQmCXirl2jHTMbEIjmRP+VVDr4IDw5FOVXQHaxA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(396003)(346002)(366004)(376002)(36756003)(110136005)(54906003)(186003)(38350700002)(8676002)(66556008)(66946007)(316002)(66476007)(38100700002)(8936002)(86362001)(2616005)(478600001)(4326008)(5660300002)(6666004)(83380400001)(7416002)(6506007)(41300700001)(6486002)(44832011)(26005)(6512007)(52116002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uNzriAjfNItmztd6wjPSKsyhoKGXxaZEm1D9tgyqLpO/KYymQbgaz8qqeFTo?=
 =?us-ascii?Q?bYAvOw30rG3tHvuTddKuBJ5hdMtJUdjJ00zAz8+HQCXWhTSsijbPqu9mA1RT?=
 =?us-ascii?Q?5azr1vrRzDzCU2OQSkcZ89oaY4tS9KMmpMgNzUySL8rcoUd9Xji7tTM9ZjDc?=
 =?us-ascii?Q?h9rtrju+cFHSuL1mDNQj+HzNBxWqDQsgk/+N+Di91lbgZcBriraNO48bD8ha?=
 =?us-ascii?Q?Xuo/KohfFuSb/do1L4hc+wsTVrEBD64glf9IzZ222JX++elf6CCnw+GLo8J8?=
 =?us-ascii?Q?Dg0qL5xWMAcYkwh7Quh/usokLDZ5BQN3hFfIaE1H0Ovg3gOj1p/iyuoNXp8W?=
 =?us-ascii?Q?f4oqQ+oiHfdtLXzVwqtGEqMpTo5yKj6Xn0flFHPZe5IiOT5SvzY/7RlVmrk6?=
 =?us-ascii?Q?FqxmCvGUVtX+EvJpTphfHBlN4TT8uBTz6nUjop8EWzpZZ0G7WfOlCJPgeyZO?=
 =?us-ascii?Q?np+/W7+mACKin7C7sp7EnefzVDyM0uhfL70NDvfSlzfyzcvQq+cOWybul2XZ?=
 =?us-ascii?Q?no/CsZuA8mcxn7bfja303fIhSKMpoF5w5+4WFIudvZStdtJ9VqmnaK2EM8Yc?=
 =?us-ascii?Q?i8VsdRkGhzrR+ZYNwpzy0aJRxO9d7M17hVB606hFzzVbqrWUeuONjOCGN91K?=
 =?us-ascii?Q?4yDqXb9eRsdUdG7CB7/6YiTL9NNy5Pz5AsYgUCpd2CBZGqbcutHe218FhMcQ?=
 =?us-ascii?Q?5oyly4Qqj1KHUJBwNOYb5YvbwjeA9ZRUXEjKTWx/nEBuRlTILgtp+h7fKZxt?=
 =?us-ascii?Q?a9PvhE8Bq7/HqCW9YsAPBnKqDUMKpwqPhypavP9J4sMiHG5TZiY+ACncgYe1?=
 =?us-ascii?Q?ogGlaC3YaNI88epv6cl2GS1CfaLfiV+f3259F5lmmE6BlgC2qP0wa2p2VTOo?=
 =?us-ascii?Q?sZGEgmlQVyMVJvbPsxutw9VWT7vUm8C6gnosrVuYHeQAkF1fUsT54c1+Dfi4?=
 =?us-ascii?Q?qmEkdXU+kHgPAdvXFRKDOhWLijbswWi+Fo+vtLKIP0/vgO7ZN/2sYUFRmb+I?=
 =?us-ascii?Q?B200H02k2CoRFRM3plJtMKPAcyRA5lUc427vDO1RMny8UiRcqaf/AlHYN9xd?=
 =?us-ascii?Q?pQRwc2pwIDvZcBjeuyxvFrD1AHXsUHN1IOGWszEnx/2kgak9sDPVhu4pDtrr?=
 =?us-ascii?Q?qaHxXdIaKnE+cSlVN3a11rIlMqh33GeZcwoQqQuaVGnPg6pgNfLkfB4DBeeu?=
 =?us-ascii?Q?/YRp3KDNrwbumVwA2NMWrcYv8wx3SxqwmfgYholp354aBIxeMTd344y4HFNz?=
 =?us-ascii?Q?FzWOxSLMZzcV90pgi0DfoItbIJtAbtfNyR6y9cXLXmmRfqIzAeyIyV0fsYxt?=
 =?us-ascii?Q?671ZitsDpMdwaj0ImX4c6XJxjNyQCVMfRtleDLTERoMOeUz94y3ZvTZ5bFL3?=
 =?us-ascii?Q?WsgQwQYf1GxUYkeUbgkRkYUh2la9fAWhYEyOnNHxmyT32o7u7p5xg0lgFuhk?=
 =?us-ascii?Q?UOCpbtz0hnWX/DxOHZ+rFWBVAYWCK91GdUJ/U6w0V23zOuTN/22x3MWUAye1?=
 =?us-ascii?Q?qUyDeQ2BxES+z+KrJ+pkhZ8cmmgszYWpBQZhXJroFuIq38m7S8JP6G8/bnEw?=
 =?us-ascii?Q?EI00/PrfFgKCzYclM3Vybu0maWlTxkDnXEz+7mEmsTHzGMkd5M9/13+ecqsC?=
 =?us-ascii?Q?HA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 448eb526-a181-42b8-96c1-08da6e53a793
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:38:00.0248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BMR1E5MrZ0F4TPnDY08JoiFk6XanATOo6+Tktq5EciGn44XLoC9gT1i/E7C4qQqk8Y969eQbUzf9ebe3DgqXhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6464
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for rate adaptation for phys similar to the AQR107. We
assume that all phys using aqr107_read_status support rate adaptation.
However, it could be possible to determine support based on the firmware
revision if there are phys discovered which do not support rate adaptation.
However, as rate adaptation is advertised in the datasheets for these phys,
I suspect it is supported most boards.

Despite the name, the "config" registers are updated with the current rate
adaptation method (if any). Because they appear to be updated
automatically, I don't know if these registers can be used to disable rate
adaptation.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v2)

Changes in v2:
- Add comments clarifying the register defines
- Reorder variables in aqr107_read_rate

 drivers/net/phy/aquantia_main.c | 51 ++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index b3a5db487e52..dd73891cf68a 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -94,6 +94,19 @@
 #define VEND1_GLOBAL_FW_ID_MAJOR		GENMASK(15, 8)
 #define VEND1_GLOBAL_FW_ID_MINOR		GENMASK(7, 0)
 
+/* The following registers all have similar layouts; first the registers... */
+#define VEND1_GLOBAL_CFG_10M			0x0310
+#define VEND1_GLOBAL_CFG_100M			0x031b
+#define VEND1_GLOBAL_CFG_1G			0x031c
+#define VEND1_GLOBAL_CFG_2_5G			0x031d
+#define VEND1_GLOBAL_CFG_5G			0x031e
+#define VEND1_GLOBAL_CFG_10G			0x031f
+/* ...and now the fields */
+#define VEND1_GLOBAL_CFG_RATE_ADAPT		GENMASK(8, 7)
+#define VEND1_GLOBAL_CFG_RATE_ADAPT_NONE	0
+#define VEND1_GLOBAL_CFG_RATE_ADAPT_USX		1
+#define VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE	2
+
 #define VEND1_GLOBAL_RSVD_STAT1			0xc885
 #define VEND1_GLOBAL_RSVD_STAT1_FW_BUILD_ID	GENMASK(7, 4)
 #define VEND1_GLOBAL_RSVD_STAT1_PROV_ID		GENMASK(3, 0)
@@ -338,40 +351,57 @@ static int aqr_read_status(struct phy_device *phydev)
 
 static int aqr107_read_rate(struct phy_device *phydev)
 {
+	u32 config_reg;
 	int val;
 
 	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_TX_VEND_STATUS1);
 	if (val < 0)
 		return val;
 
+	if (val & MDIO_AN_TX_VEND_STATUS1_FULL_DUPLEX)
+		phydev->duplex = DUPLEX_FULL;
+	else
+		phydev->duplex = DUPLEX_HALF;
+
 	switch (FIELD_GET(MDIO_AN_TX_VEND_STATUS1_RATE_MASK, val)) {
 	case MDIO_AN_TX_VEND_STATUS1_10BASET:
 		phydev->speed = SPEED_10;
+		config_reg = VEND1_GLOBAL_CFG_10M;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_100BASETX:
 		phydev->speed = SPEED_100;
+		config_reg = VEND1_GLOBAL_CFG_100M;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_1000BASET:
 		phydev->speed = SPEED_1000;
+		config_reg = VEND1_GLOBAL_CFG_1G;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_2500BASET:
 		phydev->speed = SPEED_2500;
+		config_reg = VEND1_GLOBAL_CFG_2_5G;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_5000BASET:
 		phydev->speed = SPEED_5000;
+		config_reg = VEND1_GLOBAL_CFG_5G;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_10GBASET:
 		phydev->speed = SPEED_10000;
+		config_reg = VEND1_GLOBAL_CFG_10G;
 		break;
 	default:
 		phydev->speed = SPEED_UNKNOWN;
-		break;
+		return 0;
 	}
 
-	if (val & MDIO_AN_TX_VEND_STATUS1_FULL_DUPLEX)
-		phydev->duplex = DUPLEX_FULL;
+	val = phy_read_mmd(phydev, MDIO_MMD_VEND1, config_reg);
+	if (val < 0)
+		return val;
+
+	if (FIELD_GET(VEND1_GLOBAL_CFG_RATE_ADAPT, val) ==
+	    VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE)
+		phydev->rate_adaptation = RATE_ADAPT_PAUSE;
 	else
-		phydev->duplex = DUPLEX_HALF;
+		phydev->rate_adaptation = RATE_ADAPT_NONE;
 
 	return 0;
 }
@@ -612,6 +642,16 @@ static void aqr107_link_change_notify(struct phy_device *phydev)
 		phydev_info(phydev, "Aquantia 1000Base-T2 mode active\n");
 }
 
+static int aqr107_get_rate_adaptation(struct phy_device *phydev,
+				      phy_interface_t iface)
+{
+	if (iface == PHY_INTERFACE_MODE_10GBASER ||
+	    iface == PHY_INTERFACE_MODE_2500BASEX ||
+	    iface == PHY_INTERFACE_MODE_NA)
+		return RATE_ADAPT_PAUSE;
+	return RATE_ADAPT_NONE;
+}
+
 static int aqr107_suspend(struct phy_device *phydev)
 {
 	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
@@ -673,6 +713,7 @@ static struct phy_driver aqr_driver[] = {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQR107),
 	.name		= "Aquantia AQR107",
 	.probe		= aqr107_probe,
+	.get_rate_adaptation = aqr107_get_rate_adaptation,
 	.config_init	= aqr107_config_init,
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
@@ -691,6 +732,7 @@ static struct phy_driver aqr_driver[] = {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQCS109),
 	.name		= "Aquantia AQCS109",
 	.probe		= aqr107_probe,
+	.get_rate_adaptation = aqr107_get_rate_adaptation,
 	.config_init	= aqcs109_config_init,
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
@@ -717,6 +759,7 @@ static struct phy_driver aqr_driver[] = {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQR113C),
 	.name           = "Aquantia AQR113C",
 	.probe          = aqr107_probe,
+	.get_rate_adaptation = aqr107_get_rate_adaptation,
 	.config_init    = aqr107_config_init,
 	.config_aneg    = aqr_config_aneg,
 	.config_intr    = aqr_config_intr,
-- 
2.35.1.1320.gc452695387.dirty

