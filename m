Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2782A8862
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732349AbgKEUxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKEUxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:53:16 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D62C0613CF;
        Thu,  5 Nov 2020 12:53:16 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id s89so2512774ybi.12;
        Thu, 05 Nov 2020 12:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Xv2mQTE2rLFW/hHimYoN2Giti8Qjqn8A5dCJff9zeY=;
        b=dYMClcFbEFevkOjFPUlX0dKieOwCrS38qcyrW4TLx99YmNajTm9TdyfKqLaa/weMcA
         0+cawd/tchkMqxRFoGeFi2/dplF3W0rGWWJdrsRfrgXPx+K0B1DXjWmoEVf5lHb4hL5l
         k3WKijU8hREVX3TR1ubxY6zJSSxnkob9wbEo5QI2l3PEUvOhpqzGEBgPQcZjy1eFDtXp
         5tFSvw2Z9Chc/EqpGPbXJRQuiliYHqwaljFYhE1IIehrgwcGs7WBtefNDq5T6BdGRssQ
         zvQ8vF6oY/dmMEU13Vfm8ZGbOl28GNC+sdprtK7j4Qdj1fNv3HhSCCPp+qcMeHohw2rJ
         PqfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Xv2mQTE2rLFW/hHimYoN2Giti8Qjqn8A5dCJff9zeY=;
        b=Qrn9NblbVwUpzHq8WfjnnRS8oxOrZ0TbtevZfNgHFG+8+SyuogjrWz6WB/bSSz2MwU
         wXyi/66CU5AJKrfpm1qpLBmbL5KO0uvDLLIFUlxa99LmszwnXV9aThtDH6ytNvqsMLDC
         LXTz3FMWyU397Ayb/FN6L/09M9rXcgcmjN1o+CllsZ/d78zdOqpCJFtv2xPSLMn0bOxb
         5ZiJmxSmhJiLnvzSaKF+8PhoI/wWSzKOs/x7RKLALuXnOJcJilgWvjjMRf+jGtev2mxE
         F0GAU3jjpxlkqAsqs5Ekjxc6wSy1zziQZWiZ3u5AS6Gt4b7FSv9R1oylXWjZOcpAbmX2
         TmgA==
X-Gm-Message-State: AOAM530k0KLwHaLrZo4CkaFIKIF5fRmD/diVsLDVqOj99RpXwFsRJpfP
        t0HXIDQ0tEqKmLWEKqunWjxPfVyjxtrHyLmhIkU=
X-Google-Smtp-Source: ABdhPJymBHonzu7HnT3ben3KKr8LLwVPbk9hIDQd9sf/55SuIf4Mpybwaz7Yg4hgEpfmBpZiL0q/FOK2EQh4R+agruw=
X-Received: by 2002:a25:da4e:: with SMTP id n75mr6252829ybf.425.1604609595959;
 Thu, 05 Nov 2020 12:53:15 -0800 (PST)
MIME-Version: 1.0
References: <20201028132529.3763875-1-haliu@redhat.com> <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com> <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net> <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com> <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com> <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net> <87zh3xv04o.fsf@toke.dk>
 <5de7eb11-010b-e66e-c72d-07ece638c25e@iogearbox.net> <20201104111708.0595e2a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEf4BzY2pAaEmv_x_nGQC83373ZWUuNv-wcYRye+vfZ3Fa2qbw@mail.gmail.com> <dba0723f-fd55-5dd6-dccc-4e0a649c860e@gmail.com>
In-Reply-To: <dba0723f-fd55-5dd6-dccc-4e0a649c860e@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 5 Nov 2020 12:53:04 -0800
Message-ID: <CAEf4BzawdFhuuxYqfdo7MbjL0PE_g5n4gv4RjFSWQ2UxOrtkhQ@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 4, 2020 at 7:48 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 11/4/20 1:43 PM, Andrii Nakryiko wrote:
> >
> > What users writing BPF programs can expect from iproute2 in terms of
> > available BPF features is what matters. And by not enforcing a
> > specific minimal libbpf version, iproute2 version doesn't matter all
> > that much, because libbpf version that iproute2 ends up linking
> > against might be very old.
> >
> > There was a lot of talk about API stability and backwards
> > compatibility. Libbpf has had a stable API and ABI for at least 1.5
> > years now and is very conscious about that when adding or extending
> > new APIs. That's not even a factor in me arguing for submodules. I'll
> > give a few specific examples of libbpf API not changing at all, but
> > how end user experience gets tremendously better.
> >
> > Some of the most important APIs of libbpf are, arguably,
> > bpf_object__open() and bpf_object__load(). They accept a BPF ELF file,
> > do some preprocessing and in the end load BPF instructions into the
> > kernel for verification. But while API doesn't change across libbpf
> > versions, BPF-side code features supported changes quite a lot.
> >
> > 1. BTF sanitization. Newer versions of clang would emit a richer set
> > of BTF type information. Old kernels might not support BTF at all (but
> > otherwise would work just fine), or might not support some specific
> > newer additions to BTF. If someone was to use the latest Clang, but
> > outdated libbpf and old kernel, they would have a bad time, because
> > their BPF program would fail due to the kernel being strict about BTF.
> > But new libbpf would "sanitize" BTF, according to supported features
> > of the kernel, or just drop BTF altogether, if the kernel is that old.
> >
>
> In my experience, compilers are the least likely change in a typical
> Linux development environment. BPF should not be forcing new versions
> (see me last response).
>

"My experience" and "typical" don't generalize well, I'd rather not
draw any specific conclusions from that. But as I replied to your last
response: if you have a BPF application that doesn't use BPF CO-RE and
doesn't need BTF, you'll most probably be just fine with older Clang
(<v10), no one is forcing anything.

We do recommend to use the latest Clang, so that you have to deal with
less work arounds, of course. And you get all the shiny BTF built-ins.
And some of the problematic code patterns are not generated by newer
Clangs so that you as a BPF developer have to deal with less painful
development and debugging process.

> >
> > 2. bpf_probe_read_user() falling back to bpf_probe_read(). Newer
> > kernels warn if a BPF application isn't using a proper _kernel() or
> > _user() variant of bpf_probe_read(), and eventually will just stop
> > supporting generic bpf_probe_read(). So what this means is that end
> > users would need to compile to variants of their BPF application, one
> > for older kernels with bpf_probe_read(), another with
> > bpf_probe_read_kernel()/bpf_probe_read_user(). That's a massive pain
> > in the butt. But newer libbpf versions provide a completely
> > transparent fallback from _user()/_kernel() variants to generic one,
> > if the kernel doesn't support new variants. So the instruction to
> > users becomes simple: always use
> > bpf_probe_read_user()/bpf_probe_read_kernel().
> >
>
> I vaguely recall a thread about having BPF system call return user
> friendly messages, but that was shot down. I take this example to mean
> the solution is to have libbpf handle the quirks and various changes
> which means that now libbpf takes on burden - the need for constant
> updates to handle quirks. extack has been very successful at making
> networking configuration mistakes more user friendly. Other kernel
> features should be using the same kind of extension.

I don't think this is relevant for this discussion at all. But yes,
libbpf tries to alleviate as much pain as possible. And no, extack
won't help with that in general, only with some error reporting,
potentially.
