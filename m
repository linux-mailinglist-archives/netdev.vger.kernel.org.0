Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1071D2FA5F4
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406567AbhARQUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406561AbhARQTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 11:19:43 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5073C061799
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:18:04 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id dj23so15630715edb.13
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uj8jXqWCZiQk+sWkAgcKWwDbWNi1EYRCVWXGc966/Vo=;
        b=ROCcFPDtRU7hkl5nyFmL/Q+EzhbU57MuWdsZ+96oGjZmPIUIfsnJvd+dWFDKUDdjO2
         hHemYk4O5kPudMWRvEGa1E3tsnDGYsHU3hISOosBhjY5WT5YMQrfClLdb18tjGpzAQPO
         9F0SEMrhCvbriRKZA2HdDru8SEAW84OyvSB0IcTY2WXDZTX01uPstlCl1Xlw55229msU
         kuIpXBw+3S6Pz573Btvf9RMDJy6sipsn4MXMttf0zXE5Dcojts137aacoXSOUB04/dkq
         YLfZuWg7vIHu+TC9rpWq3t9KzC5r72xCn0vln1JIhLFe1Ml608ZORYJ9tDNUc90XTkC9
         7+Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uj8jXqWCZiQk+sWkAgcKWwDbWNi1EYRCVWXGc966/Vo=;
        b=aMVb0pJIHqEICenh3AAtVUem6q7bHSp+W5Wv77nA6q5KuM5dwxlgfeI2jLddnY97w6
         zJqGwZgFmmUyuFRQ6+VMUfrHJEjAlr0xoJ0SAVvoKpET4y92E5R8v/CKEtix/1X/Trun
         55X/+ByVnPd3/KdZk68Sm6TxvgmPAby0DC8FFakyVNSDJlFzvJI03lM4+WPXcmgYEDl9
         xW/37G8v+BTQqtwoHBgwvP6sLPYbIUE4LR1PtWUxruqc4eOZ3/L00ehTdEDrW2s+GdII
         AHizgsrTnMX0h3yIMg2SX/6k5b9UFg8W8goKRsg2jQQ/H9/MBTVnynYZZrbQs7fUbZV2
         n6IQ==
X-Gm-Message-State: AOAM5312lrx0kxxlKqekHuMRsQw1PmRNhKo/o9mLccjEcaaNcu3Ob+W+
        s0oa+QD1gXclRjjbImCIq0o=
X-Google-Smtp-Source: ABdhPJzYndgDcc42rfREQi15vyuBEi7dyGoxPNmHZ8CZMA5wIAw0/F6/hlXsN2/P1lvUF3t3YFiKgg==
X-Received: by 2002:a05:6402:1383:: with SMTP id b3mr194143edv.100.1610986683530;
        Mon, 18 Jan 2021 08:18:03 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u23sm6093781edt.78.2021.01.18.08.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 08:18:03 -0800 (PST)
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
Subject: [PATCH v3 net-next 15/15] net: dsa: tag_ocelot_8021q: add support for PTP timestamping
Date:   Mon, 18 Jan 2021 18:17:31 +0200
Message-Id: <20210118161731.2837700-16-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118161731.2837700-1-olteanv@gmail.com>
References: <20210118161731.2837700-1-olteanv@gmail.com>
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
Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/dsa/ocelot/felix.c           | 12 +++++
 drivers/net/dsa/ocelot/felix_tag_8021q.c | 61 ++++++++++++++++++++++++
 drivers/net/dsa/ocelot/felix_tag_8021q.h |  7 +++
 drivers/net/ethernet/mscc/ocelot.c       |  3 ++
 drivers/net/ethernet/mscc/ocelot.h       |  8 ----
 include/soc/mscc/ocelot.h                |  9 ++++
 net/dsa/tag_ocelot_8021q.c               | 24 ++++++++++
 7 files changed, 116 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 88ceed15e9cf..59757f29bcf8 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -733,6 +733,18 @@ static bool felix_rxtstamp(struct dsa_switch *ds, int port,
 	struct timespec64 ts;
 	u64 tstamp, val;
 
+	/* If the "no XTR IRQ" workaround is in use, tell DSA to defer this skb
+	 * for RX timestamping. Then free it, and poll for its copy through
+	 * MMIO in the CPU port module, and inject that into the stack from
+	 * ocelot_xtr_poll().
+	 * If the "no XTR IRQ" workaround isn't in use, this is a no-op and
+	 * should be eliminated by the compiler as dead code.
+	 */
+	if (felix_check_xtr_pkt(ocelot, type)) {
+		kfree_skb(skb);
+		return true;
+	}
+
 	ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
 	tstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
 
diff --git a/drivers/net/dsa/ocelot/felix_tag_8021q.c b/drivers/net/dsa/ocelot/felix_tag_8021q.c
index 84abfd2eb8a7..c7f7d7624bab 100644
--- a/drivers/net/dsa/ocelot/felix_tag_8021q.c
+++ b/drivers/net/dsa/ocelot/felix_tag_8021q.c
@@ -11,9 +11,70 @@
 #include <soc/mscc/ocelot_vcap.h>
 #include <linux/dsa/8021q.h>
 #include <linux/if_bridge.h>
+#include <linux/ptp_classify.h>
 #include "felix.h"
 #include "felix_tag_8021q.h"
 
+bool felix_check_xtr_pkt(struct ocelot *ocelot, unsigned int ptp_type)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	int err, grp = 0;
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
+	if (err < 0) {
+		ocelot_write(ocelot, QS_XTR_FLUSH, BIT(grp));
+		ocelot_write(ocelot, QS_XTR_FLUSH, 0);
+	}
+
+	return true;
+}
+
 static int felix_tag_8021q_rxvlan_add(struct felix *felix, int port, u16 vid,
 				      bool pvid, bool untagged)
 {
diff --git a/drivers/net/dsa/ocelot/felix_tag_8021q.h b/drivers/net/dsa/ocelot/felix_tag_8021q.h
index a3501904e748..5080351cdb93 100644
--- a/drivers/net/dsa/ocelot/felix_tag_8021q.h
+++ b/drivers/net/dsa/ocelot/felix_tag_8021q.h
@@ -7,6 +7,7 @@
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_OCELOT_8021Q)
 
 int felix_setup_8021q_tagging(struct ocelot *ocelot);
