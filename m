Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABA31D76D7
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgERLYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:24:31 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:40584 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbgERLYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:24:30 -0400
Received: by mail-ot1-f65.google.com with SMTP id d26so7695593otc.7;
        Mon, 18 May 2020 04:24:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S+/xJo9DYFV5x/KGWI9bYykM6mq0Xnr1uVyyiFMOM94=;
        b=Y1TXobsoU2Lmp4U/8L5YGzh0WkqFwCw/MDZ87ObhHLJTWmtMOimQskBr1/pbdWjP75
         MJzrlD6TnptUtEaImuH9sNuPt4YyZY3kI/HTJ2Up2RSXirs4GYPSz0Fge7nicdEz/GXA
         QFVOLgiLVF0FCpbcs/Es3B5UpiA2WBiJE6tQOqg0k9esI9Xo0rtm0BDS8NTQRvTC52rI
         T2MUGuFN/USBlEWEvvu8A7v1EurJ9jMydykR8leyxtxK7z6sN0sRdwm799HfTLh1wBbA
         R09IycWVjec5eWiT1qKk9BmSI0iz5xpu/HVR2h+lOnPH5CgksqfwPiBu4DvmfixZXtoV
         hKKQ==
X-Gm-Message-State: AOAM5312P1nLMyt2BTLykHafZ924Fj7G0tJKVbPDOAEitDbdmca0qxiM
        EkRPKMopYj89LiZqofOeAGvu6VLLt0g0JqaA9SA=
X-Google-Smtp-Source: ABdhPJwNoxButZwgH4SDPteHjBuwwMLD1bqxVYkjDcQmRozmQtDNJ0fFE+TRSmeEzroqrNyEaK173xc8SAa+z83VsXs=
X-Received: by 2002:a05:6830:18d9:: with SMTP id v25mr7897454ote.107.1589801068351;
 Mon, 18 May 2020 04:24:28 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-6-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com> <20200515171754.GF19423@ninjato>
In-Reply-To: <20200515171754.GF19423@ninjato>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 May 2020 13:24:15 +0200
Message-ID: <CAMuHMdXgRgP8acDzn-p31wmomEbzFXJ2i2vOW1ppuHP-K6-UpQ@mail.gmail.com>
Subject: Re: [PATCH 05/17] mmc: renesas_sdhi_sys_dmac: Add support for r8a7742 SoC
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wolfram, Prabhakar,

On Fri, May 15, 2020 at 7:17 PM Wolfram Sang
<wsa+renesas@sang-engineering.com> wrote:
> On Fri, May 15, 2020 at 04:08:45PM +0100, Lad Prabhakar wrote:
> > Add support for r8a7742 SoC. Renesas RZ/G1H (R8A7742) SDHI is identical to
> > the R-Car Gen2 family.
> >
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
>
> I think we can skip this because of the generic fallback? The other

Agreed.

> entries come from a time when we had a different policy IIRC.

Indeed.  Commit c16a854e4463078a ("mmc: renesas_sdhi: Add r8a7743/5
support") predated commit d6dc425ae595e140 ("mmc: renesas_sdhi:
implement R-Car Gen[123] fallback compatibility strings").

> > --- a/drivers/mmc/host/renesas_sdhi_sys_dmac.c
> > +++ b/drivers/mmc/host/renesas_sdhi_sys_dmac.c
> > @@ -75,6 +75,7 @@ static const struct of_device_id renesas_sdhi_sys_dmac_of_match[] = {
> >       { .compatible = "renesas,sdhi-r7s72100", .data = &of_rz_compatible, },
> >       { .compatible = "renesas,sdhi-r8a7778", .data = &of_rcar_gen1_compatible, },
> >       { .compatible = "renesas,sdhi-r8a7779", .data = &of_rcar_gen1_compatible, },
> > +     { .compatible = "renesas,sdhi-r8a7742", .data = &of_rcar_gen2_compatible, },
> >       { .compatible = "renesas,sdhi-r8a7743", .data = &of_rcar_gen2_compatible, },
> >       { .compatible = "renesas,sdhi-r8a7745", .data = &of_rcar_gen2_compatible, },
> >       { .compatible = "renesas,sdhi-r8a7790", .data = &of_rcar_gen2_compatible, },

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
