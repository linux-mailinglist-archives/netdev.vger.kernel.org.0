Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A902499A3
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 11:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgHSJvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 05:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbgHSJvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 05:51:51 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF33C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 02:51:50 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id h16so18588621oti.7
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 02:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=+L9HVz8ukibL7nZvhHPrjmtnws0pGQvgwslfhgmqj1w=;
        b=C+Cf+JRF9FxsWBb+JRyETUXwen5cOD2ST4C4LuRQXbgOUXEd7uAyyOuTNZkZLXKy+m
         s+wV7saBkbkP3sl0ozmsvMY3985TolnDlwJKFGMXO29hKhzLj0/8abOno2DtvaXpfMEO
         fGinpZQRSUQmkskxDwNIujQxWbBbltHxQCvAcGt+QC7xXhfSOnYl2c/zPQjb1qlfxSCa
         IEwzSelR7sDMDg6TxRPeIImiYSmqOFKS+LqdsTaDAvxFspMuunM25Xz9aIlL07r14Vpf
         y8KF1aoSV50HOf4YIcapiqN+XZyB9Erc4N7f75250TknBEox0j4uatdHSNaHeFq7IS83
         xvFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=+L9HVz8ukibL7nZvhHPrjmtnws0pGQvgwslfhgmqj1w=;
        b=EONdSATKOBYtO53IJLyEE6Bw/1xooBotwMJfXcHBADyRAz1KhbnO0mmJZFOoy5vL7V
         CmEF8chD2nQVHSlaw9RGLRCEVSGHWx0bfhV+ECjo3DkkfGR9oN34JdiWnFPHOkmtUkyf
         63kj7wJKfY8UB7BDecN3UQAFjivFvx+fWvuWN6hLH7+WSH+XxQEtLPz0/n7juJUox1rB
         /B4xaQaovuAYTpmgS+ZoV7inDRqHAusvcf8ey3dbAQMgD8oRGRbysgO7qGDiJjd7BPc9
         h4VumJ/7djYb6rvFqxJ5DhopXyqFJYuExaHNLnFdMqODZisw6kJA8m/a0tHl4fGmmrtN
         7TiQ==
X-Gm-Message-State: AOAM533WRCfwTf9Gcr39/YOtV54zdajaXvQs27xF0L3QUn95G/edlrUS
        PCuAmzKvS+5LK4jNfiXLY6d7QaFrbzcVdaCpZEk=
X-Google-Smtp-Source: ABdhPJzC/XLk7OOchXl8ms+HjOHVbFvmH5871+gQ7tMgRMBxfSUCUuWdlgjJ8FcrBHiPIX5JzEwZKK+xFjw4XdkaMSY=
X-Received: by 2002:a9d:7997:: with SMTP id h23mr18942731otm.28.1597830709261;
 Wed, 19 Aug 2020 02:51:49 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUXzW3RTyr5M_r-YYBB_k7Yw_JnurwPV5o0xGNpn7QPgRw@mail.gmail.com>
 <6d9a041f-858e-2426-67a9-4e15acd06a95@gmail.com> <CA+icZUW+v5ZHq4FGt7JPyGOL7y7wUrw1N9BHtiuE-EmwqQrcQw@mail.gmail.com>
 <CANn89iJvw55jeWDVzyfNewr-=pXiEwCkG=c5eu6j8EeiD=PN4g@mail.gmail.com> <CA+icZUXsfBonmjxrEZQJVNbF8dF-fMsR1igRWSKTa9AY_sdBzA@mail.gmail.com>
