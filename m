Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2FEF222F4E
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgGPXow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgGPXow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 19:44:52 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4C4C061755;
        Thu, 16 Jul 2020 16:44:51 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s189so5720555pgc.13;
        Thu, 16 Jul 2020 16:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b87Qqp4/uiRihe98ddeAhee2zlCsyVOmpKiv8uZHXek=;
        b=hEkIv4UtH9Uo1HCpChBQ5wcUVhRASkkdGBO/z/koaN0BOKodrPbX3MXorkr/vL/q6p
         +dZ7YkdDJlapVuRDihjd6xZEnbrw22uEBfyzJqOqcclcS1ILf1ANkVEGE7dnkJEOo7d7
         pDdObdv6t957O8QV+6an28TumGcwxfYRFz07pjtxMkOkrf9v2KLDniNHRYs+reGLOlEw
         DRMFqcx/5dI0bUfTAh6r3Jh7fRhIBZb5XKzqE0iS2lnlx7bD5iW/TSXRVh/VplMXBqro
         uLn9UE+DCDLJBv6zGe3D+m9GE0MzPVOtamE8tAQAUgwhVjTTQNzLUzEk1/mzQxHaoOWv
         e3zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b87Qqp4/uiRihe98ddeAhee2zlCsyVOmpKiv8uZHXek=;
        b=cnYOE2g3XLq7TfxDbFhWZpX5YJKkj5+Mfj0xPFFKPZ+Y8D1yZfme2fi8nKH4V/tNzT
         cq/ZHSK4PvnhzMjHvyZK9O3+mpbjluyfJyE7TqFM4YaVY58ydYNsfj8715+KZZwVOclw
         EgSZVI2gU8HBNecCHPUKwlpz/jlFCFvBo6aOCtHItHB2sDNVLpzYqFJN4PxQB/oUr6z0
         D+4i7l8/KtvfgIvXP+NCwrb9PLQWAonptGBMt848Iw0rsBmPxCGQQffYcG5bzvSf8HZS
         KmSSSoUT3OCFm2X0I/6eewJxf3Z9ZfgWSXzn01Yy3gB1VqOncGKvWsEKhiJ/Tne4nz/n
         nCcA==
X-Gm-Message-State: AOAM5338dmQHm7sw2ULTS009yAamBuY6mPdKP5O4sQgDNGxS++HmeBfa
        UJt0W+XUlRkNrzL0qrdQtMg=
X-Google-Smtp-Source: ABdhPJzBpCDAi9m56FIS0fdW6XyWSbp5t1i5QtOoyG2uqLnRMj/6r2yyF4b1tubGXKCr5scrR6cD1w==
X-Received: by 2002:a63:210c:: with SMTP id h12mr6244042pgh.152.1594943091216;
        Thu, 16 Jul 2020 16:44:51 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8880:9ae0:70a0:cae8:8c09:d74a])
        by smtp.gmail.com with ESMTPSA id f6sm5903309pfe.174.2020.07.16.16.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 16:44:50 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Martin Schiller <ms@dev.tdt.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH v2] drivers/net/wan/x25_asy: Fix to make it work
Date:   Thu, 16 Jul 2020 16:44:33 -0700
Message-Id: <20200716234433.6490-1-xie.he.0141@gmail.com>
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

Cc: Eric Dumazet <edumazet@google.com>
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---

Change from v1:
Added skb_cow before skb_push to ensure skb_push will succeed
according the suggestion of Eric Dumazet.

Hi Eric Dumazet and Martin Schiller,
Can you review this patch again and see if it is OK for me to include
your names in a "Signed-off-by", "Reviewed-by" or "Acked-by" tag?
Thank you!

Hi All,
I'm happy to answer any questions you might have and make improvements
according to your suggestions. Thanks!

---
 drivers/net/wan/x25_asy.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
index 69773d228ec1..84640a0c13f3 100644
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
@@ -356,12 +354,21 @@ static netdev_tx_t x25_asy_xmit(struct sk_buff *skb,
  */
 
 /*
- *	Called when I frame data arrives. We did the work above - throw it
- *	at the net layer.
+ *	Called when I frame data arrive. We add a pseudo header for upper
+ *	layers and pass it to upper layers.
  */
 
 static int x25_asy_data_indication(struct net_device *dev, struct sk_buff *skb)
 {
+	if (skb_cow(skb, 1)) {
+		kfree_skb(skb);
+		return NET_RX_DROP;
+	}
+	skb_push(skb, 1);
+	skb->data[0] = X25_IFACE_DATA;
+
+	skb->protocol = x25_type_trans(skb, dev);
+
 	return netif_rx(skb);
 }
 
@@ -657,7 +664,7 @@ static void x25_asy_unesc(struct x25_asy *sl, unsigned char s)
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

