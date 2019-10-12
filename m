Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 882FFD5279
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 22:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbfJLUkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 16:40:53 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34144 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729432AbfJLUkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 16:40:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id y135so11729732wmc.1;
        Sat, 12 Oct 2019 13:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SeI64FDcmM9A/b7hGBBOzFKTBBoxulaIfQXoCsfbHog=;
        b=rbnf9JsnGsmY4rmXDlYLGOjCfO9Pe2IT4sreN6xUCIf2Ga4FfyrcizWZz2urLkgi43
         BvqJHKKNJTyBiJvYQx9+OXrZfyaTvYQzjHya3AfFd0+ngkQXUHLsbvkplIcCfPGQtUTY
         utLVH5FL0nVgbsoeqXhdq8Dd438dpLBkpBHXj+fO/fPvX60W7lTSDGWYYebMOvgblAry
         jLtQXWmNSpAGlIwZ94wd/Oq/486S9kANQh0gKQ6yi/yAqDfo4HfxEF0EKyRsgr1tJ76T
         qIv+F2ClteNzmoXehODS/1ylIli2puGztND0rwV8pQgGLvnKzd/MRN8raK0DUsRRzOi2
         zL3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SeI64FDcmM9A/b7hGBBOzFKTBBoxulaIfQXoCsfbHog=;
        b=NGBZGLnO3++jzsDvnFdlLanyHJBjqBImZEZlkwyZj2r0/PlMMbvVidmosPOjJIiyZm
         p6Ibs4B5VWaY6JWD2m+CkplG4/ScU8rSoInKIysK3NLa2MEHtLOeJYDJTNasSMUGd9PY
         Df7okhSWQAQT0Rm2PFlPkgd8C03tIAIhK0dX6Aj5wLcIC+MB+Jw4vNzszGBXRTZzLMgO
         I48eHK6VVWiFawcALEHFuqiZYdpC3wZMQRWekKKhXiawp/1BUTO54JH+vudze1sfpug2
         gqLly2jLxsFhUwZiZtoPmPwdX+VlH3ndHip8ka5P4J6M19oiNurV+Y6DT35BVdHSBlHJ
         zRug==
X-Gm-Message-State: APjAAAUPEpIFlAvNyouX7GtSAVyvYJL4gF2ecWVaYbpAfRLuJDe9PKVK
        YLFsd2/kSdBkaSVsyResryI=
X-Google-Smtp-Source: APXvYqzGDiZC3ofdi4ofrXIwbUYNEDgeOKzZsztMjqgsCKscjihm4cvwYfulPBDetc80hqsTRUfvtg==
X-Received: by 2002:a1c:f714:: with SMTP id v20mr8703107wmh.55.1570912849962;
        Sat, 12 Oct 2019 13:40:49 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:e99d:61ad:136:d387? (p200300EA8F266400E99D61AD0136D387.dip0.t-ipconnect.de. [2003:ea:8f26:6400:e99d:61ad:136:d387])
        by smtp.googlemail.com with ESMTPSA id l20sm6160048wrf.19.2019.10.12.13.40.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 12 Oct 2019 13:40:49 -0700 (PDT)
Subject: Re: [RFC PATCH net] net: phy: Fix "link partner" information
 disappear issue
To:     Yonglong Liu <liuyonglong@huawei.com>, davem@davemloft.net,
        andrew@lunn.ch, Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, shiju.jose@huawei.com
References: <1570699808-55313-1-git-send-email-liuyonglong@huawei.com>
 <ee969d27-debe-9bc4-92f2-fe5b04c36a39@gmail.com>
 <670bd6ac-54ee-ecfa-c108-fcf48a3a7dc8@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <091129e2-522c-6672-b6da-265bb0f8c656@gmail.com>
