Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C53A572AA9
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 03:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbiGMBKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 21:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbiGMBKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 21:10:40 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB41D0E07;
        Tue, 12 Jul 2022 18:10:39 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-10bec750eedso12393729fac.8;
        Tue, 12 Jul 2022 18:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RrX3peZWnGalBRHR5HZNG+F96F6AWO/ZiWH718+O+dA=;
        b=LIDvWWeRQZTx/i2X47H61p2/5b0xtFm3GNtyXOO2qqIe73b8/IQH/9A2l+mGfBtK52
         S3ZOG/LjzCIWzIcIE7e7/WXqyZa4Zcafr212YEoautFQw7Ne6FwelqZPQgYjvBXjzgRX
         2OgdZpIDewP84Kn7FB4q0S1vfN9nYPWDpJsp+wdzvFmOo4t6eP+lU60en6T6rUjywoC1
         IQCwjV2djvWMKtqXyYgbcaOOD6qKdtOb7qnEC0OnH4IPTRj2QCJShmFy8NIzgDdg8zTX
         /hW9is4OTJ4puVf6s77EUuJETfJfe9oLOLEA1sYCTGMs5+ZPPbkIcGh7nKA56yKq9ZkR
         IT2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RrX3peZWnGalBRHR5HZNG+F96F6AWO/ZiWH718+O+dA=;
        b=h7MtH58OFbRS+bQOi9iX7yHc2JFp7hpncldHhsbOgooxsky0++KnNSIPvOUeVL2pHp
         hVAwPc5HOyU1NeXBdc+45zoCarUUqmbOC5+xwf/CaxN/Myx+ZEZgB8/R2hk8xRz/WC+i
         l/ao4XZe59vhm6bBI+wWr8gRNb1/UT2yZzDD+kC3f5vUMfroZxX4v2BQ1WSBvVJJF1BO
         GnAsMKtt6kJmeh/JEoDEdXCgOXMBXe/W6JttzcZbHDf0h/Ftv+NKpwwdHe7AjWAsm8IZ
         7oZaoNXus+Wte07sGgSQQqGU0iO7sYBxftSbx5T+zAt4wg2hkhMwOyofKBR8NUCYU6cD
         neLQ==
X-Gm-Message-State: AJIora/KKW0JXhD/xZ6deN3/UW2i92bx0J0WZtVOhwo2MVkkgRwEoQP6
        G7O6YOf42JpDCTQLIpE09hAw3T9hu+sTSpDed7I=
X-Google-Smtp-Source: AGRyM1tAL2bX6mdeZ3XMD3lZNiKAC8hU+Bm50hEa1wveXWLWssf8CLjAViJsn9EmQohWw/iJJhSn9Log4iP3HsMvT20=
X-Received: by 2002:a05:6870:d0ce:b0:f3:3856:f552 with SMTP id
 k14-20020a056870d0ce00b000f33856f552mr523604oaa.99.1657674639131; Tue, 12 Jul
 2022 18:10:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220706172814.169274-1-james.hilliard1@gmail.com>
 <a0bddf0b-e8c4-46ce-b7c6-a22809af1677@fb.com> <CADvTj4ovwExtM-bWUpJELy-OqsT=J9stmqbAXto8ds2n+G8mfw@mail.gmail.com>
 <CAEf4BzYwRyXG1zE5BK1ZXmxLh+ZPU0=yQhNhpqr0JmfNA30tdQ@mail.gmail.com>
 <87v8s260j1.fsf@oracle.com> <CAADnVQLQGHoj_gCOvdFFw2pRxgMubPSp+bRpFeCSa5zvcK2qRQ@mail.gmail.com>
