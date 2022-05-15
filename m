Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08DFF527AD5
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 01:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbiEOXEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 19:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiEOXEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 19:04:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 406233617B
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 16:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652655846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HED6sqrRMHt5M94sg8hRTn2o/jwlXD/g70Ops+h6TfM=;
        b=NRtKCOlLOkrNVf1RmfSR6MDSvOY0PE4AY4T/vFbMG0bt8g8CJaLIiaXa86XNROKBGxQBa/
        0kH72Z/tiASOUFWfSXVk/91oQGTjguox2Sf91NJNb9Isv05CHgGpBIZ272beWzj/nXcFo0
        c5di/KYMFzXnaVVrl5yemu1X7PYY6BA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-cG2j2b_APSu6uSSRGI2kIg-1; Sun, 15 May 2022 19:04:05 -0400
X-MC-Unique: cG2j2b_APSu6uSSRGI2kIg-1
Received: by mail-qk1-f200.google.com with SMTP id j12-20020ae9c20c000000b0069e8ac6b244so10135446qkg.1
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 16:04:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HED6sqrRMHt5M94sg8hRTn2o/jwlXD/g70Ops+h6TfM=;
        b=0ZahP9EhN2s1SEfu14w7w2TWD3pynzVYg6pBLuxieROCcsyo9ENyKHb/J5MGm3VrH1
         D8j1B860o5In3zc3Fzk3sLsQc6ybfv1L3kUjWX73dWsjuBugBN6p6RyPkQlG1jI8yCI3
         lve44dhaGBH/rLMEKeTAyyVkTOG2vDF+YJ56iBiesT5JMnkjcCQq6uS2z4pohvx2Li3X
         spaulOly+sKDau9etkdqFgXnBuxC4jOvQHdeL7br2dp3EZO5TXam+areji1P2uAuupsS
         dONKBoq+yaMBzj0fHy34b4oAzuG1hUeen0julwiyVuo5hDkO1uDRZxrENecsHTjqeTqW
         p2DQ==
X-Gm-Message-State: AOAM530PsTXg2+S/wzSZ3X72x28z8NdSsi6ugXK+5P8knSgEgjyn3HR2
        UoL9vP6ojq6olUhYnJ5zeNaFcqgo91x5GK1zYERxn/Zn+lpOhWrCQ4JCt8WD0/Mx7FnWDFEm9oq
        7u9MctRRRuPyG32rr0KFZjRmksFzPAB31
X-Received: by 2002:a05:620a:919:b0:69f:e373:3de8 with SMTP id v25-20020a05620a091900b0069fe3733de8mr10431659qkv.27.1652655844638;
        Sun, 15 May 2022 16:04:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVzzoy/qyjeaBmM2f/mbn7p3QjZ3CLZ+xk+5lleqUjWBiKRiluPA00va3+zN49cME8YcJnOEtooTr3RySqlk4=
X-Received: by 2002:a05:620a:919:b0:69f:e373:3de8 with SMTP id
 v25-20020a05620a091900b0069fe3733de8mr10431642qkv.27.1652655844437; Sun, 15
 May 2022 16:04:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220512143314.235604-1-miquel.raynal@bootlin.com>
 <20220512143314.235604-10-miquel.raynal@bootlin.com> <CAK-6q+ipHdD=NJB2N7SHQ0TUvNpc0GQXZ7dWM9nDxqyqNgxdSA@mail.gmail.com>
In-Reply-To: <CAK-6q+ipHdD=NJB2N7SHQ0TUvNpc0GQXZ7dWM9nDxqyqNgxdSA@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 15 May 2022 19:03:53 -0400
Message-ID: <CAK-6q+i_T+FaK0tX6tF38VjyEfSzDi-QC85MTU2=4soepAag8g@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, May 15, 2022 at 6:28 PM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Thu, May 12, 2022 at 10:34 AM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
> >
> > This is the slow path, we need to wait for each command to be processed
> > before continuing so let's introduce an helper which does the
> > transmission and blocks until it gets notified of its asynchronous
> > completion. This helper is going to be used when introducing scan
> > support.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  net/mac802154/ieee802154_i.h |  1 +
> >  net/mac802154/tx.c           | 25 +++++++++++++++++++++++++
> >  2 files changed, 26 insertions(+)
> >
> > diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> > index a057827fc48a..f8b374810a11 100644
> > --- a/net/mac802154/ieee802154_i.h
> > +++ b/net/mac802154/ieee802154_i.h
> > @@ -125,6 +125,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
> >  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
> >  void ieee802154_xmit_sync_worker(struct work_struct *work);
> >  int ieee802154_sync_and_hold_queue(struct ieee802154_local *local);
> > +int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb);
> >  netdev_tx_t
> >  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
> >  netdev_tx_t
> > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > index 38f74b8b6740..ec8d872143ee 100644
> > --- a/net/mac802154/tx.c
> > +++ b/net/mac802154/tx.c
> > @@ -128,6 +128,31 @@ int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
> >         return ieee802154_sync_queue(local);
> >  }
> >
> > +int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
> > +{
> > +       int ret;
> > +
> > +       /* Avoid possible calls to ->ndo_stop() when we asynchronously perform
> > +        * MLME transmissions.
> > +        */
> > +       rtnl_lock();
>
> I think we should make an ASSERT_RTNL() here, the lock needs to be
> earlier than that over the whole MLME op. MLME can trigger more than

not over the whole MLME_op, that's terrible to hold the rtnl lock so
long... so I think this is fine that some netdev call will interfere
with this transmission.
So forget about the ASSERT_RTNL() here, it's fine (I hope).

> one message, the whole sync_hold/release queue should be earlier than
> that... in my opinion is it not right to allow other messages so far
> an MLME op is going on? I am not sure what the standard says to this,
> but I think it should be stopped the whole time? All those sequence

Whereas the stop of the netdev queue makes sense for the whole mlme-op
(in my opinion).

- Alex