In-Reply-To: <CA+icZUXsfBonmjxrEZQJVNbF8dF-fMsR1igRWSKTa9AY_sdBzA@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 19 Aug 2020 11:51:37 +0200
Message-ID: <CA+icZUX56qM6msbLBbz_ZQVdO8sam8gXRAstbrt5io-gqDyZnA@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 12, 2020 at 6:38 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> On Wed, Aug 12, 2020 at 6:25 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Wed, Aug 12, 2020 at 9:20 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > >
> > > On Wed, Aug 12, 2020 at 5:16 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > >
> > > >
> > > >
> > > > On 8/11/20 11:03 PM, Sedat Dilek wrote:
> > > > > [ CC netdev ]
> > > > > [ Please CC me I am not subscribed to this mailing-list ]
> > > > >
> > > > > Hi Eric,
> > > > >
> > > > > I have added your diffs from [0] and have some troubles to display the
> > > > > prandom_32 trace-events (I mostly followed [1]):
> > > > >
> > > > > I did:
> > > > >
> > > > > echo prandom_u32 >> /sys/kernel/debug/tracing/set_event
> > > > > echo traceon > /sys/kernel/debug/tracing/events/random/prandom_u32/trigger
> > > > > echo 1 > /sys/kernel/debug/tracing/events/enable
> > > > >
> > > > > cat /sys/kernel/debug/tracing/set_event | grep prandom
> > > > > random:prandom_u32
> > > > > cat /sys/kernel/debug/tracing/events/random/prandom_u32/trigger
> > > > > traceon:unlimited
> > > > > cat /sys/kernel/debug/tracing/events/enable
> > > > > X
> > > > >
> > > > > Following [2] and [3] I wanted to use perf:
> > > > >
> > > > > # /home/dileks/bin/perf list | grep prandom
> > > > >   random:prandom_u32                                 [Tracepoint event]
> > > > >
> > > > > Following the example in [4]:
> > > > >
> > > > > # /home/dileks/bin/perf probe --add tcp_sendmsg
> > > > > # /home/dileks/bin/perf record -e probe:tcp_sendmsg -a -g -- sleep 10
> > > > > # /home/dileks/bin/perf report --stdio
> > > > >
> > > > > That gives me a report.
> > > > >
> > > > > Adapting:
> > > > >
> > > > > # /home/dileks/bin/perf probe --add tcp_conn_request
> > > > >
> > > > > # /home/dileks/bin/perf list | grep probe:
> > > > >   probe:tcp_conn_request                             [Tracepoint event]
> > > > >   probe:tcp_sendmsg                                  [Tracepoint event]
> > > > >
> > > > > # home/dileks/bin/perf record -e probe:tcp_conn_request -a -g -- sleep 10
> > > > >
> > > > > # /home/dileks/bin/perf report --stdio
> > > > > Error:
> > > > > The perf.data data has no samples!
> > > > > # To display the perf.data header info, please use
> > > > > --header/--header-only options.
> > > > > #
> > > > >
> > > > > # /home/dileks/bin/perf report --stdio --header-only
> > > > > # ========
> > > > > # captured on    : Wed Aug 12 07:39:42 2020
> > > > > # header version : 1
> > > > > # data offset    : 440
> > > > > # data size      : 2123144
> > > > > # feat offset    : 2123584
> > > > > # hostname : iniza
> > > > > # os release : 5.8.1-2-amd64-llvm11-ias
> > > > > # perf version : 5.8.1
> > > > > # arch : x86_64
> > > > > # nrcpus online : 4
> > > > > # nrcpus avail : 4
> > > > > # cpudesc : Intel(R) Core(TM) i5-2467M CPU @ 1.60GHz
> > > > > # cpuid : GenuineIntel,6,42,7
> > > > > # total memory : 8046012 kB
> > > > > # cmdline : /home/dileks/bin/perf record -e probe:tcp_conn_request -a
> > > > > -g -- sleep 10
> > > > > # event : name = probe:tcp_conn_request, , id = { 304, 305, 306, 307
> > > > > }, type = 2, size = 120, config = 0x866, { sample_period, sample_freq
> > > > > } = 1, sample_type = IP|TID|TIME|CALLCHAIN|CPU|PERIO>
> > > > > # event : name = dummy:HG, , id = { 308, 309, 310, 311 }, type = 1,
> > > > > size = 120, config = 0x9, { sample_period, sample_freq } = 4000,
> > > > > sample_type = IP|TID|TIME|CALLCHAIN|CPU|PERIOD|IDENTIFIER,>
> > > > > # CPU_TOPOLOGY info available, use -I to display
> > > > > # NUMA_TOPOLOGY info available, use -I to display
> > > > > # pmu mappings: software = 1, power = 14, uprobe = 7, cpu = 4,
> > > > > cstate_core = 12, breakpoint = 5, uncore_cbox_0 = 9, tracepoint = 2,
> > > > > cstate_pkg = 13, uncore_arb = 11, kprobe = 6, i915 = 15, ms>
> > > > > # CACHE info available, use -I to display
> > > > > # time of first sample : 0.000000
> > > > > # time of last sample : 0.000000
> > > > > # sample duration :      0.000 ms
> > > > > # MEM_TOPOLOGY info available, use -I to display
> > > > > # bpf_prog_info 3: bpf_prog_6deef7357e7b4530 addr 0xffffffffc01d7834 size 66
> > > > > # bpf_prog_info 4: bpf_prog_6deef7357e7b4530 addr 0xffffffffc01df7e8 size 66
> > > > > # bpf_prog_info 5: bpf_prog_6deef7357e7b4530 addr 0xffffffffc041ca18 size 66
> > > > > # bpf_prog_info 6: bpf_prog_6deef7357e7b4530 addr 0xffffffffc041eb58 size 66
> > > > > # bpf_prog_info 7: bpf_prog_6deef7357e7b4530 addr 0xffffffffc1061dc0 size 66
> > > > > # bpf_prog_info 8: bpf_prog_6deef7357e7b4530 addr 0xffffffffc1063388 size 66
> > > > > # bpf_prog_info 12: bpf_prog_6deef7357e7b4530 addr 0xffffffffc129c244 size 66
> > > > > # bpf_prog_info 13: bpf_prog_6deef7357e7b4530 addr 0xffffffffc129e8c0 size 66
> > > > > # cpu pmu capabilities: branches=16, max_precise=2, pmu_name=sandybridge
> > > > > # missing features: BRANCH_STACK GROUP_DESC AUXTRACE STAT CLOCKID
> > > > > DIR_FORMAT COMPRESSED
> > > > > # ========
> > > > > #
> > > > >
> > > > > In dmesg I see:
> > > > >
> > > > > [Wed Aug 12 07:30:52 2020] Scheduler tracepoints stat_sleep,
> > > > > stat_iowait, stat_blocked and stat_runtime require the kernel
> > > > > parameter schedstats=enable or kernel.sched_schedstats=1
> > > > >
> > > > > CONFIG_SCHEDSTATS=y is set.
> > > > >
> > > > > # echo 1 > /proc/sys/kernel/sched_schedstats
> > > > > # cat /proc/sys/kernel/sched_schedstats
> > > > > 1
> > > > >
> > > > > Still seeing:
> > > > > # /home/dileks/bin/perf report --stdio
> > > > > Error:
> > > > > The perf.data data has no samples!
> > > > > # To display the perf.data header info, please use
> > > > > --header/--header-only options.
> > > > > #
> > > > >
> > > > > Do I miss to set some required Kconfigs?
> > > > > I have attached my latest kernel-config file.
> > > > >
> > > > > So I need a helping hand how to trace prandom_u32 events in general?
> > > >
> > > >
> > > > perf record -a -g -e random:prandom_u32  sleep 5
> > > >
> > > > Then something like
> > > >
> > > > perf report --no-children
> > > >
> > > > or "perf script"
> > > >
> > >
> > > I tried some similar perf record/report settings this morning.
> > >
> > > Would you mind sending out a patch for the prandom_u32/trace diff?
> > >
> > > I have it here in my local Git as:
> > >
> > > (for-5.8/random32-prandom_u32-trace-edumazet) random: Add a trace
> > > event for prandom_u32()
> > >
> > > Feel free to add my:
> > > Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> > >
> > > Also, I tried the diff for tcp_conn_request...
> > > With removing the call to prandom_u32() not useful for
> > > prandom_u32/tracing via perf.
> >
> > I am planning to send the TCP patch once net-next is open. (probably next week)
> >
>
> Great!
>
> Feel free to add my: Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
>

Hi Eric,

I forgot: Can you CC me on that planned TCP patch?

Thanks.

Regards,
- Sedat -

> - Sedat -
>
> > > But I cannot judge if it is helpful in the discussion or not.
> > >
> > > Thanks.
> > >
> > > - Sedat -
> > >
> > >
> > >
> > > > >
> > > > > How to add it as a kernel-boot-parameter (see [4])?
> > > > >
> > > > > Any help appreciated and thanks in advance.
> > > > >
> > > > > Thanks.
> > > > >
> > > > > Regards,
> > > > > - Sedat -
> > > > >
> > > > > [0] https://marc.info/?l=linux-netdev&m=159716173516111&w=2
> > > > > [1] https://www.kernel.org/doc/html/v5.8/trace/events.html
> > > > > [2] http://www.brendangregg.com/perf.html
> > > > > [3] http://www.brendangregg.com/perf.html#DynamicTracing
> > > > > [4] https://www.kernel.org/doc/html/v5.8/trace/events.html#boot-option
> > > > >
