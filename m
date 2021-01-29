Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97814308E13
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbhA2UHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:07:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbhA2Tyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 14:54:33 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09EAC061786;
        Fri, 29 Jan 2021 11:52:53 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id l27so9916293qki.9;
        Fri, 29 Jan 2021 11:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vyq09P2oaw4x3jWLZrbHOYVErJkNHGPbbt0QMfukTA8=;
        b=EWpHtNoDMUUeXcnysJV8JAIvqMx4R+wgEvPgCKBI8VToZ/Me6fxwUVz9OepKufoXDf
         YzkrknxHNvcl8lHQyeSsaLgJ1w5D+O74Vls3lhjLYwoMzGIQtuPhtCjKavyoB7hUe2Ix
         rW/MUgQx1aO/jfCE5+Uoco7PEk+d/wpATgefQK7a5qUpU08rbykwbAEHZW/4F4uFblD+
         AWDuqItYTezIRGGHgRuJE+5hJCblqrg/3Of3WUhb+TNEsLI1EQx77o3w/FBd536wArtY
         wdPkLZMGHZGHFHEvNnAdY52GU+/VaAU1Hku8dRej0K/JbHlgJuUVlaECpGy9cqffSj7E
         s7Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vyq09P2oaw4x3jWLZrbHOYVErJkNHGPbbt0QMfukTA8=;
        b=mTY5j/+U9Bs/oz1PqaVr3U7xAGPGm6BMcgnn0+yeHbfyxlqNTJvT35ZKGJtthNQ8rF
         WN5mf/WfPJDPY2uef9fNwffPiWsJYfIEkRQTlJUdlq6jtSA6Gk93Doj77qhClGX/OVNX
         VnW1uwc7bXkkcFYRgOozu74cLQGIqya24WG6FWEHR0QseLjbcURynBeIXn3gUk7KiisH
         WAysJONpNlqBlUzGXiT4sLNl6VXLTEgiM/0+R5TPYGzmXVKrgqODB72wSDS/M2RLhkbV
         jPN+WRwp+C0vEbChkh8sjvx1RnL1f+29mm7IhKJNkE+yB4kfnZKgzQ7denVS/6sOS+wp
         Qkrw==
X-Gm-Message-State: AOAM532jxa2X4gMhD5unHOPLm28yiMRO1zqVN+IfV+v+423SCQPb4d8x
        UGBnje5yCjX5pGbeY4Rm9Zk=
X-Google-Smtp-Source: ABdhPJwB6AJX7wUheibDZ4Eqpb8ln/ktwLaAwBbuBGORYTS4/5y1Qj2eLGUfr3NGOOr0TmwTRK1r0A==
X-Received: by 2002:a37:b07:: with SMTP id 7mr5904648qkl.164.1611949972942;
        Fri, 29 Jan 2021 11:52:52 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id s136sm6558994qka.106.2021.01.29.11.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 11:52:52 -0800 (PST)
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
Subject: [PATCH net-next v1 6/6] TEST ONLY: lan743x: skb_trim failure test
Date:   Fri, 29 Jan 2021 14:52:40 -0500
Message-Id: <20210129195240.31871-7-TheSven73@gmail.com>
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

Simulate low-memory in lan743x_rx_trim_skb(): fail one allocation
in every 100.

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

 drivers/net/ethernet/microchip/lan743x_main.c | 28 ++++++++-----------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 149b482fd984..dfae7745094b 100644
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
-	skb = lan743x_alloc_skb(netdev, length, can_fail);
+	skb = __netdev_alloc_skb(netdev, length, GFP_ATOMIC | GFP_DMA);
 	if (!skb)
 		return -ENOMEM;
 	dma_ptr = dma_map_single(dev, skb->data, length, DMA_FROM_DEVICE);
@@ -2058,6 +2045,13 @@ static void lan743x_rx_release_ring_element(struct lan743x_rx *rx, int index)
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
@@ -2143,7 +2137,7 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 	skb = buffer_info->skb;
 
 	/* allocate new skb and map to dma */
-	if (lan743x_rx_init_ring_element(rx, rx->last_head, true)) {
+	if (lan743x_rx_init_ring_element(rx, rx->last_head)) {
 		/* failed to allocate next skb.
 		 * Memory is very low.
 		 * Drop this packet and reuse buffer.
@@ -2343,7 +2337,7 @@ static int lan743x_rx_ring_init(struct lan743x_rx *rx)
 
 	rx->last_head = 0;
 	for (index = 0; index < rx->ring_size; index++) {
-		ret = lan743x_rx_init_ring_element(rx, index, false);
+		ret = lan743x_rx_init_ring_element(rx, index);
 		if (ret)
 			goto cleanup;
 	}
-- 
2.17.1

