Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2D4567D67
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 06:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiGFEgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 00:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiGFEgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 00:36:40 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064691C112;
        Tue,  5 Jul 2022 21:36:39 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id r6so6316547edd.7;
        Tue, 05 Jul 2022 21:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=roEa9y/JyR3AGBbWSIspFYG+c2zhm3jiZefMMjibTR8=;
        b=dLH6AzlcYLRKTcR0W16dPPOi9n4ycZtmRoxY9MqRxgi67/LHPW8ESymWi0kF/ByS7b
         Q6l7BMYW4UT/Gghg8a5SZGKrzuvutKQA65LLpBiX55HU9UVDONybOCmsxYI+4imtLe2H
         aPDPnTA2rUkOIohSBccIcp6dRtueGHnbBml92jfOwYXtQFdxxSS3TQ4yjj3uRn3aYHPS
         SDelwQg59fv090SXNd+CAtyZz5W526n8sC5lgNkpxOPtJ+na6ZmPLDJYWQCIFQEePRo0
         fzJ7CQfK13z/ltEmKWC/qUNwgA3NOarFChPPtwta9RDjm8PscNEcqL4wQgEUh1/hiuGG
         1O8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=roEa9y/JyR3AGBbWSIspFYG+c2zhm3jiZefMMjibTR8=;
        b=ai+TyA2vH4I95+CLn3HwsziHA24ekzQPXcNrsaXPo58mwoQaW/azDwhGL18NSvp0vz
         /axZ10Q72OfxMN8wpGLIKrKDfruC1nt82/ndguqICuW+xb4M1dfd7DA2HvGbO3M2gTW2
         112T4mZNt5+5K1xpQJZApv6ibk8rAD4+uLHQ3DFFhT0dS0udvv9HgpmfYyIwkI+PsLTj
         mEKTr+rRkP3o1BeBCFS46rQ0DwRmuKYS4hli1hd1VdIOouFu2vQu/Fi52qFSAm4RDzNs
         zIeNiNwlIQUpGpW6JUpq4kJ9X4C6EKX61o+5y2ojTZ9MtJFwpia3sSUa717zhPckJsxJ
         KkeQ==
X-Gm-Message-State: AJIora838uCv8xnSw+PXzJPsOM0YuUdCjhAArD7xlRMFpVL42mYitf+5
        uZn6GSGj+ZO+UOV+GsKDVPmZMOOff/cIWxGAIXU=
X-Google-Smtp-Source: AGRyM1scf0x9uXz7Fzdg3W+qR1UxRi6390+fzDX4/2w249BTS0vQcLdvdZID8wckRN9/UKHaHmHXKWhg6noFn1RAVMc=
X-Received: by 2002:a05:6402:c92:b0:43a:7177:5be7 with SMTP id
 cm18-20020a0564020c9200b0043a71775be7mr13269711edb.224.1657082197478; Tue, 05
 Jul 2022 21:36:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220609062412.3950380-1-james.hilliard1@gmail.com>
 <CAEf4BzbL8ivLH=HZDFTNyCTFjhWrWLcY3K34Ef+q4Pr+oDe_Gw@mail.gmail.com>
 <CADvTj4opMh978fMBV7cH89wbS1N_PK31AybZJ5NUacnp4kBeqg@mail.gmail.com>
 <CAEf4BzbkckyfKuhu9CV9wofCHeYa83NnfQNeK82pXLe-s8zhxA@mail.gmail.com>
 <CADvTj4q5BtrhUwvxdke0NFDRBh1bUzPRd4iGoGvt_HaDp2V7MQ@mail.gmail.com>
 <CAEf4BzZkSXLqFz4Cjx4_Z_0sxBBSd-SEhT8u+3EZVccqH7qXkg@mail.gmail.com> <CADvTj4ozq_Q0m+aKhQ+yfuGdrJOeSyt=4ORt5AjtZW61Z6OosA@mail.gmail.com>
