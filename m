Return-Path: <netdev+bounces-6782-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E55F7717F6D
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:02:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80E8B1C20E87
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A261F14291;
	Wed, 31 May 2023 12:02:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A90C8C5;
	Wed, 31 May 2023 12:02:35 +0000 (UTC)
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AEA0E5;
	Wed, 31 May 2023 05:02:34 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4f4f89f71b8so4482235e87.3;
        Wed, 31 May 2023 05:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685534552; x=1688126552;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+OqoXEp9byTnPWvb7ZYD/8jHmFgkssiOwA9B4Zryfxk=;
        b=Gd+FG9bbIXeedDVDn6grbngYZLz9qRsEEwyq0XY5v9iBqz7qxUQBxre7KF3K5jDNTF
         53NpLKbKYljeMO4fhGD0Tgust9dxpcmcvTA8MrG5m8d8GNLsI5U6hmufPIXuVYjQ7AKg
         qqZKndGtOSY+/cKZCaf5fRt5BcO5QnJFsAhlOxSSCkCACCitqg95k1dY/xTnblx5MmcE
         a3wFo5UDR58ZaLJAXfwI9okHWMALF1ZNOCawCPBMn/N45jzacjzx4z0I2GPGyELbfR+o
         wn2gLahAq5t7aTriEUgjQEO3B49Vwy7G08Y+NtnTiCWXdeXY+1rgNd1tHs/w38DFXQ9w
         gBBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685534552; x=1688126552;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+OqoXEp9byTnPWvb7ZYD/8jHmFgkssiOwA9B4Zryfxk=;
        b=VnJizC4SoLUr28s9mfiwJUJaHu2s50hqMp4eNIuuyTN+1WT/hOzcwCX+ikrn2FuzoK
         s0twOVmJBESmnp/9E6m6QabO+/vzbGfdFiIDj9vALjok3hft3e800p4ESKQdJgJ4NXLp
         40Hn7aTIXtW9js/rLaHEfRo107xRgJVQiSh8OkKYka8yxqvNLs9ZM2H5L8HZoo64PjJu
         gdiGbt6FMCeb2sCKFwnyZh63dCg4pFjC4AwKAe0OHzRxunq+qKGlnyV8CKnpArPxdfEd
         TP7TA7uwgYNZ/JhpjzJF2/uzr1229h5FLUJ6Fo/D2P5J+9AtZVCuKW11atSmp2PRO6wx
         3JKw==
X-Gm-Message-State: AC+VfDx9wbsboxu+XoR9RMBnQtHP6qWzRz0uACzHyJb+/41B/qP/RlUE
	JZvVUIe6izreUoMMt6PF+Bg=
X-Google-Smtp-Source: ACHHUZ4NDzU9U7SBybRM5oCjnlvhAJpbzub2cSUH58qR8pt3e/MPD/v4QgFftlsas1cN6HW8rDk54A==
X-Received: by 2002:a05:6512:102d:b0:4f3:bbfe:db4e with SMTP id r13-20020a056512102d00b004f3bbfedb4emr2239462lfr.56.1685534551943;
        Wed, 31 May 2023 05:02:31 -0700 (PDT)
Received: from [192.168.1.95] (host-176-36-0-241.b024.la.net.ua. [176.36.0.241])
        by smtp.gmail.com with ESMTPSA id f24-20020ac251b8000000b004f252a753e1sm691018lfk.22.2023.05.31.05.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 05:02:31 -0700 (PDT)
Message-ID: <34fb3a9841bf4977413be799f7cbef78560aaa20.camel@gmail.com>
Subject: Re: [PATCH] bpf, x86: allow function arguments up to 12 for TRACING
From: Eduard Zingerman <eddyz87@gmail.com>
To: Menglong Dong <menglong8.dong@gmail.com>, Jiri Olsa <olsajiri@gmail.com>
Cc: dsahern@kernel.org, andrii@kernel.org, davem@davemloft.net,
 ast@kernel.org,  daniel@iogearbox.net, martin.lau@linux.dev,
 song@kernel.org, yhs@fb.com,  john.fastabend@gmail.com, kpsingh@kernel.org,
 sdf@google.com, haoluo@google.com,  tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com,  x86@kernel.org, hpa@zytor.com,
 netdev@vger.kernel.org, bpf@vger.kernel.org,  linux-kernel@vger.kernel.org,
 Menglong Dong <imagedong@tencent.com>
