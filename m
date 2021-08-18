Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A123F0337
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235943AbhHRMFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:05:06 -0400
Received: from mail-vi1eur05on2074.outbound.protection.outlook.com ([40.107.21.74]:54881
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235777AbhHRMEY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:04:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JRWxYJAYKm7saRXfdLOKWK807gvk5ESGdv883Q2yuEcSP0pu97Tdpg+ra0lEnBxZwkbGKmaEIG9ESK0JYqelnEbm+k8gMhDKzyJdLFuzYGpPQW/q9aT5SDncOeSOE/M9MFBliCwqIOM28xn0om2pQklUkWIXXfvKhYsvCz5XD1QF3K2Eez3x2b+wb/muW9XVIyvQRGnub8LeopnxE9IiWLecz8V2jm+3KN+roBfni45DKiFkXq0U7DTuz4vq2p6f1OdiVlZrl+6vcsaWpi9C0No80nSOerzAE3C+crufCWSRIwk+D95tlaG6Km5EgDZi6/fvFYvdDfp8CXFns+JJAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ODo0JS0elqK4hPdj/V22l/lGLA3U+49yyxv0r757FQ=;
 b=nNVd74nDZV7RnghOilipkmANXSiJvbiWWW4vwF6WuUOet0y8gtSElKhcfxUAHZ+8SsT0S1GphmyBgCylNh2/xBjI5SRghMxYnKsEZ5C/Qgm6LgAfHREj7JiaGjOYlHJlgfJtHCq/IPJ7jHwdSlv5ngcUODnc8qt6cUCUvu0IPPmmDsjmqgGEgC8f4SU4CJG6Rg7fsKvKB2ItrJRXaHtiiJCG/efwx9TqM/1cug6LXTbkEMqljut6q1IEmo/V8LDJeHHvwLa6NmPYqNLWBVY8G9iCDBV5+dNqV+dxDxBRhv1DQKycF80jO3QtSPI6m58ANa36Z6g48Jt15zkNO2a74g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ODo0JS0elqK4hPdj/V22l/lGLA3U+49yyxv0r757FQ=;
 b=hVFU3GpzTBbk7RE3LDb82MLEWyuqPX1kP3sOIQ59+P6B4XMvVjpiudZkG3Y5l9+scMh1GrcU12OKTvyOSo5RnW+uSMZ4V3RhXfQccdLci924N9HnZpu/CC53ZLnBLj8q+L3TEcO3zXORovfKRwHm7Bqgiy5Cu492rLYWWdmfRNg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Wed, 18 Aug
 2021 12:03:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:03:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [RFC PATCH net-next 20/20] net: mscc: ocelot: enforce FDB isolation when VLAN-unaware
Date:   Wed, 18 Aug 2021 15:01:50 +0300
Message-Id: <20210818120150.892647-21-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210818120150.892647-1-vladimir.oltean@nxp.com>
References: <20210818120150.892647-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0134.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:03:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15523605-49cc-4895-657c-08d962402acc
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4222E0392BACC76323300C36E0FF9@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AIrq/9GpBwm76SPGyLlIMtdyPpZ5/+zMZms3045dbjM0dAIU/lRdZ2sv62vC5WlhG0gVhrzVYWphYsA/XCAiJUkEfuh8Vn+MQLjtJePM7WGFVCaSO8rJBTLDrMvjZkVuMESDWMDzKSam1tYFjhIJekbeNJ+DkWvTzV4I83bJcyg71h5f2DpdgmUcWwZR98/Tvh7euxos9z5Dy6wZNaHRo8wK+31OwTb9FSI73m+o7LM9GCcn4dAMt9Nn7TlgrqzeBaOI1dqS7iRa6QqTmYO5LIWxmYYyrf/7J9lWnoFMxB/9Y0OMC3iHtTvUt1g0bMPAHSN8XHMxK55X7AfRBV/NGoOSYCrN4MOU+GNnZrHxNfmJEYJbNkqK8Buu0XGbOTa5koWXW3YdqUGBuaRtMf4GAfTr9aGqPwv1ZyedNgo16uiVrHWc2aNIvQEJS6QMHGa/u8+kcDIgzewVJ2V27UOi3PyFKKWGj1HWyQIXZFZqHO9anBscsIK80e7FKBvXaFjRX4XTRmm45iJawfi8ejMyqcIVXUhRKsjtIvzaPuUlPj9nDwQSQ2NYkXj02G+nHZDkCyTX37zgcysR0w/MObr1DFQT1c/6zZQZV7j78ugyLMgV3WS+OOkDxo5vu4vFGTmj5khR6Z715FkGuXTagUSc366cxLSz+mpn77p/ii+wXzdw5aqLZR/jtIOR1bF0TnVLVABJGAD5rPpzl0ygtlmPaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(366004)(376002)(6486002)(52116002)(2616005)(44832011)(4326008)(5660300002)(26005)(1076003)(6666004)(54906003)(956004)(6512007)(6506007)(186003)(38350700002)(30864003)(38100700002)(86362001)(36756003)(110136005)(316002)(83380400001)(8936002)(478600001)(8676002)(66476007)(7416002)(7406005)(66946007)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x1x2oF0fST3JmFvRtJXnZqPu4bnmE4T7TMBJKfKcuC29Znkn4lEv6T/fR1iQ?=
 =?us-ascii?Q?fGagYi95OhCnI3mR3nLqrIzzEKzoOG4jIK4Ofbsyvch3Vrs6r770FdSd51xR?=
 =?us-ascii?Q?OLWBL9TFH7273/4AWLq+uiSK3AMa87HpVLF9Y3VeaAEpbWqXKrbQyHxgLfNp?=
 =?us-ascii?Q?Xa+h/Vnycf203LNREUKVjnIZTFgvnfSc5PVpdJxu+SJyBfG/Zqt5Rr6SYWrJ?=
 =?us-ascii?Q?mooL67bfpdMRt+GT3kMI5M+7Y91wrNW95n+JCbRBpEu1EVrSs6DZ5/luxV4h?=
 =?us-ascii?Q?usl9N66/gT/7HDNi7g1unkN5M0wmuUXWAYWYcSotflkBNsqXz4aK4m5Zi2Oo?=
 =?us-ascii?Q?x80D4uGU8Y38Jk7+DS7SDXv2XC8KNkvnnYlDF/Y+xvoSv0r9IurUftXAexO2?=
 =?us-ascii?Q?qc6r/9d/NVXK74D5snypXea0t91ClVTDeYrfScgosai27iuB85DN5KH5NEey?=
 =?us-ascii?Q?b/rNZiuGOxq++fvj2ndtOgbMaxNEL/FjlHjsl6GuhqJvjqmwWkPrW8+EoJUU?=
 =?us-ascii?Q?C2w1oL5Sz7EvN29Of6178ZLzSzNxvTddMMJWvCqTQVxQxgcVVDgfGEhTFB4f?=
 =?us-ascii?Q?QGngasPG+bf5PKQyqU+47hkx6yRl1SO7FQbWiuycjAbLjwx/WyTgbIycsc5+?=
 =?us-ascii?Q?ZtZHsrMxUgWHwO14paFTJIy0dZ8MAcUlu+Q0dZ1hidGXRukv+3j9RDK1dGox?=
 =?us-ascii?Q?zteFvvd+/3zChyr7ZXcUfRn1pQHy/8zVIHQIku1wKTe9i34k09C1TQxA2yHV?=
 =?us-ascii?Q?qzF7edxkTVgLRFybc0fTtXOPyXWCoh8j1I2hUhmDos9sK5eizIvrMGpyMszz?=
 =?us-ascii?Q?N+6G5oz7/N5r7dpcCRRSxQNWEV3rxD7D8rMKVAGEUK3fsH6vmJrUbe/slIIE?=
 =?us-ascii?Q?mYYScdUDpaCc4Hlot44tFnciLSpYNzvyt7SUZt6amtwBbB0hbKaRN9UiTMW3?=
 =?us-ascii?Q?3dKCUivBkob/aPdLl88tVJIirTSIPRb316xk2HXcl1odcIgIQFGVJExkvgWy?=
 =?us-ascii?Q?zy/wSv01uBDYRhIyplRHp0kqxb8hUxK4QdqtrVC9PIwLrVoqFj0h+zgbJ8tH?=
 =?us-ascii?Q?2PEnH0OTcyTnZHksw5+HAF2MLoA48mmLSOV8p3w2RNU8tOOFF1rJntl1cTns?=
 =?us-ascii?Q?4KpLlboJfDfwbYM/bAikbewcIQ564jQkoePtKeA9mcOlZlh5V1VvTj3b037q?=
 =?us-ascii?Q?+wS1pciKtX5x2PR8DenaO6InqrffdGfbSG+9DQzQVofMPI0fHLPqXuwHUU8I?=
 =?us-ascii?Q?pQsorCCEAKjffddkHnHPO05Jp/J6XVqEbF+GSyqMIvpJLTkI1SbrMzPIQWge?=
 =?us-ascii?Q?fEO6GhQC+LlXM/U4f7Sw8D6b?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15523605-49cc-4895-657c-08d962402acc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:03:18.8151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZVceol8OtYi23CIgSFoWljc3wd7E6JqbUpTaHgmGgVjM7tpS60iFR2chumm3J3oOJazCAxi03+ZYmFoDFtVR0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently ocelot uses a pvid of 0 for standalone ports and ports under a
VLAN-unaware bridge, and the pvid of the bridge for ports under a
VLAN-aware bridge. Standalone ports do not perform learning, but packets
received on them are still subject to FDB lookups. So if the MAC DA that
a standalone port receives has been also learned on a VLAN-unaware
bridge port, ocelot will attempt to forward to that port, even though it
can't, so it will drop packets.

So there is a desire to avoid that, and isolate the FDBs of different
bridges from one another, and from standalone ports.

The ocelot switch library has two distinct entry points: the felix DSA
driver and the ocelot switchdev driver.

We need to code up a minimal bridge_num allocation in the ocelot
switchdev driver too, this is copied from DSA with the exception that
ocelot does not care about DSA trees, cross-chip bridging etc. So it
only looks at its own ports that are already in the same bridge.

The ocelot switchdev driver uses the bridge_num it has allocated itself,
while the felix driver uses the bridge_num allocated by DSA. They are
both stored inside ocelot_port->bridge_num by the common function
ocelot_port_bridge_join() which receives the bridge_num passed by value.

Once we have a bridge_num, we can only use it to enforce isolation
between VLAN-unaware bridges. As far as I can see, ocelot does not have
anything like a FID that further makes VLAN 100 from a port be different
to VLAN 100 from another port with regard to FDB lookup. So we simply
deny multiple VLAN-aware bridges.

For VLAN-unaware bridges, we crop the 4000-4095 VLAN region and we
allocate a VLAN for each bridge_num. This will be used as the pvid of
each port that is under that VLAN-unaware bridge, for as long as that
bridge is VLAN-unaware.

VID 0 remains only for standalone ports. It is okay if all standalone
ports use the same VID 0, since they perform no address learning, the
FDB will contain no entry in VLAN 0, so the packets will always be
flooded to the only possible destination, the CPU port.

The CPU port module doesn't need to be member of the VLANs to receive
packets, but if we use the DSA tag_8021q protocol, those packets are
part of the data plane as far as ocelot is concerned, so there it needs
to. Just ensure that the DSA tag_8021q CPU port is a member of all
reserved VLANs when it is created, and is removed when it is deleted.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         |  16 +--
 drivers/net/ethernet/mscc/ocelot.c     | 182 +++++++++++++++++++++++--
 drivers/net/ethernet/mscc/ocelot.h     |   3 +
 drivers/net/ethernet/mscc/ocelot_net.c |  54 ++++++--
 include/soc/mscc/ocelot.h              |  25 ++--
 5 files changed, 244 insertions(+), 36 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index fdfb7954b203..f9eb4c628a59 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -233,7 +233,7 @@ static int felix_tag_8021q_vlan_del(struct dsa_switch *ds, int port, u16 vid)
  */
 static void felix_8021q_cpu_port_init(struct ocelot *ocelot, int port)
 {
-	ocelot->ports[port]->is_dsa_8021q_cpu = true;
+	ocelot_port_set_dsa_8021q_cpu(ocelot, port);
 	ocelot->npi = -1;
 
 	/* Overwrite PGID_CPU with the non-tagging port */
@@ -245,6 +245,7 @@ static void felix_8021q_cpu_port_init(struct ocelot *ocelot, int port)
 static void felix_8021q_cpu_port_deinit(struct ocelot *ocelot, int port)
 {
 	ocelot->ports[port]->is_dsa_8021q_cpu = false;
+	ocelot_port_unset_dsa_8021q_cpu(ocelot, port);
 
 	/* Restore PGID_CPU */
 	ocelot_write_rix(ocelot, BIT(ocelot->num_phys_ports), ANA_PGID_PGID,
@@ -633,7 +634,7 @@ static int felix_fdb_add(struct dsa_switch *ds, int port,
 {
 	struct ocelot *ocelot = ds->priv;
 
-	return ocelot_fdb_add(ocelot, port, addr, vid);
+	return ocelot_fdb_add(ocelot, port, addr, vid, br);
 }
 
 static int felix_fdb_del(struct dsa_switch *ds, int port,
@@ -642,7 +643,7 @@ static int felix_fdb_del(struct dsa_switch *ds, int port,
 {
 	struct ocelot *ocelot = ds->priv;
 
-	return ocelot_fdb_del(ocelot, port, addr, vid);
+	return ocelot_fdb_del(ocelot, port, addr, vid, br);
 }
 
 static int felix_mdb_add(struct dsa_switch *ds, int port,
@@ -651,7 +652,7 @@ static int felix_mdb_add(struct dsa_switch *ds, int port,
 {
 	struct ocelot *ocelot = ds->priv;
 
-	return ocelot_port_mdb_add(ocelot, port, mdb);
+	return ocelot_port_mdb_add(ocelot, port, mdb, br);
 }
 
 static int felix_mdb_del(struct dsa_switch *ds, int port,
@@ -660,7 +661,7 @@ static int felix_mdb_del(struct dsa_switch *ds, int port,
 {
 	struct ocelot *ocelot = ds->priv;
 
-	return ocelot_port_mdb_del(ocelot, port, mdb);
+	return ocelot_port_mdb_del(ocelot, port, mdb, br);
 }
 
 static void felix_bridge_stp_state_set(struct dsa_switch *ds, int port,
@@ -697,9 +698,7 @@ static int felix_bridge_join(struct dsa_switch *ds, int port,
 {
 	struct ocelot *ocelot = ds->priv;
 
-	ocelot_port_bridge_join(ocelot, port, br);
-
-	return 0;
+	return ocelot_port_bridge_join(ocelot, port, br, bridge_num, extack);
 }
 
 static void felix_bridge_leave(struct dsa_switch *ds, int port,
@@ -1128,6 +1127,7 @@ static int felix_setup(struct dsa_switch *ds)
 
 	ds->mtu_enforcement_ingress = true;
 	ds->assisted_learning_on_cpu_port = true;
+	ds->max_num_bridges = ds->num_ports;
 
 	return 0;
 
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index c581b955efb3..150b3d6d506a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -13,6 +13,7 @@
 
 #define TABLE_UPDATE_SLEEP_US 10
 #define TABLE_UPDATE_TIMEOUT_US 100000
+#define OCELOT_RSV_VLAN_RANGE_START 4000
 
 struct ocelot_mact_entry {
 	u8 mac[ETH_ALEN];
@@ -132,6 +133,35 @@ static void ocelot_vcap_enable(struct ocelot *ocelot, int port)
 		       REW_PORT_CFG, port);
 }
 
+static int ocelot_single_vlan_aware_bridge(struct ocelot *ocelot,
+					   struct netlink_ext_ack *extack)
+{
+	struct net_device *bridge = NULL;
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+		if (!ocelot_port || !ocelot_port->bridge ||
+		    !br_vlan_enabled(ocelot_port->bridge))
+			continue;
+
+		if (!bridge) {
+			bridge = ocelot_port->bridge;
+			continue;
+		}
+
+		if (bridge == ocelot_port->bridge)
+			continue;
+
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only one VLAN-aware bridge is supported");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
 static inline u32 ocelot_vlant_read_vlanaccess(struct ocelot *ocelot)
 {
 	return ocelot_read(ocelot, ANA_TABLES_VLANACCESS);
@@ -190,6 +220,39 @@ static void ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 		       REW_TAG_CFG, port);
 }
 
+int ocelot_bridge_num_find(struct ocelot *ocelot,
+			   const struct net_device *bridge)
+{
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+		if (ocelot_port && ocelot_port->bridge == bridge)
+			return ocelot_port->bridge_num;
+	}
+
+	return -1;
+}
+EXPORT_SYMBOL_GPL(ocelot_bridge_num_find);
+
+static u16 ocelot_vlan_unaware_pvid(struct ocelot *ocelot,
+				    const struct net_device *bridge)
+{
+	int bridge_num;
+
+	/* Standalone ports use VID 0 */
+	if (!bridge)
+		return 0;
+
+	bridge_num = ocelot_bridge_num_find(ocelot, bridge);
+	if (WARN_ON(bridge_num < 0))
+		return 0;
+
+	/* VLAN-unaware bridges use a reserved VID going from 4095 downwards */
+	return VLAN_N_VID - bridge_num - 1;
+}
+
 /* Default vlan to clasify for untagged frames (may be zero) */
 static void ocelot_port_set_pvid(struct ocelot *ocelot, int port,
 				 struct ocelot_vlan pvid_vlan)
@@ -200,7 +263,8 @@ static void ocelot_port_set_pvid(struct ocelot *ocelot, int port,
 	ocelot_port->pvid_vlan = pvid_vlan;
 
 	if (!ocelot_port->vlan_aware)
-		pvid_vlan.vid = 0;
+		pvid_vlan.vid = ocelot_vlan_unaware_pvid(ocelot,
+							 ocelot_port->bridge);
 
 	ocelot_rmw_gix(ocelot,
 		       ANA_PORT_VLAN_CFG_VLAN_VID(pvid_vlan.vid),
@@ -249,12 +313,29 @@ static int ocelot_vlan_member_del(struct ocelot *ocelot, int port, u16 vid)
 				      vid);
 }
 
+static int ocelot_add_vlan_unaware_pvid(struct ocelot *ocelot, int port,
+					const struct net_device *bridge)
+{
+	u16 vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
+
+	return ocelot_vlan_member_add(ocelot, port, vid);
+}
+
+static int ocelot_del_vlan_unaware_pvid(struct ocelot *ocelot, int port,
+					const struct net_device *bridge)
+{
+	u16 vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
+
+	return ocelot_vlan_member_del(ocelot, port, vid);
+}
+
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 			       bool vlan_aware, struct netlink_ext_ack *extack)
 {
 	struct ocelot_vcap_block *block = &ocelot->block[VCAP_IS1];
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	struct ocelot_vcap_filter *filter;
+	int err;
 	u32 val;
 
 	list_for_each_entry(filter, &block->rules, list) {
@@ -266,6 +347,19 @@ int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 		}
 	}
 
+	err = ocelot_single_vlan_aware_bridge(ocelot, extack);
+	if (err)
+		return err;
+
+	if (vlan_aware)
+		err = ocelot_del_vlan_unaware_pvid(ocelot, port,
+						   ocelot_port->bridge);
+	else
+		err = ocelot_add_vlan_unaware_pvid(ocelot, port,
+						   ocelot_port->bridge);
+	if (err)
+		return err;
+
 	ocelot_port->vlan_aware = vlan_aware;
 
 	if (vlan_aware)
@@ -298,6 +392,12 @@ int ocelot_vlan_prepare(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 		return -EBUSY;
 	}
 
+	if (vid > OCELOT_RSV_VLAN_RANGE_START) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "VLAN range 4000-4095 reserved for VLAN-unaware bridging");
+		return -EBUSY;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(ocelot_vlan_prepare);
@@ -374,9 +474,9 @@ static void ocelot_vlan_init(struct ocelot *ocelot)
 	for (vid = 1; vid < VLAN_N_VID; vid++)
 		ocelot_vlan_member_set(ocelot, 0, vid);
 
-	/* Because VLAN filtering is enabled, we need VID 0 to get untagged
-	 * traffic.  It is added automatically if 8021q module is loaded, but
-	 * we can't rely on it since module may be not loaded.
+	/* We need VID 0 to get traffic on standalone ports.
+	 * It is added automatically if the 8021q module is loaded, but we
+	 * can't rely on that since it might not be.
 	 */
 	ocelot_vlan_member_set(ocelot, all_ports, 0);
 
@@ -965,21 +1065,27 @@ void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp)
 }
 EXPORT_SYMBOL(ocelot_drain_cpu_queue);
 
-int ocelot_fdb_add(struct ocelot *ocelot, int port,
-		   const unsigned char *addr, u16 vid)
+int ocelot_fdb_add(struct ocelot *ocelot, int port, const unsigned char *addr,
+		   u16 vid, const struct net_device *bridge)
 {
 	int pgid = port;
 
 	if (port == ocelot->npi)
 		pgid = PGID_CPU;
 
+	if (!vid)
+		vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
+
 	return ocelot_mact_learn(ocelot, pgid, addr, vid, ENTRYTYPE_LOCKED);
 }
 EXPORT_SYMBOL(ocelot_fdb_add);
 
-int ocelot_fdb_del(struct ocelot *ocelot, int port,
-		   const unsigned char *addr, u16 vid)
+int ocelot_fdb_del(struct ocelot *ocelot, int port, const unsigned char *addr,
+		   u16 vid, const struct net_device *bridge)
 {
+	if (!vid)
+		vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
+
 	return ocelot_mact_forget(ocelot, addr, vid);
 }
 EXPORT_SYMBOL(ocelot_fdb_del);
@@ -1098,6 +1204,12 @@ int ocelot_fdb_dump(struct ocelot *ocelot, int port,
 
 			is_static = (entry.type == ENTRYTYPE_LOCKED);
 
+			/* Hide the reserved VLANs used for
+			 * VLAN-unaware bridging.
+			 */
+			if (entry.vid > OCELOT_RSV_VLAN_RANGE_START)
+				entry.vid = 0;
+
 			ret = cb(entry.mac, entry.vid, is_static, data);
 			if (ret)
 				return ret;
@@ -1396,6 +1508,28 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 }
 EXPORT_SYMBOL(ocelot_apply_bridge_fwd_mask);
 
+void ocelot_port_set_dsa_8021q_cpu(struct ocelot *ocelot, int port)
+{
+	u16 vid;
+
+	ocelot->ports[port]->is_dsa_8021q_cpu = true;
+
+	for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
+		ocelot_vlan_member_add(ocelot, port, vid);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_set_dsa_8021q_cpu);
+
+void ocelot_port_unset_dsa_8021q_cpu(struct ocelot *ocelot, int port)
+{
+	u16 vid;
+
+	ocelot->ports[port]->is_dsa_8021q_cpu = false;
+
+	for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
+		ocelot_vlan_member_del(ocelot, port, vid);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_unset_dsa_8021q_cpu);
+
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -1536,7 +1670,8 @@ static void ocelot_encode_ports_to_mdb(unsigned char *addr,
 }
 
 int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
-			const struct switchdev_obj_port_mdb *mdb)
+			const struct switchdev_obj_port_mdb *mdb,
+			const struct net_device *bridge)
 {
 	unsigned char addr[ETH_ALEN];
 	struct ocelot_multicast *mc;
@@ -1546,6 +1681,9 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 	if (port == ocelot->npi)
 		port = ocelot->num_phys_ports;
 
+	if (!vid)
+		vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
+
 	mc = ocelot_multicast_get(ocelot, mdb->addr, vid);
 	if (!mc) {
 		/* New entry */
@@ -1592,7 +1730,8 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 EXPORT_SYMBOL(ocelot_port_mdb_add);
 
 int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
-			const struct switchdev_obj_port_mdb *mdb)
+			const struct switchdev_obj_port_mdb *mdb,
+			const struct net_device *bridge)
 {
 	unsigned char addr[ETH_ALEN];
 	struct ocelot_multicast *mc;
@@ -1602,6 +1741,9 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 	if (port == ocelot->npi)
 		port = ocelot->num_phys_ports;
 
+	if (!vid)
+		vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
+
 	mc = ocelot_multicast_get(ocelot, mdb->addr, vid);
 	if (!mc)
 		return -ENOENT;
@@ -1635,14 +1777,26 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_port_mdb_del);
 
-void ocelot_port_bridge_join(struct ocelot *ocelot, int port,
-			     struct net_device *bridge)
+int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
+			    struct net_device *bridge, int bridge_num,
+			    struct netlink_ext_ack *extack)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	int err;
+
+	err = ocelot_single_vlan_aware_bridge(ocelot, extack);
+	if (err)
+		return err;
 
 	ocelot_port->bridge = bridge;
+	ocelot_port->bridge_num = bridge_num;
 
 	ocelot_apply_bridge_fwd_mask(ocelot);
+
+	if (br_vlan_enabled(bridge))
+		return 0;
+
+	return ocelot_add_vlan_unaware_pvid(ocelot, port, bridge);
 }
 EXPORT_SYMBOL(ocelot_port_bridge_join);
 
@@ -1652,7 +1806,11 @@ void ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	struct ocelot_vlan pvid = {0}, native_vlan = {0};
 
+	if (!br_vlan_enabled(bridge))
+		ocelot_del_vlan_unaware_pvid(ocelot, port, bridge);
+
 	ocelot_port->bridge = NULL;
+	ocelot_port->bridge_num = -1;
 
 	ocelot_port_set_pvid(ocelot, port, pvid);
 	ocelot_port_set_native_vlan(ocelot, port, native_vlan);
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 1952d6a1b98a..d90153f112a6 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -90,6 +90,9 @@ struct ocelot_multicast {
 	struct ocelot_pgid *pgid;
 };
 
+int ocelot_bridge_num_find(struct ocelot *ocelot,
+			   const struct net_device *bridge);
+
 int ocelot_port_fdb_do_dump(const unsigned char *addr, u16 vid,
 			    bool is_static, void *data);
 int ocelot_mact_learn(struct ocelot *ocelot, int port,
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index d255ab2c2848..15b26fbfe227 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -654,10 +654,11 @@ static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 			       struct netlink_ext_ack *extack)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;
 
-	return ocelot_fdb_add(ocelot, port, addr, vid);
+	return ocelot_fdb_add(ocelot, port, addr, vid, ocelot_port->bridge);
 }
 
 static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
@@ -665,10 +666,11 @@ static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 			       const unsigned char *addr, u16 vid)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;
 
-	return ocelot_fdb_del(ocelot, port, addr, vid);
+	return ocelot_fdb_del(ocelot, port, addr, vid, ocelot_port->bridge);
 }
 
 static int ocelot_port_fdb_dump(struct sk_buff *skb,
@@ -967,7 +969,7 @@ static int ocelot_port_obj_add_mdb(struct net_device *dev,
 	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;
 
-	return ocelot_port_mdb_add(ocelot, port, mdb);
+	return ocelot_port_mdb_add(ocelot, port, mdb, ocelot_port->bridge);
 }
 
 static int ocelot_port_obj_del_mdb(struct net_device *dev,
@@ -978,7 +980,7 @@ static int ocelot_port_obj_del_mdb(struct net_device *dev,
 	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;
 
-	return ocelot_port_mdb_del(ocelot, port, mdb);
+	return ocelot_port_mdb_del(ocelot, port, mdb, ocelot_port->bridge);
 }
 
 static int ocelot_port_obj_mrp_add(struct net_device *dev,
@@ -1152,6 +1154,33 @@ static int ocelot_switchdev_unsync(struct ocelot *ocelot, int port)
 	return 0;
 }
 
+static int ocelot_bridge_num_get(struct ocelot *ocelot,
+				 const struct net_device *bridge_dev)
+{
+	int bridge_num = ocelot_bridge_num_find(ocelot, bridge_dev);
+
+	if (bridge_num < 0) {
+		/* First port that offloads this bridge */
+		bridge_num = find_first_zero_bit(&ocelot->bridges,
+						 ocelot->num_phys_ports);
+
+		set_bit(bridge_num, &ocelot->bridges);
+	}
+
+	return bridge_num;
+}
+
+static void ocelot_bridge_num_put(struct ocelot *ocelot,
+				  const struct net_device *bridge_dev,
+				  int bridge_num)
+{
+	/* Check if the bridge is still in use, otherwise it is time
+	 * to clean it up so we can reuse this bridge_num later.
+	 */
+	if (!ocelot_bridge_num_find(ocelot, bridge_dev))
+		clear_bit(bridge_num, &ocelot->bridges);
+}
+
 static int ocelot_netdevice_bridge_join(struct net_device *dev,
 					struct net_device *brport_dev,
 					struct net_device *bridge,
@@ -1161,9 +1190,14 @@ static int ocelot_netdevice_bridge_join(struct net_device *dev,
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;
-	int err;
+	int bridge_num, err;
 
-	ocelot_port_bridge_join(ocelot, port, bridge);
+	bridge_num = ocelot_bridge_num_get(ocelot, bridge);
+
+	err = ocelot_port_bridge_join(ocelot, port, bridge, bridge_num,
+				      extack);
+	if (err)
+		goto err_join;
 
 	err = switchdev_bridge_port_offload(brport_dev, dev, priv,
 					    &ocelot_switchdev_blocking_nb,
@@ -1182,6 +1216,8 @@ static int ocelot_netdevice_bridge_join(struct net_device *dev,
 					&ocelot_switchdev_blocking_nb);
 err_switchdev_offload:
 	ocelot_port_bridge_leave(ocelot, port, bridge);
+err_join:
+	ocelot_bridge_num_put(ocelot, bridge, bridge_num);
 	return err;
 }
 
@@ -1201,6 +1237,7 @@ static int ocelot_netdevice_bridge_leave(struct net_device *dev,
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
+	int bridge_num = ocelot_port->bridge_num;
 	int port = priv->chip_port;
 	int err;
 
@@ -1209,6 +1246,7 @@ static int ocelot_netdevice_bridge_leave(struct net_device *dev,
 		return err;
 
 	ocelot_port_bridge_leave(ocelot, port, bridge);
+	ocelot_bridge_num_put(ocelot, bridge, bridge_num);
 
 	return 0;
 }
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 06706a9fd5b1..d825ac4c01d5 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -620,6 +620,7 @@ struct ocelot_port {
 	u16				mrp_ring_id;
 
 	struct net_device		*bridge;
+	int				bridge_num;
 	u8				stp_state;
 };
 
@@ -661,6 +662,8 @@ struct ocelot {
 	enum ocelot_tag_prefix		npi_inj_prefix;
 	enum ocelot_tag_prefix		npi_xtr_prefix;
 
+	unsigned long			bridges;
+
 	struct list_head		multicast;
 	struct list_head		pgids;
 
@@ -800,6 +803,9 @@ void ocelot_deinit(struct ocelot *ocelot);
 void ocelot_init_port(struct ocelot *ocelot, int port);
 void ocelot_deinit_port(struct ocelot *ocelot, int port);
 
+void ocelot_port_set_dsa_8021q_cpu(struct ocelot *ocelot, int port);
+void ocelot_port_unset_dsa_8021q_cpu(struct ocelot *ocelot, int port);
+
 /* DSA callbacks */
 void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data);
 void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data);
@@ -815,16 +821,17 @@ int ocelot_port_pre_bridge_flags(struct ocelot *ocelot, int port,
 				 struct switchdev_brport_flags val);
 void ocelot_port_bridge_flags(struct ocelot *ocelot, int port,
 			      struct switchdev_brport_flags val);
-void ocelot_port_bridge_join(struct ocelot *ocelot, int port,
-			     struct net_device *bridge);
+int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
+			    struct net_device *bridge, int bridge_num,
+			    struct netlink_ext_ack *extack);
 void ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 			      struct net_device *bridge);
 int ocelot_fdb_dump(struct ocelot *ocelot, int port,
 		    dsa_fdb_dump_cb_t *cb, void *data);
-int ocelot_fdb_add(struct ocelot *ocelot, int port,
-		   const unsigned char *addr, u16 vid);
-int ocelot_fdb_del(struct ocelot *ocelot, int port,
-		   const unsigned char *addr, u16 vid);
+int ocelot_fdb_add(struct ocelot *ocelot, int port, const unsigned char *addr,
+		   u16 vid, const struct net_device *bridge);
+int ocelot_fdb_del(struct ocelot *ocelot, int port, const unsigned char *addr,
+		   u16 vid, const struct net_device *bridge);
 int ocelot_vlan_prepare(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 			bool untagged, struct netlink_ext_ack *extack);
 int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
@@ -848,9 +855,11 @@ int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
 int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
 			    struct flow_cls_offload *f, bool ingress);
 int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
-			const struct switchdev_obj_port_mdb *mdb);
+			const struct switchdev_obj_port_mdb *mdb,
+			const struct net_device *bridge);
 int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
-			const struct switchdev_obj_port_mdb *mdb);
+			const struct switchdev_obj_port_mdb *mdb,
+			const struct net_device *bridge);
 int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond,
 			 struct netdev_lag_upper_info *info);
-- 
2.25.1

