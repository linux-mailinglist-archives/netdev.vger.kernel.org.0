Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9134346DCA2
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239967AbhLHUJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:09:21 -0500
Received: from mail-am6eur05on2088.outbound.protection.outlook.com ([40.107.22.88]:43105
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236464AbhLHUJU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 15:09:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mf8FxeXOZdlgK9gvAx5LNrEoAnZaisjGX8yRtSlYMpiMbwn9lEzTxWsdhTrqxbhfLXtJMZNhxambOnySs/XmkBKrt8x92kW4xNy8f5i1xCHAER9B+O4imgo44gECbzt/WAgMmJzHw1dVzbiPC6qG/7v2a+UxZmV03iXrdoSi/7KQUxe+OaLEuu6bfetSMVXn2ClcvxYWmFXhtj/tyoEu3H4wv0FNYOs6KyY+iJqlJ7mo5Rpav/yQ6i6Q4PrLVXMSsgZuLMZmhssaQq3Vcfyz/c505PL7ShiYTm53o1f6tlYT4FBYkDhW5Hb86ZAmNl5Xif6iwOkclK9Wbh5EUOJJ+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UHHkj4FMHZMkt0GPnW/jAgLzKYGtmBiRCkpMPum5vCY=;
 b=PpX6Eq123PmzC1/CXCWyszneIZ5ByvxpGVC4YDWAn12jUAN04EyoxzWl2VnMKBKf/7eYYlRumF8fQtUo0Xmdq45kLX8ghx5IqaH8+h8pPSWnvVYN3WHgdQIJjn3PHMx0GH8LvRJ4uarlYhrGqEAUCSM7s2MvtYvBbP/WKY7D3Uq6n9X+1Bswu/OwAy6Zi3o2eP2cwo+GFlxHxQ96UkoNCmLEROxxEP2zpG8E1xMaRLspwIoSblNkdmTq8cqiL0EiQa/jTA1hSa/Ck0ZgqrtRlRcaS9SLnNRooyvC8/iE5ApldiR4g/QlKmQRDWLJB9XNdYv3gat8CjxV+ahlQO790Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UHHkj4FMHZMkt0GPnW/jAgLzKYGtmBiRCkpMPum5vCY=;
 b=JajPpxAkR/pwZitmvkH960y0GLBMFONfK9T5wYue6gG+NoaWEl4r/g+eSZRj/1Z0WW9uf+Cwq+TPoHimaDt7IwxqKP4WmxGhS8nU2aiEIsJv5nANvyDopYeC1hJWEYfBDoxgWKbSgC0jk0CAOq4UjpWUJifTtOOySqWhRPh/U6o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6638.eurprd04.prod.outlook.com (2603:10a6:803:119::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 20:05:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 20:05:47 +0000
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
Subject: [PATCH net-next 01/11] net: dsa: introduce tagger-owned storage for private and shared data
Date:   Wed,  8 Dec 2021 22:04:54 +0200
Message-Id: <20211208200504.3136642-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
References: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0011.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM8P189CA0011.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 20:05:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5431188-fd4e-4e71-c8a0-08d9ba861f84
X-MS-TrafficTypeDiagnostic: VE1PR04MB6638:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VE1PR04MB6638AA3DDFF3BB5FAAFA65DFE06F9@VE1PR04MB6638.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IXQqe8CzOKBG2DO74nQDJ4hbb+M+iQMSH2tgnMPvO6N4B9w9YltH/hrIMP6OnifNw7Q/1seAh+qCSSleFSse8JR8GB3KDWQ9wAX5uekHe0KABoGJQFPPS7T4RXeUD2xmDugLRMyG3u4o+Nc+WXA/OzhrQJTu+dMc+HZ1q214qpp9N82R8GFDc+wJejPP98eM/QdjJxXsbxU+jcnaeftADkxxjzWRfUIkai4wDPT4JwKyrhcXANMJbAIywbbKN5xhiUNjSDMr9Ov/22lxNaVMWch/NaDoUKMQoC/HZVfGE4do0XpImQSkveuQqMPoQjMLPrSMkdiDwehCeOFGexiW9FEHz+ef4eW5qn9Zymj+5oQVsrJQp/bRimqZM4qoMh8qcAkwDcARDflzRVuQyN3x6Um0K63pfbYCtLzrLivcdpTMntoEtF0mXsObEnbKbK+QVPgA7vSZDQT9QBOq9hxPLEl/xRZnEiXSosjD0ePjOZ0JfcSJqpIyfytMXH/CnVxJunFtAlzr1ASkiZroEijeN7X5uXXSq6krucbowAaUGb5VBOLo90gurdXhvCZDw6r43HQK2ywc8e7Vi9dG0aEzCQwcrn3KsWhk+VTqX3WfEzMVA4DtzmMDiMX/RAMY60QbFaX0LOh4dEgnXEp2V22BvuA8oA2DdzGCocA7sEoevDMmrMQUaUzXYsPiDxzpo0njqeCkq6PHSnPz8o7Cr78+JA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(316002)(5660300002)(508600001)(7416002)(54906003)(8676002)(2616005)(44832011)(4326008)(956004)(52116002)(6916009)(8936002)(38100700002)(38350700002)(6486002)(6512007)(6506007)(66946007)(186003)(6666004)(36756003)(2906002)(86362001)(83380400001)(1076003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5pH5eFP0K1Jv0Ika0gPSnF5tulN6iAmf/sT70CPxMMFbrKqoAdmWkIXaNPiK?=
 =?us-ascii?Q?n7eH8+bL2in86sF9ID6aqkLEYJI2Gvr1RJJU96gebFAJZ0XQsruKFrdXJ4nO?=
 =?us-ascii?Q?eykufYCnRDWAMuLu+YKYBHTclrJuKxu06gxr1epvyCAWP7R3IeIRNU9n7KE0?=
 =?us-ascii?Q?vZr2okmJqif+7vmadSVStjNDcXxcV4xJdPdvPqoHkAJYIgPln4mAARvT6N1O?=
 =?us-ascii?Q?TQzvJOGNWHENo13q8tA9wNenusGRbTNyXWMRRvbxh52Z3+J1lE2FKMrAytbP?=
 =?us-ascii?Q?LpAsZsIX/ZcNn+ALTCWV/G07o9fhrRL1GbM6ZXfpM4+w/IUSXMF8BNml/3NI?=
 =?us-ascii?Q?qcEhmo9uEI2GSKeu/dZCPi3Lqc4a1SYEPRRib2au4jf5U15HGr1FAbJBq0IV?=
 =?us-ascii?Q?Mx6gic3fcG93782pHTkapGKLrivIERphyIf5hl6+fX2oQsEJETlMOJXUmT8t?=
 =?us-ascii?Q?QAosdhguj5bVCaRvyozq1r/tt7EyqVA8X/D97q0MBqw2LQqLG+Q+Bx6irL9s?=
 =?us-ascii?Q?k6Fr70eYF9UJxCJbrU7SFJ6gWbgyUoJlBlaFq5J50q8kdNQXzNAI6ou1po9B?=
 =?us-ascii?Q?w9agRVphm+CIwMPtF3DjY2oeE4WOzLR0IB4/KO/pwm9axr+1qCBWrYGzqVKU?=
 =?us-ascii?Q?C3/i8xPPPxXaQZzW0NM/aN0suMzb4lsGPlvPjyKKRtBks+9FMt8D7yOgTGVm?=
 =?us-ascii?Q?ptIVlUgjurVgv09P1OxJgrLvuzXnPqxzmAYMs1s87JxWAmkz5iFiQxITUXzi?=
 =?us-ascii?Q?IOq3GpuhqRFWNOwABdPSrZ2G0vi4++dwHhY63So3JEKaJdLpQ2uav9ZRLBeA?=
 =?us-ascii?Q?E5ocmastCF7voycTcDdiyt68Yg/lV8ALNlVChXydmYxBwDrV4FqHGpuJ1WJu?=
 =?us-ascii?Q?fSpV4Sq8soWVjCUHOU9SSDJ37+LcNFsVN7ayCFhE47S9cOhJU5mF8RIbiisX?=
 =?us-ascii?Q?qr3ZYhSbMyX/DlFPEw8HtEvJ/1pwlql1rQtsYnM1sSM/hvkg/ZVm7FUj4hvJ?=
 =?us-ascii?Q?cgbU0mcoW+t/nNDmEv3AeS4dKxLOFT4P/Y5KRk+aoGdukGspeLGcVvzNjtU+?=
 =?us-ascii?Q?R1UnE7vV+fn/MG+8yOB6JCL6f+tXRRddoXSaPm+2Za3FRV0QfM8AduYoEys/?=
 =?us-ascii?Q?gacsr7bZyokmUOBfO2MwY69ukF8cO8N8j1K+QsPFLjFgWOW4lXnYnr494QUN?=
 =?us-ascii?Q?T/tXHVZmMIwY9vtSkMhblpPgnHN/hVGQVuVG/dgLiOE0OWl0NuWw/44yBLaC?=
 =?us-ascii?Q?rnG3pvduv6l6yWLnUfSEWyudo92ovtyNAlaY1unDu/KvepyHxR2zNtKFADzq?=
 =?us-ascii?Q?0Eo06ejellM7oUTf2al3Y0bxTL8c9JPhEPBAIAG8flR7H/Qv/CucByMVkC33?=
 =?us-ascii?Q?i9RTXRavk9hGt9G6MJryycLWNUn4xe0lz7xIxTMZKma2XW817DNHT3eyDiro?=
 =?us-ascii?Q?LKE1Od+MFcC+arnLa4N18nDbfQ1gj0GE/pFxsjh3yIvUggIijX6bVQfSgFqY?=
 =?us-ascii?Q?ti/iWMM/ZoeWv0Ij+zD3VymK3pXxLlu2mUYowT+fg1t3mK/VH+orYg+RVXMV?=
 =?us-ascii?Q?aoFimw4Q2S/7Ned16oQwYFrr+lSrP5SlSyrFs4FqueaLXmNvwwPWsyEGELbB?=
 =?us-ascii?Q?N2NQzdrC/9GA5CcUre8JfwQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5431188-fd4e-4e71-c8a0-08d9ba861f84
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 20:05:46.9315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ucohnOL8y8yy1AA1hO17oX+TvYSL1zHTo34vWgq8pFPABxTDAulo6V1khFUzUxY4DjPfvoIIUIf/S3T4Vyyl0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6638
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ansuel is working on register access over Ethernet for the qca8k switch
family. This requires the qca8k tagging protocol driver to receive
frames which aren't intended for the network stack, but instead for the
qca8k switch driver itself.

The dp->priv is currently the prevailing method for passing data back
and forth between the tagging protocol driver and the switch driver.
However, this method is riddled with caveats.

The DSA design allows in principle for any switch driver to return any
protocol it desires in ->get_tag_protocol(). The dsa_loop driver can be
modified to do just that. But in the current design, the memory behind
dp->priv has to be allocated by the switch driver, so if the tagging
protocol is paired to an unexpected switch driver, we may end up in NULL
pointer dereferences inside the kernel, or worse (a switch driver may
allocate dp->priv according to the expectations of a different tagger).

The latter possibility is even more plausible considering that DSA
switches can dynamically change tagging protocols in certain cases
(dsa <-> edsa, ocelot <-> ocelot-8021q), and the current design lends
itself to mistakes that are all too easy to make.

This patch proposes that the tagging protocol driver should manage its
own memory, instead of relying on the switch driver to do so.
After analyzing the different in-tree needs, it can be observed that the
required tagger storage is per switch, therefore a ds->tagger_data
pointer is introduced. In principle, per-port storage could also be
introduced, although there is no need for it at the moment. Future
changes will replace the current usage of dp->priv with ds->tagger_data.

We define a "binding" event between the DSA switch tree and the tagging
protocol. During this binding event, the tagging protocol's ->connect()
method is called first, and this may allocate some memory for each
switch of the tree. Then a cross-chip notifier is emitted for the
switches within that tree, and they are given the opportunity to fix up
the tagger's memory (for example, they might set up some function
pointers that represent virtual methods for consuming packets).
Because the memory is owned by the tagger, there exists a ->disconnect()
method for the tagger (which is the place to free the resources), but
there doesn't exist a ->disconnect() method for the switch driver.
This is part of the design. The switch driver should make minimal use of
the public part of the tagger data, and only after type-checking it
using the supplied "proto" argument.

In the code there are in fact two binding events, one is the initial
event in dsa_switch_setup_tag_protocol(). At this stage, the cross chip
notifier chains aren't initialized, so we call each switch's connect()
method by hand. Then there is dsa_tree_bind_tag_proto() during
dsa_tree_change_tag_proto(), and here we have an old protocol and a new
one. We first connect to the new one before disconnecting from the old
one, to simplify error handling a bit and to ensure we remain in a valid
state at all times.

Co-developed-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  | 12 ++++++++
 net/dsa/dsa2.c     | 73 +++++++++++++++++++++++++++++++++++++++++++---
 net/dsa/dsa_priv.h |  1 +
 net/dsa/switch.c   | 14 +++++++++
 4 files changed, 96 insertions(+), 4 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index bdf308a5c55e..8b496c7e62ef 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -82,12 +82,15 @@ enum dsa_tag_protocol {
 };
 
 struct dsa_switch;
+struct dsa_switch_tree;
 
 struct dsa_device_ops {
 	struct sk_buff *(*xmit)(struct sk_buff *skb, struct net_device *dev);
 	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev);
 	void (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
 			     int *offset);
+	int (*connect)(struct dsa_switch_tree *dst);
+	void (*disconnect)(struct dsa_switch_tree *dst);
 	unsigned int needed_headroom;
 	unsigned int needed_tailroom;
 	const char *name;
@@ -337,6 +340,8 @@ struct dsa_switch {
 	 */
 	void *priv;
 
+	void *tagger_data;
+
 	/*
 	 * Configuration data for this switch.
 	 */
@@ -689,6 +694,13 @@ struct dsa_switch_ops {
 						  enum dsa_tag_protocol mprot);
 	int	(*change_tag_protocol)(struct dsa_switch *ds, int port,
 				       enum dsa_tag_protocol proto);
+	/*
+	 * Method for switch drivers to connect to the tagging protocol driver
+	 * in current use. The switch driver can provide handlers for certain
+	 * types of packets for switch management.
+	 */
+	int	(*connect_tag_protocol)(struct dsa_switch *ds,
+					enum dsa_tag_protocol proto);
 
 	/* Optional switch-wide initialization and destruction methods */
 	int	(*setup)(struct dsa_switch *ds);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 8814fa0e44c8..cf6566168620 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -248,8 +248,12 @@ static struct dsa_switch_tree *dsa_tree_alloc(int index)
 
 static void dsa_tree_free(struct dsa_switch_tree *dst)
 {
-	if (dst->tag_ops)
+	if (dst->tag_ops) {
+		if (dst->tag_ops->disconnect)
+			dst->tag_ops->disconnect(dst);
+
 		dsa_tag_driver_put(dst->tag_ops);
+	}
 	list_del(&dst->list);
 	kfree(dst);
 }
@@ -822,7 +826,7 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 	int err;
 
 	if (tag_ops->proto == dst->default_proto)
-		return 0;
+		goto connect;
 
 	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
 		rtnl_lock();
@@ -836,6 +840,17 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 		}
 	}
 
+connect:
+	if (ds->ops->connect_tag_protocol) {
+		err = ds->ops->connect_tag_protocol(ds, tag_ops->proto);
+		if (err) {
+			dev_err(ds->dev,
+				"Unable to connect to tag protocol \"%s\": %pe\n",
+				tag_ops->name, ERR_PTR(err));
+			return err;
+		}
+	}
+
 	return 0;
 }
 
