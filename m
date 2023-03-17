Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589346BF336
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjCQU4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjCQU4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:56:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321575F6DD;
        Fri, 17 Mar 2023 13:56:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB22DB825DA;
        Fri, 17 Mar 2023 20:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE28C4339B;
        Fri, 17 Mar 2023 20:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679086570;
        bh=VzXlHxYNFbUcVstTyt9EJfj+teDRoE31sK1fPAn46Oc=;
        h=Date:From:To:Cc:Subject:From;
        b=BaWU4SPzIsEjzmEUwROAS+A0XupSs9pAyKe6SsluWorDLlQLQ48c/R4PXMIjUoedc
         l6OqnAFh9uO30POohnzH1oJgyTxZ+f/Hqmxf7TTBIbB1INTdvPH5ykgGPIRQUFM0M6
         /BPC2XuqpbKgsrSyVHiKQpPrFv3l4mhFidDd7VyrpyK86bvhFkoftJsZVJu/vVEDIT
         tBeZaCGmCb+uokVSbHxAJB1Is5v9mVVkDLuAUoezD8pLhBuHxs1nvpGNQQQAo5xLHq
         4Y6JbrC9reKmg13EYFaXLK/HYGfy8PdYc4yuwIfSXuhppR2Sv38Y6n2qwZ7nNYnT4I
         r5R2eub3YFFyA==
Date:   Fri, 17 Mar 2023 14:56:39 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
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
        <angelogioacchino.delregno@collabora.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] wifi: mt76: mt7921: Replace fake flex-arrays with
 flexible-array members
Message-ID: <ZBTUB/kJYQxq/6Cj@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays as fake flexible arrays are deprecated and we are
moving towards adopting C99 flexible-array members instead.

Address the following warnings found with GCC-13 and
-fstrict-flex-arrays=3 enabled:
drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c:266:25: warning: array subscript 0 is outside array bounds of ‘struct mt7921_asar_dyn_limit_v2[0]’ [-Warray-bounds=]
drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c:263:25: warning: array subscript 0 is outside array bounds of ‘struct mt7921_asar_dyn_limit[0]’ [-Warray-bounds=]
drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c:223:28: warning: array subscript <unknown> is outside array bounds of ‘struct mt7921_asar_geo_limit_v2[0]’ [-Warray-bounds=]
drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c:220:28: warning: array subscript <unknown> is outside array bounds of ‘struct mt7921_asar_geo_limit[0]’ [-Warray-bounds=]
drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c:334:37: warning: array subscript i is outside array bounds of ‘u8[0]’ {aka ‘unsigned char[]’} [-Warray-bounds=]

Notice that the DECLARE_FLEX_ARRAY() helper allows for flexible-array
members in unions.

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -fstrict-flex-arrays=3 [1].

Link: https://github.com/KSPP/linux/issues/21
Link: https://github.com/KSPP/linux/issues/272
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h b/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h
index 35268b0890ad..6f2c4a572572 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h
@@ -24,7 +24,7 @@ struct mt7921_asar_dyn {
 	u8 names[4];
 	u8 enable;
 	u8 nr_tbl;
-	struct mt7921_asar_dyn_limit tbl[0];
+	DECLARE_FLEX_ARRAY(struct mt7921_asar_dyn_limit, tbl);
 } __packed;
 
 struct mt7921_asar_dyn_limit_v2 {
@@ -37,7 +37,7 @@ struct mt7921_asar_dyn_v2 {
 	u8 enable;
 	u8 rsvd;
 	u8 nr_tbl;
-	struct mt7921_asar_dyn_limit_v2 tbl[0];
+	DECLARE_FLEX_ARRAY(struct mt7921_asar_dyn_limit_v2, tbl);
 } __packed;
 
 struct mt7921_asar_geo_band {
@@ -55,7 +55,7 @@ struct mt7921_asar_geo {
 	u8 names[4];
 	u8 version;
 	u8 nr_tbl;
-	struct mt7921_asar_geo_limit tbl[0];
+	DECLARE_FLEX_ARRAY(struct mt7921_asar_geo_limit, tbl);
 } __packed;
 
 struct mt7921_asar_geo_limit_v2 {
@@ -69,7 +69,7 @@ struct mt7921_asar_geo_v2 {
 	u8 version;
 	u8 rsvd;
 	u8 nr_tbl;
-	struct mt7921_asar_geo_limit_v2 tbl[0];
+	DECLARE_FLEX_ARRAY(struct mt7921_asar_geo_limit_v2, tbl);
 } __packed;
 
 struct mt7921_asar_cl {
@@ -85,7 +85,7 @@ struct mt7921_asar_fg {
 	u8 rsvd;
 	u8 nr_flag;
 	u8 rsvd1;
-	u8 flag[0];
+	u8 flag[];
 } __packed;
 
 struct mt7921_acpi_sar {
-- 
2.34.1

