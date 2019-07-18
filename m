Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0C46D36D
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 20:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390368AbfGRSER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 14:04:17 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46951 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387815AbfGRSER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 14:04:17 -0400
Received: by mail-qt1-f194.google.com with SMTP id h21so28127138qtn.13;
        Thu, 18 Jul 2019 11:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BMtI8iXYEKCct6oAZQbFTWHKTZ52NdcALBMk5wfK+Vw=;
        b=BdXW20e1NUqfhj2zipibqlMgnLAa0/jqdkuchP70Mng1/pfvcC0CI0cn3S8cf0H7eO
         oWpWC360agDTsn8GKNGDxvULX0kVlJo3JmdwjxD8jFPHNB2UIPCkyc+TI5jzi7mXzknm
         +peHXAotjkl6O8e7WrWFjhmVp02LVXqHr86040FRwwmRwIQ0pSw3ZbGuu+GVXSZzE2Mx
         9SOu6u/rpKxikUzmqb4MMJH+vsdHZRn7IZIPzz4Ivp7MdVxapjibdurtW/K0ziih0whM
         OOsnelyI4Yr/QVO+SfuXVQsOYL4H4BRT5/ETCONww1UdvW/zZTTLt/MyudASuml5MQLy
         1tyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BMtI8iXYEKCct6oAZQbFTWHKTZ52NdcALBMk5wfK+Vw=;
        b=fMybSZqqEy6fT7N8jJImhJq2MRwZk9TmSzomYY9dVHzT1m2yJF54/bI4ZDbB9JRCYU
         RVG3rZl4qMbbbu1aRD4RTksPEesO/aIsazrWnOfQw6pyBL6cY/N1IpQFOAyadRL6CgBf
         uJTmpNQS0Q3bPhkcwmhU3xvmvJEQsY0p6Q32Wly7hwpfGJ22m3CP7ftXVKrTYC6qrOlc
         k7c4Zf4dVSfgsjs8BQFYnhdEGm23B1I2Gkqoot1JFzmJ0PBEkz2ykTklF0+TiixwuWtt
         t2AK6jkOz3Uv9FlxsKDm517ZQaDNY0PRjgEbToePSwfaX7LmnnSfNioQoAb7r77FYUY5
         uvVQ==
X-Gm-Message-State: APjAAAVpC7Iq1L0szLG9uOngquTEdD6AgWqTpNbSw+NxRdmXbggbSoyb
        XwjJbLGXcsvetepwbkdK+jWdE6adgOFpFlzrgLo=
X-Google-Smtp-Source: APXvYqxMesmkfDSiANsDzpbJqGJtgA19KN51Zr2fHQgUIequjcyeJV2n0P0IBMUFMSID5U4zffNo8y3ns9FcIVjXoyY=
X-Received: by 2002:ac8:6601:: with SMTP id c1mr31175305qtp.93.1563473055984;
 Thu, 18 Jul 2019 11:04:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190718172513.2394157-1-andriin@fb.com> <20190718175533.GG2093@redhat.com>
