Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC2825657
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 19:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbfEURH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 13:07:26 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38152 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728515AbfEURH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 13:07:26 -0400
Received: by mail-qt1-f196.google.com with SMTP id l3so10592418qtj.5
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 10:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=9uPTbP2BF+UpteaL2KhM3aAj7QjRcnMmKHeI6Yh9EPI=;
        b=iDZLE7yNQ4lDtD0XYGkkl4K2STILfN2iFJ4sfOJWHZcNwYcoj01MXQAuZDOz8ypaRK
         gQ2al+DExF3ndweDKlzGJ6S8sh3a4I1jE9yZebCzr/OaHgirNisBjWSFzzZ0aN37o2PE
         bQq5ubtJDozzrq4fm4E7hHtO8mLFyoaA8Qex24dH+DQ36QAkCCXKVyOKiuGyL+WEUoit
         I0O7bjcNirgWpLwqrE3kiuzk0lVusS/1S4J8ZocRTyM1V2+Hm8DaSmHQcZFgHDmya+Bv
         hRISJqciG/x9jHFQJfYLXz+UjXrCfL/2L4BytVMEOGs4abeYw5KrgDt4gbfB+1SGo49B
         /xHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=9uPTbP2BF+UpteaL2KhM3aAj7QjRcnMmKHeI6Yh9EPI=;
        b=puQzefo5xY2xSW7oPjMprdx/yyAP3754JelZv2zv5ytSx5/mh+t4IUHilh0B0JKbY3
         WmGyTY2YZ7DjvXx0HdViWN+2SkwJouMJ5ibcgdVD/sQp469x4mfEWMHtREpmLGT+JLCg
         neR5X/zpEthQnRR1sb1TxahZphMvmhNXLtPDeB0MCnwQmBt9R5hmCyj9JuJdGBt9t6bC
         H1acgR8+YiY/P231euzh7biz6YcEVR3sMJfnyIoo5r3Yy+xuSg6/DzneykWnJwcF1Jca
         LHi5fSv6sN7S6aANmT0scyCAOzM3Z/VY/cjUBsHzyPfE45ik0VconukmwPRWRAKglWLk
         rmQQ==
X-Gm-Message-State: APjAAAVS0szEX3fYnKFFSSnnOU8diCP1jjq4wo21WLxS4qBUFop0pM6R
        UitnKCdfiXFKysRMj7SsySByJw==
X-Google-Smtp-Source: APXvYqxcQMuxnmJbIw2a9Sa0BNYiUuGeK0GKVudpfcvZwyO/XpF8PgnhrbotuKRw055g6yJA5t4Tkw==
X-Received: by 2002:ac8:1671:: with SMTP id x46mr47261518qtk.240.1558458444792;
        Tue, 21 May 2019 10:07:24 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l127sm9247563qkc.81.2019.05.21.10.07.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 21 May 2019 10:07:24 -0700 (PDT)
Date:   Tue, 21 May 2019 10:06:48 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        xdp-newbies@vger.kernel.org, bpf@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 1/5] samples/bpf: fix test_lru_dist build
Message-ID: <20190521100648.1ce9b5be@cakuba.netronome.com>
In-Reply-To: <CAGnkfhxZPXUvBemRxAFfoq+y-UmtdQH=dvnyeLBJQo43U2=sTg@mail.gmail.com>
References: <20190518004639.20648-1-mcroce@redhat.com>
        <CAGnkfhxt=nq-JV+D5Rrquvn8BVOjHswEJmuVVZE78p9HvAg9qQ@mail.gmail.com>
        <20190520133830.1ac11fc8@cakuba.netronome.com>
        <dfb6cf40-81f4-237e-9a43-646077e020f7@iogearbox.net>
        <CAGnkfhxZPXUvBemRxAFfoq+y-UmtdQH=dvnyeLBJQo43U2=sTg@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 May 2019 17:36:17 +0200, Matteo Croce wrote:
> On Tue, May 21, 2019 at 5:21 PM Daniel Borkmann <daniel@iogearbox.net> wr=
ote:
> >
> > On 05/20/2019 10:38 PM, Jakub Kicinski wrote: =20
> > > On Mon, 20 May 2019 19:46:27 +0200, Matteo Croce wrote: =20
> > >> On Sat, May 18, 2019 at 2:46 AM Matteo Croce <mcroce@redhat.com> wro=
te: =20
> > >>>
> > >>> Fix the following error by removing a duplicate struct definition: =
=20
> > >>
> > >> Hi all,
> > >>
> > >> I forget to send a cover letter for this series, but basically what I
> > >> wanted to say is that while patches 1-3 are very straightforward,
> > >> patches 4-5 are a bit rough and I accept suggstions to make a cleaner
> > >> work. =20
> > >
> > > samples depend on headers being locally installed:
> > >
> > > make headers_install
> > >
> > > Are you intending to change that? =20
> >
> > +1, Matteo, could you elaborate?
> >
> > On latest bpf tree, everything compiles just fine:
> >
> > [root@linux bpf]# make headers_install
> > [root@linux bpf]# make -C samples/bpf/
> > make: Entering directory '/home/darkstar/trees/bpf/samples/bpf'
> > make -C ../../ /home/darkstar/trees/bpf/samples/bpf/ BPF_SAMPLES_PATH=
=3D/home/darkstar/trees/bpf/samples/bpf
> > make[1]: Entering directory '/home/darkstar/trees/bpf'
> >   CALL    scripts/checksyscalls.sh
> >   CALL    scripts/atomic/check-atomics.sh
> >   DESCEND  objtool
> > make -C /home/darkstar/trees/bpf/samples/bpf/../../tools/lib/bpf/ RM=3D=
'rm -rf' LDFLAGS=3D srctree=3D/home/darkstar/trees/bpf/samples/bpf/../../ O=
=3D
> >   HOSTCC  /home/darkstar/trees/bpf/samples/bpf/test_lru_dist
> >   HOSTCC  /home/darkstar/trees/bpf/samples/bpf/sock_example
> > =20
>=20
> Hi all,
>=20
> I have kernel-headers installed from master, but yet the samples fail to =
build:
>=20
> matteo@turbo:~/src/linux/samples/bpf$ rpm -q kernel-headers
> kernel-headers-5.2.0_rc1-38.x86_64
>=20
> matteo@turbo:~/src/linux/samples/bpf$ git describe HEAD
> v5.2-rc1-97-g5bdd9ad875b6
>=20
> matteo@turbo:~/src/linux/samples/bpf$ make
> make -C ../../ /home/matteo/src/linux/samples/bpf/
> BPF_SAMPLES_PATH=3D/home/matteo/src/linux/samples/bpf
> make[1]: Entering directory '/home/matteo/src/linux'
>   CALL    scripts/checksyscalls.sh
>   CALL    scripts/atomic/check-atomics.sh
>   DESCEND  objtool
> make -C /home/matteo/src/linux/samples/bpf/../../tools/lib/bpf/ RM=3D'rm
> -rf' LDFLAGS=3D srctree=3D/home/matteo/src/linux/samples/bpf/../../ O=3D
>   HOSTCC  /home/matteo/src/linux/samples/bpf/test_lru_dist
> /home/matteo/src/linux/samples/bpf/test_lru_dist.c:39:8: error:
> redefinition of =E2=80=98struct list_head=E2=80=99
>    39 | struct list_head {
>       |        ^~~~~~~~~
> In file included from /home/matteo/src/linux/samples/bpf/test_lru_dist.c:=
9:
> ./tools/include/linux/types.h:69:8: note: originally defined here
>    69 | struct list_head {
>       |        ^~~~~~~~~
> make[2]: *** [scripts/Makefile.host:90:
> /home/matteo/src/linux/samples/bpf/test_lru_dist] Error 1
> make[1]: *** [Makefile:1762: /home/matteo/src/linux/samples/bpf/] Error 2
> make[1]: Leaving directory '/home/matteo/src/linux'
> make: *** [Makefile:231: all] Error 2
>=20
> Am I missing something obvious?

Yes ;)  Samples use a local installation of headers in $objtree/usr (I
think, maybe $srctree/usr).  So you need to do make headers_install in
your kernel source tree, otherwise the include path from tools/ takes
priority over your global /usr/include and causes these issues.  I had
this path in my tree for some time, but I don't like enough to post it:

commit 35fb614049e93d46af708c0eaae6601df54017b3
Author: Jakub Kicinski <jakub.kicinski@netronome.com>
Date:   Mon Dec 3 15:00:24 2018 -0800

    bpf: maybe warn ppl about hrds_install
   =20
    Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 4f0a1cdbfe7c..f79a4ed2f9f7 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -208,6 +208,15 @@ HOSTCC =3D $(CROSS_COMPILE)gcc
 CLANG_ARCH_ARGS =3D -target $(ARCH)
 endif
=20
+HDR_PROBE :=3D $(shell echo "\#include <linux/types.h>\n struct list_head =
{ int a; }; int main() { return 0; }" | \
+       gcc $(KBUILD_HOSTCFLAGS) -x c - -o /dev/null 2>/dev/null && \
+       echo okay)
+
+ifeq ($(HDR_PROBE),)
+$(warning Detected possible issues with include path.)
+$(warning Please install kernel headers locally (make headers_install))
+endif
+
 BTF_LLC_PROBE :=3D $(shell $(LLC) -march=3Dbpf -mattr=3Dhelp 2>&1 | grep d=
warfris)
 BTF_PAHOLE_PROBE :=3D $(shell $(BTF_PAHOLE) --help 2>&1 | grep BTF)
 BTF_OBJCOPY_PROBE :=3D $(shell $(LLVM_OBJCOPY) --help 2>&1 | grep -i 'usag=
e.*llvm')
