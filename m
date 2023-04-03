Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235336D524E
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbjDCUZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbjDCUZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:25:29 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7BA421B;
        Mon,  3 Apr 2023 13:24:59 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id l10-20020a05600c1d0a00b003f04bd3691eso3923040wms.5;
        Mon, 03 Apr 2023 13:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680553497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+XhLVAQ4sbi4OzfC3n0v++1sIl1iSsPRMVljiqDmtbI=;
        b=aVt2dqLEgoCQf4vUm6eRdlmJj4AN8habnLsF/GEW9g4gA16x0/E7mUUm0nbw/Xccet
         SFDaWauO8aXaD1V+oKAWQkxLEJ23p7o0fYuBzvzJsdW5Eir+PAwOaPzsGJXL9QueTsOX
         jRHMWaBDqHJy03cqSxfswKGwuynXU5UM11ZluNgB4LrliNwnJCPpDGybFxBf3ZP6eAZc
         aN1J7M4wXdB+HP7QP8d8UNWkA0DFQBjhc/+w3a2+7zuD1L8F7z3y4PQ0r85lO2MEsR0z
         xBMZEYApR2h6XEBC8IO8cnroAzj0vEXneRMLyLuxrPuvkjewASJV+AWQNAJnaCMknghR
         cCdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680553497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+XhLVAQ4sbi4OzfC3n0v++1sIl1iSsPRMVljiqDmtbI=;
        b=qzRJR+v8EEkUUprBCIaj13i2iBFpvLMKQWTZHke8KDGLeQUtXlwKGOT0XHUjI5Ls4M
         3QpLOMyi59DvdNISU1z3YvDuCfhxogrvcrg1E/+1DyaeCc/K00NvjakB4Cas/xHBDmRw
         8hyw5iNOtJh/0eiVJbpUiSlAEtIn/5z+WAZM5dtOLGkkZkUi47nnRcVFRjz44zWAfNB+
         R8xB+bI8HIivauo1SrQEXGT/Zt4mIprVzXpG7/ZiD1oH9eSp21tqle1v4Nl5kL08nfdL
         cZBJY4EFFeEKidUK9O6SFbLEsIOsy63tqfEElM008wfsri9P6O52SlhplSd4c+tRn0dc
         FVzg==
X-Gm-Message-State: AAQBX9fXrg+xW7VLgIVO348Gu7EdtqvTaJrMPJMULTaEwUgNc/GaQ/kc
        kjN5a0dvgtE960bleyF+rU0gyH4stmU=
X-Google-Smtp-Source: AKy350ZA24qWLI/4FGXO3OLlo/TMiUrBmVsdOd8K1sfz++HVMKtHpe0jZloYaNLgxoaOPknYbJCn7w==
X-Received: by 2002:a1c:f617:0:b0:3e2:1368:e395 with SMTP id w23-20020a1cf617000000b003e21368e395mr415172wmc.33.1680553496671;
        Mon, 03 Apr 2023 13:24:56 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7651-4500-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7651:4500::e63])
        by smtp.googlemail.com with ESMTPSA id 24-20020a05600c021800b003ee1acdb036sm12845895wmi.17.2023.04.03.13.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 13:24:56 -0700 (PDT)
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
Subject: [PATCH v4 4/9] wifi: rtw88: main: Add the {cpwm,rpwm}_addr for SDIO based chipsets
Date:   Mon,  3 Apr 2023 22:24:35 +0200
Message-Id: <20230403202440.276757-5-martin.blumenstingl@googlemail.com>
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

Initialize the rpwm_addr and cpwm_addr for power-saving support on SDIO
based chipsets.

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v3:
- add Ping-Ke's reviewed-by (again, thank you!)

Changes since v2:
- none

Changes since v1:
- none


 drivers/net/wireless/realtek/rtw88/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index b2e78737bd5d..cdc4703ead5f 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -18,6 +18,7 @@
 #include "debug.h"
 #include "bf.h"
 #include "sar.h"
+#include "sdio.h"
 
 bool rtw_disable_lps_deep_mode;
 EXPORT_SYMBOL(rtw_disable_lps_deep_mode);
@@ -1785,6 +1786,10 @@ static int rtw_chip_parameter_setup(struct rtw_dev *rtwdev)
 		rtwdev->hci.rpwm_addr = 0x03d9;
 		rtwdev->hci.cpwm_addr = 0x03da;
 		break;
+	case RTW_HCI_TYPE_SDIO:
+		rtwdev->hci.rpwm_addr = REG_SDIO_HRPWM1;
+		rtwdev->hci.cpwm_addr = REG_SDIO_HCPWM1_V2;
+		break;
 	case RTW_HCI_TYPE_USB:
 		rtwdev->hci.rpwm_addr = 0xfe58;
 		rtwdev->hci.cpwm_addr = 0xfe57;
-- 
2.40.0

