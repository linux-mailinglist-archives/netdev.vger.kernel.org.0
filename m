Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED8421E5F5
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 04:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGNCvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 22:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726517AbgGNCvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 22:51:54 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB318C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 19:51:53 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id l17so4262582iok.7
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 19:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5ivlusaOq+vggyV8ml7oGcORvDP7HsCxY9Ud2jb0x9U=;
        b=URANGxWJ/Z+XW4qTLbTD+VzJDev2Xbe62kL5pVBQeAlmM+9vfUn9TojhwTfVF2ZCZ3
         lIYsV4YvwYr110qNbO66Ekh2OJURRdTkZhzSpQK8gSRn2EEKKwxGO/9lJFwsgPmlL6LR
         BZH6GuTtLmZOiW7EDp+crfmGmpSmcQvpFUB0EmbsaBAkixqna3bU5vMcA9moNgck3PkJ
         t4euBBSvn4iPl9CqY8ElBZMHq2l0xtmwfQRIj3ClH1LqkeWl5ArD8AxshJOoqlALMuDA
         OPIwnUN2vM9Vu5d7KSoG4r4J3os3Y0o/t9SHtylzvyh/H4qW7HKLDY4CJhGMV83HSt/N
         fuuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5ivlusaOq+vggyV8ml7oGcORvDP7HsCxY9Ud2jb0x9U=;
        b=TDgmjg/dijhHKY4bZeXqsmnv6vXMYtibt4DEaBEajpJ/SQsBtZ40CggBreICamqrXG
         HAd6ugvGkztu8A5KXRb/ke7el0LuEA8vyrtIFGMrw261Ev3YrdKDrJy/Jzs8w4Wy+Dxs
         nXn7C/2rVWmzugSNWQkK440X9s3rV0Qtj+I8y6ai+Y87IkUxqeq21LnNUTy4gWXAa00h
         5iHBE2HygOZdxrAewcDdvHtGrF5cHn7U1FBQWSWBUwsT0sm0IokGQuFwJqKl0Bv4LWTA
         /UCLytPmdT8jfbRSnEzgaO0blFUwJ3FHTk9l8BkiquiXFk0Ne/VCjGuhjW9PHF1lgCDf
         B0dg==
X-Gm-Message-State: AOAM530czI9sxD2TwAj2FmKOVNIxqgOZWas3jKGJIX+oRwho/hmzPouW
        JfUhWMJlEij0IxGlbKjru8dXBiDXdvmZXr1YfPg=
X-Google-Smtp-Source: ABdhPJwfkYS6NodQB4TyquPKLnNQbXsoaXZELmCF1xq96SKeMgauxlYDGaIaYHuB8fT1no5838oA1GsmIUnpqDeWmDU=
X-Received: by 2002:a05:6602:1581:: with SMTP id e1mr2979187iow.44.1594695112602;
 Mon, 13 Jul 2020 19:51:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593209494.git.petrm@mellanox.com> <79417f27b7c57da5c0eb54bb6d074d3a472d9ebf.1593209494.git.petrm@mellanox.com>
 <CAM_iQpXvwPGz=kKBFKQAkoJ0hwijC9M03SV9arC++gYBAU5VKw@mail.gmail.com>
 <87a70bic3n.fsf@mellanox.com> <CAM_iQpWjod0oLew-jSN+KUXkoPYkJYWyePHsvLyW4f2JbYQFRw@mail.gmail.com>
 <873662i3rc.fsf@mellanox.com> <CAM_iQpVs_OEBw54qMhn7Tx6_YAGh5PMSApj=RrO0j6ThSXpkcg@mail.gmail.com>
 <87wo3dhg63.fsf@mellanox.com> <87v9ixh7es.fsf@mellanox.com>
 <CAM_iQpU-fh9Saaxo+6juONn+Xd891sUhgaaoht0Bkn2ssAEm8A@mail.gmail.com> <875zavh1re.fsf@mellanox.com>
