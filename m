Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF3156386C
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 19:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiGARMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 13:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGARMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 13:12:14 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BBFF1D0DC;
        Fri,  1 Jul 2022 10:12:12 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-10bab338f70so4325268fac.7;
        Fri, 01 Jul 2022 10:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+CGwWJQrzlLYLvhcFN20pKNsZ67ayNjRCB53PSccOj4=;
        b=pr+hcIGHzw0QNY4elCy8H0miiE9io3uLQdrmpuiAR+tIn4b4Ioj4ZxF3rpf4C+Tx+a
         l2BD/tOcLMHlsS1opIiaFvVJXLfp0wyL+j0mVqqeiraoGRt94IPCALJu/YUh6FopNp/p
         0CkIXrjIGQFkzgHpFkAEbeGy70tM6AAOpw9qXjneru5ptShiQeK6AHFdFyKrgmpThBfD
         0N9BqP15+YK+oRJCa/lq5gy7kkyEVJs3orb/cwAyj/D5sva2uW4y251gYGbAhrVZmonn
         Df41TF2ZNv2xcNSwuvH9UrmejwQlv1dAYGKwV0qvOnj3qQ6G7YerNXLUULH1GCNpuPPl
         XDog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+CGwWJQrzlLYLvhcFN20pKNsZ67ayNjRCB53PSccOj4=;
        b=gdx1JRR+7uQFrPhtHfkUwFvGf3Hoj/0+rcVA0IKLd4XNsancj/KD2dTlbX2izL5Hwn
         3umeIRKBtlU9++Ytuf6UOkNwHd+FD1iIKgY1WqgYkwymUNfqttUUnx+exIIaZEQDpcJy
         NhPxQrhGpDD/4S7BVVs4uKLAPzwN70Ps/Nb4ogC9Pv+1TuEzJw8RnQkVIq5fuq4KmKqk
         YOk5YTkQcyZ2grvYyOBvxz7FjiuCpyH9UL3kE6hQRqxKbCiif8ZO9u98BzCpffRuDVNn
         AEtaNw34g+pQRcRHM6hNhvF/PW6b1ASzKG0BcTHbv+gCeqpuPf+Q2i8p9NXcYJVJGbg1
         OUcQ==
X-Gm-Message-State: AJIora+Mux/78s2/WF0nQlE7YkmMM6IRv0f1G3+4w123BGf7srDrz2fx
        6jjq1+r+OmcNTbca+Yt6pm3HPq0ugK0R6lqObeQ=
X-Google-Smtp-Source: AGRyM1u4nro2wRdcUFHaeSL9AfIgqXGMgqeipUdfMc9txqeb0dS4cg3K5pbsMqr3MKUQz4F0atOQB/EmGrqLIBHFHNQ=
X-Received: by 2002:a05:6870:538b:b0:101:17f2:d6e with SMTP id
 h11-20020a056870538b00b0010117f20d6emr10833211oan.200.1656695531601; Fri, 01
 Jul 2022 10:12:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220609062412.3950380-1-james.hilliard1@gmail.com>
 <CAEf4BzbL8ivLH=HZDFTNyCTFjhWrWLcY3K34Ef+q4Pr+oDe_Gw@mail.gmail.com>
 <CADvTj4opMh978fMBV7cH89wbS1N_PK31AybZJ5NUacnp4kBeqg@mail.gmail.com>
 <CAEf4BzbkckyfKuhu9CV9wofCHeYa83NnfQNeK82pXLe-s8zhxA@mail.gmail.com>
 <CADvTj4q5BtrhUwvxdke0NFDRBh1bUzPRd4iGoGvt_HaDp2V7MQ@mail.gmail.com> <CAEf4BzZkSXLqFz4Cjx4_Z_0sxBBSd-SEhT8u+3EZVccqH7qXkg@mail.gmail.com>
