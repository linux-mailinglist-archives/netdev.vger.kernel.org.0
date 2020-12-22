Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F052E0B20
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 14:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbgLVNr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 08:47:26 -0500
Received: from mail-eopbgr70073.outbound.protection.outlook.com ([40.107.7.73]:58438
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727525AbgLVNrX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 08:47:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MlUOzmWkjn4rWI95Eh0Pp9RZn+t6BZcB53EONWQAuGkl9SxnPoUBufAOJL7K/GNUY6ZdO5ndcro7BHPGPj9J4ne+phbZU1Ht2JIkCz0SFNnZfi/GIXetjCJzkx8rHLxKeO7z2ykpx/VpZ2y8hseGOaV4LqQnXy1a3wk+7t85lvL2v3nhtOIVXoc/cD5mbqaNjOi4Xq47IaLgdQxMapjr1+KvIBPoaR1WegB3hYCvpkQNo5LRzImNlI0vzt+VdVNg61ZS+9ZHvOCk0SKMCIU9O+bXaKiz4LDBVpYh5YSytHzJuDwj9sKBo0uS8nCk65SjyOUSl1yiRnh4JI1LKYgWGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tc/6yXPZ/Qr2KL5MkVF3spiSZUDlAgxrcTmDQzD1JBE=;
 b=ZI3kGFeQIn6XCdWkr4uT24pLaRMBOWNpqRxFvaatNrqVAkfkey4CaqECcFQ/hq4deXYXxHwuB0jCW1ZDdyH945Z+St5JsJQ0USZNAQ2OSRjFUC73yz/Rqyk0B4oG23ZB+095HkwR3lwuA/7fB8cMVbq7Rj64JsvXj1LCGwOzuzHkFdCAgxJAn2O1K6fEvnYZRN80Xb1b1wtZDzZRud6GMUuGFBaWIXeWuStAMc4ZMCGVAuf8WpUUfaiQA843nxVvPV00X9XYf3uXTXTGb5BTwucQ4ZLZcTg8lWfN6yKLu7fj9a2wyBHzY1vIf8E0mn5NJgXhp9kWVT3Sb14k11vklw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tc/6yXPZ/Qr2KL5MkVF3spiSZUDlAgxrcTmDQzD1JBE=;
 b=siw2BoPk3PwYh11XlbvFY0pnxXLDcM8pnP7ajUMf4dE1p9yBB5JXGVNL81KtoG5Vx3DQox/scdsIV84EpLNlVzwqeqbq2iDdYYU8+H+vQ+SmlXVIrRoB7XBgrM5OecxNzUCgBIQ8w5p4tl7ZZjpGjP/bHGPx+vXhQ81JIexYgzw=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 13:45:06 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 13:45:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH net-next 15/15] net: dsa: tag_ocelot_8021q: add support for PTP timestamping
