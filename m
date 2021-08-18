Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8938C3F0330
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbhHRME2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:04:28 -0400
Received: from mail-eopbgr00085.outbound.protection.outlook.com ([40.107.0.85]:55044
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235795AbhHRMEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:04:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsTFkwSMGZlktYgJFyfR9dgz16T/ZVFhtV7TQ76ZXdS/g6K9BfgSOPDibFTnAxaNLO/uQbZLf2B+i/k3DHWtB82kLC32RDkSetvBd1eK4JbQHDjywfpH25E3IRGpI2TiPng7kQcgoNjq/ajyoYMCqK8Pm9P7VhN7tPe2C8VhEGSk7+TvhCLIWcoqyUeV7aPY1UnOac3rkKb4vlh5cLrBwwHhFh7i6R3x64oMnjwaF1QkGgUG4XepGmQ1whijC8ASQKOcBzScW8Ey2FTusYHW1KI59UWuh1KlIoujDugWf8BKYv0b/MnCncQRnikG7UvvEx08EtcWmL9xh2kNSEY81g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XdEYQBUdStvxn6GWF9wwdHiFppBHaOQSo6eu+z3rmzQ=;
 b=gpVj5AxOsljDMYhQ0KU7hfmqeew0D+U+vgAcwbeRIQuS48GP+n/RBJZRwkZxGcIpuRrYjeZoMIUga9ydPYxWljUgEbzbyz09BQuCDbPQtzBymI/T6DMx1bSAoIaXsfrFSQgwVxf+aR4M32TydEcfpFZfZy/gEid8puZGalwx+5XPreFUPwVBPdncpS/w8pKVWd0t2d1IXda/OhTOlcyn0BOU//H+NVnVvO0qM0Ep7EI4uOlaEcE2ay1pKlOjkuUEwk0egQ0l49DbQlNamkf9JvaoTm8RLmIUuODW08RLBOEFctftHigxMJRUTE6jlh7zgSejZnTnqcBSaCX4Grxzaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XdEYQBUdStvxn6GWF9wwdHiFppBHaOQSo6eu+z3rmzQ=;
 b=rmmN/yjmZHsmBjiB8MK0If9B1LaJAEFLRP752w6y02yudGRd5QyyNHZB6Vn6WXuMdELVHEpq8mCk/+y1xeQxMuy/GsyItkdNctldonTZ8sUEJJl3+z8L9e6qidSp5ha5hMhIOmqKthpOZYd+4lXus0bLRqUtAHN3rmY+a3i2/7s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 12:03:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:03:03 +0000
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
Subject: [RFC PATCH net-next 09/20] net: dsa: tag_8021q: replace the SVL bridging with VLAN-unaware IVL bridging
Date:   Wed, 18 Aug 2021 15:01:39 +0300
Message-Id: <20210818120150.892647-10-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:03:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 919ce048-d7a7-4bf6-0b3e-08d96240214f
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3839ECC9384515D5BC41DD85E0FF9@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RuNJlNHxBXZf3PyudjagJv+jTprhYeA+YyxicyW7jzmGz+6W3Uk0Zn1MZFLc0PPQbLTtWWTFHCZOZOW8zKXQ0Q6CYGZClet+OuLT47IfDSB/QHE2SGQ0xusW67VNd0r4Fk75/65cPYSFjoncLuW/QHkqau3e99gt/HQ7CFUDb8XbEMUjOszZyrDf76PCtLjSjUHUNFGQ6MeUeRHH9jKv9Y4dEsfiuUhOOAlsjgrIFvdryEvTrDa1DFXUnrc5SG48kdbTEGalbPVhLadKWmJtZSqHewgVQq+NHkP0LUcVyqNRbiUUPJ0tjHy3tlSvYhc9rGvvojuWGU8DJxTLvuQ6H/cOVk9H4R89YOUhlXXhfcQKIrrcLktlhOs94MCMylOQjPoAu4CDlozGSonmj2tMNpGuDbJOJzUCp0yeshTvQWZsBAFAAeA8O41u/4SaAp0tEmpU3EwDMit/BCgXCwclh+YV3sFnDlktSdBsNKGtf9uR3YdGweKhutW01cN5r9W7wNijf3chbv0M2ML7q7+1IjolevmEOfFlTVSvqwFO3yAPfhvnK7qfuZu/YEPBm5xTVVqV39suSNZG123UuXacfphgvNPVOZJ1EufCCIzlaB23d/hvHj7MzdnocgQdmO4lEmPypQ31/Dk1pIlNWgYKtIZYZTirkbuxbQnnL9VPaMlib4ANL1Rew+d8o4s6Xs2F9njamn4obm5MICMsoFMywQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39850400004)(366004)(376002)(66476007)(2906002)(66556008)(8936002)(6506007)(186003)(7406005)(7416002)(52116002)(26005)(86362001)(66946007)(6486002)(44832011)(36756003)(30864003)(5660300002)(1076003)(110136005)(54906003)(6512007)(8676002)(316002)(6666004)(38350700002)(38100700002)(956004)(478600001)(83380400001)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OKdzoZvoXXDT6CiWRmLQ/JqQ13H0YDTI1T8+ItiNReUvf1hZNkZqOVDhxKWv?=
 =?us-ascii?Q?iB0sUIUwqEFYBAaf5nIWHjyM3baZwz3akifhMi9wIpdwkjiGNYdQuvl/8vom?=
 =?us-ascii?Q?QCcHxQQMM7m17MBLM2zQesOrQyVGrSRtoSmyPK0KUPoIYSN5PfU3qhlZ/PjR?=
 =?us-ascii?Q?BkpQYHaWgbrVLQGKJonACNpVDY9D0itfsE23D6dYddG0nVIP4sJ3pG6UwW6b?=
 =?us-ascii?Q?Ia3yDaMg0HPp7RkA6f/zVT5HpGvlkuuwqmwT3m78t+UX5OD2sBkNRjmG814k?=
 =?us-ascii?Q?m5hJqxcb4pDCdX8DROZVg3RrMBA0qQVO9c96z+7xubTETovHmQI/5ORmwaer?=
 =?us-ascii?Q?tZZuhn/A7j+Rgpnejo37sfB49rwP2rac3+d0rBWXOVa0zB6csIoK0gCDl9up?=
 =?us-ascii?Q?S6bOHkQk/Z5+MagDlD3zzxI7wmZXxDFmKbwUF62cmYXCcUeXnhnt32TYZyp8?=
 =?us-ascii?Q?B+Q2XTx3sY23FXa/RMH22M4X76hrIrdW1U7Rthu66ut9ONO1Xn7eJxHflN6k?=
 =?us-ascii?Q?XQnz9tsU4dUHBW2CMhWPAdoH1pos6L3F5SS9E67NOb+f3GRWTSY3y7jMasKy?=
 =?us-ascii?Q?YOQza44+YcNFG9DUtulz2CIikiirSclTeUUvtys3V8POo3xwgsWBaJJgKYgX?=
 =?us-ascii?Q?9P3vNUC79XI88izV4imi/Iax67TGVlITmeBM1M9RbZ/D3udvE4OEb56sly6Z?=
 =?us-ascii?Q?Qoo8OdnohPM2/uwvkYQbzLJw9dpiT4TSDm7fHWQx6/fH0XXeCFS2LWcZAoQ8?=
 =?us-ascii?Q?hS6pmMi59lCJ2CfvCyD85oI2MUM5C0F9yXxIVzkEfa77f43Nvyt6WPttspdX?=
 =?us-ascii?Q?q03Hbr+ikXTZ6s3DrZDXp/BkvN2fCyuhVl9yMViInvHwfN+Ct2neZComVQGo?=
 =?us-ascii?Q?zxcqnNLdsPGGi6GZyo9oDLc/yNBwjparNbf04MhXVW4VqOz2NFpBaGM6NS2G?=
 =?us-ascii?Q?eiF4IFvv4RUBghKXmsa3MLp4hH5zI8aW1dHiWJ7rytpuEW2XNBARn/tCkrnm?=
 =?us-ascii?Q?Q/7WZJWKow+dYUrK7S5ivb2mpP7R7o6DSbVvY3S7LHvtppPxbryE8WMUvhOe?=
 =?us-ascii?Q?H67aolHvztsMgOyqC0CHl6CFHfE/zmui99QH/b8EkDE61L9S4lvC6l6Wnyiz?=
 =?us-ascii?Q?zXUv73irEcLR9O5/v284Y18aRLL2y29UCfdm9xe3zJ/9azpTCkn81rYa7Ix5?=
 =?us-ascii?Q?wKGvIiBCIKmi4C5x84psoRIlJ89U6LphEmo2r3ky46Tk9JuR7xHYXQuxQqv9?=
 =?us-ascii?Q?etIRA5ikmLepUPPypLyq16VHQ9Vm3c0WqZ/5N2KyC+xM8gDWG/5SpsyOY6a7?=
 =?us-ascii?Q?S/NRfHp4TUa4DTSoXEkPh8Av?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 919ce048-d7a7-4bf6-0b3e-08d96240214f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:03:02.8711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6T50gS6V/x/skZIeJU0SACGMxj+PZIdlIrN8BsnazMLIBlpC34y6klvbTdI/VzZ7mSqlYfgEjFKzX4Hwl1SgHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For VLAN-unaware bridging, tag_8021q uses something perhaps a bit too
