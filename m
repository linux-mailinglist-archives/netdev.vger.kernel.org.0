Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E823F494C36
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 11:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiATKyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 05:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiATKyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 05:54:00 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D93C061574;
        Thu, 20 Jan 2022 02:54:00 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id cx27so27081209edb.1;
        Thu, 20 Jan 2022 02:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rueY/jFC2lLrcjtQ698sMwfakQXnY26l1d8Z0p1kGzY=;
        b=auLHWOAe3eLtUNRB3I/GnroHB9vg/WLVbd9NGSlwq2h+rIeyZH+SKh06qHVXiFcb8f
         uaP5tk8wF84oK+Hbfr3uMQbhw5K0PhDKKZ3EqCrsccaGA2a9DCYMfk06T+1GVwbfxisi
         ux+RFoTRcNJYsSVpS0Dx3lDQ57yBbv+lrzCWTBGtW5a2UPrsKrMS37iIwI2CcCz9+rgS
         rpj42xGjO8qh5hvMJt9pgXsa4TK6tgP2a4wQ8RN9hqBIP5luq1IUSZgiel0Dlt3i+vEl
         /wcGnxCKVrwphXZ1IbGQKdPCM1yhyDSZJgcADt1jQIEygY43mxzRvVj/GHjhc87yo5CV
         qiiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rueY/jFC2lLrcjtQ698sMwfakQXnY26l1d8Z0p1kGzY=;
        b=sF2HqiVwfIXNqqcGiuBf5nYMOwtvmBhS3b+Issex0v+uLzrEWmOvF1Bs25OWaJwBZc
         /tU8bVfrktRP6/bByM+q+y6OW/RYZmld0vpIzRAxaG+9Y6BsGZnbfsTP2NIegqcOjNaL
         LVXr+akzvKrBBDC9RpxiSMO6mIp8hULOPz5kOOO84RB0/iw3ErBTHlReRwoTTdX3D5vY
         9On2EYfUFV53GUI05sHVXeecsICHXIqOUBf+cBNLhfzytcLFKm+FOuOebv19mFXY3dye
         qzLyAHWZzO8pcRcUb6lkz+jZtcojLrcqceYbmiGsG5Et0z0dzapzqS4Rc7n7nCRzKEfG
         udQQ==
X-Gm-Message-State: AOAM533SwplEnSPyzdyWV5Hny0LArUATWkIHW+xV84kyK7iwOfgd3MG4
        LlgUySgDypix9AZjx0XEDYK6oHdqBHQ8H2SFpY8=
X-Google-Smtp-Source: ABdhPJxGiMU1xrv7ZzwueN4iKsoTSUGlAYddhd/BYPDmdrQuY89UiTfUdv/qHPTtG90np5GBNclAJjIoXTK8m1rJRVM=
X-Received: by 2002:a17:907:968c:: with SMTP id hd12mr27927990ejc.639.1642676038694;
 Thu, 20 Jan 2022 02:53:58 -0800 (PST)
MIME-Version: 1.0
References: <20220117142919.207370-1-marcan@marcan.st> <20220117142919.207370-8-marcan@marcan.st>
In-Reply-To: <20220117142919.207370-8-marcan@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 20 Jan 2022 12:52:16 +0200
Message-ID: <CAHp75Vfj-uqzmY24ByXLnhgyhEuaGpZckdczwUf=2OXL3aBuog@mail.gmail.com>
Subject: Re: [PATCH v3 7/9] brcmfmac: of: Use devm_kstrdup for board_type &
 check for errors
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
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
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
        SHA-cyfmac-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 17, 2022 at 4:31 PM Hector Martin <marcan@marcan.st> wrote:
>
> This was missing a NULL check, and we can collapse the strlen/alloc/copy
> into a devm_kstrdup().

Nice patch. After dropping the message,
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

>                 /* get rid of '/' in the compatible string to be able to find the FW */
>                 len = strlen(tmp) + 1;
> -               board_type = devm_kzalloc(dev, len, GFP_KERNEL);
> -               strscpy(board_type, tmp, len);
> +               board_type = devm_kstrdup(dev, tmp, GFP_KERNEL);
> +               if (!board_type) {
> +                       brcmf_err("out of memory allocating board_type\n");
> +                       of_node_put(root);
> +                       return;
> +               }

>                 for (i = 0; i < board_type[i]; i++) {
>                         if (board_type[i] == '/')
>                                 board_type[i] = '-';

Next step is to replace this with NIH strreplace()

And
  of_property_read_string_index(root, "compatible", 0, &tmp);
with
  of_property_read_string(root, "compatible", &tmp);

And might add an error check, but I believe if there is no compatible
property present, this can't be called.

-- 
With Best Regards,
Andy Shevchenko
