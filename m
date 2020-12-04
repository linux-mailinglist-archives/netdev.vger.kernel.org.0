Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34992CEDB1
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgLDMJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:09:07 -0500
Received: from mail-eopbgr00055.outbound.protection.outlook.com ([40.107.0.55]:60342
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726066AbgLDMJG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 07:09:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aAcbGZwvmZ/QV5m7hEKS+VXTuNgoi8msWqOc22RAq65aCBBuwmz2SqkXcRtbqRz+GlsfB2sT72N4ZrfBvutB5oxqrZ6LasVXPP5OWd+0lGM47j+HX0IJ+b3q/oolYt5+Qo5208s4+BqI3U4gHDG9Q3XxGPTd7ZgCQOJRbpQ0zTZNVFn145p/i5uceGzhgrL6y6OMaa0wj/togwd9THnecpvRQK4EVoodB9JPrmjqtmxkbGHp2/MZpSIF1vx944WjETbWa8/fR9NVEjYKPQyNI406ET/2U9t+N/8TiktUsASWBibbI0COUQ6QCAvCwdFR++DZe+g/o38pMMpmN2Wi0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hALnRjR6B/OX9EbDHpIPAUnMAWmuNGLflSCfm6N3Uo=;
 b=REuyGg7frQuFq2AGPaK6905GW0gBSglaj8l5EUUWlSsY+uwB4OSNhHkuBtUD5ad8WSQOrpKGnEQ5eD9zoR+Ifu/RY12iSbBwA0IqyMol1dOIKb5zve2cWjIQk/3mbbbySxVUtR6s2Il2hul2/JA7VaWFO3RtpOE5ZhUuisrFxQr8Hwis6JNmAWy/2L4IA8vrK198bQgo8TYx5TTovCtNwpauz2asvM0Tk4LVl9eUjjVY6cU81PFp4E/xFcmpESxLYOLdHbA+y/q5SN7OJHDK7AxzdqmT3rCMA2L/uMRgOlXWAcpYUuGFDCYrCqmI9XS2ZHSJgxi8aq9KO+rpz/FfRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hALnRjR6B/OX9EbDHpIPAUnMAWmuNGLflSCfm6N3Uo=;
 b=fcrZK2Nm+cYFkxx6KU1J0wULMPnWtwBAksfB8FudGbp+GtjIOqv8kAIZAWPp/eldKxfx3Z8qs71RfFzUqL/EWNbo2jTALlptm0k4+wK91rkgdo8IdXaKtXyD2hQVHaGKfEGOd8eS7MI0pMye9ETB2p80Yzpbd+LkWAzEcltan0Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com (2603:10a6:10:10d::31)
 by DB8PR04MB6762.eurprd04.prod.outlook.com (2603:10a6:10:105::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Fri, 4 Dec
 2020 12:08:17 +0000
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::a1ea:a638:c568:5a90]) by DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::a1ea:a638:c568:5a90%6]) with mapi id 15.20.3611.031; Fri, 4 Dec 2020
 12:08:17 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] enetc: Fix unused var build warning for CONFIG_OF