Date:   Tue, 22 Dec 2020 15:44:39 +0200
Message-Id: <20201222134439.2478449-16-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
References: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0169.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::23) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0169.eurprd08.prod.outlook.com (2603:10a6:800:d1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29 via Frontend Transport; Tue, 22 Dec 2020 13:45:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8d67b7d5-d080-479b-28f7-08d8a67fcacc
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7408A1A9CB2BDA106A4B8E4EE0DF0@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0XfkZNWNpXXYOR8W3iQkdz/WLyUPN4GiptCtK2WSXbkmkUTq+1omBUHkxbFaOq7Auxj8wpFgNKpYFX3VXdY99BVHZlQ+N6LF7yJw8KunBOb5bDDi8ygo3NKAuLWh4lLzPNolo1mj+j4pYrKk/1CmKGUhbXb4OBlA2dw2jHoBOhw59NeADNfL/g5o3U4YkmEYQNIjjdxqGef/zh5EL3+VjOx3zIU/5e9ObgqHJnpbadvH5r+xdKZcRQbp7zXoj4F1hOcEzL2BF/1wVRHyLDTj4J2810Sqoa1eOfsWjHGXyW1Evesqh27Yim57G4dJj8EtqssNGSJ4XDp/Z5J8N8OwKcOqDldJpSrngXf86TpVfZv8XqmC0XLz8ukHwUE9fBP8PN1cNF4zEDwnrZXZKPP8eIqnLjjHDAyYBSxWRH1XLbsvj8/1z4N6+qUt0wcWYTg3TZXLVL36q++DfviAsuNxeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(69590400010)(8676002)(956004)(186003)(4326008)(36756003)(2616005)(6512007)(498600001)(16526019)(44832011)(2906002)(83380400001)(8936002)(110136005)(54906003)(26005)(6666004)(66476007)(5660300002)(6486002)(86362001)(6506007)(66946007)(1076003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ApB+eNjniy9eetPFaUCHgqdNbbIbaACTC0lEtBkvcWU+VSY75n4AbE0zoC4f?=
 =?us-ascii?Q?3hSekEmL8wcHBTE07OfQ3lCy4yX4ZZ4p0Txv7JzccY5CBOh1xXce3iy1J4l0?=
 =?us-ascii?Q?dnTugnaJgTnTbCCDNFWZWH6m17ZTnaL+5tXtNBCWwa+57NS6Ly/TP0TZWKgv?=
 =?us-ascii?Q?CdP8oN95RdHIetQjE59TfdWCsF8foQ1TPWFCL1+Zy63RYizb+pun6FsGkX2i?=
 =?us-ascii?Q?dy/GpUiaOT3f6XGfbn6zdXApAjTSnkILO/gQtWtovHQSWjMYrigDb0jslpC3?=
 =?us-ascii?Q?VyvMXrwLQzNnsvxvGN4eVHwaobGa8/9l2ZvLYuWcINNd2Y1AzZQCDSrN21sq?=
 =?us-ascii?Q?Q9Ci7JWdNgJK/Fdiq+vAvJfPq/L2oBG9jbJtJhmF7My5jKo2cIHCBfpzmaiV?=
 =?us-ascii?Q?Ph6ygTyrpOpHlilcTl5zfZpeJjBmbSxpQr/0vt+iHClWfgD/KHlCREg/KNtO?=
 =?us-ascii?Q?UOSUvCyIb8Ksm/wER/9ML+O2/WZAc8xz9r/x86brmKskHLrwv830ou1r3pK2?=
 =?us-ascii?Q?iSRCEPdJvWXOxQjiEFk239voUNX/8prC2+Hfr7/WeBVjM6GBAO9v6KH+qcfe?=
 =?us-ascii?Q?Dg2+7FbBTm0yrFyHv6ufzcuGeIzRXgLMwXl0lLuKSkTw8Ir0lWSJHPeBb91O?=
 =?us-ascii?Q?rIB1jLPtIOvF6tLkKReBLEhp8iB+2Fqp297NH4WlXMzx2QElNClxtteZY4KK?=
 =?us-ascii?Q?qNkXN2J0ZpdxujaLjsopn17WfQqQwH/zZBJXNBHVRLmR3n+sL26H7K2iT3bi?=
 =?us-ascii?Q?liPyhRyR+NB+kVmAt2WXCy+szp3jzG8IYESG6utcVX+x99zVG5r/3ei44dQu?=
 =?us-ascii?Q?29MXcvf9vFBTyV5nceBF6tbmekq9hWaq8MTa91hjuwE9tCBZb5Q6JpIXFF6F?=
 =?us-ascii?Q?4/HtSM2EThO/mH9DlMH2eFa+I6ux68fPnT48eI151oPvjDmwEbJjg0VvWNUr?=
 =?us-ascii?Q?8ZT+YIDEKjIlPfwiOvioNV8emvQl9n/FcgSYlWDWpjylt58+V1oKSS9mkW3s?=
 =?us-ascii?Q?JU6I?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 13:45:06.5130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d67b7d5-d080-479b-28f7-08d8a67fcacc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gREtjJFqYltbbZQb9bgcaKp0pzriWT6Y7quAVTzd+gG/EUwxHkIGwKtudl8HPrQLpRroc+LX6yVI93vD1Zm2PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On TX, use the result of the ptp_classify_raw() BPF classifier from
dsa_skb_tx_timestamp() to divert some frames over to the MMIO-based
injection registers.

On RX, set up a VCAP IS2 rule that redirects the frames with an
EtherType for 1588 to the CPU port module (for MMIO based extraction)
and, if the "no XTR IRQ" workaround is in place, copies them to the
dsa_8021q CPU port as well (for notification).

There is a conflict between the VCAP IS2 trapping rule and the semantics
of the BPF classifier. Namely, ptp_classify_raw() deems general messages
as non-timestampable, but still, those are trapped to the CPU port
module since they have an EtherType of ETH_P_1588. So, if the "no XTR
IRQ" workaround is in place, we need to run another BPF classifier on
the frames extracted over MMIO, to avoid duplicates being sent to the
stack (once over Ethernet, once over MMIO). It doesn't look like it's
possible to install VCAP IS2 rules based on keys extracted from the 1588
frame headers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/dsa/ocelot/felix.c           | 12 +++++
 drivers/net/dsa/ocelot/felix_tag_8021q.c | 61 ++++++++++++++++++++++++
 drivers/net/dsa/ocelot/felix_tag_8021q.h |  7 +++
 drivers/net/ethernet/mscc/ocelot.c       |  3 ++
 drivers/net/ethernet/mscc/ocelot.h       |  8 ----
 include/soc/mscc/ocelot.h                |  9 ++++
 net/dsa/tag_ocelot_8021q.c               | 24 ++++++++++
 7 files changed, 116 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 77f73c6bad0b..a1ee6884f11c 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -757,6 +757,18 @@ static bool felix_rxtstamp(struct dsa_switch *ds, int port,
 	struct timespec64 ts;
 	u64 tstamp, val;
 
+	/* If the "no XTR IRQ" workaround is in use, tell DSA to defer this skb
+	 * for RX timestamping. Then free it, and poll for its copy through
+	 * MMIO in the CPU port module, and inject that into the stack from
+	 * ocelot_xtr_poll().
+	 * If the "no XTR IRQ" workaround isn't in use, this is a no-op and
+	 * should be eliminated by the compiler as dead code.
+	 */
+	if (felix_check_xtr_pkt(ocelot, type)) {
+		kfree_skb(skb);
+		return true;
+	}
+
 	ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
 	tstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
 
diff --git a/drivers/net/dsa/ocelot/felix_tag_8021q.c b/drivers/net/dsa/ocelot/felix_tag_8021q.c
index 5243e55a8054..2a7ab3ddb12b 100644
--- a/drivers/net/dsa/ocelot/felix_tag_8021q.c
+++ b/drivers/net/dsa/ocelot/felix_tag_8021q.c
@@ -11,9 +11,70 @@
 #include <soc/mscc/ocelot_vcap.h>
 #include <linux/dsa/8021q.h>
 #include <linux/if_bridge.h>
+#include <linux/ptp_classify.h>
 #include "felix.h"
 #include "felix_tag_8021q.h"
 
+bool felix_check_xtr_pkt(struct ocelot *ocelot, unsigned int ptp_type)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	int err, grp = 0;
+
+	if (!felix->info->quirk_no_xtr_irq)
+		return false;
+
+	if (ptp_type == PTP_CLASS_NONE)
+		return false;
+
+	while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp)) {
+		struct ocelot_frame_info info = {};
+		struct dsa_port *dp;
+		struct sk_buff *skb;
+		unsigned int type;
+
+		err = ocelot_xtr_poll_xfh(ocelot, grp, &info);
+		if (err)
+			break;
+
+		if (WARN_ON(info.port >= ocelot->num_phys_ports))
+			goto out;
+
+		dp = dsa_to_port(felix->ds, info.port);
+
+		err = ocelot_xtr_poll_frame(ocelot, grp, dp->slave,
+					    &info, &skb);
+		if (err)
+			break;
+
+		/* We trap to the CPU port module all PTP frames, but
+		 * felix_rxtstamp() only gets called for event frames.
+		 * So we need to avoid sending duplicate general
+		 * message frames by running a second BPF classifier
+		 * here and dropping those.
+		 */
+		__skb_push(skb, ETH_HLEN);
+
+		type = ptp_classify_raw(skb);
+
+		__skb_pull(skb, ETH_HLEN);
+
+		if (type == PTP_CLASS_NONE) {
+			kfree_skb(skb);
+			continue;
+		}
+
+		netif_rx(skb);
+	}
+
+out:
+	if (err < 0) {
+		ocelot_write(ocelot, QS_XTR_FLUSH, BIT(grp));
+		ocelot_write(ocelot, QS_XTR_FLUSH, 0);
+	}
+
+	return true;
+}
+
 static int felix_tag_8021q_rxvlan_add(struct ocelot *ocelot, int port, u16 vid,
 				      bool pvid, bool untagged)
 {
diff --git a/drivers/net/dsa/ocelot/felix_tag_8021q.h b/drivers/net/dsa/ocelot/felix_tag_8021q.h
index 47684a18c96e..1bf92d5fc4c4 100644
--- a/drivers/net/dsa/ocelot/felix_tag_8021q.h
+++ b/drivers/net/dsa/ocelot/felix_tag_8021q.h
@@ -7,6 +7,7 @@
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_OCELOT_8021Q)
 
 int felix_setup_8021q_tagging(struct ocelot *ocelot);
