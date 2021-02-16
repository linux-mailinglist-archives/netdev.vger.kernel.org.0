Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FADE31C4D2
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 02:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhBPBI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 20:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhBPBIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 20:08:54 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02626C0613D6;
        Mon, 15 Feb 2021 17:08:13 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id e11so6123061qtg.6;
        Mon, 15 Feb 2021 17:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sjt21hKZXX12Wv4QGL7L2PvnW/5vG0+FWLtXLe00vgc=;
        b=UqD9jpZD5zGmctng5k+4JxuFan0yGtEp2pwCCIlVp6liGkYe3Wm4lxnNO84eKM5+c3
         dlSQuSBCRtG1lBXg8BqNYPccdaccoIvxZjOlbVcStfwKM2zxd+89jT6V4g7E2xjKsk5w
         uUvWBgpv1gWeCq5Clytzs8BGEENPM1gE5OFbdD7+To5U/8WD//qTT8s8WyAgnvWTTDuU
         tgaYB/FZ+dlOf8YnyFZHJNp0eacBZiigz+vV+X44bXIQ+98oc/c+xao7F9J/Jh3EmgbP
         UN304Dous0JFmtfQ9BGqudsLp9dulEos7+K3/VtexoszxzTYL59jxdb9uhcOpzIdyBIr
         1WvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sjt21hKZXX12Wv4QGL7L2PvnW/5vG0+FWLtXLe00vgc=;
        b=FZfH4tYYd5L2FHW2Uig8uXcSghv42BoOsrUANvKrOSjRzWFhYNaW/2IPdRofk80DD9
         zVn31gd428qJnGR1Q+YbqkstbO/1kJlKrShl5bRnXwCXMWcda3TD4kMmqiCoBAx/Mcrn
         mMOXDs7NqYVd+QVyDuPLTDaZWjo8JIGK7ia5vjB1ntDAEp16nhY+cqYAHTo8Y/jW4qwD
         dvtbSc935J8lEZBw4fWiBsPhh9n2uiSIkHL77gTnkXU4pMd3fH46zirZ5JmEe5O3Me2s
         rCkhx5nqllgyOVY5BlLralt5HHdRmwPy1RA6mH2UNQXods1EtjeKSod4EKEJ8DmfHfAs
         uVwQ==
X-Gm-Message-State: AOAM533ArrAuebT4eO24n4GVz7C+0PD8wlxgfoPI2LFueGt96UTACBzu
        HRuHglh59gfPUUJWHxIEGms=
X-Google-Smtp-Source: ABdhPJzxMQLNpVo/Zyjam23fCQWvZGj3S3vA9QEo9whzhzmp6gJ4AYsY+H3rCxlDAujCimr1vgb4Dw==
X-Received: by 2002:ac8:490f:: with SMTP id e15mr17030379qtq.188.1613437692899;
        Mon, 15 Feb 2021 17:08:12 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id b20sm508830qto.45.2021.02.15.17.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 17:08:12 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com, David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?q?Anders=20R=C3=B8nningen?= <anders@ronningen.priv.no>,
        Hillf Danton <hdanton@sina.com>,
        Christoph Hellwig <hch@lst.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 1/5] lan743x: boost performance on cpu archs w/o dma cache snooping
Date:   Mon, 15 Feb 2021 20:08:02 -0500
Message-Id: <20210216010806.31948-2-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210216010806.31948-1-TheSven73@gmail.com>
References: <20210216010806.31948-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

The buffers in the lan743x driver's receive ring are always 9K,
even when the largest packet that can be received (the mtu) is
much smaller. This performs particularly badly on cpu archs
without dma cache snooping (such as ARM): each received packet
results in a 9K dma_{map|unmap} operation, which is very expensive
because cpu caches need to be invalidated.

Careful measurement of the driver rx path on armv7 reveals that
the cpu spends the majority of its time waiting for cache
invalidation.

Optimize by keeping the rx ring buffer size as close as possible
to the mtu. This limits the amount of cache that requires
invalidation.

This optimization would normally force us to re-allocate all
ring buffers when the mtu is changed - a disruptive event,
because it can only happen when the network interface is down.

Remove the need to re-allocate all ring buffers by adding support
for multi-buffer frames. Now any combination of mtu and ring
buffer size will work. When the mtu changes from mtu1 to mtu2,
consumed buffers of size mtu1 are lazily replaced by newly
allocated buffers of size mtu2.

These optimizations double the rx performance on armv7.
Third parties report 3x rx speedup on armv8.

Tested with iperf3 on a freescale imx6qp + lan7430, both sides
set to mtu 1500 bytes, measure rx performance:

