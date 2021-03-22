Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6539A344DD2
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhCVRyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbhCVRxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:53:35 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189F3C061574;
        Mon, 22 Mar 2021 10:53:35 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id i9so7474347ybp.4;
        Mon, 22 Mar 2021 10:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LDxueTAdL2AWLL01bMdPUnnD4HpNdzZ8wxBaFyudbww=;
        b=GD0yghqnscxyOcEfRGbu64M3NgeRrenUULJiEi5bCLXNE3wNB54a0uKIwAzyRLE79Q
         i7Psp/g1lRRzYuPcpO1EYWr6pPnrDf8CYcbLJZXFAyhlMZPs20msacukrWM+V8klkGBn
         S7GEp+0D24bDkhJjS/7j7nsC4HJUVPutq8aobGVCiGcQRiMDsENSWwK3nZiakusrfzNh
         StTlo3VkkAAojKRwNXTB/lHkD8xigej+brwiTtfDoiWMwAiEIEboHv1vNEriHsBi7lFw
         U9Xc5vGW7AODw0+EPj2Iq3WFH5teenIb5l0iSeGD3aYFHD6lQ0fUd9OR52Bn3n16zcq0
         takQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LDxueTAdL2AWLL01bMdPUnnD4HpNdzZ8wxBaFyudbww=;
        b=b/030+WTK/JV3CkKrVA+U64CdzkWsWPn9+EnFAaEkmSgrPUeiszxZp3PBNCsy2fLw3
         zbBnyTlZb9rAeYPewzEETX9KE8aWmy2S7gGVu9fIphWBWZAXW3CDiKbZMybr252k4euS
         HnIR0k+QSDupno1nQIb9G66Hc6gE3T0q28hqwop2OVrFO0dlP5HHy+5Q9P4W1X3HkES6
         B6otT0JwJ8gvv6swDC5Myf2g+2rueBlnCBjdFRD64K6JvyH/lrdO2ncX+bdf+KvivgZ7
         +X522YuCJniWt+TfeKiAbwsMlLQ/Swx9h2lz6ldEXanCmdsE6rszdNQUHAaa1uTxQzU8
         KTxA==
X-Gm-Message-State: AOAM531hkLT9LYORzmdhPkQb1/DuuN7i80IfG+9C5N+yOO5HoewdhHHG
        5t5tddzHenkJKdak+NfiT+Xb0WUyZysTELXyKas=
X-Google-Smtp-Source: ABdhPJzfCsjWCQu7sHhVGimfTT+JwVEP97RTB0MeZGcbm/du73/RGc8gfc2AFNRyR0lZZU+NaCM++NpLD/IRCN5iUdc=
X-Received: by 2002:a25:7d07:: with SMTP id y7mr838725ybc.425.1616435614417;
 Mon, 22 Mar 2021 10:53:34 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616430991.git.christophe.leroy@csgroup.eu>
In-Reply-To: <cover.1616430991.git.christophe.leroy@csgroup.eu>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Mar 2021 10:53:23 -0700
Message-ID: <CAEf4BzZjNK_La1t5FGyie02FCABBieZJod49rW4=WtMs7ELLSw@mail.gmail.com>
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 9:37 AM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
>
> This series implements extended BPF on powerpc32. For the implementation
> details, see the patch before the last.
>
> The following operations are not implemented:
>
>                 case BPF_ALU64 | BPF_DIV | BPF_X: /* dst /= src */
>                 case BPF_ALU64 | BPF_MOD | BPF_X: /* dst %= src */
>                 case BPF_STX | BPF_XADD | BPF_DW: /* *(u64 *)(dst + off) += src */
>
> The following operations are only implemented for power of two constants:
>
>                 case BPF_ALU64 | BPF_MOD | BPF_K: /* dst %= imm */
>                 case BPF_ALU64 | BPF_DIV | BPF_K: /* dst /= imm */
>
> Below are the results on a powerpc 885:
> - with the patch, with and without bpf_jit_enable
> - without the patch, with bpf_jit_enable (ie with CBPF)
>
> With the patch, with bpf_jit_enable = 1 :
>
> [   60.826529] test_bpf: Summary: 378 PASSED, 0 FAILED, [354/366 JIT'ed]
> [   60.832505] test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED
>
> With the patch, with bpf_jit_enable = 0 :
>
> [   75.186337] test_bpf: Summary: 378 PASSED, 0 FAILED, [0/366 JIT'ed]
> [   75.192325] test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED
>
> Without the patch, with bpf_jit_enable = 1 :
>
> [  186.112429] test_bpf: Summary: 371 PASSED, 7 FAILED, [119/366 JIT'ed]
>
> Couldn't run test_progs because it doesn't build (clang 11 crashes during the build).

Can you please try checking out the latest clang from sources and use
that one instead?

>
> Changes in v2:
> - Simplify 16 bits swap
> - Rework tailcall, use stack for tailcall counter
> - Fix handling of BPF_REG_FP:
>   - must be handler like any other register allthough only the lower 32 bits part is used as a pointer.
>   - r18 was TMP_REG, r17/r18 become de BPF_REG_FP
>   - r31 was BPF_REG_FP, it is now TMP_REG
> - removed bpf_jit32.h
> - Reorder register allocation dynamically to use the volatile registers as much as possible when not doing function calls (last patch - new)
>
> Christophe Leroy (8):
>   powerpc/bpf: Remove classical BPF support for PPC32
>   powerpc/bpf: Change register numbering for bpf_set/is_seen_register()
>   powerpc/bpf: Move common helpers into bpf_jit.h
>   powerpc/bpf: Move common functions into bpf_jit_comp.c
>   powerpc/bpf: Change values of SEEN_ flags
>   powerpc/asm: Add some opcodes in asm/ppc-opcode.h for PPC32 eBPF
>   powerpc/bpf: Implement extended BPF on PPC32
>   powerpc/bpf: Reallocate BPF registers to volatile registers when
>     possible on PPC32
>
>  Documentation/admin-guide/sysctl/net.rst |    2 +-
>  arch/powerpc/Kconfig                     |    3 +-
>  arch/powerpc/include/asm/ppc-opcode.h    |   12 +
>  arch/powerpc/net/Makefile                |    6 +-
>  arch/powerpc/net/bpf_jit.h               |   61 ++
>  arch/powerpc/net/bpf_jit32.h             |  139 ---
>  arch/powerpc/net/bpf_jit64.h             |   21 +-
>  arch/powerpc/net/bpf_jit_asm.S           |  226 -----
>  arch/powerpc/net/bpf_jit_comp.c          |  782 ++++-----------
>  arch/powerpc/net/bpf_jit_comp32.c        | 1095 ++++++++++++++++++++++
>  arch/powerpc/net/bpf_jit_comp64.c        |  295 +-----
>  11 files changed, 1372 insertions(+), 1270 deletions(-)
>  delete mode 100644 arch/powerpc/net/bpf_jit32.h
>  delete mode 100644 arch/powerpc/net/bpf_jit_asm.S
>  create mode 100644 arch/powerpc/net/bpf_jit_comp32.c
>
> --
> 2.25.0
>
