Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D9D2D6282
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 17:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392318AbgLJQwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 11:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392232AbgLJQv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 11:51:57 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444A3C061794
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 08:51:17 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id w206so3112377wma.0
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 08:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=epGNlRHgYSygzTTZ+uFkIBrJrnk/Z3AzZZijyw63diU=;
        b=wNykV1c1JlvHFJoxiReneV2Pt2vvkRHD3ZnqbdiC0M2A9Uiu1JBaIq/l8/yYj6CKlb
         51bOfU44+YB6Ji1eHliUn28ZFSXnaIGbgRn8AzaWL5H/04PZ/GkLiCNCe/dcS9aZehbw
         zwPqY/jrryJORyReX7ApUYtsK2XWbGRUc3ER3j000K8cUAbC1vUILedmOCdBNmY4q425
         Y6/bDRNqDVU1UruDy+xyhnrDwRl+mYiNWukd2JhCHI8MI+qx90Hd70cXCIDIV7c1fAtz
         jcTaHXGx1fQSZ8qTVaVqyKV1I1cy0ut+pNZYovGUcc7z2+CopqbLByVn3jRHqKp3vLUG
         oKeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=epGNlRHgYSygzTTZ+uFkIBrJrnk/Z3AzZZijyw63diU=;
        b=qM1XZKXQpRwv/LR4oCdEAwEaAhCaB92XYAqigpju0eQYA9RF/y6RaU9TNKe3grwrlT
         cNi+enibsSCktzNZVDkPM1til+2R1vr/miJ4gdtdQ57UwMzb4dzDdXuVIC4OZyku189x
         beQ9w81I58ATBWy+BxEnJ4Pj4U+w/3AXwqlV907JU8yvrAEOX9AIDGEisCq/NFA3Tapt
         zIFmgML68fblh6i8sdO/fppkrmeGBy779jhu/d0WWKTs56yv1KKOdzZPh+b0fhXWqp+i
         xYXeoICKiN0yRaj6fE9INX5boejxKBGhwRGcMRuheBzrRafrJBRW8PZv9eDEJuypxkmY
         UjgQ==
X-Gm-Message-State: AOAM532rpx+8ASRhc8qypEn/rHzeKoY5+AXz/cmFyglgXzEHcVncmNq+
        zdkLUuMenOaT+dEwIYwcqVTazl1QGuwgN+ai
X-Google-Smtp-Source: ABdhPJzNRk/1XMSjihjeRuqYw1BmHpjGdQCGana0ENyrKt1CgDQEsxqFFcjoljjIMZPt5ACDKJSpnA==
X-Received: by 2002:a1c:4e0a:: with SMTP id g10mr9189731wmh.51.1607619075580;
        Thu, 10 Dec 2020 08:51:15 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:15:13:f693:9fff:fef4:2449])
        by smtp.gmail.com with ESMTPSA id m21sm10147726wml.13.2020.12.10.08.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 08:51:14 -0800 (PST)
Date:   Thu, 10 Dec 2020 17:51:08 +0100
From:   Marco Elver <elver@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Jann Horn <jannh@google.com>, Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com>
Subject: Re: WARNING in sk_stream_kill_queues (5)
Message-ID: <X9JR/J6dMMOy1obu@elver.google.com>
References: <000000000000b4862805b54ef573@google.com>
 <X8kLG5D+j4rT6L7A@elver.google.com>
 <CANn89iJWD5oXPLgtY47umTgo3gCGBaoy+XJfXnw1ecES_EXkCw@mail.gmail.com>
 <CANpmjNOaWbGJQ5Y=qC3cA31-R-Jy4Fbe+p=OBG5O2Amz8dLtLA@mail.gmail.com>
 <CANn89iKWf1EVZUuAHup+5ndhxvOqGopq53=vZ9yeok=DnRjggg@mail.gmail.com>
 <X8kjPIrLJUd8uQIX@elver.google.com>
 <af884a0e-5d4d-f71b-4821-b430ac196240@gmail.com>
 <CANpmjNNDKm_ObRnO_b3gH6wDYjb6_ex-KhZA5q5BRzEMgo+0xg@mail.gmail.com>
 <X9DHa2OG6lewtfPQ@elver.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9DHa2OG6lewtfPQ@elver.google.com>
