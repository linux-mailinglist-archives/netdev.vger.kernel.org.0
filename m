Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44245572D06
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 07:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiGMFZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 01:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiGMFZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 01:25:46 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FEEDC18D;
        Tue, 12 Jul 2022 22:25:45 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-fe023ab520so12838045fac.10;
        Tue, 12 Jul 2022 22:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sPp3aq0xZox3YgcmSdjOtI+bv4N4Elhm3ft32O6ITtU=;
        b=Ze+BeJ0tPtuKyIdK9+nYuwG82J9kkGgHxSxb3fhFQSqz/IgTCMdlj+LG4nnRFLZ+Y1
         /Xfi49U8mCxM8UBHo+J0CbFdQGij738KNFD/RA+VOiWWtSJzXWwk2QMllMzz07S+gMfO
         KzuO0rBmFJfcjjmsn5I65gz9PZr6kD/J4iq7LeOXZHcBsTOU0AvLJQEfb9+PcoSqOHxt
         O8XfX2XSMTEsxVtGkitz1gvUSeSxRy5qr1Dw8z89vjerWeDuyqHag7FLZloD5UzOOLZX
         aKwP7j60DfTLdAtWSx+zppRFh0o/fG9p5P5m8hBHzkYz8yeUzo2gCavdIgSR38HE0JXY
         horA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sPp3aq0xZox3YgcmSdjOtI+bv4N4Elhm3ft32O6ITtU=;
        b=A37a+9hM/BXaSBVPkDxGSw8Eo5+WgA+bOj/FFGAd1jehTp+npcAyRy+KzuGThk0Z5q
         urd3ZoA90C0x1L5mpW5wc6qCxbuR2+JiaYZjikVQ7yYxgCBJ+Ti8Yg8uaXkJWpM5P/pQ
         PPnSscTqvoHJmYCB3Yh5mjgIVrU3X7H8xXd9/uLKBNWktT3IgAcpMU6A64WSQLluPcKz
         ZmjpKCJqCZ/t9J//9zZqkk76I8YhtjyiwbGi77ij21M9gEO2RIKdUGv+Fstb1wXJrcwI
         JHL/wbhS/OOuzMGNg3tbrjBC22HjmrP/hhBhdS0UupS5/ng2U2sG9ED2XX6Xr5vgOey8
         etew==
X-Gm-Message-State: AJIora+YK5TjfAIL8hEDJKAEiDUfrXItEbXvLZpcFDbu1HZZrozzm2Vu
        zr8KqLlCQ7/ej81Lc5J3LpaEUtbarjbUEzXzeOI=
X-Google-Smtp-Source: AGRyM1vQXFje4zdFVX9Smy3FQLg2cwpHs+aHjhTMwyS0O4HCACAauNpLvl6mm/3P02dEVw66PJRLsEqG86+roxnGbJc=
X-Received: by 2002:a05:6870:d0ce:b0:f3:3856:f552 with SMTP id
 k14-20020a056870d0ce00b000f33856f552mr914530oaa.99.1657689944976; Tue, 12 Jul
 2022 22:25:44 -0700 (PDT)
MIME-Version: 1.0
References: <a0bddf0b-e8c4-46ce-b7c6-a22809af1677@fb.com> <CADvTj4ovwExtM-bWUpJELy-OqsT=J9stmqbAXto8ds2n+G8mfw@mail.gmail.com>
 <CAEf4BzYwRyXG1zE5BK1ZXmxLh+ZPU0=yQhNhpqr0JmfNA30tdQ@mail.gmail.com>
 <87v8s260j1.fsf@oracle.com> <CAADnVQLQGHoj_gCOvdFFw2pRxgMubPSp+bRpFeCSa5zvcK2qRQ@mail.gmail.com>
 <CADvTj4qqxckZmxvL=97e-2W5M4DgCCMDV8RCFDg23+cY2URjTA@mail.gmail.com>
 <20220713011851.4a2tnqhdd5f5iwak@macbook-pro-3.dhcp.thefacebook.com>
 <CADvTj4o7z7J=4BOtKM9dthZyfFogV6hL5zKBwiBq7vs+bNhUHA@mail.gmail.com>
 <CAADnVQJAz7BcZjrBwu-8MjQprh86Z_UpWGMSQtFnowZTc4d6Vw@mail.gmail.com>
 <CADvTj4qtCfmsu=dMZx9LtaDMOSNsOxGVSa1g3USEWroA1AfTJA@mail.gmail.com> <20220713042549.uljgrp4lffianxyj@macbook-pro-3.dhcp.thefacebook.com>
In-Reply-To: <20220713042549.uljgrp4lffianxyj@macbook-pro-3.dhcp.thefacebook.com>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Tue, 12 Jul 2022 23:25:33 -0600
Message-ID: <CADvTj4qm5MyUtbHq6iOTiqDyJX=ra=ETOEVq-iXggzzEMhXJ8g@mail.gmail.com>
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

