Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69894308DDC
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 20:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbhA2TzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 14:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbhA2Tx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 14:53:29 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37ADC06174A;
        Fri, 29 Jan 2021 11:52:48 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id t17so7598620qtq.2;
        Fri, 29 Jan 2021 11:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wZUDEcYeUWqVsTyaSGiJjQzVWLFvK2gANMka41D/0Kc=;
        b=PDlkGC5vsd8xZoycvu/npOr/3CygFdULWtje7Xe8pRoeGHUQP4QTLYvX1HNIq48MiM
         2P3VZ83UPwtrMdEJpsptoXvsrc0H8rBzGloh2BejRDKk3EALRlSxDE4ri7Ii+ZPAnOr8
         f3+4M8LR6ltvVAyMtnuFrgAmi51/zSN2cLVQoa1JWlK2+bJ3YOfl+QRp+DCnCBThSIaG
         KIvKjxOEAdYBYiU6ElmUjC7012LDP0Tdn7f90UXlnVfYwFTm1XHMuXVE9usZ25wk5wLt
         bTdTtW6YKteEHHDjGvll+r+fM4bjeiqX48oM1bJ0a7hVWW7C+07tKm3SJyCerrsRcDps
         iphw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wZUDEcYeUWqVsTyaSGiJjQzVWLFvK2gANMka41D/0Kc=;
        b=qFM+Yp1b01ndaH69CKBiQfjpef9tVxGFcLMPzNP3LDOhVw0/+QbOS9qjnPVuV67sid
         9cVpWUtgLlH5ky1en0tiT9obh6mimOsZwdIcun1Ny63J6mXhedmkqBxvU9mbcJ0GxTuo
         IMELfCY4Rbpdr6lQ4EfpwdRNdn1/60bv+m9ZN3O7DLrfzULpRMnmqQG2BBozTarhbwam
         gj6/1ceIgJ8eyZ2asoF/AyLhFMtIZdeEVC+eh/ptngSxWXQ/J5H8vCOzEwSRWdJV2KO3
         2rTnDLiDA+wiDLd0xzsltOBuRLixzaRDp9d/bxOpHVvLpU/irKcXjSIvHbfg5BYxoZTv
         ozPg==
X-Gm-Message-State: AOAM531VkS4rvoyDoIwx4SNua2JX4DiZlQEwwlOP+mi8A5aOmPxvYVq4
        cbK1KjiPgqVNZgyfPFBs0C6SfNhazXvGMg==
X-Google-Smtp-Source: ABdhPJxiSr7iZVRJcvI2Nn1D6+z3fZENSDse9Jtbi+5pc3Gw7QWeA8bsQUZf0Lr+gqIFpH7SyKfsaA==
X-Received: by 2002:ac8:5985:: with SMTP id e5mr5866684qte.160.1611949967762;
        Fri, 29 Jan 2021 11:52:47 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id s136sm6558994qka.106.2021.01.29.11.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 11:52:47 -0800 (PST)
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
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1 2/6] lan743x: support rx multi-buffer packets
Date:   Fri, 29 Jan 2021 14:52:36 -0500
Message-Id: <20210129195240.31871-3-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210129195240.31871-1-TheSven73@gmail.com>
References: <20210129195240.31871-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

Multi-buffer packets enable us to use rx ring buffers smaller than
the mtu. This will allow us to change the mtu on-the-fly, without
having to stop the network interface in order to re-size the rx
ring buffers.

This is a big change touching a key driver function (process_packet),
so care has been taken to test this extensively:

