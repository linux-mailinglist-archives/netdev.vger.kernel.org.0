Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E32331AE52
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 23:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhBMWjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 17:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhBMWjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 17:39:41 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298E4C06178A
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 14:38:25 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id g3so1564290edb.11
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 14:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FYx2G83HZwvEl+y2GWEzMK+m063grVkkXzLExcNG/Bg=;
        b=mL14sQaIRnXzg+Yz+QbyiPKA9z/P9vUB66ecYQeT4O3hV9F8UjiSm2FQbGIgqfA53j
         jB/bjOyD4D5dtjHYtUuDhg8SRppTm4MR6hwJbEzCxbKNvQyCxqftUZ9kluHo+ZtG9XIC
         5tU0JoFTThuX3BK9PvGxEGKao6nPu1bN2vNlWYlsAPKF/74o1DYC8go/6dN1Zgebdbn9
         qSuTUDjs3x9yK7mIWduA9bGe1vn8/iW/Bew4C26qT2h8DYex0isiyfGf3D0tfBx4DBVt
         8a7BxJ/SEpa/RKhdhHoAZnppKV3NDzp0q+j6w9sFJDVY1OgmlHaHQxgr7D+lx6T3Zq2t
         krjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FYx2G83HZwvEl+y2GWEzMK+m063grVkkXzLExcNG/Bg=;
        b=rwEJKWqies3AiSW8XfINUGuAAke/l1LUfAejMa1W/tZGkzZwSkTAoUZOZj+FnlofMs
         TFK1WObdCQ8kz06HFdHhy1uPxB+rWvYRPIj73E9Kh4Qpf30jJ6DOHxhi/taa+jaaAHB4
         TkZD0wF0AC1AV7+oCszeQ8sMCTU/ncSpGrFdxeM4LJW5J/ZOwzRqgVLdi8q5lAk1i6Ry
         wZCC/XYlceYHt3z7SvaZ4GYrvFdPfY4sX52FRs+JU59RN2O8bhlv7vmplMdwI0f4fm5x
         6bmYH98B1VDr26mXrwvPjNZXDjRwO6Vc18t83ugcVT7RKvX4xirdlTAlisBQEPrI09e+
         nmww==
X-Gm-Message-State: AOAM531odL5ncRdAIIFw0P1ZSYLwJnU6uJrjcuXlhFSSrLcxg/caJsOM
        vI3JF0T04a+PeK+KJSoGioc=
X-Google-Smtp-Source: ABdhPJzPk3gTX08+Zdynzzm1UMb4qytX2CWQrMkskYPJ3MBC77XAOuT+E8IqFNFQFRTKewfWjgYOhA==
X-Received: by 2002:a50:d84c:: with SMTP id v12mr6834683edj.68.1613255903892;
        Sat, 13 Feb 2021 14:38:23 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h3sm7662582edw.18.2021.02.13.14.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 14:38:23 -0800 (PST)
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
Subject: [PATCH v2 net-next 05/12] net: mscc: ocelot: refactor ocelot_port_inject_frame out of ocelot_port_xmit
Date:   Sun, 14 Feb 2021 00:37:54 +0200
Message-Id: <20210213223801.1334216-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213223801.1334216-1-olteanv@gmail.com>
References: <20210213223801.1334216-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The felix DSA driver will inject some frames through register MMIO, same
as ocelot switchdev currently does. So we need to be able to reuse the
common code.

Also create some shim definitions, since the DSA tagger can be compiled
without support for the switch driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Create shim definitions.

 drivers/net/ethernet/mscc/ocelot.c     | 80 +++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_net.c | 81 +++-----------------------
 include/soc/mscc/ocelot.h              | 22 +++++++
 3 files changed, 109 insertions(+), 74 deletions(-)

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
index 40792b37bb9f..a22aa944e921 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -742,6 +742,28 @@ u32 __ocelot_target_read_ix(struct ocelot *ocelot, enum ocelot_target target,
 void __ocelot_target_write_ix(struct ocelot *ocelot, enum ocelot_target target,
 			      u32 val, u32 reg, u32 offset);
 
+/* Packet I/O */
+#if IS_ENABLED(CONFIG_MSCC_OCELOT_SWITCH_LIB)
+
+bool ocelot_can_inject(struct ocelot *ocelot, int grp);
+void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
+			      u32 rew_op, struct sk_buff *skb);
+
+#else
+
+static inline bool ocelot_can_inject(struct ocelot *ocelot, int grp)
+{
+	return false;
+}
+
+static inline void ocelot_port_inject_frame(struct ocelot *ocelot, int port,
+					    int grp, u32 rew_op,
+					    struct sk_buff *skb)
+{
+}
+
+#endif
+
 /* Hardware initialization */
 int ocelot_regfields_init(struct ocelot *ocelot,
 			  const struct reg_field *const regfields);
-- 
2.25.1

