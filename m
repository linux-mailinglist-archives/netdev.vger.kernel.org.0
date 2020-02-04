Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7C1152185
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 21:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbgBDUdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 15:33:24 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39948 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727458AbgBDUdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 15:33:23 -0500
Received: by mail-pl1-f193.google.com with SMTP id y1so7747185plp.7;
        Tue, 04 Feb 2020 12:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=4Y76WudeWCG5zXmxP2Nw4YSkfa14RC4kqB6t3Lg4X9M=;
        b=UM63F9EXUlmTMTVYbwks5jV/yCvDqR4chYFapC5j4CVIQviDsobwExzj3GIkgPbRdq
         //qsfAxnZ1oWlUcd0vhb6wNDUBvcZIH6/bP0reunmdDhUB2k2bkh75y4qAbG+VQgV0dp
         59icHfEdfg/Fz/zx7NbCienbak2IANxuX84XGTEe1YxKly8z/OJi34H3uMjk7Er/HXhj
         HGGS+RLISvXMN/aPIkoJD14ACshXu4NwMxheIOKq64mjltT9GCqP/sLbG29gRD80AuJr
         DOLtHEeEaArGoQsmTFcUUHUWTxqxpsz5Bz5FEpdv9b884Ytw6QBnv7Vq18AdvXdoNP4B
         yzVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=4Y76WudeWCG5zXmxP2Nw4YSkfa14RC4kqB6t3Lg4X9M=;
        b=KGbBrcpfE0rkOen2GJ+PWg/iX6oQWVxfqxYs04qeooU2bw5y8x82Uvc4cPDvt7cW+r
         0veNqVqL6kPPGO3dyUc9kirJCtjMUIFBcab5MA6S3ERPqQXi355pM9X+3WsomTuHouCw
         RDKadcrHkZQrlO6gHAQ2Sq0JUTxV+6FFnk83XU7k8KIHKr71lAFrMtl9Ydk4Zb0V84ha
         DNSrQ/ELu43w+614xbZTqGm8TY0QrNnA2wLhVB8Mw+i8MXY7aRLGzM935GFOsQZNvZDp
         7//wfVFhKvOK/RG+n9MBdVIL9TbKGbplF/huhiLTQoZOm8wN68rLqzTGFUf9wosHASbr
         6YqA==
X-Gm-Message-State: APjAAAXNh44ZdYkjrf79zg4z51PogHV2rC4vOVXKyVUmQCVWPgGOb6SG
        JsqXRi+PWBL7WXCIQ5cGoXA=
X-Google-Smtp-Source: APXvYqzeahYF5KBgE/fLGWyNk0UEHsBipBvuQH1Ndc7tvKe17Ilwb5Vq5hgNIVuTZ9BqoQ06SyLiQQ==
X-Received: by 2002:a17:90a:a78b:: with SMTP id f11mr1202943pjq.8.1580848401174;
        Tue, 04 Feb 2020 12:33:21 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v9sm4620636pja.26.2020.02.04.12.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 12:33:20 -0800 (PST)
Date:   Tue, 04 Feb 2020 12:33:13 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, zlim.lnx@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Shuah Khan <shuah@kernel.org>, Netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com, kernel-team@android.com
Message-ID: <5e39d509c9edc_63882ad0d49345c08@john-XPS-13-9370.notmuch>
In-Reply-To: <CAJ+HfNh2csyH2xZtGFXW1zwBEW4+bo_E60PWPydJkB6zZTVx3A@mail.gmail.com>
References: <20200128021145.36774-1-palmerdabbelt@google.com>
 <CAJ+HfNh2csyH2xZtGFXW1zwBEW4+bo_E60PWPydJkB6zZTVx3A@mail.gmail.com>
Subject: Re: arm64: bpf: Elide some moves to a0 after calls
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel wrote:
> On Tue, 28 Jan 2020 at 03:14, Palmer Dabbelt <palmerdabbelt@google.com>=
 wrote:
> >
> > There's four patches here, but only one of them actually does anythin=
g.  The
> > first patch fixes a BPF selftests build failure on my machine and has=
 already
> > been sent to the list separately.  The next three are just staged suc=
h that
> > there are some patches that avoid changing any functionality pulled o=
ut from
> > the whole point of those refactorings, with two cleanups and then the=
 idea.
> >
> > Maybe this is an odd thing to say in a cover letter, but I'm not actu=
ally sure
> > this patch set is a good idea.  The issue of extra moves after calls =
came up as
> > I was reviewing some unrelated performance optimizations to the RISC-=
V BPF JIT.
> > I figured I'd take a whack at performing the optimization in the cont=
ext of the
> > arm64 port just to get a breath of fresh air, and I'm not convinced I=
 like the
> > results.
> >
> > That said, I think I would accept something like this for the RISC-V =
port
> > because we're already doing a multi-pass optimization for shrinking f=
unction
> > addresses so it's not as much extra complexity over there.  If we do =
that we
> > should probably start puling some of this code into the shared BPF co=
mpiler,
> > but we're also opening the doors to more complicated BPF JIT optimiza=
tions.
> > Given that the BPF JIT appears to have been designed explicitly to be=

> > simple/fast as opposed to perform complex optimization, I'm not sure =
this is a
> > sane way to move forward.
> >
> =

> Obviously I can only speak for myself and the RISC-V JIT, but given
> that we already have opened the door for more advanced translations
> (branch relaxation e.g.), I think that this makes sense. At the same
> time we don't want to go all JVM on the JITs. :-P

I'm not against it although if we start to go this route I would want som=
e
way to quantify how we are increasing/descreasing load times.

> =

> > I figured I'd send the patch set out as more of a question than anyth=
ing else.
> > Specifically:
> >
> > * How should I go about measuring the performance of these sort of
> >   optimizations?  I'd like to balance the time it takes to run the JI=
T with the
> >   time spent executing the program, but I don't have any feel for wha=
t real BPF
> >   programs look like or have any benchmark suite to run.  Is there so=
mething
> >   out there this should be benchmarked against?  (I'd also like to kn=
ow that to
> >   run those benchmarks on the RISC-V port.)
> =

> If you run the selftests 'test_progs' with -v it'll measure/print the
> execution time of the programs. I'd say *most* BPF program invokes a
> helper (via call). It would be interesting to see, for say the
> selftests, how often the optimization can be performed.
> =

> > * Is this the sort of thing that makes sense in a BPF JIT?  I guess I=
've just
> >   realized I turned "review this patch" into a way bigger rabbit hole=
 than I
> >   really want to go down...
> >
> =

> I'd say 'yes'. My hunch, and the workloads I've seen, BPF programs are
> usually loaded, and then resident for a long time. So, the JIT time is
> not super critical. The FB/Cilium folks can definitely provide a
> better sample point, than my hunch. ;-)

In our case the JIT time can be relevant because we are effectively holdi=
ng
up a kubernetes pod load waiting for programs to load. However, we can
probably work-around it by doing more aggressive dynamic linking now that=

this is starting to land.

It would be interesting to have a test to measure load time in selftests
or selftests/benchmark/ perhaps. We have some of these out of tree we
could push in I think if there is interest.

> =

> =

> Bj=C3=B6rn


