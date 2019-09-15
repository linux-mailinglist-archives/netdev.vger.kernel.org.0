Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39924B2DB7
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 04:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbfIOCAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 22:00:17 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39548 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfIOCAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 22:00:17 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so5322190wrj.6
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 19:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OT6N0xRpuZWNoL4FkjAyh8of0sXAzSB5GBfsLipZzsY=;
        b=uX3YN723ZGGIlQXiTCm7xfLfviSGmdQVfRKgbqA96WY2wjY4Hw2C5NUFu/oh5MdPnP
         k+uS0UMlzFcDxrtsD2HtCOI/L+Vav4uayn0III85NzYYJ97ZuWoDo0tJlixDNtyxn81s
         HUXOQkeJLyQhGDWtXM1COTjmg0GITms5wuxkscvwBu9xQA4FKw8Fm8Nq2b5q/v/wx7Al
         uox2kHwPXWslzWjNaAYtHcLF6xdmuXEIGlxm6XspZwHPoAnUQGJcMllmr8PJwPfgFzFN
         Yvc12dg0NhJKNjUuWXMX8q1/OtZd41GqV8OpUjsbm4lCYYYtGRgP6XaV4ZDPUoyY8i06
         718w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OT6N0xRpuZWNoL4FkjAyh8of0sXAzSB5GBfsLipZzsY=;
        b=LUblkXmSCpoev7iTs3WTnadc+6SLakyuym2UIhGjWcPCXWj6hJ+7uVZnl9thPZLykM
         gg/bRibRZBHlvXWFseUjcscMDAkCgkNNqx3vDv7REU33R92LfqtbRe2f02kDQEAKd/5O
         5VaNa5u3i3YYy5biEKhPIBbLUJWYqFABq0P4DVUdNXhUkjpfrp959xA4eeP7IihG4V/f
         7ZQC3mQxBJmO6YwtTyIYyLd0+XpiNV5Bz7B3rbOGs26QGYztMcAfTR58Kft8AiDQSgnE
         UpAdaO5n36BQjNzpFuAxUbj+Nq4HeQOmXYNnFeoDr9WZiXnMjkpHc+tkRvsbJ7TrdLSt
         rLKA==
X-Gm-Message-State: APjAAAXmDzukk9bDhYqMTM5ZVat1XAnPMJ6mmHHhJSnMV6V6+w/ZmvBR
        Ug9LWjcMsWhpnhmcXeiNTbQ=
X-Google-Smtp-Source: APXvYqxjjQ7Dysr1bj+cHOE3tcox+AFF6GP5i631ovsfrKij868T3f5ye9L0Ht4na9ENme1zDGugwg==
X-Received: by 2002:adf:afed:: with SMTP id y45mr43144980wrd.347.1568512814801;
        Sat, 14 Sep 2019 19:00:14 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id q15sm7216333wmb.28.2019.09.14.19.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 19:00:14 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        jose.abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, joergen.andreasen@microchip.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 4/6] net: dsa: sja1105: Advertise the 8 TX queues
Date:   Sun, 15 Sep 2019 05:00:01 +0300
Message-Id: <20190915020003.27926-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190915020003.27926-1-olteanv@gmail.com>
References: <20190915020003.27926-1-olteanv@gmail.com>
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
Changes since v2:
- None.

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

