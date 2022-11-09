Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B102623215
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiKISJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiKISJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:09:32 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA5624F0C
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:09:31 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id kt23so48962505ejc.7
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 10:09:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aaAOHKyrBJT3EFrE2PabDENwkfEtobniT2QNAB+W8Nw=;
        b=I0e3JvD2m7Yh0q77HI0nsN1Gv6EiUD3qkZNqE6zCjeJS8SjgK2y+knBBTZ049gQ1E/
         d+jfUlLxuRF6TWxWV8EyOAabKjiKN82HA0o0b5nE5FDCHoUhM5SZNHuW+wnIgIBmkSou
         5NY2PFAMTwvnqR6KOitHLJkIPoKjNSM944nRMiLBHb8Y/YYwKEUnmZ6He//SkM/oqGb3
         hQzRkFFuGrdYOkXdFzmwHBz+DMTNvBVijqWG/T5WSJtXxLKLnFD4Rqk6gS2FV1YILXvZ
         cc9euHdW8qHaiw5uV7tKxsZXP5h53v0ciDuPDw3aUl0SW/fn0rTBUm2XdYXC36fRIzCc
         8eoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aaAOHKyrBJT3EFrE2PabDENwkfEtobniT2QNAB+W8Nw=;
        b=L5RcWlO9+a5BMrnD1OXhqRS005/9Z1z8V6z4OTrLnNMiZqhoexndp1oLMaCd/lj06w
         raQaWf6FdOQM4AychduQp0Q8XJ+mEqouoTdGj9W4UEw1+bjE8EW8fTqE5XCtRM6NW+w0
         zYVP9Gf1rHCC56vPcEZ+HyU1FjUqm/TRfbKYruZrkLc27i1KO+DSTy5ZX+oxNhOJcV3Z
         5tHzRvwLy8bAvv9Zd6pJa5q+X0piNaL+qy03vtlGxF4szUG4BL9Et0uktkgCo8hbKf3F
         cHw0mHmzwMdQ+38/aAfDP4DB4uweawXqCjnYM3NTrK1FZkrf0s+WzpMZJfdgWRGXbUua
         L7qQ==
X-Gm-Message-State: ACrzQf1LKceIp6KRKjUr6ZW7A+RafM5n/aOQQCcOlpmJyR7b3pn9JsGS
        5Qvjr4eAlUc6AVX10YJdShaNcskTLtom8g==
X-Google-Smtp-Source: AMsMyM77ur3tuL/Bh5+MnzkGZ/NF99HIAVquk3GHwIhasv4SBcNuo83v9lY0K2N1Oa5SdBaNWcA4iw==
X-Received: by 2002:a17:907:105d:b0:7ad:c2ef:4d69 with SMTP id oy29-20020a170907105d00b007adc2ef4d69mr1587234ejb.10.1668017369656;
        Wed, 09 Nov 2022 10:09:29 -0800 (PST)
Received: from ThinkStation-P340.. (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id rh16-20020a17090720f000b0077016f4c6d4sm6116311ejb.55.2022.11.09.10.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 10:09:29 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next 2/3] net: qualcomm: rmnet: add tx packets aggregation
Date:   Wed,  9 Nov 2022 19:02:48 +0100
Message-Id: <20221109180249.4721-3-dnlplm@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221109180249.4721-1-dnlplm@gmail.com>
References: <20221109180249.4721-1-dnlplm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bidirectional TCP throughput tests through iperf with low-cat
Thread-x based modems showed performance issues both in tx
and rx.

The Windows driver does not show this issue: inspecting USB
packets revealed that the only notable change is the driver
enabling tx packets aggregation.

Tx packets aggregation, by default disabled, requires flag
RMNET_FLAGS_EGRESS_AGGREGATION to be set (e.g. through ip command).

The maximum number of aggregated packets and the maximum aggregated
size are by default set to reasonably low values in order to support
the majority of modems.

This implementation is based on patches available in Code Aurora
repositories (msm kernel) whose main authors are

Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Sean Tranchetti <stranche@codeaurora.org>

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
 .../ethernet/qualcomm/rmnet/rmnet_config.c    |   5 +
 .../ethernet/qualcomm/rmnet/rmnet_config.h    |  19 ++
 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |  25 ++-
 .../net/ethernet/qualcomm/rmnet/rmnet_map.h   |   7 +
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 196 ++++++++++++++++++
 include/uapi/linux/if_link.h                  |   1 +
 6 files changed, 251 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 27b1663c476e..39d24e07f306 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -12,6 +12,7 @@
 #include "rmnet_handlers.h"
 #include "rmnet_vnd.h"
 #include "rmnet_private.h"
