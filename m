Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08F45810D8
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 12:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238131AbiGZKLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 06:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbiGZKLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 06:11:48 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABFF1AD9F
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 03:11:46 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id z25so22007103lfr.2
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 03:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m0G1ouauyWlsMi4tX3T8kDD9m/uUFaFanRq+c7+5U7s=;
        b=PVvx51OOtlmDQcp+hJ9/QKAgDbD27XSXYiNOQxzShhI3JbRiAGv3AGUfQNpKEX85Ju
         Y3q+EL6ksrC/5vI4VjNPjznfY5b4hFs+VPQSz22sekFKjTQj3CfuTln588rafXxviWoJ
         TRamENOpI2kB4vy+4bsL/VIyN8iaKsi+zVLh4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m0G1ouauyWlsMi4tX3T8kDD9m/uUFaFanRq+c7+5U7s=;
        b=1k9xDe3kexZFe6uBe65mB1kTVK7eRcGSqawmvSS4Oi+NpnkZsgScB+kDa9kb+slsXO
         CUZr+vzW+B85PcMxWsQauTAp0+ee/+cY8ZTfN9RdM6mSHcawRjbQWq2KHh90lQvdiGyU
         UV9vWCRUBsrWVdJczdNrw4h/P2rAqi5avEHU4QD9Na/mqz45nJKgZlmcD5t1b9fxyZLG
         l+vCOUKSD09wLUTzGL9V9faN/vZ4f2iXGHpcra8X6TbcPYeCct4P7dy2mvj1HPwMc1+c
         jX7oZVFPoPEmWDSMVpdBE6iKwe3nWSO4IEKL7kY/37T7bpxJN+UppV1J9c0wZkfpB93R
         K1ig==
X-Gm-Message-State: AJIora9Urktfv+U55slM+U+V7++cQelj7MseFUIHaAiOGb09Ja48aFIN
        Dwrj9YjBDSstlrtO5CyYdC42yqZzYSk6stbEFbakPw==
X-Google-Smtp-Source: AGRyM1uXX45ideOrulD4FMDsqWEePdjfSSh0Leo4vP9vqFrWpyY+WXm0tecZooqyBc1+OvyrSM6L79ae1yhhCM+LF8g=
X-Received: by 2002:a05:6512:1389:b0:489:d0bb:241e with SMTP id
 p9-20020a056512138900b00489d0bb241emr6755687lfa.536.1658830305163; Tue, 26
 Jul 2022 03:11:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220725065419.3005015-1-dario.binacchi@amarulasolutions.com>
 <20220725065419.3005015-3-dario.binacchi@amarulasolutions.com> <20220725123804.ofqpq4j467qkbtzn@pengutronix.de>
In-Reply-To: <20220725123804.ofqpq4j467qkbtzn@pengutronix.de>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Tue, 26 Jul 2022 12:11:33 +0200
Message-ID: <CABGWkvrBrTqWQPBWKuKzuwQzgvc-iuWJPXt2utb60MOfych09A@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] can: slcan: remove legacy infrastructure
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org, michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Max Staudt <max@enpas.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

On Mon, Jul 25, 2022 at 2:38 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 25.07.2022 08:54:15, Dario Binacchi wrote:
> > Taking inspiration from the drivers/net/can/can327.c driver and at the
> > suggestion of its author Max Staudt, I removed legacy stuff like
> > `SLCAN_MAGIC' and `slcan_devs' resulting in simplification of the code
> > and its maintainability.
> >
> > The use of slcan_devs is derived from a very old kernel, since slip.c
> > is about 30 years old, so today's kernel allows us to remove it.
> >
> > The .hangup() ldisc function, which only called the ldisc .close(), has
> > been removed since the ldisc layer calls .close() in a good place
> > anyway.
> >
> > The old slcanX name has been dropped in order to use the standard canX
> > interface naming. It has been assumed that this change does not break
> > the user space as the slcan driver provides an ioctl to resolve from tty
> > fd to netdev name.
>
> Is there a man page that documents this iotcl? Please add it and/or the
> IOCTL name.

I have not found documentation of the SIOCGIFNAME ioctl for the line discipline,
but only for netdev (i. e.
https://man7.org/linux/man-pages/man7/netdevice.7.html),

Thanks and regards,
Dario

>
> > The `maxdev' module parameter has also been removed.
> >
> > CC: Max Staudt <max@enpas.org>
> > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> >
> > ---
> >
> > Changes in v2:
>
> Nitpick:
> Changes since RFC: https://lore.kernel.org/all/20220716170007.2020037-1-dario.binacchi@amarulasolutions.com
>
> > - Update the commit description.
> > - Drop the old "slcan" name to use the standard canX interface naming.
> >
> >  drivers/net/can/slcan/slcan-core.c | 318 ++++++-----------------------
> >  1 file changed, 63 insertions(+), 255 deletions(-)
> >
> > diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
> > index c3dd7468a066..2c546f4a7981 100644
> > --- a/drivers/net/can/slcan/slcan-core.c
> > +++ b/drivers/net/can/slcan/slcan-core.c
>
> [...]
>
> > @@ -898,72 +799,49 @@ static int slcan_open(struct tty_struct *tty)
> >       if (!tty->ops->write)
> >               return -EOPNOTSUPP;
> >
> > -     /* RTnetlink lock is misused here to serialize concurrent
> > -      * opens of slcan channels. There are better ways, but it is
> > -      * the simplest one.
> > -      */
> > -     rtnl_lock();
> > +     dev = alloc_candev(sizeof(*sl), 1);
> > +     if (!dev)
> > +             return -ENFILE;
> >
> > -     /* Collect hanged up channels. */
> > -     slc_sync();
> > +     sl = netdev_priv(dev);
> >
> > -     sl = tty->disc_data;
> > +     /* Configure TTY interface */
> > +     tty->receive_room = 65536; /* We don't flow control */
> > +     sl->rcount   = 0;
> > +     sl->xleft    = 0;
>
> Nitpick: Please use 1 space in front of the =.
>
> regards,
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |



-- 

Dario Binacchi

Embedded Linux Developer

dario.binacchi@amarulasolutions.com

__________________________________


Amarula Solutions SRL

Via Le Canevare 30, 31100 Treviso, Veneto, IT

T. +39 042 243 5310
info@amarulasolutions.com

www.amarulasolutions.com
