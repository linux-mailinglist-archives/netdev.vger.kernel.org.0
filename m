Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB1632B3F0
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1840319AbhCCEIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235186AbhCCDi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 22:38:27 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9BBC061788;
        Tue,  2 Mar 2021 19:37:37 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u11so13247440plg.13;
        Tue, 02 Mar 2021 19:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IZ6QulvHLpDIHpwCY/mKawCUaqyJPj9U6oC68gm8aqs=;
        b=h3g3WUe+VJ3Oie76As+Hjodljz+AGzC/iA7L81lOg1fy34YoBqb6OCc1fveuegT6nt
         GkZrPezmpHIeG1tEsNGaeM8coIvJw11+mVswhx0+ZJpaWbknrlL0i/UYZwqLK5XBBeOL
         NySGOJk0bGb+PnH2s4x6aPoc9KaFUVC1DJVG4wwFj8lxAF3ID4kLr/crsu6yV4ZthHiC
         68BqG0yEoQDn1AQuaPLfe0RF/ivEz6pLkt0Crg5CPHQtFCDZs99fBYun56+tkgzB+bUA
         WW65oqbtUFPaBDXNu+NnyMzCsLxNdN7trCydRz7GPdqREZdq3k/xw5sJj/jBWlDx3WbJ
         4C4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IZ6QulvHLpDIHpwCY/mKawCUaqyJPj9U6oC68gm8aqs=;
        b=T7uouSpHayXZU6LJG2ZBIWQZLZx9lRZV8TKMGReA+hQunBsVnne9RuuMI5RhVxvPaA
         p2GLf7pY00P34CFFqLp7j6z8cx5iEtxOqqLs3qaVVov1U2I5F1DHBNogE2OZTSuNmzB2
         msI5IaYf48IUmsojfdoDjHQ0kVY4Ax2bV2nEQ4rxfgSDwm2v5D8LDQPmC+tTBObmECg1
         BW5Bl5auOM8ZnrmwRC8xIdVxwXXvCrX54FGui0+jT79EeT8H7KicvjkdM9d2+JS6CrQN
         X7jKFBemP51OJhFLbvHoU7n/j5xZMHMUeTFAyBMA7cLPL9l290eIIBwy8RrB7YIOhQLm
         k+6g==
X-Gm-Message-State: AOAM531FKRemW9ZYVrCC+Rce+ti6PhLl5utYpah7LmoixruiIxnVRo7W
        69HsSFnOZT9Ew93aHuqtExI=
X-Google-Smtp-Source: ABdhPJwFgVu9WZeoI+Uj4ePU6HYag9A/qWFsvogAQRtxhqXBzQcwjmU/ApSrVoUxrduClQbAwrVrxQ==
X-Received: by 2002:a17:90a:e281:: with SMTP id d1mr7538973pjz.40.1614742657305;
        Tue, 02 Mar 2021 19:37:37 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q9sm21419417pgs.28.2021.03.02.19.37.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Mar 2021 19:37:36 -0800 (PST)
Subject: Re: [PATCH net-next v2 3/3] net: phy: broadcom: Allow BCM54210E to
 configure APD
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
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
 <4e1c1a4c-d276-c850-8e97-16ef1f08dcff@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <99e28317-e93d-88fa-f43f-d1d072b61292@gmail.com>
Date:   Tue, 2 Mar 2021 19:37:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <4e1c1a4c-d276-c850-8e97-16ef1f08dcff@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/2021 8:29 PM, Florian Fainelli wrote:
> 
> 
> On 2/13/2021 2:42 AM, Vladimir Oltean wrote:
>> On Fri, Feb 12, 2021 at 07:46:32PM -0800, Florian Fainelli wrote:
>>> BCM54210E/BCM50212E has been verified to work correctly with the
>>> auto-power down configuration done by bcm54xx_adjust_rxrefclk(), add it
>>> to the list of PHYs working.
>>>
>>> While we are at it, provide an appropriate name for the bit we are
>>> changing which disables the RXC and TXC during auto-power down when
>>> there is no energy on the cable.
>>>
>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>> ---
>>
>> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
>>
>>>  drivers/net/phy/broadcom.c | 8 +++++---
>>>  include/linux/brcmphy.h    | 2 +-
>>>  2 files changed, 6 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
>>> index 3ce266ab521b..91fbd26c809e 100644
>>> --- a/drivers/net/phy/broadcom.c
>>> +++ b/drivers/net/phy/broadcom.c
>>> @@ -193,6 +193,7 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
>>>  	if (BRCM_PHY_MODEL(phydev) != PHY_ID_BCM57780 &&
>>>  	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM50610 &&
>>>  	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM50610M &&
>>> +	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54210E &&
>>>  	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54810 &&
>>>  	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54811)
>>>  		return;
>>> @@ -227,9 +228,10 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
>>>  		val |= BCM54XX_SHD_SCR3_DLLAPD_DIS;
>>>  
>>>  	if (phydev->dev_flags & PHY_BRCM_DIS_TXCRXC_NOENRGY) {
>>> -		if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810 ||
>>> -		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54811)
>>> -			val |= BCM54810_SHD_SCR3_TRDDAPD;
>>> +		if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54210E ||
>>> +		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810 ||
>>> +		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54210E)
>>> +			val |= BCM54XX_SHD_SCR3_RXCTXC_DIS;
>>>  		else
>>>  			val |= BCM54XX_SHD_SCR3_TRDDAPD;
>>>  	}
>>> diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
>>> index 844dcfe789a2..16597d3fa011 100644
>>> --- a/include/linux/brcmphy.h
>>> +++ b/include/linux/brcmphy.h
>>> @@ -193,6 +193,7 @@
>>>  #define  BCM54XX_SHD_SCR3_DEF_CLK125	0x0001
>>>  #define  BCM54XX_SHD_SCR3_DLLAPD_DIS	0x0002
>>>  #define  BCM54XX_SHD_SCR3_TRDDAPD	0x0004
>>> +#define  BCM54XX_SHD_SCR3_RXCTXC_DIS	0x0100
>>
>> Curiously enough, my BCM5464R datasheet does say:
>>
>> The TXC and RXC outputs can be disabled during auto-power down by setting the “1000BASE-T/100BASE-TX/10BASE-T
>> Spare Control 3 Register (Address 1Ch, Shadow Value 00101),” bit 8 =1.
>>
>> but when I go to the definition of the register, bit 8 is hidden. Odd.
>>
>> How can I ensure that the auto power down feature is doing something?
> 
> I am trying to confirm what the expected power levels should be from the
> 54210E product engineer so I can give you an estimate of what you should
> see with and without while measure the PHY's regulators.

Took a while but for the 54210E reference board here are the numbers,
your mileage will vary depending on the supplies, regulator efficiency
and PCB design around the PHY obviously:

BMCR.PDOWN:			86.12 mW
auto-power down:		77.84 mW
auto-power-down, DLL disabled:  30.83 mW
IDDQ-low power:			 9.85 mW (requires a RESETn toggle)
IDDQ with soft recovery:	10.75 mW

Interestingly, the 50212E that I am using requires writing the PDOWN bit
and only that bit (not a RMW) in order to get in a correct state, both
LEDs keep flashing when that happens, fixes coming.

When net-next opens back up I will submit patches to support IDDQ with
soft recovery since that is clearly much better than the standard power
down and it does not require a RESETn toggle.
-- 
Florian
