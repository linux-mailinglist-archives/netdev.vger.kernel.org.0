Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF2F4E88F5
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 18:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiC0QrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 12:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235060AbiC0QrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 12:47:13 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4FD13CE0;
        Sun, 27 Mar 2022 09:45:34 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id h11so16266996ljb.2;
        Sun, 27 Mar 2022 09:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x3oyw4M168II7jmaGTCX0PxdJkqyiFIpXhvYvB2xOKE=;
        b=Jd4aA0sg1wGmCA/0eOKACAChDCKxkLPC8Kxq3TnoH9O1+l7CmkNOjOGpKT/KrkNtt8
         fxgBD+wiAeMqzLXe1fbvKvQtpQ3mJftn0KUqkBCSR3o4pI6YlHH5cDuY1aa3i/qANoeh
         89iGiHWEig6SweHVI0cTpCAPyO3BTrhPCwLMJsfJk9Etbb9U178vPIYAmRxmZgu0+IYh
         WinXe3ZRbF8q4ADDTZKZ9IjG2wHBr1SctZUrSrKge4Dyy0nzDFxdCW3EnZkPbnOmMXgI
         jBaauVsLkKlWrxNxcsTL0/n82C4Flt6coyfiQz40v5fRx8IsZGXlVbIiK9VdcR7+Qm6M
         UmcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x3oyw4M168II7jmaGTCX0PxdJkqyiFIpXhvYvB2xOKE=;
        b=EYhBt5BlzPPJs1FRRR6A/pPU1+LoZzkMY7xgqA/JNmRcRDHXlNw0ufSOxSowewZhfE
         bvw7n0MkA4gXScCW8syLXqtHqk+Qe+RQ5o1yxpKIN0jCdbtFc0yKrEcTc0KRKCkYPAB/
         W6aKd7SndxF6I9+4ic2ACHV3LIeklyLuwgsG2hONgTC1McXCQ+vnhD6NdQmST0hCivwi
         PGPCjoxyNZFwvohG6v0UbhQWsVXBQZekw8NhMIbVWlOFor9DiQoDg89iI7AC14E4ta84
         QCi6QqMy9rBQWv12Ho0d4qFtdmLASzZ+HiUKSmtVu94sl7JBmewFG75eE6Xfhl3y0YIa
         JuDw==
X-Gm-Message-State: AOAM532zfPkQJg1LF+t3QL/O2Bo6vnBsUc2qH8JjFQ3yRqATSJUaAj/5
        IyMbKo0brNPrKv+jAqO/JQBMwZBdFtAijLUHUV0=
X-Google-Smtp-Source: ABdhPJwDdBEwE5fKnDoiExqmjAqiwnt5SPUM2eTlHkYZKsAS0G8cA5hLrrt/S9ZtF52GBd33tJo5bv+UXGdnK3ooGvI=
X-Received: by 2002:a2e:5c84:0:b0:249:84ea:3cc4 with SMTP id
 q126-20020a2e5c84000000b0024984ea3cc4mr16958580ljb.397.1648399531971; Sun, 27
 Mar 2022 09:45:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220207144804.708118-1-miquel.raynal@bootlin.com>
 <20220207144804.708118-14-miquel.raynal@bootlin.com> <CAB_54W5ao0b6QE7E_uXFeorbn6UjB6NV4emtibqswL4iXYEfng@mail.gmail.com>
 <20220303191723.39b87766@xps13> <20220304115432.7913f2ef@xps13>
 <CAB_54W4A6-Jgpr2WX3y3OPo-3=BJJDz+M5XPfWwpgCx1sXWAGQ@mail.gmail.com> <20220318191101.4dbe5a02@xps13>
