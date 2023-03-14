Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7FC56B8691
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjCNAHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjCNAHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:07:10 -0400
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55058E3FE;
        Mon, 13 Mar 2023 17:07:09 -0700 (PDT)
Received: by mail-qt1-f180.google.com with SMTP id r5so15151485qtp.4;
        Mon, 13 Mar 2023 17:07:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678752429;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mkT7iYZlk8zKVkeNFWlF6DQQY7Ctr1B0wcmYzIHetis=;
        b=btHTYsArN18UgHpB55ag+RjHSRmpKEVom10KT6i5yP5NZmlGKY4UOi/Pw9qi6KQiZX
         FTOZhFoJ2ASeKvW+AEzlc614aXsswQcKJsHmhRRcYf/YZes7qwvrIKFwlkdod4awZ5Fw
         6Gulkdh9xp+y7mAoy6L49SYXzZi9TSAWytWY1n3XtsyzFbLURYaOykL334GmReTfY7Tf
         unlGEs+f/FbDzio6bqIf6biRH4eFI0Oc2yybyjFf7CzGWsnWUjCsTG1mm5lhQa/Ol+OE
         IIXmshThmgt+aZDPW434y3N4aAI6poZ2VM/A8KYKZoXD6Vo4mpZeY+CcRSOYScKTrx7t
         3K/g==
X-Gm-Message-State: AO0yUKWZJfkWB1Zhj1Fazv+qbficvlE9dTTM7Z6pLO8hRkZgZ9qnNNeR
        drhRkRxS7cWADCqYBcbabG9SuRBLiyucwYSR
X-Google-Smtp-Source: AK7set/mxDELQL+cu2fIlvSANwdJ5yoWC6xC/1aV4yhmb6F2fNQQiz2BcKg+FOrfe2IOZYQV9EQTtw==
X-Received: by 2002:a05:622a:1443:b0:3bf:c178:c6ea with SMTP id v3-20020a05622a144300b003bfc178c6eamr59114809qtx.56.1678752428736;
        Mon, 13 Mar 2023 17:07:08 -0700 (PDT)
Received: from maniforge ([2620:10d:c091:400::5:b967])
        by smtp.gmail.com with ESMTPSA id r18-20020ac85e92000000b003b34650039bsm735629qtx.76.2023.03.13.17.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 17:07:08 -0700 (PDT)
Date:   Mon, 13 Mar 2023 19:07:06 -0500
From:   David Vernet <void@manifault.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next 2/3] bpf: Allow helpers access trusted
 PTR_TO_BTF_ID.
Message-ID: <20230314000706.GB202344@maniforge>
References: <20230313235845.61029-1-alexei.starovoitov@gmail.com>
 <20230313235845.61029-3-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313235845.61029-3-alexei.starovoitov@gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 04:58:44PM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> The verifier rejects the code:
>   bpf_strncmp(task->comm, 16, "my_task");
> with the message:
>   16: (85) call bpf_strncmp#182
>   R1 type=trusted_ptr_ expected=fp, pkt, pkt_meta, map_key, map_value, mem, ringbuf_mem, buf
> 
> Teach the verifier that such access pattern is safe.
> Do not allow untrusted and legacy ptr_to_btf_id to be passed into helpers.
> 
> Reported-by: David Vernet <void@manifault.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: David Vernet <void@manifault.com>

> ---
>  kernel/bpf/verifier.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 883d4ff2e288..2bbd89279070 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -6303,6 +6303,9 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
>  				env,
>  				regno, reg->off, access_size,
>  				zero_size_allowed, ACCESS_HELPER, meta);
> +	case PTR_TO_BTF_ID:
> +		return check_ptr_to_btf_access(env, regs, regno, reg->off,
> +					       access_size, BPF_READ, -1);
>  	case PTR_TO_CTX:
>  		/* in case the function doesn't know how to access the context,
>  		 * (because we are in a program of type SYSCALL for example), we
> @@ -7014,6 +7017,7 @@ static const struct bpf_reg_types mem_types = {
>  		PTR_TO_MEM,
>  		PTR_TO_MEM | MEM_RINGBUF,
>  		PTR_TO_BUF,
> +		PTR_TO_BTF_ID | PTR_TRUSTED,
>  	},
>  };
>  
> @@ -7145,6 +7149,17 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
>  	if (base_type(reg->type) != PTR_TO_BTF_ID)
>  		return 0;
>  
> +	if (compatible == &mem_types) {
> +		if (!(arg_type & MEM_RDONLY)) {
> +			verbose(env,
> +				"%s() may write into memory pointed by R%d type=%s\n",
> +				func_id_name(meta->func_id),
> +				regno, reg_type_str(env, reg->type));
> +			return -EACCES;
> +		}
> +		return 0;
> +	}
> +
>  	switch ((int)reg->type) {
>  	case PTR_TO_BTF_ID:
>  	case PTR_TO_BTF_ID | PTR_TRUSTED:
> -- 
> 2.34.1
> 
