Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5EBE572B07
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 03:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbiGMBpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 21:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiGMBpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 21:45:14 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3932D214E;
        Tue, 12 Jul 2022 18:45:12 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id l23so17364993ejr.5;
        Tue, 12 Jul 2022 18:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h7UuA6KEsEYfjXpZsGhGp6AlFn4ZF+0TKFjwMlSBksQ=;
        b=XRtaLuqhXKtvV7sA7WgZ6qjGuWfAZd465zy8rIQCTMAL3YnS6mh4FRKUGEtMXIJMOA
         9WxmRW00CKWv3YmuCH61O2BpJ4eFFr94WGYIvjTU/W4Zm4Ju2JC+xnVcbGoNuM447A/E
         YZiTqreFVpCgqDjEh82rzWQ2ic8/bPCyikfNK4pbey7zKdgryafZYi5AZGskWBJFOqtH
         AWVON7EBDzexTCsmLrAu2KyDyr5EyPC5bDlir/USbgZ3ztJKi/CKiknlpeFADFIkBgED
         rRG+6TgbLISIk1ObkAGyMZMwBLx2kqsB8w+mqGm76m/xTEkq+SzmrykSRWeb2/IpI9Da
         /cxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h7UuA6KEsEYfjXpZsGhGp6AlFn4ZF+0TKFjwMlSBksQ=;
        b=mqNIo9E3OjXQfC6c8qbFUVpw5GA4871GACRX8fbvvf8rdZ/LBqjHp7S2lLMgOtmv3z
         BFZ3AEryuI+AyyR+8IBED9oCNccfcXFbslEWAwAJ53V3d7RFzzc/3/GgXLu3l/mbu3t/
         fHEVXZVhH+HNgoRnDulFvTqzTp/kcP1Kw9Y8w/kFoFeA2/DomBU4KIoreCYGQ6MARIKA
         3xFvhlh2DEoHbL5FHL/ly2+h7K9g9kpy9fAhdXy5QnGtTimgcblAV3rV8RiL2ODS/RZ9
         hCaTkqHu5ev9lWDS5fUYvKcfSiPlwpsOJl8n43AKJipoPvC2CFRppmiymbtNl4zEm4wI
         6G/g==
X-Gm-Message-State: AJIora/OtSVmQJKp02j4qkHyuMJJT0c8WJJeObFfCAg3wGgVLUSZ778G
        RNJ4mO8HHcO4qrfkr04XLMpcMvQ6Y1agwHFwuyg=
X-Google-Smtp-Source: AGRyM1vPMRPDxjEx/gzlEQBBd9eB5dgYYM6XAZT0k5wm87SbRHF6rrgXdSdi5cRySIewDisAJr4ZB1batDjpfmJgHpA=
X-Received: by 2002:a17:906:9bdd:b0:72b:3cab:eade with SMTP id
 de29-20020a1709069bdd00b0072b3cabeademr1048727ejc.58.1657676711455; Tue, 12
 Jul 2022 18:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220706172814.169274-1-james.hilliard1@gmail.com>
 <a0bddf0b-e8c4-46ce-b7c6-a22809af1677@fb.com> <CADvTj4ovwExtM-bWUpJELy-OqsT=J9stmqbAXto8ds2n+G8mfw@mail.gmail.com>
 <CAEf4BzYwRyXG1zE5BK1ZXmxLh+ZPU0=yQhNhpqr0JmfNA30tdQ@mail.gmail.com>
 <87v8s260j1.fsf@oracle.com> <CAADnVQLQGHoj_gCOvdFFw2pRxgMubPSp+bRpFeCSa5zvcK2qRQ@mail.gmail.com>
 <CADvTj4qqxckZmxvL=97e-2W5M4DgCCMDV8RCFDg23+cY2URjTA@mail.gmail.com>
 <20220713011851.4a2tnqhdd5f5iwak@macbook-pro-3.dhcp.thefacebook.com> <CADvTj4o7z7J=4BOtKM9dthZyfFogV6hL5zKBwiBq7vs+bNhUHA@mail.gmail.com>