In-Reply-To: <875zavh1re.fsf@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 13 Jul 2020 19:51:41 -0700
Message-ID: <CAM_iQpUi-aKBLF5MkkSkCBchHeK5a_8OEDw3eXHZ4yPo=_hvsQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/5] net: sched: Introduce helpers for qevent blocks
To:     Petr Machata <petrm@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 7:40 AM Petr Machata <petrm@mellanox.com> wrote:
>
>
> Cong Wang <xiyou.wangcong@gmail.com> writes:
>
> > On Wed, Jul 8, 2020 at 5:13 PM Petr Machata <petrm@mellanox.com> wrote:
> >>
> >>
> >> Petr Machata <petrm@mellanox.com> writes:
> >>
> >> > Cong Wang <xiyou.wangcong@gmail.com> writes:
> >> >
> >> > I'll think about it some more. For now I will at least fix the lack of
> >> > locking.
> >>
> >> I guess I could store smp_processor_id() that acquired the lock in
> >> struct qdisc_skb_head. Do a trylock instead of lock, and on fail check
> >> the stored value. I'll need to be careful about the race between
> >> unsuccessful trylock and the test, and about making sure CPU ID doesn't
> >> change after it is read. I'll probe this tomorrow.
> >
> > Like __netif_tx_lock(), right? Seems doable.
>
> Good to see it actually used, I wasn't sure if the idea made sense :)
>
> Unfortunately it is not enough.
>
> Consider two threads (A, B) and two netdevices (eth0, eth1):
>
> - "A" takes eth0's root lock and proceeds to classification
> - "B" takes eth1's root lock and proceeds to classification
> - "A" invokes mirror to eth1, waits on lock held by "B"
> - "B" invakes mirror to eth0, waits on lock held by "A"
> - Some say they are still waiting to this day.

Sure, AA or ABBA deadlock.

>
> So one option that I see is to just stash the mirrored packet in a queue
> instead of delivering it right away:
>
> - s/netif_receive_skb/netif_rx/ in act_mirred
>
> - Reuse the RX queue for TX packets as well, differentiating the two by
>   a bit in SKB CB. Then process_backlog() would call either
>   __netif_receive_skb() or dev_queue_transmit().
>
> - Drop mirred_rec_level guard.

I don't think I follow you, the root qdisc lock is on egress which has
nothing to do with ingress, so I don't see how netif_rx() is even involved.

>
> This seems to work, but I might be missing something non-obvious, such
> as CB actually being used for something already in that context. I would
> really rather not introduce a second backlog queue just for mirred
> though.
>
> Since mirred_rec_level does not kick in anymore, the same packet can end
> up being forwarded from the backlog queue, to the qdisc, and back to the
> backlog queue, forever. But that seems OK, that's what the admin
> configured, so that's what's happening.
>
> If this is not a good idea for some reason, this might work as well:
>
> - Convert the current root lock to an rw lock. Convert all current
>   lockers to write lock (which should be safe), except of enqueue, which
>   will take read lock. That will allow many concurrent threads to enter
>   enqueue, or one thread several times, but it will exclude all other
>   users.

Are you sure we can parallelize enqueue()? They all need to move
skb into some queue, which is not able to parallelize with just a read
lock. Even the "lockless" qdisc takes a spinlock, r->producer_lock,
for enqueue().


>
>   So this guards configuration access to the qdisc tree, makes sure
>   qdiscs don't go away from under one's feet.
>
> - Introduce another spin lock to guard the private data of the qdisc
>   tree, counters etc., things that even two concurrent enqueue
>   operations shouldn't trample on. Enqueue takes this spin lock after
>   read-locking the root lock. act_mirred drops it before injecting the
>   packet and takes it again afterwards.
>
> Any opinions y'all?

I thought about forbidding mirror/redirecting to the same device,
but there might be some legitimate use cases of such. So, I don't
have any other ideas yet, perhaps there is some way to refactor
dev_queue_xmit() to avoid this deadlock.

Thanks.
