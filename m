Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1B93BA8B8
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 14:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhGCMhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 08:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhGCMhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Jul 2021 08:37:05 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A822C061762;
        Sat,  3 Jul 2021 05:34:31 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id b2so21005888ejg.8;
        Sat, 03 Jul 2021 05:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o/dhGEJDXnhd4O/PyBgBhUjqZwqKj7pT+ZJXSGfTD3o=;
        b=EE2+9xsv09MFJtNSIqyMrI+bLtLWipPrpuP/sF6wPmW3tyeE9CfPzHMF9SHvNOTZC0
         OtgLLT/FWBrqefGc+qROJZplPmY+SSr9fRdMvtKDgYDA1KsBQARLpG/JTgc9Ey3dAL2G
         bRE3LI6yfpgri9CPdasuudQ8BEoFbAPx5QbmCy74Xe1rh2kH6UFLbx8DXYwpMaBmMbUs
         NRgtU+lVwS4P1Tu5hfG1qSC6SLMmrhiGKOcLNVq/hcDXzFGUqVpdgo4c4oYwVKL+wWIU
         VYW5oK8bUmCSW1hSiwV/cuc6DbvDy+pK+T+CDbnnlGd5ZLqY2qI9xJAqC37XsqHMvENW
         0Y9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o/dhGEJDXnhd4O/PyBgBhUjqZwqKj7pT+ZJXSGfTD3o=;
        b=ZMJ8rAwE96HWsPJHvXh6pEYVcROBYRWLUvULSg1warx4KWHusQnaVijMHqMUEAVdVu
         b41DmE7a4rOcmzRUEbRB9fLbehY+8ZVPcUn1s1Vk+T3v6v/SCpvv00n6gTW3xmhk8wRh
         yk/yooBCFzFtoy12nZVgv138EBLY5xxsxbMqile6jErbqsuKHt9qjUnFzcMd0iWOj8/d
         29WUyp5Xm69iItNXMJlqFeHG/BY5kvBqjcsYFrJEnLbwB3HVg6MyzQ2lqzN1Te0T2eYr
         s30eg/fqHkW/qHVtLsoEUjI5/pEfw6qE8hxfjc6ckdkpZSALHz/lfpQ5hzuZk3krzE/4
         RhgQ==
X-Gm-Message-State: AOAM532B6u5LtWbbacClOzSVsCg9L8jrHbJbUHT7W1GvBVfwrDdnyPDO
        RFe82Gh/zuHFUWP4cq7ONuiVn7PykFlbjQ==
X-Google-Smtp-Source: ABdhPJzt1eSIv6W8ZH01/Gcl7czAyujXvk2NdaH/C4/l85s1/ldtqzbEoyZIaZISzQN6FleV0m71XA==
X-Received: by 2002:a17:906:9b86:: with SMTP id dd6mr103956ejc.178.1625315669616;
        Sat, 03 Jul 2021 05:34:29 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f3f:3d00:c18f:5fab:3a99:54e9? (p200300ea8f3f3d00c18f5fab3a9954e9.dip0.t-ipconnect.de. [2003:ea:8f3f:3d00:c18f:5fab:3a99:54e9])
        by smtp.googlemail.com with ESMTPSA id i6sm2132310ejr.68.2021.07.03.05.34.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Jul 2021 05:34:28 -0700 (PDT)
Subject: Re: [PATCH net-next v1 1/1] net: usb: asix: ax88772: suspend PHY on
 driver probe
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
References: <20210629044305.32322-1-o.rempel@pengutronix.de>
 <931f10ca-2d81-8264-950c-8d29c18a7b35@gmail.com>
 <20210702035340.sdoc5dqpuo4cgsqe@pengutronix.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <53535272-c28f-092a-f068-87253da4013c@gmail.com>
Date:   Sat, 3 Jul 2021 14:34:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210702035340.sdoc5dqpuo4cgsqe@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.07.2021 05:53, Oleksij Rempel wrote:
> On Thu, Jul 01, 2021 at 12:01:04PM -0700, Florian Fainelli wrote:
>> On 6/28/21 9:43 PM, Oleksij Rempel wrote:
>>> After probe/bind sequence is the PHY in active state, even if interface
>>> is stopped. As result, on some systems like Samsung Exynos5250 SoC based Arndale
>>> board, the ASIX PHY will be able to negotiate the link but fail to
>>> transmit the data.
>>>
>>> To handle it, suspend the PHY on probe.
>>
>> Very unusual, could not the PHY be attached/connected to a ndo_open()
>> time like what most drivers do?
> 
> May be this can be done to.
> But, should not the PHY be in the same state after phy_connect() and after
> phy_stop()?
> 
> Currently, phy_connect() and phy_start() resume the PHY. The phy_stop()
> is suspending it. Since the driver calls phy_connect(), phy_start() and
> phy_stop(), the resume/suspend state is out of balance.

At least currently there is no requirement that phy_resume()/phy_suspend()
calls have to be balanced. Drivers must be able to deal with this.
However phy_suspend() checks the state of phydev->suspended and skips the
suspend callback if set.

> In case some one will add for example something like regulator_enable/disable
> callbacks in to phydev->syspend/resume callbacks, this would never work.
> 
> So, the question is, should phy_connect() put the PHY back in to suspend
> mode? Or should the MAC driver take care of this?
> 
>>>
>>> Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>>> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>> ---
>>>  drivers/net/usb/asix_devices.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
>>> index aec97b021a73..2c115216420a 100644
>>> --- a/drivers/net/usb/asix_devices.c
>>> +++ b/drivers/net/usb/asix_devices.c
>>> @@ -701,6 +701,7 @@ static int ax88772_init_phy(struct usbnet *dev)
>>>  		return ret;
>>>  	}
>>>  
>>> +	phy_suspend(priv->phydev);
>>>  	priv->phydev->mac_managed_pm = 1;
>>>  
>>>  	phy_attached_info(priv->phydev);
>>>
>>
>>
>> -- 
>> Florian
>>
> 
> Regards,
> Oleksij
> 

