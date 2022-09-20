Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384435BED28
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 20:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbiITSvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 14:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbiITSui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 14:50:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0762174DEE
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 11:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663699826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5nlR+S8FQ3hHNuojlW0hMi5PihV38Hzh5cy0LDLsHd0=;
        b=DZKNcHMGVg988NcWsIpD7/t4VWulWDbotGfmJLZA/UIfNqyJsy39dlMIkr3XZwhc+6BLkm
        hsg9BWi+EzCjGXNSKIb26H7Qa8YcVPZAVwUXY8cqbMq7/G4QmrJS9b6yqexjOZnDK5EzHv
        YZMnSXYT/9A8vbJKi8ww6Dx2aQaAYrM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-112-q8V6TBgKPe21fQXbwlu0pA-1; Tue, 20 Sep 2022 14:50:25 -0400
X-MC-Unique: q8V6TBgKPe21fQXbwlu0pA-1
Received: by mail-wr1-f69.google.com with SMTP id m2-20020adfc582000000b0021e28acded7so1523386wrg.13
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 11:50:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=5nlR+S8FQ3hHNuojlW0hMi5PihV38Hzh5cy0LDLsHd0=;
        b=0VacB1o9P8Wi6S4avIw1Ji7/OYPwSxqdbxzvP1/TxqTLleFPgNMaE03bbcTT97Tb6/
         l87uG9LiJ1Cwn1dvfvkIIeLV+VT34vTyVSSiCKmpn0xNidTO1bkxHyfEse/IJF8ENqDn
         ZOfvlwnzADGfxagy64Ic/4lLvf5TjKhHH/27iCOEjkQ14XuCDZaY+W/w1vfLViy5hg0Z
         fSbKOySoTiEILd1V5qtLG2aO6WvJcZFhobCAh6pZ6CimMYg/b3jN7+gOhaoX1SPU+6aQ
         7u5rSqTnTQkmEMO7ep5QJ9a2hDswZkmz4tN6ZuprbVMYKLDm1onS+rFMz99FHgZSeWjM
         9EOw==
X-Gm-Message-State: ACrzQf1bdEHeM9VTnpXTfLxDYhY9J60QiNEmt1hobF0FKIXKVBWCSuZT
        00QCc2gq6LNXwxOKNgdOdcbUO/lOqzNk+NHwEd62f43a8RTqeVADAWD3ULB/g35w1Ku/+S+aTIo
        kQbUIJCVh7Ta5Lx6u
X-Received: by 2002:a05:600c:3d0c:b0:3b4:c481:c63b with SMTP id bh12-20020a05600c3d0c00b003b4c481c63bmr3305577wmb.147.1663699823892;
        Tue, 20 Sep 2022 11:50:23 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6HMk2DFlpUNLKSOCYcC/zFHY06jeiIh9AefSs7Qp9or8qqN/LcAofk8yFaY0KAG2+k2HvYCQ==
X-Received: by 2002:a05:600c:3d0c:b0:3b4:c481:c63b with SMTP id bh12-20020a05600c3d0c00b003b4c481c63bmr3305563wmb.147.1663699823604;
        Tue, 20 Sep 2022 11:50:23 -0700 (PDT)
Received: from debian.home (2a01cb058d2cf4004ad3915553d340e2.ipv6.abo.wanadoo.fr. [2a01:cb05:8d2c:f400:4ad3:9155:53d3:40e2])
        by smtp.gmail.com with ESMTPSA id m12-20020a5d56cc000000b00228cd9f6349sm414187wrw.106.2022.09.20.11.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 11:50:22 -0700 (PDT)
Date:   Tue, 20 Sep 2022 20:50:21 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Benjamin Coddington <bcodding@redhat.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Scott Mayhew <smayhew@redhat.com>,
        David Miller <davem@davemloft.net>,
        Chuck Lever <chuck.lever@oracle.com>,
        Steve French <sfrench@samba.org>, Tejun Heo <tj@kernel.org>,
        Anna Schumaker <anna@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [RFC net] Should sk_page_frag() also look at the current GFP
 context?
