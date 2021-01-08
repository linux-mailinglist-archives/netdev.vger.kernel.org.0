Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC3B2EF5DF
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbhAHQdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728082AbhAHQdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 11:33:53 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817D5C061381
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 08:33:13 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id 75so10792448ilv.13
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 08:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A1tljSHi/v+7RRb1Y0XXkfmvPdJKZp7OZc0o760G24c=;
        b=i4zS0wsgUSRBi4wTujDYIfahJVXtUznDkKsmoUZ5JhkfPRUAaa/JWeP1+wfZUF37nd
         +en3O7rhodPKabp77ZZZBoZc0ZF7/0B6OhHVF5lyi8jnZy3iuaMBE5vsyUdFPlwAXiRB
         wVN3Q0s/PzCMVEWWxftFLljotDk81Gmxvj4LFxHGZF5JQf5ijLjqk1A/ZLUxLlDqEWPA
         63ELc7WQrzzU+U1y7f9FSVaKGND2xgAxWF8c6Ym8ungn0XxhDN9w8UGnKilBFYz2o/S0
         nVxvOxjIW3z+18lU6dhC+wUDkNyj/0S/Gg4ilwZbaPA3J7Tls3ZHnpR7FvzQFWqaWR8w
         TKUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A1tljSHi/v+7RRb1Y0XXkfmvPdJKZp7OZc0o760G24c=;
        b=f0b0CEO4bmTK39VFIVwXbitFwzPS7myG1kaY34HmA5h6Y4AAJcSM5fVg+sVAXnyGlf
         eAD+Xd8Vb3LH2X6qkPLtiHLhky0QjDOFuwCwtbLUA4Un1bbWUR/eerovlooAiThdrD91
         k9WV55IkSukndosj+wUTDvO+Kn5/+AQXkn0PWbkCZ1jYsi7srzu18fqQrNf+oxEbRY2E
         6vmjCAoUtE/1YSJTH8RLDJm2zSA6ZEIwcDKQV/YbpWtv4Pir276fizzHnCtSiK/1yUyI
         VimzqI7OviAPU2PJU8+mLklhplASEt4F4BgleL2rR13PsJcDbtTBWkC3v9mvPX0TIIY/
         pMgw==
X-Gm-Message-State: AOAM532FIg1buvR0g0OwBXeXnJsDGaOhXI3aOyr6hodn6ptSzOahyCR5
        e44D12vgT2Uvn5jkNlwKpB2j/fnJJs3RR3EbjaLh83sR0QHGtg==
X-Google-Smtp-Source: ABdhPJwsSRqPgKY8LlVS5C98hztgbJb4lmHg80euHGCmbqT9k1lR9b4EMQPUTCNWcN+RdbHMmYNlTwGYKvCPv/Zt61I=
X-Received: by 2002:a92:d210:: with SMTP id y16mr4505979ily.97.1610123592851;
 Fri, 08 Jan 2021 08:33:12 -0800 (PST)
MIME-Version: 1.0
References: <20210106180428.722521-1-atenart@kernel.org> <20210106180428.722521-4-atenart@kernel.org>
 <CAKgT0UdZs7ER84PmeM5EV6rAKWiqu-5Ma47bh8qf-68fjsfbAw@mail.gmail.com>
 <161000966161.3275.12891261917424414122@kwain.local> <CAKgT0UcFu7pgy96uMhraT7B_JKEwXtVziouXLmZ4rdXPHn91Jg@mail.gmail.com>
 <161009687495.3394.14011897084392954560@kwain.local>
In-Reply-To: <161009687495.3394.14011897084392954560@kwain.local>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 8 Jan 2021 08:33:01 -0800
Message-ID: <CAKgT0UdSiLpPXUEEOLRj4+7D0KcGBNBoW5cU=4DXW0kfOb=gEQ@mail.gmail.com>
Subject: Re: [PATCH net 3/3] net-sysfs: move the xps cpus/rxqs retrieval in a
 common function
