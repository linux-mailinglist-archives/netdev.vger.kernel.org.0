Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD65D6D87CA
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbjDEUHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbjDEUHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:07:44 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D414C3F;
        Wed,  5 Apr 2023 13:07:43 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id h8so144026311ede.8;
        Wed, 05 Apr 2023 13:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680725262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sCGctQUvhfIge+ye5z2klB7irMWs+bL6IICTkDLdKvM=;
        b=SYFAl6TnoN5/SbT9gBc5amk4rbNPqrLGJRAfQJqcr05SHrpx3y0uqtq0SckNVQJhq7
         0OOxR7xQl2vtsWwFUauxF6IdbJjLAZQgN0i0+2okjftSz3gcINnsL+1sAXC7DIXiY2EH
         jHN6mXfEh6IoFwkTL3WWa8dubH/H+oavWKUQM6YT+vcEwqwYcFsaP2fVVOUM+OjQB8FR
         yudCZaYsj5ziEA09kMDdEXmbOElEZkdq6RxJx2dwjpLD+DEaTDW1UWHAw8t2+Iafcojp
         bDPqEVGGrirTHPpYTiZBxNJ+MaBTh1MzP5xhnMyk8Qa1Vig0uSp1xe7UgoFvfyLlzQba
         RM+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680725262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sCGctQUvhfIge+ye5z2klB7irMWs+bL6IICTkDLdKvM=;
        b=sLk5Zgv6CxeuD0Zym5+hOYUMEbUvX2bit8ID7pbTyR1rjS8kmVpwoFWmQYvwJnl7Ho
         LddCRqp+AWZ+zgEeyLCApkYbBb1k8KThrdNKMFo8H41wDfAZeKyttou7CL6KShZmLYyP
         mr03tVPGIymYkzV8jG+HrnuvMmpsSffvdFmNAQYZIS91m4ZVTp7pA+GgCBXndib4bjQM
         YYmLHya5Qt/52ePDR0Ou8p5cgCTEm9F94qjCQDy890iHKePqbg5KacgeVYlIhqwDIfhw
         lPEAdO9pJPPYcjjWnf76FbAQyZ1BZ+KIGgEDDGp9LtkvcRZzLZEXHBMkuB18yavptUh8
         thBg==
X-Gm-Message-State: AAQBX9fYWaXh7zWQfltpz/z168If1SpsZ5sipSe+cysXzRMAStdYtsXg
        38Kn1gf+39EubODfqFjQEjmUKihLr1sb8w==
X-Google-Smtp-Source: AKy350Y+2PiL81556sx3v/8IgHIldmsOkE3XAw4BZdStyx0NV+8YXJU/oGkLWwGjjJMqAgtQS00lTg==
X-Received: by 2002:a17:907:76af:b0:948:dfb5:50df with SMTP id jw15-20020a17090776af00b00948dfb550dfmr3817688ejc.8.1680725262088;
        Wed, 05 Apr 2023 13:07:42 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7a4e-3100-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7a4e:3100::e63])
        by smtp.googlemail.com with ESMTPSA id a23-20020a170906369700b0092a59ee224csm7724873ejc.185.2023.04.05.13.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:07:41 -0700 (PDT)
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
Subject: [PATCH v5 6/9] mmc: sdio: add Realtek SDIO vendor ID and various wifi device IDs
Date:   Wed,  5 Apr 2023 22:07:26 +0200
Message-Id: <20230405200729.632435-7-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230405200729.632435-1-martin.blumenstingl@googlemail.com>
References: <20230405200729.632435-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Reviewed-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v4:
- add Pali's reviewed-by (thank you!)

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

