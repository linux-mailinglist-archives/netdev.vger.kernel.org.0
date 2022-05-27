Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B73535BF9
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 10:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242266AbiE0IuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 04:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349937AbiE0IuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 04:50:00 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2057.outbound.protection.outlook.com [40.107.22.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A676A04E;
        Fri, 27 May 2022 01:49:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jeEQj/Ky0TEf7DoIEVJPOZ6Izet5BH1I8uSkD9Sdr9XWKsLlq9rRmLSSZMth4XNbSludurB073npLnB/gh7/Tr12oWndSt9g0nDymvBVY84d9kzyK4QNeKLemHfCY/+7qaVDdDIPr8Wmk0J4UZV9IT2/W+o4sNJ/+qDG3ob3ZUQFTgrnzClVM6tmydUmdDAEhJgg+l9DzXdXBIFb3+Djmi+7km3LHqWOfGzJEX5K/mxxEhGDONSADOBdDrTAUQvOmeRCgWgkbpAzcEgIGne2kzAaa9KE4V8uPRZNtz/S0RY+Yu9CUyNYnKOR0B8SdPlGStL+Jx7NHq1Qfhw8H6gPBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WvQlgn9eRo7NwKa49iWeeGoeZj6uAwyFzLDotFkPFJs=;
 b=UarvwBjH5tkyccWFyhEPeHbiwNszPKerxO8Cjqyw1odhEb5QUR6/ihiVslYmSygxFlaNtaecX0TXInGmt+PTYXWDxrA+2lbqfHOqhQXA2hzfq04HsrkxfjLTv2fML2d/y/UhsGtAQQajLBaz+BSrzl1Z8QcOUqGV6+mhQlxJcCdrUXYrCnYNi17odAv0mVAzOWa4GZVQ+TiDCe/SKgu8xvUeJW9fX9Hsc1ddigt1U7AH7HhpQvSO7A2dTn8bQ6xwGxBZdkYQ9rpODDKFxNJG4wiGh0bYmNO+uLv0K/471wYPSgkWCT1MR4rATUMNaTTDpPLnsh9quxINl4KXb0vpFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WvQlgn9eRo7NwKa49iWeeGoeZj6uAwyFzLDotFkPFJs=;
 b=e7F1kkAzSZs4zqc21h3WKmFbIxjZmpbsIvrM8xB+JmSINvrNOk3G32vgsxMkXZwMYKh3Mc3r8ejePhy0SpRT7pC4O50GAZC7W11pjwR72jp3A8IDH+1zJBIFwipLb5kNBFS9ZUDcuKzLvHvMNU1Dz7NDL9DPpvcr9BqV2crG+wE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5005.eurprd04.prod.outlook.com (2603:10a6:803:57::30)
 by VI1PR04MB7182.eurprd04.prod.outlook.com (2603:10a6:800:121::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Fri, 27 May
 2022 08:49:56 +0000
Received: from VI1PR04MB5005.eurprd04.prod.outlook.com
 ([fe80::b116:46f0:f42b:cf19]) by VI1PR04MB5005.eurprd04.prod.outlook.com
 ([fe80::b116:46f0:f42b:cf19%3]) with mapi id 15.20.5293.013; Fri, 27 May 2022
 08:49:56 +0000
From:   "Viorel Suman (OSS)" <viorel.suman@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Luo Jie <luoj@codeaurora.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     linux-imx@nxp.com, Viorel Suman <viorel.suman@nxp.com>
Subject: [PATCH v2] net: phy: at803x: disable WOL at probe
Date:   Fri, 27 May 2022 11:49:34 +0300
Message-Id: <20220527084935.235274-1-viorel.suman@oss.nxp.com>
X-Mailer: git-send-email 2.35.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0028.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::33) To VI1PR04MB5005.eurprd04.prod.outlook.com
 (2603:10a6:803:57::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: acc23d9b-7ce3-4bec-801d-08da3fbddf78
X-MS-TrafficTypeDiagnostic: VI1PR04MB7182:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7182333FF0596CD7F6C80526D3D89@VI1PR04MB7182.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jkJp9Cm15Y/8sYherjHHDeiKRaHVelTTMOCAiDszQtrjPQtdhkSobO+VvzDzZRHVE/M7l7XjV6+M2hpgXhXkDtKaf6c3ZIhHRdStIT0/CXAc+BF3a+ECAftw5sWzmoaonLEJlRppRqHWVZRFgcj5acMaft61cmGMTAbMG68FTOBwMUr0SJKJusM+gPc/jEurkellSNfkOsyCT4sw6godvuhkgkB0C+O8epiZY0MGAPPRbS0LfQYDGlPUE00A/NZa5fnvsSN82nsUJfBd6N0/GBzSlfz0WiiMpt0FQ+kuQc40UAhAYYkkI5s8J1nscOHtTVHJgk2ywcWCNFbjfGYrRw87kaoQSs3ungkTsJMUvwT1v5dXBGcP4rIxhRPuVP12Zw2G1XIPKhxndE8St9mT9djhONEAzeMxrWdyP82Bszq3zNCxeplXFo9DQZDutBbRHw9MeXV+mfh0P02M6dKznvishIU8to1EPW5uUFQU7xJHx+tabmHZtMkXz65BpYAq+lZ4uUIxY8A55dnOGddxdiP+L0yJOXKVDhN+ETiyvbewKnQIA+11oZLTXr9Gn0eCnGmleAHKV+UWGacuW4r4g7t7aYg3sTW5HjeQ7aBp36Iwg1PEPqsmXr4cVzVE9n1KsSV6lP7NSZ16eZXrtA+O23CA6Ivto/Bl2rj5L1PAc7kjX1SSp5qQ2wAWmQTbPnTE8Ngh0U9oitGwHQiYfpj3Dqr1MuUAPTKCTirzPODtPUI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5005.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(921005)(110136005)(2616005)(83380400001)(66476007)(6666004)(186003)(38350700002)(38100700002)(1076003)(2906002)(5660300002)(8936002)(86362001)(6506007)(316002)(6486002)(7416002)(508600001)(26005)(6512007)(66946007)(8676002)(52116002)(66556008)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jHDMlf7QENbPQ1ECo/fyC4CSXCQ769FLkBqEzLIcA/hqH6dnMtOPt7ASyV0q?=
 =?us-ascii?Q?OeWEv40I7IVN+lLm0VGF6199mZutubU/SshAyXCV+nfj2se2xTD6GYyFfXjW?=
 =?us-ascii?Q?jzWjusyYM1kmrVykS1Eaf1VguQhssW56Pd70UhNYr8w0GEMIQKikYUCvd1dA?=
 =?us-ascii?Q?7lYnqknn+/pN8eOTH1RWvyHi8wKvNgS8YONZAYE5RN/2HfbqaFW47s+sG2uF?=
 =?us-ascii?Q?BFgrxvAqTtWlAHG8dZDJ2Pzrx2DFOksHu2FgtZqcbLncBpGHjLDbOnQQWETR?=
 =?us-ascii?Q?rWe9aK2ox0Y9IK80Y/pAnB3Uk7q0/v8+U0/Y5rgACqZK3F7OrIYTDwmJOp8q?=
 =?us-ascii?Q?MT05o3K6rpUpyZ3pcjj8sQ4Q3cHAjmpnT4FK4A+5zGKQ9WuSMQe1C/+1W7oD?=
 =?us-ascii?Q?D4bPE07XzN1spf05lMQ4cHngKxWKnddWNp7u2mhHZG9hRiQBgCZ8nMrpsZIH?=
 =?us-ascii?Q?8ST8trdz2wqtUqzeYVkuOLDBAg+KSA0o0GBuYpZKWFrecd8hHBdGOczyeStx?=
 =?us-ascii?Q?Yh5kuCd7IjgbX+cKF8hRfe00p7Nk1lnEfZJy0VjBUKwcJ/X5Hw/wxOeqX46V?=
 =?us-ascii?Q?VNIVJg8VsPT0nI/9cv+wi+ljbbxAVOju5n8X1IlMdo/cD/bwLFKq93wLxcEt?=
 =?us-ascii?Q?MbJXERuOqajsrMY3aHrmSOaVcbjmC7ID5j9VjniYNByPp8QxE6+5o0wiDQ5y?=
 =?us-ascii?Q?HDi3m5eJgcmb3Dln3AGs9ccDrCx5nd27hbRnoNabIanPLlubTegQ5OuAY8Wn?=
 =?us-ascii?Q?Sx8pRN32XzCWJRi6ozjHiDnDeie5U5owiRGxqeLSVhbFiUIr49Ha2tt5Tc8v?=
 =?us-ascii?Q?6J1+x7I8NvmSk6RL5y8CLJFRj5T8q4RhgQMMIbWwBgQpgbPPuR6p3rBRD8Kb?=
 =?us-ascii?Q?ncVBIGWJyLAjEh8xE7fB/feo2Hg4L2zoYmA8m5wpaVS0Dko++d2k8MqbRTTj?=
 =?us-ascii?Q?wv0glQCqJtoK57iHDLBvZ2+8GmpBQF1kg2oxRloRDdfvSb3eObiIlDbnMZ7O?=
 =?us-ascii?Q?RlMRR2/BzzSpmgiecE1yrRxP2/jVvhDl7zBs0+fk1JWKsw0zyQW0MnEVEopK?=
 =?us-ascii?Q?5b2s4X8jE9/MA6QqzwpTnclBcfKVeMLSFiL2/IOPbMfn7XhXKTvPjI7ZVD4U?=
 =?us-ascii?Q?/N83OEc38GwbHPaTanOMsy2uq4iDfzLI2poSp7Vyfy0LXQ3KoguyJLS1KY46?=
 =?us-ascii?Q?DivuMynoQgU7aavQklfbRcBNyrz5FvK8j3vT8I35MsnV+4a0IWFhLYqJcZJk?=
 =?us-ascii?Q?WuEKK7EBXutHPVHORMA9GE64AJhBRVDyRiFSlLCNUDsDlrRlSkC3xisdaRRx?=
 =?us-ascii?Q?8PgANqfFBjOOeY6ais3V7yNoEFI+1MVbsJEm9OdX3GUH8E4wIbzegp0FnjVl?=
 =?us-ascii?Q?VPmsO/zts2rhAWHvi2W9mZqCcra7Zd7JKJ4SDX3qbw7osQN40wWjqLDR5ch+?=
 =?us-ascii?Q?ZIbCSNZboZRZpjQ4gpv+MtoLjOhn9u30cFOWZSpTG0zR8+EQWZD7FcYRJknv?=
 =?us-ascii?Q?hMpTGDPVfakCXIeVBag5qxfP5nJ+YUiRFXDYUBOarYpcQh8Uiq/PehWOEY4z?=
 =?us-ascii?Q?O+7i8BNBdp2lWmTty1L4NAqwc0XjIod40H8oeYGr4RSWIb6ZwoDcTE8+Nx4o?=
 =?us-ascii?Q?bd6VwPVY34pvE6JT7C9wUQ6AyCT4qb0V3bVS9iSm1tq/AVR65bCTSz3Dh8YV?=
 =?us-ascii?Q?yEJKEdaXg+e1zkpjuyZW2jJ4GWCRt503okEtNEQQlu0XiRFVAfEKR7La3kSb?=
 =?us-ascii?Q?Q8CsVqnGXnIz2de8k5sBHCmssMPtp+Y=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acc23d9b-7ce3-4bec-801d-08da3fbddf78
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5005.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2022 08:49:55.9275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wfJkfcGupQP1VmL0qxWlDOMOu0+CotzopoVJifn8GXOeFF1SSB2uszTgW7whSYJQmGi0i94jAVwMvEfPm0A/+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7182
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Viorel Suman <viorel.suman@nxp.com>

Before 7beecaf7d507b ("net: phy: at803x: improve the WOL feature") patch
"at803x_get_wol" implementation used AT803X_INTR_ENABLE_WOL value to set
WAKE_MAGIC flag, and now AT803X_WOL_EN value is used for the same purpose.
The problem here is that the values of these two bits are different after
hardware reset: AT803X_INTR_ENABLE_WOL=0 after hardware reset, but
AT803X_WOL_EN=1. So now, if called right after boot, "at803x_get_wol" will
set WAKE_MAGIC flag, even if WOL function is not enabled by calling
"at803x_set_wol" function. The patch disables WOL function on probe thus
the behavior is consistent.

Fixes: 7beecaf7d507b ("net: phy: at803x: improve the WOL feature")
Signed-off-by: Viorel Suman <viorel.suman@nxp.com>
---
 drivers/net/phy/at803x.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

Changes since v1:
	- addressed Jakub comments

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 73926006d319..6a467e7817a6 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -433,20 +433,21 @@ static void at803x_context_restore(struct phy_device *phydev,
 static int at803x_set_wol(struct phy_device *phydev,
 			  struct ethtool_wolinfo *wol)
 {
-	struct net_device *ndev = phydev->attached_dev;
-	const u8 *mac;
 	int ret, irq_enabled;
-	unsigned int i;
-	static const unsigned int offsets[] = {
-		AT803X_LOC_MAC_ADDR_32_47_OFFSET,
-		AT803X_LOC_MAC_ADDR_16_31_OFFSET,
-		AT803X_LOC_MAC_ADDR_0_15_OFFSET,
-	};
-
-	if (!ndev)
-		return -ENODEV;
 
 	if (wol->wolopts & WAKE_MAGIC) {
+		struct net_device *ndev = phydev->attached_dev;
+		const u8 *mac;
+		unsigned int i;
+		static const unsigned int offsets[] = {
+			AT803X_LOC_MAC_ADDR_32_47_OFFSET,
+			AT803X_LOC_MAC_ADDR_16_31_OFFSET,
+			AT803X_LOC_MAC_ADDR_0_15_OFFSET,
+		};
+
+		if (!ndev)
+			return -ENODEV;
+
 		mac = (const u8 *) ndev->dev_addr;
 
 		if (!is_valid_ether_addr(mac))
@@ -857,6 +858,9 @@ static int at803x_probe(struct phy_device *phydev)
 	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
 		int ccr = phy_read(phydev, AT803X_REG_CHIP_CONFIG);
 		int mode_cfg;
+		struct ethtool_wolinfo wol = {
+			.wolopts = 0,
+		};
 
 		if (ccr < 0)
 			goto err;
@@ -872,6 +876,13 @@ static int at803x_probe(struct phy_device *phydev)
 			priv->is_fiber = true;
 			break;
 		}
+
+		/* Disable WOL by default */
+		ret = at803x_set_wol(phydev, &wol);
+		if (ret < 0) {
+			phydev_err(phydev, "failed to disable WOL on probe: %d\n", ret);
+			goto err;
+		}
 	}
 
 	return 0;
-- 
2.35.3

