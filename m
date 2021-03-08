Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6368331368
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 17:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbhCHQ3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 11:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhCHQ2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 11:28:43 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFA9C06174A;
        Mon,  8 Mar 2021 08:28:43 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id c10so21543138ejx.9;
        Mon, 08 Mar 2021 08:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tiGJV2RhXExYKDWyCVs2qAl+gBXWf404MXhwFnRFKfg=;
        b=D5xNvUgCTm+HE+ClgXE4PFyrTWhGyTev2oYsTrgWgJCNygG9wtoLhVDsLOPKKFNO3E
         BspvA7gRqU1Lqeza9vUYk6t8fy6AzQjXTNRdIZvsVia46l+vsCKLhr7Vfi+psU+PelMj
         1hkyjKuaOu1CPuMgRjoXo6Kh2tWNHIKA0CbcIfIXrkh1xtdiHiqHn/k4XpjvZLjHr+5x
         fK3n4qso0tZGL4E7ZBo2zuOosfch4g1xKWD2WSYccy3Mci8AgxxRmD6OwoT6VJ/XJEhe
         Q6SYhsbtfirG1U9axJFGDYMVV8j7rO4x1J5dbxNp6su9ZQXmtctXPiTm4uEaUvwYsdz7
         vSgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tiGJV2RhXExYKDWyCVs2qAl+gBXWf404MXhwFnRFKfg=;
        b=gNMS6dVuWb0vasvQHmvFNdRQzCqIYQ64LLfebyfCVMEQRPpmaFD1chP9GOSIhZ1uE+
         OJW7VJLeyLMTkngT1v2InAMhQudhaWXCfZfnKWJofXCYmlbzdYKk4iLgQqB/AQREP5XE
         zQvF79aAF27aShGNvggKSuGCC2cZKUdTGwzfpsB0Rv5QjaqFmKamH5B5QMTI3q5jMmW4
         l/3hi+Sq9MqDhRMP+nTzIglx4J5685Pi3peW6JuuEYo06/z1kznIhr51VvgxMaIxQ8UM
         XCdd5SSThI/rX6D5DaEpLlAEiro4JCJMebxPY35+SoulTFlPX5+uOBj33wBTdooV+3WT
         YiOA==
X-Gm-Message-State: AOAM532ud3SwaZOttR3DLFGAW8CdFy8nLEdhTRAGSTO83rqJwVanWppk
        JuwT5ZgKjH9RxdZPk6qw1JP9PCbif7sbeQ==
X-Google-Smtp-Source: ABdhPJxQ615Q0WZoiZU0iboEHaD3ayezp9N+A8KdIZdkd0cJk2xgD3w7nU8vCviGqHfG3FWSevYF9g==
X-Received: by 2002:a17:907:76b3:: with SMTP id jw19mr15583419ejc.202.1615220921770;
        Mon, 08 Mar 2021 08:28:41 -0800 (PST)
Received: from [192.168.1.110] ([77.124.67.117])
        by smtp.gmail.com with ESMTPSA id v1sm6767875ejd.3.2021.03.08.08.28.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 08:28:41 -0800 (PST)
Subject: Re: [PATCH] net/mlx5e: allocate 'indirection_rqt' buffer dynamically
To:     Arnd Bergmann <arnd@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Noam Stolero <noams@nvidia.com>, Tal Gilboa <talgi@nvidia.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Oz Shlomo <ozsh@mellanox.com>,
        Eli Cohen <eli@mellanox.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20210308153318.2486939-1-arnd@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <31a031b3-e44e-66cb-a713-627be1f64ff6@gmail.com>
Date:   Mon, 8 Mar 2021 18:28:36 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210308153318.2486939-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/8/2021 5:32 PM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Increasing the size of the indirection_rqt array from 128 to 256 bytes
> pushed the stack usage of the mlx5e_hairpin_fill_rqt_rqns() function
> over the warning limit when building with clang and CONFIG_KASAN:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:970:1: error: stack frame size of 1180 bytes in function 'mlx5e_tc_add_nic_flow' [-Werror,-Wframe-larger-than=]
> 
> Using dynamic allocation here is safe because the caller does the
> same, and it reduces the stack usage of the function to just a few
> bytes.
> 
> Fixes: 1dd55ba2fb70 ("net/mlx5e: Increase indirection RQ table size to 256")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 0da69b98f38f..66f98618dc13 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -445,12 +445,16 @@ static void mlx5e_hairpin_destroy_transport(struct mlx5e_hairpin *hp)
>   	mlx5_core_dealloc_transport_domain(hp->func_mdev, hp->tdn);
>   }
>   
> -static void mlx5e_hairpin_fill_rqt_rqns(struct mlx5e_hairpin *hp, void *rqtc)
> +static int mlx5e_hairpin_fill_rqt_rqns(struct mlx5e_hairpin *hp, void *rqtc)
>   {
> -	u32 indirection_rqt[MLX5E_INDIR_RQT_SIZE], rqn;
> +	u32 *indirection_rqt, rqn;
>   	struct mlx5e_priv *priv = hp->func_priv;
>   	int i, ix, sz = MLX5E_INDIR_RQT_SIZE;
>   
> +	indirection_rqt = kzalloc(sz, GFP_KERNEL);
> +	if (!indirection_rqt)
> +		return -ENOMEM;
> +
>   	mlx5e_build_default_indir_rqt(indirection_rqt, sz,
>   				      hp->num_channels);
>   
> @@ -462,6 +466,9 @@ static void mlx5e_hairpin_fill_rqt_rqns(struct mlx5e_hairpin *hp, void *rqtc)
>   		rqn = hp->pair->rqn[ix];
>   		MLX5_SET(rqtc, rqtc, rq_num[i], rqn);
>   	}
> +
> +	kfree(indirection_rqt);
> +	return 0;
>   }
>   
>   static int mlx5e_hairpin_create_indirect_rqt(struct mlx5e_hairpin *hp)
> @@ -482,12 +489,15 @@ static int mlx5e_hairpin_create_indirect_rqt(struct mlx5e_hairpin *hp)
>   	MLX5_SET(rqtc, rqtc, rqt_actual_size, sz);
>   	MLX5_SET(rqtc, rqtc, rqt_max_size, sz);
>   
> -	mlx5e_hairpin_fill_rqt_rqns(hp, rqtc);
> +	err = mlx5e_hairpin_fill_rqt_rqns(hp, rqtc);
> +	if (err)
> +		goto out;
>   
>   	err = mlx5_core_create_rqt(mdev, in, inlen, &hp->indir_rqt.rqtn);
>   	if (!err)
>   		hp->indir_rqt.enabled = true;
>   
> +out:
>   	kvfree(in);
>   	return err;
>   }
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Thanks for your patch.

Tariq
