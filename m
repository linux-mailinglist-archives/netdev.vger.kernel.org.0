Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6BB92D899C
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 20:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406700AbgLLTRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 14:17:19 -0500
Received: from mail-am6eur05on2069.outbound.protection.outlook.com ([40.107.22.69]:40055
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726309AbgLLTRS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 14:17:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0S7uOR5gqj7Gdqt12eNpNue2qodtxmP/5bf8jaVp51FEvVCrprfN7fQfyhHAGlmcVS76w04rCiA49KMjFxhmI3ji06Q7sMbrAgj9HYrTsP2PPltw1A4aPliddrvDr6LQgSqTj1abAwSbP7gyM+XA2tnJZTaICi7JBG7sRoKSPzaOxt8obS6cRUf7DYyGExaIaxkVUhnblwZBlwEeuch6PBzh6I8XKtXjxVgE7B7Zra8p6keE8Kwe0cGDIJ+9UfMHf4lzCLGRvhOvHix95vD6RTvvHVFxc6sFYaFLonzHIstLZZgMdPR1lcWvui6D1NL6j4/A5CK+gdftLXfxoc2Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QONMou2xBlWen6+nG+MW8o5l83w16bVeLx9AErFWfY4=;
 b=A8DfpXEXRkCb8UlI2LIGdrO/rZjjssNyGVwoB7dggODdzRZ6K8Z5oizVb6P/LIsXRuR2k1LrbjchBVFEbQjtfRfXxslx8rGPvZsfIwJ2OfmoDcahNoTxUPP1Np+szz6N0ijGm/RtY/Jejnn6qwsSnz8THCHoB1J9akUwRHdR4oH9D+3rrNlMqw5/7lev3ABszjl9wGL4rSuo9gOCX4JWwg0X4BBmUryos7msV6sk01gsTae8Ot/FErVKKCu1YA9ZDvYjWdja5coDjpsgjShZ4/PQk6cI+6p+tp6pRKSoKwktPNls9B54J/vMtW2LawMJij8Anq4IxFFp6/OBKs0jsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QONMou2xBlWen6+nG+MW8o5l83w16bVeLx9AErFWfY4=;
 b=SxVljWoVQqI3yrt4alv/YeoOZQxOsITgiinAW8P2idFaPRUn2ElIme7FRalEsAuoxZyoQqaAVGyeOv4acW5DNigm6lr0EuCd1LUAussHRG8jXYvrLcbN+8WjPkHRysoEaBF+9XTaKTnkIkXNsjeeSXShpMGcaUxdNKLXD1RbVGA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6016.eurprd04.prod.outlook.com (2603:10a6:803:d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Sat, 12 Dec
 2020 19:16:28 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sat, 12 Dec 2020
 19:16:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: [PATCH v4 net-next] net: mscc: ocelot: install MAC addresses in .ndo_set_rx_mode from process context
Date:   Sat, 12 Dec 2020 21:16:12 +0200
Message-Id: <20201212191612.222019-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VE1PR03CA0015.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::27) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VE1PR03CA0015.eurprd03.prod.outlook.com (2603:10a6:802:a0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sat, 12 Dec 2020 19:16:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8de89cba-8cae-4462-dceb-08d89ed26ccc
X-MS-TrafficTypeDiagnostic: VI1PR04MB6016:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6016497CAC6EEDB04B3A04CFE0C90@VI1PR04MB6016.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PeZGHb6gQGMhxhF0pIzxw4p5LmOYW8ZspdgNHo0haOXL6hcb7o2xTiX+A4EbTz/MH1ubx2UNZnRaGsVIntlW9yZA5oGBSr+mrRkSg0ZPu9iAsETPnaRKaJC72sMZN5D6DZwD+7EMWEu6iLpytCFqSO62ojX1F2LwxoF0b1TFaUqTJlr5/KNnfddosEirhuWZufPGe22jmN35kIv+jizJjdzSj4XazAaF29nJgw0I/HJKiH2wuokmxbdLz78q3ldqymnOEw1pT9sDgod6z2Af3YDSRd5yfICIY72nUXPBGAMBqPq0/nAnaLirmbfzVpvLAXnajtBGoxk1RBjKwHoUHM/T77KaPAlwhY72xZdZNRcKhAD3/lo/vjHV9GRCHsbJWYrl4ZrA2gWuspjp86Cu0kS3mt46tjW5Qo4ZdtBUKWk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(478600001)(6486002)(7416002)(54906003)(110136005)(52116002)(26005)(86362001)(8936002)(316002)(8676002)(66556008)(6666004)(1076003)(36756003)(2906002)(66946007)(2616005)(44832011)(83380400001)(186003)(6506007)(69590400008)(956004)(6512007)(4326008)(66476007)(5660300002)(16526019)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qq/R3TRF2IKseyDYg+SiJ0JTzH5blt6R82OAB+bY2ysMD7GpvKBlpsHA/3eh?=
 =?us-ascii?Q?kUr7hWbj77isP06O4ucpWN1oNSJhM9yuHzt8UQswwbbEsbOsgfAqg3PUukkc?=
 =?us-ascii?Q?XFZitUIotXNj/dWvRdROGgwBC7VojRhQYmxlrhmsZYwPN8m9XAwwRSYCtLDf?=
 =?us-ascii?Q?IVJWWCDpnEF3kdt/RWmgJKRqIYF4+7P+AqB7J801lesgjs+TYt7SZ3PAh7Gp?=
 =?us-ascii?Q?SKK5RGuFwSrm9YJp6/InBxv93sRyGjJ1A5wSmMDMH2PbS20VJVfROolRhDDW?=
 =?us-ascii?Q?E/Uxg0xonUnr5qobpRLVRC9zVjGiuiEHoRCgTRnvTxWefPumXCOqWiNZLjxZ?=
 =?us-ascii?Q?tQMMvpt4O6O1AfRMjBaEe2UmXCV7i0xHWJXAc4btRJXWMt5H6S1P7/TfqdIZ?=
 =?us-ascii?Q?6Rtlko/2I4GhBqdIW1hSnzobwLsWmtm2qqBxrzNtMxXu3w0nPbt91DkvYCMI?=
 =?us-ascii?Q?D4HWj1UHzq4kRlmTUlaOPqMVmV5ZJxQMfoYgCiJm2EMI3QdEqNUWP0ERfQqS?=
 =?us-ascii?Q?Zo+Sx/6cciYv/f9ge9anMNAJnpX8Ab9XVvNkgOatygQc+Jj3RyJQN8ftzGKE?=
 =?us-ascii?Q?ttg+QMgUBcKQ0ZDt5IFKt95QvUqS8cCQeB1qc0blexkiuAY2cI01K20oVrCc?=
 =?us-ascii?Q?6UXIwEXXPH2NnHEid7wUiFQ9R78FqaJzRbLDRl3ccMFVIInuE3GWnIz82QH4?=
 =?us-ascii?Q?ZKYGVIUZoaCowgwf4g1BacQGtDSR1eBIG2Yjm7hICJrbqKJ7MPGaDYUUR1sC?=
 =?us-ascii?Q?c1gwuXX5DLrKjm+sftSIrrw1icuQz90iFuL2brjeoYSftt/h9Vx88jF3U7vW?=
 =?us-ascii?Q?NCBNdDWF9Jfktsyi317MVDSXpJojyyFMWKRKskLwIDHsYXLL82Qx/m4C7vGP?=
 =?us-ascii?Q?3nkaTWY52sVuPmTuDs/0DYbnlnLv0CgOc2i1y2pwlI1BvT0Hic3nIm4poLP7?=
 =?us-ascii?Q?+fhKsmiCNVjl16N/SRSvsMkAvzLVfXc8qFRru1t2tdDq9s+yq+T6uNB4d1Tp?=
 =?us-ascii?Q?ZVGD?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2020 19:16:27.7821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 8de89cba-8cae-4462-dceb-08d89ed26ccc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xe2khlZLQGW0QTc0SygUI2baoi+jxTspJ4ZBVdkuNUGC2L9UmpB58U/hxlOH3C3fAHvABNMTq+/ocvNqNg2ZZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6016
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently ocelot_set_rx_mode calls ocelot_mact_learn directly, which has
a very nice ocelot_mact_wait_for_completion at the end. Introduced in
commit 639c1b2625af ("net: mscc: ocelot: Register poll timeout should be
wall time not attempts"), this function uses readx_poll_timeout which
triggers a lot of lockdep warnings and is also dangerous to use from
atomic context, potentially leading to lockups and panics.

Steen Hegelund added a poll timeout of 100 ms for checking the MAC
table, a duration which is clearly absurd to poll in atomic context.
So we need to defer the MAC table access to process context, which we do
via a dynamically allocated workqueue which contains all there is to
know about the MAC table operation it has to do.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:
- Dropped WQ_MEM_RECLAIM
- Properly cleaning up on memory allocation error
- Using kmemdup
- Reordered members of struct ocelot_mact_work_ctx::learn

Changes in v3:
- Dropped Fixes tag and retargeted to net-next
- Dropped get_device/put_device since they don't offer real protection
- Now allocating a private ordered workqueue which is drained on unbind
  to avoid accessing freed memory

Changes in v2:
- Added Fixes tag (it won't backport that far, but anyway)
- Using get_device and put_device to avoid racing with unbind

 drivers/net/ethernet/mscc/ocelot.c     |  7 +++
 drivers/net/ethernet/mscc/ocelot_net.c | 80 +++++++++++++++++++++++++-
 include/soc/mscc/ocelot.h              |  2 +
 3 files changed, 86 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index abea8dd2b0cb..0b9992bd6626 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1513,6 +1513,12 @@ int ocelot_init(struct ocelot *ocelot)
 	if (!ocelot->stats_queue)
 		return -ENOMEM;
 
+	ocelot->owq = alloc_ordered_workqueue("ocelot-owq", 0);
+	if (!ocelot->owq) {
+		destroy_workqueue(ocelot->stats_queue);
+		return -ENOMEM;
+	}
+
 	INIT_LIST_HEAD(&ocelot->multicast);
 	INIT_LIST_HEAD(&ocelot->pgids);
 	ocelot_mact_init(ocelot);
@@ -1619,6 +1625,7 @@ void ocelot_deinit(struct ocelot *ocelot)
 {
 	cancel_delayed_work(&ocelot->stats_work);
 	destroy_workqueue(ocelot->stats_queue);
+	destroy_workqueue(ocelot->owq);
 	mutex_destroy(&ocelot->stats_lock);
 }
 EXPORT_SYMBOL(ocelot_deinit);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index c65ae6f75a16..2bd2840d88bd 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -414,13 +414,81 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
+enum ocelot_action_type {
+	OCELOT_MACT_LEARN,
+	OCELOT_MACT_FORGET,
+};
+
+struct ocelot_mact_work_ctx {
+	struct work_struct work;
+	struct ocelot *ocelot;
+	enum ocelot_action_type type;
+	union {
+		/* OCELOT_MACT_LEARN */
+		struct {
+			unsigned char addr[ETH_ALEN];
+			u16 vid;
+			enum macaccess_entry_type entry_type;
+			int pgid;
+		} learn;
+		/* OCELOT_MACT_FORGET */
+		struct {
+			unsigned char addr[ETH_ALEN];
+			u16 vid;
+		} forget;
+	};
+};
+
+#define ocelot_work_to_ctx(x) \
+	container_of((x), struct ocelot_mact_work_ctx, work)
+
+static void ocelot_mact_work(struct work_struct *work)
+{
+	struct ocelot_mact_work_ctx *w = ocelot_work_to_ctx(work);
+	struct ocelot *ocelot = w->ocelot;
+
+	switch (w->type) {
+	case OCELOT_MACT_LEARN:
+		ocelot_mact_learn(ocelot, w->learn.pgid, w->learn.addr,
+				  w->learn.vid, w->learn.entry_type);
+		break;
+	case OCELOT_MACT_FORGET:
+		ocelot_mact_forget(ocelot, w->forget.addr, w->forget.vid);
+		break;
+	default:
+		break;
+	};
+
+	kfree(w);
+}
+
+static int ocelot_enqueue_mact_action(struct ocelot *ocelot,
+				      const struct ocelot_mact_work_ctx *ctx)
+{
+	struct ocelot_mact_work_ctx *w = kmemdup(ctx, sizeof(*w), GFP_ATOMIC);
+
+	if (!w)
+		return -ENOMEM;
+
+	w->ocelot = ocelot;
+	INIT_WORK(&w->work, ocelot_mact_work);
+	queue_work(ocelot->owq, &w->work);
+
+	return 0;
+}
+
 static int ocelot_mc_unsync(struct net_device *dev, const unsigned char *addr)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
+	struct ocelot_mact_work_ctx w;
+
+	ether_addr_copy(w.forget.addr, addr);
+	w.forget.vid = ocelot_port->pvid_vlan.vid;
+	w.type = OCELOT_MACT_FORGET;
 
-	return ocelot_mact_forget(ocelot, addr, ocelot_port->pvid_vlan.vid);
+	return ocelot_enqueue_mact_action(ocelot, &w);
 }
 
 static int ocelot_mc_sync(struct net_device *dev, const unsigned char *addr)
@@ -428,9 +496,15 @@ static int ocelot_mc_sync(struct net_device *dev, const unsigned char *addr)
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
+	struct ocelot_mact_work_ctx w;
+
+	ether_addr_copy(w.learn.addr, addr);
+	w.learn.vid = ocelot_port->pvid_vlan.vid;
+	w.learn.pgid = PGID_CPU;
+	w.learn.entry_type = ENTRYTYPE_LOCKED;
+	w.type = OCELOT_MACT_LEARN;
 
-	return ocelot_mact_learn(ocelot, PGID_CPU, addr,
-				 ocelot_port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
+	return ocelot_enqueue_mact_action(ocelot, &w);
 }
 
 static void ocelot_set_rx_mode(struct net_device *dev)
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 731116611390..2f4cd3288bcc 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -650,6 +650,8 @@ struct ocelot {
 	struct delayed_work		stats_work;
 	struct workqueue_struct		*stats_queue;
 
+	struct workqueue_struct		*owq;
+
 	u8				ptp:1;
 	struct ptp_clock		*ptp_clock;
 	struct ptp_clock_info		ptp_info;
-- 
2.25.1

