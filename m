Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908C0572C79
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 06:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbiGMEZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 00:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiGMEZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 00:25:55 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272AA4506E;
        Tue, 12 Jul 2022 21:25:54 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o31-20020a17090a0a2200b001ef7bd037bbso1678943pjo.0;
        Tue, 12 Jul 2022 21:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nMGzjqDUW6SdVGyuTZy6wI3JH0wU7GZTzrC52WE7cc0=;
        b=ABfb0rNSZ2TR5dRBsJ0xrkkxMAwSh4EmmJtx205q+k9wcvQiq9H5D8qVacW42Z8vka
         Za1l9DY7v8VSiU9o/K6H4DW5LoPWI+7Q5yi4LMJ7Ufq22dIUV4RWtW9C+7E8hA2BIAqt
         u2MRX27wnScWVmlI9KyNah4SX5qBTYg5n4hili8eTXUJymco/6PRVPB3O07+8CFHUnG7
         4QkfxQc2lyRsYJf9D//gvyo0Nem3uQlG7YNASr6iz4jPriA6RUYpQjlfDbEY/AZE2JVd
         lP4Wit1ln6emmVBwFrOlRZno7whBDhFhY+FbK8mLyPX221eskMJ7coT5mz8PTV6U3Eyj
         oZtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nMGzjqDUW6SdVGyuTZy6wI3JH0wU7GZTzrC52WE7cc0=;
        b=vSXLpAAXZbH2xFI2coK0EGpFJqWkoiEjB6L/lGFAt4aTEGLjFf3aw1aMvs4shZiXgC
         GMdjVuHFIN2Nr/4HYsSMezkwUDzSgax9VMpGtHj5a5S6kXbC+/bF6wOq7smdy5BbKHmr
         a0scCLypXSCgZ0EgP6hmp01hAn+hvtZaqaS3r9ALNKcm6J6stWbBavtT/Q17627/vcsu
         F/JsNdSs2ws4ceAbqcpn4ywDwsyiKK4XGh/Cz3CwtQV0RpGEsoGSIJhgwaCD/HUhixoQ
         ItJXdIMYUhZnwHfWWTaZJzKv3YytYeE6xTVaOjVv1IvWQ3zzF5fJ7DDnA/FVS6CPe5Wg
         W8nw==
X-Gm-Message-State: AJIora/kbGCEHhJcOR7TtDiGUwWyqwSWIai6WXqVQe+Wh1sWNp7jL8Kl
        g+hxc7WN1s9wdZTNR9kYiXw=
X-Google-Smtp-Source: AGRyM1syYHQhPr7RhT9rFmN72PJ2fPdHbWvXbIqYCV2V7Z2PlYl6loSQ1/6Fo3O8xuydFUf85LKmKw==
X-Received: by 2002:a17:90b:3890:b0:1f0:2abb:e7d1 with SMTP id mu16-20020a17090b389000b001f02abbe7d1mr8212824pjb.158.1657686353312;
        Tue, 12 Jul 2022 21:25:53 -0700 (PDT)
Received: from macbook-pro-3.dhcp.thefacebook.com ([2620:10d:c090:400::5:580c])
        by smtp.gmail.com with ESMTPSA id h11-20020a170902680b00b0016a11750b50sm7640118plk.16.2022.07.12.21.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 21:25:52 -0700 (PDT)
Date:   Tue, 12 Jul 2022 21:25:49 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
Subject: Re: [PATCH v2] bpf/scripts: Generate GCC compatible helpers
Message-ID: <20220713042549.uljgrp4lffianxyj@macbook-pro-3.dhcp.thefacebook.com>
References: <a0bddf0b-e8c4-46ce-b7c6-a22809af1677@fb.com>
 <CADvTj4ovwExtM-bWUpJELy-OqsT=J9stmqbAXto8ds2n+G8mfw@mail.gmail.com>
 <CAEf4BzYwRyXG1zE5BK1ZXmxLh+ZPU0=yQhNhpqr0JmfNA30tdQ@mail.gmail.com>
 <87v8s260j1.fsf@oracle.com>
 <CAADnVQLQGHoj_gCOvdFFw2pRxgMubPSp+bRpFeCSa5zvcK2qRQ@mail.gmail.com>
 <CADvTj4qqxckZmxvL=97e-2W5M4DgCCMDV8RCFDg23+cY2URjTA@mail.gmail.com>
 <20220713011851.4a2tnqhdd5f5iwak@macbook-pro-3.dhcp.thefacebook.com>
 <CADvTj4o7z7J=4BOtKM9dthZyfFogV6hL5zKBwiBq7vs+bNhUHA@mail.gmail.com>
 <CAADnVQJAz7BcZjrBwu-8MjQprh86Z_UpWGMSQtFnowZTc4d6Vw@mail.gmail.com>
 <CADvTj4qtCfmsu=dMZx9LtaDMOSNsOxGVSa1g3USEWroA1AfTJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvTj4qtCfmsu=dMZx9LtaDMOSNsOxGVSa1g3USEWroA1AfTJA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 08:56:35PM -0600, James Hilliard wrote:
> On Tue, Jul 12, 2022 at 7:45 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Jul 12, 2022 at 6:29 PM James Hilliard
> > <james.hilliard1@gmail.com> wrote:
> > >
> > > On Tue, Jul 12, 2022 at 7:18 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Tue, Jul 12, 2022 at 07:10:27PM -0600, James Hilliard wrote:
> > > > > On Tue, Jul 12, 2022 at 10:48 AM Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > >
> > > > > > On Tue, Jul 12, 2022 at 4:20 AM Jose E. Marchesi
> > > > > > <jose.marchesi@oracle.com> wrote:
> > > > > > >
> > > > > > >
> > > > > > > > CC Quentin as well
> > > > > > > >
> > > > > > > > On Mon, Jul 11, 2022 at 5:11 PM James Hilliard
> > > > > > > > <james.hilliard1@gmail.com> wrote:
> > > > > > > >>
> > > > > > > >> On Mon, Jul 11, 2022 at 5:36 PM Yonghong Song <yhs@fb.com> wrote:
> > > > > > > >> >
> > > > > > > >> >
> > > > > > > >> >
> > > > > > > >> > On 7/6/22 10:28 AM, James Hilliard wrote:
> > > > > > > >> > > The current bpf_helper_defs.h helpers are llvm specific and don't work
> > > > > > > >> > > correctly with gcc.
> > > > > > > >> > >
> > > > > > > >> > > GCC appears to required kernel helper funcs to have the following
> > > > > > > >> > > attribute set: __attribute__((kernel_helper(NUM)))
> > > > > > > >> > >
> > > > > > > >> > > Generate gcc compatible headers based on the format in bpf-helpers.h.
> > > > > > > >> > >
> > > > > > > >> > > This adds conditional blocks for GCC while leaving clang codepaths
> > > > > > > >> > > unchanged, for example:
> > > > > > > >> > >       #if __GNUC__ && !__clang__
> > > > > > > >> > >       void *bpf_map_lookup_elem(void *map, const void *key)
> > > > > > > >> > > __attribute__((kernel_helper(1)));
> > > > > > > >> > >       #else
> > > > > > > >> > >       static void *(*bpf_map_lookup_elem)(void *map, const void *key) = (void *) 1;
> > > > > > > >> > >       #endif
> > > > > > > >> >
> > > > > > > >> > It does look like that gcc kernel_helper attribute is better than
> > > > > > > >> > '(void *) 1' style. The original clang uses '(void *) 1' style is
> > > > > > > >> > just for simplicity.
> > > > > > > >>
> > > > > > > >> Isn't the original style going to be needed for backwards compatibility with
> > > > > > > >> older clang versions for a while?
> > > > > > > >
> > > > > > > > I'm curious, is there any added benefit to having this special
> > > > > > > > kernel_helper attribute vs what we did in Clang for a long time?
> > > > > > > > Did GCC do it just to be different and require workarounds like this
> > > > > > > > or there was some technical benefit to this?
> > > > > > >
> > > > > > > We did it that way so we could make trouble and piss you off.
> > > > > > >
> > > > > > > Nah :)
> > > > > > >
> > > > > > > We did it that way because technically speaking the clang construction
> > > > > > > works relying on particular optimizations to happen to get correct
> > > > > > > compiled programs, which is not guaranteed to happen and _may_ break in
> > > > > > > the future.
> > > > > > >
> > > > > > > In fact, if you compile a call to such a function prototype with clang
> > > > > > > with -O0 the compiler will try to load the function's address in a
> > > > > > > register and then emit an invalid BPF instruction:
> > > > > > >
> > > > > > >   28:   8d 00 00 00 03 00 00 00         *unknown*
> > > > > > >
> > > > > > > On the other hand the kernel_helper attribute is bullet-proof: will work
> > > > > > > with any optimization level, with any version of the compiler, and in
> > > > > > > our opinion it is also more readable, more tidy and more correct.
> > > > > > >
> > > > > > > Note I'm not saying what you do in clang is not reasonable; it may be,
> > > > > > > obviously it works well enough for you in practice.  Only that we have
> > > > > > > good reasons for doing it differently in GCC.
> > > > > >
> > > > > > Not questioning the validity of the reasons, but they created
> > > > > > the unnecessary difference between compilers.
> > > > >
> > > > > Sounds to me like clang is relying on an unreliable hack that may
> > > > > be difficult to implement in GCC, so let's see what's the best option
> > > > > moving forwards in terms of a migration path for both GCC and clang.
> > > >
> > > > The following is a valid C code:
> > > > static long (*foo) (void) = (void *) 1234;
> > > > foo();
> > > >
> > > > and GCC has to generate correct assembly assuming it runs at -O1 or higher.
> > >
> > > Providing -O1 or higher with gcc-bpf does not seem to work at the moment.
> >
> > Let's fix gcc first.
> 
> If the intention is to migrate to kernel_helper for clang as well it
> seems kind of
> redundant, is there a real world use case for supporting the '(void *)
> 1' style in
> GCC rather than just adding feature detection+kernel_helper support to libbpf?
> 
> My assumption is that kernel helpers are in practice always used via libbpf
> which appears to be sufficient in terms of being able to provide a compatibility
> layer via feature detection. Or is there some use case I'm missing here?

