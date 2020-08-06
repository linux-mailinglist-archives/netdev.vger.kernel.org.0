Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A4D23E003
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgHFR60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728021AbgHFR6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 13:58:25 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73275C061574;
        Thu,  6 Aug 2020 10:58:25 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id m200so22002427ybf.10;
        Thu, 06 Aug 2020 10:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=38zt7R0RJPvUtymX3Nw4Froxt2V5VzBCbTJwdCMITjk=;
        b=JqOUSExpWEr6MrFaSCly9Ovija/fz43XDW+gr6PI61X+B+JCPytJ2Vf1F9JIMC7LuV
         t7EG7svIbvbImejCECaNF0WFsDqeEaBI8FZLkOA4kechvVj2051f6rhhB5xk3iIaSM2F
         qYK8KCMLC6dNC0Tfl6UL8+lfIKSER1HbggNtkRJmBZdFbHfchW1bj2qfa9PLbR/q0I5a
         zdje0Orjx+M8gmCTn0POcb7PLabdLmbaSAF3CtQ5qikd0OzNB9IwRYIiJYLKSrqnfw7z
         uuLv0PUSZrw5TxyVDFCVyRVXR6zSHQP6tZ4e19lTYqrHa41MutsJkkPJ4gf/2bfvdJbZ
         Nd/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=38zt7R0RJPvUtymX3Nw4Froxt2V5VzBCbTJwdCMITjk=;
        b=K0/fjFvLtQcIT+ZGB9G7Nib41xduzR+TRp7PwE9dKRtl9DZjtp287ryAL8LjKe2cbw
         qX4TEW/Fj+dZBcYh2P/T6f6KVIUYUBkxy/mSqxp2hpuCHSs4huVqoCz/5j6gygtz8UBT
         p8ch8haGeJvZb/k/6QX+guurkY1gmoJMiAB2p1JowMNS7kHYOeG9N4g1yOniTGv2t/jB
         6zKv3JpBuSRQskTEFPOvoW1GAR4NSXJin6tfBNqtRQxikoIVHluOPZVgcSfoGoHrnkmw
         yULdASGrANLAyvldw06GbfiGEgbR5nUhcaSbRSiAqUyVzqdJ82xqbHGLhYSV33Bc8l8D
         gwrw==
X-Gm-Message-State: AOAM53183e0cowIqhH2+4iaeYB/ru9gtVGr2bHKgCwNwGKvMMpHMVHU3
        PCfMW7v0ciKFZ3gxgQwwe2ppb8zGzUUcy0zETB4=
X-Google-Smtp-Source: ABdhPJz355Ybf7YZoM14a0jlC2NgBFxprVG+YySjYZNVzQuSWG8GFbt/H3f/xBFH7oB6PrZTgeImqQGI4NkzBYFnW3k=
X-Received: by 2002:a25:84cd:: with SMTP id x13mr14685208ybm.425.1596736702777;
 Thu, 06 Aug 2020 10:58:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200722054314.2103880-1-irogers@google.com> <CAEf4BzaBYaFJ3eUinS9nHeykJ0xEbZpwLts33ZDp1PT=bkyjww@mail.gmail.com>
 <CAP-5=fXMUWFs6YtQVuxjenCrOmKtKYCqZE3YofwdR=ArDYSwbQ@mail.gmail.com> <CAEf4BzYiY30de5qmiKeazG4ewyziXtdhHFFH4vjp1wi4iAXqiw@mail.gmail.com>
