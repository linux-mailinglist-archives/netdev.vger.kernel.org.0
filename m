Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783FA6C23DE
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 22:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbjCTVgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 17:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbjCTVgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 17:36:09 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123DBA24A;
        Mon, 20 Mar 2023 14:35:28 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id eg48so52246656edb.13;
        Mon, 20 Mar 2023 14:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1679348125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wCH40GOhGcrwZBpQuXJd0pp0aW1no1xxPydO+tFyDPs=;
        b=YRCnC7DPQMO2Mv0Zy+0KTWvCEzk3druYDtI7aF7Djuepodl/MWaIB/BeXnm83nCzBz
         z2OVuvB/pz/QJFTY2WXhVEiQysAy/03+QYVxFNPlSA4Ltti7NtMyPUKTHaDUbNNXQCHq
         dMngPOv6RQ8xh9+bZNSJrnQptF0dyCdyfwpOTSKpSMEO4RkOdh98/3PJLHYi8RCgUth7
         Ur0hOv7qL2TesjmNawOpYlTkC423x4Qod93zwjweM9LiOeyfaTMA4kDzCLrzcP1aUTP/
         Btib/6vOTOxjUKSbjy0UelqiAzg/DthfGrPzJUdqPHU88ttYowQDP3M2R1HH6QbQNIPE
         Wn2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679348125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wCH40GOhGcrwZBpQuXJd0pp0aW1no1xxPydO+tFyDPs=;
        b=3QG4++fZKdp2/NNeg6T/ieBBJVjRmcq4xxgJvATf50JEVZWRctsUfRYw0lWSD4jydb
         yueiF3/zk1xYZpzy9yYcqsbzhzutW3qL4JkSUGvNspp90aDDfYr27yD2oDQQlLRsNvU9
         RoNbVwqLd/f9h22bBT39N4xQiN7GjE49gSmkqjsJ1PIS3k0Hy3AlV8xT2uXu6jjoCjup
         UEiI3lz/g6DXNkQ8fCOKhkdwO1DUWnT3HPO86WC2VYcxEhvQjOkskSK8UnrJq2IWHp5k
         Fcn8yz8WjO6xWK5FC/nRAmtGQFNWOtnptFPnt5In6U3M1EQHr9sK0bLyHf+u4YCshRc5
         GpjA==
X-Gm-Message-State: AO0yUKUPcFty/CahWedI90HNGVoRrAN4Y9/19hxs+5W8LChfv0mDhESt
        gu4tIv7UGD/tEc+7sNdOhOVKCyMoSK4=
X-Google-Smtp-Source: AK7set9luSTY1niuZygkgUfk3kHjcPov9sCX9Hn3+2YPa7Y/WaRDwkJ9QGaa0egvwPvw2jIrFLLE+g==
X-Received: by 2002:a17:906:a098:b0:933:12d1:d168 with SMTP id q24-20020a170906a09800b0093312d1d168mr573640ejy.10.1679348125533;
        Mon, 20 Mar 2023 14:35:25 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-73dd-8200-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:73dd:8200::e63])
        by smtp.googlemail.com with ESMTPSA id z17-20020a5096d1000000b004aee4e2a56esm5413201eda.0.2023.03.20.14.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 14:35:24 -0700 (PDT)
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
Subject: [PATCH v3 3/9] wifi: rtw88: mac: Support SDIO specific bits in the power on sequence
Date:   Mon, 20 Mar 2023 22:35:02 +0100
Message-Id: <20230320213508.2358213-4-martin.blumenstingl@googlemail.com>
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

Add the code specific to SDIO HCI in the MAC power on sequence. This is
based on the RTL8822BS and RTL8822CS vendor drivers.

Co-developed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
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

