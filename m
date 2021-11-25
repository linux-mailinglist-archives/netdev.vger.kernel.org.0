Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3811745DAA5
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 14:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354847AbhKYNEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 08:04:52 -0500
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:51876
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1351707AbhKYNCw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 08:02:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HCaMJfIaYnqx0EgzaVg1EhJ+2stNhJq5TxqVg6RDW/J4r1YbVYnpyWy93GEemIJaCdc620vHHIy5QnHNP6OX5sgPHaJTrP5d53URGYtR1B6pskXg+xdhm++FfO8U3Nt5Fd9MhXdO6CrHRjMh6iLAryJ8kj65zBGScRyG9yITSrwNpbbA8JnLyceVD6XFXt+sa77l5RNaWrgHPv9E/O2Hn6vMk/LBM06lNnvLKb1iycSnA+MNSmXtl0bo+ss2utTS8MxzPYeWn9DF1YyfCghJGMvP9IrTrfnB8ETS5bm54Fs9KJRGywymr+5GQB5Itqls19EEBWjqopIYljwU7cNaYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VQB9WIZyGRCc/chey7OYmVRkOWpxDx6ZrXIwtvl3jbg=;
 b=SOFyR3/P8dHjHP+1mYUx5MSTgL3mA6LycXG2icVwfQKl89Ok60Q5OklyGSsl+EiAPIFRvfJZ3lxkSNQU5hL/1DJKyYQP7ZIXRAOvTdH6lo95RvnnuaMejfeSFM2PS4t7DtzIJhVKUthaO1TOWADXgIG6ir/EFwdguB4VlwTtIunfWwQR57XXOlWeFWxTnu4VPgFcxpQ7sE++YiQn7l4sWf7cvpQB5zCH1nBIvwpU/hOzU8Ap6J2Wbmsk3x8DLYVpgpsbS9H8DIc1jjTBon//E4lhpKQtBdP3VdXoUQPYAtkEG5mpenIA/Qf49uekPtMQuF8DwCKB6HmoMNVKWn2r9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQB9WIZyGRCc/chey7OYmVRkOWpxDx6ZrXIwtvl3jbg=;
 b=sQk6U5F+LWW7RUS4npoSTrDM/kU7U9mXe4wTrHhpgV+YU081NVAwXnuDvetqCycPy1nx+8scKOeSK5cwJJi5eldQsDAhaU5ad9m8/7WgNawXsI/hQ9avsNYjwl9V+nA15ZL6a4KpnAxiDjAUvaM0XKdeev3jfEjYyXtBaznFbPw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6510.eurprd04.prod.outlook.com (2603:10a6:803:127::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Thu, 25 Nov
 2021 12:59:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 12:59:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH v3 net-next 2/2] net: dsa: felix: enable cut-through forwarding between ports by default