User-Agent: Mutt/2.0.2 (2020-11-20)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 01:47PM +0100, Marco Elver wrote:
> On Tue, Dec 08, 2020 at 08:06PM +0100, Marco Elver wrote:
> > On Thu, 3 Dec 2020 at 19:01, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > On 12/3/20 6:41 PM, Marco Elver wrote:
> > >
> > > > One more experiment -- simply adding
> > > >
> > > > --- a/net/core/skbuff.c
> > > > +++ b/net/core/skbuff.c
> > > > @@ -207,7 +207,21 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
> > > >        */
> > > >       size = SKB_DATA_ALIGN(size);
> > > >       size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > > > +     size = 1 << kmalloc_index(size); /* HACK */
> > > >       data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
> > > >
> > > >
> > > > also got rid of the warnings. Something must be off with some value that
> > > > is computed in terms of ksize(). If not, I don't have any explanation
> > > > for why the above hides the problem.
> > >
> > > Maybe the implementations of various macros (SKB_DATA_ALIGN and friends)
> > > hae some kind of assumptions, I will double check this.
> > 
> > If I force kfence to return 4K sized allocations for everything, the
> > warnings remain. That might suggest that it's not due to a missed
> > ALIGN.
> > 
> > Is it possible that copies or moves are a problem? E.g. we copy
> > something from kfence -> non-kfence object (or vice-versa), and
> > ksize() no longer matches, then things go wrong?
> 
> I was able to narrow it down to allocations of size 640. I also narrowed
> it down to 5 allocations that go through kfence that start triggering
> the issue. I have attached the list of those 5 allocations with
> allocation + free stacks. I'll try to go through them, maybe I get
> lucky eventually. :-)

[...]

> kfence-#3 [0xffff88843681ac00-0xffff88843681ae7f, size=640, cache=kmalloc-1k] allocated by task 17012:
>  __kmalloc_reserve net/core/skbuff.c:142 [inline]
>  __alloc_skb+0xb8/0x3f0 net/core/skbuff.c:210
>  alloc_skb_fclone include/linux/skbuff.h:1144 [inline]
>  sk_stream_alloc_skb+0xd3/0x650 net/ipv4/tcp.c:888
>  tso_fragment net/ipv4/tcp_output.c:2124 [inline]
>  tcp_write_xmit+0x1366/0x3510 net/ipv4/tcp_output.c:2674
>  __tcp_push_pending_frames+0x68/0x1f0 net/ipv4/tcp_output.c:2866
>  tcp_push_pending_frames include/net/tcp.h:1864 [inline]
>  tcp_data_snd_check net/ipv4/tcp_input.c:5374 [inline]
>  tcp_rcv_established+0x57c/0x10b0 net/ipv4/tcp_input.c:5869
>  tcp_v4_do_rcv+0x361/0x4c0 net/ipv4/tcp_ipv4.c:1668
>  sk_backlog_rcv include/net/sock.h:1010 [inline]
>  __release_sock+0xd7/0x260 net/core/sock.c:2523
>  release_sock+0x40/0x120 net/core/sock.c:3053
>  sk_wait_data+0x127/0x2b0 net/core/sock.c:2565
>  tcp_recvmsg+0x1106/0x1b60 net/ipv4/tcp.c:2181
>  inet_recvmsg+0xb1/0x270 net/ipv4/af_inet.c:848
>  sock_recvmsg_nosec net/socket.c:885 [inline]
>  sock_recvmsg net/socket.c:903 [inline]
>  sock_recvmsg net/socket.c:899 [inline]
>  ____sys_recvmsg+0x2fd/0x3a0 net/socket.c:2563
>  ___sys_recvmsg+0xd9/0x1b0 net/socket.c:2605
>  __sys_recvmsg+0x8b/0x130 net/socket.c:2641
>  __do_sys_recvmsg net/socket.c:2651 [inline]
>  __se_sys_recvmsg net/socket.c:2648 [inline]
>  __x64_sys_recvmsg+0x43/0x50 net/socket.c:2648
>  do_syscall_64+0x34/0x80 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9

So I started putting gdb to work, and whenever I see an allocation
exactly like the above that goes through tso_fragment() a warning
immediately follows.

Long story short, I somehow synthesized this patch that appears to fix
things, but I can't explain why exactly:

| --- a/net/core/skbuff.c
| +++ b/net/core/skbuff.c
| @@ -1679,13 +1679,6 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
|  
|  	skb_metadata_clear(skb);
|  
| -	/* It is not generally safe to change skb->truesize.
| -	 * For the moment, we really care of rx path, or
| -	 * when skb is orphaned (not attached to a socket).
| -	 */
| -	if (!skb->sk || skb->destructor == sock_edemux)
| -		skb->truesize += size - osize;
| -
|  	return 0;
|  
|  nofrags:

