Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D6955C782
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241099AbiF0XRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 19:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239986AbiF0XQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 19:16:59 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B73B23178;
        Mon, 27 Jun 2022 16:16:57 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id eq6so15138140edb.6;
        Mon, 27 Jun 2022 16:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p/RWrnG5CvcdZnmSlYf5gOqW3tUhDBkt/ZrWvUubV7Q=;
        b=iOJwzXHhA1f43yermVi07KMZL5AhwhcModmJOuH7TDgBLnTBUTc9MoaqTlRZjUjoRa
         Ft6D+mzSy/aBNBC4Zy3ktvP7n9Mwd6c7NoC0ddxc3gOghRkrUNS6EcUG8UOrGHbqk7cJ
         6vuVEr+TuXDXFockvLgj1JCATF5MhWaSHDsSPBOSaOUtJWxTzDY0AzGOAatn9BgdKn0J
         mlk+KqFGHe+pQSYsCcf7z0Sui/KA9iWwXS2Djy64Ul12OnStxpBVBuv3P/eCwgkJFbpg
         hGUzyD1bcpvf++kUS63MyR+8/0Rmw1kYk0YuMiK6wC9xbCoEsn7CBE9JSwdEbeHeRJct
         SlvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p/RWrnG5CvcdZnmSlYf5gOqW3tUhDBkt/ZrWvUubV7Q=;
        b=7+gkFltDG2uj7Sdu6NJxeH94QApLsfMkX8RCYAUN613YdzErsoaw8nN4SNOCdMGyow
         UiCQKg9B1l4iy93MC6+lNPHrfN4Dt2ifbv3T10vdyiojima6F8lUAmYtsyzEXqeUSeAq
         aBA2kdgH7GWqYV/ndCHm7AWz63N/3Xq6CXkWjF5ufF577UOmUdN9DPAsr/9TrJYdgS+A
         TdKY8rwXZTnywSzfdokYwLxwsJj8txuJEohpBm0YCGU7WwzQnop6BOguoy/ERTpeaj/9
         D/giACRKIyAssjCQ3Y/hzcMmp8yDz+Nm5wKRByZAeu+qAexaRl31rcPKQW3/bmPOaiQf
         pXSQ==
X-Gm-Message-State: AJIora9kS5IgjW3TiK5Ri/K2MAbP7FQH7Tb9cEAnPNtYz4ttJiisy9yK
        wYMVmSYE+C9TCjdk6h5bCSCKwWTeoyqYqbeDloQ=
X-Google-Smtp-Source: AGRyM1vwbgm9NsfYBpK363uThEsZQgIruI9F1H/fF/JoZIEZ7Hsw+zKw0xINkCAE4UsVwPI9wqYYxHoFLWd/c4Drgh4=
X-Received: by 2002:a05:6402:3514:b0:435:f24a:fbad with SMTP id
 b20-20020a056402351400b00435f24afbadmr18912316edd.311.1656371815794; Mon, 27
 Jun 2022 16:16:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220609062412.3950380-1-james.hilliard1@gmail.com>
 <CAEf4BzbL8ivLH=HZDFTNyCTFjhWrWLcY3K34Ef+q4Pr+oDe_Gw@mail.gmail.com> <CADvTj4opMh978fMBV7cH89wbS1N_PK31AybZJ5NUacnp4kBeqg@mail.gmail.com>
