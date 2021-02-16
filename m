Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7885A31C4D9
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 02:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhBPBJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 20:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhBPBJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 20:09:33 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A525C06178A;
        Mon, 15 Feb 2021 17:08:19 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id h8so8105164qkk.6;
        Mon, 15 Feb 2021 17:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1E8onOw+L2AIdLifTqqILKE60PtOo/4KA0a+LdKDsTM=;
        b=IrRmNXDMhi1zg9P5y2sL3qasJhm8ONboRQ+cY7ikz+XEhOkGqw+xbHpyP7cAPiovxA
         8pwZcmz9dDe7hXfVno03DzXE3jF0N/kMGpRU9/3KjBEXFlCac41DeQ9rpEpzAWusnK+t
         JpvMEXS2BX0ePDVY1/qEzG/e5FzjnuljzMb4aG1DVikcmdKIltwO/E2lJhFNL5BRVEj/
         nJL/iLoI29drpuxG1bpRNnWiwVmXNbvH/AUIRhTFZ+zw+PCiskDUXG8OjO0m1QW9xNXv
         1Y3FZA6C630ennBoqfTHIgiVzuMF/QXF3FxCba+sjG4k7AQOs8T+qrXoMl/PhORW6qWO
         FB+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1E8onOw+L2AIdLifTqqILKE60PtOo/4KA0a+LdKDsTM=;
        b=Y1ZSuSEg5iCTHr4BVLPlqHPd54LLQSJ3sHIu/GC1FOMi0m17Sf6McUaihRnyX/6KlU
         N7TmvUi9hCQ9j6TwcrqlmmslsEbZ7uDmEzMG2MbCFvzo9H3hNeFgc2KAwIpKQpFVnuKB
         a1uHcH/I5r9hjAFuFizsLddnmuACH2nG91GDcYzk90+7iqCe6SA0u2/fvMf1Vctyvghj
         P300NZl+A7AicROK3lStq6E81xuNZuQ9WjoyZ189/riAaJbx4t6qCP7Wt6uY28fAJcl0
         3Bdr8AQgdCuVlV4ep0yk96U/H4DlNvUCnn7YDpBvtqiVbv8xE4Lf7iFM3gBP/Pkr9Lif
         w5kg==
X-Gm-Message-State: AOAM5326BL6oskCgPvDQ8ISVd5qoZg0vvtt3wiOiQxutpN2z3y5D6dUz
        qKzoc2gpFU3DtxID284SNHA=
X-Google-Smtp-Source: ABdhPJz8Jpmy+7JLGxxDmdFy6jq7vsZtyvVA5sF4LeY69x1YDKdLfyc+hF4E6RCn6Nxi4gsNcX6dyA==
X-Received: by 2002:a37:d01:: with SMTP id 1mr17588798qkn.247.1613437698469;
        Mon, 15 Feb 2021 17:08:18 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id b20sm508830qto.45.2021.02.15.17.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 17:08:18 -0800 (PST)
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
Subject: [PATCH net-next v3 5/5] TEST ONLY: lan743x: skb_trim failure test
Date:   Mon, 15 Feb 2021 20:08:06 -0500
Message-Id: <20210216010806.31948-6-TheSven73@gmail.com>
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

Simulate low-memory in lan743x_rx_trim_skb(): fail one allocation
in every 100.

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

 drivers/net/ethernet/microchip/lan743x_main.c | 28 ++++++++-----------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 6e1b3c996bd7..4751626f4c0f 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1963,20 +1963,7 @@ static void lan743x_rx_update_tail(struct lan743x_rx *rx, int index)
 				  index);
 }
 
-static struct sk_buff *
-lan743x_alloc_skb(struct net_device *netdev, int length, bool can_fail)
-{
-	static int rx_alloc;
-	int counter = rx_alloc++ % 100;
-
-	if (can_fail && counter >= 20 && counter < 30)
-		return NULL;
-
-	return __netdev_alloc_skb(netdev, length, GFP_ATOMIC | GFP_DMA);
-}
-
-static int
-lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index, bool can_fail)
+static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index)
 {
 	struct net_device *netdev = rx->adapter->netdev;
 	struct device *dev = &rx->adapter->pdev->dev;
@@ -1990,7 +1977,7 @@ lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index, bool can_fail)
 
 	descriptor = &rx->ring_cpu_ptr[index];
 	buffer_info = &rx->buffer_info[index];
-	skb = lan743x_alloc_skb(netdev, buffer_length, can_fail);
+	skb = __netdev_alloc_skb(netdev, buffer_length, GFP_ATOMIC | GFP_DMA);
 	if (!skb)
 		return -ENOMEM;
 	dma_ptr = dma_map_single(dev, skb->data, buffer_length, DMA_FROM_DEVICE);
@@ -2078,6 +2065,13 @@ static void lan743x_rx_release_ring_element(struct lan743x_rx *rx, int index)
 static struct sk_buff *
 lan743x_rx_trim_skb(struct sk_buff *skb, int frame_length)
 {
+	static int trim_cnt;
+
+	if ((trim_cnt++ % 100) == 77) {
+		dev_kfree_skb_irq(skb);
+		return NULL;
+	}
+
 	if (skb_linearize(skb)) {
 		dev_kfree_skb_irq(skb);
 		return NULL;
@@ -2152,7 +2146,7 @@ static int lan743x_rx_process_buffer(struct lan743x_rx *rx)
 
 	/* save existing skb, allocate new skb and map to dma */
 	skb = buffer_info->skb;
-	if (lan743x_rx_init_ring_element(rx, rx->last_head, true)) {
+	if (lan743x_rx_init_ring_element(rx, rx->last_head)) {
 		/* failed to allocate next skb.
 		 * Memory is very low.
 		 * Drop this packet and reuse buffer.
@@ -2357,7 +2351,7 @@ static int lan743x_rx_ring_init(struct lan743x_rx *rx)
 
 	rx->last_head = 0;
 	for (index = 0; index < rx->ring_size; index++) {
-		ret = lan743x_rx_init_ring_element(rx, index, false);
+		ret = lan743x_rx_init_ring_element(rx, index);
 		if (ret)
 			goto cleanup;
 	}
-- 
2.17.1