To:     Antoine Tenart <atenart@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 1:07 AM Antoine Tenart <atenart@kernel.org> wrote:
>
> Quoting Alexander Duyck (2021-01-07 17:38:35)
> > On Thu, Jan 7, 2021 at 12:54 AM Antoine Tenart <atenart@kernel.org> wrote:
> > >
> > > Quoting Alexander Duyck (2021-01-06 20:54:11)
> > > > On Wed, Jan 6, 2021 at 10:04 AM Antoine Tenart <atenart@kernel.org> wrote:
> > >
> > > That would require to hold rcu_read_lock in the caller and I'd like to
> > > keep it in that function.
> >
> > Actually you could probably make it work if you were to pass a pointer
> > to the RCU pointer.
>
> That should work but IMHO that could be easily breakable by future
> changes as it's a bit tricky.
>
> > > > >         if (dev->num_tc) {
> > > > >                 /* Do not allow XPS on subordinate device directly */
> > > > >                 num_tc = dev->num_tc;
> > > > > -               if (num_tc < 0) {
> > > > > -                       ret = -EINVAL;
> > > > > -                       goto err_rtnl_unlock;
> > > > > -               }
> > > > > +               if (num_tc < 0)
> > > > > +                       return -EINVAL;
> > > > >
> > > > >                 /* If queue belongs to subordinate dev use its map */
> > > > >                 dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
> > > > >
> > > > >                 tc = netdev_txq_to_tc(dev, index);
> > > > > -               if (tc < 0) {
> > > > > -                       ret = -EINVAL;
> > > > > -                       goto err_rtnl_unlock;
> > > > > -               }
> > > > > +               if (tc < 0)
> > > > > +                       return -EINVAL;
> > > > >         }
> > > > >
> > > >
> > > > So if we store the num_tc and nr_ids in the dev_maps structure then we
> > > > could simplify this a bit by pulling the num_tc info out of the
> > > > dev_map and only asking the Tx queue for the tc in that case and
> > > > validating it against (tc <0 || num_tc <= tc) and returning an error
> > > > if either are true.
> > > >
> > > > This would also allow us to address the fact that the rxqs feature
> > > > doesn't support the subordinate devices as you could pull out the bit
> > > > above related to the sb_dev and instead call that prior to calling
> > > > xps_queue_show so that you are operating on the correct device map.
> >
> > It probably would be necessary to pass dev and index if we pull the
> > netdev_get_tx_queue()->sb_dev bit out and performed that before we
> > called the xps_queue_show function. Specifically as the subordinate
> > device wouldn't match up with the queue device so we would be better
> > off pulling it out first.
>
> While I agree moving the netdev_get_tx_queue()->sb_dev bit out of
> xps_queue_show seems like a good idea for consistency, I'm not sure
> it'll work: dev->num_tc is not only used to retrieve the number of tc
> but also as a condition on not being 0. We have things like:
>
>   // Always done with the original dev.
>   if (dev->num_tc) {
>
>       [...]
>
>       // Can be a subordinate dev.
>       tc = netdev_txq_to_tc(dev, index);
>   }
>
> And after moving num_tc in the map, we'll have checks like:
>
>   if (dev_maps->num_tc != dev->num_tc)
>       return -EINVAL;

We shouldn't. That defeats the whole point and you will never be able
to rely on the num_tc in the device to remain constant. If we are
moving the value to an RCU accessible attribute we should just be
using that value. We can only use that check if we are in an rtnl_lock
anyway and we won't need that if we are just displaying the value.

The checks should only be used to verify the tc of the queue is within
the bounds of the num_tc of the xps_map.

> I don't think the subordinate dev holds the same num_tc value as dev.
> What's your take on this?

So if I recall the num_tc for the subordinate device would be negative
since the subordinate devices start at -1 and just further decrease.
That is yet another reason why we shouldn't be looking at the num_tc
of the device.

