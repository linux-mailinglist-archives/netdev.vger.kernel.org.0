Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BED75233BA
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 15:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243154AbiEKNKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 09:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243171AbiEKNJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 09:09:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6ADAC2317FD
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 06:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652274595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hi/JeAuE3z2ISAG/TYEpuRUDbYxZ1Oh6j1jmHrsdnag=;
        b=ChtUMcZltjT9DrkURQdS/vN8WLpi99V00PJWqYCsw8xzKZIhTvLWC23yUJLZQ//dMqGd4U
        GD3T34OMxXgbwfejf3HOslitHbwrxh5luw/DcuztfdaGm5A0YIVdc03O2ZpCKsZL80dvIL
        mr92VhK2YSW4rHClYImg73AthmbT6Jc=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-oLPhnZjEPy6f0IHlaqxukA-1; Wed, 11 May 2022 09:09:52 -0400
X-MC-Unique: oLPhnZjEPy6f0IHlaqxukA-1
Received: by mail-qv1-f69.google.com with SMTP id u19-20020ad449b3000000b004523cc11b95so1949556qvx.7
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 06:09:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hi/JeAuE3z2ISAG/TYEpuRUDbYxZ1Oh6j1jmHrsdnag=;
        b=xFtLtghFLxOp8zRVw4CGiO9cgzu5iJe00TPEeV520QfO5MT3nFrmun54kma5Igt51D
         Pngq47kgGD3LRgC8MBa1SxLNZ9ps7GThhJScFiYrfb5M5CBRMsBEO21+iGWADa18Q8hS
         nhh0/6FYJw09u9f/q6QFLDM11YvWPlYgPwIiGQx4+j6c6RXPi1elZ6SgtZqKJ/+Rbsyw
         yT578XJmkdLa44asqcuifgDrOaF+na1RDP0cueHeiqiBrofkttY5a00YV6GdP7JNevit
         VhlbaGnmOwtBoI7ZrQYzCLQUjgcyxg59tTXrp4HvXjfAUb6HMWQ5x2UdnXmC7jHva4lv
         mh+w==
X-Gm-Message-State: AOAM5336XdXcD9QtU9+12c7TK2gH5YpfjI27dKL/iu9NDyE/3EC/RKcc
        G+MDx98erdWZ2OPxlaKhRH/VNSaMX1sL2MYxiC2xNP2BUcxejNBPYStGtlLO0Ia49GEeBHZSbON
        rO94dwPu0HT6zqks9KWvvodrneJaU9SfB
X-Received: by 2002:a05:620a:40c2:b0:6a0:2b1b:2b86 with SMTP id g2-20020a05620a40c200b006a02b1b2b86mr19075430qko.80.1652274591626;
        Wed, 11 May 2022 06:09:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2waDQK91pYxQ5/eTCWX3IFWKTayNe7E6Z9jrM5S3s9zWpzq/aCBXwuIwoK3GX3CW6VbrEY1S8EQtlUFtHLek=
X-Received: by 2002:a05:620a:40c2:b0:6a0:2b1b:2b86 with SMTP id
 g2-20020a05620a40c200b006a02b1b2b86mr19075398qko.80.1652274591291; Wed, 11
 May 2022 06:09:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220427164659.106447-1-miquel.raynal@bootlin.com>
 <20220427164659.106447-7-miquel.raynal@bootlin.com> <CAK-6q+jCYDQ-rtyawz1m2Yt+ti=3d6PrhZebB=-PjcX-6L-Kdg@mail.gmail.com>
 <20220510165237.43382f42@xps13>
In-Reply-To: <20220510165237.43382f42@xps13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 11 May 2022 09:09:40 -0400
Message-ID: <CAK-6q+jeubhGah2gG1JJxfmOW=sNdMrLf+mk_a3X_r+Na=tHXg@mail.gmail.com>
Subject: Re: [PATCH wpan-next 06/11] net: mac802154: Hold the transmit queue
 when relevant
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, May 10, 2022 at 10:52 AM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> Hi Alex,
>
> > > --- a/net/mac802154/tx.c
> > > +++ b/net/mac802154/tx.c
> > > @@ -106,6 +106,21 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
> > >         return NETDEV_TX_OK;
> > >  }
> > >
> > > +void ieee802154_hold_queue(struct ieee802154_local *local)
> > > +{
> > > +       atomic_inc(&local->phy->hold_txs);
> > > +}
> > > +
> > > +void ieee802154_release_queue(struct ieee802154_local *local)
> > > +{
> > > +       atomic_dec(&local->phy->hold_txs);
> > > +}
> > > +
> > > +bool ieee802154_queue_is_held(struct ieee802154_local *local)
> > > +{
> > > +       return atomic_read(&local->phy->hold_txs);
> > > +}
> >
> > I am not getting this, should the release_queue() function not do
> > something like:
> >
> > if (atomic_dec_and_test(hold_txs))
> >       ieee802154_wake_queue(local);
> >
> > I think we don't need the test of "ieee802154_queue_is_held()" here,
> > then we need to replace all stop_queue/wake_queue with hold and
> > release?
>
> That's actually a good idea. I've implemented it and it looks nice too.
> I'll clean this up and share a new version with:
> - The wake call checked everytime hold_txs gets decremented
> - The removal of the _queue_is_held() helper
> - _wake/stop_queue() turned static
> - _hold/release_queue() used everywhere
>

I think there is also a lock necessary for atomic inc/dec hitting zero
and the stop/wake call afterwards... ,there are also a lot of
optimization techniques to only hold the lock for hitting zero cases
in such areas. However we will see...

- Alex

