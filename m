Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF61572B99
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 04:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbiGMC4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 22:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiGMC4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 22:56:49 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEBFD64DF;
        Tue, 12 Jul 2022 19:56:47 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1013ecaf7e0so12558614fac.13;
        Tue, 12 Jul 2022 19:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A4AxhqOKxKwY9v3x788IY0H+G9lgTKdeAdZ872/bmNo=;
        b=aG9EAS3Aa7ErwkVZF0AsmMhRiRic5mMOlPs02x7vx2f7IcOn8EDf8ElIwPn73soyYT
         FP29HCvo2Aj2f/6C6/unKmNbn9S+3MPN+9qKvuYwvUWRZXttGud9UKGq+d7lLoQAwflJ
         UpYZqfxC/8Ys2HY/JuxiMzhI5MV0fRIzDP13F9I2y7AmrV1xCBzTl9xYs98B1pBsWWJL
         9fTPuOFxoHgopJ6Bo/nW57D4rR6jmfS1DgW/NHNSGukbbZ54Su/89VYoA4ncExRuKEOu
         EEjTr87mHM9kFmDuLOsZx/feqR1DmkJ4xfjJM156wymkqyqPRdx7p5mh6Cn7YqQgD37l
         zOug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A4AxhqOKxKwY9v3x788IY0H+G9lgTKdeAdZ872/bmNo=;
        b=iUZ/5x/Du2UwaQgrqul5ynVEdjU/2tK4yt7585k7uWr0WQsth2DvdNLNLZ7rUKs5sF
         Tf0Y3VrpMKiqDOti1u3MyUuO7kRDcWI3pZ4R6uyqnzfbDhDob1tiIDwA2nNV4BYVS+4I
         yQYrxzb4/PfkJrgkAO11QsG72qqtLT+lLGiz2+1UWWW6F7c5NBFrmLSELo2Fez83QNsL
         mAEMWRT66xisPg+Kf6fs3+ju5acwDgoRK/GkpMe6O2A1DjJ/Nll2EvF0l80YLdDvSBiW
         fdrmssMT7WYR+f+CKGGoN1gMgYSNupVVJ3C5XwA1LC8PYtg2bw1vC9TqfnpQPX4ivGAP
         zqZQ==
X-Gm-Message-State: AJIora/ESpJqVuz53+tZcSsOoPEbOnT2MjRbazdcoe4RAzn/hjN1EeIU
        qvlzm/YSZysPCIRiLpYL2QPF8p+DvRLm0WVfy0s=
X-Google-Smtp-Source: AGRyM1u1qFFjXVP9sFaBw4tfVZUfpOxDTo1hZTLCOnlEWHRGj1sh8jo7upm3NkBcswPMefe8b0TYT7wyGdAS5FLAGqM=
X-Received: by 2002:a05:6870:d0ce:b0:f3:3856:f552 with SMTP id
 k14-20020a056870d0ce00b000f33856f552mr684768oaa.99.1657681006752; Tue, 12 Jul
 2022 19:56:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220706172814.169274-1-james.hilliard1@gmail.com>
 <a0bddf0b-e8c4-46ce-b7c6-a22809af1677@fb.com> <CADvTj4ovwExtM-bWUpJELy-OqsT=J9stmqbAXto8ds2n+G8mfw@mail.gmail.com>
 <CAEf4BzYwRyXG1zE5BK1ZXmxLh+ZPU0=yQhNhpqr0JmfNA30tdQ@mail.gmail.com>
 <87v8s260j1.fsf@oracle.com> <CAADnVQLQGHoj_gCOvdFFw2pRxgMubPSp+bRpFeCSa5zvcK2qRQ@mail.gmail.com>
 <CADvTj4qqxckZmxvL=97e-2W5M4DgCCMDV8RCFDg23+cY2URjTA@mail.gmail.com>
 <20220713011851.4a2tnqhdd5f5iwak@macbook-pro-3.dhcp.thefacebook.com>
 <CADvTj4o7z7J=4BOtKM9dthZyfFogV6hL5zKBwiBq7vs+bNhUHA@mail.gmail.com> <CAADnVQJAz7BcZjrBwu-8MjQprh86Z_UpWGMSQtFnowZTc4d6Vw@mail.gmail.com>
