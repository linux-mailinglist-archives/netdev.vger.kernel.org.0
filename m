Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2355657138
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbiL0XdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiL0XcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:32:02 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821D2E09F;
        Tue, 27 Dec 2022 15:30:51 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id l29so13818638edj.7;
        Tue, 27 Dec 2022 15:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=McF1AOS6QwVXZqqI+7NbwxhtVPi8mPQbEHxTHJxarjk=;
        b=FVm188ZTXuV2jmAwc9cBA5aHf7MS1964Wf+mL4JXLleaV3hEMyfyub4njJRtDt2GAW
         sm69wDymK8e9f4v+CFzRyxLjZhRwBvZlzMmLzgPNH8C/ze8FwseBKbuRU3EeHLxgxazf
         T6dgtkR7AUrMbjO4C6lEocpFOi3OBKIoBL/3Br6uhbCIpFPkYKx7m6mDipaPrr9+hD6E
         10WvwO7HdK4FJPPAIQEgxKRoOQcGvLTK1kurODLlH7IdsI2vLSQ+/Rxc6o+WIYUKGUpX
         ISX1QwJmt7kSqymq2sC4fH74R/UAuPKUV0IvglBEW1MFbVQfdz+1E1eCgLv+1a8BB8EH
         hbHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=McF1AOS6QwVXZqqI+7NbwxhtVPi8mPQbEHxTHJxarjk=;
        b=PvkfwLpzJu0eAmCWe906wBGlqlNTLSHFaOLBBGlDujw6yZ2jAuLzIpJaIZki6Pkkv+
         iVyTZRLJx6oLwPsFKB1btgza0SqqYq9gSNYgRrVCdPI+sMnwxc6NsRnCTRPqBRIUiYrU
         d1LgkXjRCghRdpDhsfPnKGHQovB+/Y+Jgjf5P9bdlLo+hTUkhaPKbotsdK9d4rud1YjF
         q0bFfNHI5AITOHFI99yxK9Jiy8a0RFj128XTtiDkCo29FGWkdkzFl1EJxwi4yfBhvN7A
         qrG/lYLBPOmKB/1mkrhVAk4uMCSdLKlY6UNLMLT+JUC5ecBs0ezhFzGTw0e9bbhO7+bj
         csPw==
X-Gm-Message-State: AFqh2kq6yZEtlIAYy+vnbzVJcE8v+ltU3PWCpKyxKN2tt3BOrWoEEKcQ
        XYriQcU/xBBD+wFoBYJBpaa8bTFu9A0=
X-Google-Smtp-Source: AMrXdXt418wFHFd2OaJxi+aMmLUL2V901glOQf0Al75txCCmR4Br+zSfiZKNF2o0LDfOOiKtsLMx7A==
X-Received: by 2002:a05:6402:220e:b0:483:a6d8:7ad with SMTP id cq14-20020a056402220e00b00483a6d807admr9248193edb.24.1672183849761;
        Tue, 27 Dec 2022 15:30:49 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4cf-d900-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4cf:d900::e63])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7c147000000b0046cbcc86bdesm6489978edp.7.2022.12.27.15.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:30:49 -0800 (PST)
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
Subject: [RFC PATCH v1 15/19] rtw88: main: Reserve 8 bytes of extra TX headroom for SDIO based cards
Date:   Wed, 28 Dec 2022 00:30:16 +0100
Message-Id: <20221227233020.284266-16-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
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
 drivers/net/wireless/realtek/rtw88/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 9435cb43d1dc..bcdf1f8c8450 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -2161,9 +2161,11 @@ int rtw_register_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw)
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
2.39.0

