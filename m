Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF62A3CFD66
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241106AbhGTOkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239758AbhGTOUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 10:20:35 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC79C06178C;
        Tue, 20 Jul 2021 07:58:07 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id a16so33089252ybt.8;
        Tue, 20 Jul 2021 07:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XEVu3hZadiQ0WDLAIZgrzrDxA6oJ53H3vgdnVOEPrQ8=;
        b=n9M8ng2msIt5IVVUGfaXSWpXav+TDZEIagymTXBbK6NB9K94HWizCRAthlQJvmliKm
         Gzdtvxx/uufYsp8+M6u4ZBSTDOeIsPPbGz30DYhJykCGoWAT1cTP7ZrU2W7P35Y6Cfj8
         hxp1Zx51G1hOifLvPpPbEB9TAjFdusIJPxObM1q498JKWUxjpWIM5janJxbg2623gxdU
         0HpzCE5gefwU3sua2Eq/86zqj4o6ZzkkdaEbZf62d3LyE5JZ44DGjW1qdPXRb7e8UtNx
         IsCPErg8XaT3cxTj2mGv/WuW4TKVZvg+CfR5crFWdKhY8STF2RhBpJAg1b7aPj8Jv9k1
         Om+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XEVu3hZadiQ0WDLAIZgrzrDxA6oJ53H3vgdnVOEPrQ8=;
        b=OTJSGm4m3Dld+aruncoMhti/8ApBprSz7u8Rm8tv8wLieXmqxyYXbQQux7+NcCwggW
         AWz2nqv6bz4Mu++NZ+61n/i7H5MOTlwJDr6n/1mF9rKIhWIjbVpCY2FgrACfCg5DYUBU
         JApBWhEnYXAFjTOYttZ+nsE8voibLavsn9Gn5Ty4j+hQiFkruRb9I1hpU/78QmuizKkT
         pdEKGBlEjWm8QMVnh5snJLVMrStyqx1s2PSJPJr16bTxh8XxrqMJ6yOuqw/EfAMVNOWv
         zupNbCJCatqmg5bCF83HQiAXyQxLXJkcJ6kef1kkcThEdV9ihndM1lGCjjGzO2R6bG+G
         l+nw==
X-Gm-Message-State: AOAM533CUD9nJfXqE+ltwZToYQtHIh6IG6wTnpQGJKYiwtq6e7aFr0e7
        0+RPXUVo4ZyfY4J9H7u5CKh3ZBthZ6YVhK6/+eA=
X-Google-Smtp-Source: ABdhPJxZZZwLPoyYOzEhes1wmyLaTcvkDSmkoB9Xggix4AffH0qsiSVQQQq6OFTNnq4iakaROVUT1p49GBa/uUhSbxo=
X-Received: by 2002:a25:e404:: with SMTP id b4mr40451306ybh.426.1626793087054;
 Tue, 20 Jul 2021 07:58:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210719143811.2135-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210719143811.2135-3-prabhakar.mahadev-lad.rj@bp.renesas.com> <c8ec5fe0c8eb86898416edb7c68dcf0eeeaccf54.camel@pengutronix.de>
In-Reply-To: <c8ec5fe0c8eb86898416edb7c68dcf0eeeaccf54.camel@pengutronix.de>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Tue, 20 Jul 2021 15:57:40 +0100
Message-ID: <CA+V-a8vgQ1-tUOw2o3E39reZmnLGFVN_HEvZeH-x5cj01x-Pzg@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] can: rcar_canfd: Add support for RZ/G2L family
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
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

Hi Philipp,

Thank you for the review.

On Tue, Jul 20, 2021 at 11:23 AM Philipp Zabel <p.zabel@pengutronix.de> wrote:
>
> On Mon, 2021-07-19 at 15:38 +0100, Lad Prabhakar wrote:
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
> > Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> > ---
> >  drivers/net/can/rcar/rcar_canfd.c | 178 ++++++++++++++++++++++++------
> >  1 file changed, 147 insertions(+), 31 deletions(-)
> >
> > diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
> > index 311e6ca3bdc4..d4affc002fb3 100644
> > --- a/drivers/net/can/rcar/rcar_canfd.c
> > +++ b/drivers/net/can/rcar/rcar_canfd.c
> > @@ -37,9 +37,15 @@
> [...]
> > +     if (gpriv->chip_id == RENESAS_RZG2L) {
> > +             gpriv->rstc1 = devm_reset_control_get_exclusive_by_index(&pdev->dev, 0);
> > +             if (IS_ERR(gpriv->rstc1)) {
> > +                     dev_err(&pdev->dev, "failed to get reset index 0\n");
>
> Please consider requesting the reset controls by name instead of by
> index. See also my reply to the binding patch.
>
Will do.

> > +                     return PTR_ERR(gpriv->rstc1);
> > +             }
> > +
> > +             err = reset_control_reset(gpriv->rstc1);
> > +             if (err)
> > +                     return err;
>
> I suggest to wait until after all resource requests have succeeded
> before triggering the resets, i.e. first get all reset controls and
> clocks, etc., and only then trigger resets, enable clocks, and so on.
>
> That way there will be no spurious resets in case of probe deferrals.
>
Agreed, will update the code.

Cheers,
Prabhakar

> regards
> Philipp