In-Reply-To: <CAEf4BzZkSXLqFz4Cjx4_Z_0sxBBSd-SEhT8u+3EZVccqH7qXkg@mail.gmail.com>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Fri, 1 Jul 2022 11:12:00 -0600
Message-ID: <CADvTj4ozq_Q0m+aKhQ+yfuGdrJOeSyt=4ORt5AjtZW61Z6OosA@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] libbpf: fix broken gcc SEC pragma macro
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 3:51 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jun 27, 2022 at 9:43 PM James Hilliard
> <james.hilliard1@gmail.com> wrote:
> >
> > On Mon, Jun 27, 2022 at 5:16 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Thu, Jun 9, 2022 at 4:27 PM James Hilliard <james.hilliard1@gmail.=
com> wrote:
> > > >
> > > > On Thu, Jun 9, 2022 at 12:13 PM Andrii Nakryiko
> > > > <andrii.nakryiko@gmail.com> wrote:
> > > > >
> > > > > On Wed, Jun 8, 2022 at 11:24 PM James Hilliard
> > > > > <james.hilliard1@gmail.com> wrote:
> > > > > >
> > > > > > It seems the gcc preprocessor breaks unless pragmas are wrapped
> > > > > > individually inside macros when surrounding __attribute__.
> > > > > >
> > > > > > Fixes errors like:
> > > > > > error: expected identifier or '(' before '#pragma'
> > > > > >   106 | SEC("cgroup/bind6")
> > > > > >       | ^~~
> > > > > >
> > > > > > error: expected '=3D', ',', ';', 'asm' or '__attribute__' befor=
e '#pragma'
> > > > > >   114 | char _license[] SEC("license") =3D "GPL";
> > > > > >       | ^~~
> > > > > >
> > > > > > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> > > > > > ---
> > > > > > Changes v2 -> v3:
> > > > > >   - just fix SEC pragma
> > > > > > Changes v1 -> v2:
> > > > > >   - replace typeof with __typeof__ instead of changing pragma m=
acros
> > > > > > ---
> > > > > >  tools/lib/bpf/bpf_helpers.h | 7 ++++---
> > > > > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > > > >
> > > > > > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_he=
lpers.h
> > > > > > index fb04eaf367f1..66d23c47c206 100644
> > > > > > --- a/tools/lib/bpf/bpf_helpers.h
> > > > > > +++ b/tools/lib/bpf/bpf_helpers.h
> > > > > > @@ -22,11 +22,12 @@
> > > > > >   * To allow use of SEC() with externs (e.g., for extern .maps =
declarations),
> > > > > >   * make sure __attribute__((unused)) doesn't trigger compilati=
on warning.
> > > > > >   */
> > > > > > +#define DO_PRAGMA(x) _Pragma(#x)
> > > > > >  #define SEC(name) \
> > > > > > -       _Pragma("GCC diagnostic push")                         =
             \
> > > > > > -       _Pragma("GCC diagnostic ignored \"-Wignored-attributes\=
"")          \
> > > > > > +       DO_PRAGMA("GCC diagnostic push")                       =
             \
> > > > > > +       DO_PRAGMA("GCC diagnostic ignored \"-Wignored-attribute=
s\"")        \
> > > > > >         __attribute__((section(name), used))                   =
             \
> > > > > > -       _Pragma("GCC diagnostic pop")                          =
             \
> > > > > > +       DO_PRAGMA("GCC diagnostic pop")                        =
             \
> > > > > >
> > > > >
> > > > > I'm not going to accept this unless I can repro it in the first p=
lace.
> > > > > Using -std=3Dc17 doesn't trigger such issue. Please provide the r=
epro
> > > > > first. Building systemd is not a repro, unfortunately. Please try=
 to
