Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE143A8E71
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 03:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhFPBiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 21:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbhFPBiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 21:38:01 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BFCC061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 18:35:56 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id b14so1230084iow.13
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 18:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7bNjmIPFclZ2FCgec9xd3eJMIjtOz4tBaEzOZZ1tjmI=;
        b=CQQ7Zg8WS61afNkLnw/NYffYdJhxZ5WM39Sr6PmBhIQH/e67aVU718IDjV5WtVGxiH
         tHa2UYN386lxPOKDL9x5dVlWi4EEhXCBHC4rOH5vQA7SwaF/YEsr3S9ia+j8o7LlHH1m
         GVRcUFBtyomUaEDYRm4jWSdxYMkPWo8T3/o4seWwg0BgXjLEmMYdJQB7whHuXPNbtX0U
         cTRCgr72Hm0vyIu8aiiEJsJ4KJb8yBKU4B+ai3FHX1zdUPNUEEu5mgkSX+M5L1qIdScg
         M8RrEYPjBHtf/e0cJ8L4jIMmRiqFkwnzN7/lc+F3ADJbS8pMcrBPVolQXJhZt5XRVpCe
         boFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7bNjmIPFclZ2FCgec9xd3eJMIjtOz4tBaEzOZZ1tjmI=;
        b=HeYQPhtJkinHKTgFdj0wWYIqJs8k80GixXO5S9HYfwsOEKKwC9T5o8VYWjnPgZvxpX
         EpiEkHk+bDS29OKJ3ike5zMTaLa49jVDa4/j/tKuicWNdW0xWnTkTJD+YctWIjQ/WJJk
         flTMn1MUUQx/QOwb7wrHK//UUgNnAQlLfMfv5RHIEpwIv+A+LM+kMKgbLGy8lQCPPnwe
         gl9HPRrrmPdAf5rD7FnrdTSp6LJ89nB/4m2csKb6piNVMVjCjbtDFWhCWf1ydm4kn9lq
         wx0nxEOmrOLCkBBGTM8xcJ8uUn6n31/Yxn41KpXfCoIjxVUcWR3rXyv1s23KWoz/rU2g
         Eazw==
X-Gm-Message-State: AOAM532LqBx7PLMUH1HemqOxMNm32/kF3QZPDovO4rgWLOEeiw4hEpte
        qjCzShNz17VuxSnoUnr4etwd8A==
X-Google-Smtp-Source: ABdhPJyESIdB78DT0ePZT1DdKJS22IlwGz3IdZmg5v3sBla/5pn1rYkikhBG10Z+SBAjuBJ5Fym9tA==
X-Received: by 2002:a5d:904c:: with SMTP id v12mr1565434ioq.95.1623807354648;
        Tue, 15 Jun 2021 18:35:54 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id d12sm402073ilr.38.2021.06.15.18.35.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 18:35:54 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: qualcomm: rmnet: Allow partial updates
 of IFLA_FLAGS
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210615232707.835258-1-bjorn.andersson@linaro.org>
From:   Alex Elder <elder@linaro.org>
Message-ID: <37f0f6f3-3a11-304f-4030-445e2bc578e6@linaro.org>
Date:   Tue, 15 Jun 2021 20:35:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210615232707.835258-1-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/21 6:27 PM, Bjorn Andersson wrote:
> The idiomatic way to handle the changelink flags/mask pair seems to be
> allow partial updates of the driver's link flags. In contrast the rmnet
> driver masks the incoming flags and then use that as the new flags.
> 
> Change the rmnet driver to follow the common scheme, before the
> introduction of IFLA_RMNET_FLAGS handling in iproute2 et al.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

KS was right, we want the same behavior in both newlink and changelink,
but aside from that, I like this a lot.

It looks good to me.

Reviewed-by: Alex Elder <elder@linaro.org>

> ---
> 
> Changes since v1:
> - Also do the masking dance on newlink, per Subash request
> - Add "net-next" to subject prefix
> 
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> index 8d51b0cb545c..27b1663c476e 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> @@ -163,7 +163,8 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
>  		struct ifla_rmnet_flags *flags;
>  
>  		flags = nla_data(data[IFLA_RMNET_FLAGS]);
> -		data_format = flags->flags & flags->mask;
> +		data_format &= ~flags->mask;
> +		data_format |= flags->flags & flags->mask;
>  	}
>  
>  	netdev_dbg(dev, "data format [0x%08X]\n", data_format);
> @@ -336,7 +337,8 @@ static int rmnet_changelink(struct net_device *dev, struct nlattr *tb[],
>  
>  		old_data_format = port->data_format;
>  		flags = nla_data(data[IFLA_RMNET_FLAGS]);
> -		port->data_format = flags->flags & flags->mask;
> +		port->data_format &= ~flags->mask;
> +		port->data_format |= flags->flags & flags->mask;
>  
>  		if (rmnet_vnd_update_dev_mtu(port, real_dev)) {
>  			port->data_format = old_data_format;
> 

