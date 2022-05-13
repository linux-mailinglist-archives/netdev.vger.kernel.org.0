Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30CC0526D54
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 01:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238009AbiEMXGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 19:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233399AbiEMXF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 19:05:58 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB09A2550B1
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 16:05:41 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id bd25-20020a05600c1f1900b0039485220e16so6006462wmb.0
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 16:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mivRpjYlnos8QyfKIL0ZlkiTUotRjXBDBCX8TH+HQXY=;
        b=UdpAoUQiU4hPu5EZSLJ8meLqynbM8mfTp+3iZ4wqmp60lDxYlq+Dcw1+Ai9ZPbh8ZX
         U/Aq0aRqY/wfdxyeVYaddvYyhr6KOlKipGwchEWqzXXtwH+V1D/bwmimJaudRW74KvYi
         n7BcZtD0heaYjzouHmBVcq80K1BhxMVLRbJJK2vSosuf5Ngif2YKfjFcT51VRnKgunBb
         erAORUPdaJGYpkIL2cxy+KFLpeguRkmjCXl0VzUbty3RILRMx4FyPrKpl9iLwzRuXPaG
         9alDHlC1KCZiMq7cx4G0Fojxg9XUTGxfcwoe93D6yJxceY2giRQBLPsIKFOVfUy+0kB4
         ox2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mivRpjYlnos8QyfKIL0ZlkiTUotRjXBDBCX8TH+HQXY=;
        b=vJ4j/qOWG0QWFxlk9Cc3aFMkiCX5uZ/hfHmRGJp3PeZatZt7txbrHMHAvfIxBSPsW8
         Xki40F4ok9A0kWQ/lDojcy9vM6ovplvblaO2uMioMPMzv0K4/dsOQuzcFS0eMHcP+Ctz
         WqbZK0f7a2bpxWB+oTlDMbO1mLY058AuxlIrwG4gxYPt36jzZOuTNLsaSok/zx73tvbl
         0lVXZuPhBOuBjotDS2KwFDj/t3V39kwluBdl/nBRW/tEVdqwQVV8oPPOtVRTlWhwR6/y
         2vDMColROLbOvOEkuSrWpu1t4R7eaxcwQeiOASIMM/J5E/iPbxoCv87r8z7o+Y4ol/E2
         WAXw==
X-Gm-Message-State: AOAM530wp1ou8KrhX3Y4Ly+jvkwxHmDpawU8rMVFsVaIHQJXQuNPFViR
        DvvQjRstXWUrRHAC5iNfOHVbvg1dcfUnsZ9XEaEnbg==
X-Google-Smtp-Source: ABdhPJzikMn1ioZfFD/3RZTSrR9mKVOzqPyMJYhF22HzLQV38UOOS2ThlqrYZYhQ/gQg474rfsrRF934XUb40E0b8gU=
X-Received: by 2002:a05:600c:4ecc:b0:394:790d:5f69 with SMTP id
 g12-20020a05600c4ecc00b00394790d5f69mr6625363wmq.196.1652483139965; Fri, 13
 May 2022 16:05:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220513004117.364577-1-yosryahmed@google.com> <CAEf4BzYiuBaCBcF6T9JRJ=fB=PWtDb9p-5CJAi164F4_h5fQPw@mail.gmail.com>
