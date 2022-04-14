Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1A0500A6D
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 11:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241222AbiDNJwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 05:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242078AbiDNJwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 05:52:34 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A331D0D7;
        Thu, 14 Apr 2022 02:50:10 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id r13so6128824wrr.9;
        Thu, 14 Apr 2022 02:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jEqj6dS4hwxknxKt8nbPyGn8ylY4KI7wiQLCN0ytwd4=;
        b=dfBpiVjlsURgw8l1FtunpLP/SXCSK+cHRWaMACUIAXOF9E1QQqQTXu94LlsgW4GVUy
         Q3w50jSbkKuNiID+VmJqjZ52X2aPihb9PthzPoE2/SbKed3FHv4Ex7Pum721tZLC8id+
         ygqRV2LUDEnRfdAo50KOE3YVvYuXEIaGKNtwoEf1h/KFltgi5QcYD51YikrCsVpyP1B2
         Gr7QE55XUqaCfiUeJ72eAODxAcLjcaVfieiVLc5AxET0l2MySq9wEK0ZsWUzrAsEc7bj
         6rMP/giWWEa04hkIOcJkoXGfR604MyjqX2/Z552f20oMdgEEuMmIed1JjhH8Dt6h7iFX
         Y+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jEqj6dS4hwxknxKt8nbPyGn8ylY4KI7wiQLCN0ytwd4=;
        b=01DdaZT6a1/TasyvPMjaU9XLMWHvhZ8F4xigF/ZfWS9tg0H1rwsUZ1/fXa/xrQXNk7
         Z654s0Vk596EOnlc+GH6B9vGU/0LroZvi3plv0yFZ5KAkMWBrfNt3FqwUaHIZbUsVGhS
         mF3cn36Ho0S+fYWBsXvz5mLMq/LjoLLxGPeNTdxb1Y49xV8cteR6wsnsSF8M52z0vpLM
         afmZOqPal4sTtniAs46JyvcBo6YzrXoo/PPje7k5gC1gitBDepG0nAqIKeI0UgpEa+EH
         SgVnnkHOXqrYwx/tL10g/Di/Pstjg8kHWx2VCRpI6HhH3aSkrosgu+fqkXOaNlgqa/Eq
         ep1w==
X-Gm-Message-State: AOAM531oAL1jRddwV9PoqZkkNOPcuwpaRNHN20BWlPHJvdaSU0THX8uk
        1DEssAjfx+cNGa/Fm0cPi5k=
X-Google-Smtp-Source: ABdhPJxiZGluHglMS5C73Q43h6GixG8ijFHiGdPg6fgRtR4THaNsuPUS55cih+bWuraSUoJZyEJAIg==
X-Received: by 2002:adf:f841:0:b0:207:a09b:d3cf with SMTP id d1-20020adff841000000b00207a09bd3cfmr1455218wrq.161.1649929808574;
        Thu, 14 Apr 2022 02:50:08 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id n65-20020a1c2744000000b003862bfb509bsm5102648wmn.46.2022.04.14.02.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 02:50:08 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt76: mt7915: make read-only array ppet16_ppet8_ru3_ru0 static const
Date:   Thu, 14 Apr 2022 10:50:07 +0100
Message-Id: <20220414095007.294746-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't populate the read-only array ppet16_ppet8_ru3_ru0 on the stack but
instead make it static const. Also makes the object code a little smaller.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 6d29366c5139..4b3cdb48b4bc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -814,7 +814,7 @@ static void
 mt7915_gen_ppe_thresh(u8 *he_ppet, int nss)
 {
 	u8 i, ppet_bits, ppet_size, ru_bit_mask = 0x7; /* HE80 */
-	u8 ppet16_ppet8_ru3_ru0[] = {0x1c, 0xc7, 0x71};
+	static const u8 ppet16_ppet8_ru3_ru0[] = {0x1c, 0xc7, 0x71};
 
 	he_ppet[0] = FIELD_PREP(IEEE80211_PPE_THRES_NSS_MASK, nss - 1) |
 		     FIELD_PREP(IEEE80211_PPE_THRES_RU_INDEX_BITMASK_MASK,
-- 
2.35.1

