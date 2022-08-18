Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3F9597BE0
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 05:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242951AbiHRDBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 23:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242938AbiHRDBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 23:01:11 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2047.outbound.protection.outlook.com [40.107.21.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07715A7A8A;
        Wed, 17 Aug 2022 20:01:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Az1OP6I+U9e9yg1RJJzslRnf8FnXHvK4cNl5NI8tnn12/C5YeUu2WgpIiC8/gcqsA3g27p1AMhoPwLYC2vFkCoinrTbmIfXchrXdaYljPUnRvnMoQnxdIoF7R1gpVpnYomOk9pILOihTX2LFcoemiHhg2dWq1Y+HH5ckOPJHxQTWRnquq9pwL71fIANejQ2DCbDCb3AEDeZ24b5M4SoXT2yLjQd6/LK47M55XdqOs2Eg5nN7oI8ZcFqPLr9YXQ7VXeAq83Q3zKScATM7EkOcOxE/0/LzFrPljMJB38WBbROse4W4jfGfK+1Sn2TlS/4PhdAPdKBgQhro5kNyvZgNLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zVpWDT/kQ6DaYd8fFWFppvRa9MNAhIH2N4AhUaFN1lE=;
 b=R0qzhBfkMdmf624BJK5ffowgQfAyzY5tb//MURzTyJvff0HRAYr/CYQSR36axco1TF+Ubs/qixab35EkagdeXW7G0xyfreVfzynor7nX2MrjunSFplKzvRdlpmWd3l0rgHGn0PjtxgMbBs5GxmznuDfPUbqLyARHZvqf3Fp73D0tev2e4IIKs2ihSqGSOp6f1EvvhlOSSUo0+R6i16xaqzrBDcTNha9roskaaoZdVJtFCCyDyTfDTHixULod28iYzI379quabPlgL64VyBXt9lZbMW7xEsS5EoOYkgLRzeEyXiFFXu8F3M3OQ0+g05jPxWFFtoFRIJsF2sWMQrqKdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zVpWDT/kQ6DaYd8fFWFppvRa9MNAhIH2N4AhUaFN1lE=;
 b=oWcrgWbBotQyU3o8ZzILMYMOdYHDtiTtozaBziN0quWKKepvNOhPhzCStiRkTMuylZMDZxWHqad02CkY9qzrdlD42mVVdi3do9wkmZotYRQfDcBgtL1mb+ELNwR5MXxdq1LfWHIf0Da1fhLpiwjN6doBLYWWDi7vx7kDzIv+TGs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by VI1PR04MB4637.eurprd04.prod.outlook.com (2603:10a6:803:70::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 03:01:00 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Thu, 18 Aug 2022
 03:01:00 +0000
From:   wei.fang@nxp.com
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 net 2/2] net: phy: at803x: add disable hibernation mode support
Date:   Thu, 18 Aug 2022 11:00:54 +0800
Message-Id: <20220818030054.1010660-3-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220818030054.1010660-1-wei.fang@nxp.com>
References: <20220818030054.1010660-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0038.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::20) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52607a28-3295-4507-5a2c-08da80c5e15d
X-MS-TrafficTypeDiagnostic: VI1PR04MB4637:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GofHPRwQn0qJdWlzFSZdw1/51x0/s0Taz0UhL4dHqu8GTmnYRrs1XCQK1iKDbY6SiIXmr5zvgnM8wmeXuFTRx7XVlTbkfV37ZXaJ4VAOP3ruKs+XwKl/sPL2vpgvpADT/gjwwJrqUZkXMox36omJEsbcHTLDudTWIaW0octT8gl+MzwjLi63JpEvFDSBHZOKZJPQeJGKP0xLl69VBbbxg5f3WMDrAF/xQx5yLZR16N305wUSMOQsmEb/vJVU1nAmq0edF7gACNkNmIkl7AgQ/FX0GMCHZqMoopfvnlnteDHIQDMGH6Z329XjUBOl4m1DzSSuGBh1Bwq+OFXpoQLWtE10lWkNFX4n73XRJkrwL44gke0t2n6TTrdI+JDhzorFVuWddbjtGZD7//iB5qJwL4BWfDnhn4GfDeF/60PXwWvsKEYBa96VYXGi1DTSdhurp+tgfCPxOvJoxyEMnNjvft2hbwpW52Wd2qmAqJTdkXNdlShBnNg78naloGOj1GPN5mRR3e+3R7ofJ5gyVIzGzYi5fs+QJKoQpivTXZj8pTZN08X9PwC+APgcLsx9CCUxuHou+ZDDld43PyeIACGFFpjc3vtdtFkRNLHDvykP2lcCMlUvMhvPOShfIh6lJNVR+YkKrb1o7o3u2qYJfK5At0L0x79fULuC3knf0DP6sslqZ/ZEUTEDwb+K/68WRoXESpWeWIczwlKwX7urEYJ7O8VYfQttOfNu+mnt6i3vdEzIn5Ct8pp1BKGvxApwN8OLu7k34cHQRCSZQ4rc6zUZ4AGp1IzCEdSI70Sb9BtWW+A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(83380400001)(52116002)(6512007)(6506007)(26005)(2616005)(1076003)(9686003)(186003)(38350700002)(38100700002)(66556008)(7416002)(8936002)(5660300002)(8676002)(66946007)(66476007)(2906002)(6666004)(478600001)(6486002)(41300700001)(316002)(921005)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tLxcUfBZazrpjPttVOWGq1bAZpVNJO+dtRv8DA5Qq5e41WZDNqc/eO0vdaez?=
 =?us-ascii?Q?6EhuFQqRkfnWwOcbvc31H6kGr3PSuoZiaXiPzoIUDimqhjY2L4YCiAOjj3gC?=
 =?us-ascii?Q?hpKn0BxPKLHMU9UuzIGP2x9TqlZs+HieNDB8V/YfAo6cZUQ7WE2XsRHRgPj+?=
 =?us-ascii?Q?R8pXwOs9ZssbTMghKPtg/A4LnT5q6RfeAStiWvXqk+ZPokyT/B4VZi+FittD?=
 =?us-ascii?Q?PGYIYq48hVQcO0O/glpC0UbvTh1+26zVNF382ae2NhrF9RIgUvoXYeVRScGp?=
 =?us-ascii?Q?6kf0JXpxGi/bKL6C5xkBJwgcfLKTXspytgyab5hi3rsz69IqJUKXmVvu/BYD?=
 =?us-ascii?Q?uKW90Z4d0nhSDAh/dTDVBwAEDHR6n711T9VsSTEU3t6NnZIrd7EbamSVRyAc?=
 =?us-ascii?Q?Dz+Y1PrZTdKjmtGx/Cp7e4RYLY9t1IBCbApi7BqwRKHMY4yLGBQR0LhWlYqT?=
 =?us-ascii?Q?lEiN7pVPOYd2baJuDMZj9yDt3yCkDmnoCuEPlUnFwXXaVFlJPkpuLQIQT99Z?=
 =?us-ascii?Q?Ws2gnBuEEW1hTTM/YAqJdBYCT/xGXQDVBwiZPhb4wVFXscRSnVYpnPxln2XE?=
 =?us-ascii?Q?V247cltkPVmIpsQaQJ5MYLQ9gMp8+lVWxhjd/fu6oQRYWbAgd++IEq2+Rxi1?=
 =?us-ascii?Q?usQeWLUYXv8CvnzFNusOjL//VujYg2NJZ6sbBSwhrlbmBwVkszkRSMcJFrTf?=
 =?us-ascii?Q?sUGW4cCOLRR8BRIR4chZ6ye7n5lkiDN+XvjCfG9b0wwhNsvEq9UH/rbeY1Mp?=
 =?us-ascii?Q?xDF05bHPB16xLwaNmoMPZlLybuTerQmngDZ8YWV40B4J06GJHaAivWpnU4a2?=
 =?us-ascii?Q?mhIcPQJ8FS0t2UtRVJi3boQ44YO8E5BVEibbRyK/OuRc2fExN60PsbkbnIvb?=
 =?us-ascii?Q?qyJ5UEjN1a+7ajr2aFfS1KMpL/EMHh+ZJkhd4el8dDDFLiS05705OPN+EY2A?=
 =?us-ascii?Q?/tJHoEX1dg4SJzEAjrUq3Q/BN8H3zbZY/lxEbDd/rkdOBhYflOCFCwqGkt+h?=
 =?us-ascii?Q?iMmTx5meyXtkNbjLUaMZwYFhBxcv871DqfP0OodDkSy3xWOej9JZL9yTuMPi?=
 =?us-ascii?Q?llwfn8tQ+m2xKFSPsgaIppHQGv6RuXmFcPkHLbpgFyFUiORyJd8d1gn5QpAg?=
 =?us-ascii?Q?6Km1GYExeUOTCBx3XLCiCflG2kkPi6JSCdyRcL6VpvrdS2A3x4CRC+palc/q?=
 =?us-ascii?Q?eb5fP79G82IQEMoxnvRXTPpmPAS989EZ6yWebnbEwrsVbx6dTsgqJ/xKfJjW?=
 =?us-ascii?Q?BiMpetrxpigkFC+VHwOE4LnvUjVGknApn7m8PCntnEn9o7i8iktJIc59LnUt?=
 =?us-ascii?Q?ZKbMDZPqoOQt+7UlnIyPPcviMqYisQN6n8FCXwh3VlVJTpS6EBj2Zt9pcoDC?=
 =?us-ascii?Q?5RZbK7U3JDlrxR5LBy/QRjFOf2s1/zoPtchO3rE76K/sskCQ7fRzkOewAxMK?=
 =?us-ascii?Q?fY+FdSM3EDsawNEhLOCudY8EQe6oRpGSLl2d5Lun3cB6euOd2UNVYTyyRVFk?=
 =?us-ascii?Q?OvQthveIJ7HTomxpYqj+WB6CkTLXhAGIUMTs7qixldBnXHhxbmZMaP4QEK9B?=
 =?us-ascii?Q?exCepC7sMRqvMu6cccpM57KedYdy7MNpXI80R1kF?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52607a28-3295-4507-5a2c-08da80c5e15d
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 03:01:00.5813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6DXD0Jvyoy5cLCRk7HKtjT0xdMPGRko1JvhfsDmRMVOqODzrhFNkNXep9rP6U1miihudu+KrYnSApiLLvWqHNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4637
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

