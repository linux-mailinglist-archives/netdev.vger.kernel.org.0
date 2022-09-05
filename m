Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C41D5ADB73
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 00:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiIEWfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 18:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbiIEWfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 18:35:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE511EC66
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 15:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662417317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C2/Mydp8vjCANndV/tTiRuz68eLKVMoiyb7tyhGhFWw=;
        b=P+stzy0aAA9Lbi0gCOyln+KxV8QyDzA0WvbC1b2yE6fYxm54UjdGe+uq610AbWQogPAMwj
        vV6OEWImCioXAD/ltCbaQB4CwSqdp8aYNVPrj9baFxyb+z8qDe52VK2P5c1kl9SCz2t0jt
        i6d88I8x8qgfPGZWKUmJnUDgjbKiu48=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-294-MDxhYYe7OTmck3WTPHIyKQ-1; Mon, 05 Sep 2022 18:35:16 -0400
X-MC-Unique: MDxhYYe7OTmck3WTPHIyKQ-1
Received: by mail-qk1-f198.google.com with SMTP id x22-20020a05620a259600b006b552a69231so7642191qko.18
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 15:35:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=C2/Mydp8vjCANndV/tTiRuz68eLKVMoiyb7tyhGhFWw=;
        b=imVGosl7MzmU62s0OySLT9bpGHssNKrSBPaQ69kOOQAqJxYy89EG59nUXRD4kzbkFQ
         rHvxHy/z1v3fVeog3bh5bU3iGoPjPH8O6qWjm6gup93O2hgQ7fQVhGVXui4uQ+0ICCwi
         1kCQpOTm2Zy86uIPXxOsBh24BXtBCKeI5Y67pOiEc+2aPQ8On7I+/zqTwlSgRtQG0Y+d
         LDWwgoCphaeVhOg9VJY3Y4j79EWgtadTO+qeaY4mu9O8WQx/v3uqXakgEbdjMr/p/iDH
         IwHCjpTL6FI65oOuibEzQTk7xdR7MmAAmB5fZnDwdXEJEfX23Xuezbppc4aR5UQnXKFx
         9MaA==
X-Gm-Message-State: ACgBeo0ltzHA+VeUy8V1Dz/2d75c8Z6a8MRl4luX10gJg1a1cZbg/mZT
        xnlqDuP4eCdp6MmDmg24yVB7DWa5tZdGCFvL4YV3TnkYv0pPXjgpNYjSG72X+RrG37kNrMDVxfL
        NS1SFAthUR2heh9Jlz8y8eD27a7YPDh2H
X-Received: by 2002:a05:620a:44cb:b0:6c9:c460:8838 with SMTP id y11-20020a05620a44cb00b006c9c4608838mr1081qkp.770.1662417315760;
        Mon, 05 Sep 2022 15:35:15 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4R3rST4GNyXnVICYcos5fM5YQx+lIc5De3VVYdshhff7fETZK+3CoD4oazZWFUJqNGaYUFsVaMBD7r9+VDZqA=
X-Received: by 2002:a05:620a:44cb:b0:6c9:c460:8838 with SMTP id
 y11-20020a05620a44cb00b006c9c4608838mr1051qkp.770.1662417315363; Mon, 05 Sep
 2022 15:35:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <CAK-6q+itA0C4zPAq5XGKXgCHW5znSFeB-YDMp3uB9W-kLV6WaA@mail.gmail.com>
 <20220825145831.1105cb54@xps-13> <CAK-6q+j3LMoSe_7u0WqhowdPV9KM-6g0z-+OmSumJXCZfo0CAw@mail.gmail.com>
 <20220826095408.706438c2@xps-13> <CAK-6q+gxD0TkXzUVTOiR4-DXwJrFUHKgvccOqF5QMGRjfZQwvw@mail.gmail.com>
 <20220829100214.3c6dad63@xps-13> <CAK-6q+gJwm0bhHgMVBF_pmjD9zSrxxHvNGdTrTm0fG-hAmSaUQ@mail.gmail.com>
 <20220831173903.1a980653@xps-13> <20220901020918.2a15a8f9@xps-13>
 <20220901150917.5246c2d0@xps-13> <CAK-6q+g1Gnew=zWsnW=HAcLTqFYHF+P94Q+Ywh7Rir8J8cgCgw@mail.gmail.com>
 <20220903020829.67db0af8@xps-13> <CAK-6q+hO1i=xvXx3wHo658ph93FwuVs_ssjG0=jnphEe8a+gxw@mail.gmail.com>
 <20220903180556.6430194b@xps-13> <CAK-6q+hXrUOzrsucOw3vJMu3UscOMG8X3E74px6bEZoDO4PLjw@mail.gmail.com>
 <CAK-6q+iA80oRi_NJODNkJTJmkVkcvMwO=HxRr-bPT3-u6f7iLA@mail.gmail.com>
 <CAK-6q+jiDcf_M6S+gWh_qms=dMPaSb4daPC7Afs6RZjQdHGinQ@mail.gmail.com> <20220905051608.5354637a@xps-13>
In-Reply-To: <20220905051608.5354637a@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 5 Sep 2022 18:35:04 -0400
Message-ID: <CAK-6q+jCWE_M+LXdToHy-kH91hZsD2qGycCU3tsSKqjjt=UjFw@mail.gmail.com>
Subject: Re: [PATCH wpan-next 01/20] net: mac802154: Allow the creation of
 coordinator interfaces
