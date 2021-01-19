Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AD02FC481
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729645AbhASXKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729254AbhASXJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 18:09:32 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8CAC06179E
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:25 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id g24so23504507edw.9
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fgm6ZOMHI0u+kF/ZGYnyPYnDY+w03WpGr5j5FQOeS54=;
        b=MM9BSQuoKwYMbPvxdjLFFChnDbQcdOWGg1eEMvib04uQtPCu6jhBlse/CmhokNsXKc
         BmYUzhB+EDc0qJ0at8nJeVVILfskuqodh1cJh+Zyd9un0Wb44OurejX3uI8dU9YQLz51
         /LxckCJM+vc+cSAjv7Ro3xieiC6oiUW3J/C/OFchYFHgzM1tTKvgQos9HUy8/CWUKkMU
         rQGM8easVCIU6/IBRSSzwbBEtFfGohM0S/wzXCUvNmW887j7xZD3SBkViWJGzneHAaFo
         HsIc0Tvawtpkta50EkvYh3dboxgzjsJIMrz+I2EtXRRQnkK6P7B1dRG645ebroNW31+W
         S0/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fgm6ZOMHI0u+kF/ZGYnyPYnDY+w03WpGr5j5FQOeS54=;
        b=gqLgbzCTm6aGwTPP9YFhJ/InCy/7EgxD5tRm5f9ZjwkqiccD3aTJiOU+8nCVjTcOUG
         RPHG9oy1ys1CdaTbUmRIl7UMXBccu31eKx3FkQR7Dt9EJb9dNnGTnrBLFZ+2leghKil+
         xVxs2TyArH15EcfAOZMCKOY5055sUkwbYqtpjVDPt13oTphgEWk4JA7CS4GI+1KygYKU
         WQ20rKbbZQi8qYHbEb2k3BxPz2am+Sfx3SRWn2L+JgbfNVcy/n3BhPFIYWf9zakd8H8r
         /UbZ3204pA5YLuH8VCu2HBBB43GDm+A+RoedJoWICbgG/TEW6WV4Ek+HO/NBnUZW2B3Y
         4xUg==
X-Gm-Message-State: AOAM533LABNRoT+wfGIJj3iEiXEeuNDyEo8mrNMkQd5yKdrVKUMJgBKL
        N4M6k4VTIrm4drfg5LIv6zo=
X-Google-Smtp-Source: ABdhPJx8Af4rsQA0ovCbGtzuRd2o8ZVkyxvIDgcKVtob3LiPxs4o4VVBPK9Lst70KQdNKf8xtUix2w==
X-Received: by 2002:a05:6402:4242:: with SMTP id g2mr5237032edb.103.1611097703740;
        Tue, 19 Jan 2021 15:08:23 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id lh26sm94197ejb.119.2021.01.19.15.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:08:23 -0800 (PST)
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
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 16/16] net: dsa: tag_ocelot_8021q: add support for PTP timestamping
Date:   Wed, 20 Jan 2021 01:07:49 +0200
Message-Id: <20210119230749.1178874-17-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119230749.1178874-1-olteanv@gmail.com>
References: <20210119230749.1178874-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

On TX, use the result of the ptp_classify_raw() BPF classifier from
dsa_skb_tx_timestamp() to divert some frames over to the MMIO-based
injection registers.

On RX, set up a VCAP IS2 rule that redirects the frames with an
EtherType for 1588 to the CPU port module (for MMIO based extraction)
and, if the "no XTR IRQ" workaround is in place, copies them to the
dsa_8021q CPU port as well (for notification).

There is a conflict between the VCAP IS2 trapping rule and the semantics
of the BPF classifier. Namely, ptp_classify_raw() deems general messages
as non-timestampable, but still, those are trapped to the CPU port
module since they have an EtherType of ETH_P_1588. So, if the "no XTR
IRQ" workaround is in place, we need to run another BPF classifier on
the frames extracted over MMIO, to avoid duplicates being sent to the
stack (once over Ethernet, once over MMIO). It doesn't look like it's
possible to install VCAP IS2 rules based on keys extracted from the 1588
frame headers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
Now draining the CPU queues by continuously reading QS_XTR_READ, same as
Ocelot, instead of one-time asserting QS_XTR_FLUSH, which actually
needed a sleep to be effective.

Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/dsa/ocelot/felix.c             | 81 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c         |  7 ++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  3 +-
 include/soc/mscc/ocelot.h                  |  1 +
 net/dsa/tag_ocelot_8021q.c                 | 24 +++++++
 5 files changed, 114 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index cb05d795ef05..72ab34194897 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -16,6 +16,7 @@
 #include <linux/dsa/8021q.h>
 #include <linux/platform_device.h>
 #include <linux/packing.h>
+#include <linux/ptp_classify.h>
 #include <linux/module.h>
 #include <linux/of_net.h>
 #include <linux/pci.h>
@@ -312,6 +313,15 @@ static int felix_setup_mmio_filtering(struct felix *felix)
 		return ret;
 	}
 
