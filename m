Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53398318FCB
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 17:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhBKQWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 11:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbhBKQTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 11:19:31 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C64FC0617A7;
        Thu, 11 Feb 2021 08:18:40 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id u8so6209631ior.13;
        Thu, 11 Feb 2021 08:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n9Lhs45v53vKs8blqT5xx3avh0Ky4AFVSwRqrogf4Kc=;
        b=QjgIxtA4Y8mhJo/VAl/qdtaXPMK1H4QqSEx/YPmco/Z4H0okgU6lXaSona8jWzYyRb
         lwksMVAhj92wSO8wkBqc8l8tRIoCTgGLzDLX9nM2+9cBGvR7y4e0fdJIPubtIBhbWQ0J
         VxQnN469xBCne+EAjgk2wTwCfFZsXGlDxZA6UoBtR8T+JRGXCstKpbdFwb/6X4EW8ccx
         Ub+qZChiZr9qytPhO7X2ITT8WJlUuEuqwPDbEtU6wuGQh6qHxDu5ZVOWw1jCjMGcksYT
         MGZgNyTqlLWy2Vhj1mwmjHF19CnfQxku/EhUcRxAl+FX1myupTO/+v5GL2OHS0ae4ieG
         jLIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n9Lhs45v53vKs8blqT5xx3avh0Ky4AFVSwRqrogf4Kc=;
        b=G94NaEfkbYfQc8eesVPQCpxFVg9msE/5/AWj0FBZxHMZtotYeSzbBh/+TggCqYYwuy
         C79SrN+TYvF8dNZsvxmqrnF1hANci2saNqAmfAHHhVucmjrepUM+pK0D13w9dnGRZhkM
         YLdsHsDHsbJahvzWW4TyPwwFViqGqUSpSZrKYbkc5CD7sDraRDTVXFH00FJxscgRmG29
         JvRaVbRhw7Zr2STVneDp+mCslEAd/d+JAl50D5l0kzHIO2tNWwxm4ihz0A9EaD9hB5Ln
         soP4GAbYp+2P1a1yUrJcWFhIMZykEXnpkgd0odDZfQ4/N5ISEIwv8HGX2xlpju+y/K5J
         NJhQ==
X-Gm-Message-State: AOAM531rAO0BvYh/3OEN7xtYg1MXYrF3S4tL1RQE1VuOSqD6zqRGTsvg
        rs3eJsRJolhFMMZzjehOiz4=
X-Google-Smtp-Source: ABdhPJwDwAcCh8k+TeG2+JSo9wEcbcl6UCYhwtkL2cOwP/izDt8c0Odwx6rKjeaTrJ3xoHyl0+BsWA==
X-Received: by 2002:a05:6602:24c4:: with SMTP id h4mr6265993ioe.7.1613060319554;
        Thu, 11 Feb 2021 08:18:39 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id d135sm2729913iog.35.2021.02.11.08.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 08:18:39 -0800 (PST)
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
Subject: [PATCH net-next v2 4/5] TEST ONLY: lan743x: skb_alloc failure test
Date:   Thu, 11 Feb 2021 11:18:29 -0500
Message-Id: <20210211161830.17366-5-TheSven73@gmail.com>
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
index 90d49231494d..0094ecac5741 100644
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
@@ -2137,7 +2150,7 @@ static int lan743x_rx_process_buffer(struct lan743x_rx *rx)
 
 	/* save existing skb, allocate new skb and map to dma */
 	skb = buffer_info->skb;
-	if (lan743x_rx_init_ring_element(rx, rx->last_head)) {
+	if (lan743x_rx_init_ring_element(rx, rx->last_head, true)) {
 		/* failed to allocate next skb.
 		 * Memory is very low.
 		 * Drop this packet and reuse buffer.
@@ -2342,7 +2355,7 @@ static int lan743x_rx_ring_init(struct lan743x_rx *rx)
 
 	rx->last_head = 0;
 	for (index = 0; index < rx->ring_size; index++) {
-		ret = lan743x_rx_init_ring_element(rx, index);
+		ret = lan743x_rx_init_ring_element(rx, index, false);
 		if (ret)
 			goto cleanup;
 	}
-- 
2.17.1