In-Reply-To: <CADvTj4ozq_Q0m+aKhQ+yfuGdrJOeSyt=4ORt5AjtZW61Z6OosA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Jul 2022 21:36:26 -0700
Message-ID: <CAEf4Bzap74qnzpYHbpSUS+c5JfA4Mh=sfr6rhnAm-so2qEYkRw@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 1, 2022 at 10:12 AM James Hilliard
<james.hilliard1@gmail.com> wrote:
>
> On Thu, Jun 30, 2022 at 3:51 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Jun 27, 2022 at 9:43 PM James Hilliard
> > <james.hilliard1@gmail.com> wrote:
> > >
> > > On Mon, Jun 27, 2022 at 5:16 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Thu, Jun 9, 2022 at 4:27 PM James Hilliard <james.hilliard1@gmai=
l.com> wrote:
> > > > >
> > > > > On Thu, Jun 9, 2022 at 12:13 PM Andrii Nakryiko
> > > > > <andrii.nakryiko@gmail.com> wrote:
> > > > > >
> > > > > > On Wed, Jun 8, 2022 at 11:24 PM James Hilliard
> > > > > > <james.hilliard1@gmail.com> wrote:
> > > > > > >
> > > > > > > It seems the gcc preprocessor breaks unless pragmas are wrapp=
ed
> > > > > > > individually inside macros when surrounding __attribute__.
> > > > > > >
> > > > > > > Fixes errors like:
> > > > > > > error: expected identifier or '(' before '#pragma'
> > > > > > >   106 | SEC("cgroup/bind6")
> > > > > > >       | ^~~
> > > > > > >
> > > > > > > error: expected '=3D', ',', ';', 'asm' or '__attribute__' bef=
ore '#pragma'
> > > > > > >   114 | char _license[] SEC("license") =3D "GPL";
> > > > > > >       | ^~~
> > > > > > >
> > > > > > > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> > > > > > > ---
> > > > > > > Changes v2 -> v3:
> > > > > > >   - just fix SEC pragma
> > > > > > > Changes v1 -> v2:
> > > > > > >   - replace typeof with __typeof__ instead of changing pragma=
 macros
> > > > > > > ---
> > > > > > >  tools/lib/bpf/bpf_helpers.h | 7 ++++---
> > > > > > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > > > > >
> > > > > > > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_=
helpers.h
> > > > > > > index fb04eaf367f1..66d23c47c206 100644
> > > > > > > --- a/tools/lib/bpf/bpf_helpers.h
> > > > > > > +++ b/tools/lib/bpf/bpf_helpers.h
> > > > > > > @@ -22,11 +22,12 @@
> > > > > > >   * To allow use of SEC() with externs (e.g., for extern .map=
s declarations),
> > > > > > >   * make sure __attribute__((unused)) doesn't trigger compila=
tion warning.
> > > > > > >   */
> > > > > > > +#define DO_PRAGMA(x) _Pragma(#x)
> > > > > > >  #define SEC(name) \
> > > > > > > -       _Pragma("GCC diagnostic push")                       =
               \
> > > > > > > -       _Pragma("GCC diagnostic ignored \"-Wignored-attribute=
s\"")          \
> > > > > > > +       DO_PRAGMA("GCC diagnostic push")                     =
               \
> > > > > > > +       DO_PRAGMA("GCC diagnostic ignored \"-Wignored-attribu=
tes\"")        \
> > > > > > >         __attribute__((section(name), used))                 =
               \
> > > > > > > -       _Pragma("GCC diagnostic pop")                        =
               \
> > > > > > > +       DO_PRAGMA("GCC diagnostic pop")                      =
               \
> > > > > > >
> > > > > >
> > > > > > I'm not going to accept this unless I can repro it in the first=
 place.
> > > > > > Using -std=3Dc17 doesn't trigger such issue. Please provide the=
 repro
