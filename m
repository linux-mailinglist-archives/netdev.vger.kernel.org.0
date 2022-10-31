Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF2C612E98
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 02:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJaBYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 21:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiJaBYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 21:24:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83FEDBE
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 18:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667179430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gvfohQLFAD7qCAPy9Z9quvYxHyQhH/vW75ZgSof4psI=;
        b=IVOlAyqA+GePPgZIJXy9TvJxRp7n9zBKKnSBplHVHnHNvXuxy+6jHzJ2nrowCmUpE801fd
        yRnYmQXx0RV9FJEh5AeZZSl2xAIQg9+pm0qV++/mxC03ISd0S+41tnh21rKSsoiudr7mqt
        4kxYPFnzKqAjQipGZOofEQclGIkBr50=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-537-2i2BUmyrOn6d50AzcLhxvQ-1; Sun, 30 Oct 2022 21:23:49 -0400
X-MC-Unique: 2i2BUmyrOn6d50AzcLhxvQ-1
Received: by mail-ej1-f70.google.com with SMTP id xh12-20020a170906da8c00b007413144e87fso4942551ejb.14
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 18:23:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gvfohQLFAD7qCAPy9Z9quvYxHyQhH/vW75ZgSof4psI=;
        b=rasMAWXWvZY1PBwO82Zmp4VpUgJoK8/GLr1BjAtKsTDhFtzfajHKsgfHqZWei0iu0k
         2ZNwDThJ2Hpi1gm0PNWDz8Cc1mWbTF7r0eqFP6sMVw2nkIsacmioqFoCfYqva//Kgm/X
         8xvkCrzNXOYAwBtXQv+TwvPJme8SvXLZUxbTq18AcK/hFL1HBEFiidrRISVY5pZIFOSF
         f5IE0E4SzvYIbzO6+DaJLnaEf7W2i5MG8MyW65YYtO/j3PaUCjoX3nIbAci99fX8nGfj
         ir6d0fQEmQSGvM2xWnVMSNFhNBWvEx5/3FDHHLMcuSTVRHuO3rRVkC0aGgTaHab1VFex
         SWwg==
X-Gm-Message-State: ACrzQf3wFUZVYYXHolo824xo9hb9tEUAkZFQqOcdudD29qQx328AV53a
        jAC9CAKfK/IhQzGYvqd5hG09cz8rBQdFrTxHFNwceuDym8sfgR227tAagsmz6fGOOzFGgKaEggo
        EO774ZjCAEr4yFNyXfY5JBhQKc+DjBQxg
X-Received: by 2002:aa7:de9a:0:b0:44d:8191:44c5 with SMTP id j26-20020aa7de9a000000b0044d819144c5mr10899304edv.232.1667179427818;
        Sun, 30 Oct 2022 18:23:47 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM66q7PrgyqbeHmLABEQ3sCw/ad74AYAmeG9cKVvDNrFBb8Ih91SCwnNEgD3tR7BuJQZgpo3GfUK4wKIiI9loaM=
X-Received: by 2002:aa7:de9a:0:b0:44d:8191:44c5 with SMTP id
 j26-20020aa7de9a000000b0044d819144c5mr10899288edv.232.1667179427598; Sun, 30
 Oct 2022 18:23:47 -0700 (PDT)
MIME-Version: 1.0
References: <20221018183639.806719-1-miquel.raynal@bootlin.com>
 <CAK-6q+hoJiLWyHNi90_7kbyGp9h_jV-bvRHYRQDVrEb1u_enEA@mail.gmail.com>
 <20221019115242.571c19bb@xps-13> <CAK-6q+jna-UXWVvTjnJnJ+LADB0oP_WmVJV0N5r00cb1tfhkpA@mail.gmail.com>
 <20221024141601.218b68e2@xps-13>
In-Reply-To: <20221024141601.218b68e2@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 30 Oct 2022 21:23:36 -0400
Message-ID: <CAK-6q+jiUVJdEHJJuKuRFo5EEX4cgvgXLfEUiZeo9zeWtMfVcA@mail.gmail.com>
Subject: Re: [PATCH wpan-next] mac802154: Allow the creation of coordinator interfaces
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Oct 24, 2022 at 8:16 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> > > About the way we handle the PAN coordinator role I have a couple of
> > > questions:
> > > - shall we consider only the PAN coordinator to be able to accept
> > >   associations or is any coordinator in the PAN able to do it? (this is
> > >   not clear to me)
> >
> > Me either, it sounds for me that coordinators are "leaves" and pan
> > coordinators are not. It is like in IPv6 level it is a host or router.
>
> I went through the spec once again and I actually (re)discovered
> Annexe E "Time-slot relaying based link extension (TRLE)" which indeed
> seems to tell us that relaying is an extension, so otherwise
> coordinators are "leaves" as you say.
>

okay.

> > > - If a coordinator receives a packet with no destination it should
> > >   expect it to be targeted at the PAN controller. Should we consider
> > >   relaying the packet?
> >
> > I guess it depends what the standard says here?
>
> While we don't implement TRLE (and this is a project on its own) I
> guess we should not perform any relaying.
>

Yes, it's a project on its own.

> > > - Is relaying a hardware feature or should we do it in software?
> > >
> >
> > I think for SoftMAC it is only the address filter which needs to be
> > changed. The rest is in software. So far what I can see here.
>
> If we need to change the address filters then I guess the hardware is
> broken, it would not be usable. The hardware must have a "PAN
> controller" bit to know whether or not the packet must be dropped or
> not when there is no destination field.
>

yes, I was more concerned here that in those "non leaves" the address
filter is set so as it's required to do such handling. Sure hardware
which needs to support it to change it as e.g. ack vs no ack needs to
be reported back - same thing.

> > Question is what we are using here in the Linux kernel to provide such
> > functionality...
> >
> > e.g. see:
> >
> > include/net/dst.h
> >
> > > Regarding the situation where we would have NODE + MONITOR or COORD +
> > > MONITOR, while the interface creation would work, both could not be
> > > open at the same time because the following happens:
> > > mac802154_wpan_open() {
> > >         ieee802154_check_concurrent_iface() {
> > >                 ieee802154_check_mac_settings() {
> > >                         /* prevent the two interface types from being
> > >                          * open at the same time because the filtering
> > >                          * needs are not compatible. */
> > >                 }
> > >         }
> > > }
> > >
> > > Then, because you asked me to anticipate if we ever want to support more
> > > than one NODE or COORD interface at the same time, or at least not to
> > > do anything that would lead to a step back on this regard, I decided I
> > > would provide all the infrastructure to gracefully handle this
> > > situation in the Rx path, even though right now it still cannot happen
> > > because when opening an interface, ieee802154_check_concurrent_iface()
> > > will also prevent two NODE / COORD interfaces to be opened at the same
> > > time.
> >
> > yes, but you are assuming the actual hardware here. A hardware with
> > multiple address filters can indeed support other interfaces at the
> > same time. I can also name one, hwsim and a real one - atusb.
>
> I have this use case in mind, I know the support for it may be
> brought at some point, and I think my proposal is future proof on this
> aspect. Isn't it?

It is.

- Alex

