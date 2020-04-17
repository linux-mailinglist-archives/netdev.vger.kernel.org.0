Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BA41AD451
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 04:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgDQCHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 22:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728954AbgDQCHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 22:07:37 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C26C061A0C;
        Thu, 16 Apr 2020 19:07:36 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id k28so527206lfe.10;
        Thu, 16 Apr 2020 19:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z5UauXv3T3lNNJ0/0diC0AbK2ulXIVjOMGPs3F4o77s=;
        b=h9wA1LBVuDDR944gGoZSy/Ri51k2LfffWD4psvV4ZvNhYi6/U1L/KZr7Ygh2ks58Rw
         iV60YCU8UfxpdT0cQjFzxRI8lTgPF8b+4gPRTTIGG1kBZwc7s57Pd919De4HiSIsriEq
         H7AifcVGzpE7OGTgs8KALmP86fN8WZPSn5Ifs6maPH/KsVJg0ERrahFpHHponB9wiT4q
         Hq2vrpPbJzftEJgN0INYs0Ez7FcY4CGYvFXktfVK5Qx+uinrBcBzTi4NQbHbaYXBH5IG
         /A6YkTWkK7a5+KbcJm5H7AIw46Lm5wdk2bXg9SjvuoL444S1zUIe1uRFRf2y0B7DEPG/
         lzdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z5UauXv3T3lNNJ0/0diC0AbK2ulXIVjOMGPs3F4o77s=;
        b=loqlaplDOCumaOnglHVdABf6ddCZlE8ZdqHGYrF7luFagXrl7XLZBexA3pLQPYpGn/
         PcbGX9pucxAICehWSyQmRKdykWdWQI78vgETCICHE1GqeiFL0XB71vbdE6cERMqqLKxi
         rHBP8VB+/NS0X2BJKwjOGMcOjj8/LgzYLc+im1XHW1CFZJgvaA062sEjmWcinI4/0sqW
         hQ8UDqhYBZSGLXDRPGpqpdGwBwusS60asvEmZcklIlFO8DMhoJceIcYhhodQ08FCGV/e
         eCmpfaVf9vqTFaNjqh9jav84dc2dYwmvuQGvH+NM2SQQZfGnvh02LiglaU7NUcjlnGBR
         wP0A==
X-Gm-Message-State: AGi0PuZit264E6RyuN48QXwkfs26feAFK/yJNIF7B0Iq4iu9mC65NY0U
        LPVJG8TTKSgXkJhJXP5LABykRRKEAKQCCZn4IPg=
X-Google-Smtp-Source: APiQypJlS6Ef7aXdEndbxlbH8P7dNeYcZs/XmVgjNPrsU9toDbskCnMAQcQIowXAWF87gw/cIwUfVzLuHtMtTs4/mP4=
X-Received: by 2002:ac2:569b:: with SMTP id 27mr491953lfr.134.1587089254584;
 Thu, 16 Apr 2020 19:07:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200415204743.206086-1-jannh@google.com> <20200416211116.qxqcza5vo2ddnkdq@ast-mbp.dhcp.thefacebook.com>
 <CAG48ez0ZaSo-fC0bXnYChAmEZvv_0sGsxUG5HdFn6YJdOf1=Mg@mail.gmail.com>
 <20200417004119.owbpb7pavdf3nt5t@ast-mbp.dhcp.thefacebook.com> <CAG48ez11vjn3PgAEJyz=xa6R9txuyNk+bD0dsRzguhYCHgF6dQ@mail.gmail.com>
In-Reply-To: <CAG48ez11vjn3PgAEJyz=xa6R9txuyNk+bD0dsRzguhYCHgF6dQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 16 Apr 2020 19:07:23 -0700
Message-ID: <CAADnVQK=ivC0Dy9OXEGvNcU11YW5iW7V-yM0G24NdsGAm+wnQw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Use pointer type whitelist for XADD
To:     Jann Horn <jannh@google.com>
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

