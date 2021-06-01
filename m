Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD0B396FDA
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 11:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbhFAJGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 05:06:36 -0400
Received: from mail-eopbgr40044.outbound.protection.outlook.com ([40.107.4.44]:48470
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233658AbhFAJGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 05:06:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SV9rncMYc6KnX/x5stpndA35bKfsLkj5ceVnrAsVxYrO9SoR/A0QOMUieoVeJSZLpuTxAM7A4U6BCk3hXrKxFvWbmj04h+G0soIP8404oReMNcHTdF4Bykw4tXOOuI/EPmroD4JOYdzVhJEB8NC/p7qfS8Oay/cT+FBuBcYN2xH5nraI8Xd8LrXm8SR6JYMGLkbpkpVaqFh2N6SgFsCAS8tuDtCnFAOQD1R36WgBtbE8UMT+4iCEDtByMg9bu0Xo4lz/oqi13q6cbbOC3VApHq49CMsCnlG3F9qTwSxpK+1XjkKhhLfUZAdBaSYAdyzrLKdmhsWmczMQc2nADTuA2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r/hqRBmKdQu0MkR26jGdW6r+aroBnOiUnGLlO+foYYs=;
 b=AxKCx+iRF/u0r/HX0kUZK10wpS5LhtVABOIr4eE9Xk2FVHbisE194OrIWTp+nir8dpLKHc4J0HNPKAed0ZiuEO9o6qR1P1b0wRSoR1G3wZbDIo+qAxe5ln1scY9wXUfo9ZiUAm8QIYbq5WpF6xZFK6sraJ7JhQXtE7Eb4hZ85YrXbAhMoUSpynH7IhZM+XLtzq9vE9+Na4YU/iLqKJ8AOHdTb35mfJbnBRVZRnA0LrHo6rfgDfAi95GK0re0awk7GjGkmQm/dybQxqM+643hx6YFrqESvv4gF5rvZfzkVf4zHsinHPeY7046cfzup+tWzLUGyJ1KsA2OxUI6sj+Slw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r/hqRBmKdQu0MkR26jGdW6r+aroBnOiUnGLlO+foYYs=;
 b=Xbh1+IdsLx4TbQqpTSNCirn82Fcw7DZCc0ehI6pTnNxfUyYCnzd2mea2Hyvw75lxj0PLi+txM8HfSVTj8jyKez8YBcEgiv9q40M5CAB0GR9XwLljgCewfDUvQ8Z1GKaXe9E/GlYFuNTKVpsTOPvHfzJejrH1HT/MKitVKkz5To0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Tue, 1 Jun
 2021 09:04:50 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 09:04:50 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/4] net: phy: realteck: add dt property to disable ALDPS mode
