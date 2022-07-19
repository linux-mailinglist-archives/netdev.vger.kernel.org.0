Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A37D57AAAF
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 01:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240661AbiGSXw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 19:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238688AbiGSXvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 19:51:45 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2078.outbound.protection.outlook.com [40.107.20.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507F365593;
        Tue, 19 Jul 2022 16:51:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YBIp0DlM7ckQDXgnakGSe/qYQ2iV6Tiit8xsWHcUlZ/D/i7LSTKEm66iJ//lvh1QX9DsqQ+XoHlYwdsz91XEJnV+2nhcxpmah83AE4y7v5rvTlOz6diOUNSTcBOda44ZYDZfB0zse+cL78nk5VkKdat0qG4bdf1doLRZtuWCGEOReQTKZDVNrGZx9/vMQOXYnz8WFtJbhBUUXgmm356DT0MJ49DXp0Bijlv63SmiyA3x/ESRQuxos0wyOu9BlyVp7ipOfAs+8UAWM4HMpbOVoPPQiILA/ALnhOwQ81yK3Rsd/n7hE6GJ8GgSrD2OcHzToqM+ZRxTo6H1OA5lqA8zEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CwqgF/VSthAT9ESWw2ffD+n6n8x4GWkSvUBruY6zJ8A=;
 b=X7d8V7vpY6lYQkgY0D9Do4b9YzdQ+hUHB0URTco8l8iFJD7m0JkwGzPdQec0gdlIQSVwJcOc6DnTI5X5EkHC2FjxR0a+SUhjLqPMtATW2Z/G6fUEk+2vvmXHGe1gcmSJNCq/1MFDpT7mrGUCwgO6bJmUkYFtjiFJS40vIXoHbTQsPHuJm+BpQls6ObOWDdssKVmLenQdBwkRJTCNwmjc+oSXEIQf1aE2TBjRapCRyGeOKhz6A11Pc2OzEdERXu7V4txP37rSTNiLJIRGjl6RjQZ9iJ4qllCWSHX0/5205lhgDOWARgufOzYdtsVQHoQm8fLO+b5fJI8B4RGnU0fe9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CwqgF/VSthAT9ESWw2ffD+n6n8x4GWkSvUBruY6zJ8A=;
 b=PbXBfyK0+y43glmBc9UVC5zs2rNtDKfNEeWkt0maRIqaGQqqCkTiWAQQ0WiYknb+b4JrxfCF3R3vOlce5Sja/onA0iXMGaRSZg7Y59u6CQSXzJQI9wND/03fkbQO10kZq8RjL4BZNmAxulHSZF7XD3wC/t4Q6IBkvvd1Wm1xwoHHjtrQP2FHSzBRWMc5xIEbIbURkSmAmV0JK940Wxk/ziTEag7pRxaPrAKXyfEUrdHGZC9aw9fiiaur3Xrnak6AR5fmhUw1ij+QXPd79e5XhBu/N5BWlcC/Ko7/uv6UeXz41Ey8GBaJ/xLv9t+oG7NJFL8/wZlCpzHY0Hj8PUqqgg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4811.eurprd03.prod.outlook.com (2603:10a6:10:30::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 23:50:40 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 23:50:40 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v2 11/11] net: phy: aquantia: Add support for rate adaptation
Date:   Tue, 19 Jul 2022 19:50:01 -0400
Message-Id: <20220719235002.1944800-12-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220719235002.1944800-1-sean.anderson@seco.com>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0227.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 360f166e-64ac-4dc5-38e8-08da69e17c2e
X-MS-TrafficTypeDiagnostic: DB7PR03MB4811:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8JhJZuoRw0c9OPjWzD0wQaAJ7k8H2hJ2GsrXbBSKDh5mdyvJjpb5qUSUoIbkIo60nTEU9/WY10R4N2+Nf1bJ5DIFeYVIlOLe1aIz5W+5M8hHhFCDQrmGw1RjXdS8A01pDgwd2WiEvOx56wgPZK5sdYsiargIukZu3rC0gi4yjpsusZUIan7ghJKB4uDuW188OCbwxdC2sS4N6P0xxKCkOXnekPi+rzNt1BpGqxZAMeYtgg/AUPSoaawkWUIkyXpG95yKHVSq3NpHucVAIBFsrJO5MZYD8AI380ABYLcPnglC9ttCaFKP+7Q+2UQC54xehMFZEcyIo3HxjVfVZrdt4YpQkH5Pqqoq+Mt6WN/hV7e4kMgf4NWWNLrRJkVehy6SaW40oapgYfP17lMijSh9Tg2huw9TyLgPN884f6h/exia1RLzHgDmir3XxRgQlppysqMuoJaZPFdOkHSJElNrS78SfuR+ff6usUs4qwV/WwJbmQFjirUk0Qf1agd+u6qxMNQccPIq0vK+c64vlAazo6RPCrJmuztgqZ3qr2q0/kVHj7ylRghrrCC5PcFPyJc0wXZb/Wdqr5jqjvq/rgeajManJbwUFrZi+Q9hzK4hmdkAo/kgaO0gTAsAgVMKcztM1rBobOtNR09QWojy97HOlkpanpZ3XBxafMSJj8WzpuD6rGmLwViwjCyiF2C+6opUIW2ffvO4uUJzVj8f+2GURGWvLjRRitv3N0TcuVGqBFFx4JdpRweHZIE9pXa3yWtC7K7cAnu7/+nQmfqzNlx7x+gC8R2pNRujlwiEJ5s3gt0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(39850400004)(396003)(376002)(346002)(54906003)(2906002)(1076003)(83380400001)(186003)(66476007)(66946007)(8676002)(6666004)(4326008)(110136005)(36756003)(66556008)(52116002)(26005)(6512007)(6506007)(2616005)(107886003)(38350700002)(478600001)(86362001)(41300700001)(44832011)(5660300002)(316002)(7416002)(8936002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xX5Np3fXK1NgogAnI79r2anrZYCERhHqmtA0yaqFTTK5NLImhga7Tz2bdJKa?=
 =?us-ascii?Q?ehhNqb+hF/KW7oKJENyeZp7+YPNCqkAEiyHlA69VW0HxtUU+qF+NsU7CzdHj?=
 =?us-ascii?Q?XmdcsgJmtmVl3FBhymEo/VFQsgdwhFlG7pqAwofhUKTGAYkjobkb2dGWcV9W?=
 =?us-ascii?Q?OuXpSwBwwEUDPFAMXWs4qh8LwAD40SY5h6YSxwui6nlgQlBpRX9jDFnxK1an?=
 =?us-ascii?Q?3qBoYBTdtKkmI+PmPz4zDtLPkm4OS8SzKEm3dbbo8JyWbh4WD3DkqeBCiYJA?=
 =?us-ascii?Q?MfhrfHlyWusGpzTDZSeMbKwq+pp/RuXP4NzwfWH9r0TiZjam6MZwfwwfXFMK?=
 =?us-ascii?Q?xmGz165zV7rF0z9R+LGdDfkWjzfFWEOMZXLWtmRVijouKg+nFtPcJwlavSZK?=
 =?us-ascii?Q?DD+Z6mShoup4zS+WMjAckQI6qBWqVAe7Kf7lBTBNkSBvzaby5tnM+wvDmg2Q?=
 =?us-ascii?Q?+z6/2mqEpyhezl+TB/s86BDwcwRwdXFwsYbjQHeqc+OlEvuci+TnYi6Jt+LP?=
 =?us-ascii?Q?C5+psLY1hF11dQ34/fxe76Ux0gAr9nXxlq4VsQsG6qxigtQtTyQ+vZtV5FlQ?=
 =?us-ascii?Q?UByHYj5Oj8QBO2iL2cnW2tlS7aEwYsgxCGrXMFJWbIhDpx2S5yFbA3U8xVdU?=
 =?us-ascii?Q?jzGQ8J77nnM8NoVjrXo3ZDKb8WkLgfC5YsVt+xUx1sKLruD+H4SEJH0xUvev?=
 =?us-ascii?Q?XdcZbepMwQtREJaLnu1thfMCFDl6yqpNEfDYhgJ4LSZGGGGAl56QnKLHoTy9?=
 =?us-ascii?Q?tOD6jYEV0caWDomeSJPbWKqGvjqG1MilQtDf2Viz2sW9TSqwpy8VZPTNBosn?=
 =?us-ascii?Q?GzS8RXlVkl/G4u8H/KRqznOucjHFktxb0/dzu0fgEBE1FfUcNeYmVvQ7JwXC?=
 =?us-ascii?Q?wfQAjNloUGV8xRghLdM3HiFygzquXtx8CzBfHgzCE7Yozo+3E+k7euwy2eUT?=
 =?us-ascii?Q?CVNMvlowKwWts3SknDkNGhmPPqS0SNQ8Jk7heYN8MiR1GffxieM9E9+u0U75?=
 =?us-ascii?Q?k2ieUDpP5GciCcdMcHs6zw0RQu5s/jWp6qtb3YUSVE9Gt7qzfO2E0oxB5573?=
 =?us-ascii?Q?nFyZLzlyiBxcutXwahrKvdovy23+ngRZpOGrfCqXlwCrXoCg/3sm5gD8V5gw?=
 =?us-ascii?Q?JYPP/xfAUO0laAjCLveTWa6MS1fOg4ekGw8ta9QvFoO2+4CO0cUQ6lkTCm9L?=
 =?us-ascii?Q?89z8JOFGoow6LB+QsOTS0teY2gs/RzJ74nH4J0e3SNk/xmgaGEXzEp17kzsg?=
 =?us-ascii?Q?TKnmEBPqRqzK2WzUDkwTar9h2LYqZ2HB1txRD/dQ2s5bUDCQnm64v2SIwXrs?=
 =?us-ascii?Q?SsPJQSrC8VqH0mfC+Jv/hTqZoywJUbbuaq4FdRb8d57nhEjciDFKP3RIk6Fm?=
 =?us-ascii?Q?fjqT4JrHfAYT/Z3en4QsS6CNlIyU78Pk1ZT2M0N4SinPqTrqgtRryLT9T1qJ?=
 =?us-ascii?Q?kmHikaZBvwObZwGbc1KEHqFSAtoerXF+NNWUlSkqgBCrY9xo0DTLH9GdC5b5?=
 =?us-ascii?Q?48JCHHU+0iCu8OkntdenwmQFQe5FukCzI4Ny0/pev/C7dcpEytwgwqZR5RHH?=
 =?us-ascii?Q?LtxidPTx0pt4LsQ04Tqv710Tn4pagJaNc6UX2g31nuPa5KQc0WNPThfhWAfi?=
 =?us-ascii?Q?2g=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 360f166e-64ac-4dc5-38e8-08da69e17c2e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 23:50:39.9870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OEDnxC0yIy5GnnGkUEnyv/c0K1Ep/xbiDGkTdYr4iCsxDxoMXp23YlPDAqyVQUKu8DHDizaLYQRc/6m7c1QMYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4811
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for rate adaptation for phys similar to the AQR107. We
assume that all phys using aqr107_read_status support rate adaptation.
However, it could be possible to determine support based on the firmware
revision if there are phys discovered which do not support rate adaptation.
However, as rate adaptation is advertised in the datasheets for these phys,
I suspect it is supported most boards.

Despite the name, the "config" registers are updated with the current rate
adaptation method (if any). Because they appear to be updated
automatically, I don't know if these registers can be used to disable rate
adaptation.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- Add comments clarifying the register defines
- Reorder variables in aqr107_read_rate

 drivers/net/phy/aquantia_main.c | 37 +++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 1e7036945a4e..dd73891cf68a 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -358,34 +358,50 @@ static int aqr107_read_rate(struct phy_device *phydev)
 	if (val < 0)
 		return val;
 
+	if (val & MDIO_AN_TX_VEND_STATUS1_FULL_DUPLEX)
+		phydev->duplex = DUPLEX_FULL;
+	else
+		phydev->duplex = DUPLEX_HALF;
+
 	switch (FIELD_GET(MDIO_AN_TX_VEND_STATUS1_RATE_MASK, val)) {
 	case MDIO_AN_TX_VEND_STATUS1_10BASET:
 		phydev->speed = SPEED_10;
+		config_reg = VEND1_GLOBAL_CFG_10M;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_100BASETX:
 		phydev->speed = SPEED_100;
+		config_reg = VEND1_GLOBAL_CFG_100M;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_1000BASET:
 		phydev->speed = SPEED_1000;
+		config_reg = VEND1_GLOBAL_CFG_1G;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_2500BASET:
 		phydev->speed = SPEED_2500;
+		config_reg = VEND1_GLOBAL_CFG_2_5G;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_5000BASET:
 		phydev->speed = SPEED_5000;
+		config_reg = VEND1_GLOBAL_CFG_5G;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_10GBASET:
 		phydev->speed = SPEED_10000;
+		config_reg = VEND1_GLOBAL_CFG_10G;
 		break;
 	default:
 		phydev->speed = SPEED_UNKNOWN;
-		break;
+		return 0;
 	}
 
-	if (val & MDIO_AN_TX_VEND_STATUS1_FULL_DUPLEX)
-		phydev->duplex = DUPLEX_FULL;
+	val = phy_read_mmd(phydev, MDIO_MMD_VEND1, config_reg);
+	if (val < 0)
+		return val;
+
+	if (FIELD_GET(VEND1_GLOBAL_CFG_RATE_ADAPT, val) ==
+	    VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE)
+		phydev->rate_adaptation = RATE_ADAPT_PAUSE;
 	else
-		phydev->duplex = DUPLEX_HALF;
+		phydev->rate_adaptation = RATE_ADAPT_NONE;
 
 	return 0;
 }
@@ -626,6 +642,16 @@ static void aqr107_link_change_notify(struct phy_device *phydev)
 		phydev_info(phydev, "Aquantia 1000Base-T2 mode active\n");
 }
 
