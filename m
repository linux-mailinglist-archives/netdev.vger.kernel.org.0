Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16679308E2E
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbhA2UK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbhA2Tx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 14:53:27 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E0CC061574;
        Fri, 29 Jan 2021 11:52:47 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id c1so7609112qtc.1;
        Fri, 29 Jan 2021 11:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NJl5nz8B/w9PQNydomJXvK6cYumU20h6AeRMSE4OuRY=;
        b=Z4hRnb2+wLp/gRainOiF00YxS3+yTjNJd4EKhPaqLliRLKU+sJYqDhF1XbTE7EcHLf
         GP9EiyQkG8/2difzGDPC/RfnN4t1nRv2Bi57IJv9cI1kFwLtY6/RzU//2fusE89xSZqN
         V2UaKUErnK6e1b/KutXG/F3ZWIJiiPFaJ4db9mF009X5zt6OAW2h1c5OcbH/UG4gksfG
         e3mm/ZNQGBMUq2a/ejFcxPItT7szMDRIvF4aPc6u4B/KOjSrQZwqry5y0aDAMCrlLBA2
         pWia7OqwqIQKTa36Q26W38VmzG914xkXYkEUlaH6x9u5FXUZXmjLRo9+sK9LYqF79HLn
         IWuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NJl5nz8B/w9PQNydomJXvK6cYumU20h6AeRMSE4OuRY=;
        b=Wk7vprXKDc3Y9d3a2/22bFwix0mMCzwwgwPMKbZdNgRwaG2S4CBrgWOnNCmlQGTkGO
         QqMrfYdo+xvKgeWzdq5B1/B00xE+gyyUk7vNtIgTcApibwpMguxMRKzNBcmxSW4vKx+r
         n6ti+SpiWH79acPDWP24Y80oEBmkmBh9wwd21PvIEFa+V+fUUHJ/6t1ht1xfLyvfZ+JH
         0KPmTyArXZM+11acfEmJUpLPFyRu6F/VBC3IFiDIKm8OOz6vi0/Bxl8khNHLlgUooLac
         WmI1Cx0zHpE//q9wORvTcAkI3AZQ7615p4OxiFkAfuzBI9lMt2rxsEOvnV0h4G3A8DQM
         jz8w==
X-Gm-Message-State: AOAM530aiC4TcxMhvwNzwigqwSWfD13LOS998IXYOqOvtSevMkp/jHvn
        AEvGUlB4Xd2qmG1DeQ6WQVg=
X-Google-Smtp-Source: ABdhPJwZcm0Fzs4yHPrOetfFJ86vdEXNFDDTJL6A1CHzbqQk+515R57/ojaHBAT2hDPbEwtT79296Q==
X-Received: by 2002:ac8:370b:: with SMTP id o11mr6014792qtb.314.1611949966450;
        Fri, 29 Jan 2021 11:52:46 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id s136sm6558994qka.106.2021.01.29.11.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 11:52:46 -0800 (PST)
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
Subject: [PATCH net-next v1 1/6] lan743x: boost performance on cpu archs w/o dma cache snooping
Date:   Fri, 29 Jan 2021 14:52:35 -0500
Message-Id: <20210129195240.31871-2-TheSven73@gmail.com>
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

The buffers in the lan743x driver's receive ring are always 9K,
even when the largest packet that can be received (the mtu) is
much smaller. This performs particularly badly on cpu archs
without dma cache snooping (such as ARM): each received packet
results in a 9K dma_{map|unmap} operation, which is very expensive
because cpu caches need to be invalidated.

Careful measurement of the driver rx path on armv7 reveals that
the cpu spends the majority of its time waiting for cache
invalidation.

Optimize as follows:

1. set rx ring buffer size equal to the mtu. this limits the
   amount of cache that needs to be invalidated per dma_map().

2. when dma_unmap()ping, skip cpu sync. Sync only the packet data
   actually received, the size of which the chip will indicate in
   its rx ring descriptors. this limits the amount of cache that
   needs to be invalidated per dma_unmap().

