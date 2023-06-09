Return-Path: <netdev+bounces-9418-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 55E9A728E13
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 04:34:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EDEB1C20898
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 02:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA44EA6;
	Fri,  9 Jun 2023 02:34:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2F77E5;
	Fri,  9 Jun 2023 02:34:45 +0000 (UTC)
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F81F1993;
	Thu,  8 Jun 2023 19:34:44 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id d75a77b69052e-3f9c2e3914aso9544051cf.3;
        Thu, 08 Jun 2023 19:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686278083; x=1688870083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YkLcX6B6WSlNdg/K0cMsRbNItTJ8LTlhdnmPvGk8+4E=;
        b=iqdVVzSiVHpUjKb/j+Dwp26pCM/IcL7+wiS2XORZFeatoH9ZipAomeJAzWv0URa/Cw
         1o15Ral2iftlE4iZdwVyY+OkF53jiT8YAXpxzRgQjAoaUXESCj8hCzJyldFaNLbB3lci
         2QTuoVB9KAB+XYiabxB3I+EEzkWZiXr/PU9O05CwDxjb/ONVIjUqMXIJRgDYG/c2v0wY
         lQd8rcV0+z3U4yWEseoSf6f9x89vLUll3ZjeIQWFrgva/LWHmvHLkHRVoZv6boK68ucF
         V1pyb2XUBFNI5siqYqV0q3oZ8Kl/js/LCMenoOBq8JTbuuLVZreRj8hHjK8ccHZ2RdoF
         NorQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686278083; x=1688870083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YkLcX6B6WSlNdg/K0cMsRbNItTJ8LTlhdnmPvGk8+4E=;
        b=hD+SJsewWR5wcNvtwZWHSjxcatJryKxk0zApq1GtpUnUD+IIlZOOTpTgzCoxFvS/Yz
         cxHRqSoe2AyENjsMgvEzxNvtBk6xfgzeZtK0Yam/mlau2mGPRtVu0YyV1l7RxOEBybJj
         HAwhUGge4rgaeSV3QSojNz1OY5KKULGu2qoKsBEuiUf9gA3deh2+OYoAnDcknu3NkJEy
         UBG1oN/3rsqdQIv0LlmhdCjVg7xZ16lG4+idsIiBbQ4a4eslw+zpEsxvv9/wOlQgn+W/
         tvqxlaFxRHiQ7Ijr9ZhdVFA8xcTkxB8YmgZR6S3xVB9iJkU8WB4OMTPGBKVnMRH9xV8U
         TWuw==
X-Gm-Message-State: AC+VfDwr+aqYfOkEWJpzODdA+ar7npVuynXJmGMs9XE0kO3Svb64vkA/
	gxRZNTzbilHauyg9KFn6mWRhsnSCLBu76nqJ4L+WQXeB19DT8QYa
X-Google-Smtp-Source: ACHHUZ4KM2xWMmwOMrRL2HoBURxXB8RhziHa5Tlm0Qa5gS6GMsIPAfQDmDiKNbVBLkqdCJZXHomFOF6meU4TlSjxmHk=
X-Received: by 2002:a05:622a:85:b0:3f5:3851:873f with SMTP id
 o5-20020a05622a008500b003f53851873fmr311290qtw.8.1686278083524; Thu, 08 Jun
 2023 19:34:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230607125911.145345-1-imagedong@tencent.com>
 <20230607125911.145345-2-imagedong@tencent.com> <20230607200905.5tbosnupodvydezq@macbook-pro-8.dhcp.thefacebook.com>
 <CADxym3abYOZ5JVa4FP5R-Vi7HAk=n_0vTmMGveDH8xvFtuaBDw@mail.gmail.com> <2fb8c454-1ae7-27cd-a9fa-0d8dda18a900@meta.com>
