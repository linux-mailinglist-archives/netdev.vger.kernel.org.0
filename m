Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFDC6EA8C
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 20:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731330AbfGSSOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 14:14:31 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45625 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728427AbfGSSOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 14:14:31 -0400
Received: by mail-qk1-f196.google.com with SMTP id s22so23909725qkj.12;
        Fri, 19 Jul 2019 11:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WRx85tHV8NY2PGtr51g5s6wdHYWbH2ahlIUvdNf/Huk=;
        b=tWNZIanEG8rkDWlesW5f4Y7Dm70A/6niDm6x5lYDpg4/JTA0qt8GMqSBivRr2TWVMy
         5RjFXKkIzDB3prjb3/QNICTlhxYfV/1zvNRfe6XrYZDOfKBXxYsXJOT9D3qm+x2BMwgn
         /4F/Qz4WwcEKbjoqo2eTC7MD58CCHQnBYP41u+wkBB+SeQAuAu02oMqr7JC43vEW872J
         6ow/j3hM9Z1RR1nfLSCDB6gkwEucNfXtjj8Bi+OO4evfti7cQqQRNF+9EpUY0oFXx7WL
         1tVnlY4RYcIYjqAg1irDADJNJf6KIjkkghwg5MsPO8lbss2uRIk4eRh/vo69UyKkfLIN
         w06A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WRx85tHV8NY2PGtr51g5s6wdHYWbH2ahlIUvdNf/Huk=;
        b=iMlQmFPeq/GADv7R1g1QFW8MPrcs3W0bYUQ1+zZOV9fOgTMaQ14P/vIqUnWcaTrCMi
         k5DfBAaNwiAao/Cl9qDFSAYQVtw3PuX9RshrOk/MkjXN2Dw6QRWj3oTAuo0a3xq3abB4
         HklkG/uDwnhzsgQZ/EKQHhjW/oJkNrD/Pewdn+wD6zrOVQ8af6U0Qhwy9xFt8ALmqImr
         KVqoLYUl8/aF2zhq58nRF28hbabOex2sJOJjEaLpPM50uWYgCnFYopXwkW2Zp0lhxoqN
         ESx3DijyhjGm5ONmY1YTHsgWR67XKv5zoQ1UpBmdfexVjd+RMHMzFsggQl1XYtBauhIS
         GOig==
X-Gm-Message-State: APjAAAVI8ezItp0pORb+c24javgyPFRc3YNP9ZU/tn68yLFpruCzf3A/
        EnSlpc1K9Sg5kBn28PkZPV8=
X-Google-Smtp-Source: APXvYqzA80vBgF3nIV3U7it9e6TuPMTiBkeRF4CVKatfdko8+BNkl7z+JvZzz7D82mY9Gn3ATlTU1w==
X-Received: by 2002:a05:620a:1017:: with SMTP id z23mr37137128qkj.60.1563560069608;
        Fri, 19 Jul 2019 11:14:29 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([190.15.121.82])
        by smtp.gmail.com with ESMTPSA id i16sm13427260qkk.1.2019.07.19.11.14.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 11:14:28 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 0438540340; Fri, 19 Jul 2019 15:14:24 -0300 (-03)
Date:   Fri, 19 Jul 2019 15:14:23 -0300
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix missing __WORDSIZE definition
Message-ID: <20190719181423.GO3624@kernel.org>
References: <20190718172513.2394157-1-andriin@fb.com>
 <20190718175533.GG2093@redhat.com>
 <CAEf4BzaPySx-hBwD5Lxo1tD7F_8ejA9qFjC0-ag56cakweqcbA@mail.gmail.com>
 <20190718185619.GL3624@kernel.org>
 <20190718191452.GM3624@kernel.org>
 <CAEf4BzburdiRTYSJUSpSFAxKmf6ELpvEeNW502eKskzyyMaUxQ@mail.gmail.com>
 <20190719011644.GN3624@kernel.org>
 <CAEf4BzaKDTnqe4QYebNSoCLfhcUJbhzgXC5sG+y+c4JLc9PFqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaKDTnqe4QYebNSoCLfhcUJbhzgXC5sG+y+c4JLc9PFqg@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Jul 19, 2019 at 10:54:44AM -0700, Andrii Nakryiko escreveu:
