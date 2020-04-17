Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D2A1AD439
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 03:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbgDQBkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 21:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728461AbgDQBkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 21:40:19 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8BDC061A0F
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 18:40:18 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z26so332039ljz.11
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 18:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=99ItHg5dyzrne9OcQMWrXw+tWxINPqhedQbrG/q0syI=;
        b=Q84a+IsCUS2636t8u4OhkPArpV85hE4Mp4w0Xzlk+B1yp1dwGj3/TXj3C+yTVXyaJd
         dnJ8vVYR7CEs1fcfLEZVW/9HZ9OyWzyHEHwNOyPwW8PqSJXAu+QIjL/cicCsU38RtKpL
         V1AoscyjqZ0sIDRlf9BPeppVyzb90qUPA+nbNPLLBf4MT9iDfCVVt/FO6CCZp3YXYU39
         88dLnYUYyYqrLpOqb8MZBOEXdS/4gMawxJcwlopOg1l4qXpwrDFrkftAl7jDTdVpNca+
         uBmU4TNaPzKyItZO1LN+JygoQq6pmOFNE5a5z17RZyuZ+DIbFMBr1jkHPkvBq0xQhHIc
         cYrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=99ItHg5dyzrne9OcQMWrXw+tWxINPqhedQbrG/q0syI=;
        b=AdgyJgWfIHk45AlQk0Jes4TUCc6YrvN42UKKiics64n4QUCG59a2NASUKNq/s5JG+N
         vY4GDGKkb7yt1y/4wlkA77/eIjWPtXs347JuKEynAo0qbFa8x7CJFu2ext3UluP+dEkt
         EdldYNg1bciydvTlhpDJgtmqWjlRDBfosUE4eX5GwKsuAUW+lWXBYL8FRV9nxZysFAdy
         wBh0Q6/ihxl9nRI/TZq2ueMqlgfdzvEx7oTrem+Lgx+JMRf0LntJOMeecLxM+waDEEG2
         NWPvPkcaWPoLEpchhlO4+ntbmH17pAZSgY2OCFjZ+hZ+cATmGxsFbbDZeo4A7lhGiIim
         R6/A==
X-Gm-Message-State: AGi0PuaRcHXheyc1bsCEeTB6mAHrCZ7w5c7Bwprm1yGuhqvRMBV/cCYE
        47x0A+fHUBaMkiXt151GCh6K0lNZfQIYbMqfwQ6jXVm1JvE=
X-Google-Smtp-Source: APiQypKQA67lPicgIlbctCLy1K2RZ6/p58HenU6Nud290p4MU2QpmcPNpv2dy4QUVXnAK7yOvoGUKztODl+lQNcUEEM=
X-Received: by 2002:a2e:8999:: with SMTP id c25mr568721lji.73.1587087616919;
 Thu, 16 Apr 2020 18:40:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200415204743.206086-1-jannh@google.com> <20200416211116.qxqcza5vo2ddnkdq@ast-mbp.dhcp.thefacebook.com>
 <CAG48ez0ZaSo-fC0bXnYChAmEZvv_0sGsxUG5HdFn6YJdOf1=Mg@mail.gmail.com> <20200417004119.owbpb7pavdf3nt5t@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200417004119.owbpb7pavdf3nt5t@ast-mbp.dhcp.thefacebook.com>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 17 Apr 2020 03:39:49 +0200
