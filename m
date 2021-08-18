Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E9A3F0329
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235832AbhHRMDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:03:46 -0400
Received: from mail-vi1eur05on2074.outbound.protection.outlook.com ([40.107.21.74]:54881
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231476AbhHRMDb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:03:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eaTQ9nWEhPRnlGoCasTr7b6cv69Unik6pLWw+mOxLgeK1+Vsom24uFLXVHfq7xJYbRjOtD+kPwUbefC/R0gqCplLMTXEsZLl20aROwN5kJKQU4Z1/Cc+fCHaXHthnrdW0p33PqHhQK2vlvdGk1RDFat3ES/I7EYVGVl2++wVNafdWHsJHBDDE61YPu/H75nVgkZFDnWZiM9lF009lBSbnE/PwTg6DTTEoUX3NVpFDlvTNBzbkrEjYvDukSW6uidtAe3PLaxD9Bm6rmKpDsFnD73HB/V73cNs8LMLVBmBi7mfoozout7MgpxHNV3xdeeA5ogz1guZUXJOlekZKEFtOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOlI1pFu88wHvrSjom9afx0Xd1HuttK75WyO46AuYeM=;
 b=bZ347bf75OAq8nGvbmFatbPfMvTIEuJBBad3tDLqEV0H+BpPjJ/VfWNRlBVGSWXjX8VgmyP38DSEE3vxRS7qWSG9ifdyilSpAzMvK5g3lwSG4paf2BTx9hZu8t75sIp2dFBCJ5LR02vX+o8AVu0xDi/R+2Ixg9+hOym+8S/5pmGLSS/INqnTWYPIKnZRG1WPUs0xJP/WaXd0m1TnanIX+TGqP2a8Yi3oRWAFenWWPY+O39J1a/PZROIAjYI7Qv7G4gKUvUeGzhiA5LVu9ZKLrQjKXlkMJiTih0ArphT9n5OksjE3wD5X682oaeXCuAYMbpmtiUaD1y8vrc2yGr1MkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOlI1pFu88wHvrSjom9afx0Xd1HuttK75WyO46AuYeM=;
 b=IfkSicghmlhc85O9l59E9kxomzCd5qjBgga3Pg90i1ljqZiT8F+/EB5vNcvvrarDqkv+Ob1gfKLhlpyCakdEf+Np3rrKTJhfWz2F57U4LyQWqd9GNXmDfK5PtwQRRooa2p2Wced+7h6+sGnbjkj4bnUQ7bdZ1entQ48Bye0wGPc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Wed, 18 Aug
 2021 12:02:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:02:54 +0000
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
Subject: [RFC PATCH net-next 03/20] net: dsa: propagate the bridge_num to driver .port_bridge_{join,leave} methods
Date:   Wed, 18 Aug 2021 15:01:33 +0300
Message-Id: <20210818120150.892647-4-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:02:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 392a4594-09ae-4eb4-59ed-08d962401c4c
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB42223CB432A5B3F492F8115CE0FF9@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tgZGLxLTb4mUcvrscUdQ7K5U+PIy8wSI9KHfWa/p5B0TrEegMbT/TFCnPjGdEUzBdAh9YqfNEHW2i3tN3bPRBbNGSomdGwZwx4llsgfae7Rjc8tiO/8U9lYCd+skBpY6/5pYXICHQ0P5VdG61ta76hmM0+g7xfgu6HEN1kHb9Ibguk8N7ecAR7CRlNRbhW0pWW0Fcy2tBiZ07sbGcU4zqeEOruzsut4l+ail9pJGLRw6N0OSsxZpdijwb0PrIowvlNYV7J27Bqddrr42PMZUWZGq5KM78QbMuug8bE31HzxtSbdMKSnJZ1X7TilyHMa/Dx4ln67yI4k+OACW+oJRiXoeMsPREZCDYXXpQmbmLpbR5lQI1yvEjiKZ/rP8lY0rp6QmwsqV7/XUFJ2Lwhr82WXOCTgFislsX3rEQmKMuwzbAod5cHV887BkT1y7LTVqjzxoPNV8kL+PN4Ottgio1Q5klFMd3ES8bGJDUtwhl3LP/PjKxQ/ySIZ3lnyXO+gNpg1IaPD2h0l95JDWBMYLWhxl1VrMT1kuFDpHp8fcyqgpGuaRmW7ISHxnchLJlxn+J11lY36TOYTGQ2eANAJjPyz1u0NT/9ZGZWn7HX+sxDEuTbGLQEF4UHLeZiQw8ov888++T7oGQIDo6OKmlgqVwx0kVMPozJyNMQINbHg428GfGRd2iujhV21Y04joc9Si/A2Nc9KTc1UoIcDQzTjlM2i+TLPPX9VH//I+w/2MgVk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(366004)(376002)(6486002)(52116002)(2616005)(44832011)(4326008)(5660300002)(26005)(1076003)(6666004)(54906003)(956004)(6512007)(6506007)(186003)(38350700002)(30864003)(38100700002)(86362001)(36756003)(110136005)(316002)(83380400001)(8936002)(478600001)(8676002)(66476007)(7416002)(7406005)(66946007)(66556008)(2906002)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cFEuvJ6EKJJtILmL7KSXLZMbCnuLdAaOybycBXDFx5VRvSs8XHA5r0fb8O1R?=
 =?us-ascii?Q?mZXZcQEIqJYhw58O2AxVcOjBTiNtmLnu916i9FEDYkKi4hrvafDXIVUJCAjQ?=
 =?us-ascii?Q?kvIoiesyzFhG4+WTqL437ghao2N3BC5EZmQE8/B12Dk6Wmxx91Gsebm6Aa1U?=
 =?us-ascii?Q?F/sO2DuiCDu8di2h1Fkxej3/TQ3VHFFSJszOVac7S2GCyrJuI0107GIvE5Ua?=
 =?us-ascii?Q?6cxUcgSSNok6kjGMn9rrsC0n28MaQjEugQrXHPJ55teiMWI8DEUndqoeRKqf?=
 =?us-ascii?Q?/U+ADVIZ2CvwWaUXY0tnmBSrnQvHsjhP4hjmDKE17AYjRD4JQnZ8JMqrPGCB?=
 =?us-ascii?Q?fyCt/2O04NK4rkWSvkoPwhczwSiBMAlNpFDG9ZlP5P6WqhhRoLaDZBhoAci1?=
 =?us-ascii?Q?KMUHt7gP4qCSWR3PSErmNZXnfb985FbyZAYv7YK6O+Zwb8mUSv4/yMrCg+Ed?=
 =?us-ascii?Q?RpLZ7q2YoK2+r8DXj7+IlE27az51ACwE0Yg0GDxZvsvh/v0kx0qwcRsvSC/T?=
 =?us-ascii?Q?GFPugvAtYVJzNwRZ6T/NLM8L/0nN8CshZ6uQmSTCDKghT7QYkye7/Hm7GMFV?=
 =?us-ascii?Q?fSAH4f9lykIFlW7njRD00aqkU5s1vGP2IQmYhBlEmUHUYdUS1EbTyqadDh0L?=
 =?us-ascii?Q?KwzQUhsz0H2P8/f2wFxdOyyx39qx7zRJ+AuHEJ4suyDdOOlbTxdtx4YGXPI+?=
 =?us-ascii?Q?sBFFLc6Tec/BM0A0Gkw1sNnmcnJZACT5NRkjdUjG0IrDauCGdWCEhS/0ChmW?=
 =?us-ascii?Q?ea4sfEPF0ekY7k6jAhAGduJbjpbXbxpvgBpOIl5Gd6H8F8NOLhgM3A1I/K5y?=
 =?us-ascii?Q?3QHe2iiRzaR/g1O66krda/s5h8DbvksjAR5v2jnYjbGk9e7IeTsbg519ChiJ?=
 =?us-ascii?Q?rWVYqJ+fvCkmYkBU64zdEVHybMNuQVGLoeJolxHLvQ62WTUKykmBwnLVXwIb?=
 =?us-ascii?Q?mYKpyS7Qk9Zj+MENRn+/ot0a1EOy4W8YZzCCuZDXY8AUllr+3BWkvJ4qn22l?=
 =?us-ascii?Q?PJ9LwTv/jZ6ksVkj/qdGtX5XyyxPyv/dYyNEFs/NL5huzjlijiXngHm45Atg?=
 =?us-ascii?Q?raMfAsgb5Z1irKLTvQegDE13nG2HN3AYsF066hKgJh7QyhrIafRsMoO7AZun?=
 =?us-ascii?Q?W9ICFOsB2sPJvHimAnuzH1prYv1F4Gaz04UGUvh9d1zpTEEhJ48D23ipocgW?=
 =?us-ascii?Q?yO0tIZhkrWNWwPIW4USv2Q3RMpAbs1rEydsgiMdFfGIJcVaMcn6JV3++V0NH?=
 =?us-ascii?Q?vmth8mwyFehumiUEX94O2BFPYw+YxYOquH9XcxsJ3h9Q+dNafuqwPgvfNfv5?=
 =?us-ascii?Q?QEiEPMGAyaFlMuy3JK4PE7rC?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 392a4594-09ae-4eb4-59ed-08d962401c4c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:02:54.4439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rf4NHuCO/WwViLScfoltLARiiig0vDtTmN2veYVUcL+sPuTaGIL5S7eWKVOfwngQFU8/e3mQ5XEXhidjABH3Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the driver needs to do something to isolate FDBs of different
bridges, it must be able to reliably get a FDB identifier for each
bridge.

So one might ask: why is the driver not able to call something like
dsa_bridge_num_find(bridge_dev) and find the associated FDB identifier
already provided by the DSA core if it needs to, and not change anything
if it doesn't?

The issue is that drivers might need to do something with the FDB
identifier on .port_bridge_leave too, and the dsa_bridge_num_find
function is stateful: it only retrieves a valid bridge_num if there is
at least one port which has dp->bridge_dev == br.

But the dsa_port_bridge_leave() method first clears dp->bridge_dev and
dp->bridge_num, and only then notifies the driver. The bridge that the
port just left is only present inside the cross-chip notifier attribute,
and is passed by value to the switch driver.

So the bridge_num of the bridge we just left needs to be passed by value
too, just like the bridge_dev itself. And from there, .port_bridge_join
follows the same prototype mostly for symmetry.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_common.c       |  6 ++++--
 drivers/net/dsa/b53/b53_priv.h         |  6 ++++--
 drivers/net/dsa/dsa_loop.c             |  6 ++++--
 drivers/net/dsa/hirschmann/hellcreek.c |  6 ++++--
 drivers/net/dsa/lan9303-core.c         |  4 ++--
 drivers/net/dsa/lantiq_gswip.c         |  4 ++--
 drivers/net/dsa/microchip/ksz_common.c |  4 ++--
 drivers/net/dsa/microchip/ksz_common.h |  4 ++--
 drivers/net/dsa/mt7530.c               |  4 ++--
 drivers/net/dsa/mv88e6xxx/chip.c       | 12 ++++++++----
 drivers/net/dsa/ocelot/felix.c         |  4 ++--
 drivers/net/dsa/qca8k.c                |  6 ++++--
 drivers/net/dsa/sja1105/sja1105_main.c |  4 ++--
 drivers/net/dsa/xrs700x/xrs700x.c      |  4 ++--
 include/net/dsa.h                      |  8 ++++----
 net/dsa/dsa_priv.h                     |  1 +
 net/dsa/port.c                         |  3 +++
 net/dsa/switch.c                       | 11 +++++++----
 18 files changed, 59 insertions(+), 38 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index bd1417a66cbf..d0f00cb0a235 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1847,7 +1847,8 @@ int b53_mdb_del(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_mdb_del);
 
-int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
+int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br,
+		int bridge_num)
 {
 	struct b53_device *dev = ds->priv;
 	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
@@ -1898,7 +1899,8 @@ int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
 }
 EXPORT_SYMBOL(b53_br_join);
 
