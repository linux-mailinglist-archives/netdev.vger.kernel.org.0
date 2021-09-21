Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A56412DAD
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 06:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhIUEIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 00:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbhIUEIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 00:08:05 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FACC06175F
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 21:06:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so1026109pjb.2
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 21:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zn1EkZZtYwu+/CqIaImEzdF2wzQ3/Q4ICvhMSwY9pc4=;
        b=Mplo5+lxH3SP68tQyWmFu/JWZyX9HRHbKiM7MH93oAMFkjf89geoL5h+W5avJnSX0u
         qupSiaeZZ7SpByvqSFmys6LAoCfR91AB5YSr4tEfj2gLJ1B9VV3Ol4hqfOgCbnoqgWBl
         N2eHgmNlgp50nHZcJKq7lnH7V8nTo4FmRu3Bo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zn1EkZZtYwu+/CqIaImEzdF2wzQ3/Q4ICvhMSwY9pc4=;
        b=WJYli5ILPXYnDF3Rx2glhwHrjwv/sBjTkx/aVac/G/qlebyNx1qMmNMbFm5BcJriDo
         +r5o0kw+amaX1aPuEWUNFIzaNtweZEK3zNGtxBfd9xl7anNyEPYa+bB0AmSbTlyfygPH
         MbhqTkljGMOBgFi9d4fpbZEmXYjxLC0a5R/o+fC6GU/NaaScWDSy4AtDaLqoqfeYrUrT
         N9fm5lmj/w+ZNTfYgxJMGxZqqJCH/o5ieFRF1zY/gbxlcnQY76vHyWYJ+tQjojRMl/EB
         oz/0Gebinqz4nZSFBZD7ZPF2Vf6hPoXV+MPNN9b7pgdZr/KPuyQmSodN+5enf9ZM3Rhc
         ujjw==
X-Gm-Message-State: AOAM532XGEOzVSSl4h+jCwJYVsV/cpswyFKoe0E/Ja1MeMYa0elaigck
        cPT49MnKJpAw5uYjCuKe1EYeDw==
X-Google-Smtp-Source: ABdhPJyx5YX9MminKBo66Os9ZmhaP/fJEgBHFu0WDHKC3YgKNy061CfxIN6SG+aQUmV8dm/D3dlZQg==
X-Received: by 2002:a17:90b:4a82:: with SMTP id lp2mr2861629pjb.57.1632197196917;
        Mon, 20 Sep 2021 21:06:36 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v3sm15675641pfc.193.2021.09.20.21.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 21:06:36 -0700 (PDT)
Date:   Mon, 20 Sep 2021 21:06:35 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Len Baker <len.baker@gmx.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: DR, Prefer kcalloc over open coded arithmetic
Message-ID: <202109202105.9E901893@keescook>
References: <20210905074936.15723-1-len.baker@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210905074936.15723-1-len.baker@gmx.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 05, 2021 at 09:49:36AM +0200, Len Baker wrote:
> As noted in the "Deprecated Interfaces, Language Features, Attributes,
> and Conventions" documentation [1], size calculations (especially
> multiplication) should not be performed in memory allocator (or similar)
> function arguments due to the risk of them overflowing. This could lead
> to values wrapping around and a smaller allocation being made than the
> caller was expecting. Using those allocations could lead to linear
> overflows of heap memory and other misbehaviors.
> 
> So, refactor the code a bit to use the purpose specific kcalloc()
> function instead of the argument size * count in the kzalloc() function.
> 
> [1] https://www.kernel.org/doc/html/v5.14/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
> 
> Signed-off-by: Len Baker <len.baker@gmx.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/steering/dr_action.c  | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
> index 6475ba35cf6b..e8957dad3bb1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
> @@ -716,6 +716,7 @@ mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
>  	struct mlx5dr_action *action;
>  	bool reformat_req = false;
>  	u32 num_of_ref = 0;
> +	u32 ref_act_cnt;
>  	int ret;
>  	int i;
> 
> @@ -724,11 +725,14 @@ mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
>  		return NULL;
>  	}
> 
> -	hw_dests = kzalloc(sizeof(*hw_dests) * num_of_dests, GFP_KERNEL);
> +	hw_dests = kcalloc(num_of_dests, sizeof(*hw_dests), GFP_KERNEL);
>  	if (!hw_dests)
>  		return NULL;
> 
> -	ref_actions = kzalloc(sizeof(*ref_actions) * num_of_dests * 2, GFP_KERNEL);
> +	if (unlikely(check_mul_overflow(num_of_dests, 2u, &ref_act_cnt)))
> +		goto free_hw_dests;
> +
> +	ref_actions = kcalloc(ref_act_cnt, sizeof(*ref_actions), GFP_KERNEL);

In the future, consider array3_size(), but this is fine too. :)

-Kees

>  	if (!ref_actions)
>  		goto free_hw_dests;
> 
> --
> 2.25.1
> 

-- 
Kees Cook
