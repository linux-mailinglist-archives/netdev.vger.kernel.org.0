Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02972E0B1A
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 14:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgLVNq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 08:46:59 -0500
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:47547
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727301AbgLVNq6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 08:46:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TzqAEQ8AmCIGAWKYVQ4UXc2z2EHTl/AUkgtu+YF4iBqF0fMKakJNBF9Z98QATU85xjJ9b+/HcZSlOUK8MqoGpVBD5+O666mvfyjTPhZ3dXGCMs4EGZOItgZKxrhEGev/HJqaN57xZAVYnwNGChAI/QzLlxEFj92x7TRT31gXf4iB7ufQiTcLiOnCaSptrF5UKP7+oFoO4mbgPvmorgapzivT6gwFOhxWqzQ3hVDMdGu0YdV9msC0i/4hiUfSAM05hOGXIATqHvCPLv1OYqbv1IBZRTigHFx3AD/5iezV1kjXlxAR8tOwnrgmeZlPD62amyRB+KHpTrQ2N2ARK8D0pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XdZ8F7p3/C0TLMp/aAxe+MnBlSUZ4lgUKryXWa/5zOk=;
 b=mqLPqn1k7pPAY+dbQ2DxDKL1jQqvjwcWSCH0RS2RL+JnOZJ0wbWHxiYLGbXi6iVYuBEjkUUjL2HJGPk403fDmtY+bkiDZni3IHB0igA1d7bH6BwQft+5CQ1xBa8GALKmL7Jc0lQLXcocZRxldxrczVGv1vaBYmWmLkFqKjeGBBgWJou91q6L1DSFC2eq+qQxHr9JO6/ZlFRrxOrtGom5RdZOUNXhBSrhJ2uM6ubP3fIFfSIgnn1cDCdytnPtHTJs/NCQpjjKN3CBiUxQURCF3VMU1W1/7NzWzjKOYjsNFyb7e1SxqSnEkdPJeEs3/e2d1OVpottR+778MSPbmxdClw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XdZ8F7p3/C0TLMp/aAxe+MnBlSUZ4lgUKryXWa/5zOk=;
 b=Y15uJ8U8EWfB3xtJiJeJ6HmXwBd/lcOsxLZb5oErw6H7jvyQoqS+juXUuGso/fyzy4+3lng+VoSR5xdKChc3EZy1UG15M5ASShZgELNPXlsP7L8NypC1we+y7rqwcsIEAGs1t9HiF5CtbGUrO2X0EhV5W3Uv+Fv0k/YGlyga08U=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 13:45:02 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 13:45:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 10/15] net: mscc: ocelot: refactor ocelot_port_inject_frame out of ocelot_port_xmit
