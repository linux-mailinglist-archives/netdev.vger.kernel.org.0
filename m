Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0393458020C
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235993AbiGYPjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236004AbiGYPiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:38:51 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2061.outbound.protection.outlook.com [40.107.20.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ED51BE82;
        Mon, 25 Jul 2022 08:38:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I20/zKrzq7+5NQuJLnlkZcEqCkf0LtMiqCBTF9HeYIhKN5DrDpT03HF+EcLRO7EcqlawET0SU8bzcj/RVy1WDxcwucl7kPFRrdEjmZFfMreuSBnVZh4GxEfHzrzu0qf2Uny2tk32Uri4Dqy39LtV+KKUC+eKUNvjhg663Jxs4EH6Nqk81n8WqpESlEckZb2twCSnWns7lVsWVe0VVSk/KzbZYJMCeGDcFeGMRMA3QNZ/PTKVc1wir0bwAAw2ITmTw1+Gmj2hznCWStW86Fa4qFr+nvvx/0bIl3c1ed92qusq9BQ3/64nfRassV0ockYl7C8iGoopSrkf2/5Zzh8YtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0a7DmimdmbLWoQByLaXg+qTTE0Nxelpm/Mgz/Ri5TYk=;
 b=W01/hiiTLuR4ET9uiTMHyAXnIhY2sZteM59DBdUhKjOZuFwPnbKt9EUrOQZfDtv67StLAE4Av7fhmdyn/N+uXczBS8DCR0Ryo0j/zriG6oKnikbzHJuWuyqqVkkD/GYR6tLIy8FuwDyE6GxIqJwOo7Boq6euVyycPnPRzjMB6eDcffGpQw+ZE2o06Z5yKoLt5rqq5BR8CzlcanUmsQqpATm4b/WG8baOHweTb+bPR0kyZRo119Yas/ul6D4h2LQeBtLiDwfDMcGMJ/AAKmq9ZbvtIQxUdLoFVabfUX6KN0iWe0NKg68OMnnoyzw2fcMiQUoEiNF06hzvegPNp1jbOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0a7DmimdmbLWoQByLaXg+qTTE0Nxelpm/Mgz/Ri5TYk=;
 b=18Xx5y+h20nFVEXjEcQADKiROw949c3k3jvK63HMgZgs/gFq/xlA/oa9/ffbIwUGhJYuPTOcWtSSa6l721ZMIZBPkwLzSybl9wVf6DD9/MX+Nj39VOmQGdfaBkHLZDLJsQuC+Jsd027Ov1TsgomDKH3ddBOoBC/r+nC+H8zu89r2dq2aa7qtll30Q77+hJbftPShFTv3bKIe6NmLOHCwAlTVM+JlB7Oh81SgHkrM1Pg/mopCDb02i1bLPd0mEfuaTIVGqaR4HqwCOcWUYha9cHCc1YWyn1Bck59LJWsvN6b/Z1L7JmPOW8WPCoCEuoKZClA43EIV4nDEY7n7emCwpg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR03MB6464.eurprd03.prod.outlook.com (2603:10a6:800:19e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 15:37:55 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:37:55 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v3 08/11] net: phylink: Adjust link settings based on rate adaptation
Date:   Mon, 25 Jul 2022 11:37:26 -0400
Message-Id: <20220725153730.2604096-9-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725153730.2604096-1-sean.anderson@seco.com>
References: <20220725153730.2604096-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:208:32e::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5600781-ee76-49f8-9cba-08da6e53a4c3
X-MS-TrafficTypeDiagnostic: VI1PR03MB6464:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U089GrvTrd+aVl52FOJvyn2Lh59yhgja0qrSR4XFjeQ7kYsTCOE35ewdpiLWB4R0Uws9B9wN2jXe/LG1uhrS31GthO/UkxkWyaa50c4mBf+HQL9XmA3bXRIZZs7RNf6bQNPh0NM1WgcQC4YkiPvtDjtMwz17+O06BgycIfnxc6ps4SLLnlB+028dyO6do+DWpHSF+OS2q0pOiXeSG+Ha3JT0GdB+fSOO04WLQP2XoHLp5ZuC08wpNZnMKSMcaBDL4YL7OKsaLdzZ1qT5P2DMGAXK3iYSism7xlH7eC4aUh4MaK/jPk5ZSjDu3Xkaxbb+2bixCvFnGjBxrvTyiqLqtSlh2dLgyEsW2KOa+qbyYm2Ft98UxBrek6RSW5lcpP1eIBt7osgkta5ePP4HNGIEXVbhRw7Auv9sGW1ieNYaUkr+5suWPvMzn6LbQBYDp3PLjeA7mtbDHlX2FxPkoUEO6ytuMKtWU3DDN5eQisPjbeb7K65SyP/kskBnC9+0/xSczkiBdpC3fXORLCEKLUM7yrPmwriyvrhuyd8c6Z5NO39+GsWY/SGI3lJpfjUcAm/TJq9wY28ISrfvmPDJJyJ2cXzT5xs8acEmh66qaL+0rZCt8VfanRyMEKmXqlN8abGoFS74fA1tH2jCCjnttTOUb9td/Y+qW3DVYAxNM48YsDY2nY/1Gv4z6d8X2ryQ2sfi9PMZID186BVoOC+P5Og/msBzLU3Gpn9imBlKrOus5rzG8rGTLuarwEMhW4wpscpDplRsoLnbWFIGOWvYW5VaBNh+MOHvSuFhE3ITXRiqbYU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(396003)(346002)(366004)(376002)(84040400005)(36756003)(110136005)(54906003)(186003)(38350700002)(8676002)(66556008)(66946007)(316002)(66476007)(38100700002)(8936002)(86362001)(2616005)(478600001)(4326008)(5660300002)(6666004)(83380400001)(7416002)(6506007)(41300700001)(6486002)(44832011)(30864003)(26005)(6512007)(52116002)(107886003)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D+IFXz0A2RRR0M2R8C3WuyaU6pRJO13HeOX02m5sAlysBJLMgGnrPZ4fGuM9?=
 =?us-ascii?Q?8I8/R0fhsHWdf1Vpm/3NfHXUlsylOAifJNbdCPJMCcxp6iswWJ/vhlZHvQzz?=
 =?us-ascii?Q?CsaGlqCEEojPLuX6rVwmbzR3GbiAKCENwzECqLj8J+DuQzGLBvIn9h1oGQ5C?=
 =?us-ascii?Q?s8fVQAApjA0lCh4TiG2ChQWh7PQS1b4v+sd504zRXCB8s3l81RnM4lXMbxJW?=
 =?us-ascii?Q?Rj29phfMVq6zxVDtUwgq2U4EFC+7w4N4XfrtVL3dEZ3YwVB2sm7+KCO0comm?=
 =?us-ascii?Q?pF+ThiqWbRwxg+Dg/6rH5gpUx9vVBs2hW7GggzInOK/jND3P7X6VMLAT3SGk?=
 =?us-ascii?Q?m2okSSWO0hSaaz54EmYeAuyWn929vjpu5mtjbS+3n+M5GfZGumHjug+yuvZq?=
 =?us-ascii?Q?7V7yilO2ltlhXm0WRFxZURKsttBNNZ7yk5HpNJF0aJmF9qTru315gpABlGk5?=
 =?us-ascii?Q?c+Cg471m7mFrEppyJuBIzoNVDr0trqlH7u8UmugTsHXvtXlvplDtR1OmoPMq?=
 =?us-ascii?Q?P+S162mZDrqyJmMhm8bV2uQ7PyQcoZJX201Pd196EX1OxUOaV/VBSUBpOmKu?=
 =?us-ascii?Q?rFGw1MTGgLvo/Vu2bZ6LmbzYibxUQnvEDv591Oyazq3OmEAx5ehC2smis7Fs?=
 =?us-ascii?Q?gZe1i5wkrHfpFidVV4o7ZJGhzjASF9+Dxch7lA1Kbxqp7Frvng2cauEdrBXl?=
 =?us-ascii?Q?DyDWmN/FGl3gPVfMNbkLzzewM/JNeV4/Tuu7QsUO0a5wG431ANhr/WLzR40L?=
 =?us-ascii?Q?IC3x5FEJq4Us0WbKv2pVxSzombtQDSHGASW/es839phJVgBx7uNfKLIz5/SY?=
 =?us-ascii?Q?gqLd6jQX0Ndj36GHDwBn5fagJajw+2iSIfJovi0bFAZmjM9SXwdstKzGSBUl?=
 =?us-ascii?Q?kcg9PYUAoZF+TO6uMrNqTnb1DnZ9pR0bKSWKJH1lkcK+hGLr5+UvrjJGcUPX?=
 =?us-ascii?Q?Zhw4AGMK/eg5mxIwSOW7EVJpQYDDuhOS8awz4GhIiRHeF95kYnhamDqzAwEn?=
 =?us-ascii?Q?p4PRM9HFT/LgplcGyNrEStGW2oa1xpYh3GFJjHEy5caUkWm56TBucgaNNqMp?=
 =?us-ascii?Q?/Yt7N3CCGl9E8fQ7fUcXMD2iSXVIgM+indCC6ENlkQAIQdZL6s7lZ/il1YTP?=
 =?us-ascii?Q?Iaz5VRIeUfYHec7XvfpEVDyhNFGYJQ5pOQNjn/2JPqIXzEAzoraVDVuzGjW1?=
 =?us-ascii?Q?V1JzKiwbt4UtoYoBkhNJeKDPtW10ez9WysZxO0RSHe3jtF30+IYc+UPydxYo?=
 =?us-ascii?Q?0XBPtokGS1eN8VIEt98dPypjEKind6/aSCG9ilWZJeL/jCBtduDQkt1pXfTi?=
 =?us-ascii?Q?toTJFvO3bTZpNWM65+LziHibdvFneKfcVqleHerz4XTNhHx60dxRM1cIuWwR?=
 =?us-ascii?Q?77ETDwrWOhEhBQbZvNSfrq5MEWRfK2wIxqYmiFjMmjuGRg0i8C+EZ8W6xo+X?=
 =?us-ascii?Q?oXoKbRAOjC4Nh1jUS8bi0Sx84QvTdmDcGWs9VBGwooNFIIlFFarB4/IW+yCs?=
 =?us-ascii?Q?Umu175dsDsnmeJ9SYzjvDAgDhoSqBpSjA7aH3TwUpVUB2dw/ZTT39r5rlIhh?=
 =?us-ascii?Q?4eyZHzVdP7aKI18rJlG3pKkFinlXBEOX5c0cimzGePmohpkKWZ7fp8g8R3ZB?=
 =?us-ascii?Q?bg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5600781-ee76-49f8-9cba-08da6e53a4c3
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:37:55.2595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 52/oWyirhII9/GoF+8aQy4Mj3917D3ykeMKfZcffEnp9ZZD09SJWSA6CmIq+YsnsUSbXxpGjEdUUx9zHJtUMbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6464
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Although there are no RATE_ADAPT_CRS phys in-tree, it has been added for
comparison (and the implementation is quite simple).

Co-developed-by: Russell King <linux@armlinux.org.uk>
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
Russell, I need your SoB as well as RB, since you wrote some of this.

Changes in v3:
- Modify link settings directly in phylink_link_up, instead of doing
  things more indirectly via link_*.

Changes in v2:
- Use the phy's rate adaptation setting to determine whether to use its
  link speed/duplex or the MAC's speed/duplex with MLO_AN_INBAND.
- Always use the rate adaptation setting to determine the interface
  speed/duplex (instead of sometimes using the interface mode).

 drivers/net/phy/phylink.c | 160 +++++++++++++++++++++++++++++++++++---
 include/linux/phylink.h   |   5 ++
 2 files changed, 153 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 72bf6b607320..27b60a89ddc6 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -155,6 +155,74 @@ static const char *phylink_an_mode_str(unsigned int mode)
 	return mode < ARRAY_SIZE(modestr) ? modestr[mode] : "unknown";
 }
 