> > > > > > first. Building systemd is not a repro, unfortunately. Please t=
ry to
> > > > > > do it based on libbpf-bootstrap ([0])
> > > > > >
> > > > > >   [0] https://github.com/libbpf/libbpf-bootstrap
> > > > >
> > > > > Seems to reproduce just fine already there with:
> > > > > https://github.com/libbpf/libbpf-bootstrap/blob/31face36d469a0e3e=
4c4ac1cafc66747d3150930/examples/c/minimal.bpf.c
> > > > >
> > > > > See here:
> > > > > $ /home/buildroot/buildroot/output/per-package/libbpf/host/bin/bp=
f-gcc
> > > > > -Winline -O2 -mframe-limit=3D32767 -mco-re -gbtf -std=3Dgnu17 -v
> > > > > -D__x86_64__ -mlittle-endian -I
> > > > > /home/buildroot/buildroot/output/per-package/libbpf/host/x86_64-b=
uildroot-linux-gnu/sysroot/usr/include
> > > > > minimal.bpf.c -o minimal.bpf.o
> > > > > Using built-in specs.
> > > > > COLLECT_GCC=3D/home/buildroot/buildroot/output/per-package/libbpf=
/host/bin/bpf-gcc.br_real
> > > > > COLLECT_LTO_WRAPPER=3D/home/buildroot/buildroot/output/per-packag=
e/libbpf/host/bin/../libexec/gcc/bpf-buildroot-none/12.1.0/lto-wrapper
> > > > > Target: bpf-buildroot-none
> > > > > Configured with: ./configure
> > > > > --prefix=3D/home/buildroot/buildroot/output/per-package/host-gcc-=
bpf/host
> > > > > --sysconfdir=3D/home/buildroot/buildroot/output/per-package/host-=
gcc-bpf/host/etc
> > > > > --localstatedir=3D/home/buildroot/buildroot/output/per-package/ho=
st-gcc-bpf/host/var
> > > > > --enable-shared --disable-static --disable-gtk-doc
> > > > > --disable-gtk-doc-html --disable-doc --disable-docs
> > > > > --disable-documentation --disable-debug --with-xmlto=3Dno --with-=
fop=3Dno
> > > > > --disable-nls --disable-dependency-tracking
> > > > > --target=3Dbpf-buildroot-none
> > > > > --prefix=3D/home/buildroot/buildroot/output/per-package/host-gcc-=
bpf/host
> > > > > --sysconfdir=3D/home/buildroot/buildroot/output/per-package/host-=
gcc-bpf/host/etc
> > > > > --enable-languages=3Dc --with-gnu-ld --enable-static
> > > > > --disable-decimal-float --disable-gcov --disable-libssp
> > > > > --disable-multilib --disable-shared
> > > > > --with-gmp=3D/home/buildroot/buildroot/output/per-package/host-gc=
c-bpf/host
> > > > > --with-mpc=3D/home/buildroot/buildroot/output/per-package/host-gc=
c-bpf/host
> > > > > --with-mpfr=3D/home/buildroot/buildroot/output/per-package/host-g=
cc-bpf/host
> > > > > --with-pkgversion=3D'Buildroot 2022.05-118-ge052166011-dirty'
> > > > > --with-bugurl=3Dhttp://bugs.buildroot.net/ --without-zstd --witho=
ut-isl
> > > > > --without-cloog
> > > > > Thread model: single
> > > > > Supported LTO compression algorithms: zlib
> > > > > gcc version 12.1.0 (Buildroot 2022.05-118-ge052166011-dirty)
> > > > > COLLECT_GCC_OPTIONS=3D'--sysroot=3D/home/buildroot/buildroot/outp=
ut/per-package/libbpf/host/x86_64-buildroot-linux-gnu/sysroot'
> > > > > '-Winline' '-O2' '-mframe-limit=3D32767' '-mco-re' '-gbtf' '-std=
=3Dgnu17'
> > > > > '-v' '-D' '__x86_64__' '-mlittle-endian' '-I'
> > > > > '/home/buildroot/buildroot/output/per-package/libbpf/host/x86_64-=
buildroot-linux-gnu/sysroot/usr/include'
> > > > > '-o' 'minimal.bpf.o' '-dumpdir' 'minimal.bpf.o-'
> > > > >  /home/buildroot/buildroot/output/per-package/libbpf/host/bin/../=
libexec/gcc/bpf-buildroot-none/12.1.0/cc1
> > > > > -quiet -v -I /home/buildroot/buildroot/output/per-package/libbpf/=
host/x86_64-buildroot-linux-gnu/sysroot/usr/include
> > > > > -iprefix /home/buildroot/buildroot/output/per-package/libbpf/host=
/bin/../lib/gcc/bpf-buildroot-none/12.1.0/
> > > > > -isysroot /home/buildroot/buildroot/output/per-package/libbpf/hos=
t/x86_64-buildroot-linux-gnu/sysroot
> > > > > -D __x86_64__ minimal.bpf.c -quiet -dumpdir minimal.bpf.o- -dumpb=
ase
> > > > > minimal.bpf.c -dumpbase-ext .c -mframe-limit=3D32767 -mco-re
> > > > > -mlittle-endian -gbtf -O2 -Winline -std=3Dgnu17 -version -o
> > > > > /tmp/cct4AXvg.s
> > > > > GNU C17 (Buildroot 2022.05-118-ge052166011-dirty) version 12.1.0
> > > > > (bpf-buildroot-none)
> > > > >     compiled by GNU C version 12.1.0, GMP version 6.2.1, MPFR ver=
sion
> > > > > 4.1.0, MPC version 1.2.1, isl version none
> > > > > GGC heuristics: --param ggc-min-expand=3D100 --param ggc-min-heap=
size=3D131072
> > > > > ignoring nonexistent directory
> > > > > "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../=
lib/gcc/bpf-buildroot-none/12.1.0/../../../../bpf-buildroot-none/sys-includ=
e"
> > > > > ignoring nonexistent directory
> > > > > "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../=
lib/gcc/bpf-buildroot-none/12.1.0/../../../../bpf-buildroot-none/include"
> > > > > ignoring duplicate directory
> > > > > "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../=
lib/gcc/../../lib/gcc/bpf-buildroot-none/12.1.0/include"
> > > > > ignoring duplicate directory
> > > > > "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../=
lib/gcc/../../lib/gcc/bpf-buildroot-none/12.1.0/include-fixed"
> > > > > ignoring nonexistent directory
> > > > > "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../=
lib/gcc/../../lib/gcc/bpf-buildroot-none/12.1.0/../../../../bpf-buildroot-n=
one/sys-include"
> > > > > ignoring nonexistent directory
> > > > > "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../=
lib/gcc/../../lib/gcc/bpf-buildroot-none/12.1.0/../../../../bpf-buildroot-n=
one/include"
> > > > > #include "..." search starts here:
> > > > > #include <...> search starts here:
> > > > >  /home/buildroot/buildroot/output/per-package/libbpf/host/x86_64-=
buildroot-linux-gnu/sysroot/usr/include
> > > > >  /home/buildroot/buildroot/output/per-package/libbpf/host/bin/../=
lib/gcc/bpf-buildroot-none/12.1.0/include
> > > > >  /home/buildroot/buildroot/output/per-package/libbpf/host/bin/../=
lib/gcc/bpf-buildroot-none/12.1.0/include-fixed
> > > > > End of search list.
> > > > > GNU C17 (Buildroot 2022.05-118-ge052166011-dirty) version 12.1.0
> > > > > (bpf-buildroot-none)
> > > > >     compiled by GNU C version 12.1.0, GMP version 6.2.1, MPFR ver=
sion
> > > > > 4.1.0, MPC version 1.2.1, isl version none
> > > > > GGC heuristics: --param ggc-min-expand=3D100 --param ggc-min-heap=
size=3D131072
> > > > > Compiler executable checksum: 9bf241ca1a2dd4ffd7652c5e247c9be8
> > > > > minimal.bpf.c:6:1: error: expected '=3D', ',', ';', 'asm' or
> > > > > '__attribute__' before '#pragma'
> > > > >     6 | char LICENSE[] SEC("license") =3D "Dual BSD/GPL";
> > > > >       | ^~~
> > > > > minimal.bpf.c:6:1: error: expected identifier or '(' before '#pra=
gma'
> > > > > minimal.bpf.c:10:1: error: expected identifier or '(' before '#pr=
agma'
> > > > >    10 | SEC("tp/syscalls/sys_enter_write")
> > > > >       | ^~~
> > > >
> > > > So this is a bug (hard to call this a feature) in gcc (not even
> > > > bpf-gcc, I could repro with a simple gcc). Is there a bug reported =
for
> > > > this somewhere? Are GCC folks aware and working on the fix?
> > >
> > > Yeah, saw a few issues that looked relevant:
> > > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D55578
> > > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D90400
> > >
> > > >
> > > > What's curious is that the only thing that allows to bypass this is
> > > > adding #x in macro, having #define DO_PRAGMA(x) _Pragma(x) doesn't
> > > > help.
> > > >
> > > > So ideally GCC can fix this?
> > >
> > > From the reported issues...it doesn't sound like a fix is going to be
> > > coming all that
> > > soon in GCC.
> > >
> > > > But either way your patch as is
> > > > erroneously passing extra quoted strings to _Pragma().
> > >
> > > I recall the extra quotes were needed to make this work, does it work=
 for you
