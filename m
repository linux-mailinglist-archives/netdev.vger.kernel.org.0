Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D156C1D31
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbjCTRGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbjCTRFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:05:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7226D17CD9;
        Mon, 20 Mar 2023 10:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E59961704;
        Mon, 20 Mar 2023 16:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42A8C4339B;
        Mon, 20 Mar 2023 16:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679331534;
        bh=kJn6Wm7582WE4Dn1E73Md1ECuMNXKy9TdKSqsainkW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KtHvmQ6BOF/qk4D1a2TydF+HQ6P3Zx4O3Bft4B6NUcv59eYTACyJOM3ErzLfRpQm7
         GfpqEiYdBKarLgWuJexJ442cqH0yaqLC3aDPJMs7OVq+fYz1zfPTgCb6TseJB6S9F/
         UEbpHx3pPmkdwqzaVQARI3kDz95MG5DHB5OiLi2dmhnUWhENAdWHOVThNom8u206oE
         uD6mXTqQ2GWt5oc8euVJFlvl0nVfg+4Y6gXn+sRu8HxZVvtdvQDFcCsWgybEgSsu1B
         TNsZHrzN7+lXXAxT4J5/aHPgBsnRjdk1BdbO4/kMpQKVieoXPPTSiOia+lzXrl0yJX
         dF3RXt3QbXPrQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH net-next 01/10] net: ethernet: mtk_wed: rename mtk_wed_get_memory_region in mtk_wed_get_reserved_memory_region
Date:   Mon, 20 Mar 2023 17:57:55 +0100
Message-Id: <9e6defc0bb80dcdf9d8256f81882e58eea250665.1679330630.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1679330630.git.lorenzo@kernel.org>
References: <cover.1679330630.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preliminary patch to move wed ilm/dlm and cpuboot properties in
dedicated dts nodes.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
index 6bad0d262f28..6624f6d6abdd 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
@@ -215,8 +215,8 @@ int mtk_wed_mcu_msg_update(struct mtk_wed_device *dev, int id, void *data,
 }
 
 static int
-mtk_wed_get_memory_region(struct mtk_wed_wo *wo,
-			  struct mtk_wed_wo_memory_region *region)
+mtk_wed_get_reserved_memory_region(struct mtk_wed_wo *wo,
+				   struct mtk_wed_wo_memory_region *region)
 {
 	struct reserved_mem *rmem;
 	struct device_node *np;
@@ -311,13 +311,13 @@ mtk_wed_mcu_load_firmware(struct mtk_wed_wo *wo)
 
 	/* load firmware region metadata */
 	for (i = 0; i < ARRAY_SIZE(mem_region); i++) {
-		ret = mtk_wed_get_memory_region(wo, &mem_region[i]);
+		ret = mtk_wed_get_reserved_memory_region(wo, &mem_region[i]);
 		if (ret)
 			return ret;
 	}
 
 	wo->boot.name = "wo-boot";
-	ret = mtk_wed_get_memory_region(wo, &wo->boot);
+	ret = mtk_wed_get_reserved_memory_region(wo, &wo->boot);
 	if (ret)
 		return ret;
 
-- 
2.39.2

