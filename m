Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9CCEE8F5C
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 19:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbfJ2Sfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 14:35:30 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42462 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfJ2Sf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 14:35:29 -0400
Received: by mail-qt1-f195.google.com with SMTP id z17so15047664qts.9
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 11:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qEA3yNEaGGRl9BKuKN3E5MZ7584xsnQwcKFnAhdENh4=;
        b=BAqeOKNcQ6F9fALhYv4eZ7KKhPlgTSz/SrWp7lgfi4OC3agXzidqt9rJyaWGiaWeXc
         Yi5PYwqAJ6TbfDytxDK9kOB2/j5p3bPxsIB25dN8lHYXPGp0crso+lOigcqAX3uvSkg6
         piKX5U6NPks8KubIWWGq5GU48rlnQN23vAVsM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qEA3yNEaGGRl9BKuKN3E5MZ7584xsnQwcKFnAhdENh4=;
        b=tyvc+ISIFgh8D1vt2bhkeVkWEyEphkLnGPbMo5RBpGukrlrQJ4kp5mKhbSU9rLLbdr
         AW0P4TU/QHgRgxgbiOEZfPeUokMjmRAR0dZfhYkHCyYa9n/2ijWgOeXtze49+RhrW8To
         f16mO8kmr9VXy5sPsMtKPgjbxRjhBw4EF/7N6R4dxKFmwnkkaUYtAgzbLl0Cwzd1HP66
         CkoJPomPVfLJy6osG/A47XmZFJNCufQzApmfqedL/1QlfxGY8kyngyQUYkG9TapEFXQI
         fkYejVgAxnZerUDSz8rJDXOAFLjDS8wr7Dg3oevDRnz+oc55E60b2/X068mmrI+cqlGk
         vSWg==
X-Gm-Message-State: APjAAAV3Bx1FC/+iqc6Exp/eBzn0kti3Ohib8Z8HwIiy+2llOX8i3hw/
        uafVMn8hF7jukJHDYxU7vfc3drP8J+6PEAgWghPknmaosbc=
X-Google-Smtp-Source: APXvYqwhdezEyt1hOxGNnBBcUiM0HmSC4lMEUTQ3vSMj3ogG+5y6U80EgC378QJlgKv0U/bFbY36SDWI/jwqjFCGkwE=
X-Received: by 2002:a0c:e80d:: with SMTP id y13mr9591956qvn.24.1572374128348;
 Tue, 29 Oct 2019 11:35:28 -0700 (PDT)
MIME-Version: 1.0
References: <CABWYdi1QmrHxNZT_DK4A2WUoj=r1+wxSngzaaTuGCatHisaTRw@mail.gmail.com>
 <CANn89iLE-3zxROxGOusPBRmQL4oN2Nqtg3rqXnpO8bkiFAw8EQ@mail.gmail.com>
 <CABWYdi2Eq30vEKKYxr-diofpeATNXiB3ZYKL6Q15y10w+vsCLg@mail.gmail.com> <CANn89iJYKurw-3-EooE9qyM8-2MzQvCz8qdV91J1hVNxXwsyng@mail.gmail.com>
In-Reply-To: <CANn89iJYKurw-3-EooE9qyM8-2MzQvCz8qdV91J1hVNxXwsyng@mail.gmail.com>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Tue, 29 Oct 2019 11:35:17 -0700
Message-ID: <CABWYdi0nmGE6Y+iUkfGvR07zU640Fu4op4EXbCp6ou6GJMcfww@mail.gmail.com>
Subject: Re: fq dropping packets between vlan and ethernet interfaces
To:     Eric Dumazet <edumazet@google.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

5.4-rc5 has it, but we still experience the issue.

