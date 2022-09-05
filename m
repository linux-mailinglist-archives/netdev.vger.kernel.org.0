Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E915AD32C
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 14:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbiIEMs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 08:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237613AbiIEMsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 08:48:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2A365E1
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 05:46:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74F01B80EB5
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 12:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93992C433C1;
        Mon,  5 Sep 2022 12:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662381991;
        bh=zTgkc3/O7ys8ZEP2DtrdlEqxPju/WVeIDg0OqeCo9Ug=;
        h=From:To:Cc:Subject:Date:From;
        b=mRRvS0mSi/j+ueQT7e26x4k0pPaZW8g1VcTCyASLrUDccMr8atlbnwt5W9mEoiUSw
         Pio4mGAoqIz7Iyo8RNKYHaI+89X9W1Mt9SEIGH7vgMAI7bechyK+ttuMtzUOufuWiM
         p0jb/NBsIZDNIIay0NH/PHxovnTyQVveVgo21ETdaGAJBR/AQZP+2pe+RvAeJuE+0a
         /WQYcqI6QEdSUbqHrL+IzhlObhIYQpHgBmQUA35tiGJLYzbYxWfe71RLuL6S++rs2m
         FgqtUzehdIU6sRChfkXjBGfHynnT1MyB9CC4I8NIKUg+qFjYhc4d3wq6GpwAW2ePc9
         Y+/sCcObej5yQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
Subject: [PATCH net-next] net: ethernet: mtk_eth_soc: remove mtk_foe_entry_timestamp
Date:   Mon,  5 Sep 2022 14:46:01 +0200
Message-Id: <724dc466880787ae099ea037013cf5c9537128b6.1662380540.git.lorenzo@kernel.org>
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

Get rid of mtk_foe_entry_timestamp routine since it is no longer used.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index 69ffce04d630..8f786c47b61a 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -305,17 +305,6 @@ mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 	__mtk_ppe_check_skb(ppe, skb, hash);
 }
 
-static inline int
-mtk_foe_entry_timestamp(struct mtk_ppe *ppe, u16 hash)
-{
-	u32 ib1 = READ_ONCE(ppe->foe_table[hash].ib1);
-
-	if (FIELD_GET(MTK_FOE_IB1_STATE, ib1) != MTK_FOE_STATE_BIND)
-		return -1;
-
-	return FIELD_GET(MTK_FOE_IB1_BIND_TIMESTAMP, ib1);
-}
-
 int mtk_foe_entry_prepare(struct mtk_foe_entry *entry, int type, int l4proto,
 			  u8 pse_port, u8 *src_mac, u8 *dest_mac);
 int mtk_foe_entry_set_pse_port(struct mtk_foe_entry *entry, u8 port);
-- 
2.37.3

