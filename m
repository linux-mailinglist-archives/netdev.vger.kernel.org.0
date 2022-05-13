Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915BD526D5D
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 01:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiEMXMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 19:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiEMXMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 19:12:24 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B035E2F53E1;
        Fri, 13 May 2022 16:11:48 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id j12so6693160ila.12;
        Fri, 13 May 2022 16:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GB3v5lFMCvPFMWT8NWKxn8RsnMUsp5oSififqQTuXXk=;
        b=H6KWYm5KBR4dGHbL1x8u7Dh41eAdwEdG7poy+v1+0V/N2/9Ac+5hSqomHSLiaahFJA
         V/AMIPuWiUCuQKoh84xPcRf82UMH1YU/Cq0zflyUpgeLqZ5SHEcS4YTbHJ9Z3hgRIcsS
         nW7gtiMFu+nwN5sDijJ43w4k1jme2o9cFTuU0WZ496rtZjMeqN2lo5MiUcJuAkFw9i+L
         oEvnxznxa3R/fPuhvBZKOHMZ/BrPI1AtqHYubvvBKmqNV7flkc4e6RYffDVYgzPEybCa
         RdsWoNGuS70a1pqukQ6gdDUP29lICDE+hJTrAAHk916pGj6rGRDor6gJ6e8y4zzfGuzp
         eA6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GB3v5lFMCvPFMWT8NWKxn8RsnMUsp5oSififqQTuXXk=;
        b=BBxcHZPxqqsQy6ymPCiGxFVz3URNEiOXemTFDb3THx+n4cigyDlWGkWedYPhhRhjXd
         y+TbjZX0ysa7ZQSlx9qM6/liNKW6HQcNsfGFbuF7X7HtAGZqcBMk1cY0l2/FIatt4OEi
         zh5UBySal3VLN/X7mpqHSMXrJV7PotYXHrx/RRKDtEZDzIf/3WTHKZthFnw1QwILQzSV
         WuMNvd3tUm00JzKITv7LbvsIML8hAKfrTQG5LWYaNuT+gllGezTd5Cj3fKLvJVGZWB4X
         1Y4mgtzyyFv7xwrvSc6NaqON7shLrVz720I6JdGDPlo/YtVoI8d75c8JYogiRUj+8HiQ
         RorQ==
X-Gm-Message-State: AOAM532RumNNh6MbiIKreQq2NMfj9foNe1kXGQhXiSnL2dtz+PzjuFIa
        4mdFF2vMb6Vs5kEh0PeBNOp399hQi9i1bmSXSr0=
X-Google-Smtp-Source: ABdhPJzKpLo+U9J7KPV1JSuKEGcqUmZDD825loa+/h5MypYGwia5CSNx15HCVaiZBwUvm0cCghIN2C15oiyUwD+RVNk=
X-Received: by 2002:a92:d250:0:b0:2d0:f240:d5f5 with SMTP id
 v16-20020a92d250000000b002d0f240d5f5mr3306839ilg.252.1652483507889; Fri, 13
 May 2022 16:11:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220513004117.364577-1-yosryahmed@google.com>
 <CAEf4BzYiuBaCBcF6T9JRJ=fB=PWtDb9p-5CJAi164F4_h5fQPw@mail.gmail.com> <CAJD7tkaxHKUrb44-J5Zxm6x1KH-XnPVXDgZyu4+Rc094D7MEhA@mail.gmail.com>
In-Reply-To: <CAJD7tkaxHKUrb44-J5Zxm6x1KH-XnPVXDgZyu4+Rc094D7MEhA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 May 2022 16:11:37 -0700
Message-ID: <CAEf4BzZcCfTW7NnoH5CY8GVZv44SVwue+nQaEgyO1HO0YmGrWQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix building bpf selftests statically
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

