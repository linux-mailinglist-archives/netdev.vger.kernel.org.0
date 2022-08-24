Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C08459FA2A
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 14:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237392AbiHXMng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 08:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237237AbiHXMne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 08:43:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A705386734
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 05:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661345012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NfBSLwmcH4eSGSU96LAujL7kLmANp0zLheegbWZ48gQ=;
        b=K6jkrtdindBjebK1DM2SKr2zfmuFlSUceWONYR/CZH6QD1zREkRW2/Klb+2nh1GM5Iqb/S
        FPALeRqshVa+lTg8iJgZQr0x/SgtPnAYJrVo+fFnX3n9iUT2le7T/mqJqpPK+NyqO+B1el
        /vNzVcxXpow3PuL107aRDcBVQ1KoAp4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-581-y8TwOchLO0ifZdJ6P4zwMg-1; Wed, 24 Aug 2022 08:43:31 -0400
X-MC-Unique: y8TwOchLO0ifZdJ6P4zwMg-1
Received: by mail-qt1-f200.google.com with SMTP id z10-20020a05622a124a00b003445680ff47so12676715qtx.8
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 05:43:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=NfBSLwmcH4eSGSU96LAujL7kLmANp0zLheegbWZ48gQ=;
        b=xSgiEVtgpNKIv6FSpA7qkIHGv649G+7bq6ocRnhaAeaO5PkLHRTZAcxJfuuQ+beMH9
         o5+3ALHccO/B3l9WUKouYE+44cnzOBKsuTO6pSokd7ngJDEQYkv+igpr9geTvzA8ubon
         nHEMJ7AMex92v4/eK8znYRXh7zdlyOE7SA4/4lmGSOG2SiR9s8W5xbJEQksnDE9CdZjb
         KhQItlZUBcfAqPW2W6D5YZrD2XPA43CQhinnKUD+bkKIW2I3QgzgWR9A1r7qqWgEcb49
         VM/l/oLCUwTQR7Qqk8DxyzyBDnLUbjVZtL4XTYoDOZd6BPsqEbMQ5306H+QtGJZv7yAB
         ahLA==
X-Gm-Message-State: ACgBeo1IQ5O0pyDEGpozuBFbAymnqBpJ1zlUpxH+gJYAKWyvcBpTVB8l
        MvDV0uKVa6vehhvlHj/RigIdYbRbSQnLu21vrsCYedvpE2uUiEOn/BnbzhMBWW2HdVFLkQyRKZ7
        DMGMDh2wRmGq+j5vra+Y9OtImznOJ4Tzj
X-Received: by 2002:a05:620a:10a4:b0:6ba:e280:3aff with SMTP id h4-20020a05620a10a400b006bae2803affmr19651862qkk.177.1661345011129;
        Wed, 24 Aug 2022 05:43:31 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5b32f1Ioybd27CXOEYrx2s2fvvutQPgMZWKs8jqW8kBj+JAYuWTSzfX8nlDDdeo7pZT9vpTIVzECUgIqN8uMU=
X-Received: by 2002:a05:620a:10a4:b0:6ba:e280:3aff with SMTP id
 h4-20020a05620a10a400b006bae2803affmr19651848qkk.177.1661345010915; Wed, 24
 Aug 2022 05:43:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <20220701143052.1267509-2-miquel.raynal@bootlin.com> <CAK-6q+jkUUjAGqEDgU1oJvRkigUbvSO5SXWRau6+320b=GbfxQ@mail.gmail.com>
 <20220819191109.0e639918@xps-13> <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
 <20220823182950.1c722e13@xps-13> <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
 <20220824122058.1c46e09a@xps-13>
In-Reply-To: <20220824122058.1c46e09a@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 24 Aug 2022 08:43:20 -0400
Message-ID: <CAK-6q+gjgQ1BF-QrT01JWh+2b3oL3RU+SoxUf5t7h3Hc6R8pcg@mail.gmail.com>
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
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
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

Hi,

On Wed, Aug 24, 2022 at 6:21 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
...
>
> Actually right now the second level is not enforced, and all the
> filtering levels are a bit fuzzy and spread everywhere in rx.c.
>
> I'm gonna see if I can at least clarify all of that and only make
> coord-dependent the right section because right now a
> ieee802154_coord_rx() path in ieee802154_rx_handle_packet() does not
> really make sense given that the level 3 filtering rules are mostly
> enforced in ieee802154_subif_frame().

One thing I mentioned before is that we probably like to have a
parameter for rx path to give mac802154 a hint on which filtering
level it was received. We don't have that, I currently see that this
is a parameter for hwsim receiving it on promiscuous level only and
all others do third level filtering.
We need that now, because the promiscuous mode was only used for
sniffing which goes directly into the rx path for monitors. With scan
we mix things up here and in my opinion require such a parameter and
do filtering if necessary.

- Alex

