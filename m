Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572F655F123
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbiF1WR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbiF1WPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:15:49 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00064.outbound.protection.outlook.com [40.107.0.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5682D3A734;
        Tue, 28 Jun 2022 15:15:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aSfULt0gC1lYgnDKp2OPyqTSJiGn2S7CUf+SYtVyRySKxpu74gAQVaRznBjTdbjhiZyR8ksSDlhv4+YC0TBhrEleVyvc0zbogVsGXNN4d3T3JOLRiOxPcFYK6rcikdDh37v9VS+qlYnQw6wlY5n221L605hZ2W16izImHOrmRR4B/ntZO8ZsL0RK4RaH1wQL1EV7t+4jSSU2YACu+NlBNoiQBeAOkWQyjQQ00kXv4Y1IczxELVRIZ/e/JP5o+mg/BXsGg8yaBb061GK5+eTsm4UbgM2QxF0ZSnVbWoyAW4tz5eDi9bZfFTv2mW009I/6JVlhusZD55GWyjSEe0YWuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hi4abFH3xalBjEkOAWtjAQIxhr8njJD/p8JHplUsa4s=;
 b=LAtzw1qqZS0ugJ+Eb8H0X05r9E0N9CS6ZMgNCoUHzXd1OQnBTqR9fQ5GHuKunIqaaaKcGTCtKFYeFam5EIhQWXMMcmcT0GFRRtmzzRfaAvVz07ATXv3I/mDGO0b/gaLPZ7bkVJDHOZDxmtUcnIN10aJ0aucLK1JiWFRV/hD7PUX6AuVeb5LUa6/GbeAfODxrP6l2rILpGkIswS8IhpDUxQhivoUeuJeeR2n0pZdTIClm2DPQM0qbNd7Zhmk3Nt45oMzH4CQZremT992G5WjSJE5S5KeA2h31WckSeJ5jPaSqmsek+DJj8Xj5K/NhwNKX9cIZUwPu2X2aFz/WB2Bb6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hi4abFH3xalBjEkOAWtjAQIxhr8njJD/p8JHplUsa4s=;
 b=GCrDBGTShrLnl6nCyyeWplAd3nYu0kVhqL7PMvR31XhR4OD73kgN4PpCBwj1Nc97LC0/7Ha2TRJAOPGxtP35HzYiZ+NGrGSXKiz6I04+PeRNw3WaYrynB4gy8Pm3CXhi+P/eYXD/JnxJF7vHvkV5SyR5Ly95xx99tEQVxnZEbMZXXYT5zawsu6WVcd4iFHlBZaADgRUbodRugkPS1MUrS4Sr95YjpJ5XYo5kEbTvovOu67xSmVoRYJMJRfsd+5mzFFOV36JQEQNvD5RU7V4VE0Gjqr/DdM27TuqODxiryuCOnuNip9K7satoERh6Hkth/Ihk3X1zB+8yXi72XhPGYw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB6PR03MB3013.eurprd03.prod.outlook.com (2603:10a6:6:3c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:15:02 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:15:02 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Li Yang <leoyang.li@nxp.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net-next v2 28/35] net: dpaa: Adjust queue depth on rate change
Date:   Tue, 28 Jun 2022 18:13:57 -0400
Message-Id: <20220628221404.1444200-29-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220628221404.1444200-1-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 254896b5-d12f-4247-4b43-08da5953a5f0
X-MS-TrafficTypeDiagnostic: DB6PR03MB3013:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jmR+GalwYyhe5zqCRxwfcKGXWZ+gon6jJHM9MH12gmvyTmlgDSivZXH2zcTKt+EelFjSqJcWp05gJd5EL5iTUSedFzA9GzjRatpn03akpOfnQCIN3mhmugBO4pkUGhlBmxIXKxkGUCsUfLeooMCPEtjRMYM2BEIPeeg6ACDFUcXDkyOs85dobOgp77yRUZtesLntV2LN8KP/U9uogjDqcaEYzUVcL89bxekDUqYtfXVmDpJ1ovvjojknVV+f2KUZcUhwhzKYGFJWetZpwErT2aXbeA1jSphGcOfXHU3G20SPVnqeYczk+Yaz2l+Lu4K2iZkbuh1NdKa4X41Ksp2sUHz/KgKzMbHwdCs7o7HOkigdntGA/wLcR9iLTEBON9nn589kEEsEWiopI06oyNL63mMlJds5pLRVrWgC+wReB5FJN4sAteD0f1rVMAHdsnSW+YXxPPNZkjYa4IVyu1aWb8tCocnO6MT2iX5NAxmCTMaNnsOxmf7sJLWCbJuYh4hZ/hOy916JVifCN45BK6jYmAQTMtzND8Lf+CeQ4eoC+/Pb21xmVsq9AeeNyxW3iMdMDhjgZMtmV4z7zNYVYQAg5IHgXS+o8zf/gsil5JTIoyf10SoKucXZz8Q26MAdyOQ8RiytxRz2mPwvS6MmV3ULKzlT/kUsFWYjWa2pB8E1Yut5eJdUgiRnLtVyaTmtm2Aa71/Cfafp/WGpsDe/nBHyUs8uqGDJI8Xnn2nU5UOMa5aUEVtzHi4+hz4E3CZ7frhcxNse9a4A6oq63HoWzz9ZKPC1lHYUBYBHbSFsfDIzWNw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39850400004)(376002)(366004)(136003)(346002)(2616005)(41300700001)(26005)(1076003)(66946007)(6666004)(8676002)(6506007)(6512007)(52116002)(186003)(38350700002)(83380400001)(44832011)(6486002)(8936002)(7416002)(66476007)(38100700002)(2906002)(66556008)(86362001)(5660300002)(54906003)(36756003)(110136005)(4326008)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XDjnG+eKS7snCRpmAwy+mFNQYV97WGbFKW5GppoS6dacd5L7RrfiquQcfH2V?=
 =?us-ascii?Q?JtcjRUExvH54tULdVHq7nhUjYiPfwAAnttV0BcVoIKh1fCwCRQQN8BamGRqv?=
 =?us-ascii?Q?FJMZ5KB0R59uaiDWPZLQYuFfaJq35nCUdc4kimMVIPdw0QARdCBe8q1qFa4D?=
 =?us-ascii?Q?y1KgGCNWCmQdE+ryDs93W0WUpQd0/bB5czVLNP/2EW10ZUByU/Rvcfh0GLAT?=
 =?us-ascii?Q?9ZCeZXbHg0WI9ShMV9FdQFsqUFpCRDCMKtsOso0ZPeYFkTj3FmfpiUNCo7c2?=
 =?us-ascii?Q?svhd2eHeKMqZD0tughm4Ut4T/GAd+k/KARoMd3GC25kD3pcsBaGdN2MP+L2d?=
 =?us-ascii?Q?kGo1dknJWuvIFXezIsTN+J7JYn8KdV7JtqaA3xMxIu7NN8BwV7YpEttI6YEw?=
 =?us-ascii?Q?kZrj4CqkjfWkMlMqvOWM8T24TN+eZeO32aUO3ANmpl5vrvVViMUXxM3q5wG1?=
 =?us-ascii?Q?/4AwYGvIz+rnncwN4XOx4patjegU/hatlgBE3zSdRCwu7upKKQdrm4qSk6dV?=
 =?us-ascii?Q?MBvJkKV8lCC1F9wnnvfvNuNR5R7Y58KXGktoBLPFpZwWJrCdp+xXDVmSjzWW?=
 =?us-ascii?Q?ZOnyOL1cmTsb9/A2j0UODFMNYgO4BrjctXFJPmKIPYH0MpTE9tVI4AZgJaDg?=
 =?us-ascii?Q?7HW+4s/6e/M73drhpF5ip/3NF/37Kpa6f3agt48/yxzgO0+s6JXy9UhKMT2T?=
 =?us-ascii?Q?GxRdasS3BTEt+mP/+7sEj7b7VY9ikyeRcX+hbKJYD2PqYTbz+klMtCkfsF5+?=
 =?us-ascii?Q?byf5JpzZAE4GBMcxVvF/ni/R3dUfC9y/ssr0uOSw1LGiB4nbiEojCnz84/Va?=
 =?us-ascii?Q?dylSrtZOtPiMZXGTFtH6J1tXnV51si5EqY7V2kft47f2Xes9cIkmzwpFkXR4?=
 =?us-ascii?Q?v2gT1F8/ppEtbjMvUdTa5V+A25hhyWMnPvSCjfVo6DNtwr5Rn8EGoK1IK+BX?=
 =?us-ascii?Q?lZgswiVpqZpJ6ko9eX5Nfqrh+bplrFT7/QEYd4r3L29iE+vpyz7nOP8UHRGt?=
 =?us-ascii?Q?laY92YURP661AKgQG0Rp5knzuYd69YiZ62/zgjZ2lK2wqkhHp5hF0NaFwJM9?=
 =?us-ascii?Q?4531ICkHdyBKafuLQKf0dm4m1iwSXWI/jBp7T8oee0gtSMHVov8WynSXZlZ4?=
 =?us-ascii?Q?Dm2ytviXpvurnixoKiHDcCbQ21SKtLamuuqbJvt+gDcB6Vx5iYMCNUqYVf8C?=
 =?us-ascii?Q?Bjy0bsVD5P8JGWKVz+PLiudkoWh6Yu0UcgqJllOQUwA+1bC4g0GWVi0XzSG+?=
 =?us-ascii?Q?q0MR6NYTBWsgrQcJfuqQw746djjf9TRiz2umzAqVpZNZHkLK8IlzItgoKDEv?=
 =?us-ascii?Q?loqTzl7TA5y8SMc+wh9CJxR99tuDrBOllFbIstv1Tl2UctKwwRxhDw1OijVy?=
 =?us-ascii?Q?KyJ4RYDPB3tevj3aDRFRRS0ps0g60U6Hhz9hAzor4hpegebLHb51MIU4jTAS?=
 =?us-ascii?Q?VOzbtk37ru16hVAjrY+pPHQq25QI8q59hemySop3ReqCO3A8UQOwPt1BEYqw?=
 =?us-ascii?Q?2b57XvKE0IjTgUw7Pq+6VD/ChxjiwM7AyEUoNAMkmy7C69DVmMYbXUR4EkhR?=
 =?us-ascii?Q?j9PjY5OkM/5m7CFmOMgF7fLFFhXqh2VtjJqBIg3LT7Z8YRDyhpS3KhzEBElT?=
 =?us-ascii?Q?JQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 254896b5-d12f-4247-4b43-08da5953a5f0
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:15:02.8430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9GXsOim+pjyqBEkNOSlJLx4ph4k18swP6V6qE3B75+Wy0ifZHH0Cz/SBOwdF0QbqMzXLnq2zqhUvpIhz4jVDKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB3013
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
---

Changes in v2:
- New

 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 38 +++++++++++++++++--
 .../net/ethernet/freescale/fman/fman_dtsec.c  |  1 +
 .../net/ethernet/freescale/fman/fman_memac.c  |  1 +
 .../net/ethernet/freescale/fman/fman_tgec.c   |  7 +++-
 drivers/net/ethernet/freescale/fman/mac.h     |  3 ++
 5 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 2b1fce99c004..fd81ebc7be44 100644
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
index 8ad93a4c0c21..02b3a0a2d5d1 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -782,6 +782,7 @@ static void adjust_link_memac(struct mac_device *mac_dev)
 
 	fman_mac = mac_dev->fman_mac;
 	memac_adjust_link(fman_mac, phy_dev->speed);
+	mac_dev->update_speed(mac_dev, phy_dev->speed);
 
 	fman_get_pause_cfg(mac_dev, &rx_pause, &tx_pause);
 	err = fman_set_mac_active_pause(mac_dev, rx_pause, tx_pause);
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index f4cdf0cf7c32..33f3b1cc2cfe 100644
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
@@ -794,7 +797,7 @@ int tgec_initialization(struct mac_device *mac_dev,
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

