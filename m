Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909F66D87D5
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbjDEUIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233282AbjDEUHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:07:43 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DF94ECD;
        Wed,  5 Apr 2023 13:07:41 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id b20so144000331edd.1;
        Wed, 05 Apr 2023 13:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680725259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KXZeyshZs3mev0CJJsOjbPtdAx/wMGwoGWSp2mfwNFk=;
        b=lqLy9j3WKSdn6q0oj2u6i4m+DQeF0/X9yZDqc/KWjS9BBPnCUEAPHnYte7UYko8Swf
         t/2QGv5mS36uBZKYZFfUz+YeI3lj1YzsyutEbhGe67S6Hw6gFlo/2VN74utPIZ8+HpY9
         mRqsIB5tLKMnAsvm/F5GoGwwhTxbO2gH9WoP3deHuIxJ8NvPkCIaTwPvth6sFVg3yV/B
         3sQ5S5lmH/BT1M+DxofLcsMkNwWK349LFOCL8Qkjx3ZZkGlyhYqmdxXseJuZrbaub+Vb
         p/mjjMUwaIgPeeHJDnqym4OCOrq/rbyEFi3NffZyuajIpuoBYI2GvJWczUzuWfvF1TkZ
         cPbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680725259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KXZeyshZs3mev0CJJsOjbPtdAx/wMGwoGWSp2mfwNFk=;
        b=c/70xqzIqOAgsR7KeMSVdYq8ez2MUMJ8KdW8uZPuiebWF/RRbDWDHfzV6vIcgnnpPl
         21M0FCrHmVsXN68QPK+j9JdaCvUWEPi5h99gjhrqVdQxKX26Y65KV3z+61kmsZPR2G7m
         PEYiicoTsVCKJ/Al9y/4f0EwlF4PCOQeb5iJDSCTn4AZEepyrGmsKezt6jx01sG/AjxR
         PjPGqWFIbSA7gvQKWQFHuYP+b9IEjd5ZrfwKFGPdSNjeGY1SLSnJLaqUutMLj5DI5Ng/
         xXyvL7IBOOK14IR9+aRXLFCU23kMjrOZLaFf/UhZTXNx/C+zu7oB2OdPnY9LxDUAkmZs
         5lOQ==
X-Gm-Message-State: AAQBX9cg5tJRLC20CkoHKOezvN3hNYyqlcuYTip0hzfs5IZPE0+/Q/YR
        RPpfuXVEzBOUO8+nUKu6u1XTLCWzVss4Ag==
X-Google-Smtp-Source: AKy350b+Xu/ZmRNGWn/8ATyjF16sBBzhaVbIoRa+Sj6PCVtSGkaRjnwKCK09mHdM/rvkFGb9xUWtXg==
X-Received: by 2002:a17:906:eca8:b0:8b1:fc1a:7d21 with SMTP id qh8-20020a170906eca800b008b1fc1a7d21mr3996011ejb.5.1680725259360;
        Wed, 05 Apr 2023 13:07:39 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7a4e-3100-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7a4e:3100::e63])
        by smtp.googlemail.com with ESMTPSA id a23-20020a170906369700b0092a59ee224csm7724873ejc.185.2023.04.05.13.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:07:39 -0700 (PDT)
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
Subject: [PATCH v5 3/9] wifi: rtw88: mac: Support SDIO specific bits in the power on sequence
Date:   Wed,  5 Apr 2023 22:07:23 +0200
Message-Id: <20230405200729.632435-4-martin.blumenstingl@googlemail.com>
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

Add the code specific to SDIO HCI in the MAC power on sequence. This is
based on the RTL8822BS and RTL8822CS vendor drivers.

Co-developed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v4:
- none

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