Tests with debug logging enabled (add #define DEBUG).

1. Limit rx buffer size to 500, so mtu (1500) takes 3 buffers.
   Ping to chip, verify correct packet size is sent to OS.
   Ping large packets to chip (ping -s 1400), verify correct
     packet size is sent to OS.
   Ping using packets around the buffer size, verify number of
     buffers is changing, verify correct packet size is sent
     to OS:
     $ ping -s 472
     $ ping -s 473
     $ ping -s 992
     $ ping -s 993
   Verify that each packet is followed by extension processing.

2. Limit rx buffer size to 500, so mtu (1500) takes 3 buffers.
   Run iperf3 -s on chip, verify that packets come in 3 buffers
     at a time.
   Verify that packet size is equal to mtu.
   Verify that each packet is followed by extension processing.

3. Set chip and host mtu to 2000.
   Limit rx buffer size to 500, so mtu (2000) takes 4 buffers.
   Run iperf3 -s on chip, verify that packets come in 4 buffers
     at a time.
   Verify that packet size is equal to mtu.
   Verify that each packet is followed by extension processing.

Tests with debug logging DISabled (remove #define DEBUG).

4. Limit rx buffer size to 500, so mtu (1500) takes 3 buffers.
   Run iperf3 -s on chip, note sustained rx speed.
   Set chip and host mtu to 2000, so mtu takes 4 buffers.
   Run iperf3 -s on chip, note sustained rx speed.
   Verify no packets are dropped in both cases.

Tests with DEBUG_KMEMLEAK on:
 $ mount -t debugfs nodev /sys/kernel/debug/
 $ echo scan > /sys/kernel/debug/kmemleak

5. Limit rx buffer size to 500, so mtu (1500) takes 3 buffers.
   Run the following tests concurrently for at least one hour:
   - iperf3 -s on chip
   - ping -> chip
   Monitor reported memory leaks.

6. Set chip and host mtu to 2000.
   Limit rx buffer size to 500, so mtu (2000) takes 4 buffers.
   Run the following tests concurrently for at least one hour:
   - iperf3 -s on chip
   - ping -> chip
   Monitor reported memory leaks.

7. Simulate low-memory in lan743x_rx_allocate_skb(): fail every
     100 allocations.
   Repeat (5) and (6).
   Monitor reported memory leaks.

8. Simulate  low-memory in lan743x_rx_allocate_skb(): fail 10
     allocations in a row in every 100.
   Repeat (5) and (6).
   Monitor reported memory leaks.

9. Simulate  low-memory in lan743x_rx_trim_skb(): fail 1 allocation
     in every 100.
   Repeat (5) and (6).
   Monitor reported memory leaks.

Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git # 46eb3c108fe1

To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: UNGLinuxDriver@microchip.com
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Alexey Denisov <rtgbnm@gmail.com>
Cc: Sergej Bauer <sbauer@blackbox.su>
Cc: Tim Harvey <tharvey@gateworks.com>
Cc: Anders Rønningen <anders@ronningen.priv.no>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org (open list)

 drivers/net/ethernet/microchip/lan743x_main.c | 321 ++++++++----------
 drivers/net/ethernet/microchip/lan743x_main.h |   2 +
 2 files changed, 143 insertions(+), 180 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index f485320e5784..b784e9feadac 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1955,15 +1955,6 @@ static int lan743x_rx_next_index(struct lan743x_rx *rx, int index)
 	return ((++index) % rx->ring_size);
 }
 
-static struct sk_buff *lan743x_rx_allocate_skb(struct lan743x_rx *rx)
-{
-	struct net_device *netdev = rx->adapter->netdev;
-
-	return __netdev_alloc_skb(netdev,
-				  netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING,
-				  GFP_ATOMIC | GFP_DMA);
-}
-
 static void lan743x_rx_update_tail(struct lan743x_rx *rx, int index)
 {
 	/* update the tail once per 8 descriptors */
@@ -1972,37 +1963,37 @@ static void lan743x_rx_update_tail(struct lan743x_rx *rx, int index)
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
-	struct net_device *netdev = rx->adapter->netdev;
+	struct sk_buff *skb;
+	dma_addr_t dma_ptr;
 	int length;
 
 	length = netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING;
+
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
@@ -2051,16 +2042,32 @@ static void lan743x_rx_release_ring_element(struct lan743x_rx *rx, int index)
 	memset(buffer_info, 0, sizeof(*buffer_info));
 }
 
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
 static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 {
-	struct skb_shared_hwtstamps *hwtstamps = NULL;
+	struct lan743x_rx_descriptor *descriptor, *desc_ext;
 	int result = RX_PROCESS_RESULT_NOTHING_TO_DO;
 	int current_head_index = le32_to_cpu(*rx->head_cpu_ptr);
 	struct lan743x_rx_buffer_info *buffer_info;
-	struct lan743x_rx_descriptor *descriptor;
+	struct skb_shared_hwtstamps *hwtstamps;
+	int frame_length, buffer_length;
+	struct sk_buff *skb;
 	int extension_index = -1;
-	int first_index = -1;
-	int last_index = -1;
+	bool is_last, is_first;
 
 	if (current_head_index < 0 || current_head_index >= rx->ring_size)
 		goto done;
@@ -2068,170 +2075,126 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
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
+	is_last = le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_LS_;
+	is_first = le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_FS_;
+
+	if (is_last && le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_EXT_) {
+		/* extension is expected to follow */
+		int index = lan743x_rx_next_index(rx, rx->last_head);
+
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
 	}
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
 
-			buffer_info = &rx->buffer_info[first_index];
-			skb = buffer_info->skb;
-			descriptor = &rx->ring_cpu_ptr[first_index];
-
-			/* unmap from dma */
-			packet_length =	RX_DESC_DATA0_FRAME_LENGTH_GET_
-					(descriptor->data0);
-			if (buffer_info->dma_ptr) {
-				dma_sync_single_for_cpu(&rx->adapter->pdev->dev,
-							buffer_info->dma_ptr,
-							packet_length,
-							DMA_FROM_DEVICE);
-				dma_unmap_single_attrs(&rx->adapter->pdev->dev,
-						       buffer_info->dma_ptr,
-						       buffer_info->buffer_length,
-						       DMA_FROM_DEVICE,
-						       DMA_ATTR_SKIP_CPU_SYNC);
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
+	/* Only the last buffer in a multi-buffer frame contains the total frame
+	 * length. All other buffers have a zero frame length. The chip
+	 * occasionally sends more buffers than strictly required to reach the
+	 * total frame length.
+	 * Handle this by adding all buffers to the skb in their entirety.
+	 * Once the real frame length is known, trim the skb.
+	 */
+	frame_length =
+		RX_DESC_DATA0_FRAME_LENGTH_GET_(le32_to_cpu(descriptor->data0));
+	buffer_length = buffer_info->buffer_length;
 
-			/* multi buffer packet not supported */
-			/* this should not happen since buffers are allocated
-			 * to be at least the mtu size configured in the mac.
-			 */
+	netdev_dbg(rx->adapter->netdev, "%s%schunk: %d/%d",
+		   is_first ? "first " : "      ",
+		   is_last  ? "last  " : "      ",
+		   frame_length, buffer_length);
 
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
+	/* unmap from dma */
+	if (buffer_info->dma_ptr) {
+		dma_unmap_single(&rx->adapter->pdev->dev,
+				 buffer_info->dma_ptr,
+				 buffer_info->buffer_length,
+				 DMA_FROM_DEVICE);
+		buffer_info->dma_ptr = 0;
+		buffer_info->buffer_length = 0;
+	}
+	skb = buffer_info->skb;
 
-process_extension:
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
+	/* allocate new skb and map to dma */
+	if (lan743x_rx_init_ring_element(rx, rx->last_head)) {
+		/* failed to allocate next skb.
+		 * Memory is very low.
+		 * Drop this packet and reuse buffer.
+		 */
+		lan743x_rx_reuse_ring_element(rx, rx->last_head);
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
+		rx->skb_head = skb;
+	}
 
-		if (!skb) {
-			result = RX_PROCESS_RESULT_PACKET_DROPPED;
-			goto move_forward;
+process_extension:
+	if (extension_index >= 0) {
+		u32 ts_sec;
+		u32 ts_nsec;
+
+		ts_sec = le32_to_cpu(desc_ext->data1);
+		ts_nsec = (le32_to_cpu(desc_ext->data2) &
+			  RX_DESC_DATA2_TS_NS_MASK_);
+		if (rx->skb_head) {
+			hwtstamps = skb_hwtstamps(rx->skb_head);
+			if (hwtstamps)
+				hwtstamps->hwtstamp = ktime_set(ts_sec, ts_nsec);
 		}
+		lan743x_rx_reuse_ring_element(rx, extension_index);
+		rx->last_head = extension_index;
+		netdev_dbg(rx->adapter->netdev, "process extension");
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
+		netdev_dbg(rx->adapter->netdev, "sending %d byte frame to OS",
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
+	result = RX_PROCESS_RESULT_PACKET_RECEIVED;
 done:
 	return result;
 }
@@ -2367,9 +2330,7 @@ static int lan743x_rx_ring_init(struct lan743x_rx *rx)
 
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
index 751f2bc9ce84..17e31a6210c6 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -698,6 +698,8 @@ struct lan743x_rx {
 	struct napi_struct napi;
 
 	u32		frame_count;
+
+	struct sk_buff *skb_head, *skb_tail;
 };
 
 struct lan743x_adapter {
-- 
2.17.1