On Tue, Jul 12, 2022 at 10:25 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jul 12, 2022 at 08:56:35PM -0600, James Hilliard wrote:
> > On Tue, Jul 12, 2022 at 7:45 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Jul 12, 2022 at 6:29 PM James Hilliard
> > > <james.hilliard1@gmail.com> wrote:
> > > >
> > > > On Tue, Jul 12, 2022 at 7:18 PM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Tue, Jul 12, 2022 at 07:10:27PM -0600, James Hilliard wrote:
> > > > > > On Tue, Jul 12, 2022 at 10:48 AM Alexei Starovoitov
> > > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > > >
> > > > > > > On Tue, Jul 12, 2022 at 4:20 AM Jose E. Marchesi
> > > > > > > <jose.marchesi@oracle.com> wrote:
> > > > > > > >
> > > > > > > >
> > > > > > > > > CC Quentin as well
> > > > > > > > >
> > > > > > > > > On Mon, Jul 11, 2022 at 5:11 PM James Hilliard
> > > > > > > > > <james.hilliard1@gmail.com> wrote:
> > > > > > > > >>
> > > > > > > > >> On Mon, Jul 11, 2022 at 5:36 PM Yonghong Song <yhs@fb.com> wrote:
> > > > > > > > >> >
> > > > > > > > >> >
> > > > > > > > >> >
> > > > > > > > >> > On 7/6/22 10:28 AM, James Hilliard wrote:
> > > > > > > > >> > > The current bpf_helper_defs.h helpers are llvm specific and don't work
> > > > > > > > >> > > correctly with gcc.
> > > > > > > > >> > >
> > > > > > > > >> > > GCC appears to required kernel helper funcs to have the following
> > > > > > > > >> > > attribute set: __attribute__((kernel_helper(NUM)))
> > > > > > > > >> > >
> > > > > > > > >> > > Generate gcc compatible headers based on the format in bpf-helpers.h.
> > > > > > > > >> > >
> > > > > > > > >> > > This adds conditional blocks for GCC while leaving clang codepaths
> > > > > > > > >> > > unchanged, for example:
> > > > > > > > >> > >       #if __GNUC__ && !__clang__
> > > > > > > > >> > >       void *bpf_map_lookup_elem(void *map, const void *key)
> > > > > > > > >> > > __attribute__((kernel_helper(1)));
> > > > > > > > >> > >       #else
> > > > > > > > >> > >       static void *(*bpf_map_lookup_elem)(void *map, const void *key) = (void *) 1;
> > > > > > > > >> > >       #endif
> > > > > > > > >> >
> > > > > > > > >> > It does look like that gcc kernel_helper attribute is better than
> > > > > > > > >> > '(void *) 1' style. The original clang uses '(void *) 1' style is
> > > > > > > > >> > just for simplicity.
> > > > > > > > >>
> > > > > > > > >> Isn't the original style going to be needed for backwards compatibility with
> > > > > > > > >> older clang versions for a while?
> > > > > > > > >
> > > > > > > > > I'm curious, is there any added benefit to having this special
> > > > > > > > > kernel_helper attribute vs what we did in Clang for a long time?
> > > > > > > > > Did GCC do it just to be different and require workarounds like this
> > > > > > > > > or there was some technical benefit to this?
> > > > > > > >
> > > > > > > > We did it that way so we could make trouble and piss you off.
> > > > > > > >
> > > > > > > > Nah :)
> > > > > > > >
> > > > > > > > We did it that way because technically speaking the clang construction
> > > > > > > > works relying on particular optimizations to happen to get correct
> > > > > > > > compiled programs, which is not guaranteed to happen and _may_ break in
> > > > > > > > the future.
> > > > > > > >
> > > > > > > > In fact, if you compile a call to such a function prototype with clang
> > > > > > > > with -O0 the compiler will try to load the function's address in a
> > > > > > > > register and then emit an invalid BPF instruction:
> > > > > > > >
> > > > > > > >   28:   8d 00 00 00 03 00 00 00         *unknown*
> > > > > > > >
> > > > > > > > On the other hand the kernel_helper attribute is bullet-proof: will work
> > > > > > > > with any optimization level, with any version of the compiler, and in
> > > > > > > > our opinion it is also more readable, more tidy and more correct.
> > > > > > > >
> > > > > > > > Note I'm not saying what you do in clang is not reasonable; it may be,
> > > > > > > > obviously it works well enough for you in practice.  Only that we have
> > > > > > > > good reasons for doing it differently in GCC.
> > > > > > >
> > > > > > > Not questioning the validity of the reasons, but they created
> > > > > > > the unnecessary difference between compilers.
> > > > > >
> > > > > > Sounds to me like clang is relying on an unreliable hack that may
> > > > > > be difficult to implement in GCC, so let's see what's the best option
> > > > > > moving forwards in terms of a migration path for both GCC and clang.
> > > > >
> > > > > The following is a valid C code:
> > > > > static long (*foo) (void) = (void *) 1234;
> > > > > foo();
> > > > >
> > > > > and GCC has to generate correct assembly assuming it runs at -O1 or higher.
> > > >
> > > > Providing -O1 or higher with gcc-bpf does not seem to work at the moment.
> > >
> > > Let's fix gcc first.
> >
> > If the intention is to migrate to kernel_helper for clang as well it
> > seems kind of
> > redundant, is there a real world use case for supporting the '(void *)
> > 1' style in
> > GCC rather than just adding feature detection+kernel_helper support to libbpf?
> >
> > My assumption is that kernel helpers are in practice always used via libbpf
> > which appears to be sufficient in terms of being able to provide a compatibility
> > layer via feature detection. Or is there some use case I'm missing here?
>
> static long (*foo) (void) = (void *) 1234;
> is not about calling into "kernel helpers".
> There is no concept of "kernel" in BPF ISA.