On Tue, Oct 29, 2019 at 11:33 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Oct 29, 2019 at 11:31 AM Ivan Babrou <ivan@cloudflare.com> wrote:
> >
> > I'm on 5.4-rc5. Let me apply e7a409c3f46cb0dbc7bfd4f6f9421d53e92614a5
> > on top and report back to you.
>
>
> Oops, wrong copy/paste. I really meant this one :
>
> 9669fffc1415bb0c30e5d2ec98a8e1c3a418cb9c net: ensure correct
> skb->tstamp in various fragmenters
>
>
> >
> > On Tue, Oct 29, 2019 at 11:27 AM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Tue, Oct 29, 2019 at 11:20 AM Ivan Babrou <ivan@cloudflare.com> wrote:
> > > >
> > > > Hello,
> > > >
> > > > We're trying to test Linux 5.4 early and hit an issue with FQ.
> > > >
> > > > The relevant part of our network setup involves four interfaces:
> > > >
> > > > * ext0 (ethernet, internet facing)
> > > > * vlan101@ext0 (vlan)
> > > > * int0 (ethernet, lan facing)
> > > > * vlan11@int0 (vlan)
> > > >
> > > > Both int0 and ext0 have fq on them:
> > > >
> > > > qdisc fq 1: dev ext0 root refcnt 65 limit 10000p flow_limit 100p
> > > > buckets 1024 orphan_mask 1023 quantum 3228 initial_quantum 16140
> > > > low_rate_threshold 550Kbit refill_delay 40.0ms
> > > > qdisc fq 8003: dev int0 root refcnt 65 limit 10000p flow_limit 100p
> > > > buckets 1024 orphan_mask 1023 quantum 3028 initial_quantum 15140
> > > > low_rate_threshold 550Kbit refill_delay 40.0ms
> > > >
> > > > The issue itself is that after some time ext0 stops feeding off
> > > > vlan101, which is visible as tcpdump not seeing packets on ext0, while
> > > > they flow over vlan101.
> > > >
> > > > I can see that fq_dequeue does not report any packets:
> > > >
> > > > $ sudo perf record -e qdisc:qdisc_dequeue -aR sleep 1
> > > > hping3 40335 [006] 63920.881016: qdisc:qdisc_dequeue: dequeue
> > > > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > > > packets=0 skbaddr=(nil)
> > > > hping3 40335 [006] 63920.881030: qdisc:qdisc_dequeue: dequeue
> > > > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > > > packets=0 skbaddr=(nil)
> > > > hping3 40335 [006] 63920.881041: qdisc:qdisc_dequeue: dequeue
> > > > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > > > packets=0 skbaddr=(nil)
> > > > hping3 40335 [006] 63920.881070: qdisc:qdisc_dequeue: dequeue
> > > > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > > > packets=0 skbaddr=(nil)
> > > >
> > > > Inside of fq_dequeue I'm able to see that we throw away packets in here:
> > > >
> > > > * https://elixir.bootlin.com/linux/v5.4-rc2/source/net/sched/sch_fq.c#L510
> > > >
> > > > The output of tc -s qdisc shows the following:
> > > >
> > > > qdisc fq 1: dev ext0 root refcnt 65 limit 10000p flow_limit 100p
> > > > buckets 1024 orphan_mask 1023 quantum 3228 initial_quantum 16140
> > > > low_rate_threshold 550Kbit refill_delay 40.0ms
> > > >  Sent 4872143400 bytes 8448638 pkt (dropped 201276670, overlimits 0
> > > > requeues 103)
> > > >  backlog 779376b 10000p requeues 103
> > > >   2806 flows (2688 inactive, 118 throttled), next packet delay
> > > > 1572240566653952889 ns
> > > >   354201 gc, 0 highprio, 804560 throttled, 3919 ns latency, 19492 flows_plimit
> > > > qdisc fq 8003: dev int0 root refcnt 65 limit 10000p flow_limit 100p
> > > > buckets 1024 orphan_mask 1023 quantum 3028 initial_quantum 15140
> > > > low_rate_threshold 550Kbit refill_delay 40.0ms
> > > >  Sent 15869093876 bytes 17387110 pkt (dropped 0, overlimits 0 requeues 2817)
> > > >  backlog 0b 0p requeues 2817
> > > >   2047 flows (2035 inactive, 0 throttled)
> > > >   225074 gc, 10 highprio, 102308 throttled, 7525 ns latency
> > > >
> > > > The key part here is probably that next packet delay for ext0 is the
> > > > current unix timestamp in nanoseconds. Naturally, we see this code
> > > > path being executed:
> > > >
> > > > * https://elixir.bootlin.com/linux/v5.4-rc2/source/net/sched/sch_fq.c#L462
> > > >
> > > > Unfortunately, I don't have a reliable reproduction for this issue. It
> > > > appears naturally with some traffic and I can do limited tracing with
> > > > perf and bcc tools while running hping3 to generate packets.
> > > >
> > > > The issue goes away if I replace fq with pfifo_fast on ext0.
> > >
> > > At which commit is your tree  precisely ?
> > >
> > > This sounds like the recent fix we had for fragmented packets.
> > >
> > > e7a409c3f46cb0dbc7bfd4f6f9421d53e92614a5 ipv4: fix IPSKB_FRAG_PMTU
> > > handling with fragmentation
