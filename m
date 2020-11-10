Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DFB2ADC94
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 18:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbgKJRGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 12:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbgKJRGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 12:06:49 -0500
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54405C0613CF;
        Tue, 10 Nov 2020 09:06:49 -0800 (PST)
Received: by mail-vk1-xa44.google.com with SMTP id i3so1741944vkk.11;
        Tue, 10 Nov 2020 09:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S2hWuyWxfHf1nsWdsAhIbK8CXsUZ34HwpLnb4gds8BU=;
        b=lW6eap4yjPFwd1xqWN/nDsAprEZlgu9pTkSR9mnNtKq9hNOXXSnfbZKvaK8g983w+k
         +5/MCRNK1AiIEr9DM/ogps8y3szbop8gag+BjlFGjPNqnN3uBiWgTP2daIahCSO3tiJ+
         xpgZzkWV6FeGT7w+G55XkKUHDMULe4kHUhE98YPgah3hkG0gaRvd+JW60JI9P1gWOO8F
         yVlZP9F2ehj+sP8PvvrqHC1iwLngn2Ue6osK9rmegIubwPxBFY5MYxUoqZySwj5DACt9
         BWxiab/Dq3GHmXPqcUZHQ4KL2T85Z7zaK7lZ3OK4qAPg02WYiseVqF5HcVEZ6rytoujr
         /lqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S2hWuyWxfHf1nsWdsAhIbK8CXsUZ34HwpLnb4gds8BU=;
        b=c8C708/0Rdqv+F9z0RAQ+rPZxP5CaUgncP5Ps5F0k0QNb7dkZEh65o5oXCjNZoPUP+
         WkJXWecdaqgFA0xo7xKUgsGeL3Gi9RKIrPRZQDvO0bv0Gw6j0UKFRnNhJ1VAabjMStrh
         OR2rSjCs/qSi6yWSh+tn+ML9NA2LBIErLOhH4cpvPuCx56k34T8CedJp4kp/8wUK3aUV
         O0ySE/S/3540Xlqni+EyDPaKkG9mLqPO0cKa1xKbF4pBi9uO6YzIvgu2gc5oxJSqBsz9
         3V74mlqXHGZauDliBgvUHnJafXu3pd9J/W2/e3m89pQ0favyoDap/G0RmxPKddwzD/1e
         yC1w==
X-Gm-Message-State: AOAM533oBfk86YW9H7hgCX9HQMIpJsGej5IRXa0rdHyGlKKO3OnKfmRP
        +ZIStw8eh7g+qmoq0fI62xvCinL80iBNw0kkfyRA3WZq
X-Google-Smtp-Source: ABdhPJzdhz3B1Nkrey7mX9SwbyLt0HkCknfCWhlRzq6S8L9mLF1ihwVNQ1vecQE7/g9Mu7sHMVpk+WHFgYSswxoiE10=
X-Received: by 2002:a1f:5587:: with SMTP id j129mr11529056vkb.0.1605028008315;
 Tue, 10 Nov 2020 09:06:48 -0800 (PST)
MIME-Version: 1.0
References: <20201110142032.24071-1-TheSven73@gmail.com> <CAHp75Ve7jZyshwLuNKvuk7uvj43SpcZT_=csOYXVFUqhtmFo3A@mail.gmail.com>
In-Reply-To: <CAHp75Ve7jZyshwLuNKvuk7uvj43SpcZT_=csOYXVFUqhtmFo3A@mail.gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Tue, 10 Nov 2020 12:06:37 -0500
Message-ID: <CAGngYiV6i=fsySH35UgL2fKiNp1VAfdkJ=hrZ8nmMn_1fkaa-Q@mail.gmail.com>
Subject: Re: [PATCH net v2] net: phy: spi_ks8995: Do not overwrite SPI mode flags
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Frederic LAMBERT <frdrc66@gmail.com>,
        Gabor Juhos <juhosg@openwrt.org>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        linux-spi <linux-spi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PING Jakub

On Tue, Nov 10, 2020 at 11:30 AM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> I see that this is a fix for backporing, but maybe you can send a
> patches on top of this to:
>   1) introduce
>  #define SPI_MODE_MASK  (SPI_CPHA | SPI_CPOL)
>        spi->mode &= ~SPI_MODE_MASK;
> > +       spi->mode |= SPI_MODE_0;
>
Jakub,

Is it possible to merge Andy's suggestion into net?
Or should this go into net-next?

Thank you,
Sven
