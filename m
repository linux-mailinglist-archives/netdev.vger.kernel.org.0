Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3ACC23E527
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 02:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgHGA3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 20:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgHGA3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 20:29:47 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BDFC061574;
        Thu,  6 Aug 2020 17:29:46 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id q16so99534ybk.6;
        Thu, 06 Aug 2020 17:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QARTPsLBc7jwLL0oggVuFMbGv3FDrMyjkwPVtFxQ7Yw=;
        b=BA+rcfnkP1ro1F1Obbfj6s/ZpxxwT6CYppR5d+CUJeTDHrLoyotRwgP3w6um7N6fRn
         7lpPlgHfUZuRDPmqflltqkyate98YGfvTWwynEMcClAIbWE/eH8g9o6U/77kzEpY4rq2
         C9zOa7Y36cnM2a0yPdHb7OBUh027GF9l4pJFoFoMBf5wJ+8BxDQdsMX1qGwWybTXbhVY
         /t6jGJOWNCdk0ev+x8o+jz5LtSbBTmp9xOTltVaD7S/L7CooIqQnop63bV7cGFwM/dNF
         HxSTdWK9SUfcKc0JNFA3JzyD7hBOkSme8T17K7XRyn0aLewY+c7B6JyntCZESHBxRNYp
         Eo/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QARTPsLBc7jwLL0oggVuFMbGv3FDrMyjkwPVtFxQ7Yw=;
        b=scabZ/znieVDX44wcGpsBEghFXPZMQ4o1+nPRqB7hyasYJ3zlh2mwV+sJpzMc+yShc
         8zkCLeRRbkM+3xcytETnazHLQb7/PWXmPUeIotpdc/UVeFkWDXEhK2b6tmoHhd3InSew
         QM3n/5HUKCFN3IF7eEV6Ym4KHEWcAj0hwLt4SE0JX6DFVNTni0fj82s3XIKVFiCVoE3j
         lZu4FQF2eI9HBWRi/p0aBPKFjAVX8XIgcmKlZKxVyNot19ARA0ffHGNFqMp3DHtcDeL8
         8nvl4apvYUwWaLlGxpA3aYgjSBI+XZPX1+Y+htgp2kz58z0Yvr28qi4a3SYtYf2lzjrG
         BJuw==
X-Gm-Message-State: AOAM53128PsR+xxMo/mjuGitxd+70Rv66/ygFcKCBjPvyVMEhq+TB5VX
        APeISJBm/BGRiNc2jYql3XzxasYvXkklZjAFz7Q=
X-Google-Smtp-Source: ABdhPJz1VVroPVEJo/vJ3a1DAqys6I8Z4MgbTAUtY4lgZnMJWdw2OF6UvSox6+BThxK9suteZRa5lKYkLbDfurk0ozA=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr16225387ybq.27.1596760185538;
 Thu, 06 Aug 2020 17:29:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200722054314.2103880-1-irogers@google.com> <CAEf4BzaBYaFJ3eUinS9nHeykJ0xEbZpwLts33ZDp1PT=bkyjww@mail.gmail.com>
 <CAP-5=fXMUWFs6YtQVuxjenCrOmKtKYCqZE3YofwdR=ArDYSwbQ@mail.gmail.com>
 <CAEf4BzYiY30de5qmiKeazG4ewyziXtdhHFFH4vjp1wi4iAXqiw@mail.gmail.com>
 <CAEf4BzZ_67M6nJZFL73ANYYARiErmv9aiYygw8JwJW4qyWGNog@mail.gmail.com> <CAP-5=fWUsQ2c=Rm_QL1uo8zBZzx0JtqArnMXCEC7-u3xRsHLdQ@mail.gmail.com>
In-Reply-To: <CAP-5=fWUsQ2c=Rm_QL1uo8zBZzx0JtqArnMXCEC7-u3xRsHLdQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 6 Aug 2020 17:29:34 -0700
Message-ID: <CAEf4BzbCH0s8N3QdzLD3NWUMwdAXcB2AEDyfy2+av1SVj6W96A@mail.gmail.com>
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

