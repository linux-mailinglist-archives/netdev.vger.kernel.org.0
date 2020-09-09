Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D758E262873
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 09:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbgIIHV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 03:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgIIHVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 03:21:54 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76CEC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 00:21:53 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id r7so2007306ejs.11
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 00:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EZbxsoBtaq8AxW3mkLwv1ac/GP0gLmflCPSHg4QJve8=;
        b=jgslk48pfrUL6cyEbgwn9eqCqWPziUNzZUdUkpjJ/ezfiCCXYBkSa9JQyOWifoyUGh
         Ea8no0UeeW8ahVNg5sSP5kHzaDNGy2HdmShLJzxnUyRVOS5K+n++WpKx+uCYAFKsTX/A
         TZ4v6HTPUGWOi71sO1nkcXQYPD7BwyqmptZaSeUTNdaYtPS1xIsMuoaaa6juTW8IMxDC
         sGD4eQOGXEMQ511Dkec5MhmfOPG1QitRG5IBp5+Al1trMd4bl4NmQY58sL+CckIqceUI
         gV3C2Vztf1YZXdElprn/5lY/CVK+abS1ToWRcy0dIRuoUR/viebIeeoJlAb2kH7elFpL
         4NQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EZbxsoBtaq8AxW3mkLwv1ac/GP0gLmflCPSHg4QJve8=;
        b=e7KNc+QpMtp0Y1lkLZP3gAXkyBo7hjV6KswJ9VolKQY+obNoNfOH4Y0doB+ElbdFVQ
         WhSagw1l0p/vsoCnY5tQoFLkOg1hFAdq0gMmAaxEv8CPOTIXJVuhB6M/kVz5eYl0ao+f
         mxbrk6WoKuCnP1+LGsi4VUvBnChyhB/U0J4hx7TOyHJxotTMjoCTXSW86ABVRmtZqRcR
         ZST6Wep6yJQxQRibVaD5eicPZy1VVBXzOXqPJ5jDFq0IXjygRJ8jcOKBKXjMR9aXjA8u
         y2NSShO3AV8iFIE72i3gCk43u5F87xS/ZjlO4zAemtcih+8oiXV79a+dehsTZzclKRKj
         uodQ==
X-Gm-Message-State: AOAM531ALe3cCnAmMbJfPJ4UjMkxVVmQE9mQjAwWgicZEsXQrcpyV7dR
        G3CR6U75zvd0jzewTWGXlmA=
X-Google-Smtp-Source: ABdhPJwIXNSVCe6FjvK7ep/ghx47oygYDuPMYyWVAxSE8k6PSjjc70elcc0b/deCYpetxxmFxj6e6w==
X-Received: by 2002:a17:906:3e08:: with SMTP id k8mr2282430eji.480.1599636112441;
        Wed, 09 Sep 2020 00:21:52 -0700 (PDT)
Received: from [192.168.0.108] ([77.127.52.212])
        by smtp.gmail.com with ESMTPSA id o23sm1233620eju.17.2020.09.09.00.21.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 00:21:51 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] mlx4: make sure to always set the port
 type
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, tariqt@mellanox.com,
        ogerlitz@mellanox.com, yishaih@mellanox.com, saeedm@mellanox.com,
        leonro@nvidia.com
References: <20200908222114.190718-1-kuba@kernel.org>
 <20200908222114.190718-3-kuba@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <db239d72-e4f7-b8d3-a50d-254311281dcd@gmail.com>
Date:   Wed, 9 Sep 2020 10:21:39 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908222114.190718-3-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2020 1:21 AM, Jakub Kicinski wrote:
> Even tho mlx4_core registers the devlink ports, it's mlx4_en
> and mlx4_ib which set their type. In situations where one of
> the two is not built yet the machine has ports of given type
> we see the devlink warning from devlink_port_type_warn() trigger.
> 
> Having ports of a type not supported by the kernel may seem
> surprising, but it does occur in practice - when the unsupported
> port is not plugged in to a switch anyway users are more than happy
> not to see it (and potentially allocate any resources to it).
> 
> Set the type in mlx4_core if type-specific driver is not built.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   drivers/net/ethernet/mellanox/mlx4/main.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> index 258c7a96f269..70cf24ba71e4 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> @@ -3031,6 +3031,17 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
>   	if (err)
>   		return err;
>   
> +	/* Ethernet and IB drivers will normally set the port type,
> +	 * but if they are not built set the type now to prevent
> +	 * devlink_port_type_warn() from firing.
> +	 */
> +	if (!IS_ENABLED(CONFIG_MLX4_EN) &&
> +	    dev->caps.port_type[port] == MLX4_PORT_TYPE_ETH)
> +		devlink_port_type_eth_set(&info->devlink_port, NULL);
> +	else if (!IS_ENABLED(CONFIG_MLX4_INFINIBAND) &&
> +		 dev->caps.port_type[port] == MLX4_PORT_TYPE_IB)
> +		devlink_port_type_ib_set(&info->devlink_port, NULL);
> +
>   	info->dev = dev;
>   	info->port = port;
>   	if (!mlx4_is_slave(dev)) {
> 

Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
