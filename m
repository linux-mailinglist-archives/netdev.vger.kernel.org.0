Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A634D094C
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 22:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242625AbiCGVXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 16:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiCGVXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 16:23:16 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80F3369FA;
        Mon,  7 Mar 2022 13:22:20 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id c11so2231695pgu.11;
        Mon, 07 Mar 2022 13:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VCtWA9GhLIDhdcLAMjx/GoGOd+2Q16BSja0rgEM3jOQ=;
        b=iP1JWkWIhy5lDghwp1oqNpphYrPDJXDKowsjrjN89wDXznFXfsLLWWSgJ2UY7xtCXm
         fXHXaqffa5XQ6/CBoN9Ak7MFuwSDcHSty993cKBmTbOwfPkU03Gy1ows8oGaF/jU9zzd
         c4cTNEkXP6rUVO38PcaQng0QItuv7J0aA2GFIRgwSO2IiKXipE57OeQJzVGjoV/v4EiL
         5cgzmKH1eMiKDiRNal52XLFrXCkQnwk6pn0uWnD3ToBpYXgoBVc8EqEyRaGhblEEifnt
         Ge3letKVTIFmvKMmKP0FhdPtWurt98T7ToF6EKAkk+SBUFo+m0qq0k3n1LTkda0wahlh
         8qLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VCtWA9GhLIDhdcLAMjx/GoGOd+2Q16BSja0rgEM3jOQ=;
        b=zP5lrHhWuaZBr0JNKV1zVhai5wyQPPHMoCLeTrg7bttbIF2E/9+INVR+OORCc8TNJG
         /0z0ssY6Xukz7ch34IqB39I9xoEpr8jWxusrOwfLsuuSK4PvthHuksxp6Rjt9+VGnK9w
         TpL1zRJ6jmOlkj8FUmeQHxwU+pcNKsKeDiLc6aif17F2Vj3fpkya/HCP5IQoZ0y62+Cp
         U7pf7MZ1x2wN80KSrHzhcOjlSmP5ZPbufriyT5W/VhTT9d8Ly5BztZmOYG1GxWkYeXb+
         tk2QdXCTqf339E/wXwKMdFJGxY8jmZ0astJM3Jv1FqHXGna8k/ClxjCL8oloOI2Zk/6e
         RjDw==
X-Gm-Message-State: AOAM531bL/rUA+S9w8FzL9wjAAsigzxfJYnGZys9+xzmutMjSpeFRQYA
        xlfpgQ3sLUe03mQNerM+Twg=
X-Google-Smtp-Source: ABdhPJxx6GqZSOl2vFrwdrVkv5X/z9pg6a7ZG4H0No9423qZli9hwn9HykpORtVT1tEtKzWqtbSs/w==
X-Received: by 2002:a05:6a00:2168:b0:4f6:eb64:71dd with SMTP id r8-20020a056a00216800b004f6eb6471ddmr11106836pff.40.1646688140345;
        Mon, 07 Mar 2022 13:22:20 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id b13-20020a056a00114d00b004c122b90703sm16419447pfm.27.2022.03.07.13.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 13:22:20 -0800 (PST)
Date:   Tue, 8 Mar 2022 02:52:17 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Lorenz Bauer <linux@lmb.io>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 1/5] bpf: Add ARG_SCALAR and ARG_CONSTANT
Message-ID: <20220307212217.jtgoekfmf5npmvmr@apollo.legion>
References: <20220306234311.452206-1-memxor@gmail.com>
 <20220306234311.452206-2-memxor@gmail.com>
 <CAJnrk1au7dH--t4warkURJK7k=8=ZAtHyViOWFj2Nnu0dPkqjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1au7dH--t4warkURJK7k=8=ZAtHyViOWFj2Nnu0dPkqjg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 12:58:13AM IST, Joanne Koong wrote:
> On Mon, Mar 7, 2022 at 1:24 AM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> >
> > In the next patch, we will introduce a new helper 'bpf_packet_pointer'
> > that takes offset and len and returns a packet pointer. There we want to
> > statically enforce offset is in range [0, 0xffff], and that len is a
> > constant value, in range [1, 0xffff]. This also helps us avoid a
> > pointless runtime check. To make these checks possible, we need to
> > ensure we only get a scalar type. Although a lot of other argument types
> > take scalars, their intent is different. Hence add general ARG_SCALAR
> > and ARG_CONSTANT types, where the latter is also checked to be constant
> > in addition to being scalar.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  include/linux/bpf.h   |  2 ++
> >  kernel/bpf/verifier.c | 13 +++++++++++++
> >  2 files changed, 15 insertions(+)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 88449fbbe063..7841d90b83df 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -391,6 +391,8 @@ enum bpf_arg_type {
> >         ARG_PTR_TO_STACK,       /* pointer to stack */
> >         ARG_PTR_TO_CONST_STR,   /* pointer to a null terminated read-only string */
> >         ARG_PTR_TO_TIMER,       /* pointer to bpf_timer */
> > +       ARG_SCALAR,             /* a scalar with any value(s) */
> > +       ARG_CONSTANT,           /* a scalar with constant value */
> >         __BPF_ARG_TYPE_MAX,
> >
>
> Should we rename ARG_CONST_SIZE and ARG_CONST_SIZE_OR_ZERO to
> something like ARG_MEM_CONST_SIZE / ARG_MEM_CONST_SIZE_OR_ZERO to make
> the interface more explicit? I think that would make it less confusing
> to differentiate between ARG_CONST_SIZE and ARG_CONSTANT for arguments
> that describe the length/size but are not associated with a memory
> buffer.
>

I don't have a problem with that. I was just avoiding the churn since
ARG_CONST_SIZE vs ARG_CONSTANT didn't seem confusing to me.

>
> >         /* Extended arg_types. */
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index ec3a7b6c9515..0373d5bd240f 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -5163,6 +5163,12 @@ static bool arg_type_is_int_ptr(enum bpf_arg_type type)
> >                type == ARG_PTR_TO_LONG;
> >  }
> >
> > +static bool arg_type_is_scalar(enum bpf_arg_type type)
> > +{
> > +       return type == ARG_SCALAR ||
> > +              type == ARG_CONSTANT;
> > +}
> > +
>
> I think this function name might be a bit misleading since
> ARG_CONST_SIZE / ARG_CONST_SIZE_OR_ZERO / ARG_CONST_ALLOC_SIZE_OR_ZERO
> are also scalar arg types. Maybe one alternative is to add a function

They already have their own arg_type_is_mem_size, I think the naming here has no
relation to the underlying compatible register types. ARG_CONSTANT is just a
stronger ARG_SCALAR, so it makes sense to put both under arg_type_is_scalar
umbrella.

> "arg_type_is_const" and then in check_func_arg, enforce that if
> arg_type_is_const, then tnum_is_const(reg->var_off) must be true.
> WDYT?

I don't think ARG_CONST_SIZE[_OR_ZERO] have any requirement that the scalar
value must be a known constant, so tnum_is_const check would be prohibitive.

I think the 'CONST' in their name is more misleading, so it might make sense to
drop that instead.

>
> >  static int int_ptr_type_to_size(enum bpf_arg_type type)
> >  {
> >         if (type == ARG_PTR_TO_INT)
> > @@ -5302,6 +5308,8 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
> >         [ARG_PTR_TO_STACK]              = &stack_ptr_types,
> >         [ARG_PTR_TO_CONST_STR]          = &const_str_ptr_types,
> >         [ARG_PTR_TO_TIMER]              = &timer_types,
> > +       [ARG_SCALAR]                    = &scalar_types,
> > +       [ARG_CONSTANT]                  = &scalar_types,
> >  };
> >
> >  static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
> > @@ -5635,6 +5643,11 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
> >                         verbose(env, "string is not zero-terminated\n");
> >                         return -EINVAL;
> >                 }
> > +       } else if (arg_type_is_scalar(arg_type)) {
> > +               if (arg_type == ARG_CONSTANT && !tnum_is_const(reg->var_off)) {
> > +                       verbose(env, "R%d is not a known constant\n", regno);
> > +                       return -EACCES;
> > +               }
> >         }
> >
> >         return err;
> > --
> > 2.35.1
> >

--
Kartikeya