In-Reply-To: <CAADnVQJAz7BcZjrBwu-8MjQprh86Z_UpWGMSQtFnowZTc4d6Vw@mail.gmail.com>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Tue, 12 Jul 2022 20:56:35 -0600
Message-ID: <CADvTj4qtCfmsu=dMZx9LtaDMOSNsOxGVSa1g3USEWroA1AfTJA@mail.gmail.com>
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

On Tue, Jul 12, 2022 at 7:45 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jul 12, 2022 at 6:29 PM James Hilliard
> <james.hilliard1@gmail.com> wrote:
> >
> > On Tue, Jul 12, 2022 at 7:18 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Jul 12, 2022 at 07:10:27PM -0600, James Hilliard wrote:
> > > > On Tue, Jul 12, 2022 at 10:48 AM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Tue, Jul 12, 2022 at 4:20 AM Jose E. Marchesi
> > > > > <jose.marchesi@oracle.com> wrote:
> > > > > >
> > > > > >
> > > > > > > CC Quentin as well
> > > > > > >
> > > > > > > On Mon, Jul 11, 2022 at 5:11 PM James Hilliard
> > > > > > > <james.hilliard1@gmail.com> wrote:
> > > > > > >>
> > > > > > >> On Mon, Jul 11, 2022 at 5:36 PM Yonghong Song <yhs@fb.com> wrote:
> > > > > > >> >
> > > > > > >> >
> > > > > > >> >
> > > > > > >> > On 7/6/22 10:28 AM, James Hilliard wrote:
> > > > > > >> > > The current bpf_helper_defs.h helpers are llvm specific and don't work
> > > > > > >> > > correctly with gcc.
> > > > > > >> > >
> > > > > > >> > > GCC appears to required kernel helper funcs to have the following
> > > > > > >> > > attribute set: __attribute__((kernel_helper(NUM)))
> > > > > > >> > >
> > > > > > >> > > Generate gcc compatible headers based on the format in bpf-helpers.h.
> > > > > > >> > >
> > > > > > >> > > This adds conditional blocks for GCC while leaving clang codepaths
> > > > > > >> > > unchanged, for example:
> > > > > > >> > >       #if __GNUC__ && !__clang__
> > > > > > >> > >       void *bpf_map_lookup_elem(void *map, const void *key)
> > > > > > >> > > __attribute__((kernel_helper(1)));
> > > > > > >> > >       #else
> > > > > > >> > >       static void *(*bpf_map_lookup_elem)(void *map, const void *key) = (void *) 1;
> > > > > > >> > >       #endif
> > > > > > >> >
> > > > > > >> > It does look like that gcc kernel_helper attribute is better than
> > > > > > >> > '(void *) 1' style. The original clang uses '(void *) 1' style is
> > > > > > >> > just for simplicity.
> > > > > > >>
> > > > > > >> Isn't the original style going to be needed for backwards compatibility with
> > > > > > >> older clang versions for a while?
> > > > > > >
> > > > > > > I'm curious, is there any added benefit to having this special
> > > > > > > kernel_helper attribute vs what we did in Clang for a long time?
> > > > > > > Did GCC do it just to be different and require workarounds like this
> > > > > > > or there was some technical benefit to this?
> > > > > >
> > > > > > We did it that way so we could make trouble and piss you off.
> > > > > >
> > > > > > Nah :)
> > > > > >
> > > > > > We did it that way because technically speaking the clang construction
> > > > > > works relying on particular optimizations to happen to get correct
> > > > > > compiled programs, which is not guaranteed to happen and _may_ break in
> > > > > > the future.
> > > > > >
> > > > > > In fact, if you compile a call to such a function prototype with clang
> > > > > > with -O0 the compiler will try to load the function's address in a
> > > > > > register and then emit an invalid BPF instruction:
> > > > > >
> > > > > >   28:   8d 00 00 00 03 00 00 00         *unknown*
> > > > > >
> > > > > > On the other hand the kernel_helper attribute is bullet-proof: will work
> > > > > > with any optimization level, with any version of the compiler, and in
> > > > > > our opinion it is also more readable, more tidy and more correct.
> > > > > >
> > > > > > Note I'm not saying what you do in clang is not reasonable; it may be,
> > > > > > obviously it works well enough for you in practice.  Only that we have
> > > > > > good reasons for doing it differently in GCC.
> > > > >
> > > > > Not questioning the validity of the reasons, but they created
> > > > > the unnecessary difference between compilers.
> > > >
> > > > Sounds to me like clang is relying on an unreliable hack that may
> > > > be difficult to implement in GCC, so let's see what's the best option
> > > > moving forwards in terms of a migration path for both GCC and clang.
> > >
> > > The following is a valid C code:
> > > static long (*foo) (void) = (void *) 1234;
> > > foo();
> > >
> > > and GCC has to generate correct assembly assuming it runs at -O1 or higher.
> >
> > Providing -O1 or higher with gcc-bpf does not seem to work at the moment.
>
> Let's fix gcc first.

