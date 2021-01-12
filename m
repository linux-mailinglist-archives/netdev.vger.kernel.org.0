Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95D72F3218
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388856AbhALNok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:44:40 -0500
Received: from mail-eopbgr70078.outbound.protection.outlook.com ([40.107.7.78]:43716
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727144AbhALNoi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:44:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iaueuGGMCwdNGMWBo9zBNngq2qdiJR3mfnvoAo7on/r+IaUFCoxaGkBadBJ05q6gxCitszlSfrBLG15GeXAe7lU1eB+K2UsUPBIz8lohCjl0r+2JQdMl+TrkAtRLtrdafiP0IYtoaGj+YSq7j++2t8mK2UcF+aKG6qPDNgSxpoqo1SB0wiVPxB5ADmvuNhQYEbiLCQfFINb1PWfPAcMcBGivU1YsxYcJlY7FQOwzGc495eb04Z/NYaGj001efcjbtGmv+4IxE3SEvrOnPMzceVHkekIRj70hKR0CPWMQepFfAFn+r6q5h6pyhSf9+fH7XWHgczr9gT0+KkfZFWqQ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fAPgvMovsh30mY5OeCsKrwlEmUy/JjBX6LBLUGm58U=;
 b=kbdJU7Pv3gyZM+Ye+vFA3rFFlfC4gBvYBc0aoj76YuiV1FgxJbJauNJusqepAgIrDSBIrbpjf+Hj+nGL44X0h4UFTxQjy5eSc5G8BafAN/LHzknBud686VdZRR3srdsv+dgKHcsTrko+99geyvxnRnOC3+v2j2NbzD6xnXe5GI226PfFA/yI9R9plK13P8m7CeLCcptm0gyr7/ivggUXUqU1yMQ7Je/G5TQIB7LpD3oantQlWMfBc2/1djyk5zBBONtlJ6X13cHbJgDCc+EdjwYdflHkY+YQgcRht5Pf0++q/bJIwc3ZQABiFWgfZy9+MOawlpm0o6bNtM9HdPKj1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fAPgvMovsh30mY5OeCsKrwlEmUy/JjBX6LBLUGm58U=;
 b=YsTms1WMj7LBZHzah+9LrLjjOKh1W7F8CmnhblA+GqRpp1Vaj8yzEXgqjjR0rxlF5+cfRXzPD6NXtiHYmdVnVJdChAbLiGHP2aDCPdxAHlAZA3zphNMh6sqZ83WASm3CGt1pfGHnGE1qvGeUmKlg8+ZgzI2vXZ+TF7z6P3QEVTQ=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7937.eurprd04.prod.outlook.com (2603:10a6:20b:248::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 13:43:16 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 13:43:16 +0000
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
Cc:     Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v3 14/15] net: phylink: Refactor phylink_of_phy_connect()
Date:   Tue, 12 Jan 2021 19:10:53 +0530
Message-Id: <20210112134054.342-15-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:3:18::35) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0047.apcprd02.prod.outlook.com (2603:1096:3:18::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 13:43:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 00ea4d50-4485-4c7b-342f-08d8b70003b8
X-MS-TrafficTypeDiagnostic: AM8PR04MB7937:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB7937EE524929A4BF3F28A6A7D2AA0@AM8PR04MB7937.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4V3TZ/RmykZNVyU64e2OCF2zDDe9IrSFLzLOzoeHbIzcpyLI8TGCPmuFUFb9DoVYmnpZC3t8Hc+hskv2xxaJ3x/IQX0xr+sCXYesuihOf/RWd4ojKDb4T8aX5asGvfkdqJ3voAz3tmgf4d6iTbF5c85Vl5KHeUQaQVRqWh9JKlbnwQ2M5wT68LyehuZq8DqjRDvD9z0uy33JX/tDM/wrdaOSXW/o8ljkoRutW/S2VFbNKKDeq2RSAdWYBa31OxRsuxNs89IimPnmMw02xB7FnZsf+SJukNg0QsUmSQHvuWOj5ANJrHJ2w9xTXB+LB4A2q3y7G8azn+84v1xa0lVcWjIToJYklffe6Mm9E6A3G/eEiNir5pjkNxicX6bWmQmG1aFTS4rYeEo6mtFnzRHuJqmyJYPQadr3Blrs9EoyCMg2fQNyG4XVbaYFTdpe2R2ABKU/PJ3l3eLJNp/tW4yAkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39850400004)(16526019)(5660300002)(1076003)(86362001)(52116002)(44832011)(66476007)(110136005)(6512007)(55236004)(26005)(186003)(8676002)(66556008)(316002)(8936002)(4326008)(478600001)(921005)(1006002)(6666004)(2616005)(6486002)(54906003)(6506007)(83380400001)(956004)(7416002)(66946007)(2906002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?a0b9lrZQttWcFgevrD9z4rFBxg8PSvd6tJR3W41os9Pja85azHj7m5Oqvgnt?=
 =?us-ascii?Q?ZOtHBA36ZEyOpWB+jMpgn4pbOGBjPSKsQuxFqw83Gw55gm2y+B+CaKaySGpd?=
 =?us-ascii?Q?QUIaIJfLQQhogmagx/pL2SBodgkBsVPnVrtFQN3/0k98H3U4j38aBDAQedi8?=
 =?us-ascii?Q?+uBHq9RsRYFx0NMiX5hNcYF4EfFOUy6NKvZ0WnRud0DVe57/SUIPoStBigvb?=
 =?us-ascii?Q?zV7VaYLp00Yq0TuLZAGemmzFUESiJlTYbK0wRYqUQzbE59UX8r7EsxV/or+p?=
 =?us-ascii?Q?/ff3T2p5G/pvt23oD8ty10h5KztnvF+LmhLd2fXgViNa5A4hIJvTm5BEJzv1?=
 =?us-ascii?Q?qRLu01oLPuDdnnbcGIQJbQDefjoFMZsWVixofhFrwnj4oIjOrP8clVBqPKX3?=
 =?us-ascii?Q?UFoVVECUNfKRPAAVDrSv9H/f/nJpln9DBSlq4B7uNzpulHTkqa2/rNpGmPiX?=
 =?us-ascii?Q?2iD8akI0vf78TQCj8QcKBfIwOUqImWGRu877KXp/760fsBnrtq4K+vz/x1aR?=
 =?us-ascii?Q?Z6GB89kk6JQuauWreE775G8H6azOKQXesgl2zbmMXfnpzenI452ZVGNR33B2?=
 =?us-ascii?Q?tueS2hKL7Ek5wy+kIRTqU0FaYgZSamQiQRO+Mg2hk4n8plWgSbox+fDMdkIt?=
 =?us-ascii?Q?GqLLP27fk6srK8332zqARWuqcaOulzJXnntOQFukZGpYESTTF0Tvv7t3bI7G?=
 =?us-ascii?Q?Noalk0Qu6ZJfRDJM5oNF6h+bfq0n+iCkAgquo89INe7NuRLT3k3zs162+rce?=
 =?us-ascii?Q?sW3yQUt8qIOjO++RX/nebEefWzl1JUCuySW5Hzx9WU3lR2+PGkq6wKH/vZ2E?=
 =?us-ascii?Q?4WugJ53LIJ54Vb64s6N82zlosszf+as8qfZGze01+OpNnHO6Cmo0y4i+XQRH?=
 =?us-ascii?Q?vY5QMrxvlXs+KbwgyqTx+WPTuohx0j9bWLu1pbQQ+XSo3SaHrn/4iJOvJ0kx?=
 =?us-ascii?Q?VFr+/hWHRhDLZfqGhjrcQVtbKxughN3X2rTra/gADMJ9dO5jFNOCNTL89iaJ?=
 =?us-ascii?Q?7xA6?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 13:43:16.2432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 00ea4d50-4485-4c7b-342f-08d8b70003b8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SOW/nrkwrilCWdfBqT4sonOLBZcT7gR3y1Z9QlmILBgy3vKv/50a2VsopoJen3IFV/SoNtbVzrhPKUUD6IaAfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7937
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor phylink_of_phy_connect() to use phylink_fwnode_phy_connect().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v3: None
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

