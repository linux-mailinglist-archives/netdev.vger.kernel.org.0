Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5419652C971
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 03:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbiESBvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 21:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbiESBvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 21:51:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71447689AD
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 18:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652925110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w3n7464PDnqcmAf3tMFw9NumVNCQiOBBYTd0UPzXjMc=;
        b=YmhBF1rQRv9qWCb6ER6AoCN/PzjTmqoLkl3tU+JQBTEcS7vIqNNm/mv52X9uwfL6QortB8
        MAZLtYx7IsKUBqW+MgWMpiHDLDhfa382MtAMKDxT1XOqff8u/0YXz5CIUNc+9sq8TB5npV
        BXzV5vNAUsm7oZ26XgrpA4+Yp5alfg4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-lvJj0q-nPFqrNHusk5r2cg-1; Wed, 18 May 2022 21:51:48 -0400
X-MC-Unique: lvJj0q-nPFqrNHusk5r2cg-1
Received: by mail-qv1-f70.google.com with SMTP id az11-20020ad4550b000000b00461ea78ec33so2746067qvb.16
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 18:51:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w3n7464PDnqcmAf3tMFw9NumVNCQiOBBYTd0UPzXjMc=;
        b=smtbna2okPbiuO0r/qoXS7EdJmpb3ERyaVellRc8hcxBpHEsyBaPQH9Eq8GOGzA67o
         FZR1EvxNS8bNN8ZlRbRsyfk9jWWlymbDMbg9L69A58UQPZrQc0E1QxVjnkrvpS86N82v
         hLw38rCff2ZGtGHM7wuYyiBwCrK67RAGhXBTwqHgHP6CNyWFJJP0OkiXpGSpVTrLLW1Q
         1RBGDsOXJbWNIi2ggayy11rmb3nikiHfR5I/CJH+tQY9am74ocCBpqUmuoFJpXCslEtf
         nRsS1V5YP005GA/qxwpK98yyeVlog2NfHU6yv7DDBY8+zmbgc/C0M+UoM7Xrjb9V8BzK
         cQSg==
X-Gm-Message-State: AOAM533kFEnoUBtMHpXPOhFQHT+VoRcP/wnIb/u6lDLKwAHBDd0Z1Hnt
        Ew4yC9+vtpLOOdNNRmsEiw7uztMeghIx970eBAswaXJ0mmsyHR6EJl1oZsW26AaCjOt+vw2kvM5
        n0r5wf9FAcK7c0k0mMpj2ucVjgQH4eDjK
X-Received: by 2002:ad4:5dcf:0:b0:461:fef4:c2de with SMTP id m15-20020ad45dcf000000b00461fef4c2demr22553qvh.28.1652925108196;
        Wed, 18 May 2022 18:51:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzB13UGIyshjzGgSgLrDBB9JMg9j9SBLnrOLvRrHQDPRhSjgY9HAzDYdExdCDLz3Zs3PqSLX8JpdHeYhOi7Ri8=
X-Received: by 2002:ad4:5dcf:0:b0:461:fef4:c2de with SMTP id
 m15-20020ad45dcf000000b00461fef4c2demr22543qvh.28.1652925107943; Wed, 18 May
 2022 18:51:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220512143314.235604-1-miquel.raynal@bootlin.com>
 <20220512143314.235604-10-miquel.raynal@bootlin.com> <CAK-6q+ipHdD=NJB2N7SHQ0TUvNpc0GQXZ7dWM9nDxqyqNgxdSA@mail.gmail.com>
 <CAK-6q+i_T+FaK0tX6tF38VjyEfSzDi-QC85MTU2=4soepAag8g@mail.gmail.com>
 <20220517153045.73fda4ee@xps-13> <CAK-6q+h1fmJZobmUG5bUL3uXuQLv0kvHUv=7dW+fOCcgbrdPiA@mail.gmail.com>
 <20220518121200.2f08a6b1@xps-13> <CAB_54W6XN4kytUMgMveVF7n7TPh+w75-ew25rVt-eUQiCgNuGw@mail.gmail.com>
 <20220518143702.48cb9c66@xps-13> <CAK-6q+g07ficTc-h_ks8GPpv880goHuGNXTD2fqbfbR7LDPZWQ@mail.gmail.com>
 <20220518181214.34a34ed6@xps-13>
In-Reply-To: <20220518181214.34a34ed6@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 18 May 2022 21:51:36 -0400
Message-ID: <CAK-6q+ixJsO7GYh97eCNH94JmkadTFzgjL5jOgdW2N7iTiWF6g@mail.gmail.com>
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

