Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4FB695DD5
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbjBNJBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbjBNJBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:01:00 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7720B1284B;
        Tue, 14 Feb 2023 01:00:59 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id h24so16809232qtr.0;
        Tue, 14 Feb 2023 01:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Sotg6g4Bh/A8PVyKxmYXGABNEX1eJU5WjsjoyOoCPXM=;
        b=nYm5hMXfNfniL4C7SsUcbr0NG/2bqbQphI2J2mYuEDYsJq7PkY6lIc24t8x9TrBMoM
         LYiRT7O85Vz+1ZbDcjXZw2EuxdLL+gpmCsyx2zYv38z5eYbem9lv/0w4kLHPeE0//PhW
         78iY2AfZL7gtOqxAkjhuuqru9vTNOheliaThYT4VSp0Tabx2xLUJmVYHgwkrToArEzbT
         flACIUXw8tjKFCO6euF0cXAyLNlgwwjSvVPb0JRHBghZt8mtW1E21GrjkBPHRvbLGWpy
         JR9Q1eJWO0ocFOEqqJ3OrFhH38yn8B2f/+UZIkxJ3IR7L8hi7GEUMeswRujc9BqX9xQg
         EilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sotg6g4Bh/A8PVyKxmYXGABNEX1eJU5WjsjoyOoCPXM=;
        b=ByCTZ6jDe+pZBbP8+gwJ8tQmYos1lsjR8T0Mvb+cHUQErwFNMgwEfXcFjCRfHGCNew
         rhCK7nbIG3l9a/4gXjR8v/nl7a8OsFR3sfDgKRCOqerQoyw9kVjiZsIZ8/P/Sz+jX66x
         24Asmd6KrAr++LB2gdH4Et8Ak5q5iPlxsIW0wZdU3TL/GXD/lQdTaLR1OUVWuz45KQQV
         1wk07OK5LCIKfmu9VMWLbbHdS8ZHnb8UsoeqmXzgWX0KL69b0Yz4hKlUuPWS76WAPgv4
         HbK60WGbOGfHgx/36C29SjHen/jb1AEVDg7Mhz/rli3FWRZC1MIvP09DioChe20y1x4D
         RsEQ==
X-Gm-Message-State: AO0yUKXpwiUGbdOS6P2KDjZl4vysSpt7yl57e9htFfXieCBHCOBjLptU
        hegUP+7E2vCuLgHvnpX4itC9qHeT9pqJ2Y5hQZg=
X-Google-Smtp-Source: AK7set8BrQ3EZL7oYNrSDTXecmNQ+MEqyA40JVLuuUbf8otkPYKFo01zkl8m26ZDac6afBBX0vqQBt2ouoflSVuLxmg=
X-Received: by 2002:ac8:5c0d:0:b0:3b8:6b25:88be with SMTP id
 i13-20020ac85c0d000000b003b86b2588bemr232093qti.14.1676365258564; Tue, 14 Feb
 2023 01:00:58 -0800 (PST)
MIME-Version: 1.0
References: <20230214080034.3828-1-marcan@marcan.st> <20230214080034.3828-3-marcan@marcan.st>
In-Reply-To: <20230214080034.3828-3-marcan@marcan.st>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Tue, 14 Feb 2023 20:00:45 +1100
Message-ID: <CAGRGNgV6YMhBa1bdkf_EQ0Z+nwbfhJkKcTxtc=ukWVMWtvQ2PA@mail.gmail.com>
Subject: Re: [PATCH 2/2] brcmfmac: pcie: Provide a buffer of random bytes to
 the device
To:     Arend van Spriel <aspriel@gmail.com>
Cc:     Hector Martin <marcan@marcan.st>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Linus Walleij <linus.walleij@linaro.org>,
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Hi Arend,

On Tue, Feb 14, 2023 at 7:04 PM Hector Martin <marcan@marcan.st> wrote:
>
> Newer Apple firmwares on chipsets without a hardware RNG require the
> host to provide a buffer of 256 random bytes to the device on
> initialization. This buffer is present immediately before NVRAM,
> suffixed by a footer containing a magic number and the buffer length.
>
> This won't affect chips/firmwares that do not use this feature, so do it
> unconditionally for all Apple platforms (those with an Apple OTP).

Following on from the conversation a year ago, is there a way to
detect chipsets that need these random bytes? While I'm sure Apple is
doing their own special thing for special Apple reasons, it seems
relatively sensible to omit a RNG on lower-cost chipsets, so would
other chipsets need it?

> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Beyond that, it all seems pretty sensible.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  .../broadcom/brcm80211/brcmfmac/pcie.c        | 32 +++++++++++++++++++
>  1 file changed, 32 insertions(+)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
