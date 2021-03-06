Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C6732FB31
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 15:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhCFOdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 09:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbhCFOcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 09:32:48 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113C6C06174A;
        Sat,  6 Mar 2021 06:32:48 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id y124-20020a1c32820000b029010c93864955so1071291wmy.5;
        Sat, 06 Mar 2021 06:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+8BgUq5bz3PsAUVFDhP5/OY5124Iko4SFG0LjQ7RMR8=;
        b=G/YFuu+kw7SdhlVMTonesWTdmYLycJRtw/xzCISMXm1MAQ6N4G17OhsYZMgNEXnNEX
         hxQriLG2tS9hx+2lSfpKQSqZuO1F4X7Jf2OaBHGaB69pSJruAWqyyulBTGycMCzIQyY3
         WVM+F/UnoIpY83Lu0GF1kNi4B747MuP0syeNxNL06bShVZpXyrxNomWoXR+iZssy3NFm
         6itlk9IyClKn5Sdl+9hgJu0FvRx2SINFk9wIlyxjhnWujZstCsvxRlDCdZhSxZ9jL8yK
         dWsRj3OhKpE+sDgr5OSkubOcS/+JkcbErTVrChVCMZeXIS1I0hZbBeYOiyDUqvGtO6ta
         24Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+8BgUq5bz3PsAUVFDhP5/OY5124Iko4SFG0LjQ7RMR8=;
        b=CO/NP8Z1jGsh3t28hD17dZzbImG9Z8EyETj54yihgt1a/b72cxBZQ01s1RLo0MiCVY
         IJURF29cNdiRfo9RjliP+pcThnGlAC+lA3VwmBsD5zTuHbSVG+KWBXIQ5uAqoq5U0Ap9
         /ggn/A1XXFsQ9GPaKdvvu8u7s3psDezLVdaUWaJI1cOCH7igzKcdZcNxP2gC31zYgTcg
         ek/YkysKBNIFyeDk75vHGazo8ZNHdfWPGRfeMVRUQz1BjDvUF5v20loliuBpplHaeZiS
         70u95cyAGVAd4Yrwpj/CSiNSMLJePCPc/dTtfejXU8OG4fnSzrBTMy8JK/jpKofaT0s0
         3AyQ==
X-Gm-Message-State: AOAM532g+unVWYSSQDwxK7UwoZYxnKon9DsmbsEWWeKQ/TBdyg0dFXAr
        s75K247XHbh1eyNjCMXFTBVK3O0gF88hNA==
X-Google-Smtp-Source: ABdhPJyZtXIAwLXgnj99i9aIE0+ZqBapTphXa+XGMacr7UUXmc8MyGFRXdq66uqF8mZxUYznqLcdKw==
X-Received: by 2002:a1c:5416:: with SMTP id i22mr13829871wmb.146.1615041166456;
        Sat, 06 Mar 2021 06:32:46 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:bb00:ec1e:9bd2:55d7:2364? (p200300ea8f1fbb00ec1e9bd255d72364.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:ec1e:9bd2:55d7:2364])
        by smtp.googlemail.com with ESMTPSA id 12sm9275797wmw.43.2021.03.06.06.32.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Mar 2021 06:32:45 -0800 (PST)
Subject: Re: [PATCH] net: mellanox: mlxsw: fix error return code of
 mlxsw_sp_router_nve_promote_decap()
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, jiri@nvidia.com,
        idosch@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210306140705.18517-1-baijiaju1990@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b735ad44-be13-2449-4c14-ebf2304fa3e9@gmail.com>
Date:   Sat, 6 Mar 2021 15:32:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210306140705.18517-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.03.2021 15:07, Jia-Ju Bai wrote:
> When fib_entry is NULL, no error return code of
> mlxsw_sp_router_nve_promote_decap() is assigned.
> To fix this bug, err is assigned with -EINVAL in this case.
> 
Again, are you sure this is a bug? To me it looks like it is
intentional to not return an error code if fib_entry is NULL.
Please don't blindly trust the robot results, there may
always be false positives.

> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> index 9ce90841f92d..7b260e25df1b 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> @@ -1981,8 +1981,10 @@ int mlxsw_sp_router_nve_promote_decap(struct mlxsw_sp *mlxsw_sp, u32 ul_tb_id,
>  	fib_entry = mlxsw_sp_router_ip2me_fib_entry_find(mlxsw_sp, ul_tb_id,
>  							 ul_proto, ul_sip,
>  							 type);
> -	if (!fib_entry)
> +	if (!fib_entry) {
> +		err = -EINVAL;
>  		goto out;
> +	}
>  
>  	fib_entry->decap.tunnel_index = tunnel_index;
>  	fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_NVE_DECAP;
> 

