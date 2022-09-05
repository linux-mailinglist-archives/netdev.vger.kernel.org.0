Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95E05AC904
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 05:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235876AbiIEDQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 23:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234382AbiIEDQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 23:16:22 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9768F2CCA9;
        Sun,  4 Sep 2022 20:16:15 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 708801BF207;
        Mon,  5 Sep 2022 03:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662347774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k8N1x8Yb6P/m+w/Z+VH3G0s3WLf6ly436UXghGfJCU8=;
        b=OeX8CcyU9eeU6r+c5RXbv0FoSSpyLXdBuCl60TnDFC9Ckvbi2e6V3auhdURDsiQh/sNyyu
        09hE4/A+dq6UUoWzhA2tjBkNlWxpRxqmRYsfC6JcIOlUudhqyp+CX+0tXIL9w0hglwPY5v
        XtK6c9k3DXfSztpx84DWD/vw5vsjfL1FuHH9A8WQolCfQxnMBaS10c1GzG9j9yinvvVWBX
        oJil5ow8fxVHX9nWSgYnIHy1MgJH40P70iUZulIe20LOZY0mHf4Uuc+rt1xcu5vHBNp/bC
        8Q9RJz6qx4WcyxFdLO03/h15QxFK9t7thcwmwRG7TQz89KwnNDSD/riqJrr4DA==
Date:   Mon, 5 Sep 2022 05:16:08 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        werner@almesberger.net
Subject: Re: [PATCH wpan-next 01/20] net: mac802154: Allow the creation of
 coordinator interfaces
Message-ID: <20220905051608.5354637a@xps-13>
In-Reply-To: <CAK-6q+jiDcf_M6S+gWh_qms=dMPaSb4daPC7Afs6RZjQdHGinQ@mail.gmail.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
        <CAK-6q+itA0C4zPAq5XGKXgCHW5znSFeB-YDMp3uB9W-kLV6WaA@mail.gmail.com>
        <20220825145831.1105cb54@xps-13>
        <CAK-6q+j3LMoSe_7u0WqhowdPV9KM-6g0z-+OmSumJXCZfo0CAw@mail.gmail.com>
        <20220826095408.706438c2@xps-13>
        <CAK-6q+gxD0TkXzUVTOiR4-DXwJrFUHKgvccOqF5QMGRjfZQwvw@mail.gmail.com>
        <20220829100214.3c6dad63@xps-13>
        <CAK-6q+gJwm0bhHgMVBF_pmjD9zSrxxHvNGdTrTm0fG-hAmSaUQ@mail.gmail.com>
        <20220831173903.1a980653@xps-13>
        <20220901020918.2a15a8f9@xps-13>
        <20220901150917.5246c2d0@xps-13>
        <CAK-6q+g1Gnew=zWsnW=HAcLTqFYHF+P94Q+Ywh7Rir8J8cgCgw@mail.gmail.com>
        <20220903020829.67db0af8@xps-13>
        <CAK-6q+hO1i=xvXx3wHo658ph93FwuVs_ssjG0=jnphEe8a+gxw@mail.gmail.com>
        <20220903180556.6430194b@xps-13>
        <CAK-6q+hXrUOzrsucOw3vJMu3UscOMG8X3E74px6bEZoDO4PLjw@mail.gmail.com>
        <CAK-6q+iA80oRi_NJODNkJTJmkVkcvMwO=HxRr-bPT3-u6f7iLA@mail.gmail.com>
        <CAK-6q+jiDcf_M6S+gWh_qms=dMPaSb4daPC7Afs6RZjQdHGinQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Sat, 3 Sep 2022 15:40:35 -0400:

> Hi,
>=20
> On Sat, Sep 3, 2022 at 3:10 PM Alexander Aring <aahringo@redhat.com> wrot=
e:
> >
> > On Sat, Sep 3, 2022 at 3:07 PM Alexander Aring <aahringo@redhat.com> wr=
ote: =20
> > >
> > > Hi,
> > >
> > > On Sat, Sep 3, 2022 at 12:06 PM Miquel Raynal <miquel.raynal@bootlin.=
com> wrote:
> > > ... =20
> > > >
> > > > On the Tx side, when sending eg. an association request or an
> > > > association response, I must expect and wait for an ack. This is
> > > > what I am struggling to do. How can I know that a frame which I just
> > > > transmitted has been acked? Bonus points, how can I do that in such=
 a
> > > > way that it will work with other devices? (hints below)
> > > > =20
> > > > > AACK will send a back if a frame with ack request bit was receive=
d.
> > > > > =20
> > > > > > say in a commit) I have seen no further updates about it so I g=
uess
> > > > > > it's still not available. I don't see any other way to know if a
> > > > > > frame's ack has been received or not reliably. =20
> > > > >
> > > > > You implemented it for the at86rf230 driver (the spi one which is=
 what
> > > > > also atusb uses). You implemented the
> > > > >
> > > > > ctx->trac =3D IEEE802154_NO_ACK;
> > > > >
> > > > > which signals the upper layer that if the ack request bit is set,=
 that
