Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AED231A8B4
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbhBMAQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbhBMAPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:15:52 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30684C061797
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:39 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id z19so2007321eju.9
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N2EFalKUjN8r8U2n5catlqYlb/X/4rxkXreBON4Mnw0=;
        b=MIZcjFb3S8JnW3NqhUmurReCwZ7V5DIPmoFl3UoWj+DGslDk7ouvx2Mf9eX3p/Odwe
         qIPrNCAsoAyIo+8aRcLdu0kUXKlU1pK9i8J/LMS8gGE+sL9WR3nLBHetG9VIK12OL7KJ
         xFigsU/0H7goGaRKHufeCxBgYTT5F4la3cZkBy0b/tqZLQa6qdbxeNJ1ciD4vB9ajNqI
         H7kBiXzzb8xZkF4xf59xm+nAs2+WU1hO1vBOUP2ugWltKsXjEp61AOAO6dOsbTa2d4Q9
         YmP2XnGXpfbE+XVDPUx3IpKeyJgv6BnpXz4n5mZmiWfyXIhLTAFIybL5Ux/LtUnI9hHs
         2GGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N2EFalKUjN8r8U2n5catlqYlb/X/4rxkXreBON4Mnw0=;
        b=MAldCBsL73L9lQaEQDJjeRQ0A5XuqRaV5diWUaA+RsoaSLmXV6aK24CK8k4XwdbpOE
         mvlXG++IPTbHOcyECDb1E7i2Tt/SwL+HVP/yP71CjlTKbiuPNCcfpuvTiFaytuwB9Eka
         WblwKjlVLK0aV5RT0oXAopa9edg2Q0y2xMk5Ax3RTO5S0uV12NtoGOOT5HLw1Pm0XJsQ
         eqEJFyEvlLil2idcrOTXLwNC7UaQ/XF0ClohrJj5Xu+6rejRM9TFxa7vMpJWb8JFscpD
         FvVFydu9OLEVsjCMebeUs5pcTj4QKoGLpEu7kycrnnu1rG4QuM27fyk6wS5JkctKFxNG
         Mejg==
X-Gm-Message-State: AOAM531aNG5Nbp0TF4H/wTQIM0oI/EH6OWysz7sNlAgE6IO2eU2rgv7F
        R/h7r3hzfGd/STfQbEDQqyA=
X-Google-Smtp-Source: ABdhPJwet2J+pf1fVbBn/cCgeFcRZwDWLsOjV/k1u8F8CvRQ8yX0whzEydsX3v89LHwmsakuwfNsVQ==
X-Received: by 2002:a17:906:c00a:: with SMTP id e10mr5451257ejz.501.1613175277864;
        Fri, 12 Feb 2021 16:14:37 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id c1sm7015606eja.81.2021.02.12.16.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 16:14:37 -0800 (PST)
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
Subject: [PATCH net-next 10/12] net: mscc: ocelot: refactor ocelot_xtr_irq_handler into ocelot_xtr_poll
Date:   Sat, 13 Feb 2021 02:14:10 +0200
Message-Id: <20210213001412.4154051-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213001412.4154051-1-olteanv@gmail.com>
References: <20210213001412.4154051-1-olteanv@gmail.com>
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
 drivers/net/ethernet/mscc/ocelot.c         | 151 +++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 140 +------------------
 include/soc/mscc/ocelot.h                  |   1 +
 3 files changed, 157 insertions(+), 135 deletions(-)

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
index 287c17a7e80f..a3ff09f9d3b4 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -843,5 +843,6 @@ int ocelot_sb_occ_tc_port_bind_get(struct ocelot *ocelot, int port,
 bool ocelot_can_inject(struct ocelot *ocelot, int grp);
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			      u32 rew_op, struct sk_buff *skb);
+int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **skb);
 
 #endif
-- 
2.25.1

