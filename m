Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01C44ECD93
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 21:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiC3T7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 15:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiC3T7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 15:59:14 -0400
Received: from mail.efficios.com (mail.efficios.com [167.114.26.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DFE13DD6;
        Wed, 30 Mar 2022 12:57:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 638E128521B;
        Wed, 30 Mar 2022 15:57:27 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id QMeSdFxgG6qv; Wed, 30 Mar 2022 15:57:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id C6A0528521A;
        Wed, 30 Mar 2022 15:57:26 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com C6A0528521A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1648670246;
        bh=OlAuNjbiwEl9zU0zp1UzuteLJO1zMAf8ZYwFuUBeiCQ=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=kyIq1A0p9fgaI51ipmJI8QTbh5aeT6nCdwozuEndcUvD6RFiLWxRg7YItyGfnhJto
         uNsb6ay+L8xXpRzGKj9634iNwmfcGDNvbgigHmM34YabKv3BUPDr9UJGkC0nyRIV23
         cNq8uCoDxTYkCfjj5W6iRB7JyhBfZd+5XtKfF9NDs+WhRxUmbcTr4TBa2rRE94O+5h
         25Hi9EBES9BrQlltWoKppyJjYqENSvKJ6ETJhdncSj56S+uvvBU8Fzlz0xwkvCZfRe
         Jj7zm62zwnMhP9UfkLk27jtUtnCxCB8EvlxVHlidVCG/84kuWVjyyXcUIyEvi7NgUj
         oLEOYRQUpEBaQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id o9YUZD_1RuCe; Wed, 30 Mar 2022 15:57:26 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id AFAA4285217;
        Wed, 30 Mar 2022 15:57:26 -0400 (EDT)
Date:   Wed, 30 Mar 2022 15:57:26 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <song@kernel.org>, rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>
Message-ID: <1402984893.199881.1648670246676.JavaMail.zimbra@efficios.com>
In-Reply-To: <20220330191551.GA2377@kbox>
References: <20220329181935.2183-1-beaub@linux.microsoft.com> <20220329201057.GA2549@kbox> <CAADnVQ+gm4yU9S6y+oeR3TNj82kKX0gk4ey9gVnKXKWy1Js4-A@mail.gmail.com> <20220329231137.GA3357@kbox> <CAPhsuW4WH4Hn+DaQZui5au=ueG1G5zGYiOACfKm9imG2kGA+KA@mail.gmail.com> <20220330163411.GA1812@kbox> <CAADnVQKQw+K2CoCW-nA=bngKtjP495wpB1yhEXNjKg4wSeXAWg@mail.gmail.com> <20220330191551.GA2377@kbox>
Subject: Re: [PATCH] tracing/user_events: Add eBPF interface for user_event
 created events
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4203 (ZimbraWebClient - FF98 (Linux)/8.8.15_GA_4232)
Thread-Topic: tracing/user_events: Add eBPF interface for user_event created events
Thread-Index: 1geaOq4wJoT8CKhM9E4nAZg4aMO/8w==
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Mar 30, 2022, at 3:15 PM, Beau Belgrave beaub@linux.microsoft.com wrote:

> On Wed, Mar 30, 2022 at 11:22:32AM -0700, Alexei Starovoitov wrote:
>> On Wed, Mar 30, 2022 at 9:34 AM Beau Belgrave <beaub@linux.microsoft.com> wrote:
>> > > >
>> > > > But you are fine with uprobe costs? uprobes appear to be much more costly
>> > > > than a syscall approach on the hardware I've run on.
>> 
>> Care to share the numbers?
>> uprobe over USDT is a single trap.
>> Not much slower compared to syscall with kpti.
>> 
> 
> Sure, these are the numbers we have from a production device.
> 
> They are captured via perf via PERF_COUNT_HW_CPU_CYCLES.
> It's running a 20K loop emitting 4 bytes of data out.
> Each 4 byte event time is recorded via perf.
> At the end we have the total time and the max seen.
> 
> null numbers represent a 20K loop with just perf start/stop ioctl costs.
> 
> null: min=2863, avg=2953, max=30815
> uprobe: min=10994, avg=11376, max=146682
> uevent: min=7043, avg=7320, max=95396
> lttng: min=6270, avg=6508, max=41951
> 
> These costs include the data getting into a buffer, so they represent
> what we would see in production vs the trap cost alone. For uprobe this
> means we created a uprobe and attached it via tracefs to get the above
> numbers.

[...]

I assume here that by "lttng" you specifically refer to lttng-ust (LTTng's
user-space tracer), am I correct ?

By removing the "null" baseline overhead, my rough calculations are that the
average overhead for lttng-ust in your results is (in cpu cycles):

6270-2863 = 3555

So I'm unsure what is the frequency of your CPU, but guessing around 3.5GHz
this is in the area of 1 microsecond. On an Intel CPU, this is much larger
than what I would expect. 

Can you share your test program, hardware characteristics, kernel version,
glibc version, and whether the program is compiled as a 32-bit or 64-bit
binary ?

Can you confirm that lttng-ust is not calling one getcpu system call per
event ? This might be the case if run a 32-bit x86 binary and have a
glibc < 2.35, or a kernel too old to provide CONFIG_RSEQ or don't have
CONFIG_RSEQ=y in your kernel configuration. You can validate this by
running your lttng-ust test program with a system call tracer.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
