Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C0355D219
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238130AbiF0VvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 17:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239028AbiF0VvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 17:51:08 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D169E199;
        Mon, 27 Jun 2022 14:51:07 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id g26so21869034ejb.5;
        Mon, 27 Jun 2022 14:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HjkSjk+quHsIJAc8+Pm/a2ht8JUXLV90rAzj2FC4Qwk=;
        b=dwFFoA1Dpr93AYox32+CQZDIUYUaa1GZ/NhrtMx8JXXqHiQgRmLxcSAmH5NrDGB3HC
         knnRepvFI52d6RkjCrW/SYxKV2H6jzhdDh+mTTl/FFB/tGRjI/B97ORFehvQLk9sCjVr
         rsLaf7/8DmA9bR3Ta06989ddwwr+J4WiRbvgeh1qhHrdV+rJWTvIYWld4rYselxwmMoO
         0tPntf6p3ntyjXm4eMgO6syiR8G0Sla8flN2GBr+s+Dw/AnzVjzAijGQgW7M2BpwrgG3
         rjLeZDg9R/Ip2CBzCkSB2zNUlKRTVJVvliJufVEuQrcoaw3Gsd3HrhlKyCXXnlD2FSww
         Q2bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HjkSjk+quHsIJAc8+Pm/a2ht8JUXLV90rAzj2FC4Qwk=;
        b=BKQv6hS6+SR/zLa6KdwhF1ae8uvLrVgpeqKNsD2WSGQ6i5rfLj59zWIlPVrwUCgyX5
         oN5zlPTtMkNahnUDBz47td8n3SIowL00tq0kRjmDsGjNR+b9xMFyfE4ZpNYH7pMPDj/a
         eMwfXmNJmuMQDb0qJTy0UvhAwOgkj+2DZxgo2B9BGyKkh0Lxn5bAbCUBjnZ+9g38pTIU
         oXW2eDu2QsVcaSZwW0elly0as3fXhad1bYgVI0D8ygPLcji6oyRn2Kd15kFxuz3oaeb/
         9A6+06ESzhwmZ8LplKz5OnQF2vAvOX55Ur+RBirBHGZNTZFFdh31d9o9Zj1t19QDwP9N
         LxWg==
X-Gm-Message-State: AJIora8CLRGj5xXehqoDRkXKITyAyvcBkKKqHO7vM2ol0+Lx4G1f5krb
        SeTMS6u9eWyF0kBidIXEYSxxw6Lm/k4bPtSZmdY=
X-Google-Smtp-Source: AGRyM1s43Gq74FIkRk0wywnJq6s8KS2UC07pJfnzyrIMfkPDTbi1zFeCYKux4Qb2Gr9Xzk0vKLs4YmNdCV3C41QmiVg=
X-Received: by 2002:a17:906:a3ca:b0:726:2bd2:87bc with SMTP id
 ca10-20020a170906a3ca00b007262bd287bcmr14828902ejb.226.1656366665820; Mon, 27
 Jun 2022 14:51:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220609062829.293217-1-james.hilliard1@gmail.com>
 <CAEf4BzaNBcW8ZDWcH5USd9jFshFF78psAjn2mqZp6uVGn0ZK+g@mail.gmail.com> <CADvTj4oBy3nP3s2BaN_+75dYfkq2x72wG3dC3K09osRzkcw2eA@mail.gmail.com>
In-Reply-To: <CADvTj4oBy3nP3s2BaN_+75dYfkq2x72wG3dC3K09osRzkcw2eA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Jun 2022 14:50:53 -0700
Message-ID: <CAEf4BzYxT4QRfJToez1MiK8OOtSdcG6iAgpY8AGe8WsL34EvRA@mail.gmail.com>
Subject: Re: [PATCH 1/1] libbpf: replace typeof with __typeof__ for -std=c17 compatibility
To:     James Hilliard <james.hilliard1@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
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

On Thu, Jun 9, 2022 at 4:46 PM James Hilliard <james.hilliard1@gmail.com> wrote:
>
> On Thu, Jun 9, 2022 at 12:11 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Jun 8, 2022 at 11:28 PM James Hilliard
> > <james.hilliard1@gmail.com> wrote:
> > >
> > > Fixes errors like:
> > > error: expected specifier-qualifier-list before 'typeof'
> > >    14 | #define __type(name, val) typeof(val) *name
> > >       |                           ^~~~~~
> > > ../src/core/bpf/socket_bind/socket-bind.bpf.c:25:9: note: in expansion of macro '__type'
> > >    25 |         __type(key, __u32);
> > >       |         ^~~~~~
> > >
> > > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> > > ---
> >
> > If you follow DPDK link you gave me ([0]), you'll see that they ended up doing
> >
> > #ifndef typeof
> > #define typeof __typeof__
> > #endif
> >
> > It's way more localized. Let's do that.
>
> Won't that potentially leak the redefinition into external code including the
> header file?

all this is in BPF-side helpers and we add a bunch of other "common"
definitions like barrier(), offsetof(), etc. So I think this is
acceptable, at least for now (and users will be able to override this
due to #ifndef check, right?)

>
> I don't see a redefinition of typeof like that used elsewhere in the kernel.

kernel is just happily using much cleaner looking typeof() almost
universally, though

$ rg -w typeof ~/linux/include | wc -l
401
$ rg -w __typeof__ ~/linux/include | wc -l
28

>
> However I do see __typeof__ used in many headers already so that approach
> seems to follow normal conventions and seems less risky.
>
> FYI using -std=gnu17 instead of -std=c17 works around this issue with bpf-gcc
> at least so this issue isn't really a blocker like the SEC macro
> issue, I had just
> accidentally mixed the two issues up due to accidentally not clearing out some
> header files when testing, they seem to be entirely separate.
>
> >
> > But also I tried to build libbpf-bootstrap with -std=c17 and
> > immediately ran into issue with asm, so we need to do the same with
> > asm -> __asm__. Can you please update your patch and fix both issues?
>
> Are you hitting that with clang/llvm or bpf-gcc? It doesn't appear that the
> libbpf-bootstrap build system is set up to build with bpf-gcc yet.
>

I didn't realize you were using bpf-gcc, sorry. I was testing with clang.

> >
> >   [0] https://patches.dpdk.org/project/dpdk/patch/2601191342CEEE43887BDE71AB977258213F3012@irsmsx105.ger.corp.intel.com/
> >   [1] https://github.com/libbpf/libbpf-bootstrap
> >
> >
> > >  tools/lib/bpf/bpf_core_read.h   | 16 ++++++++--------
> > >  tools/lib/bpf/bpf_helpers.h     |  4 ++--
> > >  tools/lib/bpf/bpf_tracing.h     | 24 ++++++++++++------------
> > >  tools/lib/bpf/btf.h             |  4 ++--
> > >  tools/lib/bpf/libbpf_internal.h |  6 +++---
> > >  tools/lib/bpf/usdt.bpf.h        |  6 +++---
> > >  tools/lib/bpf/xsk.h             | 12 ++++++------
> > >  7 files changed, 36 insertions(+), 36 deletions(-)
> > >
> >
> > [...]
