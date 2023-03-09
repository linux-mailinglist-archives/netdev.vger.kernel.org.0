Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC6A6B29A8
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbjCIQDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbjCIQCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:02:38 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02A0F786F;
        Thu,  9 Mar 2023 08:02:36 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id h17-20020a17090aea9100b0023739b10792so2446230pjz.1;
        Thu, 09 Mar 2023 08:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678377756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1UhO8ZSIF1PlCyAtNgmPdkBrutv5BnsXwFBFE8jFKI0=;
        b=nZVDEgjVJrjvKH9BcuETh7PUiQM9rXCCsmXQYY/Hl1afPDn1Qx/NTG893wgrwat+0e
         bx3K2l9MD1md/Sel2mZ8Mp1An8L1zV1/6Q0tk/3nmVTnRCVzJBPj9jBlM4PRdvJXGbRj
         QhSoCx+8gLI0YZtz7sRecbZ9GuNogiohajsW0knF+NbjrHYorm1J16LsPhCVKiLg/1N7
         Lt3KBqApFP1xyHhrNJRdNEKf+LPJ786tjTs+rqo+AA/3kuHKvHRg4VD9zJc0RashInCU
         /6yghKO11c59RlMHVuZ44sjs1lUvvQ1aZ9PtFZkpR7qQBGJOTyWRG6eT2WMlx7QKUQpp
         W5jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678377756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1UhO8ZSIF1PlCyAtNgmPdkBrutv5BnsXwFBFE8jFKI0=;
        b=h5iE8BQ51hWMGD6ida2s8aIMs9XL21ONlFLqAPz2MPxaVKqfjNy0M0wfsslwQM4zXz
         8ArPVw1jBQO9OnVIkieBxxXTQRuR2ffrbQO3Uh2gEBdH0RTQ20H3WBknMXn8qHhLs1Xm
         Xf+FCriOy9kyqEKMcvSFotXaMoZ1mFJoM6S39skWMKWmp1fsnsXqrZsh2L33mMOcBFLw
         pnQ0SXPDK3yV9vA8lnPhGkdYW0iiQ5h7jLH9TwjskUa7JdGQLQn+L5HUlPsVzNJWB6y0
         DyW3IG+IGsw/UU8Baawj+q6MfB0aZppd1T5jizrGKqPmubIqxHWGjA6WUPsiSkBupjzw
         50Gw==
X-Gm-Message-State: AO0yUKWIzMd+3nLSQh6q8ph0DI0Ekn0NP7y++6dfRQzfWhaiGJCeflVP
        MxLjjXG2xQDSIk1FVAuHPzKmpelet1zyS7X3sPxvhzKD
X-Google-Smtp-Source: AK7set/wBx/FSmM0ow8tfVsx6Lf6G7A9SWoZpfijYiU7pPMbjzhouTtDPdwUnLLmhXD6cFa8qQ3w09asQEueEEPAuJ8=
X-Received: by 2002:a17:90a:7bc6:b0:22c:2048:794e with SMTP id
 d6-20020a17090a7bc600b0022c2048794emr8149377pjl.7.1678377756009; Thu, 09 Mar
 2023 08:02:36 -0800 (PST)
MIME-Version: 1.0
References: <e825b50a843ffe40e33f34e4d858c07c1b2ff259.1678280913.git.geert+renesas@glider.be>
 <CAMZ6RqJ-3fyLFMjuyq4euNB-1sz0sBU5YswMeRduXO4TJ1QmLw@mail.gmail.com> <CAMuHMdWo_A8aeHS7Dy5X-6BEqUrwq5KGxnt4HDiLgfo-SaaYSg@mail.gmail.com>
