Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657346416DB
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 14:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiLCNVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 08:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLCNVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 08:21:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592302FA7B
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 05:20:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 091B7B801B8
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 13:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D87BC433C1;
        Sat,  3 Dec 2022 13:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670073656;
        bh=WRRsNHyJqBjdeC2QSytaa2enRTqxjhcJaDFKE8KqG9M=;
        h=From:To:Cc:Subject:Date:From;
        b=jp6PtICadOveJeyqCNB581pT1YISUGuuUS6EAvkN/2mKRDjThreCsSfbZC9JBz8mS
         0O3xDnjCkoIJ6kjUqmw2NXivzw5TZDeIq+EebFy8OfgeOCCUmX1hxUf6S+9XYX7I2O
         RpRaxk9mroT6t5RIP9oAbK2XxN9s5ilJv0Rhkyyl7wEQHxyVEwfPZdRBmG+bmT9zTt
         grMrm1PEpjWKieYpeIqivWsJcKIzfrFiPkl62rV0zYRNm1tn48TrjJeWrOiJtJPA9j
         m6piVHwhVl+v2Dp+G93xs0sN2AV6L2SL5F4qHtbZlc+iOIOafuQmH+Wi5heDsZslv7
         FpUHjEvqiTtBg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, sujuan.chen@mediatek.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH net-next] net: mtk_eth_soc: enable flow offload support fot MT7986 SoC
Date:   Sat,  3 Dec 2022 14:20:37 +0100
Message-Id: <fdcaacd827938e6a8c4aa1ac2c13e46d2c08c821.1670072898.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since Wireless Ethernet Dispatcher is now available for mt7986 in mt76,
enable hw flow support for MT7986 SoC.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 8b93dab79141..e3de9a53b2d9 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4593,6 +4593,7 @@ static const struct mtk_soc_data mt7986_data = {
 	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7986_CLKS_BITMAP,
 	.required_pctl = false,
+	.offload_version = 2,
 	.hash_offset = 4,
 	.foe_entry_size = sizeof(struct mtk_foe_entry),
 	.txrx = {
-- 
2.38.1