Before:
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-20.00  sec   550 MBytes   231 Mbits/sec    0
After:
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-20.00  sec  1.33 GBytes   570 Mbits/sec    0

Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
Reviewed-by: Bryan Whitehead <Bryan.Whitehead@microchip.com>
---

To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: UNGLinuxDriver@microchip.com
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Alexey Denisov <rtgbnm@gmail.com>
Cc: Sergej Bauer <sbauer@blackbox.su>
Cc: Tim Harvey <tharvey@gateworks.com>
Cc: Anders Rønningen <anders@ronningen.priv.no>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

 drivers/net/ethernet/microchip/lan743x_main.c | 324 ++++++++----------
 drivers/net/ethernet/microchip/lan743x_main.h |   5 +-
 2 files changed, 148 insertions(+), 181 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index f1f6eba4ace4..c2633efe6067 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1955,15 +1955,6 @@ static int lan743x_rx_next_index(struct lan743x_rx *rx, int index)
 	return ((++index) % rx->ring_size);
 }
 
-static struct sk_buff *lan743x_rx_allocate_skb(struct lan743x_rx *rx)
-{
-	int length = 0;
-
-	length = (LAN743X_MAX_FRAME_SIZE + ETH_HLEN + 4 + RX_HEAD_PADDING);
-	return __netdev_alloc_skb(rx->adapter->netdev,
-				  length, GFP_ATOMIC | GFP_DMA);
-}
-
 static void lan743x_rx_update_tail(struct lan743x_rx *rx, int index)
 {
 	/* update the tail once per 8 descriptors */
@@ -1972,36 +1963,40 @@ static void lan743x_rx_update_tail(struct lan743x_rx *rx, int index)
 				  index);
 }
 