In-Reply-To: <20190718175533.GG2093@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jul 2019 11:04:04 -0700
Message-ID: <CAEf4BzaPySx-hBwD5Lxo1tD7F_8ejA9qFjC0-ag56cakweqcbA@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix missing __WORDSIZE definition
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 10:55 AM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Thu, Jul 18, 2019 at 10:25:13AM -0700, Andrii Nakryiko escreveu:
> > hashmap.h depends on __WORDSIZE being defined. It is defined by
> > glibc/musl in different headers. It's an explicit goal for musl to be
> > "non-detectable" at compilation time, so instead include glibc header if
> > glibc is explicitly detected and fall back to musl header otherwise.
> >
> > Fixes: e3b924224028 ("libbpf: add resizable non-thread safe internal hashmap")
> > Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> I fixed this here differently, as below, I didn't send it because I'm still
> testing it, so far, with a few other fixes and cherry-picking "libbpf: fix ptr
> to u64 conversion warning on 32-bit platforms" that is still in the bpf tree
> and is needed for the cross build containers in my suite that are 32-bit, I
> have the results below, this builds perf + libbpf (where elfutils is available,
> which is in most cases, except the uCLibc containers due to missing argp-devel),
> with gcc and with clang:
>
> [perfbuilder@quaco linux-perf-tools-build]$ export PERF_TARBALL=http://192.168.124.1/perf/perf-5.2.0.tar.xz
> [perfbuilder@quaco linux-perf-tools-build]$ time dm
>    1 alpine:3.4                    : Ok   gcc (Alpine 5.3.0) 5.3.0, clang version 3.8.0 (tags/RELEASE_380/final)
>    2 alpine:3.5                    : Ok   gcc (Alpine 6.2.1) 6.2.1 20160822, clang version 3.8.1 (tags/RELEASE_381/final)
>    3 alpine:3.6                    : Ok   gcc (Alpine 6.3.0) 6.3.0, clang version 4.0.0 (tags/RELEASE_400/final)
>    4 alpine:3.7                    : Ok   gcc (Alpine 6.4.0) 6.4.0, Alpine clang version 5.0.0 (tags/RELEASE_500/final) (based on LLVM 5.0.0)
>    5 alpine:3.8                    : Ok   gcc (Alpine 6.4.0) 6.4.0, Alpine clang version 5.0.1 (tags/RELEASE_501/final) (based on LLVM 5.0.1)
>    6 alpine:3.9                    : Ok   gcc (Alpine 8.3.0) 8.3.0, Alpine clang version 5.0.1 (tags/RELEASE_502/final) (based on LLVM 5.0.1)
>    7 alpine:3.10                   : Ok   gcc (Alpine 8.3.0) 8.3.0, Alpine clang version 8.0.0 (tags/RELEASE_800/final) (based on LLVM 8.0.0)
>    8 alpine:edge                   : Ok   gcc (Alpine 8.3.0) 8.3.0, Alpine clang version 7.0.1 (tags/RELEASE_701/final) (based on LLVM 7.0.1)
>    9 amazonlinux:1                 : Ok   gcc (GCC) 7.2.1 20170915 (Red Hat 7.2.1-2), clang version 3.6.2 (tags/RELEASE_362/final)
>   10 amazonlinux:2                 : Ok   gcc (GCC) 7.3.1 20180303 (Red Hat 7.3.1-5), clang version 7.0.1 (Amazon Linux 2 7.0.1-1.amzn2.0.2)
>   11 android-ndk:r12b-arm          : Ok   arm-linux-androideabi-gcc (GCC) 4.9.x 20150123 (prerelease)
>   12 android-ndk:r15c-arm          : Ok   arm-linux-androideabi-gcc (GCC) 4.9.x 20150123 (prerelease)
>   13 centos:5                      : Ok   gcc (GCC) 4.1.2 20080704 (Red Hat 4.1.2-55)
>   14 centos:6                      : Ok   gcc (GCC) 4.4.7 20120313 (Red Hat 4.4.7-23)
>   15 centos:7                      : Ok   gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-36), clang version 3.4.2 (tags/RELEASE_34/dot2-final)
>   16 clearlinux:latest             : Ok   gcc (Clear Linux OS for Intel Architecture) 9.1.1 20190628 gcc-9-branch@272773, clang version 8.0.0 (tags/RELEASE_800/final)
>   17 debian:8                      : Ok   gcc (Debian 4.9.2-10+deb8u2) 4.9.2, Debian clang version 3.5.0-10 (tags/RELEASE_350/final) (based on LLVM 3.5.0)
>   18 debian:9                      : Ok   gcc (Debian 6.3.0-18+deb9u1) 6.3.0 20170516, clang version 3.8.1-24 (tags/RELEASE_381/final)
>   19 debian:10                     : Ok   gcc (Debian 8.3.0-6) 8.3.0, clang version 7.0.1-8 (tags/RELEASE_701/final)
>   20 debian:experimental           : Ok   gcc (Debian 8.3.0-19) 8.3.0, clang version 7.0.1-8 (tags/RELEASE_701/final)
>   21 debian:experimental-x-arm64   : Ok   aarch64-linux-gnu-gcc (Debian 8.3.0-19) 8.3.0
>   22 debian:experimental-x-mips    : Ok   mips-linux-gnu-gcc (Debian 8.3.0-19) 8.3.0
>   23 debian:experimental-x-mips64  : Ok   mips64-linux-gnuabi64-gcc (Debian 8.3.0-7) 8.3.0
>   24 debian:experimental-x-mipsel  : Ok   mipsel-linux-gnu-gcc (Debian 8.3.0-19) 8.3.0
>   25 fedora:20                     : Ok   gcc (GCC) 4.8.3 20140911 (Red Hat 4.8.3-7), clang version 3.4.2 (tags/RELEASE_34/dot2-final)
>   26 fedora:22                     : Ok   gcc (GCC) 5.3.1 20160406 (Red Hat 5.3.1-6), clang version 3.5.0 (tags/RELEASE_350/final)
>   27 fedora:23                     : Ok   gcc (GCC) 5.3.1 20160406 (Red Hat 5.3.1-6), clang version 3.7.0 (tags/RELEASE_370/final)
>   28 fedora:24                     : Ok   gcc (GCC) 6.3.1 20161221 (Red Hat 6.3.1-1), clang version 3.8.1 (tags/RELEASE_381/final)
>   29 fedora:24-x-ARC-uClibc        : Ok   arc-linux-gcc (ARCompact ISA Linux uClibc toolchain 2017.09-rc2) 7.1.1 20170710
>
> I've pushed it to a tmp.perf/core branch in my
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tree, that has
> these:
>
> d5e1f2d60d41 (HEAD -> perf/core, acme.korg/tmp.perf/core) libbpf: fix ptr to u64 conversion warning on 32-bit platforms
> 7c08fd16f917 tools lib bpf: Avoid designated initializers for unnamed union members
> 4c9f83c95ad6 tools lib bpf: Avoid using 'link' as it shadows a global definition in some systems
> bdb07df4a0ad tools lib bpf: Fix endianness macro usage for some compilers
> 66dbf3caff52 tools lib bpf: Replace __WORDSIZE with BITS_PER_LONG to build on the musl libc
>
> Please take a look and check if everything is fine on your side. The HEAD I'll
> remove if Daniel thinks it should wait that landing via the BPF tree, I just put it
> there for the test builds.
>
> commit 66dbf3caff52be0d004bcb9ac4cea4c19eb75dfc
> Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date:   Thu Jul 18 09:46:28 2019 -0300
>
>     tools lib bpf: Replace __WORDSIZE with BITS_PER_LONG to build on the musl libc
>
>     BITS_PER_LONG is more generally available and equivalent to __WORDSIZE,
>     so use it instead to keep it building in systems using the mustl libc
>     where __WORDSIZE is in a different place than in glibc.
>
>     And do this by explicitely adding the header where this definition is
>     (asm/bitsperlong.h) instead of getting it indirectly.
>
>     Cc: Adrian Hunter <adrian.hunter@intel.com>
>     Cc: Alexei Starovoitov <ast@kernel.org>
>     Cc: Andrii Nakryiko <andriin@fb.com>
>     Cc: Jiri Olsa <jolsa@kernel.org>
>     Cc: Namhyung Kim <namhyung@kernel.org>
>     Fixes: e3b924224028 ("libbpf: add resizable non-thread safe internal hashmap")
>     Link: https://lkml.kernel.org/n/tip-61vydgldzmmz5w2mf6rv3ryl@git.kernel.org
>     Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> index 03748a742146..f1f37b574d9c 100644
> --- a/tools/lib/bpf/hashmap.h
> +++ b/tools/lib/bpf/hashmap.h
> @@ -10,12 +10,13 @@
>
>  #include <stdbool.h>
>  #include <stddef.h>
> +#include <asm/bitsperlong.h>

Relying on this header is problematic when syncing libbpf into Github
mirror. There we'll need to re-implement it anyway, and again,
probably through __WORDSIZE or some other tricks. So if we can do away
without kernel specific header that would be great.

>  #include "libbpf_internal.h"
>
>  static inline size_t hash_bits(size_t h, int bits)
>  {
>         /* shuffle bits and return requested number of upper bits */
> -       return (h * 11400714819323198485llu) >> (__WORDSIZE - bits);
> +       return (h * 11400714819323198485llu) >> (BITS_PER_LONG - bits);
>  }
>
>  typedef size_t (*hashmap_hash_fn)(const void *key, void *ctx);
