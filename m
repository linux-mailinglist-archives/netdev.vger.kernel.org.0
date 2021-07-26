Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9553D6920
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 23:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbhGZVS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 17:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhGZVSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 17:18:54 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214E9C061757;
        Mon, 26 Jul 2021 14:59:22 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id f26so13664486ybj.5;
        Mon, 26 Jul 2021 14:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MavJ2cCZYKPW485sWxpV9V4ZO3KYbRxqOrZ4H3Wy21s=;
        b=fx/SrFpswt8oH3Awy3wgAZSB+6Q8V6DYU6hIvGXMQpmpQagAsX1lMt2cQx3UeaR6Fo
         7AJ1/uqxNIhO51xCAf9DjGGB32edlWTL6821SpmwDZamKq5zG8zTbot79Lr53NQPhQYq
         4786qUyiYITstnqQp1UKsyPds/PuV3+QqPGUy8fo2rkq7DiVsnI34Dln/m+t3ZNU+nje
         6t1husWFlord+atUJ2y5k1XJEVQ3EoRHB0fBD+wrXj+NytjJ7/YzgBssqhS8NgXsEUbT
         1hNQ6Nkbpq4rsGA5RvZlQ8OtvlwctoLIeX3LVt5x6RsjaTq9Iz0iI1Ut9sQpjaXaedAw
         CIaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MavJ2cCZYKPW485sWxpV9V4ZO3KYbRxqOrZ4H3Wy21s=;
        b=aTJoS0SBXfGgbkFcogfGZhDb63HFsKpA3BLHF8nqodRroHvuP0rIveXu/2eO2Dsyc5
         5qkHdLOUxRnCkMSbFCdx8kwzJ8YiFPmm23bEf/6e2TZbxW4bFqkeFW8XXmzEN7pGySb9
         Y4Gxivvc+1kNMDrfjmfAuZNwzF9pUvQWQ8DiwRt0HGjKht5TlIGYfdbX+bOh0iFbBlaU
         Mk7mcYC6CygZEPSyKOjTHCY5p9t6I2gRYbrZzFSgdB612lTgutLtM56DgKz10HDDrzqA
         GRXCJ9B4Uama1Yr15iffGRj4DKPXVooyRIJmqbcsagHrvPpeQ4B/e3vNQ3gQx6LBWpxe
         45zw==
X-Gm-Message-State: AOAM531dVq1saldizjJvgYpBVApdWr6FQYZsYiWEb++QiopnKOa9y0V7
        jFdD+P/w4Eftzu0xhMmLetkvM+l9y61LNnHxl+E=
X-Google-Smtp-Source: ABdhPJyeos1ydqRp61iXvxIJqxxFr/G7ENWtnVdYVePtiZCZVkmZkMJhjyDE8kipooghqEwW4mqMrRi9Tr4WC6LbvJo=
X-Received: by 2002:a5b:b48:: with SMTP id b8mr26432217ybr.179.1627336761455;
 Mon, 26 Jul 2021 14:59:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210721194951.30983-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210721194951.30983-3-prabhakar.mahadev-lad.rj@bp.renesas.com> <CAMuHMdU0YkKb-_k00Zbr3aQGSHRD8639Ut207VwQ_ji0E+YL2g@mail.gmail.com>
In-Reply-To: <CAMuHMdU0YkKb-_k00Zbr3aQGSHRD8639Ut207VwQ_ji0E+YL2g@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Mon, 26 Jul 2021 22:58:55 +0100
Message-ID: <CA+V-a8sKhhjrEHb3CU9d9oPgoNJybmSYcL-N47hjsU4LDNJkjQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] can: rcar_canfd: Add support for RZ/G2L family
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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

Thank you for the review.

On Mon, Jul 26, 2021 at 10:53 AM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> Hi Prabhakar,
>
> On Wed, Jul 21, 2021 at 9:50 PM Lad Prabhakar
> <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> > CANFD block on RZ/G2L SoC is almost identical to one found on
> > R-Car Gen3 SoC's. On RZ/G2L SoC interrupt sources for each channel
> > are split into different sources and the IP doesn't divide (1/2)
> > CANFD clock within the IP.
> >
> > This patch adds compatible string for RZ/G2L family and registers
> > the irq handlers required for CANFD operation. IRQ numbers are now
> > fetched based on names instead of indices. For backward compatibility
> > on non RZ/G2L SoC's we fallback reading based on indices.
> >
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>
> Thanks for the update!
>
> I think you misunderstood my comment on v1 about the interrupt
> handlers, cfr. below.
>
Argh my bad I took it the other way round!

