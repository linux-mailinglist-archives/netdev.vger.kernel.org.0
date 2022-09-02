Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9C65ABA8C
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 00:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbiIBWAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 18:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbiIBV6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:58:49 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150043.outbound.protection.outlook.com [40.107.15.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC8AF8FC9;
        Fri,  2 Sep 2022 14:58:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/eLsUySn4DKb81kjj6oYn0LBzqBM45yhCNiBbvCuBouYeSA4QYE6CUs2Yax3/6lW9kBm+Jx2VL5S2X/jf8EOht37f8P41DciTJnivDiY/aYpvmgunJWHG41YoF7qPQ0Tkrwz9jG5UPdmhmvpdcuTeoWMrGp6radaT6hGGKZgerVeunRNn8jQgfg4je1ca3EwWvxmMtCDv/FMvWy60G44t1pt7gh7KzFL5GMfJ8l69bnxN6iOMLqAqqctd19O5iv6gpHn8LLoJH43ucgqD5lalpbKlyDMvjM7ebubWIbMhoHrtUEjcm100c14uXopXTroYP52ZALGPyRirBoGlG/Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Js0EvR9gWskrzROD7oa36jjDuLkIHJQDWDYqsS4YuN4=;
 b=NMYL17KLvXEJ3OYcAfkelAXsXlQ9aCmDWiH81/Mkp103TL49Zx8chj01cvB10MUEhQJ8ou+PzVIF4QPLuBtAsgmIAKO0OZbWryh5buvh4wECRhP1d0flhPIYc/lxQVa3XtgON1gy0KW2Flf8JWz2da6qFMdToKgHyAQvvH9bJvtxXcMgkfBk2E8PT35kFQBK2daBLPewQyN4cOUdc1oz6A07JVzyHASGDo5KYH0bXCogKHQerQ3hdJ8GqFnSRe7ziyi3sRV0WNB3GmXTsK0kmZCyBofPR0cBvGQqVS3WE6VPhNi0lfjVUE4qW+TlJ8zFS+MRFIWeinhYAn5onGsMeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Js0EvR9gWskrzROD7oa36jjDuLkIHJQDWDYqsS4YuN4=;
 b=mqgTLPQbrA3rRiKuHhtKb//PF/doQIUmEDKMIsq8WEzEFVfhsJP43yg/dTWW1PrF5qXjqbwpxBa6gTiAeiHLOUtYOGDKXYV7B/CMzcpkiT/Lggzqa/zDPgMDw+QLuIwUzaM4HPN3SYm8A1SuXFz0T/g5R1qNM16AubEgsekiX0F2zyEcvMxttRuT9z5VW/3lExX97QHsRiCX2biNABeA3gAvpmq7xGDDvm+OJN0J1FkzwhWEq3fzmXobZzx3kEBDNu8TYD/s2jm3ZCgG0llNVt2pb+X5wdO+3g+IyU9VeWtPwLehYzhESakzuV0SdL91sduxA1OmKNPJWpN21gUE9g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB4085.eurprd03.prod.outlook.com (2603:10a6:20b:1b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 2 Sep
 2022 21:58:17 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5566.019; Fri, 2 Sep 2022
 21:58:17 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Sean Anderson <sean.anderson@seco.com>,
        Li Yang <leoyang.li@nxp.com>
Subject: [PATCH net-next v5 14/14] net: dpaa: Adjust queue depth on rate change
Date:   Fri,  2 Sep 2022 17:57:36 -0400
Message-Id: <20220902215737.981341-15-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220902215737.981341-1-sean.anderson@seco.com>
References: <20220902215737.981341-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0315.namprd03.prod.outlook.com
 (2603:10b6:610:118::15) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7b8a825-7fb9-4b53-23f6-08da8d2e3dc4
X-MS-TrafficTypeDiagnostic: AM6PR03MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CEM6ooRWAFkBQPWG9IJbI7J7MEt5RljuKb5wTi7xRskSsX+8llgvIfuMWxojA4H5SNhrH8hXobgvY1t+bkBA67J2xWQTSAaXhUDp530CASAdwpaFi/zLAz5c30ZmIgMeWD5NaQ6E9mpLTBAyrWZRFSYs86xy2jFVnKhFwYYcYLllXBXwpz7Ipd2v44OMrfNfCXv/eUFAfxRC94YGie6jp4EZ9KASWYuoySipDe2yxVC5IDvB87lbeuq0Jo8JCNtixZLTi1Y1eA0Lc6cB52D8gBAu6sr+GEy19RdZV+LDEw9WYxNYe2qhzXBJhjVsZKi5MDdHyiLbBXXVv+Ov851Mk5FG9l3JQQnVi7r7bQHwOX4IdE/4PcpQ7RQKBAea0BP6zoceomIXv3GUwYJFxzEry03ABpYIyEpRTAkr2wsZl+DJr0eT+gbUfaH+WAQTXg0k4uLhG6QZasTYeC1esafPBtakLiZOHsmus1aIB0VkK7JCPq8C+HpAbt9CHWx3ZeXk+HG7LRaoVCNGVqBGaXc3ol5+02i25hhSLnbe4TRECUb2VOcsOZs+mevgwf1LzzHMjnvRsraESKnTXydlYszfpow1TVi8JLVQO/HDbvGIa8RDER7V0zuF0qj5STP/FGCqk9F6jLixcG7BEOzOSSxw9+gaKcigGtXB2XzhmuUO0ltdYcdB3j1E8hA56o7m8zR3iBq/kHbgLUxA9hUXrbofXI+vEuCW3uvTxpb2uW3kY8csu1uvI1nWQF6fvqNCAq4WizlmPKbcnGYKt6mHhUo1wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(346002)(376002)(396003)(366004)(6506007)(6512007)(26005)(2616005)(186003)(1076003)(7416002)(44832011)(52116002)(8936002)(5660300002)(86362001)(6486002)(41300700001)(6666004)(478600001)(83380400001)(36756003)(2906002)(4326008)(8676002)(110136005)(316002)(38350700002)(38100700002)(66476007)(54906003)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bc35ShQ7F+7Id6Q3+58JnXI+TDMVssL0emFSojNmZ6yJuc5cTj0tho/tp6B8?=
 =?us-ascii?Q?W+C5XjhQORKg/1N8cHRuImhA+wmHyLrlz974Ns94VnpSYWVmwnD5oW3zDWGi?=
 =?us-ascii?Q?51kMZS1snPB+Vn3TpwGHEzYN0Ovef7gZyeQuBZDSg+ZlascrNLfvq4Jzzfq7?=
 =?us-ascii?Q?9uTWNPj9odQxyByvMTwnhSIifj4P4mJwpugVI6HT+skHtVCNf91zZPgv4Z/H?=
 =?us-ascii?Q?7rX5gZ7yWFAEK6hjPvZuycMRLt/PEwpMyw5HfHqV/M7sDmim7YRR02ldM46q?=
 =?us-ascii?Q?oGuG3WlTcigndCer/8sn28Jd8rViwEUO5i2TzdojKxw4Ah3zlmbd9SbK2+CN?=
 =?us-ascii?Q?U5Ie4qEOPzINx0g6knoLZegh+cz6GIN/yGRG/Prn1XN/4UmbIQRLkAmkC6bb?=
 =?us-ascii?Q?GvHV1WBdpYPmFEcmTAoBE+J0o24rThyOVEtFs2rLRiq/qF7f2JemCZGNGr/J?=
 =?us-ascii?Q?chYRoaupvvS49/YVoAY5zIq3ZdIg+LTFSuLeP/F/GosCW7ai8DyJ+0fS9NDH?=
 =?us-ascii?Q?wPCT8Rmp+g1IThDE8Gikqy+Q8dTXwgj791AaIk9NO+BpYHhx6H2B6LDRSDIr?=
 =?us-ascii?Q?5noznyNYmHbNVEXobd7o7d6O3SIG9DyCd+280zC/2Fdhi6VRaaRIcyfirhDw?=
 =?us-ascii?Q?rHI7ujCdrfFkiiwvsMgZ+URJR0GJmtz0lwWuzPOICOEH47aA0qSog0bQ6VQe?=
 =?us-ascii?Q?OCW+jutZXfHmvNBECIMFhz7qsibOqIjptx8EjEPHS9nCkKpwRWbEw0lNhA3O?=
 =?us-ascii?Q?O/cjnpErnekJcHa84YFTFWNBe1EK+lGAI/AOXzrviiJ2oBp+gNOSodMKMydI?=
 =?us-ascii?Q?9s7nDFL/z7cOvGMsy2nIN4Lzgk3+xa30uzH/Tnw1SGt+2sOB7pnQHLsbQwsT?=
 =?us-ascii?Q?pXus/vJ5FgE1Iu6gLa43og8Hjj28fIF49+IEnqjFfzHvj76Zy0JLoKRm3C8b?=
 =?us-ascii?Q?QSyNuzaq54SxXmlZIaylt1e5p5Tn7EmB0viUph8iC5OT/mcKBufiUc0/K8jE?=
 =?us-ascii?Q?agEoLjOzR97sEN6IyrpPG3wdebvxh937VhYgYVrLTmOCTRhY+4Pr+/qhhT8e?=
 =?us-ascii?Q?OJisvW52PeDaBfT6+iF2+cdMF/9XGDqg86n6vGV9efF7JNLUcUk+wNdScRrD?=
 =?us-ascii?Q?wvrSrSu/ngQJYtes5k29sVeXgpooJ75m7hHU+SIwmUZWXiF8pu8UcVGdk7MM?=
 =?us-ascii?Q?iAI0muRw5q1WVWOJGxWYwV+/CcdTdMb80c3uLkUFud4EWXVDM9Om7dk2Wr5U?=
 =?us-ascii?Q?Mqyoc0DB8pbOnFbzL70084R4Lx5X9P9OcghAmyhgsVvLtsSmS6iTqOZ9mYiu?=
 =?us-ascii?Q?iKo0vaBVEes1vPE1ncdMJoD6OgHHs7f79mM1t85cE2X5mDfRbs/ovapt2oAc?=
 =?us-ascii?Q?PEExRrqEM6b8FHPK8HBFeTiTMHt7vCOZda5seO++Vxox1zSttLKYjbXj/52I?=
 =?us-ascii?Q?meQkkvhG34H1BhnwU2xyPdo8PxAKKA9uoe61P/nSsjHozHSoKbH2uy0BaQJr?=
 =?us-ascii?Q?ainnzL3Xqh4mUoPG0C1XPI6FtYhT5I6zGHyvclhidoFf9jnswK36HdK6T5SZ?=
 =?us-ascii?Q?OsC3gbCtW5KPQXmNSLwcoixweIh9KYfYl/SIyTtL06USk4GUDsKxXQfHBFhg?=
 =?us-ascii?Q?NQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7b8a825-7fb9-4b53-23f6-08da8d2e3dc4
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:58:17.6247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iHit+r+3Ez0kQZkt1Yxbcu9NOqChesgm1KcLofuvddS8UAQKbTDeoMXYbG4FovkkENnLuOi0qkKGyAi9GtGsJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of setting the queue depth once during probe, adjust it on the
fly whenever we configure the link. This is a bit unusal, since usually
the DPAA driver calls into the FMAN driver, but here we do the opposite.
We need to add a netdev to struct mac_device for this, but it will soon
live in the phylink config.

I haven't tested this extensively, but it doesn't seem to break
anything. We could possibly optimize this a bit by keeping track of the
last rate, but for now we just update every time. 10GEC probably doesn't
need to call into this at all, but I've added it for consistency.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v2)

Changes in v2:
- New

 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 38 +++++++++++++++++--
 .../net/ethernet/freescale/fman/fman_dtsec.c  |  1 +
 .../net/ethernet/freescale/fman/fman_memac.c  |  1 +
 .../net/ethernet/freescale/fman/fman_tgec.c   |  7 +++-
 drivers/net/ethernet/freescale/fman/mac.h     |  3 ++
 5 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 7df3bf5a9c03..0a180d17121c 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -197,6 +197,8 @@ static int dpaa_rx_extra_headroom;
 #define dpaa_get_max_mtu()	\
 	(dpaa_max_frm - (VLAN_ETH_HLEN + ETH_FCS_LEN))
 
+static void dpaa_eth_cgr_set_speed(struct mac_device *mac_dev, int speed);
+
 static int dpaa_netdev_init(struct net_device *net_dev,
 			    const struct net_device_ops *dpaa_ops,
 			    u16 tx_timeout)
@@ -262,6 +264,9 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	net_dev->needed_headroom = priv->tx_headroom;
 	net_dev->watchdog_timeo = msecs_to_jiffies(tx_timeout);
 
+	mac_dev->net_dev = net_dev;
+	mac_dev->update_speed = dpaa_eth_cgr_set_speed;
+
 	/* start without the RUNNING flag, phylib controls it later */
 	netif_carrier_off(net_dev);
 
@@ -826,10 +831,10 @@ static int dpaa_eth_cgr_init(struct dpaa_priv *priv)
 	initcgr.we_mask = cpu_to_be16(QM_CGR_WE_CSCN_EN | QM_CGR_WE_CS_THRES);
 	initcgr.cgr.cscn_en = QM_CGR_EN;
 
-	/* Set different thresholds based on the MAC speed.
-	 * This may turn suboptimal if the MAC is reconfigured at a speed
-	 * lower than its max, e.g. if a dTSEC later negotiates a 100Mbps link.
-	 * In such cases, we ought to reconfigure the threshold, too.
+	/* Set different thresholds based on the configured MAC speed.
+	 * This may turn suboptimal if the MAC is reconfigured at another
+	 * speed, so MACs must call dpaa_eth_cgr_set_speed in their adjust_link
+	 * callback.
 	 */
 	if (priv->mac_dev->if_support & SUPPORTED_10000baseT_Full)
 		cs_th = DPAA_CS_THRESHOLD_10G;
@@ -858,6 +863,31 @@ static int dpaa_eth_cgr_init(struct dpaa_priv *priv)
 	return err;
 }
 
