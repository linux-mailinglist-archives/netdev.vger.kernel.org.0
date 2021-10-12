Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A98942A37E
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbhJLLnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:43:20 -0400
Received: from mail-vi1eur05on2048.outbound.protection.outlook.com ([40.107.21.48]:6177
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236259AbhJLLnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 07:43:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNKaa5FljDLmt/If0A6lOEoCTyBx3Jm/eBdkq16ds1TEBJGCgY8lvToMNwE/B0Fsi3UvNz+HzpNufyOK6eIeqMoL+IMSEpBr9Rj+HH2q9i7mvXJ9qTI4YSGoHiGCBcsJM3PQ+tRchfnNWLKJiiz9FhQqHSVLUHFlvvK/+XLRJLceHn3v0l4Wirmd12COH+Zc3g8BXaRem0VVjAmHUVJJOydilt42fttnYr5pdqZ9d65v2CDc84DI41VZ4MhFzJ2g0Q8K8mp/dhrIdULzmQgWZIcdSq58VI02+zf2Y17StxqUaZ8MfQLkglBxm5OUYIDF2AUMMtMlifDdAboHOYA9CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JuQ4yHkDisvr5rqpDeR5VSdzJg5OTUM34r2Sm1LptIs=;
 b=hnsELwGUYzgj7+FhZQ11XJoNVwTayvQgjxSosAySraTvQvmRtHNXlvXQ0N2cEJqcvmZaHM0G46rzKNVxJLlnTYl7318LbPaGEe/i6wO7MVfF5zlz/G3BF8wRZfBbvdlNmZJrrLnyjgw6rMhZT6cHb95fw2BaUqHLkWmNLSenEdrP4pqIrljXBpJwkPz16WyWMj0ivmRjOBDB6cd+HcR7wKIkShzkiZg4P8PMWHYOg0sLF94FP9UtuzbRIYDMFdnDcuG+2bMR5LipiwAlIIcp3BeFxzu4xELMnsOcYhStV2GgLAv28DUPPjl69riPQZGZJ6eaOgqcXS35sDiYtzNRUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JuQ4yHkDisvr5rqpDeR5VSdzJg5OTUM34r2Sm1LptIs=;
 b=ZNpPZ7XE3SafauSaKw8RRc710KzMR/Zp7UIMXn/RDaihAsbEkVIY8MJ+njutdHvJhUvpCbcnq16rJ17xE86NUQQo/cBdpVVPFXnkzJ+Khc5LoWO6tLJ6N8UpyUxMYgCnXRWWWH/rx/6mhxikM7fUCuQsnqVwUPsD4qPZkN8oruE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3709.eurprd04.prod.outlook.com (2603:10a6:803:1e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 11:41:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 11:41:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net 05/10] net: mscc: ocelot: cross-check the sequence id from the timestamp FIFO with the skb PTP header
Date:   Tue, 12 Oct 2021 14:40:39 +0300
Message-Id: <20211012114044.2526146-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
References: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0150.eurprd07.prod.outlook.com
 (2603:10a6:802:16::37) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0150.eurprd07.prod.outlook.com (2603:10a6:802:16::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Tue, 12 Oct 2021 11:40:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eaa9678b-de21-41dc-51b1-08d98d75297b
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3709C9693F093435D0631B1FE0B69@VI1PR0402MB3709.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7nwPWd44XCBuQZxBy3EKUpbZ2eus11gz4Op68DEoYDEFw3OJ2zLlKb724ubBGWDE87UNe5rUBLdxgiKqqDfOJuW32eI90UH8d5dtS7Nm3wE5GYrPSEIYgYljNQiN8+ZnZhH2qfQhmeoW0EVvWvgtpAUWaaiOYVFWW59S9PPtz1oM0Oth21Yw430iy2vtmKvIpaiRuuYPNY4TiGGNJ6YYcGUzJVfpbnF2S13VjzzYXIgkuiKKyS/hxK6Ge8uwQ9TeBsV5XLAox3nV0hxcp36aFZ+HEoLpSN4mK+1FdqqxoXF/w9KKS9elju6/s19ssFH0VIJd8l6BbdkTj4thOqQrT/fK4149MhxCgEmnVGWhXAhXHQGOcC3542dFYFYLXVDT8gGHCIl3RNzW7gUXXNPV0hwzI9k+Iyzy+W5vRlY97Md2mSRM6X39RukDqbPkXEw0AwVhDtetBUMQfZKdBDNNTKnS2wM5qCf7jcHrq9r589M9C1ySDhQ5TDuUy2Yh7xww+oxaqsybSZNA8wE50NJ/8fJJ0SCov9x/4znR6T/0OpQWHw50guLr2Jb+Arp/JG3FE9+ejZ7UAvg5XI3fpKMJOvOjL10UBGrvSmj+4E1GY8NpRpU2zVTXBenRCLj6QCd9zi70zIq1Y7S2LomFVZHaIK0UqQ4jcspxg34N5iIXH1DOV71saXNfhm4WHeqSBXS+CWjMnfKLb7Igttx/j2lFUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(2906002)(83380400001)(2616005)(44832011)(38350700002)(38100700002)(956004)(508600001)(52116002)(4326008)(6486002)(6506007)(66946007)(36756003)(6512007)(1076003)(186003)(26005)(8936002)(8676002)(54906003)(110136005)(6636002)(5660300002)(6666004)(66556008)(66476007)(316002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0+sXsQuixSAu+hX655nIvb0//rj5kvcJpLIRW00OWWxeQNDaPySdtyaDelzo?=
 =?us-ascii?Q?FhsVW+hyDf8Gsa9tWL9NlDPzQ1+Y6gqzXfR6wfbIWIJGnw1IuT8q6vsd0ebJ?=
 =?us-ascii?Q?25ITAIZisGPSvyiiTTpy9Zz+QvFnaolqprhCJN4d7f1pkNw4KrFYw0kXFteJ?=
 =?us-ascii?Q?HvVGHpaGbbI4ooMHQoC9YIpgkWlSwVJudKYXnHNVKVmlpKprZBMIrmxKZiz7?=
 =?us-ascii?Q?/Xv1fhWe0gkJFIXbOQrYhnZOEbaf9S10Xf6dyf0QNC1xb7T0ujiGZJEpJ/Db?=
 =?us-ascii?Q?M9aEOfiFzM9ZdjY7SYVVteYBuVSOp5qaI2GCdgl2La9rU7VbrlAn/PTksaRI?=
 =?us-ascii?Q?FDk9HaMvmrOFBlr+sDYqYwtsLNB1xvi4xTX/QZuTzVcSDCH43p1iTH9f83uh?=
 =?us-ascii?Q?dtgJzqUGHVTPiP5IKeYz1R4N39f+THNRwCaGVSPTNWju3AA1lcwXMXsnyOK9?=
 =?us-ascii?Q?PscGwelQkVQTWHVKEx/NbHayzoinu9DI7oxjhhsoQnpJ+JRKoTXWgQbLes7F?=
 =?us-ascii?Q?Gf8/clf+vgRfjZBVLZGhTs6jPx5g7UVW6LixfEq9FlCweVSr07s8/Tgo4y5w?=
 =?us-ascii?Q?zoY5Xko8Ugzkj8/n4HyXoA+fbMhbputnJHzrQR9toYQFgkhAF95+0c+jF6SP?=
 =?us-ascii?Q?bw8xivT1aXFuMKAFWrQizcgTxsHJz4j2snoNLinwE6iTVQdIGykCFbNMOjse?=
 =?us-ascii?Q?hpihh/SKWaNB9udG+ZSf1kYqv7jx5+ZDNXF63K+UlojpWa7u2NMokGgejahH?=
 =?us-ascii?Q?c5NtQEobENE/6WmSJtHQ5YKNGlkUXFJ6I5qVwOQ2MfR4gKNApmGNqUJGxRca?=
 =?us-ascii?Q?Z2S1SmnMKo/3qTC9r+ota8NPdXchBl2C4F1QiLvUbyf7vLRvjrti4eY22k7Y?=
 =?us-ascii?Q?gifKOeAuX0urVZngDbE/pQlQfMIEZ3MGRLML9YyeSYcc50B+r2rGjjXPy+Ii?=
 =?us-ascii?Q?icqYvgkg2OojiiqrvujRYz0WRfY+tFx9VwOoT2dgZPjZtCSBZSlSC1kVrpHc?=
 =?us-ascii?Q?O2Ppf08Fz5XFHxU9MHR6Bygdwe76G1Y5gRVWaxFQpCHvbzz4/oNRDbxGjhW9?=
 =?us-ascii?Q?SyD6PPHVbazdEE/npEknejc9z2FC5ymtKhyQe7D5A5jKhxDaSo8B/wvj8vwv?=
 =?us-ascii?Q?ngzVjhtD2SB27n5yn1m+HBmyoRXdHjmwzzOOCmLJH/1/3kGcESxHaKb4x/Gy?=
 =?us-ascii?Q?OAViV23LoWw/snlQpLZH0USQ23jZPjNXZ0FJAq4akuN1vNhu2NJHaYFV7CVg?=
 =?us-ascii?Q?SKaVUYOQt5SaNqMCot6M0BtCvX8K24NxHqI3gLpfA8UxRSMZw6SLcJNzs5gt?=
 =?us-ascii?Q?yAH4wqOqU4lFk4rjkGgJ7K9D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaa9678b-de21-41dc-51b1-08d98d75297b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 11:40:59.8822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p6yzbdlU6yO7htRlqZMvjRn7J3HXqAnI6EAgp5Yk9ZFET92Cdwv91zNyeAZ1mDYH9mpHSDS1Ipst9LC97N37OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sad reality is that when a PTP frame with a TX timestamping request
is transmitted, it isn't guaranteed that it will make it all the way to
the wire (due to congestion inside the switch), and that a timestamp
will be taken by the hardware and placed in the timestamp FIFO where an
IRQ will be raised for it.

The implication is that if enough PTP frames are silently dropped by the
hardware such that the timestamp ID has rolled over, it is possible to
match a timestamp to an old skb.

Furthermore, nobody will match on the real skb corresponding to this
timestamp, since we stupidly matched on a previous one that was stale in
the queue, and stopped there.

So PTP timestamping will be broken and there will be no way to recover.

It looks like the hardware parses the sequenceID from the PTP header,
and also provides that metadata for each timestamp. The driver currently
ignores this, but it shouldn't.

As an extra resiliency measure, do the following:

- check whether the PTP sequenceID also matches between the skb and the
  timestamp, treat the skb as stale otherwise and free it

- if we see a stale skb, don't stop there and try to match an skb one
  more time, chances are there's one more skb in the queue with the same
  timestamp ID, otherwise we wouldn't have ever found the stale one (it
  is by timestamp ID that we matched it).

While this does not prevent PTP packet drops, it at least prevents
the catastrophic consequences of incorrect timestamp matching.

Since we already call ptp_classify_raw in the TX path, save the result
in the skb->cb of the clone, and just use that result in the interrupt
code path.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/mscc/ocelot.c | 24 +++++++++++++++++++++++-
 include/soc/mscc/ocelot.h          |  1 +
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b6167c0a131d..48c02692380c 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -675,6 +675,7 @@ int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
 			return err;
 
 		OCELOT_SKB_CB(skb)->ptp_cmd = ptp_cmd;
+		OCELOT_SKB_CB(*clone)->ptp_class = ptp_class;
 	}
 
 	return 0;
@@ -708,6 +709,17 @@ static void ocelot_get_hwtimestamp(struct ocelot *ocelot,
 	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
 }
 
+static bool ocelot_validate_ptp_skb(struct sk_buff *clone, u16 seqid)
+{
+	struct ptp_header *hdr;
+
+	hdr = ptp_parse_header(clone, OCELOT_SKB_CB(clone)->ptp_class);
+	if (WARN_ON(!hdr))
+		return false;
+
+	return seqid == ntohs(hdr->sequence_id);
+}
+
 void ocelot_get_txtstamp(struct ocelot *ocelot)
 {
 	int budget = OCELOT_PTP_QUEUE_SZ;
@@ -715,10 +727,10 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 	while (budget--) {
 		struct sk_buff *skb, *skb_tmp, *skb_match = NULL;
 		struct skb_shared_hwtstamps shhwtstamps;
+		u32 val, id, seqid, txport;
 		struct ocelot_port *port;
 		struct timespec64 ts;
 		unsigned long flags;
-		u32 val, id, txport;
 
 		val = ocelot_read(ocelot, SYS_PTP_STATUS);
 
@@ -731,6 +743,7 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 		/* Retrieve the ts ID and Tx port */
 		id = SYS_PTP_STATUS_PTP_MESS_ID_X(val);
 		txport = SYS_PTP_STATUS_PTP_MESS_TXPORT_X(val);
+		seqid = SYS_PTP_STATUS_PTP_MESS_SEQ_ID(val);
 
 		port = ocelot->ports[txport];
 
@@ -740,6 +753,7 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 		spin_unlock(&ocelot->ts_id_lock);
 
 		/* Retrieve its associated skb */
+try_again:
 		spin_lock_irqsave(&port->tx_skbs.lock, flags);
 
 		skb_queue_walk_safe(&port->tx_skbs, skb, skb_tmp) {
@@ -755,6 +769,14 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 		if (WARN_ON(!skb_match))
 			continue;
 
+		if (!ocelot_validate_ptp_skb(skb_match, seqid)) {
+			dev_err_ratelimited(ocelot->dev,
+					    "port %d received stale TX timestamp for seqid %d, discarding\n",
+					    txport, seqid);
+			dev_kfree_skb_any(skb);
+			goto try_again;
+		}
+
 		/* Get the h/w timestamp */
 		ocelot_get_hwtimestamp(ocelot, &ts);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index b0ece85d9a76..cabacef8731c 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -697,6 +697,7 @@ struct ocelot_policer {
 
 struct ocelot_skb_cb {
 	struct sk_buff *clone;
+	unsigned int ptp_class; /* valid only for clones */
 	u8 ptp_cmd;
 	u8 ts_id;
 };
-- 
2.25.1

