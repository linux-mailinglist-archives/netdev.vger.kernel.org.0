Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D845D46DCAB
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239997AbhLHUJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:09:42 -0500
Received: from mail-am6eur05on2088.outbound.protection.outlook.com ([40.107.22.88]:43105
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239974AbhLHUJi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 15:09:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EQVf4kVxqDo2utCOkrzDMvsZDrKA14drkOXur2Z9+P4jSLdtxMvvCHO/Ep1/5OeIG8DjSVplFHs5coGM1QiNnGMz/nBVkKZ4xVTtwyU1U4LtWPv+Fqwn9r8qxIBl1j22+8NAB8uZbaYNLaXD/tX3Epw+4ay+FcoGbZB+ROy4BjUHq8/UqB20bwCEFUFoJQKrjbR76J2LJdeMKWGNaoh3vGM4ovnVWlV0pJkG9pogMVJ/fU/ZcbsfTIWHGn5NW43QH9yp6XBu4Ew5AG8Y/T+BDSZlb9dFOI9SSR60F7LIJGYjozqxLjMh2opcFU9I/85HBZxyVVQoHjRp+paEgb+5Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5JbrfZo9tK04sw/AqKpJdKrHV4djShEoOURZdNnXZ0c=;
 b=fEY29U2CdNYLi2ByRtzUelx4IPOQ5rIU8+9JXEvVDeQRLl8cRYWFVSAcYA5/LnO2x+0cRfEiu3oLWWTvmBizrsbVjT6rznoU68bGdZ6A0G2tXMoWz2kCtsb+qryE3iC9ZSrGdHKxUThHmlgp+C/uYn3oVkdNOtet4R31FlILg3VArYo6Tg5xbwM1N5Mz6gvr59lY98uVYN5d+NoQ+DvaJJyEiMOyGOGBU7VD5PhNsSJMgvitF5tMsOpslvV7JCTvKL5K5gSutQ0eNcQonsuTk82D91y9CiRs1vD1OngzQj9oiegop0AYjGhhsdaXJF8KlsvboRejTW/hpMKKh9SaNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JbrfZo9tK04sw/AqKpJdKrHV4djShEoOURZdNnXZ0c=;
 b=SOHh8BDVPrDPeRyel6DeYrnypaNqMUpJ+dLiNYhN0mt4/spsOEUcwTCkp1oRqMlDb/dmqw8tto7skU6DeQ7S2H9gAC+3AJyWlbKkuPZb9ku8pFBV87Orw+CwfE3AkjrorS2xAfMfdsDDU8jQot7NP0/+bRhphuy3G2IVL5f8Prk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6638.eurprd04.prod.outlook.com (2603:10a6:803:119::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 20:05:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 20:05:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Martin Kaistra <martin.kaistra@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net-next 05/11] net: dsa: sja1105: remove hwts_tx_en from tagger data
Date:   Wed,  8 Dec 2021 22:04:58 +0200
Message-Id: <20211208200504.3136642-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
References: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0011.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM8P189CA0011.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 20:05:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17259c4c-f138-4e84-c1c2-08d9ba862254
X-MS-TrafficTypeDiagnostic: VE1PR04MB6638:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VE1PR04MB663870753AA9BEEBE489EEE5E06F9@VE1PR04MB6638.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kkMkHmKS+IqnvlKmHuI95Mwp97ByCoXv6wwtL8hNsWkMuRB8o2kop0eCDk+BnBoz3UmyFc4SHMSzlrngyqlETl9c0G7Abn+neVDjB8r0x+NEiIz2hslFIkoy69DhooePFlkpGk1dYzNrJPKYiVKqaNabqqqNE4bR9Og9L8H9M+sVKT2dcR9M1/n/zR16ytL/xQ/+0+SM7mEf+wOfbARPLz9Qx7KHZ/WrWFc2v4zRsOiEevgWJnUVVGQ5RvhkMFvtaDvFeiorPcCf3NVCnJrIl7GS/GXytQWUjeXhwoMimlWeJ0B1hBV/T4OIw2QwLZDfpZFkH2tSzF5+ExlhPCj0ZIoAvn4yUPtw4N1carYcBk20AVByCDbk1dl5wUUyQ7x0O/gYGbI/9dJQOvKPt/+xVMzvKTNhmJmpIA5VeU7fGT8vxeVj+TiVF0Gx/cxt23Sr2ys8sKMyKldcu4d89bDyCYmLB2JN40I9IWHtlfqjoE595PF5l8xkZp3W0pNqq7VtPyDXw/n8za/JSObFA9aQicsmGe2LrNxnCg7A0KFDKOWzEkeJwTngi4yGP9xLzVkm7jBMwE0i7F2oPGTY8ZVQspniHwO5IkbRiS27zjx6so+PvvF5MbQq7p2TJ7O2Ep5v4Vex7Hzds29sns8H0gxqtvKg2udU5igfxwxOmYc7++VamYcWYZcTagcv0zHTASc1rFGVz1/RXMKUglIpnQ0jqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(316002)(5660300002)(508600001)(7416002)(54906003)(8676002)(2616005)(44832011)(4326008)(956004)(52116002)(6916009)(8936002)(38100700002)(38350700002)(6486002)(6512007)(6506007)(66946007)(186003)(36756003)(2906002)(86362001)(83380400001)(1076003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ftNYeduHApBCa0kuTMcZENUM/EOoKkdlToA02WUEd5JU3RDJwx0NIuJa+jlx?=
 =?us-ascii?Q?ZU3UXu0c0hHLoiPHsEQwrapgepHP79/d4h34WfgFPUpSgWmMZyZZGs86iRkr?=
 =?us-ascii?Q?6a0+0llaBboPEFbmuCsudG6J+Px6n/egBgyLGQp9IyyQCEJXAFbXiaIA0GgC?=
 =?us-ascii?Q?3br40Gfm6HTwi/leuYD1hI00tQMubnqGtmMhOjiNIhZmMaQBP8vVmJfjao5D?=
 =?us-ascii?Q?lMj2GsMd76UlrXjQfRxGvIu7PxaWnAJC5dFjPd3xhJvSJ+ISswImiQJDS0Ky?=
 =?us-ascii?Q?xWd9UQr1OXjb3Vq5r45Ha/Sj88SOaD76wx/5EGXr+OayEfK9hmJl+EwY/6kD?=
 =?us-ascii?Q?gWdTpxyiu5uvs821mBpGTggtAyq5+QwMnPuiaEPm8o5i0yYY388MQj1I8fel?=
 =?us-ascii?Q?VlCERcdyFxWapNhuPvv3XJnZ8FNraMTbMunrX5g87rwP/mjgmDzm6SFomSLX?=
 =?us-ascii?Q?nV0q01XaVtcvZ8x+7boWyL7h42FeHL8crWHLFmHn44D8OetNVSVGC5lOGRam?=
 =?us-ascii?Q?tRzRX6/MMkOQFqiyRPBE4iGEK4Am6rozQfcwic1V7eSEekNVmAHySDHxeTWC?=
 =?us-ascii?Q?01O9NLFIE22vWtG8e8GPnvVh4YFcHU1brE2uf6LBgXEZKJp6wNMtHkPWxwJW?=
 =?us-ascii?Q?/ph5MHmyCu26G9OG2XW1NmSeFhMz5zLOf/+yAWv0MtM4t6vwfKeuFW29Wh/D?=
 =?us-ascii?Q?xLeTxyw8S1ur73+s49Vzqdbp2M3MODCIbB+O7RZXPMTcv/jd3t9Gb0f5H391?=
 =?us-ascii?Q?NOOGxNSZi3RJuVeK90aql8rgGDatyi1wCdkIKzwySPlUdMOqvaerzApbYdPP?=
 =?us-ascii?Q?fH1l+0dHnMPHAyS4CAsYgNhI2eXH6Mx6n1qeqtlfAO0k1QEeU2t5ebhouH1R?=
 =?us-ascii?Q?yyq83SPvmYHhemxI9gtAXNsBCL+e8SJWXWNJUQGf+1+yp1zGJi3SBKJESPIG?=
 =?us-ascii?Q?WMU3Zol5TQ2l3cYpU1L2QfrtjyUQydmkuxxu42wBHHMsZ7zTnXmPd5r72rA3?=
 =?us-ascii?Q?LIKdIuE/Z9354L/GvHnupmhvt3YgOGsZ9UWR+6YUG2p7yLsh2vTBq9iLjEso?=
 =?us-ascii?Q?fpNWat/6Tu/R992bZlAcozQAQRgK8kL1ly/KlRWuoM6Awleah3/HDFvt3m3S?=
 =?us-ascii?Q?hcw9nybjmXBwQaCVJEzNZ2oarjXJJUbPapevZ2BDzw6DraXcjo8+25UwoX2O?=
 =?us-ascii?Q?GOpzYKiMEAntXMeiZ9sOJQj2sazn3ZdzUgsvLyzLGe8KJsZtMHFe3yfdeAsW?=
 =?us-ascii?Q?l4xcTwivUQQ18wR5LBm0OFoGef/oIVDzFUR0LA5+XWq2h99BDwddMfQXKd84?=
 =?us-ascii?Q?tc8Q6Z1TAVwQ+10V4PjV4Sdnr0cD+3WgpePjtBafbLzi8YY+7ZP7cfDcky8S?=
 =?us-ascii?Q?loQ5XQPe1b55/BESWEp88emZk38Tc2jDWLRUH33qz3mS3U8fEEfuVltpmSti?=
 =?us-ascii?Q?TlhMZs01wEmuYHDOXsJ6GLpSwisplfKSB7v/gq9wMSXRKFCnABMlBJFIiYNM?=
 =?us-ascii?Q?6tkAZxPcOFg6+XjMexvBywYG1iVFOT8Tsj7B2V6tZ4F8MqxW3hHzldpzMtJb?=
 =?us-ascii?Q?UunLlcNjt3U9QqLmxPgaP5DvOUIc4g6OA/ZPHExuzsjSxE84v4QuEykaJady?=
 =?us-ascii?Q?qmGwkUkGcZnYjw7GzXLF5RA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17259c4c-f138-4e84-c1c2-08d9ba862254
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 20:05:51.5718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2UttpavoquWBkZ2B+yMlqyfyMj/ohBYliWw4ym22OIjKPGq5h4auCam6iSC2n9X/BBMHEF7sIwyyMgDL+PX4TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6638
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This tagger property is in fact not used at all by the tagger, only by
the switch driver. Therefore it makes sense to be moved to
sja1105_private.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h     | 1 +
 drivers/net/dsa/sja1105/sja1105_ptp.c | 9 ++++-----
 include/linux/dsa/sja1105.h           | 1 -
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 21dba16af097..b0612c763ec0 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -249,6 +249,7 @@ struct sja1105_private {
 	bool fixed_link[SJA1105_MAX_NUM_PORTS];
 	unsigned long ucast_egress_floods;
 	unsigned long bcast_egress_floods;
+	unsigned long hwts_tx_en;
 	const struct sja1105_info *info;
 	size_t max_xfer_len;
 	struct spi_device *spidev;
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 54396992a919..ea41cee805b0 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -98,10 +98,10 @@ int sja1105_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 
 	switch (config.tx_type) {
 	case HWTSTAMP_TX_OFF:
-		priv->ports[port].hwts_tx_en = false;
+		priv->hwts_tx_en &= ~BIT(port);
 		break;
 	case HWTSTAMP_TX_ON:
-		priv->ports[port].hwts_tx_en = true;
+		priv->hwts_tx_en |= BIT(port);
 		break;
 	default:
 		return -ERANGE;
@@ -140,7 +140,7 @@ int sja1105_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
 	struct hwtstamp_config config;
 
 	config.flags = 0;
-	if (priv->ports[port].hwts_tx_en)
+	if (priv->hwts_tx_en & BIT(port))
 		config.tx_type = HWTSTAMP_TX_ON;
 	else
 		config.tx_type = HWTSTAMP_TX_OFF;
@@ -486,10 +486,9 @@ void sja1110_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 void sja1105_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 {
 	struct sja1105_private *priv = ds->priv;
-	struct sja1105_port *sp = &priv->ports[port];
 	struct sk_buff *clone;
 
-	if (!sp->hwts_tx_en)
+	if (!(priv->hwts_tx_en & BIT(port))
 		return;
 
 	clone = skb_clone_sk(skb);
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index acd9d2afccab..32a8a1344cf6 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -74,7 +74,6 @@ struct sja1105_skb_cb {
 
 struct sja1105_port {
 	struct sja1105_tagger_data *data;
-	bool hwts_tx_en;
 };
 
 /* Timestamps are in units of 8 ns clock ticks (equivalent to
-- 
2.25.1