On Thu, Aug 6, 2020 at 12:42 PM Ian Rogers <irogers@google.com> wrote:
>
> On Thu, Aug 6, 2020 at 10:58 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Jul 31, 2020 at 8:47 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Fri, Jul 31, 2020 at 6:47 PM Ian Rogers <irogers@google.com> wrote:
> > > >
> > > > On Tue, Jul 21, 2020 at 11:58 PM Andrii Nakryiko
> > > > <andrii.nakryiko@gmail.com> wrote:
> > > > >
> > > > > On Tue, Jul 21, 2020 at 10:44 PM Ian Rogers <irogers@google.com> wrote:
> > > > > >
> > > > > > When bpftool dumps types and enum members into a header file for
> > > > > > inclusion the names match those in the original source. If the same
> > > > > > header file needs to be included in the original source and the bpf
> > > > > > program, the names of structs, unions, typedefs and enum members will
> > > > > > have naming collisions.
> > > > >
> > > > > vmlinux.h is not really intended to be used from user-space, because
> > > > > it's incompatible with pretty much any other header that declares any
> > > > > type. Ideally we should make this better, but that might require some
> > > > > compiler support. We've been discussing with Yonghong extending Clang
> > > > > with a compile-time check for whether some type is defined or not,
> > > > > which would allow to guard every type and only declare it
> > > > > conditionally, if it's missing. But that's just an idea at this point.
> > > >
> > > > Thanks Andrii! We're not looking at user-space code but the BPF code.
> > > > The prefix idea comes from a way to solve this problem in C++ with
> > > > namespaces:
> > > >
> > > > namespace vmlinux {
> > > > #include "vmlinux.h"
> > > > }
> > > >
> > > > As the BPF programs are C code then the prefix acts like the
> > > > namespace. It seems strange to need to extend the language.
> > >
> > > This is a classic case of jumping to designing a solution without
> > > discussing a real problem first :)
> > >
> > > You don't need to use any of the kernel headers together with
> > > vmlinux.h (and it won't work as well), because vmlinux.h is supposed
> > > to have all the **used** types from the kernel. So BPF programs only
> > > include vmlinux.h and few libbpf-provided headers with helpers. Which
> > > is why I assumed that you are trying to use it from user-space. But
> > > see below on what went wrong.
> > >
> > > >
> > > > > Regardless, vmlinux.h is also very much Clang-specific, and shouldn't
> > > > > work well with GCC. Could you elaborate on the specifics of the use
> > > > > case you have in mind? That could help me see what might be the right
> > > > > solution. Thanks!
> > > >
> > > > So the use-case is similar to btf_iter.h:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/testing/selftests/bpf/progs/bpf_iter.h
> > > > To avoid collisions with somewhat cleaner macro or not games.
> > > >
> > > > Prompted by your concern I was looking into changing bpf_iter.h to use
> > > > a prefix to show what the difference would be like. I also think that
> > > > there may be issues with our kernel and tool set up that may mean that
> > > > the prefix is unnecessary, if I fix something else. Anyway, to give an
> > > > example I needed to build the selftests but this is failing for me.
> > > > What I see is:
> > > >
> > > > $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
> > > > $ cd bpf-next
> > > > $ make defconfig
> > > > $ cat >>.config <<EOF
> > > > CONFIG_DEBUG_INFO=y
> > > > CONFIG_DEBUG_INFO_BTF=y
> > > > EOF
> > > > $ make -j all
> > > > $ mkdir /tmp/selftests
> > > > $ make O=/tmp/selftests/ TARGETS=bpf kselftest
> > > > ...
> > > >   CLANG    /tmp/selftests//kselftest/bpf/tools/build/bpftool/profiler.bpf.o
> > > > skeleton/profiler.bpf.c:18:21: error: invalid application of 'sizeof'
> > > > to an incomplete type 'struct bpf_perf_event_value'
> > > >         __uint(value_size, sizeof(struct bpf_perf_event_value));
> > > >                            ^     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > >
> > > > Checking with bpftool the vmlinux lacks struct bpf_perf_event_value
> > > > but as this is unconditionally defined in bpf.h this seems wrong. Do
> > > > you have any suggestions and getting a working build?
> > >
> > > It is unconditionally defined in bpf.h, but unless kernel code really
> > > uses that type for something, compiler won't generate DWARF
> > > information for that type, which subsequently won't get into BTF.
> > > Adding CONFIG_DEBUG_INFO_BTF=y ensures you get BTF type info
> > > generated, but only for subsystems that were compiled into vmlinux
> > > according to your kernel config.
> > >
> > > In this case, default config doesn't enable CONFIG_BPF_EVENTS, which
> > > is a requirement to compile kernel/trace/bpf_trace.c, which in turn
> > > uses struct bpf_perf_event_value in the helper signature.
> > >
> > > So the solution in your case would be to use a slightly richer kernel
> > > config, which enables more of the BPF subsystem. You can check
> > > selftests/bpf/config for a list of options we typically enable to run
> > > of selftests, for instance.
> > >
> >
> > So we've discussed this and related issues today at BPF office hours
> > and few more thoughts occurred to me after I left the call.
>
> Thanks for the follow-up. I need to add the office hours to my schedule.
>
> > You don't really have to use vmlinux.h, if it's inconvenient. Unless
> > you want to use some internal kernel type that's not available in
> > kernel-headers. Otherwise feel free to use normal kernel header
> > includes and don't use vmlinux.h. If you are using BPF_CORE_READ(),
> > any type is automatically CO-RE-relocatable, even if they come from
> > #include <linux/whatever.h>. If you need to use direct memory accesses
> > with programs like fentry/fexit, then adding:
> >
> > #pragma clang attribute push (__attribute__((preserve_access_index)),
> > apply_to = record)
> >
> > before you include any headers would make types in those headers
> > automatically CO-RE-relocatable even for direct memory accesses. So
> > this is just something to keep in mind.
> >
> >
> > But the way we've been handling this was like this.
> >
> > On BPF program side:
> >
> > #include "vmlinux.h"
> > #include "my_custom_types.h"
> >
> > ...
> >
> >
> > On user-space program side:
> >
> > #include <stdint.h> /* and whatever else is needed */
> > #include "my_custom_types.h"
> >
> > Then in my_custom_types.h you just assume all the needed types are
> > defined (in either vmlinux.h or in user-space header includes):
> >
> >
> > struct my_struct {
> >     uint64_t whatever;
> > };
> >
> > So far worked fine. It still sucks you can't include some of the
> > kernel headers to get some useful macro, but to solve that we'd need
> > Clang extension to check that some type X is already defined, as we
> > discussed in the call.
> >
> > Hope this helps a bit.
>
> Thanks, I was scratching around for examples because I was using a
> kernel that wasn't providing me even the values present in bpf.h. I
> looked at the bpf selftests as hopeful best practice, but that's where
> I saw the use of macros to move definitions out of the way:
>  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/testing/selftests/bpf/progs/bpf_iter.h
> This felt like my point of pain, so perhaps that code needs to carry a
> warning. Using #define to rename types, as in that file, doesn't scale
> for something like bpf.h and so this patch - which is intended to feel
> like a use of namespaces. There are related style issues (from the
> #define renaming) in Google's build system because of the use of
> modules [1] where this kind of "textual" use of headers is considered
> an issue.

This #define rename approach is definitely not a "best practice", but
we need it for selftests to be able to **compile** them against older
kernels. We need that as part of libbpf CI in its Github mirror. So we
unconditionally undefine those bpf_iter types, just in case we are
compiling on the latest kernels that already have those types.
selftests/bpf are purposefully testing all the latest bleeding-edge
features and generally assume latest Clang and kernel, so it has its
own specifics.

If you are looking for more realistic examples, consider looking at
libbpf-tools in BCC repo ([0]). Those are nice self-contained
libbpf/CO-RE-based tools. They use pre-generated and checked-in
vmlinux.h, which is much more convenient logistically, than generating
vmlinux.h on the fly. That, of course, depends on specific build
system organization, but we do pre-generate vmlinux.h at Facebook for
our production use-cases as well.

  [0] https://github.com/iovisor/bcc/tree/master/libbpf-tools


>
> I'm wondering, following this conversation whether there is some tech
> debt cleanup that could be done. For example, on the perf side I found
> that BPF errors were being swallowed:
> https://lore.kernel.org/lkml/20200707211449.3868944-1-irogers@google.com/
> Perf is defining its own bpf.h:
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/perf/include/bpf/bpf.h
> and perhaps that needs to be rethought to be more aligned with CO-RE
> and vmlinux.h.
> It would be nice if selftests could do a better job of building
> dependencies with the necessary config requirements. There's a lot of
> feeling around to make these things work, which seems less than ideal.

There is always some amount of tech debt, for sure. But I'm also not
sure how selftests/bpf can force kernel config on users. It provides
required config in selftests/bpf/config, but it's really easy to miss
it, if you don't know about it already. But then again, even that is
not enough for real-world-applicable vmlinux.h, you need to use one of
real production kernels to generate vmlinux.h that would work well for
production use cases. That's what we are also doing at Facebook, we
try to follow the latest production kernel releases and periodically
re-generate vmlinux.h to have all the new types. Hope this helps to
clarify a bit.

>
> Thanks,
> Ian
>
> [1] https://clang.llvm.org/docs/Modules.html
>
> > [...]
