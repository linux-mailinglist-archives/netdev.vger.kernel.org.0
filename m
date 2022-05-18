Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4CE52BC35
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237469AbiERNIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 09:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237448AbiERNIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 09:08:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7C9E179C37
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652879318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wEVU18jGfqPcmg2q4iHtheDOMAbASwTYENcJwOv1TWc=;
        b=DxwynqA4V7Bg092j1bqfXmxsOfwVx/HTF4+w41PoKrrV4pTHBl+fTbQiuCZu8tFsNW4doF
        +If5E7vz0lpWX84FSkfdd2hRMn3/WTbg19Pxy8R+yCkFvse2CzvOhqySN1DteODQ+c52ig
        3Q0HI8OLYUt+mX1oxTp4ik9fsZinHd8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-NKVJLMjENuWe5QS3N0-Qdg-1; Wed, 18 May 2022 09:08:36 -0400
X-MC-Unique: NKVJLMjENuWe5QS3N0-Qdg-1
Received: by mail-qk1-f198.google.com with SMTP id c84-20020a379a57000000b0069fcf83c373so1474610qke.20
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:08:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wEVU18jGfqPcmg2q4iHtheDOMAbASwTYENcJwOv1TWc=;
        b=PfmMHqf+XNnEYS/Gux0DhMpe5u28NdOeEMwm7qPJfYykBGiEATS+c3vZKfORHWk7TN
         Y1mIIybDyr/E8pFbt5mBgUUT6SIjH3ieZZlRTpGA1GvO7IMy5K06wZ8XpM5n1TrsfUtv
         hqMMGKKidUC/8WgOW11YIV2s/R0Ztvp7NnhUIDk1Sgw2W4fNQH2/IMvT2maPIFFRkHoG
         u5fBNbD/KEgeNaEjEMc24hg0yIv3teXPRfsBymnA/fczDS4I3cLjV5UrLFs4pvYmI216
         tz80uPF5+U5d1QrQ9l3lurBP7N/97kQvpUYW0DvCfCtrLxOxN9Y1XUaJgY1DSiyqwwUg
         eFEw==
X-Gm-Message-State: AOAM530gIsg0jGLQjMPUUhzOa+LP0115uDajqWnqwtUnP0b+UOvgaxH2
        6oN7GFtsT2D097I//QoMcjRREKCnxpuuoZ25jZlWmtoXpmCtFrp23u46H31uIe70XJUTfebUfHA
        bZ80EUTmw0F85geo/FxJD/qKFe2qbddHg
X-Received: by 2002:a05:6214:c29:b0:45a:fedd:7315 with SMTP id a9-20020a0562140c2900b0045afedd7315mr24139578qvd.59.1652879314835;
        Wed, 18 May 2022 06:08:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTj9VLJa4E8oodXN1Ll3A3AwZmkLpQENC3BMYxCu0fDFABePD1WxXu6gjHoJfmlEpF13d6AdaQMKuUrBi/PVk=
X-Received: by 2002:a05:6214:c29:b0:45a:fedd:7315 with SMTP id
 a9-20020a0562140c2900b0045afedd7315mr24139548qvd.59.1652879314558; Wed, 18
 May 2022 06:08:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220512143314.235604-1-miquel.raynal@bootlin.com>
 <20220512143314.235604-10-miquel.raynal@bootlin.com> <CAK-6q+ipHdD=NJB2N7SHQ0TUvNpc0GQXZ7dWM9nDxqyqNgxdSA@mail.gmail.com>
 <CAK-6q+i_T+FaK0tX6tF38VjyEfSzDi-QC85MTU2=4soepAag8g@mail.gmail.com>
 <20220517153045.73fda4ee@xps-13> <CAK-6q+h1fmJZobmUG5bUL3uXuQLv0kvHUv=7dW+fOCcgbrdPiA@mail.gmail.com>
 <20220518121200.2f08a6b1@xps-13> <CAB_54W6XN4kytUMgMveVF7n7TPh+w75-ew25rVt-eUQiCgNuGw@mail.gmail.com>
 <20220518143702.48cb9c66@xps-13>