+bool felix_check_xtr_pkt(struct ocelot *ocelot, unsigned int ptp_type);
 
 #else
 
@@ -15,6 +16,12 @@ static inline int felix_setup_8021q_tagging(struct ocelot *ocelot)
 	return -EOPNOTSUPP;
 }
 
+static inline bool felix_check_xtr_pkt(struct ocelot *ocelot,
+				       unsigned int ptp_type)
+{
+	return false;
+}
+
 #endif /* IS_ENABLED(CONFIG_NET_DSA_TAG_OCELOT_8021Q) */
 
 #endif /* _MSCC_FELIX_TAG_8021Q_H */
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b91d4c31d3d7..14717eca8220 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -651,6 +651,7 @@ int ocelot_xtr_poll_xfh(struct ocelot *ocelot, int grp,
 
 	return 0;
 }
+EXPORT_SYMBOL(ocelot_xtr_poll_xfh);
 
 int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp,
 			  struct net_device *dev,
@@ -728,6 +729,7 @@ int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp,
 out:
 	return err;
 }
+EXPORT_SYMBOL(ocelot_xtr_poll_frame);
 
 /* Generate the IFH for frame injection
  *
@@ -806,6 +808,7 @@ void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 	skb->dev->stats.tx_packets++;
 	skb->dev->stats.tx_bytes += skb->len;
 }
+EXPORT_SYMBOL(ocelot_port_inject_frame);
 
 int ocelot_fdb_add(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid)
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 68b089d1d81b..51fabaa7896a 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -118,14 +118,6 @@ void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
 			 enum ocelot_tag_prefix extraction);
 
 bool ocelot_can_inject(struct ocelot *ocelot, int grp);
-void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
-			      u32 rew_op, struct sk_buff *skb);
-int ocelot_xtr_poll_xfh(struct ocelot *ocelot, int grp,
-			struct ocelot_frame_info *info);
-int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp,
-			  struct net_device *dev,
-			  struct ocelot_frame_info *info,
-			  struct sk_buff **skb);
 
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 25a93bcc6afe..e95b4be3dc88 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -788,4 +788,13 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 			const struct switchdev_obj_port_mdb *mdb);
 
+void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
+			      u32 rew_op, struct sk_buff *skb);
+int ocelot_xtr_poll_xfh(struct ocelot *ocelot, int grp,
+			struct ocelot_frame_info *info);
+int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp,
+			  struct net_device *dev,
+			  struct ocelot_frame_info *info,
+			  struct sk_buff **skb);
+
 #endif
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 1b5102e74369..62e0778eed8e 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -2,6 +2,8 @@
 /* Copyright 2020 NXP Semiconductors
  */
 #include <linux/dsa/8021q.h>
+#include <soc/mscc/ocelot.h>
+#include <soc/mscc/ocelot_ptp.h>
 #include "dsa_priv.h"
 
 static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
@@ -11,6 +13,28 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+	struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
+
+	/* TX timestamping was requested, so inject through MMIO */
+	if (clone) {
+		struct ocelot *ocelot = dp->ds->priv;
+		struct ocelot_port *ocelot_port;
+		int port = dp->index;
+		u32 rew_op;
+
+		ocelot_port = ocelot->ports[port];
+		rew_op = ocelot_port->ptp_cmd;
+
+		/* Retrieve timestamp ID populated inside skb->cb[0] of the
+		 * clone by ocelot_port_add_txtstamp_skb
+		 */
+		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
+			rew_op |= clone->cb[0] << 3;
+
+		ocelot_port_inject_frame(ocelot, dp->index, 0, rew_op, skb);
+
+		return NULL;
+	}
 
 	return dsa_8021q_xmit(skb, netdev, ETH_P_8021Q,
 			      ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
-- 
2.25.1