Date:   Tue, 22 Dec 2020 15:44:34 +0200
Message-Id: <20201222134439.2478449-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
References: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0169.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::23) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0169.eurprd08.prod.outlook.com (2603:10a6:800:d1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29 via Frontend Transport; Tue, 22 Dec 2020 13:45:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bc5d7e0f-f279-420e-6502-08d8a67fc860
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB74086CA54167B751DD9372FDE0DF0@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bxrUqYuVyTxGgl+BF+iu3/ROjigzeOXQYDec2S9P3H263OAD7sXbGKqc1ipZtHa7Z/1EwNVhmVxXU3SCa//NWQh92sb/TpEr9dCtkyje9cp538OJIQKkpxqnNGNP8YAK+1gV1nog1VTTsvh6QPlCTxA1Vlx3Fa/ujiiS/A4KKqdLYw9/7dioSZJKmjI7zCjMWEnEDf8c0Tz38IaKiugiPpeGLVMcAXF9/r/q2+DwXnw9QF2hDMKEBUU6/H83kKJZUuT0P36MZmHqCPc4z02vGmO4ClKbt2aQj1nTwyR1EIaDIP+hCs8iRuxGq+Xhtb3utLQKOIIe1XF64+z2RDi1wQRBJIBKxjwS16cwW/zzQycSj9IXmiIHEwKIh+aG2lKiaUNS0hpl2UOc2btS8fmpHEsa3yTiIJhFHVHmFxLbSmKrHkDjIkhETp+He1OtVHX6BW/+HYrdztTNnX9/xppXNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(69590400010)(8676002)(956004)(186003)(4326008)(36756003)(2616005)(6512007)(498600001)(16526019)(44832011)(2906002)(83380400001)(8936002)(110136005)(54906003)(26005)(6666004)(66476007)(5660300002)(6486002)(86362001)(6506007)(66946007)(1076003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HQ/w90Oi9+V8CRg04M971JOUDo1+njJzZl6mqAzhlDgOaoe9gLPCtasz2wfy?=
 =?us-ascii?Q?463wZCQAW9aJbmibqqIt/eIVRJ0uXzdUrxPw1PDHlFZCZ2/vHsSFKzg/fzo2?=
 =?us-ascii?Q?avhBmtTyxAVH62BA8ubK/WD/a7ZqjjSIQ+0cSoHUeMv1yvXy+NrKYjyGza46?=
 =?us-ascii?Q?VJ0Q0VLMU+1HEJJ1l9xS2vAgIYI8jusaMn/nxncfcqEWmc97iHlgmCLPj38O?=
 =?us-ascii?Q?OcAfHy0AqAvrda67XPjt0QoluV8uhloArLcNA8nkKVj/tOw4B4tQ+NtlyZrc?=
 =?us-ascii?Q?cQqHhJUruiPRVzFokn72eTkVJiNnkSeR4X7iwvqkEYNeMp/0xcbe2L+XoFiR?=
 =?us-ascii?Q?U449fqz9kYCMtat2N2tyxc32NUiXcLJvboVv0jTTE7wRzzOqdQDkmyKezCyi?=
 =?us-ascii?Q?LZqV8mmA/SUrNu35w3xtLmE7TUNfv1ueFkGd8Cs7ey/demXrG0Ryy4SskxPQ?=
 =?us-ascii?Q?Djs3PNB9zdrTIXgBz0huq4Ofc0RVRNZO6K8u4C/gdfSoZRuXjLckamTsUqL2?=
 =?us-ascii?Q?dt5XQgbvuLNfpnYUr2f22JiE8MtbfvhEKDufBohJCJnoXpY+IyNXx+OfJ4G4?=
 =?us-ascii?Q?QLL/5cli6yHcEDUXc1Tzopnuk0+vtVVMCOb6JUSQ7wpn307+gWXK1JiusKdG?=
 =?us-ascii?Q?T1KGGgZCsDnL24KuM0nGA9VYiF84uUXEF1suaUqBodoLjzwAMJPi9L1s+qGw?=
 =?us-ascii?Q?yDueWLzZsQRpTzMrfQJRpG4PyZrzQodCUY0FVZDFqiuvC9Nt1bn+QO4u1uCy?=
 =?us-ascii?Q?BNhyuHDaDs3fqRT1QAGHBVMFcC3AyduXp41M3wA8+lTrKtt0J/edvjjlw1mv?=
 =?us-ascii?Q?h/0NFgKzqK/t01+5JCyvxSQz4UYqAjzIBTkojzIhQSkI+XEi77Wg5I+Fz7jW?=
 =?us-ascii?Q?SgrqsCz+4SLX/9dTsO+PEVBecZ9OtkYYYUN+5BseD6PbIiGB4nc1J+OGz0z3?=
 =?us-ascii?Q?6JTtC8TNTO+StOxzpd374vdVNLNOCnMObgkoX+x16ouGUw2J5tSJhxJNt6bc?=
 =?us-ascii?Q?Gl/s?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 13:45:02.4183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: bc5d7e0f-f279-420e-6502-08d8a67fc860
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J7hXl9wW00GB3jKxkwkfr3KzCDFd4+tqndQceEJUVHPj4NwKNSeimJrSiixaBE5nKeO+dGziCbXrMtFeUpEUnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The felix DSA driver will inject some frames through register MMIO, same
as ocelot switchdev currently does. So we need to be able to reuse the
common code.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot.c     | 78 +++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.h     |  4 ++
 drivers/net/ethernet/mscc/ocelot_net.c | 81 +++-----------------------
 3 files changed, 89 insertions(+), 74 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index be4671bfe95f..52f6c986aef0 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -566,6 +566,84 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 }
 EXPORT_SYMBOL(ocelot_get_txtstamp);
 
