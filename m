Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC45E65712C
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbiL0Xc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbiL0Xb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:31:29 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027ABE02F;
        Tue, 27 Dec 2022 15:30:49 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id c17so20833998edj.13;
        Tue, 27 Dec 2022 15:30:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z1azAtpeEKYDc3NsUxyyhrkCkOfc9fkFfo7oykDXpuo=;
        b=XlGMCT0G2gcvou7A9Uz3FQJacwyUgb1Zz5lAyFoZzyZHCj1HKXqd+/VkL80XXWWrRJ
         SVsmc35bG4CZMUFjWlknxhSyXoMi0KWKe2VP0Zho3Y7CU6Xk7NliivisFCzVOOs8NlGQ
         Y0zNWolAgXyiIKDs26GR7w7hct40DjTv0GzA+YgZLLtglN0cWduBlAOziEajdQ44u8bC
         TeJuBAJQgs39nuwxrriA2O9KS5UQYldzGB5e3Qo9+CHpcajWmj/fcoUV46vc4nMBFN4t
         rtvMi1t1azNEkEGqD7iSN8wjhJdspfYH8PfehG1RwOox+e0+Lcu8ESu7ZDUTTa6ayi3v
         61kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z1azAtpeEKYDc3NsUxyyhrkCkOfc9fkFfo7oykDXpuo=;
        b=6TSN+AtHBQvF2axE+sBzP/WZdXUWdQJ6OF0inkKj66AQNsfurIYglv2+6Z2pMLfD9d
         FEd62EBhWYabGms2LWfh2lLd03sgvTXfGVWa+LuFMPR84MBZqgVsyrcEQErxRft2/dp8
         HytKwmX9XuOLaGbCsDpxY2ZuUvMaffqYZcl/lUY3WnxXibVDocFHquTpVhSluub1iI6o
         WxcL2T7VmkNSlgtC9RDl0QIXM1thUBCi6XhhW0gJBOz5BdPZZ1ykLq/h+CSOn3BqcWYv
         99QyfiS6yjoZAqL3j0OX+D2SQbB3bl2FD1mbbXaz9EHfkFD00gO8m6DN/bkES0RUb23R
         vUtQ==
X-Gm-Message-State: AFqh2kreKyCx11dR2mEx05XQBJhSAGI/nokM4q+fAaDBkiWF4LLuLKls
        aRzcZQVUtCxz0EHG+IPB8EUSan4ubqs=
X-Google-Smtp-Source: AMrXdXviXpG2jnGIM6KWSd7+hKRFh7JMbeSihF1O6ETNZdqhS0oAdWefk7N0xooLLUxc3msgYlPS0w==
X-Received: by 2002:a05:6402:282:b0:480:c06:2833 with SMTP id l2-20020a056402028200b004800c062833mr15317548edv.38.1672183847852;
        Tue, 27 Dec 2022 15:30:47 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4cf-d900-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4cf:d900::e63])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7c147000000b0046cbcc86bdesm6489978edp.7.2022.12.27.15.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:30:47 -0800 (PST)
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
Subject: [RFC PATCH v1 13/19] rtw88: mac: Add support for SDIO specifics in the power on sequence
Date:   Wed, 28 Dec 2022 00:30:14 +0100
Message-Id: <20221227233020.284266-14-martin.blumenstingl@googlemail.com>
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

Add the code specific to SDIO HCI in the MAC power on sequence. This is
based on the RTL8822BS and RTL8822CS vendor drivers.

Co-developed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/mac.c | 41 ++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index 8e1fa824b32b..ad71f9838d1d 100644
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
 
@@ -77,6 +79,26 @@ static int rtw_mac_pre_system_cfg(struct rtw_dev *rtwdev)
 	case RTW_HCI_TYPE_PCIE:
 		rtw_write32_set(rtwdev, REG_HCI_OPT_CTRL, BIT_USB_SUS_DIS);
 		break;
+	case RTW_HCI_TYPE_SDIO:
+		rtw_write8_clr(rtwdev, REG_SDIO_HSUS_CTRL, BIT(0));
+
+		for (retry = 0; retry < RTW_PWR_POLLING_CNT; retry++) {
+			if (rtw_read8(rtwdev, REG_SDIO_HSUS_CTRL) & BIT(1))
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
+			rtw_write8_set(rtwdev, REG_HCI_OPT_CTRL + 2, BIT(2));
+		else
+			rtw_write8_clr(rtwdev, REG_HCI_OPT_CTRL + 2, BIT(2));
+		break;
 	case RTW_HCI_TYPE_USB:
 		break;
 	default:
@@ -248,6 +270,7 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
 	const struct rtw_pwr_seq_cmd **pwr_seq;
+	u32 imr;
 	u8 rpwm;
 	bool cur_pwr;
 
@@ -278,12 +301,19 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
 	 */
 	rtw_hci_power_switch(rtwdev, false);
 
+	imr = rtw_read32(rtwdev, REG_SDIO_HIMR);
+	rtw_write32(rtwdev, REG_SDIO_HIMR, 0);
+
 	pwr_seq = pwr_on ? chip->pwr_on_seq : chip->pwr_off_seq;
-	if (rtw_pwr_seq_parser(rtwdev, pwr_seq))
+	if (rtw_pwr_seq_parser(rtwdev, pwr_seq)) {
+		rtw_write32(rtwdev, REG_SDIO_HIMR, imr);
 		return -EINVAL;
+	}
 
 	rtw_hci_power_switch(rtwdev, pwr_on);
 
+	rtw_write32(rtwdev, REG_SDIO_HIMR, imr);
+
 	return 0;
 }
 
@@ -450,6 +480,9 @@ static void download_firmware_reg_backup(struct rtw_dev *rtwdev,
 	rtw_write16(rtwdev, REG_FIFOPAGE_INFO_1, 0x200);
 	rtw_write32(rtwdev, REG_RQPN_CTRL_2, bckp[bckp_idx - 1].val);
 
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO)
+		rtw_read32(rtwdev, REG_SDIO_FREE_TXPG);
+
 	/* Disable beacon related functions */
 	tmp = rtw_read8(rtwdev, REG_BCN_CTRL);
 	bckp[bckp_idx].len = 1;
@@ -1062,8 +1095,12 @@ static int txdma_queue_mapping(struct rtw_dev *rtwdev)
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
2.39.0

