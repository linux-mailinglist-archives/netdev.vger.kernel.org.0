Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5038F4A4C24
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbiAaQaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbiAaQaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 11:30:03 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C37C061714;
        Mon, 31 Jan 2022 08:30:03 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id k25so44437396ejp.5;
        Mon, 31 Jan 2022 08:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vRDplifUhsb5m6qIz40Anhg2xj6DslUkXFz6GsVymy4=;
        b=D93WKL0bH3y0DsemI7NcPaBG2KnCtuCJsu1Kw+N+S/H4CUAQsHVB2XSUXCiMQXeqJp
         vSdxRC6Lp34sxJEQZaapbcutOoLdIpe6q0qqcvGnEXInFE/3jRUl2dFKFFAxwCrcsvQz
         R9OaaN0daXTLHr27vJo3gSJlzS8kcXWUc5yjsuiylmQLpnk6jPlx60odaFILHliLwy2N
         LMuaJrLRjx+ioy1WHnxzDNgEnu8Zqg7uOl+3phVC4d3EwYl8PyB5dgt8JTyEdy6EemdL
         th8OghN8ysl/lzJV1BeGWvu/BSp8KfEpWjw5hd17vz26Se44IzXpg2BN3SM9LeLRpORx
         XREw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vRDplifUhsb5m6qIz40Anhg2xj6DslUkXFz6GsVymy4=;
        b=adz9dvfYFwxHLCb3+6bW7gS8i6tSDL1bwN7f5oFEn+ca1TMtSZYkIhVnjH2Tiu9F0L
         4VGQl7uo8cHECy2F+50Dte/hFyv83TBr/Be2lDz0H38h4Y77kkyYhJNDU9eAzsKBLy1e
         4sdrQUD5bfjZ3hcDT3ZiPzsRE7KsHxnMLf+V1h7tA5Rk7fhJ70EAVM6sjkebm35U+WEV
         /uoVO+g9Nd4s0xQdPmZl4jV9lMpeAvVYvK/R7x+Z+hLcy3k3bLuSxgXZkgXr4MtIBGLq
         G5SjBI/6QzrEiHGTkRxqctsykuWQbess1xFylUxytTEM3PwUN5iS3YgF2Zg9sW+Wtbhi
         Kfxg==
X-Gm-Message-State: AOAM530juDAlGqrjSMEK7/gPwVIcU2TUGxhadM3s5+SUCF9nlr+5WiS3
        awZLvV5W9ALn1A/sh1yLC9Xc9KTTMHYeI8yJ7bI=
X-Google-Smtp-Source: ABdhPJwH3lAp3JlumSNQ61ldPCI4Vyq+OLtFCZ0qJsy2dxhZ6fQQm1lW9Qqm6EetQhoC0xmpiPhNQt1zsrbA/2qNhWo=
X-Received: by 2002:a17:906:7948:: with SMTP id l8mr17420594ejo.636.1643646601634;
 Mon, 31 Jan 2022 08:30:01 -0800 (PST)
MIME-Version: 1.0
References: <20220131160713.245637-1-marcan@marcan.st> <20220131160713.245637-4-marcan@marcan.st>
In-Reply-To: <20220131160713.245637-4-marcan@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 31 Jan 2022 18:28:25 +0200
Message-ID: <CAHp75VdgXdYXio8pTDdxsYy-iCXMvVpZM1T6gNmcxo3c1V+uJA@mail.gmail.com>
Subject: Re: [PATCH v4 3/9] brcmfmac: firmware: Do not crash on a NULL board_type
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
> This unbreaks support for USB devices, which do not have a board_type
> to create an alt_path out of and thus were running into a NULL
> dereference.

...

> @@ -599,6 +599,9 @@ static char *brcm_alt_fw_path(const char *path, const char *board_type)
>         char alt_path[BRCMF_FW_NAME_LEN];
>         char suffix[5];
>
> +       if (!board_type)
> +               return NULL;

I still think it's better to have both callers do the same thing.

Now it will be the double check in one case,

-- 
With Best Regards,
Andy Shevchenko