> > > > > -       mask = bitmap_zalloc(nr_cpu_ids, GFP_KERNEL);
> > > > > -       if (!mask) {
> > > > > -               ret = -ENOMEM;
> > > > > -               goto err_rtnl_unlock;
> > > > > +       rcu_read_lock();
> > > > > +
> > > > > +       if (is_rxqs_map) {
> > > > > +               dev_maps = rcu_dereference(dev->xps_rxqs_map);
> > > > > +               nr_ids = dev->num_rx_queues;
> > > > > +       } else {
> > > > > +               dev_maps = rcu_dereference(dev->xps_cpus_map);
> > > > > +               nr_ids = nr_cpu_ids;
> > > > > +               if (num_possible_cpus() > 1)
> > > > > +                       possible_mask = cpumask_bits(cpu_possible_mask);
> > > > >         }
> > > >
> >
> > I don't think we need the possible_mask check. That is mostly just an
> > optimization that was making use of an existing "for_each" loop macro.
> > If we are going to go through 0 through nr_ids then there is no need
> > for the possible_mask as we can just brute force our way through and
> > will not find CPU that aren't there since we couldn't have added them
> > to the map anyway.
>
> I'll remove it then. __netif_set_xps_queue could also benefit from it.

Sounds good.

> > > > I think Jakub had mentioned earlier the idea of possibly moving some
> > > > fields into the xps_cpus_map and xps_rxqs_map in order to reduce the
> > > > complexity of this so that certain values would be protected by the
> > > > RCU lock.
> > > >
> > > > This might be a good time to look at encoding things like the number
> > > > of IDs and the number of TCs there in order to avoid a bunch of this
> > > > duplication. Then you could just pass a pointer to the map you want to
> > > > display and the code should be able to just dump the values.:
> > >
> > > 100% agree to all the above. That would also prevent from making out of
> > > bound accesses when dev->num_tc is increased after dev_maps is
> > > allocated. I do have a series ready to be send storing num_tc into the
> > > maps, and reworking code to use it instead of dev->num_tc. The series
> > > also adds checks to ensure the map is valid when we access it (such as
> > > making sure dev->num_tc == map->num_tc). I however did not move nr_ids
> > > into the map yet, but I'll look into it.
> > >
> > > The idea is to send it as a follow up series, as this one is only moving
> > > code around to improve maintenance and readability. Even if all the
> > > patches were in the same series that would be a prerequisite.
> >
> > Okay, so if we are going to do it as a follow-up that is fine I
> > suppose, but one of the reasons I brought it up is that it would help
> > this patch set in terms of readability/maintainability. An additional
> > change we could look at making would be to create an xps_map pointer
> > array instead of having individual pointers. Then you could simply be
> > passing an index into the array to indicate if we are accessing the
> > CPUs or the RXQs map.
>
> Merging the two maps and embedding an offset in the struct? With the
> upcoming changes embedding information in the map themselves we should
> have a single check to know what map to use. Using a single array with
> offsets would not improve that. Also maps maintenance when num_tc
> is updated would need to take care of both maps, having side effects
> such as removing the old rxqs map when allocating the cpus one (or the
> opposite).
>
> Thanks,
> Antoine

Sorry, I didn't mean to merge the two maps. Just go from two pointers
to an array containing two pointers. Right now them sitting right next
to each other it becomes pretty easy to just convert them so that
instead of accessing them as:

dev->xps_rxqs_map
dev->xps_cpus_map

You could instead access them as:
dev->xps_map[XPS_RXQ];
dev->xps_map[XPS_CPU];

Then instead of all the if/else logic we have in the code you just are
passing the index of the xps_map you want to access and we have the
nr_ids and num_tc all encoded in the map so the code itself. Then for
displaying we are just using the fields from the map to validate.

We will still end up needing to take the rtnl_lock for the
__netif_set_xps_queue case, however that should be the only case where
we really need it as we have to re-read dev->num_tc and the
netdev_txq_to_tc and guarantee they don't change while we are
programming the map.

That reminds me we may want to add an ASSERT_RTNL to the start of
__netif_set_xps_queue and a comment indicating that we need to hold
the rtnl lock to guarantee that num_tc and the Tx queue to TC mapping
cannot change while we are programming the value into the map.
