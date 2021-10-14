Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D1E42D3BB
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 09:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhJNHer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 03:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhJNHeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 03:34:46 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E6AC061570;
        Thu, 14 Oct 2021 00:32:41 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id d9so20388213edh.5;
        Thu, 14 Oct 2021 00:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/xnuWJhrmVX8nyyGJLLTy8NHku+iwZR/WIywmchnebU=;
        b=HjIUz+Rvwj98w+qvdmPVUc1QeSFXY0FdDjWouIgMtOf3MaLNC7GnUxXM06HUklwppi
         xESR7dt7gOdjzurnqrWvLOEUsucbPPzentW8sHvoNa1AJfkAaJSyVkqwHH2KKobkzTNS
         I0tAfo9QrU8ZGOWpIjHGgHxOVypBcRtVDLUGP/qASSNmRV++B/Cx8MbugHamDCgMPC90
         aJHLzhbExKx2tXS7Mcc7xZwM+mi6IxzZDALVe7BojeCXDNRt56OTlCYzIx+TymPWO4b4
         99YQCp7S3JPeDL40mbtMMHqL7UhXG2NkP6ChaDigbeOb9F5C3YyAlmb8yLZGPN7MHEAc
         U93w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/xnuWJhrmVX8nyyGJLLTy8NHku+iwZR/WIywmchnebU=;
        b=UxPBfkvMBCD0q23FvJvYZgXNjz1ET+EIiHyr3CvEfZmwB2SIn0RozB2uGsEGLnu0Ba
         fIh2gpR6bqd2vpFkugUX6lyYjlFTeymzDGB/N1UG94FNxEd4oTNva6w9ydroPgQ1w/hh
         xZ/gVQm6XLDjt+7sWv6++drSa4LZkrTPInWroMMaPdAHS9e+hJF0jTJ3WM0wAp+MctoO
         ji94M5YeAK6k1K8d0nA0A4tSrwagoiYWkzO9URP1eHPvIesNPLZy8dOJU3xXJKIzECh1
         sg931cbVQwxMDc2pgcFK7KM8mLOfIjyDxjxw+qs0VER7j6GZsJV49hJ4+SLUD5WFnkwK
         J2Fw==
X-Gm-Message-State: AOAM531ctiM5QVigzlfK1QABDTbhOPAGGwg4Yd3O6+oEYoaytejA4rNL
        NlrmpU0cc5pMhPo9tKh1JiI=
X-Google-Smtp-Source: ABdhPJyyjIMh1xd4Ym8Ox9fBtHbG79BkxSytyUuvq14SiywJv7AAC86o8jdnEtTepgGOcQ9MkRx1+A==
X-Received: by 2002:a05:6402:40d3:: with SMTP id z19mr6448091edb.393.1634196760221;
        Thu, 14 Oct 2021 00:32:40 -0700 (PDT)
Received: from [192.168.0.108] ([176.228.71.216])
        by smtp.gmail.com with ESMTPSA id w18sm1868067edc.4.2021.10.14.00.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 00:32:39 -0700 (PDT)
Subject: Re: [PATCH] mlx5: allow larger xsk chunk_size
To:     Arnd Bergmann <arnd@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
References: <20211013150232.2942146-1-arnd@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <328f581e-7f1d-efc3-036c-66e729297e9c@gmail.com>
Date:   Thu, 14 Oct 2021 10:32:36 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211013150232.2942146-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/13/2021 6:02 PM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When building with 64KB pages, clang points out that xsk->chunk_size
> can never be PAGE_SIZE:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c:19:22: error: result of comparison of constant 65536 with expression of type 'u16' (aka 'unsigned short') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
>          if (xsk->chunk_size > PAGE_SIZE ||
>              ~~~~~~~~~~~~~~~ ^ ~~~~~~~~~
> 
> I'm not familiar with the details of this code, but from a quick look
> I found that it gets assigned from a 32-bit variable that can be
> PAGE_SIZE, and that the layout of 'xsk' is not part of an ABI or
> a hardware structure, so extending the members to 32 bits as well
> should address both the behavior on 64KB page kernels, and the
> warning I saw.
> 
> In older versions of this code, using PAGE_SIZE was the only
> possibility, so this would have never worked on 64KB page kernels,
> but the patch apparently did not address this case completely.
> 
> Fixes: 282c0c798f8e ("net/mlx5e: Allow XSK frames smaller than a page")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en/params.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
> index 879ad46d754e..b4167350b6df 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
> @@ -7,8 +7,8 @@
>   #include "en.h"
>   
>   struct mlx5e_xsk_param {
> -	u16 headroom;
> -	u16 chunk_size;
> +	u32 headroom;
> +	u32 chunk_size;

Hi Arnd,

I agree with your arguments about chunk_size.
Yet I have mixed feelings about extending the headroom. Predating 
in-driver code uses u16 for headroom (i.e. [1]), while 
xsk_pool_get_headroom returns u32.

[1] drivers/net/ethernet/mellanox/mlx5/core/en/params.c :: 
mlx5e_get_linear_rq_headroom

As this patch is a fix, let's keep it minimal, only addressing the issue 
described in title and description.
We might want to move headroom to u32 all around the driver in a 
separate patch to -next.

>   };
>   
>   struct mlx5e_lro_param {
> 
