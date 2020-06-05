Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B891EF09C
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 06:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgFEEfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 00:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgFEEfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 00:35:22 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81ECC08C5C0;
        Thu,  4 Jun 2020 21:35:21 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x207so4339720pfc.5;
        Thu, 04 Jun 2020 21:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S8fxU/b+hS/02z8/Fi2fuN6b1XahhU46dgpE3JjTWdw=;
        b=q6LUs1q43BaRPunaLR8cgeHcbOGvNDJTVTrG51Opr4lczr9I0UPNqUh+yfyjOllRPq
         RL4e5MTJK6HcM2nW0LM9gu6ItiUChLizx9KGWKiWTCWEWBOU4wAUE7siXDe0uWkHMqlf
         Py11lfZZ8S8Fh1Vpwt2pU2mkQYmBXzKfyYdDFhXSp4ynjyybtXe/4ap409iZQYp3z53O
         J9gBWctlYraiNpj9PAM2Qfs60Rfj0iItPwcJsU8kdYccQyMKNLeQi/K7zbEoV6HdR+gz
         hzhFXM/5hkisv9pQgEZMrvxWh2iYms4KiNYgoBVkdSv34efvB66KHnJAP/Uvn/VMTD97
         bQOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S8fxU/b+hS/02z8/Fi2fuN6b1XahhU46dgpE3JjTWdw=;
        b=WhllyytVdBzS9ndbKofhmV0U6A6c5gfQvDxU6Z9tJ/3G1AfnIrnuphAyQ8xYw86oDp
         RYPSKyukv3g1SrTsUVZhGK1MVIiWOCZ0jatHA9aaEtDaDLC7h2D04I1IZK4G3YeiU/uV
         v9TZjueimMQtCQ7i7CDmerZ79Gr7KPDCVvKZiWDVCyrweVzh9rJW6MuoZ2fqeJvNS62t
         eZwVj2946rChyXtg0xrAmKCGQbs0GU/8dXjFsskdyYIP2klvBQLwGZalAXF56xnVf1xk
         siZCBw7foYBeNjPMgq4t+nfd1ZcrqPMbsyCnBqaIFYFO1s5R2CghLk4cCrNzz3zHKVnj
         BOBQ==
X-Gm-Message-State: AOAM532TfsESDuWhwGIZJZQbYOgDwntvpw6ry/Fs9lWVnN/u6+2UsWSW
        zaKqUOjtwyhMRS7m/mrZtY0=
X-Google-Smtp-Source: ABdhPJz8uwa3sOcOIG/9w7ggQ81aRt+bkWfd4oIdqdxA+yK9iwkxvGbH/fFLYOFcwbq6y49nPIHBAQ==
X-Received: by 2002:a63:4182:: with SMTP id o124mr7518049pga.195.1591331721105;
        Thu, 04 Jun 2020 21:35:21 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:3d39])
        by smtp.gmail.com with ESMTPSA id x2sm5936850pfj.142.2020.06.04.21.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 21:35:20 -0700 (PDT)
Date:   Thu, 4 Jun 2020 21:35:17 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH bpf v2] bpf: increase {get,set}sockopt optval size limit
Message-ID: <20200605043517.cupb77gzytqhanyk@ast-mbp.dhcp.thefacebook.com>
References: <20200605002155.93267-1-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605002155.93267-1-sdf@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 05:21:55PM -0700, Stanislav Fomichev wrote:
> Attaching to these hooks can break iptables because its optval is
> usually quite big, or at least bigger than the current PAGE_SIZE limit.
> 
> There are two possible ways to fix it:
> 1. Increase the limit to match iptables max optval.
> 2. Implement some way to bypass the value if it's too big and trigger
>    BPF only with level/optname so BPF can still decide whether
>    to allow/deny big sockopts.
> 
> I went with #1 which means we are potentially increasing the
> amount of data we copy from the userspace from PAGE_SIZE to 512M.
> 
> v2:
> * proper comments formatting (Jakub Kicinski)
> 
> Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  kernel/bpf/cgroup.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index fdf7836750a3..fb786b0f0f88 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -1276,7 +1276,14 @@ static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
>  
>  static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
>  {
> -	if (unlikely(max_optlen > PAGE_SIZE) || max_optlen < 0)
> +	/* The user with the largest known setsockopt optvals is iptables.
> +	 * Allocate enough space to accommodate it.
> +	 *
> +	 * See XT_MAX_TABLE_SIZE and sizeof(struct ipt_replace).
> +	 */
> +	const int max_supported_optlen = 512 * 1024 * 1024 + 128;

looks like arbitrary number. Why did you pick this one?
Also it won't work with kzalloc() below.
May be trim it to some number instead of hard failing ?
bpf prog cannot really examine more than few kbytes.

> +
> +	if (unlikely(max_optlen > max_supported_optlen) || max_optlen < 0)
>  		return -EINVAL;
>  
>  	ctx->optval = kzalloc(max_optlen, GFP_USER);
> -- 
> 2.27.0.278.ge193c7cf3a9-goog
> 