> On Thu, Jul 18, 2019 at 6:16 PM Arnaldo Carvalho de Melo
> <arnaldo.melo@gmail.com> wrote:
> >
> > Em Thu, Jul 18, 2019 at 02:16:29PM -0700, Andrii Nakryiko escreveu:
> > > On Thu, Jul 18, 2019 at 12:14 PM Arnaldo Carvalho de Melo
> > > <arnaldo.melo@gmail.com> wrote:
> > > >
> > > > Em Thu, Jul 18, 2019 at 03:56:19PM -0300, Arnaldo Carvalho de Melo escreveu:
> > > > > I'll stop and replace my patch with yours to see if it survives all the
> > > > > test builds...
> > > >
> > > > So, Alpine:3.4, the first image for this distro I did when I started
> > > > these builds, survives the 6 builds with gcc and clang with your patch:
> > > >
> > > >
> > > > [perfbuilder@quaco linux-perf-tools-build]$ export PERF_TARBALL=http://192.168.124.1/perf/perf-5.2.0.tar.xz
> > > > [perfbuilder@quaco linux-perf-tools-build]$ dm
> > > >    1  alpine:3.4                    : Ok   gcc (Alpine 5.3.0) 5.3.0, clang version 3.8.0 (tags/RELEASE_380/final)
> > > >
> > > >
> > > > [perfbuilder@quaco linux-perf-tools-build]$ grep "+ make" dm.log/alpine\:3.4
> > > > + make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= -C /git/linux/tools/perf O=/tmp/build/perf
> > > > + make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= NO_LIBELF=1 -C /git/linux/tools/perf O=/tmp/build/perf
> > > > + make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= -C /git/linux/tools/perf O=/tmp/build/perf CC=clang
> > > > + make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= NO_LIBELF=1 -C /git/linux/tools/perf O=/tmp/build/perf CC=clang
> > > > + make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= LIBCLANGLLVM=1 -C /git/linux/tools/perf O=/tmp/build/perf CC=clang
> > > > + make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= LIBCLANGLLVM=1 -C /git/linux/tools/perf O=/tmp/build/perf
> > > > [perfbuilder@quaco linux-perf-tools-build]$
> > > >
> > > > Probably all the rest will go well, will let you know.
> > > >
> > > > Daniel, do you mind if I carry this one in my perf/core branch? Its
> > > > small and shouldn't clash with other patches, I think. It should go
> > > > upstream soon:
> > > >
> > > > Andrii, there are these others:
> > >
> > > I took a look at them, but I think it would be better, if you could
> > > post them as proper patches to
> > > bpf@vger.kernel.org/netdev@vger.kernel.org, so that others can check
> > > and comment, if necessary.
> > >
> > > One nit for all three of them: we typically prefix subject with just
> > > "libbpf: " instead of "tools lib libbpf".
> >
> > Sure, that was mechanic, I do it like that for the patches I upstream,
> > and that was like that in the beginning:
> >
> > [acme@quaco perf]$ git log --oneline tools/lib/bpf | grep lib | tail
> > 9d759a9b4ac2 tools lib bpf: Collect map definition in bpf_object
> > d8ad6a15cc3a tools lib bpf: Don't do a feature check when cleaning
> > 6371ca3b541c bpf tools: Improve libbpf error reporting
> > 0c77c04aa9c2 tools lib bpf: Change FEATURE-DUMP to FEATURE-DUMP.libbpf
> > 715f8db9102f tools lib bpf: Fix compiler warning on CentOS 6
> > 7c422f557266 tools build: Build fixdep helper from perf and basic libs
> > 65f041bee783 tools lib bpf: Use FEATURE_USER to allow building in the same dir as perf
> > 20517cd9c593 tools lib bpf: Fix up FEATURE_{TESTS,DISPLAY} usage
> > cc4228d57c4c bpf tools: Check endianness and make libbpf fail early
> > 1b76c13e4b36 bpf tools: Introduce 'bpf' library and add bpf feature check
> > [acme@quaco perf]$
> >
> > Anyway, I'll resubmit the patches that you acked to bpf@vger and will
> > let my container tests fail for those cases, sticking a warning so that
> > Ingo knows that this is being dealt with and those problems will get
> > fixed soon when the bpf tree merges upstream.
> 
> Great, thanks!
> 
> >
> > > >
> > > > 8dfb6ed300bf tools lib bpf: Avoid designated initializers for unnamed union members
> > >
> > > + attr.sample_period = attr.wakeup_events = 1;
> > >
> > > let's instead
> > >
> > > + attr.sample_period = 1;
> > > + attr.wakeup_events = 1;
> > >
> > > I don't like multi-assignments.
> >
> > Meh, what's wrong with it? :)
> 
> Nothing, objectively :) But I don't remember seeing multi-assignments
> in libbpf code base, so nitpicking for consistency's sake....
> 
> 
> >
> > > Also, if we are doing explicit assignment, let's do it for all the
> > > fields, not split initialization like that.
> >
> > If that is what takes to get it to build everywhere, no problem. In
> > tools/perf I'm used to doing it, documents that this is an oddity to
> > support more systems :)
> >
> > > > 80f7f8f21441 tools lib bpf: Avoid using 'link' as it shadows a global definition in some systems
> > >
> > > For this one I'm confused. What compiler/system you are getting it on?
> >
> > > I tried to reproduce it with this example (trying both global
> > > variable, as well as function):
> > >
> > > #include <stdio.h>
> > >
> > > //int link = 1;
> > > void link() {}
> > >
> > > int f(int link) {
> > >         return link;
> > > }
> > > int main() {
> > >         printf("%d\n", f(123));
> > >         return 0;
> > > }
> > >
> > > I haven't gotten any errors nor warnings. I'm certainly liking
> > > existing naming better, but my main concern is that we'll probably add
> > > more code like this, and we'll forget about this problem and will
> > > re-introduce.
> >
> > yeah, this happens from time to time with centos:6 and IIRC
> > amazonlinux:1, oraclelinux:6.
> >
> > I still remember when I got reports from the twitter guys when something
> > broke on rhel:5, that was the main reason to get these container tests
> > in place, you never know where people are using this, and since before
> > upstreaming I do the tests, fixing those became second nature 8-)
> >
> > > So I'd rather figure out why it's happening and some rare system and
> > > see if we can mitigate that without all the renames.
> 
> Ok, did some more googling. This warning (turned error in your setup)
> is emitted when -Wshadow option is enabled for GCC/clang. It appears
> to be disabled by default, so it must be enabled somewhere for perf
> build or something.