-void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *br)
+void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *br,
+		  int bridge_num)
 {
 	struct b53_device *dev = ds->priv;
 	struct b53_vlan *vl = &dev->vlans[0];
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 9bf8319342b0..e3f1e9ff1b50 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -318,8 +318,10 @@ void b53_get_strings(struct dsa_switch *ds, int port, u32 stringset,
 void b53_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *data);
 int b53_get_sset_count(struct dsa_switch *ds, int port, int sset);
 void b53_get_ethtool_phy_stats(struct dsa_switch *ds, int port, uint64_t *data);
-int b53_br_join(struct dsa_switch *ds, int port, struct net_device *bridge);
-void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *bridge);
+int b53_br_join(struct dsa_switch *ds, int port, struct net_device *bridge,
+		int bridge_num);
+void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *bridge,
+		  int bridge_num);
 void b53_br_set_stp_state(struct dsa_switch *ds, int port, u8 state);
 void b53_br_fast_age(struct dsa_switch *ds, int port);
 int b53_br_flags_pre(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index bfdf3324aac3..c9fefdede1d1 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -167,7 +167,8 @@ static int dsa_loop_phy_write(struct dsa_switch *ds, int port,
 }
 
 static int dsa_loop_port_bridge_join(struct dsa_switch *ds, int port,
-				     struct net_device *bridge)
+				     struct net_device *bridge,
+				     int bridge_num)
 {
 	dev_dbg(ds->dev, "%s: port: %d, bridge: %s\n",
 		__func__, port, bridge->name);
@@ -176,7 +177,8 @@ static int dsa_loop_port_bridge_join(struct dsa_switch *ds, int port,
 }
 
 static void dsa_loop_port_bridge_leave(struct dsa_switch *ds, int port,
-				       struct net_device *bridge)
+				       struct net_device *bridge,
+				       int bridge_num)
 {
 	dev_dbg(ds->dev, "%s: port: %d, bridge: %s\n",
 		__func__, port, bridge->name);
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 5c54ae1be62c..732fff99bfb2 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -674,7 +674,8 @@ static int hellcreek_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static int hellcreek_port_bridge_join(struct dsa_switch *ds, int port,
-				      struct net_device *br)
+				      struct net_device *br,
+				      int bridge_num)
 {
 	struct hellcreek *hellcreek = ds->priv;
 
@@ -691,7 +692,8 @@ static int hellcreek_port_bridge_join(struct dsa_switch *ds, int port,
 }
 
 static void hellcreek_port_bridge_leave(struct dsa_switch *ds, int port,
-					struct net_device *br)
+					struct net_device *br,
+					int bridge_num)
 {
 	struct hellcreek *hellcreek = ds->priv;
 
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index d7ce281570b5..4e72fd04eb5f 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1103,7 +1103,7 @@ static void lan9303_port_disable(struct dsa_switch *ds, int port)
 }
 
 static int lan9303_port_bridge_join(struct dsa_switch *ds, int port,
-				    struct net_device *br)
+				    struct net_device *br, int bridge_num)
 {
 	struct lan9303 *chip = ds->priv;
 
@@ -1117,7 +1117,7 @@ static int lan9303_port_bridge_join(struct dsa_switch *ds, int port,
 }
 
 static void lan9303_port_bridge_leave(struct dsa_switch *ds, int port,
-				      struct net_device *br)
+				      struct net_device *br, int bridge_num)
 {
 	struct lan9303 *chip = ds->priv;
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index e78026ef6d8c..2ce4da567106 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1128,7 +1128,7 @@ static int gswip_vlan_remove(struct gswip_priv *priv,
 }
 
 static int gswip_port_bridge_join(struct dsa_switch *ds, int port,
-				  struct net_device *bridge)
+				  struct net_device *bridge, int bridge_num)
 {
 	struct gswip_priv *priv = ds->priv;
 	int err;
@@ -1148,7 +1148,7 @@ static int gswip_port_bridge_join(struct dsa_switch *ds, int port,
 }
 
 static void gswip_port_bridge_leave(struct dsa_switch *ds, int port,
-				    struct net_device *bridge)
+				    struct net_device *bridge, int bridge_num)
 {
 	struct gswip_priv *priv = ds->priv;
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 1542bfb8b5e5..4f821933e291 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -173,7 +173,7 @@ void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf)
 EXPORT_SYMBOL_GPL(ksz_get_ethtool_stats);
 
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
-			 struct net_device *br)
+			 struct net_device *br, int bridge_num)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -190,7 +190,7 @@ int ksz_port_bridge_join(struct dsa_switch *ds, int port,
 EXPORT_SYMBOL_GPL(ksz_port_bridge_join);
 
 void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
-			   struct net_device *br)
+			   struct net_device *br, int bridge_num)
 {
 	struct ksz_device *dev = ds->priv;
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 1597c63988b4..3e905059374b 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -159,9 +159,9 @@ void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
 int ksz_sset_count(struct dsa_switch *ds, int port, int sset);
 void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf);
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
-			 struct net_device *br);
+			 struct net_device *br, int bridge_num);
 void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
