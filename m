Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F462FA5F6
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406597AbhARQVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406513AbhARQTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 11:19:17 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E262C061795
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:18:00 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id b2so18197336edm.3
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nLL4vHgkBQldmoHxzvQcF1sMnA0U1OUvTnFkDHgqpK8=;
        b=uAdrYZCJyHLHzqUapHPcHcOWsCsbAFPaW3YCUC23oLzpWZkeA3dzTdogaIoaDScGfw
         5qqd5QB1oQ0hnQaZou8cIkMY1vE1/43OvJTv74em+OYb4W7Fytiy7+7dQvdKHFTy+arh
         vA7k4Z8YYXY6X0Uzh0l2k3JyofPPyZiAk4RJkTP1IYIL3KRkwaJgpAzULC2DgY3uvZwG
         nGzyugib/Yzx5vX8kQZh7G+M39YW2SixM2TFK5o4DFngTBswMB8NbiUKrPgzSd+D8+gi
         VqBD8A7Fh3jIBge8Wy10ctuxobJwj5jKeOhpxZbRVzyzm9wXhLVuYnVehZOjEPUqYlHY
         5M0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nLL4vHgkBQldmoHxzvQcF1sMnA0U1OUvTnFkDHgqpK8=;
        b=AmZ+o90I1MWU34MQ4TPdDEaK0rqGkan6eAFA6rrbGFqrdYiVd1N8hT5qL3nDJzuYy5
         zF8l1esZ/XtPMHMgdbJyOMXBLPl2qJ3N61FxzRQ3qZ2uwyvwkbg3HEDR1KO3QOZaD89N
         7dZ0cVRDXUMb+HDCDqOH2RGqp+Tui23IopAJSO6hZIhfdiblz5go86JbBB2Sr9c/34SW
         lzlALaLtBDCAcFuIlFgsqTEBovrLp+j/nWdk8F+6IzYsJ1KpusPtsQkWUmGf/7M6EiSP
         EHWJEq7ZTTqVpBK3PZ/LAXl5QhCbF5sETqFgZwtmmwHsQYjSbUN7CvXItPXhQU05pGl2
         bwHA==
X-Gm-Message-State: AOAM531/D0uICeOc62WtLBwCajQa5kjwclpXE1iDyBPdUsvhaRvoDAX6
        mVrbMy0seGzsh45a8CuCBHI=
X-Google-Smtp-Source: ABdhPJxiQZetiSahpXpJe9IxwgqEHGrhSpVWDiN8tm7Hrl8/N0Wlv5k6jbpx0Or26p7ERWYW5ny+uw==
X-Received: by 2002:a50:ef04:: with SMTP id m4mr156305eds.283.1610986678967;
        Mon, 18 Jan 2021 08:17:58 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u23sm6093781edt.78.2021.01.18.08.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 08:17:58 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 12/15] net: mscc: ocelot: refactor ocelot_xtr_irq_handler into ocelot_xtr_poll
Date:   Mon, 18 Jan 2021 18:17:28 +0200
Message-Id: <20210118161731.2837700-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118161731.2837700-1-olteanv@gmail.com>
References: <20210118161731.2837700-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since the felix DSA driver will need to poll the CPU port module for
extracted frames as well, let's create some common functions that read
an Extraction Frame Header, and then an skb, from a CPU extraction
group.

This is so complicated, because the procedure to retrieve a struct
net_device pointer based on the source port is different for DSA and
switchdev. So this is the reason why the polling function is split in
the middle. The ocelot_xtr_poll_xfh() permits the caller to get a struct
net_device pointer based on the XFH port field, then pass this to the
ocelot_xtr_poll_frame() function.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot.c         | 163 +++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.h         |   6 +
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 158 ++------------------
 3 files changed, 179 insertions(+), 148 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e32a7f869faa..ac6b9942052a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -12,6 +12,9 @@
 #define TABLE_UPDATE_SLEEP_US 10
 #define TABLE_UPDATE_TIMEOUT_US 100000
 
+#define IFH_EXTRACT_BITFIELD64(x, o, w) \
+	(((x) >> (o)) & GENMASK_ULL((w) - 1, 0))
+
 struct ocelot_mact_entry {
 	u8 mac[ETH_ALEN];
 	u16 vid;
@@ -561,6 +564,166 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 }
 EXPORT_SYMBOL(ocelot_get_txtstamp);
 
