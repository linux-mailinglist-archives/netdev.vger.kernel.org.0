Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8572644DD08
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 22:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbhKKV2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 16:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbhKKV2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 16:28:15 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC92C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 13:25:26 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id h23so7126999ila.4
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 13:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y4JyUrRVkl7jRVNnow9Cuz7LmoY2mJupCDpaUKXIdd8=;
        b=VCJFK9rW+syMORNU6vFfp0mPegobo2rG2MXJKAa95n5gxdfZ7BGBU7qpK/vXzQ2085
         l6E8K+76scd90ou8RSRxzz1u5kyIFfuewtcyvvIVy5IALSWyxVQldo/fbb0abC19Enat
         fIp15wq2fycN7BOYjuF+nrhAdmdUGP4iBmNAo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y4JyUrRVkl7jRVNnow9Cuz7LmoY2mJupCDpaUKXIdd8=;
        b=VreXIW/L/DoPOBznlvkdklL3Ej5z7D6lnZfX3GwJgBb+RPmQckoAL+ITLE9t+uNVZ6
         KJ8kd99m6SkBlZedXZ9Igqa4wediRf+X2dhsfWFQvw6qwSEhqZC8djkoSxIANiLpwSfX
         vosEXLGHozL9hqDLP7rGo16eOrNlfuirDy3xOemnYpDNmZztzIyn0UMAdFLgEJiMpmLB
         VQGB8G9yCYOZC0EOs5XO/cXl+9E9EaiT7mgQzv5tX/j5aHI93TlPaSWqq21Tak9Pqsp5
         IXZA40A7UZgz1xNY8S1kNS4TJAZtlwfRyQUT2tBBHd8IJAAMLCDhIAihlbM9rLrjy6tc
         8yog==
X-Gm-Message-State: AOAM533kS7sKaIaJdcF96UjKBHJZygqpS4PkrkgoAqYk9JNEg8LCLCVY
        pphKgEGQe17n84u3am99Sw0EcA==
X-Google-Smtp-Source: ABdhPJzMZMMAipebIjjwfyE2eXlvAEIuMIJ2iMJJWhmoD8kJtFAB+V0Ywp6ZlLzmiR1Bnb19mOYdZw==
X-Received: by 2002:a05:6e02:12c3:: with SMTP id i3mr6188540ilm.316.1636665925290;
        Thu, 11 Nov 2021 13:25:25 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id l1sm2145751ioj.29.2021.11.11.13.25.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 13:25:24 -0800 (PST)
Subject: Re: [PATCH v2] net/ipa: ipa_resource: Fix wrong for loop range
To:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        ~postmarketos/upstreaming@lists.sr.ht
Cc:     martin.botka@somainline.org,
        angelogioacchino.delregno@somainline.org,
        marijn.suijten@somainline.org, jamipkettunen@somainline.org,
        Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211111183724.593478-1-konrad.dybcio@somainline.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <337396cb-0959-561d-8abd-7cf6e48d6fae@ieee.org>
Date:   Thu, 11 Nov 2021 15:25:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211111183724.593478-1-konrad.dybcio@somainline.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/21 12:37 PM, Konrad Dybcio wrote:
> The source group count was mistakenly assigned to both dst and src loops.
> Fix it to make IPA probe and work again.

Looks good.  Oops.

Reviewed-by: Alex Elder <elder@linaro.org>

> 
> Fixes: 4fd704b3608a ("net: ipa: record number of groups in data")
> Acked-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
> Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
> Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
> ---
> Changes since v1:
> - Add a "Fixes:" tag, R-b, A-b and fix up the commit message
>   drivers/net/ipa/ipa_resource.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
> index e3da95d69409..06cec7199382 100644
> --- a/drivers/net/ipa/ipa_resource.c
> +++ b/drivers/net/ipa/ipa_resource.c
> @@ -52,7 +52,7 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
>   				return false;
>   	}
>   
> -	group_count = data->rsrc_group_src_count;
> +	group_count = data->rsrc_group_dst_count;
>   	if (!group_count || group_count > IPA_RESOURCE_GROUP_MAX)
>   		return false;
>   
> 

