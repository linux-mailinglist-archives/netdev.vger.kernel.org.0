Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6961B43CF18
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 18:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243074AbhJ0Q5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 12:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233200AbhJ0Q5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 12:57:49 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A206C061570;
        Wed, 27 Oct 2021 09:55:23 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d3so5238947wrh.8;
        Wed, 27 Oct 2021 09:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CWsVp+SrjAMjXLWg5aGWLi275IB1/UGr/3Kbpvbrlz0=;
        b=U/dhtVVCVlDcYpws+z+H9Kda0couCD6neCQIXUYqlrfO99hMTp9STdc0AieEg3qQT/
         LEA+vxDrmd6yzu18iRRAB7YQmULVytVd3yh6Xi9gtG1Ybl4G92/I6YlQOxY2glyzB2ez
         RSpQKKllcdr7iULn1KqydmlmuPpSummlQFliAWT5I/z2CsL6lBTRCzfsah1skJPOy7c9
         7fl5PnuRz4XGmicNOMSDHCBzne9RpQHzLWK3ekMeRb6Bn9YJ7j+y2J1ySvyKN3NyAZOS
         WMWEP7YuQVmedJe+ydRZaG8mrxdMVK14JVyiTBZqk+ID/fmMClq1kcVaIJXjqN1JFrno
         T0vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CWsVp+SrjAMjXLWg5aGWLi275IB1/UGr/3Kbpvbrlz0=;
        b=GbPyR0kSMEZ1c/nN+UCjDxMAxLptgl9CNM3gygBpeWbz+lMzHrg/lGzgfL14Gwgh+6
         Zmt8FGNiATvNTreeloBfRad3BdSTlfSJ/t5SoKq6/5k9aMrEfXtmDb1uZSxEdHo+HAZU
         RqzvM93AWIlEKR2vdiQOF7s52+o21NqJJEiJnW3pp6Y8n+Dkns265w8mDYH2b3KOzL9g
         lcwISDRXHKta+EATbUaZLGU2sVM8P7wZ52fwmSk6sTL6rg8ppAd6vd7JkuFTb5fCJdC7
         azVgK5A6DjJXsbx6JyPEYpzuEt08qq80XJVzfMWVRK3U1gvY4WWduSHKCC485SQsTrSF
         p+oQ==
X-Gm-Message-State: AOAM530YusuGvNTDbbproLfpA4sgHDaF3ixbyjm0AOXHB+4VGvH3GZPH
        VExyvOQZpdclxnKysYaeSnLlOs3GsjwqvhnnVOA=
X-Google-Smtp-Source: ABdhPJyV24jXnFwVti0Sq573uCKjsBbNXwheOJlt548iRfoPnt9g9DgT6esuUDsI3g9IgU9ttKCWsBoZhmwBKODu/0Y=
X-Received: by 2002:a05:6000:2c6:: with SMTP id o6mr21600827wry.321.1635353722089;
 Wed, 27 Oct 2021 09:55:22 -0700 (PDT)
MIME-Version: 1.0
References: <20211027111822.3801679-1-tongtiangen@huawei.com>
In-Reply-To: <20211027111822.3801679-1-tongtiangen@huawei.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 27 Oct 2021 18:55:10 +0200
Message-ID: <CAJ+HfNhC=hfFnjVvCf=bw+n1msRjR3gGUyapAmsRDupZ5CusrQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next,v3] riscv, bpf: Add BPF exception tables
To:     Tong Tiangen <tongtiangen@huawei.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 at 13:03, Tong Tiangen <tongtiangen@huawei.com> wrote:
>
> When a tracing BPF program attempts to read memory without using the
> bpf_probe_read() helper, the verifier marks the load instruction with
> the BPF_PROBE_MEM flag. Since the riscv JIT does not currently recognize
> this flag it falls back to the interpreter.
>
> Add support for BPF_PROBE_MEM, by appending an exception table to the
> BPF program. If the load instruction causes a data abort, the fixup
> infrastructure finds the exception table and fixes up the fault, by
> clearing the destination register and jumping over the faulting
> instruction.
>
> A more generic solution would add a "handler" field to the table entry,
> like on x86 and s390.
>
> The same issue in ARM64 is fixed in:
> commit 800834285361 ("bpf, arm64: Add BPF exception tables")
>
> Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
> Tested-by: Pu Lehui <pulehui@huawei.com>
> ---
> v3:
> Modify according to Bj=C3=B6rn's comments, mainly code optimization.

Thank you!

I ran this patch against the test_bpf.ko, and selftests/bpf -- no
regressions, and after the patch is applied more tests passes. Yay!

On a related note. The RISC-V selftests/bpf is in a pretty lousy
state. I'll send a cleanup patch for them soonish. E.g.:

* RISC-V is missing in bpf_tracing.h (libbpf)
* Some programs don't converge in 16 steps, I had to increase it to ~32
* The selftest/bpf Makefile needed some RV specific changes
* ...a lot of tests still don't pass, and needs to be looked in to

Feel free to add:

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

> v2:
> Modify according to Bj=C3=B6rn's comments, mainly removes redundant head =
files
> extable.h and some code style issues.
>
>  arch/riscv/mm/extable.c         |  19 +++-
>  arch/riscv/net/bpf_jit.h        |   1 +
>  arch/riscv/net/bpf_jit_comp64.c | 185 +++++++++++++++++++++++++-------
>  arch/riscv/net/bpf_jit_core.c   |  19 ++--
>  4 files changed, 177 insertions(+), 47 deletions(-)
>

[...]

Bj=C3=B6rn
