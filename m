Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9E22E4376
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 16:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393015AbgL1PiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 10:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406339AbgL1Nub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 08:50:31 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44017C061794;
        Mon, 28 Dec 2020 05:49:51 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id y5so9421719iow.5;
        Mon, 28 Dec 2020 05:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aY3+fF6ahur6BRAAf5s0alh02lNeUKehSGviAXjROSI=;
        b=p2R639eutLj/ekQRl7oLIRUzjKG8W3xHyJI3x6H4EjLeKBgR9oxl5pUNxkRkTkg7LS
         9ySap+Nwztuphg0TUJeraGRHJHhF7jBPjGODY2EDuwShgHADXKHY19YqM2fKfiMXjB47
         veQE9NSLh8yB7IH1FcriExXeL1NgEYjd8JPcT94hg/hNeXFWlQgfC9/BCFynQ7Ka3Dfr
         0fNBNQgoU2iZPY3dilnC7f71CfYucqG1eRakyCbvdYACUMsueoawnGyQYneBC6l6+elg
         GDHeG3UavN/0JOgL0AtiuTFkL7JC54/BQbB4xO3zrG31oMqHPisfcXEfbgLJ3yo0ubnW
         Yt3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aY3+fF6ahur6BRAAf5s0alh02lNeUKehSGviAXjROSI=;
        b=UcdGPiCZiwb2uM9bHuhSaxh8Of4JmjpTkB7AgFnUn51x19HTFSGFiKYwLycXBP3/Eh
         Lv9KLrsR8JWBoTyxof4jpFGpR4yuBVwX3UWv8HgAFHcSHJi35lPUHd+YPLs/OuhtRgG4
         MYv/ziKiLF85lv/VjiMbQcFJ3UMtiOuClQ2OWdX3Pq/ui4QWiO8HeW9qtZsfGvcSRqjE
         XmMxMmdvKcdsCf7OkNe6La/mLz0imecSPGWRji3uEdWXrJIAByBIsh+5nJNdoPYLUApK
         9cGGdZzguWrvfuJKIr4/nTpo4zPg1b8mYHvrDZDWdCIWAWc1ACBpoSt2Uf8NrCdTc1Od
         9JMQ==
X-Gm-Message-State: AOAM533fgv4qWcQ06dbTKBaqGnKFs/rhv7sO4HRgbhIJZgA2b58UBOZu
        urnALx4lQes8WUNKZGQzfbm5u1nXLhq7l9vHpqY=
X-Google-Smtp-Source: ABdhPJxV3MQQijnCDs5PRer+8kGiEbxEcyeundH6v2iVn++5qu0ItwUnDD9NekDaNisM0C92aCYmrw189ktK0gzp1z4=
X-Received: by 2002:a05:6638:296:: with SMTP id c22mr39135330jaq.65.1609163390490;
 Mon, 28 Dec 2020 05:49:50 -0800 (PST)
MIME-Version: 1.0
References: <20201212165648.166220-1-aford173@gmail.com> <CAMuHMdUr5MWpa5fhpKgAm7zRgzzJga=pjNSVG3aoTvCmuq5poQ@mail.gmail.com>
In-Reply-To: <CAMuHMdUr5MWpa5fhpKgAm7zRgzzJga=pjNSVG3aoTvCmuq5poQ@mail.gmail.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Mon, 28 Dec 2020 07:49:39 -0600
Message-ID: <CAHCN7x+jm8agBzqDqnkmW1Obtd0zL6EA_xbicvkroZ+kmgEqiA@mail.gmail.com>
Subject: Re: [RFC] ravb: Add support for optional txc_refclk
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Charles Stevens <charles.stevens@logicpd.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 4:05 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Adam,
>
> On Sun, Dec 13, 2020 at 5:18 PM Adam Ford <aford173@gmail.com> wrote:
> > The SoC expects the txv_refclk is provided, but if it is provided
> > by a programmable clock, there needs to be a way to get and enable
> > this clock to operate.  It needs to be optional since it's only
> > necessary for those with programmable clocks.
> >
> > Signed-off-by: Adam Ford <aford173@gmail.com>
>
> Thanks for your patch!
>
> > --- a/drivers/net/ethernet/renesas/ravb.h
> > +++ b/drivers/net/ethernet/renesas/ravb.h
> > @@ -994,6 +994,7 @@ struct ravb_private {
> >         struct platform_device *pdev;
> >         void __iomem *addr;
> >         struct clk *clk;
> > +       struct clk *ref_clk;
> >         struct mdiobb_ctrl mdiobb;
> >         u32 num_rx_ring[NUM_RX_QUEUE];
> >         u32 num_tx_ring[NUM_TX_QUEUE];
> > diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> > index bd30505fbc57..4c3f95923ef2 100644
> > --- a/drivers/net/ethernet/renesas/ravb_main.c
> > +++ b/drivers/net/ethernet/renesas/ravb_main.c
> > @@ -2148,6 +2148,18 @@ static int ravb_probe(struct platform_device *pdev)
> >                 goto out_release;
> >         }
> >
> > +       priv->ref_clk = devm_clk_get(&pdev->dev, "txc_refclk");
>
> Please also update the DT bindings[1], to document the optional
> presence of the clock.

I am not all that familiar with the YAML syntax, but right now, the
clock-names property isn't in the binding, and the driver doesn't use
a name when requesting the single clock it's expecting.
Since the txc_refclk is optional, can the clock-names property allow
for 0-2 names while the number of clocks be 1-2?

clocks:
    minItems: 1
    maxItems: 2

  clock-names:
    minItems: 0
    maxItems: 2
    items:
      enum:
        - fck # AVB functional clock (optional if it is the only clock)
        - txc_refclk # TXC reference clock

With the above proposal, the clock-names would only be necessary when
using the txc_refclk.

>
> > +       if (IS_ERR(priv->ref_clk)) {
> > +               if (PTR_ERR(priv->ref_clk) == -EPROBE_DEFER) {
> > +                       /* for Probe defer return error */
> > +                       error = PTR_ERR(priv->ref_clk);
> > +                       goto out_release;
> > +               }
> > +               /* Ignore other errors since it's optional */
> > +       } else {
> > +               (void)clk_prepare_enable(priv->ref_clk);
>
> This can fail.
> Does this clock need to be enabled all the time?
> At least it should be disabled in the probe failure path, and in
> ravb_remove().

I'll do that for the next rev.

thanks,

adam
>
> [1] Documentation/devicetree/bindings/net/renesas,etheravb.yaml
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
