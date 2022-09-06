Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE5A5AEEB5
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 17:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbiIFP0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 11:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbiIFP0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 11:26:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD4BBFE98
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 07:37:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EBB6B8164A
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 14:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8300C433D7;
        Tue,  6 Sep 2022 14:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662475017;
        bh=XRL315MAyOCfgp7sMWqBqs6KwVLvXbXCAZ47y0frCXA=;
        h=From:To:Cc:Subject:Date:From;
        b=kB32FJVm4R9Okt3CwKgk8fekAYOeRDxFGmyaiergN1oM215KgguvHmR1bJUDQVZGA
         7sd8FntlwN4RIxMWQl2xh/dldqUgIjZcgI8bK5bXNMegHWezOh0IkcOCIZkOcts0k0
         aO35aAo1LGF7fNbr1t0fW+rZUugFeC94A36B/pSPIgtvWYA+irhNUfZZRVTeFQtpnm
         qP9GUQ5sM9fo63gMOO/OdnWRInu8opaYX9BxciT9B80feQZ0xsFkmXK4s5KxRGG+lP
         iXDzVgoAJzHewQCfFzArXSvlrS0wuGEW9YrNItBnmCUnr3jJiZ/PZConqGrCaVmz1C
         oxeIdlW8t/uFA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
Subject: [PATCH net] net: ethernet: mtk_eth_soc: fix typo in __mtk_foe_entry_clear
Date:   Tue,  6 Sep 2022 16:36:32 +0200
Message-Id: <6fb6f748b78faba37702f4757e5b3fb279eaf5ed.1662474824.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ib1 state to MTK_FOE_STATE_UNBIND in __mtk_foe_entry_clear routine.

Fixes: 33fc42de33278 ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index dab8f3f771f8..cfe804bc8d20 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -412,7 +412,7 @@ __mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 	if (entry->hash != 0xffff) {
 		ppe->foe_table[entry->hash].ib1 &= ~MTK_FOE_IB1_STATE;
 		ppe->foe_table[entry->hash].ib1 |= FIELD_PREP(MTK_FOE_IB1_STATE,
-							      MTK_FOE_STATE_BIND);
+							      MTK_FOE_STATE_UNBIND);
 		dma_wmb();
 	}
 	entry->hash = 0xffff;
-- 
2.37.3

