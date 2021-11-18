Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960F84562FC
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 19:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbhKRS6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 13:58:35 -0500
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:40737
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232724AbhKRS6f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 13:58:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxY6OC0Smw8i+1Z3iOfnJVhkwXk+kmMefPRFc84weLsZ+uL92RSJNblANlvmeWosoyQSYI5x/l9K1Zc1IUSOXlVJjWmK0n6k9TzIezBxcnelQ52dUAZeSfyqSdk2XNqFft/heZgBf2VoHl+liBNElRUDloGsHWgE0cHQNAAZAiqxc0m3NSTiGjb6yUZGZc3c4qWtZfsuG0FTsxvzOn7JBvk2XFmzjODf9jacP8CQahSXm8SwBTkGm1Gd8HXwLxCzc8P2W/Mf1TPHYMdSRk3KKg7jknC0qB6Z49EF2WycJxNWeg2bJCvdPZjpzhloxJXTpBdE0W2tmKrJLWXeextbdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jqYBCaDVzUn6b5NIM/raMl5yECukfWHYIl3t42qGzGM=;
 b=c7GaXm+IMIQQTWcTdvkYFHdIcj54P6q5Oo6Xn25IHHvKSTEI7myNhEEG3fJ8Nvq1B9e7ibYr+cRMQGRmU1zvg2gbERTxWB6+lmiQL+q5WS35TkFPC9HUWfTddxGMXF0YN1iQwuYTak/kx2YqcVETRNx392PxE5gbLp3fpfhkM29TCK+xFnfjJmb7t5X778qP3R+31AyaRpkpnXBEHJy7lX/ZNCFbzR0ofjebvwm7Qt3SkSoNEW9nQxp+60eLiBSFfI3BcsQXC/n/LTr3j36J5y0z8AQZVukYsmGnBwY/VnW9qAKp5osEpd3qUeBomt2/tGfuluwO//33T3aHRq+ELw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqYBCaDVzUn6b5NIM/raMl5yECukfWHYIl3t42qGzGM=;
 b=B+Be6QUK7v3CYqsk2CTiUaAB2wQbVusSlmZAhGNTvx9lEMrAdhgrYWNuH1nGNqemLZXeH6BDiX0x93h3Fy5kVLJ5Wy+VJBM9+Xg1UipUl90ptnwZ30VcbTHaOc6FK5lPCuF4GNRsVmLhTn+cd1W7M9S2e32HGk2UKIQdqKK4qaQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3549.eurprd04.prod.outlook.com (2603:10a6:803:8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Thu, 18 Nov
 2021 18:55:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4713.022; Thu, 18 Nov 2021
 18:55:31 +0000
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
Subject: [PATCH net-next] net: dsa: felix: enable cut-through forwarding between ports by default
Date:   Thu, 18 Nov 2021 20:53:52 +0200
Message-Id: <20211118185352.2504417-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0067.eurprd07.prod.outlook.com
 (2603:10a6:207:4::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.163.189) by AM3PR07CA0067.eurprd07.prod.outlook.com (2603:10a6:207:4::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Thu, 18 Nov 2021 18:55:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04769c75-0d07-4361-c6ca-08d9aac4fe98
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3549:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3549D05BC7AD4CF34CAC2F6AE09B9@VI1PR0402MB3549.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zkyp7uKoZZOyhTD3BsQao33Iv5HTcBiqfmeiVy3X0NNzmkOXcWlUdE3q5MS/KY3hfI7dIKe5CGX/dKuCAf1UgXeX5O4JGNr+HiCTJVIvMoL9awcBqrtW7jQwO+FoZ1ygp5rWHkdrpm904QyWQJIYSmDnWlTWKwHLjDIhhIhkwH4bOjzZk9ZW7T7wBfovRFsBm1pL4nHHv/Sprhn+YNpWA7jj4i5eNBzFCgUTeYjv7ypGDYfpEZDnSwT+hyCXFskczIjgBEj/+W8Pf1I3tD+7n/fMxnTEhj7V3zaLjX8ZpCncAcre97Pa42gGRb0t9iC/HISu90dFbyVWZsiga/Yq5Pl9AW2QAYqg5bPsWa23COjhR1Wzhlu5qdq5mC+9kQOOzVrv9o386dKO6W9+okN6v1D1EexT3WrPDcD/6Wzb0EBdddbjTA/jy3IbYkw/HB9lxwL1h4P2WQHEnN345mEWLdj0dyjWMPCEv5RRjmgQZZorH2VE/QHxB0OqvzTKyTv0+8N7r4E+XuHUM+jLgoK18xjHqA5mZc2kKNiV/tCNCCMTsJEjV9GGnCmd8KPXuIhq25eIS2uvfc//+VYKfhKZzMzulBXMF7K7x2kWL6AuM2YAEQzi1r6f59EgrSCSgkGaTnwYcan2pspZO+vbBb+ksf1z47ouiO6vmq1eVtZaHegXtdYPDYr9A7RPeXNRMejsQDFZLrAiZ7cV+p9w9YjHSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(956004)(2616005)(44832011)(508600001)(4326008)(86362001)(2906002)(83380400001)(36756003)(316002)(54906003)(6666004)(66476007)(186003)(6506007)(8676002)(66946007)(66556008)(6512007)(6916009)(5660300002)(52116002)(1076003)(38100700002)(38350700002)(8936002)(6486002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ru/5a7Kn3wBB+4M0YH/nDrW7rVwb2Y9sSJZ5ozEamqBBpvehCyQnBziJpAIq?=
 =?us-ascii?Q?VrEhVbbvUs1vzFeE08DaYZt/cyxrQ2nFIP89i0d9Mmt7Q+bwzoWetCwK0/3c?=
 =?us-ascii?Q?oYt+RhHp1Jni7JNqGWVihsKN2N9SINz33S9NUKAxe9ld0LfJWN+oMJjahId3?=
 =?us-ascii?Q?V5qO99RtHciScUbtA402AVcT2cchDTuAgfZWrRSWqw61Oa6eSuzBjNmnsFn4?=
 =?us-ascii?Q?En32FNHNfwOusU56tEHeZyQQLTK/loN2CmANOtmvlcqneY5eZBRxlFkQv0yM?=
 =?us-ascii?Q?A4aMpdOzjWLfv5GqfwLUrQl+UXdtQsR6MXKKdbVLJ6k3i0MGl6BWaiyNmhRt?=
 =?us-ascii?Q?JOt5e2RA02CLotvriBTpyt7R0DAlVSLYIcAhLKmMbqPYdlFtIl0V4EyNF/C5?=
 =?us-ascii?Q?hANj6HJGi7CNwESZqP6RVFfiPMrh3WtS0Z+Kx6gynZIMjRHMMZQ5Dr+cabz1?=
 =?us-ascii?Q?bb458ZlAAx3oHtsJJJvKaZk9gXe27UG7xycriVhGDWemFZoA2avnUbkCTLG3?=
 =?us-ascii?Q?6DG52bqxY8IN10UyZC65zQOpWjcNKjePb0Qp9/+TYi6aP8sblIkfqDUYIcCk?=
 =?us-ascii?Q?YMJAIqazIhpW8KSLL73ou+PqLKZTRPwlhu1uycjYW0Nk4lZrTKxqfh12Uf8Q?=
 =?us-ascii?Q?1LIWTpwlxCPuo3TecEKSgr08pJhbGrV8iSfeiLDEFTxZ65QvSH9kXnxlHDVh?=
 =?us-ascii?Q?0iJUR3r/4VQB/XNvUC+kgcuSIqt2cHLOX4N8cQelGL8y5alALtbSXZBpswZ4?=
 =?us-ascii?Q?+dG89MXgK8h49ypjwzVifKFPOt+RcMeg8pjLpt1b70rB68CvlljToOX92CQ1?=
 =?us-ascii?Q?RYRHX4eomk5yLUTOYZtv85pw6nNFWXoAcewF3o/GObFCnA+r7lQk+M982b4j?=
 =?us-ascii?Q?RE+Sr9Ljc1TteiVGY0usLIiSb1H9caYzvrB/jQLJXIzOUjkBrA3ghyfjxaI1?=
 =?us-ascii?Q?OAmLVbfT9w7koViETyHfnjjdsfTRbbhtu6gpnowMaxghRa242zIC8aMQZzzS?=
 =?us-ascii?Q?BldiOUAhp3oZR7kVL87m2mACiRv8xFGSbChW35EokkykPxaAubxULe8pVC6Q?=
 =?us-ascii?Q?JG6a99rOz4X9iOXP08GtJdPeLR6zUhPrZo3jsZX+JnzNEPTBJJLUIpi2Hkzk?=
 =?us-ascii?Q?KetnH+Ig6NzOPzvaVVuEgKQ/4Fsp+e72Ml/A0MyP6IAOKiW5W8ssrGlpNIlW?=
 =?us-ascii?Q?ytksb3WvE0IwAG3cAMkm5NYJ3PSQFDrcajy0FyHLS1evjHJX8+YqFp9IYxXA?=
 =?us-ascii?Q?aeXhO+yorHBRHQuZuEw14lu1/koZ+6ut/xlGxryrviTycabPLuFqz6fHYVT3?=
 =?us-ascii?Q?jCBXbTuFcktNKbCVKlC5ETadJYperCf1Rw6DfhFuW1MucundqF7GxpKHP1db?=
 =?us-ascii?Q?PJDFFYS8oE26qEGZOBh6EbUOOv3kcsvPd3B9oiXAanuqKEUQSvkYAQoa11AS?=
 =?us-ascii?Q?3HZXGdW+nKJKvRMTobpCLmF4tsiVV6SbGzh64Pj4Ns2eaBx6XL3eegVuSGVO?=
 =?us-ascii?Q?66aPhn0tgEU9otJpxVhiKez3kiUloKMWsVNdUWSKeJV+ocR77QdOQZiigltV?=
 =?us-ascii?Q?8IWIO7JuLwlMA9ikHfe5+4mfMSpOb7G/4NlIwF+bLpQN7t/fJQC0h3ulRC7B?=
 =?us-ascii?Q?FoMwrYizjm9bwlduo6M2G5s=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04769c75-0d07-4361-c6ca-08d9aac4fe98
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 18:55:31.3291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HuDSPm5fdrwNHRLS+yBtv5xRhhs8tRONWQv+bFHzJI9sQLnkQuC5zxQHVtPBjD9h5/v/fMsUy2rJEPkGbfyLnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
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
the FDB or incorrect policer updates, since these are processes are
deferred inside the switch to the end of frame. Since the switch starts
the cut-through forwarding process after all packet headers (including
IP, if any) have been processed, packets with large headers and small
payload do not see the benefit of lower forwarding latency.

There are two cases that need special attention.

The first is when a packet is multicast (or flooded) to multiple
destinations, one of which doesn't have cut-through forwarding enabled.
The switch deals with this automatically by disabling cut-through
forwarding for the frame towards all destination ports.

The second is when a packet is forwarded from a port of lower link speed
towards a port of higher link speed. This is not handled by the hardware
and needs software intervention.

Enabling cut-through forwarding is done per {egress port, traffic class}.
I don't see any reason why this would be a configurable option as long
as it works without issues, and there doesn't appear to be any user
space configuration tool to toggle this on/off, so this patch enables
cut-through forwarding on all eligible ports and traffic classes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 61 ++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c     | 10 +++++
 include/soc/mscc/ocelot.h              |  3 ++
 3 files changed, 74 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 42ac1952b39a..b7941d4dbfc6 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2125,6 +2125,66 @@ static void vsc9959_psfp_init(struct ocelot *ocelot)
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
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+		unsigned long mask;
+		int min_speed;
+		u32 val = 0;
+
+		if (ocelot_port->speed <= 0)
+			continue;
+
+		min_speed = ocelot_port->speed;
+		if (port == ocelot->npi) {
+			/* Ocelot switches forward from the NPI port towards
+			 * any port, regardless of it being in the NPI port's
+			 * forwarding domain or not.
+			 */
+			mask = dsa_user_ports(ds);
+		} else {
+			mask = ocelot_read_rix(ocelot, ANA_PGID_PGID,
+					       PGID_SRC + port);
+			/* Ocelot switches forward to the NPI port despite it
+			 * not being in the source ports' forwarding domain.
+			 */
+			if (ocelot->npi >= 0)
+				mask |= BIT(ocelot->npi);
+		}
+
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
+		ocelot_write_rix(ocelot, val, ANA_CUT_THRU_CFG, port);
+	}
+}
+
 static const struct ocelot_ops vsc9959_ops = {
 	.reset			= vsc9959_reset,
 	.wm_enc			= vsc9959_wm_enc,
@@ -2136,6 +2196,7 @@ static const struct ocelot_ops vsc9959_ops = {
 	.psfp_filter_add	= vsc9959_psfp_filter_add,
 	.psfp_filter_del	= vsc9959_psfp_filter_del,
 	.psfp_stats_get		= vsc9959_psfp_stats_get,
+	.cut_through_fwd	= vsc9959_cut_through_fwd,
 };
 
 static const struct felix_info felix_info_vsc9959 = {
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 95920668feb0..dcc654289dac 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -682,6 +682,8 @@ void ocelot_phylink_mac_link_down(struct ocelot *ocelot, int port,
 				 DEV_CLOCK_CFG_MAC_TX_RST |
 				 DEV_CLOCK_CFG_MAC_RX_RST,
 				 DEV_CLOCK_CFG);
+
+	ocelot_port->speed = SPEED_UNKNOWN;
 }
 EXPORT_SYMBOL_GPL(ocelot_phylink_mac_link_down);
 
@@ -697,6 +699,8 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 	int mac_speed, mode = 0;
 	u32 mac_fc_cfg;
 
+	ocelot_port->speed = speed;
+
 	/* The MAC might be integrated in systems where the MAC speed is fixed
 	 * and it's the PCS who is performing the rate adaptation, so we have
 	 * to write "1000Mbps" into the LINK_SPEED field of DEV_CLOCK_CFG
@@ -772,6 +776,9 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 	/* Core: Enable port for frame transfer */
 	ocelot_fields_write(ocelot, port,
 			    QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
+
+	if (ocelot->ops->cut_through_fwd)
+		ocelot->ops->cut_through_fwd(ocelot);
 }
 EXPORT_SYMBOL_GPL(ocelot_phylink_mac_link_up);
 
@@ -1637,6 +1644,9 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 
 		ocelot_write_rix(ocelot, mask, ANA_PGID_PGID, PGID_SRC + port);
 	}
+
+	if (ocelot->ops->cut_through_fwd)
+		ocelot->ops->cut_through_fwd(ocelot);
 }
 EXPORT_SYMBOL(ocelot_apply_bridge_fwd_mask);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 89d17629efe5..611847ee5faf 100644
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
-- 
2.25.1