+static void dpaa_eth_cgr_set_speed(struct mac_device *mac_dev, int speed)
+{
+	struct net_device *net_dev = mac_dev->net_dev;
+	struct dpaa_priv *priv = netdev_priv(net_dev);
+	struct qm_mcc_initcgr opts = { };
+	u32 cs_th;
+	int err;
+
+	opts.we_mask = cpu_to_be16(QM_CGR_WE_CS_THRES);
+	switch (speed) {
+	case SPEED_10000:
+		cs_th = DPAA_CS_THRESHOLD_10G;
+		break;
+	case SPEED_1000:
+	default:
+		cs_th = DPAA_CS_THRESHOLD_1G;
+		break;
+	}
+	qm_cgr_cs_thres_set64(&opts.cgr.cs_thres, cs_th, 1);
+
+	err = qman_update_cgr_safe(&priv->cgr_data.cgr, &opts);
+	if (err)
+		netdev_err(net_dev, "could not update speed: %d\n", err);
+}
+
 static inline void dpaa_setup_ingress(const struct dpaa_priv *priv,
 				      struct dpaa_fq *fq,
 				      const struct qman_fq *template)
diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index f2dd07b714ea..6617932fd3fd 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -1244,6 +1244,7 @@ static void adjust_link_dtsec(struct mac_device *mac_dev)
 	}
 
 	dtsec_adjust_link(fman_mac, phy_dev->speed);
