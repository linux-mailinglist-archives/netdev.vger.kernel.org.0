Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D173AB128
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 12:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhFQKTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 06:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbhFQKTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 06:19:33 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCB9C061574
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 03:17:25 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id w14so4944263ilv.1
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 03:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TgPllGimVmcNN4ah98danBO0E/RhAz5y3uGjSnBg5Bc=;
        b=PXgXAzeg2+TFQw/5cu/tUjYhxtgHMrg6wM9mTZ/2DUYOajPAZuwkcnT3BA3Vl1uMwJ
         z4AuUF5RRXZKCLYUpFoOruA4jtT6Ej0anJhopRkQcoBSuVzsWXee54XbXWYhRwG79RTt
         TBkG7fMwJoLkYro4pHZQW3dtYgjPtxkyMFwSg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TgPllGimVmcNN4ah98danBO0E/RhAz5y3uGjSnBg5Bc=;
        b=WpZ/Uv/IsLaQ+OZdC6GdKm7r9VG1v69cgluha2awDxVrdHI6iu+OP4gTSo6o4fSWR7
         ptXCnBjUd6fMkBY+5AYqMHkU9Fv1cRGcufS6QOGFacKXAB1/JQdqedbZCB4vIZoBTkRf
         MfF7OKRuBO6J3s2Vo4gA+OCr26lbGqRSwlOavx49o+KlVsdifpMGzwvvIVxuao6J1oEW
         gU6B0ydwfADvInQV9PL0aG1jSmPhGB5LyuDJvY+UmkdvaCAd4uTD1oersrk1BkHacuSR
         7HShGlc1njTjsbxRM0jyb6Als5ITsRgNrA564tUUQZueDHTCBq9G0WZtOMddCF8q0u1n
         kqWw==
X-Gm-Message-State: AOAM531vuRxh4fcP2jvefBr/A0AzMHPgyE+HCsyENQlwoHEFSZ+5kKRM
        PsZgzKNXyjm/l0Iv6fgvADmZ4A==
X-Google-Smtp-Source: ABdhPJz2LAw4NBLhpIqLHyfUazN/hOQHG2W76Bos6afm67s91rmSwPdAKQDg2dDZUAmHkyvazNdM+g==
X-Received: by 2002:a92:3302:: with SMTP id a2mr2993017ilf.62.1623925044956;
        Thu, 17 Jun 2021 03:17:24 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id r8sm2488194iln.35.2021.06.17.03.17.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 03:17:24 -0700 (PDT)
Subject: Re: [PATCH net-next] net: ipa: Add missing of_node_put() in
 ipa_firmware_load()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     elder@kernel.org, davem@davemloft.net, kuba@kernel.org
References: <20210617051119.1153120-1-yangyingliang@huawei.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <dc64b44a-12a7-e5e0-1532-577d6479d7c0@ieee.org>
Date:   Thu, 17 Jun 2021 05:17:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210617051119.1153120-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/21 12:11 AM, Yang Yingliang wrote:
> This node pointer is returned by of_parse_phandle() with refcount
> incremented in this function. of_node_put() on it before exiting
> this function.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Acked-by: Alex Elder <elder@linaro.org>

> ---
>   drivers/net/ipa/ipa_main.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
> index 2243e3e5b7ea..f82130db32f6 100644
> --- a/drivers/net/ipa/ipa_main.c
> +++ b/drivers/net/ipa/ipa_main.c
> @@ -530,6 +530,7 @@ static int ipa_firmware_load(struct device *dev)
>   	}
>   
>   	ret = of_address_to_resource(node, 0, &res);
> +	of_node_put(node);
>   	if (ret) {
>   		dev_err(dev, "error %d getting \"memory-region\" resource\n",
>   			ret);
> 

