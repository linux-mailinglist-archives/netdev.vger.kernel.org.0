Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2500642A379
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236271AbhJLLnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:43:13 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:6350
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236245AbhJLLnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 07:43:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R1hTalFACtnOz5b4RHH5gS0bCDoOLQ6DeUvttC+XmlisTxtUOCA0VYlPuSqmUYaK8wOEAkxx2d0EIs15jLBa/oSKOu0exggnYsoFxGfvBCSzaeTRVQ4GhAYbW1cZKJyfoz/5aS6qQKkVAcyOuo4jkQ5cQ0jCO0wpNHcwIUDdwRDJBCsWTobxTXEovLaMEj+Ehu+6NxWMY4xsTlyqM5XtWFS6r8mVD5XX/vtvQ0PbaG8zsgNoKiAHGac8aMN6fD2hYoPs9St54jvQEekFin9kbir4ISnc4uX+EH7U70UG4JEBiaXfypStdbqmzixevHqzptzIEvKK69GLvQ713RTmCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=guEVZaNKXPGVliR9eouuiU3xjUgWvj12kssshcK5xb8=;
 b=c6sjAIXKUplZ0qFpT4GMlzjC1nNH2NsCswwo8T9aUrArHKgGgwFcbZMmsf71+ZapIfbm8WTBpeocS+H2D3i66KDyonZpzHKYloNm3IjF90WgcJmNB6ZboWQ+KyFunEYYHS+MKp7Pgt+80N5nMpoL0rCDew3U5uEhvmXRzmAXy+mkRLWJU9wzO6QMHyt4Ap5iMwQgYxpLbBUqYBIjTOV45tu7h54d3LgK15YL2rzIy5n+Yx6SvnoJH+1Ct8gn0uT1dUZ8Y1XISjtLKDuGdHhH/SWmpiUMBHveblRXT9Nyus466hea7I/1Eh52d4bP+WyS5Wi9KB2uX0Ln6V3mxv1Gbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=guEVZaNKXPGVliR9eouuiU3xjUgWvj12kssshcK5xb8=;
 b=sCc1hP5Td0A2qc40a0bc5WThLe28aPI8PcOuk7+nuVvk1Ub/JQ4gwADySb0Cy8C9HTTjH3Cy24aCVnJtpxM8XRS/jgwt7uvB/2NXzX8wxsyArWkHlbIO+Er7pXJSUJy3NZVn0Y6p/1Kh/33EmpKE0ezexJHktYXyEXDE3dPGJOw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6941.eurprd04.prod.outlook.com (2603:10a6:803:12e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 11:41:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 11:41:02 +0000
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
Subject: [PATCH v2 net 08/10] net: dsa: felix: purge skb from TX timestamping queue if it cannot be sent
Date:   Tue, 12 Oct 2021 14:40:42 +0300
Message-Id: <20211012114044.2526146-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
References: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0150.eurprd07.prod.outlook.com
 (2603:10a6:802:16::37) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0150.eurprd07.prod.outlook.com (2603:10a6:802:16::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Tue, 12 Oct 2021 11:41:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f055f69-c56b-4aee-f3c5-08d98d752b4f
X-MS-TrafficTypeDiagnostic: VI1PR04MB6941:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6941214D86E6658CCB65FE51E0B69@VI1PR04MB6941.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aB+EBnRctucsE/EDFthWoMPVDfoq+a6d6Br/cooUi7+ZBXFT00tu5/y+iaBoQO+I2j71JMfsE4HTP1V2p4kM9phwyghSyu+ipm0MZV/PVmrsjwwntRfgdi5cKMF6YliJG5PQu0HLmkGhCxia2eqrgGTUsJpmYn6XIlrn153us5cuc2mpEB9CFrLwqqv2KVaDblzJvTL/yCOWedmzC2RYoqhXFBj/pG68S+LIFszxAISRc8CL0gjYFk47YMZho+e6OqmNnzctC1+SNvHIiYWC9M4S/mYwK3QKMYlb2UMHTa7hrjBHdATCmL96eGiEZlL8AKVZ3X7T06vKSM2d0Gmtl9yW8UtthV4+ap2OZqCDgl0iUM1faY7Tm8fThgFqHQdgW9p9809nNUlNAACv4nmX6dcPDpaa3X7Zdw4eKT+2MCo6hdokin695TWMHuJavqHyVqCrKK+iZr/wMeP2r/0dum4PLr7h+5QgDtUDoLYOhlsz5N21hyJgRmBsV261AQfJc4ZcUOZeOvjCVr1ADRFDMcd/d313rRCJG+LzHiZaLbPnBoc21OjQwJEHfG0iXyDzK2ZgP0LH/s5NMxz46NLhEUIUTVJc7ygsA81k2SQrTminH93ZO/hoKGBHNwOSIVlnXBLbnHQkg9A1MtzQMCABpFxGb1fCU2JqLqaaeRo+bvt1g8dTfZLU1KDUCy37QLyu6yovHoZZ0WbQ/aUK9MEiqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(44832011)(508600001)(110136005)(6636002)(2906002)(66556008)(66476007)(54906003)(52116002)(6512007)(4326008)(316002)(2616005)(956004)(26005)(186003)(38350700002)(6506007)(7416002)(66946007)(8936002)(6666004)(83380400001)(6486002)(86362001)(36756003)(1076003)(8676002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qA3HH4Y7PxoioyV9rckRZn0oth1JQVT5jiIBMaGNzNnl0Zi3KvHFDpOkmzfw?=
 =?us-ascii?Q?VIHxVn5Jl3McT8ktAQlP0dY46XuDkCN9R51Tsie10pcKgiVs9V6k7Op7Z4OH?=
 =?us-ascii?Q?FFSE6lpShko32Xm2cjkzUWwrtRU1i/o2pthgqDhQT9ze4szcGwAfxRZN7iZC?=
 =?us-ascii?Q?SNqHgNd9UA/rH8b8c2dAvI+i66vSU+33Y5ros5+eLAku4WKLiv+2hIUqIbbS?=
 =?us-ascii?Q?sc5xZYC7WzB48+AdyQoyaW1HOOY5C9oOLZ2tOpYNEpa77yi9s0b+Ydw/P1ln?=
 =?us-ascii?Q?SvZCkKSuIpDmK3NMVl637Q9614d/K/n6ei+F/cJki17Ejm0ycrNXoDiN8Mjk?=
 =?us-ascii?Q?BY7QVpqPLKA+NIANZz0E5bAQr8yplOspQjxXEX7zJJVv35ypfMt+FHv71FCv?=
 =?us-ascii?Q?LFpCl20IijzKTLP6yxhhDtIrkZntL2A6NOKPb8qyvsYTw0SlpTjNHTcQJa5U?=
 =?us-ascii?Q?IB7ZTS2OvilgcFdTJiDARN4JVx+LZ8coCrAoBNTHSEu6nMooPgBM1ENBJ9uf?=
 =?us-ascii?Q?oMPk97bS/0jGLByVZdNSWlLDVzXydnfDAKzlUtGhfWsFP71mutHAscql09d0?=
 =?us-ascii?Q?dqsO4/N9H4HbIgRploP4oIvYGFZB/2DgDwvtoxWIlWrLCbN5UCMZewA4VMHW?=
 =?us-ascii?Q?kdPeQovIVWydROKx3HJf9WLm63qOiYoZxQu+BlGtG8ewBoIPk4GHrcNxEf2f?=
 =?us-ascii?Q?R22eHMZWXyQINlkNR620kGDrljiHIO/n00AuHkkbfDRH1/sOcpn7ZClY5aFO?=
 =?us-ascii?Q?A7N+B0yKoaId/qLiK/82b188CfQLd0QK3pTh40cikxgEEJcb3KoTatFSkwj4?=
 =?us-ascii?Q?YoylWnVHwN0T4tcnxSd5z24111CC+U18SgQX3FASurTiOLOiFzLwqActl6Af?=
 =?us-ascii?Q?KQbkTBG3T5rI6d4LixquplSJ6wHXQWkZNfCe074Y26ZSIss60rVnNlvwbKPL?=
 =?us-ascii?Q?oKiCVWKZ6Jj4oPuZgIv2w4cy94lt+akO2DyEwUCgo/MQMrjIiLmSu3u5FVP8?=
 =?us-ascii?Q?VL+XOix8owKXRh6S3np55JLXRN7FnQ0qaEFVmNuUzWosXdG5DyVMiGJnXRv6?=
 =?us-ascii?Q?d3hkomAPno3GpXPLL1yUizUD+cEYf8gTfip9L5yvGv1OM+t4/Qy/f6HuT158?=
 =?us-ascii?Q?ctqLIztKLCQ853K5RGJ/FrX8HLJMxFMr44xuksfaUjNrxUQNTKSSZgPAjhh8?=
 =?us-ascii?Q?NKnVK8tKw3IMwRw0BYnKIyz+PQYk6+Nz+cFjzwwG5zmzvwSg+pZabpRlGr21?=
 =?us-ascii?Q?BkKoOlYFqUJDsZexEpcMCN6ia8ueNDl32qaazot/xF9fJbh92UA6QGaWDOi/?=
 =?us-ascii?Q?ljPjbWDA228PY2TMUqAHHKeu?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f055f69-c56b-4aee-f3c5-08d98d752b4f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 11:41:02.8405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gcfetM62zHGKnpyp6g40tAwH++F38gzpCZgUNDwsivf4rnUIbfbBr9kJ2koBJxvGcTLW88Ysd4AU1NcPsbZHCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At present, when a PTP packet which requires TX timestamping gets
dropped under congestion by the switch, things go downhill very fast.
The driver keeps a clone of that skb in a queue of packets awaiting TX
timestamp interrupts, but interrupts will never be raised for the
dropped packets.

Moreover, matching timestamped packets to timestamps is done by a 2-bit
timestamp ID, and this can wrap around and we can match on the wrong skb.

Since with the default NPI-based tagging protocol, we get no notification
about packet drops, the best we can do is eventually recover from the
drop of a PTP frame: its skb will be dead memory until another skb which
was assigned the same timestamp ID happens to find it.

However, with the ocelot-8021q tagger which injects packets using the
manual register interface, it appears that we can check for more
information, such as:

- whether the input queue has reached the high watermark or not
- whether the injection group's FIFO can accept additional data or not

so we know that a PTP frame is likely to get dropped before actually
sending it, and drop it ourselves (because DSA uses NETIF_F_LLTX, so it
can't return NETDEV_TX_BUSY to ask the qdisc to requeue the packet).

But when we do that, we can also remove the skb from the timestamping
queue, because there surely won't be any timestamp that matches it.

Fixes: 0a6f17c6ae21 ("net: dsa: tag_ocelot_8021q: add support for PTP timestamping")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/dsa/ocelot/felix.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f8603e068e7c..9af8f900aa56 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1074,6 +1074,33 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	return 0;
 }
 
+static void ocelot_port_purge_txtstamp_skb(struct ocelot *ocelot, int port,
+					   struct sk_buff *skb)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct sk_buff *clone = OCELOT_SKB_CB(skb)->clone;
+	struct sk_buff *skb_match = NULL, *skb_tmp;
+	unsigned long flags;
+
+	if (!clone)
+		return;
+
+	spin_lock_irqsave(&ocelot_port->tx_skbs.lock, flags);
+
+	skb_queue_walk_safe(&ocelot_port->tx_skbs, skb, skb_tmp) {
+		if (skb != clone)
+			continue;
+		__skb_unlink(skb, &ocelot_port->tx_skbs);
+		skb_match = skb;
+		break;
+	}
+
+	spin_unlock_irqrestore(&ocelot_port->tx_skbs.lock, flags);
+
+	WARN_ONCE(!skb_match,
+		  "Could not find skb clone in TX timestamping list\n");
+}
+
 #define work_to_xmit_work(w) \
 		container_of((w), struct felix_deferred_xmit_work, work)
 
@@ -1097,6 +1124,7 @@ static void felix_port_deferred_xmit(struct kthread_work *work)
 	if (!retries) {
 		dev_err(ocelot->dev, "port %d failed to inject skb\n",
 			port);
+		ocelot_port_purge_txtstamp_skb(ocelot, port, skb);
 		kfree_skb(skb);
 		return;
 	}
-- 
2.25.1

