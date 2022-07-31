Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03FDD585F9B
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 17:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237374AbiGaPyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 11:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbiGaPyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 11:54:15 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C08EE3B
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 08:54:13 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id r14so9877944ljp.2
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 08:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4eB2VODr+0qCxbAW7BEEzvMOUvlQ5Vk+lICZ8qaxZMI=;
        b=QDeMG3c1dnSJnu0g+xKTtGTgXxlOQoPvzoCiV+1HlbbdFruMsPo2ZE+eVtH6/cjhdc
         gcyLcbNZNyqEf3AugVUJQB5dwRJC4T2D9eJp//DlQ9O7NZCA0rcrVJD8m+kJPyWS1Pn5
         7uX4gmcLBkhrfe7Tp+78Rc43h3NZ43QuBORiE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4eB2VODr+0qCxbAW7BEEzvMOUvlQ5Vk+lICZ8qaxZMI=;
        b=0Q4Zqjhba96iW8S8t1ULwr5LMVvdgoVLjz0lCQbqa6fQ1P69CCglmD7IoWps1wdDLD
         gDWsAqLdtaIRDlYDb2GLU7UXF42MG17rjxW2ekTSzKkf1tgYZoZXXu9/QlzafVH81ZE/
         JvkDvoc56AiBLJ1rYbnOldmO2ASAJtH76uQlF6AgXje3bePG8oQT9L2GjPT0QnArTdGl
         zc0D1RwmxzIuYEkkCX9zK9Jxbn2XaxPG8C/QUPfWm89DtLqMAHeaOSvivWSiQ6/ihP2V
         +dth5S4n+SgOBgqpyXh5QjOLtdD3/2Qt/k+4uSG2KUhRMoMl0nUvNtH9lMLDWgSoKs2v
         JOOw==
X-Gm-Message-State: ACgBeo3H4hHuPfTaGT4Of2iRQEm11g6vVGd788KYxbvrtsMab+xh4zJ+
        3Bo6KZXae/zkYcnSO51wLH0oJcqj+RlMX+YswcQ1UA==
X-Google-Smtp-Source: AA6agR5e02mqIv0APIESdyZGYm9Vgb8YLp38EZiRzyPAoLvvDFC/ltg6pNYhtoNIPv1pjge+C3ESgO5kP9UJGveCPRU=
X-Received: by 2002:a05:651c:335:b0:25e:4ac0:86e2 with SMTP id
 b21-20020a05651c033500b0025e4ac086e2mr1207861ljp.427.1659282852262; Sun, 31
 Jul 2022 08:54:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220726210217.3368497-9-dario.binacchi@amarulasolutions.com>
 <20220727113054.ffcckzlcipcxer2c@pengutronix.de> <20220727192839.707a3453.max@enpas.org>
 <20220727182414.3mysdeam7mtnqyfx@pengutronix.de> <CABGWkvoE8i--g_2cNU6ToAfZk9WE6uK-nLcWy7J89hU6RidLWw@mail.gmail.com>
 <20220728090228.nckgpmfe7rpnfcyr@pengutronix.de> <CABGWkvoYR67MMmqZ6bRLuL3szhVb-gMwuAy6Z4YMkaG0yw6Sdg@mail.gmail.com>
 <20220728105049.43gbjuctezxzmm4j@pengutronix.de> <20220728125734.1c380d25.max@enpas.org>
 <CABGWkvo0B8XM+5qLhz3zY2DzyUrEQtQyJnd91VweUWDUcjyr5A@mail.gmail.com> <20220729073352.rfxdyjvttjp7rnfk@pengutronix.de>
In-Reply-To: <20220729073352.rfxdyjvttjp7rnfk@pengutronix.de>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Sun, 31 Jul 2022 17:54:01 +0200
Message-ID: <CABGWkvpgDZohEwPJu0hgm+OqfKbH=PgpPHjMMp=t3PxpPfVhVQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 8/9] can: slcan: add support to set bit time
 register (btr)
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Max Staudt <max@enpas.org>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
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

Hi Marc,

