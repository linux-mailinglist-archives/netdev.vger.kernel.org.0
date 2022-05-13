Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBEBA526D36
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 00:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381607AbiEMW56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 18:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244418AbiEMW55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 18:57:57 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297AE17E3F;
        Fri, 13 May 2022 15:57:56 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id a10so10243159ioe.9;
        Fri, 13 May 2022 15:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5qaVyZvzGf9D9TR/BSQ+mQsaNY1sb+JjxbLPRurfSus=;
        b=YHuYmeoAoE/7wiR96FKUJtLMpKbEH1Q10Gwb/VRld1GHa8ix+eu+vAdUdlnftwTjJQ
         6XAU58Q4V/LE77PzJjsounf/xpYRZ6cAyXbxzmW5qtqct36AyhupilJzuPfiKi11UlXV
         /0GcNMIwPrw8PaGMMefuqeFL3QNgi5lCRbCRohKrsut50acQVrAgpe5Hz53hAt0NYlqy
         yXLfEDfTrGnClKF40KnzTqg3+jQz2wRwdEM5DCTNQ5LRLHiRNr8rJ8Be4QubMj97FrkD
         602VdmJ7qcKE8FyMymTqI1DW8oFz8CHif3xLVYDEz+mdDAz22fvRd5oa+jdRQ8a8r3eW
         apVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5qaVyZvzGf9D9TR/BSQ+mQsaNY1sb+JjxbLPRurfSus=;
        b=tQxR6/O1pvWCn9nkRVvG/nH9a0k1fuDvrCTeeXStYimiQZBwoqJbv9KL45dvrSkC3K
         xtx2kMbF21XJLUxak1O+EzfKpSkdmHDa68J67GeQVQK03d41msLKnK3wsc6//2glkzj0
         GI/Ta2JcnroObc+h1lpf21Zn8qvoYEOm4pn9zCWJKRGjDEVoasS2rz1Pv2AOFBQ0F8DE
         p/gXluqC1R/WuVJWgi2VQmDoZI/8SXVhRyaToUeIPrLxwdlSJH12wwvlKfTQ8GmZbD+6
         azCe82nFXUJwOl10yrhGtTeWI4Wn8+li2TdTeNWjpmPQ7T+mEurqPr/t6flx/Xhsvdru
         lMTg==
X-Gm-Message-State: AOAM532/GE6sY4TLXcHlB5JWC5zET4Zro8kR3O91HSpAfJK8MoH+74kN
        vHokwmv5e8gCDZAzZ9Ze2RoCN62mPUQglH8OJBE=
X-Google-Smtp-Source: ABdhPJyLI8hRmZa7wP8SIkRPRLnLX8rsCNNKr1bmq9F7Ax+IEIYKV/BkguJMrrAClsZASZEQlw27i2dQ8WiL421/9lM=
X-Received: by 2002:a05:6638:533:b0:32a:d418:b77b with SMTP id
 j19-20020a056638053300b0032ad418b77bmr3731100jar.237.1652482675539; Fri, 13
 May 2022 15:57:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220513004117.364577-1-yosryahmed@google.com>
In-Reply-To: <20220513004117.364577-1-yosryahmed@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 May 2022 15:57:44 -0700
Message-ID: <CAEf4BzYiuBaCBcF6T9JRJ=fB=PWtDb9p-5CJAi164F4_h5fQPw@mail.gmail.com>
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

On Thu, May 12, 2022 at 5:41 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> bpf selftests can no longer be built with CFLAGS=-static with
> liburandom_read.so and its dependent target.
>
> Filter out -static for liburandom_read.so and its dependent target.
>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  tools/testing/selftests/bpf/Makefile | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 6bbc03161544..4eaefc187d5b 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -168,14 +168,17 @@ $(OUTPUT)/%:%.c
>         $(call msg,BINARY,,$@)
>         $(Q)$(LINK.c) $^ $(LDLIBS) -o $@
>
> +# If the tests are being built statically, exclude dynamic libraries defined
> +# in this Makefile and their dependencies.
> +DYNAMIC_CFLAGS := $(filter-out -static,$(CFLAGS))

