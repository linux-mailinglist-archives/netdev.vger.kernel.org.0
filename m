Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A46026EA68
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730305AbfGSRy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 13:54:57 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40392 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbfGSRy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 13:54:57 -0400
Received: by mail-qt1-f194.google.com with SMTP id a15so31879537qtn.7;
        Fri, 19 Jul 2019 10:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7d3aGBz6LkG+RR9DaLwarbKWJi6CwckUgIiJYToduQc=;
        b=DXO4F4QQvsnbmfjB5tiiDMj55L3Gs+U53hz5KIEipZ4f2h785urtsn04uKKAu23Q6N
         Sa/vIKT27feyNzz6hC6ldZ8pPetKq2uKRGuz5n3JxXYoF3KuiPhC0PmkooMhHBT55oNP
         H2Yj73joZlm7qnx7HPWg6V9oGUZDK/IsF9uwwssZw3SU7OxsajLG68LQUXJN0+6Vxzv0
         II8VTSPLJn3X27JzNrZDBO60t0MNFl++eTh0a9lSRjt5dV5fD/54xTk9rNbTuRrEEYRJ
         MOJdmdql5bFvDURzQ1iPfn2lQi47fXKQRSale8SV9c/QCsy688x4w/m5KG51IqR9NpiJ
         Iu6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7d3aGBz6LkG+RR9DaLwarbKWJi6CwckUgIiJYToduQc=;
        b=J/BWdOi3jYzOl2E4msZ09SN/nN+dVtTOYz1YSkoOUonX1e89ASqB6YkwDYZ1suUfcQ
         gX0Dy7FGKPpFS3IvrTp73Nozlp8fFwkDC/ITR/IsrpVB+GhCuRGBCXOcAVhFczSDNGYX
         Yj9NJToPkfZk/mWhhby7Mru85mUGoNI1X4SzlNOXHYYRhgXj0AtVSxDl7w4YKmxec9UB
         oTMPa6Y4Mz57efVp+0ORRMlgmdgtH8lngHlYaekSc8dhbRI763xgJoRMNLbJX0Jxx5Xn
         1zyf/ldEM/vYMa6lXYsmkdv1K/d1Al5VnnqBeNbw6eBkSxm+ngMUWdJ57ukBEsp4tgdP
         JaCA==
X-Gm-Message-State: APjAAAV06PO2eslV5fJTWQY9R6WVm5yh4/Sgv+5Mh/nPGuNFm0pXnXp9
        o80xnfKmaja1DfWCjoN+YSP0crxEohcCihhK0lg=
X-Google-Smtp-Source: APXvYqzPseEEYHcoKZoLF3iv4cEkiY3bPXycnBh2fFwK+JGGIb0NQvVwRkjwZZXVE7oUB40677taABLD/b5EeFwWJd0=
X-Received: by 2002:ac8:32a1:: with SMTP id z30mr38865023qta.117.1563558895444;
 Fri, 19 Jul 2019 10:54:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190718172513.2394157-1-andriin@fb.com> <20190718175533.GG2093@redhat.com>
 <CAEf4BzaPySx-hBwD5Lxo1tD7F_8ejA9qFjC0-ag56cakweqcbA@mail.gmail.com>
 <20190718185619.GL3624@kernel.org> <20190718191452.GM3624@kernel.org>
 <CAEf4BzburdiRTYSJUSpSFAxKmf6ELpvEeNW502eKskzyyMaUxQ@mail.gmail.com> <20190719011644.GN3624@kernel.org>