In-Reply-To: <2fb8c454-1ae7-27cd-a9fa-0d8dda18a900@meta.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Fri, 9 Jun 2023 10:34:32 +0800
Message-ID: <CADxym3Y03+n+pDupWbdrFtXU96vsWR6h40PSrVC+jJzwov=A5Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/3] bpf, x86: allow function arguments up to
 12 for TRACING
To: Yonghong Song <yhs@meta.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, davem@davemloft.net, dsahern@kernel.org, 
	ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, 
	sdf@google.com, x86@kernel.org, imagedong@tencent.com, benbjiang@tencent.com, 
	netdev@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 9, 2023 at 5:12=E2=80=AFAM Yonghong Song <yhs@meta.com> wrote:
>
>
>
> On 6/7/23 8:17 PM, Menglong Dong wrote:
> > On Thu, Jun 8, 2023 at 4:09=E2=80=AFAM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> >>
> >> On Wed, Jun 07, 2023 at 08:59:09PM +0800, menglong8.dong@gmail.com wro=
te:
> >>> From: Menglong Dong <imagedong@tencent.com>
> >>>
> >>> For now, the BPF program of type BPF_PROG_TYPE_TRACING can only be us=
ed
> >>> on the kernel functions whose arguments count less than 6. This is no=
t
> >>> friendly at all, as too many functions have arguments count more than=
 6.
> >>>
> >>> Therefore, let's enhance it by increasing the function arguments coun=
t
> >>> allowed in arch_prepare_bpf_trampoline(), for now, only x86_64.
> >>>
> >>> For the case that we don't need to call origin function, which means
> >>> without BPF_TRAMP_F_CALL_ORIG, we need only copy the function argumen=
ts
> >>> that stored in the frame of the caller to current frame. The argument=
s
> >>> of arg6-argN are stored in "$rbp + 0x18", we need copy them to
> >>> "$rbp - regs_off + (6 * 8)".
> >>>
> >>> For the case with BPF_TRAMP_F_CALL_ORIG, we need prepare the argument=
s
> >>> in stack before call origin function, which means we need alloc extra
> >>> "8 * (arg_count - 6)" memory in the top of the stack. Note, there sho=
uld
> >>> not be any data be pushed to the stack before call the origin functio=
n.
> >>> Then, we have to store rbx with 'mov' instead of 'push'.
> >>
> >> x86-64 psABI requires stack to be 16-byte aligned when args are passed=
 on the stack.
> >> I don't see this logic in the patch.
> >
> > Yeah, it seems I missed this logic......:)
> >
> > I have not figure out the rule of the alignment, but after
> > observing the behavior of the compiler, the stack seems
> > should be like this:
> >
> > ------ stack frame begin
> > rbp
> >
> > xxx   -- this part should be aligned in 16-byte
> >
> > ------ end of arguments in stack
> > xxx
> > ------ begin of arguments in stack
> >
> > So the code should be:
> >
> > +       if (nr_regs > 6 && (flags & BPF_TRAMP_F_CALL_ORIG)) {
> > +                stack_size =3D ALIGN(stack_size, 16);
> > +                stack_size +=3D (nr_regs - 6) * 8;
> > +       }
> >
> > Am I right?
>
> This is the stack_size, you should ensure stack pointer is 16-byte aligne=
d.

Oh, I see. Considering the begin of the stack frame
should already be 16-byte aligned, what we should
do here is to make the size of the current stack frame
16-byte aligned. Then, rsp will be 16-byte aligned.

Am I right?

Which means the code should be:

+       if (nr_regs > 6 && (flags & BPF_TRAMP_F_CALL_ORIG)) {
+               stack_size +=3D (nr_regs - 6) * 8;
+               stack_size =3D ALIGN(stack_size, 16);
+       }

Then, the size of current stack frame will be:
stack_size + 8(rbp) + 8(rip)

This is the example that I refer to:
https://godbolt.org/z/7o9nh4nbc

>
> >
> > Thanks!
> > Menglong Dong