+/* Generate the IFH for frame injection
+ *
+ * The IFH is a 128bit-value
+ * bit 127: bypass the analyzer processing
+ * bit 56-67: destination mask
+ * bit 28-29: pop_cnt: 3 disables all rewriting of the frame
+ * bit 20-27: cpu extraction queue mask
+ * bit 16: tag type 0: C-tag, 1: S-tag
+ * bit 0-11: VID
+ */
+static int ocelot_gen_ifh(u32 *ifh, struct frame_info *info)
+{
+	ifh[0] = IFH_INJ_BYPASS | ((0x1ff & info->rew_op) << 21);
+	ifh[1] = (0xf00 & info->port) >> 8;
+	ifh[2] = (0xff & info->port) << 24;
+	ifh[3] = (info->tag_type << 16) | info->vid;
+
+	return 0;
+}
+
+bool ocelot_can_inject(struct ocelot *ocelot, int grp)
+{
+	u32 val = ocelot_read(ocelot, QS_INJ_STATUS);
+
+	if (!(val & QS_INJ_STATUS_FIFO_RDY(BIT(grp))))
+		return false;
+	if (val & QS_INJ_STATUS_WMARK_REACHED(BIT(grp)))
+		return false;
+
+	return true;
+}
+
+void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
+			      u32 rew_op, struct sk_buff *skb)
+{
+	struct frame_info info = {};
+	u32 ifh[OCELOT_TAG_LEN / 4];
+	unsigned int i, count, last;
+
+	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
+			 QS_INJ_CTRL_SOF, QS_INJ_CTRL, grp);
+
+	info.port = BIT(port);
+	info.tag_type = IFH_TAG_TYPE_C;
+	info.vid = skb_vlan_tag_get(skb);
+	info.rew_op = rew_op;
+
+	ocelot_gen_ifh(ifh, &info);
+
+	for (i = 0; i < OCELOT_TAG_LEN / 4; i++)
+		ocelot_write_rix(ocelot, (__force u32)cpu_to_be32(ifh[i]),
+				 QS_INJ_WR, grp);
+
+	count = DIV_ROUND_UP(skb->len, 4);
+	last = skb->len % 4;
+	for (i = 0; i < count; i++)
+		ocelot_write_rix(ocelot, ((u32 *)skb->data)[i], QS_INJ_WR, grp);
+
+	/* Add padding */
+	while (i < (OCELOT_BUFFER_CELL_SZ / 4)) {
+		ocelot_write_rix(ocelot, 0, QS_INJ_WR, grp);
+		i++;
+	}
+
+	/* Indicate EOF and valid bytes in last word */
+	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
+			 QS_INJ_CTRL_VLD_BYTES(skb->len < OCELOT_BUFFER_CELL_SZ ? 0 : last) |
+			 QS_INJ_CTRL_EOF,
+			 QS_INJ_CTRL, grp);
+
+	/* Add dummy CRC */
+	ocelot_write_rix(ocelot, 0, QS_INJ_WR, grp);
+	skb_tx_timestamp(skb);
+
+	skb->dev->stats.tx_packets++;
+	skb->dev->stats.tx_bytes += skb->len;
+}
+
 int ocelot_fdb_add(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid)
 {
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 291d39d49c4e..e7685a58b7e2 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -126,6 +126,10 @@ void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
 			 enum ocelot_tag_prefix injection,
 			 enum ocelot_tag_prefix extraction);
 
+bool ocelot_can_inject(struct ocelot *ocelot, int grp);
+void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
+			      u32 rew_op, struct sk_buff *skb);
+
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
 extern struct notifier_block ocelot_switchdev_blocking_nb;
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 7cc0fcd1df8d..942eb56535b7 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -311,53 +311,20 @@ static int ocelot_port_stop(struct net_device *dev)
 	return 0;
 }
 