These optimizations double the rx performance on armv7.
Third parties report 3x rx speedup on armv8.

Performance on dma cache snooping architectures (such as x86)
is expected to stay the same.

Tested with iperf3 on a freescale imx6qp + lan7430, both sides
set to mtu 1500 bytes, measure rx performance:

Before:
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-20.00  sec   550 MBytes   231 Mbits/sec    0
After:
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-20.00  sec  1.33 GBytes   570 Mbits/sec    0

Test by Anders Roenningen (anders@ronningen.priv.no) on armv8,
    rx iperf3:
Before 102 Mbits/sec
After  279 Mbits/sec

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

 drivers/net/ethernet/microchip/lan743x_main.c | 35 ++++++++++++-------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index f1f6eba4ace4..f485320e5784 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1957,11 +1957,11 @@ static int lan743x_rx_next_index(struct lan743x_rx *rx, int index)
 
 static struct sk_buff *lan743x_rx_allocate_skb(struct lan743x_rx *rx)
 {
-	int length = 0;
+	struct net_device *netdev = rx->adapter->netdev;
 
-	length = (LAN743X_MAX_FRAME_SIZE + ETH_HLEN + 4 + RX_HEAD_PADDING);
-	return __netdev_alloc_skb(rx->adapter->netdev,
-				  length, GFP_ATOMIC | GFP_DMA);
+	return __netdev_alloc_skb(netdev,
+				  netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING,
+				  GFP_ATOMIC | GFP_DMA);
 }
 
 static void lan743x_rx_update_tail(struct lan743x_rx *rx, int index)
@@ -1977,9 +1977,10 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
 {
 	struct lan743x_rx_buffer_info *buffer_info;
 	struct lan743x_rx_descriptor *descriptor;
-	int length = 0;
+	struct net_device *netdev = rx->adapter->netdev;
+	int length;
 
-	length = (LAN743X_MAX_FRAME_SIZE + ETH_HLEN + 4 + RX_HEAD_PADDING);
+	length = netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING;
 	descriptor = &rx->ring_cpu_ptr[index];
 	buffer_info = &rx->buffer_info[index];
 	buffer_info->skb = skb;
@@ -2148,11 +2149,18 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 			descriptor = &rx->ring_cpu_ptr[first_index];
 
 			/* unmap from dma */
+			packet_length =	RX_DESC_DATA0_FRAME_LENGTH_GET_
+					(descriptor->data0);
 			if (buffer_info->dma_ptr) {
-				dma_unmap_single(&rx->adapter->pdev->dev,
-						 buffer_info->dma_ptr,
-						 buffer_info->buffer_length,
-						 DMA_FROM_DEVICE);
+				dma_sync_single_for_cpu(&rx->adapter->pdev->dev,
+							buffer_info->dma_ptr,
+							packet_length,
+							DMA_FROM_DEVICE);
+				dma_unmap_single_attrs(&rx->adapter->pdev->dev,
+						       buffer_info->dma_ptr,
+						       buffer_info->buffer_length,
+						       DMA_FROM_DEVICE,
+						       DMA_ATTR_SKIP_CPU_SYNC);
 				buffer_info->dma_ptr = 0;
 				buffer_info->buffer_length = 0;
 			}
@@ -2167,8 +2175,8 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 			int index = first_index;
 
 			/* multi buffer packet not supported */
-			/* this should not happen since
-			 * buffers are allocated to be at least jumbo size
+			/* this should not happen since buffers are allocated
+			 * to be at least the mtu size configured in the mac.
 			 */
 
 			/* clean up buffers */
@@ -2628,6 +2636,9 @@ static int lan743x_netdev_change_mtu(struct net_device *netdev, int new_mtu)
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
 	int ret = 0;
 
+	if (netif_running(netdev))
+		return -EBUSY;
+
 	ret = lan743x_mac_set_mtu(adapter, new_mtu);
 	if (!ret)
 		netdev->mtu = new_mtu;
-- 
2.17.1

