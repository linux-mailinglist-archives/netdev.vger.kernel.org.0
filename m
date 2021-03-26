Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A27134AE46
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhCZSJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhCZSJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 14:09:42 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731D4C0613AA;
        Fri, 26 Mar 2021 11:09:42 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id j198so6689008ybj.11;
        Fri, 26 Mar 2021 11:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZhDceGf5EPwxqOmSXw7vSwKwAN2oE3kPh5APLhrkFoc=;
        b=rZ5aSSs1FMJf5GOkwaIlzevMhDtIv7GWGcyp/tMZriePwT5YUyIaPyEGKp2gaPLE2l
         QJNagORWX24s9kDaMB8RWeFqZ5FQpu9tN4mO3Cg3A2kqJfgu7uX822GyYYNo9JvDZjJz
         6JVN6mF8zW4m8a95krBY959jji1or981S1VIn1uGOnvq1aJ58VLwtr9d2MNIQ/k6gJbs
         fFNWCW9ZEtoxN+71hkrz07cWEKdhifXdRVS/QYRojYXy7/stfTVT/8CHCRt/L6htJX8g
         K0as0xRGm/ajFmHbeGvhACS4PRdWsX0Mhr+a6DmJreZzz9nt8AMShYtp6kfrMopsZ1Km
         WaOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZhDceGf5EPwxqOmSXw7vSwKwAN2oE3kPh5APLhrkFoc=;
        b=QpJXwinGur9eUC1U2plPm5tb1R5daehCqD4VYazwcVGO5L7L3jUwNAHd52M5OJW9tq
         4PHOiDlxw+YNzkh2+agOKqAdXvhxYP4zfWD/mzwohyXPxE+VpNY8WKO9jqmITvFTFobv
         BHNrbm1GCOjNNSvSpgrJk2TluVMvOtmFkhW6x3RMWCZNqcsuSYMhRB4OoHr13Wfq65nJ
         f6s4iYKIRxPLx0eBPHAGu2NoO0TNZ2OHm9qajZXRU8XnpgwKiesCeqozkkj3bmCcxM/X
         mJ5b6WSKbeLEkuZcZRY7ih93b/JDyWtpPFN60LZRA0M8503seWIu7huRgrKuvxQYef3z
         tp/Q==
X-Gm-Message-State: AOAM530xEf5+P9V1TT59Xqb1/JwZLrb/0CuTXlgyBsJ1E8ChgIfAkus2
        DHezlv4CBXcZ4ysnC7dJTS2hFGHVY2aFheSeQGA=
X-Google-Smtp-Source: ABdhPJwZWcSa7JQvBA9hqNB5lZjLdckzgvKVymMhVosuDluUt0M9JwkAjau2sBLidm357xNSn5TXDUV43T3H05sAiIo=
X-Received: by 2002:a25:ab03:: with SMTP id u3mr15164570ybi.347.1616782181703;
 Fri, 26 Mar 2021 11:09:41 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616430991.git.christophe.leroy@csgroup.eu>
 <CAEf4BzZjNK_La1t5FGyie02FCABBieZJod49rW4=WtMs7ELLSw@mail.gmail.com> <86028d25-c3fe-3765-f7c3-12448523405a@csgroup.eu>
In-Reply-To: <86028d25-c3fe-3765-f7c3-12448523405a@csgroup.eu>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Mar 2021 11:09:30 -0700
Message-ID: <CAEf4BzaNh2hDmY+9CZWTDOF2gXtPcs9iGYj6PADgH4RuUOPsKQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Implement EBPF on powerpc32
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, open list <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 7:42 AM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
>
>
>
> Le 22/03/2021 =C3=A0 18:53, Andrii Nakryiko a =C3=A9crit :
> > On Mon, Mar 22, 2021 at 9:37 AM Christophe Leroy
> > <christophe.leroy@csgroup.eu> wrote:
> >>
> >> This series implements extended BPF on powerpc32. For the implementati=
on
> >> details, see the patch before the last.
> >>
> >> The following operations are not implemented:
> >>
> >>                  case BPF_ALU64 | BPF_DIV | BPF_X: /* dst /=3D src */
> >>                  case BPF_ALU64 | BPF_MOD | BPF_X: /* dst %=3D src */
> >>                  case BPF_STX | BPF_XADD | BPF_DW: /* *(u64 *)(dst + o=
ff) +=3D src */
> >>
> >> The following operations are only implemented for power of two constan=
ts:
> >>
> >>                  case BPF_ALU64 | BPF_MOD | BPF_K: /* dst %=3D imm */
> >>                  case BPF_ALU64 | BPF_DIV | BPF_K: /* dst /=3D imm */
> >>
> >> Below are the results on a powerpc 885:
> >> - with the patch, with and without bpf_jit_enable
> >> - without the patch, with bpf_jit_enable (ie with CBPF)
> >>
> >> With the patch, with bpf_jit_enable =3D 1 :
> >>
> >> [   60.826529] test_bpf: Summary: 378 PASSED, 0 FAILED, [354/366 JIT'e=
d]
> >> [   60.832505] test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED
> >>
> >> With the patch, with bpf_jit_enable =3D 0 :
> >>
> >> [   75.186337] test_bpf: Summary: 378 PASSED, 0 FAILED, [0/366 JIT'ed]
> >> [   75.192325] test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED
> >>
> >> Without the patch, with bpf_jit_enable =3D 1 :
> >>
> >> [  186.112429] test_bpf: Summary: 371 PASSED, 7 FAILED, [119/366 JIT'e=
d]
> >>
> >> Couldn't run test_progs because it doesn't build (clang 11 crashes dur=
ing the build).
> >
> > Can you please try checking out the latest clang from sources and use
> > that one instead?
>
> The crash is fixed, it builds one step more, then fails at:
>
> [root@PC-server-ldb bpf]# make CROSS_COMPILE=3Dppc-linux- ARCH=3Dpowerpc =
V=3D1
> /root/gen_ldb/linux-powerpc/tools/testing/selftests/bpf/host-tools/sbin/b=
pftool gen skeleton
> /root/gen_ldb/linux-powerpc/tools/testing/selftests/bpf/atomic_bounds.o >
> /root/gen_ldb/linux-powerpc/tools/testing/selftests/bpf/atomic_bounds.ske=
l.h
> libbpf: elf: endianness mismatch in atomic_bounds.
> Error: failed to open BPF object file: Endian mismatch
>
> I'm cross-building on x86 for powerpc/32

yeah, I'm not sure selftests/bpf supports cross-compiling. bpftool got
some patches recently to enable cross-compiling, but probably not
selftests/bpf.

>
> [root@PC-server-ldb bpf]# file atomic_bounds.o
> atomic_bounds.o: ELF 64-bit MSB relocatable, eBPF, version 1 (SYSV), with=
 debug_info, not stripped
>
> Christophe
