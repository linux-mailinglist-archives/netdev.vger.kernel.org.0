Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D8631C4D3
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 02:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhBPBJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 20:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhBPBIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 20:08:55 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FDAC061756;
        Mon, 15 Feb 2021 17:08:15 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id b14so8150263qkk.0;
        Mon, 15 Feb 2021 17:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zThIAGZwfvSkO7xnU4EZjlS525haOLyjxSDrptoIMpw=;
        b=ZZALdmcMkWw1hcaIKpLQZWaSVdXNuz9dyztRAKl+KLZ5rixd+wbe4HtlLeSAgZn32E
         uGHA0DCPmbCdCozANeHzCjwk2B/kb7QNKTTXVCUOsT+oyJYj7eq3CCjZ+QlnBj5L+Ir9
         IhtHwQFcuXDuXcv4JbktcrLGviVdJMnnJrNu2nygqVH/OJE5beul9wdYKGMZOYF6LIUF
         CFvJnLbwIUtXUkqy8FDLanbW/3XzdY3E6X9u/9EZlzc75zpDvsg90Z7qp1ScPNhcN5k6
         Lh3usx4iNXRe+oEMvSQOrme7X7IAzkoGsGRvhgFBsEhgRGdQgOvuPv6eaeyJJpGGmMb4
         2zfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zThIAGZwfvSkO7xnU4EZjlS525haOLyjxSDrptoIMpw=;
        b=kL8/2eUTVvqbEoR3MdlW3O10OL80UN0aRr4FwvKbXPKhCQWLwFYQyhXFTCsnQ/yDNM
         QVr70phFtBHbnovUWL+TurP9iIUsmCnb+rCoxZ7+/aKL1TMECeNvG9WW6VxAQn1M+cWg
         3RjPq2Rj1iIUs3jOddvUJAJ+NzLVVu2s8l37Ur2OXzhUcYbZs0cwRhO7G4QZHPfZM44L
         61rp9zXcfT5A58TPsd0FdnlzJjiFJfarOJFpAXiH7KERcTyktZNT5aAs2g3qLmSpAs3e
         OgbxtqUzEfq+2Gl8Hc6fgk8rgdK5U8sHiYdCK+G4YmEFuIW1PfbVe5aH8+jwC7dUraO3
         gdTw==
X-Gm-Message-State: AOAM530kfMefVJzx8JXY9OfXjXb7Ca8vYgJnWE/sjinF89Uld3Vfv7mp
        yilJJrJQ7HXtgNLXIbT0NGU=
X-Google-Smtp-Source: ABdhPJzj3OXkVjSjHDwg/MhJg/fEidoXM8lI5uDWlrn/LErZV87u7DQzsn2ohwz+1rYxbfAUP1Kvhw==
X-Received: by 2002:a05:620a:158c:: with SMTP id d12mr6169273qkk.147.1613437694269;
        Mon, 15 Feb 2021 17:08:14 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id b20sm508830qto.45.2021.02.15.17.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 17:08:13 -0800 (PST)
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
Subject: [PATCH net-next v3 2/5] lan743x: sync only the received area of an rx ring buffer
Date:   Mon, 15 Feb 2021 20:08:03 -0500
Message-Id: <20210216010806.31948-3-TheSven73@gmail.com>
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

On cpu architectures w/o dma cache snooping, dma_unmap() is a
is a very expensive operation, because its resulting sync
needs to invalidate cpu caches.

Increase efficiency/performance by syncing only those sections
of the lan743x's rx ring buffers that are actually in use.

Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
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

 drivers/net/ethernet/microchip/lan743x_main.c | 35 ++++++++++++++-----
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index c2633efe6067..6b642691a676 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1968,35 +1968,52 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index)
 	struct net_device *netdev = rx->adapter->netdev;
 	struct device *dev = &rx->adapter->pdev->dev;
 	struct lan743x_rx_buffer_info *buffer_info;
+	unsigned int buffer_length, used_length;
 	struct lan743x_rx_descriptor *descriptor;
 	struct sk_buff *skb;
 	dma_addr_t dma_ptr;
-	int length;
 
-	length = netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING;
+	buffer_length = netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING;
 
 	descriptor = &rx->ring_cpu_ptr[index];
 	buffer_info = &rx->buffer_info[index];
-	skb = __netdev_alloc_skb(netdev, length, GFP_ATOMIC | GFP_DMA);
+	skb = __netdev_alloc_skb(netdev, buffer_length, GFP_ATOMIC | GFP_DMA);
 	if (!skb)
 		return -ENOMEM;
-	dma_ptr = dma_map_single(dev, skb->data, length, DMA_FROM_DEVICE);
+	dma_ptr = dma_map_single(dev, skb->data, buffer_length, DMA_FROM_DEVICE);
 	if (dma_mapping_error(dev, dma_ptr)) {
 		dev_kfree_skb_any(skb);
 		return -ENOMEM;
 	}
-	if (buffer_info->dma_ptr)
-		dma_unmap_single(dev, buffer_info->dma_ptr,
-				 buffer_info->buffer_length, DMA_FROM_DEVICE);
+	if (buffer_info->dma_ptr) {
+		/* sync used area of buffer only */
+		if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_LS_)
+			/* frame length is valid only if LS bit is set.
+			 * it's a safe upper bound for the used area in this
+			 * buffer.
+			 */
+			used_length = min(RX_DESC_DATA0_FRAME_LENGTH_GET_
+					  (le32_to_cpu(descriptor->data0)),
+					  buffer_info->buffer_length);
+		else
+			used_length = buffer_info->buffer_length;
+		dma_sync_single_for_cpu(dev, buffer_info->dma_ptr,
+					used_length,
+					DMA_FROM_DEVICE);
+		dma_unmap_single_attrs(dev, buffer_info->dma_ptr,
+				       buffer_info->buffer_length,
+				       DMA_FROM_DEVICE,
+				       DMA_ATTR_SKIP_CPU_SYNC);
+	}
 
 	buffer_info->skb = skb;
 	buffer_info->dma_ptr = dma_ptr;
-	buffer_info->buffer_length = length;
+	buffer_info->buffer_length = buffer_length;
 	descriptor->data1 = cpu_to_le32(DMA_ADDR_LOW32(buffer_info->dma_ptr));
 	descriptor->data2 = cpu_to_le32(DMA_ADDR_HIGH32(buffer_info->dma_ptr));
 	descriptor->data3 = 0;
 	descriptor->data0 = cpu_to_le32((RX_DESC_DATA0_OWN_ |
-			    (length & RX_DESC_DATA0_BUF_LENGTH_MASK_)));
+			    (buffer_length & RX_DESC_DATA0_BUF_LENGTH_MASK_)));
 	lan743x_rx_update_tail(rx, index);
 
 	return 0;
-- 
2.17.1