I thought GCC at least had a somewhat kernel specific BPF ISA target,
I presume clang's bpf target is more generalized.

> 'call 1234' insn means call a function with that absolute address.
> The gcc named that attribute incorrectly.
> It should be renamed to something like __attribute__((fixed_address(1234))).
>
> It's a linux kernel abi choice to interpret 'call abs_addr' as a call to a kernel
> provided function at that address. 1,2,3,... are addresses of functions.

The impression I got was that GCC's BPF support was designed for targeting
the kernel ISA effectively, at least going off of the gcc-bpf docs gave me that
impression, although I might be wrong about that.

>
> > >
> > > > > There is no indirect call insn defined in BPF ISA yet,
> > > > > so the -O0 behavior is undefined.
> > > >
> > > > Well GCC at least seems to be able to compile BPF programs with -O0 using
> > > > kernel_helper. I assume -O0 is probably just targeting the minimum BPF ISA
> > > > optimization level or something like that which avoids indirect calls.
> > >
> > > There are other reasons why -O0 compiled progs will
> > > fail in the verifier.
> >
> > Why would -O0 generate code that isn't compatible with the selected
> > target BPF ISA?
>
> llvm has no issue producing valid BPF code with -O0.
> It's the kernel verifier that doesn't understand such code.
> For the following code:
> static long (*foo) (void) = (void *) 1234;
> long bar(void)
> {
>     return foo();
> }
>
> With -O[12] llvm will generate
>   call 1234
>   exit
> With -O0
>   r1 = foo ll
>   r1 = *(u64 *)(r1 + 0)
>   callx r1
>   exit
>
> Both codes are valid and equivalent.
> 'callx' here is a reserved insn. The kernel verifier doesn't know about it yet,
> but llvm was generting such code for 8+ years.

Hmm, I thought GCC gates non-kernel compatible BPF behind -mxbpf(for
use with GCC's internal test suite mostly AFAIU):
https://gcc.gnu.org/onlinedocs/gcc/eBPF-Options.html

>
> > > Assuming that kernel_helper attr is actually necessary
> > > we have to add its support to clang as well.
> >
> > I mean, I'd argue there's a difference between something being arguably a better
> > alternative(optional) and actually being necessary(non-optional).
>
> gcc's attribute is not better.
> It's just a different way to tell compiler about fixed function address.

I presume it's a lot simpler implementation wise than the clang
version, but I could
be wrong about that though. I mostly work with compiler integration testing and
build fixes, compiler internals are a bit out of my area of expertise.

>
> > > gcc-bpf is a niche. If gcc devs want it to become a real
> > > alternative to clang they have to always aim for feature parity
> > > instead of inventing their own ways of doing things.
> >
> > What's ultimately going to help the most in regards to helping gcc-bpf reach
> > feature parity with clang is getting it minimally usable in the real
> > world, because
> > that's how you're going to get more people testing+fixing bugs so that all these
> > differences/incompatibilities can be worked though/fixed.
>
> Can gcc-bpf compile all of selftests/bpf ?

Don't pretty much all of those use?:
#include <bpf/bpf_helpers.h>

Which doesn't really work without adding kernel_helper support to libbpf at the
moment when building with gcc-bpf.

> How many of compiled programs will pass the verifier ?

Not really sure, still been working through toolchain/build issues...kinda
tricky to do proper testing when those are all using clang specific headers.

Would be handy to get integration testing running against them with gcc-bpf
so that we can at least get a baseline in terms of what's working and catch
regressions when fixing compiler/toolchain issues, right now I think gcc-bpf is
mostly only using an internal test suite.

>
> > If nobody can compile a real world BPF program with gcc-bpf it's likely going to
> > lag further behind.
>
> selftest/bpf is a first milestone that gcc-bpf has to pass before talking about
> 'real world' bpf progs.

A test suite designed to exercise lots of edge cases isn't exactly a great first
milestone for something like this, something like the 3 small systemd BPF
programs on the other hand would be a good start IMO, since they are
widely used real world programs and relatively simple. They aren't going to
exercise all potential edge cases but they are a good starting point when it
comes to having say something for testing real world toolchain integrations
against(which is in really rough shape at the moment).

I mean even getting some normal-ish progs buildable without downstream
library patches would be a big improvement as one can then iterate a lot easier.

I mean, we're dealing with multiple issues here, some of which are more
toolchain/integration issues and others are compiler issues. If we can get
a little more integration testing going it's going to be easier to flush out the
remaining compiler issues. Kinda tricky to fix one without fixing the other.
