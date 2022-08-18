Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA78598947
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344928AbiHRQqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345030AbiHRQqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:46:42 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2050.outbound.protection.outlook.com [40.107.22.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250CBBFEB5;
        Thu, 18 Aug 2022 09:46:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n0h5ZHuHA7e7zIkh15XD5zuzFqkVkISj13XrTla9br66uutJJNYPLnHSO/ZPkFjgSDRMcmrEsbZa3cOUWuNvOdw1YGJkv8I648zI59KMqrt1AwV9ZOvw1v1ozdAfrVpQrd7B6uMxyx4JhUwIDjS3V9fEOCyhkXqj86cU4hHfbYZgPzY30GxHoGfxtOIkSazPy9w3qEpd6wNIi3aXW92nB4EVFQUA9dx1eGwun25FiTVud5NjtZ29cLBRVOEHD2agnSvbBe8ZM7U6VVHT+GpvOCxfnkqj9vYlb+VzdZCDwd56u85i9xORnqgiC8xQeym5Dh9EsHRotAHGkBsA2izOsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s1rPMsKfqnEwh2ufY/Dqe8o4eHy5wNrBwrdjN0IPY74=;
 b=TFHmCM3TauiIPPUW6EbuwXYHaOWXzwayGzhrs6uwHYMWWqq/RiV3zyHZKLHaM+pVF982R9BeroTQnMTDz/DVd8WL5wYEjsMZmGQerkfEj3LaXJov8C7on6/Lo2drtsN0tHBcQb0MVySb9G6OOS5njCLYCViJ+OTxui1vpY4Rsq1iQfdeuuiBTkOJuq3aFNJRJDZccAmp4rpdan2cgjQQYrw6reqdaaNPIDkwITk85tOEZfHuOLxlEfXZX6UXoykE4Ku6VlTtYuJkMJkp83NsuNGBQEr/yQ3peAcLnAXinaG8DorsQ2wYseQFswlXKhCJesviV5iNETUtpEkSB8egTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s1rPMsKfqnEwh2ufY/Dqe8o4eHy5wNrBwrdjN0IPY74=;
 b=k6kaCNuomAHTgRT0Fv7HBJi0YaeZAgXLvZHc2GiyvZbViIDLXWrZZm1VFxiTU03YA04EAqVVFYJc07QWvyLQPpw0inw/5eRrfZSOF49VeNrhJXvOAmwWNC7DsV7LEThCBkJ8WYf2y/E0arjEZRZTEx9r8DzTZE3aAgY+fT+rvMQpr0Z2Kz8qIfY5K3wtSxV5oZIURQ4zDE63AYjes06ZTAxMaom6gzZ8uEprdTrSLvT/RONZIYDxnQjPe+ADhXnjvT0H03n6Wgf7XkVoUeJ7xQo7nN/qnvoPq5fNv55ApZcujBYqE5O9/DhZREYUms0aLq3OCQVQV9fGrLPhrd8u0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7649.eurprd03.prod.outlook.com (2603:10a6:102:1dc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:46:39 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:46:38 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v4 07/10] net: phylink: Adjust link settings based on rate adaptation
Date:   Thu, 18 Aug 2022 12:46:13 -0400
Message-Id: <20220818164616.2064242-8-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818164616.2064242-1-sean.anderson@seco.com>
References: <20220818164616.2064242-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0019.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e56dee6a-1808-476d-bd1a-08da81393872
X-MS-TrafficTypeDiagnostic: PAXPR03MB7649:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tQKSFfzY+rMudDGHldlgub6fSRSgRlrurmmHTniJefpfHxzBNZbu/sE+GGcI0v3y8qIq4VGgEeci8o87gnAuKoVhrcCMtE2bEzgWlEeYzW1FdEvKtjBQo/vsjxZckZ4Ks4kMmCAqSRTldygZM1cx6WzRmbqmQGEttl7Fyb1WFnzUs/s2zVkB0Ot6/IZyaoFB5aaXtnkD0iqKTiH+SxNFXkLDQCs1XFBuxvzvQyuyxF/nT01/SV+ZPyPe5W7joNiNpTRhGl4m6mx7UDJYqfSe2XHlKeCn1M8j05MAvRVEwszRP+bsZKeoiXOmuWmshAE3pAabypYB+co2HOjX5Mr+lik34OCfAwJyst6ypPiraqz/p35U2ZSsIOv1tWvKCV5J57hdXr5+Z1GfOgtoGVXM/hh6/outUnYE5SsDqkXO9DmxXWMrsZJXTF0iPyLnmxZM/GSu9ORdFUxUs5K1tOMPtnlzxoATE7hJ+Yxqm8ldU9h2URJjAhaUwqDmApmNjbl1fxjlvncdFLpuptNxlP77osz/LM4YNyB8AAYwba9jPqLRj6nFg9uLw6TiQlzCgU5iuVvYfPaQnySbBqd712sm8fDfJY+EYR/uhy0AIGT30eVof/bjwMQN8kBVySvxbOkGlB1/1phaSMP/tluHu6CjJEkPKWi7pm+N6FQdJLMpQT76AAVqM4LFmyRN+VlBw0UJ/uVTi8Lj+61Rmwje2Oz+1szSBQEE84n0xLOwyseMGBBAMAFIcupNDNoR8s+YnGmGCtqpENSTCF6Ey0EzZ5mO0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(396003)(346002)(376002)(366004)(136003)(84040400005)(66476007)(66946007)(478600001)(66556008)(6486002)(8676002)(2906002)(41300700001)(107886003)(6512007)(86362001)(52116002)(4326008)(6666004)(186003)(1076003)(2616005)(7416002)(44832011)(5660300002)(26005)(8936002)(36756003)(54906003)(110136005)(6506007)(38350700002)(38100700002)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BIr5+5F+1rhvmMgyImi1rJufzVpKkDtwxKOX6/K6ZmPTtDuqBLCZx9PADakx?=
 =?us-ascii?Q?o+/mDzwLtHsgJaDkYqlUIk3RmjdglGP1Yn6rKMN//X5w8dDb/xTB+rX49EZs?=
 =?us-ascii?Q?aSN4mzKQ8LDPJLIeGKeo6CE8e3yzBtMU0gQapRLEMnpB+QGbGaseEyywlrrA?=
 =?us-ascii?Q?iR3PLacqVQpM5cAwob7i/OkfzI2QDw5iA49KGXRgPqUdNw5WM1qVSqLWkVpA?=
 =?us-ascii?Q?0aO3gE/8AkLtX8KXl7KhY7yBLQxKTdgtVQHMGyxbEQUFYOyM0zoA2DagXTvh?=
 =?us-ascii?Q?CIJWirebSHEhZZsGzYEHiZvVsx+/b48U3ugADc1klY7zAtpvuGCJiI5KFRPp?=
 =?us-ascii?Q?FdbPC7cU8ytq+2Nl07VioINrQ9Zc3Zfi4ms7F1dtWZuw/AezqvO2gEDls87J?=
 =?us-ascii?Q?ApmKmPnbERI/Q+Ef0lkEISGPpwwdip047qaVX23xHn62Qs5I0x4kNI9tOXPt?=
 =?us-ascii?Q?2GDuvOSpO3SVCnR2VZsXiVL396ru1zTINl7NtbCB27gnPvv/TMW0+468sLtB?=
 =?us-ascii?Q?SriVgxmlLLMmu1Q5LejaGsmDZ6cTPBZVKVXomLa1UL6V+390bwhsQlDPsv35?=
 =?us-ascii?Q?dNlWEE4v0DegrFXiUFnPGlkNqhDu+GNMPKbq8Ei8hsqMBnwVzFchpOt9ZYar?=
 =?us-ascii?Q?bHmcYRI0rL4OHxCBGh7A4Dq/YycWP+IYEosC6h38jA2fEHT7duq55r9YAr4L?=
 =?us-ascii?Q?BWdms+YhFuQWT20AjZ0IBWzciykVRoxkO3CEGdxIcuEDaNui3P/DvcvcUVPG?=
 =?us-ascii?Q?Whv9jVOlEcgzkLkwN2FiTFh1jrIhYnTEobmeXI3PtjEECswT+HAxyapGxn6S?=
 =?us-ascii?Q?E4fdts5EQ2WKcSJrpwo8gZJwCv7erMZnXfTxaGiFawTWVylVa2n2zXCc4Axj?=
 =?us-ascii?Q?+nUBBcmNGG0yIUheq92zSULyKIM3zs8Mdr0ML0CZQMAuFeV/A+rdpwFoLEOm?=
 =?us-ascii?Q?aO7HTJXLEp9GJ8XDdZ+sWmT6nHi0rAvjZbR8GxG2EA6xhZSUqnCqiSeuW7Ue?=
 =?us-ascii?Q?lg2niSy+0Fe8eggPQcfS89NuNoMRpaoEx+7lWe7Wr2bx6uXsXc17p33CR3gK?=
 =?us-ascii?Q?jQ0Z8GmNzIt0PndoJhRXW1iZVMleFLMCqiDlm+09eUgl/wM9AntgG4bRZFXK?=
 =?us-ascii?Q?1yqikv6Ie3XuellJ+iJdSmq9NDPA04E3jr4hgCNfth2n+/BnouGdzqhu0Hti?=
 =?us-ascii?Q?DUd3j+RXKKgIXZTpA9XcSYsOGkvfpA4VE3PkuLn908Mpnx4Vq4oy51XjQc+o?=
 =?us-ascii?Q?2c4fxrls1ouLepO6Wfyo1TYTvrRtjx6aaEjE1cA9pCDj977xX8rnYymCdPfs?=
 =?us-ascii?Q?wwIl8ErvZ/PPNLlfLpHe7WO/8gNQ4SH5+VvlgzVgSkHciCkJOvJhy0vNGmtF?=
 =?us-ascii?Q?DzUypnEtk0p4Gwy2688LHLpG1dCKO/f/BtJZM9QVi1PCEiZ4Q5oYnqtk2Vn/?=
 =?us-ascii?Q?YlBV0ZCaxyMnt/RFwvlW63jQvxcGi1HWJ3TYM+kt6Z1GBCtJQfmAcX29+0S3?=
 =?us-ascii?Q?dRm+UwVneQftT8q6m7utthDPIQxAl0Xz1u1fhCP9T2Y/6/3pVP/ZurLkA9Uj?=
 =?us-ascii?Q?3f9zHfOpz5pQsekcv1AW1o9zYIrtYvDXDqI6hm7M8xmRSjmtqpG0sxSmSI95?=
 =?us-ascii?Q?cA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e56dee6a-1808-476d-bd1a-08da81393872
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:46:38.8383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7+ITgvZhQgj1hXkPtZFd7bFqhEi61/PKaSYe4RJcqxg2huR/ZOBGaLRgowz64gRVjfNWxidj/bz9WJWLI46MOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7649
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

 drivers/net/phy/phylink.c | 136 ++++++++++++++++++++++++++++++++++----
 include/linux/phylink.h   |   5 ++
 2 files changed, 129 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 8a9da7449c73..3e4bbeb1fab2 100644
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
@@ -841,11 +909,12 @@ static void phylink_mac_config(struct phylink *pl,
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
 
@@ -982,7 +1051,8 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 	linkmode_zero(state->lp_advertising);
 	state->interface = pl->link_config.interface;
 	state->an_enabled = pl->link_config.an_enabled;
-	if  (state->an_enabled) {
+	state->rate_adaptation = pl->link_config.rate_adaptation;
+	if (state->an_enabled) {
 		state->speed = SPEED_UNKNOWN;
 		state->duplex = DUPLEX_UNKNOWN;
 		state->pause = MLO_PAUSE_NONE;
@@ -1065,19 +1135,45 @@ static void phylink_link_up(struct phylink *pl,
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
@@ -1169,6 +1265,17 @@ static void phylink_resolve(struct work_struct *w)
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
@@ -1403,6 +1510,7 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 	mutex_lock(&pl->state_mutex);
 	pl->phy_state.speed = phydev->speed;
 	pl->phy_state.duplex = phydev->duplex;
+	pl->phy_state.rate_adaptation = phydev->rate_adaptation;
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	if (tx_pause)
 		pl->phy_state.pause |= MLO_PAUSE_TX;
@@ -1414,10 +1522,11 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 
 	phylink_run_resolve(pl);
 
-	phylink_dbg(pl, "phy link %s %s/%s/%s/%s\n", up ? "up" : "down",
+	phylink_dbg(pl, "phy link %s %s/%s/%s/%s/%s\n", up ? "up" : "down",
 		    phy_modes(phydev->interface),
 		    phy_speed_to_str(phydev->speed),
 		    phy_duplex_to_str(phydev->duplex),
+		    phy_rate_adaptation_to_str(phydev->rate_adaptation),
 		    phylink_pause_to_str(pl->phy_state.pause));
 }
 
@@ -1481,6 +1590,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	pl->phy_state.speed = SPEED_UNKNOWN;
 	pl->phy_state.duplex = DUPLEX_UNKNOWN;
+	pl->phy_state.rate_adaptation = RATE_ADAPT_NONE;
 	linkmode_copy(pl->supported, supported);
 	linkmode_copy(pl->link_config.advertising, config.advertising);
 
@@ -1923,8 +2033,10 @@ static void phylink_get_ksettings(const struct phylink_link_state *state,
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

