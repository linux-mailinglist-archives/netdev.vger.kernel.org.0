Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A64F6D444
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 20:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391076AbfGRS40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 14:56:26 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36989 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727762AbfGRS40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 14:56:26 -0400
Received: by mail-qt1-f196.google.com with SMTP id y26so28352376qto.4;
        Thu, 18 Jul 2019 11:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aFbBRSOwXpaUCLuFCS3V3eKtJEqKtgRj+pwY8MFhMDU=;
        b=eF9rdqj6HCgdG8KLux8Akkebe5WhA6K+e3gKESdC3bNS/Hze7YaXa6I3ltagMLJClV
         9hovoQvvNVOIPuncSftf+JQPzag7FhWlKPnLkqGkTe9EPuo5XKoXMPAd6sxqssypAG0V
         gNDW6HLF7RxE3n0OChNi5XwZH+djQPattolQ45f1PyT/K2O00n7s6e+jManNauxQHPYb
         ouwsFXkAZHlysN5U+Z/v5coQ9Dc710qfpA814ZrrjxfI2FwROICRx7OOadd3Q1Jm166H
         qCWzhvtahtlUZ8pLawIMyFlr0hV2fbO8tUUMeLJqPWminJB5jROcCYJgvrKzI4ESCnce
         BOJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aFbBRSOwXpaUCLuFCS3V3eKtJEqKtgRj+pwY8MFhMDU=;
        b=Q07rEyEtsFxRwZwTN3X2OY5wohB1Ufex/8UdIi4Y0SEnbuqjBW+dyK6POm+Goy2IFF
         sNGTfY9mYzUf3k5VPSLe6HLGfa/3cAXUvrxPBqsawaTGUO91NGY1Xk1ZDc77gA7Sf4+F
         YxeYbVi3gKmOtLTWwI6uCinwTA2wKiZOZGrRgOOBeAXOjYzYbtO8CWtYT8fBxX44Eeh7
         Qz9y/9EUkPoMZmXZkfgHNdDXZPKgl7YIh1hSB2vNc8waCaTgGNL+xwL+6omI++JTPKiq
         JXn3Y0I/5KKQd16tZW5Vvv+c+kGBd3xsW43udy+o3UHkvSWIaz2uV9V2c9xxc5l5V8Nm
         BiuA==
X-Gm-Message-State: APjAAAW+iVOVMF1Qn/Y4qlEbCKUXQCDnwFw06xNsc7RqhE7yYrgTwsRL
        Z0bI/qFYpbIZGd0QcYzNcv0=
X-Google-Smtp-Source: APXvYqzTXrMW4lUz4x5L0S/EnkAgh0kOzN7CCnoxfzHs9CRfWmpCnsqwbKmvNCVSCf6aYh8Eq99MJQ==
X-Received: by 2002:aed:220e:: with SMTP id n14mr34069953qtc.388.1563476184611;
        Thu, 18 Jul 2019 11:56:24 -0700 (PDT)
Received: from quaco.ghostprotocols.net (179-240-162-69.3g.claro.net.br. [179.240.162.69])
        by smtp.gmail.com with ESMTPSA id p13sm10802808qkj.4.2019.07.18.11.56.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 11:56:23 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 9059540340; Thu, 18 Jul 2019 15:56:19 -0300 (-03)
Date:   Thu, 18 Jul 2019 15:56:19 -0300
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix missing __WORDSIZE definition
Message-ID: <20190718185619.GL3624@kernel.org>
References: <20190718172513.2394157-1-andriin@fb.com>
 <20190718175533.GG2093@redhat.com>
 <CAEf4BzaPySx-hBwD5Lxo1tD7F_8ejA9qFjC0-ag56cakweqcbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaPySx-hBwD5Lxo1tD7F_8ejA9qFjC0-ag56cakweqcbA@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Jul 18, 2019 at 11:04:04AM -0700, Andrii Nakryiko escreveu:
> On Thu, Jul 18, 2019 at 10:55 AM Arnaldo Carvalho de Melo
> <arnaldo.melo@gmail.com> wrote:
> >
> > Em Thu, Jul 18, 2019 at 10:25:13AM -0700, Andrii Nakryiko escreveu:
> > > hashmap.h depends on __WORDSIZE being defined. It is defined by
> > > glibc/musl in different headers. It's an explicit goal for musl to be
> > > "non-detectable" at compilation time, so instead include glibc header if
> > > glibc is explicitly detected and fall back to musl header otherwise.
> > >
> > > Fixes: e3b924224028 ("libbpf: add resizable non-thread safe internal hashmap")
> > > Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >
> > I fixed this here differently, as below, I didn't send it because I'm still
> > testing it, so far, with a few other fixes and cherry-picking "libbpf: fix ptr
> > to u64 conversion warning on 32-bit platforms" that is still in the bpf tree
> > and is needed for the cross build containers in my suite that are 32-bit, I
> > have the results below, this builds perf + libbpf (where elfutils is available,
> > which is in most cases, except the uCLibc containers due to missing argp-devel),
> > with gcc and with clang:
> >
> > [perfbuilder@quaco linux-perf-tools-build]$ export PERF_TARBALL=http://192.168.124.1/perf/perf-5.2.0.tar.xz
> > [perfbuilder@quaco linux-perf-tools-build]$ time dm
> >    1 alpine:3.4                    : Ok   gcc (Alpine 5.3.0) 5.3.0, clang version 3.8.0 (tags/RELEASE_380/final)
> >    2 alpine:3.5                    : Ok   gcc (Alpine 6.2.1) 6.2.1 20160822, clang version 3.8.1 (tags/RELEASE_381/final)
> >    3 alpine:3.6                    : Ok   gcc (Alpine 6.3.0) 6.3.0, clang version 4.0.0 (tags/RELEASE_400/final)
> >    4 alpine:3.7                    : Ok   gcc (Alpine 6.4.0) 6.4.0, Alpine clang version 5.0.0 (tags/RELEASE_500/final) (based on LLVM 5.0.0)
> >    5 alpine:3.8                    : Ok   gcc (Alpine 6.4.0) 6.4.0, Alpine clang version 5.0.1 (tags/RELEASE_501/final) (based on LLVM 5.0.1)
> >    6 alpine:3.9                    : Ok   gcc (Alpine 8.3.0) 8.3.0, Alpine clang version 5.0.1 (tags/RELEASE_502/final) (based on LLVM 5.0.1)
> >    7 alpine:3.10                   : Ok   gcc (Alpine 8.3.0) 8.3.0, Alpine clang version 8.0.0 (tags/RELEASE_800/final) (based on LLVM 8.0.0)
> >    8 alpine:edge                   : Ok   gcc (Alpine 8.3.0) 8.3.0, Alpine clang version 7.0.1 (tags/RELEASE_701/final) (based on LLVM 7.0.1)
> >    9 amazonlinux:1                 : Ok   gcc (GCC) 7.2.1 20170915 (Red Hat 7.2.1-2), clang version 3.6.2 (tags/RELEASE_362/final)
> >   10 amazonlinux:2                 : Ok   gcc (GCC) 7.3.1 20180303 (Red Hat 7.3.1-5), clang version 7.0.1 (Amazon Linux 2 7.0.1-1.amzn2.0.2)
> >   11 android-ndk:r12b-arm          : Ok   arm-linux-androideabi-gcc (GCC) 4.9.x 20150123 (prerelease)
> >   12 android-ndk:r15c-arm          : Ok   arm-linux-androideabi-gcc (GCC) 4.9.x 20150123 (prerelease)
> >   13 centos:5                      : Ok   gcc (GCC) 4.1.2 20080704 (Red Hat 4.1.2-55)
> >   14 centos:6                      : Ok   gcc (GCC) 4.4.7 20120313 (Red Hat 4.4.7-23)
> >   15 centos:7                      : Ok   gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-36), clang version 3.4.2 (tags/RELEASE_34/dot2-final)
> >   16 clearlinux:latest             : Ok   gcc (Clear Linux OS for Intel Architecture) 9.1.1 20190628 gcc-9-branch@272773, clang version 8.0.0 (tags/RELEASE_800/final)
> >   17 debian:8                      : Ok   gcc (Debian 4.9.2-10+deb8u2) 4.9.2, Debian clang version 3.5.0-10 (tags/RELEASE_350/final) (based on LLVM 3.5.0)
> >   18 debian:9                      : Ok   gcc (Debian 6.3.0-18+deb9u1) 6.3.0 20170516, clang version 3.8.1-24 (tags/RELEASE_381/final)
> >   19 debian:10                     : Ok   gcc (Debian 8.3.0-6) 8.3.0, clang version 7.0.1-8 (tags/RELEASE_701/final)
> >   20 debian:experimental           : Ok   gcc (Debian 8.3.0-19) 8.3.0, clang version 7.0.1-8 (tags/RELEASE_701/final)
> >   21 debian:experimental-x-arm64   : Ok   aarch64-linux-gnu-gcc (Debian 8.3.0-19) 8.3.0
> >   22 debian:experimental-x-mips    : Ok   mips-linux-gnu-gcc (Debian 8.3.0-19) 8.3.0
> >   23 debian:experimental-x-mips64  : Ok   mips64-linux-gnuabi64-gcc (Debian 8.3.0-7) 8.3.0
> >   24 debian:experimental-x-mipsel  : Ok   mipsel-linux-gnu-gcc (Debian 8.3.0-19) 8.3.0
> >   25 fedora:20                     : Ok   gcc (GCC) 4.8.3 20140911 (Red Hat 4.8.3-7), clang version 3.4.2 (tags/RELEASE_34/dot2-final)
> >   26 fedora:22                     : Ok   gcc (GCC) 5.3.1 20160406 (Red Hat 5.3.1-6), clang version 3.5.0 (tags/RELEASE_350/final)
> >   27 fedora:23                     : Ok   gcc (GCC) 5.3.1 20160406 (Red Hat 5.3.1-6), clang version 3.7.0 (tags/RELEASE_370/final)
> >   28 fedora:24                     : Ok   gcc (GCC) 6.3.1 20161221 (Red Hat 6.3.1-1), clang version 3.8.1 (tags/RELEASE_381/final)
> >   29 fedora:24-x-ARC-uClibc        : Ok   arc-linux-gcc (ARCompact ISA Linux uClibc toolchain 2017.09-rc2) 7.1.1 20170710
> >
> > I've pushed it to a tmp.perf/core branch in my
> > git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tree, that has
> > these:
> >
> > d5e1f2d60d41 (HEAD -> perf/core, acme.korg/tmp.perf/core) libbpf: fix ptr to u64 conversion warning on 32-bit platforms
> > 7c08fd16f917 tools lib bpf: Avoid designated initializers for unnamed union members
> > 4c9f83c95ad6 tools lib bpf: Avoid using 'link' as it shadows a global definition in some systems
> > bdb07df4a0ad tools lib bpf: Fix endianness macro usage for some compilers
> > 66dbf3caff52 tools lib bpf: Replace __WORDSIZE with BITS_PER_LONG to build on the musl libc
> >
> > Please take a look and check if everything is fine on your side. The HEAD I'll
> > remove if Daniel thinks it should wait that landing via the BPF tree, I just put it
> > there for the test builds.
> >
> > commit 66dbf3caff52be0d004bcb9ac4cea4c19eb75dfc
> > Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Date:   Thu Jul 18 09:46:28 2019 -0300
> >
> >     tools lib bpf: Replace __WORDSIZE with BITS_PER_LONG to build on the musl libc
> >
> >     BITS_PER_LONG is more generally available and equivalent to __WORDSIZE,
> >     so use it instead to keep it building in systems using the mustl libc
> >     where __WORDSIZE is in a different place than in glibc.
> >
> >     And do this by explicitely adding the header where this definition is
> >     (asm/bitsperlong.h) instead of getting it indirectly.
> >
> >     Cc: Adrian Hunter <adrian.hunter@intel.com>
> >     Cc: Alexei Starovoitov <ast@kernel.org>
> >     Cc: Andrii Nakryiko <andriin@fb.com>
> >     Cc: Jiri Olsa <jolsa@kernel.org>
> >     Cc: Namhyung Kim <namhyung@kernel.org>
> >     Fixes: e3b924224028 ("libbpf: add resizable non-thread safe internal hashmap")
> >     Link: https://lkml.kernel.org/n/tip-61vydgldzmmz5w2mf6rv3ryl@git.kernel.org
> >     Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> >
> > diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> > index 03748a742146..f1f37b574d9c 100644
> > --- a/tools/lib/bpf/hashmap.h
> > +++ b/tools/lib/bpf/hashmap.h
> > @@ -10,12 +10,13 @@
> >
> >  #include <stdbool.h>
> >  #include <stddef.h>
> > +#include <asm/bitsperlong.h>
> 
> Relying on this header is problematic when syncing libbpf into Github
> mirror. There we'll need to re-implement it anyway, and again,
> probably through __WORDSIZE or some other tricks. So if we can do away
> without kernel specific header that would be great.