When the cable is unplugged, the Atheros AR803x PHYs will enter
hibernation mode after about 10 seconds if the hibernation mode
is enabled and will not provide any clock to the MAC. But for
some MACs, this feature might cause unexpected issues due to the
logic of MACs.
Taking SYNP MAC (stmmac) as an example, if the cable is unplugged
and the "eth0" interface is down, the AR803x PHY will enter
hibernation mode. Then perform the "ifconfig eth0 up" operation,
the stmmac can't be able to complete the software reset operation
and fail to init it's own DMA. Therefore, the "eth0" interface is
failed to ifconfig up. Why does it cause this issue? The truth is
that the software reset operation of the stmmac is designed to
depend on the RX_CLK of PHY.
So, this patch offers an option for the user to determine whether
to disable the hibernation mode of AR803x PHYs.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 change:
Modify the property name and the function name to make them
more clear.
V3 change:
No change.
---
 drivers/net/phy/at803x.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 59fe356942b5..11ebd59bf2eb 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -115,6 +115,7 @@
 #define AT803X_DEBUG_REG_HIB_CTRL		0x0b
 #define   AT803X_DEBUG_HIB_CTRL_SEL_RST_80U	BIT(10)
 #define   AT803X_DEBUG_HIB_CTRL_EN_ANY_CHANGE	BIT(13)
