Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6124C69BA07
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 13:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjBRMjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 07:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBRMjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 07:39:19 -0500
X-Greylist: delayed 1800 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 18 Feb 2023 04:39:13 PST
Received: from mx.dolansoft.org (s2.dolansoft.org [212.51.146.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A975199E7;
        Sat, 18 Feb 2023 04:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=brun.one;
        s=s1; h=MIME-Version:Message-Id:Date:Subject:Cc:To:From:In-Reply-To:
        References:From:To:Subject:Date:Message-ID:Reply-To;
        bh=5U+6Z0459SCaD+OwInItRywQ8Q+yZ7dB5UAq0E7lQmM=; b=G82eN/oLtC/wEu84JUQh4YEEQO
        V5FlAWUPWKFxMhkYMluHXpPYfcXxhDc1vvO0AGAmSXUYR/DKwwE9KkXeDkfadyquw1saUMrltIq35
        W1jKiau8NgEgA5EkkVwofKr4EiM6XxYb8QvFXLvHTcgRzdy6vi56rMB0pqMnF8OpspbCBkv0R+g9L
        9nNF/YYAWFtii9OmA3gSlxlOEOGiXJeTmwPFiumLH6PqkxxiEkG4zkzB8UjHN4T48U9NOtsX0yEhd
        g9pvMTluNcTOU2TjT3Qu8MKxNT8/EtNUN2D2OuoJB8a1HL9AUlBJj0aX1z9Qrb8IhlooTn6xK3SSZ
        pLVmiLpA==;
Received: from [212.51.153.89] (helo=blacklava.cluster.local)
        by mx.dolansoft.org with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <lorenz@dolansoft.org>)
        id 1pTLPZ-000XxV-0l;
        Sat, 18 Feb 2023 11:29:49 +0000
From:   Lorenz Brun <lorenz@brun.one>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Bo Jiao <Bo.Jiao@mediatek.com>,
        Peter Chiu <chui-hao.chiu@mediatek.com>,
        Sujuan Chen <sujuan.chen@mediatek.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH] mt76: mt7915: expose device tree match table
Date:   Sat, 18 Feb 2023 12:29:45 +0100
Message-Id: <20230218112946.3039855-1-lorenz@brun.one>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: lorenz@dolansoft.org
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On MT7986 the WiFi driver currently does not get automatically loaded,
requiring manual modprobing because the device tree compatibles are not
exported into metadata.

Add the missing MODULE_DEVICE_TABLE macro to fix this.

Fixes: 99ad32a4ca3a2 ("mt76: mt7915: add support for MT7986")
Signed-off-by: Lorenz Brun <lorenz@brun.one>
---
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
index 2ac0a0f2859cb..32c137066e7f7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
@@ -1239,6 +1239,8 @@ static const struct of_device_id mt7986_wmac_of_match[] = {
 	{},
 };
 
+MODULE_DEVICE_TABLE(of, mt7986_wmac_of_match);
+
 struct platform_driver mt7986_wmac_driver = {
 	.driver = {
 		.name = "mt7986-wmac",
-- 
2.39.1