-static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
-					struct sk_buff *skb)
+static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index)
 {
+	struct net_device *netdev = rx->adapter->netdev;
+	struct device *dev = &rx->adapter->pdev->dev;
 	struct lan743x_rx_buffer_info *buffer_info;
 	struct lan743x_rx_descriptor *descriptor;
-	int length = 0;
+	struct sk_buff *skb;
+	dma_addr_t dma_ptr;
+	int length;
+
+	length = netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING;
 
-	length = (LAN743X_MAX_FRAME_SIZE + ETH_HLEN + 4 + RX_HEAD_PADDING);
 	descriptor = &rx->ring_cpu_ptr[index];
 	buffer_info = &rx->buffer_info[index];
-	buffer_info->skb = skb;
-	if (!(buffer_info->skb))
+	skb = __netdev_alloc_skb(netdev, length, GFP_ATOMIC | GFP_DMA);
+	if (!skb)
 		return -ENOMEM;
-	buffer_info->dma_ptr = dma_map_single(&rx->adapter->pdev->dev,
-					      buffer_info->skb->data,
-					      length,
-					      DMA_FROM_DEVICE);
-	if (dma_mapping_error(&rx->adapter->pdev->dev,
-			      buffer_info->dma_ptr)) {
-		buffer_info->dma_ptr = 0;
+	dma_ptr = dma_map_single(dev, skb->data, length, DMA_FROM_DEVICE);
+	if (dma_mapping_error(dev, dma_ptr)) {
+		dev_kfree_skb_any(skb);
 		return -ENOMEM;
 	}
+	if (buffer_info->dma_ptr)
+		dma_unmap_single(dev, buffer_info->dma_ptr,
+				 buffer_info->buffer_length, DMA_FROM_DEVICE);
 
+	buffer_info->skb = skb;
+	buffer_info->dma_ptr = dma_ptr;
 	buffer_info->buffer_length = length;
 	descriptor->data1 = cpu_to_le32(DMA_ADDR_LOW32(buffer_info->dma_ptr));
 	descriptor->data2 = cpu_to_le32(DMA_ADDR_HIGH32(buffer_info->dma_ptr));
 	descriptor->data3 = 0;
 	descriptor->data0 = cpu_to_le32((RX_DESC_DATA0_OWN_ |
 			    (length & RX_DESC_DATA0_BUF_LENGTH_MASK_)));
-	skb_reserve(buffer_info->skb, RX_HEAD_PADDING);
 	lan743x_rx_update_tail(rx, index);
 
 	return 0;
@@ -2050,16 +2045,32 @@ static void lan743x_rx_release_ring_element(struct lan743x_rx *rx, int index)
 	memset(buffer_info, 0, sizeof(*buffer_info));
 }
 
-static int lan743x_rx_process_packet(struct lan743x_rx *rx)
+static struct sk_buff *
+lan743x_rx_trim_skb(struct sk_buff *skb, int frame_length)
+{
+	if (skb_linearize(skb)) {
+		dev_kfree_skb_irq(skb);
+		return NULL;
+	}
+	frame_length = max_t(int, 0, frame_length - RX_HEAD_PADDING - 2);
+	if (skb->len > frame_length) {
+		skb->tail -= skb->len - frame_length;
+		skb->len = frame_length;
+	}
+	return skb;
+}
+
+static int lan743x_rx_process_buffer(struct lan743x_rx *rx)
 {
-	struct skb_shared_hwtstamps *hwtstamps = NULL;
-	int result = RX_PROCESS_RESULT_NOTHING_TO_DO;
 	int current_head_index = le32_to_cpu(*rx->head_cpu_ptr);
+	struct lan743x_rx_descriptor *descriptor, *desc_ext;
+	struct net_device *netdev = rx->adapter->netdev;
+	int result = RX_PROCESS_RESULT_NOTHING_TO_DO;
 	struct lan743x_rx_buffer_info *buffer_info;
-	struct lan743x_rx_descriptor *descriptor;
+	int frame_length, buffer_length;
 	int extension_index = -1;
-	int first_index = -1;
-	int last_index = -1;
+	bool is_last, is_first;
+	struct sk_buff *skb;
 
 	if (current_head_index < 0 || current_head_index >= rx->ring_size)
 		goto done;
@@ -2067,163 +2078,120 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 	if (rx->last_head < 0 || rx->last_head >= rx->ring_size)
 		goto done;
 
-	if (rx->last_head != current_head_index) {
-		descriptor = &rx->ring_cpu_ptr[rx->last_head];
-		if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_OWN_)
-			goto done;
+	if (rx->last_head == current_head_index)
+		goto done;
 
-		if (!(le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_FS_))
-			goto done;
+	descriptor = &rx->ring_cpu_ptr[rx->last_head];
+	if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_OWN_)
+		goto done;
+	buffer_info = &rx->buffer_info[rx->last_head];
 
-		first_index = rx->last_head;
-		if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_LS_) {
-			last_index = rx->last_head;
-		} else {
-			int index;
-
-			index = lan743x_rx_next_index(rx, first_index);
-			while (index != current_head_index) {
-				descriptor = &rx->ring_cpu_ptr[index];
-				if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_OWN_)
-					goto done;
-
-				if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_LS_) {
-					last_index = index;
-					break;
-				}
-				index = lan743x_rx_next_index(rx, index);
-			}
-		}
-		if (last_index >= 0) {
-			descriptor = &rx->ring_cpu_ptr[last_index];
-			if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_EXT_) {
-				/* extension is expected to follow */
-				int index = lan743x_rx_next_index(rx,
-								  last_index);
-				if (index != current_head_index) {
-					descriptor = &rx->ring_cpu_ptr[index];
-					if (le32_to_cpu(descriptor->data0) &
-					    RX_DESC_DATA0_OWN_) {
-						goto done;
-					}
-					if (le32_to_cpu(descriptor->data0) &
-					    RX_DESC_DATA0_EXT_) {
-						extension_index = index;
-					} else {
-						goto done;
-					}
-				} else {
-					/* extension is not yet available */
-					/* prevent processing of this packet */
-					first_index = -1;
-					last_index = -1;
-				}
-			}
-		}
-	}
-	if (first_index >= 0 && last_index >= 0) {
-		int real_last_index = last_index;
-		struct sk_buff *skb = NULL;
-		u32 ts_sec = 0;
-		u32 ts_nsec = 0;
-
-		/* packet is available */
-		if (first_index == last_index) {
-			/* single buffer packet */
-			struct sk_buff *new_skb = NULL;
-			int packet_length;
-
-			new_skb = lan743x_rx_allocate_skb(rx);
-			if (!new_skb) {
-				/* failed to allocate next skb.
-				 * Memory is very low.
-				 * Drop this packet and reuse buffer.
-				 */
-				lan743x_rx_reuse_ring_element(rx, first_index);
-				goto process_extension;
-			}
+	is_last = le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_LS_;
+	is_first = le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_FS_;
 
-			buffer_info = &rx->buffer_info[first_index];
-			skb = buffer_info->skb;
-			descriptor = &rx->ring_cpu_ptr[first_index];
-
-			/* unmap from dma */
-			if (buffer_info->dma_ptr) {
-				dma_unmap_single(&rx->adapter->pdev->dev,
-						 buffer_info->dma_ptr,
-						 buffer_info->buffer_length,
-						 DMA_FROM_DEVICE);
-				buffer_info->dma_ptr = 0;
-				buffer_info->buffer_length = 0;
-			}
-			buffer_info->skb = NULL;
-			packet_length =	RX_DESC_DATA0_FRAME_LENGTH_GET_
-					(le32_to_cpu(descriptor->data0));
-			skb_put(skb, packet_length - 4);
-			skb->protocol = eth_type_trans(skb,
-						       rx->adapter->netdev);
-			lan743x_rx_init_ring_element(rx, first_index, new_skb);
-		} else {
-			int index = first_index;
+	if (is_last && le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_EXT_) {
+		/* extension is expected to follow */
+		int index = lan743x_rx_next_index(rx, rx->last_head);
 
-			/* multi buffer packet not supported */
-			/* this should not happen since
-			 * buffers are allocated to be at least jumbo size
-			 */
+		if (index == current_head_index)
+			/* extension not yet available */
+			goto done;
+		desc_ext = &rx->ring_cpu_ptr[index];
+		if (le32_to_cpu(desc_ext->data0) & RX_DESC_DATA0_OWN_)
+			/* extension not yet available */
+			goto done;
+		if (!(le32_to_cpu(desc_ext->data0) & RX_DESC_DATA0_EXT_))
+			goto move_forward;
+		extension_index = index;
+	}
 
-			/* clean up buffers */
-			if (first_index <= last_index) {
-				while ((index >= first_index) &&
-				       (index <= last_index)) {
-					lan743x_rx_reuse_ring_element(rx,
-								      index);
-					index = lan743x_rx_next_index(rx,
-								      index);
-				}
-			} else {
-				while ((index >= first_index) ||
-				       (index <= last_index)) {
-					lan743x_rx_reuse_ring_element(rx,
-								      index);
-					index = lan743x_rx_next_index(rx,
-								      index);
-				}
-			}
-		}
+	/* Only the last buffer in a multi-buffer frame contains the total frame
+	 * length. The chip occasionally sends more buffers than strictly
+	 * required to reach the total frame length.
+	 * Handle this by adding all buffers to the skb in their entirety.
+	 * Once the real frame length is known, trim the skb.
+	 */
+	frame_length =
+		RX_DESC_DATA0_FRAME_LENGTH_GET_(le32_to_cpu(descriptor->data0));
+	buffer_length = buffer_info->buffer_length;
+
+	netdev_dbg(netdev, "%s%schunk: %d/%d",
+		   is_first ? "first " : "      ",
+		   is_last  ? "last  " : "      ",
+		   frame_length, buffer_length);
+
+	/* save existing skb, allocate new skb and map to dma */
+	skb = buffer_info->skb;
+	if (lan743x_rx_init_ring_element(rx, rx->last_head)) {
+		/* failed to allocate next skb.
+		 * Memory is very low.
+		 * Drop this packet and reuse buffer.
+		 */
+		lan743x_rx_reuse_ring_element(rx, rx->last_head);
+		/* drop packet that was being assembled */
+		dev_kfree_skb_irq(rx->skb_head);
+		rx->skb_head = NULL;
+		goto process_extension;
+	}
+
+	/* add buffers to skb via skb->frag_list */
+	if (is_first) {
+		skb_reserve(skb, RX_HEAD_PADDING);
+		skb_put(skb, buffer_length - RX_HEAD_PADDING);
+		if (rx->skb_head)
+			dev_kfree_skb_irq(rx->skb_head);
+		rx->skb_head = skb;
+	} else if (rx->skb_head) {
+		skb_put(skb, buffer_length);
+		if (skb_shinfo(rx->skb_head)->frag_list)
+			rx->skb_tail->next = skb;
+		else
+			skb_shinfo(rx->skb_head)->frag_list = skb;
+		rx->skb_tail = skb;
+		rx->skb_head->len += skb->len;
+		rx->skb_head->data_len += skb->len;
+		rx->skb_head->truesize += skb->truesize;
+	} else {
+		/* packet to assemble has already been dropped because one or
+		 * more of its buffers could not be allocated
+		 */
+		netdev_dbg(netdev, "drop buffer intended for dropped packet");
+		dev_kfree_skb_irq(skb);
+	}
 
 process_extension:
-		if (extension_index >= 0) {
-			descriptor = &rx->ring_cpu_ptr[extension_index];
-			buffer_info = &rx->buffer_info[extension_index];
-
-			ts_sec = le32_to_cpu(descriptor->data1);
-			ts_nsec = (le32_to_cpu(descriptor->data2) &
-				  RX_DESC_DATA2_TS_NS_MASK_);
-			lan743x_rx_reuse_ring_element(rx, extension_index);
-			real_last_index = extension_index;
-		}
+	if (extension_index >= 0) {
+		u32 ts_sec;
+		u32 ts_nsec;
 
-		if (!skb) {
-			result = RX_PROCESS_RESULT_PACKET_DROPPED;
-			goto move_forward;
-		}
+		ts_sec = le32_to_cpu(desc_ext->data1);
+		ts_nsec = (le32_to_cpu(desc_ext->data2) &
+			  RX_DESC_DATA2_TS_NS_MASK_);
+		if (rx->skb_head)
+			skb_hwtstamps(rx->skb_head)->hwtstamp =
+				ktime_set(ts_sec, ts_nsec);
+		lan743x_rx_reuse_ring_element(rx, extension_index);
+		rx->last_head = extension_index;
+		netdev_dbg(netdev, "process extension");
+	}
 
-		if (extension_index < 0)
-			goto pass_packet_to_os;
-		hwtstamps = skb_hwtstamps(skb);
-		if (hwtstamps)
-			hwtstamps->hwtstamp = ktime_set(ts_sec, ts_nsec);
+	if (is_last && rx->skb_head)
+		rx->skb_head = lan743x_rx_trim_skb(rx->skb_head, frame_length);
 
-pass_packet_to_os:
-		/* pass packet to OS */
-		napi_gro_receive(&rx->napi, skb);
-		result = RX_PROCESS_RESULT_PACKET_RECEIVED;
+	if (is_last && rx->skb_head) {
+		rx->skb_head->protocol = eth_type_trans(rx->skb_head,
+							rx->adapter->netdev);
+		netdev_dbg(netdev, "sending %d byte frame to OS",
+			   rx->skb_head->len);
+		napi_gro_receive(&rx->napi, rx->skb_head);
+		rx->skb_head = NULL;
+	}
 
 move_forward:
-		/* push tail and head forward */
-		rx->last_tail = real_last_index;
-		rx->last_head = lan743x_rx_next_index(rx, real_last_index);
-	}
+	/* push tail and head forward */
+	rx->last_tail = rx->last_head;
+	rx->last_head = lan743x_rx_next_index(rx, rx->last_head);
+	result = RX_PROCESS_RESULT_BUFFER_RECEIVED;
 done:
 	return result;
 }
