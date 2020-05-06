Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8421C781E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 19:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbgEFRih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 13:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgEFRig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 13:38:36 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BB5C061A0F;
        Wed,  6 May 2020 10:38:36 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id g16so2130061qtp.11;
        Wed, 06 May 2020 10:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xtjvvnsyUlerv9jnVC13/UW3IPozn5dgWUxdZ9Fi8Ew=;
        b=K+ZtP7scBBE/4qrdOn4pWC10BwgJEFLU2NiIY4QLArITvMlnUDatXDUOGPabxsHIWP
         fzi6SZZzKxwceL8QKwy+meUsiaRNRVmfVsQz6fEtjFTRontt7UupTHRCcikNe52nJrP4
         otY1Ob68jwJvCfeS6/M3inZGKHWYoezBgOn3jwaRfP/8IXGchqwg3m+SaHIK2IUvDv/a
         gZbhTUbIHDQiW66rUjrpJMUjlrIPj4iYLTlAtJdHL8r9gzwyuKGl6biik0OSlUT9q239
         OberuEAs7OgOMcavTaGP/hHh1ofaxCBwg+0mwt39deoSFmiOKACATQG62w+JykTyLGLV
         hlYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xtjvvnsyUlerv9jnVC13/UW3IPozn5dgWUxdZ9Fi8Ew=;
        b=G+jjwBYQPjP+Lh7SxKstEuxK3nIVQMxkD73SA94UwDDXG5iqqrr5U94lMfbBO5q7oY
         UqzCssD7e9dxsL3YVs2Bk2gZzbb3aPVJK++tfPf6MYfEDc0VuIUDllmpbc3xas0T8KOW
         +pahqGBIy59uRUHoaJSZ+GLnhtv/CwtRruY1eztkEMNvcIjMo+WmBBKWDp3UayBRrMQ2
         zh1PfAienNCEWuw6oB67HeCoBer1hgRXlpspoVdv7IIgC/2h0xLo+J/6KSSQsCWxVs94
         nkT6Ist46dPIP3i4OLeYcdSYJspWj2uMvh1bOy4Nulq52sBqkaLsNvhu6G7zlqU05zmW
         QZJA==
X-Gm-Message-State: AGi0PuZTrwWxg169qUNkW484uWEPM0TuNzQnQYRqg75h4ocytfCeA6ZM
        QH1SV3vZ5nPiUnkqwzYyjPB/Mw87K688BXIGvg4=
X-Google-Smtp-Source: APiQypJJFNj3bN9ODHZu+joNGsIzrL1xWA0uUmx9+XOrSHyr6oMPICVeKfVzmdQIX5LqyJz2TeE02W0VhLEzgUCb5D8=
X-Received: by 2002:ac8:3f6d:: with SMTP id w42mr9452630qtk.171.1588786715999;
 Wed, 06 May 2020 10:38:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062603.2048735-1-yhs@fb.com>
In-Reply-To: <20200504062603.2048735-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 May 2020 10:38:24 -0700
Message-ID: <CAEf4BzYkuiCf0Wo7vQn03kiW_L7t_tica87HcOmYGHWwK+ipdQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 14/20] bpf: handle spilled PTR_TO_BTF_ID
 properly when checking stack_boundary
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 3, 2020 at 11:28 PM Yonghong Song <yhs@fb.com> wrote:
>
> This specifically to handle the case like below:
>    // ptr below is a socket ptr identified by PTR_TO_BTF_ID
>    u64 param[2] = { ptr, val };
>    bpf_seq_printf(seq, fmt, sizeof(fmt), param, sizeof(param));
>
> In this case, the 16 bytes stack for "param" contains:
>    8 bytes for ptr with spilled PTR_TO_BTF_ID
>    8 bytes for val as STACK_MISC
>
> The current verifier will complain the ptr should not be visible
> to the helper.
>    ...
>    16: (7b) *(u64 *)(r10 -64) = r2
>    18: (7b) *(u64 *)(r10 -56) = r1
>    19: (bf) r4 = r10
>    ;
>    20: (07) r4 += -64
>    ; BPF_SEQ_PRINTF(seq, fmt1, (long)s, s->sk_protocol);
>    21: (bf) r1 = r6
>    22: (18) r2 = 0xffffa8d00018605a
>    24: (b4) w3 = 10
>    25: (b4) w5 = 16
>    26: (85) call bpf_seq_printf#125
>     R0=inv(id=0) R1_w=ptr_seq_file(id=0,off=0,imm=0)
>     R2_w=map_value(id=0,off=90,ks=4,vs=144,imm=0) R3_w=inv10
>     R4_w=fp-64 R5_w=inv16 R6=ptr_seq_file(id=0,off=0,imm=0)
>     R7=ptr_netlink_sock(id=0,off=0,imm=0) R10=fp0 fp-56_w=mmmmmmmm
>     fp-64_w=ptr_
>    last_idx 26 first_idx 13
>    regs=8 stack=0 before 25: (b4) w5 = 16
>    regs=8 stack=0 before 24: (b4) w3 = 10
>    invalid indirect read from stack off -64+0 size 16
>
> Let us permit this if the program is a tracing/iter program.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

LGTM, but I wonder why enabling this only for iterator programs?

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  kernel/bpf/verifier.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 36b2a38a06fe..4884b6fd7bad 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3494,6 +3494,14 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
>                         *stype = STACK_MISC;
>                         goto mark;
>                 }
> +
> +               /* pointer value can be visible to tracing/iter program */
> +               if (env->prog->type == BPF_PROG_TYPE_TRACING &&
> +                   env->prog->expected_attach_type == BPF_TRACE_ITER &&

What's the problem allowing this for all program types?

> +                   state->stack[spi].slot_type[0] == STACK_SPILL &&
> +                   state->stack[spi].spilled_ptr.type == PTR_TO_BTF_ID)
> +                       goto mark;
> +
>                 if (state->stack[spi].slot_type[0] == STACK_SPILL &&
>                     state->stack[spi].spilled_ptr.type == SCALAR_VALUE) {
>                         __mark_reg_unknown(env, &state->stack[spi].spilled_ptr);
> --
> 2.24.1
>
