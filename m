Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41675B2DA5
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 03:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbfIOBxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 21:53:47 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37958 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfIOBxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 21:53:47 -0400
Received: by mail-wr1-f65.google.com with SMTP id l11so35424252wrx.5
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 18:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sNRHKjnMT5wtGOeRmWm2Oyvi5tlsjYdjGuDZ9b9mh4g=;
        b=fkSOb3rQ3dFSL9HQm54+xYdm8geGDJxf1Y34aZrb0BT8VuraR5R+ifOCL3PA2euKdu
         6gPTsl/tkUbtWcAo0FT+U0wmg/gpCjFoWOql+WNUW/wPi0putws2hQt3j61GklYuNBKJ
         X65Plo7X5g5RFJ1UyI6Puj+XyUp0hKkpUsW3EImdAZFnpCyqdUVVNqCNIrXBduJwJt9U
         5EV+8YaNw4Uo+8uK0SsGFHNRVgw0p1GjIlfdvbC13YvFg+xvkrruh0DoGL4crJbtuIgB
         L+Yli3URqc6sNJZk6SBMiIH7dfFiBcVywJ/5QG7n8HtgbvAkM5vwHywy6Jr1qs3kXbVD
         ZqbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sNRHKjnMT5wtGOeRmWm2Oyvi5tlsjYdjGuDZ9b9mh4g=;
        b=nqDl+4sVRFBqkKWrY2AZ0R8omw7AoaHVDNfSP0DcRUETftpZAM7E80JkGlzWUhA7h8
         /vYOpXzL873McA2e5JLF4Ifn9i5v8XMqZlG0C5jbkaruAwEkfJe9st1QiLn9FGhw381p
         WZXVlVGSaHnUtzwd17PsjresvNPh5UqHD2ykyNJvl3U3Kne4wkYaPeMxjTDmu1AKfGrR
         PnZapIWVTzZSHoXo/y1iNZbtxwh4G0t07ta+cM50mIO+Vh3pI5LUNSxZGf4CWvW5gDCg
         ZcqBS4fOaIsVH8pQD2gy45u9lEeWEkJO5dbQElvtGEOSoKbJidj6BfqPO0g0nuiLTSYi
         ohjQ==
X-Gm-Message-State: APjAAAV+6UIo5GfoKD/5DV3ubLVH6h61/C7TeEsoBDzNoG6irHc/+T+p
        OsD96McRPWbayx248Kt7MeE=
X-Google-Smtp-Source: APXvYqySnqDLxWXBqjY2b7GvZM7gTxSDBJz8eT/21Fqgy4Gq8cSIm412ZXqQ6yghqOH4S0iHn3USgw==
X-Received: by 2002:adf:e410:: with SMTP id g16mr11572620wrm.297.1568512424822;
        Sat, 14 Sep 2019 18:53:44 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id p19sm5627044wmg.31.2019.09.14.18.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 18:53:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, joergen.andreasen@microchip.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 4/7] net: dsa: sja1105: Advertise the 8 TX queues
Date:   Sun, 15 Sep 2019 04:53:11 +0300
Message-Id: <20190915015314.26605-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190915015314.26605-1-olteanv@gmail.com>
References: <20190915015314.26605-1-olteanv@gmail.com>
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

