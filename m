Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2C39A5B61
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 18:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfIBQ0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 12:26:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35914 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfIBQ0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 12:26:16 -0400
Received: by mail-wr1-f67.google.com with SMTP id y19so14617252wrd.3
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 09:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SYxf9CRVbaV+rLLJ6JizDSXGmG6m/J27AtW3b+akHF0=;
        b=IZEzswrd4WRNNoYZfl9X/AE3hdsGgwnViUeL2Jn7Z5Eqfu3ZKf29PaPmCCSPtAWJcU
         ZzzT+W2vfGeYwOMwawIwzWXpt0bNhJqYDm2CGZ6kjPUwHLDS+7wHaQnZUsvk75zAA++l
         qh8ZzLls0+FR3ScYzgWm1OeZqP1nzmgYb8n4YzI4dmYDznj/RCvouq52AoLsiBO5TrBw
         jTypIRtne4WzeHFc/oWjRaA4IdUM5Rt0oyyMmgEMCA2+BsvB+mxxSAh/gZO7chbxqi4V
         CrlducF6vPYYv8vuuuygZqKIcLSdyVxZ4gooaIR8UHqIvPhRI4R2yqfgNWgZZdPaEwGS
         wfwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SYxf9CRVbaV+rLLJ6JizDSXGmG6m/J27AtW3b+akHF0=;
        b=Y/4Q4KjmkMatfiuyL5YaeWlf2I1fyPCt9wLHVum1Q7fRsy0oSYK1BKU6OvaMx5393y
         Unj6L2ILxiuS21jEEOMoSXNTJ/b5+iaF1GcsZsfdKRjhUJ1lLITGja+l3rxYxuyt5bA8
         7/BZvjLkiGVj1vyqWTd5SgTQFrAjWCRBoHDvjmZ1bOOy0qA5PXLbOvSoIZ3VZeNpajvH
         1TuJGAMEZghHFxZ8cEymnFHcTuIYUNjifWLpiURsNQm+2yA5IEP3xH94lJ/dxMVpeZP+
         STx7bvAX/BQpyUDKdP8c+jjmXGSQN5NDLUysY6M5Dh7s3xkGAS1xCVkIfirARj7CsOBw
         EYaA==
X-Gm-Message-State: APjAAAXMie2lSAzrFiwmKBGBRjpNcJDW6UE+HMHrrxB680nRJee4EqN3
        IrTP12z7sdm1PUwMJizxfhY=
X-Google-Smtp-Source: APXvYqxOPTlN0/ugPLRuCLb3Y8TGEl+7v/NzodIP/F9R4TKEpH1I3wPzNdkW5TI7M41b5nLlHfUU5w==
X-Received: by 2002:a5d:6588:: with SMTP id q8mr17031622wru.184.1567441574687;
        Mon, 02 Sep 2019 09:26:14 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id z187sm2879994wmb.0.2019.09.02.09.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 09:26:14 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v1 net-next 08/15] net: dsa: sja1105: Advertise the 8 TX queues
Date:   Mon,  2 Sep 2019 19:25:37 +0300
Message-Id: <20190902162544.24613-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190902162544.24613-1-olteanv@gmail.com>
References: <20190902162544.24613-1-olteanv@gmail.com>
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
Changes since RFC:
- None.

 drivers/net/dsa/sja1105/sja1105_main.c | 7 ++++++-
 net/dsa/tag_sja1105.c                  | 3 ++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 670c069722d5..8b930cc2dabc 100644
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
@@ -1745,6 +1747,9 @@ static int sja1105_setup(struct dsa_switch *ds)
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

