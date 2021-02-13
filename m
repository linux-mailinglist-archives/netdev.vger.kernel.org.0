Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BBF31AE58
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 23:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhBMWkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 17:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhBMWjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 17:39:46 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFC1C0617A9
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 14:38:33 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id s5so4013218edw.8
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 14:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2vcrseT027GnMbA2153IbOqMUdppkVaDedXJbkpUBmI=;
        b=EZd8O0DtSgKP6YKCXRQLGDX4agrsgORIPH5OGbqsM5dmL56MqFOAErio6f4eXgmBXx
         3fhD1NrDJDubQ3yML8H84dV79dekR/gcXkWiMLC5cb1ECDz4BFD4dZzn8j1J0f+b92Bg
         jXYw6OThUCZxrCeYW1ttPWGdh0gC635wdzYgQ+kuewhTQu4cO+H6cufJGO12MnXLgA8x
         Fi/QazytWYFbvukt4bWogl2GGBwXj7h3h510Ja7Fylu8bBY4pGJ+/YDo26OY/OsGVVaZ
         lkO6EjFjfeCD7Uuejqpbk7aUxYyMArUJYfIe1mUZi0RB0DYjQxB2Ct7f+/GHAxDjTbnv
         iDAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2vcrseT027GnMbA2153IbOqMUdppkVaDedXJbkpUBmI=;
        b=MHNk+Xd9l/zS7c1C3qQRaUhecOjbGJbM7/vjtAEo+ufPwW5qjDFwVykf6pA5m9n9ZQ
         uoIjBlclZzWB6DmbiJ2urgYZRkKTe5V1r5kOYLtp2z9nuVSE2YdH6UuHtNzoRzbcFFGr
         6uCNbv9qeaW0UFMhgXwU3kRQi8jcritgYgtftKt+wrZnhGEQS+HBjyq3HnWJb3I4t+YT
         RkUfC55uyjm9mXYPt8YQV+svEQYrqsGM9tA56QbDOG0rxWx2HsP4DGhm5oP2Qhbp8HRP
         aPHU40gKcYxONeRkntVhzGT4D+zIF65luEKCCBHNwDqein5vDv8ONlmtYm9r8pQqWcZG
         Noww==
X-Gm-Message-State: AOAM5306Zq4Gw0+APaOO+zGexU8uTcURtlSZSXaMXBOnRuaXIkHzogx0
        QbkV3obKtDevXDjHiH31RHg=
X-Google-Smtp-Source: ABdhPJybL8TMiqOiM0uBrYzpLKx52Y42H8fNbELibpRHhsuWVzv7Ywpullpx+kSwy/myt4So10mHXA==
X-Received: by 2002:a05:6402:b0f:: with SMTP id bm15mr9187010edb.133.1613255911645;
        Sat, 13 Feb 2021 14:38:31 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h3sm7662582edw.18.2021.02.13.14.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 14:38:31 -0800 (PST)
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
Subject: [PATCH v2 net-next 12/12] net: dsa: tag_ocelot_8021q: add support for PTP timestamping
Date:   Sun, 14 Feb 2021 00:38:01 +0200
Message-Id: <20210213223801.1334216-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213223801.1334216-1-olteanv@gmail.com>
References: <20210213223801.1334216-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

For TX timestamping, we use the felix_txtstamp method which is common
with the regular (non-8021q) ocelot tagger. This method says that skb
deferral is needed, prepares a timestamp request ID, and puts a clone of
the skb in a queue waiting for the timestamp IRQ.

felix_txtstamp is called by dsa_skb_tx_timestamp() just before the
tagger's xmit method. In the tagger xmit, we divert the packets
classified by dsa_skb_tx_timestamp() as PTP towards the MMIO-based
injection registers, and we declare them as dead towards dsa_slave_xmit.
If not PTP, we proceed with normal tag_8021q stuff.

Then the timestamp IRQ fires, the clone queued up from felix_txtstamp is
matched to the TX timestamp retrieved from the switch's FIFO based on
the timestamp request ID, and the clone is delivered to the stack.

On RX, thanks to the VCAP IS2 rule that redirects the frames with an
EtherType for 1588 towards two destinations:
- the CPU port module (for MMIO based extraction) and
- if the "no XTR IRQ" workaround is in place, the dsa_8021q CPU port
the relevant data path processing starts in the ptp_classify_raw BPF
classifier installed by DSA in the RX data path (post tagger, which is
completely unaware that it saw a PTP packet).

This time we can't reuse the same implementation of .port_rxtstamp that
also works with the default ocelot tagger. That is because felix_rxtstamp
is given an skb with a freshly stripped DSA header, and it says "I don't
need deferral for its RX timestamp, it's right in it, let me show you";
and it just points to the header right behind skb->data, from where it
unpacks the timestamp and annotates the skb with it.

