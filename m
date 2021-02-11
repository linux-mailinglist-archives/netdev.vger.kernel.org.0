Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1641C318FC4
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 17:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhBKQVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 11:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbhBKQTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 11:19:19 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1392C061794;
        Thu, 11 Feb 2021 08:18:37 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id e1so5587860ilu.0;
        Thu, 11 Feb 2021 08:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xp4N40JfQ3VVDOWjhEqow9AAoJ4Ma4pLuM+YDtd7UgM=;
        b=mtj2EYF6jZubD9FqRDnVGO9Nzrt3asJMR6eRmNxbiQmeLXJ41KzQgcAiw75aFbcaIO
         XPth5rq7hMm1y17IJJZ+zMgqgt2YmiL0V+BsYh+gdSQYKEo7E8/3F+aQY0ktGOEqe/px
         pFbs9oljojdEg3MJTwUVjVE2TMW3nEH6TxWItZ64TK/v+wpK1FAQmHvvamESNccCdmbU
         FfYnEFQN9BpDwxA70u2lW30+BCL3OtmUpnEzHJGDHc6vgXwrCFRrv5vnFWEBn3Ya8NEH
         3e22qb+GPWZDHlWpSBB8NPYsZGPJdtS3opt+wylkai8fTrVcCOsOgHcaaTsEvLssb7Qi
         AT/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xp4N40JfQ3VVDOWjhEqow9AAoJ4Ma4pLuM+YDtd7UgM=;
        b=MDo/e9agMYa9sXfMRgrdmcaQ2OGWL3LltQQAVhES0C2q3CDtvOP0NIktM+oDooEFmj
         YgumdcgiI9ADxuRevlNzn5j4GjlQLzBg7DODb72++dn1gD9Uz8XqBkoDW0sKIzfCA0ZX
         BAP5zWe7SdyDJkZTilEDDE3saM6DRCc8xE8QPayHS4k3ZLk1hNaSk6SKYSw5FypOZOY7
         h9Zx37m3uJXAmDaK9GcUbLJH/oVNCbfvYA3SHnPHHNnMIrjrZCWxdTLXYutiBVf65aUy
         bjsB1ReK8XI44T2dYjtOVXSir+BCTZ7tzXInNaIYzdKeBYaYcSJNJLWmWxu8m/eMXzBe
         dUAw==
X-Gm-Message-State: AOAM533gRNyb9HPkL07hI4ZVHq1NmxZ1dcNWbX8TA7lEe7qIyLNehYFv
        qra1uswVInyLFQlGOvJdgfw=
X-Google-Smtp-Source: ABdhPJyiRlMHOsnmLmk554WUf5bF1KkI+XEFPfqpzLjvZdMmtjUIkeHE6mkOmWAVM76TZBe0rVi15w==
X-Received: by 2002:a92:c00f:: with SMTP id q15mr6330193ild.62.1613060316991;
        Thu, 11 Feb 2021 08:18:36 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id d135sm2729913iog.35.2021.02.11.08.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 08:18:36 -0800 (PST)
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
Subject: [PATCH net-next v2 2/5] lan743x: sync only the received area of an rx ring buffer
Date:   Thu, 11 Feb 2021 11:18:27 -0500
Message-Id: <20210211161830.17366-3-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210211161830.17366-1-TheSven73@gmail.com>
References: <20210211161830.17366-1-TheSven73@gmail.com>
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

 drivers/net/ethernet/microchip/lan743x_main.c | 32 +++++++++++++------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 0c48bb559719..36cc67c72851 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1968,35 +1968,49 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index)
 	struct net_device *netdev = rx->adapter->netdev;
 	struct device *dev = &rx->adapter->pdev->dev;
 	struct lan743x_rx_buffer_info *buffer_info;
+	unsigned int buffer_length, packet_length;
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
+		/* unmap from dma */
+		packet_length = RX_DESC_DATA0_FRAME_LENGTH_GET_
+				(le32_to_cpu(descriptor->data0));
+		if (packet_length == 0 ||
+		    packet_length > buffer_info->buffer_length)
+			/* buffer is part of multi-buffer packet: fully used */
+			packet_length = buffer_info->buffer_length;
+		/* sync used part of buffer only */
+		dma_sync_single_for_cpu(dev, buffer_info->dma_ptr,
+					packet_length,
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

