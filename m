Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E3C572AB4
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 03:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiGMBS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 21:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiGMBS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 21:18:57 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498802251A;
        Tue, 12 Jul 2022 18:18:56 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id o3-20020a17090a744300b001ef8f7f3dddso1105164pjk.3;
        Tue, 12 Jul 2022 18:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i4p6sm+Eaw9H7Av5dxRsvpT90Zq1tawHBOllyyWvACc=;
        b=OLRPCA998W2mo1p8Be6KjHk7nFx2CLbdGrEeS0v29zc77Y1qCAjdoEZgP2/WhRwCzJ
         KTwIFCXaJ4HSojneMaX2p9Agmu70nr1IdUWo7SGn5cfKEaDJMa6jP/Qj53GVCH7Ofiry
         NXsdsAGTogVQzlCX7YxhxAoWhsXR27znvdS3qoDF0Lc010cUX3/RQUqRlpTbBTd535qb
         jnccZRO9MdwdQE4CL6ypDJn+hUTUGuy9Z1mUVtINPzdg1Ks7j4pDaMaYg9RowIu+NLOs
         fs2YESYSZB6YT23o0tPkakwwc6xbK7MYY/MHmkm7IuokJDQBxLEDGFH8cCykymnJOoD4
         m5Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i4p6sm+Eaw9H7Av5dxRsvpT90Zq1tawHBOllyyWvACc=;
        b=fAgQFVxfKaLqZkem5WHRnoFx01JdwRfUN4B1ineEKv8eTJIo5cxMgLwcThBPm1r+ig
         LV0I60zTVLCrO9G0bdHhqMu2SVLcZdIKJbe7Xah9e4uBAF8gtFmmaJfvHcGZQjh5dkEg
         EbtdE75hdNvJUcR93XEF/B4iEffCbqXIpvt9HM31G6TLdIS9DPkEw6efVBe8jRVD/dFf
         MAYIBRZArqKVl2sZFibQPWSkONHEkjsbyS4ox5HBU8D6RgoJ0+yjo3xqsNQoZgs8I1uG
         OZS8CEUqMuX0pI0FprSLTOKTW8WgEAr8PTAJNRhE7zp10iUgQP5zIUah2o4zmSyZ/YbA
         Y2xA==
X-Gm-Message-State: AJIora87DCaEkd3QgaokbGoPK76XuUonEGC47+QnoLB+gZcxZYCHkgN2
        xGVerzBMmZxrHQZt5HH9v24=
X-Google-Smtp-Source: AGRyM1s8e7UcOBYXjxFH2HF0arrPOwvEfqutFDCXqptOH9tFr1rcvXYFHeqFmW2NSPgrDSVLE3th6w==
X-Received: by 2002:a17:90b:4a04:b0:1ef:c318:ef9c with SMTP id kk4-20020a17090b4a0400b001efc318ef9cmr7313697pjb.67.1657675135536;
        Tue, 12 Jul 2022 18:18:55 -0700 (PDT)
Received: from macbook-pro-3.dhcp.thefacebook.com ([2620:10d:c090:400::5:580c])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902c3c400b0016bf24611e7sm7478169plj.5.2022.07.12.18.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 18:18:55 -0700 (PDT)
Date:   Tue, 12 Jul 2022 18:18:51 -0700
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
Message-ID: <20220713011851.4a2tnqhdd5f5iwak@macbook-pro-3.dhcp.thefacebook.com>
References: <20220706172814.169274-1-james.hilliard1@gmail.com>
 <a0bddf0b-e8c4-46ce-b7c6-a22809af1677@fb.com>
 <CADvTj4ovwExtM-bWUpJELy-OqsT=J9stmqbAXto8ds2n+G8mfw@mail.gmail.com>
 <CAEf4BzYwRyXG1zE5BK1ZXmxLh+ZPU0=yQhNhpqr0JmfNA30tdQ@mail.gmail.com>
 <87v8s260j1.fsf@oracle.com>
 <CAADnVQLQGHoj_gCOvdFFw2pRxgMubPSp+bRpFeCSa5zvcK2qRQ@mail.gmail.com>
 <CADvTj4qqxckZmxvL=97e-2W5M4DgCCMDV8RCFDg23+cY2URjTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvTj4qqxckZmxvL=97e-2W5M4DgCCMDV8RCFDg23+cY2URjTA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 07:10:27PM -0600, James Hilliard wrote:
> On Tue, Jul 12, 2022 at 10:48 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Jul 12, 2022 at 4:20 AM Jose E. Marchesi
> > <jose.marchesi@oracle.com> wrote:
> > >
> > >
> > > > CC Quentin as well
> > > >
> > > > On Mon, Jul 11, 2022 at 5:11 PM James Hilliard
> > > > <james.hilliard1@gmail.com> wrote:
> > > >>
> > > >> On Mon, Jul 11, 2022 at 5:36 PM Yonghong Song <yhs@fb.com> wrote:
> > > >> >
> > > >> >
> > > >> >
> > > >> > On 7/6/22 10:28 AM, James Hilliard wrote:
> > > >> > > The current bpf_helper_defs.h helpers are llvm specific and don't work
> > > >> > > correctly with gcc.
> > > >> > >
> > > >> > > GCC appears to required kernel helper funcs to have the following
> > > >> > > attribute set: __attribute__((kernel_helper(NUM)))
> > > >> > >
> > > >> > > Generate gcc compatible headers based on the format in bpf-helpers.h.
> > > >> > >
> > > >> > > This adds conditional blocks for GCC while leaving clang codepaths
> > > >> > > unchanged, for example:
> > > >> > >       #if __GNUC__ && !__clang__
> > > >> > >       void *bpf_map_lookup_elem(void *map, const void *key)
> > > >> > > __attribute__((kernel_helper(1)));
> > > >> > >       #else
> > > >> > >       static void *(*bpf_map_lookup_elem)(void *map, const void *key) = (void *) 1;
> > > >> > >       #endif
> > > >> >
> > > >> > It does look like that gcc kernel_helper attribute is better than
> > > >> > '(void *) 1' style. The original clang uses '(void *) 1' style is
> > > >> > just for simplicity.
> > > >>
> > > >> Isn't the original style going to be needed for backwards compatibility with
> > > >> older clang versions for a while?
> > > >
> > > > I'm curious, is there any added benefit to having this special
> > > > kernel_helper attribute vs what we did in Clang for a long time?
> > > > Did GCC do it just to be different and require workarounds like this
> > > > or there was some technical benefit to this?
> > >
> > > We did it that way so we could make trouble and piss you off.
> > >
> > > Nah :)
> > >
> > > We did it that way because technically speaking the clang construction
> > > works relying on particular optimizations to happen to get correct
> > > compiled programs, which is not guaranteed to happen and _may_ break in
> > > the future.
> > >
> > > In fact, if you compile a call to such a function prototype with clang
> > > with -O0 the compiler will try to load the function's address in a
> > > register and then emit an invalid BPF instruction:
> > >
> > >   28:   8d 00 00 00 03 00 00 00         *unknown*
> > >
> > > On the other hand the kernel_helper attribute is bullet-proof: will work
> > > with any optimization level, with any version of the compiler, and in
> > > our opinion it is also more readable, more tidy and more correct.
> > >
> > > Note I'm not saying what you do in clang is not reasonable; it may be,
> > > obviously it works well enough for you in practice.  Only that we have
> > > good reasons for doing it differently in GCC.
> >
> > Not questioning the validity of the reasons, but they created
> > the unnecessary difference between compilers.
> 
> Sounds to me like clang is relying on an unreliable hack that may
> be difficult to implement in GCC, so let's see what's the best option
> moving forwards in terms of a migration path for both GCC and clang.

The following is a valid C code:
static long (*foo) (void) = (void *) 1234;
foo();

and GCC has to generate correct assembly assuming it runs at -O1 or higher.
There is no indirect call insn defined in BPF ISA yet,
so the -O0 behavior is undefined.

> Or we can just feature detect kernel_helper and leave the (void *)1 style
> fallback in place until we drop support for clang variants that don't support
> kernel_helper. This would provide GCC compatibility and a better migration
> path for clang as well as clang will then automatically use the new variant
> whenever support for kernel_helper is introduced.

Support for valid C code will not be dropped from clang.