The same thing cannot happen with tag_ocelot_8021q, because for one
thing, the skb did not have an extraction frame header in the first
place, but a VLAN tag with no timestamp information. So the code paths
in felix_rxtstamp for the regular and 8021q tagger are completely
independent. With tag_8021q, the timestamp must come from the packet's
duplicate delivered to the CPU port module, but there is potentially
complex logic to be handled [ and prone to reordering ] if we were to
just start reading packets from the CPU port module, and try to match
them to the one we received over Ethernet and which needs an RX
timestamp. So we do something simple: we tell DSA "give me some time to
think" (we request skb deferral by returning false from .port_rxtstamp)
and we just drop the frame we got over Ethernet with no attempt to match
it to anything - we just treat it as a notification that there's data to
be processed from the CPU port module's queues. Then we proceed to read
the packets from those, one by one, which we deliver up the stack,
timestamped, using netif_rx - the same function that any driver would
use anyway if it needed RX timestamp deferral. So the assumption is that
we'll come across the PTP packet that triggered the CPU extraction
notification eventually, but we don't know when exactly. Thanks to the
VCAP IS2 trap/redirect rule and the exclusion of the CPU port module
from the flooding replicators, only PTP frames should be present in the
CPU port module's RX queues anyway.

There is just one conflict between the VCAP IS2 trapping rule and the
semantics of the BPF classifier. Namely, ptp_classify_raw() deems
general messages as non-timestampable, but still, those are trapped to
the CPU port module since they have an EtherType of ETH_P_1588. So, if
the "no XTR IRQ" workaround is in place, we need to run another BPF
classifier on the frames extracted over MMIO, to avoid duplicates being
sent to the stack (once over Ethernet, once over MMIO). It doesn't look
like it's possible to install VCAP IS2 rules based on keys extracted
from the 1588 frame headers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
- added the "ocelot_can_inject" check
- expanded a bit more on the patch implementation aspects

 drivers/net/dsa/ocelot/felix.c             | 69 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c         |  7 +++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  3 +-
 include/soc/mscc/ocelot.h                  |  5 ++
 net/dsa/tag_ocelot_8021q.c                 | 33 +++++++++++
 5 files changed, 115 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index d3b18aa6a582..b2e6a5b14f02 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -16,6 +16,7 @@
 #include <linux/dsa/8021q.h>
 #include <linux/dsa/ocelot.h>
 #include <linux/platform_device.h>
+#include <linux/ptp_classify.h>
 #include <linux/module.h>
 #include <linux/of_net.h>
 #include <linux/pci.h>
@@ -345,6 +346,15 @@ static int felix_setup_mmio_filtering(struct felix *felix)
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
 
@@ -1283,6 +1293,55 @@ static int felix_hwtstamp_set(struct dsa_switch *ds, int port,
 	return ocelot_hwstamp_set(ocelot, port, ifr);
 }
 
+static bool felix_check_xtr_pkt(struct ocelot *ocelot, unsigned int ptp_type)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	int err, grp = 0;
+
+	if (felix->tag_proto != DSA_TAG_PROTO_OCELOT_8021Q)
+		return false;
+
+	if (!felix->info->quirk_no_xtr_irq)
+		return false;
+
+	if (ptp_type == PTP_CLASS_NONE)
+		return false;
+
+	while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp)) {
+		struct sk_buff *skb;
+		unsigned int type;
+
+		err = ocelot_xtr_poll_frame(ocelot, grp, &skb);
+		if (err)
+			goto out;
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
@@ -1293,6 +1352,16 @@ static bool felix_rxtstamp(struct dsa_switch *ds, int port,
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
index 981811ffcdae..8d97c731e953 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -837,6 +837,13 @@ void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
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
index 47ee06832a51..4bd7e9d9ec61 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -552,8 +552,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 
 out:
 	if (err < 0)
-		while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp))
-			ocelot_read_rix(ocelot, QS_XTR_RD, grp);
+		ocelot_drain_cpu_queue(ocelot, 0);
 
 	return IRQ_HANDLED;
 }
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index ded9ae1149bc..1f2d90976564 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -742,6 +742,7 @@ bool ocelot_can_inject(struct ocelot *ocelot, int grp);
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			      u32 rew_op, struct sk_buff *skb);
 int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **skb);
+void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp);
 
 #else
 
@@ -762,6 +763,10 @@ static inline int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp,
 	return -EIO;
 }
 
+static inline void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp)
+{
+}
+
 #endif
 
 /* Hardware initialization */
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 190255d06bef..5f3e8e124a82 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -9,8 +9,36 @@
  *   that on egress
  */
 #include <linux/dsa/8021q.h>
+#include <soc/mscc/ocelot.h>
+#include <soc/mscc/ocelot_ptp.h>
 #include "dsa_priv.h"
 
+static struct sk_buff *ocelot_xmit_ptp(struct dsa_port *dp,
+				       struct sk_buff *skb,
+				       struct sk_buff *clone)
+{
+	struct ocelot *ocelot = dp->ds->priv;
+	struct ocelot_port *ocelot_port;
+	int port = dp->index;
+	u32 rew_op;
+
+	if (!ocelot_can_inject(ocelot, 0))
+		return NULL;
+
+	ocelot_port = ocelot->ports[port];
+	rew_op = ocelot_port->ptp_cmd;
+
+	/* Retrieve timestamp ID populated inside skb->cb[0] of the
+	 * clone by ocelot_port_add_txtstamp_skb
+	 */
+	if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
+		rew_op |= clone->cb[0] << 3;
+
+	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
+
+	return NULL;
+}
+
 static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 				   struct net_device *netdev)
 {
@@ -18,6 +46,11 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+	struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
+
+	/* TX timestamping was requested, so inject through MMIO */
+	if (clone)
+		return ocelot_xmit_ptp(dp, skb, clone);
 
 	return dsa_8021q_xmit(skb, netdev, ETH_P_8021Q,
 			      ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
-- 
2.25.1

