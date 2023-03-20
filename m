Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62ED76C23E4
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 22:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjCTVge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 17:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjCTVgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 17:36:11 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B744413D54;
        Mon, 20 Mar 2023 14:35:30 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id h8so52326584ede.8;
        Mon, 20 Mar 2023 14:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1679348127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pAqmA3HhSn5qzyU/VrL6gyfJOdARmRtdcfXfrm+JOHQ=;
        b=YJWugPH4B8sEXYvv0rEqr4rN0k6vTyouvs4MfchNdJLwh/S7Z2gfGPfXTA2gvfUjr4
         QGxv/dfwDe/jtoo8hkefB1iIob7CGBRzNWtxOCl2agtjEm3A9yP9G/1SrSjF7T+blGaO
         pFhy18P03jNTnrLOFrv3VNp+DCP/xHGATsxhVLqyG8Op4nQ3ALDw6GBuAowZ02PSq2AV
         UMq9uaM31GTq8nCric6XwkE7sS2UGlrVnzfZgyXTp3FX5TUCxyMHYu6AxwALYPGPyw16
         D6UySlPYHfD0c+pWhiiXUXngitEDz2N/9rP13pWJUOB/p2hmz+vtqbkB52uWKjpM9bcT
         kp0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679348127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pAqmA3HhSn5qzyU/VrL6gyfJOdARmRtdcfXfrm+JOHQ=;
        b=AK7e2ykwqkxGFF9x2n4PNt+uQ1F02BArjXk2pXCRqLFg1Vy9W3mw5uPhrz0dLSExAf
         mTg7RgHqs6bb57Fql6GeqvYqIc8WRkwsbLUeigNIhafECe9xAOMLPMKhd9BIeRhRt/6+
         0N8DcaOFrVFiXGKxBJgczWsyV5i9EDzhpgVNLy946EBjFX6gXDsXWpjaEMF8vDmtBG2G
         3qS6ihkReNSTA3G+e0L3Nfbywk5N08Tsmmbj9lhNef28HFvjZ0dDmaaGtFnyrcGWl4Fc
         VV5uNxZuOaAiQZ55OWEsE6mC2SMJZvfZp57vq88QQgJNh2Op1oCDqRzhiTf6S/CJ0eEl
         Vhsw==
X-Gm-Message-State: AO0yUKWYv6Cvo+cC4eQBUUHL1Z+b+vyTISx89Itd16SlqZyM2TbqxiW/
        9CCZsbBm0BwaYh5uSsQLDXFbjMvCixQ=
X-Google-Smtp-Source: AK7set/B6rUfC2mkYILiOgAhZQ0AIkRSSjMsgPaNKsldHyMHxGl1Egz8cBSBIrWsZMWaf3Mt9T/MFA==
X-Received: by 2002:a05:6402:148e:b0:4fa:4a27:adba with SMTP id e14-20020a056402148e00b004fa4a27adbamr966700edv.22.1679348127539;
        Mon, 20 Mar 2023 14:35:27 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-73dd-8200-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:73dd:8200::e63])
        by smtp.googlemail.com with ESMTPSA id z17-20020a5096d1000000b004aee4e2a56esm5413201eda.0.2023.03.20.14.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 14:35:27 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 5/9] wifi: rtw88: main: Reserve 8 bytes of extra TX headroom for SDIO cards
Date:   Mon, 20 Mar 2023 22:35:04 +0100
Message-Id: <20230320213508.2358213-6-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320213508.2358213-1-martin.blumenstingl@googlemail.com>
References: <20230320213508.2358213-1-martin.blumenstingl@googlemail.com>
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

For SDIO host controllers with DMA support the TX buffer physical memory
address need to be aligned at an 8-byte boundary. Reserve 8 bytes of
extra TX headroom so we can align the data without re-allocating the
transmit buffer.

While here, also remove the TODO comment regarding extra headroom for
USB and SDIO. For SDIO the extra headroom is now handled and for USB it
was not needed so far.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v2:
- none

Changes since v1:
- none


 drivers/net/wireless/realtek/rtw88/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index cdc4703ead5f..1cb553485cff 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -2163,9 +2163,11 @@ int rtw_register_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw)
 	int max_tx_headroom = 0;
 	int ret;
 
-	/* TODO: USB & SDIO may need extra room? */
 	max_tx_headroom = rtwdev->chip->tx_pkt_desc_sz;
 
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO)
+		max_tx_headroom += RTW_SDIO_DATA_PTR_ALIGN;
+
 	hw->extra_tx_headroom = max_tx_headroom;
 	hw->queues = IEEE80211_NUM_ACS;
 	hw->txq_data_size = sizeof(struct rtw_txq);
-- 
2.40.0

