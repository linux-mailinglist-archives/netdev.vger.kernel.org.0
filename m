Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C56B226935
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732215AbgGTP7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 11:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732208AbgGTP7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 11:59:24 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FD6C061794;
        Mon, 20 Jul 2020 08:59:24 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u5so9243642pfn.7;
        Mon, 20 Jul 2020 08:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ryf43iyDiDyn0uFaTxwELJzpnL6UWonqLXTALV9Cnnw=;
        b=Zz6k3bpYZzbAH34Z959/Ux4JWTL06wDdmR8kJizzW2UcsAlkwsHc+bEyzL78uDyA7M
         Ag/g8ivAtIy1hC/AGirVgdN0ZfFFH/d7KtR5gVyGXVKHqCHzaoXn3mG7qcRmDHpFvkjb
         dc/waQ9JuYm3LghRcLgqepkt8gi+CQxyDHq2WfOdx5QpxxPl4prcnDgyLL8Hpf+k031j
         kqd0ZRNiHqUfs8UI3dYUaWfkpXw6v1SHoW7jANoDIApoJqhPahtFKAjryZhIzEITRd48
         8N0ylGRkkv3I7fqy9PGDTf6PwMWbUaI9MNRbFvQI7Qb/7jIHYNhWZU7YIArOpqGTDP3n
         VSFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ryf43iyDiDyn0uFaTxwELJzpnL6UWonqLXTALV9Cnnw=;
        b=Y8oBJtDBWYaIafifMYMWF94+S2hpI87QuauTtDdZLV9SdRyj6eWJc+CPCvQSPsPVCJ
         h4LBdF3MbEKv2Z5GZU+aix+Ayhwxs4Aqrclhmg4rvEV1DxAw544PvBuw30vDMvGFj2Co
         sXD+OPaPtVgeIH65a4C+I8CzfQpMZizpuDVQSqrBGrPtzNjT4hO0KXlVU6npGceKaHid
         9GtuN1O0Whhnmz7q1T1KdDZwNe6+mjLlXNqOR1HMPZ+RnbHXnLikAize4jRXmFA6OQbf
         vx8hCDQPRTe++PY+4akQaKEu7GyewTL8J+d/an6cBbGOLxCBBWOBjikSbkxGw7sCWCUS
         moTQ==
X-Gm-Message-State: AOAM530LkbXy9me7wub+cMnptTuMxhCvnUmgcRGozHN34mrD0tZXk4Kc
        f7i56th4vpTiDPEwMxEblLk1v1U3pu8=
X-Google-Smtp-Source: ABdhPJxa9sYlM956HuH86QlTRYKS7pkWbPJH14405GddAXhI75eFRVT3DZMcEEclbys6Uz4cry5NLw==
X-Received: by 2002:a63:215e:: with SMTP id s30mr18028733pgm.87.1595260763104;
        Mon, 20 Jul 2020 08:59:23 -0700 (PDT)
Received: from [192.168.219.16] (ip72-219-184-175.oc.oc.cox.net. [72.219.184.175])
        by smtp.gmail.com with ESMTPSA id x3sm17259999pfn.154.2020.07.20.08.59.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 08:59:22 -0700 (PDT)
Subject: Re: [PATCH net] net: bcmgenet: add missed clk_disable_unprepare in
 bcmgenet_probe
To:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1595237794-11530-1-git-send-email-zhangchangzhong@huawei.com>
From:   Doug Berger <opendmb@gmail.com>
Message-ID: <7b499451-623c-cabf-2c95-fc7019895b3d@gmail.com>
Date:   Mon, 20 Jul 2020 09:02:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1595237794-11530-1-git-send-email-zhangchangzhong@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/2020 2:36 AM, Zhang Changzhong wrote:
> The driver forgets to call clk_disable_unprepare() in error path after
> a success calling for clk_prepare_enable().
> 
> Fix to goto err_clk_disable if clk_prepare_enable() is successful.
> 
> Fixes: c80d36ff63a5 ("net: bcmgenet: Use devm_clk_get_optional() to get the clocks")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index 368e05b..79d27be 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -4000,14 +4000,14 @@ static int bcmgenet_probe(struct platform_device *pdev)
>  	if (IS_ERR(priv->clk_wol)) {
>  		dev_dbg(&priv->pdev->dev, "failed to get enet-wol clock\n");
>  		err = PTR_ERR(priv->clk_wol);
> -		goto err;
> +		goto err_clk_disable;
>  	}
>  
>  	priv->clk_eee = devm_clk_get_optional(&priv->pdev->dev, "enet-eee");
>  	if (IS_ERR(priv->clk_eee)) {
>  		dev_dbg(&priv->pdev->dev, "failed to get enet-eee clock\n");
>  		err = PTR_ERR(priv->clk_eee);
> -		goto err;
> +		goto err_clk_disable;
>  	}
>  
>  	/* If this is an internal GPHY, power it on now, before UniMAC is
> 
Acked-by: Doug Berger <opendmb@gmail.com>

Thanks!
