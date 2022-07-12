Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BEF572151
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbiGLQsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbiGLQsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:48:20 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E984826550;
        Tue, 12 Jul 2022 09:48:18 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id oy13so10491568ejb.1;
        Tue, 12 Jul 2022 09:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mbcmmT+pMIMYMSXXNjbFWB+IQNvMXD49nlszvCumBmU=;
        b=C1vtv/hzFoN+4KUlqwUzTpCbKy6osNIrSgaVsPH2ISYa96ePHQDacSsKJieasMjDbW
         xQI+2uqQcp+HXJH4Jnpi+G1ApZQOCEsLycWTM3DqBia6powR7ttUJSwGGXT5y9tFxrsL
         mA/fbxw9AoAeeGMXWPdEeVKS60RwLdjij3kub586mW+2jlmcVpPAReibwGwnBBcqaCrZ
         +0fsFwlHPyxePGt3TUDYuWU/JZwniI+wJJA1Sh1OpGwWmuypq4MXTDkbA/UtNV2NGWpP
         zXWx4GuVCBZXpX7HmrZUtEYp+HVNYN9YyERwAX29yTRiQTiTyTlZQtc56VrhsipDOsBE
         ssPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mbcmmT+pMIMYMSXXNjbFWB+IQNvMXD49nlszvCumBmU=;
        b=xD83WuZJ0cTThlE6u9DgwfEF33dlKtMJio3+/zqEAggZnaxFM64jI7SPOw042SJOm9
         DHFVIMO5tLpPUuH/GkE0FM09LwYzouJq5ZCHAlY5rmh/xlEViWjvF8+cFWYp3lIDvgUB
         RpegtPdEj2WIGG9Gnsi18pK6kj9kzchWDQuqkGHcoUhK9UW5y44mXrW45jFGAPpPMvjs
         c6eFOuf6KAgLZCiskhfE2DW+xcv3q/59mQijPkaPTE+C55fEkfI7PV2TV3g0sqQ/MNnH
         qul7ephaAY7Op/KFM3snMu8ycLJtMINYoGINCH+YCWpr1Ix1XX64601Zo9DCuQ5aqAu1
         iXzg==
X-Gm-Message-State: AJIora+jnlt9HKATF0sQu5yeUyaM+omLXwgTVNtRRuyPybRBv7qD3jyp
        c6BwSBYVMSfCVpUpGt8B4pcgxdPyeyH+ToL2KvE=
X-Google-Smtp-Source: AGRyM1ult/9veqdiVtMu6Yt+QfiYXMYM/CbHEUmsdXJfyLCmDL4cncCV1h1TX4KkfDkaeoJZksDdv+HaMlACJA7Ni9E=
X-Received: by 2002:a17:907:6e03:b0:726:a6a3:7515 with SMTP id
 sd3-20020a1709076e0300b00726a6a37515mr25271067ejc.676.1657644497455; Tue, 12
 Jul 2022 09:48:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220706172814.169274-1-james.hilliard1@gmail.com>
 <a0bddf0b-e8c4-46ce-b7c6-a22809af1677@fb.com> <CADvTj4ovwExtM-bWUpJELy-OqsT=J9stmqbAXto8ds2n+G8mfw@mail.gmail.com>
 <CAEf4BzYwRyXG1zE5BK1ZXmxLh+ZPU0=yQhNhpqr0JmfNA30tdQ@mail.gmail.com> <87v8s260j1.fsf@oracle.com>
In-Reply-To: <87v8s260j1.fsf@oracle.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 12 Jul 2022 09:48:05 -0700
Message-ID: <CAADnVQLQGHoj_gCOvdFFw2pRxgMubPSp+bRpFeCSa5zvcK2qRQ@mail.gmail.com>
Subject: Re: [PATCH v2] bpf/scripts: Generate GCC compatible helpers
To:     "Jose E. Marchesi" <jose.marchesi@oracle.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        James Hilliard <james.hilliard1@gmail.com>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 4:20 AM Jose E. Marchesi
<jose.marchesi@oracle.com> wrote:
>
>
> > CC Quentin as well
> >
> > On Mon, Jul 11, 2022 at 5:11 PM James Hilliard
> > <james.hilliard1@gmail.com> wrote:
> >>
> >> On Mon, Jul 11, 2022 at 5:36 PM Yonghong Song <yhs@fb.com> wrote:
> >> >
> >> >
> >> >
> >> > On 7/6/22 10:28 AM, James Hilliard wrote:
> >> > > The current bpf_helper_defs.h helpers are llvm specific and don't work
> >> > > correctly with gcc.
> >> > >
> >> > > GCC appears to required kernel helper funcs to have the following
> >> > > attribute set: __attribute__((kernel_helper(NUM)))
> >> > >
> >> > > Generate gcc compatible headers based on the format in bpf-helpers.h.
> >> > >
> >> > > This adds conditional blocks for GCC while leaving clang codepaths
> >> > > unchanged, for example:
> >> > >       #if __GNUC__ && !__clang__
> >> > >       void *bpf_map_lookup_elem(void *map, const void *key)
> >> > > __attribute__((kernel_helper(1)));
> >> > >       #else
> >> > >       static void *(*bpf_map_lookup_elem)(void *map, const void *key) = (void *) 1;
> >> > >       #endif
> >> >
> >> > It does look like that gcc kernel_helper attribute is better than
> >> > '(void *) 1' style. The original clang uses '(void *) 1' style is
> >> > just for simplicity.
> >>
> >> Isn't the original style going to be needed for backwards compatibility with
> >> older clang versions for a while?
> >
> > I'm curious, is there any added benefit to having this special
> > kernel_helper attribute vs what we did in Clang for a long time?
> > Did GCC do it just to be different and require workarounds like this
> > or there was some technical benefit to this?
>
> We did it that way so we could make trouble and piss you off.
>
> Nah :)
>
> We did it that way because technically speaking the clang construction
> works relying on particular optimizations to happen to get correct
> compiled programs, which is not guaranteed to happen and _may_ break in
> the future.
>
> In fact, if you compile a call to such a function prototype with clang
> with -O0 the compiler will try to load the function's address in a
> register and then emit an invalid BPF instruction:
>
>   28:   8d 00 00 00 03 00 00 00         *unknown*
>
> On the other hand the kernel_helper attribute is bullet-proof: will work
> with any optimization level, with any version of the compiler, and in
> our opinion it is also more readable, more tidy and more correct.
>
> Note I'm not saying what you do in clang is not reasonable; it may be,
> obviously it works well enough for you in practice.  Only that we have
> good reasons for doing it differently in GCC.

Not questioning the validity of the reasons, but they created
the unnecessary difference between compilers.
We have to avoid forking.
Meaning we're not going to work around that by ifdefs in
bpf_helper_defs.h
Because gcc community will not learn the lesson and will keep
the bad practice of unnecessary forks.
The best path forward here is to support both (void *) 1 style
and kernel_helper attribute in both gcc and llvm.
Moving forward the bpf_helper_defs.h will stay with (void *)1 style
and when both compilers support both options we will start
transitioning to the new kernel_helpers style.
