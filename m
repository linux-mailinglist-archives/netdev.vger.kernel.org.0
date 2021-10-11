Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545444298DD
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 23:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235298AbhJKV2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 17:28:49 -0400
Received: from mail-eopbgr150054.outbound.protection.outlook.com ([40.107.15.54]:23262
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235293AbhJKV2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 17:28:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gks1Nsj2tmccTVTdGTWa71yJagHOnwmnEC6j+oYH7P4//A8wTjox0BpY+iVJJxpgKtWRXxKrDNATf5cxaJxl99yWkD8YxwT5S0JMjGrYRv9rv4VaULkBhEKNCy1Y2qs8dZzjzKDxWLl/zsgJsrxQZstssaqpO6kNkXdnEDgTQLjRBblbOIbdg3GXdK4FRhB/5p3oP1bRtYyO5KA0HQK+hQa2f5+xckXIxaBReNHeSNmOXVbDO6UE+nMJda7niqREjswyPQBUMjNPrpHq1zD1hlZ8VARgCutPjn93jRQAv6CVrsndHrDVyc8hABxgWaMpzWVEKwm9J23PI4uS5YPApg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mwFFY3/U02G/I/Xxw5O0IZg9kqaF9zoT4kD2iPHwlvs=;
 b=aoRzBWs6GhxpXpt1BlS4LBuFi5wGHz3i0AAjztFNZrU3JbCexsQtT9QpAF1ADebPaOzCf4FFZjFT3aXoC1sdXDMncezQI63QdThGw+lycj1Ss57NUpO/cNKHv0Lsoj7HHPhAmjrbQHTisyN54C91lM2l5PvWShTEbgX27dT4iMcRlWK17BadaQxIO9n16G1GcxXPHYDJf/fV7NM1fngUu9IKRlCaqIM44IaVb0wDU9iNRldTDxbUJTLV56+ofM/bGoctXoXRTVLm+9PWoH7nFzAxy2Phpkp9QSk1yPf6H52cBIeqPsJINr+WA6x8Bu0KuiIqx5pN/pdUsCIohfiXYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwFFY3/U02G/I/Xxw5O0IZg9kqaF9zoT4kD2iPHwlvs=;
 b=Kf71d65ECd4EeTohKXvfjKZNdPaESDWaYHdaUrK5QpIq0Snuqyic938q8QpFeqC9XUnxt/tJoTJkeKlVj2EgjssFJJ39ic9tGzu7N0Nwq6v0lIWSd/XeaRbg2yLz6HNiSkUQexC43aBrHMu4bCkGAhZtLkOTR3WmNoti0B6SBfA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4910.eurprd04.prod.outlook.com (2603:10a6:803:5c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Mon, 11 Oct
 2021 21:26:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 21:26:39 +0000
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
Subject: [PATCH net 08/10] net: dsa: felix: purge skb from TX timestamping queue if it cannot be sent
Date:   Tue, 12 Oct 2021 00:26:14 +0300
Message-Id: <20211011212616.2160588-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
References: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0260.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0260.eurprd07.prod.outlook.com (2603:10a6:803:b4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Mon, 11 Oct 2021 21:26:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa239fd1-d822-44d7-54d9-08d98cfdcfc2
X-MS-TrafficTypeDiagnostic: VI1PR04MB4910:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB49103B3E4F30B4357C4B8EAAE0B59@VI1PR04MB4910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nbZVoAgNn8G39sPvZvxbfLPTDXs2o0WpN6cpS6h150KHMSboUXwI9yLXTJrM59PvP+4SgZsoX99OE/twsyHPmOv3JUnuCP5x/Z9vwdZ0B0ctBq9wvG5/RwyR5okHJ2ZwAmGI3miTPmvNYAmTjIhpERajNnz6T73/GJx3+sEC3fWfIVAIRvQ03Ovm/X/CeUZ+QBabg5eel2VHNlGDvmLPzRsA1Duk8Nlci9DPiD0L1SH20VG1QxI4mtP5ijWvf55aQb3ZsUcz0qtJs2zO5YkUP0XTLRNeAKlhbLQMhHQZXLlfsD0nkeiDOZCt+/aNGPlI9gf205RsPrVqFEErrPk8wfvvrs27QvUG96CtUW92SetVq3L92Vnxy/cAiBh6U1ncE4PEERN88MXybKhlekOxJkeRPk0uuo7qiOcc8q3FRUwW8BVLgxX+fWr9XbvzfDnUQ4qJu0tVi9p4eQmzzIMLn5xxjBbAQow6vvRNADF7R5fRipm50ofQbfpqLz8jyNanRoyLlGJdlw02KevIA1e7LH4jhL5NvxhvExWsI17HEmdtojtQJQz12/Ac9JxYxQTicYggFzXpENezp0p4kWa7NQYZb9qZ6vb8Yl7srhqGkNMmmahfpK4WybifpPCjpTLP2HSpB+dVVz/NNSilPt1V1xd1YsDcXrvraJgBiD+5KkyIY6rwmh2GgNxhWNRONsuyc/HUYbdMKJxXraFLb9Pf3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(8676002)(66476007)(44832011)(66556008)(66946007)(54906003)(110136005)(52116002)(26005)(6486002)(5660300002)(508600001)(4326008)(6506007)(956004)(38350700002)(1076003)(6666004)(36756003)(6512007)(86362001)(38100700002)(6636002)(83380400001)(316002)(2616005)(7416002)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DFIZgYkZqnkjqL3kSs6jF8HEKCcShx2PDKvQxA2ligNKEnfAIJRNRrHfTNeK?=
 =?us-ascii?Q?a6s+0PzmJMJ5ho7v+wTpxlEpHRfM0tXEcxEvqyBJ1xIpjph4dk7MFX52mp1E?=
 =?us-ascii?Q?pGfizFdZcErGV3qh1ibAIWhAozdxTF2nfVb1AwfUy13B6HNHXT9dqHGZvQ1u?=
 =?us-ascii?Q?oLU8PoXmzeJOO7XSnSftm+ldyqaz4rrke331rE3QPcvhHP6JDHcrUx8OXLRP?=
 =?us-ascii?Q?NZk/tnVe3B3W7webZ9LE/uiO4a73iMJe/Y46BNbx+LVjWthD8ZQNd6GqN4Yn?=
 =?us-ascii?Q?owvlAEB2nGmDLq+GCKbiHpKkZAlWENfnv1qqpqlade7XfiofbyWrCfi4KbUk?=
 =?us-ascii?Q?0TEnAn79PcxtI/UqIodYskD90iO49TDd6drsX62aUNeuO3BlHWpGt7gadiVH?=
 =?us-ascii?Q?qEqDqR/26NMpoamjLl7odDEecAhj/XPDiHKLwOQ4lWHKBU9GxtZZuFftAjE9?=
 =?us-ascii?Q?eu1J64WReFdZux3K/DMjIdN4HtPfdv0vJAkOB/1hiroNfmNUbqolBshrV45k?=
 =?us-ascii?Q?A3xjbus9uo2Fsl6EnrX+Ge7dt70RheTFe1gcA/+wSvnbMpUyIrHe4CfQytue?=
 =?us-ascii?Q?EwlViFptzf9ryrge0s8ceJmv7oJXl8Yoz5MLT/4MrdTwcZUlfg6THL03qbIG?=
 =?us-ascii?Q?g8i8UfSq2VC5J8TBS+OPSFabJPjXuO9TVdnDjC5pFBt+kwwY0H8SxThCZKbs?=
 =?us-ascii?Q?ttuhShD8jxgClRJd164O1zi9t72fOVpcsRoHEE8s8arV3ig0aXPv4kaH48HA?=
 =?us-ascii?Q?gTMxXM2YZFkRbvHVT+ICBbe+dGCcPR9YuYcZ3KCzpB8I9MFFksFyoL6qGA93?=
 =?us-ascii?Q?kA1otxAOGvAHWhQUkjhQpjVHQ1rRZl5itmgexv92NdSYUEe6FwzOwluoTcWT?=
 =?us-ascii?Q?jFL0VynsBtqefDTUZZDn5A7LXm/3C4uQ4PP5q73sRbPuW57z1SN1LrSuWd6Y?=
 =?us-ascii?Q?Z1t/5TB7VNOpG0n+vMKS5Li4himQhB5H/8Z0+nO2VWV3EIH6kOIh5uBzTq9K?=
 =?us-ascii?Q?/Ja6dncB4g4Us3zvUJXrwgszAys4P2CkQR6tqpeO/m4Cl6n2wEYNQ0qBxG7S?=
 =?us-ascii?Q?iezw6UNTar9lRScPy+CEAgo0cSDltxR6LL0eixy8k4ChcAXEC+bS4bNfeUv5?=
 =?us-ascii?Q?UguCj21qokNveONDR/tDiCd0eVl/cGN/Ti+Ll39Rxd6pVZLPCJmlLlIeaGGX?=
 =?us-ascii?Q?ddZlM9Pp/Mv+E8xUnFm5wFy7T5BBs1r43AOWlaKQggTQFqAxXif53RetL8g2?=
 =?us-ascii?Q?fRRr/RF1I6chb4ecPHEZQWvF6AGLwizqAwup+phLnet8CBc/ZVp/DB87XIVl?=
 =?us-ascii?Q?35QzK+ednjxPa4EYKtsj3L5O?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa239fd1-d822-44d7-54d9-08d98cfdcfc2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 21:26:39.1608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HF6Z5Lub56s/rzt6nsBjApQlSLc9RDOF4WXvnYH+BUzfr/PehkDobOeD2VMKInigYodlm5nPFoi7xI0ldMbU+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4910
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
 drivers/net/dsa/ocelot/felix.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index e885b166a3f8..78b10957c644 100644
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

