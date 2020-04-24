Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CF31B75D0
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 14:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgDXMrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 08:47:08 -0400
Received: from mail-am6eur05on2079.outbound.protection.outlook.com ([40.107.22.79]:27744
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726667AbgDXMrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 08:47:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CZ1i+mUr7ltz4eOZV1npWEzCpY8pi5P7qzPbEUGIn7wkMXpGQVGRn5hBb6gjQlDvfBRlQXkaqS3UNJksFzpYlcHL6mFLShaD/BlawWba8v7h11IMyjgDtcUO67AU5fY5Mqz3YCGjZprfzN8bi+Jt0s6F3+xB55OwN4Egs2okHndUfwfX4kok0T1IUUCGsEjD6HEow2jUBAraQ7KNGjfcnudEMUxfB1pR5+iBwPr4XgnUyhkVmAnjjNGI93/86frXAeBkTDJ74UQXH0Y/jAlTrSm2kxeXo7qPDVHVNkvBfLyMF18R4c58Xpxxp9Ro9/4Ll5qJsjiOV8X2GdL4ZuSvCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRuF3BLZQioAelCw26gmOw8YNyYyriKv+g8xotmbu38=;
 b=OdO08uIGpK35NX3lGLim5HyZOlr0R6dWOZbPZn73PG89CL892HUvO2R2sKHu8MdrKohrBPNnERQP4CDbVcOZHQAfK8ej3dsOV7gcCq3lyVU/rQJazmKAWCZN4lDlT4V5f141iU/QMO0+MY/55HxqP7F5Dhm7H4J4RQrR+4upTS1Wd9vGeF56LskCDi7xIHUvibgGIVU1JROa1D9onxhreT3cT45BUdvyntAJVPsTd0vcg1WGDQ461jHr0rWXbIZQRLk8XfKuYH5irrFWq6DJt7AQj9419adkShrFgFlI2e9SBKFbFSTrjVTtHhDEexti53LyJmomKUz30EPI95G3mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRuF3BLZQioAelCw26gmOw8YNyYyriKv+g8xotmbu38=;
 b=QPhIP5GTVIgLqD7pH4vmj1nXa/WfJoLJTSApKRgD89tbrT5vXtHaeBzugVCS/Gpge9wRHpVI07R/VGgc7KsRBX/erqRrniqYqN01kBqMM+i6JFz+rpD0xHB7uUbBlCkLaRMzTbNaSxi1PODBO27SPkJHyW+EGTTss74EB2hZw7U=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5937.eurprd04.prod.outlook.com (2603:10a6:208:119::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 12:46:47 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860%2]) with mapi id 15.20.2937.012; Fri, 24 Apr 2020
 12:46:47 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next v2 4/9] net: fman: add kr support for dpaa1 mac
Date:   Fri, 24 Apr 2020 15:46:26 +0300
Message-Id: <1587732391-3374-5-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
References: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0025.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::35) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0P190CA0025.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 12:46:46 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e9b03577-d9f6-4266-16b7-08d7e84d8d12
X-MS-TrafficTypeDiagnostic: AM0PR04MB5937:|AM0PR04MB5937:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB59374673660CA96EBE7E53C3FBD00@AM0PR04MB5937.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(52116002)(2616005)(86362001)(44832011)(6486002)(2906002)(8676002)(4326008)(66476007)(66946007)(6666004)(66556008)(54906003)(8936002)(5660300002)(81156014)(6512007)(3450700001)(16526019)(956004)(186003)(6506007)(36756003)(316002)(26005)(7416002)(478600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C3FOXkYZkRrMtgQohC8tgf++8bTfPYvx7gfw9Ql3dAQRL3MOe4FwnsmlFRyP5q4WUMFc3/vDYG2sSIEDxFZxGATUp/3EvPfCqluVyReR9qtf/sK+6iQQpGv/FVpwiyLCuimKSzG3j2tq8e6vVLdBwNpvcU43iVov46pio/69M0mMRBT82IWl4UcOgjfsoRnSBv/QvQWxsCj0iOU4frQsZmTuvwR+qlcggdEZWuZvNE44LEHdNOyG9RIyHuJQbvkhc0XRiwkA3Yhw3nA4vBLyakOTAv/qWtOPdqChrE2zIdIMeTUhy44+5djnPP0MnC7noFlMn5C3VhdXNdeqS9mLyqubXdBF22fmCZtYAIzCMOtf19LS+x4N8a/oB2Ul9Y9A9xY7iytcS24f9jyu/6RbsoVeZxUCrC0qOMvXryO8M/xqasnF5ghwCrYgIvwnX4uZ
X-MS-Exchange-AntiSpam-MessageData: Qw+WH4hTQ8Mjd/vwNiI2UGLvQ0ROcM/fv+/awignaMg9kLkzXJf2cdFiBlPmKRvPXjqnMeN+ZUhBvU4jUQmOtA0/wn/iIkm3d3lGqWaaRKp3D30fL2IlO3uJHfXXsr88eoqiHt7XpsvNauF3DClu8g==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b03577-d9f6-4266-16b7-08d7e84d8d12
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 12:46:47.5381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oxn/fnQwfhYeGe1mzdCdrEXGR5Kl5Acw2crTh4RVxq8rW//6wcI9NwuiS9SOzFfVZXlbMZimMTyfGRuBOFA2nPA7soW2RJBndVn3vfm14l0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5937
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add kr support in mac driver for dpaa1

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
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

