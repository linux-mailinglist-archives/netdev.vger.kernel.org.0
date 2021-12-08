Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FE246DCA8
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236464AbhLHUJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:09:39 -0500
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:55236
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239963AbhLHUJg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 15:09:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KxJzx3PSF0TZVUNEjLHURxWQlxHnXW9knG88qCplcWWfl7qO+Cpu6EEDdFIxBZYn6W5bezpiR00VEOEdY6n6uVRX00ZrPZLTbdoWWgPOWgNSl4f1VbsamKeuxWBrcRfLurClcL/Mt9aYIDFxSXee2dXcHQaDvOKc+2Jy2RZxb/1KGGxNxg5ijWYIL3LMRoWeKtb+KPJJbaFnMCTlFMsWEuWP7gPb0m805zlJej+FDZpp52Ix8pssIqqmxV6qd/PdUA9CqtRD+F9MdduEq9cXpa+Ft3948bMBi873BCSR6HEE6sSOuAKwWlOVUDokqzWvBrnEL1x/3rci7WUsRZx7Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BsRhTtpUUBTvgfhe6TlIuFXXSQwdDrVaXzoEQFkil9s=;
 b=GyHw9s4PgLACfGO+kMYcJSGLPExzqFf2erM8BJcdjclkZ5U64fd7AoebmJ2ge3EGO2iW3GQt85aZym1DB2HGInC3/90/hDIggB/Jq38E0XFaA7Fq9N/R/PxhbQrOPKZKMtBC25XQmWD4jbEyBGJ3LV9zw122VmA4nFOyaDjd0HXr/6wpK1xGLwDb8cCjxCUUrVXSFQSj2oT2eo2EQ4SN+YPtm3tPRORnBlXqGa13jYWBu2UbXjtjUBhBK591JRBGiGYDTlgFY1Wz/cYjnIWy78FqiHS6cWs9rv8EeVY8IB64kKUsSpni4vZ4lEm6Rwy4v+Of3hnqZ0E3N32KZLWa7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BsRhTtpUUBTvgfhe6TlIuFXXSQwdDrVaXzoEQFkil9s=;
 b=kFyVUDzOR881jQL1md4wEpgV+CgpF3IQX2WvwqsQiKPnpaPttvggKBGUBaI5O99j2TiRZFnoPW4OoKaopSa200dOoMsc/TAtupU8gYMJ/8CuUH722aSNa76GbbKhJLXebzk/Vs5VNeZKRYZYS/qSQS0Fys/u5IcrMg0vRiN84Is=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4223.eurprd04.prod.outlook.com (2603:10a6:803:41::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Wed, 8 Dec
 2021 20:05:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 20:05:56 +0000
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
Subject: [PATCH net-next 09/11] Revert "net: dsa: move sja1110_process_meta_tstamp inside the tagging protocol driver"
Date:   Wed,  8 Dec 2021 22:05:02 +0200
Message-Id: <20211208200504.3136642-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
References: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0011.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM8P189CA0011.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 20:05:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 640259d0-447f-41b3-08d1-08d9ba862533
X-MS-TrafficTypeDiagnostic: VI1PR04MB4223:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR04MB4223BF65F1B5EE536195021CE06F9@VI1PR04MB4223.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:663;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g+srvQwNaWYZcEdtsTuQ163LzG/6IImV6uqjb7qJtlUvl+g5pniv1q+Da1MayS0/evvc/T3SS8rRhDXUDkkxF2s5HwGgbjtkroPHxJmIBlSdsFTbczgz6P5eJMVn8dIqLZSCupWo8iKFPOQpJWghGpXB3bYNq4s+qriyEHZIIMB8Bv28alvDWbpVEYhL0L5cezU+KeR7vEWszLcVPIqDGAV8cyYvoDUkplg6+51r+P80IbZUYdWJaH1oBrOjjGrqqRB6yWymmGgLKO7IekI3GSr6jw9hERRQO7+ZsjO09WO5immtEAN5uEYs/Vq5adIM4INahLvlERS+VCg0OetwxMXV3FPLRAOoCxBiNGIEiI3NSfYirJAsHZagYaTpgiOjPQbbo1OxOrzevmStS2rkIDyMMuGbsJUBbI/s8+s2LAlsnZsAhTF1gg/g5aqW0dr5HhVhQ/bndoipRMV5dlUpBZ6X0QTN2glmpAzZsV5jvkoixpO6UtKfAhmr15FJKU+sVU1QJ++XagYwAwldkiFCneaGdCjpJ/4jAxPqKYaCTbyvOreoTXMdfMLzZxh/qStdwlC3SlLP8OYfHddhm7A3J01weYiIaftjX4YuxP1vJsuMeKLaSkDy7P1nOoSCVbKRD1QIuaVsVn74Ms7Cm81yvB27fraD4N0dVV4uJSt3sk8koxMD2DRS5bPx3Y6vi1mbaRkx3WNBDEuy6KLoCCSKUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(2906002)(6506007)(66946007)(86362001)(52116002)(66476007)(66556008)(26005)(186003)(6512007)(8676002)(4326008)(2616005)(44832011)(956004)(508600001)(8936002)(6916009)(316002)(54906003)(1076003)(5660300002)(30864003)(6666004)(83380400001)(7416002)(38350700002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mA7ipP5Gjnu98MEaOZr95mD9EeQkj5I4XlRdRiv1K1THG+QTde1tMrAFC846?=
 =?us-ascii?Q?rQpWexDhdJgB0jqTRP5AYww1qnPCYrxOPdKFnpr5/tofN5x+ruRTfWt8giNe?=
 =?us-ascii?Q?pH9FMhhzse1K775R/KqBjjtGeLhLb+PB5CI1xjCqeBUd7naAFqLoX50jIuxP?=
 =?us-ascii?Q?LgdzHW4xmsr2scurVRxU4Xl8M+Lag9rnrQh0jSSKpX52nrFVqZgv3xHbU08C?=
 =?us-ascii?Q?Xc1SZn4miZLsRJ3qzySohs3tC7CVxH6NhfIsJebYOLqmAa7Hrw37GgoS+WEC?=
 =?us-ascii?Q?RufY1Qf1yjYaWtDlBKpF5h7BRZu/xgXc40wq3TKJIB1djIghSagWbtlKVhm0?=
 =?us-ascii?Q?+xhUzADkZJ4rYucM7MZqGDh2wM9Dj//f35SzMsdH3ZtxofptzIB/eDNrfili?=
 =?us-ascii?Q?VjR6MT1z9EMwFdtxrfbguMCUMLhOehps6Qzp++lGT6fRE+izdorzypxc8PfP?=
 =?us-ascii?Q?1q3amL/nDIsYxM08nygbNBYiN95X6ugQ1Xsw3g0t/N84UucpGHiuea0ULxrf?=
 =?us-ascii?Q?I7O9+EubaAPjEH0+AN8mIqvpHis8V2VOvvvfxoFsxS60LwrfWjK7HohweBoS?=
 =?us-ascii?Q?mFYrtOhNytaGq6pzfu8Rgzd5Jc0mZklPxeqV/FUlKwzFVYlU2mWZnX1RAKgG?=
 =?us-ascii?Q?s4lwMkrvea3aHAxpmpOFgSi4Sy0JuLctfQhWnnH/5HfHI2SvhSJk7YBCdLNu?=
 =?us-ascii?Q?kqTvH8t/uo3H/Z7aI1+gBEM2fFudCaKOn1LnYA0eXbjZYpT1sVBPW3tb/wtH?=
 =?us-ascii?Q?vwBsQCDkcTaaF+to1ICc5YQkw7yvcnziC7r+uCujlc/gsIY/MfkjbTE1S07I?=
 =?us-ascii?Q?NczMrdzzG8N1Yk5JCW7kCLxVlmrEohzhDbeCyPPDcuBy9WxSq9lqyBh41t5e?=
 =?us-ascii?Q?Z9WdnqVNqBt91wJ8LzBNuGnzb/qMSap8/Ac0iLPN9sROToUuMtZxUAv0KMqf?=
 =?us-ascii?Q?QLrHzTWh/2IP7byDHJBNXIFvjvvTIo+F2FaruY8z+cqj9XY3HunPurocGgMn?=
 =?us-ascii?Q?8SV7FIRHt62hFXlKzsyNV7pT5/LuA7lgzol2akbLYkou51xCRy47PPyEg9tl?=
 =?us-ascii?Q?kjZ4DbF0CR4iibMc6TIwdHmY2ssEcYKM7SxwHCiaBWr4Zvx9J7FP2jDJLbiC?=
 =?us-ascii?Q?LyVdSqxpeWLCvHBdDF/jdd6ueCTlUvHDF+v3ahQGUiyVx7XdFUN8ucd9w7OE?=
 =?us-ascii?Q?KexztIPLO1rUo7N6XCVHxRn1dWZ3YlGCbG/liTV9NzftpAAs4Q29sFtiKdg+?=
 =?us-ascii?Q?bYYDPQkMjxaI1UF4GYAGx0F+MTpm+Eu9G0No/6uTHSYiv8D8fk99JqUNReol?=
 =?us-ascii?Q?r0k3kcVfL2nzQimibpqt9eAN8E4N/jTpA0mM2BCVTfh4Kfk6RtwWSl74c6rW?=
 =?us-ascii?Q?5aYZ+gQWsM7DT5pDxUqFVo4HE7v/7CkGpNRDo7GCrObbAJli+LkjM21WrZ2W?=
 =?us-ascii?Q?KrLhoukJ3Oo3VbWfzMKKdHqXY8O2t7Xfot6QrtoZLaZj6fPjXBDgcb9o7HLn?=
 =?us-ascii?Q?oh1WVSkTKgpIJoU5xlYFGpNZoPNcXkbAZAnC5XKTu5+/G5Jfv1IQUkGtYQPz?=
 =?us-ascii?Q?SYBnW7X/JH2gWETl6PYwoPBY2IDDPz94sH9vZlopyMndz0MR8VhE8ZUOYqXQ?=
 =?us-ascii?Q?6stFxyA8iMg6vIZTLDtbWNA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 640259d0-447f-41b3-08d1-08d9ba862533
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 20:05:56.5089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 90Fu6ZFRXPwB6mgFp6TqIA5MyIO5q6u5fwsPYKKTZB/Dz1AZRivaswDO64+Y8MhwsTyPE8MVS5LgGeRQ5Q2M2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 6d709cadfde68dbd12bef12fcced6222226dcb06.

The above change was done to avoid calling symbols exported by the
switch driver from the tagging protocol driver.

With the tagger-owned storage model, we have a new option on our hands,
and that is for the switch driver to provide a data consumer handler in
the form of a function pointer inside the ->connect_tag_protocol()
method. Having a function pointer avoids the problems of the exported
symbols approach.

By creating a handler for metadata frames holding TX timestamps on
SJA1110, we are able to eliminate an skb queue from the tagger data, and
replace it with a simple, and stateless, function pointer. This skb
queue is now handled exclusively by sja1105_ptp.c, which makes the code
easier to follow, as it used to be before the reverted patch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c |  1 +
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 44 ++++++++++++++++++++---
 drivers/net/dsa/sja1105/sja1105_ptp.h  | 24 +++++++++++++
 include/linux/dsa/sja1105.h            | 26 ++++----------
 net/dsa/tag_sja1105.c                  | 50 ++++----------------------
 5 files changed, 78 insertions(+), 67 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 4f5ea5d6a623..9171fbea588c 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2714,6 +2714,7 @@ static int sja1105_connect_tag_protocol(struct dsa_switch *ds,
 	case DSA_TAG_PROTO_SJA1105:
 		tagger_data = sja1105_tagger_data(ds);
 		tagger_data->xmit_work_fn = sja1105_port_deferred_xmit;
+		tagger_data->meta_tstamp_handler = sja1110_process_meta_tstamp;
 		return 0;
 	default:
 		return -EPROTONOSUPPORT;
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index b34e4674e217..a9f7e4ae0bb2 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -80,7 +80,7 @@ static int sja1105_change_rxtstamping(struct sja1105_private *priv,
 		tagger_data->stampable_skb = NULL;
 	}
 	ptp_cancel_worker_sync(ptp_data->clock);
-	skb_queue_purge(&tagger_data->skb_txtstamp_queue);
+	skb_queue_purge(&ptp_data->skb_txtstamp_queue);
 	skb_queue_purge(&ptp_data->skb_rxtstamp_queue);
 
 	return sja1105_static_config_reload(priv, SJA1105_RX_HWTSTAMPING);
@@ -456,15 +456,48 @@ bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
 	return priv->info->rxtstamp(ds, port, skb);
 }
 
+void sja1110_process_meta_tstamp(struct dsa_switch *ds, int port, u8 ts_id,
+				 enum sja1110_meta_tstamp dir, u64 tstamp)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
+	struct sk_buff *skb, *skb_tmp, *skb_match = NULL;
+	struct skb_shared_hwtstamps shwt = {0};
+
+	/* We don't care about RX timestamps on the CPU port */
+	if (dir == SJA1110_META_TSTAMP_RX)
+		return;
+
+	spin_lock(&ptp_data->skb_txtstamp_queue.lock);
+
+	skb_queue_walk_safe(&ptp_data->skb_txtstamp_queue, skb, skb_tmp) {
+		if (SJA1105_SKB_CB(skb)->ts_id != ts_id)
+			continue;
+
+		__skb_unlink(skb, &ptp_data->skb_txtstamp_queue);
+		skb_match = skb;
+
+		break;
+	}
+
+	spin_unlock(&ptp_data->skb_txtstamp_queue.lock);
+
+	if (WARN_ON(!skb_match))
+		return;
+
+	shwt.hwtstamp = ns_to_ktime(sja1105_ticks_to_ns(tstamp));
+	skb_complete_tx_timestamp(skb_match, &shwt);
+}
+
 /* In addition to cloning the skb which is done by the common
  * sja1105_port_txtstamp, we need to generate a timestamp ID and save the
  * packet to the TX timestamping queue.
  */
 void sja1110_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 {
-	struct sja1105_tagger_data *tagger_data = sja1105_tagger_data(ds);
 	struct sk_buff *clone = SJA1105_SKB_CB(skb)->clone;
 	struct sja1105_private *priv = ds->priv;
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 	u8 ts_id;
 
 	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
@@ -479,7 +512,7 @@ void sja1110_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 
 	spin_unlock(&priv->ts_id_lock);
 
-	skb_queue_tail(&tagger_data->skb_txtstamp_queue, clone);
+	skb_queue_tail(&ptp_data->skb_txtstamp_queue, clone);
 }
 
 /* Called from dsa_skb_tx_timestamp. This callback is just to clone
@@ -919,6 +952,8 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
 
 	/* Only used on SJA1105 */
 	skb_queue_head_init(&ptp_data->skb_rxtstamp_queue);
+	/* Only used on SJA1110 */
+	skb_queue_head_init(&ptp_data->skb_txtstamp_queue);
 
 	ptp_data->clock = ptp_clock_register(&ptp_data->caps, ds->dev);
 	if (IS_ERR_OR_NULL(ptp_data->clock))
@@ -934,7 +969,6 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
 
 void sja1105_ptp_clock_unregister(struct dsa_switch *ds)
 {
-	struct sja1105_tagger_data *tagger_data = sja1105_tagger_data(ds);
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 
@@ -943,7 +977,7 @@ void sja1105_ptp_clock_unregister(struct dsa_switch *ds)
 
 	del_timer_sync(&ptp_data->extts_timer);
 	ptp_cancel_worker_sync(ptp_data->clock);
-	skb_queue_purge(&tagger_data->skb_txtstamp_queue);
+	skb_queue_purge(&ptp_data->skb_txtstamp_queue);
 	skb_queue_purge(&ptp_data->skb_rxtstamp_queue);
 	ptp_clock_unregister(ptp_data->clock);
 	ptp_data->clock = NULL;
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 3ae6b9fdd492..416461ee95d2 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -8,6 +8,21 @@
 
 #if IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP)
 
+/* Timestamps are in units of 8 ns clock ticks (equivalent to
+ * a fixed 125 MHz clock).
+ */
+#define SJA1105_TICK_NS			8
+
+static inline s64 ns_to_sja1105_ticks(s64 ns)
+{
+	return ns / SJA1105_TICK_NS;
+}
+
+static inline s64 sja1105_ticks_to_ns(s64 ticks)
+{
+	return ticks * SJA1105_TICK_NS;
+}
+
 /* Calculate the first base_time in the future that satisfies this
  * relationship:
  *
@@ -62,6 +77,10 @@ struct sja1105_ptp_data {
 	struct timer_list extts_timer;
 	/* Used only on SJA1105 to reconstruct partial timestamps */
 	struct sk_buff_head skb_rxtstamp_queue;
+	/* Used on SJA1110 where meta frames are generated only for
+	 * 2-step TX timestamps
+	 */
+	struct sk_buff_head skb_txtstamp_queue;
 	struct ptp_clock_info caps;
 	struct ptp_clock *clock;
 	struct sja1105_ptp_cmd cmd;
@@ -112,6 +131,9 @@ bool sja1105_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb);
 bool sja1110_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb);
 void sja1110_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb);
 
