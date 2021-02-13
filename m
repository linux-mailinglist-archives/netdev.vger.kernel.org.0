Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54BF31A9C6
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 04:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhBMDoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 22:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhBMDoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 22:44:08 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD726C061574;
        Fri, 12 Feb 2021 19:43:27 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id my11so1055234pjb.1;
        Fri, 12 Feb 2021 19:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fSZEyxImPeH+wflBfuB4czPSI1Ga57gwNa4vCFPWIKA=;
        b=SubLwkdkZRhqzu5ffDZZLYUX76T9KsrxYD4cN97tabTrTmBoa9nIX3AzbzswnAfS1t
         07zHKnZ/IAlN+1ILCYFsBJOTVSvBE8qZkiQGiZbnJ6ZVUUEi6q+RUUd3v+jx9HqLaaie
         OEvajXyrf5dMXV88395/i2j0tjD4IErf8Dx5pQbd3UhZCNLNdp0cpdN1dyxjXAMZ9POb
         qbEZn9A4k+9DsNorrEVhnLtCBb+kMg1VF5fejBVb1aPxEF2f+bl9PgEPK5ZijO/aKrFR
         fvbhxnzlB8C8vM6fGjusfqNBD33rj9fjw+ZrLLfRgA61BXwdRz+ONRDhPdym49X92gdW
         wnOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fSZEyxImPeH+wflBfuB4czPSI1Ga57gwNa4vCFPWIKA=;
        b=c5i567qzrf3a9F4odYFcF9Hufs2nslZnkaWFKa9mJHOkgrbCjEHD9Je2ARjmgA1VNY
         LxHiZlnZxD1mcKBdAcY7dEPv3dYDiPIAl3zbWrFHcmsLlSRo4kDfkQFGcCA7dhjHVN02
         sUkbs/KMuMJGiKL+IG6DvhGnXdUC0dA9yc8+6HJJINKj+HKarIxCkey7gf2MLCjhOTKi
         OOzWI4tAyvBpEOnfg/ow4c6fqkbYRcWNxtVSp4c68UpTYeM8scJ1hgd2XGvLr8Eud21k
         j8TgwmVHA7mPKmgrw+H5+UhfdG8Sw7MbBYWIBMnGl/AQ1h46LdM6jvCV3W1UaWSPovgC
         f1Qw==
X-Gm-Message-State: AOAM532IbZKY58Cf4LpeLBwwYlUByE+eaTn+RLfeYzLPOyvZGXrGiUHx
        A8GW5tIgEFbDSQwtPYABVFU=
X-Google-Smtp-Source: ABdhPJwvUgA2NEEpkOrdDQduJA4L3vIFl1E3TubcGlD8I37N6gT9UE6Hd+q3nxS5kfK93QhUQVU2iA==
X-Received: by 2002:a17:902:b610:b029:e3:2b1e:34ff with SMTP id b16-20020a170902b610b02900e32b1e34ffmr3248601pls.69.1613187807002;
        Fri, 12 Feb 2021 19:43:27 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d1sm10704664pgl.17.2021.02.12.19.43.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 19:43:26 -0800 (PST)
Subject: Re: [PATCH net-next 2/3] net: phy: broadcom: Fix RXC/TXC auto
 disabling
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
References: <20210212205721.2406849-1-f.fainelli@gmail.com>
 <20210212205721.2406849-3-f.fainelli@gmail.com>
 <20210213011147.6jedwieopekiwxqd@skbuf>
 <01e62046-7674-bb1d-115f-9044726c0ce7@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6482a9a1-964f-2f7b-8688-62f585d13206@gmail.com>
Date:   Fri, 12 Feb 2021 19:43:24 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <01e62046-7674-bb1d-115f-9044726c0ce7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/2021 5:14 PM, Florian Fainelli wrote:
> 
> 
> On 2/12/2021 5:11 PM, Vladimir Oltean wrote:
>> On Fri, Feb 12, 2021 at 12:57:20PM -0800, Florian Fainelli wrote:
>>> When support for optionally disabling the TXC was introduced, bit 2 was
>>> used to do that operation but the datasheet for 50610M from 2009 does
>>> not show bit 2 as being defined. Bit 8 is the one that allows automatic
>>> disabling of the RXC/TXC auto disabling during auto power down.
>>>
>>> Fixes: 52fae0837153 ("tg3 / broadcom: Optionally disable TXC if no link")
>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>> ---
>>>  include/linux/brcmphy.h | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
>>> index da7bf9dfef5b..3dd8203cf780 100644
>>> --- a/include/linux/brcmphy.h
>>> +++ b/include/linux/brcmphy.h
>>> @@ -193,7 +193,7 @@
>>>  #define BCM54XX_SHD_SCR3		0x05
>>>  #define  BCM54XX_SHD_SCR3_DEF_CLK125	0x0001
>>>  #define  BCM54XX_SHD_SCR3_DLLAPD_DIS	0x0002
>>> -#define  BCM54XX_SHD_SCR3_TRDDAPD	0x0004
>>> +#define  BCM54XX_SHD_SCR3_TRDDAPD	0x0100
>>>  
>>>  /* 01010: Auto Power-Down */
>>>  #define BCM54XX_SHD_APD			0x0a
>>> -- 
>>> 2.25.1
>>>
>>
>> We may have a problem here, with the layout of the Spare Control 3
>> register not being as universal as we think.
>>
>> Your finding may have been the same as Kevin Lo's from commit
>> b0ed0bbfb304 ("net: phy: broadcom: add support for BCM54811 PHY"),
>> therefore your change is making BCM54XX_SHD_SCR3_TRDDAPD ==
>> BCM54810_SHD_SCR3_TRDDAPD, so currently this if condition is redundant
>> and probably something else is wrong too:
>>
>> 	if (phydev->dev_flags & PHY_BRCM_DIS_TXCRXC_NOENRGY) {
>> 		if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810 ||
>> 		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54811)
>> 			val |= BCM54810_SHD_SCR3_TRDDAPD;
>> 		else
>> 			val |= BCM54XX_SHD_SCR3_TRDDAPD;
>> 	}
>>
>> I'm not sure what "TRDD" stands for, but my copy of the BCM5464R
>> datasheet shows both bits 2 as well as 8 as being reserved. I have
>> "CLK125 Output" in bit 0, "DLL Auto Power-Down" in bit 1, "SD/Energy
>> Detect Change" in bit 5, "TXC Disable" in bit 6, and that's about it.
> 
> Let me go back to the datasheet of all of the PHYs supported by
> bcm54xx_adjust_rxrefclk() and make sure we set the right bit.

I really don't know what the situation is with the 50610 and 50610M and
the datasheet appears to reflect that the latest PHYs should be revision
3 or newer (which we explicitly check for earlier), and that bit 8 is
supposed to control the disabling of RXC/TXC during auto-power down. I
can only trust that Matt checked with the design team back then and that
the datasheet must be wrong (would not be an isolated incident), let's
try not to fix something that we do not know for sure is broken.

I will respin without this patch and with another clean up added.
-- 
Florian
