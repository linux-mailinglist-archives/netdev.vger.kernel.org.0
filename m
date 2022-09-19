Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08D95BC2FF
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 08:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiISGl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 02:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiISGlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 02:41:20 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539D51C93C;
        Sun, 18 Sep 2022 23:41:15 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id t3so27049317ply.2;
        Sun, 18 Sep 2022 23:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=YGtln4qRJdeQFwxykgq2BuKS/o+48jB63ghCj0GS3KY=;
        b=MkjVOU2IVgLhpN/lrOusQHD5grafVvenCuDveooVQ+8l8W4TLMjmmH++AZxc2iTsyN
         NTaQvGgHYp6jQhgpeYqt3mAmIz7TeWuqsbeLlzO1qXyLM1LtExr63woLFr9u43kIWuWs
         sgmBgGbRYFos6rD8+iplX0SdhxL3YXEe6Zc4Nhb7JeHYz5NZQX9YyxVrB3ALqbD1a9tC
         JkOgEw0sWKRedbDgvChYXPoiGhjrsWgf/UvIG/uPtzNQJ6eJ+FH2Fxq9ZpFTDeL9OoZ5
         Dzkiij5WZAW30tTa5rLdPtDkd7JtHuyYv7yLdEhjCWCougEoaWHdcdjxBMKZ0wIGOsvh
         fytA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=YGtln4qRJdeQFwxykgq2BuKS/o+48jB63ghCj0GS3KY=;
        b=xz/RT0uDQ1PGj4pbAIa/Kp7Hx6CjL7TzQ191f9T9wpV2mRj7HtIB78Yr6Ug621ILGV
         AJ2+Y8bBjuKWZsN7jqsAlCLC3QbppbYnQov4qE27EmOu6wnyv6xo2njVK3USQzx5zX5i
         lxzmFBL3mPWGVs9aqh7scemfO9wH+Lmr9QLuV4s5GH3pV4eWF6n2yYCg2d6iiSeB4xSJ
         q42uGlmuDPE9VEFFD/JOaIKRgxuuPpX8OExHraaIVSzYTlm8ME1AiTDtjKXEDlanTAB6
         2HQPM63GhUkCCxagBCdSTr8g5VrE4R58zVpjLnJpm9AjiWMT6Z8YlJM7zMgzqIprg11H
         IF1g==
X-Gm-Message-State: ACrzQf0yBUuvYv5j4vcfZiZvN72631NL6ATxEQhabybntolVcr7Lbrd5
        9yCXHcUIK+t2xdq/bGddybRbmDGmj0VH8A==
X-Google-Smtp-Source: AMsMyM7LKXElGGRVM+cmjKl7KzaLG9qIpWIiTpzoTC8A3WSChhXRdgMz9A2cadQsejnAtgppl3HfmQ==
X-Received: by 2002:a17:903:244e:b0:178:4f50:1ca0 with SMTP id l14-20020a170903244e00b001784f501ca0mr11750903pls.104.1663569674748;
        Sun, 18 Sep 2022 23:41:14 -0700 (PDT)
Received: from MacBook.stealien.com ([110.11.251.111])
        by smtp.gmail.com with ESMTPSA id bx23-20020a17090af49700b001f334aa9170sm5821272pjb.48.2022.09.18.23.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Sep 2022 23:41:14 -0700 (PDT)
From:   Ruffalo Lavoisier <ruffalolavoisier@gmail.com>
X-Google-Original-From: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ath9k: delete repeated words
Date:   Mon, 19 Sep 2022 15:41:07 +0900
Message-Id: <20220919064108.17931-1-RuffaloLavoisier@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
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

- Delete the repeated word 'the' in the comment.

Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index dc0e5ea25673..090ff0600c81 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1744,7 +1744,7 @@ static void ar9003_hw_spectral_scan_config(struct ath_hw *ah,
 	REG_SET_BIT(ah, AR_PHY_RADAR_0, AR_PHY_RADAR_0_FFT_ENA);
 	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN, AR_PHY_SPECTRAL_SCAN_ENABLE);
 
-	/* on AR93xx and newer, count = 0 will make the the chip send
+	/* on AR93xx and newer, count = 0 will make the chip send
 	 * spectral samples endlessly. Check if this really was intended,
 	 * and fix otherwise.
 	 */
-- 
2.34.1

