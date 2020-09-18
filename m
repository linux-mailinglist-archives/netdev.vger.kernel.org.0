Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CFF27045F
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 20:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgIRSuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 14:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgIRSuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 14:50:12 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF8FC0613CE;
        Fri, 18 Sep 2020 11:50:12 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id g96so4999978ybi.12;
        Fri, 18 Sep 2020 11:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hqvHrh3o7jsEIYCRdIqyTmHwMSYgGKNVHC9p9LOXhxw=;
        b=DHO41exICjvGwAxxgbDYlzJnlKcZj15vuplT8+Ds/C6Zsm+MoNytObL5d+kXL6YYQ6
         73mS3t3sDYJn28DFoiYcp4OUQVhx7B2NdSnbpE6AoYr1qHwV1M3aJQhLLDb6aiJN/wao
         SpoigZSAfRpIHfrWuqqsZUHPKm48I0I5Xo4B3S6m3ImEwQuzuG8FlvcsrcybYeX4bmFF
         joNvS9XfxS1OB85qYm12cIwa8DEzupjF07wqbIHW7UIF/4RdH9fizf5/+hX+BJ+GF4lo
         wGKDZeQYQV8KdOo7im58v4Q24OQuvoKAZem0MXFKfmFlz8JtBHdl9ZYVApMUYYQN6HKp
         77Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hqvHrh3o7jsEIYCRdIqyTmHwMSYgGKNVHC9p9LOXhxw=;
        b=rqok6WJNhkifpqAMOGisf8ovV1lijfD1b0hhuFRyTAPkH+mmoXfUpSJCscO5+jPJck
         pJn88Tqw9Khjy+J67tXyPNYJIgXexYdPVYxfyydJYfkVsrCif6tmqvCTCr75I0BeR05j
         g8r5SztST969rOb914u1OwyCdtrWlcUJd580Y8C5KgUGVAHXEiGzLS7zo7uJQNYHf30f
         6YCEcp+jc5rXCQUQ7/CE6t86Bm5jAQHIPHNBFAAfEVXPypuoazT5HhTxG0J9j1/fjDM/
         4/lvgny/o0S7xZ0AeNq1ZaytQ7N4nKPImO53frKxLr8SbV8/t7hZsnDOANaG59MubW2h
         O+aw==
X-Gm-Message-State: AOAM533hHXxTT7qlVOi33zszK1lccLXYJ9Ka3IFLKJY/b91EiqcoAUtW
        2QYvWytu+b0rnGdR/XRgXIbFPDrfLH75gfS+mDM=
X-Google-Smtp-Source: ABdhPJyOocoh51I0ATOSNT+p7C2IV0G8EA0W32YmITZyk+4NJTlyniC7h6zcLTYEovP7TKzk4dvn5ydKFv2dFmV7l4Y=
X-Received: by 2002:a25:6644:: with SMTP id z4mr21000090ybm.347.1600455011405;
 Fri, 18 Sep 2020 11:50:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200916194733.GA4820@ubuntu-x1> <20200917080452.GB2411168@krava>
 <20200917083809.GE2411168@krava> <20200917091406.GF2411168@krava>
 <20200917125450.GC4820@ubuntu-x1> <20200918100542.GD2514666@krava>
In-Reply-To: <20200918100542.GD2514666@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 18 Sep 2020 11:50:00 -0700
Message-ID: <CAEf4BzZY5ReVYDRJq2kRGjH9Q9_H-LWWyo2WfWSbgGzr=QZ_Uw@mail.gmail.com>
Subject: Re: resolve_btfids breaks kernel cross-compilation
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Seth Forshee <seth.forshee@canonical.com>,
        Andrii Nakryiko <andriin@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 3:07 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Sep 17, 2020 at 07:54:50AM -0500, Seth Forshee wrote:
> > On Thu, Sep 17, 2020 at 11:14:06AM +0200, Jiri Olsa wrote:
> > > On Thu, Sep 17, 2020 at 10:38:12AM +0200, Jiri Olsa wrote:
> > > > On Thu, Sep 17, 2020 at 10:04:55AM +0200, Jiri Olsa wrote:
> > > > > On Wed, Sep 16, 2020 at 02:47:33PM -0500, Seth Forshee wrote:
> > > > > > The requirement to build resolve_btfids whenever CONFIG_DEBUG_INFO_BTF
> > > > > > is enabled breaks some cross builds. For example, when building a 64-bit
> > > > > > powerpc kernel on amd64 I get:
> > > > > >
> > > > > >  Auto-detecting system features:
> > > > > >  ...                        libelf: [ [32mon[m  ]
> > > > > >  ...                          zlib: [ [32mon[m  ]
> > > > > >  ...                           bpf: [ [31mOFF[m ]
> > > > > >
> > > > > >  BPF API too old
> > > > > >  make[6]: *** [Makefile:295: bpfdep] Error 1
> > > > > >
> > > > > > The contents of tools/bpf/resolve_btfids/feature/test-bpf.make.output:
> > > > > >
> > > > > >  In file included from /home/sforshee/src/u-k/unstable/tools/arch/powerpc/include/uapi/asm/bitsperlong.h:11,
> > > > > >                   from /usr/include/asm-generic/int-ll64.h:12,
> > > > > >                   from /usr/include/asm-generic/types.h:7,
> > > > > >                   from /usr/include/x86_64-linux-gnu/asm/types.h:1,
> > > > > >                   from /home/sforshee/src/u-k/unstable/tools/include/linux/types.h:10,
> > > > > >                   from /home/sforshee/src/u-k/unstable/tools/include/uapi/linux/bpf.h:11,
> > > > > >                   from test-bpf.c:3:
> > > > > >  /home/sforshee/src/u-k/unstable/tools/include/asm-generic/bitsperlong.h:14:2: error: #error Inconsistent word size. Check asm/bitsperlong.h
> > > > > >     14 | #error Inconsistent word size. Check asm/bitsperlong.h
> > > > > >        |  ^~~~~
> > > > > >
> > > > > > This is because tools/arch/powerpc/include/uapi/asm/bitsperlong.h sets
> > > > > > __BITS_PER_LONG based on the predefinied compiler macro __powerpc64__,
> > > > > > which is not defined by the host compiler. What can we do to get cross
> > > > > > builds working again?
> > > > >
> > > > > could you please share the command line and setup?
> > > >
> > > > I just reproduced.. checking on fix
> > >
> > > I still need to check on few things, but patch below should help
> >
> > It does help with the word size problem, thanks.
> >
> > > we might have a problem for cross builds with different endianity
> > > than the host because libbpf does not support reading BTF data
> > > with different endianity, and we get:
> > >
> > >   BTFIDS  vmlinux
> > > libbpf: non-native ELF endianness is not supported
> >
> > Yes, I see this now when cross building for s390.
>
> Andrii,
> I read you might be already working on this?
>   https://lore.kernel.org/bpf/CAEf4Bza9tZ-Jj0dj9Ne0fmxa95t=9XxxJR+Ce=6hDmw_d8uVFA@mail.gmail.com/
>

Yes, it's one of the limitations I'm solving, stay tuned.


> thanks,
> jirka
>
> >
> > Thanks,
> > Seth
> >
> > >
> > > jirka
> > >
> > >
> > > ---
> > > diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
> > > index a88cd4426398..d3c818b8d8d3 100644
> > > --- a/tools/bpf/resolve_btfids/Makefile
> > > +++ b/tools/bpf/resolve_btfids/Makefile
> > > @@ -1,5 +1,6 @@
> > >  # SPDX-License-Identifier: GPL-2.0-only
> > >  include ../../scripts/Makefile.include
> > > +include ../../scripts/Makefile.arch
> > >
> > >  ifeq ($(srctree),)
> > >  srctree := $(patsubst %/,%,$(dir $(CURDIR)))
> > > @@ -29,6 +30,7 @@ endif
> > >  AR       = $(HOSTAR)
> > >  CC       = $(HOSTCC)
> > >  LD       = $(HOSTLD)
> > > +ARCH     = $(HOSTARCH)
> > >
> > >  OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
> > >
> > >
> >
>