+/**
+ * phylink_interface_max_speed() - get the maximum speed of a phy interface
+ * @interface: phy interface mode defined by &typedef phy_interface_t
+ *
+ * Determine the maximum speed of a phy interface. This is intended to help
+ * determine the correct speed to pass to the MAC when the phy is performing
+ * rate adaptation.
+ *
+ * Return: The maximum speed of @interface
+ */
+static int phylink_interface_max_speed(phy_interface_t interface)
+{
+	switch (interface) {
+	case PHY_INTERFACE_MODE_100BASEX:
+	case PHY_INTERFACE_MODE_REVRMII:
+	case PHY_INTERFACE_MODE_RMII:
+	case PHY_INTERFACE_MODE_SMII:
+	case PHY_INTERFACE_MODE_REVMII:
+	case PHY_INTERFACE_MODE_MII:
+		return SPEED_100;
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
+		return SPEED_1000;
+
+	case PHY_INTERFACE_MODE_2500BASEX:
+		return SPEED_2500;
+
+	case PHY_INTERFACE_MODE_5GBASER:
+		return SPEED_5000;
+
+	case PHY_INTERFACE_MODE_XGMII:
+	case PHY_INTERFACE_MODE_RXAUI:
+	case PHY_INTERFACE_MODE_XAUI:
+	case PHY_INTERFACE_MODE_10GBASER:
+	case PHY_INTERFACE_MODE_10GKR:
+	case PHY_INTERFACE_MODE_USXGMII:
+		return SPEED_10000;
+
+	case PHY_INTERFACE_MODE_25GBASER:
+		return SPEED_25000;
+
+	case PHY_INTERFACE_MODE_XLGMII:
+		return SPEED_40000;
+
+	case PHY_INTERFACE_MODE_INTERNAL:
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_MAX:
+		/* No idea! Garbage in, unknown out */
+		return SPEED_UNKNOWN;
+	}
+
+	/* If we get here, someone forgot to add an interface mode above */
+	WARN_ON_ONCE(1);
+	return SPEED_UNKNOWN;
+}
+
 /**
  * phylink_caps_to_linkmodes() - Convert capabilities to ethtool link modes
  * @linkmodes: ethtool linkmode mask (must be already initialised)
@@ -360,6 +428,30 @@ int phylink_caps_find_max_speed(unsigned long caps, int *speed,
 }
 EXPORT_SYMBOL_GPL(phylink_caps_find_max_speed);
 
+/**
+ * phylink_cap_from_speed_duplex - Get mac capability from speed/duplex
+ * @speed: the speed to search for
+ * @duplex: the duplex to search for
+ *
+ * Find the mac capability for a given speed and duplex.
+ *
+ * Return: A mask with the mac capability patching @speed and @duplex, or 0 if
+ *         there were no matches.
+ */
+static unsigned long phylink_cap_from_speed_duplex(int speed,
+						   unsigned int duplex)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(phylink_caps_params); i++) {
+		if (speed == phylink_caps_params[i].speed &&
+		    duplex == phylink_caps_params[i].duplex)
+			return phylink_caps_params[i].mask;
+	}
+
+	return 0;
+}
+
 /**
  * phylink_get_capabilities() - get capabilities for a given MAC
  * @interface: phy interface mode defined by &typedef phy_interface_t
@@ -840,11 +932,12 @@ static void phylink_mac_config(struct phylink *pl,
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
 
@@ -981,7 +1074,8 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 	linkmode_zero(state->lp_advertising);
 	state->interface = pl->link_config.interface;
 	state->an_enabled = pl->link_config.an_enabled;
-	if  (state->an_enabled) {
+	state->rate_adaptation = pl->link_config.rate_adaptation;
+	if (state->an_enabled) {
 		state->speed = SPEED_UNKNOWN;
 		state->duplex = DUPLEX_UNKNOWN;
 		state->pause = MLO_PAUSE_NONE;
@@ -1064,19 +1158,45 @@ static void phylink_link_up(struct phylink *pl,
 			    struct phylink_link_state link_state)
 {
 	struct net_device *ndev = pl->netdev;
+	int speed, duplex;
+	bool rx_pause;
+
+	speed = link_state.speed;
+	duplex = link_state.duplex;
+	rx_pause = !!(link_state.pause & MLO_PAUSE_RX);
+
+	switch (link_state.rate_adaptation) {
+	case RATE_ADAPT_PAUSE:
+		/* The PHY is doing rate adaption from the media rate (in
+		 * the link_state) to the interface speed, and will send
+		 * pause frames to the MAC to limit its transmission speed.
+		 */
+		speed = phylink_interface_max_speed(link_state.interface);
+		duplex = DUPLEX_FULL;
+		rx_pause = true;
+		break;
+
+	case RATE_ADAPT_CRS:
+		/* The PHY is doing rate adaption from the media rate (in
+		 * the link_state) to the interface speed, and will cause
+		 * collisions to the MAC to limit its transmission speed.
+		 */
+		speed = phylink_interface_max_speed(link_state.interface);
+		duplex = DUPLEX_HALF;
+		break;
+	}
 
 	pl->cur_interface = link_state.interface;