+void sja1110_process_meta_tstamp(struct dsa_switch *ds, int port, u8 ts_id,
+				 enum sja1110_meta_tstamp dir, u64 tstamp);
+
 #else
 
 struct sja1105_ptp_cmd;
@@ -178,6 +200,8 @@ static inline int sja1105_ptp_commit(struct dsa_switch *ds,
 #define sja1110_rxtstamp NULL
 #define sja1110_txtstamp NULL
 
+#define sja1110_process_meta_tstamp NULL
+
 #endif /* IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP) */
 
 #endif /* _SJA1105_PTP_H */
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 9f7d42cbbc08..d216211b64f8 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -37,6 +37,11 @@
 
 #define SJA1105_HWTS_RX_EN			0
 
+enum sja1110_meta_tstamp {
+	SJA1110_META_TSTAMP_TX = 0,
+	SJA1110_META_TSTAMP_RX = 1,
+};
+
 struct sja1105_deferred_xmit_work {
 	struct dsa_port *dp;
 	struct sk_buff *skb;
@@ -51,12 +56,10 @@ struct sja1105_tagger_data {
 	 */
 	spinlock_t meta_lock;
 	unsigned long state;
-	/* Used on SJA1110 where meta frames are generated only for
-	 * 2-step TX timestamps
-	 */
-	struct sk_buff_head skb_txtstamp_queue;
 	struct kthread_worker *xmit_worker;
 	void (*xmit_work_fn)(struct kthread_work *work);
+	void (*meta_tstamp_handler)(struct dsa_switch *ds, int port, u8 ts_id,
+				    enum sja1110_meta_tstamp dir, u64 tstamp);
 };
 
 struct sja1105_skb_cb {
@@ -69,21 +72,6 @@ struct sja1105_skb_cb {
 #define SJA1105_SKB_CB(skb) \
 	((struct sja1105_skb_cb *)((skb)->cb))
 
-/* Timestamps are in units of 8 ns clock ticks (equivalent to
- * a fixed 125 MHz clock).
- */
-#define SJA1105_TICK_NS			8
-
-static inline s64 ns_to_sja1105_ticks(s64 ns)
-{
-	return ns / SJA1105_TICK_NS;
-}
-
-static inline s64 sja1105_ticks_to_ns(s64 ticks)
-{
-	return ticks * SJA1105_TICK_NS;
-}
-
 static inline struct sja1105_tagger_data *
 sja1105_tagger_data(struct dsa_switch *ds)
 {
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index f3c1b31645f5..fe6a6d95bb26 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -4,7 +4,6 @@
 #include <linux/if_vlan.h>
 #include <linux/dsa/sja1105.h>
 #include <linux/dsa/8021q.h>
-#include <linux/skbuff.h>
 #include <linux/packing.h>
 #include "dsa_priv.h"
 
@@ -54,11 +53,6 @@
 #define SJA1110_TX_TRAILER_LEN			4
 #define SJA1110_MAX_PADDING_LEN			15
 
-enum sja1110_meta_tstamp {
-	SJA1110_META_TSTAMP_TX = 0,
-	SJA1110_META_TSTAMP_RX = 1,
-};
-
 /* Similar to is_link_local_ether_addr(hdr->h_dest) but also covers PTP */
 static inline bool sja1105_is_link_local(const struct sk_buff *skb)
 {
@@ -539,44 +533,12 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 					      is_meta);
 }
 
-static void sja1110_process_meta_tstamp(struct dsa_switch *ds, int port,
-					u8 ts_id, enum sja1110_meta_tstamp dir,
-					u64 tstamp)
-{
-	struct sja1105_tagger_data *tagger_data = sja1105_tagger_data(ds);
-	struct sk_buff *skb, *skb_tmp, *skb_match = NULL;
-	struct skb_shared_hwtstamps shwt = {0};
-
-	/* We don't care about RX timestamps on the CPU port */
-	if (dir == SJA1110_META_TSTAMP_RX)
-		return;
-
-	spin_lock(&tagger_data->skb_txtstamp_queue.lock);
-
-	skb_queue_walk_safe(&tagger_data->skb_txtstamp_queue, skb, skb_tmp) {
-		if (SJA1105_SKB_CB(skb)->ts_id != ts_id)
-			continue;
-
-		__skb_unlink(skb, &tagger_data->skb_txtstamp_queue);
-		skb_match = skb;
-
-		break;
-	}
-
-	spin_unlock(&tagger_data->skb_txtstamp_queue.lock);
-
-	if (WARN_ON(!skb_match))
-		return;
-
-	shwt.hwtstamp = ns_to_ktime(sja1105_ticks_to_ns(tstamp));
-	skb_complete_tx_timestamp(skb_match, &shwt);
-}
-
 static struct sk_buff *sja1110_rcv_meta(struct sk_buff *skb, u16 rx_header)
 {
 	u8 *buf = dsa_etype_header_pos_rx(skb) + SJA1110_HEADER_LEN;
 	int switch_id = SJA1110_RX_HEADER_SWITCH_ID(rx_header);
 	int n_ts = SJA1110_RX_HEADER_N_TS(rx_header);
+	struct sja1105_tagger_data *tagger_data;
 	struct net_device *master = skb->dev;
 	struct dsa_port *cpu_dp;
 	struct dsa_switch *ds;
@@ -590,6 +552,10 @@ static struct sk_buff *sja1110_rcv_meta(struct sk_buff *skb, u16 rx_header)
 		return NULL;
 	}
 
+	tagger_data = sja1105_tagger_data(ds);
+	if (!tagger_data->meta_tstamp_handler)
+		return NULL;
+
 	for (i = 0; i <= n_ts; i++) {
 		u8 ts_id, source_port, dir;
 		u64 tstamp;
@@ -599,8 +565,8 @@ static struct sk_buff *sja1110_rcv_meta(struct sk_buff *skb, u16 rx_header)
 		dir = (buf[1] & BIT(3)) >> 3;
 		tstamp = be64_to_cpu(*(__be64 *)(buf + 2));
 
-		sja1110_process_meta_tstamp(ds, source_port, ts_id, dir,
-					    tstamp);
+		tagger_data->meta_tstamp_handler(ds, source_port, ts_id, dir,
+						 tstamp);
 
 		buf += SJA1110_META_TSTAMP_SIZE;
 	}
@@ -767,8 +733,6 @@ static int sja1105_connect(struct dsa_switch_tree *dst)
 			goto out;
 		}
 
-		/* Only used on SJA1110 */
-		skb_queue_head_init(&tagger_data->skb_txtstamp_queue);
 		spin_lock_init(&tagger_data->meta_lock);
 
 		xmit_worker = kthread_create_worker(0, "dsa%d:%d_xmit",
-- 
2.25.1

