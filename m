Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEF42D65D3
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 20:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393227AbgLJTCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 14:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390488AbgLJTCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 14:02:34 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BC6C0613D6
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 11:01:53 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id o11so5920951ote.4
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 11:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rx1msOfEbSyJS7cDx0/C400tSkHwuFCIEJM5sstvA4Q=;
        b=hxa5l26RAYKPmcwdGaSAsHOP7HN8acPuE7KxU8p/M13QmkBQMnx5NQSQEQ4DC9j7O+
         KFIJY/EG+lA0H1sUAlk9s3Ivg/1cgGO6tHWhRI79EXXpVHb1TQCxqIQfVUzACsPXgwlE
         bi8ktcScXiLW+aFr9rNwO71AtITLQuxbaboHEUkLR+y7NBtLIPhQz3yP18AwMADd0QRy
         nQ09oZf8fMBf6DWNscLBvMsbXVQyYKAhFwNZbBWbphQ2e6n/Ai2mMYMxaeH9fN1RN0mw
         twIweOFSAjuAFDPiU76wkqMzIU6wUZh7QrOHS3smMiJirkPjdU542XvIx9WvVCs4fZ/K
         rWvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rx1msOfEbSyJS7cDx0/C400tSkHwuFCIEJM5sstvA4Q=;
        b=TWOseBrzcW1XL6zHTCFAxCuCxb8V7cKaxUPNmG+E7sZ6hwFrmzoQltV8v0F8dIkqRl
         765LE4dGgOYCNjJaJWCfz8bWYNoHX9YxxtoTLsjSifFUVYs0vkKLwAGXjGGUflt8wmWA
         0OEFwfZgrJDoobOkvqJEM9Um4MCes86w60epBeDGQo7bnpE/iodR+eOOCJjPJB8d5Bbj
         iKTcnJpxldPMFIVDykAANGAKzzA17v3FpaK1Rrk1hlLg942XJi/xWz8JWsqquR75owy/
         Ci6H2ziQwe2ysPw7zL4Q/IZAQfGTlQCwHPND0YE2UAfRw3D9/uOW+UbjyUsphG09sWKA
         jloQ==
X-Gm-Message-State: AOAM530DLhXvvhq2ocEAcJoZW5zFzl5ruVrIq3JXDgJEMU0vOMh8qIcl
        o6i/pHPRZ8JKnLPl6ymRIIsfiSNmGnYVveHrVrwEzg==
X-Google-Smtp-Source: ABdhPJwG5+R2DIjQG+IG6LfB+23B9BthxPXL4XVHax2aft3b4QMixxgEJmhOwkBRJPSS5R5RgJ63Z6GrzvoEvzAzCOI=
X-Received: by 2002:a9d:6317:: with SMTP id q23mr7124580otk.251.1607626912981;
 Thu, 10 Dec 2020 11:01:52 -0800 (PST)
MIME-Version: 1.0
References: <000000000000b4862805b54ef573@google.com> <X8kLG5D+j4rT6L7A@elver.google.com>
 <CANn89iJWD5oXPLgtY47umTgo3gCGBaoy+XJfXnw1ecES_EXkCw@mail.gmail.com>
 <CANpmjNOaWbGJQ5Y=qC3cA31-R-Jy4Fbe+p=OBG5O2Amz8dLtLA@mail.gmail.com>
 <CANn89iKWf1EVZUuAHup+5ndhxvOqGopq53=vZ9yeok=DnRjggg@mail.gmail.com>
 <X8kjPIrLJUd8uQIX@elver.google.com> <af884a0e-5d4d-f71b-4821-b430ac196240@gmail.com>
 <CANpmjNNDKm_ObRnO_b3gH6wDYjb6_ex-KhZA5q5BRzEMgo+0xg@mail.gmail.com>
 <X9DHa2OG6lewtfPQ@elver.google.com> <X9JR/J6dMMOy1obu@elver.google.com> <CANn89i+2mAu_srdvefKLDY23HvrbOG1aMfj5uwvk6tYZ9uBtMA@mail.gmail.com>
