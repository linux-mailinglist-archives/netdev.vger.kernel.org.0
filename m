Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C425236784E
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 06:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbhDVEK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 00:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbhDVEKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 00:10:18 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38D9C06138C;
        Wed, 21 Apr 2021 21:09:42 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id lr7so4455537pjb.2;
        Wed, 21 Apr 2021 21:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mpHFvhVstRat21oM0gV+xZuTGkFLULz7ukrF5iEyIK0=;
        b=PnrB1ws8mNHmD5BVxLJuU6qLG9r7t5ta+3Ni6Wf3OeJnmyznhMtLE3gvDqHKIyHkVz
         KdG5FCaNorsqk+1Lk26cuTsNMI2MEhAdWhk07+ul4DTUwNQIjuPXiNJ5lmqRz3wiRZ6P
         SJziggGOJFWqmfJNEqZA0C57yQo5uqc7ZfWoIQ0yufqd9CRGlCH7kAVioi9Nc3PIscMF
         LLqL8egeN2TpZymJgpf99bfY/UytmdTb0Zi8ai/AJEprzxMyxcvEC/ny3HqJQzO0PBIY
         ZfU9gTgUcfaamT1VNm4MbmmgoviZP4BSiYh4WS2J6YQyD9YuIhdV2ps0Kl5Scnb75Gin
         92bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mpHFvhVstRat21oM0gV+xZuTGkFLULz7ukrF5iEyIK0=;
        b=b44MNQiZvGua9/0RWdqrOOkzmUNKysE6l5E4NyI3PpS+jOsB1ZmsyQ1KIswGQzO6w0
         nlCuSw5w/dsKd33TaHwaj4MY6a2b8Zm0m02nos3Wdq815sy3W0EaHJ+adnwqY5AJx9W2
         YQYm6z/Fy3BtCqtQiAUI/oWNQBp6TkjOOz1jIZ8KhnjI7+QGooYu2vJ7SqH6kAX7bPfd
         kQanWUUMla1IUlbuiNeYqOzfUcbnW0OjlKnR7eiW6eMbrcXZ8fcr3V5Duqo5EhQKeTxj
         ia0aB+QShEypFj7wpRdPzTwDv+aIVupub7RX5oKYe6sm6Jl1x6iDzgDXzWoXqBHFCLDh
         BmFw==
X-Gm-Message-State: AOAM531aPFxCiii3fRnJlaDoyENLr7gV00I5QEmzPSDkvoCxfFxHZ+FR
        D8jTVn5Y6jzJAoY5KOPQpAo=
X-Google-Smtp-Source: ABdhPJzk8BBXtqx6sgT1iSsBur7XCwAiWjZh+FiVyRUmlXzRCA+5kxsrggTByS1Hev/9WK83MS/HCQ==
X-Received: by 2002:a17:902:b18f:b029:ec:7ac0:fd1a with SMTP id s15-20020a170902b18fb02900ec7ac0fd1amr1414045plr.84.1619064582317;
        Wed, 21 Apr 2021 21:09:42 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id i17sm635354pfd.84.2021.04.21.21.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 21:09:42 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next 06/14] net: ethernet: mtk_eth_soc: remove unnecessary TX queue stops
Date:   Wed, 21 Apr 2021 21:09:06 -0700
Message-Id: <20210422040914.47788-7-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

When running short on descriptors, only stop the queue for the netdev that
tx was attempted for. By the time something tries to send on the other
netdev, the ring might have some more room already.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index a3958e99a29f..223131645a37 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1129,17 +1129,6 @@ static void mtk_wake_queue(struct mtk_eth *eth)
 	}
 }
 
-static void mtk_stop_queue(struct mtk_eth *eth)
-{
-	int i;
-
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
-		if (!eth->netdev[i])
-			continue;
-		netif_stop_queue(eth->netdev[i]);
-	}
-}
-
 static netdev_tx_t mtk_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
@@ -1160,7 +1149,7 @@ static netdev_tx_t mtk_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	tx_num = mtk_cal_txd_req(skb);
 	if (unlikely(atomic_read(&ring->free_count) <= tx_num)) {
-		mtk_stop_queue(eth);
+		netif_stop_queue(dev);
 		netif_err(eth, tx_queued, dev,
 			  "Tx Ring full when queue awake!\n");
 		spin_unlock(&eth->page_lock);
@@ -1186,7 +1175,7 @@ static netdev_tx_t mtk_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto drop;
 
 	if (unlikely(atomic_read(&ring->free_count) <= ring->thresh))
-		mtk_stop_queue(eth);
+		netif_stop_queue(dev);
 
 	spin_unlock(&eth->page_lock);
 
-- 
2.31.1

