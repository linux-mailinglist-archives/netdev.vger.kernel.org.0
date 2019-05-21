Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEC525AE4
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 01:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbfEUXdg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 May 2019 19:33:36 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:45018 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728107AbfEUXdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 19:33:36 -0400
Received: by mail-lf1-f65.google.com with SMTP id n134so206367lfn.11
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 16:33:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EWNs7FuLz+EBZGJHO+hMowOuxfAj3IDqhoBMiSjNTxE=;
        b=GB9OM6HAPI6/qzY4FvveFBw4ojui4DZtz5op1+xbw3Zw56AMnLoeejI5wTE+8TLH3l
         4qjYEnn51OdNa+c86XV3M98kwl/1HeVq9mtExpeQ2O1QOAmct3DhrXNVaSVncwFqNuNL
         LUCtr7bO70APhY/6sNDuTyYr2I95hHOuiuqMhBOcRSD/VsK5kz2j1CDS4cbdQ4CknXt6
         X4VOvRr+716QxysKrXe3OJvV+yfU5e6384yyzMU6toRlxAelEYG7bQXUC59rbDNYhc7C
         QBbK+SgCJrYGYhyRY1qGLYghhvS/QS6Gd4X1DCgigxlD7f3NO7MpcJxgcD5ySMYU/IFs
         Oj1Q==
X-Gm-Message-State: APjAAAXzRa66wfKME/5R/fjQz7CmapYcYVcMkEUjs2UXLwhsnVBHxtGT
        H1OkuyWJpN4mjUFXrIK+ZRnlIJrTnTRiEn8LW+3Wew==
X-Google-Smtp-Source: APXvYqxFOiQvAinejUQ5bQ+2ojPr4fXIqRhnzNKwRhVX51VwyZMoF/JudQtgNeOShJ06lSXqL67pZtMOqVe6jVwhGe0=
X-Received: by 2002:a19:a50b:: with SMTP id o11mr28367269lfe.2.1558481613710;
 Tue, 21 May 2019 16:33:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190518004639.20648-1-mcroce@redhat.com> <CAGnkfhxt=nq-JV+D5Rrquvn8BVOjHswEJmuVVZE78p9HvAg9qQ@mail.gmail.com>
 <20190520133830.1ac11fc8@cakuba.netronome.com> <dfb6cf40-81f4-237e-9a43-646077e020f7@iogearbox.net>
 <CAGnkfhxZPXUvBemRxAFfoq+y-UmtdQH=dvnyeLBJQo43U2=sTg@mail.gmail.com> <20190521100648.1ce9b5be@cakuba.netronome.com>