+static int ocelot_parse_xfh(u32 *_ifh, struct ocelot_frame_info *info)
+{
+	u8 llen, wlen;
+	u64 ifh[2];
+
+	ifh[0] = be64_to_cpu(((__force __be64 *)_ifh)[0]);
+	ifh[1] = be64_to_cpu(((__force __be64 *)_ifh)[1]);
+
+	wlen = IFH_EXTRACT_BITFIELD64(ifh[0], 7,  8);
+	llen = IFH_EXTRACT_BITFIELD64(ifh[0], 15,  6);
+
+	info->len = OCELOT_BUFFER_CELL_SZ * wlen + llen - 80;
+
+	info->timestamp = IFH_EXTRACT_BITFIELD64(ifh[0], 21, 32);
+
+	info->port = IFH_EXTRACT_BITFIELD64(ifh[1], 43, 4);
+
+	info->tag_type = IFH_EXTRACT_BITFIELD64(ifh[1], 16,  1);
+	info->vid = IFH_EXTRACT_BITFIELD64(ifh[1], 0,  12);
+
+	return 0;
+}
+
+static int ocelot_rx_frame_word(struct ocelot *ocelot, u8 grp, bool ifh,
+				u32 *rval)
+{
+	u32 val;
+	u32 bytes_valid;
+
+	val = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
+	if (val == XTR_NOT_READY) {
+		if (ifh)
+			return -EIO;
+
+		do {
+			val = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
+		} while (val == XTR_NOT_READY);
+	}
+
+	switch (val) {
+	case XTR_ABORT:
+		return -EIO;
+	case XTR_EOF_0:
+	case XTR_EOF_1:
+	case XTR_EOF_2:
+	case XTR_EOF_3:
+	case XTR_PRUNED:
+		bytes_valid = XTR_VALID_BYTES(val);
+		val = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
+		if (val == XTR_ESCAPE)
+			*rval = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
+		else
+			*rval = val;
+
+		return bytes_valid;
+	case XTR_ESCAPE:
+		*rval = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
+
+		return 4;
+	default:
+		*rval = val;
+
+		return 4;
+	}
+}
+
+int ocelot_xtr_poll_xfh(struct ocelot *ocelot, int grp,
+			struct ocelot_frame_info *info)
+{
+	u32 ifh[OCELOT_TAG_LEN / 4];
+	int i, err = 0;
+
+	for (i = 0; i < OCELOT_TAG_LEN / 4; i++) {
+		err = ocelot_rx_frame_word(ocelot, grp, true, &ifh[i]);
+		if (err != 4)
+			return (err < 0) ? err : -EIO;
+	}
+
+	ocelot_parse_xfh(ifh, info);
+
+	return 0;
+}
+
+int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp,
+			  struct net_device *dev,
+			  struct ocelot_frame_info *info,
+			  struct sk_buff **nskb)
+{
+	struct skb_shared_hwtstamps *shhwtstamps;
+	u64 tod_in_ns, full_ts_in_ns;
+	struct timespec64 ts;
+	int sz, len, buf_len;
+	struct sk_buff *skb;
+	u32 val, *buf;
+	int err = 0;
+
+	skb = netdev_alloc_skb(dev, info->len);
+	if (unlikely(!skb)) {
+		netdev_err(dev, "Unable to allocate sk_buff\n");
+		err = -ENOMEM;
+		goto out;
+	}
+
+	buf_len = info->len - ETH_FCS_LEN;
+	buf = (u32 *)skb_put(skb, buf_len);
+
+	len = 0;
+	do {
+		sz = ocelot_rx_frame_word(ocelot, grp, false, &val);
+		if (sz < 0) {
+			err = sz;
+			goto out;
+		}
+		*buf++ = val;
+		len += sz;
+	} while (len < buf_len);
+
+	/* Read the FCS */
+	sz = ocelot_rx_frame_word(ocelot, grp, false, &val);
+	if (sz < 0) {
+		err = sz;
+		goto out;
+	}
+
+	/* Update the statistics if part of the FCS was read before */
+	len -= ETH_FCS_LEN - sz;
+
+	if (unlikely(dev->features & NETIF_F_RXFCS)) {
+		buf = (u32 *)skb_put(skb, ETH_FCS_LEN);
+		*buf = val;
+	}
+
+	if (ocelot->ptp) {
+		ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
+
+		tod_in_ns = ktime_set(ts.tv_sec, ts.tv_nsec);
+		if ((tod_in_ns & 0xffffffff) < info->timestamp)
+			full_ts_in_ns = (((tod_in_ns >> 32) - 1) << 32) |
+					info->timestamp;
+		else
+			full_ts_in_ns = (tod_in_ns & GENMASK_ULL(63, 32)) |
+					info->timestamp;
+
+		shhwtstamps = skb_hwtstamps(skb);
+		memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
+		shhwtstamps->hwtstamp = full_ts_in_ns;
+	}
+
+	/* Everything we see on an interface that is in the HW bridge
+	 * has already been forwarded.
+	 */
+	if (ocelot->bridge_mask & BIT(info->port))
+		skb->offload_fwd_mark = 1;
+
+	skb->protocol = eth_type_trans(skb, dev);
+	*nskb = skb;
+out:
+	return err;
+}
+
 /* Generate the IFH for frame injection
  *
  * The IFH is a 128bit-value
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 5d80682e3b43..04d0ba1e385e 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -121,6 +121,12 @@ void ocelot_port_devlink_teardown(struct ocelot *ocelot, int port);
 bool ocelot_can_inject(struct ocelot *ocelot, int grp);
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			      u32 rew_op, struct sk_buff *skb);
+int ocelot_xtr_poll_xfh(struct ocelot *ocelot, int grp,
+			struct ocelot_frame_info *info);
+int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp,
+			  struct net_device *dev,
+			  struct ocelot_frame_info *info,
+			  struct sk_buff **skb);
 
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index a34f0a025710..032152105531 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -18,8 +18,6 @@
 #include <soc/mscc/ocelot_hsio.h>
 #include "ocelot.h"
 
-#define IFH_EXTRACT_BITFIELD64(x, o, w) (((x) >> (o)) & GENMASK_ULL((w) - 1, 0))
-
 static const u32 ocelot_ana_regmap[] = {
 	REG(ANA_ADVLEARN,				0x009000),
 	REG(ANA_VLANMASK,				0x009004),
@@ -532,173 +530,37 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	return 0;
 }
 
-static int ocelot_parse_ifh(u32 *_ifh, struct ocelot_frame_info *info)
-{
-	u8 llen, wlen;
-	u64 ifh[2];
-
-	ifh[0] = be64_to_cpu(((__force __be64 *)_ifh)[0]);
-	ifh[1] = be64_to_cpu(((__force __be64 *)_ifh)[1]);
-
-	wlen = IFH_EXTRACT_BITFIELD64(ifh[0], 7,  8);
-	llen = IFH_EXTRACT_BITFIELD64(ifh[0], 15,  6);
-
-	info->len = OCELOT_BUFFER_CELL_SZ * wlen + llen - 80;
-
-	info->timestamp = IFH_EXTRACT_BITFIELD64(ifh[0], 21, 32);
-
-	info->port = IFH_EXTRACT_BITFIELD64(ifh[1], 43, 4);
-
-	info->tag_type = IFH_EXTRACT_BITFIELD64(ifh[1], 16,  1);
-	info->vid = IFH_EXTRACT_BITFIELD64(ifh[1], 0,  12);
-
-	return 0;
-}
-
-static int ocelot_rx_frame_word(struct ocelot *ocelot, u8 grp, bool ifh,
-				u32 *rval)
-{
-	u32 val;
-	u32 bytes_valid;
-
-	val = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
-	if (val == XTR_NOT_READY) {
-		if (ifh)
-			return -EIO;
-
-		do {
-			val = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
-		} while (val == XTR_NOT_READY);
-	}
-
-	switch (val) {
-	case XTR_ABORT:
-		return -EIO;
-	case XTR_EOF_0:
-	case XTR_EOF_1:
-	case XTR_EOF_2:
-	case XTR_EOF_3:
-	case XTR_PRUNED:
-		bytes_valid = XTR_VALID_BYTES(val);
-		val = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
-		if (val == XTR_ESCAPE)
-			*rval = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
-		else
-			*rval = val;
-
-		return bytes_valid;
-	case XTR_ESCAPE:
-		*rval = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
-
-		return 4;
-	default:
-		*rval = val;
-
-		return 4;
-	}
-}
-
 static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 {
 	struct ocelot *ocelot = arg;
-	int i = 0, grp = 0;
-	int err = 0;
+	int grp = 0, err;
 
 	while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp)) {
-		struct skb_shared_hwtstamps *shhwtstamps;
 		struct ocelot_frame_info info = {};
 		struct ocelot_port_private *priv;
 		struct ocelot_port *ocelot_port;
-		u64 tod_in_ns, full_ts_in_ns;
 		struct net_device *dev;
-		u32 ifh[4], val, *buf;
-		struct timespec64 ts;
-		int sz, len, buf_len;
 		struct sk_buff *skb;
 
-		for (i = 0; i < OCELOT_TAG_LEN / 4; i++) {
-			err = ocelot_rx_frame_word(ocelot, grp, true, &ifh[i]);
-			if (err != 4)
-				goto out;
-		}
-
-		/* At this point the IFH was read correctly, so it is safe to
-		 * presume that there is no error. The err needs to be reset
-		 * otherwise a frame could come in CPU queue between the while
-		 * condition and the check for error later on. And in that case
-		 * the new frame is just removed and not processed.
-		 */
-		err = 0;
+		err = ocelot_xtr_poll_xfh(ocelot, grp, &info);
+		if (err)
+			break;
 
