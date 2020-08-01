Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4347723501D
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 05:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbgHADsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 23:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728446AbgHADsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 23:48:10 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39214C06174A;
        Fri, 31 Jul 2020 20:48:10 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id u43so3988537ybi.11;
        Fri, 31 Jul 2020 20:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c/VKXh7UvLXzf5Ss6lXp9OK9WrV8cuyA0Nh6MpLUhzA=;
        b=GHBXr5QrPvKWpevvVwA13dwxsztV9+uL0G4YR1OVG0pn4rUzARXgYugneALaCM8ES1
         ldN8CjLbCh4hree+GMjvotfruocRuzBmsAk5vicCymTovB0tA5oFekmmvysrc30Ikcfk
         IN8mn3tET2+VtTRaNrqZKSfAu7UANefKYoI9YtcTJWlQ84LG5xqKGFivbEf4H5u9zohq
         0KaFzK1kpOg9Hz+UjxrL0rSX5f3mjtLeaOHASsnm7nngdWGwOkOMoiOmjybrquKd0bwJ
         0XFdIwA2tpLgD2Vf1O1O/WpxT3WyaZWUl6mVGWYorsjizeaHx97FG2JlNuXzUTsM3wjO
         HFuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c/VKXh7UvLXzf5Ss6lXp9OK9WrV8cuyA0Nh6MpLUhzA=;
        b=JBd3OA7z/KpgV/tlD0s22Z8QfkGl4+OhMdPnDlAmejNQ2j4OF0A089albWC0eXjY8l
         iekUpqoMoaCRuhY7fhuHgqhja0AxelqAt4VP8x+Dw2pIe5D/HXpgcCgFgdOWSoHGv7su
         KoK66u10C6UIcJtnZTR12AeA3/V26VGHVOAvQi55JlZFaSopxQVaE8CNp8RQ1rahZlzh
         SjpvMtHtDe8U729m4jzUod4QJ1xxpYiFxQIugqtXzZPovtn4xWJL3Unad+lcg0PZHcSn
         9OH9GoevpHP+V+Rwr7RZ7Nx4DaczHxcHhX8w++Z+jTsSidDUXqgxfFeKk6XLBTMQIY3c
         ynfA==
X-Gm-Message-State: AOAM533tFd6X+4WYOSPYmDKL9CRIEzilWZTy7igm276lLwsJ47MGMHMv
        QLrL3zD9AhJa9tHvyyV2MD9Xir6FrEX8dIYC58k=
X-Google-Smtp-Source: ABdhPJzCZaX/HCnvio2867khHq3CLv9JnHH3oxo6ZAh7lQhvRKfCPUL33tAYT2nwxXPLi1IPA3P1xqcsGwpY5A5JWNs=
X-Received: by 2002:a25:824a:: with SMTP id d10mr11134630ybn.260.1596253689382;
 Fri, 31 Jul 2020 20:48:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200722054314.2103880-1-irogers@google.com> <CAEf4BzaBYaFJ3eUinS9nHeykJ0xEbZpwLts33ZDp1PT=bkyjww@mail.gmail.com>
 <CAP-5=fXMUWFs6YtQVuxjenCrOmKtKYCqZE3YofwdR=ArDYSwbQ@mail.gmail.com>
In-Reply-To: <CAP-5=fXMUWFs6YtQVuxjenCrOmKtKYCqZE3YofwdR=ArDYSwbQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 31 Jul 2020 20:47:58 -0700
Message-ID: <CAEf4BzYiY30de5qmiKeazG4ewyziXtdhHFFH4vjp1wi4iAXqiw@mail.gmail.com>
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
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 6:47 PM Ian Rogers <irogers@google.com> wrote:
>
> On Tue, Jul 21, 2020 at 11:58 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Jul 21, 2020 at 10:44 PM Ian Rogers <irogers@google.com> wrote:
> > >
> > > When bpftool dumps types and enum members into a header file for
> > > inclusion the names match those in the original source. If the same
> > > header file needs to be included in the original source and the bpf
> > > program, the names of structs, unions, typedefs and enum members will
> > > have naming collisions.
> >
> > vmlinux.h is not really intended to be used from user-space, because
> > it's incompatible with pretty much any other header that declares any
> > type. Ideally we should make this better, but that might require some
> > compiler support. We've been discussing with Yonghong extending Clang
> > with a compile-time check for whether some type is defined or not,
> > which would allow to guard every type and only declare it
> > conditionally, if it's missing. But that's just an idea at this point.
>
> Thanks Andrii! We're not looking at user-space code but the BPF code.
> The prefix idea comes from a way to solve this problem in C++ with
> namespaces:
>
> namespace vmlinux {
> #include "vmlinux.h"
> }
>
> As the BPF programs are C code then the prefix acts like the
> namespace. It seems strange to need to extend the language.

This is a classic case of jumping to designing a solution without
discussing a real problem first :)

