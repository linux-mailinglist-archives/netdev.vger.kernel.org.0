Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83BD2D3858
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 02:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgLIBk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 20:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgLIBk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 20:40:56 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2714C0613CF;
        Tue,  8 Dec 2020 17:40:16 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id q3so180317pgr.3;
        Tue, 08 Dec 2020 17:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LXmuShLe8MmRBicIw3DWKa+ptVtXWGYLDOodgjPJwzE=;
        b=tV2+OgBDZIQ5kf4Ksxt47bhj2n7BdftPuND9hM5dqdrItCusKags+oVSyuROLWnUHk
         fPdHnvbMFiyHW8vQWQKQRgztMpOhnjVqHxRXS2GrOKmnDdgUzoRaBExHmCtq0avJpqLN
         JtVMY74l1AlYuIDaQgah0x0oAcs6H6vHQ3lOW4Zn0SFbYw1oOcw1LgDiUIrHngwbgxJQ
         UT2czX53cvQSr47meqrXYkfwKznzY/Phmz+2a63XZ5gBT7L8HFbxAiTpo6a3ofObwd1H
         M8PXsmxwcHuqi6fbpXvgBweA44QrrwfEYTW4aKyiHfVtFdp4qbycOVutNZkjJJk8LjPQ
         0Xlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LXmuShLe8MmRBicIw3DWKa+ptVtXWGYLDOodgjPJwzE=;
        b=EdOz6ZltCh3xYSy4mK+IX6Mm60Y2l78VfTVi3BqSl9sR7dDKLWP6ZTVExLLOWrbmXY
         Xeqcnvmzz2nxvnTnpucMLRWbyX056EmG+1p1RhVav7j/+iw4P0wFL/1z1qRWq1co15Jk
         2znbkFVYn2VO1vPe0T2UgT43lSDegavUUz7yNNlaTjYLLranObbkgm7iYfJcXU8kOc6J
         6jUiDiTeAujc5UziJgItYv+K1shkRSmEclwTS0cZ6PrI7u75EAL9c8tDDhTrSOxmO7Va
         3hWvaBYev7VP0mcVNirI8hXf4oEnZUnMX2MRkwi0Vo9OD9W2Y2CLEJLQvJ3Kr5rTgR29
         Rh0w==
X-Gm-Message-State: AOAM531A0pkqeMYHQo9GllBU72C1F6Ar6P/vs0eYUNKfTtoT1nkCEjRi
        iSbQUoL/VX813g6JpCyYqVIR6kM+u5Q=
X-Google-Smtp-Source: ABdhPJxzVwUTry2fRh4T5JBJG22lRSb2HKBj6kx9fcyoKtIjiQ1h6RAwJkz4Bx72ZV2e+VLXQWbaLA==
X-Received: by 2002:a17:90a:f408:: with SMTP id ch8mr12782pjb.222.1607478016361;
        Tue, 08 Dec 2020 17:40:16 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:ac46:48a7:8096:18f5])
        by smtp.gmail.com with ESMTPSA id z65sm74699pfz.126.2020.12.08.17.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 17:40:15 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v2] net: hdlc_x25: Remove unnecessary skb_reset_network_header calls
Date:   Tue,  8 Dec 2020 17:40:13 -0800
Message-Id: <20201209014013.4996-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. In x25_xmit, skb_reset_network_header is not necessary before we call
lapb_data_request. The lapb module doesn't need skb->network_header.
So there is no need to set skb->network_header before calling
lapb_data_request.

2. In x25_data_indication (called by the lapb module after some data
have been received), skb_reset_network_header is not necessary before we
call netif_rx. After we call netif_rx, the code in net/core/dev.c will
call skb_reset_network_header before handing the skb to upper layers
(in __netif_receive_skb_core, called by __netif_receive_skb_one_core,
called by __netif_receive_skb, called by process_backlog). So we don't
need to call skb_reset_network_header by ourselves.

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_x25.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index f52b9fed0593..bb164805804e 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -77,7 +77,6 @@ static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
 	}
 
 	skb_push(skb, 1);
-	skb_reset_network_header(skb);
 
 	ptr  = skb->data;
 	*ptr = X25_IFACE_DATA;
@@ -118,7 +117,6 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 	switch (skb->data[0]) {
 	case X25_IFACE_DATA:	/* Data to be transmitted */
 		skb_pull(skb, 1);
-		skb_reset_network_header(skb);
 		if ((result = lapb_data_request(dev, skb)) != LAPB_OK)
 			dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
-- 
2.27.0

