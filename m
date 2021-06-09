Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D423A1095
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238332AbhFIJxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 05:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238326AbhFIJxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 05:53:42 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597A1C061574;
        Wed,  9 Jun 2021 02:51:47 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id z22so14920310ljh.8;
        Wed, 09 Jun 2021 02:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mbbl8pt+ODA34KdyS+WloGNbfQNhCiN7M0uQW+cvUEM=;
        b=bOujbOaFFtDatG1AG5ioV3VvdVj+AQRvnsBvIxVgo5hrZDXaBAwYfoDhzfHI3xBeNU
         prB+b2ediJvU3L4Hqfpc0464PgxknQ4rKsjgkqEGXPiTpywv23UB57msoW95M9dw29gA
         AWRWCSrZm6t1one+IiB5KWETM6pbo2HEpwk/OSo0uRt+RDmVwIMZATioNyhHxUmiXwXz
         xnktxtFFFUcEz1EtfOMRfAz6KVqdhdJprfhFCkBorJbJCj9KsrUqw4e9mjdwhAhQBNZo
         ogVyqF6A53f8+/9qK0AfmdpcdrB/09GIlbZ7HaJATAgTI4DvFlfjmddm+VoXD2v1ZY7l
         l/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Mbbl8pt+ODA34KdyS+WloGNbfQNhCiN7M0uQW+cvUEM=;
        b=cvTTUTkW/Li45DekJUbLqokzR7gLeEr8RomZoweR6OqCMXaMH6CEhCZKtfhc4C5iMs
         ZWXfskIif5KXCFoS5ZSNrsUOUkEq/eoqiaa1rhMWjxZBL0gtHF9q8K654+2fCKgNPCLU
         T7pfkVryg0ucJTS72xn/O/xlv/Aom60Z2YQPbHxaM75bH/heGmo+MyzxSwvFSCp0A/L6
         kw/IGMyYbIDNqffgM7/e5aJD1q78NkFTrB11CxnJ3fSQRzcqAqtls1vnQoJ+jfnY4SY4
         PmxIFEDf2b2t6XfBEBXwZsC3RnGpFZp78EsjQjzI+IAs95GUKAuQiCAK4uhpCqV7YPan
         Kp8A==
X-Gm-Message-State: AOAM533NViAshVnSh7iF3Ll7yFal2VtmWBK7taDIYENtlCi813LQ2Jx6
        1hCS/EibnSAGAac81IOIDbjI2kt4auo=
X-Google-Smtp-Source: ABdhPJz5V2ESY/LehtRED5paOEjX4yIV+dIM6NbBr+JPM8jskGSdB4Wt8STMRXpCm9cNokIBwO9lIg==
X-Received: by 2002:a2e:a593:: with SMTP id m19mr22031705ljp.103.1623232305523;
        Wed, 09 Jun 2021 02:51:45 -0700 (PDT)
Received: from [192.168.1.100] ([178.176.75.133])
        by smtp.gmail.com with ESMTPSA id q3sm264804ljp.44.2021.06.09.02.51.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 02:51:45 -0700 (PDT)
Subject: Re: [PATCH][next] net: usb: asix: ax88772: Fix less than zero
 comparison of a u16
To:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210608145823.159467-1-colin.king@canonical.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <5ac017f5-b8cc-6177-888a-318681b36da3@gmail.com>
Date:   Wed, 9 Jun 2021 12:51:33 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210608145823.159467-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.06.2021 17:58, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The comparison of the u16 priv->phy_addr < 0 is always false because
> phy_addr is unsigned. Fix this by assigning the return from the call
> to function asix_read_phy_addr to int ret and using this for the
> less than zero error check comparison.
> 
> Addresses-Coverity: ("Unsigned compared against 0")
> Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/net/usb/asix_devices.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index 57dafb3262d9..211c5a87eb15 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -704,9 +704,10 @@ static int ax88772_init_phy(struct usbnet *dev)
>   	struct asix_common_private *priv = dev->driver_priv;
>   	int ret;
>   
> -	priv->phy_addr = asix_read_phy_addr(dev, true);
> -	if (priv->phy_addr < 0)
> +	ret = asix_read_phy_addr(dev, true);
> +	if (ret < 0)
>   		return priv->phy_addr;

    It's not yet assigned at this point, should be:

		return ret;

> +	priv->phy_addr = ret;

    Assigned only here. :-)

>   	snprintf(priv->phy_name, sizeof(priv->phy_name), PHY_ID_FMT,
>   		 priv->mdio->id, priv->phy_addr);

MBR, Sergei