Message-ID: <20220920185021.GA21641@debian.home>
References: <b4d8cb09c913d3e34f853736f3f5628abfd7f4b6.1656699567.git.gnault@redhat.com>
 <CANn89i+=GyHjkrHMZAftB-toEhi9GcAQom1_bpT+S0qMvCz0DQ@mail.gmail.com>
 <429C561E-2F85-4DB5-993C-B2DD4E575BF0@redhat.com>
 <e8de4a15c934658b06ee1de10fd21975b972f902.camel@hammerspace.com>
 <9ADC95E9-7756-4706-8B45-E1BB65020216@redhat.com>
 <CANn89i+EKvfthJJbThWoG2fKaY9ACZ_cEZuNfXw7v9WVWGLksQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+EKvfthJJbThWoG2fKaY9ACZ_cEZuNfXw7v9WVWGLksQ@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 05:31:24PM +0200, Eric Dumazet wrote:
> On Mon, Jul 11, 2022 at 4:07 PM Benjamin Coddington <bcodding@redhat.com> wrote:
> >
> > On 8 Jul 2022, at 16:04, Trond Myklebust wrote:
> >
> > > On Fri, 2022-07-08 at 14:10 -0400, Benjamin Coddington wrote:
> > >> On 7 Jul 2022, at 12:29, Eric Dumazet wrote:
> > >>
> > >>> On Fri, Jul 1, 2022 at 8:41 PM Guillaume Nault <gnault@redhat.com>
> > >>> wrote:
> > >>>>
> > >>>> diff --git a/include/net/sock.h b/include/net/sock.h
> > >>>> index 72ca97ccb460..b934c9851058 100644
> > >>>> --- a/include/net/sock.h
> > >>>> +++ b/include/net/sock.h
> > >>>> @@ -46,6 +46,7 @@
> > >>>>  #include <linux/netdevice.h>
> > >>>>  #include <linux/skbuff.h>      /* struct sk_buff */
> > >>>>  #include <linux/mm.h>
> > >>>> +#include <linux/sched/mm.h>
> > >>>>  #include <linux/security.h>
> > >>>>  #include <linux/slab.h>
> > >>>>  #include <linux/uaccess.h>
> > >>>> @@ -2503,14 +2504,17 @@ static inline void
> > >>>> sk_stream_moderate_sndbuf(struct sock *sk)
> > >>>>   * socket operations and end up recursing into sk_page_frag()
> > >>>>   * while it's already in use: explicitly avoid task page_frag
> > >>>>   * usage if the caller is potentially doing any of them.
> > >>>> - * This assumes that page fault handlers use the GFP_NOFS flags.
> > >>>> + * This assumes that page fault handlers use the GFP_NOFS flags
> > >>>> + * or run under memalloc_nofs_save() protection.
> > >>>>   *
> > >>>>   * Return: a per task page_frag if context allows that,
> > >>>>   * otherwise a per socket one.
> > >>>>   */
> > >>>>  static inline struct page_frag *sk_page_frag(struct sock *sk)
> > >>>>  {
> > >>>> -       if ((sk->sk_allocation & (__GFP_DIRECT_RECLAIM |
> > >>>> __GFP_MEMALLOC | __GFP_FS)) ==
> > >>>> +       gfp_t gfp_mask = current_gfp_context(sk->sk_allocation);
> > >>>
> > >>> This is slowing down TCP sendmsg() fast path, reading current-
> > >>>> flags,
> > >>> possibly cold value.
> > >>
> > >> True - current->flags is pretty distant from current->task_frag.
> > >>
> > >>> I would suggest using one bit in sk, close to sk->sk_allocation to
> > >>> make the decision,
> > >>> instead of testing sk->sk_allocation for various flags.
> > >>>
> > >>> Not sure if we have available holes.
> > >>
> > >> Its looking pretty packed on my build.. the nearest hole is 5
> > >> cachelines
> > >> away.
> > >>
> > >> It'd be nice to allow network filesystem to use task_frag when
> > >> possible.
> > >>
> > >> If we expect sk_page_frag() to only return task_frag once per call
> > >> stack,
> > >> then can we simply check it's already in use, perhaps by looking at
> > >> the
> > >> size field?
> > >>
> > >> Or maybe can we set sk_allocation early from current_gfp_context()
> > >> outside
> > >> the fast path?
> > >
> > > Why not just add a bit to sk->sk_allocation itself, and have
> > > __sock_create() default to setting it when the 'kern' parameter is non-
> > > zero? NFS is not alone in following the request of the mm team to
> > > deprecate use of GFP_NOFS and GFP_NOIO.
> >
> > Can we overload sk_allocation safely?  There's 28 GFP flags already, I'm
> > worried about unintended consequences if sk_allocation gets passed on.
> >
> > What about a flag in sk_gso_type?  Looks like there's 13 free there, and its
> > in the same cacheline as sk_allocation and sk_frag.
> 
> I think we could overload GFP_COMP with little risk.

Reviving this semi-old thread after discussions at LPC.

It seems we won't have a clear path for how to make sk_page_frag()
aware of memalloc_nofs or memalloc_noio contexts before some time.
Since we continue to get bug reports for this issue, I'm thinking of
just setting sk_allocation to GFP_NOFS for sunrpc sockets. Then we'll
can think of a better way of removing GFP_NOFS or GFP_NOIO from the
different networking file systems and block devices.

Here's a summary of all the long term options discussed so far.

1) Use a special bit in sk_allocation.

Either repurpose an existing bit like GFP_COMP or allocate a free one.
Then sk_page_frag() could test this bit and avoid returning
current->task_frag when it's set. That bit would have to be masked
every time sk_allocation is used to allocate memory.
Overall, it looks a bit like using GFP_NOFS with a different name,
apart that it allows the socket to allocate memory with GFP_KERNEL when
not in memalloc_nofs critical sections (but I'm not sure if it's a
practical gain for NFS).

Alternatively, there's a one bit hole in struct sock_common, right
after skc_state, which could be used to store a 'skc_no_task_frag'
flag (the cache line should be hot because of skc_state). Any socket
user that could be called during memory reclaim could set this bit to
prevent sk_page_frag() from using current->taskfrag.

2) Avoid using current->task_frag for kernel sockets.