To:     Miquel Raynal <miquel.raynal@bootlin.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Sep 4, 2022 at 11:16 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Sat, 3 Sep 2022 15:40:35 -0400:
>
> > Hi,
> >
> > On Sat, Sep 3, 2022 at 3:10 PM Alexander Aring <aahringo@redhat.com> wrote:
> > >
> > > On Sat, Sep 3, 2022 at 3:07 PM Alexander Aring <aahringo@redhat.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > On Sat, Sep 3, 2022 at 12:06 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > ...
> > > > >
> > > > > On the Tx side, when sending eg. an association request or an
> > > > > association response, I must expect and wait for an ack. This is
> > > > > what I am struggling to do. How can I know that a frame which I just
> > > > > transmitted has been acked? Bonus points, how can I do that in such a
> > > > > way that it will work with other devices? (hints below)
> > > > >
> > > > > > AACK will send a back if a frame with ack request bit was received.
> > > > > >
> > > > > > > say in a commit) I have seen no further updates about it so I guess
> > > > > > > it's still not available. I don't see any other way to know if a
> > > > > > > frame's ack has been received or not reliably.
> > > > > >
> > > > > > You implemented it for the at86rf230 driver (the spi one which is what
> > > > > > also atusb uses). You implemented the
> > > > > >
> > > > > > ctx->trac = IEEE802154_NO_ACK;
> > > > > >
> > > > > > which signals the upper layer that if the ack request bit is set, that
> > > > > > there was no ack.
> > > > > >
> > > > > > But yea, there is a missing feature for atusb yet which requires
> > > > > > firmware changes as well.
> > > > >
> > > > > :'(
> > > >
> > > > There is a sequence handling in tx done on atusb firmware and I think
> > > > it should be pretty easy to add a byte for trac status.
> > > >
> > > > diff --git a/atusb/fw/mac.c b/atusb/fw/mac.c
> > > > index 835002c..156bd95 100644
> > > > --- a/atusb/fw/mac.c
> > > > +++ b/atusb/fw/mac.c
> > > > @@ -116,7 +116,7 @@ static void receive_frame(void)
> > > >
> > > >  static bool handle_irq(void)
> > > >  {
> > > > -       uint8_t irq;
> > > > +       uint8_t irq, data[2];
> > > >
> > > >         irq = reg_read(REG_IRQ_STATUS);
> > > >         if (!(irq & IRQ_TRX_END))
> > > > @@ -124,7 +124,15 @@ static bool handle_irq(void)
> > > >
> > > >         if (txing) {
> > > >                 if (eps[1].state == EP_IDLE) {
> > > > -                       usb_send(&eps[1], &this_seq, 1, tx_ack_done, NULL);
> > > > +                       data[0] = tx_ack_done;
> > > > +
> > > > +                       spi_begin();
> > > > +                       spi_io(REG_TRX_STATE);
> > > > +
> > > > +                       data[1] = spi_recv();
> > > > +                       spi_end();
> > >
> > > data[1] = reg_read(REG_TRX_STATE) as seen above for REG_IRQ_STATUS
> > > would be better here...
> > >
> >
> > after digging the code more, there is another queue case which we
> > should handle, also correct using buffer parameter instead of the
> > callback parameter which was stupid... However I think the direction
> > is clear. Sorry for the spam.
>
> Don't be, your feedback is just super useful.
>
> > diff --git a/atusb/fw/mac.c b/atusb/fw/mac.c
> > index 835002c..b52ba1a 100644
> > --- a/atusb/fw/mac.c
> > +++ b/atusb/fw/mac.c
> > @@ -32,7 +32,7 @@ static uint8_t tx_buf[MAX_PSDU];
> >  static uint8_t tx_size = 0;
> >  static bool txing = 0;
> >  static bool queued_tx_ack = 0;
> > -static uint8_t next_seq, this_seq, queued_seq;
> > +static uint8_t next_seq, this_seq, queued_seq, queued_tx_trac;
> >
> >
> >  /* ----- Receive buffer management ----------------------------------------- */
> > @@ -57,6 +57,7 @@ static void tx_ack_done(void *user);
> >  static void usb_next(void)
> >  {
> >         const uint8_t *buf;
> > +       uint8_t data[2];
> >
> >         if (rx_in != rx_out) {
> >                 buf = rx_buf[rx_out];
> > @@ -65,7 +66,9 @@ static void usb_next(void)
> >         }
> >
> >         if (queued_tx_ack) {
> > -               usb_send(&eps[1], &queued_seq, 1, tx_ack_done, NULL);
> > +               data[0] = queued_seq;
> > +               data[1] = queued_tx_trac;
> > +               usb_send(&eps[1], data, sizeof(data), tx_ack_done, NULL);

This is also broken, see below.

> >                 queued_tx_ack = 0;
> >         }
> >  }
> > @@ -116,7 +119,7 @@ static void receive_frame(void)
> >
> >  static bool handle_irq(void)
> >  {
> > -       uint8_t irq;
> > +       uint8_t irq, data[2];
>
> I don't know why, but defining data on the stack just does not work.
> Defining it above with the other static variables is okay. I won't
> fight more for "today" but if someone has an explanation I am all hears.

I can explain it... following the usb_send() it will end in usb_io()
and this is an asynchronous function to use somehow the USB IP core
API of the mcu... it's wrong to use a stack variable here because it
can be overwritten. I am sorry, I did not keep that in mind...

- Alex

