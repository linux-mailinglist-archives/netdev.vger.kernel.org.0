Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E192F6D2139
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbjCaNNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbjCaNNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:13:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4961A944;
        Fri, 31 Mar 2023 06:13:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5ADA8B82F6C;
        Fri, 31 Mar 2023 13:13:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B86C433EF;
        Fri, 31 Mar 2023 13:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680268412;
        bh=0Z0VSc/Pdg8WAOtxQIuNbiILq7OdgMdHZPAiZ/hleNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMS0Vb5+vEa1g/Kqfrg1KNSBMoPz2kc0O+kTypYgZCOxjBFIAls+i+VyuJwXgDn/d
         M1ar0Bw8m8qRBLSWeokN8yKUg2yOL1Mme+RwjvuMrpgwekcASFCbImWa6/mbXJnVVR
         FlVTc3kQew36Kw6RWdiJ1aACzV6TL7LGng4TKFSpHZzzOwCweQAbtNu55g9CRbURuz
         VwQ93LFugK3eaCdVP5jcm7x+ayu41FgVlfJAIdkWj6fmPIn6cNTNCJ5DkXeTetoNz0
         +FV4mfuE8a5tYkeedfjwKUNy2ZiW/2aC0GFK2UGx3VUoecbY5uREpVdlVW6huE7f0R
         55tnNUpbIxpqA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 net-next 01/10] net: ethernet: mtk_wed: rename mtk_wed_get_memory_region in mtk_wed_get_reserved_memory_region
Date:   Fri, 31 Mar 2023 15:12:37 +0200
Message-Id: <2915976b78fddb4b918c071d7409efa832201f3e.1680268101.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1680268101.git.lorenzo@kernel.org>
References: <cover.1680268101.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preliminary patch to move Wireless Ethernet Dispatch (WED)
ilm/dlm and cpuboot properties in dedicated dts nodes.

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