> > > without them?
> > >
> > > >
> > > > I'm pondering whether it's just cleaner to define SEC() without
> > > > pragmas for GCC? It will only cause compiler warning about unnecess=
ary
> > > > unused attribute for extern *variable* declarations, which are very
> > > > rare. Instead of relying on this quirky "fix" approach. Ideally,
> > > > though, GCC just fixes _Pragma() handling, of course.
> > >
> > > I mean, as long as this workaround is reliable I'd say using it is th=
e
> > > best option
> > > for backwards compatibility, especially since it's only needed in one=
 place from
> > > the looks of it.
> >
> > Is it reliable, though? Adding those quotes breaks Clang (I checked)
> > and it doesn't work as expected with GCC as well. It stops complaining
> > about #pragma, but it also doesn't push -Wignored-attributes. Here's
> > the test:
>
> Ok, yeah, guess my hack doesn't really work then.
>
> >
> > #define DO_PRAGMA(x) _Pragma(#x)
> >
> > #define SEC(name) \
> >        DO_PRAGMA("GCC diagnostic push")                                =
    \
> >        DO_PRAGMA("GCC diagnostic ignored \"-Wignored-attributes\"")    =
    \
> >         __attribute__((section(name), used))                           =
    \
> >        DO_PRAGMA("GCC diagnostic pop")                                 =
    \
