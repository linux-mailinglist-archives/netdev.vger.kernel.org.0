Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B2BE8F9B
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 19:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732145AbfJ2Syo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 14:54:44 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:34687 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728181AbfJ2Syo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 14:54:44 -0400
Received: by mail-yw1-f65.google.com with SMTP id d192so5474167ywa.1
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 11:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tCsM+F3miCULt/gY/WW+4RJNfi/IOoW/fMArF9UpILY=;
        b=ru0cYWorNDdiOUsvnCXXT6N0xwGju4hHLZXWLSBNouMFRwoVfVkRjEtClV4vKKtOEg
         P++rvn1eLsUgN6xEkW7PSy/kPkJuyc0E5+nZ4XXrAhkrqoQN0xi4uCg80uZlcPjE0JTF
         IdONUykHltfyebRKgJb8PjvS961cdnsp/Ruz0Dh7VYHrdDqzJBJFUnPdBADf/O6M2zL7
         l/F0HxNFacsBg4v2wyBmLfx0TA+vdIjG1jqteT3tkLqPZ7uZ5bb9NR/nEJTg4gE6axIk
         u1eUfXYNc3ONt0oBvr/x/3qZtMSNR4U1akg9hnuaRuBwoIKMk6sDG1AdycJEtcQ1jiJd
         ehnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tCsM+F3miCULt/gY/WW+4RJNfi/IOoW/fMArF9UpILY=;
        b=jY/f74u+5hORuswhfFhpToPUZxKmWTteyPmb4oziNlYTqg1awHuKQnsGSC/6RBP0ab
         P+MyNqBO+RarfIYDD1jT9+CXSdqc+/4pYEs9EeJ/vipM9KnxTmsiXZMYhhU3+KYLa/wI
         g0lKk8rY4I6GCUMYDexSlnVrPRumxIDBPol4pDvJRVvtDKvkD8Z1k8yc8HEy/8k7+efa
         +R02rNQH/4+TTZMBo5Qa4Z2RYF9ZALuq7ztBa86xdlnvsTWN4Xop+J+N2s+kQLgfP7Tz
         eLk2Hg3AdhN+8AmVzvmb25i9ZsBKgDj8qEJ/fXznXDVyuSD5PPuiIGJ6mifoqGOQjXMA
         CH5A==
X-Gm-Message-State: APjAAAXaHH3afXrIz5HrMec4EWeS2luOi4k4qD3jFOycPapSl6aYDp92
        AQwF2aHgcvGzYzD1VauGZCtsmFoTWpcjPjEbQ3iD7Q==
X-Google-Smtp-Source: APXvYqwFzfPIgmgqEPumA5fHRTkZflCMijOYJlhUg5Ram1iEuur13Yu8woZoXqPTlVKUxA8M5/BISOjxGOX3B4FOHsQ=
X-Received: by 2002:a0d:df17:: with SMTP id i23mr16847892ywe.92.1572375282397;
 Tue, 29 Oct 2019 11:54:42 -0700 (PDT)
MIME-Version: 1.0
References: <CABWYdi1QmrHxNZT_DK4A2WUoj=r1+wxSngzaaTuGCatHisaTRw@mail.gmail.com>
 <CANn89iLE-3zxROxGOusPBRmQL4oN2Nqtg3rqXnpO8bkiFAw8EQ@mail.gmail.com>
 <CABWYdi2Eq30vEKKYxr-diofpeATNXiB3ZYKL6Q15y10w+vsCLg@mail.gmail.com>
 <CANn89iJYKurw-3-EooE9qyM8-2MzQvCz8qdV91J1hVNxXwsyng@mail.gmail.com>
 <CABWYdi0nmGE6Y+iUkfGvR07zU640Fu4op4EXbCp6ou6GJMcfww@mail.gmail.com> <CANn89iKvLFDHPU2W86TfC7jNFW8HM5o8tE8wiRc7E=CRXLT=-Q@mail.gmail.com>
