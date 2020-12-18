Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0DA2DE9CF
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 20:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733130AbgLRTe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 14:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbgLRTe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 14:34:27 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F13BC0617B0;
        Fri, 18 Dec 2020 11:33:46 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id u203so2944978ybb.2;
        Fri, 18 Dec 2020 11:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KNBRvdmn/wyHTPHKsxQKl3rgA8nQ9Ef1h/1/1RSinx0=;
        b=smd6OovZibegU2ze2AZcT6ztlhK9aFY8OGPE8O/x8dVdjACocHuWUkqs1kVbf0FnQs
         DzvRqEM8tsVULNCUN4uUoaAOyX3BYPY34+3XMmvnrENqgg4F5/ki4Ky5kunhE9j7HO+N
         hjNQTLhSg/1zUa3kI52+eBPbOyqaP4wsZnZS/ZaLU/Gwzrc3+ehGPq1gYGlOQJwO3ETG
         cs0hPx1wUbTVkF8mnQ3qfvbr+FdEsnCEsSyJn6mLDxtj4X622XyBpDD/5I/s1Uz9zJx+
         lxfZFmjKUvSOM/Y9ilH6uN1j5N7/kEvYqCrkxQDCYXCxKPxjOrzCsEk0Ton2xc5ss94j
         Nt0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KNBRvdmn/wyHTPHKsxQKl3rgA8nQ9Ef1h/1/1RSinx0=;
        b=mFki/RhdocE1fJ5iHAjP0dMDknX+vWFLKUVcmc+H10x6VjowpFNdlBLoWTULjFkozQ
         35V4HR0aNniAYr6SxquYRI/Z0HvTWr5e/0mpvbJ/s1USqeDQgQ+3ZuXEz4xJo5kWm5HT
         k8VnPlxZAd+4d+bQl/+sBVsgl0kTGltv3n3AZk7y429QqkKwykYFzES2qk8QzmOdUjtK
         fBoCz/hMgOAniOxEvG86WY9Gy94Bz5UzTMbmXQ3Er4VqgzJCFzjAuNRYAahQ59SV57dM
         lFpaRjGIoMuLkyctybzRlNU6druEVCtDMABedvSHUGA5o8ZjrtKsQzKB4KuowYfb+Gww
         UT3w==
X-Gm-Message-State: AOAM5328X9yLyeqztOcNoRGjr+aAU7TSzK9cTds06xfYKINSHu6BHlsu
        ssKYbKu38HFou8quWWWTEom8XnEU9h8pZpun79A=
X-Google-Smtp-Source: ABdhPJxEs172K5VHfcViqfe+yfi8RChWTtiy61V1DgUR9JtIfk5I1OUYbtJ2w0fp6/iN5zKhS4GhnS3HcQ+h5sxyBdU=
X-Received: by 2002:a25:818e:: with SMTP id p14mr7850113ybk.425.1608320025975;
 Fri, 18 Dec 2020 11:33:45 -0800 (PST)
MIME-Version: 1.0
References: <cover.1608112796.git.christophe.leroy@csgroup.eu>
 <1fed5e11ba08ee28d12f3f57986e5b143a6aa937.1608112797.git.christophe.leroy@csgroup.eu>
 <20201217061133.lnfnhbzvikgtjb3i@ast-mbp> <854404a0-1951-91d9-2ebb-208390a64c77@csgroup.eu>
In-Reply-To: <854404a0-1951-91d9-2ebb-208390a64c77@csgroup.eu>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 18 Dec 2020 11:33:35 -0800
Message-ID: <CAEf4BzbNp0bvTbh4UjHO0KTs3Q83yuBMdh-8wCHCcTrPWnO25Q@mail.gmail.com>
Subject: Re: [RFC PATCH v1 7/7] powerpc/bpf: Implement extended BPF on PPC32
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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