In-Reply-To: <CANn89i+2mAu_srdvefKLDY23HvrbOG1aMfj5uwvk6tYZ9uBtMA@mail.gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Thu, 10 Dec 2020 20:01:40 +0100
Message-ID: <CANpmjNMdgX1H=ztDH5cpmmZJ3duL4M8Vn9Ty-XzNpsrhx0h4sA@mail.gmail.com>
Subject: Re: WARNING in sk_stream_kill_queues (5)
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Dec 2020 at 18:14, Eric Dumazet <edumazet@google.com> wrote:
> On Thu, Dec 10, 2020 at 5:51 PM Marco Elver <elver@google.com> wrote:
[...]
> > So I started putting gdb to work, and whenever I see an allocation
> > exactly like the above that goes through tso_fragment() a warning
> > immediately follows.
> >
> > Long story short, I somehow synthesized this patch that appears to fix
> > things, but I can't explain why exactly:
> >
> > | --- a/net/core/skbuff.c
> > | +++ b/net/core/skbuff.c
> > | @@ -1679,13 +1679,6 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
> > |
> > |       skb_metadata_clear(skb);
> > |
> > | -     /* It is not generally safe to change skb->truesize.
> > | -      * For the moment, we really care of rx path, or
> > | -      * when skb is orphaned (not attached to a socket).
> > | -      */
> > | -     if (!skb->sk || skb->destructor == sock_edemux)
> > | -             skb->truesize += size - osize;
> > | -
> > |       return 0;
> > |
> > |  nofrags:
> >
> > Now, here are the breadcrumbs I followed:
> >
> >
> > 1.      Breakpoint on kfence_ksize() -- first allocation that matches the above:
> >
> >         | #0  __kfence_ksize (s=18446612700164612096) at mm/kfence/core.c:726
> >         | #1  0xffffffff816fbf30 in kfence_ksize (addr=0xffff888436856000) at mm/kfence/core.c:737
> >         | #2  0xffffffff816217cf in ksize (objp=0xffff888436856000) at mm/slab_common.c:1178
> >         | #3  0xffffffff84896911 in __alloc_skb (size=914710528, gfp_mask=2592, flags=0, node=-1) at net/core/skbuff.c:217
> >         | #4  0xffffffff84d0ba73 in alloc_skb_fclone (priority=<optimized out>, size=<optimized out>) at ./include/linux/skbuff.h:1144
> >         | #5  sk_stream_alloc_skb (sk=0xffff8881176cc000, size=0, gfp=2592, force_schedule=232) at net/ipv4/tcp.c:888
> >         | #6  0xffffffff84d41c36 in tso_fragment (gfp=<optimized out>, mss_now=<optimized out>, len=<optimized out>,
> >         |     skb=<optimized out>, sk=<optimized out>) at net/ipv4/tcp_output.c:2124
> >         | #7  tcp_write_xmit (sk=0xffff8881176cc000, mss_now=21950, nonagle=3096, push_one=-1996874776, gfp=0)
> >         |     at net/ipv4/tcp_output.c:2674
> >         | #8  0xffffffff84d43e48 in __tcp_push_pending_frames (sk=0xffff8881176cc000, cur_mss=337, nonagle=0)
> >         |     at ./include/net/sock.h:918
> >         | #9  0xffffffff84d3259c in tcp_push_pending_frames (sk=<optimized out>) at ./include/net/tcp.h:1864
> >         | #10 tcp_data_snd_check (sk=<optimized out>) at net/ipv4/tcp_input.c:5374
> >         | #11 tcp_rcv_established (sk=0xffff8881176cc000, skb=0x0 <fixed_percpu_data>) at net/ipv4/tcp_input.c:5869
> >         | #12 0xffffffff84d56731 in tcp_v4_do_rcv (sk=0xffff8881176cc000, skb=0xffff888117f52ea0) at net/ipv4/tcp_ipv4.c:1668
> >         | [...]
> >
> >         Set watchpoint on skb->truesize:
> >
> >         | (gdb) frame 3
> >         | #3  0xffffffff84896911 in __alloc_skb (size=914710528, gfp_mask=2592, flags=0, node=-1) at net/core/skbuff.c:217
> >         | 217             size = SKB_WITH_OVERHEAD(ksize(data));
> >         | (gdb) p &skb->truesize
> >         | $5 = (unsigned int *) 0xffff888117f55f90
> >         | (gdb) awatch *0xffff888117f55f90
> >         | Hardware access (read/write) watchpoint 6: *0xffff888117f55f90
> >
> > 2.      Some time later, we see that the skb with kfence-allocated data
> >         is cloned:
> >
> >         | Thread 7 hit Hardware access (read/write) watchpoint 6: *0xffff888117f55f90
> >         |
> >         | Value = 1570
> >         | 0xffffffff84886947 in __skb_clone (n=0xffff888117f55fa0, skb=0xffff888117f55ec0) at net/core/skbuff.c:1002
> >         | 1002            C(truesize);
> >         | (gdb) bt
> >         | #0  0xffffffff84886947 in __skb_clone (n=0xffff888117f55fa0, skb=0xffff888117f55ec0) at net/core/skbuff.c:1002
> >         | #1  0xffffffff8488bfb9 in skb_clone (skb=0xffff888117f55ec0, gfp_mask=2592) at net/core/skbuff.c:1454
> >         | #2  0xffffffff84d3cd1c in __tcp_transmit_skb (sk=0xffff8881176cc000, skb=0xffff888117f55ec0, clone_it=0, gfp_mask=2592,
> >         |     rcv_nxt=0) at net/ipv4/tcp_output.c:1267
> >         | #3  0xffffffff84d4125b in tcp_transmit_skb (gfp_mask=<optimized out>, clone_it=<optimized out>, skb=<optimized out>,
> >         |     sk=<optimized out>) at ./include/linux/tcp.h:439
> >         | #4  tcp_write_xmit (sk=0xffff8881176cc000, mss_now=392485600, nonagle=1326, push_one=-1996875104, gfp=0)
> >         |     at net/ipv4/tcp_output.c:2688
> >         | #5  0xffffffff84d43e48 in __tcp_push_pending_frames (sk=0xffff8881176cc000, cur_mss=337, nonagle=0)
> >         |     at ./include/net/sock.h:918
> >         | #6  0xffffffff84d3259c in tcp_push_pending_frames (sk=<optimized out>) at ./include/net/tcp.h:1864
> >         | #7  tcp_data_snd_check (sk=<optimized out>) at net/ipv4/tcp_input.c:5374
> >         | #8  tcp_rcv_established (sk=0xffff8881176cc000, skb=0x0 <fixed_percpu_data>) at net/ipv4/tcp_input.c:5869
> >         | #9  0xffffffff84d56731 in tcp_v4_do_rcv (sk=0xffff8881176cc000, skb=0xffff888117f57820) at net/ipv4/tcp_ipv4.c:1668
> >         | #10 0xffffffff8487bf67 in sk_backlog_rcv (skb=<optimized out>, sk=<optimized out>) at ./include/net/sock.h:1010
> >         [...]
> >
> >
> > 3.      The original skb (that was cloned) has its truesize adjusted
> >         after a pskb_expand_head():
> >
> >         | Thread 2 hit Hardware access (read/write) watchpoint 6: *0xffff888117f55f90
> >         |
> >         | Old value = 1570
> >         | New value = 1954
> >
> >         ^^ the difference between the old and the new value is exactly
> >         384, which is also the final underflow of the sk_wmem_queued
> >         that triggers the warning. Presumably if the original allocation
> >         had been through kmalloc-1k and not KFENCE, the difference here
> >         would have been 0, since ksize() of the original allocation in
> >         step (1) would have been 1024, and not 640 (difference of 384).
> >
> >         | 0xffffffff8488d84b in pskb_expand_head (skb=0xffff888117f55ec0, nhead=401956752, ntail=1954, gfp_mask=2298092192)
> >         |     at net/core/skbuff.c:1687
> >         | 1687                    skb->truesize += size - osize;
> >         | (gdb) bt
> >         | #0  0xffffffff8488d84b in pskb_expand_head (skb=0xffff888117f55ec0, nhead=401956752, ntail=1954, gfp_mask=2298092192)
> >         |     at net/core/skbuff.c:1687
> >         | #1  0xffffffff8488de01 in skb_prepare_for_shift (skb=<optimized out>) at ./arch/x86/include/asm/atomic.h:29
> >         | #2  skb_prepare_for_shift (skb=0xffff888117f55ec0) at net/core/skbuff.c:3276
> >         | #3  0xffffffff848936b1 in skb_shift (tgt=0xffff888117f549c0, skb=0xffff888117f55ec0, shiftlen=674) at net/core/skbuff.c:3351
> >         | #4  0xffffffff84d264de in tcp_skb_shift (shiftlen=<optimized out>, pcount=<optimized out>, from=<optimized out>,
> >         |     to=<optimized out>) at net/ipv4/tcp_input.c:1497
> >         | #5  tcp_shift_skb_data (dup_sack=<optimized out>, end_seq=<optimized out>, start_seq=<optimized out>, state=<optimized out>,
> >         |     skb=<optimized out>, sk=<optimized out>) at net/ipv4/tcp_input.c:1605
> >         | #6  tcp_sacktag_walk (skb=0xffff888117f55ec0, sk=0xffff8881176cc000, next_dup=0x894,
> >         |     state=0xffffffff88fa1aa0 <watchpoints+192>, start_seq=0, end_seq=401956752, dup_sack_in=false)
> >         |     at net/ipv4/tcp_input.c:1670
> >         | #7  0xffffffff84d276de in tcp_sacktag_write_queue (sk=0xffff888117f55f90, ack_skb=0x1888117f55f90, prior_snd_una=2196,
> >         |     state=0xffffffff88fa1aa0 <watchpoints+192>) at net/ipv4/tcp_input.c:1931
> >         | #8  0xffffffff84d2ca1d in tcp_ack (sk=0xffff8881176cc000, skb=0x1888117f55f90, flag=16643) at net/ipv4/tcp_input.c:3758
> >         | #9  0xffffffff84d32387 in tcp_rcv_established (sk=0xffff8881176cc000, skb=0xffff888117f54020) at net/ipv4/tcp_input.c:5858
> >         | #10 0xffffffff84d56731 in tcp_v4_do_rcv (sk=0xffff8881176cc000, skb=0xffff888117f54020) at net/ipv4/tcp_ipv4.c:1668
> >         [...]
> >
> >
> > Any of this make sense?
>
> Very nice debugging !
>
> I guess we could fix this in skb_prepare_for_shift(), eventually
> caring for the truesize manipulation
> (or reverting the change done in pskb_expand_head(), since only kfence
> is having this issue.

Phew, good to hear I finally got lucky. :-)

Either option is fine, as long as it avoids this problem in future.
Hopefully it can be fixed for 5.11.

> (All TCP skbs in output path have the same allocation size for skb->head)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index e578544b2cc7110ec2f6bcf4c29d93e4b4b1ad14..798b51eeeaa4fbed65d41d9eab207dbbf438dab3
> 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3270,7 +3270,14 @@ EXPORT_SYMBOL(skb_split);
>   */
>  static int skb_prepare_for_shift(struct sk_buff *skb)
>  {
> -       return skb_cloned(skb) && pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
> +       unsigned int ret = 0, save;
> +
> +       if (skb_cloned(skb)) {
> +               save = skb->truesize;
> +               ret = pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
> +               skb->truesize = save;
> +       }
> +       return ret;
>  }

FWIW,

    Tested-by: Marco Elver <elver@google.com>

Thanks,
-- Marco
