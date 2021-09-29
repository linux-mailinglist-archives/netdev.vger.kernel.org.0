Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F0A41C2AB
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245481AbhI2KZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245325AbhI2KZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 06:25:50 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46548C06161C;
        Wed, 29 Sep 2021 03:24:09 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id x7so6644659edd.6;
        Wed, 29 Sep 2021 03:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JhKUer31n+qbgtT3+NjW3VfpyAlVd0vh/K+LV/OlnC0=;
        b=jSphoSBJrNAGxP46hTwTkPJ+4SUeOjCSlvf6lHPnYVcIC2Sp9CIctgkr/4C25tDF4Y
         3pNnH15BJv95ZySDXwNuhU0gj3WxUA4LvlvjK2qj6zpN505D96/NoD80xA8NFR3dqwp9
         bhZI6vR8M1TvuakHkXKD3eN5qcPlKtog7x9T59p4Lsfe5rJW6xX8g57yAqwVN05+FtiZ
         ctmYeh+gpPNaenfir8Hip2wUdy2nUwU11ZWgtRieT91IYcPk6TPOT8MoNSvTxweao2PG
         ukPFxyd4k/x60OrMfQ5ThSqQSTwYxJ/8gEcsTv4Kvh9xpuYb8kh3xPB55xUTK3QzQNvP
         HePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JhKUer31n+qbgtT3+NjW3VfpyAlVd0vh/K+LV/OlnC0=;
        b=cptjrHhRXebv+Hvm4r5MjGC48ClJAdtbndRr4k4rhX8FrKhHlxeEq6B2PYYdcWfsht
         AHLS3pLdckhb/PKZI4J6kfaqzhsveDt/vedxCp9bEz+nkd2/85i6cebtE/zQzXrOx0el
         etv4Icd8H0rFUFuRhNc28WaavpLUyyVtGd2YkUqo8bILVALIbe6mch1AovYIu+1ZMmc9
         g5p2h9XJPpqTQoC7i2ZDhIFxmxO0GOYZF8oov1T2PNKl+ufPCpkgFY4nmGOfvo6PnEEx
         PWvdSrTWRGSGRVN+pYtCms9q7fOdA3Slcalf+LIMsMib8lL0llxn5cRMH4YUPRtNwsWi
         V4nQ==
X-Gm-Message-State: AOAM530Rd4K8sxihbUJ3j5+3wfqTYChU+oFuSyvbyJIPoZYSrV0ydUsN
        6PEHunUQ1Of5OfrkpuFj0uQ6x66J38M=
X-Google-Smtp-Source: ABdhPJyAjbsIYBh97/f406c0qcVrYdyUoTN8xMbO1QoYXsFSFUYZEeqAOKwoJXyMeaeWqO/jOFfldA==
X-Received: by 2002:a17:906:b884:: with SMTP id hb4mr1341395ejb.376.1632911047229;
        Wed, 29 Sep 2021 03:24:07 -0700 (PDT)
Received: from [192.168.0.108] ([176.228.98.2])
        by smtp.gmail.com with ESMTPSA id my11sm1096098ejc.80.2021.09.29.03.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 03:24:06 -0700 (PDT)
Subject: Re: [PATCH][net-next] net/mlx4: Use array_size() helper in
 copy_to_user()
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210928201733.GA268467@embeddedor>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <283d239b-9af9-d3a3-72be-9138c032ef63@gmail.com>
Date:   Wed, 29 Sep 2021 13:24:05 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210928201733.GA268467@embeddedor>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/28/2021 11:17 PM, Gustavo A. R. Silva wrote:
> Use array_size() helper instead of the open-coded version in
> copy_to_user(). These sorts of multiplication factors need
> to be wrapped in array_size().
> 
> Link: https://github.com/KSPP/linux/issues/160
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   drivers/net/ethernet/mellanox/mlx4/cq.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
> index f7053a74e6a8..4d4f9cf9facb 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/cq.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
> @@ -314,7 +314,8 @@ static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
>   			buf += PAGE_SIZE;
>   		}
>   	} else {
> -		err = copy_to_user((void __user *)buf, init_ents, entries * cqe_size) ?
> +		err = copy_to_user((void __user *)buf, init_ents,
> +				   array_size(entries, cqe_size)) ?
>   			-EFAULT : 0;
>   	}
>   
> 

Thanks for your patch.
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
