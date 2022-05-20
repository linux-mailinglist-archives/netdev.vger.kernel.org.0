Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F81152F244
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350909AbiETSNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352476AbiETSNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:13:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549A818DAC9;
        Fri, 20 May 2022 11:13:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0919B82A55;
        Fri, 20 May 2022 18:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD201C34100;
        Fri, 20 May 2022 18:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653070387;
        bh=517w0061VhT0H/2QvPkC4TTyfnG9lp0U3TLqta29KZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mU4DXDIFZk/KjH0I05ydJghpxRix8vZ/C/1zWjsaIQz9EJsrKCrr2oBTG3R+A6VOl
         FF20FKhIU057fv4aou8hkX95C7Cu+TISGrv6EqffpI/WpLppIgef/L+qA4HpeYRXyQ
         XsCnyinlT8Fxf5C2jWpl6MKsBH8TOfrZyothyVh0yvt8gUGoApNGatO9MejkXzbAvt
         04HHSHcQwh4BGVBoBF5+75ihBo9TuGTXVSlR5/wU5qkaomoTS77JBQgu3Mxim9Wd/X
         Iv5SYAxwPRri8Ek8oyLiGieJP21R2cbEHrb8iYqkiAI+CuZCE/eqj2O58tuv4cn7vG
         IiC0IfYrl9tAw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v3 net-next 15/16] net: ethernet: mtk_eth_soc: convert scratch_ring pointer to void
Date:   Fri, 20 May 2022 20:11:38 +0200
Message-Id: <830515be544d4106a52102c15da6e7df3d1e04ab.1653069056.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1653069056.git.lorenzo@kernel.org>
References: <cover.1653069056.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 64c201e763c3..c034fd90dbdc 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -893,7 +893,7 @@ static int mtk_init_fq_dma(struct mtk_eth *eth)
 	for (i = 0; i < cnt; i++) {
 		struct mtk_tx_dma_v2 *txd;
 
-		txd = (void *)eth->scratch_ring + i * soc->txrx.txd_size;
+		txd = eth->scratch_ring + i * soc->txrx.txd_size;
 		txd->txd1 = dma_addr + i * MTK_QDMA_PAGE_SIZE;
 		if (i < cnt - 1)
 			txd->txd2 = eth->phy_scratch_ring +
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index f53024682698..67482124de2a 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -1033,7 +1033,7 @@ struct mtk_eth {
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