tied with the sja1105 switch: each port uses the same pvid which is also
used for standalone operation (a unique one from which the source port
and device ID can be retrieved when packets from that port are forwarded
to the CPU). Since each port has a unique pvid when performing
autonomous forwarding, the switch must be configured for Shared VLAN
Learning (SVL) such that the VLAN ID itself is ignored when performing
FDB lookups. Without SVL, packets would always be flooded.

First of all, to make tag_8021q more palatable to switches which might
not support Shared VLAN Learning, let's just use a common VLAN for all
ports that are under a bridge.

Secondly, using Shared VLAN Learning means that FDB isolation can never
be enforced. But now, when all ports under the same VLAN-unaware bridge
share the same VLAN ID, it can.

The disadvantage is that the CPU port can no longer perform precise
source port identification for these packets. But at least we have a
mechanism which has proven to be adequate for that situation: imprecise
RX, which is what we use for VLAN-aware bridging.

The VLAN ID that VLAN-unaware bridges will use with tag_8021q is the
same one as we were previously using for imprecise TX (bridge TX
forwarding offload). It is already allocated, it is just a matter of
using it.

Note that because now all ports under the same bridge share the same
VLAN, the complexity of performing a tag_8021q bridge join decreases
dramatically. We no longer have to install the RX VLAN of a newly
joining port into the port membership of the existing bridge ports.
The newly joining port just becomes a member of the VLAN corresponding
to that bridge, and the other ports are already members of it. So
forwarding works properly.

