Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2730F6C23E0
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 22:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjCTVgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 17:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbjCTVgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 17:36:12 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80E3193DF;
        Mon, 20 Mar 2023 14:35:30 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id o12so52342010edb.9;
        Mon, 20 Mar 2023 14:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1679348126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kQARc2IKQ7J+PNhmSMnJI2VcVwSc/7PMjvPSw/XGItg=;
        b=LJCwuLzAxZxLiPrLzGrI772iagRWmk9PnHVA3Q7GBd+TFvGiluLCX4s7EO1uXY8r1y
         bko2VZfbL7iVT7piupZyNQ1KuNH24cR2U4YWbOZPVgKa39M0c+8VTjFIGobu0R+zuFSA
         7Vs4T4StDh2mAT1GhaJdXAbKwQ7EZjiNN+zPkr2dgEobH+WWg28MHooxYflCFnFSfe8C
         b0yX1fhasF+WIS6l1bntiDkf5L4dGPOOnkNwm/ybN5v/NVelQfxm/OA+X54X2s1Gr/xl
         FnIiLCWx/qypyyGXMZNXViFVAymQprzY6lxsrKPwRhLC9f+DoHG0WRiHbOqbMtk/aRBQ
         fEuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679348126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kQARc2IKQ7J+PNhmSMnJI2VcVwSc/7PMjvPSw/XGItg=;
        b=Usu7R97C3DFME/EJhw7QAuXDXMfSzRdg9GAJNBhu7pLmaYREn5p3mmhgpiEb1rWzZ+
         WI5zW1DqKLtfOnKpj8o97eBvlDQmCj6W7el0MxM/5BUsZyDsVQo4+U0ws2tYKkPt/toa
         KV0Hdoqn6zkBqy3TJ2PC+k7JkzzSWA450DIr7O8uIsoi2tVdaH8xAvSyYnTTSMV6lFGc
         uJRjY+FdtHGJHTCVi+nLDQJ436qF7cMNC7+fyLZpLkhJS8xFtjX/LI0/pNkYOjYioqsN
         6ctiA3qY6a3wkkIn1Q+vGxjzPSizg8H1k9PeUKf5uzjfu2rz+4eFF/9cXREMkNuucED0
         MqPw==
X-Gm-Message-State: AO0yUKVPv4X+l8d0wmse0A1Emx0GJvD7r6hOxT0N71LjQHyOYliAD0E6
        gS/r+Y6FoG/85WaVf4UZECnR6mdVuW0=
X-Google-Smtp-Source: AK7set9ilmj5hTWsAlRs4VvyfMPNn9uUUvq6oLlfN40g/Dhn4vSfV3sVHlwo/MMcpnR98YEgOYBk1A==
X-Received: by 2002:aa7:c242:0:b0:500:5627:a20b with SMTP id y2-20020aa7c242000000b005005627a20bmr1095118edo.1.1679348126505;
        Mon, 20 Mar 2023 14:35:26 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-73dd-8200-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:73dd:8200::e63])
        by smtp.googlemail.com with ESMTPSA id z17-20020a5096d1000000b004aee4e2a56esm5413201eda.0.2023.03.20.14.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 14:35:26 -0700 (PDT)
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
Subject: [PATCH v3 4/9] wifi: rtw88: main: Add the {cpwm,rpwm}_addr for SDIO based chipsets
Date:   Mon, 20 Mar 2023 22:35:03 +0100
Message-Id: <20230320213508.2358213-5-martin.blumenstingl@googlemail.com>
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

Initialize the rpwm_addr and cpwm_addr for power-saving support on SDIO
based chipsets.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
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

