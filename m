Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB786B51E4
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjCJU37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbjCJU3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:29:49 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BF0E4C51;
        Fri, 10 Mar 2023 12:29:48 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id da10so25504988edb.3;
        Fri, 10 Mar 2023 12:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1678480187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o0INBobV4GwzJU+2C5ZKefRu5gWfU+5TEJBFfZ4U1UU=;
        b=j4i8O5l4HOkk8sr61CMqnbLEssp8e+Y//lV7yYjV7v6rioPWc8vD5rVMx11S2WSGY+
         tN9tMsfeu+4sE5dbIo9XsEDpWXXs4BnsEGhE7hy2muvtkmvoYRgDpuKjGQ+xntNJEeDL
         jl5eQS0O+r0zo6pE1sP3RashjR08DjqrgHBDZPi7Zrgt7pwjRzBJtGN1ryR6LFnNlx5p
         +AHeGqVRObQQlR1mdaKNpeFaxf3/b5gCYQhW/x0IYQP0MGwRUFrB9SjLJmjOzi1YMrYk
         /iuYrLTEwXWPMsuoJIBAOGF05zy0l1NwZgLBY1qbvmw8a+Qz/MC/U6IM+LBtr01poNCp
         tM3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678480187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o0INBobV4GwzJU+2C5ZKefRu5gWfU+5TEJBFfZ4U1UU=;
        b=RJ6lt7/5RyUt5BUYYHDEV419fPlbAM3m77sRevX2pcA2rZlIjukFclHGMufuYR43Ma
         FqL4ECHeNTY67w+ncrNYQL3PJbLCiJDiaR+foAh7SuNmqghUoGtRvTEb80/MSru0xurn
         N56vGbfnwWNpJLAXGgtihCIJ4+iFPtrHoZA18dHEGGVuW7nSmcy1WKs11f5b6NdSN64i
         eZgNaY0g0uFTNWudRgrWn8itzB1i7txsGErl9GN243cTeDPl4gtOafAvZpFpG30lk/Vk
         4ASM1AMH6frOSFTpcxjMyf3gDt6XApKtUVcdcOrgsjlQ9YSAyrLGieeUtMd4fKF6DUaU
         af8w==
X-Gm-Message-State: AO0yUKWP8TuyXO508izdo6GtkeAmoaMZLyMesAQ1J65mkhocb9UNNaTi
        p0f4aI+xSVj+4jzCSF+J+SYRkGXAREw=
X-Google-Smtp-Source: AK7set+Bg4/V7lZG92qSah8mhbwZcz5UMKYxH9tKZAkVUVo7wv2kf5SKzbi/gDexx2SADxGRBNyh7Q==
X-Received: by 2002:a17:906:1604:b0:8ef:fd8:9d04 with SMTP id m4-20020a170906160400b008ef0fd89d04mr22901668ejd.27.1678480186799;
        Fri, 10 Mar 2023 12:29:46 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b84f-c400-0000-0000-0000-079c.c23.pool.telefonica.de. [2a01:c23:b84f:c400::79c])
        by smtp.googlemail.com with ESMTPSA id md10-20020a170906ae8a00b008e34bcd7940sm259047ejb.132.2023.03.10.12.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 12:29:46 -0800 (PST)
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
Subject: [PATCH v2 RFC 3/9] wifi: rtw88: mac: Support SDIO specific bits in the power on sequence
Date:   Fri, 10 Mar 2023 21:29:16 +0100
Message-Id: <20230310202922.2459680-4-martin.blumenstingl@googlemail.com>
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

Add the code specific to SDIO HCI in the MAC power on sequence. This is
based on the RTL8822BS and RTL8822CS vendor drivers.

Co-developed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v1:
- only access REG_SDIO_HIMR for RTW_HCI_TYPE_SDIO
- use proper BIT_HCI_SUS_REQ, BIT_HCI_RESUME_RDY and BIT_SDIO_PAD_E5
  macros as suggested by Ping-Ke


 drivers/net/wireless/realtek/rtw88/mac.c | 46 +++++++++++++++++++++---
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index cfdfc8a2c836..17704394cca3 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -7,6 +7,7 @@
 #include "reg.h"
 #include "fw.h"
 #include "debug.h"
+#include "sdio.h"
 
 void rtw_set_channel_mac(struct rtw_dev *rtwdev, u8 channel, u8 bw,
 			 u8 primary_ch_idx)
@@ -60,6 +61,7 @@ EXPORT_SYMBOL(rtw_set_channel_mac);
 
 static int rtw_mac_pre_system_cfg(struct rtw_dev *rtwdev)
 {
+	unsigned int retry;
 	u32 value32;
 	u8 value8;
 
@@ -77,6 +79,28 @@ static int rtw_mac_pre_system_cfg(struct rtw_dev *rtwdev)
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
@@ -248,6 +272,7 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
 	const struct rtw_pwr_seq_cmd **pwr_seq;
+	u32 imr;
 	u8 rpwm;
 	bool cur_pwr;
 	int ret;
@@ -273,18 +298,24 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
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
+
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO)
+		rtw_write32(rtwdev, REG_SDIO_HIMR, imr);
 
 	if (pwr_on)
 		set_bit(RTW_FLAG_POWERON, rtwdev->flags);
 
-	return 0;
+	return ret;
 }
 
 static int __rtw_mac_init_system_cfg(struct rtw_dev *rtwdev)
@@ -455,6 +486,9 @@ static void download_firmware_reg_backup(struct rtw_dev *rtwdev,
 	rtw_write16(rtwdev, REG_FIFOPAGE_INFO_1, 0x200);
 	rtw_write32(rtwdev, REG_RQPN_CTRL_2, bckp[bckp_idx - 1].val);
 
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO)
+		rtw_read32(rtwdev, REG_SDIO_FREE_TXPG);
+
 	/* Disable beacon related functions */
 	tmp = rtw_read8(rtwdev, REG_BCN_CTRL);
 	bckp[bckp_idx].len = 1;
@@ -1067,8 +1101,12 @@ static int txdma_queue_mapping(struct rtw_dev *rtwdev)
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
2.39.2