I don't particularly like yet another CFLAGS global variable, but also
you are not filtering out -static from LDFLAGS, which would be
problematic if you try to do

make SAN_FLAGS=-static

which otherwise would work (and is probably better than overriding all of CFLAGS

How about something like this

diff --git a/tools/testing/selftests/bpf/Makefile
b/tools/testing/selftests/bpf/Makefile
index 6bbc03161544..2e8eddf240af 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -170,11 +170,11 @@ $(OUTPUT)/%:%.c

 $(OUTPUT)/liburandom_read.so: urandom_read_lib1.c urandom_read_lib2.c
        $(call msg,LIB,,$@)
-       $(Q)$(CC) $(CFLAGS) -fPIC $(LDFLAGS) $^ $(LDLIBS) --shared -o $@
+       $(Q)$(CC) $(filter-out -static,$(CFLAGS) $(LDFLAGS)) $^
$(LDLIBS) -fPIC -shared -o $@

 $(OUTPUT)/urandom_read: urandom_read.c urandom_read_aux.c
$(OUTPUT)/liburandom_read.so
        $(call msg,BINARY,,$@)
-       $(Q)$(CC) $(CFLAGS) $(LDFLAGS) $(filter %.c,$^)                        \
+       $(Q)$(CC) $(filter-out -static,$(CFLAGS) $(LDFLAGS)) $(filter %.c,$^)  \
                  liburandom_read.so $(LDLIBS)                                 \
                  -Wl,-rpath=. -Wl,--build-id=sha1 -o $@

?


But I also have a question, this leaves urandom_read relying on
system-wide shared libraries, isn't that still a problem for you? Or
you intend to just ignore urandom_read-related tests?


$ ldd urandom_read
        linux-vdso.so.1 (0x00007ffd0d5e5000)
        liburandom_read.so (0x00007fc7f7d76000)
        libelf.so.1 => /lib64/libelf.so.1 (0x00007fc7f7937000)
        libz.so.1 => /lib64/libz.so.1 (0x00007fc7f7720000)
        librt.so.1 => /lib64/librt.so.1 (0x00007fc7f7518000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x00007fc7f72f8000)
        libc.so.6 => /lib64/libc.so.6 (0x00007fc7f6f33000)
        /lib64/ld-linux-x86-64.so.2 (0x00007fc7f7b50000)




>  $(OUTPUT)/liburandom_read.so: urandom_read_lib1.c urandom_read_lib2.c
>         $(call msg,LIB,,$@)
> -       $(Q)$(CC) $(CFLAGS) -fPIC $(LDFLAGS) $^ $(LDLIBS) --shared -o $@
> +       $(Q)$(CC) $(DYNAMIC_CFLAGS) -fPIC $(LDFLAGS) $^ $(LDLIBS) --shared -o $@
>
>  $(OUTPUT)/urandom_read: urandom_read.c urandom_read_aux.c $(OUTPUT)/liburandom_read.so
>         $(call msg,BINARY,,$@)
> -       $(Q)$(CC) $(CFLAGS) $(LDFLAGS) $(filter %.c,$^)                        \
> -                 liburandom_read.so $(LDLIBS)                                 \
> +       $(Q)$(CC) $(DYNAMIC_CFLAGS) $(LDFLAGS) $(filter %.c,$^)                 \
> +                 liburandom_read.so $(LDLIBS)                                  \
>                   -Wl,-rpath=. -Wl,--build-id=sha1 -o $@
>
>  $(OUTPUT)/bpf_testmod.ko: $(VMLINUX_BTF) $(wildcard bpf_testmod/Makefile bpf_testmod/*.[ch])
> --
> 2.36.0.550.gb090851708-goog
>
