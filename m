Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825DB46F788
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 00:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbhLIXjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 18:39:06 -0500
Received: from mail-am6eur05on2077.outbound.protection.outlook.com ([40.107.22.77]:21854
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229760AbhLIXjF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 18:39:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OszHZwEeXMppbRrSMr/1Oj4VqoQHdlg+6RAnnWCTQ63bU2NiLLoKU7N+caZWvz2T0WZljXRm7S3q/k5oPCwvL/qMPkFbZ9UPbZ9breAGLN8ExO2/lXBg7Us2zHBeRrnCPl7u5CZM/NTwaOSNR41brX85MfSelLkF62tQa1/TRb0x/IjPswjBYHBDJ8WJgBP/ii6Lc/EXHqBdwY7kiONcru2+iZt3J2rjVCafP8B6Vg+Aih6/AE51E7k6X76HHsDCwN2mS1iaOwQ/fIcT8tCLnd5308/StfEFavOVYA8fg5O91FtM8ooZty+Ejp+/AH9ABvw58yGieiJtPcmMnf5Sdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6yuEahf/A+t0d8GZJgDXHa3l9yAe4s1JOGaqWAf4G/A=;
 b=PmqgThCIgMFfOz+2dTFwvPiG9W0uc2d/iqwhNWRE1nGKW3Nak+18HcrHmbRHrEBnccbAK8/zU4LWmKC7FJFgZ0JTZRkJOkP3jzJq84fM1W1zYMsN66gN8SewQ15IPXI/Xkt7I84TS0goZjQD+dzca2lGheoKtyvtJd0ZQquUmfenu67Tp031e+GmZE+KOW3Ot1JEZEv0w78kDFmb5WnCiAX0K/8i58QxobRXfeqz1PpwOWj/XYZAt97sZYnBm8ZrFaAkymOz2lk+WnaNnQeBYPG5JgHEON9BYoIdGBQejVPtbxaYTcQKttGXP/JMWODkCkhAFJX/M2AGTEOfDVcpbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yuEahf/A+t0d8GZJgDXHa3l9yAe4s1JOGaqWAf4G/A=;
 b=ZIqxGHaNX8IY6hlU372C/xZ6xeik8Vlc34xOGtrzw0r0ErK4nygkhmrJGubSdynRw8kwM5zBfCktsoK/xK8neoHo+MrXOlLjzX+eY0jX4JviCWsAQei9bmdC+cS2NThPT5UbEDWupjU1+BOi9b9Oz7AsEfouH47Z/eScU2xiLZQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Thu, 9 Dec
 2021 23:35:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 23:35:20 +0000
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
Subject: [PATCH v2 net-next 10/11] net: dsa: tag_sja1105: split sja1105_tagger_data into private and public sections
Date:   Fri, 10 Dec 2021 01:34:46 +0200
Message-Id: <20211209233447.336331-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209233447.336331-1-vladimir.oltean@nxp.com>
References: <20211209233447.336331-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 23:35:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf141995-1c3a-4766-1831-08d9bb6c9032
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34080263C6F60AFE3C2520CFE0709@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: odL+jbfc65kOPVMjETIkODIv9Gi4Kx/F320hVCeqBU4LiT2wjtaFyTXSsOJOclMQehy9mmi0B001g7RBtiy28uZ2F1T3j9C7/ZOeqN5OxmB1nRfeqXmA4J9G4ahBYkxS06DMb8Pkubk0ykxJCfS7+cx4BC9nSMJDGf4o4ar5PxKtOTXJ9Qz2WJd1sNzZTXNWYJ20JyGIcDELyIxzC44GcjennrQdnwAgYC6g8Ljp6HnIjhJIhc9dWkeUIkKPVmnImKNWIPAxgMXAYeF3mCPuvlvYGAuW+VX6SBGVty3fYzP/t3Wkn5QHRc+F6Md8AlDuZAlGeo+WlJLzBjyRM9VvTc8I0q0EmomMRNrEp0Cg2140zqhTB/u/f8PJLb05/ZWlON6HveEPSDv8E0/R2ErxV8APlv6ONdpemVWSJSa3Yfx+bfO9OTZxgQkAebrpHi3XUeQHvvj2ejKpiMPjaMkfFfnbvXD0i2KGdo18oBAtTuskLIqGlM16EcdprdMwzD4yiTqiAnmQUKkpPdK/FAHthgDjctRZsu94VAeGuv4uwqgST8s+15u7R0N5xzTPWmAhC2XsGKRn3CXOLH64diQ9SQZSKTyosLvVt+iU7IISC7SZs69zg5aNnuR5/Le7KoIlPcCSre7dtxw0P4G2lFri7U+pWIA/HAU1feGVHAqS/xP2UqRrVSatjv2hvYtvlxtgR/359dUsDV1zuJKzfIhWLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(316002)(83380400001)(66946007)(6506007)(30864003)(66476007)(1076003)(44832011)(86362001)(6666004)(7416002)(2616005)(36756003)(956004)(38350700002)(6916009)(26005)(5660300002)(186003)(38100700002)(4326008)(8676002)(8936002)(52116002)(54906003)(66556008)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V1YM0QFxw9qfuZ18vLQCZDBDychzR+a7flOHVRGWur3iUx5WMjt75nzlvibu?=
 =?us-ascii?Q?cgVXDGzWJL5N+JTe3vIatOcsJYjeP6gMxN1QclJyjYpNKQSdziyh/0toK09E?=
 =?us-ascii?Q?D8QVJqkKrGJWFdLjY8xD+h7+v83mGPyqEBlRaAXg1qgmfcuLtvvtm0gq7kFo?=
 =?us-ascii?Q?gjSh3W9DPJy4pVeMu1ELsZUv1Nk4VS9mMwIdiz8z8Ic2Ke4RskRD8IySBj3o?=
 =?us-ascii?Q?ck6YLiOG/jTX0l9Sq51FxnWbqpecVqh8WPj+z+307myEGmksrehSuAmFk0ng?=
 =?us-ascii?Q?cF2DpEaXyUoH4l5V8NQNu159m4eQw+1jwUZMJDx4NBzOIsoumWVuaam618xE?=
 =?us-ascii?Q?UVuEZYSQ5xuAFayVQxKbmYOOfIpRPxop1YTl6yLiH8ss9Crov6YhiMFSM9Hu?=
 =?us-ascii?Q?XsDK76zzpIbEeT9QDW4gkTIg9djjynWKB4GXkiVqybVzlGyF8ffM8JwSp9lr?=
 =?us-ascii?Q?iTTVU65aMO3ecuiuUm2ycmhKzzmVTCSYB1gPxtz6O1ypde5b0G5u/jAiEeGb?=
 =?us-ascii?Q?MyCpXjXicmfGCv1axb0PyUZas2hkkq8AjoiAjidnLZFkIDCZKt57iUwIv4RA?=
 =?us-ascii?Q?2vMp37EDwEf7mA+HbVy7Zz4uEuokQmsneA8u61cV3ka2VniRh1Q32E0iQj6D?=
 =?us-ascii?Q?u5e284j5b0udmMXdErxXZZbZPwOMnPadexRaZflTP9+ti3hJVZCbBKPwx5rG?=
 =?us-ascii?Q?ltqJ1jrDIj2MLyXrsBHSicSRrH6/tgMXXdC0Bz5yPxD59iwUEkRjuugeGkV2?=
 =?us-ascii?Q?scUB3ZkkX2Qv6od/0RIWas0cWZfwBlkod6/gpi0nsrJdS14OwhMfGohJeQM1?=
 =?us-ascii?Q?3jsmOcSUd62qXpGLnY+KwGWQCpeQe4bgFZij2Lp5PztNHClNFlN7BY+4fEIq?=
 =?us-ascii?Q?MT0v+DPAQtoQSHd4IB8vgjzlJngpFbszeXJILSWS96dmk6LYVJT60QcnjfIp?=
 =?us-ascii?Q?PLXpPf6A23nOkuZF9jyYta7ojJ5/ai+AtuLpSfq1nIBr2ngktMYTlyjxMolQ?=
 =?us-ascii?Q?59PN8pRklhH0gpT23GPMuW6q0fTxoWPZJYCKjWyX/nFnzxuhi46EZXiCIQ/v?=
 =?us-ascii?Q?ZVV3BOx8WOQJagUg0Gd/0OfbyVd86dBQkP/EzQfT+3Z7YzFp9uDMyXXD0AvE?=
 =?us-ascii?Q?H9QNVCTkicNWzbmr6ROsop+0z7uqroagfyuB6jq/0G3+UzuZonEbIvJVGdVO?=
 =?us-ascii?Q?qNXOTkEoVCXgkb+IeKKr/1LH1ooYUTqStgxQIBgfVgExcD+QIc3qr3uklk15?=
 =?us-ascii?Q?iM7t81VnVRwdCleherQ0Vo/9lS6oZnpi9Mer9FY+l0IqB7fKPA4mwBrtsxGw?=
 =?us-ascii?Q?bJJ1Iqtq4wJErIq1igX7C2N1Xs3n28HVO1F54OyAnIfjXFAvwWCXNoN+WTjy?=
 =?us-ascii?Q?vgCWmkx86f5Nc1kSxwfSQfHoJ6Ni2Hv/drFMtX/7i3CiVJLgLcpSvjImGpD+?=
 =?us-ascii?Q?qf4QZny+edZF1Ag3IcAbwfNH3TQ5343X1wy957NIc60shlkiyG5eADIV43VT?=
 =?us-ascii?Q?5J4Of+C7KJJ/O/hYNnDqiYTqvabUGwZGNfa1VW3a8Bb5/BbjI+cUdzQM2q7Y?=
 =?us-ascii?Q?z+yefUKLj2TIbBT6PIYqsX97OCrtZS8n/nKrsi9/ok628w6Nq83fpNP3Be8F?=
 =?us-ascii?Q?i0HuUU9SkcUHTPh22gZAHb4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf141995-1c3a-4766-1831-08d9bb6c9032
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 23:35:20.2356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lZPgdE3qju4srUJPt792/83/n5Sp/oXEwW8Q5j2gsWGlH68BlTaUwVfkKldVM/OiDSI7XDtK2zgxfokheigdlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sja1105 driver messes with the tagging protocol's state when PTP RX
timestamping is enabled/disabled. This is fundamentally necessary
because the tagger needs to know what to do when it receives a PTP
packet. If RX timestamping is enabled, then a metadata follow-up frame
is expected, and this holds the (partial) timestamp. So the tagger plays
hide-and-seek with the network stack until it also gets the metadata
frame, and then presents a single packet, the timestamped PTP packet.
But when RX timestamping isn't enabled, there is no metadata frame
expected, so the hide-and-seek game must be turned off and the packet
must be delivered right away to the network stack.

Considering this, we create a pseudo isolation by devising two tagger
methods callable by the switch: one to get the RX timestamping state,
and one to set it. Since we can't export symbols between the tagger and
the switch driver, these methods are exposed through function pointers.

After this change, the public portion of the sja1105_tagger_data
contains only function pointers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_ptp.c |  22 ++----
 include/linux/dsa/sja1105.h           |  13 +--
 net/dsa/tag_sja1105.c                 | 109 +++++++++++++++++++-------
 3 files changed, 91 insertions(+), 53 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index a9f7e4ae0bb2..be3068a935af 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -58,11 +58,10 @@ enum sja1105_ptp_clk_mode {
 #define ptp_data_to_sja1105(d) \
 		container_of((d), struct sja1105_private, ptp_data)
 
-/* Must be called only with the tagger_data->state bit
- * SJA1105_HWTS_RX_EN cleared
+/* Must be called only while the RX timestamping state of the tagger
+ * is turned off
  */
 static int sja1105_change_rxtstamping(struct sja1105_private *priv,
-				      struct sja1105_tagger_data *tagger_data,
 				      bool on)
 {
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
@@ -74,11 +73,6 @@ static int sja1105_change_rxtstamping(struct sja1105_private *priv,
 	general_params->send_meta1 = on;
 	general_params->send_meta0 = on;
 
-	/* Initialize the meta state machine to a known state */
-	if (tagger_data->stampable_skb) {
-		kfree_skb(tagger_data->stampable_skb);
-		tagger_data->stampable_skb = NULL;
-	}
 	ptp_cancel_worker_sync(ptp_data->clock);
 	skb_queue_purge(&ptp_data->skb_txtstamp_queue);
 	skb_queue_purge(&ptp_data->skb_rxtstamp_queue);
@@ -117,17 +111,17 @@ int sja1105_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 		break;
 	}
 
-	if (rx_on != test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state)) {
-		clear_bit(SJA1105_HWTS_RX_EN, &tagger_data->state);
+	if (rx_on != tagger_data->rxtstamp_get_state(ds)) {
+		tagger_data->rxtstamp_set_state(ds, false);
 
-		rc = sja1105_change_rxtstamping(priv, tagger_data, rx_on);
+		rc = sja1105_change_rxtstamping(priv, rx_on);
 		if (rc < 0) {
 			dev_err(ds->dev,
 				"Failed to change RX timestamping: %d\n", rc);
 			return rc;
 		}
 		if (rx_on)
-			set_bit(SJA1105_HWTS_RX_EN, &tagger_data->state);
+			tagger_data->rxtstamp_set_state(ds, true);
 	}
 
 	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
@@ -146,7 +140,7 @@ int sja1105_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
 		config.tx_type = HWTSTAMP_TX_ON;
 	else
 		config.tx_type = HWTSTAMP_TX_OFF;
-	if (test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
+	if (tagger_data->rxtstamp_get_state(ds))
 		config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
 	else
 		config.rx_filter = HWTSTAMP_FILTER_NONE;
@@ -423,7 +417,7 @@ bool sja1105_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 
-	if (!test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
+	if (!tagger_data->rxtstamp_get_state(ds))
 		return false;
 
 	/* We need to read the full PTP clock to reconstruct the Rx
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index d216211b64f8..e9cb1ae6d742 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -35,8 +35,6 @@
 #define SJA1105_META_SMAC			0x222222222222ull
 #define SJA1105_META_DMAC			0x0180C200000Eull
 
-#define SJA1105_HWTS_RX_EN			0
-
 enum sja1110_meta_tstamp {
 	SJA1110_META_TSTAMP_TX = 0,
 	SJA1110_META_TSTAMP_RX = 1,
@@ -50,16 +48,13 @@ struct sja1105_deferred_xmit_work {
 
 /* Global tagger data */
 struct sja1105_tagger_data {
-	struct sk_buff *stampable_skb;
-	/* Protects concurrent access to the meta state machine
-	 * from taggers running on multiple ports on SMP systems
-	 */
-	spinlock_t meta_lock;
-	unsigned long state;
-	struct kthread_worker *xmit_worker;
+	/* Tagger to switch */
 	void (*xmit_work_fn)(struct kthread_work *work);
 	void (*meta_tstamp_handler)(struct dsa_switch *ds, int port, u8 ts_id,
 				    enum sja1110_meta_tstamp dir, u64 tstamp);
+	/* Switch to tagger */
+	bool (*rxtstamp_get_state)(struct dsa_switch *ds);
+	void (*rxtstamp_set_state)(struct dsa_switch *ds, bool on);
 };
 
 struct sja1105_skb_cb {
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index fe6a6d95bb26..93d2484b2480 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -53,6 +53,25 @@
 #define SJA1110_TX_TRAILER_LEN			4
 #define SJA1110_MAX_PADDING_LEN			15
 
+#define SJA1105_HWTS_RX_EN			0
+
+struct sja1105_tagger_private {
+	struct sja1105_tagger_data data; /* Must be first */
+	unsigned long state;
+	/* Protects concurrent access to the meta state machine
+	 * from taggers running on multiple ports on SMP systems
+	 */
+	spinlock_t meta_lock;
+	struct sk_buff *stampable_skb;
+	struct kthread_worker *xmit_worker;
+};
+
+static struct sja1105_tagger_private *
+sja1105_tagger_private(struct dsa_switch *ds)
+{
+	return ds->tagger_data;
+}
+
 /* Similar to is_link_local_ether_addr(hdr->h_dest) but also covers PTP */
 static inline bool sja1105_is_link_local(const struct sk_buff *skb)
 {
@@ -120,12 +139,13 @@ static struct sk_buff *sja1105_defer_xmit(struct dsa_port *dp,
 					  struct sk_buff *skb)
 {
 	struct sja1105_tagger_data *tagger_data = sja1105_tagger_data(dp->ds);
+	struct sja1105_tagger_private *priv = sja1105_tagger_private(dp->ds);
 	void (*xmit_work_fn)(struct kthread_work *work);
 	struct sja1105_deferred_xmit_work *xmit_work;
 	struct kthread_worker *xmit_worker;
 
 	xmit_work_fn = tagger_data->xmit_work_fn;
-	xmit_worker = tagger_data->xmit_worker;
+	xmit_worker = priv->xmit_worker;
 
 	if (!xmit_work_fn || !xmit_worker)
 		return NULL;
@@ -362,32 +382,32 @@ static struct sk_buff
 	 */
 	if (is_link_local) {
 		struct dsa_port *dp = dsa_slave_to_port(skb->dev);
-		struct sja1105_tagger_data *tagger_data;
+		struct sja1105_tagger_private *priv;
 		struct dsa_switch *ds = dp->ds;
 
-		tagger_data = sja1105_tagger_data(ds);
+		priv = sja1105_tagger_private(ds);
 
-		if (!test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
+		if (!test_bit(SJA1105_HWTS_RX_EN, &priv->state))
 			/* Do normal processing. */
 			return skb;
 
-		spin_lock(&tagger_data->meta_lock);
+		spin_lock(&priv->meta_lock);
 		/* Was this a link-local frame instead of the meta
 		 * that we were expecting?
 		 */
-		if (tagger_data->stampable_skb) {
+		if (priv->stampable_skb) {
 			dev_err_ratelimited(ds->dev,
 					    "Expected meta frame, is %12llx "
 					    "in the DSA master multicast filter?\n",
 					    SJA1105_META_DMAC);
-			kfree_skb(tagger_data->stampable_skb);
+			kfree_skb(priv->stampable_skb);
 		}
 
 		/* Hold a reference to avoid dsa_switch_rcv
 		 * from freeing the skb.
 		 */
-		tagger_data->stampable_skb = skb_get(skb);
-		spin_unlock(&tagger_data->meta_lock);
+		priv->stampable_skb = skb_get(skb);
+		spin_unlock(&priv->meta_lock);
 
 		/* Tell DSA we got nothing */
 		return NULL;
@@ -400,22 +420,22 @@ static struct sk_buff
 	 */
 	} else if (is_meta) {
 		struct dsa_port *dp = dsa_slave_to_port(skb->dev);
-		struct sja1105_tagger_data *tagger_data;
+		struct sja1105_tagger_private *priv;
 		struct dsa_switch *ds = dp->ds;
 		struct sk_buff *stampable_skb;
 
-		tagger_data = sja1105_tagger_data(ds);
+		priv = sja1105_tagger_private(ds);
 
 		/* Drop the meta frame if we're not in the right state
 		 * to process it.
 		 */
-		if (!test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
+		if (!test_bit(SJA1105_HWTS_RX_EN, &priv->state))
 			return NULL;
 
-		spin_lock(&tagger_data->meta_lock);
+		spin_lock(&priv->meta_lock);
 
-		stampable_skb = tagger_data->stampable_skb;
-		tagger_data->stampable_skb = NULL;
+		stampable_skb = priv->stampable_skb;
+		priv->stampable_skb = NULL;
 
 		/* Was this a meta frame instead of the link-local
 		 * that we were expecting?
@@ -423,14 +443,14 @@ static struct sk_buff
 		if (!stampable_skb) {
 			dev_err_ratelimited(ds->dev,
 					    "Unexpected meta frame\n");
-			spin_unlock(&tagger_data->meta_lock);
+			spin_unlock(&priv->meta_lock);
 			return NULL;
 		}
 
 		if (stampable_skb->dev != skb->dev) {
 			dev_err_ratelimited(ds->dev,
 					    "Meta frame on wrong port\n");
-			spin_unlock(&tagger_data->meta_lock);
+			spin_unlock(&priv->meta_lock);
 			return NULL;
 		}
 
@@ -441,12 +461,36 @@ static struct sk_buff
 		skb = stampable_skb;
 		sja1105_transfer_meta(skb, meta);
 
-		spin_unlock(&tagger_data->meta_lock);
+		spin_unlock(&priv->meta_lock);
 	}
 
 	return skb;
 }
 
+static bool sja1105_rxtstamp_get_state(struct dsa_switch *ds)
+{
+	struct sja1105_tagger_private *priv = sja1105_tagger_private(ds);
+
+	return test_bit(SJA1105_HWTS_RX_EN, &priv->state);
+}
+
+static void sja1105_rxtstamp_set_state(struct dsa_switch *ds, bool on)
+{
+	struct sja1105_tagger_private *priv = sja1105_tagger_private(ds);
+
+	if (on)
+		set_bit(SJA1105_HWTS_RX_EN, &priv->state);
+	else
+		clear_bit(SJA1105_HWTS_RX_EN, &priv->state);
+
+	/* Initialize the meta state machine to a known state */
+	if (!priv->stampable_skb)
+		return;
+
+	kfree_skb(priv->stampable_skb);
+	priv->stampable_skb = NULL;
+}
+
 static bool sja1105_skb_has_tag_8021q(const struct sk_buff *skb)
 {
 	u16 tpid = ntohs(eth_hdr(skb)->h_proto);
@@ -699,26 +743,27 @@ static void sja1110_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 
 static void sja1105_disconnect(struct dsa_switch_tree *dst)
 {
-	struct sja1105_tagger_data *tagger_data;
+	struct sja1105_tagger_private *priv;
 	struct dsa_port *dp;
 
 	list_for_each_entry(dp, &dst->ports, list) {
-		tagger_data = dp->ds->tagger_data;
+		priv = dp->ds->tagger_data;
 
-		if (!tagger_data)
+		if (!priv)
 			continue;
 
-		if (tagger_data->xmit_worker)
-			kthread_destroy_worker(tagger_data->xmit_worker);
+		if (priv->xmit_worker)
+			kthread_destroy_worker(priv->xmit_worker);
 
-		kfree(tagger_data);
-		dp->ds->tagger_data = NULL;
+		kfree(priv);
+		dp->ds->priv = NULL;
 	}
 }
 
 static int sja1105_connect(struct dsa_switch_tree *dst)
 {
 	struct sja1105_tagger_data *tagger_data;
+	struct sja1105_tagger_private *priv;
 	struct kthread_worker *xmit_worker;
 	struct dsa_port *dp;
 	int err;
@@ -727,13 +772,13 @@ static int sja1105_connect(struct dsa_switch_tree *dst)
 		if (dp->ds->tagger_data)
 			continue;
 
-		tagger_data = kzalloc(sizeof(*tagger_data), GFP_KERNEL);
-		if (!tagger_data) {
+		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+		if (!priv) {
 			err = -ENOMEM;
 			goto out;
 		}
 
-		spin_lock_init(&tagger_data->meta_lock);
+		spin_lock_init(&priv->meta_lock);
 
 		xmit_worker = kthread_create_worker(0, "dsa%d:%d_xmit",
 						    dst->index, dp->ds->index);
@@ -742,8 +787,12 @@ static int sja1105_connect(struct dsa_switch_tree *dst)
 			goto out;
 		}
 
-		tagger_data->xmit_worker = xmit_worker;
-		dp->ds->tagger_data = tagger_data;
+		priv->xmit_worker = xmit_worker;
+		/* Export functions for switch driver use */
+		tagger_data = &priv->data;
+		tagger_data->rxtstamp_get_state = sja1105_rxtstamp_get_state;
+		tagger_data->rxtstamp_set_state = sja1105_rxtstamp_set_state;
+		dp->ds->tagger_data = priv;
 	}
 
 	return 0;
-- 
2.25.1

