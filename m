Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDDE33B1D4
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 12:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhCOL4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 07:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbhCOL4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 07:56:14 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1163C061764
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 04:56:13 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id b18so8530574wrn.6
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 04:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QcEr1X+mUwsw61u0qn6YZThDpYW/l0i66GNmDFej3bE=;
        b=wsJFcg2KdmWraYw/koGpYI3x1U1tJKhHWsX0i9j7ttS3rxWREfZS7j2t+0c/bL7Hq3
         YRgskRKQEJry3tyMbN8d8QrqzuEUbhr/6jys7QUAj11RpPohyrW27qAGPvPcAkOzOMLL
         8fu70P4RDwLr2LnfJnhPbfM+xbcKCK0H8vvgnJnXIIpC2VnLA6n81VQeAvABONNLs6U0
         zu6WzSlYnCyxUNdY9iEycvbkhlI0b+GadmR6ORMqEE0EB/ZWIKuZhRa56cf0D0JD2Eon
         b+hW31VDvwTIFcolWjY7RKjxPSk/VRgs/w3fVTvVkXqn/oD7jIONSh6wKNsAHxQdIECO
         d3Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QcEr1X+mUwsw61u0qn6YZThDpYW/l0i66GNmDFej3bE=;
        b=mAx4nMnz9T9WUabVs2yikY/TSmRORbumDKlXJWUxlE5VQbONpcq3gBgoKnYlV8uRso
         zQmXDS4S0wA8SVK4mBYNDhLw0zGLo7FICj2Br3ha7A/lncmmqN8oPoo/+s4k/6QVtMsb
         lqDfBFtsyf2CSk/WrDZdXbE0etFLkuIeo98Cu6FBlRHS43xDBv6aQfDxMhu21R2FmyKG
         O1UlGyABXJO1dSNyLwKAuZ31scAzQkdT9xZO+w+yTHImJWuULmWItyLOqlZ7lDM+RZyG
         TxFqNO5n4xb2nrmoyDv9IdYOgTlR6obWJ/37Z5jBTu7ywsiYIv/AZv4tIotJS2tae+jF
         bi7g==
X-Gm-Message-State: AOAM533PoDEeSCYFQ4E1ZpuLevZGh9N12dezIELSIiKzC+eyqvX9+2J/
        q+2i4upBXLAeQHsp4GBh2RQytzVutGbc8xOQ
X-Google-Smtp-Source: ABdhPJx4GYdcsvdqFcIXX9B/f4WeoeXSGuSzpeZYXE707OfevnMNhUBirIs50G/BdTvxNZaxAL/aVw==
X-Received: by 2002:a5d:534b:: with SMTP id t11mr26414610wrv.186.1615809372077;
        Mon, 15 Mar 2021 04:56:12 -0700 (PDT)
Received: from [192.168.0.162] (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id i4sm11698470wmq.12.2021.03.15.04.56.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 04:56:11 -0700 (PDT)
Subject: Re: [PATCH 4/5] soc: qcom: wcnss_ctrl: Allow reading firmware-name
 from DT
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20210312003318.3273536-1-bjorn.andersson@linaro.org>
 <20210312003318.3273536-5-bjorn.andersson@linaro.org>
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Message-ID: <e3421bd4-e4ce-95fc-0598-b73353469d0d@linaro.org>
Date:   Mon, 15 Mar 2021 11:57:42 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210312003318.3273536-5-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/03/2021 00:33, Bjorn Andersson wrote:
> The WLAN NV firmware blob differs between platforms, and possibly
> devices, so add support in the wcnss_ctrl driver for reading the path of
> this file from DT in order to allow these files to live in a generic
> file system (or linux-firmware).
> 
> The new property is optional and the code falls back to the old filename
> if the property isn't specified.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>   drivers/soc/qcom/wcnss_ctrl.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/soc/qcom/wcnss_ctrl.c b/drivers/soc/qcom/wcnss_ctrl.c
> index 358526b9de06..2a06d631e415 100644
> --- a/drivers/soc/qcom/wcnss_ctrl.c
> +++ b/drivers/soc/qcom/wcnss_ctrl.c
> @@ -200,6 +200,7 @@ static int wcnss_download_nv(struct wcnss_ctrl *wcnss, bool *expect_cbc)
>   	struct wcnss_download_nv_req *req;
>   	const struct firmware *fw;
>   	struct device *dev = wcnss->dev;
> +	const char *nvbin = NVBIN_FILE;
>   	const void *data;
>   	ssize_t left;
>   	int ret;
> @@ -208,10 +209,13 @@ static int wcnss_download_nv(struct wcnss_ctrl *wcnss, bool *expect_cbc)
>   	if (!req)
>   		return -ENOMEM;
>   
> -	ret = request_firmware(&fw, NVBIN_FILE, dev);
> +	ret = of_property_read_string(dev->of_node, "firmware-name", &nvbin);
> +	if (ret < 0 && ret != -EINVAL)
> +		goto free_req;
> +
> +	ret = request_firmware(&fw, nvbin, dev);
>   	if (ret < 0) {
> -		dev_err(dev, "Failed to load nv file %s: %d\n",
> -			NVBIN_FILE, ret);
> +		dev_err(dev, "Failed to load nv file %s: %d\n", nvbin, ret);
>   		goto free_req;
>   	}
>   
> 

Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
