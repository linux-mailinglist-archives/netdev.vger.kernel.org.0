Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24F857AAA7
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 01:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240398AbiGSXvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 19:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239881AbiGSXvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 19:51:21 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2078.outbound.protection.outlook.com [40.107.20.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C782861DB0;
        Tue, 19 Jul 2022 16:50:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nz1Dh5ej1SSgktCHE1zmgqNvb1yp8Q23VAEUYSO8J+NGq3irxCUQirUmaO+zyndpuFtIBvn5rJk7xDYJU4fFyddZwQ0+9/7PfcftII4Yetca/U8F9gSoyMPp1BQmxeCPyH+6h8tTVL9X6WjPVh3aOrXUS1eI5AGYO/tDUs6o00/fpvBUAEJdmDCxFUws445cY6vBQ6D7vHQBOqagVNuwbAMb1BJlEQ/UhcaPNf4G4Qw6GTOnZJXdBptOZT8WQqEqA69ACZ6wcbfDvg1U5o7DfU4HZ/+0D9ED/f/inh6bKk3seCOgECaOKlhDTnKrQ2jqvZmeNXWUW40RJjyWm5k7pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=muenqxh0QkBSPg9xKgGudRNTjup5zs7BA7/AafM8Jys=;
 b=QlIqbR1umBedc80X0SBGGMINgFKQCEKlLFjsVRS2gsdzb0BvzCaUq6EXukoMPuOK8FOdrfgM+OAFs1FHHYDjVBUC8S0SrKhKrrQSgKL8hPSMJ2Xmjn6kI+o/+OULj6lgsdwzHyF8zl8XJ54EqPNYF6h6SgHGiIZWgvfmzBv2nCLc1RXKdoEzHMrvDx08sriOx/+aLp/9YLvSWohLuJIeHtM3t+I3h2prlxB6vyZnZzBcLSedDMlIt9FPM1pKTwp1pkZgJHgXFneVEBLrdgdywY1J54TTIV7Bg90QB8tgsOkgq5u6WpKbsFwBuKYawzMir/zHM4Y8wrV+V3q/2a90xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muenqxh0QkBSPg9xKgGudRNTjup5zs7BA7/AafM8Jys=;
 b=TVAqM3Zf3q5dCDvuHHXq1NcNP9PY9FH0J2IGv7NcAzDorOG9I+b0egKMKlMwAHO5e0ejzikcoEd3NIr8xS7IHq5h4axRcpB5NXJVlQ8TrpmUeL8Ggdq9ZgkGgShA2e6Y8dr9lugYPP/0ErPC80Eg9JQ3ApYbM0OFf6SeEDCdrIFme1+q6BTTmQ9tp/xvXyOBa/N5hBZKLyx0T+7gvO9qkbOhdWiTt+0GMQyMXZJ6Gpjn5nyMxQL9V6jSCOH2HeWy+yYdj6+0W4IE1Y9IhXEQKilJvsVG9FBvI1CQwObKA2IQuvbtwiJcWRP/FAfUNpDkKBOjeVkzKFbeJF8TAH6dMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4811.eurprd03.prod.outlook.com (2603:10a6:10:30::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 23:50:34 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 23:50:34 +0000
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
Subject: [PATCH v2 07/11] net: phylink: Adjust link settings based on rate adaptation
Date:   Tue, 19 Jul 2022 19:49:57 -0400
Message-Id: <20220719235002.1944800-8-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 976668bb-2b5c-4faa-5cd2-08da69e178b7
X-MS-TrafficTypeDiagnostic: DB7PR03MB4811:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B42cGMLO5yJ3jalCHlWYRhhtTEqf+ERlGfaNpZu5zIYZMNNZDr4Nv9b5mrn5jFZkYhbo7bfsS0FdDkamSIEUl42VpryiolICFf5G3QlcUpG6Pqs/T+2eyE7eEVHw4Iu3zrhE5Y6JAAZnvBKYdpgVlOcluPFFFjvd7hNbvK6OJ1KjWOuEN/fmmx79rt4xA3rrbaWyqrlBNzxuHYSrJWZuanXKzw052d2k3KBGMdn1cd3U0UPvnKUTJSX2nv46uf7OiNxT10kY+zixTLYHd928Fr3ydRrqj6GuDsXKKl/0RkcEqdHaNXbskI16+VBLyLddoFC8NA5GyjR4UQQvpBNjVgO0bjjdZbSsdX/WrqbaFTn3M4CGlp9QdEFlL95gsO4uyWYP/afuJLGyQHzmk9zg6j4e5+aKsejk5XgrK/zwFdpXIznDUykmDwTxZ42N3RjN4geEyOULq54jzLz96LxFOL5JXDAbKo74YjocnZPBcRSByiQQZ9t2w49M8UYT/nzAuohsscmKP5iJEEa6n3fMPHns7H3RX4lrzZR8vuymBP8PBnuHIrPAe+3J5ZbNELmduTyqcYEiVBFtg8C2ZHcojF/iefTLEuC+XZis4piP5Syvbpheplsr7RzqneofCqpGdINkjMJ/yp6FWqnSWAaoIS3viW5a1pkkvi82oQanh1QRVvvZdPk7oWnBaEOJSx9ORIUfvJVR4GKn6Q2Z3pNaXI7R3D6LB8bGc/2KYdnWlgt5Yyg1/AouK8WQXlSL76StwETnWB8Za782KNeEXgVZRWv444G223rFa0KTKW9zxpA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(39850400004)(396003)(376002)(346002)(54906003)(2906002)(1076003)(83380400001)(186003)(66476007)(66946007)(8676002)(6666004)(4326008)(110136005)(36756003)(66556008)(52116002)(26005)(6512007)(6506007)(2616005)(107886003)(38350700002)(478600001)(86362001)(41300700001)(44832011)(5660300002)(316002)(7416002)(8936002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9vkz5dtgkZA9DnNV2HMy431ozFMxA5KgCdPCoI/ulsAUnnEkIP7yBdm4tRQV?=
 =?us-ascii?Q?i5Je4f3cntxtmUz1cxP2fHCj9bEtulDHT6AR+YLdtI+6uIaXFr6XDAJnD/mG?=
 =?us-ascii?Q?wF8mZVGeeahPa7fI26TKv5n5bNLWuI/PWtf1SvzXhuDi4BajtqUcjMqS7JIc?=
 =?us-ascii?Q?6ZLGTuWw3VwN94gR7XoQ9pypohp1JthMp5TX7jrzT7P7R/f10T5/emdx+oD1?=
 =?us-ascii?Q?DkrC9FnXVwYQ63TzXKWHRJ9Dfol5gXF7rJjPjCgp/b7Kgig7jVkoM8OqnG2M?=
 =?us-ascii?Q?NM6so9CFy+04H0OeGqWLwbjBEOxnpXMGGu0bL5KfaO2o6QQTq/o0LBvmyyUq?=
 =?us-ascii?Q?NZdOFZUQDnACRo+yL+TNJgMC57VdsSX7sZt/jr0FolaKnXWR8XGaks07VoM8?=
 =?us-ascii?Q?wo49+01E58TNxzCXQpAfS6cmZBCU40lCGSJeaRZRTj3UGUrHdOJ2jk/98+SB?=
 =?us-ascii?Q?RgCuUOfgYlmk4iziog6meY6EW5qooDaTiPdjWX/H468PRK1UjBgcuAarN48K?=
 =?us-ascii?Q?YGagEWMWScF5mxx5L5i/L/GIag556EmS2HwWMnkV/Mt2qX0PxjB8zCn1a3sX?=
 =?us-ascii?Q?96UEapQZLA+yJwR/j1LJim0AfKHR1JQ2vODJ7u8jNt09JqZ2YslM8ffWvCuA?=
 =?us-ascii?Q?xfxSl4IWUZ7ujDS1VDRKPFkcN87vMfLiqtuTUwHjXsN9zkgY4f4gcnvtwXDx?=
 =?us-ascii?Q?Rul01G7VN8QM8v2krMimCMiBoFb1A2qnEvwtpmT0FYGU2UwLHKU25rtWppZB?=
 =?us-ascii?Q?6+HhO4RWKtp4wYFsKvu1vekbK0/V3HzyV5WQB8nX8ln9g7NZpaK5ObuGZcHM?=
 =?us-ascii?Q?7iDeKMmq1tx0S2sSpFWVCfkD0UTwk7vGkoERHSJTSJhUc/6hEZNLe33vi2bY?=
 =?us-ascii?Q?RAUC5V0/yIV+iXUFVqxg+ftPdIlgYQ0kxecHSElinYIEbfDJLbun7dJJPW6/?=
 =?us-ascii?Q?kcy3LkdSx6nmeFZzAkUkLJJrPfuLm71pJCwoxf8XuL5FqEuw/wScijL7NvhI?=
 =?us-ascii?Q?wkFqw9+qlAKS99yJOuje5Q2Ri5UEuVx/rBpWNfw+77JfzCeouS7iTXxBj9cl?=
 =?us-ascii?Q?pANB2U9IN0LSwbyiu6DinpR7x82YJKulEKxpbXYaDc5w7vkuCLYWgshmFFTf?=
 =?us-ascii?Q?XsNzjMyAaYhx954WOpyDMSnWQ2KeW0KbVnKekSCGYYxBTZ+d0bbw52Ra9vvY?=
 =?us-ascii?Q?m6t1bXV5Emf4HLCRuvyjWS1cj8b/PcSEVp8kpQKM6p8oLuDUFroeehHbvtRo?=
 =?us-ascii?Q?h2a6fHZiicmRVr/U4b9/geDFyLWCUV0TQvEDvkYu17qjxH2pJX5mCGsJkxCF?=
 =?us-ascii?Q?t7nOZNDKbD0AEdVlmCU1CCf+BoW0afIr6mF+hWZTsDK0Jo9yn8IbY0rTD3bg?=
 =?us-ascii?Q?6niRPt/ujjYANLeLL1ZxchwKwrWgzO2xwsYNtjdXzqdnlocf334oszNbqPtA?=
 =?us-ascii?Q?YOFerZVyQZiC/Au0J6fpT5cFA+KVDBYm1M9nlDc6UCZaUy3H7UDemVvPcZHC?=
 =?us-ascii?Q?k9icbrsiHknOD6NU0fr/NC5LGoVn8gbAsATW32KqrmP0qRlb2F6JnSYGeZls?=
 =?us-ascii?Q?JfCNSae2QOxE6el/4nFy5B/Zacubzf2b1aBnnIUg4ogKf3a+9C+8iTbmcLfV?=
 =?us-ascii?Q?Ww=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 976668bb-2b5c-4faa-5cd2-08da69e178b7
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 23:50:34.1281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6B1fSfwBVsPK15CSvSwG96r3JNys8bdR/DqPAdhmL8Rb+pSMxd742Uwrg1vEFxGTWCzu0k6+Fpwt/Zdf+OUU+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4811
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_FILL_THIS_FORM_SHORT
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the phy is configured to use pause-based rate adaptation, ensure that
the link is full duplex with pause frame reception enabled. As
suggested, if pause-based rate adaptation is enabled by the phy, then
pause reception is unconditionally enabled.

The interface duplex is determined based on the rate adaptation type.
When rate adaptation is enabled, so is the speed. We assume the maximum
interface speed is used. This is only relevant for MLO_AN_PHY. For
MLO_AN_INBAND, the MAC/PCS's view of the interface speed will be used.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- Use the phy's rate adaptation setting to determine whether to use its
  link speed/duplex or the MAC's speed/duplex with MLO_AN_INBAND.
- Always use the rate adaptation setting to determine the interface
  speed/duplex (instead of sometimes using the interface mode).

 drivers/net/phy/phylink.c | 126 ++++++++++++++++++++++++++++++++++----
 include/linux/phylink.h   |   1 +
 2 files changed, 114 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index da0623d94a64..619ef553476f 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -160,16 +160,93 @@ static const char *phylink_an_mode_str(unsigned int mode)
  * @state: A link state
  *
  * Update the .speed and .duplex members of @state. We can determine them based
- * on the .link_speed and .link_duplex. This function should be called whenever
- * .link_speed and .link_duplex are updated.  For example, userspace deals with
- * link speed and duplex, and not the interface speed and duplex. Similarly,
- * phys deal with link speed and duplex and only implicitly the interface speed
- * and duplex.
+ * on the .link_speed, .link_duplex, .interface, and .rate_adaptation. This
+ * function should be called whenever .link_speed and .link_duplex are updated.
+ * For example, userspace deals with link speed and duplex, and not the
+ * interface speed and duplex. Similarly, phys deal with link speed and duplex
+ * and only implicitly the interface speed and duplex.
  */
 static void phylink_state_fill_speed_duplex(struct phylink_link_state *state)
 {
-	state->speed = state->link_speed;
-	state->duplex = state->link_duplex;
+	switch (state->rate_adaptation) {
+	case RATE_ADAPT_NONE:
+		state->speed = state->link_speed;
+		state->duplex = state->link_duplex;
+		return;
+	case RATE_ADAPT_PAUSE:
+		state->duplex = DUPLEX_FULL;
+		break;
+	case RATE_ADAPT_CRS:
+		state->duplex = DUPLEX_HALF;
+		break;
+	case RATE_ADAPT_OPEN_LOOP:
+		state->duplex = state->link_duplex;
+		break;
+	}
+
+	/* Use the max speed of the interface */
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_100BASEX:
+	case PHY_INTERFACE_MODE_REVRMII:
+	case PHY_INTERFACE_MODE_RMII:
+	case PHY_INTERFACE_MODE_SMII:
+	case PHY_INTERFACE_MODE_REVMII:
+	case PHY_INTERFACE_MODE_MII:
+		state->speed = SPEED_100;
+		return;
+
+	case PHY_INTERFACE_MODE_TBI:
+	case PHY_INTERFACE_MODE_MOCA:
+	case PHY_INTERFACE_MODE_RTBI:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_1000BASEKX:
+	case PHY_INTERFACE_MODE_TRGMII:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_GMII:
+		state->speed = SPEED_1000;
+		return;
+
+	case PHY_INTERFACE_MODE_2500BASEX:
+		state->speed = SPEED_2500;
+		return;
+
+	case PHY_INTERFACE_MODE_5GBASER:
+		state->speed = SPEED_5000;
+		return;
+
+	case PHY_INTERFACE_MODE_XGMII:
+	case PHY_INTERFACE_MODE_RXAUI:
+	case PHY_INTERFACE_MODE_XAUI:
+	case PHY_INTERFACE_MODE_10GBASER:
+	case PHY_INTERFACE_MODE_10GKR:
+	case PHY_INTERFACE_MODE_USXGMII:
+		state->speed = SPEED_10000;
+		return;
+
+	case PHY_INTERFACE_MODE_25GBASER:
+		state->speed = SPEED_25000;
+		return;
+
+	case PHY_INTERFACE_MODE_XLGMII:
+		state->speed = SPEED_40000;
+		return;
+
+	case PHY_INTERFACE_MODE_INTERNAL:
+		state->speed = state->link_speed;
+		return;
+
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_MAX:
+		state->speed = SPEED_UNKNOWN;
+		return;
+	}
+
+	WARN_ON(1);
 }
 
 /**
@@ -803,11 +880,12 @@ static void phylink_mac_config(struct phylink *pl,
 			       const struct phylink_link_state *state)
 {
 	phylink_dbg(pl,
-		    "%s: mode=%s/%s/%s/%s adv=%*pb pause=%02x link=%u an=%u\n",
+		    "%s: mode=%s/%s/%s/%s/%s adv=%*pb pause=%02x link=%u an=%u\n",
 		    __func__, phylink_an_mode_str(pl->cur_link_an_mode),
 		    phy_modes(state->interface),
 		    phy_speed_to_str(state->speed),
 		    phy_duplex_to_str(state->duplex),
+		    phy_rate_adaptation_to_str(state->rate_adaptation),
 		    __ETHTOOL_LINK_MODE_MASK_NBITS, state->advertising,
 		    state->pause, state->link, state->an_enabled);
 
@@ -944,6 +1022,7 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 	linkmode_zero(state->lp_advertising);
 	state->interface = pl->link_config.interface;
 	state->an_enabled = pl->link_config.an_enabled;
+	state->rate_adaptation = pl->link_config.rate_adaptation;
 	if (state->an_enabled) {
 		state->link_speed = SPEED_UNKNOWN;
 		state->link_duplex = DUPLEX_UNKNOWN;
@@ -968,8 +1047,10 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 	else
 		state->link = 0;
 
-	state->link_speed = state->speed;
-	state->link_duplex = state->duplex;
+	if (state->rate_adaptation == RATE_ADAPT_NONE) {
+		state->link_speed = state->speed;
+		state->link_duplex = state->duplex;
+	}
 }
 
 /* The fixed state is... fixed except for the link state,
@@ -1043,6 +1124,8 @@ static void phylink_link_up(struct phylink *pl,
 	struct net_device *ndev = pl->netdev;
 
 	pl->cur_interface = link_state.interface;
+	if (link_state.rate_adaptation == RATE_ADAPT_PAUSE)
+		link_state.pause |= MLO_PAUSE_RX;
 
 	if (pl->pcs && pl->pcs->ops->pcs_link_up)
 		pl->pcs->ops->pcs_link_up(pl->pcs, pl->cur_link_an_mode,
@@ -1145,6 +1228,18 @@ static void phylink_resolve(struct work_struct *w)
 				}
 				link_state.interface = pl->phy_state.interface;
 
+				/* If we are doing rate adaptation, then the
+				 * link speed/duplex comes from the PHY
+				 */
+				if (pl->phy_state.rate_adaptation) {
+					link_state.rate_adaptation =
+						pl->phy_state.rate_adaptation;
+					link_state.link_speed =
+						pl->phy_state.link_speed;
+					link_state.link_duplex =
+						pl->phy_state.link_duplex;
+				}
+
 				/* If we have a PHY, we need to update with
 				 * the PHY flow control bits.
 				 */
@@ -1380,6 +1475,7 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 	mutex_lock(&pl->state_mutex);
 	pl->phy_state.link_speed = phydev->speed;
 	pl->phy_state.link_duplex = phydev->duplex;
+	pl->phy_state.rate_adaptation = phydev->rate_adaptation;
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	if (tx_pause)
 		pl->phy_state.pause |= MLO_PAUSE_TX;
@@ -1392,10 +1488,11 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 
 	phylink_run_resolve(pl);
 
-	phylink_dbg(pl, "phy link %s %s/%s/%s/%s\n", up ? "up" : "down",
+	phylink_dbg(pl, "phy link %s %s/%s/%s/%s/%s\n", up ? "up" : "down",
 		    phy_modes(phydev->interface),
 		    phy_speed_to_str(phydev->speed),
 		    phy_duplex_to_str(phydev->duplex),
+		    phy_rate_adaptation_to_str(phydev->rate_adaptation),
 		    phylink_pause_to_str(pl->phy_state.pause));
 }
 
@@ -1459,6 +1556,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	pl->phy_state.link_speed = SPEED_UNKNOWN;
 	pl->phy_state.link_duplex = DUPLEX_UNKNOWN;
+	pl->phy_state.rate_adaptation = RATE_ADAPT_NONE;
 	phylink_state_fill_speed_duplex(&pl->phy_state);
 	linkmode_copy(pl->supported, supported);
 	linkmode_copy(pl->link_config.advertising, config.advertising);
@@ -1902,8 +2000,10 @@ static void phylink_get_ksettings(const struct phylink_link_state *state,
 {
 	phylink_merge_link_mode(kset->link_modes.advertising, state->advertising);
 	linkmode_copy(kset->link_modes.lp_advertising, state->lp_advertising);
-	kset->base.speed = state->link_speed;
-	kset->base.duplex = state->link_duplex;
+	if (kset->base.rate_adaptation == RATE_ADAPT_NONE) {
+		kset->base.speed = state->link_speed;
+		kset->base.duplex = state->link_duplex;
+	}
 	kset->base.autoneg = state->an_enabled ? AUTONEG_ENABLE :
 				AUTONEG_DISABLE;
 }
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index ab5edc1e5330..f32b97f27ddc 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -80,6 +80,7 @@ struct phylink_link_state {
 	int duplex;
 	int link_duplex;
 	int pause;
+	int rate_adaptation;
 	unsigned int link:1;
 	unsigned int an_enabled:1;
 	unsigned int an_complete:1;
-- 
2.35.1.1320.gc452695387.dirty

