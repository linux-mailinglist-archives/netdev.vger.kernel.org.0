Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E3A3CB4FD
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 11:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239104AbhGPJFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 05:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbhGPJFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 05:05:21 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F60C06175F;
        Fri, 16 Jul 2021 02:02:27 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id v189so13735149ybg.3;
        Fri, 16 Jul 2021 02:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cIlG7Tj9PHyebgVnc/iO72vl2A3TQGm2yNs4i4yWOOU=;
        b=fBRyinH2auRaW9VIjTG5wuhme+khhzh95O8QGjyGLLHSKjsDmpWtA/VF7HcPLJ9gbo
         5VwU5bebcUVWTaaklRRm69PmicVKPVvjlzzohECC5oRVOJ0UbA8OGH8t3BRCDeezJgwX
         C9zekLGi5deY5C4huxsgPL/H9psWfPrVbGJdk5RynO542q0BRQ9PUgn8KbDt0dFNiKz1
         Yxk6hCjk0csqtFYncP7l6u5jioXRB+Md9P9NINnE89OUr/XiAYfzP2HUzyxFMYrj0KLj
         2sTBqouS+/m/nRj95/hyB2ZQN5vaZn3NmXIyYuI42hvBJvb5A73lkUXFNPOoG/dkWXov
         1EsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cIlG7Tj9PHyebgVnc/iO72vl2A3TQGm2yNs4i4yWOOU=;
        b=qQy4jA3e4vhySIlwOUUNjqXeurAGW2Nos+7MCoCLbinobn6v4FJv4w7rh1ABqDATzf
         BArYBr0uKLeu8LB06mgjd7RiYrn+Em1ykS25gVPImZiFGHQZFao3w+VPXfD+TMiHbuMd
         R0Ql4aNgcrUjxlJIevPGE4FenBmUkHIymAEpbG8oIipBh+9kfUQVoPdjRuLleXqWfo+x
         SeAdZno1T10ENkx3fU7G3Dr7hQRVLp1ai4aFIC+cNPbR66KiFvbVaz6DgikVy78TaFUl
         A1JJrLGPuDZqWOSesBCOH/0uv0lqWuMJ9p5uhGbzMJtVp72TiakiU3dWT7LbNkizkaTY
         ep0g==
X-Gm-Message-State: AOAM530jAcILAquGisPNUD19GoXVlO0yPf7Hmz5obPXvo6WS1DB+lHME
        pxN7xEfbnRG4NnbXqDSUnTqxYOxTK9SfV0S9ahc=
X-Google-Smtp-Source: ABdhPJzjZH+UpiII0wGH5jTfkZY4AH/3/G0jav7ObOm0JDClSdgeFVXQOBQAE0iXvC9eFeyGX7vYwHMNfgK5VhLCc74=
X-Received: by 2002:a25:d491:: with SMTP id m139mr11115293ybf.156.1626426146574;
 Fri, 16 Jul 2021 02:02:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210715182123.23372-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210715182123.23372-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <CAMuHMdV3JkV5D5_PsngoLiLPA_B1VBvRKsCz7j2tXKYVE_Bx9A@mail.gmail.com>
 <CA+V-a8v5m-F-n4E9HpwLe1C9gHWepTc0rCVk5oh5RCJ7oTXe2A@mail.gmail.com> <CAMuHMdWBqLcCGWkP9JoALuiXT1m9a1rRwR8ExShUQmJ1HCikZA@mail.gmail.com>
In-Reply-To: <CAMuHMdWBqLcCGWkP9JoALuiXT1m9a1rRwR8ExShUQmJ1HCikZA@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Fri, 16 Jul 2021 10:02:00 +0100
Message-ID: <CA+V-a8v9H5T_eNn3j2Eb4iS9Stww0y8kFxNPqX_R7qePY0kKww@mail.gmail.com>
Subject: Re: [PATCH 3/6] dt-bindings: clk: r9a07g044-cpg: Add entry for
 P0_DIV2 core clock
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

On Fri, Jul 16, 2021 at 9:56 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Prabhakar,
>
> On Fri, Jul 16, 2021 at 10:45 AM Lad, Prabhakar
> <prabhakar.csengg@gmail.com> wrote:
> > On Fri, Jul 16, 2021 at 9:08 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > On Thu, Jul 15, 2021 at 8:21 PM Lad Prabhakar
> > > <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> > > > Add P0_DIV2 core clock required for CANFD module. CANFD core clock is
> > > > sourced from P0_DIV2 referenced from HW manual Rev.0.50.
> > >
> > > OK.
> > >
> > > > Also add R9A07G044_LAST_CORE_CLK entry to avoid changes in
> > > > r9a07g044-cpg.c file.
> > >
> > > I'm not so fond of adding this.  Unlike the other definitions, it is
> > > not really part of the bindings, but merely a convenience definition
> > > for the driver.  Furthermore it has to change when a new definition
> > > is ever added.
> > >
> > Agreed will drop this.
> >
> > > > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > > > Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> > > > ---
> > > >  include/dt-bindings/clock/r9a07g044-cpg.h | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/include/dt-bindings/clock/r9a07g044-cpg.h b/include/dt-bindings/clock/r9a07g044-cpg.h
> > > > index 0728ad07ff7a..2fd20db0b2f4 100644
> > > > --- a/include/dt-bindings/clock/r9a07g044-cpg.h
> > > > +++ b/include/dt-bindings/clock/r9a07g044-cpg.h
> > > > @@ -30,6 +30,8 @@
> > > >  #define R9A07G044_CLK_P2               19
> > > >  #define R9A07G044_CLK_AT               20
> > > >  #define R9A07G044_OSCCLK               21
> > > > +#define R9A07G044_CLK_P0_DIV2          22
> > > > +#define R9A07G044_LAST_CORE_CLK                23
> > >
> > > Third issue: off-by-one error, it should be 22 ;-)
> > >
> > 23 was intentionally as these numbers aren't used for core clock count
> > we use r9a07g044_core_clks[] instead.
>
> It ends up as an off-by-one bug in the range check in
> rzg2l_cpg_clk_src_twocell_get().
>
Ooops missed that!

Cheers,
Prabhakar

> > Said that I'll drop this.
>
> OK.
>
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
