Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BC6217E6F
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 06:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgGHEiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 00:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgGHEiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 00:38:05 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5F7C061755;
        Tue,  7 Jul 2020 21:38:04 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m9so9148305pfh.0;
        Tue, 07 Jul 2020 21:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pGbaCoMke0eHVeVRLkTlHstsJU5HzwWe4OVKEnmf1ZQ=;
        b=sbxCs0Xh2GFQxQ+jOOqUDA4ATECZXZ2LYdmSyQjvs7devdjXaMII5lDZiIUTSCJY0X
         U7UCVgT7t1OcdgWbf9oY1ilqODpu70WpY1ItakeeQmoerMUy/LMhjq5iJWq5rSbtdejy
         xbvIMeKzFf6x7fmtlSHMpjB7hXA3OvGR1LN1mHVnowtPTVUmRyrn9ozfCjk+sbS4E+Dt
         st1okfrv4p7vrDbRRB7EgbaQRl86CQoSa0BlRByLqKjrz4kYwlSSvXj0OBuZcJOMocpW
         mAVyxhpQ1C/JAouRcBrBWG4pOqMhKdWUZO2moH/xqvObFvLjpRo+QkTlUZiH60M+V64Q
         LhJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pGbaCoMke0eHVeVRLkTlHstsJU5HzwWe4OVKEnmf1ZQ=;
        b=UOeqvUaYOChqQxfyTtAbewQT/Wka2Z4c4HniEkChI1ca8hfQhlzv0fcQkSODZLXeNM
         bL1pK+fcaY4JFJtsjS1iauZrfj6yL+EM40araeyRtlrg1PkEHyFSCarY9Mgpo8eImvAP
         L/N8IoOI9Z/3MqRnTpgsIu9qwarJzxaL8P4H+dhWjNchtzpTNRUoZyUkuKBi/PXwdPKj
         XMulAlf0lxNpu4E4Zci8UWlNxW+LVAvtPGA9TNb1h7+gi3gksKGr7RPGcJF4XQYniI+k
         0eZk1vnAwcE/Y5eUBvu/keLvMX6ryAdLMr1nJX9bnzL50d2sBrbTaxVhDYDsXF0Ok4JW
         YYrQ==
X-Gm-Message-State: AOAM533OUdw2RYvpeIXRTKA/RKUJDOIQQ3aBfK9J9BAv9P7AhnnXVwLC
        0+EUCmMpIygqw4ck/KplQD0=
X-Google-Smtp-Source: ABdhPJyueUvBUwFB5CkcsW7TctjCVGF9ROFxbj4AKt5/+V3u8yHu6Y7DuT1FOCV6MrMPQqKXKnknFg==
X-Received: by 2002:aa7:9736:: with SMTP id k22mr50226247pfg.62.1594183083354;
        Tue, 07 Jul 2020 21:38:03 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8880:9ae0:4dfb:86a6:10aa:1756])
        by smtp.gmail.com with ESMTPSA id f6sm26191724pfe.174.2020.07.07.21.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 21:38:02 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Martin Habets <mhabets@solarflare.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Xie He <xie.he.0141@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org
Subject: [PATCH] drivers/net/wan/x25_asy: Fix to make it work
Date:   Tue,  7 Jul 2020 21:37:54 -0700
Message-Id: <20200708043754.46554-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver is not working because of problems of its receiving code.
This patch fixes it to make it work.

When the driver receives an LAPB frame, it should first pass the frame
to the LAPB module to process. After processing, the LAPB module passes
the data (the packet) back to the driver, the driver should then add a
one-byte pseudo header and pass the data to upper layers.

The changes to the "x25_asy_bump" function and the
"x25_asy_data_indication" function are to correctly implement this
procedure.

Also, the "x25_asy_unesc" function ignores any frame that is shorter
than 3 bytes. However the shortest frames are 2-byte long. So we need
to change it to allow 2-byte frames to pass.

Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/x25_asy.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
index 69773d228ec1..3fd8938e591b 100644
--- a/drivers/net/wan/x25_asy.c
+++ b/drivers/net/wan/x25_asy.c
@@ -183,7 +183,7 @@ static inline void x25_asy_unlock(struct x25_asy *sl)
 	netif_wake_queue(sl->dev);
 }
 
-/* Send one completely decapsulated IP datagram to the IP layer. */
+/* Send an LAPB frame to the LAPB module to process. */
 
 static void x25_asy_bump(struct x25_asy *sl)
 {
@@ -195,13 +195,12 @@ static void x25_asy_bump(struct x25_asy *sl)
 	count = sl->rcount;
 	dev->stats.rx_bytes += count;
 
-	skb = dev_alloc_skb(count+1);
+	skb = dev_alloc_skb(count);
 	if (skb == NULL) {
 		netdev_warn(sl->dev, "memory squeeze, dropping packet\n");
 		dev->stats.rx_dropped++;
 		return;
 	}
-	skb_push(skb, 1);	/* LAPB internal control */
 	skb_put_data(skb, sl->rbuff, count);
 	skb->protocol = x25_type_trans(skb, sl->dev);
 	err = lapb_data_received(skb->dev, skb);
@@ -209,7 +208,6 @@ static void x25_asy_bump(struct x25_asy *sl)
 		kfree_skb(skb);
 		printk(KERN_DEBUG "x25_asy: data received err - %d\n", err);
 	} else {
-		netif_rx(skb);
 		dev->stats.rx_packets++;
 	}
 }
@@ -356,12 +354,16 @@ static netdev_tx_t x25_asy_xmit(struct sk_buff *skb,
  */
 
 /*
- *	Called when I frame data arrives. We did the work above - throw it
- *	at the net layer.
+ *	Called when I frame data arrives. We add a pseudo header for upper
+ *	layers and pass it to upper layers.
  */
 
 static int x25_asy_data_indication(struct net_device *dev, struct sk_buff *skb)
 {
+	skb_push(skb, 1);
+	skb->data[0] = X25_IFACE_DATA;
+	skb->protocol = x25_type_trans(skb, dev);
+
 	return netif_rx(skb);
 }
 
@@ -657,7 +659,7 @@ static void x25_asy_unesc(struct x25_asy *sl, unsigned char s)
 	switch (s) {
 	case X25_END:
 		if (!test_and_clear_bit(SLF_ERROR, &sl->flags) &&
-		    sl->rcount > 2)
+		    sl->rcount >= 2)
 			x25_asy_bump(sl);
 		clear_bit(SLF_ESCAPE, &sl->flags);
 		sl->rcount = 0;
-- 
2.25.1