In-Reply-To: <CAEf4BzYiY30de5qmiKeazG4ewyziXtdhHFFH4vjp1wi4iAXqiw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 6 Aug 2020 10:58:12 -0700
Message-ID: <CAEf4BzZ_67M6nJZFL73ANYYARiErmv9aiYygw8JwJW4qyWGNog@mail.gmail.com>
Subject: Re: [RFC PATCH] bpftool btf: Add prefix option to dump C
To:     Ian Rogers <irogers@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 8:47 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Jul 31, 2020 at 6:47 PM Ian Rogers <irogers@google.com> wrote:
> >
> > On Tue, Jul 21, 2020 at 11:58 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Tue, Jul 21, 2020 at 10:44 PM Ian Rogers <irogers@google.com> wrote:
> > > >
> > > > When bpftool dumps types and enum members into a header file for
> > > > inclusion the names match those in the original source. If the same
> > > > header file needs to be included in the original source and the bpf
> > > > program, the names of structs, unions, typedefs and enum members will
> > > > have naming collisions.
> > >
> > > vmlinux.h is not really intended to be used from user-space, because
> > > it's incompatible with pretty much any other header that declares any
> > > type. Ideally we should make this better, but that might require some
> > > compiler support. We've been discussing with Yonghong extending Clang
> > > with a compile-time check for whether some type is defined or not,
> > > which would allow to guard every type and only declare it
> > > conditionally, if it's missing. But that's just an idea at this point.
> >
> > Thanks Andrii! We're not looking at user-space code but the BPF code.
> > The prefix idea comes from a way to solve this problem in C++ with
> > namespaces:
> >
> > namespace vmlinux {
> > #include "vmlinux.h"
> > }
> >
> > As the BPF programs are C code then the prefix acts like the
> > namespace. It seems strange to need to extend the language.
>
> This is a classic case of jumping to designing a solution without
> discussing a real problem first :)
>
> You don't need to use any of the kernel headers together with
> vmlinux.h (and it won't work as well), because vmlinux.h is supposed
> to have all the **used** types from the kernel. So BPF programs only
> include vmlinux.h and few libbpf-provided headers with helpers. Which
> is why I assumed that you are trying to use it from user-space. But
> see below on what went wrong.
>
> >
> > > Regardless, vmlinux.h is also very much Clang-specific, and shouldn't
> > > work well with GCC. Could you elaborate on the specifics of the use
> > > case you have in mind? That could help me see what might be the right
> > > solution. Thanks!
> >
> > So the use-case is similar to btf_iter.h:
> > https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/testing/selftests/bpf/progs/bpf_iter.h
> > To avoid collisions with somewhat cleaner macro or not games.
> >
> > Prompted by your concern I was looking into changing bpf_iter.h to use
> > a prefix to show what the difference would be like. I also think that
> > there may be issues with our kernel and tool set up that may mean that
> > the prefix is unnecessary, if I fix something else. Anyway, to give an
> > example I needed to build the selftests but this is failing for me.
> > What I see is:
> >
> > $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
> > $ cd bpf-next
> > $ make defconfig
> > $ cat >>.config <<EOF
> > CONFIG_DEBUG_INFO=y
> > CONFIG_DEBUG_INFO_BTF=y
> > EOF
> > $ make -j all
> > $ mkdir /tmp/selftests
> > $ make O=/tmp/selftests/ TARGETS=bpf kselftest
> > ...
> >   CLANG    /tmp/selftests//kselftest/bpf/tools/build/bpftool/profiler.bpf.o
> > skeleton/profiler.bpf.c:18:21: error: invalid application of 'sizeof'
> > to an incomplete type 'struct bpf_perf_event_value'
> >         __uint(value_size, sizeof(struct bpf_perf_event_value));
> >                            ^     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> > Checking with bpftool the vmlinux lacks struct bpf_perf_event_value
> > but as this is unconditionally defined in bpf.h this seems wrong. Do
> > you have any suggestions and getting a working build?
>
> It is unconditionally defined in bpf.h, but unless kernel code really
> uses that type for something, compiler won't generate DWARF
> information for that type, which subsequently won't get into BTF.
> Adding CONFIG_DEBUG_INFO_BTF=y ensures you get BTF type info
> generated, but only for subsystems that were compiled into vmlinux
> according to your kernel config.
>
> In this case, default config doesn't enable CONFIG_BPF_EVENTS, which
> is a requirement to compile kernel/trace/bpf_trace.c, which in turn
> uses struct bpf_perf_event_value in the helper signature.
>
> So the solution in your case would be to use a slightly richer kernel
> config, which enables more of the BPF subsystem. You can check
> selftests/bpf/config for a list of options we typically enable to run
> of selftests, for instance.
>

So we've discussed this and related issues today at BPF office hours
and few more thoughts occurred to me after I left the call.

You don't really have to use vmlinux.h, if it's inconvenient. Unless
you want to use some internal kernel type that's not available in
kernel-headers. Otherwise feel free to use normal kernel header
includes and don't use vmlinux.h. If you are using BPF_CORE_READ(),
any type is automatically CO-RE-relocatable, even if they come from
#include <linux/whatever.h>. If you need to use direct memory accesses
with programs like fentry/fexit, then adding:

#pragma clang attribute push (__attribute__((preserve_access_index)),
apply_to = record)

before you include any headers would make types in those headers
automatically CO-RE-relocatable even for direct memory accesses. So
this is just something to keep in mind.


But the way we've been handling this was like this.

On BPF program side:

#include "vmlinux.h"
#include "my_custom_types.h"

...


On user-space program side:

#include <stdint.h> /* and whatever else is needed */
#include "my_custom_types.h"

Then in my_custom_types.h you just assume all the needed types are
defined (in either vmlinux.h or in user-space header includes):


struct my_struct {
    uint64_t whatever;
};

So far worked fine. It still sucks you can't include some of the
kernel headers to get some useful macro, but to solve that we'd need
Clang extension to check that some type X is already defined, as we
discussed in the call.

Hope this helps a bit.



[...]
