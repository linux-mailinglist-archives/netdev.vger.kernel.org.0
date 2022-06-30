Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE50562595
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbiF3Vv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbiF3Vv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:51:58 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6462653EDF;
        Thu, 30 Jun 2022 14:51:56 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id lw20so624739ejb.4;
        Thu, 30 Jun 2022 14:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fQmj+4djLot+BM5Xbe38Wuy8twk3q3PYBp8tjTSzigE=;
        b=ZLB9PXX6uec4fPzZ5iTzenYJb0Se6cd2kCW1sLfxUiPLEdXo6a81ZEjsgrvT6fjJJh
         sMrvcW/mbR8DdOXi/ojKdurVDDOVyILKUYcnBxH0VG3vO70uuID5oGdhIPn+OeXcjfIw
         HAhixcDD1Or1O75E0KXKKvg9F5P2MSp+tNt57opuGERsAvmBw5wnAHa9nHgeTbsmYghC
         HOWZAlQV09dieahKLMPc3scGFNmzIzJ/Rk4KHcVdKjYUsOdB+onkaoBM2J0m/m9zlRvW
         NcAERwkdrpDQMxnL3vBwECyCYoey7DdWafuPpJTU7MmllKJ0qnwYIdOFPVZZJM0NVfw/
         H9mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fQmj+4djLot+BM5Xbe38Wuy8twk3q3PYBp8tjTSzigE=;
        b=rVTRU4QKx+IHe/RtB8Vedx+gqwQN2tXK0oVye0cT2x5AlwL/poXcrusOxSQGnrsewh
         HrPJdcbagsLMEr9QTzFahitdOaEGLahuhv0sZ9HEClrEN6ZQejXnNYVRq1jHiQZK5aeP
         6QlRt05ZMKO2FQWrUqDeqA1oU6PUFoTXQ9lm1QRmEcpO5Awvs4IaFAKdR/Tvl5b7vRDg
         wpJY6AsrwqnXxvU4GdW2eX5O01zGRhVzRv87bKjjQPopHstrwW+gGln7FFNRdTjp6zJ/
         txAzvnCeKmbGsRKfRzICDyNsENWB54skOhRsG5o7CULbQ9MyEYQ4nsHatIE7U0LP/qsG
         OAuQ==
X-Gm-Message-State: AJIora/NwlgdQDt2hR8AL3ffUwy/lTCeFLpe3Kt7GtwXCJfbdpE4rkgY
        26aARzvFIK/aHmFt7pQsMchanJQ1wCV+Nkt6/S4=
X-Google-Smtp-Source: AGRyM1tSzuf1xl1y5rqKFB3IS0uPOh82cYjTgc58Y6wJ2mM8wLbRvO8B8/gL9ygbj9EezWS07u0EHPc667jYM01goKI=
X-Received: by 2002:a17:906:a3ca:b0:726:2bd2:87bc with SMTP id
 ca10-20020a170906a3ca00b007262bd287bcmr10947112ejb.226.1656625914877; Thu, 30
 Jun 2022 14:51:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220609062412.3950380-1-james.hilliard1@gmail.com>
 <CAEf4BzbL8ivLH=HZDFTNyCTFjhWrWLcY3K34Ef+q4Pr+oDe_Gw@mail.gmail.com>
 <CADvTj4opMh978fMBV7cH89wbS1N_PK31AybZJ5NUacnp4kBeqg@mail.gmail.com>
 <CAEf4BzbkckyfKuhu9CV9wofCHeYa83NnfQNeK82pXLe-s8zhxA@mail.gmail.com> <CADvTj4q5BtrhUwvxdke0NFDRBh1bUzPRd4iGoGvt_HaDp2V7MQ@mail.gmail.com>
In-Reply-To: <CADvTj4q5BtrhUwvxdke0NFDRBh1bUzPRd4iGoGvt_HaDp2V7MQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 30 Jun 2022 14:51:43 -0700
Message-ID: <CAEf4BzZkSXLqFz4Cjx4_Z_0sxBBSd-SEhT8u+3EZVccqH7qXkg@mail.gmail.com>
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

