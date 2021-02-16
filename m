Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819E531C4D7
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 02:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhBPBJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 20:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhBPBI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 20:08:58 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01952C061788;
        Mon, 15 Feb 2021 17:08:18 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id q85so8083888qke.8;
        Mon, 15 Feb 2021 17:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yP6IM66T67/6mtMnFzbnkT8S2SYnDBbnYYGg3mjHIYs=;
        b=VGkA7eAYzpUc4NBu1AGN2oV0QBhitjYgl8diooy254l+LeZZt/o5ty97sgtQ0I1wzC
         sr19JmsXHnqOtlLPyb5pl+QVzhFJd97GpMJ30M0uEgHyI47XSblcnYvYtkF0Ib397GtV
         Y1zOw+GF4jjewf69SX5dj0Em9XoZflwXZgPjdYbGEsrsANKD0WoOxtJSYJGY6D3iAkVw
         4iXP5Rjo3hWcoRc4rKtuQ+2uAAvYLzfVn7UYtD7uksEuYQq6OFHRd/7B8tODNbZKdGN4
         6bWoeunVE784w6t13F91nOFDgkZxSfLxQf8tf1AD7JuZnN6xhTvBxqkgn4EibCwW7tNy
         qHQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yP6IM66T67/6mtMnFzbnkT8S2SYnDBbnYYGg3mjHIYs=;
        b=Qm/4x/BuZhLO7fKU567HOPtzZlLp4Uka/YrCASyWxc0q1zYTfCs1UUfyvLrzv+m+PR
         cHNedAsmH5N9Ow3xm7fjm/ed128wEaCauGkWPddpLRWu1XX71R0fArp22BtYbIYOpH7N
         +wi5dXzUWYUfkIoxKv9Rfg54+GvA9d6sncCHPZR3+awmjM1Ln8iuR6hMDioXq2sxqeJ0
         QzX7KdvBtRVy0NtnYbddHtZ2daYFDIaDugn88xUQErX4UQ1pKfkUYAZlU3nJOVs/E+hO
         JxdamBQrh0vDx72WuJabF6YHmmsyQLf4/WWfU92pL6icAnEmCWgvxL7dLxGQARZ8/Zfa
         amAQ==
X-Gm-Message-State: AOAM530mH+1V+bXfpjP7EO13yr+utXcYGfIHfV4OOjwqJLbfweoiPIN0
        ihUnDBcZLF4SiGCnhiq7zac=
X-Google-Smtp-Source: ABdhPJyEEca4ub6fNVJO/tyZmcjCbTby6c/Ro2rzIDHHRW94s0urk1CvckM0H8fVYd0sojYEmEXCMw==
X-Received: by 2002:a05:620a:148c:: with SMTP id w12mr15366491qkj.186.1613437697035;
        Mon, 15 Feb 2021 17:08:17 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id b20sm508830qto.45.2021.02.15.17.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 17:08:16 -0800 (PST)
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
Subject: [PATCH net-next v3 4/5] TEST ONLY: lan743x: skb_alloc failure test
Date:   Mon, 15 Feb 2021 20:08:05 -0500
Message-Id: <20210216010806.31948-5-TheSven73@gmail.com>
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

Simulate low-memory in lan743x_rx_allocate_skb(): fail 10
allocations in a row in every 100.

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

 drivers/net/ethernet/microchip/lan743x_main.c | 21 +++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 90738ec5e7ec..6e1b3c996bd7 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1963,7 +1963,20 @@ static void lan743x_rx_update_tail(struct lan743x_rx *rx, int index)
 				  index);
 }
 
-static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index)
+static struct sk_buff *
+lan743x_alloc_skb(struct net_device *netdev, int length, bool can_fail)
+{
+	static int rx_alloc;
+	int counter = rx_alloc++ % 100;
+
+	if (can_fail && counter >= 20 && counter < 30)
+		return NULL;
+
+	return __netdev_alloc_skb(netdev, length, GFP_ATOMIC | GFP_DMA);
+}
+
+static int
+lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index, bool can_fail)
 {
 	struct net_device *netdev = rx->adapter->netdev;
 	struct device *dev = &rx->adapter->pdev->dev;
@@ -1977,7 +1990,7 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index)
 
 	descriptor = &rx->ring_cpu_ptr[index];
 	buffer_info = &rx->buffer_info[index];
-	skb = __netdev_alloc_skb(netdev, buffer_length, GFP_ATOMIC | GFP_DMA);
+	skb = lan743x_alloc_skb(netdev, buffer_length, can_fail);
 	if (!skb)
 		return -ENOMEM;
 	dma_ptr = dma_map_single(dev, skb->data, buffer_length, DMA_FROM_DEVICE);
@@ -2139,7 +2152,7 @@ static int lan743x_rx_process_buffer(struct lan743x_rx *rx)
 
 	/* save existing skb, allocate new skb and map to dma */
 	skb = buffer_info->skb;
-	if (lan743x_rx_init_ring_element(rx, rx->last_head)) {
+	if (lan743x_rx_init_ring_element(rx, rx->last_head, true)) {
 		/* failed to allocate next skb.
 		 * Memory is very low.
 		 * Drop this packet and reuse buffer.
@@ -2344,7 +2357,7 @@ static int lan743x_rx_ring_init(struct lan743x_rx *rx)
 
 	rx->last_head = 0;
 	for (index = 0; index < rx->ring_size; index++) {
-		ret = lan743x_rx_init_ring_element(rx, index);
+		ret = lan743x_rx_init_ring_element(rx, index, false);
 		if (ret)
 			goto cleanup;
 	}
-- 
2.17.1