This means that we can unhook dsa_tag_8021q_bridge_{join,leave} from the
cross-chip notifier level dsa_switch_bridge_{join,leave}. We can put
these calls directly into the sja1105 driver.

With this new mode of operation, a port controlled by tag_8021q can have
two pvids whereas before it could only have one. The pvid for standalone
operation is different from the pvid used for VLAN-unaware bridging.
This is done, again, so that FDB isolation can be enforced.
Let tag_8021q manage this by deleting the standalone pvid when a port
joins a bridge, and restoring it when it leaves it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c |  32 +++++-
 include/linux/dsa/8021q.h              |  14 ++-
 net/dsa/dsa_priv.h                     |   4 -
 net/dsa/switch.c                       |   4 +-
 net/dsa/tag_8021q.c                    | 137 +++++++++----------------
 5 files changed, 85 insertions(+), 106 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 12a92deb5e5b..1d05a6234a6d 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1987,13 +1987,24 @@ static void sja1105_bridge_stp_state_set(struct dsa_switch *ds, int port,
 static int sja1105_bridge_join(struct dsa_switch *ds, int port,
 			       struct net_device *br, int bridge_num)
 {
-	return sja1105_bridge_member(ds, port, br, true);
+	int rc;
+
+	rc = dsa_tag_8021q_bridge_join(ds, port, br, bridge_num);
+	if (rc)
+		return rc;
+
+	rc = sja1105_bridge_member(ds, port, br, true);
+	if (rc)
+		dsa_tag_8021q_bridge_leave(ds, port, br, bridge_num);
+
+	return rc;
 }
 
 static void sja1105_bridge_leave(struct dsa_switch *ds, int port,
 				 struct net_device *br, int bridge_num)
 {
 	sja1105_bridge_member(ds, port, br, false);
+	dsa_tag_8021q_bridge_leave(ds, port, br, bridge_num);
 }
 
 #define BYTES_PER_KBIT (1000LL / 8)
@@ -2915,6 +2926,21 @@ static int sja1105_port_bridge_flags(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static int sja1105_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
+					 struct net_device *br,
+					 int bridge_num)
+{
+	/* Nothing to do, tag_8021q took care of everything */
+	return 0;
+}
+
+static void sja1105_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
+					    struct net_device *br,
+					    int bridge_num)
+{
+	/* Nothing to do, tag_8021q took care of everything */
+}
+
 static void sja1105_teardown_ports(struct sja1105_private *priv)
 {
 	struct dsa_switch *ds = priv->ds;
@@ -3144,8 +3170,8 @@ const struct dsa_switch_ops sja1105_switch_ops = {
 	.tag_8021q_vlan_add	= sja1105_dsa_8021q_vlan_add,
 	.tag_8021q_vlan_del	= sja1105_dsa_8021q_vlan_del,
 	.port_prechangeupper	= sja1105_prechangeupper,
-	.port_bridge_tx_fwd_offload = dsa_tag_8021q_bridge_tx_fwd_offload,
-	.port_bridge_tx_fwd_unoffload = dsa_tag_8021q_bridge_tx_fwd_unoffload,
+	.port_bridge_tx_fwd_offload = sja1105_bridge_tx_fwd_offload,
+	.port_bridge_tx_fwd_unoffload = sja1105_bridge_tx_fwd_unoffload,
 };
 EXPORT_SYMBOL_GPL(sja1105_switch_ops);
 
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index c7fa4a3498fe..29b9c0e195ae 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -30,19 +30,17 @@ int dsa_tag_8021q_register(struct dsa_switch *ds, __be16 proto);
 
 void dsa_tag_8021q_unregister(struct dsa_switch *ds);
 
+int dsa_tag_8021q_bridge_join(struct dsa_switch *ds, int port,
+			      struct net_device *br, int bridge_num);
+
+void dsa_tag_8021q_bridge_leave(struct dsa_switch *ds, int port,
+				struct net_device *br, int bridge_num);
+
 struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 			       u16 tpid, u16 tci);
 
 void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id);
 
