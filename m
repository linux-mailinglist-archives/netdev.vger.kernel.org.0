Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40FD388EFF
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 15:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353647AbhESN0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 09:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346776AbhESN0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 09:26:45 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F44C06175F;
        Wed, 19 May 2021 06:25:26 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id y36so1461936ybi.11;
        Wed, 19 May 2021 06:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o2yairP/6+4RZbe6rYEI6uszDalPkfCMP4sSPLox2S8=;
        b=l5Gk/KyYYvUiKXrzrrmbsWIiffFuywfT1DgM8rWwRicXZEJy58+UEmZBxkOmvWV2dF
         S14emLbK/ie0LUk6xP6+IOGx3vMrfN9oIZh1qNZnZqgCYiSKD548ewBFl6Yr68NGOpze
         xG1dslTjMR4D2E8Jxb+sxEWsU499RNHL7C8xK2ZC4d5ILEE2twduRgHfV9dcUmXGXVfl
         KeWOOKrvRpri+5vnpP4HC1R4OXdhqZPfdqbE/8XusDEjn+/g7KA8oX66ZDPS2qTuWIL9
         8OjZxetlHsmGBcfGtlW7GzNbVrghX1dlPPVaRL+oUw4M9k8IB8OaxMXKrEo4c2kAv4jY
         9M9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o2yairP/6+4RZbe6rYEI6uszDalPkfCMP4sSPLox2S8=;
        b=VyQXaQH7eyTIoO4bbOJV1481vMWqSqG7tbpbaMeTfN4PkGnxrml6hAGKT8yViG4arn
         +y43k79BC6794apIoJgV/ao/hVvqitlF94u9Yh0DDosS5DohevKU08lkiDuVat8Ox3U+
         H9aNTsA6X2lUBs0xCvtAR3eSsGMXGrnOtVF6KSSHt/F+dz2m04V6cd+CFLn//nA3V7Qk
         Q4dyXoGDmQTI3Fdezda/T1Embjg2Z4wFNEkgDCPkdLl1el9VQbLxT91mBPsclD28DUVw
         adVjCgbTDWFZTzgsrnMIjYypuj0AkSJ+KouHyYc9EEriMMsv1FvxKZiDG6lrwmf3SKPp
         klZg==
X-Gm-Message-State: AOAM532vnuWR17zh8hNGKfNXP/X9gW9vHAM8nWz0LTuwFd+PBrmGMXFR
        GGMBkkLRFbc9+5zjNC5WAW8m2eFATHu3hH0Khig=
X-Google-Smtp-Source: ABdhPJw5dEV+YDa0vQ81zp7UOcVw5DeMMldZfG5bLMxhDK5cja9cxmWrozmWJ2xs19D20lpyzxJ9tPxk9qauONXvt+I=
X-Received: by 2002:a25:3c87:: with SMTP id j129mr634113yba.141.1621430725641;
 Wed, 19 May 2021 06:25:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210511214605.2937099-1-pgwipeout@gmail.com> <YKOB7y/9IptUvo4k@unreal>
 <CAMdYzYrV0T9H1soxSVpQv=jLCR9k9tuJddo1Kw-c3O5GJvg92A@mail.gmail.com>
 <YKTJwscaV1WaK98z@unreal> <cbfecaf2-2991-c79e-ba80-c805d119ac2f@gmail.com>
 <YKT7bLjzucl/QEo2@unreal> <CAMdYzYpVYuNuYgZp-sNj4QFbgHH+SoFpffbdCNJST2_KZEhSug@mail.gmail.com>
 <YKUK8hBImIUFV35I@unreal> <20210519131512.GA30436@shell.armlinux.org.uk>
In-Reply-To: <20210519131512.GA30436@shell.armlinux.org.uk>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Wed, 19 May 2021 09:25:14 -0400
Message-ID: <CAMdYzYpgVda9D2scNZMFmA_+xFf1p9-T-NpDmnOKeAFWHnsfHg@mail.gmail.com>
Subject: Re: [PATCH] net: phy: add driver for Motorcomm yt8511 phy
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 9:15 AM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Wed, May 19, 2021 at 03:56:18PM +0300, Leon Romanovsky wrote:
> > I'm sorry that I continue to ask, but is net/phy/* usable without MODULE?
>
> Simple answer: it is.

As far as I can tell, so correct me if I'm wrong, MODULE_DEVICE_TABLE
is what permits the module system to automatically load the correct
module for the device.

>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