Date: Wed, 31 May 2023 15:02:29 +0300
In-Reply-To: <CADxym3biE8WcMxWf1wok+s4pBYEi6+fYQAbZJVxm7eBfzWLjLQ@mail.gmail.com>
References: <20230530044423.3897681-1-imagedong@tencent.com>
	 <ZHb+ypjE4Ybg3O18@krava>
	 <CADxym3biE8WcMxWf1wok+s4pBYEi6+fYQAbZJVxm7eBfzWLjLQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 2023-05-31 at 17:03 +0800, Menglong Dong wrote:
> On Wed, May 31, 2023 at 4:01=E2=80=AFPM Jiri Olsa <olsajiri@gmail.com> wr=
ote:
> >=20
> > On Tue, May 30, 2023 at 12:44:23PM +0800, menglong8.dong@gmail.com wrot=
e:
> > > From: Menglong Dong <imagedong@tencent.com>
> > >=20
> > > For now, the BPF program of type BPF_PROG_TYPE_TRACING can only be us=
ed
> > > on the kernel functions whose arguments count less than 6. This is no=
t
> > > friendly at all, as too many functions have arguments count more than=
 6.
> > >=20
> > > Therefore, let's enhance it by increasing the function arguments coun=
t
> > > allowed in arch_prepare_bpf_trampoline(), for now, only x86_64.
> > >=20
> > > For the case that we don't need to call origin function, which means
> > > without BPF_TRAMP_F_CALL_ORIG, we need only copy the function argumen=
ts
> > > that stored in the frame of the caller to current frame. The argument=
s
> > > of arg6-argN are stored in "$rbp + 0x18", we need copy them to
> > > "$rbp - regs_off + (6 * 8)".
> > >=20
> > > For the case with BPF_TRAMP_F_CALL_ORIG, we need prepare the argument=
s
> > > in stack before call origin function, which means we need alloc extra
> > > "8 * (arg_count - 6)" memory in the top of the stack. Note, there sho=
uld
> > > not be any data be pushed to the stack before call the origin functio=
n.
> > > Then, we have to store rbx with 'mov' instead of 'push'.
> > >=20
> > > It works well for the FENTRY and FEXIT, I'm not sure if there are oth=
er
> > > complicated cases.
> > >=20
> > > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > > ---
> > >  arch/x86/net/bpf_jit_comp.c | 88 ++++++++++++++++++++++++++++++++---=
--
> >=20
> > please add selftests for this.. I had to add one to be able to check
> > the generated trampoline
> >=20
>=20
> Okay!
>=20
> BTW, I failed to compile the latest selftests/bpf with
> the following errors:
>=20
> progs/verifier_and.c:58:16: error: invalid operand for instruction
>         asm volatile ("                                 \
>=20

These tests were moved to use inline assembly recently (2 month ago).
Discussion at the time was whether to use \n\ or \ terminators at the
end of each line. People opted for \ as easier to read.
Replacing \ with \n\ and compiling this test using clang 14 shows
more informative error message:

$ make -j14 `pwd`/verifier_and.bpf.o
  CLNG-BPF [test_maps] verifier_and.bpf.o
progs/verifier_and.c:68:1: error: invalid operand for instruction
        w1 %%=3D 2;                                       \n\
^
<inline asm>:11:5: note: instantiated into assembly here
        w1 %=3D 2;=20

My guess is that clang 14 does not know how to handle operations on
32-bit sub-registers w[0-9].

But using clang 14 I get some errors not related to inline assembly as well=
.
Also, I recall that there were runtime issues with clang 14 and
tests using enum64.

All-in-all, you need newer version of clang for tests nowadays,
sorry for inconvenience.

> The version of clang I used is:
>=20
> clang --version
> Debian clang version 14.0.6
> Target: x86_64-pc-linux-gnu
> Thread model: posix
> InstalledDir: /usr/bin
>=20
> Does anyone know the reason?
>=20
> Thanks!
> Menglong Dong
>=20
> > jirka
> >=20
> >=20
>=20


