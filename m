Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50CB72ADC2D
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 17:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgKJQak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 11:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKJQak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 11:30:40 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DB0C0613CF;
        Tue, 10 Nov 2020 08:30:40 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id v12so11871077pfm.13;
        Tue, 10 Nov 2020 08:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Emb5D9r6vMHQJaEak29n+N1kdy4zO6KUWrIUTneLBuA=;
        b=KwVcNwoaZUVIsJ7CPNOmwmBCeNBSuC/UrOIDzWAvLPJMMAKYGyLVTvgaczyoqb8FCQ
         1c9vI7nEXtfXHENvngRyNRQDw8qVpWnbBopZrL3w4yFV0p1JlpinDoj9BR2Opy0qiTxa
         LFB9snRr255eu/iHxvfgyhrMZ81yrsOedZoWapUPqNwI41hezobZOGorYjqjpyEihN9L
         EoJiOHfPAn8ocKWgLPFU0cFEmC6XJmsPe4Tzy0OwGMER/1G0nzT6DKDy/pQz6264HszE
         JYbyzeYu30l+XMqsR8tCAyoObX4RYzzFuL3AcWC4pUyOWUhkWT5guIC9eE7W6w1gvLEp
         bkNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Emb5D9r6vMHQJaEak29n+N1kdy4zO6KUWrIUTneLBuA=;
        b=obsPEiEuSznbBq8V0/GBU4uzLlvdgYolFE3rQjDL9IV4hVWM2ZPkJXPrAo1PMxuTqu
         58pGsjQs+Uy7PSWQnytJfK1L820k34Mi0ZZErs68iVotTDCgG0YtHzqycF+CWXCzXrj2
         TtPmbjtaOSFANe3CxNV9Z6Zzk/QPsF1SV5OxGJBoDDEDUJ4vHNM26+2Da6OvxBnITvHi
         cfv4+IlE7EKjm8rL5LSFCOYyZ+HCAQsVXJXaNxzgvhIOlx5oh7JdgNUdX4QK34I0d+YX
         Gn/WCU4M9+BTmOiNAnZQIydclHHvrEPgE5/lHfzGfvWiUCP+a9j4OBRypYh4w4vS7Z1h
         0xsw==
X-Gm-Message-State: AOAM533f7nk6x7S6SmxEtDN1xGYA8UkI8A2+jxUAiqqNJ9RZFu7jxyT2
        luPRaAdU9YPev1ZIeGwB79Dg7cvCwIyn68O44uPo33kAqS1l1A==
X-Google-Smtp-Source: ABdhPJyY0453AcBPMxoZFi1CIwxdJZwtVD04o73CzpSKHWth3PJ3hVVfK5CtNjnLjtzEhr+F6cT7YPfm5EByAZw29gQ=
X-Received: by 2002:a63:3e05:: with SMTP id l5mr17259587pga.74.1605025839839;
 Tue, 10 Nov 2020 08:30:39 -0800 (PST)
MIME-Version: 1.0
References: <20201110142032.24071-1-TheSven73@gmail.com>
In-Reply-To: <20201110142032.24071-1-TheSven73@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 10 Nov 2020 18:31:28 +0200
Message-ID: <CAHp75Ve7jZyshwLuNKvuk7uvj43SpcZT_=csOYXVFUqhtmFo3A@mail.gmail.com>
Subject: Re: [PATCH net v2] net: phy: spi_ks8995: Do not overwrite SPI mode flags
To:     Sven Van Asbroeck <thesven73@gmail.com>
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

On Tue, Nov 10, 2020 at 4:20 PM Sven Van Asbroeck <thesven73@gmail.com> wrote:
>
> From: Sven Van Asbroeck <thesven73@gmail.com>
>
> This driver makes sure the underlying SPI bus is set to "mode 0"
> by assigning SPI_MODE_0 to spi->mode. Which overwrites all other
> SPI mode flags.
>
> In some circumstances, this can break the underlying SPI bus driver.
> For example, if SPI_CS_HIGH is set on the SPI bus, the driver
> will clear that flag, which results in a chip-select polarity issue.
>
> Fix by changing only the SPI_MODE_N bits, i.e. SPI_CPHA and SPI_CPOL.

I see that this is a fix for backporing, but maybe you can send a
patches on top of this to:
  1) introduce
 #define SPI_MODE_MASK  (SPI_CPHA | SPI_CPOL)

> +       /* use SPI_MODE_0 without changing any other mode flags */
> +       spi->mode &= ~(SPI_CPHA | SPI_CPOL);

2)
       spi->mode &= ~SPI_MODE_MASK;

> +       spi->mode |= SPI_MODE_0;

?

-- 
With Best Regards,
Andy Shevchenko