In-Reply-To: <CADvTj4o7z7J=4BOtKM9dthZyfFogV6hL5zKBwiBq7vs+bNhUHA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 12 Jul 2022 18:44:59 -0700
Message-ID: <CAADnVQJAz7BcZjrBwu-8MjQprh86Z_UpWGMSQtFnowZTc4d6Vw@mail.gmail.com>
Subject: Re: [PATCH v2] bpf/scripts: Generate GCC compatible helpers
To:     James Hilliard <james.hilliard1@gmail.com>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 6:29 PM James Hilliard
<james.hilliard1@gmail.com> wrote:
>
> On Tue, Jul 12, 2022 at 7:18 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Jul 12, 2022 at 07:10:27PM -0600, James Hilliard wrote:
> > > On Tue, Jul 12, 2022 at 10:48 AM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Tue, Jul 12, 2022 at 4:20 AM Jose E. Marchesi
> > > > <jose.marchesi@oracle.com> wrote:
> > > > >
> > > > >
> > > > > > CC Quentin as well
> > > > > >
> > > > > > On Mon, Jul 11, 2022 at 5:11 PM James Hilliard
> > > > > > <james.hilliard1@gmail.com> wrote:
> > > > > >>
> > > > > >> On Mon, Jul 11, 2022 at 5:36 PM Yonghong Song <yhs@fb.com> wrote:
> > > > > >> >
> > > > > >> >
> > > > > >> >
> > > > > >> > On 7/6/22 10:28 AM, James Hilliard wrote:
> > > > > >> > > The current bpf_helper_defs.h helpers are llvm specific and don't work
> > > > > >> > > correctly with gcc.
> > > > > >> > >
> > > > > >> > > GCC appears to required kernel helper funcs to have the following
> > > > > >> > > attribute set: __attribute__((kernel_helper(NUM)))
> > > > > >> > >
> > > > > >> > > Generate gcc compatible headers based on the format in bpf-helpers.h.
> > > > > >> > >
> > > > > >> > > This adds conditional blocks for GCC while leaving clang codepaths
> > > > > >> > > unchanged, for example:
> > > > > >> > >       #if __GNUC__ && !__clang__
> > > > > >> > >       void *bpf_map_lookup_elem(void *map, const void *key)
> > > > > >> > > __attribute__((kernel_helper(1)));
> > > > > >> > >       #else
> > > > > >> > >       static void *(*bpf_map_lookup_elem)(void *map, const void *key) = (void *) 1;
> > > > > >> > >       #endif
> > > > > >> >
> > > > > >> > It does look like that gcc kernel_helper attribute is better than
> > > > > >> > '(void *) 1' style. The original clang uses '(void *) 1' style is
> > > > > >> > just for simplicity.
> > > > > >>
> > > > > >> Isn't the original style going to be needed for backwards compatibility with
> > > > > >> older clang versions for a while?
> > > > > >
> > > > > > I'm curious, is there any added benefit to having this special
> > > > > > kernel_helper attribute vs what we did in Clang for a long time?
> > > > > > Did GCC do it just to be different and require workarounds like this
> > > > > > or there was some technical benefit to this?
> > > > >
> > > > > We did it that way so we could make trouble and piss you off.
> > > > >
> > > > > Nah :)
> > > > >
> > > > > We did it that way because technically speaking the clang construction
> > > > > works relying on particular optimizations to happen to get correct
> > > > > compiled programs, which is not guaranteed to happen and _may_ break in
> > > > > the future.
> > > > >
> > > > > In fact, if you compile a call to such a function prototype with clang
> > > > > with -O0 the compiler will try to load the function's address in a
> > > > > register and then emit an invalid BPF instruction:
> > > > >
> > > > >   28:   8d 00 00 00 03 00 00 00         *unknown*
> > > > >
> > > > > On the other hand the kernel_helper attribute is bullet-proof: will work
> > > > > with any optimization level, with any version of the compiler, and in
> > > > > our opinion it is also more readable, more tidy and more correct.
> > > > >
> > > > > Note I'm not saying what you do in clang is not reasonable; it may be,
> > > > > obviously it works well enough for you in practice.  Only that we have
> > > > > good reasons for doing it differently in GCC.
> > > >
> > > > Not questioning the validity of the reasons, but they created
> > > > the unnecessary difference between compilers.
> > >
> > > Sounds to me like clang is relying on an unreliable hack that may
> > > be difficult to implement in GCC, so let's see what's the best option
> > > moving forwards in terms of a migration path for both GCC and clang.
> >
> > The following is a valid C code:
> > static long (*foo) (void) = (void *) 1234;
> > foo();
> >
> > and GCC has to generate correct assembly assuming it runs at -O1 or higher.
>
> Providing -O1 or higher with gcc-bpf does not seem to work at the moment.

Let's fix gcc first.

> > There is no indirect call insn defined in BPF ISA yet,
> > so the -O0 behavior is undefined.
>
> Well GCC at least seems to be able to compile BPF programs with -O0 using
> kernel_helper. I assume -O0 is probably just targeting the minimum BPF ISA
> optimization level or something like that which avoids indirect calls.

There are other reasons why -O0 compiled progs will
fail in the verifier.

> >
> > > Or we can just feature detect kernel_helper and leave the (void *)1 style
> > > fallback in place until we drop support for clang variants that don't support
> > > kernel_helper. This would provide GCC compatibility and a better migration
> > > path for clang as well as clang will then automatically use the new variant
> > > whenever support for kernel_helper is introduced.
> >
> > Support for valid C code will not be dropped from clang.
>
> That wasn't what I was suggesting, I was suggesting adding support for
> kernel_helper to clang, and then in the future libbpf(not clang) can
> drop support
> for the (void *)1 style in the future if desired(or can just keep the
> fallback). By
> feature detecting kernel_helper and providing a fallback we get a nice clean
> migration path.

Makes sense. That deprecation step is far away though.
Assuming that kernel_helper attr is actually necessary
we have to add its support to clang as well.
We have to keep compilers in sync.
gcc-bpf is a niche. If gcc devs want it to become a real
alternative to clang they have to always aim for feature parity
instead of inventing their own ways of doing things.
