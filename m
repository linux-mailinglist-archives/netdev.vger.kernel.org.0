Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997722CF817
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 01:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730885AbgLEAoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 19:44:15 -0500
Received: from mail-vi1eur05on2089.outbound.protection.outlook.com ([40.107.21.89]:36448
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726241AbgLEAoO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 19:44:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bued1k32RMJ8VEB3BAz4Rp0VU8HtPlfP0fRa7WqF4nbAxbMaB1IEn55RuOhPLS/Iy1dnf1Q3FEfPClckxxrYEhUQMOfh4lrKoZhhOK+/Y8fRjf/OBk54jIPoLGnK5bds4YFvPrrvFajbYRHeUcDC9StvCU+UeTGiHnRJfwsZVV3qIRuVhMUUBWZ6dGrTW6ZdW74tGAqN2BR5mS3/f7dfcU31iiOb8ri5JCPVVrHlpDzDYdZXw+vy114GSMnSAx3TkB2SayimlKBb5BXpPA8sdaQiuc0n14h25dHIvo/W6g5n45l9borxDOoXGjZb9bKkxV/jHDbNVlZLJ0hC74nu/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6AYQRYwUPAHi0YfcZjIPYqwFu1XOpSiJJ4YZA52Cn8Y=;
 b=YjF+ccOwgQZrlYgxcwc5DXDZ1i8FWVct75b8wpmDumHcbAZ6d+CSyMjgsgtqf/eTnRx0XvzbfowUG18tz5n+2hXzlbkPkypGUW6XQaIDJMlRnI7h9jywC/4ph/Ny2n3yGDadSQvyG00B47STa6o1yI/O/GN/3pl9Jon7UJ9Po5199yIiEmLDiAu2mQ3azBzlhYfvGCHtBgzpKH/RQboq8uaQUjsQsFUaW1nCup4+NHeobLan7fT14MeWHPbhj6nEZQI/ZnJkVFZFkroM/AbCSdgLPIRCDe/FXFzY7jZOne6ZTgxAzGzX2BEln6O0FadX/Xr54LXPsIPgQdls/cECBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6AYQRYwUPAHi0YfcZjIPYqwFu1XOpSiJJ4YZA52Cn8Y=;
 b=AGSNIBjTS/vuGSpedwNDiriBUdHiRGHIHqwLTBHP2p4WJkcapMb1OJ4Ax9RH6hdUSzJ04vhGkQwDzOVvqjEPuFw01HeAXnyhEkjugLkBuIhkbn+2TdqPrZ/9t4LyNTxmjsF6Kf9iq/7SUMxm9DLSF62NmWMSsaqxQ9gNwqbGj/I=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.31; Sat, 5 Dec
 2020 00:43:26 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 00:43:25 +0000
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
Subject: [PATCH v3 net-next] net: mscc: ocelot: install MAC addresses in .ndo_set_rx_mode from process context
Date:   Sat,  5 Dec 2020 02:43:15 +0200
Message-Id: <20201205004315.143851-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1P195CA0027.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::16) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1P195CA0027.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:5a::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Sat, 5 Dec 2020 00:43:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fff65445-fea5-4a8a-c6b4-08d898b6c698
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3407ED26C71803099FF29768E0F00@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d9ovDEpz8UybJhLiQ2qPfN/TiWgzBqg1uwpgbxWOR1cGQux5hLEXqIELt8nOjd7mwHtQVYK/gOpbD/pxxfOw6TTSg05KZ6IJpt/QXCSo8MMcTUm+qFcafjy1BxFdz7ND04VgxJWpk4ADf9rr6mzerl6jR3HvbhuT/ZPHNSydMEkedwcnmQPpYs0ZOZXxsLAwIcrXLdZTyh/CIxgkkUEfgO6uTMSSNDN4n3kq4AcBZs8btECWHSDYnl5cn52eKyxiVmRNRn3Rl3GP8MeUAPzq89KpyTSLXi0VFQNCD1/PzUUlhUqDoLmtpFTJromfqm2c3IPHFy4k4SASNj588bAt3aXpxoxOwkoHzWxruluAOMNb7H3C6py9J4LJi3A3uzHTnlJS88bnXb9QhC5Ff1ZmiaYdpEbXxk9noKi5BZjp6+k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(86362001)(44832011)(6506007)(26005)(66556008)(16526019)(5660300002)(66946007)(2906002)(956004)(2616005)(8676002)(4326008)(69590400008)(186003)(7416002)(316002)(1076003)(52116002)(54906003)(66476007)(110136005)(6666004)(8936002)(6486002)(83380400001)(6512007)(36756003)(478600001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Oa2Am0K04aTLG2TkA2F5PM1yHaBwUIGX03z/h1UZ3n5xUidIICTTkGzypvrv?=
 =?us-ascii?Q?XOMM11GgfrFoNzPYZcuVp9d/iUA0G92r7wxryqLnkcYrWsfLJwZbT3OI/Ggx?=
 =?us-ascii?Q?dgCAqr9xJCk2IauRzZCJKWAgnDfCvefmkdD/M/+0Dilkp1xUKbeKW867Nr1g?=
 =?us-ascii?Q?yq9v+kdBfmJXja9uHcxIM06Oc7zrUhJvAKRzZw0lk2VZcqcGE3Myca9GbloY?=
 =?us-ascii?Q?ul4L6e4OAgXnROAjbKMzhG3CXsBRN9iWTIVgvNMkk11dSlwu/f8U2xSSAv6W?=
 =?us-ascii?Q?l2lzxlTx3ptO36nw2ZCZF0o9SB4VKowQlV6lzmNtPuvkduShXtKGStLlJ7kg?=
 =?us-ascii?Q?ZSzYEoeMWnRvJ56dn3xq6Wy7+SMd2E6dVoEeJzBbXG6xZ3o8zFUVRdnBjO0C?=
 =?us-ascii?Q?x2WEBAdnTnjsL3pRzoJSoWD4IEW0m5AlnqbO9OD9dC2bBpDnQad/j+CnDoP+?=
 =?us-ascii?Q?KYuQoZuHj0+w0CGI9Va2KqR0quNhARjJ/wxlSRlE4zkiRynGu/Ttwzvt4JZk?=
 =?us-ascii?Q?NKlbCCNUwwvRWA35+gFDg7dR/k6nyMAFd7K/pxi775D070MreQ07DcMtX/KC?=
 =?us-ascii?Q?RiPtuVNqRgnEOWmmMaoLyaWQxiXzeSWGq0svEdxb9js/GGWOsf9v80rFGiLa?=
 =?us-ascii?Q?Dms73OvfInrs1fGuTSwxmpncLwQQzmLtSUmkH0vyS/IYYDBRW703ST+0HjK/?=
 =?us-ascii?Q?PdxMJnTMMjKFM39cc3tzOP8xezf/MN2FITEmgaQWg1unjrcvuB63OGnCpthQ?=
 =?us-ascii?Q?w7g2h9RylpJhwWGytBlOJsBs3yfU6vlBxBu3Szu73Int6On87cizodJGAB/Z?=
 =?us-ascii?Q?3awvxSCNJfqk8oN8JWwm1n6m/cvX62yPHRXiUycolmMD8mjP9hbZsd6DRBiV?=
 =?us-ascii?Q?b+kjtfikYkvDs+X9pbXxlpbVaI68lvW1DsOvM6P9fp8zvw901QVUkimlEIut?=
 =?us-ascii?Q?ZN7Cta6GcfloOakb5ZqV3B3H3Zm8OtOe6OLkVpuTL+QNCHmKgplp21EKfksQ?=
 =?us-ascii?Q?xS8g?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fff65445-fea5-4a8a-c6b4-08d898b6c698
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 00:43:25.8744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q44/gqsBuRnAdhNKP1QtO+aIzKJ4nvBgSW39fsxrjpMC/vPBALucAL5W5MmOUeSbVZHa0EzdSoexWyORrB1mUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
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
Changes in v3:
- Dropped Fixes tag and retargeted to net-next
- Dropped get_device/put_device since they don't offer real protection
- Now allocating a private ordered workqueue which is drained on unbind
  to avoid accessing freed memory

Changes in v2:
- Added Fixes tag (it won't backport that far, but anyway)
- Using get_device and put_device to avoid racing with unbind

 drivers/net/ethernet/mscc/ocelot.c     |  5 ++
 drivers/net/ethernet/mscc/ocelot_net.c | 81 +++++++++++++++++++++++++-
 include/soc/mscc/ocelot.h              |  2 +
 3 files changed, 85 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index abea8dd2b0cb..b9626eec8db6 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1513,6 +1513,10 @@ int ocelot_init(struct ocelot *ocelot)
 	if (!ocelot->stats_queue)
 		return -ENOMEM;
 
+	ocelot->owq = alloc_ordered_workqueue("ocelot-owq", WQ_MEM_RECLAIM);
+	if (!ocelot->owq)
+		return -ENOMEM;
+
 	INIT_LIST_HEAD(&ocelot->multicast);
 	INIT_LIST_HEAD(&ocelot->pgids);
 	ocelot_mact_init(ocelot);
@@ -1619,6 +1623,7 @@ void ocelot_deinit(struct ocelot *ocelot)
 {
 	cancel_delayed_work(&ocelot->stats_work);
 	destroy_workqueue(ocelot->stats_queue);
+	destroy_workqueue(ocelot->owq);
 	mutex_destroy(&ocelot->stats_lock);
 }
 EXPORT_SYMBOL(ocelot_deinit);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index c65ae6f75a16..9ba7e2b166e9 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -414,13 +414,82 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
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
+			int pgid;
+			enum macaccess_entry_type entry_type;
+			unsigned char addr[ETH_ALEN];
+			u16 vid;
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
+	struct ocelot_mact_work_ctx *w = kmalloc(sizeof(*w), GFP_ATOMIC);
+
+	if (!w)
+		return -ENOMEM;
+
+	memcpy(w, ctx, sizeof(*w));
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
@@ -428,9 +497,15 @@ static int ocelot_mc_sync(struct net_device *dev, const unsigned char *addr)
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