On Thu, Apr 16, 2020 at 6:40 PM Jann Horn <jannh@google.com> wrote:
>
> On Fri, Apr 17, 2020 at 2:41 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> > On Fri, Apr 17, 2020 at 12:34:42AM +0200, Jann Horn wrote:
> > > On Thu, Apr 16, 2020 at 11:11 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > > On Wed, Apr 15, 2020 at 10:47:43PM +0200, Jann Horn wrote:
> > > > > At the moment, check_xadd() uses a blacklist to decide whether a given
> > > > > pointer type should be usable with the XADD instruction. Out of all the
> > > > > pointer types that check_mem_access() accepts, only four are currently let
> > > > > through by check_xadd():
> > > > >
> > > > > PTR_TO_MAP_VALUE
> > > > > PTR_TO_CTX           rejected
> > > > > PTR_TO_STACK
> > > > > PTR_TO_PACKET        rejected
> > > > > PTR_TO_PACKET_META   rejected
> > > > > PTR_TO_FLOW_KEYS     rejected
> > > > > PTR_TO_SOCKET        rejected
> > > > > PTR_TO_SOCK_COMMON   rejected
> > > > > PTR_TO_TCP_SOCK      rejected
> > > > > PTR_TO_XDP_SOCK      rejected
> > > > > PTR_TO_TP_BUFFER
> > > > > PTR_TO_BTF_ID
> > > > >
> > > > > Looking at the currently permitted ones:
> > > > >
> > > > >  - PTR_TO_MAP_VALUE: This makes sense and is the primary usecase for XADD.
> > > > >  - PTR_TO_STACK: This doesn't make much sense, there is no concurrency on
> > > > >    the BPF stack. It also causes confusion further down, because the first
> > > > >    check_mem_access() won't check whether the stack slot being read from is
> > > > >    STACK_SPILL and the second check_mem_access() assumes in
> > > > >    check_stack_write() that the value being written is a normal scalar.
> > > > >    This means that unprivileged users can leak kernel pointers.
> > > > >  - PTR_TO_TP_BUFFER: This is a local output buffer without concurrency.
> > > > >  - PTR_TO_BTF_ID: This is read-only, XADD can't work. When the verifier
> > > > >    tries to verify XADD on such memory, the first check_ptr_to_btf_access()
> > > > >    invocation gets confused by value_regno not being a valid array index
> > > > >    and writes to out-of-bounds memory.
> > > >
> > > > > Limit XADD to PTR_TO_MAP_VALUE, since everything else at least doesn't make
> > > > > sense, and is sometimes broken on top of that.
> > > > >
> > > > > Fixes: 17a5267067f3 ("bpf: verifier (add verifier core)")
> > > > > Signed-off-by: Jann Horn <jannh@google.com>
> > > > > ---
> > > > > I'm just sending this on the public list, since the worst-case impact for
> > > > > non-root users is leaking kernel pointers to userspace. In a context where
> > > > > you can reach BPF (no sandboxing), I don't think that kernel ASLR is very
> > > > > effective at the moment anyway.
> > > > >
> > > > > This breaks ten unit tests that assume that XADD is possible on the stack,
> > > > > and I'm not sure how all of them should be fixed up; I'd appreciate it if
> > > > > someone else could figure out how to fix them. I think some of them might
> > > > > be using XADD to cast pointers to numbers, or something like that? But I'm
> > > > > not sure.
> > > > >
> > > > > Or is XADD on the stack actually something you want to support for some
> > > > > reason, meaning that that part would have to be fixed differently?
> > > >
> > > > yeah. 'doesnt make sense' is relative.
> > > > I prefer to fix the issues instead of disabling them.
> > > > xadd to PTR_TO_STACK, PTR_TO_TP_BUFFER, PTR_TO_BTF_ID should all work
> > > > because they are direct pointers to objects.
> > >
> > > PTR_TO_STACK and PTR_TO_TP_BUFFER I can sort of understand. But
> > > PTR_TO_BTF_ID is always readonly, so XADD on PTR_TO_BTF_ID really
> > > doesn't make any sense AFAICS.
> >
> > Not quite. See bpf_tcp_ca_btf_struct_access(). Few fields of one specific
> > 'struct tcp_sock' are whitelisted for write.
>
> Oh... but that kind of thing is not really safe, right? While there
> aren't really any pointers to struct tcp_sock in the kernel, I've
> noticed that there are also some helpers that take ARG_PTR_TO_BTF_ID
> arguments, which is kind of similar; and those look like it wouldn't
> be hard for root to abuse them to corrupt kernel memory. E.g.
> bpf_skb_output_proto is reachable from tracing programs, so I expect
> that it'd be pretty easy to corrupt kernel memory with that.
>
> As far as I can tell, fundamentally, BPF must not write through BTF
> pointers because the BPF verifier can't guarantee that BTF pointers
> actually point to the type they're supposed to point to.

In general case of tracing yes. There is no 100% guarantee
that's why there is no write there.
But in case of bpf-tcp-cc it's guaranteed to be a valid pointer.
Or I'm missing your point.
