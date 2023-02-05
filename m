Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E845168B125
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 18:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjBERyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 12:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBERyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 12:54:08 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AE717149;
        Sun,  5 Feb 2023 09:54:07 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id ml19so28476711ejb.0;
        Sun, 05 Feb 2023 09:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DphQeSQZJvbNuRjNugbdilolmsiVVgBCD0pCY3YPQUo=;
        b=UqhO8kaPxSnFzaZS6O47he52FqNrXKdSoC1htl4GMBQaXY5E6GnAN7O4oSN1Zm0lr/
         fMCozRC/4M5dRoDVcK3zX9tURfoyPns8HL013E7awa7U3GHtulQdhVhyO8oUTNHKvP4w
         NEYM4i1qHVNm9VgDM3lRcgwOXfqcb2feH4oxKWhyZTbOu3MjZFMwKCGBcKHP3I/z0Aj3
         EJ6Px1gI0bBBTY60jNOurte7EmzfPqlKnG8xJivWjyaLNt27PSv4A6HYDFsMjpyqBtCt
         0D1LgiE0F7aQUVfq44r4wIQwDUXoCcDBXkT9z0fMkTwNTn4PHlGNF0VqISbReH1IHASQ
         55Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DphQeSQZJvbNuRjNugbdilolmsiVVgBCD0pCY3YPQUo=;
        b=ZL23iudGPcVzt7DKp1tISVqcoqTDkFddQOvDoDs5XMVUw6aHgfisnaeytLiOvfuYob
         IdKg7OtkwVg7v35+F3Tj5xLgcVmBMxKUApxGbgQGzUF7RpuJxk+IYE9XzuU0kFkHoaAJ
         cVKP3XD1HvOect+zPVxwFvcC3qZo+ny3PiUOjKefpFIuWw0rF58pboWL2cdh16K03yR8
         GaNYGrOqPjSvCZF8XZimOsKiUfXNCUuiLFhOTp3gH5MnxnjrWLXzBDcdNwNsZPQXkwle
         zwfeT9PUWPZUJ8Ad7VS6pjdeK0YYHE48MOJhy+UxpYAOcjfFcqbjmGGKnpymInXqW0yD
         SdbA==
X-Gm-Message-State: AO0yUKWtOdhz5pW03pFiYFywxp/iHyLDoMxvqFGhfLONDzRLbKuereBf
        Rug3vvklAO4i+qDTRaF0/cU=
X-Google-Smtp-Source: AK7set8R/RpjHz1I9LQp3quAaOb1owfTrxZiV8lwCubfnBO+9DbUGf0wEYJXGGpUazVE7qs12pdI4g==
X-Received: by 2002:a17:906:6d42:b0:87a:daee:70b8 with SMTP id a2-20020a1709066d4200b0087adaee70b8mr14567604ejt.24.1675619646272;
        Sun, 05 Feb 2023 09:54:06 -0800 (PST)
Received: from arinc9-PC.lan ([37.120.152.236])
        by smtp.gmail.com with ESMTPSA id e13-20020a170906248d00b0087a9f699effsm4423118ejb.173.2023.02.05.09.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Feb 2023 09:54:05 -0800 (PST)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Richard van Schagen <richard@routerhints.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, erkin.bozoglu@xeront.com
Subject: [PATCH net] net: ethernet: mtk_eth_soc: enable special tag when any MAC uses DSA
Date:   Sun,  5 Feb 2023 20:53:31 +0300
Message-Id: <20230205175331.511332-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

The special tag is only enabled when the first MAC uses DSA. However, it
must be enabled when any MAC uses DSA. Change the check accordingly.

This fixes hardware DSA untagging not working on the second MAC of the
MT7621 and MT7623 SoCs, and likely other SoCs too. Therefore, remove the
check that disables hardware DSA untagging for the second MAC of the MT7621
and MT7623 SoCs.

Fixes: a1f47752fd62 ("net: ethernet: mtk_eth_soc: disable hardware DSA untagging for second MAC")
Co-developed-by: Richard van Schagen <richard@routerhints.com>
Signed-off-by: Richard van Schagen <richard@routerhints.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index f1cb1efc94cf..b5b99f417c86 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3177,7 +3177,7 @@ static void mtk_gdm_config(struct mtk_eth *eth, u32 config)
 
 		val |= config;
 
-		if (!i && eth->netdev[0] && netdev_uses_dsa(eth->netdev[0]))
+		if (eth->netdev[i] && netdev_uses_dsa(eth->netdev[i]))
 			val |= MTK_GDMA_SPECIAL_TAG;
 
 		mtk_w32(eth, val, MTK_GDMA_FWD_CFG(i));
@@ -3243,8 +3243,7 @@ static int mtk_open(struct net_device *dev)
 	struct mtk_eth *eth = mac->hw;
 	int i, err;
 
-	if ((mtk_uses_dsa(dev) && !eth->prog) &&
-	    !(mac->id == 1 && MTK_HAS_CAPS(eth->soc->caps, MTK_GMAC1_TRGMII))) {
+	if (mtk_uses_dsa(dev) && !eth->prog) {
 		for (i = 0; i < ARRAY_SIZE(eth->dsa_meta); i++) {
 			struct metadata_dst *md_dst = eth->dsa_meta[i];
 
@@ -3261,8 +3260,7 @@ static int mtk_open(struct net_device *dev)
 		}
 	} else {
 		/* Hardware special tag parsing needs to be disabled if at least
-		 * one MAC does not use DSA, or the second MAC of the MT7621 and
-		 * MT7623 SoCs is being used.
+		 * one MAC does not use DSA.
 		 */
 		u32 val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
 		val &= ~MTK_CDMP_STAG_EN;
-- 
2.37.2

