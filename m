Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C61131B48F
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 05:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhBOEaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 23:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbhBOE37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 23:29:59 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F23C061574;
        Sun, 14 Feb 2021 20:29:19 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id ba1so3037466plb.1;
        Sun, 14 Feb 2021 20:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0WZYfOFnzaHo5jvAPYsiWHst02OWh8D/3sn5St1K8pw=;
        b=RJ4nT9jRu1kSdIo8MWTunxXamKIlkLHv2YPXO7Tulh7TfZjsuxL9XGy/881TXUR1xQ
         SP40ZgmkUNeIz1uqOymIKyx2cPBd7wR42OpTCblebKsk7LDc1PGLBOqWiQChU7k8Bqkm
         yZhs2FnXdtexddeXZFHS1FFAzIJXeSiLNQydpI10J9ptraPcgqGIQVWInREryTKP7JxS
         puy1mCGXdMZvmF84XYxwdo2hp/GaQpca08rEPEkC126K7ny9J/LyvVJClxpVKyZFOT/E
         BOgI4LIuisnsSBxADwNMQ5xkINkilpGYUKdYcEhXRwXgL/5Aav8IFau8Xz+fqHIv/Cmr
         0ugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0WZYfOFnzaHo5jvAPYsiWHst02OWh8D/3sn5St1K8pw=;
        b=EVh6yG4ES5FUDKRtdV8KGqcrgNQKOv54ivBIdygAmzSb6XWtBYDb7EzB6cZsSESBuC
         JFSKmR9AgxbmO5t7ocmRvdV0goAsre9efgvXgL9GKiW8BYOauw0tz/5Z0EmipYBrAHwh
         en5zPjEdeHVSDlHgOEvjAK+3XFQmek6SlCqdGdEnnyvcYUf++/zs0itBdqfh+d95NBr4
         /BZv0lHU2KDox+VE60qKx/Mh6q3KhvyOjWVy0EmV6+G9NCuImNR1aiDLUEIkm74QE/fV
         YpKqLCcxIfdjvr1/t4T/yC1ER2Ti8oU1TBcv0l3gvQgicK7d3nzXGGfXDfjfEGZLfl+n
         johA==
X-Gm-Message-State: AOAM530S+E/ryYodX24oJHBEz/O4FJzJm9cBOgYXMLmpj73lyLpMxWXm
        PqpoxzIJOgIZHEBocN84fyU=
X-Google-Smtp-Source: ABdhPJxQHg7sjo8G6enu1sXHYzX1ewZwYExS3y6z4GYh7wCeDEJGUtEKDBCn2SjdvyWLewusnTPhiA==
X-Received: by 2002:a17:902:6b43:b029:df:fb48:aece with SMTP id g3-20020a1709026b43b02900dffb48aecemr13595611plt.59.1613363359342;
        Sun, 14 Feb 2021 20:29:19 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 68sm17290678pfg.90.2021.02.14.20.29.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Feb 2021 20:29:18 -0800 (PST)
Subject: Re: [PATCH net-next v2 3/3] net: phy: broadcom: Allow BCM54210E to
 configure APD
To:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        "open list:BROADCOM ETHERNET PHY DRIVERS" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>, michael@walle.cc
References: <20210213034632.2420998-1-f.fainelli@gmail.com>
 <20210213034632.2420998-4-f.fainelli@gmail.com>
 <20210213104245.uti4qb2u2r5nblef@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4e1c1a4c-d276-c850-8e97-16ef1f08dcff@gmail.com>
Date:   Sun, 14 Feb 2021 20:29:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213104245.uti4qb2u2r5nblef@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/2021 2:42 AM, Vladimir Oltean wrote:
> On Fri, Feb 12, 2021 at 07:46:32PM -0800, Florian Fainelli wrote:
>> BCM54210E/BCM50212E has been verified to work correctly with the
>> auto-power down configuration done by bcm54xx_adjust_rxrefclk(), add it
>> to the list of PHYs working.
>>
>> While we are at it, provide an appropriate name for the bit we are
>> changing which disables the RXC and TXC during auto-power down when
>> there is no energy on the cable.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> 
>>  drivers/net/phy/broadcom.c | 8 +++++---
>>  include/linux/brcmphy.h    | 2 +-
>>  2 files changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
>> index 3ce266ab521b..91fbd26c809e 100644
>> --- a/drivers/net/phy/broadcom.c
>> +++ b/drivers/net/phy/broadcom.c
>> @@ -193,6 +193,7 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
>>  	if (BRCM_PHY_MODEL(phydev) != PHY_ID_BCM57780 &&
>>  	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM50610 &&
>>  	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM50610M &&
>> +	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54210E &&
>>  	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54810 &&
>>  	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54811)
>>  		return;
>> @@ -227,9 +228,10 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
>>  		val |= BCM54XX_SHD_SCR3_DLLAPD_DIS;
>>  
>>  	if (phydev->dev_flags & PHY_BRCM_DIS_TXCRXC_NOENRGY) {
>> -		if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810 ||
>> -		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54811)
>> -			val |= BCM54810_SHD_SCR3_TRDDAPD;
>> +		if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54210E ||
>> +		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810 ||
>> +		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54210E)
>> +			val |= BCM54XX_SHD_SCR3_RXCTXC_DIS;
>>  		else
>>  			val |= BCM54XX_SHD_SCR3_TRDDAPD;
>>  	}
>> diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
>> index 844dcfe789a2..16597d3fa011 100644
>> --- a/include/linux/brcmphy.h
>> +++ b/include/linux/brcmphy.h
>> @@ -193,6 +193,7 @@
>>  #define  BCM54XX_SHD_SCR3_DEF_CLK125	0x0001
>>  #define  BCM54XX_SHD_SCR3_DLLAPD_DIS	0x0002
>>  #define  BCM54XX_SHD_SCR3_TRDDAPD	0x0004
>> +#define  BCM54XX_SHD_SCR3_RXCTXC_DIS	0x0100
> 
> Curiously enough, my BCM5464R datasheet does say:
> 
> The TXC and RXC outputs can be disabled during auto-power down by setting the “1000BASE-T/100BASE-TX/10BASE-T
> Spare Control 3 Register (Address 1Ch, Shadow Value 00101),” bit 8 =1.
> 
> but when I go to the definition of the register, bit 8 is hidden. Odd.
> 
> How can I ensure that the auto power down feature is doing something?

I am trying to confirm what the expected power levels should be from the
54210E product engineer so I can give you an estimate of what you should
see with and without while measure the PHY's regulators.
-- 
Florian