In-Reply-To: <20190521100648.1ce9b5be@cakuba.netronome.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Wed, 22 May 2019 01:32:57 +0200
Message-ID: <CAGnkfhzkRXF6WDYj9W2sffuLSYys_zbv9QekfuZWvc4VBCMKUA@mail.gmail.com>
Subject: Re: [PATCH 1/5] samples/bpf: fix test_lru_dist build
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        xdp-newbies@vger.kernel.org, bpf@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 7:07 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Tue, 21 May 2019 17:36:17 +0200, Matteo Croce wrote:
> > On Tue, May 21, 2019 at 5:21 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >
> > > On 05/20/2019 10:38 PM, Jakub Kicinski wrote:
> > > > On Mon, 20 May 2019 19:46:27 +0200, Matteo Croce wrote:
> > > >> On Sat, May 18, 2019 at 2:46 AM Matteo Croce <mcroce@redhat.com> wrote:
> > > >>>
> > > >>> Fix the following error by removing a duplicate struct definition:
> > > >>
> > > >> Hi all,
> > > >>
> > > >> I forget to send a cover letter for this series, but basically what I
> > > >> wanted to say is that while patches 1-3 are very straightforward,
> > > >> patches 4-5 are a bit rough and I accept suggstions to make a cleaner
> > > >> work.
> > > >
> > > > samples depend on headers being locally installed:
> > > >
> > > > make headers_install
> > > >
> > > > Are you intending to change that?
> > >
> > > +1, Matteo, could you elaborate?
> > >
> > > On latest bpf tree, everything compiles just fine:
> > >
> > > [root@linux bpf]# make headers_install
> > > [root@linux bpf]# make -C samples/bpf/
> > > make: Entering directory '/home/darkstar/trees/bpf/samples/bpf'
> > > make -C ../../ /home/darkstar/trees/bpf/samples/bpf/ BPF_SAMPLES_PATH=/home/darkstar/trees/bpf/samples/bpf
> > > make[1]: Entering directory '/home/darkstar/trees/bpf'
> > >   CALL    scripts/checksyscalls.sh
> > >   CALL    scripts/atomic/check-atomics.sh
> > >   DESCEND  objtool
> > > make -C /home/darkstar/trees/bpf/samples/bpf/../../tools/lib/bpf/ RM='rm -rf' LDFLAGS= srctree=/home/darkstar/trees/bpf/samples/bpf/../../ O=
> > >   HOSTCC  /home/darkstar/trees/bpf/samples/bpf/test_lru_dist
> > >   HOSTCC  /home/darkstar/trees/bpf/samples/bpf/sock_example
> > >
> >
> > Hi all,
> >
> > I have kernel-headers installed from master, but yet the samples fail to build:
> >
> > matteo@turbo:~/src/linux/samples/bpf$ rpm -q kernel-headers
> > kernel-headers-5.2.0_rc1-38.x86_64
> >
> > matteo@turbo:~/src/linux/samples/bpf$ git describe HEAD
> > v5.2-rc1-97-g5bdd9ad875b6
> >
> > matteo@turbo:~/src/linux/samples/bpf$ make
> > make -C ../../ /home/matteo/src/linux/samples/bpf/
> > BPF_SAMPLES_PATH=/home/matteo/src/linux/samples/bpf
> > make[1]: Entering directory '/home/matteo/src/linux'
> >   CALL    scripts/checksyscalls.sh
> >   CALL    scripts/atomic/check-atomics.sh
> >   DESCEND  objtool
> > make -C /home/matteo/src/linux/samples/bpf/../../tools/lib/bpf/ RM='rm
> > -rf' LDFLAGS= srctree=/home/matteo/src/linux/samples/bpf/../../ O=
> >   HOSTCC  /home/matteo/src/linux/samples/bpf/test_lru_dist
> > /home/matteo/src/linux/samples/bpf/test_lru_dist.c:39:8: error:
> > redefinition of ‘struct list_head’
> >    39 | struct list_head {
> >       |        ^~~~~~~~~
> > In file included from /home/matteo/src/linux/samples/bpf/test_lru_dist.c:9:
> > ./tools/include/linux/types.h:69:8: note: originally defined here
> >    69 | struct list_head {
> >       |        ^~~~~~~~~
> > make[2]: *** [scripts/Makefile.host:90:
> > /home/matteo/src/linux/samples/bpf/test_lru_dist] Error 1
> > make[1]: *** [Makefile:1762: /home/matteo/src/linux/samples/bpf/] Error 2
> > make[1]: Leaving directory '/home/matteo/src/linux'
> > make: *** [Makefile:231: all] Error 2
> >
> > Am I missing something obvious?
>
> Yes ;)  Samples use a local installation of headers in $objtree/usr (I
> think, maybe $srctree/usr).  So you need to do make headers_install in
> your kernel source tree, otherwise the include path from tools/ takes
> priority over your global /usr/include and causes these issues.  I had
> this path in my tree for some time, but I don't like enough to post it:
>
> commit 35fb614049e93d46af708c0eaae6601df54017b3
> Author: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date:   Mon Dec 3 15:00:24 2018 -0800
>
>     bpf: maybe warn ppl about hrds_install
>
>     Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 4f0a1cdbfe7c..f79a4ed2f9f7 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -208,6 +208,15 @@ HOSTCC = $(CROSS_COMPILE)gcc
>  CLANG_ARCH_ARGS = -target $(ARCH)
>  endif
>
> +HDR_PROBE := $(shell echo "\#include <linux/types.h>\n struct list_head { int a; }; int main() { return 0; }" | \
> +       gcc $(KBUILD_HOSTCFLAGS) -x c - -o /dev/null 2>/dev/null && \
> +       echo okay)
> +
> +ifeq ($(HDR_PROBE),)
> +$(warning Detected possible issues with include path.)
> +$(warning Please install kernel headers locally (make headers_install))
> +endif
> +
>  BTF_LLC_PROBE := $(shell $(LLC) -march=bpf -mattr=help 2>&1 | grep dwarfris)
>  BTF_PAHOLE_PROBE := $(shell $(BTF_PAHOLE) --help 2>&1 | grep BTF)
>  BTF_OBJCOPY_PROBE := $(shell $(LLVM_OBJCOPY) --help 2>&1 | grep -i 'usage.*llvm')

Hi Jakub,

I see now, It worked, thanks. This is a bit error prone IMHO, if you
ever think about sending this patch, consider it ACKed by me.

Thanks,
-- 
Matteo Croce
per aspera ad upstream
