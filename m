Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467DD33B1E0
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 12:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhCOL5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 07:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbhCOL5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 07:57:00 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0EEC061764
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 04:57:00 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo19275435wmq.4
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 04:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Yev+AXBqBGQDoXLDGZvdwqzLRoGYBMa84ajRYLADAlY=;
        b=GKC+39P/+pAeKRKWUcuMCwME3qJHyZGlsL9yqmqZtqu8kkztx6r1WhHmqTEvmVr6TZ
         bgUHfi9WX4zcZ5UzwzqLfAjWbya6i5SdVTaM4HkMx9QSFtba/d1QAm7zkI++XA5oL2x6
         EjxinYlQjGbo8yeoieAaNG06T6BV7YJ0sQDoFCZlwU5/5mc8VzeJ0fATfGfnEt/P/gIZ
         RO53T3kNHCq8UmCcNapXnAHD/M1FVJF+Z3O9Cfbr19z+ygfq/1OgvYU16mIFQ3xE9yVq
         1DxhtlDlhIDn/UgecK53C6qRJCw0siuxA/HYbM12zJjX73B/zG9+rPG71VgVPhCyss7N
         Gdzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yev+AXBqBGQDoXLDGZvdwqzLRoGYBMa84ajRYLADAlY=;
        b=rVTWdgrFkFX+deApPHZTgrZkioultzyg1gvb1bVqKsuK6GqTARaimzHt13fAzE0ru7
         dqTq7v1Nsm5WSplPo/tUU8MQy9CoZE/yUCaia1eXmXUmwNFEbEJTAJ/WAAos0x8w+x6u
         5MKkl+pKGZPM7JopJHRISO36y97ByKThRTczhK6LcP2bHgu3Dgx9P3lXUbqcMEEklkxI
         HOZ5rfQKIphs0cq/r6LeYVrcLGJwaEBgJBLfJMQbTlidvmi+c4aInm1F6gEFjtljiOXm
         vxT3Xn8Om2c1vZga0xrozfGgqeGxkWbzKjzVNJm2uB5Jtn9x6G/8IC0Mctoupx6IXTU3
         bBPg==
X-Gm-Message-State: AOAM532jgvIr+Tsm2I5JXGCwFmS1aalyCdi7ZtfPp6ToadSq5Bt73tSq
        NLVBkGLnzPPU90LvgSDnw1EHTFJzS9mDWIS0
X-Google-Smtp-Source: ABdhPJxT6sZ4Kyu6Ea72eRUbWYWp7uYlahgXPf1kv/Lqw9O1aIRHSWEgLHAU7/0c59NW+hlMQHpP0g==
X-Received: by 2002:a05:600c:3541:: with SMTP id i1mr10685689wmq.97.1615809418800;
        Mon, 15 Mar 2021 04:56:58 -0700 (PDT)
Received: from [192.168.0.162] (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id l15sm18325308wru.38.2021.03.15.04.56.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 04:56:58 -0700 (PDT)
Subject: Re: [PATCH 2/5] wcn36xx: Allow firmware name to be overridden by DT
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20210312003318.3273536-1-bjorn.andersson@linaro.org>
 <20210312003318.3273536-3-bjorn.andersson@linaro.org>
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Message-ID: <a462bb9f-657d-6543-1f93-95c7f360a2e6@linaro.org>
Date:   Mon, 15 Mar 2021 11:58:29 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210312003318.3273536-3-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/03/2021 00:33, Bjorn Andersson wrote:
> The WLAN NV firmware blob differs between platforms, and possibly
> devices, so add support in the wcn36xx driver for reading the path of
> this file from DT in order to allow these files to live in a generic
> file system (or linux-firmware).
> 
> For some reason the parent (wcnss_ctrl) also needs to upload this blob,
> so rather than specifying the same information in both nodes wcn36xx
> reads the string from the parent's of_node.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
> 
> This patch can be applied independently of the others, but relates to the
> acceptance of the addition to the DT binding (in patch 1/5). So my suggestion
> is that this one goes through the ath tree and the others through the Qualcomm
> SoC tree.
> 
>   drivers/net/wireless/ath/wcn36xx/main.c    | 7 +++++++
>   drivers/net/wireless/ath/wcn36xx/smd.c     | 4 ++--
>   drivers/net/wireless/ath/wcn36xx/wcn36xx.h | 1 +
>   3 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> index afb4877eaad8..87b5c0ff16c0 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -1407,6 +1407,13 @@ static int wcn36xx_probe(struct platform_device *pdev)
>   		goto out_wq;
>   	}
>   
> +	wcn->nv_file = WLAN_NV_FILE;
> +	ret = of_property_read_string(wcn->dev->parent->of_node, "firmware-name", &wcn->nv_file);
> +	if (ret < 0 && ret != -EINVAL) {
> +		wcn36xx_err("failed to read \"firmware-name\" property\n");
> +		goto out_wq;
> +	}
> +
>   	wcn->smd_channel = qcom_wcnss_open_channel(wcnss, "WLAN_CTRL", wcn36xx_smd_rsp_process, hw);
>   	if (IS_ERR(wcn->smd_channel)) {
>   		wcn36xx_err("failed to open WLAN_CTRL channel\n");
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index d0c3a1557e8d..7b928f988068 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -514,10 +514,10 @@ int wcn36xx_smd_load_nv(struct wcn36xx *wcn)
>   	u16 fm_offset = 0;
>   
>   	if (!wcn->nv) {
> -		ret = request_firmware(&wcn->nv, WLAN_NV_FILE, wcn->dev);
> +		ret = request_firmware(&wcn->nv, wcn->nv_file, wcn->dev);
>   		if (ret) {
>   			wcn36xx_err("Failed to load nv file %s: %d\n",
> -				      WLAN_NV_FILE, ret);
> +				    wcn->nv_file, ret);
>   			goto out;
>   		}
>   	}
> diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
> index 71fa9992b118..5977af2116e3 100644
> --- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
> +++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
> @@ -185,6 +185,7 @@ struct wcn36xx {
>   	struct device		*dev;
>   	struct list_head	vif_list;
>   
> +	const char		*nv_file;
>   	const struct firmware	*nv;
>   
>   	u8			fw_revision;
> 

Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
