Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021AA6C23D8
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 22:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjCTVgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 17:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjCTVgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 17:36:08 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E5F18AB7;
        Mon, 20 Mar 2023 14:35:30 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id b20so19411762edd.1;
        Mon, 20 Mar 2023 14:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1679348128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cIXZMLxx/ubavYAb0x2y+MWgAklULVLiudoNGsi/gKc=;
        b=FYWoX7tDPL38lqEnew6QDLMyxgNpv+YHllFLrHJmtU57rgtjxLdtzNvY89CaQzTVxY
         QbPSDjYX9tBYEmPoiRovQln23elACHXUMlD7YzBAQ2e6Zmm/HP1uah1w8XI4DdJ6assj
         yz9TLQIg4CEbHwVNcJwRimBQc4K+Cfd5V3fkzf+UmTFmJ/6YRGP+EJPnyDC/Bxn/9643
         98rh3uwD9CtALydIUCnN7scALnpBzwBAPDRW4KDAcYh4USUjNvifoGcFi1MuU5v8Ei27
         1wzlHIoRCDsE27Jy56zSZ6thef7jpm1YRhMgjy9svTzdddQ+fE7eN0sC8dUacybarFhB
         2x/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679348128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cIXZMLxx/ubavYAb0x2y+MWgAklULVLiudoNGsi/gKc=;
        b=yYLkuBN66HODi1ZCOskKyb2t/s7KUjgBG9WZy6L63DJtZ0GjB3m5NymNcc966e8wsy
         yMzGu/kXWUJqN6KshAMWAwxgVmqA6v7YvMCE3NS0J6ZYZNbxozpvqukL0mMCr7jNXuhh
         hTHP/z1C07ZfinfQyYPbbLKtC1zMdu70Qq5bI9CRtjr7snW53wcHw90kwNT2CwRtL2H4
         ghdDc4iRlBOrHppIQ36FrcwTBakFzjm70/BJHqVIYqFcwPjvF9o4vlJDCDH5dVe6y2OB
         7m4SZMpvsB5tz2W18jagdJxgCFQPJ/0RZz5sMBSRwqi8yKZ9LqMapp5rBATLUY8q+W1G
         DYmA==
X-Gm-Message-State: AO0yUKVlusyWj2xSVQ5iIKot9zQLYCVusZ67ihEaq3xVNfd7A5FC59yQ
        zgG9p6JkS+j14r6wBwtPpZ+6KEAaM8k=
X-Google-Smtp-Source: AK7set/h1Kuju9OeDuVNsvJ1JURneblLKR4Yr+YpzMoOj1GIhYKvgdGJfzw10O0iiEuLniXxXKk+5Q==
X-Received: by 2002:a17:906:7c9:b0:8b2:8876:6a3c with SMTP id m9-20020a17090607c900b008b288766a3cmr490868ejc.29.1679348128499;
        Mon, 20 Mar 2023 14:35:28 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-73dd-8200-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:73dd:8200::e63])
        by smtp.googlemail.com with ESMTPSA id z17-20020a5096d1000000b004aee4e2a56esm5413201eda.0.2023.03.20.14.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 14:35:28 -0700 (PDT)
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
Subject: [PATCH v3 6/9] mmc: sdio: add Realtek SDIO vendor ID and various wifi device IDs
Date:   Mon, 20 Mar 2023 22:35:05 +0100
Message-Id: <20230320213508.2358213-7-martin.blumenstingl@googlemail.com>
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

Add the SDIO vendor ID for Realtek and some device IDs extracted from
their GPL vendor driver. This will be useful in the future when the
rtw88 driver gains support for these chips.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v2:
- none

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
2.40.0

