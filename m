Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09E627CED3
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729932AbgI2NQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:16:00 -0400
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:52705
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725554AbgI2NP7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 09:15:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpX4TNyh+594rRS0+ASzYvbH2da1O9dIxdBGMa6LMrOe/7sLSKGK4+enbjDEotzSzNlJ8OxD4RpG2/YAJxAN32B8rvLxNZAi4YTi/tDgr+h3ORKkL7rjw+JKpFqxJp7gt5qpW2AHcC32TDavBE0xkdxyiLSeo54go669BIjAe2SMsjW7M0r4r/Aw4oYDdRwCn/AGmNxfKESW4Qv/yDtbHpQfR9kMvxEWVyqgovM9WTlj3dNBsj0kk1Jf258YDnM6/xwDLtonOX1bD1X9FLx6c+j5LrQQauGk/C2RSD6iUxXT4Pxx8ve5VKrpdq04bl1mwhAmMkBDgNNIv0XNVPtHog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7vltm/bJ+9JZXr4ZPK+P+mx4pvyG4E07xLm/hjBAug=;
 b=Wx7o+f6MH5QLxpPa9fYr4C332Akn4OJ6Hd42WqUzscuSv1GKjn33dkjjlYVZwdrb6/lAV7yTX8mXpxKnZRQ4g3bwcoisArLCYjfdzcJZDl2dKfd38Lvpdhq+L1K1+2rD9ltYPznk10LJ4EI3bh2vfuIkqtW6U3pG0S2SFKWTM4fhK7vWm56kx+7XH6VhVXtFlBkOcaAmjoVGYZ4dynt3Euapk0QV8UqSSs9iiD1modFHYTRBQLq3yt6ap5V5561IV5Wsl50R19k+LclT3Y/uMsu2N8A7b4y0BSNcjwTk6c1U6T9LU/NUTF/xDz/R+CiW2AQur9sYip0TOT15LYxbwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7vltm/bJ+9JZXr4ZPK+P+mx4pvyG4E07xLm/hjBAug=;
 b=gdIYxWeLD3qM/fdh45/k2oPVaA7YrTubtVMRBrkdLUpuLDmODqOOvBgwGZDNHNDNV5TD4nmd7Befq2c939Prs6BLMkg5hrcg1C1RC5jidt+gtYxyQYi/CL5EOEgRtES77/o/VuAAJOk1mHU1eRE96WZsRZGoLSHuLw1Cbmnd6Fc=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB2967.eurprd04.prod.outlook.com (2603:10a6:6:a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.28; Tue, 29 Sep 2020 13:15:50 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 13:15:50 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V5 2/3] can: flexcan: add flexcan driver for i.MX8MP