[acme@quaco perf]$ rpm -qf /usr/include/asm/bitsperlong.h 
kernel-headers-5.1.16-300.fc30.x86_64

It is kernel specific, but it comes from a distro package, and one that
is even required to build anything that uses glibc:

[acme@quaco perf]$ rpm -q --whatrequires kernel-headers
glibc-headers-2.29-15.fc30.x86_64
audit-libs-devel-3.0-0.9.20190507gitf58ec40.fc30.x86_64
libnl3-devel-3.4.0-8.fc30.x86_64
[acme@quaco perf]$
[acme@quaco perf]$ rpm -q --whatrequires glibc-headers
glibc-devel-2.29-15.fc30.x86_64
[acme@quaco perf]$

It is available everywhere:

Alpine, for instance:

$ dsh alpine:3.10
/ $ apk info --who-owns /usr/include/asm/bitsperlong.h
/usr/include/asm/bitsperlong.h is owned by linux-headers-4.19.36-r0
/ $
/ $ cat /etc/alpine-release
3.10.0

OpenSuSE:

$ dsh opensuse:42.3
sh-4.3$ grep PRETTY /etc/os-release
PRETTY_NAME="openSUSE Leap 42.3"
sh-4.3$ ls -la /usr/include/asm/bitsperlong.h
-rw-r--r--. 1 root root 258 Jan 15  2016 /usr/include/asm/bitsperlong.h
sh-4.3$ set -o vi
sh-4.3$ rpm -qf /usr/include/asm/bitsperlong.h
linux-glibc-devel-4.4-6.3.1.noarch
sh-4.3$
sh-4.3$ exit