Since sk_kern_sock is in the same cache line as sk_allocation, we
probably could let sk_page_frag() test if sk is a kernel socket and
avoid using current->task_frag in this case. Alternatively, we could
define a new flag as in option 1 and automatically set it when creating
kernel sockets (as proposed by Trond).

However, there are many kernel socket users and, so far, only NFS (and
maybe other networking FS in the future) need this protection. So it
looks like a pretty big hammer. Also, NBD uses sockets passed from user
space. Therefore if it were to phase out GFP_NOFS, sk_page_frag() could
return current->task_frag again (maybe NBD should transfrom its sockets
to kernel sockets, but that's a bit of a tangential discussion).

3) Adjust sk_allocation when necessary.

The idea would be to update sk_allocation before entering TCP fast
path. Something like:

  old_sk_allocation = sk->sk_allocation;
  sk->sk_allocation = current_gfp_context(sk->sk_allocation);
  ... use sk ...
  sk->sk_allocation = old_sk_allocation;

That doesn't seem feasible though, as this assumes exclusive access to
the socket, but we grab the socket lock only after entering
tcp_sendmsg().

A similar idea was to do this automatically in kernel_sendmsg(), but
it faces the same exclusive access problem. Furthermore, not all
GFP_NOFS users use kernel_sendmsg() (same problem as with option 2).

4) Detect if current->task_frag is already in use.

There may be a way for sk_page_frag() to detect if current->task_frag
is already in use, that is, if it's in a recursive call. That'd be nice
as that'd avoid the need for any heuristic based on sk_allocation.
However, I can't think of any way to do that efficiently and without
adding bits in current.

Thanks to all those involved in this thread, and to Paolo and Eric for
the fruitful discussions at LPC.