Date:   Sat, 12 Oct 2019 22:40:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <670bd6ac-54ee-ecfa-c108-fcf48a3a7dc8@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.10.2019 07:55, Yonglong Liu wrote:
> 
> 
> On 2019/10/11 3:17, Heiner Kallweit wrote:
>> On 10.10.2019 11:30, Yonglong Liu wrote:
>>> Some drivers just call phy_ethtool_ksettings_set() to set the
>>> links, for those phy drivers that use genphy_read_status(), if
>>> autoneg is on, and the link is up, than execute "ethtool -s
>>> ethx autoneg on" will cause "link partner" information disappear.
>>>
>>> The call trace is phy_ethtool_ksettings_set()->phy_start_aneg()
>>> ->linkmode_zero(phydev->lp_advertising)->genphy_read_status(),
>>> the link didn't change, so genphy_read_status() just return, and
>>> phydev->lp_advertising is zero now.
>>>
>> I think that clearing link partner advertising info in
>> phy_start_aneg() is questionable. If advertising doesn't change
>> then phy_config_aneg() basically is a no-op. Instead we may have
>> to clear the link partner advertising info in genphy_read_lpa()
>> if aneg is disabled or aneg isn't completed (basically the same
>> as in genphy_c45_read_lpa()). Something like:
>>
>> if (!phydev->autoneg_complete) { /* also covers case that aneg is disabled */
>> 	linkmode_zero(phydev->lp_advertising);
>> } else if (phydev->autoneg == AUTONEG_ENABLE) {
>> 	...
>> }
>>
> 
> If clear the link partner advertising info in genphy_read_lpa() and
> genphy_c45_read_lpa(), for the drivers that use genphy_read_status()
> is ok, but for those drivers that use there own read_status() may
> have problem, like aqr_read_status(), it will update lp_advertising
> first, and than call genphy_c45_read_status(), so will cause
> lp_advertising lost.
> 
Right, in genphy_read_lpa() we shouldn't clear all lpa bits but only
those ones the generic functions care about. Basically the same as
in the c45 version. Then a vendor-specific part isn't affected.

aqr_read_status() is a good example. It deals with 1Gbps mode that
isn't covered by the generic c45 functions. Therefore the 1Gbps-related
bits won't be overwritten by the generic functions.

> Another question, please see genphy_c45_read_status(), if clear the
> link partner advertising info in genphy_c45_read_lpa(), if autoneg is
> off, phydev->lp_advertising will not clear.
> 

If autoneg is off, lp_advertising should never be set, so there's
nothing to clear. However we may have to look at the case that user
switches to fixed speed mode via ethtool.

>>> This patch call genphy_read_lpa() before the link state judgement
>>> to fix this problem.
>>>
>>> Fixes: 88d6272acaaa ("net: phy: avoid unneeded MDIO reads in genphy_read_status")
>>> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
>>> ---
>>>  drivers/net/phy/phy_device.c | 8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>>> index 9d2bbb1..ef3073c 100644
>>> --- a/drivers/net/phy/phy_device.c
>>> +++ b/drivers/net/phy/phy_device.c
>>> @@ -1839,6 +1839,10 @@ int genphy_read_status(struct phy_device *phydev)
>>>  	if (err)
>>>  		return err;
>>>  
>>> +	err = genphy_read_lpa(phydev);
>>> +	if (err < 0)
>>> +		return err;
>>> +
>>>  	/* why bother the PHY if nothing can have changed */
>>>  	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
>>>  		return 0;
>>> @@ -1848,10 +1852,6 @@ int genphy_read_status(struct phy_device *phydev)
>>>  	phydev->pause = 0;
>>>  	phydev->asym_pause = 0;
>>>  
>>> -	err = genphy_read_lpa(phydev);
>>> -	if (err < 0)
>>> -		return err;
>>> -
>>>  	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
>>>  		phy_resolve_aneg_linkmode(phydev);
>>>  	} else if (phydev->autoneg == AUTONEG_DISABLE) {
>>>
>>
>>
>> .
>>
> 
> 

