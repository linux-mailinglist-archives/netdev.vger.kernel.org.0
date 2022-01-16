Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE4A48FF8A
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 23:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbiAPWvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 17:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbiAPWvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 17:51:00 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68186C061574;
        Sun, 16 Jan 2022 14:51:00 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id ay4-20020a05600c1e0400b0034a81a94607so17674756wmb.1;
        Sun, 16 Jan 2022 14:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RQNSz+9Ongl6D3vtokUiSrT++IM4wgxyZXz0eiKQvqI=;
        b=EcBk6VegNpRDxFNgkEtPbgyUSZGljDL6dhQ+CvYbTf6MsRixS6lVP7CJlHvMPBMBog
         ODv0rnjf1NuONh509lX8yXQMkJgTfIwNGkH5BAHkhABKV4pnw6AopApW/LdLrfoTB2vi
         wx5zh20eLh1p061bQh+5xVOgg8PLcTlcJVfLED38TR40AP2x/52ithvARtmb75mUW34f
         Yu4G9ZExfypcz5OLr8e7K7Comq25eGZTzYDPt/lrz2a7UXrTeytROFZfYjV0v/n8mpJf
         HrY/TCOhn2gnFHP7UIodHgLu6kyamimnoIPsqOr1uxuW+MoCFq/2PFz4cAQYeclZNX3Q
         oiQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RQNSz+9Ongl6D3vtokUiSrT++IM4wgxyZXz0eiKQvqI=;
        b=d77Njyz9BccmjgZ0eluCGeVb112/43UBD9DnFmZEIENgFPHMOzFyWAd0yHoy/UtqCf
         8VC+FWedZzZQ/pSIgiXJ59DISN8Pi/MOAS3jNgvKQZ9d0hzqFt96CbsU7h7Q7vWjoY+C
         ecr6SOzgC53DBvV1QCvzA4Ff0fnBENpmNYJFAZNQm3UkGd3SaXmL6AHyS/oAHtgU8s7t
         Hzbqi/tM/5ppxwBt38yYodkVwZUGRcBMBLgHd/evzfNl4PYVk4LkJM4CDTMVqA5DLWyG
         +TCMNY0XCaFAG/u0zEJRr30Et/+DhiRut+qPAhMu4F03DbYjeEEtgA7i0Uj3OA9BMnPK
         u/FQ==
X-Gm-Message-State: AOAM533pkZAIppr2EFCxP9xoqU4rZbrj5BXrrDrHNCbdRAQe9H+zdYn4
        zoU+ou8p/BovcaHXFBmmoN/2HOb7ep+B9RgQwXUJlTzpcp2G3Q==
X-Google-Smtp-Source: ABdhPJzkDhrOYIBzWpxnpU9zBb69eGcKLV6JvL1EMQyW1NYKaHh+h0qAE7iaJJRO47lqlKu1MdBZ5R+Y/zcWqhhTrHk=
X-Received: by 2002:a1c:ed01:: with SMTP id l1mr25168995wmh.185.1642373458627;
 Sun, 16 Jan 2022 14:50:58 -0800 (PST)
MIME-Version: 1.0
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
 <20220112173312.764660-19-miquel.raynal@bootlin.com> <CAB_54W4PL1ty5XsqRoEKwsy-h8KL9gSGMK6N=HiWJDp6NHsb0A@mail.gmail.com>
 <20220113180709.0dade123@xps13> <CAB_54W4LdzH9=XS7-ZnxfyCMQFCTS-F5JkUmV+6HtWcCpUS-nQ@mail.gmail.com>
 <20220114194425.3df06391@xps13> <CAB_54W5xJV-3fxOUyvdxBBfUZWYx7JU=BDVhTHFcjJ7SOEdeUw@mail.gmail.com>
In-Reply-To: <CAB_54W5xJV-3fxOUyvdxBBfUZWYx7JU=BDVhTHFcjJ7SOEdeUw@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 16 Jan 2022 17:50:47 -0500
Message-ID: <CAB_54W74Ne185-uEfC23xW6w2nSGDgxef7WxpFKM5T1s7XnYOw@mail.gmail.com>
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