-int dsa_tag_8021q_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
-					struct net_device *br,
-					int bridge_num);
-
-void dsa_tag_8021q_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
-					   struct net_device *br,
-					   int bridge_num);
-
 u16 dsa_8021q_bridge_tx_fwd_offload_vid(int bridge_num);
 
 u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 55b908f588ac..417fac51c6e8 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -533,10 +533,6 @@ int dsa_bridge_num_get(const struct net_device *bridge_dev, int max);
 void dsa_bridge_num_put(const struct net_device *bridge_dev, int bridge_num);
 
 /* tag_8021q.c */
-int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
-			      struct dsa_notifier_bridge_info *info);
-int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
-			       struct dsa_notifier_bridge_info *info);
 int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
 				  struct dsa_notifier_tag_8021q_vlan_info *info);
 int dsa_switch_tag_8021q_vlan_del(struct dsa_switch *ds,
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 44d40a267632..26dbd70ebb5e 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -110,7 +110,7 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 			return err;
 	}
 
-	return dsa_tag_8021q_bridge_join(ds, info);
+	return 0;
 }
 
 static int dsa_switch_bridge_leave(struct dsa_switch *ds,
@@ -162,7 +162,7 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 			return err;
 	}
 
-	return dsa_tag_8021q_bridge_leave(ds, info);
+	return 0;
 }
 
 /* Matches for all upstream-facing ports (the CPU port and all upstream-facing
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index f8f7b7c34e7d..ae94c684961d 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -109,6 +109,15 @@ int dsa_8021q_rx_source_port(u16 vid)
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rx_source_port);
 
+/* Returns the decoded VBID from the RX VID. */
+static int dsa_tag_8021q_rx_vbid(u16 vid)
+{
+	u16 vbid_hi = (vid & DSA_8021Q_VBID_HI_MASK) >> DSA_8021Q_VBID_HI_SHIFT;
+	u16 vbid_lo = (vid & DSA_8021Q_VBID_LO_MASK) >> DSA_8021Q_VBID_LO_SHIFT;
+
+	return (vbid_hi << 2) | vbid_lo;
+}
+
 bool vid_is_dsa_8021q_rxvlan(u16 vid)
 {
 	return (vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_RX;
@@ -239,11 +248,17 @@ int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
 			if (dsa_is_user_port(ds, port))
 				flags |= BRIDGE_VLAN_INFO_UNTAGGED;
 
+			/* Standalone VLANs are PVIDs */
 			if (vid_is_dsa_8021q_rxvlan(info->vid) &&
 			    dsa_8021q_rx_switch_id(info->vid) == ds->index &&
 			    dsa_8021q_rx_source_port(info->vid) == port)
 				flags |= BRIDGE_VLAN_INFO_PVID;
 
+			/* And bridging VLANs are PVIDs too on user ports */
+			if (dsa_tag_8021q_rx_vbid(info->vid) &&
+			    dsa_is_user_port(ds, port))
+				flags |= BRIDGE_VLAN_INFO_PVID;
+
 			err = dsa_switch_do_tag_8021q_vlan_add(ds, port,
 							       info->vid,
 							       flags);
@@ -322,111 +337,55 @@ int dsa_switch_tag_8021q_vlan_del(struct dsa_switch *ds,
  * +-+-----+-+-----+-+-----+-+-----+-+    +-+-----+-+-----+-+-----+-+-----+-+
  *   swp0    swp1    swp2    swp3           swp0    swp1    swp2    swp3
  */
-static bool dsa_tag_8021q_bridge_match(struct dsa_switch *ds, int port,
-				       struct dsa_notifier_bridge_info *info)
+int dsa_tag_8021q_bridge_join(struct dsa_switch *ds, int port,
+			      struct net_device *br, int bridge_num)
 {
 	struct dsa_port *dp = dsa_to_port(ds, port);
+	u16 standalone_vid, bridge_vid;
+	int err;
 
-	/* Don't match on self */
-	if (ds->dst->index == info->tree_index &&
-	    ds->index == info->sw_index &&
-	    port == info->port)
-		return false;
-
-	if (dsa_port_is_user(dp))
-		return dp->bridge_dev == info->br;
-
-	return false;
-}
-
-int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
-			      struct dsa_notifier_bridge_info *info)
-{
-	struct dsa_switch *targeted_ds;
-	struct dsa_port *targeted_dp;
-	u16 targeted_rx_vid;
-	int err, port;
-
-	if (!ds->tag_8021q_ctx)
-		return 0;
-
-	targeted_ds = dsa_switch_find(info->tree_index, info->sw_index);
-	targeted_dp = dsa_to_port(targeted_ds, info->port);
-	targeted_rx_vid = dsa_8021q_rx_vid(targeted_ds, info->port);
-
-	for (port = 0; port < ds->num_ports; port++) {
-		struct dsa_port *dp = dsa_to_port(ds, port);
-		u16 rx_vid = dsa_8021q_rx_vid(ds, port);
-
-		if (!dsa_tag_8021q_bridge_match(ds, port, info))
-			continue;
+	/* Delete the standalone VLAN of the port and replace it with a
+	 * bridging VLAN
+	 */
+	standalone_vid = dsa_8021q_rx_vid(ds, port);
+	bridge_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
 
-		/* Install the RX VID of the targeted port in our VLAN table */
-		err = dsa_port_tag_8021q_vlan_add(dp, targeted_rx_vid, true);
-		if (err)
-			return err;
+	dsa_port_tag_8021q_vlan_del(dp, standalone_vid, false);
 
-		/* Install our RX VID into the targeted port's VLAN table */
-		err = dsa_port_tag_8021q_vlan_add(targeted_dp, rx_vid, true);
-		if (err)
-			return err;
+	err = dsa_port_tag_8021q_vlan_add(dp, bridge_vid, true);
+	if (err) {
+		dsa_port_tag_8021q_vlan_add(dp, standalone_vid, false);
+		return err;
 	}
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_join);
 
-int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
-			       struct dsa_notifier_bridge_info *info)
+void dsa_tag_8021q_bridge_leave(struct dsa_switch *ds, int port,
+				struct net_device *br, int bridge_num)
 {
-	struct dsa_switch *targeted_ds;
-	struct dsa_port *targeted_dp;
-	u16 targeted_rx_vid;
-	int port;
-
-	if (!ds->tag_8021q_ctx)
-		return 0;
-
-	targeted_ds = dsa_switch_find(info->tree_index, info->sw_index);
-	targeted_dp = dsa_to_port(targeted_ds, info->port);
-	targeted_rx_vid = dsa_8021q_rx_vid(targeted_ds, info->port);
-
-	for (port = 0; port < ds->num_ports; port++) {
-		struct dsa_port *dp = dsa_to_port(ds, port);
-		u16 rx_vid = dsa_8021q_rx_vid(ds, port);
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	u16 standalone_vid, bridge_vid;
+	int err;
 
-		if (!dsa_tag_8021q_bridge_match(ds, port, info))
-			continue;
+	/* Delete the bridging VLAN of the port and replace it with a
+	 * standalone VLAN
+	 */
+	standalone_vid = dsa_8021q_rx_vid(ds, port);
+	bridge_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
 
-		/* Remove the RX VID of the targeted port from our VLAN table */
-		dsa_port_tag_8021q_vlan_del(dp, targeted_rx_vid, true);
+	dsa_port_tag_8021q_vlan_del(dp, bridge_vid, true);
 
-		/* Remove our RX VID from the targeted port's VLAN table */
-		dsa_port_tag_8021q_vlan_del(targeted_dp, rx_vid, true);
+	err = dsa_port_tag_8021q_vlan_add(dp, standalone_vid, false);
+	if (err) {
+		dev_err(ds->dev,
+			"Failed to delete tag_8021q standalone VLAN %d from port %d: %pe\n",
+			standalone_vid, port, ERR_PTR(err));
+		dsa_port_tag_8021q_vlan_add(dp, bridge_vid, true);
 	}
-
-	return 0;
-}
-
-int dsa_tag_8021q_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
-					struct net_device *br,
-					int bridge_num)
-{
-	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
-
-	return dsa_port_tag_8021q_vlan_add(dsa_to_port(ds, port), tx_vid,
-					   true);
-}
-EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_tx_fwd_offload);
-
-void dsa_tag_8021q_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
-					   struct net_device *br,
-					   int bridge_num)
-{
-	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
-
-	dsa_port_tag_8021q_vlan_del(dsa_to_port(ds, port), tx_vid, true);
 }
-EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_tx_fwd_unoffload);
+EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_leave);
 
 /* Set up a port's tag_8021q RX and TX VLAN for standalone mode operation */
 static int dsa_tag_8021q_port_setup(struct dsa_switch *ds, int port)
-- 
2.25.1

