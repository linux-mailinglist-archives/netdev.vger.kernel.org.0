Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8893B6D87D8
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbjDEUII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbjDEUHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:07:43 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29ECC4EDB;
        Wed,  5 Apr 2023 13:07:42 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id h8so144026080ede.8;
        Wed, 05 Apr 2023 13:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680725260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dkhlZEl4RroxwrI00S3LvqdnKVm2/rkrNG2QmpLdPZU=;
        b=cFWOxmlJ6G4FLX66WtUl/G7UTqGkvTYzUVtYZ2xNpATIU/v6qsQytvDFC4euhkd2PB
         PyKsHLWK8xFq5bU0aWPkCNUorWQcFszCsTV3Qai2HpYpUfQiWbQ6XKSxRM322jqTtpKa
         VC6+6MIdJKoStBG3WXZ1iRvuoJ1uFuadGdg2GBMZr4pbOkF+B3eT5eYdJiN877YGgC+3
         BJD+rBhEMGI7EVWhJjQr0fOg6wl44cOojBzIXaiZvQ8CC5tvG//oIsvB2/iEj/qzBY2m
         scUhudPUJI4S/+yWEozPh7YuuZ3dUhoVgHplzr7/1F3uyRnC3kYSX+C6KElWqLb3jVyH
         T8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680725260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dkhlZEl4RroxwrI00S3LvqdnKVm2/rkrNG2QmpLdPZU=;
        b=Lk7Tev580MviomcmExGtCFi58T9x7UAriyqBzO6tIbXs39e15YyVF9edVHVx+PqHcF
         IiA+9uQVhFG0sOnkfMkf+IBTbqSgBnFVI32civ0L8rGT1ZLF/0W3pZzEtWD8LHzd/t6c
         pwQ2py1p75BYy4+bll4iipZwqjihkcKWYKWBpbbGyPWaxpuei+B2vCGryfnOz62oRIXZ
         hK5DTeRHEz4ZGvQJBlS17WoXsjUzRJdIyUhbtRNczLRh1eanyp7FbY1G/BrF0xk9TMdC
         7gj09vlI6LtIdThznlaGu8bMzYVHHiLX+x2jAg1fbJALDyfyUMKxVPjhBsycRUDtboHd
         qBSQ==
X-Gm-Message-State: AAQBX9d3bKohVLJHRSH3HLu8xu2ElbqrUkweFkHoNjEuNvBu/ZIZ/oeH
        aQXA2Xc8ASIK9D/R1jOc3GuLIXoi6jZ0EA==
X-Google-Smtp-Source: AKy350Z1byxBzJE6VFTxDDC3PSwn3D166NHQTbdk57q8cFcF/efncbNSuCen/Aqdwl49TiOfI9Lu7w==
X-Received: by 2002:a17:907:1c9f:b0:8f2:62a9:6159 with SMTP id nb31-20020a1709071c9f00b008f262a96159mr4632277ejc.2.1680725260315;
        Wed, 05 Apr 2023 13:07:40 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7a4e-3100-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7a4e:3100::e63])
        by smtp.googlemail.com with ESMTPSA id a23-20020a170906369700b0092a59ee224csm7724873ejc.185.2023.04.05.13.07.39
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
Subject: [PATCH v5 4/9] wifi: rtw88: main: Add the {cpwm,rpwm}_addr for SDIO based chipsets
Date:   Wed,  5 Apr 2023 22:07:24 +0200
Message-Id: <20230405200729.632435-5-martin.blumenstingl@googlemail.com>
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

Initialize the rpwm_addr and cpwm_addr for power-saving support on SDIO
based chipsets.

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

