Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1640565712F
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiL0Xcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbiL0Xbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:31:33 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53F5E089;
        Tue, 27 Dec 2022 15:30:50 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id t17so34962909eju.1;
        Tue, 27 Dec 2022 15:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8GWyz5jQ6a8YBmKbthsrt/fWSXYydYplp8Hp3+tK5/w=;
        b=lcCjFGVE8jmprid5xwPUJt/k8T5XVelgRoWY/4Sb/g9E6vwPhIpcx3hYj0YrMV8E2w
         qwHDsqvcSWFhe3kmVzqlJEwNAm9Fa+IPr6RGKFdpezTPgPn+Q/mTb7iyTWcunYNKxOai
         5gcXdoIys+5k1lYY1iq77SD51W47gy52SeBndRnPBNzN4vkgIKu+D5MW4MFjeqTTQdl1
         td1iDbeDr/Ib7EZoR+IGQ4Q0msQC5EnHMkm7Dt4sZV8n+xs6y8QHS2OYV4SUeoNiJEQk
         acYkBeu43EwJQ37ReDLjNC5IvILgTY70vUnJg+LaOCATfhwydU/+pJLQwNYD6rtV/NeA
         UxBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8GWyz5jQ6a8YBmKbthsrt/fWSXYydYplp8Hp3+tK5/w=;
        b=tBKo6yaHrLL44CdgGIjzH1JiiN9e0xz4ckAnNYimvHAo3r+McSIpsUobCvmRW7Qjis
         MigzeLFW29X4mbN3ZSyeK68El9DG33FWn3blvRjYEadI8UJO69HxNj0j2NAP4a3aXTVU
         Cqh79NVqf2aL74HDfOFtnaruD7cOVifJWgpYI1q0ylHM0ljDPLCQ/LtPcnss7VRYjSYg
         uw8Akv1nF0j/XWM1mm3dxp1IWXG361ye5TerRqTjRBXoTR5srSqyebvxo5QveP+DjJSj
         1AHbL/EuBCEE2ma/cEJxZE8LrzayfS1U66eXnJxFiwgEoXLO83v9wgxGrjTmSQ35Aeu5
         qtFw==
X-Gm-Message-State: AFqh2kqgznQyZMaVecbqM7YWrWRtKz/l2krQ3YBS2CappCwYlNBV4hIW
        OcxapkhiWHWwvQ+JgS+7B80hlQvNHQI=
X-Google-Smtp-Source: AMrXdXug7dD2x+hUREVGCOcXthn322kJQQUzoJL5jtSwDeisAdmc2xP+5VqEg0o4uKCfHh/iHiex/w==
X-Received: by 2002:a17:906:12c7:b0:7c1:639:6b42 with SMTP id l7-20020a17090612c700b007c106396b42mr24917114ejb.62.1672183848843;
        Tue, 27 Dec 2022 15:30:48 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4cf-d900-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4cf:d900::e63])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7c147000000b0046cbcc86bdesm6489978edp.7.2022.12.27.15.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:30:48 -0800 (PST)
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
Subject: [RFC PATCH v1 14/19] rtw88: main: Add the rpwm_addr and cpwm_addr for SDIO based chipsets
Date:   Wed, 28 Dec 2022 00:30:15 +0100
Message-Id: <20221227233020.284266-15-martin.blumenstingl@googlemail.com>
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

Initialize the rpwm_addr and cpwm_addr for power-saving support on SDIO
based chipsets.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 888427cf3bdf..9435cb43d1dc 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -18,6 +18,7 @@
 #include "debug.h"
 #include "bf.h"
 #include "sar.h"
+#include "sdio.h"
 
 bool rtw_disable_lps_deep_mode;
 EXPORT_SYMBOL(rtw_disable_lps_deep_mode);
@@ -1783,6 +1784,10 @@ static int rtw_chip_parameter_setup(struct rtw_dev *rtwdev)
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
2.39.0