-			   struct net_device *br);
+			   struct net_device *br, int bridge_num);
 void ksz_port_fast_age(struct dsa_switch *ds, int port);
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data);
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index d757d9dcba51..751e477691f4 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1192,7 +1192,7 @@ mt7530_port_bridge_flags(struct dsa_switch *ds, int port,
 
 static int
 mt7530_port_bridge_join(struct dsa_switch *ds, int port,
-			struct net_device *bridge)
+			struct net_device *bridge, int bridge_num)
 {
 	struct mt7530_priv *priv = ds->priv;
 	u32 port_bitmap = BIT(MT7530_CPU_PORT);
@@ -1305,7 +1305,7 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
 
 static void
 mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
-			 struct net_device *bridge)
+			 struct net_device *bridge, int bridge_num)
 {
 	struct mt7530_priv *priv = ds->priv;
 	int i;
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 32fd657a325a..37878ccf499c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2387,7 +2387,8 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
 }
 
 static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
-				      struct net_device *br)
+				      struct net_device *br,
+				      int bridge_num)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
@@ -2400,7 +2401,8 @@ static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
 }
 
 static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
-					struct net_device *br)
+					struct net_device *br,
+					int bridge_num)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 
@@ -2413,7 +2415,8 @@ static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
 
 static int mv88e6xxx_crosschip_bridge_join(struct dsa_switch *ds,
 					   int tree_index, int sw_index,
-					   int port, struct net_device *br)
+					   int port, struct net_device *br,
+					   int bridge_num)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
@@ -2430,7 +2433,8 @@ static int mv88e6xxx_crosschip_bridge_join(struct dsa_switch *ds,
 
 static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
 					     int tree_index, int sw_index,
-					     int port, struct net_device *br)
+					     int port, struct net_device *br,
+					     int bridge_num)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index cbe23b20f3fa..3ab7cf2f0f50 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -695,7 +695,7 @@ static int felix_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static int felix_bridge_join(struct dsa_switch *ds, int port,
-			     struct net_device *br)
+			     struct net_device *br, int bridge_num)
 {
 	struct ocelot *ocelot = ds->priv;
 
@@ -705,7 +705,7 @@ static int felix_bridge_join(struct dsa_switch *ds, int port,
 }
 
 static void felix_bridge_leave(struct dsa_switch *ds, int port,
-			       struct net_device *br)
+			       struct net_device *br, int bridge_num)
 {
 	struct ocelot *ocelot = ds->priv;
 
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 1f63f50f73f1..9addf99ceead 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1505,7 +1505,8 @@ qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 }
 
 static int
-qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
+qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br,
+		       int bridge_num)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int port_mask = BIT(QCA8K_CPU_PORT);
@@ -1534,7 +1535,8 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 }
 
 static void
-qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
+qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br,
+			int bridge_num)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int i;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 715557c20cb5..12a92deb5e5b 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1985,13 +1985,13 @@ static void sja1105_bridge_stp_state_set(struct dsa_switch *ds, int port,
 }
 
 static int sja1105_bridge_join(struct dsa_switch *ds, int port,
-			       struct net_device *br)
+			       struct net_device *br, int bridge_num)
 {
 	return sja1105_bridge_member(ds, port, br, true);
 }
 
 static void sja1105_bridge_leave(struct dsa_switch *ds, int port,
-				 struct net_device *br)
+				 struct net_device *br, int bridge_num)
 {
 	sja1105_bridge_member(ds, port, br, false);
 }
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index 130abb0f1438..230dbbcc48f3 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -542,13 +542,13 @@ static int xrs700x_bridge_common(struct dsa_switch *ds, int port,
 }
 
 static int xrs700x_bridge_join(struct dsa_switch *ds, int port,
-			       struct net_device *bridge)
+			       struct net_device *bridge, int bridge_num)
 {
 	return xrs700x_bridge_common(ds, port, bridge, true);
 }
 
 static void xrs700x_bridge_leave(struct dsa_switch *ds, int port,
-				 struct net_device *bridge)
+				 struct net_device *bridge, int bridge_num)
 {
 	xrs700x_bridge_common(ds, port, bridge, false);
 }
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 62820bd1d00d..b2aaef292c6d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -694,9 +694,9 @@ struct dsa_switch_ops {
 	 */
 	int	(*set_ageing_time)(struct dsa_switch *ds, unsigned int msecs);
 	int	(*port_bridge_join)(struct dsa_switch *ds, int port,
-				    struct net_device *bridge);
+				    struct net_device *bridge, int bridge_num);
 	void	(*port_bridge_leave)(struct dsa_switch *ds, int port,
-				     struct net_device *bridge);
+				     struct net_device *bridge, int bridge_num);
 	/* Called right after .port_bridge_join() */
 	int	(*port_bridge_tx_fwd_offload)(struct dsa_switch *ds, int port,
 					      struct net_device *bridge,
@@ -776,10 +776,10 @@ struct dsa_switch_ops {
 	 */
 	int	(*crosschip_bridge_join)(struct dsa_switch *ds, int tree_index,
 					 int sw_index, int port,
-					 struct net_device *br);
+					 struct net_device *br, int bridge_num);
 	void	(*crosschip_bridge_leave)(struct dsa_switch *ds, int tree_index,
 					  int sw_index, int port,
-					  struct net_device *br);
+					  struct net_device *br, int bridge_num);
 	int	(*crosschip_lag_change)(struct dsa_switch *ds, int sw_index,
 					int port);
 	int	(*crosschip_lag_join)(struct dsa_switch *ds, int sw_index,
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 88aaf43b2da4..c5caa2d975d2 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -53,6 +53,7 @@ struct dsa_notifier_ageing_time_info {
 /* DSA_NOTIFIER_BRIDGE_* */
 struct dsa_notifier_bridge_info {
 	struct net_device *br;
+	int bridge_num;
 	int tree_index;
 	int sw_index;
 	int port;
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 605c6890e53b..3ef55bd6eb40 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -368,6 +368,8 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	if (err)
 		return err;
 
+	info.bridge_num = dp->bridge_num;
+
 	brport_dev = dsa_port_to_bridge_port(dp);
 
 	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_JOIN, &info);
@@ -417,6 +419,7 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.br = br,
+		.bridge_num = dp->bridge_num,
 	};
 	int bridge_num = dp->bridge_num;
 	int err;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index fd1a1c6bf9cf..44d40a267632 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -94,7 +94,8 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 
 	if (dst->index == info->tree_index && ds->index == info->sw_index &&
 	    ds->ops->port_bridge_join) {
-		err = ds->ops->port_bridge_join(ds, info->port, info->br);
+		err = ds->ops->port_bridge_join(ds, info->port, info->br,
+						info->bridge_num);
 		if (err)
 			return err;
 	}
@@ -103,7 +104,8 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 	    ds->ops->crosschip_bridge_join) {
 		err = ds->ops->crosschip_bridge_join(ds, info->tree_index,
 						     info->sw_index,
-						     info->port, info->br);
+						     info->port, info->br,
+						     info->bridge_num);
 		if (err)
 			return err;
 	}
@@ -121,13 +123,14 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 
 	if (dst->index == info->tree_index && ds->index == info->sw_index &&
 	    ds->ops->port_bridge_leave)
-		ds->ops->port_bridge_leave(ds, info->port, info->br);
+		ds->ops->port_bridge_leave(ds, info->port, info->br,
+					   info->bridge_num);
 
 	if ((dst->index != info->tree_index || ds->index != info->sw_index) &&
 	    ds->ops->crosschip_bridge_leave)
 		ds->ops->crosschip_bridge_leave(ds, info->tree_index,
 						info->sw_index, info->port,
-						info->br);
+						info->br, info->bridge_num);
 
 	/* If the bridge was vlan_filtering, the bridge core doesn't trigger an
 	 * event for changing vlan_filtering setting upon slave ports leaving
-- 
2.25.1

