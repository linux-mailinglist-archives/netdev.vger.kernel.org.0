Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF25E21F0
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 19:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730513AbfJWRkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 13:40:16 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41523 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729283AbfJWRkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 13:40:16 -0400
Received: by mail-pl1-f196.google.com with SMTP id t10so10419042plr.8
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 10:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=07dMQIg2lrA6wgz0rrIqf754/7FblgaNM+koPoR09QA=;
        b=Cv+IaU5j9hE+8I9Hj7iLWIwqEehKwHMTxXmZZTYjTP8FdYFixjGtRIDgHAo2CD4wN/
         nMRYoCxH4SPKEvOj42XRoG6dzNpQ/Ny78VQILzntD24/n4Vv4cMmXxDneLM280kK5edQ
         xDmp86nXxfsZpRMDor9jSs1ecwipOD2aqD0etmi1ztLIqRBJVhFaLJUD8huVlCdKrQqM
         2N1fRxzairnXxpYQUmoAESPXCRm45aKPEDdZEZs12hsEzjCELkJgColpblPQSpNWlxkP
         09qy8Fq1LVYwJeQNUaeseeEZIIrK+4Kq/Lebe4o78ARmdtAwWfllzVflOLPQiiJQTKJK
         am/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=07dMQIg2lrA6wgz0rrIqf754/7FblgaNM+koPoR09QA=;
        b=QrNVjAetSkGOOyXalvalMjBEBydb0KA24SvAnJ+HSHz+Y8bEfUL6GPRlmoQP6X5sTX
         pEaMuEw6sLXDe5UHg+mCgCHfxNMuLbH425DqJ8rySYZ+tytxjbC5Pctwlgl887ONBjqG
         sW2vXw2pX38rwfY5wHRsSoHbiqFHO0FSHH6t2cS20nj/XH+pvJr5Pqm3u6elQD1JohJ3
         4Hz1LNXNyiebBpd6dQvyNjyn5xdR67xu4UeQhFbdiETQcuoKpuRXsUm1o3OCCCKql8aU
         hEvHCMT/ad5iqVOdssSYpWsLEclPo86uuuSPvlHjQAb/fUMtMWpevJvRpho+nChJKO4y
         +DNQ==
X-Gm-Message-State: APjAAAVBy7M3RjTbsA0dLMJZDWL8vvWrKFNlHDkJDIDQ9Mo5XpR13Smu
        6dKO4Dau1dk9Zyq1HuQmZfef7dqMUS7KhMnPHHgJogQ/
X-Google-Smtp-Source: APXvYqwgXv/tqM0XOLF+87vR1rzfi6Gl5nx8B+WUD6tGAqNRldGsbw73QboJZ/ZdpLdE20y8/MmGxWPGKxqLhFvsSUY=
X-Received: by 2002:a17:902:321:: with SMTP id 30mr11056783pld.61.1571852415448;
 Wed, 23 Oct 2019 10:40:15 -0700 (PDT)
MIME-Version: 1.0
References: <20191022231051.30770-1-xiyou.wangcong@gmail.com>
 <20191022231051.30770-4-xiyou.wangcong@gmail.com> <CANn89i+Y+fMqPbT-YyKcbQOH96+D=U8K4wnNgFkGYtjStKPrEQ@mail.gmail.com>
 <CAM_iQpWxDN7Wm_ar7cStiMnhmmy7RK=BG5k4zwD+K6kbgfPEKw@mail.gmail.com> <CANn89i+Q5ucKuEAt6rotf2xwappiMgRwL0Cgmvvnk5adYb-o0w@mail.gmail.com>
In-Reply-To: <CANn89i+Q5ucKuEAt6rotf2xwappiMgRwL0Cgmvvnk5adYb-o0w@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 23 Oct 2019 10:40:03 -0700
Message-ID: <CAM_iQpWah2M2tG=+eRS86VtjknTiBC42DSwdHB8USpXgRsfWjw@mail.gmail.com>
Subject: Re: [Patch net-next 3/3] tcp: decouple TLP timer from RTO timer
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 7:15 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Oct 22, 2019 at 6:10 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Tue, Oct 22, 2019 at 4:24 PM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Tue, Oct 22, 2019 at 4:11 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > Currently RTO, TLP and PROBE0 all share a same timer instance
> > > > in kernel and use icsk->icsk_pending to dispatch the work.
> > > > This causes spinlock contention when resetting the timer is
> > > > too frequent, as clearly shown in the perf report:
> > > >
> > > >    61.72%    61.71%  swapper          [kernel.kallsyms]                        [k] queued_spin_lock_slowpath
> > > >    ...
> > > >     - 58.83% tcp_v4_rcv
> > > >       - 58.80% tcp_v4_do_rcv
> > > >          - 58.80% tcp_rcv_established
> > > >             - 52.88% __tcp_push_pending_frames
> > > >                - 52.88% tcp_write_xmit
> > > >                   - 28.16% tcp_event_new_data_sent
> > > >                      - 28.15% sk_reset_timer
> > > >                         + mod_timer
> > > >                   - 24.68% tcp_schedule_loss_probe
> > > >                      - 24.68% sk_reset_timer
> > > >                         + 24.68% mod_timer
> > > >
> > > > This patch decouples TLP timer from RTO timer by adding a new
> > > > timer instance but still uses icsk->icsk_pending to dispatch,
> > > > in order to minimize the risk of this patch.
> > > >
> > > > After this patch, the CPU time spent in tcp_write_xmit() reduced
> > > > down to 10.92%.
> > >
> > > What is the exact benchmark you are running ?
> > >
> > > We never saw any contention like that, so lets make sure you are not
> > > working around another issue.
> >
> > I simply ran 256 parallel netperf with 128 CPU's to trigger this
> > spinlock contention, 100% reproducible here.
>
> How many TX/RX queues on the NIC ?