On Thu, Dec 17, 2020 at 1:54 AM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
>
>
>
> Le 17/12/2020 =C3=A0 07:11, Alexei Starovoitov a =C3=A9crit :
> > On Wed, Dec 16, 2020 at 10:07:37AM +0000, Christophe Leroy wrote:
> >> Implement Extended Berkeley Packet Filter on Powerpc 32
> >>
> >> Test result with test_bpf module:
> >>
> >>      test_bpf: Summary: 378 PASSED, 0 FAILED, [354/366 JIT'ed]
> >
> > nice!
> >
> >> Registers mapping:
> >>
> >>      [BPF_REG_0] =3D r11-r12
> >>      /* function arguments */
> >>      [BPF_REG_1] =3D r3-r4
> >>      [BPF_REG_2] =3D r5-r6
> >>      [BPF_REG_3] =3D r7-r8
> >>      [BPF_REG_4] =3D r9-r10
> >>      [BPF_REG_5] =3D r21-r22 (Args 9 and 10 come in via the stack)
> >>      /* non volatile registers */
> >>      [BPF_REG_6] =3D r23-r24
> >>      [BPF_REG_7] =3D r25-r26
> >>      [BPF_REG_8] =3D r27-r28
> >>      [BPF_REG_9] =3D r29-r30
> >>      /* frame pointer aka BPF_REG_10 */
> >>      [BPF_REG_FP] =3D r31
> >>      /* eBPF jit internal registers */
> >>      [BPF_REG_AX] =3D r19-r20
> >>      [TMP_REG] =3D r18
> >>
> >> As PPC32 doesn't have a redzone in the stack,
> >> use r17 as tail call counter.
> >>
> >> r0 is used as temporary register as much as possible. It is referenced
> >> directly in the code in order to avoid misuse of it, because some
> >> instructions interpret it as value 0 instead of register r0
> >> (ex: addi, addis, stw, lwz, ...)
> >>
> >> The following operations are not implemented:
> >>
> >>              case BPF_ALU64 | BPF_DIV | BPF_X: /* dst /=3D src */
> >>              case BPF_ALU64 | BPF_MOD | BPF_X: /* dst %=3D src */
> >>              case BPF_STX | BPF_XADD | BPF_DW: /* *(u64 *)(dst + off) =
+=3D src */
> >>
> >> The following operations are only implemented for power of two constan=
ts:
> >>
> >>              case BPF_ALU64 | BPF_MOD | BPF_K: /* dst %=3D imm */
> >>              case BPF_ALU64 | BPF_DIV | BPF_K: /* dst /=3D imm */
> >
> > Those are sensible limitations. MOD and DIV are rare, but XADD is commo=
n.
> > Please consider doing it as a cmpxchg loop in the future.
> >
> > Also please run test_progs. It will give a lot better coverage than tes=
t_bpf.ko
> >
>
> I'm having hard time cross building test_progs:
>
> ~/linux-powerpc/tools/testing/selftests/bpf/$ make CROSS_COMPILE=3Dppc-li=
nux-
> ...
>    GEN
> /home/chr/linux-powerpc/tools/testing/selftests/bpf/tools/build/bpftool/D=
ocumentation/bpf-helpers.7
>    INSTALL  eBPF_helpers-manpage
>    INSTALL  Documentation-man
>    GEN      vmlinux.h
> /bin/sh: /home/chr/linux-powerpc/tools/testing/selftests/bpf/tools/sbin/b=
pftool: cannot execute
> binary file
> make: *** [/home/chr/linux-powerpc/tools/testing/selftests/bpf/tools/incl=
ude/vmlinux.h] Error 126
> make: *** Deleting file `/home/chr/linux-powerpc/tools/testing/selftests/=
bpf/tools/include/vmlinux.h'
>
> Looks like it builds bpftool for powerpc and tries to run it on my x86.
> How should I proceed ?


The best way would be to fix whatever needs to be fixed in
selftests/bpf and/or bpftool Makefiles to support cross-compilation.
There was some work already for bpftool to support that (with building
bpftool-bootstrap separately for a host architecture, etc). Please
check what's broken and let's try to fix it.

>
> Thanks
> Christophe
