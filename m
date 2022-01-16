Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D3348FF80
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 23:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbiAPWoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 17:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbiAPWob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 17:44:31 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E42C061574;
        Sun, 16 Jan 2022 14:44:31 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id o7-20020a05600c510700b00347e10f66d1so6857382wms.0;
        Sun, 16 Jan 2022 14:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+aBcDjXVQfx4otmP79Z3vhfOCjFafF+R9LLR8zqDWFE=;
        b=pUouIfM+IckvWwAsqAKYbGAxa+Kv/tAxz1UlHxMU1yrxbnJXwnaMf9aqhSijzz3or6
         SKa8qR3dfFV/eCL+cXGwevs++gZle0ZA1vr0dGUPtVwae0lGilxXwAhG2+1rRL381xWI
         kPR5m7J9ra7KKDJZbftFD3pwRJ6If5q2XmHl+2uZXaAvtjQYePXoG48Y04yDh97G+Phw
         tLyUZj2aQ0tpJZKI97oLTviIo4Mdg0SehATnCHhbj2/p0fD3BaBAvAH23qlhyZIjeHZ/
         qnZ1zotPL9OTzZxXZsH57PdS8KvTAXOolVsg/IgFzjdpxDgNJdDLPaowehAb3Ts9fdcu
         mcnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+aBcDjXVQfx4otmP79Z3vhfOCjFafF+R9LLR8zqDWFE=;
        b=e+6pqKukbE9PYljxVR6mdJAWHccVKImNvXRGxqhQ9gSmSEtx7d1vaDQFDA1/rBkwAk
         P6J/B7hah4unAC95r4lfQAcr8WxV2sRsH2GQsOV9Snu9ONRaCPoAf1P2bfx+QI5YMtl5
         SikVr/k4bU6F3O2cHpnRCDuV4a7q/tDCgL5Wq0rLsra5fJQSqcp2VNY80Wigtb4yanWj
         1mGfJof49mRo92t2vUnJbZwjeobI26wV6mXMyCdxsuLI8BG6zNfy5W4klMGRzwYHAdO+
         jjXFHgC9hk1CXhHRXp1pB0HSDo5VIbt4Kc1eJApFBOaSbnExTfxJdsUnubK2PZZUBq5J
         5eZA==
X-Gm-Message-State: AOAM531PvskkXHQ0xp/ppMbdZhTUQ/Yb9TLLdcHtQHnZZ+gOi8E16t4D
        YjnGftlix6GtyOZV8Fp/otT/Ohi3Er6hEWQGgZ8=
X-Google-Smtp-Source: ABdhPJxZS6EfUHEnsOV/ffsrnIpiY1m8+hij7LGfsQsOJwvKKKXdXXKsnxqkRdI5mbpyfkSD9oJhHDqPSoy7wtT64T8=
X-Received: by 2002:a1c:ed01:: with SMTP id l1mr25155386wmh.185.1642373069843;
 Sun, 16 Jan 2022 14:44:29 -0800 (PST)
MIME-Version: 1.0
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
 <20220112173312.764660-19-miquel.raynal@bootlin.com> <CAB_54W4PL1ty5XsqRoEKwsy-h8KL9gSGMK6N=HiWJDp6NHsb0A@mail.gmail.com>
 <20220113180709.0dade123@xps13> <CAB_54W4LdzH9=XS7-ZnxfyCMQFCTS-F5JkUmV+6HtWcCpUS-nQ@mail.gmail.com>
 <20220114194425.3df06391@xps13>
In-Reply-To: <20220114194425.3df06391@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 16 Jan 2022 17:44:18 -0500
Message-ID: <CAB_54W5xJV-3fxOUyvdxBBfUZWYx7JU=BDVhTHFcjJ7SOEdeUw@mail.gmail.com>
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

