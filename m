Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C45368C80
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 07:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240705AbhDWFWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 01:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240494AbhDWFV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 01:21:59 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B09BC06138F;
        Thu, 22 Apr 2021 22:21:23 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id m6-20020a17090a8586b02901507e1acf0fso622984pjn.3;
        Thu, 22 Apr 2021 22:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ETl9BH5g7aSjjPd9xSrYXQLCyVhrrpEc2i1Ck3dijOQ=;
        b=DWLaNz57Xo7Q8CmeyQcEYGngcqRDERgnjBO75qo/hNGHh82Ym0jvG+u4PkNZFf7l50
         kPJMVS9bRA/LP/Rk0qRYekytRQD7yvrTn/FLRak7+qGpNPFvyVDjxWhNpbW+K8RDxsyy
         MlFV2wy+7offo5XcQxatZDQu2or2gJtdO4RYWcdfdMAEFak+UEhPyg6tt1mBD4TdSEDs
         0mFId+SldNVJxIUc2G+WNwOc+SfG6Z+uP8c5fMc/I3iZwgvxi/DTeqsm89iVWvOJogLm
         WHnMd0J5sDETDzTKE7q9rn0swI6bFg6ZV/WmTz/3hl5zlYgDngWX0IN5nDAmV2Zmtj5m
         3uXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ETl9BH5g7aSjjPd9xSrYXQLCyVhrrpEc2i1Ck3dijOQ=;
        b=tr/f2I4OyYybpg3Uroz7kDqlYODcFdsv4e4ilzrFqs9Yq6CaEHnxBsE6EdGWRNSROF
         EfpRKa4V6OcLvaRchFkEfmh/jtuVYxsSQ8P0wsGGfnHNhWLFc49hkAkOwdn2hwSzFSf4
         azIx5zy6+JZxDULxStB3u2u1yBQZPL3vciqNuUjnIbK/7erxXBBYLl0C8yGqZ30wtoQ4
         liCHEEt/hgHlyNb+LhnLqZHJ2E7IhfQ3ySAhMGDazPMDeGbSKygZogpj8ZpkhuT3fFj4
         oc/I5LsCwntob7su2gmzg0XJOSCMZDi+7q7zVegv81aTErGbhRDd/4y9pn4bf25kYqO6
         /8FQ==
X-Gm-Message-State: AOAM532dZmbcTOW4ZL5otlj/70ZgMGWhsqWahNl81uOhx6bO39VDht/z
        yiPdgObZEVV2Pcy+YywobgI=
X-Google-Smtp-Source: ABdhPJwlNRwofxQXQT8gDYyYbpa4g9JgJwom0b/sTOP/MIaP7DBJiX8ulLbceCJ7cCxSFTKLULDmdA==
X-Received: by 2002:a17:90b:e8b:: with SMTP id fv11mr2499975pjb.66.1619155283170;
        Thu, 22 Apr 2021 22:21:23 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id y24sm6238825pjp.26.2021.04.22.22.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 22:21:22 -0700 (PDT)
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
Subject: [PATCH net-next v2 06/15] net: ethernet: mtk_eth_soc: remove unnecessary TX queue stops
Date:   Thu, 22 Apr 2021 22:20:59 -0700
Message-Id: <20210423052108.423853-7-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
References: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
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
index d992d4f1f400..e6f832dde9a6 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1131,17 +1131,6 @@ static void mtk_wake_queue(struct mtk_eth *eth)
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
@@ -1162,7 +1151,7 @@ static netdev_tx_t mtk_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	tx_num = mtk_cal_txd_req(skb);
 	if (unlikely(atomic_read(&ring->free_count) <= tx_num)) {
-		mtk_stop_queue(eth);
+		netif_stop_queue(dev);
 		netif_err(eth, tx_queued, dev,
 			  "Tx Ring full when queue awake!\n");
 		spin_unlock(&eth->page_lock);
@@ -1188,7 +1177,7 @@ static netdev_tx_t mtk_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto drop;
 
 	if (unlikely(atomic_read(&ring->free_count) <= ring->thresh))
-		mtk_stop_queue(eth);
+		netif_stop_queue(dev);
 
 	spin_unlock(&eth->page_lock);
 
-- 
2.31.1

