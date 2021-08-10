Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94FF43E5599
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 10:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbhHJIhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 04:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhHJIhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 04:37:38 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DCDC0613D3;
        Tue, 10 Aug 2021 01:37:16 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id s184so31204658ios.2;
        Tue, 10 Aug 2021 01:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gnPKMaU00UCLHLbaCu25WvQfF+nVyh7mG8iqPJwCTtU=;
        b=LLX2raXKGwA6gdGvRan7ZiuFcTgG877fDwmf9h56Rs9Qf1zP4xt0q1LEra87wWG2hg
         V7vJNWfsnwOgeco9xREfHgpzGBR1aAo1CvaP4y5wwYXbWgG6iC0PHyDyEwfBOfPAfTVT
         /ueM/ru81L6l3OHAr3hljOKA4XyaHSoDMvq5RHIv2BsV384ZCuSq3X0q32LEY2lWd0Mb
         gNTLj2FbxKC8N3L0c3iRxklk6ghnkuXUu4UBflJ9kpr6gShdpLYktjRjrNkW+aXwZAz/
         rsbQLF1BVLk1PXwmd43veJBpoIakkhA5TUTMwfRM9SAL8T0WVFwMivZoJiJ7ZuKW93j5
         lLqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gnPKMaU00UCLHLbaCu25WvQfF+nVyh7mG8iqPJwCTtU=;
        b=bTkiR9oj5Nq6mhoCczyio6fUNuX0oOVJodDbniWbFmKIldnMc0GgRKjLyYrLzoDUc+
         zSL5TEhgcBwNjR2Q8rycIv6et0aWIeUxy1UCCTcnyGv6TRQxWfkotISf4IMG+hm5274B
         ZWrC1hGn3EHuxbT4NyKBenfZ29RuG4QxCuPMisP5bZA0fdfa40KFFKjGdAPWRDSK4sG6
         zrOuwzMh/uCOLjLQLnn07kkiGSHG3LTbw8Rq9msOY5h8l0DQDx9OY7LnicU2LhjjqIq0
         wglAw7gWBQi+++2i25cL1qL8XEBbdHU/ZgHa3oxUgDJgbyho44mvLuQpDAxnTd2/UGfY
         4xlQ==
X-Gm-Message-State: AOAM533qzLEZ+/AHMu75dV6jfcqIPF9zFjBjguLpAtqrubefQ3yCMoQ3
        MAHehrwIevupsWV8IhbyR44n3A/nPLh7ywKPINY=
X-Google-Smtp-Source: ABdhPJz98UAvW3cm4tAjUP6zMkqSFBjRXQqCbocrq/OaqFGiue2x2yrK24wrwSM4UiaeeTqgVmwdzGbsY7Xbo/bgII0=
X-Received: by 2002:a05:6638:329d:: with SMTP id f29mr26485952jav.140.1628584636021;
 Tue, 10 Aug 2021 01:37:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210727133022.634-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210727133022.634-3-prabhakar.mahadev-lad.rj@bp.renesas.com> <CAMuHMdU7-AahJmKLabba_ZF2bcPwktU00Q_uBOYm+AdiBVGyTA@mail.gmail.com>
In-Reply-To: <CAMuHMdU7-AahJmKLabba_ZF2bcPwktU00Q_uBOYm+AdiBVGyTA@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Tue, 10 Aug 2021 09:36:50 +0100
Message-ID: <CA+V-a8vfnnfgK1cY8dqsPJUwotK7SZZu5MjeGuJTa--+qaN4gg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] can: rcar_canfd: Add support for RZ/G2L family
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

On Tue, Aug 10, 2021 at 9:27 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Prabhakar,
>
> On Tue, Jul 27, 2021 at 3:30 PM Lad Prabhakar
> <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> > CANFD block on RZ/G2L SoC is almost identical to one found on
> > R-Car Gen3 SoC's. On RZ/G2L SoC interrupt sources for each channel
> > are split into different sources and the IP doesn't divide (1/2)
> > CANFD clock within the IP.
> >
> > This patch adds compatible string for RZ/G2L family and splits
> > the irq handlers to accommodate both RZ/G2L and R-Car Gen3 SoC's.
> >
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
>
> Thanks for your patch!
>
> I've just noticed a set of silly typos:
>
> > --- a/drivers/net/can/rcar/rcar_canfd.c
> > +++ b/drivers/net/can/rcar/rcar_canfd.c
>
> > +static void rcar_canfd_handle_global_recieve(struct rcar_canfd_global *gpriv, u32 ch)
>
> receive (everywhere)
>
Ouch, I'll respin with the typo's fixed.

Cheers,
Prabhakar

> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
