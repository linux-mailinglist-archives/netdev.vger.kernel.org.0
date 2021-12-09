Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B6D46F787
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 00:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbhLIXjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 18:39:05 -0500
Received: from mail-am6eur05on2077.outbound.protection.outlook.com ([40.107.22.77]:21854
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234476AbhLIXi7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 18:38:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EEetmNrs2zFFPlQFvK2nu1rWTyTfnh/Lrq1kfhGPIxLkKSIczm3y8wUDqJN9z0jpBedINC+d29PXKvT9b/TPXd0e0KhhQWAZ27ua0tcR8r8tMTnL3gRAwIrXRL3ZOB0wPNZ1us8c9mt5B0vcRoiBp65NvDaoNjovk0ONV4YaxFusUQYJvR7Kxk5uYL3wlWNOdyRgmNArNjONoKbpG7oCFkxGU6rLJ91ur45PAJD4x0jP1HVvcQJluZW52HLdTjKUITnD0IwWVnQbgk4iNRh3zZ6vMhearpe01C2byP1LNRue/3McjHM/waAUaOa3JsTMXpa+40EA9xQ+te1jZJxECQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BsRhTtpUUBTvgfhe6TlIuFXXSQwdDrVaXzoEQFkil9s=;
 b=ihfvRzb6CheagkD3LwnlDVUWk+aUrcJvhQFivxtWg6M6KFkAetS5ZmvzAG65aPisFIseZO/jnJ75W3k3LKrLj9ZXjDNhQCHj4C2e9n1MXYi0cA/fJpzKC5XACrytk/xq6YSEJaAZDbgNItfRMJd52u8Jo4co0AkCq2lnsUnvMOxi96dXP0dpQlcQ/4kHoqe2rkIUEF6GNGjK/Bd3wHZEd/tUDY31eV8c3Dq0oHNq1hKoCABTfGEYas+lQpIBaPq6xtg8SgKhROEYTwEDWOCkCDTA5Xil726rp968+Pml184/Fu/WKfJ575CLVzGJNgYrUUDYBJ4XmXHlwCpg/5KMZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BsRhTtpUUBTvgfhe6TlIuFXXSQwdDrVaXzoEQFkil9s=;
 b=ihTBTSUE5S5pq0LMOAIVPsb59sdzFSiI5BwO+pZfiTvkfvaEWs0vOeuqqmJ5WNFu19ZSSN6kp9OdHGPzy/uNIMA+/FWRcPmbsYbJ8YoWisU7iIykgP5YtdFPYcEKntQy8Oah02V/ScEyuJhFwnhtl3lTphw5E9qoUerdfMbA1Mw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Thu, 9 Dec
 2021 23:35:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 23:35:19 +0000
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
Subject: [PATCH v2 net-next 09/11] Revert "net: dsa: move sja1110_process_meta_tstamp inside the tagging protocol driver"
Date:   Fri, 10 Dec 2021 01:34:45 +0200
Message-Id: <20211209233447.336331-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209233447.336331-1-vladimir.oltean@nxp.com>
References: <20211209233447.336331-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 23:35:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f94e3eb5-4130-41b5-8671-08d9bb6c8f7a
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34085DFF6B258F127D29E7E9E0709@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:663;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hKHVRKf31V6ZKt91fiyAGGFBwZBKYdaj4P6iOqre7rKJPLVZBEQcMZyiy3V26Z5LCRBkNkksCT0GBmlrljRpd7lJ3N31mFnpr1mR/w90q9i5/15WkN4rRsnNrKFY7AeX48uydmtKw0FObld/Q3JzuGMzOHDcCHqW5ScpPLIM7DMSEuc+BRc5QP1f1mJerjxwwuR+mMSyKtMFRpNbnHSCcIsGrJxW4ErkNMk1BkHpvuZ/BhrC9JB8jrvpSG/s+nL2M5Dg5cj+SL0NzmvUjOmLwKAYLqi5kPs/5p7JXszuyQy/1kDKAmmYy26vzhbmv5YOfbnC8rEeGolILWRCWOgocngckdTJD6IdEDvFae+4sTOYQrI1XqXgr7ghgQsZiGtx5Mclys1tWRlLqPPcX3gAgJxc2F2xQIY5DgGfeYXvG+VxC1F2ziw2nXCcRoOU56qdrNtziITvrQPEl8P4NXqgqUuvge1CjxK4vE5v0MB178aWXC4WvI4QWnzP5/x96MC5ELKAFakMPCG5gMGT80sTaQGsMS4Ry6PmLen5mXkirvub/EI6dE8I8BgNHzBrziDNU7vZtqBqQqU2sklOknl6ZAEsLTVfTNpaB357g+XT8HP3XgKLX4aqwuIdn8Tp44HP51lsb5UN0ZVueKxd+idxbs5BoDDb2H9ZZ7Fbl+dYNR51r63Fu4wRTBAB2Kci2mPtlYrTb862+lbUjnoi5L7m7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(316002)(83380400001)(66946007)(6506007)(30864003)(66476007)(1076003)(44832011)(86362001)(6666004)(7416002)(2616005)(36756003)(956004)(38350700002)(6916009)(26005)(5660300002)(186003)(38100700002)(4326008)(8676002)(8936002)(52116002)(54906003)(66556008)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/lhohK6kjm58YBP1B6q+wE4ZgRPqHl6Rna/Ewv02KS09rBsSz0rkPdupK2jQ?=
 =?us-ascii?Q?lPwcqR3HuKP9YfDnKRgh8TNoJ1u5qhrQO+ORAwE99Jl/lFnnMlljC7oPYA0x?=
 =?us-ascii?Q?jwpb/7pqcPoiaa5CxCVuJxiISHcbZoifXRy2KumV8u1oxQTnpyJJ8C7/8f5U?=
 =?us-ascii?Q?Rsgkj4u0W7Ksb19Kmm9lz6wcPxE5EAXA50T7UvMnSOm3nZL3Oy3XaqLDgIBC?=
 =?us-ascii?Q?zE7JVWsXGB2q233kuLxOttRHNAUREM8xoK0MnbE89RUNAHLwGnTQjSGt7irO?=
 =?us-ascii?Q?BUsUo8vjzp/wdnGHb7TTPBj1BGQXztMeL018JfZBYE8qD7qH8/7xyPw43bH3?=
 =?us-ascii?Q?//XDrjP+X9rOmuc7mQMYQsFC11J7LAuaFjFBP0lKZHQMZABE21urhKrIYSfE?=
 =?us-ascii?Q?D+ryblXFkjmmRwcDo5ibW9WIQ/TaOy7UIo/0e9q2r/8cdoipRDtr61Am0A0J?=
 =?us-ascii?Q?ULFKc9QGcdI0ySg6EB4bxe44Jg8O6nZe+caUqCNpUsOMD7QQimAa4xoT6Vys?=
 =?us-ascii?Q?RWIL9KGp2ztEgTJZfqTJBPx6JyoL7OvkAirbHsZyNVLaX8u5uwc1H1eFBZlH?=
 =?us-ascii?Q?caUu4JGxKV4Y1HGQN4rr9AtRmoT/QwEgnqXssblYy6hxaWXBTk4S9y6+rZI8?=
 =?us-ascii?Q?HBSgGVKKxgb2dUJgwLpKBRntgSZvRM6d9czt+wcLLOmmaPTDw32Pyz0mGYM4?=
 =?us-ascii?Q?golmLG7DBzqhHj/O8jiBbjxSEDm5EhCuj6ZC6gL+hGOirMMZr99M61d9Caqd?=
 =?us-ascii?Q?jNhAnIFaWxCYVcqXBpwVOz6hamA29ub8L7yPcRZAkHf+CCFc9ValMdENVsDk?=
 =?us-ascii?Q?ltxql3PI0bn6NT0X7tFmTCXuVgS3cI23YXeMI5ykkthOod+N7sfk9R82kikD?=
 =?us-ascii?Q?A9zUGfxkTXKT6yT+ccwSxJLHNtVnDW1i7iZnMgO0xMxPh/1+9NDvarrzJGmy?=
 =?us-ascii?Q?7wAkqByOEYQpma2qY6AvvGsIeHQdjp9Z7G5+XhFTjS6X3xLZ0nUrqaoeFMkr?=
 =?us-ascii?Q?fOAReDXL3cSz7nFeRysndqyaepmfYEJDMJTDcsvgqI4viXmX/KKskMBv0XOu?=
 =?us-ascii?Q?C6jjUslNMufh7P0BNscyVD+Nen2ApY9t9JzTu5InI/RrJLqhShhvBAnfaNS/?=
 =?us-ascii?Q?547zt+FJDgVMvjcIEow77dEbBxt3NjKA+NhYdgw92ZWjKqPIk2yZRLgKqIo3?=
 =?us-ascii?Q?1cwb7rdMwzWoikVcuGSI7Otj3DfXCV3vdWQpf91Sf7dA5Ir6XX2JHCntX5db?=
 =?us-ascii?Q?R7JT4YL4T6bgyWtW4DkK8TQdVx8RwWhYxr6zlpd4QHZvranoEnWoaTxDxAZG?=
 =?us-ascii?Q?+GUkQ0f5Tf4XRKZ8K/adEsZ3Dyeq9dy6DPLTPWphjfIeVEZe8bl0crkF7vqR?=
 =?us-ascii?Q?e1uL2/K1c0tMKAIqrYkQqnyGeJUx12VWCaCXIGD6fqiv7nOxSrb0s+fG8JPs?=
 =?us-ascii?Q?Kq/9AvLAMEZYbbxOT6jcEA4TBnAgqDoYVjeQfPPLoDeqqYbcTrp1F1RMhwJC?=
 =?us-ascii?Q?QZzqtsv5PlQEX4/lCPvlVtbtLZX9sDCQU2t1u1egBrZr6tQeod8nuspNFdXY?=
 =?us-ascii?Q?uoKuf/J8c2+ttsOmfbUn0JsauqiqS8Yd9iI09gz1TvKLz8s5Jhi4AqhSqPtm?=
 =?us-ascii?Q?MF+ZMClm5zreECzJHr9K6ow=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f94e3eb5-4130-41b5-8671-08d9bb6c8f7a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 23:35:18.9544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DeaIKaTk1JxB1XTQdDIgzQT5aR4t4HAaiKu7WkycSTxEXcSTJXox/8LMmOtUQfE5TLSxoLiIwF3DXKpVzDP8pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
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

