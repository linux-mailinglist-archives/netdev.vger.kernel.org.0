Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1DC8D1FB
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 13:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfHNLSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 07:18:45 -0400
Received: from mx2.mailbox.org ([80.241.60.215]:23436 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727266AbfHNLSm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 07:18:42 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id 4BF60A1605;
        Wed, 14 Aug 2019 13:18:41 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id NTjTAxwrEIS3; Wed, 14 Aug 2019 13:18:27 +0200 (CEST)
From:   Stefan Roese <sr@denx.de>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>
Subject: [PATCH net-next 3/4 v2] net: ethernet: mediatek: Rename NEXT_RX_DESP_IDX to NEXT_DESP_IDX
Date:   Wed, 14 Aug 2019 13:18:24 +0200
Message-Id: <20190814111825.10855-3-sr@denx.de>
In-Reply-To: <20190814111825.10855-1-sr@denx.de>
References: <20190814111825.10855-1-sr@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the NEXT_RX_DESP_IDX macro to NEXT_DESP_IDX, so that it better
can be used for TX ops as well. This will be used in the upcoming
MT7628/88 support (same functionality for RX and TX in this macro).

Signed-off-by: Stefan Roese <sr@denx.de>
Cc: René van Dorst <opensource@vdorst.com>
Cc: Daniel Golle <daniel@makrotopia.org>
Cc: Sean Wang <sean.wang@mediatek.com>
Cc: John Crispin <john@phrozen.org>
---
v2:
- New patch

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++--
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index bee2cdca66e7..d9978174b96a 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -903,7 +903,7 @@ static struct mtk_rx_ring *mtk_get_rx_ring(struct mtk_eth *eth)
 
 	for (i = 0; i < MTK_MAX_RX_RING_NUM; i++) {
 		ring = &eth->rx_ring[i];
-		idx = NEXT_RX_DESP_IDX(ring->calc_idx, ring->dma_size);
+		idx = NEXT_DESP_IDX(ring->calc_idx, ring->dma_size);
 		if (ring->dma[idx].rxd2 & RX_DMA_DONE) {
 			ring->calc_idx_update = true;
 			return ring;
@@ -952,7 +952,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		if (unlikely(!ring))
 			goto rx_done;
 
-		idx = NEXT_RX_DESP_IDX(ring->calc_idx, ring->dma_size);
+		idx = NEXT_DESP_IDX(ring->calc_idx, ring->dma_size);
 		rxd = &ring->dma[idx];
 		data = ring->data[idx];
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 088e2bc621f7..556644f28eae 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -39,7 +39,7 @@
 				 NETIF_F_SG | NETIF_F_TSO | \
 				 NETIF_F_TSO6 | \
 				 NETIF_F_IPV6_CSUM)
-#define NEXT_RX_DESP_IDX(X, Y)	(((X) + 1) & ((Y) - 1))
+#define NEXT_DESP_IDX(X, Y)	(((X) + 1) & ((Y) - 1))
 
 #define MTK_MAX_RX_RING_NUM	4
 #define MTK_HW_LRO_DMA_SIZE	8
-- 
2.22.1

