Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742586D87BD
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbjDEUHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbjDEUHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:07:44 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA014EEE;
        Wed,  5 Apr 2023 13:07:42 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id eg48so143883584edb.13;
        Wed, 05 Apr 2023 13:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680725261;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pVt1Hg2y+1LDZ/2pY/O4ZqeMD6lt6NR+npC2QpYr9Ek=;
        b=UQEMiKWiIVAlrWUJ7nA6Bzyg0Phv0/wfXfQOc3IbWR7U9xjLfkA0U1SZd47xW4fTOo
         bb27OdXg2jbA3fT0bVkGi8YYRhmRD5cazJhhz6zy3E9fZGe64m8l8fChrXFAhAddaCDl
         JOoZVhm5o5mpGn27b+KUff3fLMllF7Lyx+ghQIOAPZgbh53mqzYAj1qr2ZFMPajhH6KM
         r+PjmnwahxVsAM97JwFVLsP+R/aDZYaOPax3oOUiPxdJu2r0/1iSQgOygFe0ukeDG95s
         sWiADkzc0QNVLbn8UaI+fm84wgJyeKsqsHp9hwtIgA59OonYPi5JDwUjK2ysHJL1xAX9
         emRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680725261;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pVt1Hg2y+1LDZ/2pY/O4ZqeMD6lt6NR+npC2QpYr9Ek=;
        b=pwiZqTS/5ESQIBWCLxvdcB8pu7NWYiyLo0dgbgjyKImwC0QuhTuzMDNd5DdIEraKhF
         rEe/qsVEbLW0RCvZej7O/lI7NR2WHI+Dp2/Hz6OZWmD8pIeijneGh7UGmLLv+IvSfZFi
         jgQSiLwgRJyfSUukgE4KEmlGwcokOCKq/i3XIksSmus/NUMXTRbcAO42toJdxnBM5b/n
         /Qm0abt20/7vyqnw04kYk8kSio5RkfcivqzEvf+Mo+GUHxx9VaFMlX+a+tZ2Z9LFNVlg
         NBcK/ZKL/M5OZ7NykAHh275jJqLbtTNBekEkfOZZXJa/oGnsC9fAiGsScxcWwJdXRZzL
         tM7A==
X-Gm-Message-State: AAQBX9cSKmepOrSg5voz7kGB2kXy/FV+BtKXyh+VBDaO2DYlnPLh8Vj5
        ak6jVQR9caE9gdp4jjJ6G75rWWx164ZGlw==
X-Google-Smtp-Source: AKy350Z0O9ks33BinzCFA3+DadRwD/YP5JFFK2DErYwJaRH0ugekZY0JkQm2ttpv67foiywDmmck0A==
X-Received: by 2002:a17:907:20b7:b0:947:630b:35f9 with SMTP id pw23-20020a17090720b700b00947630b35f9mr4015977ejb.74.1680725261208;
        Wed, 05 Apr 2023 13:07:41 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7a4e-3100-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7a4e:3100::e63])
        by smtp.googlemail.com with ESMTPSA id a23-20020a170906369700b0092a59ee224csm7724873ejc.185.2023.04.05.13.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:07:40 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macromorgan@hotmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v5 5/9] wifi: rtw88: main: Reserve 8 bytes of extra TX headroom for SDIO cards
Date:   Wed,  5 Apr 2023 22:07:25 +0200
Message-Id: <20230405200729.632435-6-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230405200729.632435-1-martin.blumenstingl@googlemail.com>
References: <20230405200729.632435-1-martin.blumenstingl@googlemail.com>
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
Changes since v4:
- none

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