ClearLinux:

$ dsh clearlinux:latest
sh-5.0$ ls -la /usr/include/asm/bitsperlong.h
-rw-r--r-- 2 root root 321 Feb  1 20:26 /usr/include/asm/bitsperlong.h
sh-5.0$

I see what you mean tho, tools/arch and tools/include _have_
bitsperlong.h as well and the perf build is using that... And I checked
and the above don't have BITS_PER_LONG, just some have __BITS_PER_LONG,
etc... /me scratches head, so what we ended up in the tools/include to
solve that was:
#ifdef __SIZEOF_LONG__
#define BITS_PER_LONG (__CHAR_BIT__ * __SIZEOF_LONG__)
#else
#define BITS_PER_LONG __WORDSIZE
#endif

To help in you deciding how you want to fix this:

commit e81fcd43723d32e9c9dbb8e8d66f147b5b84256b
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri Jul 15 12:38:18 2016 -0300

    tools: Simplify BITS_PER_LONG define

    Do it using (__CHAR_BIT__ * __SIZEOF_LONG__), simpler, works everywhere,
    reduces the complexity by ditching CONFIG_64BIT, that was being
    synthesized from yet another set of defines, which proved fragile,
    breaking the build on linux-next for no obvious reasons.

    Committer Note:

    Except on:

    gcc version 4.1.2 20080704 (Red Hat 4.1.2-55)

    Fallback to __WORDSIZE in that case...

    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
    Cc: Andy Lutomirski <luto@amacapital.net>
    Cc: H. Peter Anvin <hpa@zytor.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Link: http://lkml.kernel.org/r/20160715072243.GP30154@twins.programming.kicks-ass.net
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Using the tools/{include,arch} headers as perf does it is continuing to
build without failures, in addition to the set of containers first
reported:

  30 fedora:25                     : Ok   gcc (GCC) 6.4.1 20170727 (Red Hat 6.4.1-1), clang version 3.9.1 (tags/RELEASE_391/final)
  31 fedora:26                     : Ok   gcc (GCC) 7.3.1 20180130 (Red Hat 7.3.1-2), clang version 4.0.1 (tags/RELEASE_401/final)
  32 fedora:27                     : Ok   gcc (GCC) 7.3.1 20180712 (Red Hat 7.3.1-6), clang version 5.0.2 (tags/RELEASE_502/final)
  33 fedora:28                     : Ok   gcc (GCC) 8.3.1 20190223 (Red Hat 8.3.1-2), clang version 6.0.1 (tags/RELEASE_601/final)
  34 fedora:29                     : Ok   gcc (GCC) 8.3.1 20190223 (Red Hat 8.3.1-2), clang version 7.0.1 (Fedora 7.0.1-6.fc29)
  35 fedora:30                     : Ok   gcc (GCC) 9.1.1 20190503 (Red Hat 9.1.1-1), clang version 8.0.0 (Fedora 8.0.0-1.fc30)
  36 fedora:30-x-ARC-glibc         : Ok   arc-linux-gcc (ARC HS GNU/Linux glibc toolchain 2019.03-rc1) 8.3.1 20190225
  37 fedora:30-x-ARC-uClibc        : Ok   arc-linux-gcc (ARCv2 ISA Linux uClibc toolchain 2019.03-rc1) 8.3.1 20190225
  38 fedora:31                     : Ok   gcc (GCC) 9.1.1 20190605 (Red Hat 9.1.1-2), clang version 8.0.0 (Fedora 8.0.0-3.fc31)
  39 fedora:rawhide                : Ok   gcc (GCC) 9.1.1 20190605 (Red Hat 9.1.1-2), clang version 8.0.0 (Fedora 8.0.0-3.fc31)
  40 gentoo-stage3-amd64:latest    : Ok   gcc (Gentoo 8.3.0-r1 p1.1) 8.3.0
  41 mageia:5                      : Ok   gcc (GCC) 4.9.2, clang version 3.5.2 (tags/RELEASE_352/final)
  42 mageia:6                      : Ok   gcc (Mageia 5.5.0-1.mga6) 5.5.0, clang version 3.9.1 (tags/RELEASE_391/final)

I'll stop and replace my patch with yours to see if it survives all the
test builds...

- Arnaldo
 
> >  #include "libbpf_internal.h"
> >
> >  static inline size_t hash_bits(size_t h, int bits)
> >  {
> >         /* shuffle bits and return requested number of upper bits */
> > -       return (h * 11400714819323198485llu) >> (__WORDSIZE - bits);
> > +       return (h * 11400714819323198485llu) >> (BITS_PER_LONG - bits);
> >  }
> >
> >  typedef size_t (*hashmap_hash_fn)(const void *key, void *ctx);

-- 

- Arnaldo