On Fri, Jul 29, 2022 at 9:33 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 29.07.2022 08:52:07, Dario Binacchi wrote:
> > Hello Marc and Max,
> >
> > On Thu, Jul 28, 2022 at 12:57 PM Max Staudt <max@enpas.org> wrote:
> > >
> > > On Thu, 28 Jul 2022 12:50:49 +0200
> > > Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > >
> > > > On 28.07.2022 12:23:04, Dario Binacchi wrote:
> > > > > > > Does it make sense to use the device tree
> > > > > >
> > > > > > The driver doesn't support DT and DT only works for static serial
> > > > > > interfaces.
> > > >
> > > > Have you seen my remarks about Device Tree?
> > >
> > > Dario, there seems to be a misunderstanding about the Device Tree.
> > >
> > > It is used *only* for hardware that is permanently attached, present at
> > > boot, and forever after. Not for dyamically added stuff, and definitely
> > > not for ldiscs that have to be attached manually by the user.
> > >
> > >
> > > The only exception to this is if you have an embedded device with an
> > > slcan adapter permanently attached to one of its UARTs. Then you can
> > > use the serdev ldisc adapter to attach the ldisc automatically at boot.
> >
> > It is evident that I am lacking some skills (I will try to fix it :)).
>
> We're all here to learn something!
>
> > I think it is equally clear that it is not worth going down this path.
>
> If you have a static attached serial devices serdev is the way to go.
> But slcan has so many drawbacks compared to "real" CAN adapters that I
> hope the no one uses them in such a scenario.
>
> > > If you are actively developing for such a use case, please let us know,
> > > so we know what you're after and can help you better :)
> >
> > I don't have a use case, other than to try, if possible, to make the driver
> > autonomous from slcand / slcan_attach for the CAN bus setup.
>
> From my point of view your job is done!

Ok.

>
> > Returning to Marc's previous analysis:
> > "... Some USB CAN drivers query the bit timing const from the USB device."
> >
> > Can we think of taking the gs_usb driver as inspiration for getting/setting the
> > bit timings?
> >
> > https://elixir.bootlin.com/linux/latest/source/drivers/net/can/usb/gs_usb.c#L951
> > https://elixir.bootlin.com/linux/latest/source/drivers/net/can/usb/gs_usb.c#L510
> >
> > and, as done with patches:
> >
> > can: slcan: extend the protocol with CAN state info
> > can: slcan: extend the protocol with error info
>
> You can define a way to query bit timing constants and CAN clock rate,
> but you have to get this into the "official" firmware. You have to roll
> out a firmware update to all devices. What about non official firmware?
>
> > further extend the protocol to get/set the bit timing from / to the adapter ?
> > In the case of non-standard bit rates, the driver would try, depending on the
> > firmware of the adapter, to calculate and set the bit timings autonomously.
>
> If an adapter follows 100% the official firmware doc the BTR registers
> are interpreted as SJA1000 with 8 MHz CAN clock.

I checked the sources and documentation of the usb adapter I used (i.
e. Https://www.fischl.de/usbtin/):
...
sxxyyzz[CR]                 Set can bitrate registers of MCP2515. You
can set non-standard baudrates which are not supported by the "Sx"
command.
                                     xx: CNF1 as hexadecimal value (00-FF)
                                     yy: CNF2 as hexadecimal value (00-FF)
                                     zz: CNF3 as hexadecimal value
...

Different from what is reported by can232_ver3_Manual.pdf :

sxxyy[CR]         Setup with BTR0/BTR1 CAN bit-rates where xx and yy is a hex
                         value. This command is only active if the CAN

And here is the type of control carried out by the slcan_attach for
the btr parameter:
https://github.com/linux-can/can-utils/blob/master/slcan_attach.c#L144
When I would have expected a different check (i. e. if (strlen(btr) > 4).
Therefore it is possible that each adapter uses these bytes in its own
way as well as
in the content and also in the number of bytes.

Thanks and regards,
Dario

>
> See
>
> | https://lore.kernel.org/all/20220728105049.43gbjuctezxzmm4j@pengutronix.de
>
> where I compare the 125 Kbit/s BTR config of the documentation with the
> bit timing calculated by the kernel algorithm.
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
