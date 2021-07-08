Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715013C1824
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 19:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbhGHRd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 13:33:29 -0400
Received: from mail.efficios.com ([167.114.26.124]:41662 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhGHRd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 13:33:27 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 49C7D356D73;
        Thu,  8 Jul 2021 13:30:44 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id tso4qtwJn-oc; Thu,  8 Jul 2021 13:30:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id AFF91357023;
        Thu,  8 Jul 2021 13:30:42 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com AFF91357023
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1625765442;
        bh=yMCYyUaDxa0KOIyw0fOG9F7BxYnhCUATdYeNCkh9Sd8=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=DD66BDayNIPrk1AxZnelfo9LMYuU77BQ2RXKSI6d2ruOdKNi+D/1I/DaleCo9j9mi
         I0nIX9jl9ByWQV14NlOXWtTtHwi1RhCqyQopPqMOdGoF2Tpk3MjOfw+iKVjrrhPPAq
         a5JLtTdGIQLmvg7dGztILNzzDKpnHUDXNM2vErTa2tWvq6D00cwVudDsMYe6prVNRc
         El6BT/7ir9Oh0siLaKjJmJgmeEEoaNclmAE56sZA0fXbQpsyFNnP+fRRg2LYYqETYj
         zU0gMbEZiJE+vTS3KmTun6RQfI+rl5mHimQY7GUFzSbgFQZt/YSYw0hSfht6PiPKc8
         3oSiIwuLO+wIw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id wvLcxJ3AAWch; Thu,  8 Jul 2021 13:30:42 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 98ABF356D6D;
        Thu,  8 Jul 2021 13:30:42 -0400 (EDT)
Date:   Thu, 8 Jul 2021 13:30:42 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     rostedt <rostedt@goodmis.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        syzbot+721aa903751db87aa244@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Message-ID: <12904992.10404.1625765442490.JavaMail.zimbra@efficios.com>
In-Reply-To: <CAEf4BzYRxRW8qR3oENuVEMBYtcvK0bUDEkoq+e4TRT5Hh0pV_Q@mail.gmail.com>
References: <20210629095543.391ac606@oasis.local.home> <CAEf4BzZPb=cPf9V1Bz+USiq+b5opUTNkj4+CRjXdHcmExW3jVg@mail.gmail.com> <20210707184518.618ae497@rorschach.local.home> <CAEf4BzZ=hFZw1RNx0Pw=kMNq2xRrqHYCQQ_TY_pt86Zg9HFJfA@mail.gmail.com> <20210707200544.1fbfd42b@rorschach.local.home> <CAEf4BzYRxRW8qR3oENuVEMBYtcvK0bUDEkoq+e4TRT5Hh0pV_Q@mail.gmail.com>
Subject: Re: [PATCH] tracepoint: Add tracepoint_probe_register_may_exist()
 for BPF tracing
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4059 (ZimbraWebClient - FF89 (Linux)/8.8.15_GA_4059)
Thread-Topic: tracepoint: Add tracepoint_probe_register_may_exist() for BPF tracing
Thread-Index: zSZXTZdQDtLWPVa8QvQrrBDxNYsq7Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Jul 7, 2021, at 8:23 PM, Andrii Nakryiko andrii.nakryiko@gmail.com wrote:

> On Wed, Jul 7, 2021 at 5:05 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>> On Wed, 7 Jul 2021 16:49:26 -0700
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>>
>> > As for why the user might need that, it's up to the user and I don't
>> > want to speculate because it will always sound contrived without a
>> > specific production use case. But people are very creative and we try
>> > not to dictate how and what can be done if it doesn't break any
>> > fundamental assumption and safety.
>>
>> I guess it doesn't matter, because if they try to do it, the second
>> attachment will simply fail to attach.
>>
> 
> But not for the kprobe case.
> 
> And it might not always be possible to know that the same BPF program
> is being attached. It could be attached by different processes that
> re-use pinned program (without being aware of each other). Or it could
> be done from some generic library that just accepts prog_fd and
> doesn't really know the exact BPF program and whether it was already
> attached.
> 
> Not sure why it doesn't matter that attachment will fail where it is
> expected to succeed. The question is rather why such restriction?

Before eBPF came to exist, all in-kernel users of the tracepoint API never
required multiple registrations for a given (tracepoint, probe, data) tuple.

This allowed us to expose an API which can consider that the (tracepoint, probe, data)
tuple is unique for each registration/unregistration pair, and therefore use that same
tuple for unregistration. Refusing multiple registrations for a given tuple allows us to
forgo the complexity of reference counting for duplicate registrations, and provide
immediate feedback to misbehaving tracers which have duplicate registration or
unbalanced registration/unregistration pairs.

From the perspective of a ring buffer tracer, the notion of multiple instances of
a given (tracepoint, probe, data) tuple is rather silly: it would mean that a given
tracepoint hit would generate many instances of the exact same event into the
same trace buffer.

AFAIR, having the WARN_ON_ONCE() within the tracepoint code to highlight this kind of misuse
allowed Steven to find a few unbalanced registration/unregistration issues while developing
ftrace in the past. I vaguely recall that it triggered for blktrace at some point as well.

Considering that allowing duplicates would add complexity to the tracepoint code,
what is the use-case justifying allowing many instances of the exact same callback
and data for a given tracepoint ?

One key difference I notice here between eBPF and ring buffer tracers is what eBPF
considers a "program". AFAIU (please let me know if I'm mistaken), the "callback"
argument provided by eBPF to the tracepoint API is a limited set of trampoline routines.
The bulk of the eBPF "program" is provided in the "data" argument. So this means the
"program" is both the eBPF code and some context.

So I understand that a given eBPF code could be loaded more than once for a given
tracepoint, but I would expect that each registration on a given tracepoint be
provided with its own "context", otherwise we end up in a similar situation as the
ring buffer's duplicated events scenario I explained above.

Also, we should discuss whether kprobes might benefit from being more strict by
rejecting duplicated (instrumentation site, probe, data) tuples.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