On Fri, 14 Jan 2022 at 13:44, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Thu, 13 Jan 2022 19:01:56 -0500:
>
> > Hi,
> >
> > On Thu, 13 Jan 2022 at 12:07, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > alex.aring@gmail.com wrote on Wed, 12 Jan 2022 17:44:02 -0500:
> > >
> > > > Hi,
> > > >
> > > > On Wed, 12 Jan 2022 at 12:33, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > ...
> > > > > +       return 0;
> > > > > +}
> > > > > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > > > > index c829e4a75325..40656728c624 100644
> > > > > --- a/net/mac802154/tx.c
> > > > > +++ b/net/mac802154/tx.c
> > > > > @@ -54,6 +54,9 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
> > > > >         struct net_device *dev = skb->dev;
> > > > >         int ret;
> > > > >
> > > > > +       if (unlikely(mac802154_scan_is_ongoing(local)))
> > > > > +               return NETDEV_TX_BUSY;
> > > > > +
> > > >
> > > > Please look into the functions "ieee802154_wake_queue()" and
> > > > "ieee802154_stop_queue()" which prevent this function from being
> > > > called. Call stop before starting scanning and wake after scanning is
> > > > done or stopped.
> > >
> > > Mmmh all this is already done, isn't it?
> > > - mac802154_trigger_scan_locked() stops the queue before setting the
> > >   promiscuous mode
> > > - mac802154_end_of_scan() wakes the queue after resetting the
> > >   promiscuous mode to its original state
> > >
> > > Should I drop the check which stands for an extra precaution?
> > >
> >
> > no, I think then it should be a WARN_ON() more without any return
> > (hopefully it will survive). This case should never happen otherwise
> > we have a bug that we wake the queue when we "took control about
> > transmissions" only.
> > Change the name, I think it will be in future not only scan related.
> > Maybe "mac802154_queue_stopped()". Everything which is queued from
> > socket/upperlayer(6lowpan) goes this way.
>
> Got it.
>
> I've changed the name of the helper, and used an atomic variable there
> to follow the count.
>
> > > But overall I think I don't understand well this part. What is
> > > a bit foggy to me is why the (async) tx implementation does:
> > >
> > > *Core*                           *Driver*
> > >
> > > stop_queue()
> > > drv_async_xmit() -------
> > >                         \------> do something
> > >                          ------- calls ieee802154_xmit_complete()
> > > wakeup_queue() <--------/
> > >
> > > So we actually disable the queue for transmitting. Why??
> > >
> >
> > Because all transceivers have either _one_ transmit framebuffer or one
> > framebuffer for transmit and receive one time. We need to report to
> > stop giving us more skb's while we are busy with one to transmit.
> > This all will/must be changed in future if there is hardware outside
> > which is more powerful and the driver needs to control the flow here.
> >
> > That ieee802154_xmit_complete() calls wakeup_queue need to be
> > forbidden when we are in "synchronous transmit mode"/the queue is
> > stopped. The synchronous transmit mode is not for any hotpath, it's
> > for MLME and I think we also need a per phy lock to avoid multiple
> > synchronous transmissions at one time. Please note that I don't think
> > here only about scan operation, also for other possible MLME-ops.
> >
>
> First, thank you very much for all your guidance and reviews, I think I
> have a much clearer understanding now.
>
> I've tried to follow your advices, creating:
> - a way of tracking ongoing transmissions
> - a synchronous API for MLME transfers
>

Please note that I think we cannot use netif_stop_queue() from context
outside of netif xmit() callback. It's because the atomic counter
itself is racy in xmit(), we need to be sure xmit() can't occur while
stopping the queue. I think maybe "netif_tx_disable()" is the right
call to stop from another context, because it holds the tx_lock, which
I believe is held while xmit().
Where the wake queue call should be fine to call..., maybe we can
remove some EXPORT_SYMBOL() then?

I saw that some drivers call "ieee802154_wake_queue()" in error cases,
may we introduce a new helper "?ieee802154_xmit_error?" for error
cases so you can also catch error cases in your sync tx. See `grep -r
"ieee802154_wake_queue" drivers/net/ieee802154`, if we have more
information we might add more meaning into the error cases (e.g.
proper errno).

> I've decided to use the wait_queue + atomic combo which looks nice.
> Everything seems to work, I just need a bit of time to clean and rework
> a bit the series before sending a v3.
>

Okay, sounds good to implement both requirements.

- Alex