On Sun, 16 Jan 2022 at 17:44, Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Fri, 14 Jan 2022 at 13:44, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >
> > alex.aring@gmail.com wrote on Thu, 13 Jan 2022 19:01:56 -0500:
> >
> > > Hi,
> > >
> > > On Thu, 13 Jan 2022 at 12:07, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > >
> > > > Hi Alexander,
> > > >
> > > > alex.aring@gmail.com wrote on Wed, 12 Jan 2022 17:44:02 -0500:
> > > >
> > > > > Hi,
> > > > >
> > > > > On Wed, 12 Jan 2022 at 12:33, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > > ...
> > > > > > +       return 0;
> > > > > > +}
> > > > > > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > > > > > index c829e4a75325..40656728c624 100644
> > > > > > --- a/net/mac802154/tx.c
> > > > > > +++ b/net/mac802154/tx.c
> > > > > > @@ -54,6 +54,9 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
> > > > > >         struct net_device *dev = skb->dev;
> > > > > >         int ret;
> > > > > >
> > > > > > +       if (unlikely(mac802154_scan_is_ongoing(local)))
> > > > > > +               return NETDEV_TX_BUSY;
> > > > > > +
> > > > >
> > > > > Please look into the functions "ieee802154_wake_queue()" and
> > > > > "ieee802154_stop_queue()" which prevent this function from being
> > > > > called. Call stop before starting scanning and wake after scanning is
> > > > > done or stopped.
> > > >
> > > > Mmmh all this is already done, isn't it?
> > > > - mac802154_trigger_scan_locked() stops the queue before setting the
> > > >   promiscuous mode
> > > > - mac802154_end_of_scan() wakes the queue after resetting the
> > > >   promiscuous mode to its original state
> > > >
> > > > Should I drop the check which stands for an extra precaution?
> > > >
> > >
> > > no, I think then it should be a WARN_ON() more without any return
> > > (hopefully it will survive). This case should never happen otherwise
> > > we have a bug that we wake the queue when we "took control about
> > > transmissions" only.
> > > Change the name, I think it will be in future not only scan related.
> > > Maybe "mac802154_queue_stopped()". Everything which is queued from
> > > socket/upperlayer(6lowpan) goes this way.
> >
> > Got it.
> >
> > I've changed the name of the helper, and used an atomic variable there
> > to follow the count.
> >
> > > > But overall I think I don't understand well this part. What is
> > > > a bit foggy to me is why the (async) tx implementation does:
> > > >
> > > > *Core*                           *Driver*
> > > >
> > > > stop_queue()
> > > > drv_async_xmit() -------
> > > >                         \------> do something
> > > >                          ------- calls ieee802154_xmit_complete()
> > > > wakeup_queue() <--------/
> > > >
> > > > So we actually disable the queue for transmitting. Why??
> > > >
> > >
> > > Because all transceivers have either _one_ transmit framebuffer or one
> > > framebuffer for transmit and receive one time. We need to report to
> > > stop giving us more skb's while we are busy with one to transmit.
> > > This all will/must be changed in future if there is hardware outside
> > > which is more powerful and the driver needs to control the flow here.
> > >
> > > That ieee802154_xmit_complete() calls wakeup_queue need to be
> > > forbidden when we are in "synchronous transmit mode"/the queue is
> > > stopped. The synchronous transmit mode is not for any hotpath, it's
> > > for MLME and I think we also need a per phy lock to avoid multiple
> > > synchronous transmissions at one time. Please note that I don't think
> > > here only about scan operation, also for other possible MLME-ops.
> > >
> >
> > First, thank you very much for all your guidance and reviews, I think I
> > have a much clearer understanding now.
> >
> > I've tried to follow your advices, creating:
> > - a way of tracking ongoing transmissions
> > - a synchronous API for MLME transfers
> >
>
> Please note that I think we cannot use netif_stop_queue() from context
> outside of netif xmit() callback. It's because the atomic counter
> itself is racy in xmit(), we need to be sure xmit() can't occur while
> stopping the queue. I think maybe "netif_tx_disable()" is the right
> call to stop from another context, because it holds the tx_lock, which
> I believe is held while xmit().
> Where the wake queue call should be fine to call..., maybe we can
> remove some EXPORT_SYMBOL() then?
>

I am sorry, that comment should go below.

> I saw that some drivers call "ieee802154_wake_queue()" in error cases,
> may we introduce a new helper "?ieee802154_xmit_error?" for error
> cases so you can also catch error cases in your sync tx. See `grep -r
> "ieee802154_wake_queue" drivers/net/ieee802154`, if we have more
> information we might add more meaning into the error cases (e.g.
> proper errno).

maybe we can remove some EXPORT_SYMBOL() then?

- Alex