> > --- a/drivers/net/can/rcar/rcar_canfd.c
> > +++ b/drivers/net/can/rcar/rcar_canfd.c
>
> > @@ -1577,6 +1586,53 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
> >         priv->can.clock.freq = fcan_freq;
> >         dev_info(&pdev->dev, "can_clk rate is %u\n", priv->can.clock.freq);
> >
> > +       if (gpriv->chip_id == RENESAS_RZG2L) {
> > +               char *irq_name;
> > +               int err_irq;
> > +               int tx_irq;
> > +
> > +               err_irq = platform_get_irq_byname(pdev, ch == 0 ? "ch0_err" : "ch1_err");
> > +               if (err_irq < 0) {
> > +                       err = err_irq;
> > +                       goto fail;
> > +               }
> > +
> > +               tx_irq = platform_get_irq_byname(pdev, ch == 0 ? "ch0_trx" : "ch1_trx");
> > +               if (tx_irq < 0) {
> > +                       err = tx_irq;
> > +                       goto fail;
> > +               }
> > +
> > +               irq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
> > +                                         "canfd.ch%d_err", ch);
> > +               if (!irq_name) {
> > +                       err = -ENOMEM;
> > +                       goto fail;
> > +               }
> > +               err = devm_request_irq(&pdev->dev, err_irq,
> > +                                      rcar_canfd_channel_interrupt, 0,
>
> This is the same interrupt handler...
>
> > +                                      irq_name, gpriv);
> > +               if (err) {
> > +                       dev_err(&pdev->dev, "devm_request_irq CH Err(%d) failed, error %d\n",
> > +                               err_irq, err);
> > +                       goto fail;
> > +               }
> > +               irq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
> > +                                         "canfd.ch%d_trx", ch);
> > +               if (!irq_name) {
> > +                       err = -ENOMEM;
> > +                       goto fail;
> > +               }
> > +               err = devm_request_irq(&pdev->dev, tx_irq,
> > +                                      rcar_canfd_channel_interrupt, 0,
>
> ... as this one.
>
> > +                                      irq_name, gpriv);
> > +               if (err) {
> > +                       dev_err(&pdev->dev, "devm_request_irq Tx (%d) failed, error %d\n",
> > +                               tx_irq, err);
> > +                       goto fail;
> > +               }
> > +       }
> > +
> >         if (gpriv->fdmode) {
> >                 priv->can.bittiming_const = &rcar_canfd_nom_bittiming_const;
> >                 priv->can.data_bittiming_const =
>
> > @@ -1711,20 +1798,51 @@ static int rcar_canfd_probe(struct platform_device *pdev)
> >         gpriv->base = addr;
> >
> >         /* Request IRQ that's common for both channels */
> > -       err = devm_request_irq(&pdev->dev, ch_irq,
> > -                              rcar_canfd_channel_interrupt, 0,
> > -                              "canfd.chn", gpriv);
> > -       if (err) {
> > -               dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
> > -                       ch_irq, err);
> > -               goto fail_dev;
> > +       if (gpriv->chip_id == RENESAS_RCAR_GEN3) {
> > +               err = devm_request_irq(&pdev->dev, ch_irq,
> > +                                      rcar_canfd_channel_interrupt, 0,
> > +                                      "canfd.ch_int", gpriv);
> > +               if (err) {
> > +                       dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
> > +                               ch_irq, err);
> > +                       goto fail_dev;
> > +               }
> > +
> > +               err = devm_request_irq(&pdev->dev, g_irq,
> > +                                      rcar_canfd_global_interrupt, 0,
> > +                                      "canfd.g_int", gpriv);
> > +               if (err) {
> > +                       dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
> > +                               g_irq, err);
> > +                       goto fail_dev;
> > +               }
> > +       } else {
> > +               err = devm_request_irq(&pdev->dev, g_recc_irq,
> > +                                      rcar_canfd_global_interrupt, 0,
>
> This is the same interrupt handler...
>
> > +                                      "canfd.g_recc", gpriv);
> > +
> > +               if (err) {
> > +                       dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
> > +                               g_recc_irq, err);
> > +                       goto fail_dev;
> > +               }
> > +
> > +               err = devm_request_irq(&pdev->dev, g_err_irq,
> > +                                      rcar_canfd_global_interrupt, 0,
>
> ... as this one.
>
> > +                                      "canfd.g_err", gpriv);
> > +               if (err) {
> > +                       dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
> > +                               g_err_irq, err);
> > +                       goto fail_dev;
> > +               }
> >         }
> > -       err = devm_request_irq(&pdev->dev, g_irq,
> > -                              rcar_canfd_global_interrupt, 0,
> > -                              "canfd.gbl", gpriv);
> > +
> > +       err = reset_control_reset(gpriv->rstc1);
> > +       if (err)
> > +               goto fail_dev;
> > +       err = reset_control_reset(gpriv->rstc2);
> >         if (err) {
> > -               dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
> > -                       g_irq, err);
> > +               reset_control_assert(gpriv->rstc1);
> >                 goto fail_dev;
> >         }
>
> I did not object to having fine-grained interrupt handlers on RZ/G2L.
> I did object to duplicating code in global and fine-grained interrupt
> handlers.
>
> The trick to have both is to let the global interrupt handlers call
> (conditionally) into the fine-grained handlers. In pseudo-code:
>
>     global_interrupt_handler()
>     {
>             if (...)
>                     fine_grained_handler1();
>
>             if (...)
>                     fine_grained_handler2();
>             ...
>     }
>
> On R-Car Gen3, you register the global interrupt handlers, as before.
> On RZ/G2L, you register the fine-grained interrupt handlers instead.
>
Agreed will re-spin with the fine-grained version tomorrow.

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
