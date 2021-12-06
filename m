Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3B646A6B9
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 21:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349544AbhLFUUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 15:20:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29023 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349605AbhLFUUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 15:20:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638821831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8CkVhoq6YizOgNsw45WuxejzlMWVie7ct2RIOH9957s=;
        b=gG9S5XehRuRjQjl1UkP8hSycRXepJQeZ3Rc22che1KFtKgsX+zk6r51ZRr3kGNVTIqabI3
        pABu7mX36AJzfZBXpslb1AxyjB/CqpSnH9E9eLuAPDFK00SFMVyljrJSHkMrSK7WV1a0W+
        +nN/HEVHKnEyYMAL+IqI+bGBRZAjICI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-FDB8PgvWO1SDLbiDEm_7RQ-1; Mon, 06 Dec 2021 15:17:07 -0500
X-MC-Unique: FDB8PgvWO1SDLbiDEm_7RQ-1
Received: by mail-ed1-f70.google.com with SMTP id w18-20020a056402071200b003e61cbafdb4so9349055edx.4
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 12:17:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8CkVhoq6YizOgNsw45WuxejzlMWVie7ct2RIOH9957s=;
        b=rf50KL45HFVK+7ZS0qEnw2lhy34VayEIHh1OrgFmkhubvuevCMEeyvavcbsdiueqZY
         RneCGzDis+yD2XDGJV+qNgBwr209W2u5c/xiVRb2QrhiofKpqgZip9EyXnBG5PbUlkuf
         tjjnp4OaHsbIqMNbq0keA5SkiizKR2Ou37F27AhLw4U8XtXa/fh+jT/zPE/QVT3VUwn7
         DLwjqhC0kBzgPc114G7EiSY0VqS0xU9N1v48j4mAzrAqfP+e7sYprkWyxzF5t5F3zawT
         d89UGhW0Sj8g+Onr55GIbNu2RHhL2laOmj+jqO13IG1COIBGUtYIHgAywP/724AWowhL
         fTQQ==
X-Gm-Message-State: AOAM531JeY23G2XN1quBmRpE79x3PwAGDqkyI3rLP987bhFzZu7wV/hA
        xDbaXOOuiqoWg3F89NvSNG15Y9K380NpEMQI0ACMokt2TFqZiVN19xPbX+mNG39p90agDqdjLL6
        OQEsFDOugqQmMYog9
X-Received: by 2002:a05:6402:2790:: with SMTP id b16mr2111783ede.24.1638821826408;
        Mon, 06 Dec 2021 12:17:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxeKr09eIJWx5IKWrJ9gBAiKwpN3+k8dpS8vAQl9jn9+IuL+M5Mdlo8T0SGgaDCw/9gsQUPTw==
X-Received: by 2002:a05:6402:2790:: with SMTP id b16mr2111743ede.24.1638821826166;
        Mon, 06 Dec 2021 12:17:06 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id d19sm7789772edt.34.2021.12.06.12.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 12:17:05 -0800 (PST)
Date:   Mon, 6 Dec 2021 21:17:04 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next 2/3] bpf: Add get_func_[arg|ret|arg_cnt] helpers
Message-ID: <Ya5vwJLqNDPWwM3z@krava>
References: <20211204140700.396138-1-jolsa@kernel.org>
 <20211204140700.396138-3-jolsa@kernel.org>
 <61ae66d49f24f_c5bd208bf@john.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61ae66d49f24f_c5bd208bf@john.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 11:39:00AM -0800, John Fastabend wrote:
> Jiri Olsa wrote:
> > Adding following helpers for tracing programs:
> > 
> > Get n-th argument of the traced function:
> >   long bpf_get_func_arg(void *ctx, u32 n, u64 *value)
> > 
> > Get return value of the traced function:
> >   long bpf_get_func_ret(void *ctx, u64 *value)
> > 
> > Get arguments count of the traced funtion:
> >   long bpf_get_func_arg_cnt(void *ctx)
> > 
> > The trampoline now stores number of arguments on ctx-8
> > address, so it's easy to verify argument index and find
> > return value argument's position.
> > 
> > Moving function ip address on the trampoline stack behind
> > the number of functions arguments, so it's now stored on
> > ctx-16 address if it's needed.
> > 
> > All helpers above are inlined by verifier.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index c26871263f1f..d5a3791071d6 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -4983,6 +4983,31 @@ union bpf_attr {
> >   *	Return
> >   *		The number of loops performed, **-EINVAL** for invalid **flags**,
> >   *		**-E2BIG** if **nr_loops** exceeds the maximum number of loops.
> > + *
> > + * long bpf_get_func_arg(void *ctx, u32 n, u64 *value)
> > + *	Description
> > + *		Get **n**-th argument (zero based) of the traced function (for tracing programs)
> > + *		returned in **value**.
> > + *
> > + *	Return
> > + *		0 on success.
> > + *		**-EINVAL** if n >= arguments count of traced function.
> > + *
> > + * long bpf_get_func_ret(void *ctx, u64 *value)
> > + *	Description
> > + *		Get return value of the traced function (for tracing programs)
> > + *		in **value**.
> > + *
> > + *	Return
> > + *		0 on success.
> > + *		**-EINVAL** for tracing programs other than BPF_TRACE_FEXIT or BPF_MODIFY_RETURN.
> 
> 
> Can we just throw a verifier error if the program type doesn't support
> this? Then weget a void and ther is no error case.

we discussed this with Andrii in previous version:
  https://lore.kernel.org/bpf/CAEf4BzbauHaDDJvGpx4oCRddd4KWpb4PkxUiUJvx-CXqEN2sdQ@mail.gmail.com/

having it this way will allow us for example to use one program
for both fentry and fexit hooks

> 
> > + *
> > + * long bpf_get_func_arg_cnt(void *ctx)
> > + *	Description
> > + *		Get number of arguments of the traced function (for tracing programs).
> > + *
> > + *	Return
> > + *		The number of arguments of the traced function.
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)		\
> >  	FN(unspec),			\
> > @@ -5167,6 +5192,9 @@ union bpf_attr {
> >  	FN(kallsyms_lookup_name),	\
> >  	FN(find_vma),			\
> >  	FN(loop),			\
> > +	FN(get_func_arg),		\
> > +	FN(get_func_ret),		\
> > +	FN(get_func_arg_cnt),		\
> >  	/* */
> >  
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 6522ffdea487..cf6853d3a8e9 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -12974,6 +12974,7 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env,
> >  static int do_misc_fixups(struct bpf_verifier_env *env)
> >  {
> >  	struct bpf_prog *prog = env->prog;
> > +	enum bpf_attach_type eatype = prog->expected_attach_type;
> >  	bool expect_blinding = bpf_jit_blinding_enabled(prog);
> >  	enum bpf_prog_type prog_type = resolve_prog_type(prog);
> >  	struct bpf_insn *insn = prog->insnsi;
> > @@ -13344,11 +13345,79 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
> >  			continue;
> >  		}
> >  
> 
> [...]
> 
> > +		/* Implement get_func_arg_cnt inline. */
> > +		if (prog_type == BPF_PROG_TYPE_TRACING &&
> > +		    insn->imm == BPF_FUNC_get_func_arg_cnt) {
> > +			/* Load nr_args from ctx - 8 */
> > +			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
> > +
> > +			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 1);
> > +			if (!new_prog)
> > +				return -ENOMEM;
> 
> How does this handle the !x86 case? The code above only touches the x86
> jit? Perhaps its obvious with some code digging, but its not to me from
> the patch description and code here.

right, it assumes all 3 helpers are called from trampoline only 

so I think I mis-placed the verifier's bpf_func_proto 'get' for all 3 helpers,
it should be in tracing_prog_func_proto rather than in bpf_tracing_func_proto
plus perhaps check for proper attach type

thanks
jirka

> 
> > +
> > +			env->prog = prog = new_prog;
> > +			insn      = new_prog->insnsi + i + delta;
> > +			continue;
> > +		}
> > +
> 