Date:   Wed, 30 Sep 2020 05:15:56 +0800
Message-Id: <20200929211557.14153-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200929211557.14153-1-qiangqing.zhang@nxp.com>
References: <20200929211557.14153-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0189.apcprd06.prod.outlook.com (2603:1096:4:1::21)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR06CA0189.apcprd06.prod.outlook.com (2603:1096:4:1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25 via Frontend Transport; Tue, 29 Sep 2020 13:15:48 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7b1bab17-3ed9-4a34-2412-08d86479c8d8
X-MS-TrafficTypeDiagnostic: DB6PR04MB2967:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB2967924ADB3AE28E2347F22AE6320@DB6PR04MB2967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uFpr0HBHer9q7E/1RrNiGuaclSW9YJ9ho9CqTDs21weGfQpZ6YaeROOGagRSrvtJR3Zm7wlb2I9E7sZvCeY224LuXzJslbm3ty7q5ZUg2ZjAVxEfTL+FFGbUhlQiSnhdEX2hsvomuSdIDs49dy9oNb7a0/c3I56DNm0bLSrvj0qm/Jp6Xo9LgUsW/wtBtsO9+A+y63MoMl2KgUC9ncehucnM8f70gSCaiw0VUmqRtCS8A4T8fYQHKCPhR/5R9rrp79+dg/smwirubGq0dMIlNCmCa/I8qj+TBnP1nMOSJ74syityZMt7Jt+Vrp+tJ5Dh+7kZGGYReJW0h7+wk2IRlVFB5BOxNBaOIHRMvx19TBN8pd0j8kC/P+/kUm7tAbXIoximKKJyKZxABch7MJ2P2csmNhJ3Q7ukJXpVfrmKUsChYIgHWXs0KdokxCohyeAR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(376002)(39850400004)(8936002)(4326008)(6486002)(26005)(6666004)(66476007)(2616005)(956004)(66946007)(36756003)(5660300002)(6512007)(66556008)(2906002)(1076003)(16526019)(186003)(86362001)(83380400001)(478600001)(8676002)(316002)(69590400008)(52116002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: S6UgFmt8g3jLPrEhO6JbyaeYCLkjaAEeSRpmA3KF4wCyuIzVK48n1pNRTtV2qhPl0jbdYqKXaoqIwH/dl0tAR3CGUftKMc/ZZe0eAXt+2DonpenQ932BhqkRL0PIdx1Idvel6B9f3nlljdV4wIGnbV6M8UoHqvIq4y+zOTrJ1LzHFNkM6OndmS95dXUWiTowMbnuo8jtCAks5M6oZxO6jYE8Kr8P9vREBG6s0LLt7QuCtuAMJsBE21gZbiznYIFeUssPpx6tD2xS5jJbbFEzwiBp8ipl+Ho3vBkZx2iTQ/twXeWpwC/xw/CcArufOnLJowxTJaozXOvXqNGyK7xi693ruyMiJCQwInhm9l3oJ2Uk7/YgTfmU7zsotM0qdG5JCVz+lvgwlx4yqPivlZZqF/R76bnngfOAzdkSIr5qLpw18A6IQy1CnbvR5zlG69PDN9Gt/mHF9BvaG7zwSF6WNh4LqTK5z2FNaIPAbf9CmdFWXyOSCLTAvVR91h6WuKbWTzY59wrYPZh+OEfKcr2eCY5hBbXmT8KCvhu8/+xa6Re14r3o9bLOFBWWc7NR1h1lK/B1SamGcGgjPFuNZqiGSTBPVbesgoWe0O3mZP8LFEvSXsq8TiGUw5h8CcNshlQbeW1OZUbjLZMCQUGVydxJ+w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b1bab17-3ed9-4a34-2412-08d86479c8d8
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 13:15:49.8842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Di2FNMVkajO1PQUAivqI9uXhhuiUTkSjRx9BkuFkUA5VMsxdqEiJW3XfSrXXk/XCh1X2M8O7TbmsvMxhuFsQOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB2967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add flexcan driver for i.MX8MP, which supports CAN FD and ECC.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
ChangeLogs:
V1->V2:
	* sort the order of the quirks by their value.
V2->V3:
	* add FLEXCAN_QUIRK_SUPPORT_ECC for i.MX8MP.
V3->V5:
	* no changes.
---
 drivers/net/can/flexcan.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 8e4c27d9e1b7..1ab12774cbbb 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -214,6 +214,7 @@
  *   MX53  FlexCAN2  03.00.00.00    yes        no        no       no        no           no
  *   MX6s  FlexCAN3  10.00.12.00    yes       yes        no       no       yes           no
  *   MX8QM FlexCAN3  03.00.23.00    yes       yes        no       no       yes          yes
+ *   MX8MP FlexCAN3  03.00.17.01    yes       yes        no      yes       yes          yes
  *   VF610 FlexCAN3  ?               no       yes        no      yes       yes?          no
  * LS1021A FlexCAN2  03.00.04.00     no       yes        no       no       yes           no
  * LX2160A FlexCAN3  03.00.23.00     no       yes        no       no       yes          yes
@@ -391,6 +392,13 @@ static const struct flexcan_devtype_data fsl_imx8qm_devtype_data = {
 		FLEXCAN_QUIRK_SUPPORT_FD,
 };
 
+static struct flexcan_devtype_data fsl_imx8mp_devtype_data = {
+	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
+		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP |
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SETUP_STOP_MODE |
+		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SUPPORT_ECC,
+};
+
 static const struct flexcan_devtype_data fsl_vf610_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP |
@@ -1892,6 +1900,7 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 
 static const struct of_device_id flexcan_of_match[] = {
 	{ .compatible = "fsl,imx8qm-flexcan", .data = &fsl_imx8qm_devtype_data, },
+	{ .compatible = "fsl,imx8mp-flexcan", .data = &fsl_imx8mp_devtype_data, },
 	{ .compatible = "fsl,imx6q-flexcan", .data = &fsl_imx6q_devtype_data, },
 	{ .compatible = "fsl,imx28-flexcan", .data = &fsl_imx28_devtype_data, },
 	{ .compatible = "fsl,imx53-flexcan", .data = &fsl_imx25_devtype_data, },
-- 
2.17.1