-/* Generate the IFH for frame injection
- *
- * The IFH is a 128bit-value
- * bit 127: bypass the analyzer processing
- * bit 56-67: destination mask
- * bit 28-29: pop_cnt: 3 disables all rewriting of the frame
- * bit 20-27: cpu extraction queue mask
- * bit 16: tag type 0: C-tag, 1: S-tag
- * bit 0-11: VID
- */
-static int ocelot_gen_ifh(u32 *ifh, struct frame_info *info)
-{
-	ifh[0] = IFH_INJ_BYPASS | ((0x1ff & info->rew_op) << 21);
-	ifh[1] = (0xf00 & info->port) >> 8;
-	ifh[2] = (0xff & info->port) << 24;
-	ifh[3] = (info->tag_type << 16) | info->vid;
-
-	return 0;
-}
-
-static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
-	u32 val, ifh[OCELOT_TAG_LEN / 4];
-	struct frame_info info = {};
-	u8 grp = 0; /* Send everything on CPU group 0 */
-	unsigned int i, count, last;
 	int port = priv->chip_port;
+	u32 rew_op = 0;
 
-	val = ocelot_read(ocelot, QS_INJ_STATUS);
-	if (!(val & QS_INJ_STATUS_FIFO_RDY(BIT(grp))) ||
-	    (val & QS_INJ_STATUS_WMARK_REACHED(BIT(grp))))
+	if (!ocelot_can_inject(ocelot, 0))
 		return NETDEV_TX_BUSY;
 
-	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
-			 QS_INJ_CTRL_SOF, QS_INJ_CTRL, grp);
-
-	info.port = BIT(port);
-	info.tag_type = IFH_TAG_TYPE_C;
-	info.vid = skb_vlan_tag_get(skb);
-
 	/* Check if timestamping is needed */
-	if (ocelot->ptp && (shinfo->tx_flags & SKBTX_HW_TSTAMP)) {
-		info.rew_op = ocelot_port->ptp_cmd;
+	if (ocelot->ptp && (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
+		rew_op = ocelot_port->ptp_cmd;
 
 		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
 			struct sk_buff *clone;
@@ -370,45 +337,11 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 
 			ocelot_port_add_txtstamp_skb(ocelot, port, clone);
 
-			info.rew_op |= clone->cb[0] << 3;
+			rew_op |= clone->cb[0] << 3;
 		}
 	}
 
-	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP) {
-		info.rew_op = ocelot_port->ptp_cmd;
-		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
-			info.rew_op |= skb->cb[0] << 3;
-	}
-
-	ocelot_gen_ifh(ifh, &info);
-
-	for (i = 0; i < OCELOT_TAG_LEN / 4; i++)
-		ocelot_write_rix(ocelot, (__force u32)cpu_to_be32(ifh[i]),
-				 QS_INJ_WR, grp);
-
-	count = DIV_ROUND_UP(skb->len, 4);
-	last = skb->len % 4;
-	for (i = 0; i < count; i++)
-		ocelot_write_rix(ocelot, ((u32 *)skb->data)[i], QS_INJ_WR, grp);
-
-	/* Add padding */
-	while (i < (OCELOT_BUFFER_CELL_SZ / 4)) {
-		ocelot_write_rix(ocelot, 0, QS_INJ_WR, grp);
-		i++;
-	}
-
-	/* Indicate EOF and valid bytes in last word */
-	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
-			 QS_INJ_CTRL_VLD_BYTES(skb->len < OCELOT_BUFFER_CELL_SZ ? 0 : last) |
-			 QS_INJ_CTRL_EOF,
-			 QS_INJ_CTRL, grp);
-
-	/* Add dummy CRC */
-	ocelot_write_rix(ocelot, 0, QS_INJ_WR, grp);
-	skb_tx_timestamp(skb);
-
-	dev->stats.tx_packets++;
-	dev->stats.tx_bytes += skb->len;
+	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
 
 	kfree_skb(skb);
 
-- 
2.25.1