+	if (link_state.rate_adaptation == RATE_ADAPT_PAUSE)
+		link_state.pause |= MLO_PAUSE_RX;
 
 	if (pl->pcs && pl->pcs->ops->pcs_link_up)
 		pl->pcs->ops->pcs_link_up(pl->pcs, pl->cur_link_an_mode,
-					 pl->cur_interface,
-					 link_state.speed, link_state.duplex);
+					  pl->cur_interface, speed, duplex);
 
-	pl->mac_ops->mac_link_up(pl->config, pl->phydev,
-				 pl->cur_link_an_mode, pl->cur_interface,
-				 link_state.speed, link_state.duplex,
-				 !!(link_state.pause & MLO_PAUSE_TX),
-				 !!(link_state.pause & MLO_PAUSE_RX));
+	pl->mac_ops->mac_link_up(pl->config, pl->phydev, pl->cur_link_an_mode,
+				 pl->cur_interface, speed, duplex,
+				 !!(link_state.pause & MLO_PAUSE_TX), rx_pause);
 
 	if (ndev)
 		netif_carrier_on(ndev);
@@ -1168,6 +1288,17 @@ static void phylink_resolve(struct work_struct *w)
 				}
 				link_state.interface = pl->phy_state.interface;
 
+				/* If we are doing rate adaptation, then the
+				 * link speed/duplex comes from the PHY
+				 */
+				if (pl->phy_state.rate_adaptation) {
+					link_state.rate_adaptation =
+						pl->phy_state.rate_adaptation;
+					link_state.speed = pl->phy_state.speed;
+					link_state.duplex =
+						pl->phy_state.duplex;
+				}
+
 				/* If we have a PHY, we need to update with
 				 * the PHY flow control bits.
 				 */
