Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966CB6D525B
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbjDCUZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbjDCUZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:25:29 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308AB3589;
        Mon,  3 Apr 2023 13:24:59 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id l37so17795519wms.2;
        Mon, 03 Apr 2023 13:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680553496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JWBBdl9G7eNDg08iRhOIt/VcT/WgsIEh7WEQyv/DsT8=;
        b=D+4nt1AHx8Ir/OaRwoLCAXA6bJJdYPsRTkGVKIToFj6ZmIOIUZeXKrGbodtlU1SJp2
         MkYEHgdDmD+jbGwQzcD8ZbtAX9r46wJ6dNGonUxnb5dxpoka+OMEUV13lYjrOjpd1r+G
         RfTyUl10RFM0Ki0OBbgUZP4cP9rXQb9dBlnBTwuzB46Nz874v59xGhlVgMg215WxW8c/
         08BnS7e8c2Qdvclc8y/1S/GGD2ozGgL3ILSwZ3IMmOKAplTXGmkNHrO8QO3p97wntqQQ
         ZHkg2bqfdKpEcbSh7RLNM/sCcTek1jMFKwhk6ZwJlu/3mHRdaao00AZKBQoutZx3m9S+
         T0yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680553496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JWBBdl9G7eNDg08iRhOIt/VcT/WgsIEh7WEQyv/DsT8=;
        b=zc5PyIg0xRvwq4LZWSc7V5S1oRX9VqarpNWs0s7gTdJG0V+4+eYA5SnKQjWDPpbDwC
         XFTW3/XHDf6JL3u7Di/tjuxsZheGX5wkPxGlF3GpynfycLB3JwJbNbeHVn5/teTX//w6
         NpEPnHn8PvcTnapaW61eRjmYqFjFFbmCWYN8025j9r4+CjC38AlVYQEy9M/mf2haz5RE
         1H45iIDq+LHSenaFIBudO7miK0Q7PxBG053gZkkAgS8/NLCtdAIRHSawhAap9YL1cvEo
         Emob0MHEYDyj9TXq7753Y8YzaQSENm1623ybp9WU8s451GgiE6WUviYLVCHFfCEBybRl
         VgPQ==
X-Gm-Message-State: AAQBX9eGypXNZF8x+j+Lcc6QwH/nuIwOtKqVZS5bn0SZKoM3MW1dn6RJ
        t09g6WvLiTAwohk9VpUrUeA67dy0+aw=
X-Google-Smtp-Source: AKy350b2n5maNB7jZQRhlj7kQUFCz+7ysyCcjdlcjnHlgxwJPEa99hBIMgbySSXFc3HIqMdVqblCbw==
X-Received: by 2002:a7b:ca54:0:b0:3f0:3c2:3fa4 with SMTP id m20-20020a7bca54000000b003f003c23fa4mr501252wml.12.1680553495881;
        Mon, 03 Apr 2023 13:24:55 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7651-4500-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7651:4500::e63])
        by smtp.googlemail.com with ESMTPSA id 24-20020a05600c021800b003ee1acdb036sm12845895wmi.17.2023.04.03.13.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 13:24:55 -0700 (PDT)
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
Subject: [PATCH v4 3/9] wifi: rtw88: mac: Support SDIO specific bits in the power on sequence
Date:   Mon,  3 Apr 2023 22:24:34 +0200
Message-Id: <20230403202440.276757-4-martin.blumenstingl@googlemail.com>
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

Add the code specific to SDIO HCI in the MAC power on sequence. This is
based on the RTL8822BS and RTL8822CS vendor drivers.

Co-developed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v3:
- add Ping-Ke's reviewed-by (again, thank you!)

Changes since v2:
- add sdio.h include in patch 2 already (instead of patch 3) as
  suggested by Larry Finger (thank you!) so the build doesn't break
  during bisect
- only set RTW_FLAG_POWERON when applying the power on sequence was
  successful (thanks for the suggestion Ping-Ke!)
- fix smatch false positive "uninitialized symbol 'imr'" in
  rtw_mac_power_switch() by initializing imr to 0. Thanks for spotting
  this and for the suggestion Ping-Ke!