In-Reply-To: <CADvTj4opMh978fMBV7cH89wbS1N_PK31AybZJ5NUacnp4kBeqg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Jun 2022 16:16:42 -0700
Message-ID: <CAEf4BzbkckyfKuhu9CV9wofCHeYa83NnfQNeK82pXLe-s8zhxA@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] libbpf: fix broken gcc SEC pragma macro
To:     James Hilliard <james.hilliard1@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 9, 2022 at 4:27 PM James Hilliard <james.hilliard1@gmail.com> wrote:
>
> On Thu, Jun 9, 2022 at 12:13 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Jun 8, 2022 at 11:24 PM James Hilliard
> > <james.hilliard1@gmail.com> wrote:
> > >
> > > It seems the gcc preprocessor breaks unless pragmas are wrapped
> > > individually inside macros when surrounding __attribute__.
> > >
> > > Fixes errors like:
> > > error: expected identifier or '(' before '#pragma'
> > >   106 | SEC("cgroup/bind6")
> > >       | ^~~
> > >
> > > error: expected '=', ',', ';', 'asm' or '__attribute__' before '#pragma'
> > >   114 | char _license[] SEC("license") = "GPL";
> > >       | ^~~
> > >
> > > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> > > ---
> > > Changes v2 -> v3:
> > >   - just fix SEC pragma
> > > Changes v1 -> v2:
> > >   - replace typeof with __typeof__ instead of changing pragma macros
> > > ---
> > >  tools/lib/bpf/bpf_helpers.h | 7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > > index fb04eaf367f1..66d23c47c206 100644
> > > --- a/tools/lib/bpf/bpf_helpers.h
> > > +++ b/tools/lib/bpf/bpf_helpers.h
> > > @@ -22,11 +22,12 @@
> > >   * To allow use of SEC() with externs (e.g., for extern .maps declarations),
> > >   * make sure __attribute__((unused)) doesn't trigger compilation warning.
> > >   */
> > > +#define DO_PRAGMA(x) _Pragma(#x)
> > >  #define SEC(name) \
> > > -       _Pragma("GCC diagnostic push")                                      \
> > > -       _Pragma("GCC diagnostic ignored \"-Wignored-attributes\"")          \
> > > +       DO_PRAGMA("GCC diagnostic push")                                    \
> > > +       DO_PRAGMA("GCC diagnostic ignored \"-Wignored-attributes\"")        \
> > >         __attribute__((section(name), used))                                \
> > > -       _Pragma("GCC diagnostic pop")                                       \
> > > +       DO_PRAGMA("GCC diagnostic pop")                                     \
> > >
> >
> > I'm not going to accept this unless I can repro it in the first place.
> > Using -std=c17 doesn't trigger such issue. Please provide the repro
> > first. Building systemd is not a repro, unfortunately. Please try to
> > do it based on libbpf-bootstrap ([0])
> >
> >   [0] https://github.com/libbpf/libbpf-bootstrap
>
> Seems to reproduce just fine already there with:
> https://github.com/libbpf/libbpf-bootstrap/blob/31face36d469a0e3e4c4ac1cafc66747d3150930/examples/c/minimal.bpf.c
>
> See here:
> $ /home/buildroot/buildroot/output/per-package/libbpf/host/bin/bpf-gcc
> -Winline -O2 -mframe-limit=32767 -mco-re -gbtf -std=gnu17 -v
> -D__x86_64__ -mlittle-endian -I
> /home/buildroot/buildroot/output/per-package/libbpf/host/x86_64-buildroot-linux-gnu/sysroot/usr/include
> minimal.bpf.c -o minimal.bpf.o
> Using built-in specs.
> COLLECT_GCC=/home/buildroot/buildroot/output/per-package/libbpf/host/bin/bpf-gcc.br_real
> COLLECT_LTO_WRAPPER=/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../libexec/gcc/bpf-buildroot-none/12.1.0/lto-wrapper
> Target: bpf-buildroot-none
> Configured with: ./configure
> --prefix=/home/buildroot/buildroot/output/per-package/host-gcc-bpf/host
> --sysconfdir=/home/buildroot/buildroot/output/per-package/host-gcc-bpf/host/etc
> --localstatedir=/home/buildroot/buildroot/output/per-package/host-gcc-bpf/host/var
> --enable-shared --disable-static --disable-gtk-doc
> --disable-gtk-doc-html --disable-doc --disable-docs
> --disable-documentation --disable-debug --with-xmlto=no --with-fop=no
> --disable-nls --disable-dependency-tracking
> --target=bpf-buildroot-none
> --prefix=/home/buildroot/buildroot/output/per-package/host-gcc-bpf/host
> --sysconfdir=/home/buildroot/buildroot/output/per-package/host-gcc-bpf/host/etc
> --enable-languages=c --with-gnu-ld --enable-static
> --disable-decimal-float --disable-gcov --disable-libssp
> --disable-multilib --disable-shared
> --with-gmp=/home/buildroot/buildroot/output/per-package/host-gcc-bpf/host
> --with-mpc=/home/buildroot/buildroot/output/per-package/host-gcc-bpf/host
> --with-mpfr=/home/buildroot/buildroot/output/per-package/host-gcc-bpf/host
> --with-pkgversion='Buildroot 2022.05-118-ge052166011-dirty'
> --with-bugurl=http://bugs.buildroot.net/ --without-zstd --without-isl
> --without-cloog
> Thread model: single
> Supported LTO compression algorithms: zlib
> gcc version 12.1.0 (Buildroot 2022.05-118-ge052166011-dirty)
> COLLECT_GCC_OPTIONS='--sysroot=/home/buildroot/buildroot/output/per-package/libbpf/host/x86_64-buildroot-linux-gnu/sysroot'
> '-Winline' '-O2' '-mframe-limit=32767' '-mco-re' '-gbtf' '-std=gnu17'
> '-v' '-D' '__x86_64__' '-mlittle-endian' '-I'
> '/home/buildroot/buildroot/output/per-package/libbpf/host/x86_64-buildroot-linux-gnu/sysroot/usr/include'
> '-o' 'minimal.bpf.o' '-dumpdir' 'minimal.bpf.o-'
>  /home/buildroot/buildroot/output/per-package/libbpf/host/bin/../libexec/gcc/bpf-buildroot-none/12.1.0/cc1
> -quiet -v -I /home/buildroot/buildroot/output/per-package/libbpf/host/x86_64-buildroot-linux-gnu/sysroot/usr/include
> -iprefix /home/buildroot/buildroot/output/per-package/libbpf/host/bin/../lib/gcc/bpf-buildroot-none/12.1.0/
> -isysroot /home/buildroot/buildroot/output/per-package/libbpf/host/x86_64-buildroot-linux-gnu/sysroot
> -D __x86_64__ minimal.bpf.c -quiet -dumpdir minimal.bpf.o- -dumpbase
> minimal.bpf.c -dumpbase-ext .c -mframe-limit=32767 -mco-re
> -mlittle-endian -gbtf -O2 -Winline -std=gnu17 -version -o
> /tmp/cct4AXvg.s
> GNU C17 (Buildroot 2022.05-118-ge052166011-dirty) version 12.1.0
> (bpf-buildroot-none)
>     compiled by GNU C version 12.1.0, GMP version 6.2.1, MPFR version
> 4.1.0, MPC version 1.2.1, isl version none
> GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
> ignoring nonexistent directory
> "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../lib/gcc/bpf-buildroot-none/12.1.0/../../../../bpf-buildroot-none/sys-include"
> ignoring nonexistent directory
> "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../lib/gcc/bpf-buildroot-none/12.1.0/../../../../bpf-buildroot-none/include"
> ignoring duplicate directory
> "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../lib/gcc/../../lib/gcc/bpf-buildroot-none/12.1.0/include"
> ignoring duplicate directory
> "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../lib/gcc/../../lib/gcc/bpf-buildroot-none/12.1.0/include-fixed"
> ignoring nonexistent directory
> "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../lib/gcc/../../lib/gcc/bpf-buildroot-none/12.1.0/../../../../bpf-buildroot-none/sys-include"
> ignoring nonexistent directory
> "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../lib/gcc/../../lib/gcc/bpf-buildroot-none/12.1.0/../../../../bpf-buildroot-none/include"
> #include "..." search starts here:
> #include <...> search starts here:
>  /home/buildroot/buildroot/output/per-package/libbpf/host/x86_64-buildroot-linux-gnu/sysroot/usr/include
>  /home/buildroot/buildroot/output/per-package/libbpf/host/bin/../lib/gcc/bpf-buildroot-none/12.1.0/include
>  /home/buildroot/buildroot/output/per-package/libbpf/host/bin/../lib/gcc/bpf-buildroot-none/12.1.0/include-fixed
> End of search list.
> GNU C17 (Buildroot 2022.05-118-ge052166011-dirty) version 12.1.0
> (bpf-buildroot-none)
>     compiled by GNU C version 12.1.0, GMP version 6.2.1, MPFR version
> 4.1.0, MPC version 1.2.1, isl version none
> GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
> Compiler executable checksum: 9bf241ca1a2dd4ffd7652c5e247c9be8
> minimal.bpf.c:6:1: error: expected '=', ',', ';', 'asm' or
> '__attribute__' before '#pragma'
>     6 | char LICENSE[] SEC("license") = "Dual BSD/GPL";
>       | ^~~
> minimal.bpf.c:6:1: error: expected identifier or '(' before '#pragma'
> minimal.bpf.c:10:1: error: expected identifier or '(' before '#pragma'
>    10 | SEC("tp/syscalls/sys_enter_write")
>       | ^~~

So this is a bug (hard to call this a feature) in gcc (not even
bpf-gcc, I could repro with a simple gcc). Is there a bug reported for
this somewhere? Are GCC folks aware and working on the fix?

What's curious is that the only thing that allows to bypass this is
adding #x in macro, having #define DO_PRAGMA(x) _Pragma(x) doesn't
help.

So ideally GCC can fix this? But either way your patch as is
erroneously passing extra quoted strings to _Pragma().

I'm pondering whether it's just cleaner to define SEC() without
pragmas for GCC? It will only cause compiler warning about unnecessary
unused attribute for extern *variable* declarations, which are very
rare. Instead of relying on this quirky "fix" approach. Ideally,
though, GCC just fixes _Pragma() handling, of course.

>
> >
> > >  /* Avoid 'linux/stddef.h' definition of '__always_inline'. */
> > >  #undef __always_inline
> > > --
> > > 2.25.1
> > >
