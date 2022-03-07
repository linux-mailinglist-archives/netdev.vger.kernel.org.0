Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FBD4D07AF
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 20:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239992AbiCGT3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 14:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbiCGT3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 14:29:23 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12D4AE47;
        Mon,  7 Mar 2022 11:28:27 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id n19so6975053lfh.8;
        Mon, 07 Mar 2022 11:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=omZqi7W8GBGM2eccYGUpTeQjxUdxp7+vH2Lo2guanBs=;
        b=goSMcWtZxitx+IOx7s+s1EalbPffLTFHgAZAcBAHgDEFK3kPuuanlPXq6tXQaxMxSl
         DpRdNJgH26tPno5xEmgIxwEQabO7ckQZjUMYo4+GBpn786uPTkv4Pd/TRE3Hxa6bkubt
         XlOtqqOQYmKex1V12ue4euXT+oe256HrVgjfyniXCff4YwIQRgV54uySMPJ6b+ar0bgE
         Hwweo0ilQCNErKas3eVWt7OBBBSfgJ+elJU0U3ilfX1vMVD2dA9OyJBVOSYq0ptm3jC2
         tFDoh8oSNO4iwsBaFRWg4gAaLU25locqme+cJLy6g2PPpINtBUXzaXwZOltSO8Bat8bY
         J2tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=omZqi7W8GBGM2eccYGUpTeQjxUdxp7+vH2Lo2guanBs=;
        b=dyRd61rvog1IjH7CAUemEx2qWCGLZjY8q4o9hZBhoIbSeoDvTluZQXOV7mgOjUEGmZ
         NGEfrlcWURUSf7thrb4OqOsItRoXYltWZlaAGq87HmGgtiHh/KSt9WA2teZgDBSL0U2z
         bIpX0onfejO/LgSblOPvL8KXHv91hzwcDe5oGVgaUlEGLflfzYJRo0dQhxxhn539roat
         +gRSY9nKpiUEOjHVQv1LAf42SZwElnFVptrt07FMl9PBsS5hvUSl5Lg+G53q4yKQERxS
         n9H8/d5vl8CTBJr2Iele8DbZ1dwFO6F8VDQH7UCN+JK8nyCC/MOP4RSOB1nQSo1yLVZY
         Pw3A==
X-Gm-Message-State: AOAM533c/L01FAOK2Hc6Mvfzn9ODQJ5jh1g2eXsepea/3mNo8fMkZ/kZ
        8Gs2JfvaluKTzoQjqgZasjWZ4cTZffIlHQyt1Pw=
X-Google-Smtp-Source: ABdhPJyYCfHgzA2i9xHcJ+K22YVF52g0oJflAsjJ1VHpeyVZqyjEw9oUTEZqrmqgSyFpj/dspfr1WkSzMebijNtJFeU=
X-Received: by 2002:a19:9201:0:b0:443:c317:98ff with SMTP id
 u1-20020a199201000000b00443c31798ffmr8462944lfd.331.1646681304873; Mon, 07
 Mar 2022 11:28:24 -0800 (PST)
MIME-Version: 1.0
References: <20220306234311.452206-1-memxor@gmail.com> <20220306234311.452206-2-memxor@gmail.com>
In-Reply-To: <20220306234311.452206-2-memxor@gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Mon, 7 Mar 2022 11:28:13 -0800
Message-ID: <CAJnrk1au7dH--t4warkURJK7k=8=ZAtHyViOWFj2Nnu0dPkqjg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 1/5] bpf: Add ARG_SCALAR and ARG_CONSTANT
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Lorenz Bauer <linux@lmb.io>,
        netdev@vger.kernel.org
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

On Mon, Mar 7, 2022 at 1:24 AM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
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
> +       ARG_CONSTANT,           /* a scalar with constant value */
>         __BPF_ARG_TYPE_MAX,
>

Should we rename ARG_CONST_SIZE and ARG_CONST_SIZE_OR_ZERO to
something like ARG_MEM_CONST_SIZE / ARG_MEM_CONST_SIZE_OR_ZERO to make
the interface more explicit? I think that would make it less confusing
to differentiate between ARG_CONST_SIZE and ARG_CONSTANT for arguments
that describe the length/size but are not associated with a memory
buffer.


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

I think this function name might be a bit misleading since
ARG_CONST_SIZE / ARG_CONST_SIZE_OR_ZERO / ARG_CONST_ALLOC_SIZE_OR_ZERO
are also scalar arg types. Maybe one alternative is to add a function
"arg_type_is_const" and then in check_func_arg, enforce that if
arg_type_is_const, then tnum_is_const(reg->var_off) must be true.
WDYT?

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