Date:   Thu, 25 Nov 2021 14:58:08 +0200
Message-Id: <20211125125808.2383984-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211125125808.2383984-1-vladimir.oltean@nxp.com>
References: <20211125125808.2383984-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0142.eurprd07.prod.outlook.com
 (2603:10a6:207:8::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.163.189) by AM3PR07CA0142.eurprd07.prod.outlook.com (2603:10a6:207:8::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.7 via Frontend Transport; Thu, 25 Nov 2021 12:59:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c898c34-68ac-48bc-2502-08d9b0135e17
X-MS-TrafficTypeDiagnostic: VE1PR04MB6510:
X-Microsoft-Antispam-PRVS: <VE1PR04MB65107D37CBA3AA1B9406B450E0629@VE1PR04MB6510.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v2wn0Pmymu54xrXz2HuWM5gMVdxmWwAATSdb1GlpkS8iKH9Ugj8h0hvoeAXy1kA1fX9SqxoSe0IuqX9VTJr+mEVcvowaO7XOoACYDFfCVTkIq47rm3oil+/X7S4CHLoifU81b7Kp/nnjxn3LeGdcSSSqbejZcY8CfaR4bK4i04QMHLgWOuB3w5MNh0UfwDIQm1XkJe6MdNCLVJBKFFYSMtL1d7LsJpFLWcyeA8xCBpKvDQ39GUV8CxicCTtBSjRW6VysdiweMOf/ob2S20rJnB0BvBVNT3YTH1aCVL6tAvMtYyT1OlaAPiIJp/AnP40LLBIbthjwqEZTEnAhEBJiBskRFB6Ni5ZVpsKZVoM5nHUbpCPCulvk23xrh/gzckKLGjOYcRYSZS5bHBvvw+y7t5yrPdCAFWeCq/IeReSglsHVNreB/uFYnRZMzrAhfKkXOmCuqMBymyH00/mEa71un1KPazpJ+UXf9qix9pfRZ5FcN+WPd0q3TdeGvShnMnzVRcdadK4DDHVbXRGn0uKpCrdX3r2SM7On/Pnriqf4Py7ccnxnNv3hsYpzyRF9GrXXlXhCW0fi0UqdwIk+Tkgfq1MsH0ceY367jFiRG3VtXXT/DgSSmOVCpEe8JVFRHLMxEKCv6rY4ZoQ3o/l2uNHBBeKciLNUimMmUJah8uzqoIEiHoe+eBt19ER4aS4RRHr4Zt4SiF02xnSwMer5gAIN1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(66946007)(8676002)(508600001)(66476007)(6486002)(6916009)(26005)(38350700002)(30864003)(66556008)(2616005)(186003)(86362001)(956004)(6512007)(8936002)(36756003)(83380400001)(38100700002)(54906003)(6506007)(4326008)(2906002)(1076003)(52116002)(44832011)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HcOcQBDHlRonpKuoB7U8O8TYAMPk/sc+9IR99sRSQGuWToOS3cPk5KoCMSiJ?=
 =?us-ascii?Q?2izdM6WsP8K/3CxURvv7SnsT6OwdUypUkTQOgusiov3Hp6kLTRWBUfub2lVL?=
 =?us-ascii?Q?ta3+TTm5Wi3M7WMU9OKFVtNiJTfCjOqAx+y1fl/P67Pu+o5uakmeOJdWN9/X?=
 =?us-ascii?Q?mFZ6wMBNbaV12CeWCX14k4I5z/BocFSfre+fioM21qCVg2Cv5/4GE1KKmTgB?=
 =?us-ascii?Q?ayVG1DycV/IQVzuYL2SP4T+rmNQIFB8BedcXTxMHbZO217gnHCt9kwlqZzYe?=
 =?us-ascii?Q?gTZW/CC/ar17w0DQn4PoU+f9fIGrjTwvL9XRgERP/xkaW7UN2IjsRW9luJtW?=
 =?us-ascii?Q?xotuVD+ZjyZsAheRt8OHqcGdGO3pk0GYye9gzmxfwJpYkUTtrQkKJR1Q/cMx?=
 =?us-ascii?Q?2czmmDRGPqG4gjk6nFB5Xn2SpbXjavu6QiMRcAXh7YLyHkrVKOMrSnsdErOq?=
 =?us-ascii?Q?F5gBIQdT8WoRBFu+gcR5hC9741bd2dtKE11JsvIpsVcTND7bB/IcDRAt0emt?=
 =?us-ascii?Q?hEi80JVxMIzt925L+778JXSJdYWxXwKHrN6X8ARhbvMbwS29Ke3FbcUZ00So?=
 =?us-ascii?Q?04fEa6XlJALtPF2HmfVYLRw9QK7trSs4LlOL7Xn15FfonKt81L6h2Vs4Am6c?=
 =?us-ascii?Q?Daz8VS3jN6giCzDS3bYqpOoIFS2o0xSUAi6FFNz/TfP0uhYPkCPo9YnUVVYp?=
 =?us-ascii?Q?+CE0Um1vyAseeXQHSJmjVVculA42bP7poVqt211qXprWmbQxpLW+3c3XTCsb?=
 =?us-ascii?Q?wNxWx772MQvUK4lXJzYrsE6WW4Nr4GE2TfSUzaRAhw4D9qKUuXGFRMzINvSl?=
 =?us-ascii?Q?esJIgtZ6fb1ZzK424kZZKiRqK8HcAkGSWLJ3E++BdXD4eOyOPfn6Hl/k40ow?=
 =?us-ascii?Q?OFbQgKwl14JITnOJzkVk1zIvjpWBPHyGgmzqZqCJ7dPo2UD366xNgPKTWb9p?=
 =?us-ascii?Q?3EtMr1UFFF0iivocGaDfqKNwYHji4CQ8AIIgCZbq309YakhF8xOCZm3l8eBg?=
 =?us-ascii?Q?0uV4nuX3sfW41SoWeiv26NfXsJqPgJrIM3DmygtNYb13CQ0r5vQXvN1gm3QL?=
 =?us-ascii?Q?YSjZ6EfLBfqEMG05IVHFsj9QGmUGhAsVSvFyyvkEXhQToI1Gj6w9ANAs7TuA?=
 =?us-ascii?Q?a62vKewiJhZY8Gh940/FAPMXRFCk+Up6alSZF6j+HMYHw7BCkMwSBJ857WDH?=
 =?us-ascii?Q?Dbd2iNYAIZDfY7umwacTf9H/AEGyMI75cWzMQR6+WuzkMHxU+dkqf/XKyRxq?=
 =?us-ascii?Q?LDpURjqEP/3NYCYrx8VAx3FQXxdpmZuCtp8OQoW7g9uhLoLuAttBnDr5+QbG?=
 =?us-ascii?Q?iKheRBZFaHcHDYNL2ROn9mDVMJiz0wC+WF4HmUKzoYq2pUNKParLXOIE4cad?=
 =?us-ascii?Q?h0UK6a016H4VOM9y7y6bUMqyfW09lZFuEp+HItUQeUn65+Ap8dS9Ny3rkrlb?=
 =?us-ascii?Q?qIYbvsafaE1h+fBmp3LTT+6kchZtSN5yrN5P8q7tb7QnP0Pxex/Udg4cuFKg?=
 =?us-ascii?Q?3UMytaRzsld7/KBVAsfy9Gvy+eOmRuuI+XT+4VLDW/2S0YAekej3ixPm0hkr?=
 =?us-ascii?Q?5qoBI7eu9Hru0nH+oThXotTiUgkRUBenx6DnC32kxK3Wx+5kRqlN1wpqYdqK?=
 =?us-ascii?Q?Ae1h8CNPYtKTKgtPJIojEVg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c898c34-68ac-48bc-2502-08d9b0135e17
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 12:59:08.1057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eq13zFcPCr2HC9rbTmlKHBkhwGP0FZ+uZmJyT8l9vPdZ62MSXRPR7LOH87G3fRv5FVi85eO0y6+fe3Tola/OjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6510
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VSC9959 switch embedded within NXP LS1028A (and that version of
Ocelot switches only) supports cut-through forwarding - meaning it can
start the process of looking up the destination ports for a packet, and
forward towards those ports, before the entire packet has been received
(as opposed to the store-and-forward mode).

The up side is having lower forwarding latency for large packets. The
down side is that frames with FCS errors are forwarded instead of being
dropped. However, erroneous frames do not result in incorrect updates of
the FDB or incorrect policer updates, since these processes are deferred
inside the switch to the end of frame. Since the switch starts the
cut-through forwarding process after all packet headers (including IP,
if any) have been processed, packets with large headers and small
payload do not see the benefit of lower forwarding latency.

There are two cases that need special attention.

The first is when a packet is multicast (or flooded) to multiple
destinations, one of which doesn't have cut-through forwarding enabled.
The switch deals with this automatically by disabling cut-through
forwarding for the frame towards all destination ports.

The second is when a packet is forwarded from a port of lower link speed
towards a port of higher link speed. This is not handled by the hardware
and needs software intervention.

Since we practically need to update the cut-through forwarding domain
from paths that aren't serialized by the rtnl_mutex (phylink
mac_link_down/mac_link_up ops), this means we need to serialize physical
link events with user space updates of bonding/bridging domains.

