Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF2138DBB7
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 17:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbhEWPz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 11:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbhEWPzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 11:55:46 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65AACC061574;
        Sun, 23 May 2021 08:54:19 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id n6-20020a17090ac686b029015d2f7aeea8so9864533pjt.1;
        Sun, 23 May 2021 08:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NPLKamZ9/ZYlfg2IVe2bQUIYpT9APx67IKzrgt/lV2A=;
        b=liATBOiCjESotZSb4t4K4t9nOKJOmJFueVrKjGOxVnIXGjIy+PcuGJXy8SC5zuAYqh
         GgjNrz9HuzfSJTA4jlm7qcyPbVxvsNzubnnIvneuEYxAGKsvvvbHc98015hAXcOmUXqO
         khWk7KxRmjVsAx+DJkPqzcn6RsOTH647/wFQ9xi3uePtD2IIlG3a1OQNOrhQFFo5TeMh
         wDpT7p4lNbTh++7gfdA2MS46TxpDL4FWYKdFLAfMLWKWsJbekQ/VvfbWkPxn31rTc8ai
         zEJERsB2Phqug7acSHSVgcIDirh6VpySn8V1qKRV2uzboKDFidZyY/geIMxeFjiTQugP
         CU5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NPLKamZ9/ZYlfg2IVe2bQUIYpT9APx67IKzrgt/lV2A=;
        b=AqoA0K2bxoOh0vdAtD5/oKGKxzFkucTRWwD1SOcl0FlM88AO36z+Tw7nYddu5z7dDg
         yOVW0h3o3edNqshHQxwlAGOsh5yIsAqUad30NjrY8tXs5JprYFu9OX/toxHcVAg7lZCU
         F3MhPuMzm6DU8T+XJ9Nc2DkW02Ik6osSFl+aB55ZXyE+TdSbMWy0gk7MK8H3+sie5k/0
         is+0sLSfvrXUVMACahENbLPkpwhquH84lzKZjn1IcNNMp58ZKf36sXUI4hVwQiIxYj4Z
         kvk/O0Y6uXREEh0RzaL/o1FsZRlEiwnRl++VREoF2PjrHcBD9MI9x9I6StuhBvYlS4Vr
         GedA==
X-Gm-Message-State: AOAM530fZNTQXR2/C/pilUzb/EtV086uppw73v+ZWgA0aq7zqvtYhTc5
        M9y2I9TSBGljg6pNgA+D0YHN15bL1RK4KQ==
X-Google-Smtp-Source: ABdhPJyoSn20xeqh6TG4kDQomaSBX8JWRXARTrNd7jYWQBUrkDx2+OK+DAN9wHzxKJICaxJOuBkOng==
X-Received: by 2002:a17:90a:7a89:: with SMTP id q9mr20447684pjf.0.1621785258616;
        Sun, 23 May 2021 08:54:18 -0700 (PDT)
Received: from localhost.localdomain (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id t133sm10022765pgb.0.2021.05.23.08.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 08:54:18 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 2/2] net: r6040: Use ETH_FCS_LEN
Date:   Sun, 23 May 2021 08:54:11 -0700
Message-Id: <20210523155411.11185-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523155411.11185-1-f.fainelli@gmail.com>
References: <20210523155411.11185-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of the open coded constant 4.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/rdc/r6040.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6040.c
index aff68e2cb700..ef78c2424668 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -544,7 +544,7 @@ static int r6040_rx(struct net_device *dev, int limit)
 		skb_ptr->dev = priv->dev;
 
 		/* Do not count the CRC */
-		skb_put(skb_ptr, descptr->len - 4);
+		skb_put(skb_ptr, descptr->len - ETH_FCS_LEN);
 		dma_unmap_single(&priv->pdev->dev, le32_to_cpu(descptr->buf),
 				 MAX_BUF_SIZE, DMA_FROM_DEVICE);
 		skb_ptr->protocol = eth_type_trans(skb_ptr, priv->dev);
@@ -552,7 +552,7 @@ static int r6040_rx(struct net_device *dev, int limit)
 		/* Send to upper layer */
 		netif_receive_skb(skb_ptr);
 		dev->stats.rx_packets++;
-		dev->stats.rx_bytes += descptr->len - 4;
+		dev->stats.rx_bytes += descptr->len - ETH_FCS_LEN;
 
 		/* put new skb into descriptor */
 		descptr->skb_ptr = new_skb;
-- 
2.25.1

