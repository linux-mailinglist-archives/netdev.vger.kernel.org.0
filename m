Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC4F4D0F40
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 06:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbiCHFnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 00:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbiCHFnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 00:43:20 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4028220E5;
        Mon,  7 Mar 2022 21:42:24 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id 195so19845322iou.0;
        Mon, 07 Mar 2022 21:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VU/bk80dcvq3/B3jqvkSt1+SbRmuTtLtwkH9kdbbGQg=;
        b=S36EuXfluWmyDYsp3P4NtHTdlgZ3jNFcoYuNp+TSNHec/f+mfX6Ob1V4aQqaufz5S2
         HbwGlUEx/LVenwQ146QDL1/eXOV3nXjv311IFzWB4e5r3ZjAOQo3vOANtJHdq/+CD9Jg
         m4Bl6DhT3Gbi+YX1e3XyEDyy4PMxJhgK7Sr03icEtq0Wi6ic5iNXlSJcyZzh9Y898/Dz
         G2eTNyU5DgDStdaYQsYWgwcjw+um4qmd0J44mcH6JtdWkIDtVshwtDsI6+v351Hbxe4I
         FbhxTbbtXQP1TIkHMuhtMSRyMD7/FVJ+IGYiCisWzPC0ERkAc3at9aHkqEgD3EFFvDSd
         BUDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VU/bk80dcvq3/B3jqvkSt1+SbRmuTtLtwkH9kdbbGQg=;
        b=FcSxPnVxsA0L6VqjyBBps29VKAt1yORAJ5IrkV1IIEopcL3GOEgrckWlVDhrgqmI7X
         2lSH6DvcioU0uym0NXGh+SKORpeLYgCVwU0iPGUELSROiMSjhBpBv1A+cWGPiDB9aC85
         4lBWyWW46VcpDgPy5hxmwQKV0LyNrR94gyzJg6mOXSRkFQ297uee8OBFGepHJ7FqHbNG
         FUFxzDjEqVizHjU2g6ckfBdcvSuITzeEDCGzZ3HHl8EmMAPw7PHw2Un2ejOhFTNrSizK
         wMN0b0X3n2KyAn7eCgti1PUF/RofWLiFMN6diku5Tjum96bVZeI7a5D8I2y0dz1H+b//
         dN1w==
X-Gm-Message-State: AOAM530yC8/qIMLh11Zdl+Z0Zp3N3Vzea9ZgahAZVTVuoMtDF1GE4VCk
        hWfGaGYXpVUw290N4p8gNHxz12JhJ+10MIPRulhWdSJR2fo=
X-Google-Smtp-Source: ABdhPJxoVBWSeo1Oh9SY4a1guJBlUjUUPu3rs3+wGg4oTVIxqevKUfb/5ElZhm2aVSuPnwHXoCk3iE9lQpYHVztTddA=
X-Received: by 2002:a5d:948a:0:b0:645:b742:87c0 with SMTP id
 v10-20020a5d948a000000b00645b74287c0mr9647775ioj.79.1646718144199; Mon, 07
 Mar 2022 21:42:24 -0800 (PST)
MIME-Version: 1.0
References: <20220306234311.452206-1-memxor@gmail.com> <20220306234311.452206-2-memxor@gmail.com>
In-Reply-To: <20220306234311.452206-2-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Mar 2022 21:42:13 -0800
Message-ID: <CAEf4Bza0smGgyty87gfbUM8z5i+QOFvVqH+VHYcQxobODxCvfQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 1/5] bpf: Add ARG_SCALAR and ARG_CONSTANT
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Lorenz Bauer <linux@lmb.io>,
        Networking <netdev@vger.kernel.org>
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

On Sun, Mar 6, 2022 at 3:43 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> In the next patch, we will introduce a new helper 'bpf_packet_pointer'
> that takes offset and len and returns a packet pointer. There we want to
> statically enforce offset is in range [0, 0xffff], and that len is a
> constant value, in range [1, 0xffff]. This also helps us avoid a
> pointless runtime check. To make these checks possible, we need to
> ensure we only get a scalar type. Although a lot of other argument types
> take scalars, their intent is different. Hence add general ARG_SCALAR
> and ARG_CONSTANT types, where the latter is also checked to be constant
> in addition to being scalar.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/bpf.h   |  2 ++
>  kernel/bpf/verifier.c | 13 +++++++++++++
>  2 files changed, 15 insertions(+)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 88449fbbe063..7841d90b83df 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -391,6 +391,8 @@ enum bpf_arg_type {
>         ARG_PTR_TO_STACK,       /* pointer to stack */
>         ARG_PTR_TO_CONST_STR,   /* pointer to a null terminated read-only string */
>         ARG_PTR_TO_TIMER,       /* pointer to bpf_timer */
> +       ARG_SCALAR,             /* a scalar with any value(s) */

What's the difference between ARG_ANYTHING and ARG_SCALAR?

> +       ARG_CONSTANT,           /* a scalar with constant value */

This ARG_CONSTANT serves a very similar purpose as
ARG_CONST_ALLOC_SIZE_OR_ZERO, tbh. The only difference is that one is
used to set meta->mem_size and this one is used (through extra func_id
special handling) to set meta->ret_pkt_len. But meta->mem_size and
meta->ret_pkt_len mean the same thing: how many bytes are directly
accessible through a pointer returned from the helper. So I feel like
there is some opportunity to unify and generalize, instead of adding
more custom variants of constants. WDYT?



>         __BPF_ARG_TYPE_MAX,
>
>         /* Extended arg_types. */
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index ec3a7b6c9515..0373d5bd240f 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -5163,6 +5163,12 @@ static bool arg_type_is_int_ptr(enum bpf_arg_type type)
>                type == ARG_PTR_TO_LONG;
>  }
>
> +static bool arg_type_is_scalar(enum bpf_arg_type type)
> +{
> +       return type == ARG_SCALAR ||
> +              type == ARG_CONSTANT;
> +}
> +
>  static int int_ptr_type_to_size(enum bpf_arg_type type)
>  {
>         if (type == ARG_PTR_TO_INT)
> @@ -5302,6 +5308,8 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
>         [ARG_PTR_TO_STACK]              = &stack_ptr_types,
>         [ARG_PTR_TO_CONST_STR]          = &const_str_ptr_types,
>         [ARG_PTR_TO_TIMER]              = &timer_types,
> +       [ARG_SCALAR]                    = &scalar_types,
> +       [ARG_CONSTANT]                  = &scalar_types,
>  };
>
>  static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
> @@ -5635,6 +5643,11 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>                         verbose(env, "string is not zero-terminated\n");
>                         return -EINVAL;
>                 }
> +       } else if (arg_type_is_scalar(arg_type)) {
> +               if (arg_type == ARG_CONSTANT && !tnum_is_const(reg->var_off)) {
> +                       verbose(env, "R%d is not a known constant\n", regno);
> +                       return -EACCES;
> +               }
>         }
>
>         return err;
> --
> 2.35.1
>