> >
> > extern int something SEC("whatever");
> >
> > int main()
> > {
> >         return something;
> > }
> >
> >
> > Used like this you get same warning:
> >
> > $ cc test.c
> > test.c:10:1: warning: =E2=80=98used=E2=80=99 attribute ignored [-Wattri=
butes]
> >    10 | extern int something SEC("whatever");
> >       | ^~~~~~
> >
> > Removing quotes fixes Clang (linker error is expected)
> >
> > $ clang test.c
> > /opt/rh/gcc-toolset-11/root/usr/lib/gcc/x86_64-redhat-linux/11/../../..=
/../bin/ld:
>
> FYI I was testing with GCC 12.1.
>
> > /tmp/test-4eec0b.o: in function `main':
> > test.c:(.text+0xe): undefined reference to `something'
> >
> > But we get back to the original problem with GCC:
> >
> > $ cc test.c
> > test.c:10:1: error: expected =E2=80=98=3D=E2=80=99, =E2=80=98,=E2=80=99=
, =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or =E2=80=98__attribute__=E2=
=80=99
> > before =E2=80=98#pragma=E2=80=99
> >    10 | extern int something SEC("whatever");
> >       | ^~~
> > test.c:10:1: error: expected identifier or =E2=80=98(=E2=80=99 before =
=E2=80=98#pragma=E2=80=99
> > test.c: In function =E2=80=98main=E2=80=99:
> > test.c:14:16: error: =E2=80=98something=E2=80=99 undeclared (first use =
in this function)
> >    14 |         return something;
> >       |                ^~~~~~~~~
> >
> >
> > So the best way forward I can propose for you is this:
>
> Yeah, probably the best option for now.
>
> >
> >
> > #if __GNUC__ && !__clang__
> >
> > #define SEC(name) __attribute__((section(name), used))
> >
> > #else
> >
> > #define SEC(name) \
> >         _Pragma("GCC diagnostic push")                                 =
     \
> >         _Pragma("GCC diagnostic ignored \"-Wignored-attributes\"")     =
     \
> >         __attribute__((section(name), used))                           =
     \
> >         _Pragma("GCC diagnostic pop")                                  =
     \
> >
> > #endif
> >
> > extern int something SEC("whatever");
> >
> > int main()
> > {
> >         return something;
> > }
> >
> >
> > With some comments explaining how broken GCC is w.r.t. _Pragma. And
> > just live with compiler warning about used if used with externs.
>
> Yeah, do you want to spin a patch with that? I think you probably have a =
better
> understanding of the issue at this point than I do.

I'd appreciate it if you do that and test selftests/bpf compilation
and execution with bpf-gcc (which I don't have locally). Our CI will
take care of testing Clang compilation. Thanks!

>
> >
> >
> > >
> > > >
> > > > >
> > > > > >
> > > > > > >  /* Avoid 'linux/stddef.h' definition of '__always_inline'. *=
/
> > > > > > >  #undef __always_inline
> > > > > > > --
> > > > > > > 2.25.1
> > > > > > >
