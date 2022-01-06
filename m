Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178AF486464
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238836AbiAFMcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiAFMcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 07:32:17 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EBCC061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 04:32:17 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso6807329pjm.4
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 04:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LbbHJnfFJa635LNHtwNypapWioSFVlnQx2kyNjrWm4E=;
        b=KYqP0kcBUcSvlLhrut8dRrSJSxD8FmuH7R45O2CUoeGPv2NiyDA0WaiIOCpAN7+wVL
         VMe0E5jd2sZ8I9+hvCFk+c4r4iXK5hDPdy3J7kO5xODJSdROF2rBeTJMOUUsOYqHZa3a
         8zK+IYr2XjfyO50kZiuVc3i2WwdkMMGsWZLJY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LbbHJnfFJa635LNHtwNypapWioSFVlnQx2kyNjrWm4E=;
        b=PW0+87Jlbg4T19/R0xPq+FBRXEdaDmC9uCZUKwJ2CWAPx3l/w660uLfHqPfppcZD5C
         t9ST6B4uxpCOcZdk4YVW0DhZAK+B3NU/gcF3NxhrxdRKQk13S0l9tSy7MYQZsMYW5Cld
         PYUb2TXhOqLtygxvIJoriE15zPmuCjLQoEuvZLRz25L7dK3WSRiCLLZFEeMPbcvH/QbO
         E+sDbNfoOVNLomAP1S/tnz+r6kvzZ8BRNYkTH2mfi84JvhJ6fUqC/R4S5W3kN0DCntPP
         dq1963JYnXK5RAhxTNQKSNBye0QzO6DenIIO/h/z2vD+c5FplgWTcEqNOFAbRHQWFWtu
         Qcjw==
X-Gm-Message-State: AOAM533rtJvmUrsQJZmu+MvmZnnSO5j9W+tzVuIfTsHq8KRzPLWjvwp0
        WOT1Y7M81Z/TB9rPHoE1PRFZIp5lJ5Nj4O3GacTmzw==
X-Google-Smtp-Source: ABdhPJzpBs//uHxEy1Y6b9A1PBKSNp3traSjdndLPLblh1LSQ2ada4lXL+T31sAFhrndnbnvRzwLzHK/3C1CVCMiBcE=
X-Received: by 2002:a17:90a:7e81:: with SMTP id j1mr6817950pjl.14.1641472336853;
 Thu, 06 Jan 2022 04:32:16 -0800 (PST)
MIME-Version: 1.0
References: <CA+wXwBRbLq6SW39qCD8GNG98YD5BJR2MFXmJV2zU1xwFjC-V0A@mail.gmail.com>
 <CANn89iLbKNkB9bzkA2nk+d2c6rq40-6-h9LXAVFCkub=T4BGsQ@mail.gmail.com>