@@ -1136,6 +1151,46 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 	dst->setup = false;
 }
 
+static int dsa_tree_bind_tag_proto(struct dsa_switch_tree *dst,
+				   const struct dsa_device_ops *tag_ops)
+{
+	const struct dsa_device_ops *old_tag_ops = dst->tag_ops;
+	struct dsa_notifier_tag_proto_info info;
+	int err;
+
+	dst->tag_ops = tag_ops;
+
+	/* Notify the new tagger about the connection to this tree */
+	if (tag_ops->connect) {
+		err = tag_ops->connect(dst);
+		if (err)
+			goto out_revert;
+	}
+
+	/* Notify the switches from this tree about the connection
+	 * to the new tagger
+	 */
+	info.tag_ops = tag_ops;
+	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_CONNECT, &info);
+	if (err && err != -EOPNOTSUPP)
+		goto out_disconnect;
+
+	/* Notify the old tagger about the disconnection from this tree */
+	if (old_tag_ops->disconnect)
+		old_tag_ops->disconnect(dst);
+
+	return 0;
+
+out_disconnect:
+	/* Revert the new tagger's connection to this tree */
+	if (tag_ops->disconnect)
+		tag_ops->disconnect(dst);
+out_revert:
+	dst->tag_ops = old_tag_ops;
+
+	return err;
+}
+
 /* Since the dsa/tagging sysfs device attribute is per master, the assumption
  * is that all DSA switches within a tree share the same tagger, otherwise
  * they would have formed disjoint trees (different "dsa,member" values).
@@ -1168,12 +1223,15 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 			goto out_unlock;
 	}
 
+	/* Notify the tag protocol change */
 	info.tag_ops = tag_ops;
 	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO, &info);
 	if (err)