Date:   Tue,  1 Jun 2021 17:04:07 +0800
Message-Id: <20210601090408.22025-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210601090408.22025-1-qiangqing.zhang@nxp.com>
References: <20210601090408.22025-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGBP274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::25)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 09:04:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76956b38-1cf8-4f1f-1e3a-08d924dc503b
X-MS-TrafficTypeDiagnostic: DB8PR04MB6795:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB679545F6382E3046C90B55DEE63E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4CQeImz/FRqXuBTwt6M4VPiwoGqxzL8n/6AXc0+E1BcAZnxLtWKxWBX5uRfdycXUsiLtg5CWRWLZBvLGziWTU05a6igVHY+jpQMjnXVuSDkiFtH8UwqdU0vJj5cg8tLtqtqkVRef7XN2c8aTaa0c0mQzrSddfToUccByAgc34nRJ5pP7YTVjKpmZEJd4yENsJObq/BdjNO+9Gz5mjU9rfo0y7/0NK9dG8x/t3C8MxWU5CxT0Xo5YzfqBqMeGuGkg8YAhhA3B0kPEEhWqAcnkZA2HDZPADGMYcd6IrPqAdxoDLd9UfzKwjKtAFWpkLxAEyt/MvlUSIj+3ADtBCYezkDCZ86PdO+Ul7I1KoK+lbqlVRjBxbBj4c1SCj/vgopt6OBojojs8hIW8BQCOBfaw1FX1Vi9p3iXcWrLAViYoQow4sh4b2dgPa2IcVsLOctTagKQXkeCpiks81FC71uc2M6ECV4PM9KeAASnB09sKblcrPDHO6SXFURx+XxWYoX4GZUgll0uYQy6q8HBPZLiv1q2BE7YzZJ8O72ZnuGN4gqs2B2osPntxZli6t6xMXazJvbervfopobnhT/DrnetAU1GW8kbTH6fXor3amuz70OfEeP3swQO+3gE9eE/v6P2+9cWcXD1Va6Ibu+yY+Pnhx8Bd7lbf3jPvmCMMeOQ7nviIhYQtbfBizXrwe0OMgoyu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(39850400004)(396003)(136003)(66946007)(38350700002)(8936002)(478600001)(6666004)(36756003)(2616005)(52116002)(6506007)(2906002)(316002)(86362001)(16526019)(6486002)(186003)(956004)(38100700002)(5660300002)(6512007)(83380400001)(26005)(1076003)(66556008)(7416002)(8676002)(4326008)(66476007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gKgVtuMKz0qUt4BQN4OkUhJHBl+NniIZ1kD1dvKiM+3iWfuYwD0OS0HiVXOV?=
 =?us-ascii?Q?YTgxULMWPrUoOKHR39PgSww8/h6dQLIxbQPNGrkf5GqlGJqkLM0PMYzM7RTM?=
 =?us-ascii?Q?f1NFEdyXvqWLxKaK3QYQNuEFhxwtozE7exyiOg25YN5WVglBvAdMoPk5BnU8?=
 =?us-ascii?Q?oR1ylaXU6j3rYP3ti/KvCt8S4sRICrNpXVNj1GKRmS7oJY0ZG1pxt/ynLuyM?=
 =?us-ascii?Q?ND5iGgDKMv1rPdkkMz5OIhT1d/0WzsSnV2+MMkFOQ16xUDsxB7bAI4gvkteV?=
 =?us-ascii?Q?d6LkXQpfMMP9mqooMX4jxNe+ze4ANgRkbCPdABZDx5YtPtDybaR8/yaJXRaC?=
 =?us-ascii?Q?kCNGGZspnKCpDuc240uUTgZx53lvy3d+KUKnRC9htav9ffaBOfgbdUCOl0X/?=
 =?us-ascii?Q?RcIAXOsVTejadImEnEFXhpPklCuXOxubmBcBq5UPnrp18i458cOW6Vn/sHK5?=
 =?us-ascii?Q?yDHGu9RG97djqIYWHmSotey5h32wdW+GmMaJs36WVo5xnE1pxTlDzJiDHqtk?=
 =?us-ascii?Q?ctFL5E4pECpS/bLxWnhbaGEVvSi13WpfRGfo5JB04V+gHspfbUFDPmEoL//4?=
 =?us-ascii?Q?UUn6CKMgC9ErTiAINLjkLakvVvnrn1tb9KxcvicUCV3B10cvW6VY6nQB+wNi?=
 =?us-ascii?Q?yR0VSlAcFf6Tmj/0w7tOaxrRCxYza9WwL9sF8ARb926pPNvijBaP4PFrsKkR?=
 =?us-ascii?Q?vXIAD4VV8jU+QTt/DEAHtWV/iS4NwDPhwSLjVk2iO7XAwTOMv62mh3CCnehI?=
 =?us-ascii?Q?Y90DoDyoX1lOK2degHtNYCDIz6m7j/onJIZKjkWIbG1TW3TWhoL9J19MsYpc?=
 =?us-ascii?Q?DL9aobxiLEuogt38Qr4NGuX/q8ODs/rtME94GxNX0qqobf0N8FMWHIIi2aUC?=
 =?us-ascii?Q?J9V+YOUu9ol9XnIt4KMX0aLYX4bP6jVHSxaxE+05CsTBMT1saZxckf0dutck?=
 =?us-ascii?Q?TAKAAubszSyByXEOqTLNaOBkUd+V3lGokUNZ1SlPSTbEcLenU9tkhhDVDKK+?=
 =?us-ascii?Q?T+MwxkEdcaAG4G43ZkgemtJGId1hMkXrNH9I7GQeOCBArHXKQxPke2k6YLGd?=
 =?us-ascii?Q?SDJ6+1q1KeEoqwAXYhWtto9/heGwf0yQvbmPwZgQrXooDZUSCB+jygOi9q/9?=
 =?us-ascii?Q?Db89AqPO2xCMbBFR1fTTVN4mHyQcJq5pHlfixiFkqwrxzMsJPmAMd7CNyTFG?=
 =?us-ascii?Q?JY+1pXDbx3Oy0nYQYog9fJkYkNdzolkjVuzbGxkn0EwZxv3EK3asynhQe/9h?=
 =?us-ascii?Q?8mv6mJNsJzNmhhHL0L5etlVkcogeS0Ow4ttfl5PB+kQx5faztD+zyyd3mjK0?=
 =?us-ascii?Q?INm6rc3U0SEXBR24Bg+sRtVI?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76956b38-1cf8-4f1f-1e3a-08d924dc503b
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 09:04:50.8814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: im9bJpxG1Q142cLUS3Ktx6Zy3AQT0gsdbFNLpaOeeCuCnfP5Ff/1YUHFx1v6MWgnDDt1OR85s6oOc5VYnZYfsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6795
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If enable Advance Link Down Power Saving (ALDPS) mode, it will change
crystal/clock behavior, which cause RXC clock stop for dozens to hundreds
of miliseconds. This is comfirmed by Realtek engineer.

For some MACs, it needs RXC clock to support RX logic, after this patch,
PHY can generate continuous RXC clock during auto-negotiation. This patch
adds dt property to disable ALDPS mode per users' requirement.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/phy/realtek.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 4219c23ff2b0..90e3a8cbfc2f 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -73,6 +73,7 @@
 
 /* quirks for realtek phy */
 #define RTL821X_CLKOUT_DISABLE_FEATURE		BIT(0)
+#define RTL821X_ALDPS_DISABLE_FEATURE		BIT(1)
 
 MODULE_DESCRIPTION("Realtek PHY driver");
 MODULE_AUTHOR("Johnson Leung");
@@ -104,6 +105,9 @@ static int rtl821x_probe(struct phy_device *phydev)
 	if (of_property_read_bool(dev->of_node, "rtl821x,clkout-disable"))
 		priv->quirks |= RTL821X_CLKOUT_DISABLE_FEATURE;
 
+	if (of_property_read_bool(dev->of_node, "rtl821x,aldps-disable"))
+		priv->quirks |= RTL821X_ALDPS_DISABLE_FEATURE;
+
 	phydev->priv = priv;
 
 	return 0;
@@ -325,8 +329,10 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 	u16 val;
 	int ret;
 
-	val = RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_XTAL_OFF;
-	phy_modify_paged_changed(phydev, 0xa43, RTL8211F_PHYCR1, val, val);
+	if (!(priv->quirks & RTL821X_ALDPS_DISABLE_FEATURE)) {
+		val = RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_XTAL_OFF;
+		phy_modify_paged_changed(phydev, 0xa43, RTL8211F_PHYCR1, val, val);
+	}
 
 	switch (phydev->interface) {
 	case PHY_INTERFACE_MODE_RGMII:
-- 
2.17.1

