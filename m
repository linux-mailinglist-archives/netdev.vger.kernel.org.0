Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C6F6425F5
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbiLEJm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiLEJm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:42:56 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5FC655D
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 01:42:54 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id fc4so19382648ejc.12
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 01:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2rm8lIkqXIIb2KXbNJWo5SLx5o44tBObuAxUSyKbZCQ=;
        b=ckDFDHr1bLdBB9LtXemgAUObxa3c1dlxWKWXE1dItqPcVMLW9lBFW9ZfG/LNNiSsg2
         EYCXup0lncIqtwOIrg4dReHEZe5hzPB3U6SARkvJ8JhqLb+0ng4AMX7Oa3uXi0C7oEkb
         qPNk4vQv3o87wVcAE4ggJKP+u4/KKsAr6Vl5Ku2YjOK53RYxLIRHaDOXA+zxDBnW8eGL
         VCMoicvdsfM5b1aCpKsupEbANLcpU1p8fCbgXMs24bwUsqpX/4rbjDevrTVIAn7/U7bv
         +7NiyNGuFozAi3PsGOsRenATtOUPFkWC7wY/us4HfkkmCgKszW/dAj/cSQyofGzYLI9y
         5ykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2rm8lIkqXIIb2KXbNJWo5SLx5o44tBObuAxUSyKbZCQ=;
        b=3sGklNF2gUSA6LB85qiyz04jF3SNNMBs1LjAB8zsfcbvS7szbOHDDxuZOKLxOnOkrL
         72uZ2v97pNn59cr9i/vFQPO2SeY5fisxy00aQRKBmy0O+Hjfxuv9Rmr2pfyn8kN96gwF
         tUOmNXUnQG4lCUUK+IbYrGExsJpja+Z+q6xYezbJMg9q3v95RqjukwccGWwC4mwoWmtp
         cDkAVDD+FptI3RgVGCG61U4BpZxIFQKF+C1BxNgIbMmp/1sHuKBUzM0uuOMSKseViI57
         d+gmuJ4mxKJaOoZ8666k1hS8frKkyq+TbkTYBuRAKhE3aNUu3yDHamJxAbFJZjV9TRLd
         /L0Q==
X-Gm-Message-State: ANoB5pk8QlOxuJU94z2uPovMtV0Q/YutV7vO4ip0Uw27ra268eTwTazt
        2BDpAYd7swVHDS8L4zhWctQ=
X-Google-Smtp-Source: AA0mqf78wKQ3+n27zW543VPcI2W6q4eoG48kUL+4VJ3KEUv1AaPZ2s3a3zsypQbmOI7vb8mSZQaCcw==
X-Received: by 2002:a17:907:50a2:b0:7c0:98e6:1216 with SMTP id fv34-20020a17090750a200b007c098e61216mr19863663ejc.575.1670233372706;
        Mon, 05 Dec 2022 01:42:52 -0800 (PST)
Received: from ThinkStation-P340.. (host-217-57-98-66.business.telecomitalia.it. [217.57.98.66])
        by smtp.gmail.com with ESMTPSA id bn18-20020a170906c0d200b0077a1dd3e7b7sm6083866ejb.102.2022.12.05.01.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 01:42:52 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>
Cc:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Taht <dave.taht@gmail.com>, netdev@vger.kernel.org,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next v3 2/3] net: qualcomm: rmnet: add tx packets aggregation
Date:   Mon,  5 Dec 2022 10:33:58 +0100
Message-Id: <20221205093359.49350-3-dnlplm@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221205093359.49350-1-dnlplm@gmail.com>
References: <20221205093359.49350-1-dnlplm@gmail.com>
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

Add tx packets aggregation.

Bidirectional TCP throughput tests through iperf with low-cat
Thread-x based modems revelead performance issues both in tx
and rx.

The Windows driver does not show this issue: inspecting USB
packets revealed that the only notable change is the driver
enabling tx packets aggregation.

Tx packets aggregation is by default disabled and can be enabled
by increasing the value of ETHTOOL_A_COALESCE_TX_MAX_AGGR_FRAMES.

The maximum aggregated size is by default set to a reasonably low
value in order to support the majority of modems.

This implementation is based on patches available in Code Aurora
repositories (msm kernel) whose main authors are

Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Sean Tranchetti <stranche@codeaurora.org>

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
v3
- Fixed no previous prototype for rmnet_map_flush_tx_packet_queue
  warning reported by kernel test robot