+bool felix_check_xtr_pkt(struct ocelot *ocelot, unsigned int ptp_type);
 
 #else
 
@@ -15,6 +16,12 @@ static inline int felix_setup_8021q_tagging(struct ocelot *ocelot)
 	return -EOPNOTSUPP;
 }
 
+static inline bool felix_check_xtr_pkt(struct ocelot *ocelot,
+				       unsigned int ptp_type)
+{
+	return false;
+}
+
 #endif /* IS_ENABLED(CONFIG_NET_DSA_TAG_OCELOT_8021Q) */
 
 #endif /* _MSCC_FELIX_TAG_8021Q_H */
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ac6b9942052a..bb60382021e2 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -646,6 +646,7 @@ int ocelot_xtr_poll_xfh(struct ocelot *ocelot, int grp,
 
 	return 0;
 }
+EXPORT_SYMBOL(ocelot_xtr_poll_xfh);
 
 int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp,
 			  struct net_device *dev,
@@ -723,6 +724,7 @@ int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp,
 out:
 	return err;
 }
+EXPORT_SYMBOL(ocelot_xtr_poll_frame);
 
 /* Generate the IFH for frame injection
  *
@@ -801,6 +803,7 @@ void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 	skb->dev->stats.tx_packets++;
 	skb->dev->stats.tx_bytes += skb->len;
 }
+EXPORT_SYMBOL(ocelot_port_inject_frame);
 
 int ocelot_fdb_add(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid)
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 04d0ba1e385e..d42aa229239e 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -119,14 +119,6 @@ int ocelot_port_devlink_init(struct ocelot *ocelot, int port,
 void ocelot_port_devlink_teardown(struct ocelot *ocelot, int port);
 
 bool ocelot_can_inject(struct ocelot *ocelot, int grp);
-void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
-			      u32 rew_op, struct sk_buff *skb);
-int ocelot_xtr_poll_xfh(struct ocelot *ocelot, int grp,
-			struct ocelot_frame_info *info);
-int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp,
-			  struct net_device *dev,
-			  struct ocelot_frame_info *info,
-			  struct sk_buff **skb);
 
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index ba803afcc55c..fa60ab5239d7 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -840,4 +840,13 @@ int ocelot_sb_occ_tc_port_bind_get(struct ocelot *ocelot, int port,
 				   enum devlink_sb_pool_type pool_type,
 				   u32 *p_cur, u32 *p_max);
 
+void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
+			      u32 rew_op, struct sk_buff *skb);
+int ocelot_xtr_poll_xfh(struct ocelot *ocelot, int grp,
+			struct ocelot_frame_info *info);
+int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp,
+			  struct net_device *dev,
+			  struct ocelot_frame_info *info,
+			  struct sk_buff **skb);
+
 #endif
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 430d77d0b8eb..a829d73d392b 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -2,6 +2,8 @@
 /* Copyright 2020-2021 NXP Semiconductors
  */
 #include <linux/dsa/8021q.h>
+#include <soc/mscc/ocelot.h>
+#include <soc/mscc/ocelot_ptp.h>
 #include "dsa_priv.h"
 
 static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
@@ -11,6 +13,28 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
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

