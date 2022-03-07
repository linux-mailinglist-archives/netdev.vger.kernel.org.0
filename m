Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8ED4D0B04
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 23:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243030AbiCGWZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 17:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241302AbiCGWZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 17:25:27 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A7B6FA00;
        Mon,  7 Mar 2022 14:24:31 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id j26so15201077wrb.1;
        Mon, 07 Mar 2022 14:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zbMZsIhYJ+77vvsPZqt2FUvbmhqeDxMePb3nZB4cAlI=;
        b=qk/46LPOyKRdvec+MKolVbUYO/E7hTEJpciHXRhBVUmmNAyo2C/8d97ZqVaKPsuFQR
         g28XiQxVe2sCZP1J4om1F2VAvaHjlN/A2tbJdm+zmnUPpCGWKbq/BnCGY54cDizS2sXh
         DLljZlhxEuuZ5m1bXGEl69acOJ4W+UjX66CaqOXniK4WwpzQvxJ1hcO7bd5TxzkBfT+h
         xYU0X44s5t62Q1FwkakwfyYhu3oOR2xcNYRsAVzer1zydacqroMozijJcMVywovCq/tF
         g7gYlW0Hi5PIkn+Cq66Jbm3y7aHTCF7jCpU0NH0egwL9p84eecVwb01d9H0Fj+dRhmP1
         aCOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zbMZsIhYJ+77vvsPZqt2FUvbmhqeDxMePb3nZB4cAlI=;
        b=FoBUoTOCx7kWbyazQOEyVGyQJPuz3JXkXLtJPZgjltZhdHDSE2bBCx6ngUdqqBUcdk
         IQBb3s0c1vcZNGgf3cfo8gG6wAsfhZq2nWgSwxDjJFWLe31D08Pus/CwFYEm7ToHAi2S
         1qtOluoGOH9HzS8qFzAuL1btX6djFSufhiAQr8PBVIkInjTtpTNmOoWhwvr8QYMlukEL
         1MJjVkk9FTp0VvFzY4Pab++i2w3QCxw1NwfejuLKribGXmoeLx9ygnqtfbG3QJZoLN5f
         eVpjqcdyyKYnNOYYlm7FbHr/kwSGDiLDaQCLK8K4fKcVjW+QrbeGJOFw7d5D5xWzKzhK
         2bhQ==
X-Gm-Message-State: AOAM530sHMDTOGgrSUN3Z4bh0Vi8xroETEIXrYP9+QEIDoM+4jm1Gv56
        I7YqkxzVyov6mYJrBsRKU08=
X-Google-Smtp-Source: ABdhPJwqSNvyS4GjI+QGP/a7FIEfmDb8n8qMgSIZbujBF1i1aTX14o3KbErC3DQHg6WB2p2+k3Yong==
X-Received: by 2002:adf:e98d:0:b0:1f1:5d2b:eee6 with SMTP id h13-20020adfe98d000000b001f15d2beee6mr9674551wrm.143.1646691870231;
        Mon, 07 Mar 2022 14:24:30 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id u10-20020a05600c19ca00b00389860c6d3asm543321wmq.23.2022.03.07.14.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 14:24:29 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt76: connac: make read-only array ba_range static const
Date:   Mon,  7 Mar 2022 22:24:29 +0000
Message-Id: <20220307222429.165336-1-colin.i.king@gmail.com>
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

Don't populate the read-only array ba_range on the stack but
instead make it static const. Also makes the object code a little
smaller.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 0a646ae51c8d..fb44fc6c78f3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1044,7 +1044,7 @@ void mt76_connac_mcu_wtbl_ba_tlv(struct mt76_dev *dev, struct sk_buff *skb,
 	}
 
 	if (enable && tx) {
-		u8 ba_range[] = { 4, 8, 12, 24, 36, 48, 54, 64 };
+		static const u8 ba_range[] = { 4, 8, 12, 24, 36, 48, 54, 64 };
 		int i;
 
 		for (i = 7; i > 0; i--) {
-- 
2.35.1