@@ -1402,6 +1533,7 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 	mutex_lock(&pl->state_mutex);
 	pl->phy_state.speed = phydev->speed;
 	pl->phy_state.duplex = phydev->duplex;
+	pl->phy_state.rate_adaptation = phydev->rate_adaptation;
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	if (tx_pause)
 		pl->phy_state.pause |= MLO_PAUSE_TX;
@@ -1413,10 +1545,11 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 
 	phylink_run_resolve(pl);
 
-	phylink_dbg(pl, "phy link %s %s/%s/%s/%s\n", up ? "up" : "down",
+	phylink_dbg(pl, "phy link %s %s/%s/%s/%s/%s\n", up ? "up" : "down",
 		    phy_modes(phydev->interface),
 		    phy_speed_to_str(phydev->speed),
 		    phy_duplex_to_str(phydev->duplex),
+		    phy_rate_adaptation_to_str(phydev->rate_adaptation),
 		    phylink_pause_to_str(pl->phy_state.pause));
 }
 
@@ -1480,6 +1613,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	pl->phy_state.speed = SPEED_UNKNOWN;
 	pl->phy_state.duplex = DUPLEX_UNKNOWN;
+	pl->phy_state.rate_adaptation = RATE_ADAPT_NONE;
 	linkmode_copy(pl->supported, supported);
 	linkmode_copy(pl->link_config.advertising, config.advertising);
 
