Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578CF46DCAC
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240007AbhLHUJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:09:43 -0500
Received: from mail-am6eur05on2088.outbound.protection.outlook.com ([40.107.22.88]:43105
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240001AbhLHUJj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 15:09:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXV7eB+ZvV7EBemAdxM+zi/yQDSctiugTqxOfJh9s2FPHHCO3MjBHkxvFGpQR3Zsg4tpnJnr1C0rkcoC3qUh8CX9HwDRkcIdmxyXEYelxJrCaJaZKywjsuAGjJyrAWg8rKSiiAhoK1uD15+6aADjtPXVCLfUcfLeqPJ4fhnC1Bop+UwPUKihWgPN0/wjp0Kv43WHGb9hkR12QMhnw78U/myH8X6RMcT/Ej0GpxlGMM1EPDHM5HD0KXQub5furZKXXDZhrPcs9K+aPjOW3pCvyBdZuCSvwBvL1wS1wBiR6CHtnE78XxUNy0Bcg9u20pZxeJMnaSzqDE3ufS1OYzPHug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bnxB4kBLQPMHGCUw3gPBHZRwqskA4kPaownoJbLeCrE=;
 b=IgxpIddBs45ctJJz2OmSssTqQ7C95cmBbqJSZQZZ147mKSmlCvTBmU1oiSFWQI/+PC1/5dtBfJP/8Q0MSvzbkufzAejXaGVRR9JJ6Xv4/6DD/bv5QTw125lNl6mAMSjE5itEWi3W5J9RYsAn0/JgCjbvKSMu9vN6BxYPu2MWvI+U4f/s6pxriYslFEaXpPyTOnjVeShNB7nMPgLbeK5R9mJWMtZVogLDjy3CQ31D5VdT+y2lW1SjUoxPPu3KUPmgKBJOBy7mJQ408w5Gchzh7POogn/9XmvyH+5Fje8kjccm1Ozi188dmBdlH6c+tyxmgb/90IQ0g+2vGk2NiiajTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bnxB4kBLQPMHGCUw3gPBHZRwqskA4kPaownoJbLeCrE=;
 b=CX/uIhAhoC+LdRTJFXdzA+5ocGsoxJQzGzGXRPaEp1AiGV7Uz2WTMM21O6LGPe8gRPHGMV67ESwYMEmPGcutKifqc/eJmi8gObxBEQgNs7G057ZKQ2pu0BkvOOHNKUHxfOMRnG8YDFQ5U8MV1reVp02oA9mr1qyqpnu7z5+2X5E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6638.eurprd04.prod.outlook.com (2603:10a6:803:119::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 20:05:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 20:05:52 +0000
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
Subject: [PATCH net-next 06/11] net: dsa: sja1105: make dp->priv point directly to sja1105_tagger_data
Date:   Wed,  8 Dec 2021 22:04:59 +0200
Message-Id: <20211208200504.3136642-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
References: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0011.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM8P189CA0011.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 20:05:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10e7c77f-117c-44bf-7a68-08d9ba862313
X-MS-TrafficTypeDiagnostic: VE1PR04MB6638:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VE1PR04MB6638DAA91DAB5E9BE2BACA82E06F9@VE1PR04MB6638.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PqoLK5Da2SQD9jGh587j6oKo1HuePrBwjZG36DDG519AR+GrQ5ogWz3deuer1X2CoGduSTpSyNYNF4gdZx9c4Qr8RmUq8THq2jY34EoEygGZK7jTQW3wJF8pUZOvYR9oeI9FkM3JK15ljimG6jRrYfHKrc/mttgGp74QFG5YGVfQbVxC+bqPaBjfVOB1quHPndHRQTvyt0xGM7bwrDQZu7rDHk5JnVnYnXZZeJmWIr56R4usMkHowAd2fx689Ulil4+QsA4ayZ5VyuTkMNpp7U8y+yJ0FEcepaZMEIb5kk1KwJItdwL3PbFkj5y6qWos8GiWd+ZY76t23FNdAKRknepmMA7gUMqx1DaCX6OsHcVHjnhm/Zfla2r1yWKgsa2IsBhgchlxLSn1HLyBZw2SMpdXDt083tmK9o4SxLp8IP3zA2hweEhhc5f19NIobkHjjTdVuHQZa1WJoQ/+YRsUu3c0kDhOjun3tZ7GU9mNhxv3T7Wl0lt4Mk+pnh4CSnJtht2t1XU1IFwBptJa+haqDx+umsa2AAP5eD791cZEERzW3zMCSzSLbj0c55MsGMxxGWoiB3jCrot94l2tsiNOEXpLx1uspu/uxgIsuETXSWrWZ9pH+FpWHOMiyFG3I1IhgsaMFbq4e0oL3n/XMOXEEtYn74COcLkW/QoiJDYOBwKiy1ZeQDjevu2PbBP2prw11AD8ePZH2qms2aPFoSpu0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(316002)(5660300002)(508600001)(7416002)(54906003)(8676002)(2616005)(44832011)(4326008)(956004)(52116002)(6916009)(8936002)(38100700002)(38350700002)(6486002)(6512007)(6506007)(66946007)(186003)(36756003)(2906002)(86362001)(83380400001)(1076003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l1A2KYpjRs8ZAxB5wWrnK7f55fkDkQ6wDy9xDIjFiiV4Ld3QV/xGhpnvloYX?=
 =?us-ascii?Q?RcZL6AVaGFzY19dwowhKz3tcWxQNzJ7NelZc6gyTx73qfuxu4e7s9JNYYIQQ?=
 =?us-ascii?Q?nPy7VrXu1Yb/1gda0ljDDjI4/Ob7N/8o48Kafb30wMfJLTTRQ4bVTzOIA363?=
 =?us-ascii?Q?/X42oGlvV7Y/uOUudROA7eDbZx/TgbfXP7/LKmOVQc+IAPdbLi2x1VK7Zjy2?=
 =?us-ascii?Q?yKampMsby2OZMmWDQtEQTCWB9H0kXsPH2JT0rsbyATuNvjCCnOIGtgwegFs/?=
 =?us-ascii?Q?cc+UyBTIOboAqSoXjOuWXehWlxSMuJwFcTGp9ys5WthB3q/wka5qUs2aBIfe?=
 =?us-ascii?Q?1dsDPl/A7rfVZ59piQOAJl6ZHEAwwzNQ6wmgmRg4hUspC9Cm5xWNJ3CVooJ4?=
 =?us-ascii?Q?jFduS2tEcNhc8eqz/8VCojx7J7jmrWGy9gUettCqNuU7TTMOCkydLV4UH8Nf?=
 =?us-ascii?Q?GlhAQV6iCE+jtsap0qcyX3hupBLicLn+LKyHuXzdYQWANVcXFjzFmbDgWSKS?=
 =?us-ascii?Q?LoYxmObsxs4+0tIUh1kp6HETug5lX0IyqwtS/PoRxGX4fBtqKUpE7TP7bhWl?=
 =?us-ascii?Q?nktDNqhiddx2wyC/ocx/piPMFxzAO7hNN/bSfRsD5hl4uLmWfsq45jEAgNht?=
 =?us-ascii?Q?xjbPyQ7/Go3INDbjvl1FS8kwa32l336pysgEPpx3MsokC+AH0IyXKvho5Lgs?=
 =?us-ascii?Q?2l7NL7CtIKcNmtrvTwLu8fHbt9xN5Yk81Ork6B38nrsWmYNYhWES7m9uAJkR?=
 =?us-ascii?Q?+EEpgGHMXIKUa0vJttw2YgeydISNyuAltpxD+aEzJqkiUrQpCk/O7/T6kTM0?=
 =?us-ascii?Q?idzrWIDR/zeQ1rqPOydfdsZh07g0bQL04hrh/X9adW+pgQrN6aQgTFH0wA1f?=
 =?us-ascii?Q?9EzngZmTK5Zky206YHb4cz5W1oksJYETawC9HiYqBtWfERzLYc7A69/lFNlH?=
 =?us-ascii?Q?MC1jcjrRA73ksCk/sFsIl7dfaZBi99BqRdM1GZ71AWqnRkmXGmVoVO11BJCG?=
 =?us-ascii?Q?eMJgE+aqmI+X6yfNnELvDYWWh5g6+mYotzHcPy+oI6ANTC5EC8EeEn0Kq6xM?=
 =?us-ascii?Q?AHgGakX90cqGVKBkX12CJRmNQ0QjJmFNUmTUIPmSnP6ch0bgt3Ua+wkWydaA?=
 =?us-ascii?Q?l9YqaSFekiveDDBLTsBfLMosf8F3mcuQv2VPvzBszBaynC7HQhG7c4Y3ihZY?=
 =?us-ascii?Q?S4H2VockEPsWC8KDAlZuRUaj65AIIzKCWEjxA/QcmsvM/WEEQciMR15nSQKD?=
 =?us-ascii?Q?4D7yESOy836RxOxz5Mb19PZpPWE/MnbLvzZveNjy3PvWk0vA1Pj3QaRJTSGV?=
 =?us-ascii?Q?0iis1miAfEr9g3Luu1Hq5brt/eYqfh6XcwXnOJ93MjTOo6m3Ez88acSzng6R?=
 =?us-ascii?Q?vdvYQSLS26JeDu+zvbICzFRokjYrNGWUMQKC2L92mDBeLkfSQ0iLmsItjcHN?=
 =?us-ascii?Q?py9OdKVPp/CEWR2YpKhifz11pRY1WJgtKGK/XsV/p2f5aRG5TIic85Y/IDS9?=
 =?us-ascii?Q?FQgNexN/rCDfew/zY6fb2Bzl+efLZ4RdP97gU/2EH1PwB8LOG7c9uguoW/Re?=
 =?us-ascii?Q?FItiNZFjMXEdI7sTkSaw1zG0MpV7fW+otZI/1GZG8NER4BrFDqFhTG7wY78a?=
 =?us-ascii?Q?UqAVCttWFNqU+FUQVcwN1fY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10e7c77f-117c-44bf-7a68-08d9ba862313
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 20:05:52.8373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XWMI0VZeXcf9/4AHHcaN68CeyBxjprspxS0AFwxCUEzXYOBsjpXlcJEg4ou5G8oXH9AE52wE5RyXAOkQXpCLfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6638
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The design of the sja1105 tagger dp->priv is that each port has a
separate struct sja1105_port, and the sp->data pointer points to a
common struct sja1105_tagger_data.

We have removed all per-port members accessible by the tagger, and now
only struct sja1105_tagger_data remains. Make dp->priv point directly to
this.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  1 -
 drivers/net/dsa/sja1105/sja1105_main.c | 16 +++------
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 16 +++++----
 include/linux/dsa/sja1105.h            |  8 +----
 net/dsa/tag_sja1105.c                  | 48 ++++++++++++++------------
 5 files changed, 39 insertions(+), 50 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index b0612c763ec0..6ef6fb4f30e6 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -257,7 +257,6 @@ struct sja1105_private {
 	u16 bridge_pvid[SJA1105_MAX_NUM_PORTS];
 	u16 tag_8021q_pvid[SJA1105_MAX_NUM_PORTS];
 	struct sja1105_flow_block flow_block;
-	struct sja1105_port ports[SJA1105_MAX_NUM_PORTS];
 	/* Serializes transmission of management frames so that
 	 * the switch doesn't confuse them with one another.
 	 */
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 5c486bd2bc61..4f3350df7f4d 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3017,7 +3017,8 @@ static int sja1105_setup_ports(struct sja1105_private *priv)
 	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
 	struct dsa_switch *ds = priv->ds;
 	struct kthread_worker *worker;
-	int port, rc;
+	struct dsa_port *dp;
+	int rc;
 
 	worker = kthread_create_worker(0, "dsa%d:%d_xmit", ds->dst->index,
 				       ds->index);
@@ -3031,17 +3032,8 @@ static int sja1105_setup_ports(struct sja1105_private *priv)
 	tagger_data->xmit_worker = worker;
 	tagger_data->xmit_work_fn = sja1105_port_deferred_xmit;
 
-	/* Connections between dsa_port and sja1105_port */
-	for (port = 0; port < ds->num_ports; port++) {
-		struct sja1105_port *sp = &priv->ports[port];
-		struct dsa_port *dp = dsa_to_port(ds, port);
-
-		if (!dsa_port_is_user(dp))
-			continue;
-
-		dp->priv = sp;
-		sp->data = tagger_data;
-	}
+	dsa_switch_for_each_user_port(dp, ds)
+		dp->priv = tagger_data;
 
 	return 0;
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index ea41cee805b0..9077067328c2 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -461,22 +461,24 @@ void sja1110_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 {
 	struct sk_buff *clone = SJA1105_SKB_CB(skb)->clone;
 	struct sja1105_private *priv = ds->priv;
-	struct sja1105_port *sp = &priv->ports[port];
+	struct sja1105_tagger_data *tagger_data;
 	u8 ts_id;
 
+	tagger_data = &priv->tagger_data;
+
 	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 
-	spin_lock(&sp->data->meta_lock);
+	spin_lock(&tagger_data->meta_lock);
 
-	ts_id = sp->data->ts_id;
+	ts_id = tagger_data->ts_id;
 	/* Deal automatically with 8-bit wraparound */
-	sp->data->ts_id++;
+	tagger_data->ts_id++;
 
 	SJA1105_SKB_CB(clone)->ts_id = ts_id;
 
-	spin_unlock(&sp->data->meta_lock);
+	spin_unlock(&tagger_data->meta_lock);
 
-	skb_queue_tail(&sp->data->skb_txtstamp_queue, clone);
+	skb_queue_tail(&tagger_data->skb_txtstamp_queue, clone);
 }
 
 /* Called from dsa_skb_tx_timestamp. This callback is just to clone
@@ -488,7 +490,7 @@ void sja1105_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 	struct sja1105_private *priv = ds->priv;
 	struct sk_buff *clone;
 
-	if (!(priv->hwts_tx_en & BIT(port))
+	if (!(priv->hwts_tx_en & BIT(port)))
 		return;
 
 	clone = skb_clone_sk(skb);
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 32a8a1344cf6..1dda9cce85d9 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -43,9 +43,7 @@ struct sja1105_deferred_xmit_work {
 	struct kthread_work work;
 };
 
-/* Global tagger data: each struct sja1105_port has a reference to
- * the structure defined in struct sja1105_private.
- */
+/* Global tagger data */
 struct sja1105_tagger_data {
 	struct sk_buff *stampable_skb;
 	/* Protects concurrent access to the meta state machine
@@ -72,10 +70,6 @@ struct sja1105_skb_cb {
 #define SJA1105_SKB_CB(skb) \
 	((struct sja1105_skb_cb *)((skb)->cb))
 
-struct sja1105_port {
-	struct sja1105_tagger_data *data;
-};
-
 /* Timestamps are in units of 8 ns clock ticks (equivalent to
  * a fixed 125 MHz clock).
  */
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 7008952b6c1d..fc2af71b965c 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -125,13 +125,13 @@ static inline bool sja1105_is_meta_frame(const struct sk_buff *skb)
 static struct sk_buff *sja1105_defer_xmit(struct dsa_port *dp,
 					  struct sk_buff *skb)
 {
+	struct sja1105_tagger_data *tagger_data = dp->priv;
 	void (*xmit_work_fn)(struct kthread_work *work);
 	struct sja1105_deferred_xmit_work *xmit_work;
-	struct sja1105_port *sp = dp->priv;
 	struct kthread_worker *xmit_worker;
 
-	xmit_work_fn = sp->data->xmit_work_fn;
-	xmit_worker = sp->data->xmit_worker;
+	xmit_work_fn = tagger_data->xmit_work_fn;
+	xmit_worker = tagger_data->xmit_worker;
 
 	if (!xmit_work_fn || !xmit_worker)
 		return NULL;
@@ -368,32 +368,32 @@ static struct sk_buff
 	 */
 	if (is_link_local) {
 		struct dsa_port *dp = dsa_slave_to_port(skb->dev);
-		struct sja1105_port *sp = dp->priv;
+		struct sja1105_tagger_data *tagger_data = dp->priv;
 
 		if (unlikely(!dsa_port_is_sja1105(dp)))
 			return skb;
 
-		if (!test_bit(SJA1105_HWTS_RX_EN, &sp->data->state))
+		if (!test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
 			/* Do normal processing. */
 			return skb;
 
-		spin_lock(&sp->data->meta_lock);
+		spin_lock(&tagger_data->meta_lock);
 		/* Was this a link-local frame instead of the meta
 		 * that we were expecting?
 		 */
-		if (sp->data->stampable_skb) {
+		if (tagger_data->stampable_skb) {
 			dev_err_ratelimited(dp->ds->dev,
 					    "Expected meta frame, is %12llx "
 					    "in the DSA master multicast filter?\n",
 					    SJA1105_META_DMAC);
-			kfree_skb(sp->data->stampable_skb);
+			kfree_skb(tagger_data->stampable_skb);
 		}
 
 		/* Hold a reference to avoid dsa_switch_rcv
 		 * from freeing the skb.
 		 */
-		sp->data->stampable_skb = skb_get(skb);
-		spin_unlock(&sp->data->meta_lock);
+		tagger_data->stampable_skb = skb_get(skb);
+		spin_unlock(&tagger_data->meta_lock);
 
 		/* Tell DSA we got nothing */
 		return NULL;
@@ -406,7 +406,7 @@ static struct sk_buff
 	 */
 	} else if (is_meta) {
 		struct dsa_port *dp = dsa_slave_to_port(skb->dev);
-		struct sja1105_port *sp = dp->priv;
+		struct sja1105_tagger_data *tagger_data = dp->priv;
 		struct sk_buff *stampable_skb;
 
 		if (unlikely(!dsa_port_is_sja1105(dp)))
@@ -415,13 +415,13 @@ static struct sk_buff
 		/* Drop the meta frame if we're not in the right state
 		 * to process it.
 		 */
-		if (!test_bit(SJA1105_HWTS_RX_EN, &sp->data->state))
+		if (!test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
 			return NULL;
 
-		spin_lock(&sp->data->meta_lock);
+		spin_lock(&tagger_data->meta_lock);
 
-		stampable_skb = sp->data->stampable_skb;
-		sp->data->stampable_skb = NULL;
+		stampable_skb = tagger_data->stampable_skb;
+		tagger_data->stampable_skb = NULL;
 
 		/* Was this a meta frame instead of the link-local
 		 * that we were expecting?
@@ -429,14 +429,14 @@ static struct sk_buff
 		if (!stampable_skb) {
 			dev_err_ratelimited(dp->ds->dev,
 					    "Unexpected meta frame\n");
-			spin_unlock(&sp->data->meta_lock);
+			spin_unlock(&tagger_data->meta_lock);
 			return NULL;
 		}
 
 		if (stampable_skb->dev != skb->dev) {
 			dev_err_ratelimited(dp->ds->dev,
 					    "Meta frame on wrong port\n");
-			spin_unlock(&sp->data->meta_lock);
+			spin_unlock(&tagger_data->meta_lock);
 			return NULL;
 		}
 
@@ -447,7 +447,7 @@ static struct sk_buff
 		skb = stampable_skb;
 		sja1105_transfer_meta(skb, meta);
 
-		spin_unlock(&sp->data->meta_lock);
+		spin_unlock(&tagger_data->meta_lock);
 	}
 
 	return skb;
@@ -545,8 +545,8 @@ static void sja1110_process_meta_tstamp(struct dsa_switch *ds, int port,
 {
 	struct sk_buff *skb, *skb_tmp, *skb_match = NULL;
 	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct sja1105_tagger_data *tagger_data;
 	struct skb_shared_hwtstamps shwt = {0};
-	struct sja1105_port *sp = dp->priv;
 
 	if (!dsa_port_is_sja1105(dp))
 		return;
@@ -555,19 +555,21 @@ static void sja1110_process_meta_tstamp(struct dsa_switch *ds, int port,
 	if (dir == SJA1110_META_TSTAMP_RX)
 		return;
 
-	spin_lock(&sp->data->skb_txtstamp_queue.lock);
+	tagger_data = dp->priv;
 
-	skb_queue_walk_safe(&sp->data->skb_txtstamp_queue, skb, skb_tmp) {
+	spin_lock(&tagger_data->skb_txtstamp_queue.lock);
+
+	skb_queue_walk_safe(&tagger_data->skb_txtstamp_queue, skb, skb_tmp) {
 		if (SJA1105_SKB_CB(skb)->ts_id != ts_id)
 			continue;
 
-		__skb_unlink(skb, &sp->data->skb_txtstamp_queue);
+		__skb_unlink(skb, &tagger_data->skb_txtstamp_queue);
 		skb_match = skb;
 
 		break;
 	}
 
-	spin_unlock(&sp->data->skb_txtstamp_queue.lock);
+	spin_unlock(&tagger_data->skb_txtstamp_queue.lock);
 
 	if (WARN_ON(!skb_match))
 		return;
-- 
2.25.1