In-Reply-To: <CAADnVQLQGHoj_gCOvdFFw2pRxgMubPSp+bRpFeCSa5zvcK2qRQ@mail.gmail.com>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Tue, 12 Jul 2022 19:10:27 -0600
Message-ID: <CADvTj4qqxckZmxvL=97e-2W5M4DgCCMDV8RCFDg23+cY2URjTA@mail.gmail.com>
Subject: Re: [PATCH v2] bpf/scripts: Generate GCC compatible helpers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "Jose E. Marchesi" <jose.marchesi@oracle.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 10:48 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jul 12, 2022 at 4:20 AM Jose E. Marchesi
> <jose.marchesi@oracle.com> wrote:
> >
> >
> > > CC Quentin as well
> > >
> > > On Mon, Jul 11, 2022 at 5:11 PM James Hilliard
> > > <james.hilliard1@gmail.com> wrote:
> > >>
> > >> On Mon, Jul 11, 2022 at 5:36 PM Yonghong Song <yhs@fb.com> wrote:
> > >> >
> > >> >
> > >> >
> > >> > On 7/6/22 10:28 AM, James Hilliard wrote:
> > >> > > The current bpf_helper_defs.h helpers are llvm specific and don't work
> > >> > > correctly with gcc.
> > >> > >
> > >> > > GCC appears to required kernel helper funcs to have the following
> > >> > > attribute set: __attribute__((kernel_helper(NUM)))
> > >> > >
> > >> > > Generate gcc compatible headers based on the format in bpf-helpers.h.
> > >> > >
> > >> > > This adds conditional blocks for GCC while leaving clang codepaths
> > >> > > unchanged, for example:
> > >> > >       #if __GNUC__ && !__clang__
> > >> > >       void *bpf_map_lookup_elem(void *map, const void *key)
> > >> > > __attribute__((kernel_helper(1)));
> > >> > >       #else
> > >> > >       static void *(*bpf_map_lookup_elem)(void *map, const void *key) = (void *) 1;
> > >> > >       #endif
> > >> >
> > >> > It does look like that gcc kernel_helper attribute is better than
> > >> > '(void *) 1' style. The original clang uses '(void *) 1' style is
> > >> > just for simplicity.
> > >>
> > >> Isn't the original style going to be needed for backwards compatibility with
> > >> older clang versions for a while?
> > >
> > > I'm curious, is there any added benefit to having this special
> > > kernel_helper attribute vs what we did in Clang for a long time?
> > > Did GCC do it just to be different and require workarounds like this
> > > or there was some technical benefit to this?
> >
> > We did it that way so we could make trouble and piss you off.
> >
> > Nah :)
> >
> > We did it that way because technically speaking the clang construction
> > works relying on particular optimizations to happen to get correct
> > compiled programs, which is not guaranteed to happen and _may_ break in
> > the future.
> >
> > In fact, if you compile a call to such a function prototype with clang
> > with -O0 the compiler will try to load the function's address in a
> > register and then emit an invalid BPF instruction:
> >
> >   28:   8d 00 00 00 03 00 00 00         *unknown*
> >
> > On the other hand the kernel_helper attribute is bullet-proof: will work
> > with any optimization level, with any version of the compiler, and in
> > our opinion it is also more readable, more tidy and more correct.
> >
> > Note I'm not saying what you do in clang is not reasonable; it may be,
> > obviously it works well enough for you in practice.  Only that we have
> > good reasons for doing it differently in GCC.
>
> Not questioning the validity of the reasons, but they created
> the unnecessary difference between compilers.

Sounds to me like clang is relying on an unreliable hack that may
be difficult to implement in GCC, so let's see what's the best option
moving forwards in terms of a migration path for both GCC and clang.

> We have to avoid forking.

Avoiding having to maintain a separate libbpf fork for GCC compatibility
is precisely the purpose of this patch.

> Meaning we're not going to work around that by ifdefs in
> bpf_helper_defs.h
> Because gcc community will not learn the lesson and will keep
> the bad practice of unnecessary forks.

Is there some background I'm missing here? What's your definition
of an unnecessary fork?

> The best path forward here is to support both (void *) 1 style
> and kernel_helper attribute in both gcc and llvm.

How about we use a guard like this:
#if __has_attribute(kernel_helper)
new kernel_helper variant macro
#else
legacy clang variant macro
#endif

> Moving forward the bpf_helper_defs.h will stay with (void *)1 style
> and when both compilers support both options we will start
> transitioning to the new kernel_helpers style.

Or we can just feature detect kernel_helper and leave the (void *)1 style
fallback in place until we drop support for clang variants that don't support
kernel_helper. This would provide GCC compatibility and a better migration
path for clang as well as clang will then automatically use the new variant
whenever support for kernel_helper is introduced.
