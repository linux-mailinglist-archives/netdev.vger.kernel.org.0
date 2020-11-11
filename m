Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3707A2AF5B9
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 17:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgKKQDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 11:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727449AbgKKQDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 11:03:49 -0500
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCECC0613D1;
        Wed, 11 Nov 2020 08:03:49 -0800 (PST)
Received: by mail-vs1-xe41.google.com with SMTP id t8so1444033vsr.2;
        Wed, 11 Nov 2020 08:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D688jg4M+etuC7EpYy8xu4NpHHM16onVnkpm0PnCHSE=;
        b=EUVSumJRdY0k1MZnLF87QI4teakp/ioGjlxubbDNbipGpb1jusqpdfbpGluzMARVYZ
         Ntpic0dA7/DDhld7e9nhodJrSALDAac49lQlnSJTpybritrAxdf6o6KAS5a8mb1Q517F
         MBlbovHIhXkkLgVD71UcKRK6jzCHPcH6eqeFjwupM2sNc2zXREHiIwpBcMY8di2Sh5HQ
         iDgjDiSQV8QQWu7xhRcHg2/FcM/KAY7OT85E/EWW/PeDc1XRmZGOhfGoZ576n/05mT5p
         msjhvQ3fCkZHHrtGsUdtj+iBcQCaeVcJ+gwXR+XWx32FN+kOWj+hBqaA4LNfNYkI3sAH
         BzZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D688jg4M+etuC7EpYy8xu4NpHHM16onVnkpm0PnCHSE=;
        b=baKaBQfrinK9msQ7RHG8uvFzAkIfNr6tTYl5mo23XcdfFmDwueakP5R7x8eXWL2fWl
         boQKDXhYp9wSs+W67NGN4UqQAQyIQc/DnHPWllX7F8NNKqj22SaGJOwWTelWP2zjI4H8
         ha3Acwilou+BCMGzc6k6ETHprtPxEkmSH/HhrCWztweBETBx59d+oFLfKiPvsNYxDmSx
         SUY8fDsEZnFJpQbL8//QRotAo16pkse4kebv5crRQOAInvrqkuGnrEO3bCymofeoTuH4
         g/8DvmllWrB+b7WdTMsze45veIrveaiiu/MkDRM26STRBHN8VHl4MD1jItkSdzW6RIF3
         BjNA==
X-Gm-Message-State: AOAM533yW56bZ9S8L0p4eYtEhHd7IO02CYh1Sm3YX7Ar4MT1hJESNg6U
        Fr/wuEhdfeTjTKTYZ7aj44fawQEiXBKZ9o2FBOY=
X-Google-Smtp-Source: ABdhPJx6dKfkko6dw4C422lE0JZk0ZIW2NnYWaOwinI5G9DsXjc9yecsD8la7prLfBL0eyvFO0AoZUgTtltyTG6JNyc=
X-Received: by 2002:a67:2c53:: with SMTP id s80mr16661846vss.12.1605110628574;
 Wed, 11 Nov 2020 08:03:48 -0800 (PST)
MIME-Version: 1.0
References: <20201110142032.24071-1-TheSven73@gmail.com>
In-Reply-To: <20201110142032.24071-1-TheSven73@gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Wed, 11 Nov 2020 11:03:37 -0500
Message-ID: <CAGngYiVftXwcYbeSgXtiu9aMUG6GQTAcON=CK32o5=YLM40g4A@mail.gmail.com>
Subject: Re: [PATCH net v2] net: phy: spi_ks8995: Do not overwrite SPI mode flags
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Frederic LAMBERT <frdrc66@gmail.com>,
        Gabor Juhos <juhosg@openwrt.org>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        linux-spi <linux-spi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A spi core fix has been accepted which makes this patch unnecessary.

https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git/commit/?id=766c6b63aa044e84b045803b40b14754d69a2a1d

On Tue, Nov 10, 2020 at 9:20 AM Sven Van Asbroeck <thesven73@gmail.com> wrote:
>
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
>
> Fixes: a8e510f682fe ("phy: Micrel KS8995MA 5-ports 10/100 managed Ethernet switch support added")
> Fixes: f3186dd87669 ("spi: Optionally use GPIO descriptors for CS GPIOs")
> Link: https://patchwork.kernel.org/project/spi-devel-general/patch/20201106150706.29089-1-TheSven73@gmail.com/#23747737
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
> ---