In-Reply-To: <CANn89iKvLFDHPU2W86TfC7jNFW8HM5o8tE8wiRc7E=CRXLT=-Q@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 29 Oct 2019 11:54:31 -0700
Message-ID: <CANn89i+uxbxB8vTWXhOuW4-weP-NO2yFbbs15cJh7+BJtjSSkA@mail.gmail.com>
Subject: Re: fq dropping packets between vlan and ethernet interfaces
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 11:41 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Oct 29, 2019 at 11:35 AM Ivan Babrou <ivan@cloudflare.com> wrote:
> >
> > 5.4-rc5 has it, but we still experience the issue.
>
> Please refrain from top-posting on netdev@
>
> You could try the debug patch I have posted earlier.
>
> Something like :
>
> diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
> index 98dd87ce15108cfe1c011da44ba32f97763776c8..2b9697e05115d334fd6d3a2909d5112d04032420
> 100644
> --- a/net/sched/sch_fq.c
> +++ b/net/sched/sch_fq.c
> @@ -380,9 +380,14 @@ static void flow_queue_add(struct fq_flow *flow,
> struct sk_buff *skb)
>  {
>         struct rb_node **p, *parent;
>         struct sk_buff *head, *aux;
> +       u64 now = ktime_get_ns();
>
> -       fq_skb_cb(skb)->time_to_send = skb->tstamp ?: ktime_get_ns();
> -
> +       if (skb->tstamp) {
> +               WARN_ON_ONCE(skb->tstamp - now > 30LLU * NSEC_PER_SEC);

Probably needs to use s64 as in :

WARN_ON_ONCE((s64)(skb->tstamp - now) > (s64)(30LLU * NSEC_PER_SEC));

> +               fq_skb_cb(skb)->time_to_send = skb->tstamp;
> +       } else {
> +               fq_skb_cb(skb)->time_to_send = now;
> +       }
>         head = flow->head;
>         if (!head ||
>             fq_skb_cb(skb)->time_to_send >=
> fq_skb_cb(flow->tail)->time_to_send) {
>
>
> >
> > On Tue, Oct 29, 2019 at 11:33 AM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Tue, Oct 29, 2019 at 11:31 AM Ivan Babrou <ivan@cloudflare.com> wrote:
> > > >
> > > > I'm on 5.4-rc5. Let me apply e7a409c3f46cb0dbc7bfd4f6f9421d53e92614a5
> > > > on top and report back to you.
> > >
> > >
> > > Oops, wrong copy/paste. I really meant this one :
> > >
> > > 9669fffc1415bb0c30e5d2ec98a8e1c3a418cb9c net: ensure correct
> > > skb->tstamp in various fragmenters
> > >
> > >
> > > >
> > > > On Tue, Oct 29, 2019 at 11:27 AM Eric Dumazet <edumazet@google.com> wrote:
> > > > >
> > > > > On Tue, Oct 29, 2019 at 11:20 AM Ivan Babrou <ivan@cloudflare.com> wrote:
> > > > > >
> > > > > > Hello,
> > > > > >
> > > > > > We're trying to test Linux 5.4 early and hit an issue with FQ.
> > > > > >
> > > > > > The relevant part of our network setup involves four interfaces:
> > > > > >
> > > > > > * ext0 (ethernet, internet facing)
> > > > > > * vlan101@ext0 (vlan)
> > > > > > * int0 (ethernet, lan facing)
> > > > > > * vlan11@int0 (vlan)
> > > > > >
> > > > > > Both int0 and ext0 have fq on them:
> > > > > >
> > > > > > qdisc fq 1: dev ext0 root refcnt 65 limit 10000p flow_limit 100p
> > > > > > buckets 1024 orphan_mask 1023 quantum 3228 initial_quantum 16140
> > > > > > low_rate_threshold 550Kbit refill_delay 40.0ms
> > > > > > qdisc fq 8003: dev int0 root refcnt 65 limit 10000p flow_limit 100p
> > > > > > buckets 1024 orphan_mask 1023 quantum 3028 initial_quantum 15140
> > > > > > low_rate_threshold 550Kbit refill_delay 40.0ms
> > > > > >
> > > > > > The issue itself is that after some time ext0 stops feeding off
> > > > > > vlan101, which is visible as tcpdump not seeing packets on ext0, while
> > > > > > they flow over vlan101.
> > > > > >
> > > > > > I can see that fq_dequeue does not report any packets:
> > > > > >
> > > > > > $ sudo perf record -e qdisc:qdisc_dequeue -aR sleep 1
> > > > > > hping3 40335 [006] 63920.881016: qdisc:qdisc_dequeue: dequeue
> > > > > > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > > > > > packets=0 skbaddr=(nil)
> > > > > > hping3 40335 [006] 63920.881030: qdisc:qdisc_dequeue: dequeue
> > > > > > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > > > > > packets=0 skbaddr=(nil)
> > > > > > hping3 40335 [006] 63920.881041: qdisc:qdisc_dequeue: dequeue
> > > > > > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > > > > > packets=0 skbaddr=(nil)
> > > > > > hping3 40335 [006] 63920.881070: qdisc:qdisc_dequeue: dequeue
> > > > > > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > > > > > packets=0 skbaddr=(nil)
> > > > > >
> > > > > > Inside of fq_dequeue I'm able to see that we throw away packets in here:
> > > > > >
> > > > > > * https://elixir.bootlin.com/linux/v5.4-rc2/source/net/sched/sch_fq.c#L510
> > > > > >
> > > > > > The output of tc -s qdisc shows the following:
> > > > > >
> > > > > > qdisc fq 1: dev ext0 root refcnt 65 limit 10000p flow_limit 100p
> > > > > > buckets 1024 orphan_mask 1023 quantum 3228 initial_quantum 16140
> > > > > > low_rate_threshold 550Kbit refill_delay 40.0ms
> > > > > >  Sent 4872143400 bytes 8448638 pkt (dropped 201276670, overlimits 0
> > > > > > requeues 103)
> > > > > >  backlog 779376b 10000p requeues 103
> > > > > >   2806 flows (2688 inactive, 118 throttled), next packet delay
> > > > > > 1572240566653952889 ns
> > > > > >   354201 gc, 0 highprio, 804560 throttled, 3919 ns latency, 19492 flows_plimit
> > > > > > qdisc fq 8003: dev int0 root refcnt 65 limit 10000p flow_limit 100p
> > > > > > buckets 1024 orphan_mask 1023 quantum 3028 initial_quantum 15140
> > > > > > low_rate_threshold 550Kbit refill_delay 40.0ms
> > > > > >  Sent 15869093876 bytes 17387110 pkt (dropped 0, overlimits 0 requeues 2817)
> > > > > >  backlog 0b 0p requeues 2817
> > > > > >   2047 flows (2035 inactive, 0 throttled)
> > > > > >   225074 gc, 10 highprio, 102308 throttled, 7525 ns latency
> > > > > >
> > > > > > The key part here is probably that next packet delay for ext0 is the
> > > > > > current unix timestamp in nanoseconds. Naturally, we see this code
> > > > > > path being executed:
> > > > > >
> > > > > > * https://elixir.bootlin.com/linux/v5.4-rc2/source/net/sched/sch_fq.c#L462
> > > > > >
> > > > > > Unfortunately, I don't have a reliable reproduction for this issue. It
> > > > > > appears naturally with some traffic and I can do limited tracing with
> > > > > > perf and bcc tools while running hping3 to generate packets.
> > > > > >
> > > > > > The issue goes away if I replace fq with pfifo_fast on ext0.
> > > > >
> > > > > At which commit is your tree  precisely ?
> > > > >
> > > > > This sounds like the recent fix we had for fragmented packets.
> > > > >
> > > > > e7a409c3f46cb0dbc7bfd4f6f9421d53e92614a5 ipv4: fix IPSKB_FRAG_PMTU
> > > > > handling with fragmentation
