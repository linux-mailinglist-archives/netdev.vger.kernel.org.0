Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0216953CE1C
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 19:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344502AbiFCReI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 13:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344493AbiFCReH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 13:34:07 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFD452B17;
        Fri,  3 Jun 2022 10:34:07 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id u12-20020a17090a1d4c00b001df78c7c209so12622758pju.1;
        Fri, 03 Jun 2022 10:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=cdqPGWFLl2ixHd1tMn/2WHCtX6ExuPscFLYPj6FpsVc=;
        b=G/aBmedgMCNwdkYurSzeGg6U347KOZwBCbhQhD8U5bB4BksJxHxUP//f+gV+haAaoW
         YhXoYrmuWy8ETBTKEGR9VmBWsp4jmpy4408x44BH0C3CLFP8s//eMIFeeu8MilMDwtrd
         O5LOmH3w88xxOwcK75Koa8BHsD7LBIzza81N6IY8snx/Rlgv40637dA7rcyhTk5C/ibq
         QSMha8nPUCthYkVXJt5SxD4XJl4i9102sejCpVkd+JJzbFm6QVFkQRk4+Op4AWEnomga
         ajnbCaopu2tIQ83VlfmVAszo8YzoABUDF8LhA9l68ebCrfRZT5M2jFKD9deekzndkCQp
         r+WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cdqPGWFLl2ixHd1tMn/2WHCtX6ExuPscFLYPj6FpsVc=;
        b=3hWB6DBYHf5ZOCZRLTAF8kKfuyqb+tmYUBb4eUk2P7T5XjqA46870rOqmUSErCoar6
         BsdBTXEBueQJ+o6dmwVEAg6D9uZrNPiHCuk5YCYUU5sgpIkRGbh6fev5zcPVZtgQ2+wO
         DQBQC7yZA8FTUiJMAUEw+nnjmrqg7LdfD8R4IYomGZIfleVBzK6HWm6qB9vQhq+8LWal
         guOgkQFJeQh1YhCf8QA74bSsXFYJ+M9z0r54yNzmhqdOzAN+8qMJoETrF1KSC3id5Aas
         tpwACr/3CIGv82Nl3zyYCB4APRiqBv23aEB95fk8ER5bP+ZnKh0gFvbHf3QHIGeRZgiH
         JBMQ==
X-Gm-Message-State: AOAM531yHQnlORcnzxuZMHaM/EuGyRDlGL9QoUBlVvyNfvoWL8xfHyEQ
        WwQ5BDtBsianZz8k7FftNWU=
X-Google-Smtp-Source: ABdhPJwRXdUOQd9XjVjtn6pEO6ZZ2k4haGF34IHOEqqx6CRNSXb1KbRUjNgeJIOanXTsB4txNWbIrQ==
X-Received: by 2002:a17:902:ccc8:b0:162:6ea:4d with SMTP id z8-20020a170902ccc800b0016206ea004dmr11238123ple.144.1654277646375;
        Fri, 03 Jun 2022 10:34:06 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0c0:79de:f3f4:353c:8616])
        by smtp.gmail.com with ESMTPSA id b10-20020a17090a5a0a00b001cd4989febcsm8087797pjd.8.2022.06.03.10.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 10:34:06 -0700 (PDT)
Date:   Fri, 3 Jun 2022 23:04:03 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Simon Sundberg <simon.sundberg@kau.se>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf 1/2] bpf: Fix calling global functions from
 BPF_PROG_TYPE_EXT programs
Message-ID: <20220603173403.rshyftcseryug4rm@apollo.legion>
References: <20220603154028.24904-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220603154028.24904-1-toke@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 03, 2022 at 09:10:26PM IST, Toke Høiland-Jørgensen wrote:
> The verifier allows programs to call global functions as long as their
> argument types match, using BTF to check the function arguments. One of the
> allowed argument types to such global functions is PTR_TO_CTX; however the
> check for this fails on BPF_PROG_TYPE_EXT functions because the verifier
> uses the wrong type to fetch the vmlinux BTF ID for the program context
> type. This failure is seen when an XDP program is loaded using
> libxdp (which loads it as BPF_PROG_TYPE_EXT and attaches it to a global XDP
> type program).
>
> Fix the issue by passing in the target program type instead of the
> BPF_PROG_TYPE_EXT type to bpf_prog_get_ctx() when checking function
> argument compatibility.
>
> The first Fixes tag refers to the latest commit that touched the code in
> question, while the second one points to the code that first introduced
> the global function call verification.
>
> Fixes: 3363bd0cfbb8 ("bpf: Extend kfunc with PTR_TO_CTX, PTR_TO_MEM argument support")
> Fixes: 51c39bb1d5d1 ("bpf: Introduce function-by-function verification")
> Reported-by: Simon Sundberg <simon.sundberg@kau.se>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  kernel/bpf/btf.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 7bccaa4646e5..361de7304c4d 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -6054,6 +6054,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>  				    struct bpf_reg_state *regs,
>  				    bool ptr_to_mem_ok)
>  {
> +	enum bpf_prog_type prog_type = env->prog->type;
>  	struct bpf_verifier_log *log = &env->log;
>  	u32 i, nargs, ref_id, ref_obj_id = 0;
>  	bool is_kfunc = btf_is_kernel(btf);
> @@ -6095,6 +6096,9 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>  						     BTF_KFUNC_TYPE_KPTR_ACQUIRE, func_id);
>  	}
>
> +	if (prog_type == BPF_PROG_TYPE_EXT && env->prog->aux->dst_prog)
> +		prog_type = env->prog->aux->dst_prog->type;
> +

nit: it might be better to reuse resolve_prog_type here.

>  	/* check that BTF function arguments match actual types that the
>  	 * verifier sees.
>  	 */
> @@ -6171,7 +6175,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>  				return -EINVAL;
>  			}
>  			/* rest of the arguments can be anything, like normal kfunc */
> -		} else if (btf_get_prog_ctx_type(log, btf, t, env->prog->type, i)) {
> +		} else if (btf_get_prog_ctx_type(log, btf, t, prog_type, i)) {
>  			/* If function expects ctx type in BTF check that caller
>  			 * is passing PTR_TO_CTX.
>  			 */
> --
> 2.36.1
>

--
Kartikeya
