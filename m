Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1316B51EE
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjCJUaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbjCJU3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:29:53 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5D2119976;
        Fri, 10 Mar 2023 12:29:52 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id j11so25436874edq.4;
        Fri, 10 Mar 2023 12:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1678480191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S6dWwXrKh+cV+DyaUDYXQ8ldoQ1QnB6tL7RwZKQ0TRo=;
        b=HdIGTEidSTCAh0gUFChpoO8SWhVnmVt3A7m5rDso99XCqa+53206T76w2swO5YacVr
         apOSwadC+FxBtWu11O2Bof19mAjF7o9iQOAxyc+Xvz9xVK7Q9UHQj8GvUyDx3pDzORv6
         qSzShx2thFjnk66H37BUhHGol6S0aUZwRbRIvnpMKEzENeYDMLimarIjhMl74Hx7/X+W
         HSXpBdwGLp4xzqRX5Dcjh98CngKr3p63vc48+XOpBSkUrUt4jl1QQTy6Av9PnouXUk1x
         COsdpsVLxcqhlWMSc80g4/NJQTeP3MubwCRyIK2Pvs+FF0Zd1ipudy5ZoGQDhTZC/uO2
         9Kjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678480191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S6dWwXrKh+cV+DyaUDYXQ8ldoQ1QnB6tL7RwZKQ0TRo=;
        b=WN8R7jmv7QfuXQEAqqXJg2krm5xPoImIFGZ6ME13XZnHEcnNSbejlrDpNxcHM9mskg
         S7Z8+UuzY4DKniSU7AyXUEQB15qBaILd4MMgBtss7wNW6e+idohquIOFIWKi1CELepwi
         6S701VNkfmqJg/3aXlQCPpxYPYjyfGBGw+7ME9SSbMYHFqFTFjN2EJC+5ajFprhG85zU
         a5DrHY3pg8pDIkXCdfhveza1Cg0GlyCKCPtRioyM7ZDGZOsIm7hHyhzmvnd+lMjJCfYs
         iwpNFu9A/S9mJQ0QnopYnlg8xY3wx9H8DqzEmn+5jFOqwVf3AZ1N9J8sbvrw9SmoRR6j
         B+pQ==
X-Gm-Message-State: AO0yUKVkm320SCoU3x8aqWDu0YL+mmfGgP9HC10ZTsWdCr/Q3o9I1e29
        /SsYnosB4MNmtSzWEN5JT5qHw8dqLIs=
X-Google-Smtp-Source: AK7set/R8cefOJ9uBJBJHwUXpqc8CizeqOEbl9mFbjGJDJNWwnqDlJEAMmLxtS9xrOVVdQC2CRwoSw==
X-Received: by 2002:a17:906:b84c:b0:8ef:2485:3032 with SMTP id ga12-20020a170906b84c00b008ef24853032mr26765194ejb.65.1678480190697;
        Fri, 10 Mar 2023 12:29:50 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b84f-c400-0000-0000-0000-079c.c23.pool.telefonica.de. [2a01:c23:b84f:c400::79c])
        by smtp.googlemail.com with ESMTPSA id md10-20020a170906ae8a00b008e34bcd7940sm259047ejb.132.2023.03.10.12.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 12:29:50 -0800 (PST)
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
Subject: [PATCH v2 RFC 6/9] mmc: sdio: add Realtek SDIO vendor ID and various wifi device IDs
Date:   Fri, 10 Mar 2023 21:29:19 +0100
Message-Id: <20230310202922.2459680-7-martin.blumenstingl@googlemail.com>
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

Add the SDIO vendor ID for Realtek and some device IDs extracted from
their GPL vendor driver. This will be useful in the future when the
rtw88 driver gains support for these chips.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v1:
- Add Ulf's Acked-by (who added: "I assume it's easier if Kalle picks
  up this patch, along with the series")


 include/linux/mmc/sdio_ids.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 0e4ef9c5127a..d7cd39a8ad57 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -112,6 +112,15 @@
 #define SDIO_VENDOR_ID_MICROCHIP_WILC		0x0296
 #define SDIO_DEVICE_ID_MICROCHIP_WILC1000	0x5347
 
+#define SDIO_VENDOR_ID_REALTEK			0x024c
+#define SDIO_DEVICE_ID_REALTEK_RTW8723BS	0xb723
+#define SDIO_DEVICE_ID_REALTEK_RTW8723DS	0xd723
+#define SDIO_DEVICE_ID_REALTEK_RTW8821BS	0xb821
+#define SDIO_DEVICE_ID_REALTEK_RTW8821CS	0xc821
+#define SDIO_DEVICE_ID_REALTEK_RTW8821DS	0xd821
+#define SDIO_DEVICE_ID_REALTEK_RTW8822BS	0xb822
+#define SDIO_DEVICE_ID_REALTEK_RTW8822CS	0xc822
+
 #define SDIO_VENDOR_ID_SIANO			0x039a
 #define SDIO_DEVICE_ID_SIANO_NOVA_B0		0x0201
 #define SDIO_DEVICE_ID_SIANO_NICE		0x0202
-- 
2.39.2

