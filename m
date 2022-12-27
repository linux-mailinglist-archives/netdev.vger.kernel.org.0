Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36F565711A
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbiL0XbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbiL0Xaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:30:55 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8392BDED6;
        Tue, 27 Dec 2022 15:30:45 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id r26so15660520edc.5;
        Tue, 27 Dec 2022 15:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P3w67rXYb4ve8I5B5m+YRlvZDv2zR1R4FBsmmtE/Ozc=;
        b=ij2yiiak3n1tbzP0a4ZRCOYWftMiGqXaFkS/INqNNpDGY65+9PvFg7KZShqKx9azIA
         QlDHFUs0ax10yOWKAXOiisG8EGBT1OKPDSleEgIYXuFA1ACblgIPv+pRl9WgjbTpw/z7
         ZlPD/iBf41KZOHP7su1h5w5oeBmknkU+IuetVJiJgABN79qAF8r+5UwwE9aMnC5J2VEi
         spcgfQ1WgoIQGYlHDVihThvHe7kuMIlfdzAd6tt74k5UQ0WpgqGGdCjFmR9CjfAfY9yH
         SUwrDITzciL3rNiW8nTw12TUjjvCti8Au3jlUjm4SSHkCO7Aco+wOCe+i71l1Is1hKPP
         rbBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P3w67rXYb4ve8I5B5m+YRlvZDv2zR1R4FBsmmtE/Ozc=;
        b=ITbvyGZLHVQlUoBRfS+oiX+RiQTrnJIm0T7hmfvtyDuzcBV2yfqr9HLbZF1AgJJlK0
         yL9sFxmAkjCHU0xr03rbeNKaJ5VAGcrJLJKhv8XR+df1wV+eVLcqxCvxl2L04nKA774q
         LiLAg9/xeRrfZA8Jin/y9Mbalk4uX0ivtaji1Wqz5fSkFQ4ZvIug2IHLOisUKHEJT9fE
         Eo41RSbIT9CfzwkO0WdvqM6UZ1rRkj5qLhkZP5jP8G9/fJGhJRTLnSChprIpm1uq+Q6U
         3lGkm63/k0oVhX5XG4SeqxOm8KX1kOxr1cTl+xKo3v7osJzjtExTbtIjFAbaxhHTR+fz
         WEvg==
X-Gm-Message-State: AFqh2kqf2CrZEKx7FxMFNs0CDq1XDfFgZc9dA+aXSd+i+L+WkepoVVmc
        hG8wsnCV24unckpLD7vq63FtuS4d7CY=
X-Google-Smtp-Source: AMrXdXuZuZZ7LwRM5nmqIXSaJ14M6sThRtWPouK1QxqOssAmKEQQESQFbRVXVZ7rsppPlDHbBG6ngw==
X-Received: by 2002:aa7:d8da:0:b0:474:5de4:a5d1 with SMTP id k26-20020aa7d8da000000b004745de4a5d1mr24070817eds.39.1672183843624;
        Tue, 27 Dec 2022 15:30:43 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4cf-d900-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4cf:d900::e63])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7c147000000b0046cbcc86bdesm6489978edp.7.2022.12.27.15.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:30:43 -0800 (PST)
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
Subject: [RFC PATCH v1 09/19] rtw88: hci: Add an optional power_switch() callback to rtw_hci_ops
Date:   Wed, 28 Dec 2022 00:30:10 +0100
Message-Id: <20221227233020.284266-10-martin.blumenstingl@googlemail.com>
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

32-bit SDIO bus reads/writes only work when the card is powered on. Add
an optional power_switch() callback to struct rtw_hci_ops where we
inform the HCI sub-driver that the chip is now powered on. Based on this
information the upcoming SDIO HCI implementation can then use the
appropriate 32-bit read/write accessors.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/hci.h | 8 ++++++++
 drivers/net/wireless/realtek/rtw88/mac.c | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/hci.h b/drivers/net/wireless/realtek/rtw88/hci.h
index 830d7532f2a3..602a6acc1ca1 100644
--- a/drivers/net/wireless/realtek/rtw88/hci.h
+++ b/drivers/net/wireless/realtek/rtw88/hci.h
@@ -22,6 +22,8 @@ struct rtw_hci_ops {
 	int (*write_data_rsvd_page)(struct rtw_dev *rtwdev, u8 *buf, u32 size);
 	int (*write_data_h2c)(struct rtw_dev *rtwdev, u8 *buf, u32 size);
 
+	void (*power_switch)(struct rtw_dev *rtwdev, bool on);
+
 	u8 (*read8)(struct rtw_dev *rtwdev, u32 addr);
 	u16 (*read16)(struct rtw_dev *rtwdev, u32 addr);
 	u32 (*read32)(struct rtw_dev *rtwdev, u32 addr);
@@ -84,6 +86,12 @@ rtw_hci_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
 	return rtwdev->hci.ops->write_data_h2c(rtwdev, buf, size);
 }
 
+static inline void rtw_hci_power_switch(struct rtw_dev *rtwdev, bool on)
+{
+	if (rtwdev->hci.ops->power_switch)
+		rtwdev->hci.ops->power_switch(rtwdev, on);
+}
+
 static inline u8 rtw_read8(struct rtw_dev *rtwdev, u32 addr)
 {
 	return rtwdev->hci.ops->read8(rtwdev, addr);
diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index 4e5c194aac29..bf1291902661 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -269,10 +269,18 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
 	if (pwr_on == cur_pwr)
 		return -EALREADY;
 
+	/* Always signal power off before power sequence. This way
+	 * read/write functions will take path which works in both
+	 * states. State will change in the middle of the sequence.
+	 */
+	rtw_hci_power_switch(rtwdev, false);
+
 	pwr_seq = pwr_on ? chip->pwr_on_seq : chip->pwr_off_seq;
 	if (rtw_pwr_seq_parser(rtwdev, pwr_seq))
 		return -EINVAL;
 
+	rtw_hci_power_switch(rtwdev, pwr_on);
+
 	return 0;
 }
 
-- 
2.39.0

