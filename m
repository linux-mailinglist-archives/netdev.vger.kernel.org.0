Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED0A2C6CD0
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 22:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730653AbgK0VHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 16:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732495AbgK0U6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 15:58:42 -0500
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F543C0613D1;
        Fri, 27 Nov 2020 12:58:42 -0800 (PST)
Received: by mail-oo1-xc44.google.com with SMTP id z13so1372505ooa.5;
        Fri, 27 Nov 2020 12:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1KGtHfb3cXIN/UAkrygKexRxTyUNGSaTPD92WwxmuB0=;
        b=jkOqukqTDXeI5SYiN4RTcIKxWrD8cglL6MkU4qekXiBpXYrzBKBYJ0amxVe/y7ORT7
         2NJHxvo/b7KNrjAHesZOeZzvf/ZHcFz4gpF6CB6uGnLRmncFeJc+bfBikj1tDza8OQxA
         hWxv+CUKFsV8kX48QStLdjpUJfitI/tYSPvidCrkiVMRXXk/0ykhSAZTzrQbrtoPXsjF
         1jBiIM1gYr3qiMj82DGEnDNfiKxF9+0kalPHB8pk04N939Hu5IG1ZboLayCiV5j0fdw5
         fOoVgzFTBO2y+ShhG+UeyrkHSZKDk5oO/JfsGwA8NupPsnaNekI5oxK/9ak+s3EkxElV
         cyTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1KGtHfb3cXIN/UAkrygKexRxTyUNGSaTPD92WwxmuB0=;
        b=VQTwauYnKtHg0Yc2gTw63fknzi0F84+oLPnQMilCrtmyxMgcMAPjhS1j1C6WTerMc0
         LGjkb7W7kFTgx5S90Or494y5H0WNdi2ZPGUYCHVH49KxLto+vPRc4MkgoS1tr4Y65zym
         4i9RFJXN6yhnwUpPMJf8yUHnKtJQL1gHtr8J0ueo/IdduG83Zt2CMetyZAiiKrS6G0CT
         btC5QliUhNzf3qpO3QV7qq++4eIJxZKX8EvE4e2W/xiFVrff5iBFDxQeqe2OMzOhrxEl
         6IRKFeLytXQNLddSj0CaPAIkzwg/BIKyvWQbt2KKxapyWt/m6KxnrpP44PJ/n6LaciWs
         BHXA==
X-Gm-Message-State: AOAM531sGnUg6Vl59JWasYbfXm6hxTRp8ieHFeDUumIFxmkUZmbJJrvb
        /auWQO14yFdQJ2XMfuPBmrnHeA+WOMXzHyJVFmgkl0g0rA==
X-Google-Smtp-Source: ABdhPJwNTLIN4rhmD0UOmy5NCorkOrPVN/P4X/3M5e7qbsHiWgZUXmKqSmPJiuYbTN4y6yNd5DNY4JVWc/FBy8cTt+k=
X-Received: by 2002:a4a:8f98:: with SMTP id c24mr7245260ooj.27.1606510721475;
 Fri, 27 Nov 2020 12:58:41 -0800 (PST)
MIME-Version: 1.0
References: <20201125193740.36825-1-george.mccollister@gmail.com>
 <20201125193740.36825-3-george.mccollister@gmail.com> <20201125174214.0c9dd5a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
 <20201126132418.zigx6c2iuc4kmlvy@skbuf> <20201126175607.bqmpwbdqbsahtjn2@skbuf>
 <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
 <20201126220500.av3clcxbbvogvde5@skbuf> <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAFSKS=MAdnR2jzmkQfTnSQZ7GY5x5KJE=oeqPCQdbZdf5n=4ZQ@mail.gmail.com> <20201127195057.ac56bimc6z3kpygs@skbuf>
