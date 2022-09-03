Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBF65AC10F
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 21:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbiICTKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 15:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbiICTKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 15:10:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4283F324
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 12:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662232216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZK7kW7g3nA/IMsZ748NoWytpPXrK/3y9tfwwIoIKLoA=;
        b=J3YPcg8KqqfIThLcMnJxGpyw7BCvsnjJsMNAHGyecPA1II/KXQLSaJhyMz7gsk2j3x8p8W
        flQx53g6qth53g283OlznHbS7ZHY69V6okN+vbdb2GvC2X8YZINeFWP5whzrlXPP0uVFtX
        JCn9lkOcVdd5AIrtieB55Ck+o0Gr1Tg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-651-TfQiExsbNDGtV20NJL05-w-1; Sat, 03 Sep 2022 15:10:15 -0400
X-MC-Unique: TfQiExsbNDGtV20NJL05-w-1
Received: by mail-qv1-f70.google.com with SMTP id w19-20020a0562140b3300b0049cad77df78so1055979qvj.6
        for <netdev@vger.kernel.org>; Sat, 03 Sep 2022 12:10:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ZK7kW7g3nA/IMsZ748NoWytpPXrK/3y9tfwwIoIKLoA=;
        b=zBKEBM9W8oMsIHYAFSzEFwg1hmHZ1MnsKRAj5Wgtu9jOPHn/vDdhH+JxSSzTnU9pVu
         qF2EfLIU/eTBZ9md/mBr6z2ATXvAavHT4YZBlohPObqFMQzH8rxMZMyYoUmobBWIIkq4
         qI8oahFwpTViRE71VgOe6W5G5SY26SsLcykrZTxNNsnVAemF++Haj6zSKaGBOgWIcrMy
         lIpHNwpkfH2UV7uFsxor0RBZJPW/T0mEQihXzGVh/wVsP6/LoOx4NYZQzhRop/cXYIxE
         WnFubBJoyEDLsxvymfre/LPyf7yISPNgjCVAIJgBMoQiTW0+hh9zlY9+vfMfW5P7Lxe9
         xG1Q==
X-Gm-Message-State: ACgBeo1Jvop/uczO5Ju60oJegs4BZVCmSORc+NwRPljnx4W/iUvpEL20
        eLaF2ffkHFtUOe8+Ch0LQkxk6FU+EJ+L0FRBr0K/cQz0weJTRYBlWPzCJGFGlbMA/U+DLOcSmtm
        OAUb4MCp0qOHdc7W9kKJFV58a171KekiC
X-Received: by 2002:a37:a02:0:b0:6bb:17af:a8e6 with SMTP id 2-20020a370a02000000b006bb17afa8e6mr27233741qkk.80.1662232214957;
        Sat, 03 Sep 2022 12:10:14 -0700 (PDT)
X-Google-Smtp-Source: AA6agR435Cns1uVn6933JwLlcyP7VA8SmkopDyP3EawLba6isjFyHIz1Ze0Uaw9PMAboWgNvclY0EDXLfW0ecvNy2ns=
X-Received: by 2002:a37:a02:0:b0:6bb:17af:a8e6 with SMTP id
 2-20020a370a02000000b006bb17afa8e6mr27233730qkk.80.1662232214757; Sat, 03 Sep
 2022 12:10:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <20220823182950.1c722e13@xps-13> <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
 <20220824122058.1c46e09a@xps-13> <CAK-6q+gjgQ1BF-QrT01JWh+2b3oL3RU+SoxUf5t7h3Hc6R8pcg@mail.gmail.com>
 <20220824152648.4bfb9a89@xps-13> <CAK-6q+itA0C4zPAq5XGKXgCHW5znSFeB-YDMp3uB9W-kLV6WaA@mail.gmail.com>
 <20220825145831.1105cb54@xps-13> <CAK-6q+j3LMoSe_7u0WqhowdPV9KM-6g0z-+OmSumJXCZfo0CAw@mail.gmail.com>
 <20220826095408.706438c2@xps-13> <CAK-6q+gxD0TkXzUVTOiR4-DXwJrFUHKgvccOqF5QMGRjfZQwvw@mail.gmail.com>
 <20220829100214.3c6dad63@xps-13> <CAK-6q+gJwm0bhHgMVBF_pmjD9zSrxxHvNGdTrTm0fG-hAmSaUQ@mail.gmail.com>
 <20220831173903.1a980653@xps-13> <20220901020918.2a15a8f9@xps-13>
 <20220901150917.5246c2d0@xps-13> <CAK-6q+g1Gnew=zWsnW=HAcLTqFYHF+P94Q+Ywh7Rir8J8cgCgw@mail.gmail.com>
 <20220903020829.67db0af8@xps-13> <CAK-6q+hO1i=xvXx3wHo658ph93FwuVs_ssjG0=jnphEe8a+gxw@mail.gmail.com>
 <20220903180556.6430194b@xps-13> <CAK-6q+hXrUOzrsucOw3vJMu3UscOMG8X3E74px6bEZoDO4PLjw@mail.gmail.com>
In-Reply-To: <CAK-6q+hXrUOzrsucOw3vJMu3UscOMG8X3E74px6bEZoDO4PLjw@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sat, 3 Sep 2022 15:10:03 -0400
Message-ID: <CAK-6q+iA80oRi_NJODNkJTJmkVkcvMwO=HxRr-bPT3-u6f7iLA@mail.gmail.com>
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
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 3, 2022 at 3:07 PM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Sat, Sep 3, 2022 at 12:06 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> ...
> >
> > On the Tx side, when sending eg. an association request or an
> > association response, I must expect and wait for an ack. This is
> > what I am struggling to do. How can I know that a frame which I just
> > transmitted has been acked? Bonus points, how can I do that in such a
> > way that it will work with other devices? (hints below)
> >
> > > AACK will send a back if a frame with ack request bit was received.
> > >
> > > > say in a commit) I have seen no further updates about it so I guess
> > > > it's still not available. I don't see any other way to know if a
> > > > frame's ack has been received or not reliably.
> > >
> > > You implemented it for the at86rf230 driver (the spi one which is what
> > > also atusb uses). You implemented the
> > >
> > > ctx->trac = IEEE802154_NO_ACK;
> > >
> > > which signals the upper layer that if the ack request bit is set, that
> > > there was no ack.
> > >
> > > But yea, there is a missing feature for atusb yet which requires
> > > firmware changes as well.
> >
> > :'(
>
> There is a sequence handling in tx done on atusb firmware and I think
> it should be pretty easy to add a byte for trac status.
>
> diff --git a/atusb/fw/mac.c b/atusb/fw/mac.c
> index 835002c..156bd95 100644
> --- a/atusb/fw/mac.c
> +++ b/atusb/fw/mac.c
> @@ -116,7 +116,7 @@ static void receive_frame(void)
>
>  static bool handle_irq(void)
>  {
> -       uint8_t irq;
> +       uint8_t irq, data[2];
>
>         irq = reg_read(REG_IRQ_STATUS);
>         if (!(irq & IRQ_TRX_END))
> @@ -124,7 +124,15 @@ static bool handle_irq(void)
>
>         if (txing) {
>                 if (eps[1].state == EP_IDLE) {
> -                       usb_send(&eps[1], &this_seq, 1, tx_ack_done, NULL);
> +                       data[0] = tx_ack_done;
> +
> +                       spi_begin();
> +                       spi_io(REG_TRX_STATE);
> +
> +                       data[1] = spi_recv();
> +                       spi_end();

data[1] = reg_read(REG_TRX_STATE) as seen above for REG_IRQ_STATUS
would be better here...

- Alex

