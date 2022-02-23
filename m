Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68E04C0B56
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 06:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbiBWFB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 00:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbiBWFBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 00:01:24 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A5E60CC6;
        Tue, 22 Feb 2022 21:00:57 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 75so18882093pgb.4;
        Tue, 22 Feb 2022 21:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+/xBpqUkq7Y4V5ZVo51HPFC+VaILtpPPrho3sQ/Rr5U=;
        b=AQ2cTFfDP2y5u6aJ5Mqh4CGVId6ETkHF4zTVAQx+7GFy40wv3St3cLZWNURPUvjUky
         CBFQvJXoO2ZOVgkBqQT0Qq8qy18T3ROX4Lv6Eqm7P8YkQXWamXWsmRIvklv6IwVbHhcB
         S48E+8RGh1IPI0kQ6tqDiGld2AxZIPLeVKngadC6H4KKssNPO50lMsMosaKVloXk75HB
         iMEAGqG+LT57UyCcf6uozsn7auUdvfwV1JgSm3pGzCMHSgC6pkXpKZwmCqaQq7bgKsi6
         IemqcGqg1IhW4BNKTM0ZSBYqofvl+mkr/q6h1jdfAS9BRrAM+Mo+adk7l/eRn/400FWF
         3RjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+/xBpqUkq7Y4V5ZVo51HPFC+VaILtpPPrho3sQ/Rr5U=;
        b=f5FYwYeI7M8Z6dnlV95j8amqS9x9PkLvWE60ENSFRHeQCsMrNsH6c02Ntbi9Da/vN9
         iMIsZ93IUAOzGnYarg5btQpnyBkyn8bsmz0nSVid7QNhcHTbi3wgP2pZDgpQw3oVGEnL
         uXXSk0MMI+lf9bZRFqtrgg9rtjQB59VmxDVrtIcyexgwyXqPDH7S8gO7EQk3+e+AFlw/
         DbGUfU3aORVI39bqoiKQI9UknmOHzmzZZdu8lDK+LWxa1FCk/GtKELCUXJRZL+Pw9DW/
         uTARjRITCwalVvwjl6TZv8oFsHx5cvrMjNj2ZHg4Q9R+yJHwzdVyPw8Ul+ELek1Kt7WC
         +QLw==
X-Gm-Message-State: AOAM5325Jlx4/UmU2Esv64eGQwadz76+Ee9LK9XBTyz5HqZWSs/ZqdWB
        0v8wjJ3/OOdgU1PaL4nqPM3nEv8SdgU=
X-Google-Smtp-Source: ABdhPJweMG52IbjOfNhR38qdSBhdYUX7z4Nl6HrCWGL1SHIiw6TRiSyNTudqcnVR8CliWcF6uU+SAw==
X-Received: by 2002:a62:84d3:0:b0:4e1:b5c:1dd4 with SMTP id k202-20020a6284d3000000b004e10b5c1dd4mr27912170pfd.20.1645592457211;
        Tue, 22 Feb 2022 21:00:57 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id y14sm17849414pfm.219.2022.02.22.21.00.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 21:00:56 -0800 (PST)
Message-ID: <1675a52d-a270-d768-5ccc-35b1e82e56d2@gmail.com>
Date:   Tue, 22 Feb 2022 21:00:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 3/3] drivers/net/ftgmac100: fix DHCP potential failure
 with systemd
Content-Language: en-US
To:     Heyi Guo <guoheyi@linux.alibaba.com>, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dylan Hung <dylan_hung@aspeedtech.com>, netdev@vger.kernel.org
References: <20220223031436.124858-1-guoheyi@linux.alibaba.com>
 <20220223031436.124858-4-guoheyi@linux.alibaba.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220223031436.124858-4-guoheyi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/22/2022 7:14 PM, Heyi Guo wrote:
> DHCP failures were observed with systemd 247.6. The issue could be
> reproduced by rebooting Aspeed 2600 and then running ifconfig ethX
> down/up.
> 
> It is caused by below procedures in the driver:
> 
> 1. ftgmac100_open() enables net interface and call phy_start()
> 2. When PHY is link up, it calls netif_carrier_on() and then
> adjust_link callback
> 3. ftgmac100_adjust_link() will schedule the reset task
> 4. ftgmac100_reset_task() will then reset the MAC in another schedule
> 
> After step 2, systemd will be notified to send DHCP discover packet,
> while the packet might be corrupted by MAC reset operation in step 4.
> 
> Call ftgmac100_reset() directly instead of scheduling task to fix the
> issue.
> 
> Signed-off-by: Heyi Guo <guoheyi@linux.alibaba.com>
> ---
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Joel Stanley <joel@jms.id.au>
> Cc: Guangbin Huang <huangguangbin2@huawei.com>
> Cc: Hao Chen <chenhao288@hisilicon.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Dylan Hung <dylan_hung@aspeedtech.com>
> Cc: netdev@vger.kernel.org
> 
> 
> ---
>   drivers/net/ethernet/faraday/ftgmac100.c | 13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> index c1deb6e5d26c5..d5356db7539a4 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1402,8 +1402,17 @@ static void ftgmac100_adjust_link(struct net_device *netdev)
>   	/* Disable all interrupts */
>   	iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
>   
> -	/* Reset the adapter asynchronously */
> -	schedule_work(&priv->reset_task);
> +	/* Release phy lock to allow ftgmac100_reset to aquire it, keeping lock

typo: acquire

> +	 * order consistent to prevent dead lock.
> +	 */
> +	if (netdev->phydev)
> +		mutex_unlock(&netdev->phydev->lock);
> +
> +	ftgmac100_reset(priv);
> +
> +	if (netdev->phydev)
> +		mutex_lock(&netdev->phydev->lock);

Do you really need to perform a full MAC reset whenever the link goes up 
or down? Instead cannot you just extract the maccr configuration which 
adjusts the speed and be done with it?

What kind of Ethernet MAC design is this seriously.
-- 
Florian
