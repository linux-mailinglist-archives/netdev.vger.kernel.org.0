Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2192B70AB
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 22:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgKQVIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 16:08:41 -0500
Received: from mail.efficios.com ([167.114.26.124]:41020 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgKQVIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 16:08:40 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 6F9432E47A5;
        Tue, 17 Nov 2020 16:08:39 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id LO9Bn8O4dPT7; Tue, 17 Nov 2020 16:08:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 066222E47A3;
        Tue, 17 Nov 2020 16:08:39 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 066222E47A3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1605647319;
        bh=joXKuLCpettkfLPWQA9ObKq0PJ88vpgz9lbGcXrQyMA=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=UCarJfwVdzks5AyjoqhdSTXUk68cIUlBy38qr8peTeuToTfs8PYbU5UYD9L/pE3oV
         +IjPh9zok1YLl02EZ4Fm9q42mS4EBLoZK/ZS/2WZFCvTHnpcpFXA6d6S/vf2rqsWxi
         b4fgN+pYrKYI7bR8lh187Nn8EMFrA5WK0ZwAjsFhJeolxmDTrfBJjbhSROMhvQC1wu
         PWWPNWY4CgJEkyJOQH6p3Q2vk8PFA3zZLVGfzz/fu4i2kTUrUJDO1DKe+utEt8gfQL
         wxscORal2YRl0Xwa9QCjB4ewtMOinCoBtVSNp4nCtmUJj9xJ4vz0h4MBX9iv4gT9x5
         hXI9806u7wyyg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Hdohe4PMzBeJ; Tue, 17 Nov 2020 16:08:38 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id E7F592E46A1;
        Tue, 17 Nov 2020 16:08:38 -0500 (EST)
Date:   Tue, 17 Nov 2020 16:08:38 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Mullins <mmullins@mmlx.us>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Message-ID: <1352757747.48575.1605647318836.JavaMail.zimbra@efficios.com>
In-Reply-To: <20201117153451.3015c5c9@gandalf.local.home>
References: <20201116175107.02db396d@gandalf.local.home> <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com> <20201117142145.43194f1a@gandalf.local.home> <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com> <20201117153451.3015c5c9@gandalf.local.home>
Subject: Re: [PATCH] tracepoint: Do not fail unregistering a probe due to
 memory allocation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3975 (ZimbraWebClient - FF82 (Linux)/8.8.15_GA_3975)
Thread-Topic: tracepoint: Do not fail unregistering a probe due to memory allocation
Thread-Index: dfXwPnJ9g3zb2UbAm/xFFNT2U71zQw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Nov 17, 2020, at 3:34 PM, rostedt rostedt@goodmis.org wrote:

> On Tue, 17 Nov 2020 14:47:20 -0500 (EST)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
>> There seems to be more effect on the data size: adding the "stub_func" field
>> in struct tracepoint adds 8320 bytes of data to my vmlinux. But considering
>> the layout of struct tracepoint:
>> 
>> struct tracepoint {
>>         const char *name;               /* Tracepoint name */
>>         struct static_key key;
>>         struct static_call_key *static_call_key;
>>         void *static_call_tramp;
>>         void *iterator;
>>         int (*regfunc)(void);
>>         void (*unregfunc)(void);
>>         struct tracepoint_func __rcu *funcs;
>>         void *stub_func;
>> };
>> 
>> I would argue that we have many other things to optimize there if we want to
>> shrink the bloat, starting with static keys and system call reg/unregfunc
>> pointers.
> 
> This is the part that I want to decrease, and yes there's other fish to fry
> in that code, but I really don't want to be adding more.

I agree on the goal of not bloating the code and data size of tracepoints, but
I also don't want to introduce subtle hard-to-debug undefined behaviors.

> 
>> 
>> > 
>> > Since all tracepoints callbacks have at least one parameter (__data), we
>> > could declare tp_stub_func as:
>> > 
>> > static void tp_stub_func(void *data, ...)
>> > {
>> >	return;
>> > }
>> > 
>> > And now C knows that tp_stub_func() can be called with one or more
>> > parameters, and had better be able to deal with it!
>> 
>> AFAIU this won't work.
>> 
>> C99 6.5.2.2 Function calls
>> 
>> "If the function is defined with a type that is not compatible with the type (of
>> the
>> expression) pointed to by the expression that denotes the called function, the
>> behavior is
>> undefined."
> 
> But is it really a problem in practice. I'm sure we could create an objtool
> function to check to make sure we don't break anything at build time.

There are also tools like UBSAN which will trigger whenever an undefined behavior
is executed. Having tools which can validate that the generated assembly happens to
work does not make it OK to generate code with undefined behavior.

> 
>> 
>> and
>> 
>> 6.7.5.3 Function declarators (including prototypes), item 15:
>> 
>> "For two function types to be compatible, both shall specify compatible return
>> types.
> 
> But all tracepoint callbacks have void return types, which means they are
> compatible.

Yes, my concern is about what follows just after:

> 
>> 
>> Moreover, the parameter type lists, if both are present, shall agree in the
>> number of
>> parameters and in use of the ellipsis terminator; corresponding parameters shall
>> have
>> compatible types. [...]"
> 
> Which is why I gave the stub function's first parameter the same type that
> all tracepoint callbacks have a prototype that starts with "void *data"
> 
> and my solution is to define:
> 
>	void tp_stub_func(void *data, ...) { return; }
> 
> Which is in line with: "corresponding parameters shall have compatible
> types". The corresponding parameter is simply "void *data".

No, you forgot about the part "[...] shall agree [...] in use of the ellipsis
terminator"

That last part about agreeing about use of the ellipsis terminator is what
makes your last solution run into undefined behavior territory. The caller
and callee don't agree on the use of ellipsis terminator: the caller does not
use it, but the callee expects it.

> 
>> 
>> What you suggest here is to use the ellipsis in the stub definition, but the
>> caller
>> prototype does not use the ellipsis, which brings us into undefined behavior
>> territory
>> again.
> 
> And I believe the "undefined behavior" is that you can't trust what is in
> the parameters if the callee chooses to look at them, and that is not the
> case here.

I am aware of no such definition of "undefined behavior". So you would be
very much dependent on the compiler choosing a not-so-hurtful way to deal
with this behavior then.

> But since the called function doesn't care, I highly doubt it
> will ever be an issue. I mean, the only way this can break is if the caller
> places something in the stack that it expects the callee to fix.

AFAIU an undefined behavior is something we really try to avoid in C. As I said
earlier, it seems to work in practice because the cdecl calling convention leaves
the stack cleanup to the caller. But I'm worried about subtle portability issues
that may arise due to this.

> With all the functions in assembly we have, I'm pretty confident that if a compiler
> does something like this, it would break all over the place.

Fair point. Then maybe we should write the stub in assembly ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
