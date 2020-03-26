Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41E3519406F
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 14:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgCZNwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 09:52:08 -0400
Received: from mail-eopbgr70054.outbound.protection.outlook.com ([40.107.7.54]:4353
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727904AbgCZNwH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 09:52:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrCtr1BneTuIsdhBdNdnCltZufWA4tdumXv2DrBpZ/SDFxKwLCpE3UfPDm807u9Am0KbikuKsazr1KzkapjsOwnTZJW6xRlr6Q9wOQZ835dR8BBnr/IZNWIceG1T4SgpDpARu6/JiZDvwVaq0VjoVFsssoH1d6RrggTHmLyJZYPYDhIxE0RR7Jixm1wPi5yvPtp/KEniSj0YHEbpjNQMIPdYnlQxeDyI2vBxJkknvCLFOfs/g9QCxsnduLxDPROtnoX1CwPD5t3i8mTACln0iBfOErW9BOfrHlATBa9nlLm4V3UNsAD+iR0/CgrB2/Yzq5yCIvVPCFnv/5P04ws4+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9u4rjTqPj5dpCXxPPN+Lop/Yuq6Yzfwlq5jqg0+/Q8=;
 b=jCgxEQBHT7EzWRsSGeTUQQsOxGXtIWgkOPATcnH9/zRou811pJ1vm7Y9RiuSOwBfM7NouWeOMd6xidbBPLTN0F/SuirnJ2FxfwuHGmFEJJyatVd+eB/tyj2id00rtXyZ/iZ6anAP4CSx6FWkWWoOdC/Y/dfF9m2uuOK4AyA4NxV1tcm2hTPQEG0mDDhAZPikr04KLxcK4nXF6mIBy9JptAxc4CH2q6QAwkStgFenAljaWu49B4LBL4Ugb7k6FTfLs2Y2mI7bHPd3qFA1zkl/gM14js/T8uuuCh/GW9tcGbx+v+wOEANQpFcMhhIl9PTjjEFTDi+ZAIs0l2Bd5/XJRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9u4rjTqPj5dpCXxPPN+Lop/Yuq6Yzfwlq5jqg0+/Q8=;
 b=UaJ0QzNhcEPxGLvYvK3lEUvgheR5/IqLBY5Qgvk7U8i7IkugxV+M2J5odFKOmzuY+sprcPxix66G7QEVCRixqCWGX8/AmLM45NHSmVMZLa8rQK0XlQGGWq7J74d6j67iL7g+UHmMT63YCqYX99yFo/iVN8p4BVsrAfYSj4ih00c=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com (20.178.122.87) by
 VI1PR04MB4272.eurprd04.prod.outlook.com (10.171.182.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Thu, 26 Mar 2020 13:52:04 +0000
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8]) by VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8%3]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 13:52:04 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next 4/9] net: fman: add kr support for dpaa1 mac
Date:   Thu, 26 Mar 2020 15:51:17 +0200
Message-Id: <1585230682-24417-5-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0142.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::47) To VI1PR04MB5454.eurprd04.prod.outlook.com
 (2603:10a6:803:d1::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (89.37.124.34) by AM0PR01CA0142.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2835.20 via Frontend Transport; Thu, 26 Mar 2020 13:52:02 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [89.37.124.34]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3f55782a-428e-49f8-b8df-08d7d18cdd70
X-MS-TrafficTypeDiagnostic: VI1PR04MB4272:|VI1PR04MB4272:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4272D143587139CB395238EBFBCF0@VI1PR04MB4272.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(26005)(478600001)(186003)(16526019)(956004)(81166006)(3450700001)(36756003)(81156014)(8936002)(44832011)(4326008)(8676002)(5660300002)(2616005)(7416002)(2906002)(66946007)(86362001)(6486002)(66556008)(316002)(6506007)(6512007)(6666004)(66476007)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4272;H:VI1PR04MB5454.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KmJ7V77qs6SXMyBy+RKhtaP1sz6bvGuxOzbYKU9t5CPuwVZ4w4x17cxXjqf/O3VzEfvMkvHwLSajX9X5MwNIBVIaqlchyfR1YGmBd4d7PfRD8x1H/J3H+817t67k7PKlxODwRZgu9wQjOOdf9zxrHY8kBgUahicRC16H09O56zcM9VrNX2ZmJJAIYnVfyIPaHw64G4sDUssrHPn4yOc2UghIydkRTVGF+cONTWN9WmCinp0cLpDGwqbN38d03dgvR/FpLuGvJuI0vPNgJIVYqye5KQnph70RVqDJeBmKimjLRKbO/JtmnLvBAZZNsJx09Y2Lt9U3sSo8W4FSzjeegNzKMxrydeKwy90NieGJ9X7+zja7ZVA3HNSk62H5YFU59EVuS015O/HUoeuHgz5uZseySSguFtBnJXT1wwQ+25VWHENtMw2X53/+RhHjbZbN
X-MS-Exchange-AntiSpam-MessageData: l0rwQfmhoI7uAr/9C+gOAlQrB91GysVWDz+TtkOQvgrZSRceXDdJWCdNwvSz55elTd3MhbdpN33RfN8vYiNZBMoZy2B8Fdt29sjDHQrN/21uPeUM44fh+s7LD40ef0/qZKhhLxV7BXFu2zMXEEL8UQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f55782a-428e-49f8-b8df-08d7d18cdd70
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 13:52:03.8922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S+bJpx31H1hDRU92XUBm6wivQ53mlUIokyHeMzyCVYPEP6SKU9Ph/gH8h262i6wEx1x+BBe40TroEfZTt8ZnNftJcl1hjw9Rxh8PCAQG4o4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4272
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