-		goto out_unwind_tagger;
+		return err;
 
-	dst->tag_ops = tag_ops;
+	err = dsa_tree_bind_tag_proto(dst, tag_ops);
+	if (err)
+		goto out_unwind_tagger;
 
 	rtnl_unlock();
 
@@ -1260,6 +1318,7 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
 	struct dsa_switch_tree *dst = ds->dst;
 	const struct dsa_device_ops *tag_ops;
 	enum dsa_tag_protocol default_proto;
+	int err;
 
 	/* Find out which protocol the switch would prefer. */
 	default_proto = dsa_get_tag_protocol(dp, master);
@@ -1307,6 +1366,12 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
 		 */
 		dsa_tag_driver_put(tag_ops);
 	} else {
+		if (tag_ops->connect) {
+			err = tag_ops->connect(dst);
+			if (err)
+				return err;
+		}
+
 		dst->tag_ops = tag_ops;
 	}
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 38ce5129a33d..0db2b26b0c83 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -37,6 +37,7 @@ enum {
 	DSA_NOTIFIER_VLAN_DEL,
 	DSA_NOTIFIER_MTU,
 	DSA_NOTIFIER_TAG_PROTO,
+	DSA_NOTIFIER_TAG_PROTO_CONNECT,
 	DSA_NOTIFIER_MRP_ADD,
 	DSA_NOTIFIER_MRP_DEL,
 	DSA_NOTIFIER_MRP_ADD_RING_ROLE,
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 9c92edd96961..06948f536829 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -647,6 +647,17 @@ static int dsa_switch_change_tag_proto(struct dsa_switch *ds,
 	return 0;
 }
 
+static int dsa_switch_connect_tag_proto(struct dsa_switch *ds,
+					struct dsa_notifier_tag_proto_info *info)
+{
+	const struct dsa_device_ops *tag_ops = info->tag_ops;
+
+	if (!ds->ops->connect_tag_protocol)
+		return -EOPNOTSUPP;
+
+	return ds->ops->connect_tag_protocol(ds, tag_ops->proto);
+}
+
 static int dsa_switch_mrp_add(struct dsa_switch *ds,
 			      struct dsa_notifier_mrp_info *info)
 {
@@ -766,6 +777,9 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_TAG_PROTO:
 		err = dsa_switch_change_tag_proto(ds, info);
 		break;
+	case DSA_NOTIFIER_TAG_PROTO_CONNECT:
+		err = dsa_switch_connect_tag_proto(ds, info);
+		break;
 	case DSA_NOTIFIER_MRP_ADD:
 		err = dsa_switch_mrp_add(ds, info);
 		break;
-- 
2.25.1