Date:   Fri,  4 Dec 2020 14:08:00 +0200
Message-Id: <20201204120800.17193-1-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR06CA0082.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::23) To DB8PR04MB6764.eurprd04.prod.outlook.com
 (2603:10a6:10:10d::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR06CA0082.eurprd06.prod.outlook.com (2603:10a6:208:fa::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 12:08:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 962c8ba2-31b2-445b-fcb9-08d8984d488d
X-MS-TrafficTypeDiagnostic: DB8PR04MB6762:
X-Microsoft-Antispam-PRVS: <DB8PR04MB6762D3F8136FBF382A75C04296F10@DB8PR04MB6762.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5KgOsTPoW0WQMlH6roRl6Ka6dCDqv5td2VDynCcyX1CvtIL+uhTzFiLEAu8ZaEI8ZZozjI7FYpA3Z8/7IKwyee2yhnsbd3tmBQXvPCcfQrJEwICAjBByJmZQBt2Y1KnZTl5Fj8fxsvfhAtq9xXDQElLGOF/j7cCcB6hDNXIuNEj0bQpNdtoiMwrJLL7lui0H0rsNlpnaLTYGH7C40fn+O/NWRDZ1i26PyzPp3GbJ21V4dEGgteyvEjWXtDYPJV4Cp4GPvxVjl7J0/vd++t9mJL3UwszJILYQjwKewi/ozGikH63L9qTrtnbbe+YgD3nkK6F6EF9De7le8e4V3umTLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6764.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(4326008)(86362001)(26005)(478600001)(1076003)(66946007)(66556008)(52116002)(6666004)(8676002)(36756003)(6916009)(316002)(66476007)(5660300002)(8936002)(6486002)(54906003)(7696005)(44832011)(2616005)(186003)(16526019)(2906002)(83380400001)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?AKvbALeMxKv5LVujVsaJShbOmrGO5w8a2Fj/IIy+ubIsyekL37w0gPJrwerR?=
 =?us-ascii?Q?lXCY8Z6Kit3AxVOWw9pIBf6fc2u+jEPyntPIZZ1+2nTTa8R5dJ7yiO/xiqfO?=
 =?us-ascii?Q?c3nFVEeE2e4vdxznr8FogzIh8H8uerIQsmgIFRz9ffImJXoafefAO5F/R8kO?=
 =?us-ascii?Q?JMMQBWcx3Oam8kXGDQ2L/DnzcWzVqpoTsFCjRJcOtmQK75eZqIHOoRkzxvH5?=
 =?us-ascii?Q?6QX9k++uo9oKJuFwfgiW68ApEqrGlWfs9suKh5NFACuApZVQlVY9wh9OoVXD?=
 =?us-ascii?Q?lAscEdLqpGEoho+/uPRPx8C7NNiXmbTXNxdSzW1QKmG/U43xxR0KuvA5Iuut?=
 =?us-ascii?Q?LZDrk+hCaPeUimHu9vWpK2k4tBa+gebIDysk/CPPyqUn92/V5cpXzQbOxmUf?=
 =?us-ascii?Q?NeT0j/nPmXqEiq2jbqF6GceguX5KMvPGBtb0Qt04OfaeBXypqz8nkVo69u4l?=
 =?us-ascii?Q?grXBtyW07Oo0fj//gTY3ZaDzuySeDKvykUkN82ZdDwLlZNvtmz1QXqB0MVL4?=
 =?us-ascii?Q?6t4kdtPzr6qT92k/esC1WMQR+rtW7wjrtQoV4jv9fR7Dh703B5OD8qK1JL35?=
 =?us-ascii?Q?u16j1OL7a1L1DQA4pQG+HauDNw7tNpN9kbyYl3COLylTgAkb0Wm1S2OKRuSH?=
 =?us-ascii?Q?NVw12vy2NqreBm14ock2es0nXrZRKQyBhXVH+nKvaSckyPgtDvB0TFc8ijcZ?=
 =?us-ascii?Q?Aj6W1OimtVCcfYeRiI7Hftem2d6QEo8x4Co0fD7MEkx6OhU9bsgAoy25+VOA?=
 =?us-ascii?Q?oAzVChN+o+D+rt5Pqg3glQL2olqhGbr7+fhqB651PLwh3RByIh7JXU9D0nQU?=
 =?us-ascii?Q?WI+Dw2cvlf2KIiRKuCN1pUEHJF6xIk7eIxp4Je28fHob3aRHiFBzg2FJhZ7t?=
 =?us-ascii?Q?nreTsPyTajF0q1cj/sRXccjeEJ5s/AER+XzQ2zenfCQ1amXbEI2yjfwX+gUB?=
 =?us-ascii?Q?Sj4TOAHxJdTY1EZwCjumAdW62VrUPAGji4XQM8FuE2q54gnZsYMPT1Dc2s+l?=
 =?us-ascii?Q?TdeO?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 962c8ba2-31b2-445b-fcb9-08d8984d488d
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6764.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 12:08:17.2422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O7ufVT1xUtW/+VpmaM4U/xXC3Lsj7KHvY50MHgeXXWBwvIfoSG1s2L3/pfaeJAtQ213mb7z0ZrKOg7PpFViUzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6762
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When CONFIG_OF is disabled, there is a harmless warning about
an unused variable:

enetc_pf.c: In function 'enetc_phylink_create':
enetc_pf.c:981:17: error: unused variable 'dev' [-Werror=unused-variable]

Slightly rearrange the code to pass around the of_node as a
function argument, which avoids the problem without hurting
readability.

Fixes: 71b77a7a27a3 ("enetc: Migrate to PHYLINK and PCS_LYNX")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 21 +++++++++----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index ecdc2af8c292..ed8fcb8b486e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -851,13 +851,12 @@ static bool enetc_port_has_pcs(struct enetc_pf *pf)
 		pf->if_mode == PHY_INTERFACE_MODE_USXGMII);
 }
 
