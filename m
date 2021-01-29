Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5DB308DE5
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 20:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbhA2T4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 14:56:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233024AbhA2Tyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 14:54:33 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91463C0613ED;
        Fri, 29 Jan 2021 11:52:52 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id k193so9917087qke.6;
        Fri, 29 Jan 2021 11:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FUZQHmSz8v3ZgZ4ETLTlu70PtPovT39hOXxs/7uV0ak=;
        b=KMWjVfcFin1+Di60Wpv6w/JJgM5adDrEgxFWsbt4urmWktq9qtXvWk6IWQ6/y/fATr
         VCgGxgtFL52vUhzdvWLMGXU3pn2XYdEeGjvDo6GW4fAcqMsTyVttwaqNChsdMLB+5LGp
         q3QuFOaOBqX+h69kCDMpnNA1/bgBV+Kx81JEY/5mwNfBH8U9wZd6ApDxCthIxZtInDOA
         8FMuVL/sPbE3bcII6OoFV/VvU9DtRBWm+R1ygiYTRNNtGd4JkQnj4E1vAO+LVYkIUc6g
         blL+vHQ9jK1qFvHp3Lcy5BFBN/GLDStYIq6uV0glfOMbYtqHVMVqfJXX+AkhsJ4vNCYY
         SKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FUZQHmSz8v3ZgZ4ETLTlu70PtPovT39hOXxs/7uV0ak=;
        b=DCm/vZRWT8hikh18Mjxp6mCCW1p+5T0Enjoue4qM/kmdcribg1qSobQZbFgxfFr+9s
         QmzrhO79YtGstNX15J9FoHAjZ02IcP1EWagdio+M+KiZWnWCTnAVqAzPydlyJ6or16GJ
         rf6hV8rMDQGWJ8s23Wae985pUpfJDxrCqYg9A46fuUp3T7QT6SbzVXccKuaW1/nsm1lb
         51VVc6IaTZfZuzSqHN5hNatdssL8go8zb9o6CQy8Mr8DKPVBD0vrtywjkfopPJ/NhfPC
         wB3PUX5K6aneomiMo4XMQdBMgHaOu1K6cJ2lRwbG1ec3o4gJDJ0sq/MQuNBtBHDPWcw7
         DQ5Q==
X-Gm-Message-State: AOAM532Rmljpmt0HDhW/w7zq2U7IgToteDypBCEpi9DsygNOKAWmvAM2
        JyQ8ocEmaxJ9jrYmSripOXSQyBy1aOIxDA==
X-Google-Smtp-Source: ABdhPJyGnyx8VFJmsUtjCYdaCcfwmo6W/kWastkQEQBD2SJ/a/yef0mx/nCvKnB1GjKgswWmdfRKZw==
X-Received: by 2002:a37:a156:: with SMTP id k83mr5862461qke.471.1611949971669;
        Fri, 29 Jan 2021 11:52:51 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id s136sm6558994qka.106.2021.01.29.11.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 11:52:51 -0800 (PST)
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
Subject: [PATCH net-next v1 5/6] TEST ONLY: lan743x: skb_alloc failure test
Date:   Fri, 29 Jan 2021 14:52:39 -0500
Message-Id: <20210129195240.31871-6-TheSven73@gmail.com>
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

Simulate low-memory in lan743x_rx_allocate_skb(): fail 10
allocations in a row in every 100.

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

 drivers/net/ethernet/microchip/lan743x_main.c | 21 +++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index ed4959ad9237..149b482fd984 100644
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
-	skb = __netdev_alloc_skb(netdev, length, GFP_ATOMIC | GFP_DMA);
+	skb = lan743x_alloc_skb(netdev, length, can_fail);
 	if (!skb)
 		return -ENOMEM;
 	dma_ptr = dma_map_single(dev, skb->data, length, DMA_FROM_DEVICE);
@@ -2130,7 +2143,7 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 	skb = buffer_info->skb;
 
 	/* allocate new skb and map to dma */
-	if (lan743x_rx_init_ring_element(rx, rx->last_head)) {
+	if (lan743x_rx_init_ring_element(rx, rx->last_head, true)) {
 		/* failed to allocate next skb.
 		 * Memory is very low.
 		 * Drop this packet and reuse buffer.
@@ -2330,7 +2343,7 @@ static int lan743x_rx_ring_init(struct lan743x_rx *rx)
 
 	rx->last_head = 0;
 	for (index = 0; index < rx->ring_size; index++) {
-		ret = lan743x_rx_init_ring_element(rx, index);
+		ret = lan743x_rx_init_ring_element(rx, index, false);
 		if (ret)
 			goto cleanup;
 	}
-- 
2.17.1

