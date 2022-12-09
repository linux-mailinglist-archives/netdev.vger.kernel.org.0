Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB990647F23
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 09:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiLIIVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 03:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiLIIVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 03:21:33 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58475CD12;
        Fri,  9 Dec 2022 00:21:32 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id o127so4663185yba.5;
        Fri, 09 Dec 2022 00:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v3RTjeyyiRTAhODV0n3zXPIltUWeH9mdUsUulbRdH4Y=;
        b=I68bjLoq30DDevaccoVyiJLwK3tJyRwlR9fqbgOdHs4H2JVNggn5W8x6NbNuSMDvnY
         ckVYaPQLShPzebCxUZ8BOMxYriuK1YVcd71RiL5RxE+NsDuXVv659UwYHqwY718EEN40
         qZv/mHl2310qGHETs0c6tQkrlXvJFXSdBdgIVVZfKDP07GnPooeFlfugPF4HUHt5NNz5
         w9xKM/3OI7PmWW4h9y9WDJP6Ji3lUXfkmjGPKgPRqF8dvDzk4YZtVn/it9EuFYq5WYYY
         ODT07mfIlA1g/aAFnQJFsT95A/Q6G8Jk6FT3AE6p/GCxayYFXCQNQG68nbZ7pbtL5bRp
         ntEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v3RTjeyyiRTAhODV0n3zXPIltUWeH9mdUsUulbRdH4Y=;
        b=UXNIVnM/lEQ14JfqBHj1l76tDhB7B3KMKgNpW1if38phl6aXgKlVY644LtlVyjF1yL
         WiCHignOfza/9GD+v4SIL9OpkOsXcsNZWCWj/tef+iTurWm8OXL4l+BHoWc9syKviWQd
         gcw8L+fgNKlfh0YjTv01t0PQUW/PV9wrH+O13Hl3jqx2sxTjbN1Es8Igjz4ODg6CLjnh
         3pS270tpQVOlZxMCU1yaAT79vEeu4Zi09btZ983HYE+Va2W90neqWMafnGuvlcrza85z
         Ofna6N5FT2fp8cqF+0YOGXTmRdIgNFkHuW+7Hieh1K2YSorG4eovtRU2vJK9lBGXGsuG
         tuvg==
X-Gm-Message-State: ANoB5pnAHLvkkfgqBbdeX04dAue5uNrIDvi8w6lVCv9q9SeZxNvKL+GL
        E6sb1z5F7cWa1YLRa7GUs7d9xtCE7+2JoixuKUoSHl98ZB7i/g==
X-Google-Smtp-Source: AA0mqf6D7MOwK8V5FdIqJBWAUExRwwx4GNnORVJ1/nyWDDw+z5Nm6WTMCzcuG72Gkg3/kp50u2y1eF6hAyVtRb4k4qc=
X-Received: by 2002:a25:53c5:0:b0:6fb:80c:fe0f with SMTP id
 h188-20020a2553c5000000b006fb080cfe0fmr32944286ybb.25.1670574092075; Fri, 09
 Dec 2022 00:21:32 -0800 (PST)
MIME-Version: 1.0
References: <Y5B3sAcS6qKSt+lS@kili>
In-Reply-To: <Y5B3sAcS6qKSt+lS@kili>
From:   Uladzislau Koshchanka <koshchanka@gmail.com>
Date:   Fri, 9 Dec 2022 11:21:21 +0300
Message-ID: <CAHktU2C00J7wY5uDbbScxwb0fD2kwUH+-=hgS5o_Timemh0Auw@mail.gmail.com>
Subject: Re: [PATCH net] lib: packing: fix shift wrapping in bit_reverse()
To:     Dan Carpenter <error27@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        olteanv@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Dec 2022 at 14:30, Dan Carpenter <error27@gmail.com> wrote:
>
> The bit_reverse() function is clearly supposed to be able to handle
> 64 bit values, but the types for "(1 << i)" and "bit << (width - i - 1)"
> are not enough to handle more than 32 bits.

It seems from the surrounding code that this function is only called
for width of up to a byte (but correct me if I'm wrong). There are
fast implementations of bit-reverse in include/linux/bitrev.h. It's
better to just remove this function entirely and call bitrev8, which
is just a precalc-table lookup. While at it, also sort includes.

Signed-off-by: Uladzislau Koshchanka <koshchanka@gmail.com>

 lib/packing.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/lib/packing.c b/lib/packing.c
index 9a72f4bbf0e2..47ea47c1198a 100644
--- a/lib/packing.c
+++ b/lib/packing.c
@@ -2,10 +2,11 @@
 /* Copyright 2016-2018 NXP
  * Copyright (c) 2018-2019, Vladimir Oltean <olteanv@gmail.com>
  */
-#include <linux/packing.h>
-#include <linux/module.h>
 #include <linux/bitops.h>
+#include <linux/bitrev.h>
 #include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/packing.h>
 #include <linux/types.h>

 static int get_le_offset(int offset)
@@ -29,19 +30,6 @@ static int get_reverse_lsw32_offset(int offset, size_t len)
        return word_index * 4 + offset;
 }

-static u64 bit_reverse(u64 val, unsigned int width)
-{
-       u64 new_val = 0;
-       unsigned int bit;
-       unsigned int i;
-
-       for (i = 0; i < width; i++) {
-               bit = (val & (1 << i)) != 0;
-               new_val |= (bit << (width - i - 1));
-       }
-       return new_val;
-}
-
 static void adjust_for_msb_right_quirk(u64 *to_write, int *box_start_bit,
                                       int *box_end_bit, u8 *box_mask)
 {
@@ -49,7 +37,7 @@ static void adjust_for_msb_right_quirk(u64
*to_write, int *box_start_bit,
        int new_box_start_bit, new_box_end_bit;

        *to_write >>= *box_end_bit;
-       *to_write = bit_reverse(*to_write, box_bit_width);
+       *to_write = bitrev8(*to_write) >> (8 - box_bit_width);
        *to_write <<= *box_end_bit;

        new_box_end_bit   = box_bit_width - *box_start_bit - 1;