-		ocelot_parse_ifh(ifh, &info);
+		if (WARN_ON(info.port >= ocelot->num_phys_ports))
+			goto out;
 
 		ocelot_port = ocelot->ports[info.port];
 		priv = container_of(ocelot_port, struct ocelot_port_private,
 				    port);
 		dev = priv->dev;
 
-		skb = netdev_alloc_skb(dev, info.len);
-
-		if (unlikely(!skb)) {
-			netdev_err(dev, "Unable to allocate sk_buff\n");
-			err = -ENOMEM;
-			goto out;
-		}
-		buf_len = info.len - ETH_FCS_LEN;
-		buf = (u32 *)skb_put(skb, buf_len);
-
-		len = 0;
-		do {
-			sz = ocelot_rx_frame_word(ocelot, grp, false, &val);
-			if (sz < 0) {
-				err = sz;
-				goto out;
-			}
-			*buf++ = val;
-			len += sz;
-		} while (len < buf_len);
-
-		/* Read the FCS */
-		sz = ocelot_rx_frame_word(ocelot, grp, false, &val);
-		if (sz < 0) {
-			err = sz;
-			goto out;
-		}
-
-		/* Update the statistics if part of the FCS was read before */
-		len -= ETH_FCS_LEN - sz;
-
-		if (unlikely(dev->features & NETIF_F_RXFCS)) {
-			buf = (u32 *)skb_put(skb, ETH_FCS_LEN);
-			*buf = val;
-		}
-
-		if (ocelot->ptp) {
-			ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
-
-			tod_in_ns = ktime_set(ts.tv_sec, ts.tv_nsec);
-			if ((tod_in_ns & 0xffffffff) < info.timestamp)
-				full_ts_in_ns = (((tod_in_ns >> 32) - 1) << 32) |
-						info.timestamp;
-			else
-				full_ts_in_ns = (tod_in_ns & GENMASK_ULL(63, 32)) |
-						info.timestamp;
-
-			shhwtstamps = skb_hwtstamps(skb);
-			memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
-			shhwtstamps->hwtstamp = full_ts_in_ns;
-		}
-
-		/* Everything we see on an interface that is in the HW bridge
-		 * has already been forwarded.
-		 */
-		if (ocelot->bridge_mask & BIT(info.port))
-			skb->offload_fwd_mark = 1;
+		err = ocelot_xtr_poll_frame(ocelot, grp, dev, &info, &skb);
+		if (err)
+			break;
 
-		skb->protocol = eth_type_trans(skb, dev);
 		if (!skb_defer_rx_timestamp(skb))
 			netif_rx(skb);
-		dev->stats.rx_bytes += len;
+		dev->stats.rx_bytes += info.len;
 		dev->stats.rx_packets++;
 	}
 
-- 
2.25.1

