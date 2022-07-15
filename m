Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33A6576999
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbiGOWE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiGOWDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:03:46 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2079.outbound.protection.outlook.com [40.107.20.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7714C8BAB0;
        Fri, 15 Jul 2022 15:01:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgcHjjJQMe2TeXRxqrQ2nLkOnJ/H/99mNuWookim9vdnLiZD/XpCXSlrCudW7cxxjepiXdHbixzTF8Gv2CnOryrbpDKVOf+92yGDdzfmoxlLZHrgh+XH1mFj0i9j5S2fxfLTqDKws9LtiP+5dAayluokjsirgdRhy2GSPA+GNsvOvEcm08uVLchdibsVsWkdjpLkCtOVKkxLM+smMF9ZIaNraTJjrKy3YU27GWV7SAyQztQGW1kkqRd6/ooukcDUST/SBYGxKrw6sDH0xOVQVuHmCzwCYAx4jY4Y+v0v6EFQsWYF9XYgsX0v7U2Hqfklni90ONQjNEomXqL38OugeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ClQv9/2FPO54g4q78T3PSaIdaYtS2SYF8xNzSGVDR5w=;
 b=m6fGtDEOikXOWm9Yf3f4FSbEHdNHZzusoAQmfx4tNLt165XPjGwHh95LZNEFu1fqM0XdIiqDzNs6eEVdqljBzuKPev0S737zT4mX38YyE4FB83Ofo5Fm1+Zt7Adda0paulhPwyFSfu86fsUOMJsgbu0jO3BqbvRurxNIq+ugpNeSeLyuVerIdnQC9hta9O2gTDckjzsAOxeWdFeoOVn5jwdMAWycX91EnKH26EL4r5LQfvEhpH/LYbKHavuPIRYyWH7cTf/0iBOM6q9tQ6GdRfBoaN20kHwETrVcMOZfDIBqQuY/b0REPeZs7MMeK5ZhJ1oF41ILiVS+UlNV+5GsSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ClQv9/2FPO54g4q78T3PSaIdaYtS2SYF8xNzSGVDR5w=;
 b=q4mJsLct73dCTdyhM7WhA8Se5mE/k9buuaVpUPwOA+4oWRfxTZvpqaMglx3/u339Y6ZJ3Q138hDpczNg5JON9UpBdwM+jJKK3/wpJLSNwA8+FzGZ0AC03rAufFMuv5u2Bcjz+kCSmRfInyfi5bCMZVuafhtTEPZ4CglM4/+nnXIWk7x1H8oDfO/wCmvswNj22D491YgmGHOc8BU/zLUrO5dn112AmL01LTuX7nPSNuGBOdmpERvsKO90vU4fC52NoBqPAmLYGlWIFe9Gq/FwKCKAeW1jSn3FTib/vW5P4Ol1fkxUEM9Ieuf8wbGzLSW63QCZOZ/GOCG8sAFo/w81YQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by HE1PR03MB2857.eurprd03.prod.outlook.com (2603:10a6:7:5f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Fri, 15 Jul
 2022 22:01:39 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:38 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Li Yang <leoyang.li@nxp.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net-next v3 38/47] net: dpaa: Adjust queue depth on rate change
Date:   Fri, 15 Jul 2022 17:59:45 -0400
Message-Id: <20220715215954.1449214-39-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52060cf8-b1f9-473a-fbd6-08da66ad97a5
X-MS-TrafficTypeDiagnostic: HE1PR03MB2857:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r6/2JsEs79TSkmhR5AFjtCYzoYmr9GGiHQMyksU7JOI6roP1r36mMS4kBWEIQ9i7WVpVpzFES+lxRhseGkSlVHEnZmyV8KcuXYipMzOJxkno9GPLipG7RMH0B9Vq7cSmSp5QzUh/WF/OU5xxKPYiKE27MAqjNMHTmAwsl4thC84KBr1244HYadMVUfTsE/JM+T6yHbLc1mXqrUPZcfY8SaFZNgjGxo4j9n+SvF93zx//LECEhE/wZMndUTJhSlQVfvYl6LDp8l0UIoQq51jUhkjFn8SKZChLIxwsfv/v2wvf5rJ/tqEamD2i0YOw3mLJHBPuA/E+E+uwmpNejOIEPnlznSb8Qu8WMTwNmyUPR3UioNayEv5s8F4X9to2ThCasqG1gx20jn5NgE+D1Bm+tyJeBMflzTqwp3xdb93ojfN5fwnDDUzu0CNOHW635WOul/ltgxCg9rhTBWMgl8xCmZHtqxVHVAxKmQSzXeLeXhTNs7wQwCGawlwN25l4ovkUt/y7RVfGIrvesjq1sux+3eTqMuiwUKdp19pHMYBh1KD9JYSJH7bBthlVMksHO56GU/FtUKteAT9FfcXzEi0+mv5Ia711OhfyAzhyvyVSG+NXeDhxA0R7TtB41szGwoeIfBFH+U4iD+5znsyfcz4Ys0D/vTQaewAHCbGWAxN9PrYqwdvdDV+E+PaAaKi1BS52PD0eMLVRRDaaVbW4vh9SK49JEJdAdnmbPhci7TgoyIDrHb1MS4crM6qL+GAMhmfdKLp+tyrIwMttmuZUCGglh4cWQnEAij4BdhvEnujwOSbBLCru2eoJqBq4SYDf5y/h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39850400004)(396003)(366004)(346002)(136003)(316002)(54906003)(38100700002)(2616005)(186003)(36756003)(2906002)(6506007)(38350700002)(26005)(1076003)(86362001)(110136005)(5660300002)(6666004)(6512007)(66476007)(4326008)(8676002)(7416002)(44832011)(66556008)(52116002)(83380400001)(8936002)(66946007)(478600001)(6486002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YN85NKAnsRn21EJGimE+HxXNLkeAiCDwgfzYBHgubAaKUn6Cv/rhpdRQxG71?=
 =?us-ascii?Q?475/zVy05WySLMNYPOsFLVOgDZl56zs0nQC0Dj0/ROPrttfUaP6uc/NCBvWI?=
 =?us-ascii?Q?nA40lM59+k9ajJAiKfubjnH1/6haSsJClQcYPfMkUR1t+39rKJzSN3GPvuOn?=
 =?us-ascii?Q?B4g3Uhz8GLHD8feMYcXZrIF5ARmPd51L8vUyjjtmTHFEHfuLK3iBwIRSYPzR?=
 =?us-ascii?Q?I0t4yOkC8FCxHzjQd5VxRjJHb5fAo5kbnrmCM89sg7qcUFvBB21+usnHCKVW?=
 =?us-ascii?Q?MfWkxfBMhFBB3hSUwLbsLgPUWhYJZTsXJFWmp312Jy6f9RFR/6loqWv+7Ijq?=
 =?us-ascii?Q?4pgE8WvvkBOfxEgfNOQoP3vPNiXP6Dv6rKgAzVtOeUFxz3itb8Nd7LvB6ocn?=
 =?us-ascii?Q?CCpmVVk26jaA3bWKLRygiC+5ddOqFIJNuByFH1YlXx0M6XHRWoH/RqukldNM?=
 =?us-ascii?Q?YW05zdY55+PJQdJC3x/oAZQ/pGeS7g1oGaw/S2CXrqya5v4SLlLDrGjElYV6?=
 =?us-ascii?Q?qxTgDdxUbzSxnfGLGGduhyPEX+7ejzerQw17nikUn8iktgQHqAdUomym1zsq?=
 =?us-ascii?Q?AifUphcJjCiPP0qPLsmBFV3Vd3ODi5BccHpqJvsfCMqRNtX45r7f7PKZWnra?=
 =?us-ascii?Q?R/jORwRi4oi/CoD8H+WTGCRVNoSP8VuDm7j0X2WL//AiZZFE9jusr9t78yFB?=
 =?us-ascii?Q?6pEYqo6qBfz/gtJxLjfDhyvfGKJaWOPI/vY6NAEc99k9ql9H52sSXz2bJ0nK?=
 =?us-ascii?Q?z51LsdAEzHe8ZF7CzSd1KQDV8rTWkSkI54HFoRmA6sTBFk0YOlsK3BjtRRF4?=
 =?us-ascii?Q?69T3yXsy9y4uArCuuUsYg9DUdJXmkjJMO9LssfNycrBTFSPwIdVWq5iNc0vo?=
 =?us-ascii?Q?2B+HzJioKiFDPv7d4GLppcg2yToYu9AZ9oO7Ds7KQ8NS6huG4DxWGLPe7jJJ?=
 =?us-ascii?Q?ilm6ziIsLspcgQcXYV2xPWoIcofDbyFInDldu5eLQeSYjOsiTGKTkB82RVnZ?=
 =?us-ascii?Q?xExabf70dUULiByWs9yRJM2EAyOjaE6ynm27KxI1KrRC+nFgWGIDRJIyj81C?=
 =?us-ascii?Q?PprKbqC7rlDITK7sIojem1klrgHwWxlzwk0dND8ksu7uegVqrlX5FDDaiUYV?=
 =?us-ascii?Q?B3FxtMMYkSNMhXLm0YVEoLvWwgiRhJgoGZLbietkAqJ1GGJaya31Z+WRLGzd?=
 =?us-ascii?Q?syKIigAtGcCmSX1yMAzwWfA+fnEEm9Zq6CgyaYwHXLkoXmYtiNPGz8F0IN72?=
 =?us-ascii?Q?6gCqqNRi2Fo+iV+Md9/7v644KGhBC6tWxg+1FpxKkLdU/fZ73dsOpNyAu6Vo?=
 =?us-ascii?Q?ZDjv1ekEQW1XDOevBi7ZW5SwjQKlcupe+rJG7z0V9UifldSUwjxvJ+X2ThH+?=
 =?us-ascii?Q?mIhGOWptTLL2rYPf2z6ROiAr4oAT3l6SmbOxpweYJkTO73zBhYHnDOnY1TPL?=
 =?us-ascii?Q?Lb/uBM3H2jJItTifi/YZIA5fIpQ5lFN/v7WWif2eRxC2BDknurnZCyp86UIB?=
 =?us-ascii?Q?GslmHiktTVNGzOTLSSZCR34UgoCCEgT93/adKpY/9LtzLt/tR0lhxmMVL1D9?=
 =?us-ascii?Q?LuVoHZnBDfDhaNKkfMBSEcKcu1sotDZ10vuyHHRvgIJ68AA7wkEKzSDsIxG+?=
 =?us-ascii?Q?Qg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52060cf8-b1f9-473a-fbd6-08da66ad97a5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:38.8615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AhGeiAJC1Uza6hXIidjPm5LJY2mMRaqZngEmNs8170g62V+7CEVB2OBC4ORTP8XZgjxMJ3+WLsdWxNMcjq88gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR03MB2857
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 377e5513a414..a2a89f547813 100644
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

