Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA3C3D4C55
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 08:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhGYFfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 01:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhGYFfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 01:35:11 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D4BC061757;
        Sat, 24 Jul 2021 23:15:40 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id x14so2283831edr.12;
        Sat, 24 Jul 2021 23:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dtsDN8UE7KPVVcd4PEUyYbKdwuylFOBB12bakeDTWEs=;
        b=hWqG/A9h1mqw3EXHS6Cul9yfKV8Vc37BNs9K80tjTuwTYv3ZDj9dyweU8kZrQH9/mq
         qRE7f6EwYHdvjoE4afY5g8/32QWLAU230YZOOPE1h7h/mvjTWsZJ+MDxySvv0FhbmqoG
         wfu1m6Yxy09Uu7I8ZZL83HbybCnltD9hpE8iQZ5txHW/+tmFk8ylr6gUaCSJaC7atuHa
         IJ6SQfFI+BjGhgqdNeBTiuC8JeecjwX3D/GSK1uTCwrZjM3lDso88+ma0dYoySANYXua
         KKJNu8ZGXQD5zmttMkeM7zF9GipNMYZl4FrozkfyKflBOqIpTelejuhVSVnuYdHyOimG
         TyXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dtsDN8UE7KPVVcd4PEUyYbKdwuylFOBB12bakeDTWEs=;
        b=OOlWmc+sXNvHoWnyKtrE4SpuJrGJKVoE1S0A1Tk1ar2nwICbySTQzd7QrlsJokNMuc
         EazCUTtX5aae6qqXU+6XttN4chBfK/fYptPSeuxhDJ99SIX//tYD0P2wD0Xj5b3GbdVP
         gAA3W4YVTqE8S604QuGX3ySqShBeVIKJEmeOQzpxXI1DOSED+CR+ZpgNaEBTer8E029o
         OoSgpQvT4iq7fJMPRXSSM/UvXjFtNMpSrfQsxIDaabI67LF3pipfn/X/JcE88x0w3r7n
         GlUnMErtmn7uvGj8LMEszjWcsZJvYksY7uW8yfnLFwYZi7xRePEPHwH+bnUO2BabLztu
         pSxA==
X-Gm-Message-State: AOAM532fOR5ijaXwOymRSPwK1anQfWNPdj72Ez1zfmOR8ZVk7vefTk3w
        CDhQW18Qvmj8eohL7qrb547MNwj+S9w=
X-Google-Smtp-Source: ABdhPJxHz/ysGgS2mbWQk881hBx/qyW6Vxb6SOVX3Sp3nS/SmigQVvPHCNJdT/l0GMlYidjXld8nbw==
X-Received: by 2002:aa7:ca57:: with SMTP id j23mr14313902edt.224.1627193739295;
        Sat, 24 Jul 2021 23:15:39 -0700 (PDT)
Received: from [192.168.0.108] ([77.127.114.213])
        by smtp.gmail.com with ESMTPSA id a5sm17336000edj.20.2021.07.24.23.15.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jul 2021 23:15:38 -0700 (PDT)
Subject: Re: [PATCH] mlx4: Fix missing error code in mlx4_load_one()
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, tariqt@nvidia.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1627036569-71880-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <f62d2d35-3838-06a8-8230-4cc2e9166ac7@gmail.com>
Date:   Sun, 25 Jul 2021 09:15:36 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1627036569-71880-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/23/2021 1:36 PM, Jiapeng Chong wrote:
> The error code is missing in this code scenario, add the error code
> '-EINVAL' to the return value 'err'.
> 
> Eliminate the follow smatch warning:
> 
> drivers/net/ethernet/mellanox/mlx4/main.c:3538 mlx4_load_one() warn:
> missing error code 'err'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Fixes: 7ae0e400cd93 ("net/mlx4_core: Flexible (asymmetric) allocation of
> EQs and MSI-X vectors for PF/VFs")
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/main.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> index 00c8465..28ac469 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> @@ -3535,6 +3535,7 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
>   
>   		if (!SRIOV_VALID_STATE(dev->flags)) {
>   			mlx4_err(dev, "Invalid SRIOV state\n");
> +			err = -EINVAL;
>   			goto err_close;
>   		}
>   	}
> 

Thanks for you patch.
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Regards,
Tariq
