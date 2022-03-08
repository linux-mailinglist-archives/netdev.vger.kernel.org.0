Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8D54D1039
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 07:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241256AbiCHG1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 01:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbiCHG1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 01:27:01 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0245D369F0;
        Mon,  7 Mar 2022 22:26:06 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id k92so7133175pjh.5;
        Mon, 07 Mar 2022 22:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RIGqq09dFqiRViioM7vNAEkrah314bLb5nU+GFM4OwE=;
        b=E3aFJofk4M51NDLMTDfY0ms+f3MxDW7EX5wyuP7syaLuwpL2Ywk9oGJTd/Dty3bbCl
         3y9Qj1rXFNAPjvWQAaJsMhk1oOSihuq1ZkLkWDiz3oT2xfJ/GxuBRFvkkd4DeinJRPtD
         XimmTWdr4yulxqqzELElF8uuFEaVlWi0ZtwCHE6fmTUZcQ6C1sOC7vtOZBMNu/GH5mhF
         EC4Gu8xwfm4JPGjw9DJzJtrupVVHK1iioF2LREVwf7KMo+0ONIE3HZnnNiPi/3C5a3IS
         smSYlAG42e+RFUlQ9HEARchmDrwbeIAgtUS0L00ZR/zrrVgvhbFSu0ijaXbmNmu8nC4l
         ARDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RIGqq09dFqiRViioM7vNAEkrah314bLb5nU+GFM4OwE=;
        b=AKu1AogljeCZnCg0FW0f0j9nDDZzCFRDlkpOY+BRbm7XFCWcUSN+HlaT25hrqeqsYz
         PHJAzq9mU8WdTaRJKP7854hUYJAMQ0zvda8JiEOinb2IRnEa4DKKShvc3ZA8lhDBEoFo
         wx4SiTmzOeGhl0VvHsueNJPGwNXcRc9V9j6AC0Vpt+cQ2ob657kDcr3N38GT8XqxmqQr
         fRTw2fuCY+TeAmLHlZS83W7vMRAnkpMB86JF/KnM2x5R90R4zrrw9eRc0Ho5eVVTZsSS
         TZQK92MmSAUrPW5PpNRX8woKJkoPxGig5UJxwnN0Hjg1tVwxX9sdiQsa0OnhGjJKwNWT
         mWbg==
X-Gm-Message-State: AOAM532qL+BzdBhg6awkw6RAOOq1gLYkl0Ure1sFVerUNitPukSummoA
        8k8zLIBT8okCycuHqurwyTdBd/59aIby+Q==
X-Google-Smtp-Source: ABdhPJypGWsYHD31vti9XmTKgL+M2yXOMlxPAiA9IWACgy0c5VhA7LnptdKvteda+TdoUT+Gt3hU+g==
X-Received: by 2002:a17:90b:4b4a:b0:1bf:83d:6805 with SMTP id mi10-20020a17090b4b4a00b001bf083d6805mr3124394pjb.174.1646720765372;
        Mon, 07 Mar 2022 22:26:05 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id w5-20020a17090a4f4500b001bf3bdf39a8sm1421888pjl.4.2022.03.07.22.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 22:26:05 -0800 (PST)
Date:   Tue, 8 Mar 2022 11:56:02 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Lorenz Bauer <linux@lmb.io>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 1/5] bpf: Add ARG_SCALAR and ARG_CONSTANT
Message-ID: <20220308062602.7aydtzkk5ghyo5gb@apollo.legion>
References: <20220306234311.452206-1-memxor@gmail.com>
 <20220306234311.452206-2-memxor@gmail.com>
 <CAEf4Bza0smGgyty87gfbUM8z5i+QOFvVqH+VHYcQxobODxCvfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza0smGgyty87gfbUM8z5i+QOFvVqH+VHYcQxobODxCvfQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 11:12:13AM IST, Andrii Nakryiko wrote:
> On Sun, Mar 6, 2022 at 3:43 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
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
>
> What's the difference between ARG_ANYTHING and ARG_SCALAR?
>

ARG_SCALAR only accepts reg->type == SCALAR, ARG_ANYTHING accepts anything as
long as reg->type != NOT_INIT (due to SRC_OP for check_reg_arg and early return
without further checks).

> > +       ARG_CONSTANT,           /* a scalar with constant value */
>
> This ARG_CONSTANT serves a very similar purpose as
> ARG_CONST_ALLOC_SIZE_OR_ZERO, tbh. The only difference is that one is
> used to set meta->mem_size and this one is used (through extra func_id
> special handling) to set meta->ret_pkt_len. But meta->mem_size and
> meta->ret_pkt_len mean the same thing: how many bytes are directly
> accessible through a pointer returned from the helper. So I feel like
> there is some opportunity to unify and generalize, instead of adding
> more custom variants of constants. WDYT?
>

I see, indeed it would make sense to make both equivalent, since
CONST_ALLOC_SIZE must also be a constant. Joanne also mentioned consolidating,
but I didn't understand how that would work for ARG_CONSTANT and ARG_CONST_SIZE
ones.

I'm wondering whether we can take a step back and should go with the following
convention:

ARG_MEM_SIZE, and two type flags, ARG_ZERO | ARG_CONSTANT

Old				New (in bpf_func_proto)
-------------------------------------------------------------------
ARG_CONST_SIZE			ARG_MEM_SIZE
ARG_CONST_SIZE_OR_ZERO		ARG_MEM_SIZE | ARG_ZERO
ARG_CONST_ALLOC_SIZE		ARG_MEM_SIZE | ARG_CONST
ARG_CONST_ALLOC_SIZE_OR_ZERO	ARG_MEM_SIZE | ARG_CONST | ARG_ZERO
ARG_CONSTANT (mine)		ARG_MEM_SIZE | ARG_CONST

When we detect ARG_CONST, we always set meta->mem_size, which can be used to
refine returned pointer range, otherwise meta->mem_size = -1 by default (so it
will be -1 for the !tnum_is_const(reg->var_off) case).

if (arg_type & ARG_CONST)
	meta->mem_size = reg->var_off.value;
	if (!(arg_type & ARG_ZERO) && !meta->mem_size)
		// error

The check_mem_size_reg call is only made when we see that previous reg was
ARG_PTR_TO_MEM. When preceding argument is not ARG_PTR_TO_MEM, we error if
ARG_CONST is not set for ARG_MEM_SIZE (so that either the mem size is for
previous parameter, or otherwise a constant size for the returned pointer).
We can also only allow certain pointer return types for that case.

If that is too much automagic, we can also discern using ARG_MEM_SIZE vs
ARG_RET_MEM_SIZE, but I think the above is fine.

ARG_CONST ofcourse only applies to args taking scalar type.

>
>
> >         __BPF_ARG_TYPE_MAX,
> >
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