On Mon, Jun 27, 2022 at 9:43 PM James Hilliard
<james.hilliard1@gmail.com> wrote:
>
> On Mon, Jun 27, 2022 at 5:16 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Jun 9, 2022 at 4:27 PM James Hilliard <james.hilliard1@gmail.co=
m> wrote:
> > >
> > > On Thu, Jun 9, 2022 at 12:13 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Wed, Jun 8, 2022 at 11:24 PM James Hilliard
> > > > <james.hilliard1@gmail.com> wrote:
> > > > >
> > > > > It seems the gcc preprocessor breaks unless pragmas are wrapped
> > > > > individually inside macros when surrounding __attribute__.
> > > > >
> > > > > Fixes errors like:
> > > > > error: expected identifier or '(' before '#pragma'
> > > > >   106 | SEC("cgroup/bind6")
> > > > >       | ^~~
> > > > >
> > > > > error: expected '=3D', ',', ';', 'asm' or '__attribute__' before =
'#pragma'
> > > > >   114 | char _license[] SEC("license") =3D "GPL";
> > > > >       | ^~~
> > > > >
> > > > > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> > > > > ---
> > > > > Changes v2 -> v3:
> > > > >   - just fix SEC pragma
> > > > > Changes v1 -> v2:
> > > > >   - replace typeof with __typeof__ instead of changing pragma mac=
ros
> > > > > ---
> > > > >  tools/lib/bpf/bpf_helpers.h | 7 ++++---
> > > > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_help=
ers.h
> > > > > index fb04eaf367f1..66d23c47c206 100644
> > > > > --- a/tools/lib/bpf/bpf_helpers.h
> > > > > +++ b/tools/lib/bpf/bpf_helpers.h
> > > > > @@ -22,11 +22,12 @@
> > > > >   * To allow use of SEC() with externs (e.g., for extern .maps de=
clarations),
> > > > >   * make sure __attribute__((unused)) doesn't trigger compilation=
 warning.
> > > > >   */
> > > > > +#define DO_PRAGMA(x) _Pragma(#x)
> > > > >  #define SEC(name) \
> > > > > -       _Pragma("GCC diagnostic push")                           =
           \
> > > > > -       _Pragma("GCC diagnostic ignored \"-Wignored-attributes\""=
)          \
> > > > > +       DO_PRAGMA("GCC diagnostic push")                         =
           \
> > > > > +       DO_PRAGMA("GCC diagnostic ignored \"-Wignored-attributes\=
"")        \
> > > > >         __attribute__((section(name), used))                     =
           \
> > > > > -       _Pragma("GCC diagnostic pop")                            =
           \
> > > > > +       DO_PRAGMA("GCC diagnostic pop")                          =
           \
