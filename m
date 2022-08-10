Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0544958F41C
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 00:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbiHJWE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 18:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbiHJWEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 18:04:55 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFBB81B2F;
        Wed, 10 Aug 2022 15:04:54 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 130so14878346pfv.13;
        Wed, 10 Aug 2022 15:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=YYJjRLucIChyK6APevUjSlHLzhvc7kx5V1ce89D+Ci0=;
        b=Ina7MvM0fw6Rnu6mFHPASwMT5BfxaVoY0EkYmfHFiRlq+aIBRfdaT68FfyXhysiSa8
         jXa5mn3ydiUXb72u7LujBk2s48+ssLJaze4g3fA3VI6amiDU5R7P0g+1thVgSJ6I+7NS
         zEnpr0U557hWqpMmL4d5cB4J6SQKc+OXApWJv/iiWp3PAcTUlIk+QZS0XhfZYAOa2tYL
         mpyoZAIvG/mOyz2tgA9tUge7Hee5POFzm/aPXFGgBYYys816n9+7cQbGXsCY81dL2zJl
         bj99Us/lnrMUHnzqwDCAwm9Q28BI/0QXabncSdDe7SEAAjo+Toy75RSnz1ZaWzodTvrG
         4Nsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=YYJjRLucIChyK6APevUjSlHLzhvc7kx5V1ce89D+Ci0=;
        b=Be/qxLHGUJylIS/HLYbGVfYgqq89xtPPpdaGWgvnMn8Jov9157899Sea435Cu7wHLp
         ulTc9Pxf52cRGp5BgWI9meMckx5yGeWHI9dN+mWZ4B6pqRy6QWMKDcBKns/pL9iyTdcC
         XBmUKNpUYMS+n/yt1VIh5d51lBmLBAr/er6Nl9/yGGw1oETYWg8LDDFp+30uIJfAzhHD
         A9wyDZ7LyNMjQigU4DZ4NYuxJsGflnm8FxRX1Vno38lQMHPx7umnYvY7ILfv3gxjnlqL
         pgQqayqB52UGznIxHi+/vb3Vq+3eECDohGkJ/izXp236aplebNlhaiEORrSeCXGrRI2M
         ereQ==
X-Gm-Message-State: ACgBeo0U8kn+oW0Rm7PxjOJUjZMQRpBE3cjwy2xFYTdHh+qqn0qqWvGn
        BsKKKHj0OJ0dMWvQEQrz/iA=
X-Google-Smtp-Source: AA6agR7MOkZdKiZUvC077NS2slfn3nrTZbPgsNCrIP7XpHTfuH83HFEwqnMTKb/cwOt9pR8K4MbsLQ==
X-Received: by 2002:a63:c108:0:b0:41d:6bf3:6807 with SMTP id w8-20020a63c108000000b0041d6bf36807mr13939912pgf.157.1660169093850;
        Wed, 10 Aug 2022 15:04:53 -0700 (PDT)
Received: from rfl-device.localdomain ([39.124.24.102])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902a38d00b0016be6a554b5sm13366035pla.233.2022.08.10.15.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 15:04:53 -0700 (PDT)
From:   Ruffalo Lavoisier <ruffalolavoisier@gmail.com>
X-Google-Original-From: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
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
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt76: connac: fix in comment
Date:   Thu, 11 Aug 2022 07:04:44 +0900
Message-Id: <20220810220445.8957-1-RuffaloLavoisier@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
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

Correct spelling on 'transmitted' in comment

Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 9b17bd97ec09..972190f7b81f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -2648,7 +2648,7 @@ int mt76_connac_mcu_add_key(struct mt76_dev *dev, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(mt76_connac_mcu_add_key);
 
-/* SIFS 20us + 512 byte beacon tranmitted by 1Mbps (3906us) */
+/* SIFS 20us + 512 byte beacon transmitted by 1Mbps (3906us) */
 #define BCN_TX_ESTIMATE_TIME (4096 + 20)
 void mt76_connac_mcu_bss_ext_tlv(struct sk_buff *skb, struct mt76_vif *mvif)
 {
-- 
2.25.1

