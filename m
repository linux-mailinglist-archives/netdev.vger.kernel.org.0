Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBDA45289AB
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 18:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245664AbiEPQIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 12:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245722AbiEPQIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 12:08:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967E638BCF;
        Mon, 16 May 2022 09:08:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F42660FEB;
        Mon, 16 May 2022 16:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA66C3411D;
        Mon, 16 May 2022 16:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652717305;
        bh=5zNfSJuhI4dXzdSVVXLUoVyHOoDat1Fm5kjHvHG5PMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ks7uA+fl+FeuvZlHYmnKmrD776FtLfDc+fAM+Ost1IyAlSABNxHfoofa3zKXT9LQ5
         tHjloy/FGGR4BeMt0T4515mBuSQwpmxT3F7rWwBNp+WfhZVYVKlzQAP7TJP6fDNM5Z
         4h+6E5kYT3Kr3THRyexKYMRE44MNzk1J3iVYP2K26K1sJJ6veofoYJ/voG7/us68un
         2n9KM1rxzab8S002CdwjYGHo4Mgk2PG/u19zBZNHQoJguN7KYXVBNSa1SaHHicnMnx
         QBUYqqE7iUpZ8Fyg755PJJ/Q3InORUrYAO3Jmb9CtR56FseZNCaMZQF31ynzS+/17y
         TGKctzsfIW6wQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 net-next 14/15] net: ethernet: mtk_eth_soc: convert scratch_ring pointer to void
Date:   Mon, 16 May 2022 18:06:41 +0200
Message-Id: <235146c3d8620deef0d831cbca76452776ca6a04.1652716741.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1652716741.git.lorenzo@kernel.org>
References: <cover.1652716741.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the code converting scratch_ring pointer to void

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 4190172ba902..373d9733e66f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -827,7 +827,7 @@ static int mtk_init_fq_dma(struct mtk_eth *eth)
 	for (i = 0; i < cnt; i++) {
 		struct mtk_tx_dma_v2 *txd;
 
-		txd = (void *)eth->scratch_ring + i * soc->txrx.txd_size;
+		txd = eth->scratch_ring + i * soc->txrx.txd_size;
 		txd->txd1 = dma_addr + i * MTK_QDMA_PAGE_SIZE;
 		if (i < cnt - 1)
 			txd->txd2 = eth->phy_scratch_ring +
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 57501dd5adcc..d955af42ad93 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -1131,7 +1131,7 @@ struct mtk_eth {
 	struct mtk_rx_ring		rx_ring_qdma;
 	struct napi_struct		tx_napi;
 	struct napi_struct		rx_napi;
-	struct mtk_tx_dma		*scratch_ring;
+	void				*scratch_ring;
 	dma_addr_t			phy_scratch_ring;
 	void				*scratch_head;
 	struct clk			*clks[MTK_CLK_MAX];
-- 
2.35.3

