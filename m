Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048EF1FD32A
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgFQRJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbgFQRJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 13:09:14 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EF4C06174E;
        Wed, 17 Jun 2020 10:09:13 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id h95so1367319pje.4;
        Wed, 17 Jun 2020 10:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=idTgR3OxjMHNtCLNRt5gSOfMSNeQMCjvcLgQtbsY/+4=;
        b=dnHj7qg+reRZPYIb4+4tyWOmlZMqaKSGsJ8Gd9sGpyvAe6ykeGJZwQ9Tx8ISP5LyCZ
         JRVc6+1ZQ99zlGA3TfFs+Avjr7ZMi2B8PAo17TYraV6IvzUW8qgOJdyAOWYuwCaQ3Sg2
         dRja6UNLxL53f5tShKoc6YoH/+M8wr8IMAwXnWzXbnHgp1ZkYe9yCZ9KdLtCo4mVnXsc
         o0pvvn+RSKBtd2OilxpG0r8pikcAdK8s/NYWvqH9UAj2hIJVz2WSz/Dkxuc2TVxUMQ2d
         IR/1tVJFbqgp6+SKTExU8k6Cg9r3b6Xcsne5/EKklATbv5sckU11PWRdwLcjMgvYu0l0
         huMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=idTgR3OxjMHNtCLNRt5gSOfMSNeQMCjvcLgQtbsY/+4=;
        b=qm2VtmhGrpEan/czlH3FeeI+et22SSPAx4N0jLrIZqGAXkrKpFIsZduEzvkJADbpZ0
         9Icx3qKgrUIpLOH6m8E4/AVd7z1KR+IaWIvIJ4/sO3s03QHxmQp+TocoxKmCjuGUbo4n
         B9K+hhEZf5EAbSukghpKFx0HaaX9KdwnQc2iKCjxwPqahoMw8lzS+pm5IeBRd14sTqd2
         P2YNyrVbLc2doYcJVF5SckJslF4iueDcepsBssWrX7jJ09uHfiQd714xmTQS+6Tm3YN1
         mURZGG52TtpLK3GJWvku2IzIpA9cX/jUJug19b/HWz6bXFujgAUhSKWNj7mWStSTFYMU
         EyUQ==
X-Gm-Message-State: AOAM533yhWFnu/AGROtPOD1J77HrKH6Wn6sB9UqaZeMWUiY3ZM/4SYHm
        hlnT5havbsm4Gfk65D60yDw=
X-Google-Smtp-Source: ABdhPJwr2ScYm/EDWciF3FgaluiZXymy0N2t6o3x0L/K5XjP4v4ACSE0CfTxLCGpGCD8GucNWDXFHg==
X-Received: by 2002:a17:902:7246:: with SMTP id c6mr31629pll.191.1592413752596;
        Wed, 17 Jun 2020 10:09:12 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:7972])
        by smtp.gmail.com with ESMTPSA id q68sm162266pjc.30.2020.06.17.10.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 10:09:11 -0700 (PDT)
Date:   Wed, 17 Jun 2020 10:09:09 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net,
        David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH bpf v5 1/3] bpf: don't return EINVAL from
 {get,set}sockopt when optlen > PAGE_SIZE
Message-ID: <20200617170909.koev3t5fmngla3c4@ast-mbp.dhcp.thefacebook.com>
References: <20200617010416.93086-1-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617010416.93086-1-sdf@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 06:04:14PM -0700, Stanislav Fomichev wrote:
> Attaching to these hooks can break iptables because its optval is
> usually quite big, or at least bigger than the current PAGE_SIZE limit.
> David also mentioned some SCTP options can be big (around 256k).
> 
> For such optvals we expose only the first PAGE_SIZE bytes to
> the BPF program. BPF program has two options:
> 1. Set ctx->optlen to 0 to indicate that the BPF's optval
>    should be ignored and the kernel should use original userspace
>    value.
> 2. Set ctx->optlen to something that's smaller than the PAGE_SIZE.
> 
> v5:
> * use ctx->optlen == 0 with trimmed buffer (Alexei Starovoitov)
> * update the docs accordingly
> 
> v4:
> * use temporary buffer to avoid optval == optval_end == NULL;
>   this removes the corner case in the verifier that might assume
>   non-zero PTR_TO_PACKET/PTR_TO_PACKET_END.
> 
> v3:
> * don't increase the limit, bypass the argument
> 
> v2:
> * proper comments formatting (Jakub Kicinski)
> 
> Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
> Cc: David Laight <David.Laight@ACULAB.COM>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  kernel/bpf/cgroup.c | 53 ++++++++++++++++++++++++++++-----------------
>  1 file changed, 33 insertions(+), 20 deletions(-)
> 
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 4d76f16524cc..ac53102e244a 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -1276,16 +1276,23 @@ static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
>  
>  static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
>  {
> -	if (unlikely(max_optlen > PAGE_SIZE) || max_optlen < 0)
> +	if (unlikely(max_optlen < 0))
>  		return -EINVAL;
>  
> +	if (unlikely(max_optlen > PAGE_SIZE)) {
> +		/* We don't expose optvals that are greater than PAGE_SIZE
> +		 * to the BPF program.
> +		 */
> +		max_optlen = PAGE_SIZE;
> +	}
> +
>  	ctx->optval = kzalloc(max_optlen, GFP_USER);
>  	if (!ctx->optval)
>  		return -ENOMEM;
>  
>  	ctx->optval_end = ctx->optval + max_optlen;
>  
> -	return 0;
> +	return max_optlen;
>  }
>  
>  static void sockopt_free_buf(struct bpf_sockopt_kern *ctx)
> @@ -1319,13 +1326,13 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
>  	 */
>  	max_optlen = max_t(int, 16, *optlen);
>  
> -	ret = sockopt_alloc_buf(&ctx, max_optlen);
> -	if (ret)
> -		return ret;
> +	max_optlen = sockopt_alloc_buf(&ctx, max_optlen);
> +	if (max_optlen < 0)
> +		return max_optlen;
>  
>  	ctx.optlen = *optlen;
>  
> -	if (copy_from_user(ctx.optval, optval, *optlen) != 0) {
> +	if (copy_from_user(ctx.optval, optval, min(*optlen, max_optlen)) != 0) {
>  		ret = -EFAULT;
>  		goto out;
>  	}
> @@ -1353,8 +1360,14 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
>  		/* export any potential modifications */
>  		*level = ctx.level;
>  		*optname = ctx.optname;
> -		*optlen = ctx.optlen;
> -		*kernel_optval = ctx.optval;
> +
> +		/* optlen == 0 from BPF indicates that we should
> +		 * use original userspace data.
> +		 */
> +		if (ctx.optlen != 0) {
> +			*optlen = ctx.optlen;

I think it should be:
*optlen = min(ctx.optlen, max_optlen);

Otherwise when bpf prog doesn't adjust ctx.oplen the kernel will see
4k only in kernel_optval whereas optlen will be > 4k.
I suspect iptables sockopt should have crashed at this point.
How did you test it?

> +			*kernel_optval = ctx.optval;
> +		}
>  	}
>  
