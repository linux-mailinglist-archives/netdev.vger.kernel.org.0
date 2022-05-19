Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F11F52C9E7
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 04:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbiESCou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 22:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiESCos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 22:44:48 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB22AFB33;
        Wed, 18 May 2022 19:44:47 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id k16so3900492pff.5;
        Wed, 18 May 2022 19:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/OdaK4ohDQWqt/u7hVRffmm7/7Ucw/KXwt4ikkI4/7M=;
        b=kxvYx/iDZ1TiQYeWNrQ2lyRRSORv2anenTiDo9Q8GytcjjWGAq1yLqeGsHVK+BSede
         Wmy085ncnEgG/XqJKS/6losOXuLgWLe+V9l5c6l6aldcei7oeECFPyM090Z5QoWBCNgz
         WfNFl4QBWQ8GOgGOlSD85fYwPlaWdEwDpI1ImElZGvgg7BbyDxZtUbYMK4EWS8Q8WxNU
         gcPuSZv6STJOB61pWg+5KU+ciMnhbFBoW0rWCaTImNUFM3GyQn78645i/tB/hv5fMMlC
         XdHJSS19HrGgAyKFuXUrA7yumP3MTexBLbHpGw42O2a03odn4lZn9toXyalQbhyyPFWo
         OvAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/OdaK4ohDQWqt/u7hVRffmm7/7Ucw/KXwt4ikkI4/7M=;
        b=468JedPeuG1xvFaU5CrEGDOV+L1wiiVM/3UHPTszB1zlzE3lfrylRg/EdMrygN5GuY
         7EFZ3CyLmhlwEpKSq4jkYvHzGYdwtBsf8OEQZeHM2RrNEr6xeuouNwjPptJC5qR2tvfL
         YGksE16BFKy8ewksDjXj1d5YnqLz/9w0ZQCEbD3da265o/MOuahz8EyaZ2CRQ/JP0wlI
         ryQLaczlPKYEUYrYQs0CYa3iwwcZvEsIlU0L1A6Gk3EO2XcbH0dnts5eA+AGbl7cCxhn
         R/tRTwc1mDAFlm/CEb8tERZ3x3JtP+bd46c9eicAbnjKURx4dsxF2GbPI1lCcM+0puoy
         yL/A==
X-Gm-Message-State: AOAM532o3gzddeb4/1a82Ndwkyf9BCKEX1nvk930SABlq5NYRov46ZxH
        h3dtB9Dy0EF2BxaYvdqFQ5U=
X-Google-Smtp-Source: ABdhPJwjnOi2OGUAujBkLN7r/sI9LF4LR9+vlMA+A5qsDmy5xL5qE0jjToo8eBwgcjJ1aFS8BHmvrQ==
X-Received: by 2002:a05:6a00:1c76:b0:510:8b76:93b5 with SMTP id s54-20020a056a001c7600b005108b7693b5mr2649421pfw.44.1652928287402;
        Wed, 18 May 2022 19:44:47 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q23-20020aa78437000000b005184031963bsm234613pfn.85.2022.05.18.19.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 19:44:46 -0700 (PDT)
Date:   Thu, 19 May 2022 10:44:39 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH net 1/2] selftests/bpf: Fix build error with ima_setup.sh
Message-ID: <YoWvFz16SsSG7bH9@Laptop-X1>
References: <20220512071819.199873-1-liuhangbin@gmail.com>
 <20220512071819.199873-2-liuhangbin@gmail.com>
 <CAEf4BzZuj90MFaXci3av2BF+=m-P26Y3Zer8TogBiZ8fYsYP=g@mail.gmail.com>
 <YoHKw/at89Wp19F/@Laptop-X1>
 <CAEf4BzZhKpikBQFCEyRMmUHdTEt6xi+0ntfPswHA5WWK39cFjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZhKpikBQFCEyRMmUHdTEt6xi+0ntfPswHA5WWK39cFjQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 03:36:53PM -0700, Andrii Nakryiko wrote:
> > On Fri, May 13, 2022 at 02:58:05PM -0700, Andrii Nakryiko wrote:
> > > > -TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read $(OUTPUT)/bpf_testmod.ko \
> > > > -                      ima_setup.sh                                     \
> > > > +TRUNNER_EXTRA_BUILD := $(OUTPUT)/urandom_read $(OUTPUT)/bpf_testmod.ko \
> > > >                        $(wildcard progs/btf_dump_test_case_*.c)
> > >
> > >
> > > note that progs/btf_dump_test_case_*.c are not built, they are just
> > > copied over (C source files), so I don't think this fix is necessary.
> > >
> > > btw, I tried running `OUTPUT="/tmp/bpf" make test_progs` and it didn't
> > > error out. But tbh, I'd recommend building everything instead of
> > > building individual targets.
> >
> > After update the code to latest bpf-next. It works this time, the ima_setup.sh
> > was copied to target folder correctly.
> >
> >   EXT-COPY [test_progs] urandom_read bpf_testmod.ko liburandom_read.so ima_setup.sh btf_dump_test_case_bitfields.c btf_dump_test_case_multidim.c btf_dump_test_case_namespacing.c btf_dump_test_case_ordering.c btf_dump_test_case_packing.c btf_dump_test_case_padding.c btf_dump_test_case_syntax.c
> >   BINARY   test_progs
> >
> > Not sure why the previous kernel doesn't work. But anyway I will drop this patch.
> >
> > On the other hand, when I build with latest bpf-next. I got error like:
> >
> > """
> > # OUTPUT="/tmp/bpf" make test_progs
> >   BINARY   urandom_read                                                                                                                                                       gcc -g -O0 -rdynamic -Wall -Werror -DHAVE_GENHDR  -I/home/net/tools/testing/selftests/bpf -I/tmp/bpf/tools/include -I/home/net/include/generated -I/home/net/tools/lib -I/home/net/tools/include -I/home/net/tools/include/uapi -I/tmp/bpf  urandom_read.c urandom_read_aux.c  \
> >           liburandom_read.so -lelf -lz -lrt -lpthread   \
> >           -Wl,-rpath=. -Wl,--build-id=sha1 -o /tmp/bpf/urandom_read
> 
> we assume liburandom_read.so is going to be under selftests/bpf here,
> but it's actually under $(OUTPUT)/
> 
> Can you try $(OUTPUT)/liburandom_read.so? I suspect this might break
> -rpath=., though, but let's try this first?

Sigh.. After rebase to latest bpf-next, to make clean and re-do
`OUTPUT="/tmp/bpf" make test_progs`, There is no liburandom_read.so build
issue but the ima_setup.sh error come up again...

  LINK     resolve_btfids
  LIB      liburandom_read.so
  BINARY   urandom_read
  MOD      bpf_testmod.ko
  CC [M]  /home/net/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.o
  MODPOST /home/net/tools/testing/selftests/bpf/bpf_testmod/Module.symvers
  CC [M]  /home/net/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.mod.o
  LD [M]  /home/net/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.ko
  BTF [M] /home/net/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.ko
make: *** No rule to make target '/tmp/bpf/ima_setup.sh', needed by 'ima_setup.sh'.  Stop.

Not sure if it's a build environment setup issue or others.

Hangbin