+	/* The ownership of the CPU port module's queues might have just been
+	 * transferred to the tag_8021q tagger from the NPI-based tagger.
+	 * So there might still be all sorts of crap in the queues. On the
+	 * other hand, the MMIO-based matching of PTP frames is very brittle,
+	 * so we need to be careful that there are no extra frames to be
+	 * dequeued over MMIO, since we would never know to discard them.
+	 */
+	ocelot_drain_cpu_queue(ocelot, 0);
+
 	return 0;
 }
 
@@ -1159,6 +1169,67 @@ static int felix_hwtstamp_set(struct dsa_switch *ds, int port,
 	return ocelot_hwstamp_set(ocelot, port, ifr);
 }
 
+static bool felix_check_xtr_pkt(struct ocelot *ocelot, unsigned int ptp_type)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	int err, grp = 0;
+
+	if (felix->tag_proto == DSA_TAG_PROTO_OCELOT)
+		return false;
+
+	if (!felix->info->quirk_no_xtr_irq)
+		return false;
+
+	if (ptp_type == PTP_CLASS_NONE)
+		return false;
+
+	while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp)) {
+		struct ocelot_frame_info info = {};
+		struct dsa_port *dp;
+		struct sk_buff *skb;
+		unsigned int type;
+
+		err = ocelot_xtr_poll_xfh(ocelot, grp, &info);
+		if (err)
+			break;
+
+		if (WARN_ON(info.port >= ocelot->num_phys_ports))
+			goto out;
+
+		dp = dsa_to_port(felix->ds, info.port);
+
+		err = ocelot_xtr_poll_frame(ocelot, grp, dp->slave,
+					    &info, &skb);
+		if (err)
+			break;
+
+		/* We trap to the CPU port module all PTP frames, but
+		 * felix_rxtstamp() only gets called for event frames.
+		 * So we need to avoid sending duplicate general
+		 * message frames by running a second BPF classifier
+		 * here and dropping those.
+		 */
+		__skb_push(skb, ETH_HLEN);
+
+		type = ptp_classify_raw(skb);
+
+		__skb_pull(skb, ETH_HLEN);
+
+		if (type == PTP_CLASS_NONE) {
+			kfree_skb(skb);
+			continue;
+		}
+
+		netif_rx(skb);
+	}
+
+out:
+	if (err < 0)
+		ocelot_drain_cpu_queue(ocelot, 0);
+
+	return true;
+}
+
 static bool felix_rxtstamp(struct dsa_switch *ds, int port,
 			   struct sk_buff *skb, unsigned int type)
 {
@@ -1169,6 +1240,16 @@ static bool felix_rxtstamp(struct dsa_switch *ds, int port,
 	struct timespec64 ts;
 	u64 tstamp, val;
 
+	/* If the "no XTR IRQ" workaround is in use, tell DSA to defer this skb
+	 * for RX timestamping. Then free it, and poll for its copy through
+	 * MMIO in the CPU port module, and inject that into the stack from
+	 * ocelot_xtr_poll().
+	 */
+	if (felix_check_xtr_pkt(ocelot, type)) {
+		kfree_skb(skb);
+		return true;
+	}
+
 	ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
 	tstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
 
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 25f51b82e1b8..f41fa0a8e883 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -806,6 +806,13 @@ void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 }
 EXPORT_SYMBOL(ocelot_port_inject_frame);
 
+void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp)
+{
+	while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp))
+		ocelot_read_rix(ocelot, QS_XTR_RD, grp);
+}
+EXPORT_SYMBOL(ocelot_drain_cpu_queue);
+
 int ocelot_fdb_add(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid)
 {
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 317ee2395b89..1e56d12deb0e 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -566,8 +566,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 
 out:
 	if (err < 0)
-		while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp))
-			ocelot_read_rix(ocelot, QS_XTR_RD, grp);
+		ocelot_drain_cpu_queue(ocelot, 0);
 
 	return IRQ_HANDLED;
 }
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 3036ffc6b79d..2a115e7b4610 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -850,5 +850,6 @@ int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp,
 			  struct net_device *dev,
 			  struct ocelot_frame_info *info,
 			  struct sk_buff **skb);
+void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp);
 
 #endif
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 7bd45b66e9a4..e6f2e7931efa 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -9,6 +9,8 @@
  *   that on egress
  */
 #include <linux/dsa/8021q.h>
+#include <soc/mscc/ocelot.h>
+#include <soc/mscc/ocelot_ptp.h>
 #include "dsa_priv.h"
 
 static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
@@ -18,6 +20,28 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+	struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
+
+	/* TX timestamping was requested, so inject through MMIO */
+	if (clone) {
+		struct ocelot *ocelot = dp->ds->priv;
+		struct ocelot_port *ocelot_port;
+		int port = dp->index;
+		u32 rew_op;
+
+		ocelot_port = ocelot->ports[port];
+		rew_op = ocelot_port->ptp_cmd;
+
+		/* Retrieve timestamp ID populated inside skb->cb[0] of the
+		 * clone by ocelot_port_add_txtstamp_skb
+		 */
+		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
+			rew_op |= clone->cb[0] << 3;
+
+		ocelot_port_inject_frame(ocelot, dp->index, 0, rew_op, skb);
+
+		return NULL;
+	}
 
 	return dsa_8021q_xmit(skb, netdev, ETH_P_8021Q,
 			      ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
-- 
2.25.1

