Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2323864A143
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 14:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbiLLNhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 08:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbiLLNhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 08:37:23 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFEC13E9F
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 05:36:47 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id 3so5719120iou.12
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 05:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XRZwufW4/TiQTPauxmRLaTVOjEccKG9/fVgaRUTLj+0=;
        b=MqRhgEcXTVFoc4N7S8UoYGpAVKTYM2zCdOMhFM3so+edfmoNfYDbvH7tirZz4M54mB
         SExkIUUeecG8cm7Xpw9sRHOeVPXL16NXkwCb70wQGbpfu+DKw9slhx0d1v1jB/RLO9Gx
         y8U+SN+y7Y4ECjUfcoIeV88E2LzuNESTif3Fp6kHjcCdmw1XR9gn4D9V2Qowm1rXwHps
         Taw+HRAP0WOmQWdZkwT4BhQpv18Cox2+8fISOzvBPrInoGwBT63AuYOiFeAjZ+XTyq45
         +89JstzlqDEJFilFThrLiBjsvg0Qdk8YFLIV3c6/ZUQe7Z7RLEb1zteKrXaM2ElzSoVj
         txdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XRZwufW4/TiQTPauxmRLaTVOjEccKG9/fVgaRUTLj+0=;
        b=ZC7T6bv/LW94qG2CbQwxKZXkIey4o3i7Cr+6OsJl5DR9ao+bMeoMHzE+4tDk9adBIG
         4/mM0GJKxtbQqgUYuM8ZdYopLmB0rbsyCwZcIfxmT18sTK2NCXyZOOhjLOKP7/DHgTDp
         nZk14T8BBN7VjNc6cgXUl5rgdykaOYR24OOupcr9CghoKpQwwiVCsW4dFuPAp4uq1Xbr
         IFhu3zxX5ViXsTG1Epp1m4ONS+hLXjc1PmjJV0WZtLvRdtIbZCO+lRBwX7OxWNy0pTlu
         lNC2HHz+vu3KuuRgdzg0RzI8NSysNMsoEDqkY8J9MaX2IGdvfxSYaJgcuhNGfgFCRJio
         +yEQ==
X-Gm-Message-State: ANoB5pl8LZUhkkG91YgF2sXbxwGflyQh2e2qjnMisQakmNVCToqLTiph
        2LpGkuRkOJxNc0wRyurjyzsgLzkapN2cIZbCGX8=
X-Google-Smtp-Source: AA0mqf7t/qdmBJ+Ad+GNoBEw4td1qt/j5dny1satmJ7JanznE6G08OkgCfgm2W1D2H6cGm/qGHO5XA==
X-Received: by 2002:a05:6602:22d5:b0:6e0:7dd:59ac with SMTP id e21-20020a05660222d500b006e007dd59acmr10090839ioe.14.1670852206665;
        Mon, 12 Dec 2022 05:36:46 -0800 (PST)
Received: from [10.211.55.3] ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id k1-20020a0566022a4100b006bb57cfcb88sm4025040iov.44.2022.12.12.05.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 05:36:46 -0800 (PST)
Message-ID: <b98e8a7b-0610-6fd2-1b51-5feca73f79ef@linaro.org>
Date:   Mon, 12 Dec 2022 07:36:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2] net: ipa: Remove redundant dev_err()
Content-Language: en-US
To:     Kang Minchul <tegongkang@gmail.com>, Alex Elder <elder@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221212071854.766878-1-tegongkang@gmail.com>
From:   Alex Elder <alex.elder@linaro.org>
In-Reply-To: <20221212071854.766878-1-tegongkang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/12/22 1:18 AM, Kang Minchul wrote:
> Function dev_err() is redundant because platform_get_irq_byname()
> already prints an error.
> 
> Also, platform_get_irq_byname() can't return 0 so ret <= 0
> should be ret < 0.
> 
> Signed-off-by: Kang Minchul <tegongkang@gmail.com>

Now that I've looked at this closely, it's not clear what
version of the code you are basing your patch on.

The current version of net-next/master, as well as the
current linus/master, do not include the message you
are removing.  This patch removed the message more than
a year ago:

   91306d1d131ee net: ipa: Remove useless error message

So at least the portion of your patch that removes the
message is unnecessary.

Meanwhile, it seems there is no need to check for a 0
return from platform_get_irq_byname(), but there is
no harm in doing so.

If you would like to send version 3 of this patch, which
would return what platform_get_irq_byname() returns if it
is less than 0 in gsi_irq_init(), I would be OK with that.

But please it on net-next/master.

Thanks.

					-Alex

> ---
> Changes in v2:
>    - Annotate patch with net-next.
>    - Remove unnecessary comparison with zero.
> 
>   drivers/net/ipa/gsi.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> index 55226b264e3c..a4f19f7f188e 100644
> --- a/drivers/net/ipa/gsi.c
> +++ b/drivers/net/ipa/gsi.c
> @@ -1967,11 +1967,8 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev, bool prefetch,
>   
>   	/* Get the GSI IRQ and request for it to wake the system */
>   	ret = platform_get_irq_byname(pdev, "gsi");
> -	if (ret <= 0) {
> -		dev_err(gsi->dev,
> -			"DT error %d getting \"gsi\" IRQ property\n", ret);
> +	if (ret < 0)
>   		return ret ? : -EINVAL;
> -	}
>   	irq = ret;
>   
>   	ret = request_irq(irq, gsi_isr, 0, "gsi", gsi);

