Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD49318FD5
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 17:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhBKQX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 11:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhBKQUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 11:20:45 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993C4C0617A9;
        Thu, 11 Feb 2021 08:18:41 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id e24so6261415ioc.1;
        Thu, 11 Feb 2021 08:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K5uPwCPOWjfw9QcfeAo+s6B96+MXudquzTFEC9qlVfA=;
        b=mxh8Gano4tVdhpguaNZWelHqNOmkAq8FmGzX0wxTgCYjQmg/f8HCtqz8yBSrMgb/h2
         rzuKKdf6SdJrCKykcLmFFGGb8hf3OimOdSSTm2XGvTJ5MLN0Oiicr3mAU1rN65CVBy2R
         NTie4EPk5PIx/dqJ0IiWr1J+F95Nj0Fs4e1Uref68ETIamy7C+nyNh/pCT4Dq3RfchV6
         HZmToU16BKUcX8zOby3Rs3lpv7ns5+UZLJ2h/bsjqn27KJoZWiB/DDLF05sDCnklxZ5a
         K6s9xpYNNoPMBo/FhnpVTPO6Ea4jvys/UQdE8dCBmQsmNrogL38O8Ee2vAq27mW/vOkK
         7qrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K5uPwCPOWjfw9QcfeAo+s6B96+MXudquzTFEC9qlVfA=;
        b=ENVQNdHFNZk0h5kOoQm/bgDQTlmaDI0nNKy/HXwfi2tVI3NMKskK0eZFd4YvK7lG1q
         54deMRTrZu0wdpytpBHEtuhyK0cEv3HCyq+WuOieunMjYL5MTO8lzMlgmXUuFa4y7uiU
         0Iw6O4EvbUts12mkm43SIYJOw0NWLZakdZeVnaCn9DrvOqY0uJMrXbDcfkWZ22m1RMlI
         v9hAl2RmiXrhURPztJ3/wKoG1AkjTpjPlWqn4On0Y0XWM9SPhvvPnH7LM7JFuAQV4GhS
         qLYJGChYGYZjUF5M+4zqr0loqwsRCbHWyPBTOX31gkjj50nIdIYPnhjsgDk1gQEtb60d
         MfsQ==
X-Gm-Message-State: AOAM532AIiQKzy3KQHcQtukYUjUsNiTQvZz9glXHw1ZzVwzjOpkMTXYa
        Ph4oNjKLcoEROtPqcItpjfk=
X-Google-Smtp-Source: ABdhPJzEMaoG8P6yCpQTf3XOCHDJoKcWoMkTVAg+gIl6vGFzU09Gilm1YOBR3bIUAcgyz72dCl5Pig==
X-Received: by 2002:a6b:7e41:: with SMTP id k1mr6052264ioq.81.1613060320923;
        Thu, 11 Feb 2021 08:18:40 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id d135sm2729913iog.35.2021.02.11.08.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 08:18:40 -0800 (PST)
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
Subject: [PATCH net-next v2 5/5] TEST ONLY: lan743x: skb_trim failure test
Date:   Thu, 11 Feb 2021 11:18:30 -0500
Message-Id: <20210211161830.17366-6-TheSven73@gmail.com>
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
index 0094ecac5741..53c2b93b82b4 100644
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
@@ -2075,6 +2062,13 @@ static void lan743x_rx_release_ring_element(struct lan743x_rx *rx, int index)
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
@@ -2150,7 +2144,7 @@ static int lan743x_rx_process_buffer(struct lan743x_rx *rx)
 
 	/* save existing skb, allocate new skb and map to dma */
 	skb = buffer_info->skb;
-	if (lan743x_rx_init_ring_element(rx, rx->last_head, true)) {
+	if (lan743x_rx_init_ring_element(rx, rx->last_head)) {
 		/* failed to allocate next skb.
 		 * Memory is very low.
 		 * Drop this packet and reuse buffer.
@@ -2355,7 +2349,7 @@ static int lan743x_rx_ring_init(struct lan743x_rx *rx)
 
 	rx->last_head = 0;
 	for (index = 0; index < rx->ring_size; index++) {
-		ret = lan743x_rx_init_ring_element(rx, index, false);
+		ret = lan743x_rx_init_ring_element(rx, index);
 		if (ret)
 			goto cleanup;
 	}
-- 
2.17.1