Right, I came to the exact same conclusion, doing tests here:

[perfbuilder@3a58896a648d tmp]$ gcc -Wshadow shadow_global_decl.c   -o shadow_global_decl
shadow_global_decl.c: In function 'main':
shadow_global_decl.c:9: warning: declaration of 'link' shadows a global declaration
shadow_global_decl.c:4: warning: shadowed declaration is here
[perfbuilder@3a58896a648d tmp]$ gcc --version |& head -1
gcc (GCC) 4.4.7 20120313 (Red Hat 4.4.7-23)
[perfbuilder@3a58896a648d tmp]$ gcc shadow_global_decl.c   -o shadow_global_decl
[perfbuilder@3a58896a648d tmp]$ 

So I'm going to remove this warning from the places where it causes
problems.

> Would it be possible to disable it at least for libbpf when building
> from perf either everywhere or for those systems where you see this
> warning? I don't think this warning is useful, to be honest, just
> random name conflict between any local and global variables will cause
> this.

Yeah, I might end up having this applied.

[acme@quaco perf]$ git diff
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 495066bafbe3..b6e902a2312f 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -32,7 +32,6 @@ EXTRA_WARNINGS += -Wno-system-headers
 EXTRA_WARNINGS += -Wold-style-definition
 EXTRA_WARNINGS += -Wpacked
 EXTRA_WARNINGS += -Wredundant-decls
-EXTRA_WARNINGS += -Wshadow
 EXTRA_WARNINGS += -Wstrict-prototypes
 EXTRA_WARNINGS += -Wswitch-default
 EXTRA_WARNINGS += -Wswitch-enum
[acme@quaco perf]$


Sorry for the noise...

- Arnaldo