Now, here are the breadcrumbs I followed:


1. 	Breakpoint on kfence_ksize() -- first allocation that matches the above:

	| #0  __kfence_ksize (s=18446612700164612096) at mm/kfence/core.c:726
	| #1  0xffffffff816fbf30 in kfence_ksize (addr=0xffff888436856000) at mm/kfence/core.c:737
	| #2  0xffffffff816217cf in ksize (objp=0xffff888436856000) at mm/slab_common.c:1178
	| #3  0xffffffff84896911 in __alloc_skb (size=914710528, gfp_mask=2592, flags=0, node=-1) at net/core/skbuff.c:217
	| #4  0xffffffff84d0ba73 in alloc_skb_fclone (priority=<optimized out>, size=<optimized out>) at ./include/linux/skbuff.h:1144
	| #5  sk_stream_alloc_skb (sk=0xffff8881176cc000, size=0, gfp=2592, force_schedule=232) at net/ipv4/tcp.c:888
	| #6  0xffffffff84d41c36 in tso_fragment (gfp=<optimized out>, mss_now=<optimized out>, len=<optimized out>,
	|     skb=<optimized out>, sk=<optimized out>) at net/ipv4/tcp_output.c:2124
	| #7  tcp_write_xmit (sk=0xffff8881176cc000, mss_now=21950, nonagle=3096, push_one=-1996874776, gfp=0)
	|     at net/ipv4/tcp_output.c:2674
	| #8  0xffffffff84d43e48 in __tcp_push_pending_frames (sk=0xffff8881176cc000, cur_mss=337, nonagle=0)
	|     at ./include/net/sock.h:918
	| #9  0xffffffff84d3259c in tcp_push_pending_frames (sk=<optimized out>) at ./include/net/tcp.h:1864
	| #10 tcp_data_snd_check (sk=<optimized out>) at net/ipv4/tcp_input.c:5374
	| #11 tcp_rcv_established (sk=0xffff8881176cc000, skb=0x0 <fixed_percpu_data>) at net/ipv4/tcp_input.c:5869
	| #12 0xffffffff84d56731 in tcp_v4_do_rcv (sk=0xffff8881176cc000, skb=0xffff888117f52ea0) at net/ipv4/tcp_ipv4.c:1668
	| [...]	

	Set watchpoint on skb->truesize:

	| (gdb) frame 3
	| #3  0xffffffff84896911 in __alloc_skb (size=914710528, gfp_mask=2592, flags=0, node=-1) at net/core/skbuff.c:217
	| 217             size = SKB_WITH_OVERHEAD(ksize(data));
	| (gdb) p &skb->truesize
	| $5 = (unsigned int *) 0xffff888117f55f90
	| (gdb) awatch *0xffff888117f55f90
	| Hardware access (read/write) watchpoint 6: *0xffff888117f55f90

2. 	Some time later, we see that the skb with kfence-allocated data
	is cloned:

	| Thread 7 hit Hardware access (read/write) watchpoint 6: *0xffff888117f55f90
	|
	| Value = 1570
	| 0xffffffff84886947 in __skb_clone (n=0xffff888117f55fa0, skb=0xffff888117f55ec0) at net/core/skbuff.c:1002
	| 1002            C(truesize);
	| (gdb) bt
	| #0  0xffffffff84886947 in __skb_clone (n=0xffff888117f55fa0, skb=0xffff888117f55ec0) at net/core/skbuff.c:1002
	| #1  0xffffffff8488bfb9 in skb_clone (skb=0xffff888117f55ec0, gfp_mask=2592) at net/core/skbuff.c:1454
	| #2  0xffffffff84d3cd1c in __tcp_transmit_skb (sk=0xffff8881176cc000, skb=0xffff888117f55ec0, clone_it=0, gfp_mask=2592,
	|     rcv_nxt=0) at net/ipv4/tcp_output.c:1267
	| #3  0xffffffff84d4125b in tcp_transmit_skb (gfp_mask=<optimized out>, clone_it=<optimized out>, skb=<optimized out>,
	|     sk=<optimized out>) at ./include/linux/tcp.h:439
	| #4  tcp_write_xmit (sk=0xffff8881176cc000, mss_now=392485600, nonagle=1326, push_one=-1996875104, gfp=0)
	|     at net/ipv4/tcp_output.c:2688
	| #5  0xffffffff84d43e48 in __tcp_push_pending_frames (sk=0xffff8881176cc000, cur_mss=337, nonagle=0)
	|     at ./include/net/sock.h:918
	| #6  0xffffffff84d3259c in tcp_push_pending_frames (sk=<optimized out>) at ./include/net/tcp.h:1864
	| #7  tcp_data_snd_check (sk=<optimized out>) at net/ipv4/tcp_input.c:5374
	| #8  tcp_rcv_established (sk=0xffff8881176cc000, skb=0x0 <fixed_percpu_data>) at net/ipv4/tcp_input.c:5869
	| #9  0xffffffff84d56731 in tcp_v4_do_rcv (sk=0xffff8881176cc000, skb=0xffff888117f57820) at net/ipv4/tcp_ipv4.c:1668
	| #10 0xffffffff8487bf67 in sk_backlog_rcv (skb=<optimized out>, sk=<optimized out>) at ./include/net/sock.h:1010
	[...]


