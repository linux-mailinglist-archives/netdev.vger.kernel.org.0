Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B592C8070
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 10:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgK3I7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 03:59:16 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45981 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgK3I7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 03:59:15 -0500
Received: by mail-ot1-f67.google.com with SMTP id k3so10557141otp.12;
        Mon, 30 Nov 2020 00:59:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X8FoExwOHfGwv6em4eg1AHlrFN+EBui3VH6c7kGHW8M=;
        b=tYehXjYZRFKCAprWD2yeGaK3EmRIMutMS9Nh0HLxZ/lGfu0Lz9zh1k0S1RW3o5iVt4
         KYrbmsdtLejLO0B5T9vBb8MBgSHh/1SUH4enn/VEkyoL2q3zus7tbR9x0fIyGvo/UiSy
         Hnvdesa9ovkigevLmcAvq7MNNaCSkQIyHOI9IoZi+DBJPjQJ/7pa6/d0cWnk9UW55qwE
         EcsNYVeZcLCwQbzazgrjAQ9VsGjE49TsmoSrSNTvypVlY1X2pL1wlgQrGXOBRVoYzvWf
         cXvy8g31g2Bj5KBaFNlujwmRlozSiJRmi8p3/AUkaiu45qUls8bXmvuieh2uznjjI13/
         2eNg==
X-Gm-Message-State: AOAM530NKsvpYaAatyMW3oNw4qJDjdElPqaZl93kImYqiWzb5OVUozGJ
        UFEygl3cBfV6dGK97lHWmdRyvPpTgoHFYMmMX+E=
X-Google-Smtp-Source: ABdhPJyrxbQKboqBlxNa7SnfyzU9JOt4/0bUzb0T5TziKWmjRC/+Hn6sbqGLcmZKse22Dhoci+I3ZQs7I9ocW0SW4DY=
X-Received: by 2002:a9d:686:: with SMTP id 6mr14830891otx.107.1606726714613;
 Mon, 30 Nov 2020 00:58:34 -0800 (PST)
MIME-Version: 1.0
References: <20201128122819.32187696@canb.auug.org.au>
In-Reply-To: <20201128122819.32187696@canb.auug.org.au>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 30 Nov 2020 09:58:23 +0100
Message-ID: <CAMuHMdVJKarCRRRJq_hmvvv0NcSpREdqDbH8L5NitZmFUEbqmw@mail.gmail.com>
Subject: Re: [PATCH] powerpc: fix the allyesconfig build
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        PowerPC <linuxppc-dev@lists.ozlabs.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Daniel Axtens <dja@axtens.net>, Joel Stanley <joel@jms.id.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On Sat, Nov 28, 2020 at 2:28 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> There are 2 drivers that have arrays of packed structures that contain
> pointers that end up at unaligned offsets.  These produce warnings in
> the PowerPC allyesconfig build like this:
>
> WARNING: 148 bad relocations
> c00000000e56510b R_PPC64_UADDR64   .rodata+0x0000000001c72378
> c00000000e565126 R_PPC64_UADDR64   .rodata+0x0000000001c723c0
>
> They are not drivers that are used on PowerPC (I assume), so mark them
> to not be built on PPC64 when CONFIG_RELOCATABLE is enabled.
>
> Cc: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Michael Turquette <mturquette@baylibre.com>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
> Cc: Salil Mehta <salil.mehta@huawei.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Nicholas Piggin  <npiggin@gmail.com>
> Cc: Daniel Axtens <dja@axtens.net>
> Cc: Joel Stanley <joel@jms.id.au>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Thanks for your patch!

> --- a/drivers/clk/renesas/Kconfig
> +++ b/drivers/clk/renesas/Kconfig
> @@ -151,6 +151,10 @@ config CLK_R8A779A0
>         select CLK_RENESAS_CPG_MSSR
>
>  config CLK_R9A06G032
> +       # PPC64 RELOCATABLE kernels cannot handle relocations to
> +       # unaligned locations that are produced by the array of
> +       # packed structures in this driver.
> +       depends on !(PPC64 && RELOCATABLE)
>         bool "Renesas R9A06G032 clock driver"
>         help
>           This is a driver for R9A06G032 clocks

I prefer to fix this in the driver instead.  The space saving by packing the
structure is minimal.
I've sent a patch
https://lore.kernel.org/r/20201130085743.1656317-1-geert+renesas@glider.be
(when lore is back)

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
