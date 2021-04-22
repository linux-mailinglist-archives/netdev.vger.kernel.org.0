Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DB036868F
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 20:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238740AbhDVS36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 14:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238463AbhDVS35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 14:29:57 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55997C061756
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 11:29:22 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id l9so2915280ilh.10
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 11:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IbyceF9eui++TAtaSZCeZk5izUprZMiF7QKSv4IUobA=;
        b=wFbJIb87LPilAH04qOvCl1m//akK+exnwlHVZTVvemwMBA6BxEytxRdZvZuT1Vut8Y
         /hlyWUZEQwaZ8dv6gZ6Nm3zJUeuqxhs6csXnOwf1mp7ZrLo3ZVvmPWEQ/aVX1NIbafj7
         lrTqpo83oxozY6x1fEVyGMdK32GgDkBCEx1yFzxxrmC8TIXAf5PqlHfhs9TP9vSXWZPB
         CvvW+rBpDSZN/T4YYy8zg2+RzffPIu/2hz0FvVHV8Onqti5uLSDPKoyDiZX/mJUv9S+L
         LiZNoFpulV9KdU+8Bv0hQ0r+4FiYgwtHhuez87M+pLnZHO99w5BwQiU/Tdsm6lx8ih71
         e18w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IbyceF9eui++TAtaSZCeZk5izUprZMiF7QKSv4IUobA=;
        b=Mo+0Wbno7P5RujRImXJiX61IgSqD+UT2MmdqpmOcA8qbzasqYe42KMCrIFOr5WS5qq
         +Lt50nKaPrerI04JSIJXHf0YvnJe0VTStxUaj8spZxbfqzGYAoeE2NgBvYRcsgRw8gMb
         qUhdjnTQZix6qk12ZzOuWQCfyuFYADz/SXqVtgvlrbck+II8KDNFG7dahDq2jnXHHe0L
         Y5vUPQeoIzALy0sBcj6KsgDR5GEQMjecVvfV7sgrdC+dUfBS5ZpgiPPspdEMX5U+GXeV
         X3we/N9dcqzQI9xw2tVc8o/Ip1YEDx2v9KBU3T4ugfqmW47Dr9ZWmEGwhhkvQzxywowW
         qiPg==
X-Gm-Message-State: AOAM531fFQSFqyFvervtcWIPXLs1llUubihYSv1CsOMLJF1qRheaAgbY
        3RxDWnu1ydId3QEBt4ZReQcwHw==
X-Google-Smtp-Source: ABdhPJyY9eJZp9VAetK5Q0+RdfAXkpq38nHagsnhZeEz9s729SPJ5vt8aH5CMSfLEBwViFdbG+qADA==
X-Received: by 2002:a05:6e02:168f:: with SMTP id f15mr4222568ila.264.1619116161690;
        Thu, 22 Apr 2021 11:29:21 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id u9sm1422138ilg.69.2021.04.22.11.29.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 11:29:21 -0700 (PDT)
Subject: Re: [PATCH] net: qualcomm: rmnet: Allow partial updates of IFLA_FLAGS
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniele Palmas <dnlplm@gmail.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Loic Poulain <loic.poulain@linaro.org>
References: <20210422182045.1040966-1-bjorn.andersson@linaro.org>
From:   Alex Elder <elder@linaro.org>
Message-ID: <76db0c51-15be-2d27-00a7-c9f8dc234816@linaro.org>
Date:   Thu, 22 Apr 2021 13:29:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210422182045.1040966-1-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/21 1:20 PM, Bjorn Andersson wrote:
> The idiomatic way to handle the changelink flags/mask pair seems to be
> allow partial updates of the driver's link flags. In contrast the rmnet
> driver masks the incoming flags and then use that as the new flags.
> 
> Change the rmnet driver to follow the common scheme, before the
> introduction of IFLA_RMNET_FLAGS handling in iproute2 et al.

I like this a lot.  It should have been implemented this way
to begin with; there's not much point to have the mask if
it's only applied to the passed-in value.

KS, are you aware of *any* existing user space code that
would not work correctly if this were accepted?

I.e., the way it was (is), the value passed in *assigns*
the data format flags.  But with Bjorn's changes, the
data format flags would be *updated* (i.e., any bits not
set in the mask field would remain with their previous
value).

Reviewed-by: Alex Elder <elder@linaro.org>

> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>   drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> index 8d51b0cb545c..2c8db2fcc53d 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> @@ -336,7 +336,8 @@ static int rmnet_changelink(struct net_device *dev, struct nlattr *tb[],
>   
>   		old_data_format = port->data_format;
>   		flags = nla_data(data[IFLA_RMNET_FLAGS]);
> -		port->data_format = flags->flags & flags->mask;
> +		port->data_format &= ~flags->mask;
> +		port->data_format |= flags->flags & flags->mask;
>   
>   		if (rmnet_vnd_update_dev_mtu(port, real_dev)) {
>   			port->data_format = old_data_format;
> 

