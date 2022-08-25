Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750915A0579
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 03:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiHYBCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 21:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiHYBCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 21:02:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBC05A3DF
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 18:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661389363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=As7vBntFjQuYod1QsY5gNfKl9Mu0uEY0cuCRhy1F0LU=;
        b=D58UWF1E7h+2MHFei6arm8uBd9uuDaUu7cSeP+Gsnp6YStd80BroDr+Ito/lO+rBAJIcyL
        Dkr2N9Ob2z9raTcjNrX6Zqw9N/7wls/R7dpRJ6mhXkPycTlD802yeTv6TWS4+PFVUEsPFK
        /4q4nnAQHB61ubc/dHzOXrLJlcP3IIk=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-349-0QHpnUVVMYWBeMccHktD-w-1; Wed, 24 Aug 2022 21:02:41 -0400
X-MC-Unique: 0QHpnUVVMYWBeMccHktD-w-1
Received: by mail-qt1-f197.google.com with SMTP id b10-20020a05622a020a00b003437e336ca7so14120208qtx.16
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 18:02:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=As7vBntFjQuYod1QsY5gNfKl9Mu0uEY0cuCRhy1F0LU=;
        b=kL3PZN4Hqn/2OIX7ITIqrqXur7IIJjVUDUAIIv/ADV5H9J4Z5yzVQIg+ywPIgmk30R
         P9gijyrMwIukG0/c8mZaBbjUf0AQnaNVmIsgx1LkWN7QQT2owbPdfPz3+nabNr6H6CSb
         GcEhxC1qu60LNrT8Oyddv7r5aepzga9Chh5ASY33vn22u6NpG1d21EdEa5HoTLJvN5dU
         B12rHdWMU3BT7crDodqBwLvJ8IMAWQBBu17qofMiSAXORughpXJzZBS+RmIXgmZUOIqB
         DFPvsuDLfObXUBR1mLk3GU8GNgvSgYrhGtjeMqfflJ7KpYKOLPmEwPbGUEJuEMCTJnkX
         8tWg==
X-Gm-Message-State: ACgBeo1EZfffhLbkpUXrvQmSgxMRrSpqCIpehfcdkX6KJLlCag2HnjmP
        Cc3eRitYDlWnJMA2LXeItntOK/68jb9x3gDA2Q0vsF8GPHRfgTlUPoduvFdN9aQIbg2xQ5F5KuU
        zLPye6oZBc/EOmHy6Po3R3LgbK2+3d+cJ
X-Received: by 2002:a05:622a:4:b0:344:94b7:a396 with SMTP id x4-20020a05622a000400b0034494b7a396mr1681725qtw.123.1661389361303;
        Wed, 24 Aug 2022 18:02:41 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6RD4qzoDAIbpqCBZsBitgPKBVGZTcA55Mw16sq45LpNLxaX1kiFTGmSjg0aVosnwpzS5WfOmusqlSIOQbXliE=
X-Received: by 2002:a05:622a:4:b0:344:94b7:a396 with SMTP id
 x4-20020a05622a000400b0034494b7a396mr1681706qtw.123.1661389361103; Wed, 24
 Aug 2022 18:02:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <20220701143052.1267509-2-miquel.raynal@bootlin.com> <CAK-6q+jkUUjAGqEDgU1oJvRkigUbvSO5SXWRau6+320b=GbfxQ@mail.gmail.com>
 <20220819191109.0e639918@xps-13> <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
 <20220823182950.1c722e13@xps-13> <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
 <20220824122058.1c46e09a@xps-13> <CAK-6q+gjgQ1BF-QrT01JWh+2b3oL3RU+SoxUf5t7h3Hc6R8pcg@mail.gmail.com>
 <20220824152648.4bfb9a89@xps-13> <CAK-6q+itA0C4zPAq5XGKXgCHW5znSFeB-YDMp3uB9W-kLV6WaA@mail.gmail.com>
In-Reply-To: <CAK-6q+itA0C4zPAq5XGKXgCHW5znSFeB-YDMp3uB9W-kLV6WaA@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 24 Aug 2022 21:02:29 -0400
Message-ID: <CAK-6q+gnkz-Yf=39Ss361dDsmzhJErJCAq9FaKK3m5nRih=VDA@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Aug 24, 2022 at 5:53 PM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Wed, Aug 24, 2022 at 9:27 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Wed, 24 Aug 2022 08:43:20 -0400:
> >
> > > Hi,
> > >
> > > On Wed, Aug 24, 2022 at 6:21 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > ...
> > > >
> > > > Actually right now the second level is not enforced, and all the
> > > > filtering levels are a bit fuzzy and spread everywhere in rx.c.
> > > >
> > > > I'm gonna see if I can at least clarify all of that and only make
> > > > coord-dependent the right section because right now a
> > > > ieee802154_coord_rx() path in ieee802154_rx_handle_packet() does not
> > > > really make sense given that the level 3 filtering rules are mostly
> > > > enforced in ieee802154_subif_frame().
> > >
> > > One thing I mentioned before is that we probably like to have a
> > > parameter for rx path to give mac802154 a hint on which filtering
> > > level it was received. We don't have that, I currently see that this
> > > is a parameter for hwsim receiving it on promiscuous level only and
> > > all others do third level filtering.
> > > We need that now, because the promiscuous mode was only used for
> > > sniffing which goes directly into the rx path for monitors. With scan
> > > we mix things up here and in my opinion require such a parameter and
> > > do filtering if necessary.
> >
> > I am currently trying to implement a slightly different approach. The
> > core does not know hwsim is always in promiscuous mode, but it does
> > know that it does not check FCS. So the core checks it. This is
> > level 1 achieved. Then in level 2 we want to know if the core asked
> > the transceiver to enter promiscuous mode, which, if it did, should
> > not imply more filtering. If the device is working in promiscuous
> > mode but this was not asked explicitly by the core, we don't really
> > care, software filtering will apply anyway.
> >
>
> I doubt that I will be happy with this solution, this all sounds like
> "for the specific current behaviour that we support 2 filtering levels
> it will work", just do a parameter on which 802.15.4 filtering level
> it was received and the rx path will check what kind of filter is

I think a per phy field is enough here because the receive path should
be synchronized with changing filtering level on hardware. No need for
per receive path parameter.

"If the device is working in promiscuous mode but this was not asked
explicitly by the core, we don't really care, software filtering will
apply anyway."
I don't understand this sentence, we should not filter on things which
the hardware is doing for us. I mean okay I'm fine to handle it now
just to check twice, but in the future there might be more "we don't
need to filter this because we know the hardware is doing it" patches.

- Alex

