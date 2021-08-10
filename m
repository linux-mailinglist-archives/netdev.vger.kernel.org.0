Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E213E7D55
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 18:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbhHJQSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 12:18:43 -0400
Received: from mail-am6eur05on2080.outbound.protection.outlook.com ([40.107.22.80]:16133
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234930AbhHJQQh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 12:16:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsPmLaRss9XTt0BwaumZh1lLzfLcqCbUpmS1F6xG8gILF0PeJtNoarFAfMgTt5Fu3ZbjKGhUkP0qQNNB3bPSNOLYX415XyKEUhcWxJEtXmTY7KsyFmifnQ6saxPt0zEhxjBBX2HSF2LRGFLXtgCrA2Qqy0h38xh4Ffkkf1j8KuuiUAtZd4iv0Krk7olsKpvoxyP0QyO+SQkU4ni4uloqCx+LMf1Bqyn36HYpy88ySpbnK4cdCMjvP2NQf/+D/VPy7ID5KgBzF9DPAIYjlVxCT0KXAnTo9r8dJTseXaLtmCbffGchntfWfG9HPYBAoDmQLjQY+DsRk2G5yYYH9OgS2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CO52hiSiUilkcsoj1jIetSWOMIzQto97DR93y4RSA9s=;
 b=Mj2MCYhStezd7/ay01qoUOdDfLq0AT0y3Gs2jUyZtM4k5rpAKY0P0Q391Szz7RDwtgylqqIuOh1KpZm26uUz9r88pxwQjKWArqNTycMGANImcoE8KkNrZczMZoxhYmWs++Pdf9VaIBJ83Eb7j1a8Fa/vPWM1meXCOBEuqSXzMEAnWAelxEvDx02G2lcbKrYKVwaSoxdLFPKlW861RMQJZlHdgcvxoZ6XqMBNHFyCFQUiVotYiUfqor3AJyv5FnAziLiDcyGpiQWPz/inv3b8pFJoxGUiHzZKVMMUvawT6N7sQLpUZabA5tPRLrcHz4VlQbemHpG7IvREPA4r+eZ0yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CO52hiSiUilkcsoj1jIetSWOMIzQto97DR93y4RSA9s=;
 b=T1I1HHF3gRUWLocvg8fBtBCMqkZjOXuj+0kkJO0CKb0FOPJl+wQwpjVRRKdrxRoYe4STXP0fqU8fV+J9Si4gkUegyCEwdNlkDQ3xJr9fvYVWUWZ0OfxqLp8MSHj7bE80+HC0gr7d9NYudpiOhZYVE7Fyx/E5lA132KhzqA9WuYU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2800.eurprd04.prod.outlook.com (2603:10a6:800:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Tue, 10 Aug
 2021 16:15:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 16:15:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>
Subject: [RFC PATCH v2 net-next 7/8] net: dsa: convert cross-chip notifiers to iterate using dp
Date:   Tue, 10 Aug 2021 19:14:47 +0300
Message-Id: <20210810161448.1879192-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810161448.1879192-1-vladimir.oltean@nxp.com>
References: <20210810161448.1879192-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0031.eurprd05.prod.outlook.com (2603:10a6:205::44)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM4PR05CA0031.eurprd05.prod.outlook.com (2603:10a6:205::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 16:15:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 397d52b3-87aa-48b3-82fc-08d95c1a08da
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2800:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28000AC7B93FA06BF451BBABE0F79@VI1PR0402MB2800.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S2g6kF0yEO/uhGsbvn2IgA7iqhlwB2o8R4iZVwZWFDCquV1Y8W4BNm0JjgCb4+kvnoCxk99Phz0USBFS6CNojLFtNsk+wShs/JHJMPThkZyb4qRHdP+z3nC4usN2RdN+rYo7SZ2deqmvzBv/vEEvE0w0Cbe9zTUeEoXZVFYjEYyO+/wQ6YkIvcZ1UIbz5ETXf1l6QizE61FYeaEqYNT/99Tz5UG5yEJAmSiYHQH3nkzyHU6Drg/Fgc1qS8zrmmWlyvqlp4/00RLTGF77haD7J3WQ4DvvZOHdVzfWctPV5KSJk8q+fEBoH+gHNBkSzkjsyv0YLleJDVSu1cw8W7YyAH4DJXPDIMerRO4YkFv1UVFRBGlZrWEoW+XefLnD+I+tHaJ5Gml3iDqCDMNEgPFuxY1vja6H6S9tEsmcbROWO7S/87qyxBMEnLP+5TMxLCbsK/GE0POwxttDoB64FdPTVWiEu+p0sQxRWNnOBkhUTjaEFgxgak9vg0rKHJ/lhgBRCAZOX+dwd3MiF4iZBqEDz5npa0zFNEO8G37gUFf9jo7fbxV0AKNWf3SJ6uWnnD6xk5faZ01cxgDliGS0EawU8uDh/iJQkH0QMaY4VKJ1RuNtq2Wm/2gR8vL33SJ07PLI1r7gC3lG7wZsHnNBtNvuIZ/VdzQdQdfx7KrD69W6Z0+gQaHVzUXxlcYU9TtiKg6N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(6506007)(52116002)(6512007)(86362001)(110136005)(478600001)(8676002)(2906002)(956004)(83380400001)(54906003)(26005)(1076003)(8936002)(6486002)(316002)(36756003)(7416002)(30864003)(186003)(66946007)(5660300002)(66556008)(66476007)(44832011)(2616005)(6666004)(4326008)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KUHPvd2a1LmciRJowuXONiyblncN9kx8uT/z0s6cwK78a/wjXAZLKwxWI8Ty?=
 =?us-ascii?Q?y4UmxyBbQ1/jMYFmlACQWTN2FswQ4JcLm6PWY/qItTNSlZgFMYg68gYgD9Ya?=
 =?us-ascii?Q?JlxHIDZ0BPiJjxI6wog8bHo5KLEsiAsCMpybZznQWfdnxUvVlZvPg7Yr4hU+?=
 =?us-ascii?Q?97ZNZhJ4PJKoehCo9e33WZ9DCWVVmG/Wa60N/IJKU3qJevGrDLhU+0gEQr+G?=
 =?us-ascii?Q?VErT7MRPyoKL85o5hvwFoUCdWWvaZOOFRovrfoIhBb+0l+MQ8Lc+chE6ITqE?=
 =?us-ascii?Q?ffpYRPDscdgmzt0JleJvW/TrgwGrfqyvrmTjjJ552IfGrCGpchM1IsT0959d?=
 =?us-ascii?Q?Q+2hCSeOJcTzlhyWdl8YqysuNzTr67zuy5BZ7uOp16wutMFGgR6BmmRWN3S3?=
 =?us-ascii?Q?3xdDY80Ict4drZS5LF2UJuaKnwnn9O70DQrEnUnqYLkbdto0HHyByxKFrFcC?=
 =?us-ascii?Q?qMHVvlF9tzKiIAU6xTTcvUoQMYP2yF3MJoybUbc1LfatiPt+60Y6oYeT1Nhg?=
 =?us-ascii?Q?pBXvw+aTrPG5g0J7iju3rFvWdECcU510D04wLa/EeLcQw5Nxd0dNQFLQhbNz?=
 =?us-ascii?Q?+s/PWNjvJGfjIV8TG8tCuf6Mf/lc9Jj1EgZcjr6yQhgO6dbNN6w8nqyVU3gX?=
 =?us-ascii?Q?Ml5hUMMiWsrjtLA4nklr1BcuRV54hQcfb2XpXimP2haayplA+XF2WtXtFha5?=
 =?us-ascii?Q?GCT3GZWfhEcusK0xHdKvMuekqMFMvYqG5CuQE8UJ+o0i7jzT0j+PXPGmNOF7?=
 =?us-ascii?Q?K2j9Vg8tJaKA253J8+v89D4TXI/brg4FdXnXIBJ15I6/hPfI2aTlAzeen3wv?=
 =?us-ascii?Q?5E6GPC6EYLt5yOUJL/vPh64v/odImKQjAnfd3DByebBXeBothec7vDJT+PHN?=
 =?us-ascii?Q?2zFodO/CWHgLgKFn9Z7A0g82VvgMXddmZ6yPNM8JRRVAthrGG/5CkK/2gJMm?=
 =?us-ascii?Q?rEJTsk1j4XukCcWadiK+mSISIVZ+8WT/kPV+HIa14nwpXpMnhqx6mUz6o0V9?=
 =?us-ascii?Q?EvJCXxxaIkCL2Y6lGyEOPQZrQFMGRywM+XevtpJUHECEFjsYM8va5QorXtPC?=
 =?us-ascii?Q?s/IVS27YMENHr8ePopltL/GO8DtIsyBptnwKBPO6RN1D5P/LMtUFfFYh/6qo?=
 =?us-ascii?Q?5qPfB0F43GZDqb0DAxysbrMRdNaCHkiwbYsC3INVTqr53hyDsYs/72DwPbrj?=
 =?us-ascii?Q?rMaff+zg0HfzB1Hv2fMWVoSMCOM+bqg3NJsAgbSQ+QqholXyASXMkfpt6hgR?=
 =?us-ascii?Q?5Ev/9p7huGzoAI+xoYstfwoGtXWPegy06TaoWQQwAUpVwdhJowrcE4uPcIWR?=
 =?us-ascii?Q?zVSCVhNuvGgstrbLYrzFHaGD?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 397d52b3-87aa-48b3-82fc-08d95c1a08da
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 16:15:13.8987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H5D241XEdodj1dpz4t+2x3k7eGIpj3HmyHLMwAB2q7oQut9ROOvZ719vpQcrDP5x65vl/5D96sYNLdcznHqtMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2800
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The majority of cross-chip switch notifiers need to filter in some way
over the type of ports: some install VLANs etc on all cascade ports.

The difference is that the matching function, which filters by port
type, is separate from the function where the iteration happens. So this
patch needs to refactor the matching functions' prototypes as well, to
take the dp as argument.

In a future patch/series, I might convert dsa_towards_port to return a
struct dsa_port *dp too, but at the moment it is a bit entangled with
dsa_routing_port which is also used by mv88e6xxx and they both return an
int port. So keep dsa_towards_port the way it is and convert it into a
dp using dsa_to_port.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 net/dsa/switch.c    | 129 +++++++++++++++++++++++---------------------
 net/dsa/tag_8021q.c |  53 +++++++++---------
 2 files changed, 97 insertions(+), 85 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 5ddcf37ecfa5..b18480f333bb 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -46,10 +46,10 @@ static int dsa_switch_ageing_time(struct dsa_switch *ds,
 	return 0;
 }
 
-static bool dsa_switch_mtu_match(struct dsa_switch *ds, int port,
-				 struct dsa_notifier_mtu_info *info)
+static bool dsa_port_mtu_match(struct dsa_port *dp,
+			       struct dsa_notifier_mtu_info *info)
 {
-	if (ds->index == info->sw_index && port == info->port)
+	if (dp->ds->index == info->sw_index && dp->index == info->port)
 		return true;
 
 	/* Do not propagate to other switches in the tree if the notifier was
@@ -58,7 +58,7 @@ static bool dsa_switch_mtu_match(struct dsa_switch *ds, int port,
 	if (info->targeted_match)
 		return false;
 
-	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
+	if (dsa_port_is_dsa(dp) || dsa_port_is_cpu(dp))
 		return true;
 
 	return false;
@@ -67,14 +67,16 @@ static bool dsa_switch_mtu_match(struct dsa_switch *ds, int port,
 static int dsa_switch_mtu(struct dsa_switch *ds,
 			  struct dsa_notifier_mtu_info *info)
 {
-	int port, ret;
+	struct dsa_port *dp;
+	int ret;
 
 	if (!ds->ops->port_change_mtu)
 		return -EOPNOTSUPP;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_mtu_match(ds, port, info)) {
-			ret = ds->ops->port_change_mtu(ds, port, info->mtu);
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_mtu_match(dp, info)) {
+			ret = ds->ops->port_change_mtu(ds, dp->index,
+						       info->mtu);
 			if (ret)
 				return ret;
 		}
@@ -164,19 +166,19 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
  * DSA links) that sit between the targeted port on which the notifier was
  * emitted and its dedicated CPU port.
  */
-static bool dsa_switch_host_address_match(struct dsa_switch *ds, int port,
-					  int info_sw_index, int info_port)
+static bool dsa_port_host_address_match(struct dsa_port *dp,
+					int info_sw_index, int info_port)
 {
 	struct dsa_port *targeted_dp, *cpu_dp;
 	struct dsa_switch *targeted_ds;
 
-	targeted_ds = dsa_switch_find(ds->dst->index, info_sw_index);
+	targeted_ds = dsa_switch_find(dp->ds->dst->index, info_sw_index);
 	targeted_dp = dsa_to_port(targeted_ds, info_port);
 	cpu_dp = targeted_dp->cpu_dp;
 
-	if (dsa_switch_is_upstream_of(ds, targeted_ds))
-		return port == dsa_towards_port(ds, cpu_dp->ds->index,
-						cpu_dp->index);
+	if (dsa_switch_is_upstream_of(dp->ds, targeted_ds))
+		return dp->index == dsa_towards_port(dp->ds, cpu_dp->ds->index,
+						     cpu_dp->index);
 
 	return false;
 }
@@ -194,11 +196,12 @@ static struct dsa_mac_addr *dsa_mac_addr_find(struct list_head *addr_list,
 	return NULL;
 }
 
-static int dsa_switch_do_mdb_add(struct dsa_switch *ds, int port,
-				 const struct switchdev_obj_port_mdb *mdb)
+static int dsa_port_do_mdb_add(struct dsa_port *dp,
+			       const struct switchdev_obj_port_mdb *mdb)
 {
-	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
+	int port = dp->index;
 	int err;
 
 	/* No need to bother with refcounting for user ports */
@@ -229,11 +232,12 @@ static int dsa_switch_do_mdb_add(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int dsa_switch_do_mdb_del(struct dsa_switch *ds, int port,
-				 const struct switchdev_obj_port_mdb *mdb)
+static int dsa_port_do_mdb_del(struct dsa_port *dp,
+			       const struct switchdev_obj_port_mdb *mdb)
 {
-	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
+	int port = dp->index;
 	int err;
 
 	/* No need to bother with refcounting for user ports */
@@ -259,11 +263,12 @@ static int dsa_switch_do_mdb_del(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int dsa_switch_do_fdb_add(struct dsa_switch *ds, int port,
-				 const unsigned char *addr, u16 vid)
+static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
+			       u16 vid)
 {
-	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
+	int port = dp->index;
 	int err;
 
 	/* No need to bother with refcounting for user ports */
@@ -294,11 +299,12 @@ static int dsa_switch_do_fdb_add(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int dsa_switch_do_fdb_del(struct dsa_switch *ds, int port,
-				 const unsigned char *addr, u16 vid)
+static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+			       u16 vid)
 {
-	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
+	int port = dp->index;
 	int err;
 
 	/* No need to bother with refcounting for user ports */
@@ -327,17 +333,16 @@ static int dsa_switch_do_fdb_del(struct dsa_switch *ds, int port,
 static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 				   struct dsa_notifier_fdb_info *info)
 {
+	struct dsa_port *dp;
 	int err = 0;
-	int port;
 
 	if (!ds->ops->port_fdb_add)
 		return -EOPNOTSUPP;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_host_address_match(ds, port, info->sw_index,
-						  info->port)) {
-			err = dsa_switch_do_fdb_add(ds, port, info->addr,
-						    info->vid);
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_host_address_match(dp, info->sw_index,
+						info->port)) {
+			err = dsa_port_do_fdb_add(dp, info->addr, info->vid);
 			if (err)
 				break;
 		}
@@ -349,17 +354,16 @@ static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 static int dsa_switch_host_fdb_del(struct dsa_switch *ds,
 				   struct dsa_notifier_fdb_info *info)
 {
+	struct dsa_port *dp;
 	int err = 0;
-	int port;
 
 	if (!ds->ops->port_fdb_del)
 		return -EOPNOTSUPP;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_host_address_match(ds, port, info->sw_index,
-						  info->port)) {
-			err = dsa_switch_do_fdb_del(ds, port, info->addr,
-						    info->vid);
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_host_address_match(dp, info->sw_index,
+						info->port)) {
+			err = dsa_port_do_fdb_del(dp, info->addr, info->vid);
 			if (err)
 				break;
 		}
@@ -372,22 +376,24 @@ static int dsa_switch_fdb_add(struct dsa_switch *ds,
 			      struct dsa_notifier_fdb_info *info)
 {
 	int port = dsa_towards_port(ds, info->sw_index, info->port);
+	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (!ds->ops->port_fdb_add)
 		return -EOPNOTSUPP;
 
-	return dsa_switch_do_fdb_add(ds, port, info->addr, info->vid);
+	return dsa_port_do_fdb_add(dp, info->addr, info->vid);
 }
 
 static int dsa_switch_fdb_del(struct dsa_switch *ds,
 			      struct dsa_notifier_fdb_info *info)
 {
 	int port = dsa_towards_port(ds, info->sw_index, info->port);
+	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (!ds->ops->port_fdb_del)
 		return -EOPNOTSUPP;
 
-	return dsa_switch_do_fdb_del(ds, port, info->addr, info->vid);
+	return dsa_port_do_fdb_del(dp, info->addr, info->vid);
 }
 
 static int dsa_switch_hsr_join(struct dsa_switch *ds,
@@ -453,37 +459,39 @@ static int dsa_switch_mdb_add(struct dsa_switch *ds,
 			      struct dsa_notifier_mdb_info *info)
 {
 	int port = dsa_towards_port(ds, info->sw_index, info->port);
+	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (!ds->ops->port_mdb_add)
 		return -EOPNOTSUPP;
 
-	return dsa_switch_do_mdb_add(ds, port, info->mdb);
+	return dsa_port_do_mdb_add(dp, info->mdb);
 }
 
 static int dsa_switch_mdb_del(struct dsa_switch *ds,
 			      struct dsa_notifier_mdb_info *info)
 {
 	int port = dsa_towards_port(ds, info->sw_index, info->port);
+	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (!ds->ops->port_mdb_del)
 		return -EOPNOTSUPP;
 
-	return dsa_switch_do_mdb_del(ds, port, info->mdb);
+	return dsa_port_do_mdb_del(dp, info->mdb);
 }
 
 static int dsa_switch_host_mdb_add(struct dsa_switch *ds,
 				   struct dsa_notifier_mdb_info *info)
 {
+	struct dsa_port *dp;
 	int err = 0;
-	int port;
 
 	if (!ds->ops->port_mdb_add)
 		return -EOPNOTSUPP;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_host_address_match(ds, port, info->sw_index,
-						  info->port)) {
-			err = dsa_switch_do_mdb_add(ds, port, info->mdb);
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_host_address_match(dp, info->sw_index,
+						info->port)) {
+			err = dsa_port_do_mdb_add(dp, info->mdb);
 			if (err)
 				break;
 		}
@@ -495,16 +503,16 @@ static int dsa_switch_host_mdb_add(struct dsa_switch *ds,
 static int dsa_switch_host_mdb_del(struct dsa_switch *ds,
 				   struct dsa_notifier_mdb_info *info)
 {
+	struct dsa_port *dp;
 	int err = 0;
-	int port;
 
 	if (!ds->ops->port_mdb_del)
 		return -EOPNOTSUPP;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_host_address_match(ds, port, info->sw_index,
-						  info->port)) {
-			err = dsa_switch_do_mdb_del(ds, port, info->mdb);
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_host_address_match(dp, info->sw_index,
+						info->port)) {
+			err = dsa_port_do_mdb_del(dp, info->mdb);
 			if (err)
 				break;
 		}
@@ -513,13 +521,13 @@ static int dsa_switch_host_mdb_del(struct dsa_switch *ds,
 	return err;
 }
 
-static bool dsa_switch_vlan_match(struct dsa_switch *ds, int port,
-				  struct dsa_notifier_vlan_info *info)
+static bool dsa_port_vlan_match(struct dsa_port *dp,
+				struct dsa_notifier_vlan_info *info)
 {
-	if (ds->index == info->sw_index && port == info->port)
+	if (dp->ds->index == info->sw_index && dp->index == info->port)
 		return true;
 
-	if (dsa_is_dsa_port(ds, port))
+	if (dsa_port_is_dsa(dp))
 		return true;
 
 	return false;
@@ -528,14 +536,15 @@ static bool dsa_switch_vlan_match(struct dsa_switch *ds, int port,
 static int dsa_switch_vlan_add(struct dsa_switch *ds,
 			       struct dsa_notifier_vlan_info *info)
 {
-	int port, err;
+	struct dsa_port *dp;
+	int err;
 
 	if (!ds->ops->port_vlan_add)
 		return -EOPNOTSUPP;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_vlan_match(ds, port, info)) {
-			err = ds->ops->port_vlan_add(ds, port, info->vlan,
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_vlan_match(dp, info)) {
+			err = ds->ops->port_vlan_add(ds, dp->index, info->vlan,
 						     info->extack);
 			if (err)
 				return err;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index b29f4eb9aed1..8e4fbbfc6d86 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -139,12 +139,13 @@ dsa_tag_8021q_vlan_find(struct dsa_8021q_context *ctx, int port, u16 vid)
 	return NULL;
 }
 
-static int dsa_switch_do_tag_8021q_vlan_add(struct dsa_switch *ds, int port,
-					    u16 vid, u16 flags)
+static int dsa_port_do_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid,
+					  u16 flags)
 {
-	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
-	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_8021q_context *ctx = dp->ds->tag_8021q_ctx;
+	struct dsa_switch *ds = dp->ds;
 	struct dsa_tag_8021q_vlan *v;
+	int port = dp->index;
 	int err;
 
 	/* No need to bother with refcounting for user ports */
@@ -175,12 +176,12 @@ static int dsa_switch_do_tag_8021q_vlan_add(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int dsa_switch_do_tag_8021q_vlan_del(struct dsa_switch *ds, int port,
-					    u16 vid)
+static int dsa_port_do_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid)
 {
-	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
-	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_8021q_context *ctx = dp->ds->tag_8021q_ctx;
+	struct dsa_switch *ds = dp->ds;
 	struct dsa_tag_8021q_vlan *v;
+	int port = dp->index;
 	int err;
 
 	/* No need to bother with refcounting for user ports */
@@ -207,14 +208,16 @@ static int dsa_switch_do_tag_8021q_vlan_del(struct dsa_switch *ds, int port,
 }
 
 static bool
-dsa_switch_tag_8021q_vlan_match(struct dsa_switch *ds, int port,
-				struct dsa_notifier_tag_8021q_vlan_info *info)
+dsa_port_tag_8021q_vlan_match(struct dsa_port *dp,
+			      struct dsa_notifier_tag_8021q_vlan_info *info)
 {
-	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
+	struct dsa_switch *ds = dp->ds;
+
+	if (dsa_port_is_dsa(dp) || dsa_port_is_cpu(dp))
 		return true;
 
 	if (ds->dst->index == info->tree_index && ds->index == info->sw_index)
-		return port == info->port;
+		return dp->index == info->port;
 
 	return false;
 }
@@ -222,7 +225,8 @@ dsa_switch_tag_8021q_vlan_match(struct dsa_switch *ds, int port,
 int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
 				  struct dsa_notifier_tag_8021q_vlan_info *info)
 {
-	int port, err;
+	struct dsa_port *dp;
+	int err;
 
 	/* Since we use dsa_broadcast(), there might be other switches in other
 	 * trees which don't support tag_8021q, so don't return an error.
@@ -232,21 +236,20 @@ int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
 	if (!ds->ops->tag_8021q_vlan_add || !ds->tag_8021q_ctx)
 		return 0;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_tag_8021q_vlan_match(ds, port, info)) {
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_tag_8021q_vlan_match(dp, info)) {
 			u16 flags = 0;
 
-			if (dsa_is_user_port(ds, port))
+			if (dsa_port_is_user(dp))
 				flags |= BRIDGE_VLAN_INFO_UNTAGGED;
 
 			if (vid_is_dsa_8021q_rxvlan(info->vid) &&
 			    dsa_8021q_rx_switch_id(info->vid) == ds->index &&
-			    dsa_8021q_rx_source_port(info->vid) == port)
+			    dsa_8021q_rx_source_port(info->vid) == dp->index)
 				flags |= BRIDGE_VLAN_INFO_PVID;
 
-			err = dsa_switch_do_tag_8021q_vlan_add(ds, port,
-							       info->vid,
-							       flags);
+			err = dsa_port_do_tag_8021q_vlan_add(dp, info->vid,
+							     flags);
 			if (err)
 				return err;
 		}
@@ -258,15 +261,15 @@ int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
 int dsa_switch_tag_8021q_vlan_del(struct dsa_switch *ds,
 				  struct dsa_notifier_tag_8021q_vlan_info *info)
 {
-	int port, err;
+	struct dsa_port *dp;
+	int err;
 
 	if (!ds->ops->tag_8021q_vlan_del || !ds->tag_8021q_ctx)
 		return 0;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_tag_8021q_vlan_match(ds, port, info)) {
-			err = dsa_switch_do_tag_8021q_vlan_del(ds, port,
-							       info->vid);
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_tag_8021q_vlan_match(dp, info)) {
+			err = dsa_port_do_tag_8021q_vlan_del(dp, info->vid);
 			if (err)
 				return err;
 		}
-- 
2.25.1

