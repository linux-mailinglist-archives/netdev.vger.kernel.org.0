Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA17E31959D
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhBKWMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhBKWMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 17:12:16 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2396C0613D6;
        Thu, 11 Feb 2021 14:11:35 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id g6so5650779wrs.11;
        Thu, 11 Feb 2021 14:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EVMkLE8ZEQPIGcKVp1+MK6xpYvu/Zlxrqw/Ql7iZyp8=;
        b=Z+TX+PWJXYT2waSFlMOQHnPimX6MIVmjFZWN44WMwcJMZ9e/FYT8Iy69PbWPSVhfwi
         mOzaQYbkMikucj9LrPcaMsP7D8Z4vtlkqxQgpvaTFgU8MHwL4V6KSI7ELsDvmu7I/ATK
         /IYLiukYyhGytXHXdApywxNEYJ+yFWNnVvO7lH6sdhCp1X3d/S0kJePCNpXJV/lLXhKH
         +Q2Wc8zc+ECo2yzL5aRwP5Tr7H4ozjZGe95eMQtKwYPfa7H/8sJYveP8VQWl+XdOVTcr
         YLuZd2D70tL1oHw7TGJRaT8l11itxPwGdRq4u8Eb0qTnEs3Jhn+dc0NYxm6W9VrBbIhY
         hcyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EVMkLE8ZEQPIGcKVp1+MK6xpYvu/Zlxrqw/Ql7iZyp8=;
        b=sccxjyjXMHeZ3TcucPfMpUQfy85DbYFHPzxwRI7WJffweo34StCszBJrITxOuzGYFc
         mrLBi9Lun2sOwWcfbqZ5SA4hmOs+xuIsmt6U38s6sZUGD8giox39nqiC+mLCaQ4Dszcc
         g/9qEFzRkcZYXTCP/BaMWJ0TZcgXcdQqdRuanUmlqr+9OOkATTquF0SkIIhJTL9s6PmH
         9gP7JWMZxGupABDz/ZqwhtT22fDyZBoASDXFsfshwPmZdnglPTHSkhHRAjTD5fAGKUa6
         OgxVLUfFAtIKEmTm402mr51snqu0OPusR0TkBcTCh4IWo8GeGOufPQpQSkhU2biR4UWD
         fmEA==
X-Gm-Message-State: AOAM532kgHCOEVEKDgBhr2mRE7htwRuUgaWDt2FhXhKnzYDWlfe12r5n
        bDudQ6jXjsjz7Io57R1ddxaRuPR7Si4pGw==
X-Google-Smtp-Source: ABdhPJzl0q7kWvSul/JIjAABngAT96WD21q0wXm8XjIqWHBY2B3RMfgQxOxUYcqpYdhM08q5qJZ2NA==
X-Received: by 2002:adf:a59a:: with SMTP id g26mr7712767wrc.271.1613081494241;
        Thu, 11 Feb 2021 14:11:34 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:1524:b28c:2a1c:169e? (p200300ea8f1fad001524b28c2a1c169e.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:1524:b28c:2a1c:169e])
        by smtp.googlemail.com with ESMTPSA id b15sm6779694wrr.47.2021.02.11.14.11.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 14:11:33 -0800 (PST)
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210211211927.28061-1-elder@linaro.org>
 <20210211211927.28061-3-elder@linaro.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2 net-next 2/5] net: ipa: don't report EPROBE_DEFER error
Message-ID: <b1824bb1-5e17-7e5c-98e4-9249fbb1188a@gmail.com>
Date:   Thu, 11 Feb 2021 23:11:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210211211927.28061-3-elder@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.02.2021 22:19, Alex Elder wrote:
> When initializing the IPA core clock and interconnects, it's
> possible we'll get an EPROBE_DEFER error.  This isn't really an
> error, it's just means we need to be re-probed later.
> 
> Check the return code when initializing these, and if it's
> EPROBE_DEFER, skip printing the error message.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/ipa_clock.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
> index 354675a643db5..238a713f6b604 100644
> --- a/drivers/net/ipa/ipa_clock.c
> +++ b/drivers/net/ipa/ipa_clock.c
> @@ -1,7 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  
>  /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
> - * Copyright (C) 2018-2020 Linaro Ltd.
> + * Copyright (C) 2018-2021 Linaro Ltd.
>   */
>  
>  #include <linux/refcount.h>
> @@ -68,8 +68,9 @@ static int ipa_interconnect_init_one(struct device *dev,
>  	if (IS_ERR(path)) {
>  		int ret = PTR_ERR(path);
>  
> -		dev_err(dev, "error %d getting %s interconnect\n", ret,
> -			data->name);
> +		if (ret != -EPROBE_DEFER)
> +			dev_err(dev, "error %d getting %s interconnect\n", ret,
> +				data->name);
>  

You may want to use dev_err_probe() here.

>  		return ret;
>  	}
> @@ -281,7 +282,10 @@ ipa_clock_init(struct device *dev, const struct ipa_clock_data *data)
>  
>  	clk = clk_get(dev, "core");
>  	if (IS_ERR(clk)) {
> -		dev_err(dev, "error %ld getting core clock\n", PTR_ERR(clk));
> +		ret = PTR_ERR(clk);
> +		if (ret != -EPROBE_DEFER)
> +			dev_err(dev, "error %d getting core clock\n", ret);
> +
>  		return ERR_CAST(clk);
>  	}
>  
> 