> > > > > do it based on libbpf-bootstrap ([0])
> > > > >
> > > > >   [0] https://github.com/libbpf/libbpf-bootstrap
> > > >
> > > > Seems to reproduce just fine already there with:
> > > > https://github.com/libbpf/libbpf-bootstrap/blob/31face36d469a0e3e4c=
4ac1cafc66747d3150930/examples/c/minimal.bpf.c
> > > >
> > > > See here:
> > > > $ /home/buildroot/buildroot/output/per-package/libbpf/host/bin/bpf-=
gcc
> > > > -Winline -O2 -mframe-limit=3D32767 -mco-re -gbtf -std=3Dgnu17 -v
> > > > -D__x86_64__ -mlittle-endian -I
> > > > /home/buildroot/buildroot/output/per-package/libbpf/host/x86_64-bui=
ldroot-linux-gnu/sysroot/usr/include
> > > > minimal.bpf.c -o minimal.bpf.o
> > > > Using built-in specs.
> > > > COLLECT_GCC=3D/home/buildroot/buildroot/output/per-package/libbpf/h=
ost/bin/bpf-gcc.br_real
> > > > COLLECT_LTO_WRAPPER=3D/home/buildroot/buildroot/output/per-package/=
libbpf/host/bin/../libexec/gcc/bpf-buildroot-none/12.1.0/lto-wrapper
> > > > Target: bpf-buildroot-none
> > > > Configured with: ./configure
> > > > --prefix=3D/home/buildroot/buildroot/output/per-package/host-gcc-bp=
f/host
> > > > --sysconfdir=3D/home/buildroot/buildroot/output/per-package/host-gc=
c-bpf/host/etc
> > > > --localstatedir=3D/home/buildroot/buildroot/output/per-package/host=
-gcc-bpf/host/var
> > > > --enable-shared --disable-static --disable-gtk-doc
> > > > --disable-gtk-doc-html --disable-doc --disable-docs
> > > > --disable-documentation --disable-debug --with-xmlto=3Dno --with-fo=
p=3Dno
> > > > --disable-nls --disable-dependency-tracking
> > > > --target=3Dbpf-buildroot-none
> > > > --prefix=3D/home/buildroot/buildroot/output/per-package/host-gcc-bp=
f/host
> > > > --sysconfdir=3D/home/buildroot/buildroot/output/per-package/host-gc=
c-bpf/host/etc
> > > > --enable-languages=3Dc --with-gnu-ld --enable-static
> > > > --disable-decimal-float --disable-gcov --disable-libssp
> > > > --disable-multilib --disable-shared
> > > > --with-gmp=3D/home/buildroot/buildroot/output/per-package/host-gcc-=
bpf/host
> > > > --with-mpc=3D/home/buildroot/buildroot/output/per-package/host-gcc-=
bpf/host
> > > > --with-mpfr=3D/home/buildroot/buildroot/output/per-package/host-gcc=
-bpf/host
> > > > --with-pkgversion=3D'Buildroot 2022.05-118-ge052166011-dirty'
> > > > --with-bugurl=3Dhttp://bugs.buildroot.net/ --without-zstd --without=
-isl
> > > > --without-cloog
> > > > Thread model: single
> > > > Supported LTO compression algorithms: zlib
> > > > gcc version 12.1.0 (Buildroot 2022.05-118-ge052166011-dirty)
> > > > COLLECT_GCC_OPTIONS=3D'--sysroot=3D/home/buildroot/buildroot/output=
/per-package/libbpf/host/x86_64-buildroot-linux-gnu/sysroot'
> > > > '-Winline' '-O2' '-mframe-limit=3D32767' '-mco-re' '-gbtf' '-std=3D=
gnu17'
> > > > '-v' '-D' '__x86_64__' '-mlittle-endian' '-I'
> > > > '/home/buildroot/buildroot/output/per-package/libbpf/host/x86_64-bu=
ildroot-linux-gnu/sysroot/usr/include'
> > > > '-o' 'minimal.bpf.o' '-dumpdir' 'minimal.bpf.o-'
> > > >  /home/buildroot/buildroot/output/per-package/libbpf/host/bin/../li=
bexec/gcc/bpf-buildroot-none/12.1.0/cc1
> > > > -quiet -v -I /home/buildroot/buildroot/output/per-package/libbpf/ho=
st/x86_64-buildroot-linux-gnu/sysroot/usr/include
> > > > -iprefix /home/buildroot/buildroot/output/per-package/libbpf/host/b=
in/../lib/gcc/bpf-buildroot-none/12.1.0/
> > > > -isysroot /home/buildroot/buildroot/output/per-package/libbpf/host/=
x86_64-buildroot-linux-gnu/sysroot
> > > > -D __x86_64__ minimal.bpf.c -quiet -dumpdir minimal.bpf.o- -dumpbas=
e
> > > > minimal.bpf.c -dumpbase-ext .c -mframe-limit=3D32767 -mco-re
> > > > -mlittle-endian -gbtf -O2 -Winline -std=3Dgnu17 -version -o
> > > > /tmp/cct4AXvg.s
> > > > GNU C17 (Buildroot 2022.05-118-ge052166011-dirty) version 12.1.0
> > > > (bpf-buildroot-none)
> > > >     compiled by GNU C version 12.1.0, GMP version 6.2.1, MPFR versi=
on
> > > > 4.1.0, MPC version 1.2.1, isl version none
> > > > GGC heuristics: --param ggc-min-expand=3D100 --param ggc-min-heapsi=
ze=3D131072
> > > > ignoring nonexistent directory
> > > > "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../li=
b/gcc/bpf-buildroot-none/12.1.0/../../../../bpf-buildroot-none/sys-include"
> > > > ignoring nonexistent directory
> > > > "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../li=
b/gcc/bpf-buildroot-none/12.1.0/../../../../bpf-buildroot-none/include"
> > > > ignoring duplicate directory
> > > > "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../li=
b/gcc/../../lib/gcc/bpf-buildroot-none/12.1.0/include"
> > > > ignoring duplicate directory
> > > > "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../li=
b/gcc/../../lib/gcc/bpf-buildroot-none/12.1.0/include-fixed"
> > > > ignoring nonexistent directory
> > > > "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../li=
b/gcc/../../lib/gcc/bpf-buildroot-none/12.1.0/../../../../bpf-buildroot-non=
e/sys-include"
> > > > ignoring nonexistent directory
> > > > "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../li=
b/gcc/../../lib/gcc/bpf-buildroot-none/12.1.0/../../../../bpf-buildroot-non=
e/include"
> > > > #include "..." search starts here:
> > > > #include <...> search starts here:
> > > >  /home/buildroot/buildroot/output/per-package/libbpf/host/x86_64-bu=
ildroot-linux-gnu/sysroot/usr/include
> > > >  /home/buildroot/buildroot/output/per-package/libbpf/host/bin/../li=
b/gcc/bpf-buildroot-none/12.1.0/include
> > > >  /home/buildroot/buildroot/output/per-package/libbpf/host/bin/../li=
b/gcc/bpf-buildroot-none/12.1.0/include-fixed
> > > > End of search list.
> > > > GNU C17 (Buildroot 2022.05-118-ge052166011-dirty) version 12.1.0
> > > > (bpf-buildroot-none)
> > > >     compiled by GNU C version 12.1.0, GMP version 6.2.1, MPFR versi=
on
> > > > 4.1.0, MPC version 1.2.1, isl version none
> > > > GGC heuristics: --param ggc-min-expand=3D100 --param ggc-min-heapsi=
ze=3D131072
> > > > Compiler executable checksum: 9bf241ca1a2dd4ffd7652c5e247c9be8
> > > > minimal.bpf.c:6:1: error: expected '=3D', ',', ';', 'asm' or
> > > > '__attribute__' before '#pragma'
> > > >     6 | char LICENSE[] SEC("license") =3D "Dual BSD/GPL";
> > > >       | ^~~
> > > > minimal.bpf.c:6:1: error: expected identifier or '(' before '#pragm=
a'
> > > > minimal.bpf.c:10:1: error: expected identifier or '(' before '#prag=
ma'
> > > >    10 | SEC("tp/syscalls/sys_enter_write")
> > > >       | ^~~
> > >
> > > So this is a bug (hard to call this a feature) in gcc (not even
> > > bpf-gcc, I could repro with a simple gcc). Is there a bug reported fo=
r
> > > this somewhere? Are GCC folks aware and working on the fix?
> >
> > Yeah, saw a few issues that looked relevant:
> > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D55578
> > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D90400
> >
> > >
> > > What's curious is that the only thing that allows to bypass this is
> > > adding #x in macro, having #define DO_PRAGMA(x) _Pragma(x) doesn't
> > > help.
> > >
> > > So ideally GCC can fix this?
> >
> > From the reported issues...it doesn't sound like a fix is going to be
> > coming all that
> > soon in GCC.
> >
> > > But either way your patch as is
> > > erroneously passing extra quoted strings to _Pragma().
> >
> > I recall the extra quotes were needed to make this work, does it work f=
or you
> > without them?
> >
> > >
> > > I'm pondering whether it's just cleaner to define SEC() without
> > > pragmas for GCC? It will only cause compiler warning about unnecessar=
y
> > > unused attribute for extern *variable* declarations, which are very
> > > rare. Instead of relying on this quirky "fix" approach. Ideally,
> > > though, GCC just fixes _Pragma() handling, of course.
> >
> > I mean, as long as this workaround is reliable I'd say using it is the
> > best option
> > for backwards compatibility, especially since it's only needed in one p=
lace from
> > the looks of it.
>
> Is it reliable, though? Adding those quotes breaks Clang (I checked)
> and it doesn't work as expected with GCC as well. It stops complaining
> about #pragma, but it also doesn't push -Wignored-attributes. Here's
> the test:

Ok, yeah, guess my hack doesn't really work then.

>
> #define DO_PRAGMA(x) _Pragma(#x)
>
> #define SEC(name) \
>        DO_PRAGMA("GCC diagnostic push")                                  =
  \
>        DO_PRAGMA("GCC diagnostic ignored \"-Wignored-attributes\"")      =
  \
>         __attribute__((section(name), used))                             =
  \
>        DO_PRAGMA("GCC diagnostic pop")                                   =
  \
>
> extern int something SEC("whatever");
>
> int main()
> {
>         return something;
> }
>
>
> Used like this you get same warning:
>
> $ cc test.c
> test.c:10:1: warning: =E2=80=98used=E2=80=99 attribute ignored [-Wattribu=
tes]
>    10 | extern int something SEC("whatever");
>       | ^~~~~~
>
> Removing quotes fixes Clang (linker error is expected)
>
> $ clang test.c
> /opt/rh/gcc-toolset-11/root/usr/lib/gcc/x86_64-redhat-linux/11/../../../.=
./bin/ld:

FYI I was testing with GCC 12.1.

> /tmp/test-4eec0b.o: in function `main':
> test.c:(.text+0xe): undefined reference to `something'
>
> But we get back to the original problem with GCC:
>
> $ cc test.c
> test.c:10:1: error: expected =E2=80=98=3D=E2=80=99, =E2=80=98,=E2=80=99, =
=E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or =E2=80=98__attribute__=E2=80=
=99
> before =E2=80=98#pragma=E2=80=99
>    10 | extern int something SEC("whatever");
>       | ^~~
> test.c:10:1: error: expected identifier or =E2=80=98(=E2=80=99 before =E2=
=80=98#pragma=E2=80=99
> test.c: In function =E2=80=98main=E2=80=99:
> test.c:14:16: error: =E2=80=98something=E2=80=99 undeclared (first use in=
 this function)
>    14 |         return something;
>       |                ^~~~~~~~~
>
>
> So the best way forward I can propose for you is this:

Yeah, probably the best option for now.

>
>
> #if __GNUC__ && !__clang__
>
> #define SEC(name) __attribute__((section(name), used))
>
> #else
>
> #define SEC(name) \
>         _Pragma("GCC diagnostic push")                                   =
   \
>         _Pragma("GCC diagnostic ignored \"-Wignored-attributes\"")       =
   \
>         __attribute__((section(name), used))                             =
   \
>         _Pragma("GCC diagnostic pop")                                    =
   \
>
> #endif
>
> extern int something SEC("whatever");
>
> int main()
> {
>         return something;
> }
>
>
> With some comments explaining how broken GCC is w.r.t. _Pragma. And
> just live with compiler warning about used if used with externs.

Yeah, do you want to spin a patch with that? I think you probably have a be=
tter
understanding of the issue at this point than I do.

>
>
> >
> > >
> > > >
> > > > >
> > > > > >  /* Avoid 'linux/stddef.h' definition of '__always_inline'. */
> > > > > >  #undef __always_inline
> > > > > > --
> > > > > > 2.25.1
> > > > > >