In-Reply-To: <CAMuHMdWo_A8aeHS7Dy5X-6BEqUrwq5KGxnt4HDiLgfo-SaaYSg@mail.gmail.com>
From:   Vincent Mailhol <vincent.mailhol@gmail.com>
Date:   Fri, 10 Mar 2023 01:02:23 +0900
Message-ID: <CAMZ6RqKWYWLUOgAHcz74dcc0NuGu2uxKNGFtNyQqoxdTo9uh7A@mail.gmail.com>
Subject: Re: [PATCH v2] can: rcar_canfd: Add transceiver support
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 9 Mar 2023 at 17:12, Geert Uytterhoeven <geert@linux-m68k.org> wrot=
e:
> Hi Vincent,
>
> On Wed, Mar 8, 2023 at 4:55=E2=80=AFPM Vincent Mailhol
> <vincent.mailhol@gmail.com> wrote:
> > On Wed. 8 Mar. 2023 at 22:20, Geert Uytterhoeven
> > <geert+renesas@glider.be> wrote:
> > > Add support for CAN transceivers described as PHYs.
> > >
> > > While simple CAN transceivers can do without, this is needed for CAN
> > > transceivers like NXP TJR1443 that need a configuration step (like
> > > pulling standby or enable lines), and/or impose a bitrate limit.
> > >
> > > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> >
> > I have one nitpick (see below). Aside from that:
> > Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>
> Thanks!
>
> >
> > > ---
> > > v2:
> > >   - Add Reviewed-by.
> > > ---
> > >  drivers/net/can/rcar/rcar_canfd.c | 30 +++++++++++++++++++++++++----=
-
> > >  1 file changed, 25 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar=
/rcar_canfd.c
> > > index ef4e1b9a9e1ee280..6df9a259e5e4f92c 100644
> > > --- a/drivers/net/can/rcar/rcar_canfd.c
> > > +++ b/drivers/net/can/rcar/rcar_canfd.c
> > > @@ -35,6 +35,7 @@
> > >  #include <linux/netdevice.h>
> > >  #include <linux/of.h>
> > >  #include <linux/of_device.h>
> > > +#include <linux/phy/phy.h>
> > >  #include <linux/platform_device.h>
> > >  #include <linux/reset.h>
> > >  #include <linux/types.h>
> > > @@ -530,6 +531,7 @@ struct rcar_canfd_channel {
> > >         struct net_device *ndev;
> > >         struct rcar_canfd_global *gpriv;        /* Controller referen=
ce */
> > >         void __iomem *base;                     /* Register base addr=
ess */
> > > +       struct phy *transceiver;                /* Optional transceiv=
er */
> > >         struct napi_struct napi;
> > >         u32 tx_head;                            /* Incremented on xmi=
t */
> > >         u32 tx_tail;                            /* Incremented on xmi=
t done */
> > > @@ -1413,11 +1415,17 @@ static int rcar_canfd_open(struct net_device =
*ndev)
> > >         struct rcar_canfd_global *gpriv =3D priv->gpriv;
> > >         int err;
> > >
> > > +       err =3D phy_power_on(priv->transceiver);
> > > +       if (err) {
> > > +               netdev_err(ndev, "failed to power on PHY, error %d\n"=
, err);

Actually, I wanted to comment on this line=E2=80=A6

> > > +               return err;
> > > +       }
> > > +
> > >         /* Peripheral clock is already enabled in probe */
> > >         err =3D clk_prepare_enable(gpriv->can_clk);
> > >         if (err) {
> > >                 netdev_err(ndev, "failed to enable CAN clock, error %=
d\n", err);
> >                                                                       ^=
^
> >
> > Nitpick: can you print the mnemotechnic instead of the error value?

=E2=80=A6but instead pointed to that line when writing my comment.

> >
> >                 netdev_err(ndev, "failed to enable CAN clock, error
> > %pe\n", ERR_PTR(err));
>
> Thanks for the suggestion!
>
> As you're pointing to pre-existing code, and there are several cases
> like that, I sent a follow-up patch to fix all of them at once:
> https://lore.kernel.org/r/8a39f99fc28967134826dff141b51a5df824b034.167834=
9267.git.geert+renesas@glider.be

Thanks for fixing the pre-existing code as well! My intent was to
point to the newly introduced code but inadvertently commented on the
old code.