On Fri, May 13, 2022 at 4:05 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> On Fri, May 13, 2022 at 3:57 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, May 12, 2022 at 5:41 PM Yosry Ahmed <yosryahmed@google.com> wrote:
> > >
> > > bpf selftests can no longer be built with CFLAGS=-static with
> > > liburandom_read.so and its dependent target.
> > >
> > > Filter out -static for liburandom_read.so and its dependent target.
> > >
> > > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > > ---
> > >  tools/testing/selftests/bpf/Makefile | 9 ++++++---
> > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > > index 6bbc03161544..4eaefc187d5b 100644
> > > --- a/tools/testing/selftests/bpf/Makefile
> > > +++ b/tools/testing/selftests/bpf/Makefile
> > > @@ -168,14 +168,17 @@ $(OUTPUT)/%:%.c
> > >         $(call msg,BINARY,,$@)
> > >         $(Q)$(LINK.c) $^ $(LDLIBS) -o $@
> > >
> > > +# If the tests are being built statically, exclude dynamic libraries defined
> > > +# in this Makefile and their dependencies.
> > > +DYNAMIC_CFLAGS := $(filter-out -static,$(CFLAGS))
> >
> > I don't particularly like yet another CFLAGS global variable, but also
> > you are not filtering out -static from LDFLAGS, which would be
> > problematic if you try to do
> >
> > make SAN_FLAGS=-static
> >
> > which otherwise would work (and is probably better than overriding all of CFLAGS
> >
> > How about something like this
>
> Yeah this looks good, thanks for pointing out the problem with LDFLAGS.

ok, cool, please incorporate into v2 then

>
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile
> > b/tools/testing/selftests/bpf/Makefile
> > index 6bbc03161544..2e8eddf240af 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -170,11 +170,11 @@ $(OUTPUT)/%:%.c
> >
> >  $(OUTPUT)/liburandom_read.so: urandom_read_lib1.c urandom_read_lib2.c
> >         $(call msg,LIB,,$@)
> > -       $(Q)$(CC) $(CFLAGS) -fPIC $(LDFLAGS) $^ $(LDLIBS) --shared -o $@
> > +       $(Q)$(CC) $(filter-out -static,$(CFLAGS) $(LDFLAGS)) $^
> > $(LDLIBS) -fPIC -shared -o $@
> >
> >  $(OUTPUT)/urandom_read: urandom_read.c urandom_read_aux.c
> > $(OUTPUT)/liburandom_read.so
> >         $(call msg,BINARY,,$@)
> > -       $(Q)$(CC) $(CFLAGS) $(LDFLAGS) $(filter %.c,$^)                        \
> > +       $(Q)$(CC) $(filter-out -static,$(CFLAGS) $(LDFLAGS)) $(filter %.c,$^)  \
> >                   liburandom_read.so $(LDLIBS)                                 \
> >                   -Wl,-rpath=. -Wl,--build-id=sha1 -o $@
> >
> > ?
> >
> >
> > But I also have a question, this leaves urandom_read relying on
> > system-wide shared libraries, isn't that still a problem for you? Or
> > you intend to just ignore urandom_read-related tests?
> >
>
> I wasn't running those tests, and I thought having most tests compile
> statically is better than nothing. Maybe this can be fixed by defining
> a static target for liburandom_read? I am honestly not sure, I have
> little experience with Makefiles/compilation.

usdt selftest explicitly tests working with shared libraries, so we
have to keep liburandom_read.so as a shared library. But yes, at least
you can skip the test at runtime.

>
> >
> > $ ldd urandom_read
> >         linux-vdso.so.1 (0x00007ffd0d5e5000)
> >         liburandom_read.so (0x00007fc7f7d76000)
> >         libelf.so.1 => /lib64/libelf.so.1 (0x00007fc7f7937000)
> >         libz.so.1 => /lib64/libz.so.1 (0x00007fc7f7720000)
> >         librt.so.1 => /lib64/librt.so.1 (0x00007fc7f7518000)
> >         libpthread.so.0 => /lib64/libpthread.so.0 (0x00007fc7f72f8000)
> >         libc.so.6 => /lib64/libc.so.6 (0x00007fc7f6f33000)
> >         /lib64/ld-linux-x86-64.so.2 (0x00007fc7f7b50000)
> >
> >
> >
> >
> > >  $(OUTPUT)/liburandom_read.so: urandom_read_lib1.c urandom_read_lib2.c
> > >         $(call msg,LIB,,$@)
> > > -       $(Q)$(CC) $(CFLAGS) -fPIC $(LDFLAGS) $^ $(LDLIBS) --shared -o $@
> > > +       $(Q)$(CC) $(DYNAMIC_CFLAGS) -fPIC $(LDFLAGS) $^ $(LDLIBS) --shared -o $@
> > >
> > >  $(OUTPUT)/urandom_read: urandom_read.c urandom_read_aux.c $(OUTPUT)/liburandom_read.so
> > >         $(call msg,BINARY,,$@)
> > > -       $(Q)$(CC) $(CFLAGS) $(LDFLAGS) $(filter %.c,$^)                        \
> > > -                 liburandom_read.so $(LDLIBS)                                 \
> > > +       $(Q)$(CC) $(DYNAMIC_CFLAGS) $(LDFLAGS) $(filter %.c,$^)                 \
> > > +                 liburandom_read.so $(LDLIBS)                                  \
> > >                   -Wl,-rpath=. -Wl,--build-id=sha1 -o $@
> > >
> > >  $(OUTPUT)/bpf_testmod.ko: $(VMLINUX_BTF) $(wildcard bpf_testmod/Makefile bpf_testmod/*.[ch])
> > > --
> > > 2.36.0.550.gb090851708-goog
> > >