+static int aqr107_get_rate_adaptation(struct phy_device *phydev,
+				      phy_interface_t iface)
+{
+	if (iface == PHY_INTERFACE_MODE_10GBASER ||
+	    iface == PHY_INTERFACE_MODE_2500BASEX ||
+	    iface == PHY_INTERFACE_MODE_NA)
+		return RATE_ADAPT_PAUSE;
+	return RATE_ADAPT_NONE;
+}
+
 static int aqr107_suspend(struct phy_device *phydev)
 {
 	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
@@ -687,6 +713,7 @@ static struct phy_driver aqr_driver[] = {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQR107),
 	.name		= "Aquantia AQR107",
 	.probe		= aqr107_probe,
+	.get_rate_adaptation = aqr107_get_rate_adaptation,
 	.config_init	= aqr107_config_init,
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
@@ -705,6 +732,7 @@ static struct phy_driver aqr_driver[] = {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQCS109),
 	.name		= "Aquantia AQCS109",
 	.probe		= aqr107_probe,
+	.get_rate_adaptation = aqr107_get_rate_adaptation,
 	.config_init	= aqcs109_config_init,
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
@@ -731,6 +759,7 @@ static struct phy_driver aqr_driver[] = {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQR113C),
 	.name           = "Aquantia AQR113C",
 	.probe          = aqr107_probe,
+	.get_rate_adaptation = aqr107_get_rate_adaptation,
 	.config_init    = aqr107_config_init,
 	.config_aneg    = aqr_config_aneg,
 	.config_intr    = aqr_config_intr,
-- 
2.35.1.1320.gc452695387.dirty

