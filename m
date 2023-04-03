Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B136D525E
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbjDCUZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjDCUZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:25:30 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0133B40F0;
        Mon,  3 Apr 2023 13:24:59 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id m6-20020a05600c3b0600b003ee6e324b19so18830301wms.1;
        Mon, 03 Apr 2023 13:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680553497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BvOl5JhylfoaBnxuZm+cl3/vdE7xXTn5p5ikGyOF0OA=;
        b=DVYQIl2xyCqggv68+Llg7ZNfsyHdigv07Xt+ZVU5MiARHPTc4QaEQc91aCprVMA7vS
         IsqoWK8FmcGf295PXB0GBEZ2U12brNVl0szKJZgPD5Yhr407fFgigParY1S5ouQ6HyCV
         0PS/W5lXrBqURKFSI8fAVlkzNoOSoiz+UbgKvJMdCDFC616vGEJUhd5U3IKXOrU+RekN
         raIUjfN5xqThHoHwqOJesr3CUsqVoejsCAZruXqNrUbU0MXbHz9H1+r/OnjYpYPUrJzy
         o3GkjUzs38q0DebnfeEuHV/0GUQT0QZBpP7QiVYqFK6VHL5SCWMYJShjCTpCod2j6mfH
         lKuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680553497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BvOl5JhylfoaBnxuZm+cl3/vdE7xXTn5p5ikGyOF0OA=;
        b=WXXbSHx88NKo74t7lJ/0lN8fxE8aFIoPixdxTRXWs5RA7scXNlH45ghM8D/lWAmmoR
         Et+Ti8QOTFEwhe3apIJoIQI+I14JoCLvCCoMYgO6x4fbIHczeSTkKQgbRxfo2TdrEXc4
         mio2y59BEnNV9QjseMIKilb9xT556n4tnKqJ5/k/xdSXDBTJJlRk5ohgiIiDwD8ALROa
         2dGXYmppK8CHrGtVJpzvOtEUfLgt+/vk1XqA+0Pdb8cMW52Ub9LGbkj+wgzkzxfKVevM
         KQUNwSjRXMrs6aUJ9zQRznBeA36kIGUmZ5MW036vx0HhNqSvFJTMvB8NIju9gHItu2iA
         y/rw==
X-Gm-Message-State: AAQBX9fGCjpYm4JA8F9yb3LGGuk0IfxVLF+60Myar4iXCbVipjBMWryM
        hxpV0ADZBeVlNkClA24/VpX34LjMppI=
X-Google-Smtp-Source: AKy350ZKXN3d3l3H6E+XvY4mpnVqyxzJSDZFoaKfAk2uIPJPzrvWwkZHgWdO9MJZI0MZIHoe0ZNxHA==
X-Received: by 2002:a7b:c8c3:0:b0:3f0:5074:efa7 with SMTP id f3-20020a7bc8c3000000b003f05074efa7mr473798wml.14.1680553497697;
        Mon, 03 Apr 2023 13:24:57 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7651-4500-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7651:4500::e63])
        by smtp.googlemail.com with ESMTPSA id 24-20020a05600c021800b003ee1acdb036sm12845895wmi.17.2023.04.03.13.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 13:24:57 -0700 (PDT)
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
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v4 5/9] wifi: rtw88: main: Reserve 8 bytes of extra TX headroom for SDIO cards
Date:   Mon,  3 Apr 2023 22:24:36 +0200
Message-Id: <20230403202440.276757-6-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403202440.276757-1-martin.blumenstingl@googlemail.com>
References: <20230403202440.276757-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v3:
- add Ping-Ke's reviewed-by (again, thank you!)

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