> > > > >
> > > >
> > > > I'm not going to accept this unless I can repro it in the first pla=
ce.
> > > > Using -std=3Dc17 doesn't trigger such issue. Please provide the rep=
ro
> > > > first. Building systemd is not a repro, unfortunately. Please try t=
o
> > > > do it based on libbpf-bootstrap ([0])
> > > >
> > > >   [0] https://github.com/libbpf/libbpf-bootstrap
> > >
> > > Seems to reproduce just fine already there with:
> > > https://github.com/libbpf/libbpf-bootstrap/blob/31face36d469a0e3e4c4a=
c1cafc66747d3150930/examples/c/minimal.bpf.c
> > >
> > > See here:
> > > $ /home/buildroot/buildroot/output/per-package/libbpf/host/bin/bpf-gc=
c
> > > -Winline -O2 -mframe-limit=3D32767 -mco-re -gbtf -std=3Dgnu17 -v
> > > -D__x86_64__ -mlittle-endian -I
> > > /home/buildroot/buildroot/output/per-package/libbpf/host/x86_64-build=
root-linux-gnu/sysroot/usr/include
> > > minimal.bpf.c -o minimal.bpf.o
> > > Using built-in specs.
> > > COLLECT_GCC=3D/home/buildroot/buildroot/output/per-package/libbpf/hos=
t/bin/bpf-gcc.br_real
> > > COLLECT_LTO_WRAPPER=3D/home/buildroot/buildroot/output/per-package/li=
bbpf/host/bin/../libexec/gcc/bpf-buildroot-none/12.1.0/lto-wrapper
> > > Target: bpf-buildroot-none
> > > Configured with: ./configure
> > > --prefix=3D/home/buildroot/buildroot/output/per-package/host-gcc-bpf/=
host
> > > --sysconfdir=3D/home/buildroot/buildroot/output/per-package/host-gcc-=
bpf/host/etc
> > > --localstatedir=3D/home/buildroot/buildroot/output/per-package/host-g=
cc-bpf/host/var
> > > --enable-shared --disable-static --disable-gtk-doc
> > > --disable-gtk-doc-html --disable-doc --disable-docs
> > > --disable-documentation --disable-debug --with-xmlto=3Dno --with-fop=
=3Dno
> > > --disable-nls --disable-dependency-tracking
> > > --target=3Dbpf-buildroot-none
> > > --prefix=3D/home/buildroot/buildroot/output/per-package/host-gcc-bpf/=
host
> > > --sysconfdir=3D/home/buildroot/buildroot/output/per-package/host-gcc-=
bpf/host/etc
> > > --enable-languages=3Dc --with-gnu-ld --enable-static
> > > --disable-decimal-float --disable-gcov --disable-libssp
> > > --disable-multilib --disable-shared
> > > --with-gmp=3D/home/buildroot/buildroot/output/per-package/host-gcc-bp=
f/host
> > > --with-mpc=3D/home/buildroot/buildroot/output/per-package/host-gcc-bp=
f/host
> > > --with-mpfr=3D/home/buildroot/buildroot/output/per-package/host-gcc-b=
pf/host
> > > --with-pkgversion=3D'Buildroot 2022.05-118-ge052166011-dirty'
> > > --with-bugurl=3Dhttp://bugs.buildroot.net/ --without-zstd --without-i=
sl
> > > --without-cloog
> > > Thread model: single
> > > Supported LTO compression algorithms: zlib
> > > gcc version 12.1.0 (Buildroot 2022.05-118-ge052166011-dirty)
> > > COLLECT_GCC_OPTIONS=3D'--sysroot=3D/home/buildroot/buildroot/output/p=
er-package/libbpf/host/x86_64-buildroot-linux-gnu/sysroot'
> > > '-Winline' '-O2' '-mframe-limit=3D32767' '-mco-re' '-gbtf' '-std=3Dgn=
u17'
> > > '-v' '-D' '__x86_64__' '-mlittle-endian' '-I'
> > > '/home/buildroot/buildroot/output/per-package/libbpf/host/x86_64-buil=
droot-linux-gnu/sysroot/usr/include'
> > > '-o' 'minimal.bpf.o' '-dumpdir' 'minimal.bpf.o-'
> > >  /home/buildroot/buildroot/output/per-package/libbpf/host/bin/../libe=
xec/gcc/bpf-buildroot-none/12.1.0/cc1
> > > -quiet -v -I /home/buildroot/buildroot/output/per-package/libbpf/host=
/x86_64-buildroot-linux-gnu/sysroot/usr/include
> > > -iprefix /home/buildroot/buildroot/output/per-package/libbpf/host/bin=
/../lib/gcc/bpf-buildroot-none/12.1.0/
> > > -isysroot /home/buildroot/buildroot/output/per-package/libbpf/host/x8=
6_64-buildroot-linux-gnu/sysroot
> > > -D __x86_64__ minimal.bpf.c -quiet -dumpdir minimal.bpf.o- -dumpbase
> > > minimal.bpf.c -dumpbase-ext .c -mframe-limit=3D32767 -mco-re
> > > -mlittle-endian -gbtf -O2 -Winline -std=3Dgnu17 -version -o
> > > /tmp/cct4AXvg.s
> > > GNU C17 (Buildroot 2022.05-118-ge052166011-dirty) version 12.1.0
> > > (bpf-buildroot-none)
> > >     compiled by GNU C version 12.1.0, GMP version 6.2.1, MPFR version
> > > 4.1.0, MPC version 1.2.1, isl version none
> > > GGC heuristics: --param ggc-min-expand=3D100 --param ggc-min-heapsize=
=3D131072
> > > ignoring nonexistent directory
> > > "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../lib/=
gcc/bpf-buildroot-none/12.1.0/../../../../bpf-buildroot-none/sys-include"
> > > ignoring nonexistent directory
> > > "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../lib/=
gcc/bpf-buildroot-none/12.1.0/../../../../bpf-buildroot-none/include"
> > > ignoring duplicate directory
> > > "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../lib/=
gcc/../../lib/gcc/bpf-buildroot-none/12.1.0/include"
> > > ignoring duplicate directory
> > > "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../lib/=
gcc/../../lib/gcc/bpf-buildroot-none/12.1.0/include-fixed"
> > > ignoring nonexistent directory
> > > "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../lib/=
gcc/../../lib/gcc/bpf-buildroot-none/12.1.0/../../../../bpf-buildroot-none/=
sys-include"
> > > ignoring nonexistent directory
> > > "/home/buildroot/buildroot/output/per-package/libbpf/host/bin/../lib/=
gcc/../../lib/gcc/bpf-buildroot-none/12.1.0/../../../../bpf-buildroot-none/=
include"
> > > #include "..." search starts here:
> > > #include <...> search starts here:
> > >  /home/buildroot/buildroot/output/per-package/libbpf/host/x86_64-buil=
droot-linux-gnu/sysroot/usr/include
> > >  /home/buildroot/buildroot/output/per-package/libbpf/host/bin/../lib/=
gcc/bpf-buildroot-none/12.1.0/include
> > >  /home/buildroot/buildroot/output/per-package/libbpf/host/bin/../lib/=
gcc/bpf-buildroot-none/12.1.0/include-fixed
> > > End of search list.
> > > GNU C17 (Buildroot 2022.05-118-ge052166011-dirty) version 12.1.0
> > > (bpf-buildroot-none)
> > >     compiled by GNU C version 12.1.0, GMP version 6.2.1, MPFR version
> > > 4.1.0, MPC version 1.2.1, isl version none
> > > GGC heuristics: --param ggc-min-expand=3D100 --param ggc-min-heapsize=
=3D131072
> > > Compiler executable checksum: 9bf241ca1a2dd4ffd7652c5e247c9be8
> > > minimal.bpf.c:6:1: error: expected '=3D', ',', ';', 'asm' or
> > > '__attribute__' before '#pragma'
> > >     6 | char LICENSE[] SEC("license") =3D "Dual BSD/GPL";
> > >       | ^~~
> > > minimal.bpf.c:6:1: error: expected identifier or '(' before '#pragma'
> > > minimal.bpf.c:10:1: error: expected identifier or '(' before '#pragma=
'
> > >    10 | SEC("tp/syscalls/sys_enter_write")
> > >       | ^~~
> >
> > So this is a bug (hard to call this a feature) in gcc (not even
> > bpf-gcc, I could repro with a simple gcc). Is there a bug reported for
> > this somewhere? Are GCC folks aware and working on the fix?
>
> Yeah, saw a few issues that looked relevant:
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D55578
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D90400
>
> >
> > What's curious is that the only thing that allows to bypass this is
> > adding #x in macro, having #define DO_PRAGMA(x) _Pragma(x) doesn't
> > help.
> >
> > So ideally GCC can fix this?
>
> From the reported issues...it doesn't sound like a fix is going to be
> coming all that
> soon in GCC.
>
> > But either way your patch as is
> > erroneously passing extra quoted strings to _Pragma().
>
> I recall the extra quotes were needed to make this work, does it work for=
 you