On Wed, May 18, 2022 at 12:12 PM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> > > > > > > > > > +int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
> > > > > > > > > > +{
> > > > > > > > > > +       int ret;
> > > > > > > > > > +
> > > > > > > > > > +       /* Avoid possible calls to ->ndo_stop() when we asynchronously perform
> > > > > > > > > > +        * MLME transmissions.
> > > > > > > > > > +        */
> > > > > > > > > > +       rtnl_lock();
> > > > > > > > >
> > > > > > > > > I think we should make an ASSERT_RTNL() here, the lock needs to be
> > > > > > > > > earlier than that over the whole MLME op. MLME can trigger more than
> > > > > > > >
> > > > > > > > not over the whole MLME_op, that's terrible to hold the rtnl lock so
> > > > > > > > long... so I think this is fine that some netdev call will interfere
> > > > > > > > with this transmission.
> > > > > > > > So forget about the ASSERT_RTNL() here, it's fine (I hope).
> > > > > > > >
> > > > > > > > > one message, the whole sync_hold/release queue should be earlier than
> > > > > > > > > that... in my opinion is it not right to allow other messages so far
> > > > > > > > > an MLME op is going on? I am not sure what the standard says to this,
> > > > > > > > > but I think it should be stopped the whole time? All those sequence
> > > > > > > >
> > > > > > > > Whereas the stop of the netdev queue makes sense for the whole mlme-op
> > > > > > > > (in my opinion).
> > > > > > >
> > > > > > > I might still implement an MLME pre/post helper and do the queue
> > > > > > > hold/release calls there, while only taking the rtnl from the _tx.
> > > > > > >
> > > > > > > And I might create an mlme_tx_one() which does the pre/post calls as
> > > > > > > well.
> > > > > > >
> > > > > > > Would something like this fit?
> > > > > >
> > > > > > I think so, I've heard for some transceiver types a scan operation can
> > > > > > take hours... but I guess whoever triggers that scan in such an
> > > > > > environment knows that it has some "side-effects"...
> > > > >
> > > > > Yeah, a scan requires the data queue to be stopped and all incoming
> > > > > packets to be dropped (others than beacons, ofc), so users must be
> > > > > aware of this limitation.
> > > >
> > > > I think there is a real problem about how the user can synchronize the
> > > > start of a scan and be sure that at this point everything was
> > > > transmitted, we might need to real "flush" the queue. Your naming
> > > > "flush" is also wrong, It will flush the framebuffer(s) of the
> > > > transceivers but not the netdev queue... and we probably should flush
> > > > the netdev queue before starting mlme-op... this is something to add
> > > > in the mlme_op_pre() function.
> > >
> > > Is it even possible? This requires waiting for the netdev queue to be
> > > empty before stopping it, but if users constantly flood the transceiver
> > > with data packets this might "never" happen.
> > >
> >
> > Nothing is impossible, just maybe nobody thought about that. Sure
> > putting more into the queue should be forbidden but what's inside
> > should be "flushed". Currently we make a hard cut, there is no way
> > that the user knows what's sent or not BUT that is the case for
> > xmit_do() anyway, it's not reliable... people need to have the right
> > upper layer protocol. However I think we could run into problems if we
> > especially have features like waiting for the socket error queue to
> > know if e.g. an ack was received or not.
>
> Looking at net/core/dev.c I don't see the issue anymore, let me try to
> explain: as far as I understand the net device queue is a very
> conceptual "queue" which only has a reality if the underlying layer
> really implements the concept of a queue. To be more precise, at the
> netdev level itself, there is a HARD_TX_LOCK() call which serializes
> the ->ndo_start_xmit() calls, but whatever entered the
> ->ndo_start_xmit() hook _will_ be handled by the lower layer and is not
> in any "waiting" state at the net core level.
>
> In practice, the IEEE 802.15.4 core treats all packets immediately and
> do not really bother "queuing" them like if there was a "waiting"
> state. So all messages that the userspace expected to be send (which
> did not return NETDEV_TX_BUSY) at the moment where we decide to stop
> data transmissions will be processed.
>
> If several frames had to be transmitted to the IEEE 802.15.4 core and
> they all passed the netdev "queuing" mechanism, then they will be
> forwarded to the tranceivers thanks to the wait_event(!ongoing_txs) and
> only after we declare the queue sync'ed.
>
> For me there is no hard cut.

In my opinion there is definitely in case of a wpan interface a queue
handling right above xmit_do() which is in a "works for now" state.
Your queue flush function will not flush any queue, as I said it's
flushing the transceivers framebuffer at the starting point of
xmit_do() call and you should change your comments/function names to
describe this behaviour.

- Alex

