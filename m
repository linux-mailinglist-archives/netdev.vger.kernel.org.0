Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8EF2735B3
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 00:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgIUWXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 18:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgIUWXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 18:23:39 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC40C061755;
        Mon, 21 Sep 2020 15:23:39 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gf14so482330pjb.5;
        Mon, 21 Sep 2020 15:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1j5BtrbIEhk+Z7E8WkLPxtpf9YSppEhFPYc8Rq00vxc=;
        b=datv3RSUPRNmt0lRa/AxFZEU7grLhUY5MpA1Qdz2KNgq6CxAwhQIWgUzhUJb7lOwk0
         A/zJqdXP0BCJALAcC2FDiWU7vJORvT4pSs6iSwq7Z2TkdczrGEuJm0fj77wePDMxsDMe
         ykV3/w48auEQFYREWmSJ88HlfSfyOLg04j4THDt/KvCtnQe+d+E0TUme8zJ1L/OkVpPf
         EbfJBc8+9t/omQHKLXWVlg5FcjWDFi72bb9q7QYjMpv5bXO7X5db9+Tar3u0jfKJ9D6t
         TBswgJIv499jipAD3K1v8pVShc8col7OIz6jmT8gNRcpOYWutrQKi765h83uJMP8TOJl
         rSfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1j5BtrbIEhk+Z7E8WkLPxtpf9YSppEhFPYc8Rq00vxc=;
        b=ZzCUk+QVncGVp+JpXEOxvw3Ibcylob1OeHQHurhHQKipvvw637F2gKak/gurMEtgGi
         eK6UCq5yarqvOYi7ifv58O8c1DcJ5kkWJpnpcr+1nIDHd+YaC6mY2K0gYbeox+24aBIY
         Hty/zOXqLpqK32ulMeYswCIu3nJcctM2DQ+vED/M7mAUb/f9WSWckS4EXC5RURcVp9fy
         twT8SxY9CGDrdAdf+9AlDLxL4t5DqkN2aqeNp0dRQV6PUq7tttqFrbc8fX6VoSqJaiRl
         162NrosAx6AE0PpzD735L6g1QgAdNgx47M50KidCfdfPWEp2fUnjAF/5abVu2us4aEqn
         dXSQ==
X-Gm-Message-State: AOAM5333TGMSygX+ujjPTVD3pHGXyyxVS5T4RRianLRMBge3o32XZlAZ
        L0lrv4RAKz9JPSp5zo7ZYrBZs00b8ac=
X-Google-Smtp-Source: ABdhPJyOZXMvqHoLU9lqrIvXhytlm9DbiQr+dwgUnhihvchhhLMMOyMHVxlM1qH0ecfOatgpjsxaPQ==
X-Received: by 2002:a17:90b:164e:: with SMTP id il14mr1181230pjb.5.1600727018797;
        Mon, 21 Sep 2020 15:23:38 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:b927])
        by smtp.gmail.com with ESMTPSA id c4sm399006pjq.7.2020.09.21.15.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 15:23:38 -0700 (PDT)
Date:   Mon, 21 Sep 2020 15:23:35 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v4 11/11] bpf: use a table to drive helper arg
 type checks
Message-ID: <20200921222335.lew7wmyrtuej5mrh@ast-mbp.dhcp.thefacebook.com>
References: <20200921121227.255763-1-lmb@cloudflare.com>
 <20200921121227.255763-12-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921121227.255763-12-lmb@cloudflare.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 01:12:27PM +0100, Lorenz Bauer wrote:
> +struct bpf_reg_types {
> +	const enum bpf_reg_type types[10];
> +};

any idea on how to make it more robust?

