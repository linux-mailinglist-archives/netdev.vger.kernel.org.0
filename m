Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42BBE368C88
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 07:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240921AbhDWFWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 01:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240603AbhDWFWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 01:22:05 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559FBC06138B;
        Thu, 22 Apr 2021 22:21:28 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id em21-20020a17090b0155b029014e204a81e6so3890435pjb.1;
        Thu, 22 Apr 2021 22:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZjOoYVT7YenRNOA8qc+XyIjvt2WMHLDSuOV16uduX+U=;
        b=U3CLhQ7h0Dxhy+BHEyMa6zfMvJ1QXxRb+OUfRqHbNtc1NYbaDgTwPylzJd10DHemPK
         tgWtd/XNQy2NjW+hjsqDm0i1SQ2Xxp18zBvNSjOCJT+gVK1/N3e9xqszGy2w/QvEDCPV
         jbI7uyGCWysHHK1M6rVrHmh9QaOjHYrQhkRG28spyUgikNXbwXwGtTrm7G1DVa/1Tm3t
         v/LFb26rxLKf+u3Oe7aQcGUrtF5Wo6iJgxezNiAHiVPaIw52CGvzAsHrmqhbkZ1nj9Vg
         GP7J6xfG0yl8mPgav+RxuFbSCAXXbsgrPA7K/DvT1E0Y2DYpVEtj6oi2e3wPIIYUSfsi
         P8Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZjOoYVT7YenRNOA8qc+XyIjvt2WMHLDSuOV16uduX+U=;
        b=exCV7IOx3wkIy2k/27/noq1cWu8dYli9Lc4Z4gtqV2dqp/SiqaMg3jrW1gVuKALXLO
         ichk5+szs58IpWcM6/z9IHEhsN3QBVGJoq1wIcrBVhVamXUUOTk6KKhgu5dYHWREXIOg
         TYG3iQfp/rxTO0xqQksnCBvtVtu4D14k9qswGXw1azWo2oZQ4T5LIke/dORC249I0OZx
         qRrU23mwJPMSB/pk6xwrmitMDz9H8ggLxTlXjUmZ1g1LVKy/zN/PzouzBFFOr+AFAOie
         CnZchv2lt60QXIJI5OElt1q7FI1Wa8GopV9Hqo4Gtb18Gh48icQQk3lc3wCotr8r8a3X
         e6qw==
X-Gm-Message-State: AOAM532i2emGCLi6wzg/f4eRk/8wxy+ysKfAP645QdNqSUrfjYxRL64n
        zenPSV5AHXdTLK2AWzjlGqSp5DYIGtcOtLz7
X-Google-Smtp-Source: ABdhPJwpbeLxgmvWdgaaDoj1/CFLwGXveStOfAhuLSfGsDI2iAwOKlTiAC7TMO1Pm1GYVNkff3cfVw==
X-Received: by 2002:a17:902:4c:b029:ec:a39a:41ad with SMTP id 70-20020a170902004cb02900eca39a41admr2348006pla.52.1619155287923;
        Thu, 22 Apr 2021 22:21:27 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id y24sm6238825pjp.26.2021.04.22.22.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 22:21:27 -0700 (PDT)
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
Subject: [PATCH net-next v2 11/15] net: ethernet: mtk_eth_soc: only read the full RX descriptor if DMA is done
Date:   Thu, 22 Apr 2021 22:21:04 -0700
Message-Id: <20210423052108.423853-12-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
References: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Uncached memory access is expensive, and there is no need to access all
descriptor words if we can't process them anyway

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 6d23118b7a6c..4735942ed283 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -777,13 +777,18 @@ static inline int mtk_max_buf_size(int frag_size)
 	return buf_size;
 }
 
-static inline void mtk_rx_get_desc(struct mtk_rx_dma *rxd,
+static inline bool mtk_rx_get_desc(struct mtk_rx_dma *rxd,
 				   struct mtk_rx_dma *dma_rxd)
 {
-	rxd->rxd1 = READ_ONCE(dma_rxd->rxd1);
 	rxd->rxd2 = READ_ONCE(dma_rxd->rxd2);
+	if (!(rxd->rxd2 & RX_DMA_DONE))
+		return false;
+
+	rxd->rxd1 = READ_ONCE(dma_rxd->rxd1);
 	rxd->rxd3 = READ_ONCE(dma_rxd->rxd3);
 	rxd->rxd4 = READ_ONCE(dma_rxd->rxd4);
+
+	return true;
 }
 
 /* the qdma core needs scratch memory to be setup */
@@ -1255,8 +1260,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		rxd = &ring->dma[idx];
 		data = ring->data[idx];
 
-		mtk_rx_get_desc(&trxd, rxd);
-		if (!(trxd.rxd2 & RX_DMA_DONE))
+		if (!mtk_rx_get_desc(&trxd, rxd))
 			break;
 
 		/* find out which mac the packet come from. values start at 1 */
-- 
2.31.1