In-Reply-To: <CAEf4BzYiuBaCBcF6T9JRJ=fB=PWtDb9p-5CJAi164F4_h5fQPw@mail.gmail.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Fri, 13 May 2022 16:05:03 -0700
Message-ID: <CAJD7tkaxHKUrb44-J5Zxm6x1KH-XnPVXDgZyu4+Rc094D7MEhA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix building bpf selftests statically
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 3:57 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, May 12, 2022 at 5:41 PM Yosry Ahmed <yosryahmed@google.com> wrote:
> >
> > bpf selftests can no longer be built with CFLAGS=-static with
> > liburandom_read.so and its dependent target.
> >
> > Filter out -static for liburandom_read.so and its dependent target.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >  tools/testing/selftests/bpf/Makefile | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 6bbc03161544..4eaefc187d5b 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -168,14 +168,17 @@ $(OUTPUT)/%:%.c
> >         $(call msg,BINARY,,$@)
> >         $(Q)$(LINK.c) $^ $(LDLIBS) -o $@
> >
> > +# If the tests are being built statically, exclude dynamic libraries defined
> > +# in this Makefile and their dependencies.
> > +DYNAMIC_CFLAGS := $(filter-out -static,$(CFLAGS))
>
> I don't particularly like yet another CFLAGS global variable, but also
> you are not filtering out -static from LDFLAGS, which would be
> problematic if you try to do
>
> make SAN_FLAGS=-static
>
> which otherwise would work (and is probably better than overriding all of CFLAGS
>
> How about something like this

Yeah this looks good, thanks for pointing out the problem with LDFLAGS.

>
> diff --git a/tools/testing/selftests/bpf/Makefile
> b/tools/testing/selftests/bpf/Makefile
> index 6bbc03161544..2e8eddf240af 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -170,11 +170,11 @@ $(OUTPUT)/%:%.c
>
>  $(OUTPUT)/liburandom_read.so: urandom_read_lib1.c urandom_read_lib2.c
>         $(call msg,LIB,,$@)
> -       $(Q)$(CC) $(CFLAGS) -fPIC $(LDFLAGS) $^ $(LDLIBS) --shared -o $@
> +       $(Q)$(CC) $(filter-out -static,$(CFLAGS) $(LDFLAGS)) $^
> $(LDLIBS) -fPIC -shared -o $@
>
>  $(OUTPUT)/urandom_read: urandom_read.c urandom_read_aux.c
> $(OUTPUT)/liburandom_read.so
>         $(call msg,BINARY,,$@)
> -       $(Q)$(CC) $(CFLAGS) $(LDFLAGS) $(filter %.c,$^)                        \
> +       $(Q)$(CC) $(filter-out -static,$(CFLAGS) $(LDFLAGS)) $(filter %.c,$^)  \
>                   liburandom_read.so $(LDLIBS)                                 \
>                   -Wl,-rpath=. -Wl,--build-id=sha1 -o $@
>
> ?
>
>
> But I also have a question, this leaves urandom_read relying on
> system-wide shared libraries, isn't that still a problem for you? Or
> you intend to just ignore urandom_read-related tests?
>

I wasn't running those tests, and I thought having most tests compile
statically is better than nothing. Maybe this can be fixed by defining
a static target for liburandom_read? I am honestly not sure, I have
little experience with Makefiles/compilation.

>
> $ ldd urandom_read
>         linux-vdso.so.1 (0x00007ffd0d5e5000)
>         liburandom_read.so (0x00007fc7f7d76000)
>         libelf.so.1 => /lib64/libelf.so.1 (0x00007fc7f7937000)
>         libz.so.1 => /lib64/libz.so.1 (0x00007fc7f7720000)
>         librt.so.1 => /lib64/librt.so.1 (0x00007fc7f7518000)
>         libpthread.so.0 => /lib64/libpthread.so.0 (0x00007fc7f72f8000)
>         libc.so.6 => /lib64/libc.so.6 (0x00007fc7f6f33000)
>         /lib64/ld-linux-x86-64.so.2 (0x00007fc7f7b50000)
>
>
>
>
> >  $(OUTPUT)/liburandom_read.so: urandom_read_lib1.c urandom_read_lib2.c
> >         $(call msg,LIB,,$@)
> > -       $(Q)$(CC) $(CFLAGS) -fPIC $(LDFLAGS) $^ $(LDLIBS) --shared -o $@
> > +       $(Q)$(CC) $(DYNAMIC_CFLAGS) -fPIC $(LDFLAGS) $^ $(LDLIBS) --shared -o $@
> >
> >  $(OUTPUT)/urandom_read: urandom_read.c urandom_read_aux.c $(OUTPUT)/liburandom_read.so
> >         $(call msg,BINARY,,$@)
> > -       $(Q)$(CC) $(CFLAGS) $(LDFLAGS) $(filter %.c,$^)                        \
> > -                 liburandom_read.so $(LDLIBS)                                 \
> > +       $(Q)$(CC) $(DYNAMIC_CFLAGS) $(LDFLAGS) $(filter %.c,$^)                 \
> > +                 liburandom_read.so $(LDLIBS)                                  \
> >                   -Wl,-rpath=. -Wl,--build-id=sha1 -o $@
> >
> >  $(OUTPUT)/bpf_testmod.ko: $(VMLINUX_BTF) $(wildcard bpf_testmod/Makefile bpf_testmod/*.[ch])
> > --
> > 2.36.0.550.gb090851708-goog
> >