+#define   AT803X_DEBUG_HIB_CTRL_PS_HIB_EN	BIT(15)
 
 #define AT803X_DEBUG_REG_3C			0x3C
 
@@ -192,6 +193,9 @@
 #define AT803X_KEEP_PLL_ENABLED			BIT(0)
 #define AT803X_DISABLE_SMARTEEE			BIT(1)
 
+/* disable hibernation mode */
+#define AT803X_DISABLE_HIBERNATION_MODE		BIT(2)
+
 /* ADC threshold */
 #define QCA808X_PHY_DEBUG_ADC_THRESHOLD		0x2c80
 #define QCA808X_ADC_THRESHOLD_MASK		GENMASK(7, 0)
@@ -730,6 +734,9 @@ static int at803x_parse_dt(struct phy_device *phydev)
 	if (of_property_read_bool(node, "qca,disable-smarteee"))
 		priv->flags |= AT803X_DISABLE_SMARTEEE;
 
+	if (of_property_read_bool(node, "qca,disable-hibernation-mode"))
+		priv->flags |= AT803X_DISABLE_HIBERNATION_MODE;
+
 	if (!of_property_read_u32(node, "qca,smarteee-tw-us-1g", &tw)) {
 		if (!tw || tw > 255) {
 			phydev_err(phydev, "invalid qca,smarteee-tw-us-1g\n");
@@ -999,6 +1006,20 @@ static int at8031_pll_config(struct phy_device *phydev)
 					     AT803X_DEBUG_PLL_ON, 0);
 }
 
+static int at803x_hibernation_mode_config(struct phy_device *phydev)
+{
+	struct at803x_priv *priv = phydev->priv;
+
+	/* The default after hardware reset is hibernation mode enabled. After
+	 * software reset, the value is retained.
+	 */
+	if (!(priv->flags & AT803X_DISABLE_HIBERNATION_MODE))
+		return 0;
+
+	return at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_HIB_CTRL,
+					 AT803X_DEBUG_HIB_CTRL_PS_HIB_EN, 0);
+}
+
 static int at803x_config_init(struct phy_device *phydev)
 {
 	struct at803x_priv *priv = phydev->priv;
@@ -1051,6 +1072,10 @@ static int at803x_config_init(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
+	ret = at803x_hibernation_mode_config(phydev);
+	if (ret < 0)
+		return ret;
+
 	/* Ar803x extended next page bit is enabled by default. Cisco
 	 * multigig switches read this bit and attempt to negotiate 10Gbps
 	 * rates even if the next page bit is disabled. This is incorrect
-- 
2.25.1

