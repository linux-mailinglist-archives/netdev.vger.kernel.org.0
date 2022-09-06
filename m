Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58E95AF0E5
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbiIFQlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 12:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234649AbiIFQku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:40:50 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60081.outbound.protection.outlook.com [40.107.6.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78027861FD;
        Tue,  6 Sep 2022 09:19:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7en/RGPGghQqxFa/qOjClVlHmZkCZDLNc9ofyz3wmMzKxsc1keuXfhgoSRkJArUXxgwWFJZwvgrWjHihZ4EkJgWrpaHZ671Nki/J+VlKHa+jLXeBD3C1PAGFnPwoVmrh0zSkL/qclabJW1ewLqv0r85AZHU+wgSTjK6Nlfyd3Bvb+khsLj0fus8lopTjxRMFOCweq9aVBFTu7NpowA9KaO4RBjgxQ+HWX9C8bSOsHaNLFlWqvSAjAmUK9oSnwc/u6zgFjCDNDVucAxpXLRp+/o8aF01284tCPU2qhCyGouKe2tNNBzZL9DraGIKhqlKMtIIkqOGS6JCmL9musT9NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oBB1mhdyh9YzU2vFlFtwpeLoSGrAGLifLsj76S8Kvck=;
 b=Q3tOPzodWkeAoafLRe7RFo3BVCao8hcWfCMWAxpow8wXbE02zufUK+eNgcWSuZUMFL4eiAqEZ2CucvFnZUrRABCMPmhhYDoVAdwm/ffRk880Jg1668fErjTflwQglJUxtYb09b5Y2Ty8CwvkjB6FLLvnBxdjgAXwsiie2jXUY4stlllHVlJrpiEe6kXzG+H/PurdvFBttVG+DcUyQf+DGxOddAQV2+4kFBBFZRz+qlXsniOh20kCQwrgLDWTSBG+jM2CqiJLkxXMlAVVzYP8oJKG5ex2uDT082RAuYq7qhIgjdj0os4CrJPs3nAe3s0YVHYITHwsSuA+d4X1ZdDtkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBB1mhdyh9YzU2vFlFtwpeLoSGrAGLifLsj76S8Kvck=;
 b=gFrbdt4USrx8PNk8JaLic55QU277k49GEVRgsiYOyOIzZRLICdYirG4jmf+nzLsXH4BkXh6iouMLfnE4rvec7mIkJN+uDUbxBXr3k53AUNdgAnYdXJKNfc4PZrdxnMgQ8vgRlg+TsJXx1XfBbRd6lULTkItdXFQ+nhYpsGzFSqLDAupNli2Ofaz2VYadYsyUQKaETmBws3Eaw1wJkfM5n/Un7QBb55oWAvpJnYtUW//faMPWnr03sCYnf7pxmQN6OHkW0sTPrSiAz90Ytuof2DbH/uQdRQLSZVCph37cmRPyQw+pvrzBx3e0pg4c0mUXm55etHOVQyws6DiTvj52pw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VE1PR03MB5664.eurprd03.prod.outlook.com (2603:10a6:803:11d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Tue, 6 Sep
 2022 16:19:13 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 16:19:12 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v5 5/8] net: phylink: Adjust link settings based on rate adaptation