static long (*foo) (void) = (void *) 1234;
is not about calling into "kernel helpers".
There is no concept of "kernel" in BPF ISA.
'call 1234' insn means call a function with that absolute address.
The gcc named that attribute incorrectly.
It should be renamed to something like __attribute__((fixed_address(1234))).

It's a linux kernel abi choice to interpret 'call abs_addr' as a call to a kernel
provided function at that address. 1,2,3,... are addresses of functions.

> >
> > > > There is no indirect call insn defined in BPF ISA yet,
> > > > so the -O0 behavior is undefined.
> > >
> > > Well GCC at least seems to be able to compile BPF programs with -O0 using
> > > kernel_helper. I assume -O0 is probably just targeting the minimum BPF ISA
> > > optimization level or something like that which avoids indirect calls.
> >
> > There are other reasons why -O0 compiled progs will
> > fail in the verifier.
> 
> Why would -O0 generate code that isn't compatible with the selected
> target BPF ISA?

llvm has no issue producing valid BPF code with -O0.
It's the kernel verifier that doesn't understand such code.
For the following code:
static long (*foo) (void) = (void *) 1234;
long bar(void)
{
    return foo();
}

With -O[12] llvm will generate
  call 1234
  exit
With -O0
  r1 = foo ll
  r1 = *(u64 *)(r1 + 0)
  callx r1
  exit

Both codes are valid and equivalent.
'callx' here is a reserved insn. The kernel verifier doesn't know about it yet,
but llvm was generting such code for 8+ years.

> > Assuming that kernel_helper attr is actually necessary
> > we have to add its support to clang as well.
> 
> I mean, I'd argue there's a difference between something being arguably a better
> alternative(optional) and actually being necessary(non-optional).

gcc's attribute is not better.
It's just a different way to tell compiler about fixed function address.

> > gcc-bpf is a niche. If gcc devs want it to become a real
> > alternative to clang they have to always aim for feature parity
> > instead of inventing their own ways of doing things.
> 
> What's ultimately going to help the most in regards to helping gcc-bpf reach
> feature parity with clang is getting it minimally usable in the real
> world, because
> that's how you're going to get more people testing+fixing bugs so that all these
> differences/incompatibilities can be worked though/fixed.

Can gcc-bpf compile all of selftests/bpf ?
How many of compiled programs will pass the verifier ?

> If nobody can compile a real world BPF program with gcc-bpf it's likely going to
> lag further behind.

selftest/bpf is a first milestone that gcc-bpf has to pass before talking about
'real world' bpf progs.