You don't need to use any of the kernel headers together with
vmlinux.h (and it won't work as well), because vmlinux.h is supposed
to have all the **used** types from the kernel. So BPF programs only
include vmlinux.h and few libbpf-provided headers with helpers. Which
is why I assumed that you are trying to use it from user-space. But
see below on what went wrong.

>
> > Regardless, vmlinux.h is also very much Clang-specific, and shouldn't
> > work well with GCC. Could you elaborate on the specifics of the use
> > case you have in mind? That could help me see what might be the right
> > solution. Thanks!
>
> So the use-case is similar to btf_iter.h:
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/testing/selftests/bpf/progs/bpf_iter.h
> To avoid collisions with somewhat cleaner macro or not games.
>
> Prompted by your concern I was looking into changing bpf_iter.h to use
> a prefix to show what the difference would be like. I also think that
> there may be issues with our kernel and tool set up that may mean that
> the prefix is unnecessary, if I fix something else. Anyway, to give an
> example I needed to build the selftests but this is failing for me.
> What I see is:
>
> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
> $ cd bpf-next
> $ make defconfig
> $ cat >>.config <<EOF
> CONFIG_DEBUG_INFO=y
> CONFIG_DEBUG_INFO_BTF=y
> EOF
> $ make -j all
> $ mkdir /tmp/selftests
> $ make O=/tmp/selftests/ TARGETS=bpf kselftest
> ...
>   CLANG    /tmp/selftests//kselftest/bpf/tools/build/bpftool/profiler.bpf.o
> skeleton/profiler.bpf.c:18:21: error: invalid application of 'sizeof'
> to an incomplete type 'struct bpf_perf_event_value'
>         __uint(value_size, sizeof(struct bpf_perf_event_value));
>                            ^     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Checking with bpftool the vmlinux lacks struct bpf_perf_event_value
> but as this is unconditionally defined in bpf.h this seems wrong. Do
> you have any suggestions and getting a working build?

It is unconditionally defined in bpf.h, but unless kernel code really
uses that type for something, compiler won't generate DWARF
information for that type, which subsequently won't get into BTF.
Adding CONFIG_DEBUG_INFO_BTF=y ensures you get BTF type info
generated, but only for subsystems that were compiled into vmlinux
according to your kernel config.

In this case, default config doesn't enable CONFIG_BPF_EVENTS, which
is a requirement to compile kernel/trace/bpf_trace.c, which in turn
uses struct bpf_perf_event_value in the helper signature.

So the solution in your case would be to use a slightly richer kernel
config, which enables more of the BPF subsystem. You can check
selftests/bpf/config for a list of options we typically enable to run
of selftests, for instance.

>
> > > To avoid these collisions an approach is to redeclare the header file
> > > types and enum members, which leads to duplication and possible
> > > inconsistencies. Another approach is to use preprocessor macros
> > > to rename conflicting names, but this can be cumbersome if there are
> > > many conflicts.
> > >
> > > This patch adds a prefix option for the dumped names. Use of this option
> > > can avoid name conflicts and compile time errors.
> > >
> > > Signed-off-by: Ian Rogers <irogers@google.com>
> > > ---
> > >  .../bpf/bpftool/Documentation/bpftool-btf.rst |  7 ++++++-
> > >  tools/bpf/bpftool/btf.c                       | 18 ++++++++++++++---
> > >  tools/lib/bpf/btf.h                           |  1 +
> > >  tools/lib/bpf/btf_dump.c                      | 20 +++++++++++++------
> > >  4 files changed, 36 insertions(+), 10 deletions(-)
> > >
> >
> > [...]
> >
> > > diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> > > index 491c7b41ffdc..fea4baab00bd 100644
> > > --- a/tools/lib/bpf/btf.h
> > > +++ b/tools/lib/bpf/btf.h
> > > @@ -117,6 +117,7 @@ struct btf_dump;
> > >
> > >  struct btf_dump_opts {
> > >         void *ctx;
> > > +       const char *name_prefix;
> > >  };
> >
> > BTW, we can't do that, this breaks ABI. btf_dump_opts were added
> > before we understood the problem of backward/forward  compatibility of
> > libbpf APIs, unfortunately.
>
> This could be fixed by adding a "new" API for the parameter, which
> would be unfortunate compared to just amending the existing API. There
> may be solutions that are less duplicative.
>

Does ABI stability sucks for maintainers of the library? It absolutely
does! But we can't just go and break it.

> Thanks,
> Ian
>
> > >
> > >  typedef void (*btf_dump_printf_fn_t)(void *ctx, const char *fmt, va_list args);
> > > diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
> > > index e1c344504cae..baf2b4d82e1e 100644
> > > --- a/tools/lib/bpf/btf_dump.c
> > > +++ b/tools/lib/bpf/btf_dump.c
> >
> > [...]