> without them?
>
> >
> > I'm pondering whether it's just cleaner to define SEC() without
> > pragmas for GCC? It will only cause compiler warning about unnecessary
> > unused attribute for extern *variable* declarations, which are very
> > rare. Instead of relying on this quirky "fix" approach. Ideally,
> > though, GCC just fixes _Pragma() handling, of course.
>
> I mean, as long as this workaround is reliable I'd say using it is the
> best option
> for backwards compatibility, especially since it's only needed in one pla=
ce from
> the looks of it.

Is it reliable, though? Adding those quotes breaks Clang (I checked)
and it doesn't work as expected with GCC as well. It stops complaining
about #pragma, but it also doesn't push -Wignored-attributes. Here's
the test:

#define DO_PRAGMA(x) _Pragma(#x)

#define SEC(name) \
       DO_PRAGMA("GCC diagnostic push")                                    =
\
       DO_PRAGMA("GCC diagnostic ignored \"-Wignored-attributes\"")        =
\
        __attribute__((section(name), used))                               =
\
       DO_PRAGMA("GCC diagnostic pop")                                     =
\

extern int something SEC("whatever");

int main()
{
        return something;
}


Used like this you get same warning:

$ cc test.c
test.c:10:1: warning: =E2=80=98used=E2=80=99 attribute ignored [-Wattribute=
s]
   10 | extern int something SEC("whatever");
      | ^~~~~~

Removing quotes fixes Clang (linker error is expected)

$ clang test.c
/opt/rh/gcc-toolset-11/root/usr/lib/gcc/x86_64-redhat-linux/11/../../../../=
bin/ld:
/tmp/test-4eec0b.o: in function `main':
test.c:(.text+0xe): undefined reference to `something'

But we get back to the original problem with GCC:

$ cc test.c
test.c:10:1: error: expected =E2=80=98=3D=E2=80=99, =E2=80=98,=E2=80=99, =
=E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or =E2=80=98__attribute__=E2=80=
=99
before =E2=80=98#pragma=E2=80=99
   10 | extern int something SEC("whatever");
      | ^~~
test.c:10:1: error: expected identifier or =E2=80=98(=E2=80=99 before =E2=
=80=98#pragma=E2=80=99
test.c: In function =E2=80=98main=E2=80=99:
test.c:14:16: error: =E2=80=98something=E2=80=99 undeclared (first use in t=
his function)
   14 |         return something;
      |                ^~~~~~~~~


So the best way forward I can propose for you is this:


#if __GNUC__ && !__clang__

#define SEC(name) __attribute__((section(name), used))

#else

#define SEC(name) \
        _Pragma("GCC diagnostic push")                                     =
 \
        _Pragma("GCC diagnostic ignored \"-Wignored-attributes\"")         =
 \
        __attribute__((section(name), used))                               =
 \
        _Pragma("GCC diagnostic pop")                                      =
 \

#endif

extern int something SEC("whatever");

int main()
{
        return something;
}


With some comments explaining how broken GCC is w.r.t. _Pragma. And
just live with compiler warning about used if used with externs.


>
> >
> > >
> > > >
> > > > >  /* Avoid 'linux/stddef.h' definition of '__always_inline'. */
> > > > >  #undef __always_inline
> > > > > --
> > > > > 2.25.1
> > > > >
