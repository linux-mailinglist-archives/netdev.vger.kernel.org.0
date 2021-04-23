Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96125368C77
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 07:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240465AbhDWFV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 01:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240403AbhDWFVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 01:21:55 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B49FC06174A;
        Thu, 22 Apr 2021 22:21:19 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id y22-20020a17090a8b16b0290150ae1a6d2bso645966pjn.0;
        Thu, 22 Apr 2021 22:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IhMuV7pk/e6sV7VUIyv8mgUtfEot/XwuLzvlzQOD9tE=;
        b=lmLheeEPGFQgitLGJY+wsWubJP+ggaguhY3vmRN+E82W0DBWsuLaZKiNy3fmbngytR
         Pp3iI++8Zg3h+6LP2O7TM9U1qa+026qhc6tLnH/B76oY9dZ02r9FCb2Zdi0VkY/mINPV
         XiFhil4oCVGQtkdjqIz79VZbID0LOje6s0D9WYcyR9Ht4ZbEVZV4O3RIqqiksMenfRRJ
         Q45783Y63qzCXFiC9RwC0E3mZOUAl9ivHiYjzA71FySr0PGEnJzkTLaWbDsR8VReLrcy
         wQjwpYjSr3/N0cfiOuDlQfvt/CsgreHvG4Uaii1WWbKNVVIV34jKa7BJVuztyA23YTAy
         MYjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IhMuV7pk/e6sV7VUIyv8mgUtfEot/XwuLzvlzQOD9tE=;
        b=lq3kXnPBJEvDzaK7KoR4+eOgHg8zKOm7O0QR1W8Lhg55QTYXb2EolqtWlhyvuCUHo1
         O2hk8LWbJg3YF2UmrrKykBqRcBvcFYvzXdjpLs2jNEgG4SzG2a/RyOaL6B5vIEPO5lhS
         0XO8Xz940PPG9t2JB8tQukQCfuDuDXBejOJJ5He8yju1nZgc+tuhicw+7geKMc4sO9K+
         PqANgGyuW50ryBBG4qj1sPvDgGWjWNiyKID5puFjz4UXespeV5+P3Lh2OYVThLLK7Cgg
         N4L0lBdYSn0DZRNba7GkHUJH8ld8PlxI5+10UYldRMIWwB3I4fZh25MUk6x3vx6grQYI
         EFng==
X-Gm-Message-State: AOAM5314AJFg+hqkWmseobs5D7V0Y5NmheK4jYnD7qX0WkKcEsUewRjC
        iwWMWlVzumT5eV/ki6wqNBAi972e98Isv02M
X-Google-Smtp-Source: ABdhPJxlQhY9hZBU8DSNJ2pRRuIJvNc1Qgl1KnYHabKy5rGCRe0QNGaaH6fat8apwejStrcwnpD5Iw==
X-Received: by 2002:a17:90a:1190:: with SMTP id e16mr2497504pja.110.1619155278782;
        Thu, 22 Apr 2021 22:21:18 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id y24sm6238825pjp.26.2021.04.22.22.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 22:21:18 -0700 (PDT)
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
Subject: [PATCH net-next v2 02/15] net: ethernet: mtk_eth_soc: unmap RX data before calling build_skb
Date:   Thu, 22 Apr 2021 22:20:55 -0700
Message-Id: <20210423052108.423853-3-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
References: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Since build_skb accesses the data area (for initializing shinfo), dma unmap
needs to happen before that call

Signed-off-by: Felix Fietkau <nbd@nbd.name>
[Ilya: split build_skb cleanup fix into a separate commit]
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index b2175ec451ab..540003f3fcb8 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1298,6 +1298,9 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			goto release_desc;
 		}
 
+		dma_unmap_single(eth->dev, trxd.rxd1,
+				 ring->buf_size, DMA_FROM_DEVICE);
+
 		/* receive data */
 		skb = build_skb(data, ring->frag_size);
 		if (unlikely(!skb)) {
@@ -1307,8 +1310,6 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		}
 		skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
 
-		dma_unmap_single(eth->dev, trxd.rxd1,
-				 ring->buf_size, DMA_FROM_DEVICE);
 		pktlen = RX_DMA_GET_PLEN0(trxd.rxd2);
 		skb->dev = netdev;
 		skb_put(skb, pktlen);
-- 
2.31.1

