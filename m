Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D6A3CFE91
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 18:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238101AbhGTPWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 11:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239812AbhGTPSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 11:18:16 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46784C06127E;
        Tue, 20 Jul 2021 08:56:56 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id c16so26655779ybl.9;
        Tue, 20 Jul 2021 08:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WnvkgdxtoAemKPJLVMVY6hqBu9goS/fqMgfnJCN6o5Y=;
        b=DfZdlfpB9mN4dbZ8DAGVh9rGPukd8Qb2dOC6nAI/GMp64aBSKlOxqoJqUkklal8mmi
         Wxq0TdLtRv4zS9DMnK6gDuYxs9sSf/vJhRtvYvpO0Nfl1+aE0a6RGhxu3LvtSMttQoN3
         iFguBYIF+scSIPVSo3OISIVSSb4yVuoVuWkvcbNsh6Uim+kPsJQC5e80kAjxIuIId/Ir
         B53P/vRmrpKXB/RhM6KoO4WtmpEfA1lxOeafoCGY7vnC3622TEtWRaSfBHI3BKOtu9xx
         3fOyeQTnCvtdz8N/2lfeLVhj49ecYt8XEEuIeo6Qzyw9oE0f5GTxOb8LYHTgKFCb138F
         AoCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WnvkgdxtoAemKPJLVMVY6hqBu9goS/fqMgfnJCN6o5Y=;
        b=g7Ivv75DOMtRyzRgbpTH85+KFfr5s/vxwpBd3Sgd6ve375bKs2HUTjYG6bUQGjDgCY
         5BtWudR62qNBByk/Mdc+lH7bSREFn6NrFrhlJ7nOewQr5ldDuUbcfZqlMXaH/qD6zI8a
         Q5O4yKeXXSuH/tFcZ2Z1XUQI6WxTQvQjGi0c0vXwTg2ZXcG586N8eU1/f9BzP7r+YoYF
         2lfiCj4Y815uMoNm5lvmTtDj7USx5PZd1WiarP9HX5DbQ/AC+MBxgeHITir5ff/T4jx7
         Z8wCwZvyDF6Sn+/b6YHyM1ekUSBx6/W21AV6IveGJE3/9oqRLE3VDJA3G9dr36vfUaPO
         Oq9A==
X-Gm-Message-State: AOAM5315RY58ssYhQkAl7sPoOw7V9f8bJl7jjKXPAxczjZM2m2YsfKs2
        OVyz22RQewtR0VukljKHTSdEOEAAMepibegowH8=
X-Google-Smtp-Source: ABdhPJwcLYTBQc1sWKW28kOeuJp5aYajJPTD3dd6Ctg+5bv2Sh4Mp1muP9ZdFeVJhMt1/OIu3K5lHGtHOJPD1wu06dA=
X-Received: by 2002:a25:cc52:: with SMTP id l79mr39052227ybf.476.1626796615519;
 Tue, 20 Jul 2021 08:56:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210719143811.2135-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210719143811.2135-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <dc2de27b087c7030ea7e76dd31bb3d8bce18d97f.camel@pengutronix.de>
 <CA+V-a8v-54QXtcT-gPy5vj9drqZ6Ntr0-3j=42Dedi-kojNtXQ@mail.gmail.com> <CAMuHMdVFarkF49=Vvcv-6NLhxbLUE33PXnqhAiPxpaCNN7u4Bw@mail.gmail.com>
In-Reply-To: <CAMuHMdVFarkF49=Vvcv-6NLhxbLUE33PXnqhAiPxpaCNN7u4Bw@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Tue, 20 Jul 2021 16:56:29 +0100
Message-ID: <CA+V-a8sKDGyBCYJnxH=_cJrbYFL1Ev4ETsjYEXx7fQsW-NYiYA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] dt-bindings: net: can: renesas,rcar-canfd:
 Document RZ/G2L SoC
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

On Tue, Jul 20, 2021 at 4:11 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Prabhakar,
>
> On Tue, Jul 20, 2021 at 4:31 PM Lad, Prabhakar
> <prabhakar.csengg@gmail.com> wrote:
> > On Tue, Jul 20, 2021 at 11:22 AM Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > > On Mon, 2021-07-19 at 15:38 +0100, Lad Prabhakar wrote:
> > > > Add CANFD binding documentation for Renesas RZ/G2L SoC.
> > > >
> > > > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > > > Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
>
> > > > --- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> > > > +++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
>
> > > > +    resets:
> > > > +      items:
> > > > +        - description: CANFD_RSTP_N
> > > > +        - description: CANFD_RSTC_N
> > >
> > > Do you know what the "P" and "C" stands for? It would be nice if the
> > > description could tell us what the reset lines are used for.
> > >
> > unfortunately the HW manual does not mention  anything about "P" and "C" :(
> >
> > > I would prefer if you used these names (or shortened versions, for
> > > example "rstp_n", "rstc_n") as "reset-names" and let the driver
> > > reference the resets by name instead of by index.
> > >
> > OK will do that and maxItems:2 for resets.
> >
> > @Geert, for R-Car Gen3 does "canfd_rst" (as it's a module reset)
> > sounds good for reset-names? Or do you have any other suggestions?
>
> I wouldn't bother with reset-names on R-Car, as there is only a
> single reset.
>
OK will keep "description: CANFD reset" for R-Car as done in the
current patch and just add reset-names only for RZ/G2L SoC.

> BTW, does there exist a generally-accepted reset-equivalent of "fck"
> ("Functional ClocK")?
>
None that I am aware of (Couple of binding docs have "rst"), but maybe
Philipp could have some suggestions.

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