v2
- Removed icmp packets direct sending
- Changed spin_lock_irqsave to spin_lock_bh
- Increased the possible maximum size of an aggregated block
- Aligned rmnet_egress_agg_params and types to ethtool ones
- Changed bypass time from variable to define
- Fixed RCT style in rmnet_map_tx_aggregate
- Fixed order of skb freeing in rmnet_map_tx_aggregate
- rmnet_map_tx_aggregate refactoring
- Change aggregation function to use frag_list
- Removed RMNET_FLAGS_EGRESS_AGGREGATION
---
 .../ethernet/qualcomm/rmnet/rmnet_config.c    |   5 +
 .../ethernet/qualcomm/rmnet/rmnet_config.h    |  20 ++
 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |  18 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_map.h   |   6 +
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 191 ++++++++++++++++++
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |   9 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |   1 +
 7 files changed, 246 insertions(+), 4 deletions(-)

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
index 3d3cba56c516..ed112d51ac5a 100644
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
+	u32 bytes;
+	u32 count;
+	u64 time_nsec;
+};
+
 /* One instance of this structure is instantiated for each real_dev associated
  * with rmnet.
  */
@@ -30,6 +37,19 @@ struct rmnet_port {
 	struct hlist_head muxed_ep[RMNET_MAX_LOGICAL_EP];
 	struct net_device *bridge_ep;
 	struct net_device *rmnet_dev;
+
+	/* Egress aggregation information */
+	struct rmnet_egress_agg_params egress_agg_params;
+	/* Protect aggregation related elements */
+	spinlock_t agg_lock;
+	struct sk_buff *skbagg_head;
+	struct sk_buff *skbagg_tail;
+	int agg_state;
+	u8 agg_count;
+	struct timespec64 agg_time;
+	struct timespec64 agg_last;
+	struct hrtimer hrtimer;
+	struct work_struct agg_wq;
 };
 
 extern struct rtnl_link_ops rmnet_link_ops;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index a313242a762e..914ef03b5438 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -164,8 +164,18 @@ static int rmnet_map_egress_handler(struct sk_buff *skb,
 
 	map_header->mux_id = mux_id;
 
-	skb->protocol = htons(ETH_P_MAP);
+	if (port->egress_agg_params.count > 1) {
+		unsigned int len;
+
+		len = rmnet_map_tx_aggregate(skb, port, orig_dev);
+		if (likely(len)) {
+			rmnet_vnd_tx_fixup_len(len, orig_dev);
+			return -EINPROGRESS;
+		}
+		return -ENOMEM;
+	}
 
+	skb->protocol = htons(ETH_P_MAP);
 	return 0;
 }
 
@@ -235,6 +245,7 @@ void rmnet_egress_handler(struct sk_buff *skb)
 	struct rmnet_port *port;
 	struct rmnet_priv *priv;
 	u8 mux_id;
+	int err;
 
 	sk_pacing_shift_update(skb->sk, 8);
 
@@ -247,8 +258,11 @@ void rmnet_egress_handler(struct sk_buff *skb)
 	if (!port)
 		goto drop;
 
-	if (rmnet_map_egress_handler(skb, port, mux_id, orig_dev))
+	err = rmnet_map_egress_handler(skb, port, mux_id, orig_dev);
+	if (err == -ENOMEM)
 		goto drop;
+	else if (err == -EINPROGRESS)
+		return;
 
 	rmnet_vnd_tx_fixup(skb, orig_dev);
 
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index 2b033060fc20..b70284095568 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -53,5 +53,11 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
 				      struct net_device *orig_dev,
 				      int csum_type);
 int rmnet_map_process_next_hdr_packet(struct sk_buff *skb, u16 len);
+unsigned int rmnet_map_tx_aggregate(struct sk_buff *skb, struct rmnet_port *port,
+				    struct net_device *orig_dev);
+void rmnet_map_tx_aggregate_init(struct rmnet_port *port);
+void rmnet_map_tx_aggregate_exit(struct rmnet_port *port);
+void rmnet_map_update_ul_agg_config(struct rmnet_port *port, u32 size,
+				    u32 count, u32 time);
 
 #endif /* _RMNET_MAP_H_ */
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index ba194698cc14..2c094640f245 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -12,6 +12,7 @@
 #include "rmnet_config.h"
 #include "rmnet_map.h"
 #include "rmnet_private.h"
+#include "rmnet_vnd.h"
 
 #define RMNET_MAP_DEAGGR_SPACING  64
 #define RMNET_MAP_DEAGGR_HEADROOM (RMNET_MAP_DEAGGR_SPACING / 2)
@@ -518,3 +519,193 @@ int rmnet_map_process_next_hdr_packet(struct sk_buff *skb,
 
 	return 0;
 }