3. 	The original skb (that was cloned) has its truesize adjusted
	after a pskb_expand_head():

	| Thread 2 hit Hardware access (read/write) watchpoint 6: *0xffff888117f55f90
	| 
	| Old value = 1570
	| New value = 1954

	^^ the difference between the old and the new value is exactly
	384, which is also the final underflow of the sk_wmem_queued
	that triggers the warning. Presumably if the original allocation
	had been through kmalloc-1k and not KFENCE, the difference here
	would have been 0, since ksize() of the original allocation in
	step (1) would have been 1024, and not 640 (difference of 384).

	| 0xffffffff8488d84b in pskb_expand_head (skb=0xffff888117f55ec0, nhead=401956752, ntail=1954, gfp_mask=2298092192)
	|     at net/core/skbuff.c:1687
	| 1687                    skb->truesize += size - osize;
	| (gdb) bt
	| #0  0xffffffff8488d84b in pskb_expand_head (skb=0xffff888117f55ec0, nhead=401956752, ntail=1954, gfp_mask=2298092192)
	|     at net/core/skbuff.c:1687
	| #1  0xffffffff8488de01 in skb_prepare_for_shift (skb=<optimized out>) at ./arch/x86/include/asm/atomic.h:29
	| #2  skb_prepare_for_shift (skb=0xffff888117f55ec0) at net/core/skbuff.c:3276
	| #3  0xffffffff848936b1 in skb_shift (tgt=0xffff888117f549c0, skb=0xffff888117f55ec0, shiftlen=674) at net/core/skbuff.c:3351
	| #4  0xffffffff84d264de in tcp_skb_shift (shiftlen=<optimized out>, pcount=<optimized out>, from=<optimized out>,
	|     to=<optimized out>) at net/ipv4/tcp_input.c:1497
	| #5  tcp_shift_skb_data (dup_sack=<optimized out>, end_seq=<optimized out>, start_seq=<optimized out>, state=<optimized out>,
	|     skb=<optimized out>, sk=<optimized out>) at net/ipv4/tcp_input.c:1605
	| #6  tcp_sacktag_walk (skb=0xffff888117f55ec0, sk=0xffff8881176cc000, next_dup=0x894,
	|     state=0xffffffff88fa1aa0 <watchpoints+192>, start_seq=0, end_seq=401956752, dup_sack_in=false)
	|     at net/ipv4/tcp_input.c:1670
	| #7  0xffffffff84d276de in tcp_sacktag_write_queue (sk=0xffff888117f55f90, ack_skb=0x1888117f55f90, prior_snd_una=2196,
	|     state=0xffffffff88fa1aa0 <watchpoints+192>) at net/ipv4/tcp_input.c:1931
	| #8  0xffffffff84d2ca1d in tcp_ack (sk=0xffff8881176cc000, skb=0x1888117f55f90, flag=16643) at net/ipv4/tcp_input.c:3758
	| #9  0xffffffff84d32387 in tcp_rcv_established (sk=0xffff8881176cc000, skb=0xffff888117f54020) at net/ipv4/tcp_input.c:5858
	| #10 0xffffffff84d56731 in tcp_v4_do_rcv (sk=0xffff8881176cc000, skb=0xffff888117f54020) at net/ipv4/tcp_ipv4.c:1668
	[...]


Any of this make sense?

Thanks,
-- Marco
