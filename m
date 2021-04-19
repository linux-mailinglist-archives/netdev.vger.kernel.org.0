Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C62D363EB5
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 11:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238686AbhDSJjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 05:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhDSJjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 05:39:08 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A0AC06174A;
        Mon, 19 Apr 2021 02:38:37 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id z13so37875116lfd.9;
        Mon, 19 Apr 2021 02:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qeqfISbVM2w7Pu7fUrVjLsN6tyhOhIQnaxOgyYh0Dxc=;
        b=dP/uPUa/GvE53vERq7s0HWSJILahAfZgv7PzzcRU+ZXNB5zH8K9FDS/huhv7UJh2zv
         E8TlO5tj2mkyfkggBLM2lygtO8y12DjjvOouY1IfJw+aeL/o6JqgSw/OD8SedN5UTZkQ
         Ld6Zu8IEWO+iI2TBW+R2ywbxz9gwjW6gqfq/IxZMf1u8Pl50yLy49BIu20l4BSDrGetO
         uHIuXQgEmFnPBD2GS4FoiHiqhEMFMeMygiRPgBpFKXlr3BdySTT18dkhFRjHHFVrbWXP
         5W/Mm1VaipOzOChHuhDIvCKZWQAtvHbn9QaWBA5W5kiULcnkZRFmk+w3LPwVeEpVIL8X
         oMrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=qeqfISbVM2w7Pu7fUrVjLsN6tyhOhIQnaxOgyYh0Dxc=;
        b=DxHex1MRPE2aAV2fo8a1HbPKQIuFHkr3Q1xHL3XIF/qd3T7HnRojzIlYbDXIUBpVqC
         DPY3HwLgEBC274gKJ1+GEAYhYDA3ZlSobygXFYX0HiOFz/wQSaIJuOxLBU8ePHX3uJqH
         9dp0l6zu4ZO2NTmkqCGbQAa3sX3jDH7deuHAmaoYLwPsfrH4vdd8HaYTFCxE97eN/N20
         Id2/Ng3QutBgCVX53r/SUiVXwE1N/QlHwMSnPn8rkxJ65L0tk5grwVv/cCKkT1tvkBht
         LSL+2cpXN9WyeOgy7DWUmqhbhuijp6uCoavLeifSuUmRqzrOZHsWtTK85MEFvgkDqJVo
         SB1w==
X-Gm-Message-State: AOAM5331A1lMxzh8RIsngP9OGUsjbKZdeU1bXInCjT68Bc7odMk7SnG7
        kHlBaoMgwo51cQRZsf1cUgvf9ET4CqYtJg==
X-Google-Smtp-Source: ABdhPJxVkWCmKvfU8TczGps6ZFnUYIUNU9kVduyFVnFuC0e4G12HzQ+w7UyAG9JCeMW5zVOjyFqmcA==
X-Received: by 2002:a19:850b:: with SMTP id h11mr12321534lfd.342.1618825116410;
        Mon, 19 Apr 2021 02:38:36 -0700 (PDT)
Received: from [192.168.1.100] ([178.176.74.223])
        by smtp.gmail.com with ESMTPSA id y8sm1827017ljk.9.2021.04.19.02.38.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 02:38:36 -0700 (PDT)
Subject: Re: [PATCH] net: ethernet: ravb: Fix release of refclk
To:     Adam Ford <aford173@gmail.com>, netdev@vger.kernel.org
Cc:     aford@beaconembedded.com, geert@linux-m68k.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210417132329.6886-1-aford173@gmail.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <ae2f6201-3646-4896-0246-8ae849df3a4f@gmail.com>
Date:   Mon, 19 Apr 2021 12:38:33 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210417132329.6886-1-aford173@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 17.04.2021 16:23, Adam Ford wrote:

> The call to clk_disable_unprepare() can happen before priv is
> initialized.

    Mhm, how's that? :-/

> This means moving clk_disable_unprepare out of
> out_release into a new label.
> 
> Fixes: 8ef7adc6beb2("net: ethernet: ravb: Enable optional refclk")
> Signed-off-by: Adam Ford <aford173@gmail.com>
> 
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 8c84c40ab9a0..64a545c98ff2 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
[...]
> @@ -2252,8 +2252,9 @@ static int ravb_probe(struct platform_device *pdev)
>   	/* Stop PTP Clock driver */
>   	if (chip_id != RCAR_GEN2)
>   		ravb_ptp_stop(ndev);
> -out_release:
> +out_unprepare_refclk:

    I'd really prefer out_disable_refclk.

>   	clk_disable_unprepare(priv->refclk);
> +out_release:
>   	free_netdev(ndev);
>   
>   	pm_runtime_put(&pdev->dev);

MBR, Sergei
