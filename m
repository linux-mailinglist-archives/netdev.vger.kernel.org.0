Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F422BC48C
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 09:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgKVIgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 03:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727330AbgKVIgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 03:36:07 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07254C0613CF;
        Sun, 22 Nov 2020 00:36:05 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id s25so18964608ejy.6;
        Sun, 22 Nov 2020 00:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KSBUEVa1x7/4PC/tS/TFqyMip0/VC+6jUS5QTF5o5IM=;
        b=s+/oKz3oldIl1t5BYk68RHZ+d+pyjpZDzMF15rrugvaDNKM7IsCYxhreJ+gfX9T3Mf
         ERwEHaUyT3Mxm6EsH7sx8lfGaNaXjprvDkfm5fXFlgG4btElOZxogoJoW8HK9glJP11D
         MmflztiWl7tZcOD4MiwakyZuXyu+5qJHJuCb+S6yy8dLyePLrOzPRN/zn058KCxaZpdq
         PNI0Ze+RX1wStPfYdhLkXoM/3YXx73MbaxTyvKiY5nZ/4UBiiFz+atauZXBCU8+fGgTo
         UiSRogmLW92SoTanXB+tLX+xSQvCWxuC0mTdDfTcKy4r9fLUNcY/ZKIpanJIYKdNWPN6
         zDgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KSBUEVa1x7/4PC/tS/TFqyMip0/VC+6jUS5QTF5o5IM=;
        b=beB/YPP6JCeuDg0aOTHCzADLh4lvd3yav/9L9LKw9jtXfdbvDeCbQRi0O2wxiWBN8Q
         4DTDYwNKLjnRoeAIzh9KYu0DPJwx/uLIEbpEXKIy3asow8uVLLf2oJaHcqgmjrdQg3nC
         ac1VKE3eme38wuokTYtAYQFNpNSaR378nT0ArhLCQDPx29WvGxZipNhJNUXSKQFvlPA/
         bPrlrh9cpY8hWGFE9Du1WPnZt13/XgxYijx5vsOK7G3TPpvZj6HusgrkSSj7qR+VDyTV
         6QcEzgRIjo6JDOGBen4vzE1ZFnT1pb5tFYFtVzyRGs/I+1DJ5pWb3WxsMDXivijT/p3J
         n/RQ==
X-Gm-Message-State: AOAM5320F3u0Z2mKsRQkrRqIbppU3dFLGPDKx1IMT4Lje9zMEI4kLpvv
        dBU3SO8P2hkVh8yRPxFaqjh5ZZdu7eA=
X-Google-Smtp-Source: ABdhPJz+yvCpqHMjFz1ak9Nf4Hu9OI+si59vmxOEzFhW7SiCEq8T8FgmLg4BNFAaXrovUEAPxq7h5g==
X-Received: by 2002:a17:907:7253:: with SMTP id ds19mr8344354ejc.166.1606034164513;
        Sun, 22 Nov 2020 00:36:04 -0800 (PST)
Received: from [192.168.0.110] ([77.127.85.120])
        by smtp.gmail.com with ESMTPSA id p1sm3379016edx.4.2020.11.22.00.36.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2020 00:36:03 -0800 (PST)
Subject: Re: [PATCH 044/141] net/mlx4: Fix fall-through warnings for Clang
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <cover.1605896059.git.gustavoars@kernel.org>
 <84cd69bc9b9768cf3bc032c0205ffe485b80ba03.1605896059.git.gustavoars@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <0ba92238-2e31-b7d8-5664-72933dc76a7b@gmail.com>
Date:   Sun, 22 Nov 2020 10:36:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <84cd69bc9b9768cf3bc032c0205ffe485b80ba03.1605896059.git.gustavoars@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/20/2020 8:31 PM, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a break statement instead of just letting the code
> fall through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   drivers/net/ethernet/mellanox/mlx4/resource_tracker.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> index 1187ef1375e2..e6b8b8dc7894 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> @@ -2660,6 +2660,7 @@ int mlx4_FREE_RES_wrapper(struct mlx4_dev *dev, int slave,
>   	case RES_XRCD:
>   		err = xrcdn_free_res(dev, slave, vhcr->op_modifier, alop,
>   				     vhcr->in_param, &vhcr->out_param);
> +		break;
>   
>   	default:
>   		break;
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks for your patch.