In-Reply-To: <20190719011644.GN3624@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 19 Jul 2019 10:54:44 -0700
Message-ID: <CAEf4BzaKDTnqe4QYebNSoCLfhcUJbhzgXC5sG+y+c4JLc9PFqg@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix missing __WORDSIZE definition
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 6:16 PM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Thu, Jul 18, 2019 at 02:16:29PM -0700, Andrii Nakryiko escreveu:
> > On Thu, Jul 18, 2019 at 12:14 PM Arnaldo Carvalho de Melo
> > <arnaldo.melo@gmail.com> wrote:
> > >
> > > Em Thu, Jul 18, 2019 at 03:56:19PM -0300, Arnaldo Carvalho de Melo escreveu:
> > > > I'll stop and replace my patch with yours to see if it survives all the
> > > > test builds...
> > >
> > > So, Alpine:3.4, the first image for this distro I did when I started
> > > these builds, survives the 6 builds with gcc and clang with your patch:
> > >
> > >
> > > [perfbuilder@quaco linux-perf-tools-build]$ export PERF_TARBALL=http://192.168.124.1/perf/perf-5.2.0.tar.xz
> > > [perfbuilder@quaco linux-perf-tools-build]$ dm
> > >    1  alpine:3.4                    : Ok   gcc (Alpine 5.3.0) 5.3.0, clang version 3.8.0 (tags/RELEASE_380/final)
> > >
> > >
> > > [perfbuilder@quaco linux-perf-tools-build]$ grep "+ make" dm.log/alpine\:3.4
> > > + make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= -C /git/linux/tools/perf O=/tmp/build/perf
> > > + make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= NO_LIBELF=1 -C /git/linux/tools/perf O=/tmp/build/perf
> > > + make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= -C /git/linux/tools/perf O=/tmp/build/perf CC=clang
> > > + make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= NO_LIBELF=1 -C /git/linux/tools/perf O=/tmp/build/perf CC=clang
> > > + make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= LIBCLANGLLVM=1 -C /git/linux/tools/perf O=/tmp/build/perf CC=clang
> > > + make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= LIBCLANGLLVM=1 -C /git/linux/tools/perf O=/tmp/build/perf
> > > [perfbuilder@quaco linux-perf-tools-build]$
> > >
> > > Probably all the rest will go well, will let you know.
> > >
> > > Daniel, do you mind if I carry this one in my perf/core branch? Its
> > > small and shouldn't clash with other patches, I think. It should go
> > > upstream soon:
> > >
> > > Andrii, there are these others:
> >
> > I took a look at them, but I think it would be better, if you could
> > post them as proper patches to
> > bpf@vger.kernel.org/netdev@vger.kernel.org, so that others can check
> > and comment, if necessary.
> >
> > One nit for all three of them: we typically prefix subject with just
> > "libbpf: " instead of "tools lib libbpf".
>
> Sure, that was mechanic, I do it like that for the patches I upstream,
> and that was like that in the beginning:
>
> [acme@quaco perf]$ git log --oneline tools/lib/bpf | grep lib | tail
> 9d759a9b4ac2 tools lib bpf: Collect map definition in bpf_object
> d8ad6a15cc3a tools lib bpf: Don't do a feature check when cleaning
> 6371ca3b541c bpf tools: Improve libbpf error reporting
> 0c77c04aa9c2 tools lib bpf: Change FEATURE-DUMP to FEATURE-DUMP.libbpf
> 715f8db9102f tools lib bpf: Fix compiler warning on CentOS 6
> 7c422f557266 tools build: Build fixdep helper from perf and basic libs
> 65f041bee783 tools lib bpf: Use FEATURE_USER to allow building in the same dir as perf
> 20517cd9c593 tools lib bpf: Fix up FEATURE_{TESTS,DISPLAY} usage
> cc4228d57c4c bpf tools: Check endianness and make libbpf fail early
> 1b76c13e4b36 bpf tools: Introduce 'bpf' library and add bpf feature check
> [acme@quaco perf]$
>
> Anyway, I'll resubmit the patches that you acked to bpf@vger and will
> let my container tests fail for those cases, sticking a warning so that
> Ingo knows that this is being dealt with and those problems will get
> fixed soon when the bpf tree merges upstream.

Great, thanks!

>
> > >
> > > 8dfb6ed300bf tools lib bpf: Avoid designated initializers for unnamed union members
> >
> > + attr.sample_period = attr.wakeup_events = 1;
> >
> > let's instead
> >
> > + attr.sample_period = 1;
> > + attr.wakeup_events = 1;
> >
> > I don't like multi-assignments.
>
> Meh, what's wrong with it? :)

Nothing, objectively :) But I don't remember seeing multi-assignments
in libbpf code base, so nitpicking for consistency's sake....


>
> > Also, if we are doing explicit assignment, let's do it for all the
> > fields, not split initialization like that.
>
> If that is what takes to get it to build everywhere, no problem. In
> tools/perf I'm used to doing it, documents that this is an oddity to
> support more systems :)
>
> > > 80f7f8f21441 tools lib bpf: Avoid using 'link' as it shadows a global definition in some systems
> >
> > For this one I'm confused. What compiler/system you are getting it on?
>
> > I tried to reproduce it with this example (trying both global
> > variable, as well as function):
> >
> > #include <stdio.h>
> >
> > //int link = 1;
> > void link() {}
> >
> > int f(int link) {
> >         return link;
> > }
> > int main() {
> >         printf("%d\n", f(123));
> >         return 0;
> > }
> >
> > I haven't gotten any errors nor warnings. I'm certainly liking
> > existing naming better, but my main concern is that we'll probably add
> > more code like this, and we'll forget about this problem and will
> > re-introduce.
>
> yeah, this happens from time to time with centos:6 and IIRC
> amazonlinux:1, oraclelinux:6.
>
> I still remember when I got reports from the twitter guys when something
> broke on rhel:5, that was the main reason to get these container tests
> in place, you never know where people are using this, and since before
> upstreaming I do the tests, fixing those became second nature 8-)
>
> > So I'd rather figure out why it's happening and some rare system and
> > see if we can mitigate that without all the renames.

Ok, did some more googling. This warning (turned error in your setup)
is emitted when -Wshadow option is enabled for GCC/clang. It appears
to be disabled by default, so it must be enabled somewhere for perf
build or something.

Would it be possible to disable it at least for libbpf when building
from perf either everywhere or for those systems where you see this
warning? I don't think this warning is useful, to be honest, just
random name conflict between any local and global variables will cause
this.


> >
> >
> > > d93fe741e291 tools lib bpf: Fix endianness macro usage for some compilers
> >
> > This one looks good to me, thanks!
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> Ok, will collect this, change the prefix to: "libbpf: ..." and send to
> bpf@vger
>
> >
> > >
> > > If you could take a look at them at my tmp.perf/core branch at:
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/log/?h=tmp.perf/core
> > >
> > > I'm force pushing it now to replace my __WORDSIZE patch with yours, the
> > > SHAs should be the 3 above and the one below.
> > >
> > > And to build cleanly I had to cherry pick this one:
> > >
> > > 3091dafc1884 (HEAD -> perf/core) libbpf: fix ptr to u64 conversion warning on 32-bit platforms
> > >
> > > Alpine:3.5 just finished:
> > >
> > >    2 alpine:3.5                    : Ok   gcc (Alpine 6.2.1) 6.2.1 20160822, clang version 3.8.1 (tags/RELEASE_381/final)
> > >
> > > - Arnaldo
>
> --
>
> - Arnaldo
