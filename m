Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938B531A8AC
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhBMAPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbhBMAPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:15:48 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CB0C06178A
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:33 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id y9so1995438ejp.10
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ylXrqQOgEbEe2mRnGFiRkaeO2Wc94t0vCDLSbcHr4fw=;
        b=R8JEKmiMXD5KVnDb/nwxlpDreZa0uzkD9FS14hHTYjngs95KIUNHHKXw/UncpHVkKM
         oi7for3Jii/K3sIHmZNKbYviedUzHqupCiMBoLrXkZBGqkeEe7dcIp9Z526t6nDfOTNQ
         3Xw/1UOI/H2PnscUTn3zAa05HJzSe1TKYDCu8g9HOICnWbRL9KKWNTdLrMgdh1iUQISv
         UhIlwIK59F5/mKzIlmkFolahxnfFH9ujJLkqHFnhj/e4X/uxJt3z7sEE+3kDBlorOfgW
         pex6pmbw7IMMQyxQCRvMBC77r7vh/XPNatjK9EssSc9yBYy4gwyPacQEW40g2cYwNupa
         onuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ylXrqQOgEbEe2mRnGFiRkaeO2Wc94t0vCDLSbcHr4fw=;
        b=BCSaoobXBVcb5E0MVONs5Kgs6+qZQHe1sFeZmzm49j+lJQNaLOC7QaL3aQeIWabyPN
         2AAAOnY3LPIBhdVxnSuaRNuIRUpP+NMU5Ruk55cXwm4L7ZNivkvhAHPI+EFqdW5hMVmX
         //HtlYGKYtkwsKJNeUdSM/wN1+uCZG0ogoU7VaSV1URtXP4WBjixIdOr4OmvMiedo/Br
         is5b9OErPJwxnlbUP4/XL1o8zVWFZiMdm8RtdQT0N1Lzu4PDdt26tiUoPRp0R45kzpfk
         prLtcO/JIbJVT4GlzJUEhIrPoib6x8AKmaUjM3LqvvAft8BDJkP+FX28coWf2IbeHIoN
         gsHw==
X-Gm-Message-State: AOAM531xonht2S7cE/AEp0Tl/ea43q3RzmlYVDCd4bhrM9bc1/VH2ckO
        nAMYMZJFySGqO+n9Ie+YIa4=
X-Google-Smtp-Source: ABdhPJydFpNB378YCQDjmuVpnT/dQVT4/FU8bJdufcA0Whj7ke2rZbjSCRKhzOmoXNAIrpwMumqyKA==
X-Received: by 2002:a17:906:82c9:: with SMTP id a9mr5174375ejy.547.1613175271989;
        Fri, 12 Feb 2021 16:14:31 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id c1sm7015606eja.81.2021.02.12.16.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 16:14:31 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 05/12] net: mscc: ocelot: refactor ocelot_port_inject_frame out of ocelot_port_xmit
Date:   Sat, 13 Feb 2021 02:14:05 +0200
Message-Id: <20210213001412.4154051-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213001412.4154051-1-olteanv@gmail.com>
References: <20210213001412.4154051-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The felix DSA driver will inject some frames through register MMIO, same
as ocelot switchdev currently does. So we need to be able to reuse the
common code.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c     | 80 +++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_net.c | 81 +++-----------------------
 include/soc/mscc/ocelot.h              |  4 ++
 3 files changed, 91 insertions(+), 74 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index d1a9cdbf7a3e..7106d9ee534a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -628,6 +628,86 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
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
+EXPORT_SYMBOL(ocelot_can_inject);
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
+EXPORT_SYMBOL(ocelot_port_inject_frame);
+
 int ocelot_fdb_add(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid)
 {
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 1ab453298a18..6518262532f0 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -488,53 +488,20 @@ static int ocelot_port_stop(struct net_device *dev)
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
@@ -547,45 +514,11 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 
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
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 40792b37bb9f..656fd8bc818d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -847,4 +847,8 @@ int ocelot_sb_occ_tc_port_bind_get(struct ocelot *ocelot, int port,
 				   enum devlink_sb_pool_type pool_type,
 				   u32 *p_cur, u32 *p_max);
 
+bool ocelot_can_inject(struct ocelot *ocelot, int grp);
+void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
+			      u32 rew_op, struct sk_buff *skb);
+
 #endif
-- 
2.25.1

