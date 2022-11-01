Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F08A6149EE
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 12:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiKALvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 07:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiKALvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 07:51:03 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130082.outbound.protection.outlook.com [40.107.13.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331381B7B2
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 04:48:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XoZ8s8qGaR5raDN/b+eh+zn+BgIHjuQyieUhDM+p24iHHtgMuXlgkl8SJy1XCN+HryFpZorcjK9xgYdnlz6PpeicPT/fe5jVzCaQPS4LWeu6RrXMXJvAGQNTDRZMj7qvjIlgY6CH43GdrPYOVi58KS6ZiclShp7WF05PuOOK71Se7eaQOPt5OYJpVW2hH3+bhB+K+ohhjeIfYOhKCCw71T7507UbGqQrSc3q2LQ/xCY2ssgKfBtRI3tXVo6AJJ7SGAaQFTfEKa11da5fWVbuE1q+rOLJfPs8lZBLQGJqftuaP6sbzP86FGpUvx6iki29McTTsV7wU+ptwp1/IkbhsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nq5KDD+KsW1fy7o6yUt1lfCtXnSfJHCe9lhnhoUXJ9g=;
 b=aIh+tLJhQZBOYOMy+DlX1jbI1mAti63sOXG75KAQUPXiIANbWq/VFAcCM5dPfSuUvuYtBEfoECzhCVJoGqFdxszIlKqIPJPz6jFkwIyMTrwqGUvT6des3Xqv1XH1XMprhPm3AHopBlAEoZSlf1tlcXVZatNUQpoQBTE6pMNo9zuCg4NR5rqSPEWU0DGtM+tyoK/9M8fUd5GmHGRRc2f73Ecjl8URUCghCZjmRmk+eDueij8NUEhkjvOU364JollLkZQd40iUFbrmN5f5NHxcb6eH7hzbvb5nvJOQ5i/yxzXznmZ+YEzfsjSnQ8a5oovP3GqY7z3Qwq/ZwPuVvLe2Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nq5KDD+KsW1fy7o6yUt1lfCtXnSfJHCe9lhnhoUXJ9g=;
 b=F2IXBbKX0TF+GLJ4m4t2bdZWCS0vf5oakJ+PlYFRNFBuvvcy/OLmOOqMQoHslhGU6lqxB2A1D6HTfAj516wO5IUyhYW/1hl4mK9qaamPfwSqvIXv8+nWgB+ayvupx7E15W/i/AhZlfer4cKrdbutw++zxVWruJAPwNx6ARWwwbs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8453.eurprd04.prod.outlook.com (2603:10a6:20b:410::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Tue, 1 Nov
 2022 11:48:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.018; Tue, 1 Nov 2022
 11:48:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 3/4] net: mscc: ocelot: drop workaround for forcing RX flow control
Date:   Tue,  1 Nov 2022 13:48:05 +0200
Message-Id: <20221101114806.1186516-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
References: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0057.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8453:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f3e9da6-5da1-41de-9a7f-08dabbfefe35
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X1+MXVKeaDOnh+UUOnPPp3rCCVvj71Qg7n0jHR/VuzxESm9K7utfXEYSZnqBOcaw6XjlmsDHaDZG5LgZvy8vYKXqf2tKFsaF0JEsDpE6Cxv5yAkvIUyG6Bh0viLabb/g1WFkKjvlia6vRgEqOWPaPQUwHVnSLn8TAEo6Vv4lCmYka0cYBMwUHEZE58bQJnJwWbCtkLxVcDEsom8jGMyAFg9WaIs9ls1JPc1FEkdR5r0AtmTWe1cj1SVb7oM83GWJlae+krQdeeFj+r49hFKRvRzRXcy53cY5jlqtDzMipX51eKzf0zlq5epmZAvni8tTnff3v3vdlZy7R0HNOKSL8Msto66aLHph8lu/k3sTWFZg/fEKQyC0rtqZEaXCJ7Jc3R3PTzdSDS6bX5n8YiiA1t8Gx2kgERRYS8DEUhxw0rDSog7aJvg++50R/XR97cc9NXOx5UbnvBpgUnxSi/75VkPIX49l9xbfKgRDxseYw84nUadgRxO/UhQCd0JSqwmNd4w4l3PfRACOGMKvRjemIn4uUzPX3Tu4cOENVq9tCbkdZPYns5iyuldAqk1l1wJUASgFLlkxagYqk75MkhYU5ZQiv1RlIEQKqDsEMBeT6cjzuZvM8U3IvR+O4bSZ6cVJUPGWieKnx5TGfMxvpZrFJ/jG8xupMKs9JcDTAwUjK+KQ9yMvPCnhPtHY1IkzB8QYQsCu2TpFGSAG7+zXYeaE6rGYSnq649V3cKEIbWnouj8L/tF6IqecPlN2BCWSL41j2ut9Ild4MvAmEMlOExOo0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199015)(6486002)(41300700001)(26005)(478600001)(44832011)(7416002)(5660300002)(2616005)(2906002)(6512007)(83380400001)(6666004)(36756003)(54906003)(6916009)(8936002)(66946007)(52116002)(8676002)(4326008)(66476007)(66556008)(186003)(1076003)(86362001)(38100700002)(38350700002)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qWtkXct93rLfxyRyOpEpec4Y44Z6V5t3ef6dJ1i3L5cUGSheoJC+qkPkSrPm?=
 =?us-ascii?Q?AjkmJXtxteetb3FNwfp5cEyQW2gCoEVI2whKZiQOSCAeRh5ASPUN6ASgxW5J?=
 =?us-ascii?Q?M8lTpSGg2OsYYz0w456UjAE/53zlZC2351CdYgGWDV7mt5z7if8/IVtTJTvk?=
 =?us-ascii?Q?HKgdfv46n6oWP8U8wUF8iWPoOoDHKz84Z5wzm2xbKDoLyUtj0fnZfse2bse8?=
 =?us-ascii?Q?/peEWoIi4kEAkF+7Sx+9Tu7x1uJ4JZijCIiezykx1BmAA52puXymdz/A6RcZ?=
 =?us-ascii?Q?iusOI7SXMqUcL7xXa0MadMXMWEuI1AHTypQQXmm/ShKk5ahPkfI0BmjiipQI?=
 =?us-ascii?Q?N0D/1ZfrLhs9+kb4ATDCmkoDyIehE3pg/SV9HQMkzl1pu0MTNVY18uaIKyZS?=
 =?us-ascii?Q?OtHxwhlieIJKa8kaaTHP580Qf5nWf0Fl5k8P0DewRFsCS9xjGdiRMv2cEv+T?=
 =?us-ascii?Q?m4IIbLcvuoXgTxiuv2BXba0sjbOWm7l7RO9FY77qtxTaGbI/zjGrhwF0CgOp?=
 =?us-ascii?Q?17z7neVzH656na7bEKZ/7f6ET4kaSXj8/uHHvKq0vGWCSuqc7MmAsfAEn63e?=
 =?us-ascii?Q?pDU3KSJIbJ0zyvoT0xxRYlsrR9L3qT7qFKANSn3qKgDxeJAyBGzwxdLtDc3d?=
 =?us-ascii?Q?Z144d1qa5WOKxhIbahzmJdPud0vjm6z2P6MeDEVYTNZ/xBTIjs95ONfbobrt?=
 =?us-ascii?Q?jxYdknAbo2P6tbvBZn7YGf+HtjqMc6CAg/u1UXGTXO2nkTbiNL/bm6Vlc/zh?=
 =?us-ascii?Q?cd4ybbtJYSSUiuws8ncqU08qbGRtdWjTwWAquwruxOM+CE30XTwwbRGfovyK?=
 =?us-ascii?Q?Oh/PVG0qU3Dj+yM4p0clQFiobcn9gTTGmRzPVMzf7l78KoJV3a1g9I5IHV1Z?=
 =?us-ascii?Q?6VWbm+23ZDhcBCh+zqtZsPJtwkR2xMmgtCk5ftY2k1KQzfLA8Scpf2zGnYog?=
 =?us-ascii?Q?kYvId7a/ot4bVVSaT3Oms/cce13NjoPx1nuF8eUEd7EaRp3SntwfXahRoZ8H?=
 =?us-ascii?Q?SnItCKFMD8cmW4xtswr+8eLR2T/8/5ztq9UhNsC7ZqBrWc76AK/i9UO+fZlI?=
 =?us-ascii?Q?fzX+JybsU1dCC8Mz/nsnodyAkQUFgdrMW4XclDwXgoptfVetHHDS/8Y06cPf?=
 =?us-ascii?Q?PhFIjQPm438PZrmMKVTooSt/DRdHDYEnrCa/8z0qGqyjpHSstISFD/ui++MU?=
 =?us-ascii?Q?KzNR36oMTq2UvxuRffaPSnXfFHuHucjnNOrOBGB10dMA7NBpq2isoZ2rVQcA?=
 =?us-ascii?Q?O4KN10OMrmTQkcb4SdC0edsqXqySWAEOEJrM8Y7Ix2F3n5AEt6dQLnwySWtA?=
 =?us-ascii?Q?mFWEDqNlrVjsViQYhibeEIBhAHyyZk50eKNC2yzp/+App81zZcKpMHVaWSCe?=
 =?us-ascii?Q?qMJaNwhcFGHaKl6H7soQw9SVXe7gWXPhs6QNHrQ6jEeRnYsP6gkR8D6+NAh3?=
 =?us-ascii?Q?db2e1NSq4qewctFl0h6mgzjmpf6him90mRfConqj3sg0JLxyCVwR2q5jIPFw?=
 =?us-ascii?Q?/u5Bykqjwihu2jK6DIt6D+XeIwq0s3v253cS7DiworxW/oKN7gJ5wI/MSj+b?=
 =?us-ascii?Q?rtl8vy5s97W2JISPnIfcm3p1XI92tWGJdgppYwY0gE60+Frw+N9YPhbkPB8U?=
 =?us-ascii?Q?CA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f3e9da6-5da1-41de-9a7f-08dabbfefe35
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 11:48:28.9078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0lpeUYSeLfy9KdMtheLgh1nuc/FwWtWwFzsDxywmAoJGUKfV/D/ym1s9tqHVptopv7l50qqNRGqO7e9vlzNPiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8453
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As phylink gained generic support for PHYs with rate matching via PAUSE
frames, the phylink_mac_link_up() method will be called with the maximum
speed and with rx_pause=true if rate matching is in use. This means that
setups with 2500base-x as the SERDES protocol between the MAC/PCS and
the PHY now work with no need for the driver to do anything special.

Tested with fsl-ls1028a-qds-7777.dts.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 13b14110a060..da56f9bfeaf0 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -872,10 +872,8 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 		return;
 	}
 
-	/* Handle RX pause in all cases, with 2500base-X this is used for rate
-	 * adaptation.
-	 */
-	mac_fc_cfg |= SYS_MAC_FC_CFG_RX_FC_ENA;
+	if (rx_pause)
+		mac_fc_cfg |= SYS_MAC_FC_CFG_RX_FC_ENA;
 
 	if (tx_pause)
 		mac_fc_cfg |= SYS_MAC_FC_CFG_TX_FC_ENA |
-- 
2.34.1