In-Reply-To: <CANn89iLbKNkB9bzkA2nk+d2c6rq40-6-h9LXAVFCkub=T4BGsQ@mail.gmail.com>
From:   Daniel Dao <dqminh@cloudflare.com>
Date:   Thu, 6 Jan 2022 12:32:06 +0000
Message-ID: <CA+wXwBTQtzgsErFZZEUbEq=JMhdq-fF2OXJ7ztnnq6hPXs_L3Q@mail.gmail.com>
Subject: Re: Expensive tcp_collapse with high tcp_rmem limit
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Marek Majkowski <marek@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 5, 2022 at 1:38 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Jan 5, 2022 at 4:15 AM Daniel Dao <dqminh@cloudflare.com> wrote:
> >
> > Hello,
> >
> > We are looking at increasing the maximum value of TCP receive buffer in order
> > to take better advantage of high BDP links. For historical reasons (
> > https://blog.cloudflare.com/the-story-of-one-latency-spike/), this was set to
> > a lower than default value.
> >
> > We are still occasionally seeing long time spent in tcp_collapse, and the time
> > seems to be proportional with max rmem. For example, with net.ipv4.tcp_rmem = 8192 2097152 16777216,
> > we observe tcp_collapse latency with the following bpftrace command:
> >
>
> I suggest you add more traces, like the payload/truesize ratio when
> these events happen.
> and tp->rcv_ssthresh, sk->sk_rcvbuf
>
> TCP stack by default assumes a conservative [1] payload/truesize ratio of 50%

I forgot to add that for this experiment we also set tcp_adv_win_scale
= -2 to see if it
reduces the chance of triggering tcp_collapse

>
> Meaning that a 16MB sk->rcvbuf would translate to a TCP RWIN of 8MB.
>
> I suspect that you use XDP, and standard MTU=1500.
> Drivers in XDP mode use one page (4096 bytes on x86) per incoming frame.
> In this case, the ratio is ~1428/4096 = 35%
>
> This is one of the reason we switched to a 4K MTU at Google, because we
> have an effective ratio close to 100% (even if XDP was used)
>
> [1] The 50% ratio of TCP is defeated with small MSS, and malicious traffic.

I updated the bpftrace script to get data on len/truesize on collapsed skb

  kprobe:tcp_collapse {
    $sk = (struct sock *) arg0;
    $tp = (struct tcp_sock *) arg0;
    printf("tid %d: rmem_alloc=%ld sk_rcvbuf=%ld rcv_ssthresh=%ld\n", tid,
        $sk->sk_backlog.rmem_alloc.counter, $sk->sk_rcvbuf, $tp->rcv_ssthresh);
    printf("tid %d: advmss=%ld wclamp=%ld rcv_wnd=%ld\n", tid, $tp->advmss,
        $tp->window_clamp, $tp->rcv_wnd);
    @start[tid] = nsecs;
  }

  kretprobe:tcp_collapse /@start[tid] != 0/ {
    $us = (nsecs - @start[tid])/1000;
    @us = hist($us);
    printf("tid %d: %ld us\n", tid, $us);
    delete(@start[tid]);
  }

  kprobe:tcp_collapse_one {
    $skb = (struct sk_buff *) arg1;
    printf("tid %d: s=%ld len=%ld truesize=%ld\n", tid, sizeof(struct
sk_buff), $skb->len, $skb->truesize);
  }

  interval:s:6000 { exit(); }

Here is the output:

  tid 0: rmem_alloc=16780416 sk_rcvbuf=16777216 rcv_ssthresh=2920
  tid 0: advmss=1460 wclamp=4194304 rcv_wnd=450560
  tid 0: len=3316 truesize=15808
  tid 0: len=4106 truesize=16640
  tid 0: len=3967 truesize=16512
  tid 0: len=2988 truesize=15488
  ...
  tid 0: len=5279 truesize=17664
  tid 0: len=425 truesize=2048
  tid 0: 17176 us

The skb looks indeed bloated (len=3316, truesize=15808), so collapsing
definitely
helps. It just took a long time to go through thousands of 16KB skb

>
>
> >   bpftrace -e 'kprobe:tcp_collapse { @start[tid] = nsecs; } kretprobe:tcp_collapse /@start[tid] != 0/ { $us = (nsecs - @start[tid])/1000; @us = hist($us); delete(@start[tid]); printf("%ld us\n", $us);} interval:s:6000 { exit(); }'
> >   Attaching 3 probes...
> >   15496 us
> >   14301 us
> >   12248 us
> >   @us:
> >   [8K, 16K)              3 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
> >
> > Spending up to 16ms with 16MiB maximum receive buffer seems high.  Are there any
> > recommendations on possible approaches to reduce the tcp_collapse latency ?
> > Would clamping the duration of a tcp_collapse call be reasonable, since we only
> > need to spend enough time to free space to queue the required skb ?
>
> It depends if the incoming skb is queued in in-order queue or
> out-of-order queue.
> For out-of-orders, we have a strategy in tcp_prune_ofo_queue() which
> should work reasonably well after commit
> 72cd43ba64fc17 tcp: free batches of packets in tcp_prune_ofo_queue()
>
> Given the nature of tcp_collapse(), limiting it to even 1ms of processing time
> would still allow for malicious traffic to hurt you quite a lot.

I don't yet understand why we have cases of bloated skbs. But it seems
like adapting the
batch prune strategy in tcp_prune_ofo_queue() to tcp_collapse makes sense to me.

I think every collapsed skb saves us truesize - len (?), and we can
set goal to free up 12.5% of sk_rcvbuf
same as tcp_prune_ofo_queue()
