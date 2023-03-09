Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEDD6B1DAC
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 09:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjCIIRY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 9 Mar 2023 03:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjCIIRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 03:17:05 -0500
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAE250F8D;
        Thu,  9 Mar 2023 00:13:16 -0800 (PST)
Received: by mail-qt1-f170.google.com with SMTP id r16so1135691qtx.9;
        Thu, 09 Mar 2023 00:13:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678349554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p+1xOKbrywXjEK6z9y1/Q9rNoAtKiRUOKGVYgkwDhuM=;
        b=N10kkF73X6/cGILt9pBg7ob9k58LQI0Zwmt2YLBYzBad6JpnY42/QJlNUswgMKUXvW
         U6pTDp5JgXPA4qalF8Ka5UaW7p8vCshvFYCl5oiCcGvyiZfhSIe9X1YG4qORHc+buhSu
         kdppqGDXIjyAqAwuib8bYlH3/HDjIhZbRI7UwNEGTVcCCbk//Tw7KKAKjvXBLKPy7zsN
         /jM3rWJyhi87Pw//2kqWWYlc/uGfGQY9mtW9Bvc55CmfPCYs3j/OFShTs2g1fjIGlMRC
         eKihbYlVVUkwj4BEj8CGzo4uioKnOCB+5DTkkwZhmuslBAuiKcWYJ4XUSN1vaDvSB72S
         uKvQ==
X-Gm-Message-State: AO0yUKVfCkKqPwISYKChRiWqdaXDIbBXE/slELgbU/AXewtXck1hV5PN
        ViamSuVXKGKlca3+w1AmuegfWfNDSXI0r2IQ
X-Google-Smtp-Source: AK7set8wfaaHUeOCLG4dTj7ZI19vy+QTZODNFf/3enh9PvcO5/s+yyg05hKW/km+x0WYaPo9huMYsg==
X-Received: by 2002:a05:622a:341:b0:3b8:6075:5d16 with SMTP id r1-20020a05622a034100b003b860755d16mr35193875qtw.56.1678349554574;
        Thu, 09 Mar 2023 00:12:34 -0800 (PST)
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com. [209.85.128.174])
        by smtp.gmail.com with ESMTPSA id u2-20020a37ab02000000b007423caef02fsm12874582qke.122.2023.03.09.00.12.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 00:12:34 -0800 (PST)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-536bf92b55cso20418547b3.12;
        Thu, 09 Mar 2023 00:12:33 -0800 (PST)
X-Received: by 2002:a81:f105:0:b0:538:49a4:b1e0 with SMTP id
 h5-20020a81f105000000b0053849a4b1e0mr15534773ywm.2.1678349553687; Thu, 09 Mar
 2023 00:12:33 -0800 (PST)
MIME-Version: 1.0
References: <e825b50a843ffe40e33f34e4d858c07c1b2ff259.1678280913.git.geert+renesas@glider.be>
 <CAMZ6RqJ-3fyLFMjuyq4euNB-1sz0sBU5YswMeRduXO4TJ1QmLw@mail.gmail.com>
In-Reply-To: <CAMZ6RqJ-3fyLFMjuyq4euNB-1sz0sBU5YswMeRduXO4TJ1QmLw@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 9 Mar 2023 09:12:22 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWo_A8aeHS7Dy5X-6BEqUrwq5KGxnt4HDiLgfo-SaaYSg@mail.gmail.com>
Message-ID: <CAMuHMdWo_A8aeHS7Dy5X-6BEqUrwq5KGxnt4HDiLgfo-SaaYSg@mail.gmail.com>
Subject: Re: [PATCH v2] can: rcar_canfd: Add transceiver support
To:     Vincent Mailhol <vincent.mailhol@gmail.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincent,

On Wed, Mar 8, 2023 at 4:55 PM Vincent Mailhol
<vincent.mailhol@gmail.com> wrote:
> On Wed. 8 Mar. 2023 at 22:20, Geert Uytterhoeven
> <geert+renesas@glider.be> wrote:
> > Add support for CAN transceivers described as PHYs.
> >
> > While simple CAN transceivers can do without, this is needed for CAN
> > transceivers like NXP TJR1443 that need a configuration step (like
> > pulling standby or enable lines), and/or impose a bitrate limit.
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
>
> I have one nitpick (see below). Aside from that:
> Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Thanks!

>
> > ---
> > v2:
> >   - Add Reviewed-by.
> > ---
> >  drivers/net/can/rcar/rcar_canfd.c | 30 +++++++++++++++++++++++++-----
> >  1 file changed, 25 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
> > index ef4e1b9a9e1ee280..6df9a259e5e4f92c 100644
> > --- a/drivers/net/can/rcar/rcar_canfd.c
> > +++ b/drivers/net/can/rcar/rcar_canfd.c
> > @@ -35,6 +35,7 @@
> >  #include <linux/netdevice.h>
> >  #include <linux/of.h>
> >  #include <linux/of_device.h>
> > +#include <linux/phy/phy.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/reset.h>
> >  #include <linux/types.h>
> > @@ -530,6 +531,7 @@ struct rcar_canfd_channel {
> >         struct net_device *ndev;
> >         struct rcar_canfd_global *gpriv;        /* Controller reference */
> >         void __iomem *base;                     /* Register base address */
> > +       struct phy *transceiver;                /* Optional transceiver */
> >         struct napi_struct napi;
> >         u32 tx_head;                            /* Incremented on xmit */
> >         u32 tx_tail;                            /* Incremented on xmit done */
> > @@ -1413,11 +1415,17 @@ static int rcar_canfd_open(struct net_device *ndev)
> >         struct rcar_canfd_global *gpriv = priv->gpriv;
> >         int err;
> >
> > +       err = phy_power_on(priv->transceiver);
> > +       if (err) {
> > +               netdev_err(ndev, "failed to power on PHY, error %d\n", err);
> > +               return err;
> > +       }
> > +
> >         /* Peripheral clock is already enabled in probe */
> >         err = clk_prepare_enable(gpriv->can_clk);
> >         if (err) {
> >                 netdev_err(ndev, "failed to enable CAN clock, error %d\n", err);
>                                                                       ^^
>
> Nitpick: can you print the mnemotechnic instead of the error value?
>
>                 netdev_err(ndev, "failed to enable CAN clock, error
> %pe\n", ERR_PTR(err));

Thanks for the suggestion!

As you're pointing to pre-existing code, and there are several cases
like that, I sent a follow-up patch to fix all of them at once:
https://lore.kernel.org/r/8a39f99fc28967134826dff141b51a5df824b034.1678349267.git.geert+renesas@glider.be

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
