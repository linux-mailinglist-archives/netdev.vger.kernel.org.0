Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49706D5255
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbjDCUZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbjDCUZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:25:30 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D2F35AB;
        Mon,  3 Apr 2023 13:25:01 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso18822226wmo.0;
        Mon, 03 Apr 2023 13:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680553498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDHdMGLPoHCKVsAutbZQAivZfIzDcGEn0BhV76bkKq8=;
        b=ZBhdvjJKsHmKDygOHjfLZpJD3ebBLl2DLDJNznWbjz8GX5TjVmYtLkLGHmxhgrIPJo
         YPGSij9J56wKGc8oUdCfrDW6ApXASp4OkNlBqsOR3ZCeWeSuTN+i0QzIR/Ig/Khve7Mi
         7CKaxnWvarDOraXaFIODmkkne7jHdyBOeOevRpK3KjnExWT5wQB4bWjD/r7iINYyAOmx
         DNRWirs9RIQDyF6hewTEU6D6hZgBb8lAK0Q59SNYU/N81tN+E9Qw9lEaxNDpnOpT3i8d
         Yt5NIjQW13MvhJHUs15qSRT5UqzMFHyCPJdeMFukLz/Bz4DZvc/i6aXvy8ouOVDYqrDO
         tZxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680553498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KDHdMGLPoHCKVsAutbZQAivZfIzDcGEn0BhV76bkKq8=;
        b=ycHn5HMMdzzIbqZAS9Fx7rOTbYsB5gsHRWvXdz/Xx2jqx72ZSki6DR+cX0n0aFXPIw
         zSoCK3ukq7cYRfl1GnY9oU7MNL73SGrj43db9F1799Jf8xRZ/Q+gGyPGUoquC44RaNfw
         faaCAL4384RQm0iGcySA1D4NyYZ2jHl2/uflSTmHZnLVIZKMzeyokNTAwW/8TJX0Rx1/
         LJrKgldgilOylz3ZOJrNcNf370PaVqPzXHKOaJ88PCErEvdRbF8drcFqsQ7hcthJEvBy
         GwB4UzqbQ06GcFrM66jPGsKWlzNNtCRHajLyqpnsGNnDrRKFh7iiLoWj8lFcaqlUSigx
         IV7g==
X-Gm-Message-State: AAQBX9fbZOm/mk+MR59bpWMFr7qdQ0nqxY7n+B6Vi9VhXV1zMKjn3muF
        6aaC541lrJ+4LMf7p+5AVSVLR8mv3go=
X-Google-Smtp-Source: AKy350YZa21TNC+4SWylVtGOE5EBxtSicSVx/C1R9QrN3IpPuYH0xPcJqX+IUyI+X2ooHXZHytUIXg==
X-Received: by 2002:a05:600c:211:b0:3ee:4bd1:39ca with SMTP id 17-20020a05600c021100b003ee4bd139camr478216wmi.13.1680553498463;
        Mon, 03 Apr 2023 13:24:58 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7651-4500-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7651:4500::e63])
        by smtp.googlemail.com with ESMTPSA id 24-20020a05600c021800b003ee1acdb036sm12845895wmi.17.2023.04.03.13.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 13:24:58 -0700 (PDT)
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
Subject: [PATCH v4 6/9] mmc: sdio: add Realtek SDIO vendor ID and various wifi device IDs
Date:   Mon,  3 Apr 2023 22:24:37 +0200
Message-Id: <20230403202440.276757-7-martin.blumenstingl@googlemail.com>
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

Add the SDIO vendor ID for Realtek and some device IDs extracted from
their GPL vendor driver. This will be useful in the future when the
rtw88 driver gains support for these chips.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v3:
- sort entries by their value for consistency as suggested by Pali
- add Ping-Ke's reviewed-by

Changes since v2:
- none

Changes since v1:
- none


 include/linux/mmc/sdio_ids.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 0e4ef9c5127a..66f503ed2448 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -112,6 +112,15 @@
 #define SDIO_VENDOR_ID_MICROCHIP_WILC		0x0296
 #define SDIO_DEVICE_ID_MICROCHIP_WILC1000	0x5347
 
+#define SDIO_VENDOR_ID_REALTEK			0x024c
+#define SDIO_DEVICE_ID_REALTEK_RTW8723BS	0xb723
+#define SDIO_DEVICE_ID_REALTEK_RTW8821BS	0xb821
+#define SDIO_DEVICE_ID_REALTEK_RTW8822BS	0xb822
+#define SDIO_DEVICE_ID_REALTEK_RTW8821CS	0xc821
+#define SDIO_DEVICE_ID_REALTEK_RTW8822CS	0xc822
+#define SDIO_DEVICE_ID_REALTEK_RTW8723DS	0xd723
+#define SDIO_DEVICE_ID_REALTEK_RTW8821DS	0xd821
+
 #define SDIO_VENDOR_ID_SIANO			0x039a
 #define SDIO_DEVICE_ID_SIANO_NOVA_B0		0x0201
 #define SDIO_DEVICE_ID_SIANO_NICE		0x0202
-- 
2.40.0

