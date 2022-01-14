Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE1948E15A
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 01:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbiANACL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 19:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiANACJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 19:02:09 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE78C061574;
        Thu, 13 Jan 2022 16:02:09 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id x4so12934573wru.7;
        Thu, 13 Jan 2022 16:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZqV85jqpMu5U1nKTqX4UJcEgtxfIvDGTlM48tzo5X7Y=;
        b=EIIrabWBegwkS/JPAOLAHOYHs9RSrWWUA6evRPXmTL326ue9pEZaEodWsuaDfqjY9i
         ONPVRBgt6yPzID5Ngq5N5D9FUdEVGl5OvtMEZqN7jcL+ufX8GT2lE54vsfJPBVqtNrJJ
         1aXHyR0rryeGyF5udMGt5lL/7sGFnhKPAVRxtyCVR8CYrKgUh8/lVqidJG1c8YzghF3M
         GqYrUkQ+OKnldw1ta6T8O6TArr2xS5Cr6CiZ6fhi7/MITmvgfOVqq0QypcFhnkyGYpym
         ZWJrFmjBymh5bLvvipCbtbzQVU7ArYCFejZ8CBl903DGA0vcoroJR0mPeJdx2q1aVJ/Q
         IsLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZqV85jqpMu5U1nKTqX4UJcEgtxfIvDGTlM48tzo5X7Y=;
        b=nNnhQwjYn3DWCHigRiYE81TdoVMKwcYdEUJjT00aeuhgWplnEicG2A5y5v6oxTPrWj
         lQQTHoCsBQMV6MebNYfFzruVWMcF5vvVSFguARpvgX2f0s+EoslQPAFqBfsXjD4+krQt
         kV5dyUGNG3Sw6tA+AaCxPMeJZ6REGi4IIHjMpIMe/w4mytOev5Om8yxYtCW7tvwtaXKw
         VnM4wLx3j+fhf9bqFvwJLalp+0RexFQwhC8yfLm27ULHj8p/rQ1Kx0W5ynkkL6s+C7Se
         vs275zOrt/3ZfwUctYFFmrHpFdYgcIt4rF7NrurQkngamZyPjgnlNwpSJsuDuHj4jzon
         vNfw==
X-Gm-Message-State: AOAM530jZgWifgjhYkbK2z+kB2nW8oTwnvmk3OBEsn5sCRlbdTCVCzRI
        0WHx+zlnuEj0pEKUn3pygo9OroTYXk57ZHQE35I=
X-Google-Smtp-Source: ABdhPJzHrlUjzVq/4GeK1zeUzZMAakBxu2nvWzh3DaCwdyQ9py+KmfaYWM53+TaW8wfzHoMLCE22QtPY51FuTN+pdRE=
X-Received: by 2002:adf:ec92:: with SMTP id z18mr217913wrn.207.1642118527999;
 Thu, 13 Jan 2022 16:02:07 -0800 (PST)
MIME-Version: 1.0
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
 <20220112173312.764660-19-miquel.raynal@bootlin.com> <CAB_54W4PL1ty5XsqRoEKwsy-h8KL9gSGMK6N=HiWJDp6NHsb0A@mail.gmail.com>
 <20220113180709.0dade123@xps13>
In-Reply-To: <20220113180709.0dade123@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Thu, 13 Jan 2022 19:01:56 -0500
Message-ID: <CAB_54W4LdzH9=XS7-ZnxfyCMQFCTS-F5JkUmV+6HtWcCpUS-nQ@mail.gmail.com>
Subject: Re: [wpan-next v2 18/27] net: mac802154: Handle scan requests
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 13 Jan 2022 at 12:07, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Wed, 12 Jan 2022 17:44:02 -0500:
>
> > Hi,
> >
> > On Wed, 12 Jan 2022 at 12:33, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > ...
> > > +       return 0;
> > > +}
> > > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > > index c829e4a75325..40656728c624 100644
> > > --- a/net/mac802154/tx.c
> > > +++ b/net/mac802154/tx.c
> > > @@ -54,6 +54,9 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
> > >         struct net_device *dev = skb->dev;
> > >         int ret;
> > >
> > > +       if (unlikely(mac802154_scan_is_ongoing(local)))
> > > +               return NETDEV_TX_BUSY;
> > > +
> >
> > Please look into the functions "ieee802154_wake_queue()" and
> > "ieee802154_stop_queue()" which prevent this function from being
> > called. Call stop before starting scanning and wake after scanning is
> > done or stopped.
>
> Mmmh all this is already done, isn't it?
> - mac802154_trigger_scan_locked() stops the queue before setting the
>   promiscuous mode
> - mac802154_end_of_scan() wakes the queue after resetting the
>   promiscuous mode to its original state
>
> Should I drop the check which stands for an extra precaution?
>

no, I think then it should be a WARN_ON() more without any return
(hopefully it will survive). This case should never happen otherwise
we have a bug that we wake the queue when we "took control about
transmissions" only.
Change the name, I think it will be in future not only scan related.
Maybe "mac802154_queue_stopped()". Everything which is queued from
socket/upperlayer(6lowpan) goes this way.

>
> But overall I think I don't understand well this part. What is
> a bit foggy to me is why the (async) tx implementation does:
>
> *Core*                           *Driver*
>
> stop_queue()
> drv_async_xmit() -------
>                         \------> do something
>                          ------- calls ieee802154_xmit_complete()
> wakeup_queue() <--------/
>
> So we actually disable the queue for transmitting. Why??
>

Because all transceivers have either _one_ transmit framebuffer or one
framebuffer for transmit and receive one time. We need to report to
stop giving us more skb's while we are busy with one to transmit.
This all will/must be changed in future if there is hardware outside
which is more powerful and the driver needs to control the flow here.

That ieee802154_xmit_complete() calls wakeup_queue need to be
forbidden when we are in "synchronous transmit mode"/the queue is
stopped. The synchronous transmit mode is not for any hotpath, it's
for MLME and I think we also need a per phy lock to avoid multiple
synchronous transmissions at one time. Please note that I don't think
here only about scan operation, also for other possible MLME-ops.

> > Also there exists a race which exists in your way and also the one
> > mentioned above. There can still be some transmissions going on... We
> > need to wait until "all possible" tx completions are done... to be
> > sure there are really no transmissions going on. However we need to be
> > sure that a wake cannot be done if a tx completion is done, we need to
> > avoid it when the scan operation is ongoing as a workaround for this
> > race.
> >
> > This race exists and should be fixed in future work?
>
> Yep, this is true, do you have any pointers? Because I looked at the
> code and for now it appears quite unpractical to add some kind of
> flushing mechanism on that net queue. I believe we cannot use the netif
> interface for that so we would have to implement our own mechanism in
> the ieee802154 core.

yes, we need some kind of "wait_for_completion()" and "complete()". We
are currently lucky that we allow only one skb to be transmitted at
one time. I think it is okay to put that on a per phy basis...

- Alex
