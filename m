Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFBB5EC7BC
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbiI0PaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 11:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbiI0PaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:30:20 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795C01879FE
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 08:30:16 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1odCXB-0007o6-0O;
        Tue, 27 Sep 2022 17:30:09 +0200
Date:   Tue, 27 Sep 2022 16:30:02 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Sujuan Chen <sujuan.chen@mediatek.com>,
        Bo Jiao <Bo.Jiao@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chen Minqiang <ptpt52@gmail.com>
Subject: [PATCH] net: ethernet: mtk_eth_soc: fix mask of
 RX_DMA_GET_SPORT{,_V2}
Message-ID: <YzMW+mg9UsaCdKRQ@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bitmasks applied in RX_DMA_GET_SPORT and RX_DMA_GET_SPORT_V2 macros
were swapped. Fix that.

Reported-by: Chen Minqiang <ptpt52@gmail.com>
Fixes: 160d3a9b192985 ("net: ethernet: mtk_eth_soc: introduce MTK_NETSYS_V2 support")
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 1efaba5d433775..b52f3b0177efb9 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -315,8 +315,8 @@
 #define MTK_RXD5_PPE_CPU_REASON	GENMASK(22, 18)
 #define MTK_RXD5_SRC_PORT	GENMASK(29, 26)
 
-#define RX_DMA_GET_SPORT(x)	(((x) >> 19) & 0xf)
-#define RX_DMA_GET_SPORT_V2(x)	(((x) >> 26) & 0x7)
+#define RX_DMA_GET_SPORT(x)	(((x) >> 19) & 0x7)
+#define RX_DMA_GET_SPORT_V2(x)	(((x) >> 26) & 0xf)
 
 /* PDMA V2 descriptor rxd3 */
 #define RX_DMA_VTAG_V2		BIT(0)
-- 
2.37.3