If the intention is to migrate to kernel_helper for clang as well it
seems kind of
redundant, is there a real world use case for supporting the '(void *)
1' style in
GCC rather than just adding feature detection+kernel_helper support to libbpf?

My assumption is that kernel helpers are in practice always used via libbpf
which appears to be sufficient in terms of being able to provide a compatibility
layer via feature detection. Or is there some use case I'm missing here?

>
> > > There is no indirect call insn defined in BPF ISA yet,
> > > so the -O0 behavior is undefined.
> >
> > Well GCC at least seems to be able to compile BPF programs with -O0 using
> > kernel_helper. I assume -O0 is probably just targeting the minimum BPF ISA
> > optimization level or something like that which avoids indirect calls.
>
> There are other reasons why -O0 compiled progs will
> fail in the verifier.

Why would -O0 generate code that isn't compatible with the selected
target BPF ISA?
I mean according to GCC docs "-O0 means (almost) no optimization":
https://gcc.gnu.org/onlinedocs/gnat_ugn/Optimization-Levels.html

My understanding is that -O0 does not actually mean no optimization in practice.

>
> > >
> > > > Or we can just feature detect kernel_helper and leave the (void *)1 style
> > > > fallback in place until we drop support for clang variants that don't support
> > > > kernel_helper. This would provide GCC compatibility and a better migration
> > > > path for clang as well as clang will then automatically use the new variant
> > > > whenever support for kernel_helper is introduced.
> > >
> > > Support for valid C code will not be dropped from clang.
> >
> > That wasn't what I was suggesting, I was suggesting adding support for
> > kernel_helper to clang, and then in the future libbpf(not clang) can
> > drop support
> > for the (void *)1 style in the future if desired(or can just keep the
> > fallback). By
> > feature detecting kernel_helper and providing a fallback we get a nice clean
> > migration path.
>
> Makes sense. That deprecation step is far away though.

Sure, feature detection/fallback would probably make sense to keep indefinitely
or until libbpf drops support entirely for non-kernel_helper clang versions for
other reasons.

> Assuming that kernel_helper attr is actually necessary
> we have to add its support to clang as well.

I mean, I'd argue there's a difference between something being arguably a better
alternative(optional) and actually being necessary(non-optional).

> We have to keep compilers in sync.

The end goal here IMO is kernel helper implementation convergence, since
it's fairly trivial to support both via feature detection the one that we want
the implementations to converge to is the one that's most important for both
compilers to support.

> gcc-bpf is a niche. If gcc devs want it to become a real
> alternative to clang they have to always aim for feature parity
> instead of inventing their own ways of doing things.

What's ultimately going to help the most in regards to helping gcc-bpf reach
feature parity with clang is getting it minimally usable in the real
world, because
that's how you're going to get more people testing+fixing bugs so that all these
differences/incompatibilities can be worked though/fixed.

If nobody can compile a real world BPF program with gcc-bpf it's likely going to
lag further behind. There's a lot of ecosystem
tooling/infrastructure(build system
support and such) that needs to add support for it as well and that
ends up being
rather difficult without at least a minimally functional toolchain.
For example I've
been working on integrating gcc-bpf into
buildroot(https://buildroot.org/)'s cross
compilation toolchain infrastructure which will then get tested in our
autobuilder
CI(http://autobuild.buildroot.net/) which tends to help surface a lot
of obscure bugs
and incompatibilities.

With embedded system cpu architecture support using clang toolchains tend to
lag behind GCC in general so getting gcc-bpf working there is
helpful(and reduces
the need for larger and more complex hybrid clang/gcc toolchain setups/builds).
