Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260C52DEA3A
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 21:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732281AbgLRUbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 15:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731893AbgLRUbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 15:31:10 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90DAC0617A7;
        Fri, 18 Dec 2020 12:30:29 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id be12so2008944plb.4;
        Fri, 18 Dec 2020 12:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CDALKKIXOkGYN3IZKp1cx2QzFoc+xiaO0Zwqnz5KkGU=;
        b=jra/zTEaFAOMTDD2cuTwu3Vrt7ZzfnEiGOkbkbE89HGO30TREdYKkgEBP2iAQViKTz
         R7Dg/71C04FE3WDB7Bwpdm56oASGEWU3P7fwmys+VoVdtTTBpRW1rMGtIfyV/hdMt+aX
         rXN6gq2UIgmaLAoIqdJiU0JH2b7wh1nTEKFoA1FS2UAkbg5SOWpEEcA6SGSZQ1qSUpGh
         s17rbANradmXEmldhAZlpoQy9uMlHm489gCAaN+9bFMtERs2PcuBrlLm1AFkDnCZiVvo
         93OAgEVqXVJriUXW07+ve0BpXppQIZxLkLy9Lx1FqLe6eYV74wQyEROs5ea5zeMkROIv
         J/zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=CDALKKIXOkGYN3IZKp1cx2QzFoc+xiaO0Zwqnz5KkGU=;
        b=I81NdQJjFKRA7dweU6iEeqIe61cotbu2ycJQC0SQuS7Fi7M0VP4U2wSTsEeB7oVCWa
         /84xzgVjc9cx632QeCN262CrzW9rGj8zcGlO2IJF2lAIoCljG8GCxH1Tzl14LyeqKdTx
         T0O5tC5Rg5VhgiqUNXW+s38l6aN7NIay/WFaBy6BsXTLFx9nhyTd6hvQwWC336aNfelz
         D6r12AZQ5Q/YcdAQRRyB/tTQCrCZhRGQX3cuJTfa0bxiM/O0EhzS0NG9K/X4UelweWC0
         NaQIITseBE7GXg5meyGtRmt4lVlTxHgnmBAEY2Gnijl0qsZ2MURJkfCrGJmR+7F0+xMR
         1yCg==
X-Gm-Message-State: AOAM5339VnT/XBV8tFLzp6NvAJkPrhRxaX3sGCZpwgqdE84BJ7Jj4V6b
        EGFGCm6aqbjq8p1UcNBt6FuvD7T4FTk=
X-Google-Smtp-Source: ABdhPJy2wr2N9ZawYOkZjy6tlo7YMxsuweTwSze9FS28ok+395Ir9pQDtgoCmERrojxWeiJQ/UF0Yw==
X-Received: by 2002:a17:902:7205:b029:db:d2d5:fe79 with SMTP id ba5-20020a1709027205b02900dbd2d5fe79mr5991114plb.30.1608323429139;
        Fri, 18 Dec 2020 12:30:29 -0800 (PST)
Received: from [10.67.48.230] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j12sm8897353pjd.8.2020.12.18.12.30.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 12:30:28 -0800 (PST)
Subject: Re: [PATCH net] net: systemport: set dev->max_mtu to
 UMAC_MAX_MTU_SIZE
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "open list:BROADCOM SYSTEMPORT ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20201218173843.141046-1-f.fainelli@gmail.com>
 <20201218202441.ppcxswvlix3xszsn@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <c178b5db-3de4-5f02-eee3-c9e69393174a@gmail.com>
Date:   Fri, 18 Dec 2020 12:30:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201218202441.ppcxswvlix3xszsn@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/18/20 12:24 PM, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Fri, Dec 18, 2020 at 09:38:43AM -0800, Florian Fainelli wrote:
>> The driver is already allocating receive buffers of 2KiB and the
>> Ethernet MAC is configured to accept frames up to UMAC_MAX_MTU_SIZE.
>>
>> Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  drivers/net/ethernet/broadcom/bcmsysport.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
>> index 0fdd19d99d99..b1ae9eb8f247 100644
>> --- a/drivers/net/ethernet/broadcom/bcmsysport.c
>> +++ b/drivers/net/ethernet/broadcom/bcmsysport.c
>> @@ -2577,6 +2577,7 @@ static int bcm_sysport_probe(struct platform_device *pdev)
>>  			 NETIF_F_HW_VLAN_CTAG_TX;
>>  	dev->hw_features |= dev->features;
>>  	dev->vlan_features |= dev->features;
>> +	dev->max_mtu = UMAC_MAX_MTU_SIZE;
>>  
>>  	/* Request the WOL interrupt and advertise suspend if available */
>>  	priv->wol_irq_disabled = 1;
>> -- 
>> 2.25.1
>>
> 
> Do you want to treat the SYSTEMPORT Lite differently?
> 
> 	/* Set maximum frame length */
> 	if (!priv->is_lite)
> 		umac_writel(priv, UMAC_MAX_MTU_SIZE, UMAC_MAX_FRAME_LEN);
> 	else
> 		gib_set_pad_extension(priv);

SYSTEMPORT Lite does not actually validate the frame length, so setting
a maximum number to the buffer size we allocate could work, but I don't
see a reason to differentiate the two types of MACs here.
-- 
Florian