@@ -1922,8 +2056,10 @@ static void phylink_get_ksettings(const struct phylink_link_state *state,
 {
 	phylink_merge_link_mode(kset->link_modes.advertising, state->advertising);
 	linkmode_copy(kset->link_modes.lp_advertising, state->lp_advertising);
-	kset->base.speed = state->speed;
-	kset->base.duplex = state->duplex;
+	if (kset->base.rate_adaptation == RATE_ADAPT_NONE) {
+		kset->base.speed = state->speed;
+		kset->base.duplex = state->duplex;
+	}
 	kset->base.autoneg = state->an_enabled ? AUTONEG_ENABLE :
 				AUTONEG_DISABLE;
 }
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index a5a236cfacb6..192a18a8674a 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -75,6 +75,10 @@ static inline bool phylink_autoneg_inband(unsigned int mode)
  * @speed: link speed, one of the SPEED_* constants.
  * @duplex: link duplex mode, one of DUPLEX_* constants.
  * @pause: link pause state, described by MLO_PAUSE_* constants.
+ * @rate_adaptation: rate adaptation being performed, one of the RATE_ADAPT_*
+ *   constants. If rate adaptation is taking place, then the speed/duplex of
+ *   the medium link mode (@speed and @duplex) and the speed/duplex of the phy
+ *   interface mode (@interface) are different.
  * @link: true if the link is up.
  * @an_enabled: true if autonegotiation is enabled/desired.
  * @an_complete: true if autonegotiation has completed.
@@ -86,6 +90,7 @@ struct phylink_link_state {
 	int speed;
 	int duplex;
 	int pause;
+	int rate_adaptation;
 	unsigned int link:1;
 	unsigned int an_enabled:1;
 	unsigned int an_complete:1;
-- 
2.35.1.1320.gc452695387.dirty

