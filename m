Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F00665710A
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbiL0Xau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbiL0Xan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:30:43 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29AAB30;
        Tue, 27 Dec 2022 15:30:41 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id s5so20852904edc.12;
        Tue, 27 Dec 2022 15:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=btb9JCFbAduIuQyMWX4fEkp8lECM3tHdIlZQhT1+ifQ=;
        b=VR4staqyRagqWvg9HiMYvJRnLd/Z8E0ODa8AFk92I16qqZlovxWvgmxnSedR7gqRCr
         UZBJf8fwSL+duyK9wHOttFt7I4UUSsNEzLUymFxIO6hB2xfqBCngHLOSbkgneOX+sxts
         cvrNT/npALLXAQaqIuzzYWSEb50lVc3dUzOmdBrryFl7AGlFKiEynTGwi5NONJCLrjAr
         ZvQ/L1k6S2kCRlbTiNc93nc9m1iL07gDKiOAiUqvBGscesyxetRdSb9Y6I/8DIGURmX9
         sFK0NxrzbevRS0fB13HyfPiAZThRJARi6nKRRYh1dXw/SM9JCuXDwW+F0lKmUvofaPYK
         0MTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=btb9JCFbAduIuQyMWX4fEkp8lECM3tHdIlZQhT1+ifQ=;
        b=R5WqDZZFQilNwpS7iFCqzXfKNEZrhynA9y1A25rI/DB2P0S3nu7bp9MRU58VEQr6mw
         V5vYjBfUbyDd3FqEkXsMmUjPV40pSjg+yavlFB50GJeywp/q9lWz7lvxyS/DlrnsZwoA
         BW/JqBF/HKI4jVU075m8J/n4Kue2nhCfbwOjO9sTwm0/zB5EVMyQFJeiwZHnRf932etB
         saPCzk0Crbmnn1mjSbyqOFGzpVT7QyWIO5yFdUNWuFZLeJtJfKc3NcottLMJyK5+MxNM
         PhhkHh1OQmhyJaw8Y/xQhCNir0pUCtmPyZGBlRAlTcfASIUpv6tXg8giifZg9tfbISxp
         fVdw==
X-Gm-Message-State: AFqh2ko1p9o6Tp5JPhfFU3YH4sBORiQgWos7XOneOxkIfG2ZpDi8DgX/
        VkrleIauF83hplmXb0uIHsoSYKbXmJU=
X-Google-Smtp-Source: AMrXdXs2lyI3DW7x++xTstNUDhNGbja194swr2CllpVhgdnt/hjiY4o8QguagNs8T4n4kVsk0lOzFQ==
X-Received: by 2002:aa7:da4c:0:b0:46f:9a53:fdce with SMTP id w12-20020aa7da4c000000b0046f9a53fdcemr19915029eds.41.1672183840006;
        Tue, 27 Dec 2022 15:30:40 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4cf-d900-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4cf:d900::e63])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7c147000000b0046cbcc86bdesm6489978edp.7.2022.12.27.15.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:30:39 -0800 (PST)
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
Subject: [RFC PATCH v1 05/19] mmc: sdio: add Realtek SDIO vendor ID and various wifi device IDs
Date:   Wed, 28 Dec 2022 00:30:06 +0100
Message-Id: <20221227233020.284266-6-martin.blumenstingl@googlemail.com>
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

Add the SDIO vendor ID for Realtek and some device IDs extracted from
their GPL vendor driver. This will be useful in the future when the
rtw88 driver gains support for these chips.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 include/linux/mmc/sdio_ids.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 74f9d9a6d330..bba39d4565da 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -111,6 +111,15 @@
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
2.39.0