In-Reply-To: <20220518143702.48cb9c66@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 18 May 2022 09:08:23 -0400
Message-ID: <CAK-6q+g07ficTc-h_ks8GPpv880goHuGNXTD2fqbfbR7LDPZWQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 09/11] net: mac802154: Introduce a
 synchronous API for MLME commands
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, May 18, 2022 at 8:37 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
>
> alex.aring@gmail.com wrote on Wed, 18 May 2022 08:05:46 -0400:
>
> > Hi,
> >
> > On Wed, May 18, 2022 at 6:12 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > >
> > > aahringo@redhat.com wrote on Tue, 17 May 2022 21:14:03 -0400:
> > >
> > > > Hi,
> > > >
> > > > On Tue, May 17, 2022 at 9:30 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > >
> > > > >
> > > > > aahringo@redhat.com wrote on Sun, 15 May 2022 19:03:53 -0400:
> > > > >
> > > > > > Hi,
> > > > > >
> > > > > > On Sun, May 15, 2022 at 6:28 PM Alexander Aring <aahringo@redhat.com> wrote:
> > > > > > >
> > > > > > > Hi,
> > > > > > >
> > > > > > > On Thu, May 12, 2022 at 10:34 AM Miquel Raynal
> > > > > > > <miquel.raynal@bootlin.com> wrote:
> > > > > > > >
> > > > > > > > This is the slow path, we need to wait for each command to be processed
> > > > > > > > before continuing so let's introduce an helper which does the
> > > > > > > > transmission and blocks until it gets notified of its asynchronous
> > > > > > > > completion. This helper is going to be used when introducing scan
> > > > > > > > support.
> > > > > > > >
> > > > > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > > > > > ---
> > > > > > > >  net/mac802154/ieee802154_i.h |  1 +
> > > > > > > >  net/mac802154/tx.c           | 25 +++++++++++++++++++++++++
> > > > > > > >  2 files changed, 26 insertions(+)
> > > > > > > >
> > > > > > > > diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> > > > > > > > index a057827fc48a..f8b374810a11 100644
> > > > > > > > --- a/net/mac802154/ieee802154_i.h
> > > > > > > > +++ b/net/mac802154/ieee802154_i.h
> > > > > > > > @@ -125,6 +125,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
> > > > > > > >  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
> > > > > > > >  void ieee802154_xmit_sync_worker(struct work_struct *work);
> > > > > > > >  int ieee802154_sync_and_hold_queue(struct ieee802154_local *local);
> > > > > > > > +int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb);
> > > > > > > >  netdev_tx_t
> > > > > > > >  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
> > > > > > > >  netdev_tx_t
> > > > > > > > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > > > > > > > index 38f74b8b6740..ec8d872143ee 100644
> > > > > > > > --- a/net/mac802154/tx.c
> > > > > > > > +++ b/net/mac802154/tx.c
> > > > > > > > @@ -128,6 +128,31 @@ int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
> > > > > > > >         return ieee802154_sync_queue(local);
> > > > > > > >  }
> > > > > > > >
> > > > > > > > +int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
> > > > > > > > +{
> > > > > > > > +       int ret;
> > > > > > > > +
> > > > > > > > +       /* Avoid possible calls to ->ndo_stop() when we asynchronously perform
> > > > > > > > +        * MLME transmissions.
> > > > > > > > +        */
> > > > > > > > +       rtnl_lock();
> > > > > > >
> > > > > > > I think we should make an ASSERT_RTNL() here, the lock needs to be
> > > > > > > earlier than that over the whole MLME op. MLME can trigger more than
> > > > > >
> > > > > > not over the whole MLME_op, that's terrible to hold the rtnl lock so
> > > > > > long... so I think this is fine that some netdev call will interfere
> > > > > > with this transmission.
> > > > > > So forget about the ASSERT_RTNL() here, it's fine (I hope).
> > > > > >
> > > > > > > one message, the whole sync_hold/release queue should be earlier than
> > > > > > > that... in my opinion is it not right to allow other messages so far
> > > > > > > an MLME op is going on? I am not sure what the standard says to this,
> > > > > > > but I think it should be stopped the whole time? All those sequence
> > > > > >
> > > > > > Whereas the stop of the netdev queue makes sense for the whole mlme-op
> > > > > > (in my opinion).
> > > > >
> > > > > I might still implement an MLME pre/post helper and do the queue
> > > > > hold/release calls there, while only taking the rtnl from the _tx.
> > > > >
> > > > > And I might create an mlme_tx_one() which does the pre/post calls as
> > > > > well.
> > > > >
> > > > > Would something like this fit?
> > > >
> > > > I think so, I've heard for some transceiver types a scan operation can
> > > > take hours... but I guess whoever triggers that scan in such an
> > > > environment knows that it has some "side-effects"...
> > >
> > > Yeah, a scan requires the data queue to be stopped and all incoming
> > > packets to be dropped (others than beacons, ofc), so users must be
> > > aware of this limitation.
> >
> > I think there is a real problem about how the user can synchronize the
> > start of a scan and be sure that at this point everything was
> > transmitted, we might need to real "flush" the queue. Your naming
> > "flush" is also wrong, It will flush the framebuffer(s) of the
> > transceivers but not the netdev queue... and we probably should flush
> > the netdev queue before starting mlme-op... this is something to add
> > in the mlme_op_pre() function.
>
> Is it even possible? This requires waiting for the netdev queue to be
> empty before stopping it, but if users constantly flood the transceiver
> with data packets this might "never" happen.
>

Nothing is impossible, just maybe nobody thought about that. Sure
putting more into the queue should be forbidden but what's inside
should be "flushed". Currently we make a hard cut, there is no way
that the user knows what's sent or not BUT that is the case for
xmit_do() anyway, it's not reliable... people need to have the right
upper layer protocol. However I think we could run into problems if we
especially have features like waiting for the socket error queue to
know if e.g. an ack was received or not.

> And event thought we might accept this situation, I don't know how to
> check the emptiness of the netif queue. Any inputs?

Don't think about it, I see a practical issue here which I keep in my mind.

- Alex

