Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605504298DB
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 23:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbhJKV2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 17:28:47 -0400
Received: from mail-eopbgr40088.outbound.protection.outlook.com ([40.107.4.88]:16861
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235285AbhJKV2l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 17:28:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6Ek+eY/+pDYLcZ7iW6ENyebJpZCwSq9PCLIuDvj0CnVoZG9vmXEt42qxA5YDmvekgj2wkyMXF+ofdHlHD8LFuUxDmaJUJBZfGPepQZu44PdBQV9n30gJjmqL17Ojy/Jjj2AstUFvvDgHW36X8SMuGlqE5x2kCjGxXgcaAc+lkDFCL9xTf93RsE8M1qqV7oLaLAuAXPMK3YwHHuiyoraOAYX7UfX2acBqas3AH/1D9Fkxrx5KMifflqy3zCDy5bz804N8bLmSsFnAjMlxnYihR3Vtp7Ut0RyxJlIEltmKXTiVr2Bcp9gf8sCt1H8Pu3z6mV7+PB2GXJVpa6fULydhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7iFFJssByNiJoCL4AG6MtOS5jNCDnRV/oVZlxBV4LnQ=;
 b=fyW4E+0mjmsIUjsHq42Y77fkHn/R59f/mn3kP7rsVSJDaK7VXfLRzvrj58qWhc+7y6bV/uA1KjUbKEdEMpZ2Z/wMpHplzLpMKOUbNZF2P6YOUfa6tVfL5CWrkIgsLOHhelSD1x/Xbli+fRjj6tXS8RT95XJkagJ7q8XkQ5tDpOnHM/hZZPLkWodZwplXEgy+HqlNvhPTkQGBzrl/zUI1IYKt8qak+yW6AZS7vKVwhscL/3uks9gFpUhg+FSb62vreztQCT01EUngCubPOX0rHsqBxrPSZ+WNmZrMgzbwtcx7V9A6tpsy7dmNLMn2LaTYH0Fgmo7okWQFODEexp9Duw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7iFFJssByNiJoCL4AG6MtOS5jNCDnRV/oVZlxBV4LnQ=;
 b=mixooY5MUf4fGYN+m2z/D+LuOzG4LfrIODvKIwz3ZTUI7KjIYJcHU1066VcwKC3WxPSpDvQXiB6A7NzH4ya/e179CNGZ2oqzNEW74NBc+x5KZI6R32QPwaOdv2TYQLCm3x3yFIUv5zghhvkmV3CqNa4E6agY/CcXYQv/w1l78og=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (20.177.49.83) by
 VE1PR04MB6703.eurprd04.prod.outlook.com (10.255.118.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Mon, 11 Oct 2021 21:26:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 21:26:36 +0000
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
Subject: [PATCH net 05/10] net: mscc: ocelot: cross-check the sequence id from the timestamp FIFO with the skb PTP header
Date:   Tue, 12 Oct 2021 00:26:11 +0300
Message-Id: <20211011212616.2160588-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
References: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0260.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0260.eurprd07.prod.outlook.com (2603:10a6:803:b4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Mon, 11 Oct 2021 21:26:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 088d62b7-25c3-400a-70f3-08d98cfdcdf9
X-MS-TrafficTypeDiagnostic: VE1PR04MB6703:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB670310D9DEDBEAD6F9603730E0B59@VE1PR04MB6703.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cgf8BWYle44i8ZJlMMBriMXN3sOYtPF/3EAHA322ZPBmvZuDwfiDDPiQWvdEtw1Z5ikS56ExxsRzQpErEGwBRZYo+DdvMK72BRix9/WY7+T39BxTL+6el1582AEKyCLWqQPAyv5/0X/oQDMyEFfvRCS2rsHBP/iHQVYa2fd1LMv8KfQDoIXM2T2f3kSo2QnxMm6SfhrHjnWGmWg8nkKYTcUyVs0z/viw2bSzDmmP4OVcViuuZh4hEgpHxiEwmOHzvH94n6ZJnHc8PxtIKOXEQMXiWlzuGS5AsVzh4Gu2utnj6+DkYCiBRXXynfVCyIvb+Bf57huZ/ylAmFf7c15Lq2M2W6mJXGZnNJWxpvtGktFpUOhhOMb8xO+YJGcokDl+YlRj+glkbLcGlpPbEXIunXb+qvliZsj9svI8YRczgVui/AVMyeMhHAdv0aG918naNh7E7ouP0GoLfg62G/NOUmf4b4D9SNK1vmmTBgW+0JdQaRYftjKvTEOQGDYmEml/Lj75ZYrcoRKNrpUN7+oEWtbml5xan7CvnOTfozHaSflR6q7Qvs3/F3SY0+Q3dspX6J24J2YkGPYUJVxcjz2txTynlI3AQkgurBnlcll8iGEMKKQNX/K3xRh+2U/jfFLLEmmznLgGKwVWh/Nrts66VVfvFzmB2ac3DnrG4/USNpmSYz5iYZDZli3J+rWtNHFCS3/2r58WW9C1v+MMXCKaiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(52116002)(36756003)(1076003)(2906002)(6636002)(86362001)(66476007)(66556008)(8936002)(7416002)(6506007)(6486002)(66946007)(6512007)(508600001)(6666004)(2616005)(8676002)(5660300002)(38100700002)(38350700002)(4326008)(316002)(956004)(26005)(54906003)(110136005)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1CcgTb6u785X2y5nlJ0K3E7OsUBHJcyL7zcBs5zhjXigjIiPT9c+UtymlH+t?=
 =?us-ascii?Q?urrhyYbiDhqNA6Bw2icU5IPNtxkeEfj1T+MV8TtnBTxwSb3z5RcPIGwBcn9/?=
 =?us-ascii?Q?v/mZYo+Cv5XO1D07jzw32uHgANvoUFE+ryTKYgi6DJlJnMN/Tlnse7wg7Ujv?=
 =?us-ascii?Q?0rhgeSBRkE6DUODFguB27c43uAEmizWEhs0WFPg4pxzjfIE0J4dYZyzl4qpf?=
 =?us-ascii?Q?Bh9fzRCl/JKbEm8cOzn4MpsFaTRTLg9lnk6PijuGd/7u18oNnq+gxkVY6oQm?=
 =?us-ascii?Q?mCmru20NxHRPyPs4CgMGspCAoMRUSEsPNGissWutQz6jcdaRSxvdOtS3ynqH?=
 =?us-ascii?Q?rblsP2vQrOWixyf+3d7P3+tcQS8+BbyM+46Jmxa9Qpoul+DZx2VvJhKsmLSg?=
 =?us-ascii?Q?GqbWl07wmpR3WmPcK4WrPBL6sYyk1VMafPpeqIv7QnbDTahyimo49OTvtSO9?=
 =?us-ascii?Q?I9QqEj30cqPbGw0eNfNTHzRxd4CXnICIyg40dgQEP3u8p4XGW0oT05couo5N?=
 =?us-ascii?Q?HogbvEynr4uZ5Y6Swwf2q3DWNr0DTbvUkh6WF6Rhg05ntipkcTO8ao8hraz/?=
 =?us-ascii?Q?3IBycJZjeZCPs3Q3Migijn64lcawH3rnK2WwozIyMnYigWMSyAYMi2dCwnSd?=
 =?us-ascii?Q?0Niv5GEYVMKjm+DLbaFhJjP1hUI6+uGZ8RYtEp6VVcEqJS7Nl8xrvKJ2Rdwi?=
 =?us-ascii?Q?cN+OXyiW9XmTnD7GeY8wdVpooHihfGJXnwoC+eCIJVIOu95fTZBpXvTgmvR4?=
 =?us-ascii?Q?jrx1drxGe8marO6BSGlAsgX7N/RuTwbhLCWHC6POraCfSNGd5BYVuABOyhLk?=
 =?us-ascii?Q?m5feitjAVDliZfZXf9xETxrSexUsBNsEgODE1FquPknyLIT3SNflnKMUuJhS?=
 =?us-ascii?Q?aEo0ZB3wjnt0JbQeAZ52Ot1/Kv2xVOVolZvnP5Sbe6OvzRbP6JdT4nPaLJUv?=
 =?us-ascii?Q?KtNXxznnZGpmViCQvHPEl6rtLZYGO+wWA0tKOeKmImOXKqRKk1cV/bRMG/za?=
 =?us-ascii?Q?J2o4rYuzy9p97UwYBbvU2OOZVH7tKZZ3iWTkQzSh3/wsQGBxBf+0usculky/?=
 =?us-ascii?Q?gc2qJ0zdhkAT1Vaf37gh1lU0f8Fa98v4n60cNrMdAnYExPQFGfjUQQfpW8TP?=
 =?us-ascii?Q?H5ZJIyggxEbZM2beT6PgsPsDWeZ1m5dmvraF8HKP/mBQF3tGJqysWNI/Tlcw?=
 =?us-ascii?Q?2BrKar7CYfbgr4W6+vs+duGomoDKDD1Yf4YF5OdwIULqg3ZGJkS/J5jrDpPR?=
 =?us-ascii?Q?dntpNhhLbIjUrCf1of+0aqCJ+SIFRicpPjpRWoHGCDL93QbuljfEgObxSb8n?=
 =?us-ascii?Q?Dq1TOhtKbyTBxv2ybdWqQ+WD?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 088d62b7-25c3-400a-70f3-08d98cfdcdf9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 21:26:36.1566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1/LrdsQqjyCD+4t8fz8W+TSK/siT4NTdAinMeC7HjHD6+UkTmvcfkDho1wI0/iO9CVhQldbw1S95eOnbzIvkYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6703
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
 drivers/net/ethernet/mscc/ocelot.c | 24 +++++++++++++++++++++++-
 include/soc/mscc/ocelot.h          |  1 +
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 4a667df9b447..cf9c2aded2b5 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -671,6 +671,7 @@ int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
 			return err;
 
 		OCELOT_SKB_CB(skb)->ptp_cmd = ptp_cmd;
+		OCELOT_SKB_CB(*clone)->ptp_class = ptp_class;
 	}
 
 	return 0;
@@ -704,6 +705,17 @@ static void ocelot_get_hwtimestamp(struct ocelot *ocelot,
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
@@ -711,10 +723,10 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 	while (budget--) {
 		struct sk_buff *skb, *skb_tmp, *skb_match = NULL;
 		struct skb_shared_hwtstamps shhwtstamps;
+		u32 val, id, seqid, txport;
 		struct ocelot_port *port;
 		struct timespec64 ts;
 		unsigned long flags;
-		u32 val, id, txport;
 
 		val = ocelot_read(ocelot, SYS_PTP_STATUS);
 
@@ -727,6 +739,7 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 		/* Retrieve the ts ID and Tx port */
 		id = SYS_PTP_STATUS_PTP_MESS_ID_X(val);
 		txport = SYS_PTP_STATUS_PTP_MESS_TXPORT_X(val);
+		seqid = SYS_PTP_STATUS_PTP_MESS_SEQ_ID(val);
 
 		port = ocelot->ports[txport];
 
@@ -736,6 +749,7 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 		spin_unlock(&ocelot->ts_id_lock);
 
 		/* Retrieve its associated skb */
+try_again:
 		spin_lock_irqsave(&port->tx_skbs.lock, flags);
 
 		skb_queue_walk_safe(&port->tx_skbs, skb, skb_tmp) {
@@ -751,6 +765,14 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
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

