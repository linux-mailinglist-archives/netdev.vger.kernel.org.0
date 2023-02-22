Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF5D69FD05
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 21:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbjBVUce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 15:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbjBVUcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 15:32:33 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCE937541;
        Wed, 22 Feb 2023 12:32:30 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id u14so6358634ple.7;
        Wed, 22 Feb 2023 12:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4SoNs2AKnQHfT4o3sdpr0qfSg+D9akMHdmyO9trz+Aw=;
        b=qAGSz3cV0cyYhf6nHtki8Gm7b+iF27+pcWqifxWYW/g/aYORuXkGSGO6Nnc6+gM8Li
         d909MOL+rPrEhg29f00/Vq/bB+stvMZyKjpgawhWlteCs4VkItFS4THNgny5F1pBqhwR
         Wv8A9sbrXS6LjyfBZrU5jSGzzmilyhtKeDAv+DeoT/UN5u9UHyOHmrspFDVSMyylqmt5
         yXJGj/u4Z9bw2uapOd8jmvWnpGnr3jzhS3+SATKpURztK1cbBFVJLx7NRw+J3LegzKCi
         Jbolq/TmOjiQDHJZZWK7WJdxwRJzTxDUvw1koZJibGzWuQJ/ZCZPKF5X9sfiUz1x2UXP
         yxJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4SoNs2AKnQHfT4o3sdpr0qfSg+D9akMHdmyO9trz+Aw=;
        b=IKlK3ZkcHVz2S3mniAiPk+o9r5tCagqBHsj/2yTSz6x8EwauJ6NPqzD8erzh7AYrIA
         Kn1hu8zoCXmVHOEQMFcYCOF2gSz9Ry5E/L/htmIFgu2u/7S7FFd5T0oIFYb08jJN7Crq
         iHsu5w1xmzAVcjVD3L7UROqXZUe+bAe91Q6pP1MjX5GLsKNucGSjl3eOrlzc9TmI2dK1
         PCKjLLMOziHyPgS8dV8rAltl7oBZCs+E2jk4Oq3tYtsk5Jh1y2XROYeYHYZHxJ1vdYIy
         1XCIURdfTXUhSxgxnwH7o7ltayc5GdSXzCpfn6PI1WN3rE4sZuFxTyP5zvCQYXX6vM3H
         Itbw==
X-Gm-Message-State: AO0yUKULlviV19ccSH8Ub0zErRQtYmVrsKwRAXL22JzVoFMxVfm2IZqD
        /E3Dw8yfGWscM+TydAu9MEE=
X-Google-Smtp-Source: AK7set/A+88kuxnSMd/VCcTL283WiNenLQTKBQLDG+GX39Va4ZYG2QFI+qWtMf5GXu4znAbsX91Ekg==
X-Received: by 2002:a05:6a21:329c:b0:c7:7248:4e42 with SMTP id yt28-20020a056a21329c00b000c772484e42mr12686181pzb.18.1677097949342;
        Wed, 22 Feb 2023 12:32:29 -0800 (PST)
Received: from MacBook-Pro-6.local ([2620:10d:c090:400::5:9cb3])
        by smtp.gmail.com with ESMTPSA id m18-20020a6562d2000000b005026c125d47sm5802061pgv.21.2023.02.22.12.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 12:32:28 -0800 (PST)
Date:   Wed, 22 Feb 2023 12:32:26 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf@vger.kernel.org, martin.lau@kernel.org, andrii@kernel.org,
        ast@kernel.org, memxor@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, kernel-team@fb.com, toke@kernel.org
Subject: Re: [PATCH v11 bpf-next 09/10] bpf: Add bpf_dynptr_slice and
 bpf_dynptr_slice_rdwr
Message-ID: <20230222203214.5e33mmjzljoaowbq@MacBook-Pro-6.local>
References: <20230222060747.2562549-1-joannelkoong@gmail.com>
 <20230222060747.2562549-10-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222060747.2562549-10-joannelkoong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 10:07:46PM -0800, Joanne Koong wrote:
> @@ -9975,8 +10023,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>  		}
>  	}
>  
> -	for (i = 0; i < CALLER_SAVED_REGS; i++)
> -		mark_reg_not_init(env, regs, caller_saved[i]);
> +	mark_reg_not_init(env, regs, caller_saved[BPF_REG_0]);

...

>  	/* Check return type */
>  	t = btf_type_skip_modifiers(desc_btf, func_proto->type, NULL);
> @@ -10062,6 +10109,41 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>  				regs[BPF_REG_0].type = PTR_TO_BTF_ID | PTR_UNTRUSTED;
>  				regs[BPF_REG_0].btf = desc_btf;
>  				regs[BPF_REG_0].btf_id = meta.arg_constant.value;
> +			} else if (meta.func_id == special_kfunc_list[KF_bpf_dynptr_slice] ||
> +				   meta.func_id == special_kfunc_list[KF_bpf_dynptr_slice_rdwr]) {
> +				enum bpf_type_flag type_flag = get_dynptr_type_flag(meta.initialized_dynptr.type);
> +
> +				mark_reg_known_zero(env, regs, BPF_REG_0);
> +
> +				if (!tnum_is_const(regs[BPF_REG_4].var_off)) {
> +					verbose(env, "mem_size must be a constant\n");
> +					return -EINVAL;
> +				}
> +				regs[BPF_REG_0].mem_size = regs[BPF_REG_4].var_off.value;

This is a bit fragile.
Instead of moving above 'for' may be let's use meta.arg_constant approach ?
Just doing:
if (is_kfunc_arg_constant(meta->btf, &args[i]) || is_kfunc_arg_mem_size(...))
won't quite work, since we'll be doing mark_chain_precision() twice.
(check_kfunc_mem_size_reg() will do it 2nd time).

Another issue is that __sz allows var_off, but bpf_dynptr_slice() needs tnum_is_const
and the patch is doing it explicitly.
Ideally some combination of __sz and __k is needed.

I don't like our suffix logic, but maybe let's do quick "__szk" for now ?
Then it can do normal __sz check and in addition do tnum_is_const() check
and set meta.arg_constant ?

Then 'for' will stay in place and regs[BPF_REG_4] won't be needed.

> +
> +				/* PTR_MAYBE_NULL will be added when is_kfunc_ret_null is checked */
> +				regs[BPF_REG_0].type = PTR_TO_MEM | type_flag;
> +
> +				if (meta.func_id == special_kfunc_list[KF_bpf_dynptr_slice]) {
> +					regs[BPF_REG_0].type |= MEM_RDONLY;
> +				} else {
> +					/* this will set env->seen_direct_write to true */
> +					if (!may_access_direct_pkt_data(env, NULL, BPF_WRITE)) {
> +						verbose(env, "the prog does not allow writes to packet data\n");
> +						return -EINVAL;
> +					}
> +				}
> +
> +				if (!meta.initialized_dynptr.id) {
> +					verbose(env, "verifier internal error: no dynptr id\n");
> +					return -EFAULT;
> +				}
> +				regs[BPF_REG_0].dynptr_id = meta.initialized_dynptr.id;
> +
> +				/* we don't need to set BPF_REG_0's ref obj id
> +				 * because packet slices are not refcounted (see
> +				 * dynptr_type_refcounted)
> +				 */
>  			} else {
>  				verbose(env, "kernel function %s unhandled dynamic return type\n",
>  					meta.func_name);
> @@ -10121,6 +10203,9 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>  			regs[BPF_REG_0].id = ++env->id_gen;
>  	} /* else { add_kfunc_call() ensures it is btf_type_is_void(t) } */
>  
> +	for (i = BPF_REG_1; i < CALLER_SAVED_REGS; i++)
> +		mark_reg_not_init(env, regs, caller_saved[i]);
> +