+
+#define RMNET_AGG_BYPASS_TIME_NSEC 10000000L
+
+static void reset_aggr_params(struct rmnet_port *port)
+{
+	port->skbagg_head = NULL;
+	port->agg_count = 0;
+	port->agg_state = 0;
+	memset(&port->agg_time, 0, sizeof(struct timespec64));
+}
+
+static void rmnet_send_skb(struct rmnet_port *port, struct sk_buff *skb)
+{
+	if (skb_needs_linearize(skb, port->dev->features)) {
+		if (unlikely(__skb_linearize(skb))) {
+			struct rmnet_priv *priv;
+
+			priv = netdev_priv(port->rmnet_dev);
+			this_cpu_inc(priv->pcpu_stats->stats.tx_drops);
+			dev_kfree_skb_any(skb);
+			return;
+		}
+	}
+
+	dev_queue_xmit(skb);
+}
+
+static void rmnet_map_flush_tx_packet_work(struct work_struct *work)
+{
+	struct sk_buff *skb = NULL;
+	struct rmnet_port *port;
+
+	port = container_of(work, struct rmnet_port, agg_wq);
+
+	spin_lock_bh(&port->agg_lock);
+	if (likely(port->agg_state == -EINPROGRESS)) {
+		/* Buffer may have already been shipped out */
+		if (likely(port->skbagg_head)) {
+			skb = port->skbagg_head;
+			reset_aggr_params(port);
+		}
+		port->agg_state = 0;
+	}
+
+	spin_unlock_bh(&port->agg_lock);
+	if (skb)
+		rmnet_send_skb(port, skb);
+}
+
+static enum hrtimer_restart rmnet_map_flush_tx_packet_queue(struct hrtimer *t)
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
+unsigned int rmnet_map_tx_aggregate(struct sk_buff *skb, struct rmnet_port *port,
+				    struct net_device *orig_dev)
+{
+	struct timespec64 diff, last;
+	unsigned int len = skb->len;
+	struct sk_buff *agg_skb;
+	int size;
+
+	spin_lock_bh(&port->agg_lock);
+	memcpy(&last, &port->agg_last, sizeof(struct timespec64));
+	ktime_get_real_ts64(&port->agg_last);
+
+	if (!port->skbagg_head) {
+		/* Check to see if we should agg first. If the traffic is very
+		 * sparse, don't aggregate.
+		 */
+new_packet:
+		diff = timespec64_sub(port->agg_last, last);
+		size = port->egress_agg_params.bytes - skb->len;
+
+		if (size < 0) {
+			/* dropped */
+			spin_unlock_bh(&port->agg_lock);
+			return 0;
+		}
+
+		if (diff.tv_sec > 0 || diff.tv_nsec > RMNET_AGG_BYPASS_TIME_NSEC ||
+		    size == 0) {
+			spin_unlock_bh(&port->agg_lock);
+			skb->protocol = htons(ETH_P_MAP);
+			dev_queue_xmit(skb);
+			return len;
+		}
+
+		port->skbagg_head = skb_copy_expand(skb, 0, size, GFP_ATOMIC);
+		if (!port->skbagg_head) {
+			spin_unlock_bh(&port->agg_lock);
+			skb->protocol = htons(ETH_P_MAP);
+			dev_queue_xmit(skb);
+			return len;
+		}
+		dev_kfree_skb_any(skb);
+		port->skbagg_head->protocol = htons(ETH_P_MAP);
+		port->agg_count = 1;
+		ktime_get_real_ts64(&port->agg_time);
+		skb_frag_list_init(port->skbagg_head);
+		goto schedule;
+	}
+	diff = timespec64_sub(port->agg_last, port->agg_time);
+	size = port->egress_agg_params.bytes - port->skbagg_head->len;
+
+	if (skb->len > size) {
+		agg_skb = port->skbagg_head;
+		reset_aggr_params(port);
+		spin_unlock_bh(&port->agg_lock);
+		hrtimer_cancel(&port->hrtimer);
+		rmnet_send_skb(port, agg_skb);
+		spin_lock_bh(&port->agg_lock);
+		goto new_packet;
+	}
+
+	if (skb_has_frag_list(port->skbagg_head))
+		port->skbagg_tail->next = skb;
+	else
+		skb_shinfo(port->skbagg_head)->frag_list = skb;
+
+	port->skbagg_head->len += skb->len;
+	port->skbagg_head->data_len += skb->len;
+	port->skbagg_head->truesize += skb->truesize;
+	port->skbagg_tail = skb;
+	port->agg_count++;
+
+	if (diff.tv_sec > 0 || diff.tv_nsec > port->egress_agg_params.time_nsec ||
+	    port->agg_count == port->egress_agg_params.count ||
+	    port->skbagg_head->len == port->egress_agg_params.bytes) {
+		agg_skb = port->skbagg_head;
+		reset_aggr_params(port);
+		spin_unlock_bh(&port->agg_lock);
+		hrtimer_cancel(&port->hrtimer);
+		rmnet_send_skb(port, agg_skb);
+		return len;
+	}
+
+schedule:
+	if (!hrtimer_active(&port->hrtimer) && port->agg_state != -EINPROGRESS) {
+		port->agg_state = -EINPROGRESS;
+		hrtimer_start(&port->hrtimer,
+			      ns_to_ktime(port->egress_agg_params.time_nsec),
+			      HRTIMER_MODE_REL);
+	}
+	spin_unlock_bh(&port->agg_lock);
+
+	return len;
+}
+
+void rmnet_map_update_ul_agg_config(struct rmnet_port *port, u32 size,
+				    u32 count, u32 time)
+{
+	spin_lock_bh(&port->agg_lock);
+	port->egress_agg_params.bytes = size;
+	port->egress_agg_params.count = count;
+	port->egress_agg_params.time_nsec = time * NSEC_PER_USEC;
+	spin_unlock_bh(&port->agg_lock);
+}
+
+void rmnet_map_tx_aggregate_init(struct rmnet_port *port)
+{
+	hrtimer_init(&port->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	port->hrtimer.function = rmnet_map_flush_tx_packet_queue;
+	spin_lock_init(&port->agg_lock);
+	rmnet_map_update_ul_agg_config(port, 4096, 1, 800);
+	INIT_WORK(&port->agg_wq, rmnet_map_flush_tx_packet_work);
+}
+
+void rmnet_map_tx_aggregate_exit(struct rmnet_port *port)
+{
+	hrtimer_cancel(&port->hrtimer);
+	cancel_work_sync(&port->agg_wq);
+
+	spin_lock_bh(&port->agg_lock);
+	if (port->agg_state == -EINPROGRESS) {
+		if (port->skbagg_head) {
+			dev_kfree_skb_any(port->skbagg_head);
+			reset_aggr_params(port);
+		}
+
+		port->agg_state = 0;
+	}
+	spin_unlock_bh(&port->agg_lock);
+}
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 3f5e6572d20e..6d8b8fdb9d03 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -29,7 +29,7 @@ void rmnet_vnd_rx_fixup(struct sk_buff *skb, struct net_device *dev)
 	u64_stats_update_end(&pcpu_ptr->syncp);
 }
 
