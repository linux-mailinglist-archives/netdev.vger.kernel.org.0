Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45BE1648BE3
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 01:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiLJArk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 19:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLJArj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 19:47:39 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68014DD0;
        Fri,  9 Dec 2022 16:47:37 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id t17so15239637eju.1;
        Fri, 09 Dec 2022 16:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uRnRrqGsFpngaI89ODUUTmQJOBbmZXvuzOkPrCLsszM=;
        b=j7132LuMo5aHHPdlvEWbCPQmE1/OnzvHCr1zbaj91+ZEl3kRZLZtZP5WaRt8prNwsk
         06SbQjIlWtRTafIoKdeQKKVPYqY/qiLJvbWSlHcx0QE9E6Ls+M9WzH6BYXss1X3S6SeF
         oqHmen/fDSz3vy1aESM4VHRNCULDPpf1yeDAdZ2z0W22g1772tcHaZNO1Ya7CK+/K3zc
         ISDz8RjQw0EGzvHGrFDUh4QFs5K3YzO+wre95dc4Eaf+y4YbBN4iBRzVbUYFNWJfGo/P
         7XzSXNSnoc4brItBbDkwLsvSKwdtuUMGvJS6ELQpW8jAm6MI/LZHSLSml+9JCqutsok/
         SjnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uRnRrqGsFpngaI89ODUUTmQJOBbmZXvuzOkPrCLsszM=;
        b=ZShXGy+uvzokD0ijPwZQcwxkzYy8awyOyypfvTXg6XPVDHH9BTERv+8ZZoYXyQ11RS
         1xR7fVVuj4tNe9oXNUQekp06YumuUH+MgMF/12NECerF/u/TFTi3Q64DQfqYUlz/7V0D
         RmwzZFGazlcFRD3EQ2oiUp7sbi+Yw1HUG6RktVBGSBfJ4WMumN4IYEPp5w0IGQuyx9OB
         diSV23F9MjbwM+8HuXnMQihBN3vnhqJW5EnCp6Xn9pd+9a8IpEMWmHP1FxE2unVFGdw2
         nmI+qF3/APorYdfp28pITkSVgVKVd23ZgzRQZSY1tda56h6icQNlirlT+3eCifzw5NBR
         D+xw==
X-Gm-Message-State: ANoB5plk9k+B6fravfGgMb7BQaBuMH2kBJhrnJeXyU5WZAavuKGKFiz3
        peIVS2U5E/DvOAE7gUIKfcPh2enRzly0yQ==
X-Google-Smtp-Source: AA0mqf4FN60H3mOLSUeiSgAWP+9BKg3XqlbLAQ4LON1jjtFfV8L+aj0XkAgozjycPxluHPy4hPbijw==
X-Received: by 2002:a17:907:3e91:b0:7c1:13b5:c434 with SMTP id hs17-20020a1709073e9100b007c113b5c434mr10137680ejc.35.1670633255959;
        Fri, 09 Dec 2022 16:47:35 -0800 (PST)
Received: from koshchanka.. (mm-144-58-120-178.brest.dynamic.pppoe.byfly.by. [178.120.58.144])
        by smtp.gmail.com with ESMTPSA id 1-20020a170906318100b007c0688a68cbsm468739ejy.176.2022.12.09.16.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 16:47:35 -0800 (PST)
From:   Uladzislau Koshchanka <koshchanka@gmail.com>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Uladzislau Koshchanka <koshchanka@gmail.com>
Subject: [PATCH] lib: packing: replace bit_reverse() with bitrev8()
Date:   Sat, 10 Dec 2022 03:44:23 +0300
Message-Id: <20221210004423.32332-1-koshchanka@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221209220651.i43mxhz5aczhhjgs@skbuf>
References: <20221209220651.i43mxhz5aczhhjgs@skbuf>
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

Remove bit_reverse() function.  Instead use bitrev8() from linux/bitrev.h +
bitshift.  Reduces code-repetition.

Signed-off-by: Uladzislau Koshchanka <koshchanka@gmail.com>
---
 lib/Kconfig   |  1 +
 lib/packing.c | 16 ++--------------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index 9bbf8a4b2108..cc969ef58a2a 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -24,6 +24,7 @@ config LINEAR_RANGES
 
 config PACKING
 	bool "Generic bitfield packing and unpacking"
+	select BITREVERSE
 	default n
 	help
 	  This option provides the packing() helper function, which permits
diff --git a/lib/packing.c b/lib/packing.c
index 9a72f4bbf0e2..a96169237ae6 100644
--- a/lib/packing.c
+++ b/lib/packing.c
@@ -7,6 +7,7 @@
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/types.h>
+#include <linux/bitrev.h>
 
 static int get_le_offset(int offset)
 {
@@ -29,19 +30,6 @@ static int get_reverse_lsw32_offset(int offset, size_t len)
 	return word_index * 4 + offset;
 }
 
-static u64 bit_reverse(u64 val, unsigned int width)
-{
-	u64 new_val = 0;
-	unsigned int bit;
-	unsigned int i;
-
-	for (i = 0; i < width; i++) {
-		bit = (val & (1 << i)) != 0;
-		new_val |= (bit << (width - i - 1));
-	}
-	return new_val;
-}
-
 static void adjust_for_msb_right_quirk(u64 *to_write, int *box_start_bit,
 				       int *box_end_bit, u8 *box_mask)
 {
@@ -49,7 +37,7 @@ static void adjust_for_msb_right_quirk(u64 *to_write, int *box_start_bit,
 	int new_box_start_bit, new_box_end_bit;
 
 	*to_write >>= *box_end_bit;
-	*to_write = bit_reverse(*to_write, box_bit_width);
+	*to_write = bitrev8(*to_write) >> (8 - box_bit_width);
 	*to_write <<= *box_end_bit;
 
 	new_box_end_bit   = box_bit_width - *box_start_bit - 1;
-- 
2.34.1

