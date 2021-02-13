Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B9D31AE57
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 23:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhBMWkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 17:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhBMWjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 17:39:43 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E1FC061797
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 14:38:30 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id f14so5370515ejc.8
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 14:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wviURdepjTxmTjnHnz5kZb4F7hAFFzrRv8NbUOSOTCU=;
        b=gtvtSItCwP6ScMznYYxlaxVuc7m+Zz6MuqBWPAL061hDXHfLUhVwU6AB/+XXewdH7h
         iVrWisi/JNTWVkYLTtBH14kUVopfc18aDWokO5/IiPV9HAFhNAp/A2Jab1aZrJLnRazr
         8cM9/BLAu9bHQyAJU42OuJ6tLTd2/n4T+l8T84AThUY1O+118SEjZhj0A/fXg704mn4B
         lzDr/sahvfFdp/PGdfHv7LZAJc5rzbwTJxt2Ezd0DMr7o7h3b/8qWeCy6ChA4a6JzVpW
         h/z8gJu4JLXA9azkvOf80PJHXfuqt5FD3mnbLMtFERb0bOJ0Hbp+eU5CP7jvtnf8rv/D
         rswA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wviURdepjTxmTjnHnz5kZb4F7hAFFzrRv8NbUOSOTCU=;
        b=n2lYmymW4yGuAE7E8jc1OAvqQ/GddTN7nmlpGXWVsNwpNmwdm+Ou6rTFqxJDvnQNO8
         HLT4Fzyf7s3zAl4uBAvjxgnWh5GgvJ59v+/NHrKssIsM8XEsrSuN3vqmkJ3wvFGEz7rC
         JFAwhjooFGEFFyWCOOxCjVqCkN4bXf95sOazdZuwTrJh54gjBqOT0TRhiYfk8PmVCNTb
         MuoEc3JN7zlltOJDIcaDo58be5CCmD4EwKPXw79IVA4lI+AcziAWi8njAW91Z+zX6Zli
         CTWOIG+hUTb14tPGR5qt787nzCU7S/NdnYbAzC4qJKcATzQQCeZD4CZkXhNUFX3CbDjL
         pVng==
X-Gm-Message-State: AOAM53212Ya6CVhmgRRac1XmBzGMTlGhxfdEJHesHtOZEUKQhAmOIDcc
        NiCxuvHVG/BMgE/Z8VJcOsg=
X-Google-Smtp-Source: ABdhPJxzK6alJWM+G+wd9CBhOufxkiC8CxgFMTeGYeiyhNNEaetzNIs294i/G6i8gAW43+gQSPfiRA==
X-Received: by 2002:a17:906:5495:: with SMTP id r21mr9164395ejo.59.1613255909490;
        Sat, 13 Feb 2021 14:38:29 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h3sm7662582edw.18.2021.02.13.14.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 14:38:29 -0800 (PST)
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
Subject: [PATCH v2 net-next 10/12] net: mscc: ocelot: refactor ocelot_xtr_irq_handler into ocelot_xtr_poll
Date:   Sun, 14 Feb 2021 00:37:59 +0200
Message-Id: <20210213223801.1334216-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213223801.1334216-1-olteanv@gmail.com>
References: <20210213223801.1334216-1-olteanv@gmail.com>
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

We abuse the struct ocelot_ops :: port_to_netdev function a little bit,
in order to retrieve the DSA port net_device or the ocelot switchdev
net_device based on the source port information from the Extraction
Frame Header, but it's all in the benefit of code simplification -
netdev_alloc_skb needs it. Originally, the port_to_netdev method was
intended for parsing act->dev from tc flower offload code.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Added shim definitions.

 drivers/net/ethernet/mscc/ocelot.c         | 151 +++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 140 +------------------
 include/soc/mscc/ocelot.h                  |   7 +
 3 files changed, 163 insertions(+), 135 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 699b0c1c1780..981811ffcdae 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -629,6 +629,157 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 }
 EXPORT_SYMBOL(ocelot_get_txtstamp);
 