@@ -2242,12 +2210,12 @@ static int lan743x_rx_napi_poll(struct napi_struct *napi, int weight)
 				  DMAC_INT_BIT_RXFRM_(rx->channel_number));
 	}
 	for (count = 0; count < weight; count++) {
-		result = lan743x_rx_process_packet(rx);
+		result = lan743x_rx_process_buffer(rx);
 		if (result == RX_PROCESS_RESULT_NOTHING_TO_DO)
 			break;
 	}
 	rx->frame_count += count;
-	if (count == weight || result == RX_PROCESS_RESULT_PACKET_RECEIVED)
+	if (count == weight || result == RX_PROCESS_RESULT_BUFFER_RECEIVED)
 		return weight;
 
 	if (!napi_complete_done(napi, count))
@@ -2359,9 +2327,7 @@ static int lan743x_rx_ring_init(struct lan743x_rx *rx)
 
 	rx->last_head = 0;
 	for (index = 0; index < rx->ring_size; index++) {
-		struct sk_buff *new_skb = lan743x_rx_allocate_skb(rx);
-
-		ret = lan743x_rx_init_ring_element(rx, index, new_skb);
+		ret = lan743x_rx_init_ring_element(rx, index);
 		if (ret)
 			goto cleanup;
 	}
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 751f2bc9ce84..40dfb564c4f7 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -698,6 +698,8 @@ struct lan743x_rx {
 	struct napi_struct napi;
 
 	u32		frame_count;
+
+	struct sk_buff *skb_head, *skb_tail;
 };
 
 struct lan743x_adapter {
@@ -831,8 +833,7 @@ struct lan743x_rx_buffer_info {
 #define LAN743X_RX_RING_SIZE        (65)
 
 #define RX_PROCESS_RESULT_NOTHING_TO_DO     (0)
-#define RX_PROCESS_RESULT_PACKET_RECEIVED   (1)
-#define RX_PROCESS_RESULT_PACKET_DROPPED    (2)
+#define RX_PROCESS_RESULT_BUFFER_RECEIVED   (1)
 
 u32 lan743x_csr_read(struct lan743x_adapter *adapter, int offset);
 void lan743x_csr_write(struct lan743x_adapter *adapter, int offset, u32 data);
-- 
2.17.1

