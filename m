Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76CB4A4C1D
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380428AbiAaQ3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380486AbiAaQ2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 11:28:17 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3DCC061401;
        Mon, 31 Jan 2022 08:28:16 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id r10so28040231edt.1;
        Mon, 31 Jan 2022 08:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SRGWD5HujtGaIfy6YI6sQxXDCuS1sXnoBeyNAfdeYfw=;
        b=ChnztWGFCtrmF8AR1r+RxPbBgCvUh0CFlJUcnaF52cf5G1sjhuI7GzfAEFXFuzTQkM
         JxycPhTVhoZtFs7XinEr+TOKblJu49ps9qXeBjK0ScLdwojro28qNzmRh10OqkWGwHhV
         vtBa+0kLeIc6limAZBPJAZC9EgPv4VCTLX07epyDEu+yiwKgbL9tsOV0KKnmC5ZnAHvn
         uH0fE/7Il/g8fhtNHrIh1RMxTB06zccccFG7TUwimrwW0oFiMF4+B9DkJlFQzDG04Sk9
         CxTtObvrEBHH9Cb9TRsJY4DhJHo9u5ENG96hEs47e66AFhqodn6kekntyKOXZRDPHCEY
         nqfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SRGWD5HujtGaIfy6YI6sQxXDCuS1sXnoBeyNAfdeYfw=;
        b=T1aG/0uPrrDJp4vfq+mKAMaGTA77ov1vzrTLtiNd7XWrQts0QYgbvnBasn/+aUAnr7
         xkHhvYNXs7uFSMHXS9UGBnsopwN9T65OFxvm2V+RMMnkK27QsPLJE2J46UgvcGnc9i3N
         QNQfKLkXxujvSS77a+yuvWmdgrF8SFOXf6ye2qIPlyTaha6s8Rbcd+BnJ0OYxo88JKsM
         csii3ZoeebIDq+uCbBCIC9xrqe2JIBUkcx76ypsac2xGzMWqrPUROFphprxLm9YztLJy
         yOxAymO/tp8+8E5UaGQQRHou5Qy+1BQ6VnWpSMKK/Fpjp1gTpDyu/hvD6sBNIZYcxv4U
         X/gg==
X-Gm-Message-State: AOAM530GuvSnHY2NtfjxNxvwbT7zySvKplP5Vs5XWpQjCetsQP1qh1PI
        u1zDdFcSfhp7k18lKi4Zp4KlEiet5ALJVlIA3A0=
X-Google-Smtp-Source: ABdhPJxN6zodTFR1sUdARmDocQ6DqGl7M4lBjebz7UFYoBxZ4kMltyMXUVtIA2lfAdrmFf2GE2DGhFAXGCGauiLOqqI=
X-Received: by 2002:aa7:d6c5:: with SMTP id x5mr20979293edr.29.1643646494962;
 Mon, 31 Jan 2022 08:28:14 -0800 (PST)
MIME-Version: 1.0
References: <20220131160713.245637-1-marcan@marcan.st> <20220131160713.245637-3-marcan@marcan.st>
In-Reply-To: <20220131160713.245637-3-marcan@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 31 Jan 2022 18:26:39 +0200
Message-ID: <CAHp75Vd8Yut7fSnyVnr-rYcK22DiZdnfofb+-DCJ6A5M9Y_VDg@mail.gmail.com>
Subject: Re: [PATCH v4 2/9] brcmfmac: firmware: Allocate space for default
 boardrev in nvram
To:     Hector Martin <marcan@marcan.st>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 6:07 PM Hector Martin <marcan@marcan.st> wrote:
>
> If boardrev is missing from the NVRAM we add a default one, but this
> might need more space in the output buffer than was allocated. Ensure
> we have enough padding for this in the buffer.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Fixes: 46f2b38a91b0 ("brcmfmac: insert default boardrev in nvram data if missing")
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> index 0eb13e5df517..1001c8888bfe 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> @@ -207,6 +207,8 @@ static int brcmf_init_nvram_parser(struct nvram_parser *nvp,
>                 size = BRCMF_FW_MAX_NVRAM_SIZE;
>         else
>                 size = data_len;
> +       /* Add space for properties we may add */
> +       size += strlen(BRCMF_FW_DEFAULT_BOARDREV) + 1;
>         /* Alloc for extra 0 byte + roundup by 4 + length field */
>         size += 1 + 3 + sizeof(u32);
>         nvp->nvram = kzalloc(size, GFP_KERNEL);
> --
> 2.33.0
>


-- 
With Best Regards,
Andy Shevchenko
