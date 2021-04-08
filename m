Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BA7357C11
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 07:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbhDHF7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 01:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhDHF7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 01:59:49 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A15C061760
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 22:59:38 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id u5-20020a7bcb050000b029010e9316b9d5so568937wmj.2
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 22:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QiUkydbdapYlyR6rLYqqWCXM8CK6Lg8rD/foCYmu5Ls=;
        b=NptcrxqYe5ibklJmBWEFRqKIMiCQcNbTFhu0TWAingp8zSlEGKBswSRjMk6VCCwrVh
         hq65p3b1ZrTuHnhLGPspEZkxsebJJnoascS5JAAVl+K1xWSqj+oJONOlkSvh4C8ZnwpY
         RLi6apo8hAth2zofp1ebKBxxAQAmEyTiClCR7Xb0llH4cFuoFuOAKQIYogjQsFk4cWDU
         Qre+m+4LuZmnanAtZErpjQilD8W1W+d9Ls24aU7TQA6032XZxGtolirsLFMJpWy4wxgN
         /gUyxHj7EZDyskpMIX95/2/gibOaL6G0WiS6Tx//hJqzVncQ9T17NW7+SdWaoyWd9D3p
         lvqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QiUkydbdapYlyR6rLYqqWCXM8CK6Lg8rD/foCYmu5Ls=;
        b=MRZZOtNIbzugGyGDqBrGLJnwQ+C+zsYUuQuWItGFU07WxI8oZXvQ8ksAqzUP4ewnVO
         SS7lRPI2ZyZaGyd6NolrRKh8kL/BlK+QDapSvxaWUQMbeIeCQJ95M6RkYmjFZkvr+jDG
         /+A51OTzX9BlyeCMaubofqCYs7P4h2nZPq10Mu2pGqMNlUZHVZWZNeaxnSw/WWe1WVcP
         JtpZLouZzofnqbufZRc/5WEQN0qEGf2sygqKtIhwtdDc4iO91SqpQ00CdVPzjANStGab
         Kjv7K8UyoGWKKiLMUcadIAChdak1sTvZ6irzI1Xih59Wrq586FpSFmmOFKjTg4tEymhu
         yiAA==
X-Gm-Message-State: AOAM533Sszh8GqApnLSu+KQJG01OZqEJvBXQpiZYzP1K+y8OfnTRuQrg
        5minwiUbxaTJjlU9d3dIMUogVazE2lM=
X-Google-Smtp-Source: ABdhPJxA5knIZ9fXoyQgBgYKLqCJwVefg0LkMNPqatA331WzVb3T7GnzBIsblxPSneXTZiOpBtXrjw==
X-Received: by 2002:a05:600c:3514:: with SMTP id h20mr6601888wmq.45.1617861576816;
        Wed, 07 Apr 2021 22:59:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:6dfe:cdb3:c4f9:2744? (p200300ea8f3846006dfecdb3c4f92744.dip0.t-ipconnect.de. [2003:ea:8f38:4600:6dfe:cdb3:c4f9:2744])
        by smtp.googlemail.com with ESMTPSA id w7sm9995563wro.43.2021.04.07.22.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 22:59:36 -0700 (PDT)
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <9e695411-ab1d-34fe-8b90-3e8192ab84f6@gmail.com>
 <a34e3ad6-21a8-5151-7beb-5080f4ac102a@gmail.com>
 <DB8PR04MB679540FF95A7B05931830A30E6749@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 2/3] net: fec: use mac-managed PHY PM
Message-ID: <d47a3d9f-a9cf-4765-9ee8-19ebb9155150@gmail.com>
Date:   Thu, 8 Apr 2021 07:59:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB679540FF95A7B05931830A30E6749@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.04.2021 07:45, Joakim Zhang wrote:
> 
>> -----Original Message-----
>> From: Heiner Kallweit <hkallweit1@gmail.com>
>> Sent: 2021年4月7日 23:53
>> To: Andrew Lunn <andrew@lunn.ch>; Russell King - ARM Linux
>> <linux@armlinux.org.uk>; Jakub Kicinski <kuba@kernel.org>; David Miller
>> <davem@davemloft.net>; Fugang Duan <fugang.duan@nxp.com>
>> Cc: netdev@vger.kernel.org; Joakim Zhang <qiangqing.zhang@nxp.com>
>> Subject: [PATCH net-next 2/3] net: fec: use mac-managed PHY PM
>>
>> Use the new mac_managed_pm flag to work around an issue with KSZ8081
>> PHY that becomes unstable when a soft reset is triggered during aneg.
>>
>> Reported-by: Joakim Zhang <qiangqing.zhang@nxp.com>
>> Tested-by: Joakim Zhang <qiangqing.zhang@nxp.com>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/ethernet/freescale/fec_main.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/freescale/fec_main.c
>> b/drivers/net/ethernet/freescale/fec_main.c
>> index 3db882322..70aea9c27 100644
>> --- a/drivers/net/ethernet/freescale/fec_main.c
>> +++ b/drivers/net/ethernet/freescale/fec_main.c
>> @@ -2048,6 +2048,8 @@ static int fec_enet_mii_probe(struct net_device
>> *ndev)
>>  	fep->link = 0;
>>  	fep->full_duplex = 0;
>>
>> +	phy_dev->mac_managed_pm = 1;
>> +
>>  	phy_attached_info(phy_dev);
>>
>>  	return 0;
>> @@ -3864,6 +3866,7 @@ static int __maybe_unused fec_resume(struct
>> device *dev)
>>  		netif_device_attach(ndev);
>>  		netif_tx_unlock_bh(ndev);
>>  		napi_enable(&fep->napi);
>> +		phy_init_hw(ndev->phydev);
> 
> 
> For now, I think we doesn't need to re-initialize PHY after MAC resume back, it also can be done by PHY driver if it needed.
> 
The PHY PM resume callback (that used to call phy_init_hw) is a no-op now.
So we have to call it from the MAC resume callback. Power to the PHY may be
off during system suspend, therefore it may be reset to power-on defaults.
That's why phy_init_hw() should be called, that includes calling the
PHY drivers config_init callback.

> Best Regards,
> Joakim Zhang
>>  		phy_start(ndev->phydev);
>>  	}
>>  	rtnl_unlock();
>> --
>> 2.31.1
>>
> 

