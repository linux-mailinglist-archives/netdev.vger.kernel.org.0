Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E072021E5FC
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 04:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgGNCzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 22:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbgGNCzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 22:55:38 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50017C061755;
        Mon, 13 Jul 2020 19:55:38 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id by13so15563671edb.11;
        Mon, 13 Jul 2020 19:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+TkAPchkeADsCApjDsygzVoXRKX4pEnQNE3pl6BWub8=;
        b=m+urkWke7MUX4d6AM+4iPZJ2bEo6N+i1IirJQZe99s5uUD9FeWQe3YWMbcqstrViil
         HNh6OfVb9l2xZUkD7swgnPI5QAX9TULZRcYzBHFBFi23Th8JVG9Rt4Y0LJtIBlKL3Cnc
         HYHf7HJJz8tl2jufyoA63pmxNER56G7OkM/IcJHtK1ROKGeBlUG42N4XtuKr7ddBt77r
         a0uByQDuZ8ISqQZ2Cj+Ah4qcNPsSas+V7VA89bSOehTp+80gIIpqqnEcYRLeDyaBr/uL
         0KTV6MXoQVcw/r4GOiSNPyCu3nVEsUjwFmpYz32cKQbC9aJ/OKac9OrLfVcAn/itkqq3
         hpAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+TkAPchkeADsCApjDsygzVoXRKX4pEnQNE3pl6BWub8=;
        b=savWuNsxfBy/ZwRGsMMMbVMSs12xJMdTFnUMVKOsLHECpXQgH1a0YCGJF/SfUBIpT8
         tnp5d/q406ovGP+sQwlSvxVjY6Cc3vF/sp8/Nj2fMlQkVSgTpjFyEgo2JSElrBL42Ek4
         UWoVLBUqXNFuETpuZ90t3HrhGNBQHopHN8mxVlpML54NyZ8Y0gsSuuR2luRTgn2TP04w
         +V8Lfmx7vqnDOG9gAUV2QTmKXB1FjwriDUD0zZmvwe+zgZ1zZBcWnlOFV0lVFrkfw8UA
         LjjCFZROTGEJiXDB2Ma7WF2c9b4MHE25epenzT4HkyJZapdWjT6u7KQyMo6PimnElPrR
         iU9g==
X-Gm-Message-State: AOAM5331XJhTHSVmhowhVtxW/n5q0u8+u6PnXm26Keog8ym8iAsYjkEp
        yNM2tc8nQtEglGPBydVltD8rDz8g
X-Google-Smtp-Source: ABdhPJzaThfDiSqoyGMSos5gZm5P3BLAPoTw92Y96RGCq/k1+YfWrD3DKnnI09s/5NKpWSNbQK/RaQ==
X-Received: by 2002:a05:6402:1544:: with SMTP id p4mr2355053edx.334.1594695336677;
        Mon, 13 Jul 2020 19:55:36 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 23sm13337493edx.75.2020.07.13.19.55.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 19:55:35 -0700 (PDT)
Subject: Re: [PATCH] net: xilinx: fix potential NULL dereference in
 temac_probe()
To:     Xu Wang <vulab@iscas.ac.cn>, davem@davemloft.net, kuba@kernel.org,
        michal.simek@xilinx.com, esben@geanix.com, hkallweit1@gmail.com,
        weiyongjun1@huawei.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org
References: <20200714022304.4003-1-vulab@iscas.ac.cn>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <683a0713-2587-17e4-6280-b2f905b3a230@gmail.com>
Date:   Mon, 13 Jul 2020 19:55:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200714022304.4003-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/13/2020 7:23 PM, Xu Wang wrote:
> platform_get_resource() may return NULL, add proper
> check to avoid potential NULL dereferencing.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> ---

If you use devm_ioremap_resource() you can remove the !res check
entirely which would be equally acceptable as a fix.

>  drivers/net/ethernet/xilinx/ll_temac_main.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
> index 929244064abd..85a767fa2ecf 100644
> --- a/drivers/net/ethernet/xilinx/ll_temac_main.c
> +++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
> @@ -1408,6 +1408,8 @@ static int temac_probe(struct platform_device *pdev)
>  
>  	/* map device registers */
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -EINVAL;
>  	lp->regs = devm_ioremap(&pdev->dev, res->start,
>  					resource_size(res));
>  	if (!lp->regs) {
> @@ -1503,6 +1505,8 @@ static int temac_probe(struct platform_device *pdev)
>  	} else if (pdata) {
>  		/* 2nd memory resource specifies DMA registers */
>  		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +		if (!res)
> +			return -EINVAL;
>  		lp->sdma_regs = devm_ioremap(&pdev->dev, res->start,
>  						     resource_size(res));
>  		if (!lp->sdma_regs) {
> 

-- 
Florian