-static int enetc_mdiobus_create(struct enetc_pf *pf)
+static int enetc_mdiobus_create(struct enetc_pf *pf, struct device_node *node)
 {
-	struct device *dev = &pf->si->pdev->dev;
 	struct device_node *mdio_np;
 	int err;
 
-	mdio_np = of_get_child_by_name(dev->of_node, "mdio");
+	mdio_np = of_get_child_by_name(node, "mdio");
 	if (mdio_np) {
 		err = enetc_mdio_probe(pf, mdio_np);
 
@@ -969,18 +968,17 @@ static const struct phylink_mac_ops enetc_mac_phylink_ops = {
 	.mac_link_down = enetc_pl_mac_link_down,
 };
 
-static int enetc_phylink_create(struct enetc_ndev_priv *priv)
+static int enetc_phylink_create(struct enetc_ndev_priv *priv,
+				struct device_node *node)
 {
 	struct enetc_pf *pf = enetc_si_priv(priv->si);
-	struct device *dev = &pf->si->pdev->dev;
 	struct phylink *phylink;
 	int err;
 
 	pf->phylink_config.dev = &priv->ndev->dev;
 	pf->phylink_config.type = PHYLINK_NETDEV;
 
-	phylink = phylink_create(&pf->phylink_config,
-				 of_fwnode_handle(dev->of_node),
+	phylink = phylink_create(&pf->phylink_config, of_fwnode_handle(node),
 				 pf->if_mode, &enetc_mac_phylink_ops);
 	if (IS_ERR(phylink)) {
 		err = PTR_ERR(phylink);
@@ -1001,13 +999,14 @@ static void enetc_phylink_destroy(struct enetc_ndev_priv *priv)
 static int enetc_pf_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *ent)
 {
+	struct device_node *node = pdev->dev.of_node;
 	struct enetc_ndev_priv *priv;
 	struct net_device *ndev;
 	struct enetc_si *si;
 	struct enetc_pf *pf;
 	int err;
 
-	if (pdev->dev.of_node && !of_device_is_available(pdev->dev.of_node)) {
+	if (node && !of_device_is_available(node)) {
 		dev_info(&pdev->dev, "device is disabled, skipping\n");
 		return -ENODEV;
 	}
@@ -1058,12 +1057,12 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 		goto err_alloc_msix;
 	}
 
-	if (!of_get_phy_mode(pdev->dev.of_node, &pf->if_mode)) {
-		err = enetc_mdiobus_create(pf);
+	if (!of_get_phy_mode(node, &pf->if_mode)) {
+		err = enetc_mdiobus_create(pf, node);
 		if (err)
 			goto err_mdiobus_create;
 
-		err = enetc_phylink_create(priv);
+		err = enetc_phylink_create(priv, node);
 		if (err)
 			goto err_phylink_create;
 	}
-- 
2.25.1