+	mac_dev->update_speed(mac_dev, phy_dev->speed);
 	fman_get_pause_cfg(mac_dev, &rx_pause, &tx_pause);
 	err = fman_set_mac_active_pause(mac_dev, rx_pause, tx_pause);
 	if (err < 0)
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index fc79abd1f204..32d26cf17843 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -782,6 +782,7 @@ static void adjust_link_memac(struct mac_device *mac_dev)
 
 	fman_mac = mac_dev->fman_mac;
 	memac_adjust_link(fman_mac, phy_dev->speed);
+	mac_dev->update_speed(mac_dev, phy_dev->speed);
 
 	fman_get_pause_cfg(mac_dev, &rx_pause, &tx_pause);
 	err = fman_set_mac_active_pause(mac_dev, rx_pause, tx_pause);
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 1b60239d5fc7..5a4be54ad459 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -601,8 +601,11 @@ static int tgec_del_hash_mac_address(struct fman_mac *tgec,
 	return 0;
 }
 
-static void adjust_link_void(struct mac_device *mac_dev)
+static void tgec_adjust_link(struct mac_device *mac_dev)
 {
+	struct phy_device *phy_dev = mac_dev->phy_dev;
+
+	mac_dev->update_speed(mac_dev, phy_dev->speed);
 }
 
 static int tgec_set_exception(struct fman_mac *tgec,
@@ -795,7 +798,7 @@ int tgec_initialization(struct mac_device *mac_dev,
 	mac_dev->set_allmulti		= tgec_set_allmulti;
 	mac_dev->set_tstamp		= tgec_set_tstamp;
 	mac_dev->set_multi		= fman_set_multi;
-	mac_dev->adjust_link            = adjust_link_void;
+	mac_dev->adjust_link            = tgec_adjust_link;
 	mac_dev->enable			= tgec_enable;
 	mac_dev->disable		= tgec_disable;
 
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index a55efcb7998c..b95d384271bd 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -28,6 +28,7 @@ struct mac_device {
 	struct phy_device	*phy_dev;
 	phy_interface_t		phy_if;
 	struct device_node	*phy_node;
+	struct net_device	*net_dev;
 
 	bool autoneg_pause;
 	bool rx_pause_req;
@@ -56,6 +57,8 @@ struct mac_device {
 	int (*remove_hash_mac_addr)(struct fman_mac *mac_dev,
 				    enet_addr_t *eth_addr);
 
+	void (*update_speed)(struct mac_device *mac_dev, int speed);
+
 	struct fman_mac		*fman_mac;
 	struct mac_priv_s	*priv;
 };
-- 
2.35.1.1320.gc452695387.dirty

