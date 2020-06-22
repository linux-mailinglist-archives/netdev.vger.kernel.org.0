Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF52F203826
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729116AbgFVNgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:36:15 -0400
Received: from mail-db8eur05on2055.outbound.protection.outlook.com ([40.107.20.55]:24081
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728431AbgFVNgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:36:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKQZjv3PXhtwXB4phH2SnBkYrPcuokOJjJiuSL0VvnSrlBmaHvFGbIS0ixW+rx7kzSFKzz198hvdhsPtlOGDVJBEGgesuqU/hNn6h+vASzR9WXj+h7hUvpwiXINf8AYdmKPRllbwufH7m6xqePjz7ULAyYLngVAUqlZG3o73Fd68GRnQo6pd9RpcMIb7w9URfPSm8aQVPcKJtBYO62l9jES834zN3y4QbjPilyz4W6grz29HXdHl2zBMMrNEt7ZnxtAWy5HCl1Jc8slbOSrZoM26nt2EQQXEK0Rvo7hDa8hZi3QhQngdBEOA/dV7kQfiaXE5P43Vii4UNj9V9ia6FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9u4rjTqPj5dpCXxPPN+Lop/Yuq6Yzfwlq5jqg0+/Q8=;
 b=K/H9pzo3wnIXwaBscfFRciovvzW7y7XG8p7RxoHn0hEMScg3sppgrOv1vj7CH8zqDEpnWMrp7J1qycO5G4/kPByTJ+wQAdCpr8bxh95ENmeTHXtoteK4IiOVQaBJ6we00TpaiOYvnHHuHjq3mVP89iya7d8VJLkBSviXX2QcuQocLYxOMs6/oUlN44Ln8GneWyijpnsApC1/Mo+lQ4Kfm3/ca9wzPjHjPPGfuyxsUqML0GaoxW+hZ1ATbZd1LXaYagijTabYbPgm52Mwu5OGSfS4QIBBQZ24OfBUIcHhWNh2gQnJEqTC8hwE9n5JxP2mrYLbSrSxzG16qxO4dKwqKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9u4rjTqPj5dpCXxPPN+Lop/Yuq6Yzfwlq5jqg0+/Q8=;
 b=U5KWavIT/7vCM1LLw2rOQx3E2NYsGAD5EHOAZb5wuj6en4RXGIAGKGbknREHAUjdTrmPRHY2R+5xqUuiyBqCAbhJXZ2yAttOtsUCZ/dIQrtV3rN3f6yCYY8o8Xzy1x94PCS5DSnkyBcFbW7zFQiDx9lpz1uyAftiYQ7HyJhwY2k=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5075.eurprd04.prod.outlook.com (2603:10a6:208:bf::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 13:35:55 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 13:35:55 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next v3 3/7] net: fman: add kr support for dpaa1 mac
Date:   Mon, 22 Jun 2020 16:35:20 +0300
Message-Id: <1592832924-31733-4-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
References: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0086.eurprd07.prod.outlook.com
 (2603:10a6:207:6::20) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM3PR07CA0086.eurprd07.prod.outlook.com (2603:10a6:207:6::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3131.12 via Frontend Transport; Mon, 22 Jun 2020 13:35:53 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0f5b9d7c-ffb4-4959-11c5-08d816b13049
X-MS-TrafficTypeDiagnostic: AM0PR04MB5075:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5075D744825EC2372176F807FB970@AM0PR04MB5075.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0yxe9SXwJB4dsthxN8MiEl7C4UuOl9TQfvuu0LHKeLJkfHkB35WwqEdFNnYqA3NQJJFmF+p9qVDlbQVWFYZwjTbibQ6qBg9QLVYd6/Hw6ywxj9JqaEj9SxKO98Vsei6KkYEJqIVEROeBMU+Gp9MeO2IXyp+pkkryl3KFOCyIE/WA/G4miVR1AJiOMt2+sFLvof2N8mixHNNKziXqzEWrDKiiDy/zPAIux2SivqYv61rLZHMoo+z0wTBPULpDUPB5MUz+EdPpyR7njPcE9ByFJAtVhmZMOLE4DKoZfl4ksaHZ6KIdptrBD/7OafmQzV034tHpFaGQptG/O3jRVcjZKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(66476007)(66556008)(66946007)(83380400001)(5660300002)(2616005)(956004)(44832011)(86362001)(6666004)(2906002)(8676002)(6512007)(52116002)(16526019)(186003)(26005)(3450700001)(6506007)(4326008)(6486002)(316002)(478600001)(8936002)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GuJcJvxxWQz1ozPg7xQxDec0ADsgHNDCmhfHZDIwf9seomii72ipLJyK2wN15uYkQxkYPgPxUe0twkXZ/IU0X1YFIBvrtkqs1KPOuOO7MJ0dSYAUABUs3goUsmkDJoxdQ5pVoCB1GiIpZqlVNha205qvfub3ofNaYAlQkVfHCtIwkvBWJy0NtenWDQQ0jn7l5nsThj76eCvT2O5By9de8C+GbpMFDEUa98tR0ZLHLM7P1Z7eJUdJ2drP2nmrVqLfYsgCYHGjpvs9g7+Z3BOtnJK3qpNDCF5VBTdv0KcZc10+DASIW5w4rYDyOlo1XVWSSngnKsy0OXjNAoxK6pss70aze9qdz/hma/Q/2wYlr5RSuLHFwer7I5FRJfkciN2Wf+jgiAShMGNk2kr8LYTjjlMXgO+3iwoqgiHHJMy9yQCP6TISl9e9cP4xULDngIH6EF6te/GmFBR/LxOS6zIGMi2LN9XZhIGroAqy8612WlI=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f5b9d7c-ffb4-4959-11c5-08d816b13049
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 13:35:54.9531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4//vHN2et8FpriLa7TDdPaIFyF1AgmVu/jylKvQH7/N+aKVWPagXH0Ef72AAQum8Hf821LAG23l5YhWHzgxYrVhjUQOzTUmtJv+57MbQORo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5075
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add kr support in mac driver for dpaa1

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 drivers/net/ethernet/freescale/fman/mac.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 43427c5..90fe594 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -1,4 +1,5 @@
 /* Copyright 2008-2015 Freescale Semiconductor, Inc.
+ * Copyright 2020 NXP
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are met:
@@ -220,6 +221,7 @@ static int memac_initialization(struct mac_device *mac_dev)
 
 	set_fman_mac_params(mac_dev, &params);
 
+	/* use XGMII mode for all 10G interfaces to setup memac */
 	if (priv->max_speed == SPEED_10000)
 		params.phy_if = PHY_INTERFACE_MODE_XGMII;
 
@@ -540,7 +542,8 @@ static void setup_memac(struct mac_device *mac_dev)
 	[PHY_INTERFACE_MODE_RGMII_TXID]	= SPEED_1000,
 	[PHY_INTERFACE_MODE_RTBI]		= SPEED_1000,
 	[PHY_INTERFACE_MODE_QSGMII]		= SPEED_1000,
-	[PHY_INTERFACE_MODE_XGMII]		= SPEED_10000
+	[PHY_INTERFACE_MODE_XGMII]		= SPEED_10000,
+	[PHY_INTERFACE_MODE_10GKR]		= SPEED_10000
 };
 
 static struct platform_device *dpaa_eth_add_device(int fman_id,
@@ -795,9 +798,12 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (priv->max_speed == 1000)
 		mac_dev->if_support |= SUPPORTED_1000baseT_Full;
 
-	/* The 10G interface only supports one mode */
+	/* Supported 10G interfaces */
 	if (mac_dev->phy_if == PHY_INTERFACE_MODE_XGMII)
 		mac_dev->if_support = SUPPORTED_10000baseT_Full;
+	/* Supported KR interfaces */
+	if (mac_dev->phy_if == PHY_INTERFACE_MODE_10GKR)
+		mac_dev->if_support = SUPPORTED_10000baseKR_Full;
 
 	/* Get the rest of the PHY information */
 	mac_dev->phy_node = of_parse_phandle(mac_node, "phy-handle", 0);
-- 
1.9.1