+static int ocelot_rx_frame_word(struct ocelot *ocelot, u8 grp, bool ifh,
+				u32 *rval)
+{
+	u32 bytes_valid, val;
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
+static int ocelot_xtr_poll_xfh(struct ocelot *ocelot, int grp, u32 *xfh)
+{
+	int i, err = 0;
+
+	for (i = 0; i < OCELOT_TAG_LEN / 4; i++) {
+		err = ocelot_rx_frame_word(ocelot, grp, true, &xfh[i]);
+		if (err != 4)
+			return (err < 0) ? err : -EIO;
+	}
+
+	return 0;
+}
+
+int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
+{
+	struct skb_shared_hwtstamps *shhwtstamps;
+	u64 tod_in_ns, full_ts_in_ns;
+	u64 timestamp, src_port, len;
+	u32 xfh[OCELOT_TAG_LEN / 4];
+	struct net_device *dev;
+	struct timespec64 ts;
+	struct sk_buff *skb;
+	int sz, buf_len;
+	u32 val, *buf;
+	int err;
+
+	err = ocelot_xtr_poll_xfh(ocelot, grp, xfh);
+	if (err)
+		return err;
+
+	ocelot_xfh_get_src_port(xfh, &src_port);
+	ocelot_xfh_get_len(xfh, &len);
+	ocelot_xfh_get_rew_val(xfh, &timestamp);
+
+	if (WARN_ON(src_port >= ocelot->num_phys_ports))
+		return -EINVAL;
+
+	dev = ocelot->ops->port_to_netdev(ocelot, src_port);
+	if (!dev)
+		return -EINVAL;
+
+	skb = netdev_alloc_skb(dev, len);
+	if (unlikely(!skb)) {
+		netdev_err(dev, "Unable to allocate sk_buff\n");
+		return -ENOMEM;
+	}
+
+	buf_len = len - ETH_FCS_LEN;
+	buf = (u32 *)skb_put(skb, buf_len);
+
+	len = 0;
+	do {
+		sz = ocelot_rx_frame_word(ocelot, grp, false, &val);
+		if (sz < 0) {
+			err = sz;
+			goto out_free_skb;
+		}
+		*buf++ = val;
+		len += sz;
+	} while (len < buf_len);
+
+	/* Read the FCS */
+	sz = ocelot_rx_frame_word(ocelot, grp, false, &val);
+	if (sz < 0) {
+		err = sz;
+		goto out_free_skb;
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
+		if ((tod_in_ns & 0xffffffff) < timestamp)
+			full_ts_in_ns = (((tod_in_ns >> 32) - 1) << 32) |
+					timestamp;
+		else
+			full_ts_in_ns = (tod_in_ns & GENMASK_ULL(63, 32)) |
+					timestamp;
+
+		shhwtstamps = skb_hwtstamps(skb);
+		memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
+		shhwtstamps->hwtstamp = full_ts_in_ns;
+	}
+
+	/* Everything we see on an interface that is in the HW bridge
+	 * has already been forwarded.
+	 */
+	if (ocelot->bridge_mask & BIT(src_port))
+		skb->offload_fwd_mark = 1;
+
+	skb->protocol = eth_type_trans(skb, dev);
+	*nskb = skb;
+
+	return 0;
+
+out_free_skb:
+	kfree_skb(skb);
+	return err;
+}
+EXPORT_SYMBOL(ocelot_xtr_poll_frame);
+
 bool ocelot_can_inject(struct ocelot *ocelot, int grp)
 {
 	u32 val = ocelot_read(ocelot, QS_INJ_STATUS);
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index fe0f8d6a32ce..47ee06832a51 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -531,153 +531,23 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	return 0;
 }
 
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
-		struct ocelot_port_private *priv;
-		struct ocelot_port *ocelot_port;
-		u64 tod_in_ns, full_ts_in_ns;
-		u64 src_port, len, timestamp;
-		struct net_device *dev;
-		u32 xfh[4], val, *buf;
-		struct timespec64 ts;
 		struct sk_buff *skb;
-		int sz, buf_len;
-
-		for (i = 0; i < OCELOT_TAG_LEN / 4; i++) {
-			err = ocelot_rx_frame_word(ocelot, grp, true, &xfh[i]);
-			if (err != 4)
-				goto out;
-		}
-
-		/* At this point the XFH was read correctly, so it is safe to
-		 * presume that there is no error. The err needs to be reset
-		 * otherwise a frame could come in CPU queue between the while
-		 * condition and the check for error later on. And in that case
-		 * the new frame is just removed and not processed.
-		 */
-		err = 0;
-
-		ocelot_xfh_get_src_port(xfh, &src_port);
-		ocelot_xfh_get_len(xfh, &len);
-		ocelot_xfh_get_rew_val(xfh, &timestamp);
-
-		ocelot_port = ocelot->ports[src_port];
-		priv = container_of(ocelot_port, struct ocelot_port_private,
-				    port);
-		dev = priv->dev;
 
-		skb = netdev_alloc_skb(dev, len);
-
-		if (unlikely(!skb)) {
-			netdev_err(dev, "Unable to allocate sk_buff\n");
-			err = -ENOMEM;
-			goto out;
-		}
-		buf_len = len - ETH_FCS_LEN;
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
+		err = ocelot_xtr_poll_frame(ocelot, grp, &skb);
+		if (err)
 			goto out;
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
-			if ((tod_in_ns & 0xffffffff) < timestamp)
-				full_ts_in_ns = (((tod_in_ns >> 32) - 1) << 32) |
-						timestamp;
-			else
-				full_ts_in_ns = (tod_in_ns & GENMASK_ULL(63, 32)) |
-						timestamp;
-
-			shhwtstamps = skb_hwtstamps(skb);
-			memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
-			shhwtstamps->hwtstamp = full_ts_in_ns;
-		}
 
-		/* Everything we see on an interface that is in the HW bridge
-		 * has already been forwarded.
-		 */
-		if (ocelot->bridge_mask & BIT(src_port))
-			skb->offload_fwd_mark = 1;
+		skb->dev->stats.rx_bytes += skb->len;
+		skb->dev->stats.rx_packets++;
 
-		skb->protocol = eth_type_trans(skb, dev);
 		if (!skb_defer_rx_timestamp(skb))
 			netif_rx(skb);
-		dev->stats.rx_bytes += len;
-		dev->stats.rx_packets++;
 	}
 
 out:
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 11cae2e968b5..ded9ae1149bc 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -741,6 +741,7 @@ void __ocelot_target_write_ix(struct ocelot *ocelot, enum ocelot_target target,
 bool ocelot_can_inject(struct ocelot *ocelot, int grp);
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			      u32 rew_op, struct sk_buff *skb);
+int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **skb);
 
 #else
 
@@ -755,6 +756,12 @@ static inline void ocelot_port_inject_frame(struct ocelot *ocelot, int port,
 {
 }
 
+static inline int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp,
+					struct sk_buff **skb)
+{
+	return -EIO;
+}
+
 #endif
 
 /* Hardware initialization */
-- 
2.25.1

