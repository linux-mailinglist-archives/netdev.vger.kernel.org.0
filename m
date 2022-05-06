Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59EF51E154
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 23:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444569AbiEFVsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 17:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348985AbiEFVsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 17:48:31 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E856FA1C;
        Fri,  6 May 2022 14:44:47 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id l18so16722278ejc.7;
        Fri, 06 May 2022 14:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N3A1rf/Rj0PDegZIBfqZUEZZbtuVQj5afQJ+DdGLJXY=;
        b=qIRoPoyIi9YUs2nECEBig8BQu3212ApJ192x/PT3kMGoYGdOdLgi4i/CpRitLS2c5Q
         tR8aBD/U8y02V1Do3uwlRPKXizYTv0uL7qWSMEvP5UO3yhPCR6vYjRHr+gi32YQE415O
         cTgbnS3ikd6RrO+hPDJc3+zcDE0Vtk/E+l5qf2hKFV+xpAAKmpcyHbmMplqWRjSIt3mb
         aldH2gdqvT0FDDBx4XJYO6M3Szu3ig6UabTifk/hdSr8FRF5PeRgnUdgpF3B3i0jjhEt
         jsxFTcGvFJtcYxIic4jEtB7hX3mtnva63X2s7cOyBCrMHiCOwDw4A99hJx/2KR7aemGd
         OlwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N3A1rf/Rj0PDegZIBfqZUEZZbtuVQj5afQJ+DdGLJXY=;
        b=FDbXa2FWTQP909yFKrqk5VukJnrqiff9oGFqidS/pA2zQVEURTzway7KtuVVdAgxcu
         8+L9hniKsmfpX+8HWw9fsTOppzSa6QYItgTVJg/sFi6ScFoFc2TwNHHd8QfoEmkSEzmx
         KzrY2ES1X6y8q3TVLJ6HDeoKPy2Nu30hLqi6F2Y7bobHx6DjEqQmZiAiOaO5vPx2k/Uf
         DperEChh7F8C4lZ7nyGjZRpnoUgWE1+gDom7LMRN+TEE1JrZEAxekmhuCu5vhZmskMw7
         BE37qHRmD34rCfyFQ1F99e9xgdqZUB4UdvDQSgsBQpHVH/tEKvClqIVM52q8vnrKQMdJ
         +GDg==
X-Gm-Message-State: AOAM532pk8oE5SbAaUUMqxPjnVbTA8K9Fx2+xpEhBmL/nCX039QttLsF
        fUfK5rTxozcKjqPgQkXxbOTZCcBPhNN9O80wC0o=
X-Google-Smtp-Source: ABdhPJxKnXTPN1rE0ELs3y3hDsepy+hk9ObUJpCYg5aHeKL8ddu3x4IdwKD6k5cRrp+Yu12tRGxgzdfBai7wdCKbXO4=
X-Received: by 2002:a17:907:6d9d:b0:6da:7d4c:287f with SMTP id
 sb29-20020a1709076d9d00b006da7d4c287fmr4633735ejc.741.1651873485631; Fri, 06
 May 2022 14:44:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220429014240.3434866-1-pulehui@huawei.com> <20220429014240.3434866-3-pulehui@huawei.com>
In-Reply-To: <20220429014240.3434866-3-pulehui@huawei.com>
From:   Luke Nelson <luke.r.nels@gmail.com>
Date:   Fri, 6 May 2022 14:44:34 -0700
Message-ID: <CAB-e3NRn9VgdWfakom6Cbx-3btakEzvpNVmiQw7k-h_-EtOMng@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/2] riscv, bpf: Support riscv jit to provide bpf_line_info
To:     Pu Lehui <pulehui@huawei.com>
Cc:     bpf <bpf@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Xi Wang <xi.wang@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
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

Thanks for the patch! I have a couple of notes written down below.

> +               ctx->prologue_offset = ctx->ninsns;
> ...
> +               prologue_len = ctx->epilogue_offset - ctx->prologue_offset;
> +               for (i = 0; i < prog->len; i++)
> +                       ctx->offset[i] = ninsns_rvoff(prologue_len + ctx->offset[i]);

The logic looks correct to me; my only nit is that the name
prologue_offset might be a bit confusing. The prologue is always at
the beginning of the final JITed program, it just happens to be that
the prologue is emitted "out of order" on the initial/internal passes
that compute offsets.

What prologue_offset really measures in your code is the length of the
body of the JITed program. What do you think about renaming
prologue_offset to something like body_len? Then the line to compute
prologue_len becomes:

        prologue_len = ctx->epilogue_offset - ctx->body_len;

This version makes more sense to me why it's correct. Curious what you think.


> +               bpf_prog_fill_jited_linfo(prog, ctx->offset);

Here's a quote from the comment that documents
bpf_prog_fill_jited_linfo in kernel/bpf/core.c:

/* The jit engine is responsible to provide an array
 * for insn_off to the jited_off mapping (insn_to_jit_off).
...
 * jited_off is the byte off to the last byte of the jited insn.

This comment says that ctx->offset (passed to this function as
insn_to_jit_off) should map each instruction to the offset of the last
byte of the JITed instructions, but as I understand it your patch sets
ctx->offset[i] to be the offset _one past_ the last byte of the JITed
instructions (i.e., the first byte of the next instruction). I'm not
sure if this is a bug in your code, in this comment, or in my
understanding :)

As a concrete example, suppose the BPF instruction at index 0 compiles
to 2 (non-compressed) RISC-V instructions, or 8 bytes. Then
ctx->offset[0] will be 2 after the initial JIT passes, and your code
would update ctx->offset[0] to be 4*prologue_len + 8. This offset
corresponds to the first byte of insns[1], not the last byte of
insn[0], which would be 4*prologue_len + 7.

My guess would be that the comment is out of date and your code is
doing the correct thing, since it seems in line with what other JITs
are doing. If that's the case, maybe we can consider updating that
comment at some point. I'm curious if the tests you ran would break if
you changed your code to match what the comment says (i.e.,
subtracting 1 byte from each element in ctx->offset before passing to
bpf_prog_fill_jited_linfo).


> ./test_progs -a btf
> #19 btf:OK
> Summary: 1/215 PASSED, 0 SKIPPED, 0 FAILED

Last, did you have a chance to run any of the other tests with your
change (e.g., test_verifier, test_bpf.ko, other tests in test_progs)?
I don't expect this change to break any tests, but may as well run
them if it's easy enough just to be sure.


Thanks!
- Luke