60 queues (default), 25Gbps NIC, mlx5.

> What is the qdisc setup ?

fq_codel, which is default here. Its parameters are default too.

>
> >
> > A single netperf TCP_RR could _also_ confirm the improvement:
> >
> > Before patch:
> >
> > $ netperf -H XXX -t TCP_RR -l 20
> > MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0
> > AF_INET to XXX () port 0 AF_INET : first burst 0
> > Local /Remote
> > Socket Size   Request  Resp.   Elapsed  Trans.
> > Send   Recv   Size     Size    Time     Rate
> > bytes  Bytes  bytes    bytes   secs.    per sec
> >
> > 655360 873800 1        1       20.00    17665.59
> > 655360 873800
> >
> >
> > After patch:
> >
> > $ netperf -H XXX -t TCP_RR -l 20
> > MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0
> > AF_INET to XXX () port 0 AF_INET : first burst 0
> > Local /Remote
> > Socket Size   Request  Resp.   Elapsed  Trans.
> > Send   Recv   Size     Size    Time     Rate
> > bytes  Bytes  bytes    bytes   secs.    per sec
> >
> > 655360 873800 1        1       20.00    18829.31
> > 655360 873800
> >
> > (I have run it for multiple times, just pick a median one here.)
> >
> > The difference can also be observed by turning off/on TLP without patch.
>
> OK thanks for using something I can repro easily :)
>
> I ran the experiment ten times :

How many CPU's do you have?


>
> lpaa23:/export/hda3/google/edumazet# echo 3
> >/proc/sys/net/ipv4/tcp_early_retrans
> lpaa23:/export/hda3/google/edumazet# for f in {1..10}; do
> ./super_netperf 1 -H lpaa24 -t TCP_RR -l 20; done
>   26797
>   26850
>   25266
>   27605
>   26586
>   26341
>   27255
>   27532
>   26657
>   27253
>
>
> Then disabled tlp, and got no obvious difference
>
> lpaa23:/export/hda3/google/edumazet# echo 0
> >/proc/sys/net/ipv4/tcp_early_retrans
> lpaa23:/export/hda3/google/edumazet# for f in {1..10}; do
> ./super_netperf 1 -H lpaa24 -t TCP_RR -l 20; done
>   25311
>   24658
>   27105
>   27421
>   27604
>   24649
>   26259
>   27615
>   27543
>   26217
>
> I tried with 256 concurrent flows, and same overall observation about
> tlp not changing the numbers.
> (In fact I am not even sure we arm RTO at all while doing a TCP_RR)

In case you misunderstand, the CPU profiling I used is captured
during 256 parallel TCP_STREAM.


> lpaa23:/export/hda3/google/edumazet# echo 3
> >/proc/sys/net/ipv4/tcp_early_retrans
> lpaa23:/export/hda3/google/edumazet# for f in {1..10}; do
> ./super_netperf 256 -H lpaa24 -t TCP_RR -l 20; done
> 1578682
> 1572444
> 1573490
> 1536378
> 1514905
> 1580854
> 1575949
> 1578925
> 1511164
> 1568213
> lpaa23:/export/hda3/google/edumazet# echo 0
> >/proc/sys/net/ipv4/tcp_early_retrans
> lpaa23:/export/hda3/google/edumazet# for f in {1..10}; do
> ./super_netperf 256 -H lpaa24 -t TCP_RR -l 20; done
> 1576228
> 1578401
> 1577654
> 1579506
> 1570682
> 1582267
> 1550069
> 1530599
> 1583269
> 1578830
>
>
> I wonder if you have some IRQ smp_affinity problem maybe, or some
> scheduler strategy constantly migrating your user threads ?

Scheduler is default too. IRQ smp affinity is statically distributed to
each of the first 60 CPU's.

>
> TLP is quite subtle, having two timers instead of one is probably
> going to trigger various bugs.

This is exactly why I keep icsk_pending. ;)

Thanks.