Enabling cut-through forwarding is done per {egress port, traffic class}.
I don't see any reason why this would be a configurable option as long
as it works without issues, and there doesn't appear to be any user
space configuration tool to toggle this on/off, so this patch enables
cut-through forwarding on all eligible ports and traffic classes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3:
- follow Jakub's advice to disable cut-through on ports that are down
- follow Jakub's advice to update cut-through before a port joins a
  forwarding domain, and after it leaves, respectively
- introduce a mutex to serialize with phylink ops
- introduce a debugging print

v1->v2:
update the cut-through forwarding domain on
ocelot_phylink_mac_link_down() too, since the port that went down could
have been a port which was keeping cut-through disabled on the other
ports in its bridging domain, due to it being the only port with the
lowest speed. So a link down event can lead to cut-through forwarding
being enabled, and the driver should support that.

 drivers/net/dsa/ocelot/felix.c         | 12 +++-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 75 +++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c     | 77 +++++++++++++++++++++++---
 include/soc/mscc/ocelot.h              |  9 ++-
 4 files changed, 162 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index e487143709da..0e102caddb73 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -240,24 +240,32 @@ static int felix_tag_8021q_vlan_del(struct dsa_switch *ds, int port, u16 vid)
  */
 static void felix_8021q_cpu_port_init(struct ocelot *ocelot, int port)
 {
+	mutex_lock(&ocelot->fwd_domain_lock);
+
 	ocelot->ports[port]->is_dsa_8021q_cpu = true;
 	ocelot->npi = -1;
 
 	/* Overwrite PGID_CPU with the non-tagging port */
 	ocelot_write_rix(ocelot, BIT(port), ANA_PGID_PGID, PGID_CPU);
 
-	ocelot_apply_bridge_fwd_mask(ocelot);
+	ocelot_apply_bridge_fwd_mask(ocelot, true);
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 
 static void felix_8021q_cpu_port_deinit(struct ocelot *ocelot, int port)
 {
+	mutex_lock(&ocelot->fwd_domain_lock);
+
 	ocelot->ports[port]->is_dsa_8021q_cpu = false;
 
 	/* Restore PGID_CPU */
 	ocelot_write_rix(ocelot, BIT(ocelot->num_phys_ports), ANA_PGID_PGID,
 			 PGID_CPU);
 
-	ocelot_apply_bridge_fwd_mask(ocelot);
+	ocelot_apply_bridge_fwd_mask(ocelot, true);
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 
 /* Set up a VCAP IS2 rule for delivering PTP frames to the CPU port module.
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 42ac1952b39a..36f9c2e0e063 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2125,6 +2125,80 @@ static void vsc9959_psfp_init(struct ocelot *ocelot)
 	INIT_LIST_HEAD(&psfp->sgi_list);
 }
 
+/* When using cut-through forwarding and the egress port runs at a higher data
+ * rate than the ingress port, the packet currently under transmission would
+ * suffer an underrun since it would be transmitted faster than it is received.
+ * The Felix switch implementation of cut-through forwarding does not check in
+ * hardware whether this condition is satisfied or not, so we must restrict the
+ * list of ports that have cut-through forwarding enabled on egress to only be
+ * the ports operating at the lowest link speed within their respective
+ * forwarding domain.
+ */
+static void vsc9959_cut_through_fwd(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct dsa_switch *ds = felix->ds;
+	int port, other_port;
+
+	lockdep_assert_held(&ocelot->fwd_domain_lock);
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+		int min_speed = ocelot_port->speed;
+		unsigned long mask = 0;
+		u32 tmp, val = 0;
+
+		/* Disable cut-through on ports that are down */
+		if (ocelot_port->speed <= 0)
+			goto set;
+
+		if (dsa_is_cpu_port(ds, port)) {
+			/* Ocelot switches forward from the NPI port towards
+			 * any port, regardless of it being in the NPI port's
+			 * forwarding domain or not.
+			 */
+			mask = dsa_user_ports(ds);
+		} else {
+			mask = ocelot_get_bridge_fwd_mask(ocelot, port);
+			mask &= ~BIT(port);
+			if (ocelot->npi >= 0)
+				mask |= BIT(ocelot->npi);
+			else
+				mask |= ocelot_get_dsa_8021q_cpu_mask(ocelot);
+		}
+
+		/* Calculate the minimum link speed, among the ports that are
+		 * up, of this source port's forwarding domain.
+		 */
+		for_each_set_bit(other_port, &mask, ocelot->num_phys_ports) {
+			struct ocelot_port *other_ocelot_port;
+
+			other_ocelot_port = ocelot->ports[other_port];
+			if (other_ocelot_port->speed <= 0)
+				continue;
+
+			if (min_speed > other_ocelot_port->speed)
+				min_speed = other_ocelot_port->speed;
+		}
+
+		/* Enable cut-through forwarding for all traffic classes. */
+		if (ocelot_port->speed == min_speed)
+			val = GENMASK(7, 0);
+
+set:
+		tmp = ocelot_read_rix(ocelot, ANA_CUT_THRU_CFG, port);
+		if (tmp == val)
+			continue;
+
+		dev_dbg(ocelot->dev,
+			"port %d fwd mask 0x%lx speed %d min_speed %d, %s cut-through forwarding\n",
+			port, mask, ocelot_port->speed, min_speed,
+			val ? "enabling" : "disabling");
+
+		ocelot_write_rix(ocelot, val, ANA_CUT_THRU_CFG, port);
+	}
+}
+
 static const struct ocelot_ops vsc9959_ops = {
 	.reset			= vsc9959_reset,
 	.wm_enc			= vsc9959_wm_enc,
@@ -2136,6 +2210,7 @@ static const struct ocelot_ops vsc9959_ops = {
 	.psfp_filter_add	= vsc9959_psfp_filter_add,
 	.psfp_filter_del	= vsc9959_psfp_filter_del,
 	.psfp_stats_get		= vsc9959_psfp_stats_get,
+	.cut_through_fwd	= vsc9959_cut_through_fwd,
 };
 
 static const struct felix_info felix_info_vsc9959 = {
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 26feb030d1a6..03c716ef39cf 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -663,9 +663,17 @@ void ocelot_phylink_mac_link_down(struct ocelot *ocelot, int port,
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	int err;
 
+	ocelot_port->speed = SPEED_UNKNOWN;
+
 	ocelot_port_rmwl(ocelot_port, 0, DEV_MAC_ENA_CFG_RX_ENA,
 			 DEV_MAC_ENA_CFG);
 
+	if (ocelot->ops->cut_through_fwd) {
+		mutex_lock(&ocelot->fwd_domain_lock);
+		ocelot->ops->cut_through_fwd(ocelot);
+		mutex_unlock(&ocelot->fwd_domain_lock);
+	}
+
 	ocelot_fields_write(ocelot, port, QSYS_SWITCH_PORT_MODE_PORT_ENA, 0);
 
 	err = ocelot_port_flush(ocelot, port);
@@ -697,6 +705,8 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 	int mac_speed, mode = 0;
 	u32 mac_fc_cfg;
 
+	ocelot_port->speed = speed;
+
 	/* The MAC might be integrated in systems where the MAC speed is fixed
 	 * and it's the PCS who is performing the rate adaptation, so we have
 	 * to write "1000Mbps" into the LINK_SPEED field of DEV_CLOCK_CFG
@@ -769,6 +779,15 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 	ocelot_port_writel(ocelot_port, DEV_MAC_ENA_CFG_RX_ENA |
 			   DEV_MAC_ENA_CFG_TX_ENA, DEV_MAC_ENA_CFG);
 
+	/* If the port supports cut-through forwarding, update the masks before
+	 * enabling forwarding on the port.
+	 */
+	if (ocelot->ops->cut_through_fwd) {
+		mutex_lock(&ocelot->fwd_domain_lock);
+		ocelot->ops->cut_through_fwd(ocelot);
+		mutex_unlock(&ocelot->fwd_domain_lock);
+	}
+
 	/* Core: Enable port for frame transfer */
 	ocelot_fields_write(ocelot, port,
 			    QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
@@ -1542,7 +1561,7 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond,
 	return mask;
 }
 
-static u32 ocelot_get_bridge_fwd_mask(struct ocelot *ocelot, int src_port)
+u32 ocelot_get_bridge_fwd_mask(struct ocelot *ocelot, int src_port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[src_port];
 	const struct net_device *bridge;
@@ -1569,8 +1588,9 @@ static u32 ocelot_get_bridge_fwd_mask(struct ocelot *ocelot, int src_port)
 
 	return mask;
 }
+EXPORT_SYMBOL_GPL(ocelot_get_bridge_fwd_mask);
 
-static u32 ocelot_get_dsa_8021q_cpu_mask(struct ocelot *ocelot)
+u32 ocelot_get_dsa_8021q_cpu_mask(struct ocelot *ocelot)
 {
 	u32 mask = 0;
 	int port;
@@ -1587,12 +1607,22 @@ static u32 ocelot_get_dsa_8021q_cpu_mask(struct ocelot *ocelot)
 
 	return mask;
 }
+EXPORT_SYMBOL_GPL(ocelot_get_dsa_8021q_cpu_mask);
 
-void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
+void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot, bool joining)
 {
 	unsigned long cpu_fwd_mask;
 	int port;
 
+	lockdep_assert_held(&ocelot->fwd_domain_lock);
+
+	/* If cut-through forwarding is supported, update the masks before a
+	 * port joins the forwarding domain, to avoid potential underruns if it
+	 * has the highest speed from the new domain.
+	 */
+	if (joining && ocelot->ops->cut_through_fwd)
+		ocelot->ops->cut_through_fwd(ocelot);
+
 	/* If a DSA tag_8021q CPU exists, it needs to be included in the
 	 * regular forwarding path of the front ports regardless of whether
 	 * those are bridged or standalone.
@@ -1639,6 +1669,16 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 
 		ocelot_write_rix(ocelot, mask, ANA_PGID_PGID, PGID_SRC + port);
 	}
+
+	/* If cut-through forwarding is supported and a port is leaving, there
+	 * is a chance that cut-through was disabled on the other ports due to
+	 * the port which is leaving (it has a higher link speed). We need to
+	 * update the cut-through masks of the remaining ports no earlier than
+	 * after the port has left, to prevent underruns from happening between
+	 * the cut-through update and the forwarding domain update.
+	 */
+	if (!joining && ocelot->ops->cut_through_fwd)
+		ocelot->ops->cut_through_fwd(ocelot);
 }
 EXPORT_SYMBOL(ocelot_apply_bridge_fwd_mask);
 
@@ -1647,6 +1687,8 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u32 learn_ena = 0;
 
+	mutex_lock(&ocelot->fwd_domain_lock);
+
 	ocelot_port->stp_state = state;
 
 	if ((state == BR_STATE_LEARNING || state == BR_STATE_FORWARDING) &&
@@ -1656,7 +1698,9 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 	ocelot_rmw_gix(ocelot, learn_ena, ANA_PORT_PORT_CFG_LEARN_ENA,
 		       ANA_PORT_PORT_CFG, port);
 
-	ocelot_apply_bridge_fwd_mask(ocelot);
+	ocelot_apply_bridge_fwd_mask(ocelot, state == BR_STATE_FORWARDING);
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 EXPORT_SYMBOL(ocelot_bridge_stp_state_set);
 
@@ -1886,9 +1930,13 @@ void ocelot_port_bridge_join(struct ocelot *ocelot, int port,
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
+	mutex_lock(&ocelot->fwd_domain_lock);
+
 	ocelot_port->bridge = bridge;
 
-	ocelot_apply_bridge_fwd_mask(ocelot);
+	ocelot_apply_bridge_fwd_mask(ocelot, true);
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 EXPORT_SYMBOL(ocelot_port_bridge_join);
 
@@ -1897,11 +1945,15 @@ void ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
+	mutex_lock(&ocelot->fwd_domain_lock);
+
 	ocelot_port->bridge = NULL;
 
 	ocelot_port_set_pvid(ocelot, port, NULL);
 	ocelot_port_manage_port_tag(ocelot, port);
-	ocelot_apply_bridge_fwd_mask(ocelot);
+	ocelot_apply_bridge_fwd_mask(ocelot, false);
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 EXPORT_SYMBOL(ocelot_port_bridge_leave);
 
@@ -2023,12 +2075,16 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
 		return -EOPNOTSUPP;
 
+	mutex_lock(&ocelot->fwd_domain_lock);
+
 	ocelot->ports[port]->bond = bond;
 
 	ocelot_setup_logical_port_ids(ocelot);
-	ocelot_apply_bridge_fwd_mask(ocelot);
+	ocelot_apply_bridge_fwd_mask(ocelot, true);
 	ocelot_set_aggr_pgids(ocelot);
 
+	mutex_unlock(&ocelot->fwd_domain_lock);
+
 	return 0;
 }
 EXPORT_SYMBOL(ocelot_port_lag_join);
@@ -2036,11 +2092,15 @@ EXPORT_SYMBOL(ocelot_port_lag_join);
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond)
 {
+	mutex_lock(&ocelot->fwd_domain_lock);
+
 	ocelot->ports[port]->bond = NULL;
 
 	ocelot_setup_logical_port_ids(ocelot);
-	ocelot_apply_bridge_fwd_mask(ocelot);
+	ocelot_apply_bridge_fwd_mask(ocelot, false);
 	ocelot_set_aggr_pgids(ocelot);
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 EXPORT_SYMBOL(ocelot_port_lag_leave);
 
@@ -2331,6 +2391,7 @@ int ocelot_init(struct ocelot *ocelot)
 	mutex_init(&ocelot->stats_lock);
 	mutex_init(&ocelot->ptp_lock);
 	mutex_init(&ocelot->mact_lock);
+	mutex_init(&ocelot->fwd_domain_lock);
 	spin_lock_init(&ocelot->ptp_clock_lock);
 	spin_lock_init(&ocelot->ts_id_lock);
 	snprintf(queue_name, sizeof(queue_name), "%s-stats",
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 89d17629efe5..33f2e8c9e88b 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -561,6 +561,7 @@ struct ocelot_ops {
 	int (*psfp_filter_del)(struct ocelot *ocelot, struct flow_cls_offload *f);
 	int (*psfp_stats_get)(struct ocelot *ocelot, struct flow_cls_offload *f,
 			      struct flow_stats *stats);
+	void (*cut_through_fwd)(struct ocelot *ocelot);
 };
 
 struct ocelot_vcap_policer {
@@ -655,6 +656,8 @@ struct ocelot_port {
 
 	struct net_device		*bridge;
 	u8				stp_state;
+
+	int				speed;
 };
 
 struct ocelot {
@@ -712,6 +715,8 @@ struct ocelot {
 
 	/* Lock for serializing access to the MAC table */
 	struct mutex			mact_lock;
+	/* Lock for serializing forwarding domain changes */
+	struct mutex			fwd_domain_lock;
 
 	struct workqueue_struct		*owq;
 
@@ -811,7 +816,9 @@ void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs);
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port, bool enabled,
 			       struct netlink_ext_ack *extack);
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state);
-void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot);
+u32 ocelot_get_dsa_8021q_cpu_mask(struct ocelot *ocelot);
+u32 ocelot_get_bridge_fwd_mask(struct ocelot *ocelot, int src_port);
+void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot, bool joining);
 int ocelot_port_pre_bridge_flags(struct ocelot *ocelot, int port,
 				 struct switchdev_brport_flags val);
 void ocelot_port_bridge_flags(struct ocelot *ocelot, int port,
-- 
2.25.1