Date:   Tue,  6 Sep 2022 12:18:49 -0400
Message-Id: <20220906161852.1538270-6-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220906161852.1538270-1-sean.anderson@seco.com>
References: <20220906161852.1538270-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:207:3d::23) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e206706-702b-4811-54f2-08da9023884c
X-MS-TrafficTypeDiagnostic: VE1PR03MB5664:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VC/0VzGFQsdlJn1JxTX1R2MkFsBj6maWUViQeeF1kcn4RiffvU7i7lOy2F+m6foclIpjqOumMoihenlpCk5mZ32m+qULOIFcuyvDEB8nTdXgeADO5JZQnfE7nyHVmwuYqNQQnDXiSa6cNt+alzf7RP14D3dUaYaa0wFxe3N7jk7BAG7QGMHT3esVALnOOHJ9r2HWYucTnm0IcpaABAn4lgF/OnW8P4PtRyUk+TvgEHxb7vToGZPeGXdT8wlBbSuEqPNkrbWBu+11bNRWY4YuIm7aj43GxkQPpxqBtD0feTlrmxZ/b3cBnAXuMykLyCemwQ7TCMsrV/WgujCikCfKd8TrTG0uMdiq7tEXX65uRSApItjGhdHnWjeoyqGSHf+6tpb4dk/ZMWce22ewvM30Td7UZ9pYEZ7WsB1w/I3ilaGc8N1oHY4fRMYKfJEN6zmXIKR8WD7vbrIF1fKEERS8OpjHkgRUuRycluUBdMGux83aulDDB6QSMpejdwsStz8/+Rt5T58XL3ZrooSrna9woaoyv7fUItjvpGgq3m0gWfCHmMAfdfNm/zMR99UuopKZ2LCB4zT0YDJg2+r6kRp8FgOCMDhXa9Kbw2cUUIRnNuA40Z7i5YtG1NDSWKyMq4quDJgQLDLK5IVcFcJmw5IKU1Zf5MXWqXP+cOxqVP1HqPvsCZaWRQJeHwN37K5kZp/PfyzDkaB7Ptm5YiI2a4fm294xG9UHLO3Dzod/OGVjpExAM9sW46m9MKP2A/ViXhf8rLPtgCUrE7IezF3YnJ1o0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(39850400004)(346002)(366004)(396003)(84040400005)(6666004)(26005)(6512007)(6506007)(41300700001)(107886003)(2906002)(38350700002)(83380400001)(478600001)(38100700002)(6486002)(36756003)(4326008)(7416002)(66556008)(66946007)(110136005)(54906003)(316002)(5660300002)(44832011)(8676002)(66476007)(86362001)(8936002)(186003)(52116002)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ApEAcZj84PVtFFh+99NfUiui3UFD85bD3I2tx3jIuwMjvy3mmLFCSXMJSiDZ?=
 =?us-ascii?Q?t0f1EtZhohJllN7t0U9x/hPM/hyNczlnihYXJ3Ylz9rsVIoaJtTOLMxEoTrW?=
 =?us-ascii?Q?lKMzf0JSZMa5u4WyqXHL2R6+bjnmnQBkPBkTiDwAcsX33TuMDqq5IZJYND5h?=
 =?us-ascii?Q?T39r5MS3bu6JwJpbHB71oTfJN6M3PuKgAiGpCEyys3+j0If+0o5xXljIgh5d?=
 =?us-ascii?Q?0P71b0JzLRJ04Pv+7oZ3tkArz271ZPHk9VOx6xuMCClIDE3HqP4e/XynpRo0?=
 =?us-ascii?Q?7jcKXrjHwh+5z9oaqpbsHOIfPb9OfyUU7OvVnFpiKtgDiNtkWYAu05RR8yND?=
 =?us-ascii?Q?8Rc5cysP6yoHsQsLOVqsiQSrq1RXmSAmjrQt4CK7zu5E+v8LT89iGrVI5DwX?=
 =?us-ascii?Q?KAUjEcBDfPvSUQXU5s44VcxEit3GET9qqxIwUGS4WZTTzpgzg58uA0/pCfJE?=
 =?us-ascii?Q?pHdtE/us+UcEs0eAefBJlelxx3HrTd0L7XXlyBqz5vkmstCoqGM5SvOuMWXo?=
 =?us-ascii?Q?OUuXjvT1KzvmERnJxS50y0FCCtboP20ebH23rmmRzQebtkjy1WL6Md1lDGwl?=
 =?us-ascii?Q?aGVoRPLYT+kz5aTg9umfLuGO7KBotDGe5kjbsvnJV6fwyFeyD2ccukGcn145?=
 =?us-ascii?Q?p+6uk0wqiJ1+m+wStZBBff5njxyamqYNwoapN5NMntvXN+CeEsSEHivxxEzM?=
 =?us-ascii?Q?LlvAfWVRGfSOuGn+jJfNSlpzWoNx/FmpEuSu+iwbxg0QsEIknSYeW7ZAMNTx?=
 =?us-ascii?Q?uyEcDOROJkZ8MA1WCGv/L1Ejp8ibSid0xrCeUSWs6VFQFCCa2Njx3kMeJsRu?=
 =?us-ascii?Q?x4aHxsNj7ixqctEZeSisCzz1XK5QggLPFycTUhI9g9akSZEXxtlAusEYth59?=
 =?us-ascii?Q?X9lRJvPoS4sSfPhTvsXNO/eVAZdy/4a+T6S+fVgcVw2hSYK6p+nvcyb5/NGZ?=
 =?us-ascii?Q?X33tWVyBR+trXNQHIIPePpIjf/AYygzTgLirhzNQv3Zymk8ifBAKyRtJnd1f?=
 =?us-ascii?Q?dQM9inOwW8OYNkfRtBwWY3N88sgd0EGOfZ53K8cgBJLJ69LWbU84fN94hQ/e?=
 =?us-ascii?Q?iXidRd2gcqZImPJ5Tk2v4xPPidds1RpUNHY73RzArb/+EJoPME+OMFVFYxsV?=
 =?us-ascii?Q?MnWoSzHLwVHvqsJG41eC+xpHSujbY6LfYH2R64kLy3LgL5TZ9jnUIus/Tza8?=
 =?us-ascii?Q?kqNOE5wFH77z2Q6CGuoVTlr1zC2FtsG3zRJNnYPQ2H7xOTXTbjBk/XkAl6rL?=
 =?us-ascii?Q?ac4pbPZJfHDUQPtPM0Nt8gQYHKpEeOCECC1I0tXXso2a42CnhwF0LIm4Jtvm?=
 =?us-ascii?Q?hSJszdQKb5174VjHMG6RMvcObp/7P1wOCafarMDVhQ0o917L9Y1hgWLrVNkq?=
 =?us-ascii?Q?oH9zuxs/wd30MC895BvE7hGXM9Fbqo9mvExtYbe2f7k4eq8NQ31lZPGQrTyT?=
 =?us-ascii?Q?h/j7b4t6r7Lts2ByyF4de5ILTpiHMFoFcUXiDTvTtHfCxLivjOUXG6y84hvq?=
 =?us-ascii?Q?6GrRl0btAKCyp81IL4GmSAC775xGGsvjA9f2/CxSOOTCeClwcsAYTtDeTIJp?=
 =?us-ascii?Q?brCmAW3UnhNT7AaCH/q8dfL2IT8DQnXnuwh4iAl68VKYsODoWNQTm54aGYpo?=
 =?us-ascii?Q?og=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e206706-702b-4811-54f2-08da9023884c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 16:19:11.3024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZurZZAG0Xr3FmxckW5IGVtK54TKN1epSglG/+j7JXYR/Z4+R8puvVMmrHnOxzDyqdpJNCskx6hq8IJw1uQZ/iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR03MB5664
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
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