> +
> +static const struct bpf_reg_types *compatible_reg_types[] = {
> +	[ARG_PTR_TO_MAP_KEY]		= &map_key_value_types,
> +	[ARG_PTR_TO_MAP_VALUE]		= &map_key_value_types,
> +	[ARG_PTR_TO_UNINIT_MAP_VALUE]	= &map_key_value_types,
> +	[ARG_PTR_TO_MAP_VALUE_OR_NULL]	= &map_key_value_types,
> +	[ARG_CONST_SIZE]		= &scalar_types,
> +	[ARG_CONST_SIZE_OR_ZERO]	= &scalar_types,
> +	[ARG_CONST_ALLOC_SIZE_OR_ZERO]	= &scalar_types,
> +	[ARG_CONST_MAP_PTR]		= &const_map_ptr_types,
> +	[ARG_PTR_TO_CTX]		= &context_types,
> +	[ARG_PTR_TO_CTX_OR_NULL]	= &context_types,
> +	[ARG_PTR_TO_SOCK_COMMON]	= &sock_types,
> +	[ARG_PTR_TO_SOCKET]		= &fullsock_types,
> +	[ARG_PTR_TO_SOCKET_OR_NULL]	= &fullsock_types,
> +	[ARG_PTR_TO_BTF_ID]		= &btf_ptr_types,
> +	[ARG_PTR_TO_SPIN_LOCK]		= &spin_lock_types,
> +	[ARG_PTR_TO_MEM]		= &mem_types,
> +	[ARG_PTR_TO_MEM_OR_NULL]	= &mem_types,
> +	[ARG_PTR_TO_UNINIT_MEM]		= &mem_types,
> +	[ARG_PTR_TO_ALLOC_MEM]		= &alloc_mem_types,
> +	[ARG_PTR_TO_ALLOC_MEM_OR_NULL]	= &alloc_mem_types,
> +	[ARG_PTR_TO_INT]		= &int_ptr_types,
> +	[ARG_PTR_TO_LONG]		= &int_ptr_types,
> +	[__BPF_ARG_TYPE_MAX]		= NULL,

I don't understand what this extra value is for.
I tried:
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fc5c901c7542..87b0d5dcc1ff 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -292,7 +292,6 @@ enum bpf_arg_type {
        ARG_PTR_TO_ALLOC_MEM,   /* pointer to dynamically allocated memory */
        ARG_PTR_TO_ALLOC_MEM_OR_NULL,   /* pointer to dynamically allocated memory or NULL */
        ARG_CONST_ALLOC_SIZE_OR_ZERO,   /* number of allocated bytes requested */
-       __BPF_ARG_TYPE_MAX,
 };

 /* type of values returned from helper functions */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 15ab889b0a3f..83faa67858b6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4025,7 +4025,6 @@ static const struct bpf_reg_types *compatible_reg_types[] = {
        [ARG_PTR_TO_ALLOC_MEM_OR_NULL]  = &alloc_mem_types,
        [ARG_PTR_TO_INT]                = &int_ptr_types,
        [ARG_PTR_TO_LONG]               = &int_ptr_types,
-       [__BPF_ARG_TYPE_MAX]            = NULL,
 };

and everything is fine as I think it should be.

> +	compatible = compatible_reg_types[arg_type];
> +	if (!compatible) {
> +		verbose(env, "verifier internal error: unsupported arg type %d\n", arg_type);
>  		return -EFAULT;
>  	}

This check will trigger the same way when somebody adds new ARG_* and doesn't add to the table.

>  
> +	err = check_reg_type(env, regno, compatible);
> +	if (err)
> +		return err;
> +
>  	if (type == PTR_TO_BTF_ID) {
>  		const u32 *btf_id = fn->arg_btf_id[arg];
>  
> @@ -4174,10 +4213,6 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>  	}
>  
>  	return err;
> -err_type:
> -	verbose(env, "R%d type=%s expected=%s\n", regno,
> -		reg_type_str[type], reg_type_str[expected_type]);
> -	return -EACCES;

I'm not a fan of table driven checks. I think one explicit switch statement
would have been easier to read, but I guess we can convert back to it later if
table becomes too limiting. The improvement in the verifier output is important
and justifies this approach.

Applied to bpf-next. Thanks!