Message-ID: <CAG48ez11vjn3PgAEJyz=xa6R9txuyNk+bD0dsRzguhYCHgF6dQ@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Use pointer type whitelist for XADD
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 2:41 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Fri, Apr 17, 2020 at 12:34:42AM +0200, Jann Horn wrote:
> > On Thu, Apr 16, 2020 at 11:11 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > > On Wed, Apr 15, 2020 at 10:47:43PM +0200, Jann Horn wrote:
> > > > At the moment, check_xadd() uses a blacklist to decide whether a given
> > > > pointer type should be usable with the XADD instruction. Out of all the
> > > > pointer types that check_mem_access() accepts, only four are currently let
> > > > through by check_xadd():
> > > >
> > > > PTR_TO_MAP_VALUE
> > > > PTR_TO_CTX           rejected
> > > > PTR_TO_STACK
> > > > PTR_TO_PACKET        rejected
> > > > PTR_TO_PACKET_META   rejected
> > > > PTR_TO_FLOW_KEYS     rejected
> > > > PTR_TO_SOCKET        rejected
> > > > PTR_TO_SOCK_COMMON   rejected
> > > > PTR_TO_TCP_SOCK      rejected
> > > > PTR_TO_XDP_SOCK      rejected
> > > > PTR_TO_TP_BUFFER
> > > > PTR_TO_BTF_ID
> > > >
> > > > Looking at the currently permitted ones:
> > > >
> > > >  - PTR_TO_MAP_VALUE: This makes sense and is the primary usecase for XADD.
> > > >  - PTR_TO_STACK: This doesn't make much sense, there is no concurrency on
> > > >    the BPF stack. It also causes confusion further down, because the first
> > > >    check_mem_access() won't check whether the stack slot being read from is
> > > >    STACK_SPILL and the second check_mem_access() assumes in
> > > >    check_stack_write() that the value being written is a normal scalar.
> > > >    This means that unprivileged users can leak kernel pointers.
> > > >  - PTR_TO_TP_BUFFER: This is a local output buffer without concurrency.
> > > >  - PTR_TO_BTF_ID: This is read-only, XADD can't work. When the verifier
> > > >    tries to verify XADD on such memory, the first check_ptr_to_btf_access()
> > > >    invocation gets confused by value_regno not being a valid array index
> > > >    and writes to out-of-bounds memory.
> > >
> > > > Limit XADD to PTR_TO_MAP_VALUE, since everything else at least doesn't make
> > > > sense, and is sometimes broken on top of that.
> > > >
> > > > Fixes: 17a5267067f3 ("bpf: verifier (add verifier core)")
> > > > Signed-off-by: Jann Horn <jannh@google.com>
> > > > ---
> > > > I'm just sending this on the public list, since the worst-case impact for
> > > > non-root users is leaking kernel pointers to userspace. In a context where
> > > > you can reach BPF (no sandboxing), I don't think that kernel ASLR is very
> > > > effective at the moment anyway.
> > > >
> > > > This breaks ten unit tests that assume that XADD is possible on the stack,
> > > > and I'm not sure how all of them should be fixed up; I'd appreciate it if
> > > > someone else could figure out how to fix them. I think some of them might
> > > > be using XADD to cast pointers to numbers, or something like that? But I'm
> > > > not sure.
> > > >
> > > > Or is XADD on the stack actually something you want to support for some
> > > > reason, meaning that that part would have to be fixed differently?
> > >
> > > yeah. 'doesnt make sense' is relative.
> > > I prefer to fix the issues instead of disabling them.
> > > xadd to PTR_TO_STACK, PTR_TO_TP_BUFFER, PTR_TO_BTF_ID should all work
> > > because they are direct pointers to objects.
> >
> > PTR_TO_STACK and PTR_TO_TP_BUFFER I can sort of understand. But
> > PTR_TO_BTF_ID is always readonly, so XADD on PTR_TO_BTF_ID really
> > doesn't make any sense AFAICS.
>
> Not quite. See bpf_tcp_ca_btf_struct_access(). Few fields of one specific
> 'struct tcp_sock' are whitelisted for write.

Oh... but that kind of thing is not really safe, right? While there
aren't really any pointers to struct tcp_sock in the kernel, I've
noticed that there are also some helpers that take ARG_PTR_TO_BTF_ID
arguments, which is kind of similar; and those look like it wouldn't
be hard for root to abuse them to corrupt kernel memory. E.g.
bpf_skb_output_proto is reachable from tracing programs, so I expect
that it'd be pretty easy to corrupt kernel memory with that.

As far as I can tell, fundamentally, BPF must not write through BTF
pointers because the BPF verifier can't guarantee that BTF pointers
actually point to the type they're supposed to point to.

> > > Unlike pointer to ctx and flow_key that will be rewritten and are not
> > > direct pointers.
> > >
> > > Short term I think it's fine to disable PTR_TO_TP_BUFFER because
> > > prog breakage is unlikely (if it's actually broken which I'm not sure yet).
> > > But PTR_TO_BTF_ID and PTR_TO_STACK should be fixed.
> > > The former could be used in bpf-tcp-cc progs. I don't think it is now,
> > > but it's certainly conceivable.
> > > PTR_TO_STACK should continue to work because tests are using it.
> > > 'but stack has no concurrency' is not an excuse to break tests.
> >
> > Meh, if you insist, I guess I can patch it differently. Although I
> > really think that "tests abuse it as a hack" shouldn't be a reason to
> > keep around functionality that doesn't make sense for production use.
>
> The pointer could have reached __sync_fetch_and_add() via two different paths
> just to simplify the C code:
> if (..)
>  my_value = lookup();
> else
>  my_value = &my_init_value;
> __sync_fetch_and_add(&my_init_value->counter, 1);

Yeah, okay, I guess that could happen.
