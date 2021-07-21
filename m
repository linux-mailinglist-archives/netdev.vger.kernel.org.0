Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFEE03D12F3
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240014AbhGUPPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239996AbhGUPPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 11:15:24 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1112C061757
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 08:55:59 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id q13so243459plx.7
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 08:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=RSgJZgL5+8JDLD0WocVJD8SB24xW93k7iVgT/78Sy20=;
        b=Bz5HdzvhnqAwgoTJ2mc8rFx1BZpq5k+jDTZz4jPm9R7EwU5EbHBqm+WngUGHOa3F9g
         LEjEORs2BZn3AT3cbgPsz5qrMl8eB58PvC/215HL1dNBAsPby8+wcsTI7Glw2+qnCXj/
         VAJd4vq70yT6IOSpy3ndijUSf5ImyQ5d5Lc21BuBOgE7IdpYAVl+eI2ez6Y+/q1MGtnL
         qXfPTC9aQdtE7YZrgQ2SsHGl5FI+MJ0yqVm8091yvpqx+i3zRR7u6jKld9nMqwgr1rSs
         LpBkJ4RctuIJk3ajs08+1G8bVXdd/L0VjbhxCm9j2kYkblX2HF2eU23ovCnf60Pz5I7D
         CNxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=RSgJZgL5+8JDLD0WocVJD8SB24xW93k7iVgT/78Sy20=;
        b=ePPvZmHGAYEXFmgTke3WiG1DMCAuvvlC2vfOHeJTj9YKAHX6EfR+dGmjH1WYRmixJ7
         91J2XlOCxigDrpeWss+3HVWizX37r1pKJoBdRWT/ecepduOsEzPC7nw8bZo13tsZkYzL
         S60j8pBJZeOv02yyNa1sJPam3XwUizYZzGUKpl/LkseWIgULGKPB2Q8R7x26HB4zDPxe
         h66bfDBpVUzksFt06TAeL6lTw8S303RdeJdr5laeDiaR6SKfi4a87qLlxGY5iCw6M4sE
         YXPFZPC2TYWzoXXq2KetEvIt4MWSbc0kMqBvRde1NJDD/4Tl49XbrEAMDEz1frBeFsxq
         MIWA==
X-Gm-Message-State: AOAM532ZusdHcSyMBTYp0+XvGCqlO6MtjWCuaZ4X9NFbMYz1B5WTB0TE
        SHzZUXAQxJgX6XqHwaftequBeoUBMxcBiw==
X-Google-Smtp-Source: ABdhPJzZSlNsPhf1QsxsV4wRl2bwvxT828TD7A/odWmLldAyLK5QQITmbH4bGXuTrU4/GBIwvI6H4g==
X-Received: by 2002:a17:903:3005:b029:12b:54cf:c513 with SMTP id o5-20020a1709033005b029012b54cfc513mr27997855pla.21.1626882959326;
        Wed, 21 Jul 2021 08:55:59 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id x3sm329098pjq.6.2021.07.21.08.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 08:55:58 -0700 (PDT)
Subject: Re: [PATCH net-next] ionic: cleanly release devlink instance
To:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, drivers@pensando.io,
        linux-kernel@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        netdev@vger.kernel.org
References: <956213a5c415c30e7e9f9c20bb50bc5b50ba4d18.1626870761.git.leonro@nvidia.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <04d36c6b-1e8d-117f-3079-8314f6b8051d@pensando.io>
Date:   Wed, 21 Jul 2021 08:55:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <956213a5c415c30e7e9f9c20bb50bc5b50ba4d18.1626870761.git.leonro@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/21 5:39 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>
> The failure to register devlink will leave the system with dangled
> devlink resource, which is not cleaned if devlink_port_register() fails.
>
> In order to remove access to ".registered" field of struct devlink_port,
> require both devlink_register and devlink_port_register to success and
> check it through device pointer.
>
> Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sure, thanks.

Acked-by: Shannon Nelson <snelson@pensando.io>

> ---
> Future series will remove .registered field from the devlink.
> ---
>   .../net/ethernet/pensando/ionic/ionic_devlink.c    | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> index b41301a5b0df..cd520e4c5522 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> @@ -91,20 +91,20 @@ int ionic_devlink_register(struct ionic *ionic)
>   	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
>   	devlink_port_attrs_set(&ionic->dl_port, &attrs);
>   	err = devlink_port_register(dl, &ionic->dl_port, 0);
> -	if (err)
> +	if (err) {
>   		dev_err(ionic->dev, "devlink_port_register failed: %d\n", err);
> -	else
> -		devlink_port_type_eth_set(&ionic->dl_port,
> -					  ionic->lif->netdev);
> +		devlink_unregister(dl);
> +		return err;
> +	}
>   
> -	return err;
> +	devlink_port_type_eth_set(&ionic->dl_port, ionic->lif->netdev);
> +	return 0;
>   }
>   
>   void ionic_devlink_unregister(struct ionic *ionic)
>   {
>   	struct devlink *dl = priv_to_devlink(ionic);
>   
> -	if (ionic->dl_port.registered)
> -		devlink_port_unregister(&ionic->dl_port);
> +	devlink_port_unregister(&ionic->dl_port);
>   	devlink_unregister(dl);
>   }

