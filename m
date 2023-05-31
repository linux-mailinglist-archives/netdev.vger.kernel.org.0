Return-Path: <netdev+bounces-6796-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DFE37718122
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:11:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96A162814C1
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 13:11:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6B7A14294;
	Wed, 31 May 2023 13:11:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF6912B8C;
	Wed, 31 May 2023 13:11:05 +0000 (UTC)
Received: from mail-yw1-x1142.google.com (mail-yw1-x1142.google.com [IPv6:2607:f8b0:4864:20::1142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA92D9;
	Wed, 31 May 2023 06:11:04 -0700 (PDT)
Received: by mail-yw1-x1142.google.com with SMTP id 00721157ae682-565aa2cc428so48690577b3.1;
        Wed, 31 May 2023 06:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685538663; x=1688130663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YMHNxtLliZ2AvZ7BdWhgd9VB7EbsZ/iFVPRdfnAvAIs=;
        b=FErNm+WvV6cZHL75kBQyo2UBm9dre99Bc4zbXu1EsL86LWG/M1G9jhs49GXQorpayQ
         LEbTVwOGVskxVKJjr6KqoqEXkxC+gCWd2VpGLyIxS/t7VYWRW6Q/B0ElLGT2H+STbq8H
         6YMUDb333LuJKwLV9PfjlomlcZ7bns6zPqXhjzXZT20v9ZzAqczpbOnPsk8VCsFuX+IO
         cQmrtCQW6c4TBX3ms+ZY/Cqv8IV21/q08GvuMot/9UJgleQaeupdYAj+Y5YbBvXwhG8d
         ZuGDTYC9JtpUe4g08lfSvENlyoDbvilNr602dLEtXm4wihlhJl+oCa4Zmt22LcLspH/c
         e7Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685538663; x=1688130663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YMHNxtLliZ2AvZ7BdWhgd9VB7EbsZ/iFVPRdfnAvAIs=;
        b=IW443/tYyzKYrwYJGaUnOj5weyYbXo8BlGM+mII02Lk4h45cGQg2WBAObnUAWrguU0
         5QcQ83H8nmaLolDQfksvjPYwTZUPvJmUfcdjs+ypA26U4NnZi8IwRicSu4tcoeTIxgBd
         ZJ7rkiXhbcYeEf2I8Zax1alaf29q8hExgHmdJfYin3sU1cyC3faZ0wQ6WjnuSij5iT9U
         4yfTdyfYo0R9y/CDDP4olp2JrjxRZD86izUdi6LE4BTXsIfHqjfxOHNlVpuIF41DgIaK
         7I/Z2v93Sn96gj3MEGbctvxvAG2MmSG9fZQ59fT6oYENEoIF/A1T6MLn7tQ5GEuFToN3
         01Tw==
X-Gm-Message-State: AC+VfDzN9fNjyCFJRjahUWF0kVHznSbK8MxpS/LoHSAyzVztQgaeEbeH
	Hk7Wemsx6XnKX6Gc2D+LUjmbktnzth+GlPtRaRY=
X-Google-Smtp-Source: ACHHUZ5QdMRj9Z/EbvvuGzuIS47cw5z10AgGLopA2qlZgNO3cBUb8yYvOMdlQnABnmxTs2+jGbu1jfk/BE0kwkrQnAY=
X-Received: by 2002:a25:ca86:0:b0:bb1:38a:f0b with SMTP id a128-20020a25ca86000000b00bb1038a0f0bmr5282809ybg.65.1685538663191;
 Wed, 31 May 2023 06:11:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530044423.3897681-1-imagedong@tencent.com>
 <ZHb+ypjE4Ybg3O18@krava> <CADxym3biE8WcMxWf1wok+s4pBYEi6+fYQAbZJVxm7eBfzWLjLQ@mail.gmail.com>
 <34fb3a9841bf4977413be799f7cbef78560aaa20.camel@gmail.com>
In-Reply-To: <34fb3a9841bf4977413be799f7cbef78560aaa20.camel@gmail.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Wed, 31 May 2023 21:10:51 +0800
Message-ID: <CADxym3YuGnoPpxUx92ZZqhi4z8t-hHQaKfah=9k6L-YiTg+Jjw@mail.gmail.com>
Subject: Re: [PATCH] bpf, x86: allow function arguments up to 12 for TRACING
To: Eduard Zingerman <eddyz87@gmail.com>
Cc: Jiri Olsa <olsajiri@gmail.com>, dsahern@kernel.org, andrii@kernel.org, 
	davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net, 
	martin.lau@linux.dev, song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, 
	kpsingh@kernel.org, sdf@google.com, haoluo@google.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, netdev@vger.kernel.org, bpf@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 8:02=E2=80=AFPM Eduard Zingerman <eddyz87@gmail.com=
> wrote:
>
> On Wed, 2023-05-31 at 17:03 +0800, Menglong Dong wrote:
> > On Wed, May 31, 2023 at 4:01=E2=80=AFPM Jiri Olsa <olsajiri@gmail.com> =
wrote:
> > >
> > > On Tue, May 30, 2023 at 12:44:23PM +0800, menglong8.dong@gmail.com wr=
ote:
> > > > From: Menglong Dong <imagedong@tencent.com>
> > > >
> > > > For now, the BPF program of type BPF_PROG_TYPE_TRACING can only be =
used
> > > > on the kernel functions whose arguments count less than 6. This is =
not
> > > > friendly at all, as too many functions have arguments count more th=
an 6.
> > > >
> > > > Therefore, let's enhance it by increasing the function arguments co=
unt
> > > > allowed in arch_prepare_bpf_trampoline(), for now, only x86_64.
> > > >
> > > > For the case that we don't need to call origin function, which mean=
s
> > > > without BPF_TRAMP_F_CALL_ORIG, we need only copy the function argum=
ents
> > > > that stored in the frame of the caller to current frame. The argume=
nts
> > > > of arg6-argN are stored in "$rbp + 0x18", we need copy them to
> > > > "$rbp - regs_off + (6 * 8)".
> > > >
> > > > For the case with BPF_TRAMP_F_CALL_ORIG, we need prepare the argume=
nts
> > > > in stack before call origin function, which means we need alloc ext=
ra
> > > > "8 * (arg_count - 6)" memory in the top of the stack. Note, there s=
hould
> > > > not be any data be pushed to the stack before call the origin funct=
ion.
> > > > Then, we have to store rbx with 'mov' instead of 'push'.
> > > >
> > > > It works well for the FENTRY and FEXIT, I'm not sure if there are o=
ther
> > > > complicated cases.
> > > >
> > > > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > > > ---
> > > >  arch/x86/net/bpf_jit_comp.c | 88 ++++++++++++++++++++++++++++++++-=
----
> > >
> > > please add selftests for this.. I had to add one to be able to check
> > > the generated trampoline
> > >
> >
> > Okay!
> >
> > BTW, I failed to compile the latest selftests/bpf with
> > the following errors:
> >
> > progs/verifier_and.c:58:16: error: invalid operand for instruction
> >         asm volatile ("                                 \
> >
>
> These tests were moved to use inline assembly recently (2 month ago).
> Discussion at the time was whether to use \n\ or \ terminators at the
> end of each line. People opted for \ as easier to read.
> Replacing \ with \n\ and compiling this test using clang 14 shows
> more informative error message:
>
> $ make -j14 `pwd`/verifier_and.bpf.o
>   CLNG-BPF [test_maps] verifier_and.bpf.o
> progs/verifier_and.c:68:1: error: invalid operand for instruction
>         w1 %%=3D 2;                                       \n\
> ^
> <inline asm>:11:5: note: instantiated into assembly here
>         w1 %=3D 2;
>
> My guess is that clang 14 does not know how to handle operations on
> 32-bit sub-registers w[0-9].
>
> But using clang 14 I get some errors not related to inline assembly as we=
ll.
> Also, I recall that there were runtime issues with clang 14 and
> tests using enum64.
>
> All-in-all, you need newer version of clang for tests nowadays,
> sorry for inconvenience.

Thanks for your explanation! It works well after I
update my clang to a newer version.

Menglong Dong
>
> > The version of clang I used is:
> >
> > clang --version
> > Debian clang version 14.0.6
> > Target: x86_64-pc-linux-gnu
> > Thread model: posix
> > InstalledDir: /usr/bin
> >
> > Does anyone know the reason?
> >
> > Thanks!
> > Menglong Dong
> >
> > > jirka
> > >
> > >
> >
>