+#include "rmnet_map.h"
 
 /* Local Definitions and Declarations */
 
@@ -39,6 +40,8 @@ static int rmnet_unregister_real_device(struct net_device *real_dev)
 	if (port->nr_rmnet_devs)
 		return -EINVAL;
 
+	rmnet_map_tx_aggregate_exit(port);
+
 	netdev_rx_handler_unregister(real_dev);
 
 	kfree(port);
@@ -79,6 +82,8 @@ static int rmnet_register_real_device(struct net_device *real_dev,
 	for (entry = 0; entry < RMNET_MAX_LOGICAL_EP; entry++)
 		INIT_HLIST_HEAD(&port->muxed_ep[entry]);
 
+	rmnet_map_tx_aggregate_init(port);
+
 	netdev_dbg(real_dev, "registered with rmnet\n");
 	return 0;
 }
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
index 3d3cba56c516..d341df78e411 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
@@ -6,6 +6,7 @@
  */
 
 #include <linux/skbuff.h>
+#include <linux/time.h>
 #include <net/gro_cells.h>
 
 #ifndef _RMNET_CONFIG_H_
@@ -19,6 +20,12 @@ struct rmnet_endpoint {
 	struct hlist_node hlnode;
 };
 
+struct rmnet_egress_agg_params {
+	u16 agg_size;
+	u16 agg_count;
+	u64 agg_time_nsec;
+};
+
 /* One instance of this structure is instantiated for each real_dev associated
  * with rmnet.
  */