> > > > > there was no ack.
> > > > >
> > > > > But yea, there is a missing feature for atusb yet which requires
> > > > > firmware changes as well. =20
> > > >
> > > > :'( =20
> > >
> > > There is a sequence handling in tx done on atusb firmware and I think
> > > it should be pretty easy to add a byte for trac status.
> > >
> > > diff --git a/atusb/fw/mac.c b/atusb/fw/mac.c
> > > index 835002c..156bd95 100644
> > > --- a/atusb/fw/mac.c
> > > +++ b/atusb/fw/mac.c
> > > @@ -116,7 +116,7 @@ static void receive_frame(void)
> > >
> > >  static bool handle_irq(void)
> > >  {
> > > -       uint8_t irq;
> > > +       uint8_t irq, data[2];
> > >
> > >         irq =3D reg_read(REG_IRQ_STATUS);
> > >         if (!(irq & IRQ_TRX_END))
> > > @@ -124,7 +124,15 @@ static bool handle_irq(void)
> > >
> > >         if (txing) {
> > >                 if (eps[1].state =3D=3D EP_IDLE) {
> > > -                       usb_send(&eps[1], &this_seq, 1, tx_ack_done, =
NULL);
> > > +                       data[0] =3D tx_ack_done;
> > > +
> > > +                       spi_begin();
> > > +                       spi_io(REG_TRX_STATE);
> > > +
> > > +                       data[1] =3D spi_recv();
> > > +                       spi_end(); =20
> >
> > data[1] =3D reg_read(REG_TRX_STATE) as seen above for REG_IRQ_STATUS
> > would be better here...
> > =20
>=20
> after digging the code more, there is another queue case which we
> should handle, also correct using buffer parameter instead of the
> callback parameter which was stupid... However I think the direction
> is clear. Sorry for the spam.

Don't be, your feedback is just super useful.

> diff --git a/atusb/fw/mac.c b/atusb/fw/mac.c
> index 835002c..b52ba1a 100644
> --- a/atusb/fw/mac.c
> +++ b/atusb/fw/mac.c
> @@ -32,7 +32,7 @@ static uint8_t tx_buf[MAX_PSDU];
>  static uint8_t tx_size =3D 0;
>  static bool txing =3D 0;
>  static bool queued_tx_ack =3D 0;
> -static uint8_t next_seq, this_seq, queued_seq;
> +static uint8_t next_seq, this_seq, queued_seq, queued_tx_trac;
>=20
>=20
>  /* ----- Receive buffer management -------------------------------------=
---- */
> @@ -57,6 +57,7 @@ static void tx_ack_done(void *user);
>  static void usb_next(void)
>  {
>         const uint8_t *buf;
> +       uint8_t data[2];
>=20
>         if (rx_in !=3D rx_out) {
>                 buf =3D rx_buf[rx_out];
> @@ -65,7 +66,9 @@ static void usb_next(void)
>         }
>=20
>         if (queued_tx_ack) {
> -               usb_send(&eps[1], &queued_seq, 1, tx_ack_done, NULL);
> +               data[0] =3D queued_seq;
> +               data[1] =3D queued_tx_trac;
> +               usb_send(&eps[1], data, sizeof(data), tx_ack_done, NULL);
>                 queued_tx_ack =3D 0;
>         }
>  }
> @@ -116,7 +119,7 @@ static void receive_frame(void)
>=20
>  static bool handle_irq(void)
>  {
> -       uint8_t irq;
> +       uint8_t irq, data[2];

I don't know why, but defining data on the stack just does not work.
Defining it above with the other static variables is okay. I won't
fight more for "today" but if someone has an explanation I am all hears.

>         irq =3D reg_read(REG_IRQ_STATUS);
>         if (!(irq & IRQ_TRX_END))
> @@ -124,10 +127,13 @@ static bool handle_irq(void)
>=20
>         if (txing) {
>                 if (eps[1].state =3D=3D EP_IDLE) {
> -                       usb_send(&eps[1], &this_seq, 1, tx_ack_done, NULL=
);
> +                       data[0] =3D this_seq;
> +                       data[1] =3D reg_read(REG_TRX_STATE);
> +                       usb_send(&eps[1], data, sizeof(data),
> tx_ack_done, NULL);
>                 } else {
>                         queued_tx_ack =3D 1;
>                         queued_seq =3D this_seq;
> +                       queued_tx_trac =3D reg_read(REG_TRX_STATE);
>                 }
>                 txing =3D 0;
>                 return 1;
>=20


Thanks,
Miqu=C3=A8l
