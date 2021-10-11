Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CB14298D7
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 23:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235279AbhJKV2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 17:28:37 -0400
Received: from mail-eopbgr40088.outbound.protection.outlook.com ([40.107.4.88]:16861
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235262AbhJKV2g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 17:28:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GV2zxPW1CoQ30PHPboU021+U8mxJtyCKklJOsbG0WzKom1mMBE35tPvPksrVYMct4/W9aD1Oud1z5KHeSvi1sCwlv5R3w2VZXJyxLKcwXGmMIjc6wgE9XKzXy3WI+0FCsLe816x7kGapWfQGs9R5WCsROPvsCVvoIqei4W4HQh7Wr1ckEZRG6bmBryoj1xcU2I1+cAekQTZlHKLZxzTfzOIKUNCAwL2QZ47eKJFOoizFyNWNmu70dnl37qs25c1N42QH20f38F5beo38BJxkQUq94mGaMuzw4ePjdauFyeeeBw5ZdB4v6M9LESxP0aUCX6f3MEYvvswcE5XBh95vZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hNUFTCHn6jOmTkTxZm3CMsMBwNoq9toXO671sTnyaw=;
 b=i2OgaJiIAIL54FpKccNJ0Tlvis+JIMFJ9e5D9YKBdYEEpdWceYHNRc8EzL8DR1K5wOkpPLhDHocbRW1M/0LQvlwmLaK6rBFHKIhWh3JHFFpWHT/c/sYf70d65YLU5kzlMIHWbwNsZNhX/EwB49au/sO4d1vu3hhkn8KWzolQ6sR3jyZQmlWfMC7bJ8OMsKoOZDKZXknvKrezR0IgyFk4vApOWBJwoUSAzDdvMlI4lfqYBg+8HOFyKuTstfunEG7UYzTeXu+qlvterTB1VU9ZIMKE8pcWb77gspyv0o2biieou/BkC3LT+e2Qo+o313j7vhdWcSXGcWYFJlvbhB6QtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hNUFTCHn6jOmTkTxZm3CMsMBwNoq9toXO671sTnyaw=;
 b=dex5P6fORrhttiHX4oDnL3u8jEBdHX+8zHTg8mwx5O5SQLtcNoTfiIAqvNis94GyZ2MUBbnVih7GN4ApLV5+J4wzmr5iCWkCL8dq4bUA8l2Um5ouHVHepQuZ3KNktlSDwtOEEzL4fxmBMsgUlJ8bcHfFWEWcedSNZdOfQ3ub/k8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (20.177.49.83) by
 VE1PR04MB6703.eurprd04.prod.outlook.com (10.255.118.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Mon, 11 Oct 2021 21:26:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 21:26:33 +0000
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
Subject: [PATCH net 02/10] net: mscc: ocelot: avoid overflowing the PTP timestamp FIFO
Date:   Tue, 12 Oct 2021 00:26:08 +0300
Message-Id: <20211011212616.2160588-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
References: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0260.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0260.eurprd07.prod.outlook.com (2603:10a6:803:b4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Mon, 11 Oct 2021 21:26:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01c14eb7-9b83-4316-b558-08d98cfdcc1e
X-MS-TrafficTypeDiagnostic: VE1PR04MB6703:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB67037F79AB00B4050686C1C3E0B59@VE1PR04MB6703.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BUz65Sn2jJaRGb2vXpcYL+MZe5TSejaD6ayF1iREctde8GiM6Or9ncgCvX5Z3k+vcHyzMEfUlrEMgUiqSSoOt6PhWNk7yJjrCRolONQ1lxObD56M8pxlkPnunoTthiv63y1myx8IZALCexzgXB5dzOn1GyF3SR0gkv7qibupKg4IZ0HfWoRnAvdR+9gpFEgt/468M3+dysG1ji1yHwwJ57Vjos4u9CCdEz/UVRua3dc7itFN4ZhLXBwoUd72NZeiEU0+/LRe116OudFWcRDe2h4zsQmG/K8FhlrfQBeHlWWFOlJEFs+pfC8qaTw65GwHeE4xtOTrDEDs5UNUDX1ZRHpBw939hHSEihoL92O78RnXqhmOFMFkPfyOQotHmCeHD1IKuFAitckC79ZOsG4URTJkHfEMpH+qOHNMlGYLFTBYadkAJ+0TnCANCU8xy6fPvehuE2o3/ath8BhOdMRxUN+QQUxGRei7WrxlQNOR6WNgEv75m4wQFnhT560VCmggfo9dZM8OVut0ORYGGVLnSa766iSR0klmYg3xmPLukjmn6ofME8aJEfJfR0N69pCxsTWUDdbpMGD+icOGqslou6ggA2CIJNSxN9Ro2tiXkiWUFs8X4+d7Jk96Ak+zp/s0Lvnaf3IFIqEdSBRmNTzmW4lf4pmeDg1BaCRXtctUSt+x/TDg7KUhqWf38hry74PhKD+26bUKksHELm8jAmdBDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(52116002)(36756003)(1076003)(2906002)(6636002)(86362001)(66476007)(66556008)(8936002)(7416002)(6506007)(6486002)(66946007)(6512007)(508600001)(6666004)(2616005)(8676002)(5660300002)(38100700002)(38350700002)(4326008)(316002)(956004)(26005)(54906003)(110136005)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kEtZG3dBq19lTqE1CNMd4gt7v14ViOwEQfxtwk9skysl9jhtRue14yTZeUkN?=
 =?us-ascii?Q?16pQiBdfuDnG2Nmvt3+jvCD59JeKfDtfGzuSid4UT4r8jrjcAXbGDK9RZVd2?=
 =?us-ascii?Q?QBSfoY6lFiuNM+btBihR6s9/WHLdf+6p35aoAMedFnSs0bPmFLpMxMXCxup8?=
 =?us-ascii?Q?5ffMGtD4jU85PExRbSLlIsT7gYlZee7D/X1tj9XLHdWNECGiqRh6ryiqKM7T?=
 =?us-ascii?Q?3vHyFzDqEOz4Kc0MZMD7WmXm8QQitkjBVqjRHK0lmsMh63CPASDUVStAFpI1?=
 =?us-ascii?Q?Ktf0IqAcRgIifJ8+worEwgBcj3MpWm2lIuDDl8BwfjOhSWkzccBCwF//LxI7?=
 =?us-ascii?Q?BP3zFTijsDkxE1UIGHmKZHuy+FTk5n3Z+LsbjOYcX9kqlati6wujby5x94Ct?=
 =?us-ascii?Q?IRn1BCcD06GnAcTNkguD0uFxxTzJos+/RRf4fXCeYpiL6ITHHevt4guKDsQD?=
 =?us-ascii?Q?QMMUS5kL9rzw0Z4x88exHAwrK5NKdUs9aMJo0RjJ3nGeMD+1+IBliNDq8Oo3?=
 =?us-ascii?Q?9N1Ll3iLKbmiwNtcHkXN3t8sKHx4EEAxG846BDfYwy8pHp/qjXbUaW75flFn?=
 =?us-ascii?Q?LEcB0gIJaVcjXwB4h1KVAx9tmkh0HcuVcFzjx/te3p3OucSj66IcMiacXyhg?=
 =?us-ascii?Q?daNsrH8ui24fd+5iR9BLrmYeKVhMYS9CXcQuAcRiUHC87o5Ia1yJ4x+vVi8G?=
 =?us-ascii?Q?S/xaS45kvYe3AtZ3U5MPIw/NzB3Z630wuEmtIe0OrKvNyL/Jx6eF66u4C0JH?=
 =?us-ascii?Q?YayNkVnPpeUHXdYKBKjaLj+lVPxUhiAOjm/BB1A3zDgcoQbH6LM70TI8Vxlc?=
 =?us-ascii?Q?2rsKYTH7K+K9EmfNypGa84vmGeIq74Fzxl/udYGmDT+SynnP3PQQ8Cc76Md6?=
 =?us-ascii?Q?Z6SE8cA6ygdbnoYqB/W1x3oYaYWyBp7XFrCfc5+p3YHffCT/HeWFennqYxPu?=
 =?us-ascii?Q?gBerz8erPOk1eur1z0RmG8wFjnXNX2S4Bo/+IhmjXPSQZCUl6uSygDV9bYdo?=
 =?us-ascii?Q?6K9/uR6On6Yfhwh0Mza0IwFkFxnGEbL/QuEplXwfe5kaPSaKrHfZDMCpF85T?=
 =?us-ascii?Q?vsWfNjHl3AkPO+QqXam9BqeP1Vm2VkYavnJypkXLW7VBEBC14ar8+MEHUlFY?=
 =?us-ascii?Q?fSj/ZGh50qPYgwGsOl+ivpHE53Pw0AVvU4Tk+T3CSTjnMOzvg8YXZeDcsqrd?=
 =?us-ascii?Q?p74WAY78ZS0VkwswIpwBnXJJrjdueKKjJd2zUJTs8pb5DEHQpXLcDS2TygvX?=
 =?us-ascii?Q?4eZMVBQrVhZVjfcYPgjfjM26PYGM4wrj1OFEIKPFwVEaaYKv8Y3ub+XnXzK7?=
 =?us-ascii?Q?etgzL1h25vftJ9KMYE5HX7ti?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01c14eb7-9b83-4316-b558-08d98cfdcc1e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 21:26:33.0893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IAZ/2qGIj8fWwvZsDNVJ2AmIosULh16ttMw4+0U5wezWEiAtw4+G2hfJn/wt5sW/J51cXlHRgnI2zhT2+eV/xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6703
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PTP packets with 2-step TX timestamp requests are matched to packets
based on the egress port number and a 6-bit timestamp identifier.
All PTP timestamps are held in a common FIFO that is 128 entry deep.

This patch ensures that back-to-back timestamping requests cannot exceed
the hardware FIFO capacity. If that happens, simply send the packets
without requesting a TX timestamp to be taken (in the case of felix,
since the DSA API has a void return code in ds->ops->port_txtstamp) or
drop them (in the case of ocelot).

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c     |  6 ++++-
 drivers/net/ethernet/mscc/ocelot.c | 37 ++++++++++++++++++++++++------
 include/soc/mscc/ocelot.h          |  5 +++-
 include/soc/mscc/ocelot_ptp.h      |  1 +
 4 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a3a9636430d6..50ef20724958 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1291,8 +1291,12 @@ static void felix_txtstamp(struct dsa_switch *ds, int port,
 	if (!ocelot->ptp)
 		return;
 
-	if (ocelot_port_txtstamp_request(ocelot, port, skb, &clone))
+	if (ocelot_port_txtstamp_request(ocelot, port, skb, &clone)) {
+		dev_err_ratelimited(ds->dev,
+				    "port %d delivering skb without TX timestamp\n",
+				    port);
 		return;
+	}
 
 	if (clone)
 		OCELOT_SKB_CB(skb)->clone = clone;
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index a65e80827a09..82149d8242ba 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -569,22 +569,36 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL_GPL(ocelot_phylink_mac_link_up);
 
-static void ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
-					 struct sk_buff *clone)
+static int ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
+					struct sk_buff *clone)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	unsigned long flags;
+
+	spin_lock_irqsave(&ocelot->ts_id_lock, flags);
 
-	spin_lock(&ocelot_port->ts_id_lock);
+	if (ocelot_port->ptp_skbs_in_flight == OCELOT_MAX_PTP_ID ||
+	    ocelot->ptp_skbs_in_flight == OCELOT_PTP_FIFO_SIZE) {
+		spin_unlock_irqrestore(&ocelot->ts_id_lock, flags);
+		return -EBUSY;
+	}
 
 	skb_shinfo(clone)->tx_flags |= SKBTX_IN_PROGRESS;
 	/* Store timestamp ID in OCELOT_SKB_CB(clone)->ts_id */
 	OCELOT_SKB_CB(clone)->ts_id = ocelot_port->ts_id;
+
 	ocelot_port->ts_id++;
 	if (ocelot_port->ts_id == OCELOT_MAX_PTP_ID)
 		ocelot_port->ts_id = 0;
+
+	ocelot_port->ptp_skbs_in_flight++;
+	ocelot->ptp_skbs_in_flight++;
+
 	skb_queue_tail(&ocelot_port->tx_skbs, clone);
 
-	spin_unlock(&ocelot_port->ts_id_lock);
+	spin_unlock_irqrestore(&ocelot->ts_id_lock, flags);
+
+	return 0;
 }
 
 u32 ocelot_ptp_rew_op(struct sk_buff *skb)
@@ -633,6 +647,7 @@ int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u8 ptp_cmd = ocelot_port->ptp_cmd;
+	int err;
 
 	/* Store ptp_cmd in OCELOT_SKB_CB(skb)->ptp_cmd */
 	if (ptp_cmd == IFH_REW_OP_ORIGIN_PTP) {
@@ -650,7 +665,10 @@ int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
 		if (!(*clone))
 			return -ENOMEM;
 
-		ocelot_port_add_txtstamp_skb(ocelot, port, *clone);
+		err = ocelot_port_add_txtstamp_skb(ocelot, port, *clone);
+		if (err)
+			return err;
+
 		OCELOT_SKB_CB(skb)->ptp_cmd = ptp_cmd;
 	}
 
@@ -709,9 +727,14 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 		id = SYS_PTP_STATUS_PTP_MESS_ID_X(val);
 		txport = SYS_PTP_STATUS_PTP_MESS_TXPORT_X(val);
 
-		/* Retrieve its associated skb */
 		port = ocelot->ports[txport];
 
+		spin_lock(&ocelot->ts_id_lock);
+		port->ptp_skbs_in_flight--;
+		ocelot->ptp_skbs_in_flight--;
+		spin_unlock(&ocelot->ts_id_lock);
+
+		/* Retrieve its associated skb */
 		spin_lock_irqsave(&port->tx_skbs.lock, flags);
 
 		skb_queue_walk_safe(&port->tx_skbs, skb, skb_tmp) {
@@ -1950,7 +1973,6 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
 	skb_queue_head_init(&ocelot_port->tx_skbs);
-	spin_lock_init(&ocelot_port->ts_id_lock);
 
 	/* Basic L2 initialization */
 
@@ -2083,6 +2105,7 @@ int ocelot_init(struct ocelot *ocelot)
 	mutex_init(&ocelot->stats_lock);
 	mutex_init(&ocelot->ptp_lock);
 	spin_lock_init(&ocelot->ptp_clock_lock);
+	spin_lock_init(&ocelot->ts_id_lock);
 	snprintf(queue_name, sizeof(queue_name), "%s-stats",
 		 dev_name(ocelot->dev));
 	ocelot->stats_queue = create_singlethread_workqueue(queue_name);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 06706a9fd5b1..b0ece85d9a76 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -603,10 +603,10 @@ struct ocelot_port {
 	/* The VLAN ID that will be transmitted as untagged, on egress */
 	struct ocelot_vlan		native_vlan;
 
+	unsigned int			ptp_skbs_in_flight;
 	u8				ptp_cmd;
 	struct sk_buff_head		tx_skbs;
 	u8				ts_id;
-	spinlock_t			ts_id_lock;
 
 	phy_interface_t			phy_mode;
 
@@ -680,6 +680,9 @@ struct ocelot {
 	struct ptp_clock		*ptp_clock;
 	struct ptp_clock_info		ptp_info;
 	struct hwtstamp_config		hwtstamp_config;
+	unsigned int			ptp_skbs_in_flight;
+	/* Protects the 2-step TX timestamp ID logic */
+	spinlock_t			ts_id_lock;
 	/* Protects the PTP interface state */
 	struct mutex			ptp_lock;
 	/* Protects the PTP clock */
diff --git a/include/soc/mscc/ocelot_ptp.h b/include/soc/mscc/ocelot_ptp.h
index 6e54442b49ad..f085884b1fa2 100644
--- a/include/soc/mscc/ocelot_ptp.h
+++ b/include/soc/mscc/ocelot_ptp.h
@@ -14,6 +14,7 @@
 #include <soc/mscc/ocelot.h>
 
 #define OCELOT_MAX_PTP_ID		63
+#define OCELOT_PTP_FIFO_SIZE		128
 
 #define PTP_PIN_CFG_RSZ			0x20
 #define PTP_PIN_TOD_SEC_MSB_RSZ		PTP_PIN_CFG_RSZ
-- 
2.25.1

