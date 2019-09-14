Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8B3B2948
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 03:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404150AbfINBUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 21:20:55 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55130 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404104AbfINBUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 21:20:55 -0400
Received: by mail-wm1-f66.google.com with SMTP id p7so4425835wmp.4
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 18:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Opd+VIax4ZhhOxEBYm1izV0fxGmqqv95BztAVemUI5I=;
        b=frd/JS4gI0Zx0R0S0H50GUHokg0gWsuOIQvIgvZBLRMoBxN+Z4TNpmZZ0hKFSy8aDY
         3AjWdWXYFCfyf9AcM+4XwT2F5kPWzJX3JpVYjFO7ZFM7ZqYM8xX1nVURRhUfoKcDx+M3
         yXdB9PCzpzmvk+JoR4WOMZUAmR8tqgrsE6muMKurDY0wZOexSxkrd3YrKvbw2y7U9qfB
         zHO93fQ5jah8x5CHs3keFGQHraoEPdUFKahNpYMzLwoaWpWF2ZQ+lMFvtImxyVSBXA9W
         nzeS7u+ols6wkgzqRZz04NdiF9i9MbPF2zKKuqAS5UA6Uhkc3EFoG3hUA4dhapwQJEZO
         DQew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Opd+VIax4ZhhOxEBYm1izV0fxGmqqv95BztAVemUI5I=;
        b=VzcPyp5pD1JxoP28fvMEkxMVPXgRfhtGkQSuh5wK/QEpCJi5D0EJljnh2xjfbs3tz+
         tEQZh1t2a3jhTCMkNNATALXfphBKdtTPbZxexk1U+t5ywJks9AKNfSE/vjuA8LNjui6I
         vRq75bthbm+zo2XPrc3/c3Vx1zlgWv9VHxU2VVbmEV6iYmG8ykvCtJ53pj7RRd9e3ogd
         lxIcyIbsUbWSwI9cZDIsInSsL2NjThxt5k9QXHCz3uIfdgQZ9dVHxt1a7Z6VfqxQnfxi
         WdjudOlBiKb48rF1dJx8lKWg6CBINfNeeDqIpk32h5T0uM3tkb5hoT5CIZDRoIA5g425
         vonQ==
X-Gm-Message-State: APjAAAXcN/ASGppayvfzwDUq1IXL9gcQBAQYC/1Zh7cRpZWGFI3I0Zqo
        lVn+mKJR8jPFT3M6RU8Hlxs=
X-Google-Smtp-Source: APXvYqxQsBJRmGw6CR5B/Pfjf9lq7QlVt4cUP21oJjDr7PNx2v8X66O1rN3CKFSgVa4eScP4HrA/Ug==
X-Received: by 2002:a1c:f317:: with SMTP id q23mr5270992wmq.33.1568424053650;
        Fri, 13 Sep 2019 18:20:53 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id o14sm21857979wrw.11.2019.09.13.18.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 18:20:53 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, joergen.andreasen@microchip.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 4/7] net: dsa: sja1105: Advertise the 8 TX queues
Date:   Sat, 14 Sep 2019 04:17:59 +0300
Message-Id: <20190914011802.1602-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190914011802.1602-1-olteanv@gmail.com>
References: <20190914011802.1602-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preparation patch for the tc-taprio offload (and potentially
for other future offloads such as tc-mqprio).

Instead of looking directly at skb->priority during xmit, let's get the
netdev queue and the queue-to-traffic-class mapping, and put the
resulting traffic class into the dsa_8021q PCP field. The switch is
configured with a 1-to-1 PCP-to-ingress-queue-to-egress-queue mapping
(see vlan_pmap in sja1105_main.c), so the effect is that we can inject
into a front-panel's egress traffic class through VLAN tagging from
Linux, completely transparently.

Unfortunately the switch doesn't look at the VLAN PCP in the case of
management traffic to/from the CPU (link-local frames at
01-80-C2-xx-xx-xx or 01-1B-19-xx-xx-xx) so we can't alter the
transmission queue of this type of traffic on a frame-by-frame basis. It
is only selected through the "hostprio" setting which ATM is harcoded in
the driver to 7.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes since v1:
- None, but the use of netdev_txq_to_tc is now finally correct after
  adjusting the gate_mask meaning in the taprio offload structure.

Changes since RFC:
- None.

 drivers/net/dsa/sja1105/sja1105_main.c | 7 ++++++-
 net/dsa/tag_sja1105.c                  | 3 ++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d8cff0107ec4..108f62c27c28 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -384,7 +384,9 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		/* Disallow dynamic changing of the mirror port */
 		.mirr_ptacu = 0,
 		.switchid = priv->ds->index,
-		/* Priority queue for link-local frames trapped to CPU */
+		/* Priority queue for link-local management frames
+		 * (both ingress to and egress from CPU - PTP, STP etc)
+		 */
 		.hostprio = 7,
 		.mac_fltres1 = SJA1105_LINKLOCAL_FILTER_A,
 		.mac_flt1    = SJA1105_LINKLOCAL_FILTER_A_MASK,
@@ -1711,6 +1713,9 @@ static int sja1105_setup(struct dsa_switch *ds)
 	 */
 	ds->vlan_filtering_is_global = true;
 
+	/* Advertise the 8 egress queues */
+	ds->num_tx_queues = SJA1105_NUM_TC;
+
 	/* The DSA/switchdev model brings up switch ports in standalone mode by
 	 * default, and that means vlan_filtering is 0 since they're not under
 	 * a bridge, so it's safe to set up switch tagging at this time.
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 47ee88163a9d..9c9aff3e52cf 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -89,7 +89,8 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
 	struct dsa_switch *ds = dp->ds;
 	u16 tx_vid = dsa_8021q_tx_vid(ds, dp->index);
-	u8 pcp = skb->priority;
+	u16 queue_mapping = skb_get_queue_mapping(skb);
+	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
 
 	/* Transmitting management traffic does not rely upon switch tagging,
 	 * but instead SPI-installed management routes. Part 2 of this
-- 
2.17.1

