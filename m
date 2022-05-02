Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D588516907
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 02:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356170AbiEBAZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 20:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233796AbiEBAZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 20:25:00 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37CA1903A;
        Sun,  1 May 2022 17:21:31 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id b18so3962095lfv.9;
        Sun, 01 May 2022 17:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NrbRTlOjLJ7GKE+mKA7USRHI7yNIBxpaIMJafNoKoEc=;
        b=LPPaKRHXJQuiNFVBvyDkapH+2DvmN65TAUABFK+zdgWVt9uJyTu/kBOMPuR522bxu0
         9/5Zzk6XOvdKWeCA1EQoo+lnlTM1RLPFv9Lhd3yYUj4lly2jZeHnlNU3Pxplq5K541Rx
         AJOfiOWhsHnSr3S51mwAMMDca6s65mC0eUMr45IzD7k0mVjqd8PPCHiyFiMWSlzjla+p
         DXKxKgmAe6Sd/1bBY8okB0h5GM+Td6edkAlV8FH11plxqZRAkry3dzN05/THWiDptABM
         NaxEqoLspwK9VqnrlVF1JY0vORP++UUIWzihvD2QWo/4D4RGemfhx1SYRTh/Lq7WgstA
         ikmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NrbRTlOjLJ7GKE+mKA7USRHI7yNIBxpaIMJafNoKoEc=;
        b=eEGioVk11jUGwPdLDWFLfuV1/4UeDwjSMntBPnilA22SJ/zfoiXaR6xJhCVSpa3m7N
         l1W+C7CrRQZFADEPf82KJJlaaHod1Q5rbLtFqQkSUevwZQfeNPKNbyesN0w6rXqspvGQ
         pu9w3/wqHyw3mXTBa6Jzs0OgXk+COypRk/Tzw4h9tIaKOVF/Fb3to5iqNazBDc4RTO1W
         BRPxJQtpVZUeaTdR51rDunBeMJMMv73RH7Qr7U2b6iUx/LOF3KgeBu732Qr4F7bcFq3T
         6j0kmftq281VoBFGpTVHGXi5ryAqdt5KEL5v/fAfsg+NNRR9ky8cfCAbGigpqoW48itq
         xN+g==
X-Gm-Message-State: AOAM532BQb2hFBVcYw4UJslI9BwVMUycS/XvzKe7iNO6RfvICrgCk1Us
        wKU12Dj2MuM/rfIFK3M7l+BSe3W+M6sGYOR8+bA=
X-Google-Smtp-Source: ABdhPJzIFYvSoctCNdM7BZX2G69G9d8fO3EbygFv47/qloPeaEWMWd+AlyDnCjPqH1bsSDzLv0uIKy+ewlB5WYXxAT8=
X-Received: by 2002:a05:6512:1599:b0:473:6c22:fa68 with SMTP id
 bp25-20020a056512159900b004736c22fa68mr2533892lfb.656.1651450890017; Sun, 01
 May 2022 17:21:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220427164659.106447-1-miquel.raynal@bootlin.com>
 <20220427164659.106447-9-miquel.raynal@bootlin.com> <CAB_54W7NWEYgmLfowvyXtKEsKhBaVrPzpkB1kasYpAst98mKNA@mail.gmail.com>
 <20220428095848.34582df4@xps13>
In-Reply-To: <20220428095848.34582df4@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 1 May 2022 20:21:18 -0400
Message-ID: <CAB_54W6nrNaXouN2LkEtzSpYNSmXT+WUbr4Y9rETyATznAbkEg@mail.gmail.com>
Subject: Re: [PATCH wpan-next 08/11] net: mac802154: Add a warning in the hot path
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

On Thu, Apr 28, 2022 at 3:58 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Wed, 27 Apr 2022 14:01:25 -0400:
>
> > Hi,
> >
> > On Wed, Apr 27, 2022 at 12:47 PM Miquel Raynal
> > <miquel.raynal@bootlin.com> wrote:
> > >
> > > We should never start a transmission after the queue has been stopped.
> > >
> > > But because it might work we don't kill the function here but rather
> > > warn loudly the user that something is wrong.
> > >
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
>
> [...]
>
> > > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > > index a8a83f0167bf..021dddfea542 100644
> > > --- a/net/mac802154/tx.c
> > > +++ b/net/mac802154/tx.c
> > > @@ -124,6 +124,8 @@ bool ieee802154_queue_is_held(struct ieee802154_local *local)
> > >  static netdev_tx_t
> > >  ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
> > >  {
> > > +       WARN_ON_ONCE(ieee802154_queue_is_stopped(local));
> > > +
> > >         return ieee802154_tx(local, skb);
> > >  }
> > >
> > > diff --git a/net/mac802154/util.c b/net/mac802154/util.c
> > > index 847e0864b575..cfd17a7db532 100644
> > > --- a/net/mac802154/util.c
> > > +++ b/net/mac802154/util.c
> > > @@ -44,6 +44,24 @@ void ieee802154_stop_queue(struct ieee802154_local *local)
> > >         rcu_read_unlock();
> > >  }
> > >
> > > +bool ieee802154_queue_is_stopped(struct ieee802154_local *local)
> > > +{
> > > +       struct ieee802154_sub_if_data *sdata;
> > > +       bool stopped = true;
> > > +
> > > +       rcu_read_lock();
> > > +       list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > > +               if (!sdata->dev)
> > > +                       continue;
> > > +
> > > +               if (!netif_queue_stopped(sdata->dev))
> > > +                       stopped = false;
> > > +       }
> > > +       rcu_read_unlock();
> > > +
> > > +       return stopped;
> > > +}
> >
> > sorry this makes no sense, you using net core functionality to check
> > if a queue is stopped in a net core netif callback. Whereas the sense
> > here for checking if the queue is really stopped is when 802.15.4
> > thinks the queue is stopped vs net core netif callback running. It
> > means for MLME-ops there are points we want to make sure that net core
> > is not handling any xmit and we should check this point and not
> > introducing net core functionality checks.
>
> I think I've mixed two things, your remark makes complete sense. I
> should instead here just check a 802.15.4 internal variable.
>

I am thinking about this patch series... and I think it still has bugs
or at least it's easy to have bugs when the context is not right
prepared to call a synchronized transmission. We leave here the netdev
state machine world for transmit vs e.g. start/stop netif callback...
We have a warning here if there is a core netif xmit callback running
when 802.15.4 thinks it shouldn't (because we take control of it) but
I also think about a kind of the other way around. A warning if
802.15.4 transmits something but the netdev core logic "thinks" it
shouldn't.

That requires some checks (probably from netcore functionality) to
check if we call a 802.15.4 sync xmit but netif core already called
stop() callback. The last stop() callback - means the driver_ops
stop() callback was called, we have some "open_count" counter there
which MUST be incremented before doing any looping of one or several
sync transmissions. All I can say is if we call xmit() but the driver
is in stop() state... it will break things.

My concern is also here that e.g. calling netif down or device
suspend() are only two examples I have in my mind right now. I don't
know all cases which can occur, that's why we should introduce another
WARN_ON_ONCE() for the case that 802.15.4 transmits something but we
are in a state where we can't transmit something according to netif
state (driver ops called stop()).

Can you add such a check as well? And please keep in mind to increment
the open count when implementing MLME-ops (or at least handle it
somehow), otherwise I guess it's easy to hit the warning. If another
user reports warnings and tells us what they did we might know more
other "cases" to fix.

There should maybe be an option in hwsim to delay a transmission
completion and such cases can be tested...

- Alex
