Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD6331A8B5
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbhBMAQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:16:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbhBMAPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:15:54 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B728C0617A9
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:41 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id hs11so2108213ejc.1
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ctI68pIK+ni/8YPjOqbQ9Q1HsY1P8MMtKWzj5NYHh2o=;
        b=RJe1PFxSgF4Y9fMD8tMxH3Xfj9KrC0djkcTBN0X5BG6ESwqOdWncp9TlJWGDIJQp26
         aAqzxwVXVw0RwO5SRKFQT/F1FcC1OlelGrD5gRVGYAbrxyQlGhqNpG6B0ZNRbopVGThE
         nuBrjzhZ1/FHS5MqibiB91MQsDQP9pk96ljhlG4ioJ14yu4rUbEzAWWptxYbox1b6Jmx
         MExRi6IOECNnH/HTMblL84LTA2Bm9b895Pc4OHjfyhzvchdSvPRlT6ajz3JRtGy36jH1
         DBtxoXjuSYghhmAi8wcU80RBzlKyY6dyqvBDonwMo3KNBfVASLMlwDGzXVkZORHRmbim
         bZMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ctI68pIK+ni/8YPjOqbQ9Q1HsY1P8MMtKWzj5NYHh2o=;
        b=Gl5E8YSgo5FqingvNK2Un6Tc5Rqgyov4bkp837JCnBIn7G3laiLMYLOyfsHSQY11Fq
         8YCaj/74y6/uMaW0hkQDlwnVP61TXtDblJjVmyNa406O+Oo695AVy/aUCuID+SGSNV1V
         /O8dvLHyMfF+9modpFLIHHsUIhNaGIIEC1HjgJcdWOeIWfZ/sLjYW/ETCb0M/F7zZ0LP
         XRdrhlMVJ6aDRxMigRsXyKXz8Zv77t/ITeCqXUOHxANGFYdcHc958yiO8HPTpmcp+t/F
         UxWbGop2m6yZVCrY0GKVvTlru8o1NC2GwC2avTIsb4qMKGV/ZOWQEszpacDtzPM2pvx7
         YJUg==
X-Gm-Message-State: AOAM532PfoH4Jv9wf+iDlcOinIVvrcZccM50tkHglEtXiWjSZGeWlnn4
        APuALN4CcGP75Lw+YtK61W4=
X-Google-Smtp-Source: ABdhPJzzNQ9RmWj978yJJtVPhX1XvJI98As8KZqsG0vTB7Fiba3v1tcGvPj0ZnW+VzK6kKQ23C5gPA==
X-Received: by 2002:a17:906:f4f:: with SMTP id h15mr5407429ejj.498.1613175280164;
        Fri, 12 Feb 2021 16:14:40 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id c1sm7015606eja.81.2021.02.12.16.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 16:14:39 -0800 (PST)
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
Subject: [PATCH net-next 12/12] net: dsa: tag_ocelot_8021q: add support for PTP timestamping
Date:   Sat, 13 Feb 2021 02:14:12 +0200
Message-Id: <20210213001412.4154051-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213001412.4154051-1-olteanv@gmail.com>
References: <20210213001412.4154051-1-olteanv@gmail.com>
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
 drivers/net/dsa/ocelot/felix.c             | 69 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c         |  7 +++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  3 +-
 include/soc/mscc/ocelot.h                  |  1 +
 net/dsa/tag_ocelot_8021q.c                 | 30 ++++++++++
 5 files changed, 108 insertions(+), 2 deletions(-)

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
index a3ff09f9d3b4..6de00762e8c2 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -844,5 +844,6 @@ bool ocelot_can_inject(struct ocelot *ocelot, int grp);
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			      u32 rew_op, struct sk_buff *skb);
 int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **skb);
+void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp);
 
 #endif
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 190255d06bef..da5f682cd647 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -9,8 +9,33 @@
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
@@ -18,6 +43,11 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
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