@@ -30,6 +37,18 @@ struct rmnet_port {
 	struct hlist_head muxed_ep[RMNET_MAX_LOGICAL_EP];
 	struct net_device *bridge_ep;
 	struct net_device *rmnet_dev;
+
+	/* Egress aggregation information */
+	struct rmnet_egress_agg_params egress_agg_params;
+	/* Protect aggregation related elements */
+	spinlock_t agg_lock;
+	struct sk_buff *agg_skb;
+	int agg_state;
+	u8 agg_count;
+	struct timespec64 agg_time;
+	struct timespec64 agg_last;
+	struct hrtimer hrtimer;
+	struct work_struct agg_wq;
 };
 
 extern struct rtnl_link_ops rmnet_link_ops;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index a313242a762e..82e2669e3590 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -136,10 +136,15 @@ static int rmnet_map_egress_handler(struct sk_buff *skb,
 {
 	int required_headroom, additional_header_len, csum_type = 0;
 	struct rmnet_map_header *map_header;
+	bool is_icmp = false;
 
 	additional_header_len = 0;
 	required_headroom = sizeof(struct rmnet_map_header);
 
+	if (port->data_format & RMNET_FLAGS_EGRESS_AGGREGATION &&
+	    rmnet_map_tx_agg_skip(skb))
+		is_icmp = true;
+
 	if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV4) {
 		additional_header_len = sizeof(struct rmnet_map_ul_csum_header);
 		csum_type = RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
@@ -164,8 +169,18 @@ static int rmnet_map_egress_handler(struct sk_buff *skb,
 
 	map_header->mux_id = mux_id;
 
-	skb->protocol = htons(ETH_P_MAP);
+	if (port->data_format & RMNET_FLAGS_EGRESS_AGGREGATION && !is_icmp) {
+		if (skb_is_nonlinear(skb)) {
+			if (unlikely(__skb_linearize(skb)))
+				goto done;
+		}
+
+		rmnet_map_tx_aggregate(skb, port, orig_dev);
+		return -EINPROGRESS;
+	}
 
+done:
+	skb->protocol = htons(ETH_P_MAP);
 	return 0;
 }
 
@@ -235,6 +250,7 @@ void rmnet_egress_handler(struct sk_buff *skb)
 	struct rmnet_port *port;
 	struct rmnet_priv *priv;
 	u8 mux_id;
+	int err;
 
 	sk_pacing_shift_update(skb->sk, 8);
 
@@ -247,8 +263,13 @@ void rmnet_egress_handler(struct sk_buff *skb)
 	if (!port)
 		goto drop;
 
-	if (rmnet_map_egress_handler(skb, port, mux_id, orig_dev))
+	err = rmnet_map_egress_handler(skb, port, mux_id, orig_dev);
+	if (err == -ENOMEM) {
 		goto drop;
+	} else if (err == -EINPROGRESS) {
+		rmnet_vnd_tx_fixup(skb, orig_dev);
+		return;
+	}
 
 	rmnet_vnd_tx_fixup(skb, orig_dev);
 
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index 2b033060fc20..6aefc4e1bf47 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -53,5 +53,12 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
 				      struct net_device *orig_dev,
 				      int csum_type);
 int rmnet_map_process_next_hdr_packet(struct sk_buff *skb, u16 len);
+bool rmnet_map_tx_agg_skip(struct sk_buff *skb);
+void rmnet_map_tx_aggregate(struct sk_buff *skb, struct rmnet_port *port,
+			    struct net_device *orig_dev);
+void rmnet_map_tx_aggregate_init(struct rmnet_port *port);
+void rmnet_map_tx_aggregate_exit(struct rmnet_port *port);
+void rmnet_map_update_ul_agg_config(struct rmnet_port *port, u16 size,
+				    u16 count, u32 time);
 
 #endif /* _RMNET_MAP_H_ */
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index ba194698cc14..49eeed4a126b 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -12,6 +12,7 @@
 #include "rmnet_config.h"
 #include "rmnet_map.h"
 #include "rmnet_private.h"
+#include "rmnet_vnd.h"
 
 #define RMNET_MAP_DEAGGR_SPACING  64
 #define RMNET_MAP_DEAGGR_HEADROOM (RMNET_MAP_DEAGGR_SPACING / 2)
@@ -518,3 +519,198 @@ int rmnet_map_process_next_hdr_packet(struct sk_buff *skb,
 
 	return 0;
 }
+
+long rmnet_agg_bypass_time __read_mostly = 10000L * NSEC_PER_USEC;
+
+bool rmnet_map_tx_agg_skip(struct sk_buff *skb)
+{
+	bool is_icmp = 0;
+
+	if (skb->protocol == htons(ETH_P_IP)) {
+		struct iphdr *ip4h = ip_hdr(skb);
+
+		if (ip4h->protocol == IPPROTO_ICMP)
+			is_icmp = true;
+	} else if (skb->protocol == htons(ETH_P_IPV6)) {
+		unsigned int icmp_offset = 0;
+
+		if (ipv6_find_hdr(skb, &icmp_offset, IPPROTO_ICMPV6, NULL, NULL) == IPPROTO_ICMPV6)
+			is_icmp = true;
+	}
+
+	return is_icmp;
+}
+
+static void reset_aggr_params(struct rmnet_port *port)
+{
+	port->agg_skb = NULL;
+	port->agg_count = 0;
+	port->agg_state = 0;
+	memset(&port->agg_time, 0, sizeof(struct timespec64));
+}
+
+static void rmnet_map_flush_tx_packet_work(struct work_struct *work)
+{
+	struct sk_buff *skb = NULL;
+	struct rmnet_port *port;
+	unsigned long flags;
+
+	port = container_of(work, struct rmnet_port, agg_wq);
+
+	spin_lock_irqsave(&port->agg_lock, flags);
+	if (likely(port->agg_state == -EINPROGRESS)) {
+		/* Buffer may have already been shipped out */
+		if (likely(port->agg_skb)) {
+			skb = port->agg_skb;
+			reset_aggr_params(port);
+		}
+		port->agg_state = 0;
+	}
+
+	spin_unlock_irqrestore(&port->agg_lock, flags);
+	if (skb)
+		dev_queue_xmit(skb);
+}
+
+enum hrtimer_restart rmnet_map_flush_tx_packet_queue(struct hrtimer *t)
+{
+	struct rmnet_port *port;
+
+	port = container_of(t, struct rmnet_port, hrtimer);
+
+	schedule_work(&port->agg_wq);
+
+	return HRTIMER_NORESTART;
+}
+
+void rmnet_map_tx_aggregate(struct sk_buff *skb, struct rmnet_port *port,
+			    struct net_device *orig_dev)
+{
+	struct timespec64 diff, last;
+	int size = 0;
+	struct sk_buff *agg_skb;
+	unsigned long flags;
+
+new_packet:
+	spin_lock_irqsave(&port->agg_lock, flags);
+	memcpy(&last, &port->agg_last, sizeof(struct timespec64));
+	ktime_get_real_ts64(&port->agg_last);
+
+	if (!port->agg_skb) {
+		/* Check to see if we should agg first. If the traffic is very
+		 * sparse, don't aggregate.
+		 */
+		diff = timespec64_sub(port->agg_last, last);
+		size = port->egress_agg_params.agg_size - skb->len;
+
+		if (size < 0) {
+			struct rmnet_priv *priv;
+
+			/* dropped */
+			dev_kfree_skb_any(skb);
+			spin_unlock_irqrestore(&port->agg_lock, flags);
+			priv = netdev_priv(orig_dev);
+			this_cpu_inc(priv->pcpu_stats->stats.tx_drops);
+
+			return;
+		}
+
+		if (diff.tv_sec > 0 || diff.tv_nsec > rmnet_agg_bypass_time ||
+		    size == 0) {
+			spin_unlock_irqrestore(&port->agg_lock, flags);
+			skb->protocol = htons(ETH_P_MAP);
+			dev_queue_xmit(skb);
+			return;
+		}
+
+		port->agg_skb = skb_copy_expand(skb, 0, size, GFP_ATOMIC);
+		if (!port->agg_skb) {
+			reset_aggr_params(port);
+			spin_unlock_irqrestore(&port->agg_lock, flags);
+			skb->protocol = htons(ETH_P_MAP);
+			dev_queue_xmit(skb);
+			return;
+		}
+		port->agg_skb->protocol = htons(ETH_P_MAP);
+		port->agg_count = 1;
+		ktime_get_real_ts64(&port->agg_time);
+		dev_kfree_skb_any(skb);
+		goto schedule;
+	}
+	diff = timespec64_sub(port->agg_last, port->agg_time);
+	size = port->egress_agg_params.agg_size - port->agg_skb->len;
+
+	if (skb->len > size ||
+	    diff.tv_sec > 0 || diff.tv_nsec > port->egress_agg_params.agg_time_nsec) {
+		agg_skb = port->agg_skb;
+		reset_aggr_params(port);
+		spin_unlock_irqrestore(&port->agg_lock, flags);
+		hrtimer_cancel(&port->hrtimer);
+		dev_queue_xmit(agg_skb);
+		goto new_packet;
+	}
+
+	skb_put_data(port->agg_skb, skb->data, skb->len);
+	port->agg_count++;
+	dev_kfree_skb_any(skb);
+
+	if (port->agg_count == port->egress_agg_params.agg_count ||
+	    port->agg_skb->len == port->egress_agg_params.agg_size) {
+		agg_skb = port->agg_skb;
+		reset_aggr_params(port);
+		spin_unlock_irqrestore(&port->agg_lock, flags);
+		hrtimer_cancel(&port->hrtimer);
+		dev_queue_xmit(agg_skb);
+		return;
+	}
+
+schedule:
+	if (!hrtimer_active(&port->hrtimer) && port->agg_state != -EINPROGRESS) {
+		port->agg_state = -EINPROGRESS;
+		hrtimer_start(&port->hrtimer,
+			      ns_to_ktime(port->egress_agg_params.agg_time_nsec),
+			      HRTIMER_MODE_REL);
+	}
+	spin_unlock_irqrestore(&port->agg_lock, flags);
+}
+
+void rmnet_map_update_ul_agg_config(struct rmnet_port *port, u16 size,
+				    u16 count, u32 time)
+{
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&port->agg_lock, irq_flags);
+	port->egress_agg_params.agg_size = size;
+	port->egress_agg_params.agg_count = count;
+	port->egress_agg_params.agg_time_nsec = time * NSEC_PER_USEC;
+	spin_unlock_irqrestore(&port->agg_lock, irq_flags);
+}
+
+void rmnet_map_tx_aggregate_init(struct rmnet_port *port)
+{
+	hrtimer_init(&port->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	port->hrtimer.function = rmnet_map_flush_tx_packet_queue;
+	spin_lock_init(&port->agg_lock);
+	rmnet_map_update_ul_agg_config(port, 4096, 16, 800);
+	INIT_WORK(&port->agg_wq, rmnet_map_flush_tx_packet_work);
+}
+
+void rmnet_map_tx_aggregate_exit(struct rmnet_port *port)
+{
+	unsigned long flags;
+
+	hrtimer_cancel(&port->hrtimer);
+	cancel_work_sync(&port->agg_wq);
+
+	spin_lock_irqsave(&port->agg_lock, flags);
+	if (port->agg_state == -EINPROGRESS) {
+		if (port->agg_skb) {
+			kfree_skb(port->agg_skb);
+			reset_aggr_params(port);
+		}
+
+		port->agg_state = 0;
+	}
+
+	spin_unlock_irqrestore(&port->agg_lock, flags);
+}
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5e7a1041df3a..09a30e2b29b1 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1351,6 +1351,7 @@ enum {
 #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
 #define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 4)
 #define RMNET_FLAGS_EGRESS_MAP_CKSUMV5            (1U << 5)
+#define RMNET_FLAGS_EGRESS_AGGREGATION            (1U << 6)
 
 enum {
 	IFLA_RMNET_UNSPEC,
-- 
2.37.1