-void rmnet_vnd_tx_fixup(struct sk_buff *skb, struct net_device *dev)
+void rmnet_vnd_tx_fixup_len(unsigned int len, struct net_device *dev)
 {
 	struct rmnet_priv *priv = netdev_priv(dev);
 	struct rmnet_pcpu_stats *pcpu_ptr;
@@ -38,10 +38,15 @@ void rmnet_vnd_tx_fixup(struct sk_buff *skb, struct net_device *dev)
 
 	u64_stats_update_begin(&pcpu_ptr->syncp);
 	pcpu_ptr->stats.tx_pkts++;
-	pcpu_ptr->stats.tx_bytes += skb->len;
+	pcpu_ptr->stats.tx_bytes += len;
 	u64_stats_update_end(&pcpu_ptr->syncp);
 }
 
+void rmnet_vnd_tx_fixup(struct sk_buff *skb, struct net_device *dev)
+{
+	rmnet_vnd_tx_fixup_len(skb->len, dev);
+}
+
 /* Network Device Operations */
 
 static netdev_tx_t rmnet_vnd_start_xmit(struct sk_buff *skb,
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
index dc3a4443ef0a..c2b2baf86894 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
@@ -16,6 +16,7 @@ int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
 int rmnet_vnd_dellink(u8 id, struct rmnet_port *port,
 		      struct rmnet_endpoint *ep);
 void rmnet_vnd_rx_fixup(struct sk_buff *skb, struct net_device *dev);
+void rmnet_vnd_tx_fixup_len(unsigned int len, struct net_device *dev);
 void rmnet_vnd_tx_fixup(struct sk_buff *skb, struct net_device *dev);
 void rmnet_vnd_setup(struct net_device *dev);
 int rmnet_vnd_validate_real_dev_mtu(struct net_device *real_dev);
-- 
2.37.1

