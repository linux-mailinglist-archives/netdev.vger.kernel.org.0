Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B9B3AE4AA
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 10:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhFUIWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 04:22:25 -0400
Received: from first.geanix.com ([116.203.34.67]:58034 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhFUIWZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 04:22:25 -0400
Received: from localhost (80-62-117-165-mobile.dk.customer.tdc.net [80.62.117.165])
        by first.geanix.com (Postfix) with ESMTPSA id 6D1734C326A;
        Mon, 21 Jun 2021 08:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1624263609; bh=S+se73egPywLKSHDrqIVcIlWhwgjZ5Op011LkNiDG+I=;
        h=From:To:Subject:Date;
        b=iCq/2UUPKG2zNloXmruyGKC3nlpkU/olBmHGsJwiF5LY+haKl9wYrHp1H7T/6UUHe
         ET/NhDmGWTUjBWhjhP+ztUuj5KV1iV+wqacrKbUH816sLakbmEzMR2+s7Zj3m10p3P
         RvuvJKZApI85LSG5zxLW5ZUtNflGIJ+k0QDVeaqHdnT3moXNdvLduPXLrqMvJxdt3z
         jBHkSquTg+dNJy3Ryu8sWEegaEu0VCXVx9gf6X/FYr2Frn8jlQzVLG7jUn3hCM5NXs
         K9g0os9xdX4Hniuatz+sTrME6/Z7QfM4Ms1INlF8yr0xQwKNjgY1KUD8+32XzTKOMJ
         6SSlLGPqa7grA==
From:   Esben Haabendal <esben@geanix.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] net: ll_temac: Remove left-over debug message
Date:   Mon, 21 Jun 2021 10:20:08 +0200
Message-Id: <bd834ced7d5a7f6980e9b2d358f7876c215185b5.1624263139.git.esben@geanix.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 93bd6fdb21b5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: f63963411942 ("net: ll_temac: Avoid ndo_start_xmit returning NETDEV_TX_BUSY")
Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 9a13953ea70f..60a4f79b8fa1 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -942,10 +942,8 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	wmb();
 	lp->dma_out(lp, TX_TAILDESC_PTR, tail_p); /* DMA start */
 
-	if (temac_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1)) {
-		netdev_info(ndev, "%s -> netif_stop_queue\n", __func__);
+	if (temac_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1))
 		netif_stop_queue(ndev);
-	}
 
 	return NETDEV_TX_OK;
 }
-- 
2.32.0