In-Reply-To: <20220318191101.4dbe5a02@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 27 Mar 2022 12:45:20 -0400
Message-ID: <CAB_54W4d+qUd2nA2Av3N0OfCf5stDjG3YQ97kebGiTrPAbLqZg@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 13/14] net: mac802154: Introduce a tx queue
 flushing mechanism
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Mar 18, 2022 at 2:11 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Sun, 13 Mar 2022 16:43:52 -0400:
>
> > Hi,
> >
> > On Fri, Mar 4, 2022 at 5:54 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > > I had a second look at it and it appears to me that the issue was
> > > already there and is structural. We just did not really cared about it
> > > because we didn't bother with synchronization issues.
> > >
> >
> > I am not sure if I understand correctly. We stop the queue at some
> > specific moment and we need to make sure that xmit_do() is not called
> > or can't be called anymore.
> >
> > I was thinking about:
> >
> > void ieee802154_disable_queue(struct ieee802154_hw *hw)
> > {
> >         struct ieee802154_local *local = hw_to_local(hw);
> >         struct ieee802154_sub_if_data *sdata;
> >
> >         rcu_read_lock();
> >         list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> >                 if (!sdata->dev)
> >                         continue;
> >
> >                netif_tx_disable(sdata->dev);
> >         }
> >         rcu_read_unlock();
> > }
> > EXPORT_SYMBOL(ieee802154_stop_queue);
> >
> > From my quick view is that "netif_tx_disable()" ensures by holding
> > locks and other things and doing netif_tx_stop_queue() it we can be
> > sure there will be no xmit_do() going on while it's called and
> > afterwards. It can be that there are still transmissions on the
> > transceiver that are on the way, but then your atomic counter and
> > wait_event() will come in place.
>
> I went for a deeper investigation to understand how the net core
> was calling our callbacks. And it appeared to go through
> dev_hard_start_xmit() and come from __dev_queue_xmit(). This means
> the ieee802154 callback could only be called once at a time
> because it is protected by the network device transmit lock
> (netif_tx_lock()). Which makes the logic safe and not racy as I
> initially thought. This was the missing peace in my mental model I
> believe.
>

You forget here that you want to stop all transmission and to wait
that all transmissions are done from a sleepable context.

> > We need to be sure there will be nothing queued anymore for
> > transmission what (in my opinion) tx_disable() does. from any context.
> >
> > We might need to review some netif callbacks... I have in my mind for
> > example stop(), maybe netif_tx_stop_queue() is enough (because the
> > context is like netif_tx_disable(), helding similar locks, etc.) but
> > we might want to be sure that nothing is going on anymore by using
> > your wait_event() with counter.
>
> I don't see a real reason anymore to use the tx_disable() call. Is
> there any reason this could be needed that I don't have in mind? Right
> now the only thing that I see is that it could delay a little bit the
> moment where we actually stop the queue because we would be waiting for
> the lock to be released after the skb has been offloaded to hardware.
> Perhaps maybe we would let another frame to be transmitted before we
> actually get the lock.
>
> > Is there any problem which I don't see?
>
> One question however, as I understand, if userspace tries to send more
> packets, I believe the "if (!stopped)" condition will be false and the
> xmit call will simply be skipped, ending with a -ENETDOWN error [1]. Is
> it what we want? I initially thought we could actually queue patches and
> wait for the queue to be re-enabled again, but it does not look easy.
>

The problem is here that netif_tx_stop_queue() will only set some
flags and this will be checked there. [0]
Now you want to do from a sleepable context:

1. stop queue (net core functionality check [0])
2. wait until all ongoing transmissions are done (softmac layer atomic
counter handled in xmit_do())

Example situation for the race:

cpu0:
 - checked _already_ the if queue is stopped [0] it was not the case
BUT not incremented the atomic counter yet to signal that a
transmission is going on  (which is done later in xmit_do)

While cpu0 is in the above mentioned state cpu1 is in the following state:

- mlme message will transmitted
- stop the queue by setting flag [0] (note the check in cpu0 already
happened and a transmission is on the way)
- make a wait_event($ONGOING_TRANSMISSION_COUNTER) which will not wait
- (it's zero because and does not wait because cpu0 didn't incremented
the ongoing transmission counter yet)

---

This will end in that both cpu0 and cpu1 start transmissions... but
this is only "we completed the spi transfer to the transceiver" the
framebuffer is written and transmission is started. That the
transceiver actually transmits the frame is completely handled on the
transceiver side, on the Linux side we only need to care about that we
don't overwrite the framebuffer while a transmission is going on. This
can happen here, e.g. cpu0 writes the framebuffer first, then cpu1
will overwrite the framebuffer because we start another transmission
(writing framebuffer) while the transceiver still reads the
framebuffer for the cpu0 transmission. In short it will break.

If we want to start transmissions from any sleepable context we cannot
use "netif_tx_stop_queue()" because it does not guarantee that
xmit_do() is still going on, "netif_tx_disable()" will do it because
it will held the xmit_lock while setting the flag and we don't run
into the above problem.

Is this more clear? I think it was never clear what I really meant by
this race, I hope the above example helped. Also "netif_tx_disable()"
was my first hit to find netif_tx_disable()what we need, but maybe
there exists better options?
To be sure, I mean we need "netif_tx_disable()" only for any sleepable
context e.g. we trigger mlme transmission and take control of all
transmissions and be sure nothing is going on anymore, then we need to
have still the wait_event(). After this is done we can be sure no
transmission is going on and we can take over until we are done (mlme
sync tx handling) and can call wake_queue() again.

- Alex

[0] https://elixir.bootlin.com/linux/v5.17/source/net/core/dev.c#L4114
