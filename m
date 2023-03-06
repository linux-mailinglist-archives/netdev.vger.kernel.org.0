Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072F36AB729
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 08:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjCFHge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 02:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjCFHgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 02:36:33 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF17EB52;
        Sun,  5 Mar 2023 23:36:31 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id j11so15060949edq.4;
        Sun, 05 Mar 2023 23:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678088190;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8nSlJRmoyDB/IYKTqktglboL1Hxr7Hmu138PGkNs4m0=;
        b=CdDfju1ZS+OHMPB4/lVRm31i1vCgw8tmfm9kCBG5SUn+Y8gA17eglXbzndPc5r7BdI
         6IZ4TpODdqW5eB3EyI01dO1wh8dqZQjUm9pggObL1fbvlRD6KY6N0oUXJLZ5wsQSkAgb
         6vuhbpdCo1gfYtaninaGdWSH+8gGxBz44ho4+dSXyCuhFa4idy1rC6HBBMAlcLsoNuuj
         0axGB4lCfYobnW7Tjhw4i7G96APF7FWWQ9IAcQU5eIzGawPHQlMr0qjOtUoM50Dwf3lF
         lOEf6RkjETupgE5mzuX0ZyM0lsgvGLPD0s60Q7fJc62Vc+8Lcn40M0IOfOX00Ubzcqw1
         TuMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678088190;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8nSlJRmoyDB/IYKTqktglboL1Hxr7Hmu138PGkNs4m0=;
        b=A1wC5xt0N6gpGIfUkvqrk/idW6F9vHIdorTvbYwuVxMgZBJK6HL2H4QMX5c/myIWiE
         JCK/Gu8U2ZR7hRdDMh2E/QAPFC8UBP+1aNfOmK2MXdfcgJ0IiZZwj/kWohDxZNMYOOhY
         NqICquoUbhaJ0CpPVXHgVO1lGN3Ny9ThpyorLZN1j/sNyZHrcDoz9Dbqjz3Plqv66Yjh
         SSVJOkRmIhfIN1NmxWv6wjF+KqwnJKGYDHSR/eZZsXUs1FM/cz1ljcdD/7DqXZx0E0F1
         TeEAv15qCvqwj/RSuf6GvrkhXZjvztEQ8XHJRnMlytaypqB+fsSTf7MR9yILs3iD6f+o
         D7CA==
X-Gm-Message-State: AO0yUKWoAZNQuXmu/ATlKnL0/Yg1utriH97p4tbkuWJpjHf19MEy8lO0
        mYiBzgjvtBmZSZVbNkNUbzVhnD6tdDv3Lw==
X-Google-Smtp-Source: AK7set/cHifXnvtA4ryRSFVvVZh1qM/3vBQu3D+M8krSAAF2Jg8shWiVIW40/uTv8JnBDNDFOFqKFw==
X-Received: by 2002:a17:906:52ca:b0:8ae:b008:9b5a with SMTP id w10-20020a17090652ca00b008aeb0089b5amr9360637ejn.69.1678088190017;
        Sun, 05 Mar 2023 23:36:30 -0800 (PST)
Received: from localhost ([2a02:1210:74a0:3200:2fc:d4f0:c121:5e8b])
        by smtp.gmail.com with ESMTPSA id ku17-20020a170907789100b008def483cf79sm4131727ejc.168.2023.03.05.23.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Mar 2023 23:36:29 -0800 (PST)
Date:   Mon, 6 Mar 2023 08:36:28 +0100
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf@vger.kernel.org, martin.lau@kernel.org, andrii@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org
Subject: Re: [PATCH v13 bpf-next 03/10] bpf: Allow initializing dynptrs in
 kfuncs
Message-ID: <20230306073628.g2kg5vp6lw6vzyya@apollo>
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-4-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301154953.641654-4-joannelkoong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 04:49:46PM CET, Joanne Koong wrote:
> This change allows kfuncs to take in an uninitialized dynptr as a
> parameter. Before this change, only helper functions could successfully
> use uninitialized dynptrs. This change moves the memory access check
> (including stack state growing and slot marking) into
> process_dynptr_func(), which both helpers and kfuncs call into.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  kernel/bpf/verifier.c | 67 ++++++++++++++-----------------------------
>  1 file changed, 22 insertions(+), 45 deletions(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index e0e00509846b..82e39fc5ed05 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -268,7 +268,6 @@ struct bpf_call_arg_meta {
>  	u32 ret_btf_id;
>  	u32 subprogno;
>  	struct btf_field *kptr_field;
> -	u8 uninit_dynptr_regno;
>  };
>
>  struct btf *btf_vmlinux;
> @@ -6225,10 +6224,11 @@ static int process_kptr_func(struct bpf_verifier_env *env, int regno,
>   * Helpers which do not mutate the bpf_dynptr set MEM_RDONLY in their argument
>   * type, and declare it as 'const struct bpf_dynptr *' in their prototype.
>   */
> -static int process_dynptr_func(struct bpf_verifier_env *env, int regno,
> -			       enum bpf_arg_type arg_type, struct bpf_call_arg_meta *meta)
> +static int process_dynptr_func(struct bpf_verifier_env *env, int regno, int insn_idx,
> +			       enum bpf_arg_type arg_type)
>  {
>  	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
> +	int err;
>
>  	/* MEM_UNINIT and MEM_RDONLY are exclusive, when applied to an
>  	 * ARG_PTR_TO_DYNPTR (or ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_*):
> @@ -6254,23 +6254,23 @@ static int process_dynptr_func(struct bpf_verifier_env *env, int regno,
>  	 *		 to.
>  	 */
>  	if (arg_type & MEM_UNINIT) {
> +		int i;
> +
>  		if (!is_dynptr_reg_valid_uninit(env, reg)) {
>  			verbose(env, "Dynptr has to be an uninitialized dynptr\n");
>  			return -EINVAL;
>  		}
>
> -		/* We only support one dynptr being uninitialized at the moment,
> -		 * which is sufficient for the helper functions we have right now.
> -		 */
> -		if (meta->uninit_dynptr_regno) {
> -			verbose(env, "verifier internal error: multiple uninitialized dynptr args\n");
> -			return -EFAULT;
> +		/* we write BPF_DW bits (8 bytes) at a time */
> +		for (i = 0; i < BPF_DYNPTR_SIZE; i += 8) {
> +			err = check_mem_access(env, insn_idx, regno,
> +					       i, BPF_DW, BPF_WRITE, -1, false);
> +			if (err)
> +				return err;
>  		}

I am not sure moving check_mem_access into process_dynptr_func is the right
thing to do. Not sure if a problem already, but sooner or later it might be.

The side effects of the call should take effect on the current state only after
we have gone through all arguments for the helper/kfunc call. In this case we
will now do stack access while processing the dynptr arg, which may affect the
state of stack we see through other memory arguments coming later.

I think it is better to do it after argument processing is done, similar to
existing meta.access_size handling which is done after check_func_arg loop (for
the same reasons).

> [...]
