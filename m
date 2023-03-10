Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82B46B51E8
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbjCJUaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjCJU3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:29:52 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576441184E8;
        Fri, 10 Mar 2023 12:29:51 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id ec29so25431480edb.6;
        Fri, 10 Mar 2023 12:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1678480189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UUBD7rch99GMOQyL8Ae2f+UXvjRNBjvU/Ii+k39kGW4=;
        b=pahbYhYVKtx4elU1fingL0craRTW24JnUiCmt9nB5HWonJagZJMdQNondYWBZoE0fE
         x+/gkCnMx/eqI1EO7jcMPc/0atU+kJK1u/GVMJEi8ES3yA+TffjOCuuTYxBG3tGm2vax
         Eb/rFACvyRMjZ27SAbQGDGkUzbh3gbNtezNDW0wza6SodoklNAKl8KCbCQAERR7wiO36
         SWNMmKVEName8pqmHEI68fe03vLMKIsO/TGF3M4ovmgdNUOrzOhAnE3vMjmI8dWj5Qej
         dknuhEYTQaeB3DcqCX4wDhuinl2KeOnkdehZb6v7Zhjoz98AJ2EhwzcXQ9FH1sJRpoea
         nQww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678480189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UUBD7rch99GMOQyL8Ae2f+UXvjRNBjvU/Ii+k39kGW4=;
        b=NA/Eov3vGaPoYixcgAglYPcZCuFCT5v0uVSaV73Ael1BuGAICOVSNxSVgvcGBy7dj6
         LOLpojn65p2usICUU7uwT/eDXiZqlAo4oF6KNE+nEN4ib0GnMUx5BBWyauiGjYrVjBlC
         bAq9TfrTaTy5Btyi8abnwYudCzEukTAKQVl46FX4tPnAUIKtzcBOfRd34knJtWerqZ7g
         lUE/Pu9jwxI5Opql+AY46FtlpkgTMyKMRs0bpg5qV7tCG8orY09GloWMnhbI0iUtMhnF
         QIMOoHnzes0xigdm2rtoatEsiz7vgACk1TR/EByBjIlFns0o6tNi2UcurkBvEsFh9Vi6
         f18A==
X-Gm-Message-State: AO0yUKXiH0Kqa1hyBbnZ9iOQoYQ9VIhGvtaiX9qy9d6TnqNKZ4R7haEJ
        /t/29DzCFYtbaHMNFqn2WNmhzyrD6rU=
X-Google-Smtp-Source: AK7set860vu+evJ0vxvCcU02HsjApoUIPQfc2lSNA9tNx2TXzMorpqE1vL5VW2OwSBG1BC8GA5qnOg==
X-Received: by 2002:a17:906:1604:b0:879:bff:55c with SMTP id m4-20020a170906160400b008790bff055cmr29224358ejd.1.1678480189589;
        Fri, 10 Mar 2023 12:29:49 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b84f-c400-0000-0000-0000-079c.c23.pool.telefonica.de. [2a01:c23:b84f:c400::79c])
        by smtp.googlemail.com with ESMTPSA id md10-20020a170906ae8a00b008e34bcd7940sm259047ejb.132.2023.03.10.12.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 12:29:49 -0800 (PST)
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
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 RFC 5/9] wifi: rtw88: main: Reserve 8 bytes of extra TX headroom for SDIO cards
Date:   Fri, 10 Mar 2023 21:29:18 +0100
Message-Id: <20230310202922.2459680-6-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
References: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
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
2.39.2

