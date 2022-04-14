Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463FF500A97
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 11:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242115AbiDNJ5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 05:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242050AbiDNJ5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 05:57:05 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1A9167C0;
        Thu, 14 Apr 2022 02:54:40 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id b19so6134985wrh.11;
        Thu, 14 Apr 2022 02:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qz4eoGCjwqiVTIGhSK37UOjVOVCpyvZrQ4WRtbzGJcY=;
        b=o6Q2r7jKuN5KwGswZCLVojX54AFIYdM8E7FrOjUvQcnVhxqQaEAlspQV217XzhSoAv
         HD0LmIr8jJ2vFXbfZwCw2TPEHTwaaL4g+qu7J4ZEC0nGohy2w2QiiYlPq1SoyfDNhbVw
         Jr8PQ88O8YL6MDLMXDXARCdmw4Id3hifEtFjffLRP7opy6qBf83OePZLNAFo1V/j/j9p
         M8SbmFrrA3oFhfoRsrHLZaEJjLstgP49/4bGHjOqMNBt8wBXBfChyvkUyhUWZzrLEZTq
         tfY1JfDmZWzim41tkAtdj05+o4/hu2EdCVtbQo0tROIKgQDo2/nUJxuN5C/cUoThnV/Y
         07rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qz4eoGCjwqiVTIGhSK37UOjVOVCpyvZrQ4WRtbzGJcY=;
        b=LfGRhJX6cvjbPmvv1Su8E2vzEVZMGg5QeWcoFM8bn/K3YsSFNy1hUXr9UoV5AslQrT
         X7pLh8oBORGQhEUafPjTlqsnfEcDJMTEa6niB75YmiPZg9+vVsQgeOtBEffbDkCSmd7n
         gwgLazxiZ61BWXWtwvhcBKiVHik9ZBkBj8hZxjUkc00a8IiVbTDAPNHaWj9bEZ0yLug1
         JwngmazROsVUvA1/I5dDvRWtFueBRURcmp3g0o8ZQXptSnvWik5npoeiO4Y0XAgUl31I
         jo/9slyCvrMDPPaSTTX0m9hwLebU4OHCsPu59BAcXUuZ9Ygmjd+u4kHCo/3xJzqnqncs
         sSgw==
X-Gm-Message-State: AOAM531nHzu7E8sHQDNA8TeRBXCFJzpUCQUAiPkjrB+T523QkDRG2Rs3
        fKCglqoohEdZ4FiTR0kgpqw=
X-Google-Smtp-Source: ABdhPJyJpElLXIDRtcHN0en+en7f4nKd00rYFyVmnDPQ66HEr4AxsmGykL5nNAhtm9fVYQ9i1B0T5g==
X-Received: by 2002:a5d:47cc:0:b0:204:1c9d:2157 with SMTP id o12-20020a5d47cc000000b002041c9d2157mr1421460wrc.294.1649930079091;
        Thu, 14 Apr 2022 02:54:39 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id d14-20020a056000186e00b0020405198faasm1633727wri.52.2022.04.14.02.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 02:54:38 -0700 (PDT)
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
Subject: [PATCH] mt76: mt7921: make read-only array ppet16_ppet8_ru3_ru0 static const
Date:   Thu, 14 Apr 2022 10:54:38 +0100
Message-Id: <20220414095438.294980-1-colin.i.king@gmail.com>
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
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index fdaf2451bc1d..d400a3297b0c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -12,7 +12,7 @@ static void
 mt7921_gen_ppe_thresh(u8 *he_ppet, int nss)
 {
 	u8 i, ppet_bits, ppet_size, ru_bit_mask = 0x7; /* HE80 */
-	u8 ppet16_ppet8_ru3_ru0[] = {0x1c, 0xc7, 0x71};
+	static const u8 ppet16_ppet8_ru3_ru0[] = {0x1c, 0xc7, 0x71};
 
 	he_ppet[0] = FIELD_PREP(IEEE80211_PPE_THRES_NSS_MASK, nss - 1) |
 		     FIELD_PREP(IEEE80211_PPE_THRES_RU_INDEX_BITMASK_MASK,
-- 
2.35.1