Although there are no RATE_ADAPT_CRS phys in-tree, it has been added for
comparison (and the implementation is quite simple).

Co-developed-by: Russell King <linux@armlinux.org.uk>
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
Russell, I need your SoB as well as RB, since you wrote some of this.

(no changes since v4)

Changes in v4:
- Remove phylink_interface_max_speed, which was accidentally added

Changes in v3:
- Modify link settings directly in phylink_link_up, instead of doing
  things more indirectly via link_*.

Changes in v2:
- Use the phy's rate adaptation setting to determine whether to use its
  link speed/duplex or the MAC's speed/duplex with MLO_AN_INBAND.
- Always use the rate adaptation setting to determine the interface
  speed/duplex (instead of sometimes using the interface mode).

 drivers/net/phy/phylink.c | 137 ++++++++++++++++++++++++++++++++++----
 include/linux/phylink.h   |   5 ++
 2 files changed, 130 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 1f022e5d01ba..8ce110c7be5c 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -155,6 +155,75 @@ static const char *phylink_an_mode_str(unsigned int mode)
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
+	case PHY_INTERFACE_MODE_QUSGMII:
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
@@ -791,11 +860,12 @@ static void phylink_mac_config(struct phylink *pl,
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
 
@@ -932,7 +1002,8 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 	linkmode_zero(state->lp_advertising);
 	state->interface = pl->link_config.interface;
 	state->an_enabled = pl->link_config.an_enabled;
-	if  (state->an_enabled) {
+	state->rate_adaptation = pl->link_config.rate_adaptation;
+	if (state->an_enabled) {
 		state->speed = SPEED_UNKNOWN;
 		state->duplex = DUPLEX_UNKNOWN;
 		state->pause = MLO_PAUSE_NONE;
@@ -1015,19 +1086,45 @@ static void phylink_link_up(struct phylink *pl,
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
@@ -1119,6 +1216,17 @@ static void phylink_resolve(struct work_struct *w)
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
@@ -1353,6 +1461,7 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 	mutex_lock(&pl->state_mutex);
 	pl->phy_state.speed = phydev->speed;
 	pl->phy_state.duplex = phydev->duplex;
+	pl->phy_state.rate_adaptation = phydev->rate_adaptation;
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	if (tx_pause)
 		pl->phy_state.pause |= MLO_PAUSE_TX;
@@ -1364,10 +1473,11 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 
 	phylink_run_resolve(pl);
 
-	phylink_dbg(pl, "phy link %s %s/%s/%s/%s\n", up ? "up" : "down",
+	phylink_dbg(pl, "phy link %s %s/%s/%s/%s/%s\n", up ? "up" : "down",
 		    phy_modes(phydev->interface),
 		    phy_speed_to_str(phydev->speed),
 		    phy_duplex_to_str(phydev->duplex),
+		    phy_rate_adaptation_to_str(phydev->rate_adaptation),
 		    phylink_pause_to_str(pl->phy_state.pause));
 }
 
@@ -1431,6 +1541,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	pl->phy_state.speed = SPEED_UNKNOWN;
 	pl->phy_state.duplex = DUPLEX_UNKNOWN;
+	pl->phy_state.rate_adaptation = RATE_ADAPT_NONE;
 	linkmode_copy(pl->supported, supported);
 	linkmode_copy(pl->link_config.advertising, config.advertising);
 
@@ -1873,8 +1984,10 @@ static void phylink_get_ksettings(const struct phylink_link_state *state,
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
index c2aa49c692a0..1524846e01b4 100644
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

