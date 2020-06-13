Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA741F7FEE
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 02:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgFMAeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 20:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbgFMAeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 20:34:00 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBEAC03E96F;
        Fri, 12 Jun 2020 17:33:59 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id m2so4558881pjv.2;
        Fri, 12 Jun 2020 17:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YUFyv8386aH553PO7hcNPbcPivk11FYUWHAF8jUp1Sg=;
        b=EyFboyG4+Ogi5REcSnLm3cM4Us9aRldL5Jhpf5bTmpquKnX5efLq5n51Gf7kuoM0hJ
         XAxKafzQlSfJHUl/IToH+GQwjacsc800r6QZbvaidyMaP9QCaVDUBTE4q194UYYWSAMW
         cXXglxzH5XNWmgU48fulsreQWzvpwa+daEZfGNXKifP9jp8GLu0ovYfd4NYS9iGML+bU
         QPXi8QowT0Zoy+7bFoG/PYiOg66CtFTvh0kc+PG56obi8kLzF0wKpEWRgE3NUAOMxmHs
         hrYtTF5qpGINZtMNt9xMioRhMy+nHt7kDHWJ4SUsNq8b6dI2M3e3Dy7tCsQASRcmAUvD
         6+jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YUFyv8386aH553PO7hcNPbcPivk11FYUWHAF8jUp1Sg=;
        b=YlTSfRG40zNx1PMwNVij94TuyMgA+hQzkhuBcoe0Od5XyvEutXx5qqjiJFiXc8gFMa
         6iFmaJ26oqGjZgvi68q6lrYSKPImt952Y1nhENughMHuA0XIZ55P8M9tixibodW/hblW
         n5uRyEhlgIjYxXEus8g4KpI2/qykjiVskAdyavGXVoakc/u+fxJ5llEpC3APeWeXfra0
         pkh3CQbSlloOvr0+RaA41oppatVfOEChIEaRQEmT2A57Dlro9r0sOQl0VPLKFZhd8zPF
         oU94zoEMb1PlqrFQspXwKJvNAaMGjTBjSbE6dwyA6nFuc2KpTzsj6vhe+K0NhvcULq4K
         2ssw==
X-Gm-Message-State: AOAM533lPrMz93B5Yt28VOVDTMdYQc7yPKJTm7KxUXu5IEEUpgEPJBSH
        9iMyZt1KVddeTtvQuLjWipA=
X-Google-Smtp-Source: ABdhPJwoTUFSnYdM5OTVu6QKluwePOdVjOMr/m39rysO9NHlsRASIRArnp0MayLmqXNyRL2sWQb3Eg==
X-Received: by 2002:a17:90a:c5:: with SMTP id v5mr1394100pjd.192.1592008439358;
        Fri, 12 Jun 2020 17:33:59 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:7547])
        by smtp.gmail.com with ESMTPSA id d23sm2637806pjv.45.2020.06.12.17.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 17:33:58 -0700 (PDT)
Date:   Fri, 12 Jun 2020 17:33:56 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net,
        David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH bpf v3 1/2] bpf: don't return EINVAL from
 {get,set}sockopt when optlen > PAGE_SIZE
Message-ID: <20200613003356.sqp6zn3lnh4qeqyl@ast-mbp.dhcp.thefacebook.com>
References: <20200608182748.6998-1-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608182748.6998-1-sdf@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 11:27:47AM -0700, Stanislav Fomichev wrote:
> Attaching to these hooks can break iptables because its optval is
> usually quite big, or at least bigger than the current PAGE_SIZE limit.
> David also mentioned some SCTP options can be big (around 256k).
> 
> There are two possible ways to fix it:
> 1. Increase the limit to match iptables max optval. There is, however,
>    no clear upper limit. Technically, iptables can accept up to
>    512M of data (not sure how practical it is though).
> 
> 2. Bypass the value (don't expose to BPF) if it's too big and trigger
>    BPF only with level/optname so BPF can still decide whether
>    to allow/deny big sockopts.
> 
> The initial attempt was implemented using strategy #1. Due to
> listed shortcomings, let's switch to strategy #2. When there is
> legitimate a real use-case for iptables/SCTP, we can consider increasing
> the PAGE_SIZE limit.
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
>  kernel/bpf/cgroup.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index fdf7836750a3..758082853086 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -1276,9 +1276,18 @@ static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
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
> +		ctx->optval = NULL;
> +		ctx->optval_end = NULL;
> +		return 0;
> +	}

It's probably ok, but makes me uneasy about verifier consequences.
ctx->optval is PTR_TO_PACKET and it's a valid pointer from verifier pov.
Do we have cases already where PTR_TO_PACKET == PTR_TO_PACKET_END ?
I don't think we have such tests. I guess bpf prog won't be able to read
anything and nothing will crash, but having PTR_TO_PACKET that is
actually NULL would be an odd special case to keep in mind for everyone
who will work on the verifier from now on.

Also consider bpf prog that simply reads something small like 4 bytes.
IP_FREEBIND sockopt (like your selftest in the patch 2) will have
those 4 bytes, so it's natural for the prog to assume that it can read it.
It will have
p = ctx->optval;
if (p + 4 > ctx->optval_end)
 /* goto out and don't bother logging, since that never happens */
*(u32*)p;

but 'clever' user space would pass long optlen and prog suddenly
'not seeing' the sockopt. It didn't crash, but debugging would be
surprising.

I feel it's better to copy the first 4k and let the program see it.
