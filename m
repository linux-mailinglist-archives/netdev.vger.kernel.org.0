Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E475580170
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236197AbiGYPPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236204AbiGYPOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:14:49 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130075.outbound.protection.outlook.com [40.107.13.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3301D332;
        Mon, 25 Jul 2022 08:12:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jC8Eb9Ndy4VIVc0ciooPylvhL5xlcESmW2r1YJ0C6VH1feZm5ZIXjLuZ3cOL4bBCCAJK1jrVKBFSUzKu7Nij8ETNxYAO7U7p4X3oFNvf8AhCBF7YGQOswBf8oCVbw25aexB5yZAlxIjfg/7LdBvx6iwAxQv4OySGkplZ331klkC7YnP3uaBY5GHsz3/XYBNCWawSUAuf91Eay0bROcgriCtiEBr9TuY58yuSOo96sTxVN1TZyCFOtu98DZ0VGCOChJ/mGbbcj+db6Kep5U+dYEwRpnG+PqOvrwUpXNR/iZ3bhTEAPnfzx/PMH9yXaW4skejPQhvasRdzlkd4uMA8dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m2icLyPw92tchujC7meQbydBWVzlYIdCZDbwzZflRR0=;
 b=W3vp97dXS2dDWAjQp6qGCk48FbXl+VSCdypdMEq22+YcSgakDHNrD6oe9qBuO6LUtvwRqm2ipnSqIs9TzckcF74Gi6xKbnRyE7miZTKz11qjWn1lMKncZF3Atb48g6I8VYzr899QMPfBB8S9V0Tb2gMWAfNtYU8lS6Gp7Rdsn5Lzv1/Wyb0KIYgkCNePUMGopjwkwfUB8HI2GG78RYKY96OgMXWqqy83/rIp+gn3nPg9H6gGeVbPDaPF8M5cYw/9rTeyG8RWdQDsM2V/Cyi+R5RAElbdFyb0X0b5VkjZ9Xc1Z7Ngm0iOAoJA/WTrzFEDtzvk3gcn7piZs4dIpul82w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m2icLyPw92tchujC7meQbydBWVzlYIdCZDbwzZflRR0=;
 b=GXvUeNlPiT1ApW95/G+OoAUdCzuwqBa5e5yVniYi6H+qdbS2MtJl1EyugFF709ZVYGk90sXnCSjRzTqdZ2v1E/3LpMesf51eSTdxitf7AI+PQ2HDBj3uIsmmDUAOL1+pmiNxUFDxGMni5ErPei7ldWlSfmRDmeK4St48aiht4F2ZmuKdJBcnlZYz0+Xj+Qh3AFldqDY//FO3FLzpqjRC9t0yoyNN/mnLfrSpw3/fZnUsZcC1+upH1Squu+ezqzgGsKolWHkca915ay34O272SXT3wnilG7gfh/FjLDwZCX/SW6tYO+Xc0LXj1hpO1M8e2kXgivWumNwO72lIYsiJrg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3723.eurprd03.prod.outlook.com (2603:10a6:5:6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Mon, 25 Jul 2022 15:11:44 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:44 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>,
        Li Yang <leoyang.li@nxp.com>
Subject: [PATCH v4 25/25] net: dpaa: Adjust queue depth on rate change
Date:   Mon, 25 Jul 2022 11:10:39 -0400
Message-Id: <20220725151039.2581576-26-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725151039.2581576-1-sean.anderson@seco.com>
References: <20220725151039.2581576-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:610:e7::24) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0dbc1cbb-3144-475b-50e5-08da6e4ffc61
X-MS-TrafficTypeDiagnostic: DB7PR03MB3723:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /kkuuYPOJRqNFrMqtROQOLaW7oQIhr74uA4q6JbysnLmkgIGf0i/Z2A2WZhfihPM67PYQ+r0c/IUJ+DzmE2eU6a6MkYTLR6coeT+0kWk0Luflgj3MC4CGj0z76/Gc9V8qySmqLqZEBrtrgOMykg7pEJmICmxeSMhbqOeNYW+wCG7YgR4TLohsDRRgabbjgibI80JA2UwX0wkwaFdUO2Z21NKKcQTnmB1y8BCCqcAm2Pdnoa6V2WAv2zMEaarq6tMopVmj7kB4Qr7XAisw33tIxsLMZQceZH7Lz+QRWIDgE2D8eZHS2zXtWZBN7e25ri1+PGBMvhwZq/meBVoHjsEhL3Uuss6YUwdlZ2EJGrms38x6HCorOUSkqf739wtlVmEa4Z/5Os/VsJpjPAOlZhA976spUnjOaPiTVYgU7h6BYsuiuc8g8pQ4s8+U/9g66UodD2xPtYK4isH7WiFY046PCBx+jUKM9OgKt3a2qTo+7UPqn8l64rPQDpPB3biPN08JkpKtaY+jlnxmZXEOX/fVCjw6y5KnVoFOmr3KYBGkwr3bgFmxgSXn5fisIIlAE/xpyGOoDL07jQgvYY57Jm8QZQI9qjXr5IuASBw/k9Tf3LBlWnSDXG6yb6rkAs5F8z5ima0OcahxCc87gr7HKBxpRO7yZuirgHumxM1IdsO9vcXpQOjDPbCGJE5tYn06Qst4NCDB4U9Uzu0NJANV4rI23w//bJwBLwmLfMKxxpVEuFPmM063BxSOLsFPTHkJF0u3xz+ScWaZ1mEB7K42DEKvDEOJVIxdHnKlBoycKsa0QU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(39850400004)(376002)(366004)(186003)(6512007)(2616005)(66946007)(1076003)(316002)(5660300002)(44832011)(66556008)(4326008)(66476007)(8936002)(6506007)(7416002)(52116002)(54906003)(110136005)(6666004)(26005)(8676002)(6486002)(2906002)(38350700002)(86362001)(83380400001)(38100700002)(36756003)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CA1vibEQi+6AZaDHV9k+yure4wk+N+3uR9DS0MghHP9jZdoiwhAqQZF69I42?=
 =?us-ascii?Q?BSIvbq0oDnF9O4qoW6c1ZlQU32yI57fQ8emc/6oeGXDJhDTOL5TmPerTBLNJ?=
 =?us-ascii?Q?WfsPwIrqrF10i15tTXOTJ1Gmkn+vBKi5MOBBOUS76Cc8Lceo7N0YAr5AWnOC?=
 =?us-ascii?Q?sT+Qsq3LnDyWIzj2jRs0Bt9IHSR36Xuqe6v7/0Lgn8Dcqb/PKKeQUKaEEEle?=
 =?us-ascii?Q?Jk73MRcg/rv+Pvv4Y7EKjdOqdiGQNMEz92Dy+FVDRDMUpG9cFy0p3wRH/vDd?=
 =?us-ascii?Q?hmwiNNnNU4vr9zX0kBC4m/+npctIddif2yf2cceQK7OReX84JeiTHoa5Gd3l?=
 =?us-ascii?Q?mFwnFvgvheoaJkguD3gbS9ps1UeeZfh27chrTP3gzTJX/zFx6nfdkdLVleci?=
 =?us-ascii?Q?CDhV3LsUoGLn/rN7+mkyVVN4WBVI+iwLgVyV/1nnqaYLOC0cnBgb2pP+if0y?=
 =?us-ascii?Q?iVr8760IFiKu7AAkOWySc5PbumWYXQwAV1shFg3sIUcMsWL1w522TyMoyL4a?=
 =?us-ascii?Q?wA46HdrldgYiNxiZq4FRhVcMJChvgyJkYIoqL/LiFSxXAeyRaZqnsE9FHWB6?=
 =?us-ascii?Q?NkmEInnoHFrDRrCx8Eqpc7vEd0ejmdY30W/hZ/YWANBd0kctMiQzEkx8RtZL?=
 =?us-ascii?Q?5kWvGBw/LbsUEL44tDmMCpgCNF+RPi7zk1gwnvNBs48tgmXQddECJU2ZEJ+f?=
 =?us-ascii?Q?6GIyPVJM/Uwm8wiYnb5Q51/PG15x40RMbQvD86MvmDpAMk+zIW/3/NJLRwNH?=
 =?us-ascii?Q?hauAAEUFyKLgl/CKwJT7aoy76ODwz5syvCSLDZscHxO8/syy8wnvcQ6CUJqV?=
 =?us-ascii?Q?9VV6AWwRp0mGhxtdBc7Hc8c5heTR9+8VwPcK7816XJyz1yAbcKT8ongYNK6r?=
 =?us-ascii?Q?8sSA334vdwh9ra7xoLNk8K+dTWpoQNobHB1xSepW5kYc6Fd4TvA99ycHM1aN?=
 =?us-ascii?Q?tfaEyX2/1bK66hm3vlexP0dAB2PLe+oTXO03wHIsPwl3J3Fwe8VaUx4hODjt?=
 =?us-ascii?Q?YEEn1FOltrm2sfjuxSzJY5RmydQG9HbrWg3kXTmp3jFNgPlpG4uLOjRhzMhq?=
 =?us-ascii?Q?7RQnmiZy/yU65WM+CcZ+FnQydt2TZj6y2fkqVYRK31aY/bMHZnNnmaUGAIuC?=
 =?us-ascii?Q?02oHFTXNE/cwlzHqbI/GN7fNYq28bLAjKoA+TGIGnd8G7xkO4cZyYWTWAk8d?=
 =?us-ascii?Q?bLSaQE5iorL1TmN1g5qnDkGHKPMzXP5+rSyn1i+yQzX61/l92/PZtuL2tjkM?=
 =?us-ascii?Q?UFc653QtJrX6fCAEAkxQC9KTFWUg/HJAd9HjioVxo6XbcvZ6ousf8AW5E6CU?=
 =?us-ascii?Q?YO2eV5KIWCilw5Dg3PtQyMOwFNe5euN1zHNEA79JDFACOU3rgF5wsR8Jfd7w?=
 =?us-ascii?Q?FIl8Y10Odc3b5xzETLHZJhhFm6akz7NjGMIhvszdIl5ZbZcQNXKPLFaCclz7?=
 =?us-ascii?Q?+Khwpr4DtrQr1SmUMaOKaZzlWbxxB9/T6Bkp9dFF/c69+o2qRB4P0leNmqE+?=
 =?us-ascii?Q?YLZ3bOR7nCnytk8PqhNBj8jrfhFL/rYzScF9vqyH7F8Z2gwpJ1Z7z+gZS19v?=
 =?us-ascii?Q?UvVm0X+jqc7ILigxIEaYuGBFOsk+3dwty+/YhI0p4gxjjv7SPvS7I1ypsLge?=
 =?us-ascii?Q?PA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dbc1cbb-3144-475b-50e5-08da6e4ffc61
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:44.3929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0W5sY49ioRFsnqNzEEgF35m0wrVCPBsetM/pxOW+JhN58TByk2B3XgqUB9qwQdsR4+1TwaJND/pYH2MZDW7okw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3723
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