In-Reply-To: <20201127195057.ac56bimc6z3kpygs@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Fri, 27 Nov 2020 14:58:29 -0600
Message-ID: <CAFSKS=Pf6zqQbNhaY=A_Da9iz9hcyxQ8E1FBp2o7a_KLBbopYw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x driver
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 1:50 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Fri, Nov 27, 2020 at 12:47:41PM -0600, George McCollister wrote:
> > On Fri, Nov 27, 2020, 12:35 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > > On Fri, 27 Nov 2020 00:05:00 +0200 Vladimir Oltean wrote:
> > > > On Thu, Nov 26, 2020 at 01:07:12PM -0600, George McCollister wrote:
> > > > > On Thu, Nov 26, 2020 at 11:56 AM Vladimir Oltean <olteanv@gmail.com>
> > > wrote:
> > > > > > On Thu, Nov 26, 2020 at 03:24:18PM +0200, Vladimir Oltean wrote:
> > > > > > > On Wed, Nov 25, 2020 at 08:25:11PM -0600, George McCollister
> > > wrote:
> > > > > > > > > > +     {XRS_RX_UNDERSIZE_L, "rx_undersize"},
> > > > > > > > > > +     {XRS_RX_FRAGMENTS_L, "rx_fragments"},
> > > > > > > > > > +     {XRS_RX_OVERSIZE_L, "rx_oversize"},
> > > > > > > > > > +     {XRS_RX_JABBER_L, "rx_jabber"},
> > > > > > > > > > +     {XRS_RX_ERR_L, "rx_err"},
> > > > > > > > > > +     {XRS_RX_CRC_L, "rx_crc"},
> > > > > > > > >
> > > > > > > > > As Vladimir already mentioned to you the statistics which have
> > > > > > > > > corresponding entries in struct rtnl_link_stats64 should be
> > > reported
> > > > > > > > > the standard way. The infra for DSA may not be in place yet,
> > > so best
> > > > > > > > > if you just drop those for now.
> > > > > > > >
> > > > > > > > Okay, that clears it up a bit. Just drop these 6? I'll read
> > > through
> > > > > > > > that thread again and try to make sense of it.
> > > > > > >
> > > > > > > I feel that I should ask. Do you want me to look into exposing RMON
> > > > > > > interface counters through rtnetlink (I've never done anything
> > > like that
> > > > > > > before either, but there's a beginning for everything), or are you
> > > going
> > > > > > > to?
> > > > > >
> > > > > > So I started to add .ndo_get_stats64 based on the hardware counters,
> > > but
> > > > > > I already hit the first roadblock, as described by the wise words of
> > > > > > Documentation/networking/statistics.rst:
> > > > > >
> > > > > > | The `.ndo_get_stats64` callback can not sleep because of accesses
> > > > > > | via `/proc/net/dev`. If driver may sleep when retrieving the
> > > statistics
> > > > > > | from the device it should do so periodically asynchronously and
> > > only return
> > > > > > | a recent copy from `.ndo_get_stats64`. Ethtool interrupt
> > > coalescing interface
> > > > > > | allows setting the frequency of refreshing statistics, if needed.
> > >
> > > I should have probably also mentioned here that unlike most NDOs
> > > .ndo_get_stats64 is called without rtnl lock held at all.
> > >
> > > > > > Unfortunately, I feel this is almost unacceptable for a DSA driver
> > > that
> > > > > > more often than not needs to retrieve these counters from a slow and
> > > > > > bottlenecked bus (SPI, I2C, MDIO etc). Periodic readouts are not an
> > > > > > option, because the only periodic interval that would not put
> > > absurdly
> > > > > > high pressure on the limited SPI bandwidth would be a readout
> > > interval
> > > > > > that gives you very old counters.
> > >
> > > What's a high interval? It's not uncommon to refresh the stats once a
> > > second even in high performance NICs.
> > >
> > > > > Indeed it seems ndo_get_stats64() usually gets data over something
> > > > > like a local or PCIe bus or from software. I had a brief look to see
> > > > > if I could find another driver that was getting the stats over a slow
> > > > > bus and didn't notice anything. If you haven't already you might do a
> > > > > quick grep and see if anything pops out to you.
> > > > >
> > > > > >
> > > > > > What exactly is it that incurs the atomic context? I cannot seem to
> > > > > > figure out from this stack trace:
> > > > >
> > > > > I think something in fs/seq_file.c is taking an rcu lock.
> > > >
> > > > Not quite. It _is_ the RCU read-side lock that's taken, but it's taken
> > > > locally from dev_seq_start in net/core/net-procfs.c. The reason is that
> > > > /proc/net/dev iterates through all interfaces from the current netns,
> > > > and it is precisely that that creates atomic context. You used to need
> > > > to hold the rwlock_t dev_base_lock, but now you can also "get away" with
> > > > the RCU read-side lock. Either way, both are atomic context, so it
> > > > doesn't help.
> > > >
> > > > commit c6d14c84566d6b70ad9dc1618db0dec87cca9300
> > > > Author: Eric Dumazet <eric.dumazet@gmail.com>
> > > > Date:   Wed Nov 4 05:43:23 2009 -0800
> > > >
> > > >     net: Introduce for_each_netdev_rcu() iterator
> > > >
> > > >     Adds RCU management to the list of netdevices.
> > > >
> > > >     Convert some for_each_netdev() users to RCU version, if
> > > >     it can avoid read_lock-ing dev_base_lock
> > > >
> > > >     Ie:
> > > >             read_lock(&dev_base_loack);
> > > >             for_each_netdev(net, dev)
> > > >                     some_action();
> > > >             read_unlock(&dev_base_lock);
> > > >
> > > >     becomes :
> > > >
> > > >             rcu_read_lock();
> > > >             for_each_netdev_rcu(net, dev)
> > > >                     some_action();
> > > >             rcu_read_unlock();
> > > >
> > > >
> > > >     Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > > >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > > >
> > > > So... yeah. As long as this kernel interface exists, it needs to run in
> > > > atomic context, by construction. Great.
> > > >
> > > > > I suppose it doesn't really matter though since the documentation says
> > > > > we can't sleep.
> > > >
> > > > You're talking, I suppose, about these words of wisdom in
> > > > Documentation/filesystems/seq_file.rst?
> > > >
> > > > | However, the seq_file code (by design) will not sleep between the calls
> > > > | to start() and stop(), so holding a lock during that time is a
> > > > | reasonable thing to do. The seq_file code will also avoid taking any
> > > > | other locks while the iterator is active.
> > > >
> > > > It _doesn't_ say that you can't sleep between start() and stop(), right?
> > > > It just says that if you want to keep the seq_file iterator atomic, the
> > > > seq_file code is not sabotaging you by sleeping. But you still could
> > > > sleep if you wanted to.
> > > >
> > > > Back to the statistics counters.
> > > >
> > > > How accurate do the counters in /proc/net/dev need to be? What programs
> > > > consume those? Could they be more out of date than the ones retrieved
> > > > through rtnetlink?
> > >
> > > ifconfig does for sure.
> > >
> > > > I'm thinking that maybe we could introduce another ndo, something like
> > > > .ndo_get_stats64_blocking, that could be called from all places except
> > > > from net/core/net-procfs.c. That one could still call the non-blocking
> > > > variant. Then, depending on the answer to the question "how inaccurate
> > > > could we reasonably leave /proc/net/dev", we could:
> > > > - just return zeroes there
> > > > - return the counters cached from the last blocking call
> > >
> > > I'd rather not introduce divergent behavior like that.
> > >
> > > Is the periodic refresh really that awful? We're mostly talking error
> > > counters here so every second or every few seconds should be perfectly
> > > fine.
> > >
> >
> > That sounds pretty reasonable to me. Worst case is about a 100kbp/s
> > management bus and with the amount of data we're talking about that should
> > be no problem so long as there's a way to raise the interval or disable it
> > entirely.
>
> 100 Kbps = 12.5KB/s.
> sja1105 has 93 64-bit counters, and during every counter refresh cycle I

Yeah, that's quite big. The xrs700x counters are only 16 bit. They
need to be polled on an interval anyway or they will roll.

> would need to get some counters from the beginning of that range, some
> from the middle and some from the end. With all the back-and-forth
> between the sja1105 driver and the SPI controller driver, and the
> protocol overhead associated with creating a "SPI read" message, it is
> all in all more efficient to just issue a burst read operation for all
> the counters, even ones that I'm not going to use. So let's go with
> that, 93x8 bytes (and ignore protocol overhead) = 744 bytes of SPI I/O
> per second. At a throughput of 12.5KB/s, that takes 59 ms to complete,
> and that's just for the raw I/O, that thing which keeps the SPI mutex
> locked. You know what else I could do during that time? Anything else!
> Like for example perform PTP timestamp reconstruction, which has a hard
> deadline at 135 ms after the packet was received, and would appreciate
> if the SPI mutex was not locked for 59 ms every second.

Indeed, however if you need to acquire this data at all it's going to
burden the system at that time so unless you're able to stretch out
the reads over a length of time whether or not you're polling every
second or once a day may not matter if you're never able to miss a
deadline.

> And all of that, for what benefit? Honestly any periodic I/O over the
> management interface is too much I/O, unless there is any strong reason
> to have it.

True enough.

>
> Also, even the simple idea of providing out-of-date counters to user
> space running in syscall context has me scratching my head. I can only
> think of all the drivers in selftests that are checking statistics
> counters before, then they send a packet, then they check the counters
> after. What do those need to do, put a sleep to make sure the counters
> were updated?

Yeah, I don't know enough about how these are used. I'll defer to you.

I apologize if I'm slow at responding. Yesterday and today are
holidays in the US.
