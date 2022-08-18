Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58EF5988B2
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344777AbiHRQVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344818AbiHRQUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:20:44 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10088.outbound.protection.outlook.com [40.107.1.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DA2BD123;
        Thu, 18 Aug 2022 09:18:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlfWcZseOCtiKUPc4Ue9/MO7sfB/Dmz5potZuKB1zXwBTCXmqtEq+7Yc9i9sfq/MEvcibPGkHq8aRiAYnK6mB17AJfE+5THusqLqKDUpKxO5Lf6g39lXSfx/31KAh53uXmUEfogZmYACK0/66ursk42vYHCTfsx2XdOF8H/WHaPcYIWc3O0cyXSmfNZiLn8BTD1LWkYSC7EfooJqAgcMEA4O4pXB0uKpTfN+74KD3Vrvgx1L6Q5t9N5nRgB+EewWJHSEuYkhUhO6c7zNVE2CY6TwpG+E11pCbQeOXiEp+393pTduCtbYxS+UVQ9JjteDZzzu/TZ9Ii62Dsbtjtj+HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m2icLyPw92tchujC7meQbydBWVzlYIdCZDbwzZflRR0=;
 b=Ssd6tWEJJUDg52wKA7UGYmj4xu2O3XggdyiYKkL+wNmhDXTjF4aGyVaQTvmAvjkSGmQHYN3nHjnJ4SWCbzcx1yw9xEvi6Hy1lFzc6lJO9zB7iN323zuQnn4obA1lD2uIzQb7zLPx0d5fFIlvveQTtwozZtnemFfe2Oes264M6KQqv68iFkuh0oMhSRtHkGQY8qn+dNLofXDtEIowslILRCDSVNR+Kj7LsZplrlSUOz+Rn57BW50m2EeVQszOPmwUfsaJSTY5StbirbFc4BDbBRbrbVYiQSzdpX9zYiiUEN7jueEZC/sL3k+VIvc0cNbN4l8nU2hST4VJCnD9LB8H0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m2icLyPw92tchujC7meQbydBWVzlYIdCZDbwzZflRR0=;
 b=uyPntzfGInTQC1Hvz9pDpszezS2TsG9iPYCeb9xEsJAh9TSnaR0eaWoq/w2FXDVTkD3TexpU6S9wXqA2WixLCEmPftqkgEWlhdBGtZExfrTmDEswKvu1tGIvCFj5NsVPstFnBcGlIE3cIO+XjbmcHK3PCMgyQezqcC/qLvBiICUIbSCNKKr5kKOEZ/kn25NR7rE53LBI0f5tFXTsqL9ZzdsSBqx4Ysm3Ur5OhcI6RxGF6XVBR0bsEChPeJNymrFMRFITnU7WtY+nXDMvSQUg8nLe7lR/L80q+sPV7S1kAR5MP11YBFciwtoZiF84+mEbofvER2e4oV4TjKH5EC5YKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB5621.eurprd03.prod.outlook.com (2603:10a6:20b:f6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 16:17:44 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:44 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>,
        Li Yang <leoyang.li@nxp.com>
Subject: [RESEND PATCH net-next v4 25/25] net: dpaa: Adjust queue depth on rate change
Date:   Thu, 18 Aug 2022 12:16:49 -0400
Message-Id: <20220818161649.2058728-26-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818161649.2058728-1-sean.anderson@seco.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:208:e8::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72a58b4f-fff4-46f7-833b-08da81352ec1
X-MS-TrafficTypeDiagnostic: AM6PR03MB5621:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P9L1mB7hnXffvk6PcvuhFeI6o3rhlfVyxATeSkV5/IY4dLcOK6RvcwkvCg2B1zah10GoDVdacquRZgcZpcP1vCgzR3pOJ1bP1Nar0MD/oeeYnBKYnuZWEo2fwmPST4ioyFkbmTerTqdm+Gkek9IprlDtKCZ6F12fWv9RyOJyu4O00pYEx1DJml/g7ng0ST232y8mfySrbK6k0PSwu1G8mSdPHzT8Ae8v+zi1erK1eQbsLmb2RHRDBvj6zH2KQc1m/CmQXVkQaWjb6vUHKiGSw9YaclQSc9KpETcAmfmTzAQdpMFKlfA+ugnyaitxMNL97miqXDgAhtlljnhpIkcUSUOdOCkkgyOICDAB2I7m/p4WJ4ssFom1ckXTOwdOgDdiawPTE5QmsyTYy4/OHOGfTjPyYJqESqThthd1BVse4HziiHeITFu31UxRCmuXjbIxoCrAt0pDfluynCVHvWjeapOe8FUsYqEgQ8AZukHRd+R3QK+nRCEjKdDlbsko1a32oX0yLsIOUhV68gt2DQe+iCVAm/VRewqS1uBowIPCyKazpGTjFu46qFQzVmhtGBWI9BcVkYMPF+wiDHIT8EDiV1Vb1sNztc4g10z8Uy1yDlZ2KibUm872fEIrDPuzYaI1qcO6/cG1tWgmBwTO8H5276dtWWTIcFPII6XxEnmMugEoW1Y9W9UJIRI4+VzvR6BKd5T1g0sAssRDIUn0jHZu9tna7dBbOJ4P5tuCXhRyM4GTpcxfHuiDOi5ReccCeh6w7ddPmPerdRYmcp3R6dBFGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(346002)(396003)(376002)(39850400004)(41300700001)(316002)(478600001)(54906003)(38350700002)(5660300002)(38100700002)(6486002)(66946007)(7416002)(110136005)(66556008)(66476007)(8936002)(44832011)(8676002)(4326008)(2906002)(36756003)(6506007)(186003)(86362001)(26005)(1076003)(2616005)(52116002)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NxRXYg9Iue0b1TYx/9kGMA6KzF195Pq64B3sAeWg0rpZnrULSWTd/EjOQC9i?=
 =?us-ascii?Q?Q3PYWFioR5wqzYza6lmWDHmTlTnwb+uuLei16byl8ruZNKg/ObfqFrAJxnvk?=
 =?us-ascii?Q?cdlj/11Csreqd+2gePRrDdVSZJ8CDd9y978BvBWqVkua6l0SNelEv9ex+iL3?=
 =?us-ascii?Q?KaekS2FaRtcVXL3ZY2BkX8GA6M3rds6uGUZ1nK9tyGVPWSEpdDpFMQKkmKd7?=
 =?us-ascii?Q?YVnSHiBnUlKiVB+KoUiUcMwwukSKOy2ofL/jacrhlL6bSemxajihgXO+ZUXm?=
 =?us-ascii?Q?8OjbC6V2wGH5ew+W9pzmNOfQn+p26cwPaVJDvg+xNq++W4avzMlzwV/R2/sa?=
 =?us-ascii?Q?p4HMxsB0XW4qJXlhRhQR9aBxanRcBKJgFFUXi3erYrHrFWFg3OWdkAFQAnav?=
 =?us-ascii?Q?6txsxgBhqJ0Ul40ii7pE44iTig3H/wSxu6RFdjmw8YXc262iHfzodhh+UrNQ?=
 =?us-ascii?Q?WAEz+RdZQlLCuzQPHuWrAL91ujMCxM27m8F/qRpsSmBLxmFIWYbgupOXDWM8?=
 =?us-ascii?Q?qyGbyhTSNHGeMmBOBwOFZ0atzL8qH61vjUV4ynZ57qaZHu7ftcvWmm1+t8y4?=
 =?us-ascii?Q?va+FTMshym3fv2svt9IkONHDe30HL+x+4KjSdQDrot9pvMzLvN99+4qqNHXG?=
 =?us-ascii?Q?ydVmtABQObQLc3Mm2r8kikjuuXKi0K1+W5KM2CAg8UljXlGydGmVdGkVkyaF?=
 =?us-ascii?Q?L7kcEOL3GyIKr5kM97RUNvYRdO2Ga0dVQthZTe33K0Mmk1rKkmZTDxjIK/9m?=
 =?us-ascii?Q?aG1yZ5bGAqWSJyV2j7behYo2c9YU+dd/GcLtEwMm9XeJ5plQpzxhRuImzraY?=
 =?us-ascii?Q?2gjDTglQC98TPhb2G4V2PYNaEUUg+c/rLs766WH5PHzdZJxvPopcX3HE1vWS?=
 =?us-ascii?Q?PS1yEY7xnT/4XFTwI3tkFADelY9Ic0zjQ0SMjemKatjMh90nszznopUAeplh?=
 =?us-ascii?Q?VVjYIr2DcHHch/ucUOQSUS3EXMX++8qEpbQht65jaX1By0ezGoOxAn8Devod?=
 =?us-ascii?Q?W33t3Ad75dsqrVHGzLdbR/nG8szGUBKl9qmY+wNdY0lpI4ijn9CmWQkTxtiB?=
 =?us-ascii?Q?MPbmH5R3Kewpamy+rLYSPL2Ows8CQH7XGK/wtmWb+6m9JMRiEnLoyYoJXPrF?=
 =?us-ascii?Q?Un45gFlLuhz0+2bw81QM0zMX6CvZuVHNTLpLMR39g581iwCy/Y4t58kOm5S8?=
 =?us-ascii?Q?awLJJGx7D3ZwRc6Yz6cp5Q0X28Jr53JRKDg9xIYJsCnEJq2XhloTt1E66Qzr?=
 =?us-ascii?Q?a3dTni2VUALpb+qTeKI92nNlrK4dOHN+74hTIbSGzBKExLPZRyAQNe0fInet?=
 =?us-ascii?Q?1bxPj7l1vtXic9Romtq8SNU89Gj5xNSwzovMYsXFJgcwsyUI3OpxnAxHrX2s?=
 =?us-ascii?Q?Sc5Pi9Yx0iCRk4MmiGuMi3dkGoXQb0W6IWGFM++qM+yXeoI8npU1gF8/+5yo?=
 =?us-ascii?Q?vmuquUXEzjUEG2fNpDOgPPw52FZTOPRO4aJXkt+0NwkZ1rxtnzwTpPbOQNIk?=
 =?us-ascii?Q?Frb1n/i1y7VhQFLeiDyGX26bZ8I59G6AeSA94yK9EHQ3HAbvEt/hzYDgGYMU?=
 =?us-ascii?Q?9+2KY10M/MSQJlBq6H/86A13UcdO5Ti36HW+3HnGr4RcXtKxe6hFUD40iKAs?=
 =?us-ascii?Q?QA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72a58b4f-fff4-46f7-833b-08da81352ec1
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:44.5592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P4smnn4cV4DsHDvpvOeOfPayu4g4V+/SRb9hYfq6tbWzLLVYs/eGfg0UsTyi3ChXpn7vJgXYoA50ddZKPqOikw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5621
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
index b0ebf2ff0d00..f643009cac5f 100644
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

