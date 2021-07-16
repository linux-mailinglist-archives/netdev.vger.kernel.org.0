Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3913CB45F
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 10:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237848AbhGPIgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 04:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237055AbhGPIgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 04:36:09 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287B6C06175F;
        Fri, 16 Jul 2021 01:33:15 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id g5so13567143ybu.10;
        Fri, 16 Jul 2021 01:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/ff+YehTziKFzYJPNZTmNGwqrJDQ7taVpMo22hrLQTM=;
        b=fJJE3al6ENVbGCPr84bxxK73tb+QFEtQBTr8WjAiGgx1soyasDZuavfSHFV8k2USZJ
         oH15lp0HnclcufuUab76el9kobyVbC2vAWMZRxRyEScGPx27YPI78/9w8jz3gib6Ru7t
         D2ZThF//EqvCRwtQTEFbNs6gvNEVUP/z/cXb+39U0f3RcrFeVa8iDfNAhbXzWT1BtPzM
         GxGzimR3OLemsPfvI74ehnxPp4JxjNkDYzj155y/zgx9BG6SWy6+/xNURwJkFVlu99Xm
         bj8y/iFt4HTjqAxQnDUb2SQBBIAI0R+LGb8CiXeNj064hLl6al/RuAZ3XFizFcbgZtD6
         1C6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/ff+YehTziKFzYJPNZTmNGwqrJDQ7taVpMo22hrLQTM=;
        b=DM1073jSbBaVN4ntKPXC7FdFNnAzNtnYOXPtZ+RPa5CpZvEavwbNoRc8z4cDM2R+xc
         zzykUvnGAkrLZJnE8rhJgdLTP+sEw6coXiu4cNFRvibcy6btFhhQzYqtV4AJmSSzIFcr
         AOO3HUDD4+f7OgtkGcoNF25eT+KGBwAAzj3Sv/yPWAan5/eZbjHozYaEHNrA6rQEI6TI
         gFwrneg+uGYUx+K7I6uRADP9xMB6NU248e0bW1SYK+7aK/ykbXsivcajVHErl7uWCq7h
         anPaZSlDskIm+RrhZm5CeaH3C9b6dftjxT3Kczke11+Fifb6XlqClwf1fKZTz9y5SF3K
         rnCA==
X-Gm-Message-State: AOAM532zxSTIm0xswoN/G7ufAElTH0q7tnC0cxqc8E0bbxBfiy0t6PS5
        ZT/XU14OXsCj4MmXUOnC+Us4MiirmfHd/7Pa0Ok=
X-Google-Smtp-Source: ABdhPJyrob7shQ8fsxArMpyWE8C80LM02fpQHs2T6NT87HRMygJqZOtA+ZFbLbJU/yq46BokUQ7v5NpX6VvESFTMtcE=
X-Received: by 2002:a25:b9d0:: with SMTP id y16mr11360302ybj.62.1626424394240;
 Fri, 16 Jul 2021 01:33:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210715182123.23372-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210715182123.23372-3-prabhakar.mahadev-lad.rj@bp.renesas.com> <CAMuHMdXB-kEU7QVuMH1SNrwg+VPbHeOVQS3rjhcgQRFwoMsgdA@mail.gmail.com>
In-Reply-To: <CAMuHMdXB-kEU7QVuMH1SNrwg+VPbHeOVQS3rjhcgQRFwoMsgdA@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Fri, 16 Jul 2021 09:32:48 +0100
Message-ID: <CA+V-a8tgF6nDKHnEG429cj=+YDNvP0jF0Wz+r2sO-FU_f7dJUg@mail.gmail.com>
Subject: Re: [PATCH 2/6] can: rcar_canfd: Add support for RZ/G2L family
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

On Fri, Jul 16, 2021 at 8:47 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Prabhakar,
>
> On Thu, Jul 15, 2021 at 8:21 PM Lad Prabhakar
> <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> > CANFD block on RZ/G2L SoC is almost identical to one found on
> > R-Car Gen3 SoC's.
> >
> > On RZ/G2L SoC interrupt sources for each channel are split into
> > different sources, irq handlers for the same are added.
> >
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
>
> Thanks for your patch!
>
> > --- a/drivers/net/can/rcar/rcar_canfd.c
> > +++ b/drivers/net/can/rcar/rcar_canfd.c
> > @@ -1070,6 +1077,56 @@ static void rcar_canfd_tx_done(struct net_device *ndev)
> >         can_led_event(ndev, CAN_LED_EVENT_TX);
> >  }
> >
> > +static irqreturn_t rcar_canfd_global_err_interrupt(int irq, void *dev_id)
> > +{
>
> > +static irqreturn_t rcar_canfd_global_recieve_fifo_interrupt(int irq, void *dev_id)
> > +{
>
> >  static irqreturn_t rcar_canfd_global_interrupt(int irq, void *dev_id)
> >  {
> >         struct rcar_canfd_global *gpriv = dev_id;
> > @@ -1139,6 +1196,56 @@ static void rcar_canfd_state_change(struct net_device *ndev,
> >         }
> >  }
> >
> > +static irqreturn_t rcar_canfd_channel_tx_interrupt(int irq, void *dev_id)
> > +{
>
> > +static irqreturn_t rcar_canfd_channel_err_interrupt(int irq, void *dev_id)
> > +{
>
> It looks like the new split interrupt handlers duplicate code from
> the existing unified interrupt handlers.  Perhaps the latter can be
> made to call the former instead?
>
Agreed.

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