Changes since v1:
- only access REG_SDIO_HIMR for RTW_HCI_TYPE_SDIO
- use proper BIT_HCI_SUS_REQ, BIT_HCI_RESUME_RDY and BIT_SDIO_PAD_E5
  macros as suggested by Ping-Ke


 drivers/net/wireless/realtek/rtw88/mac.c | 47 +++++++++++++++++++++---
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index 2fcba43a6f72..44e07b61b9b9 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -61,6 +61,7 @@ EXPORT_SYMBOL(rtw_set_channel_mac);
 
 static int rtw_mac_pre_system_cfg(struct rtw_dev *rtwdev)
 {
+	unsigned int retry;
 	u32 value32;
 	u8 value8;
 
@@ -78,6 +79,28 @@ static int rtw_mac_pre_system_cfg(struct rtw_dev *rtwdev)
 	case RTW_HCI_TYPE_PCIE:
 		rtw_write32_set(rtwdev, REG_HCI_OPT_CTRL, BIT_USB_SUS_DIS);
 		break;
+	case RTW_HCI_TYPE_SDIO:
+		rtw_write8_clr(rtwdev, REG_SDIO_HSUS_CTRL, BIT_HCI_SUS_REQ);
+
+		for (retry = 0; retry < RTW_PWR_POLLING_CNT; retry++) {
+			if (rtw_read8(rtwdev, REG_SDIO_HSUS_CTRL) & BIT_HCI_RESUME_RDY)
+				break;
+
+			usleep_range(10, 50);
+		}
+
+		if (retry == RTW_PWR_POLLING_CNT) {
+			rtw_err(rtwdev, "failed to poll REG_SDIO_HSUS_CTRL[1]");
+			return -ETIMEDOUT;
+		}
+
+		if (rtw_sdio_is_sdio30_supported(rtwdev))
+			rtw_write8_set(rtwdev, REG_HCI_OPT_CTRL + 2,
+				       BIT_SDIO_PAD_E5 >> 16);
+		else
+			rtw_write8_clr(rtwdev, REG_HCI_OPT_CTRL + 2,
+				       BIT_SDIO_PAD_E5 >> 16);
+		break;
 	case RTW_HCI_TYPE_USB:
 		break;
 	default:
@@ -249,6 +272,7 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
 	const struct rtw_pwr_seq_cmd **pwr_seq;
+	u32 imr = 0;
 	u8 rpwm;
 	bool cur_pwr;
 	int ret;
@@ -274,18 +298,24 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
 	if (pwr_on == cur_pwr)
 		return -EALREADY;
 
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO) {
+		imr = rtw_read32(rtwdev, REG_SDIO_HIMR);
+		rtw_write32(rtwdev, REG_SDIO_HIMR, 0);
+	}
+
 	if (!pwr_on)
 		clear_bit(RTW_FLAG_POWERON, rtwdev->flags);
 
 	pwr_seq = pwr_on ? chip->pwr_on_seq : chip->pwr_off_seq;
 	ret = rtw_pwr_seq_parser(rtwdev, pwr_seq);
-	if (ret)
-		return ret;
 
-	if (pwr_on)
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO)
+		rtw_write32(rtwdev, REG_SDIO_HIMR, imr);
+
+	if (!ret && pwr_on)
 		set_bit(RTW_FLAG_POWERON, rtwdev->flags);
 
-	return 0;
+	return ret;
 }
 
 static int __rtw_mac_init_system_cfg(struct rtw_dev *rtwdev)
@@ -456,6 +486,9 @@ static void download_firmware_reg_backup(struct rtw_dev *rtwdev,
 	rtw_write16(rtwdev, REG_FIFOPAGE_INFO_1, 0x200);
 	rtw_write32(rtwdev, REG_RQPN_CTRL_2, bckp[bckp_idx - 1].val);
 
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO)
+		rtw_read32(rtwdev, REG_SDIO_FREE_TXPG);
+
 	/* Disable beacon related functions */
 	tmp = rtw_read8(rtwdev, REG_BCN_CTRL);
 	bckp[bckp_idx].len = 1;
@@ -1068,8 +1101,12 @@ static int txdma_queue_mapping(struct rtw_dev *rtwdev)
 	if (rtw_chip_wcpu_11ac(rtwdev))
 		rtw_write32(rtwdev, REG_H2CQ_CSR, BIT_H2CQ_FULL);
 
-	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_USB)
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO) {
+		rtw_read32(rtwdev, REG_SDIO_FREE_TXPG);
+		rtw_write32(rtwdev, REG_SDIO_TX_CTRL, 0);
+	} else if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_USB) {
 		rtw_write8_set(rtwdev, REG_TXDMA_PQ_MAP, BIT_RXDMA_ARBBW_EN);
+	}
 
 	return 0;
 }
-- 
2.40.0

