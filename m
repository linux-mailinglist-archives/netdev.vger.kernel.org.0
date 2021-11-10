Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F1D44BCAB
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 09:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhKJIRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 03:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbhKJIRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 03:17:19 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2965C061764
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 00:14:31 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so1285896wme.4
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 00:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=Qj0Arh/3rol2yCrfYWsT0cTtPrXomQE1ROfBInPEOQk=;
        b=WFRRYMd3D9Qc0+VBOp/m1ZEHl1W600WiAqZh4EQsHXhDLq9xW7f3+zqSLLdO4ds1yy
         Zke3EhZPbOt9xm6Q8AmaQ3a1HGFhVw2UkO+xkpz6XTH5/heEnbFcEINUITfeXdIgTCOm
         LiuKa0jq4J1zyduzJMtofotWdBM4MgWebpHGCSSVBF43MOINW9RNO7J8HS/tUnH2DZBp
         TqBuqN4Xp0uELgRzJpya8nOrMAXo1lPp8MhrlIUUSJi6blldwqQhG1kq2dTkxeSWazeM
         Cpn4tU4GzE1bToe+u+2KZbMLpMZM56hwodU2q2amNAKsiaFpM/L7o5qE6R9aF/1WSrm+
         jIqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=Qj0Arh/3rol2yCrfYWsT0cTtPrXomQE1ROfBInPEOQk=;
        b=RNJFxScISJ3OeK2Up6CFXQGa112uudCB6e2qCPw9eR8YPkwMAm1GhfNa0apr7v/40+
         uZCa9Ulsyy8tLkkM/5oim2D9N+gprvfFp6sryMr/3hclV5uemfw0TfTdPqyuNe+YXf1E
         A+DKlrtYuCDE8v8s3jIpnqgtQ59UVdPGlUt1ynTLH+McDCyzGCAHuc066wziXrMve2JK
         E4Ptb4OfO/xrSdhIeQHW0vyMniiC4oWyGl1u1RCs3nqL5p8asi0C1i3P3wjqgQ7RZr7E
         MniJANJrlaPm0cwUKPCeWnt5CJuRys4C8iTGVSJ+MoV0RtwR/HMxLM9mZZNn04hvests
         ewTQ==
X-Gm-Message-State: AOAM532FaPjICsg7FSMfhyoMOKfgyKEBn0TDu9MG98QLch3QhP2VhH93
        gokFZ6JrZchASZFM3PZu3vQ=
X-Google-Smtp-Source: ABdhPJwD5HXl1CW3T97cflxPq/VKfcWyIbJLk3cEd7HSgKFRAStD2rGJpV7tsNi8IRy88xvTm/6o2g==
X-Received: by 2002:a7b:c08a:: with SMTP id r10mr14268635wmh.184.1636532070416;
        Wed, 10 Nov 2021 00:14:30 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:50a8:62f0:9952:bc6b? (p200300ea8f1a0f0050a862f09952bc6b.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:50a8:62f0:9952:bc6b])
        by smtp.googlemail.com with ESMTPSA id t1sm24698620wre.32.2021.11.10.00.14.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 00:14:29 -0800 (PST)
Message-ID: <f5454635-a857-b563-0a44-6dc135872b1d@gmail.com>
Date:   Wed, 10 Nov 2021 09:14:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
To:     Bastian Germann <bage@linutronix.de>, Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        netdev@vger.kernel.org,
        Benedikt Spranger <b.spranger@linutronix.de>
References: <20211105153648.8337-1-bage@linutronix.de>
 <6e1844e5-cbee-5d50-e304-efa785405922@gmail.com>
 <108f9fe7-54ec-d601-d091-bac6178624cf@linutronix.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] phy: phy_ethtool_ksettings_set: Don't discard
 phy_start_aneg's return
In-Reply-To: <108f9fe7-54ec-d601-d091-bac6178624cf@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.11.2021 15:25, Bastian Germann wrote:
> Am 06.11.21 um 22:52 schrieb Heiner Kallweit:
>> On 05.11.2021 16:36, bage@linutronix.de wrote:
>>> From: Bastian Germann <bage@linutronix.de>
>>>
>>> Take the return of phy_start_aneg into account so that ethtool will handle
>>> negotiation errors and not silently accept invalid input.
>>>
>>> Fixes: 2d55173e71b0 ("phy: add generic function to support ksetting support")
>>> Signed-off-by: Bastian Germann <bage@linutronix.de>
>>> Reviewed-by: Benedikt Spranger <b.spranger@linutronix.de>
>>
>> In addition to what Andrew said already:
>>
>> - This patch won't apply on net due to a4db9055fdb9.
> 
> Hi Heiner,
> 
> Thanks for your remarks. I would have gotten the first one right if the netdev
> tree was documented in the MAINTAINERS file (T: ...) and not only in netdev-FAQ.
> 
> Maybe you want to address that.
> 

I'd interpret the MAINTAINERS structure in a way that if no T: entry is given
the one from the next upper directory should be used. And for drivers/net/
the T: entries are available.

It's a typical case that a subsystem has a bigger number of drivers which
use the repo of the subsystem, and just few drivers have an own repo,
working with pull requests.
IMO having to add the subsystem T: entries to every driver entry would be
not needed overhead.

Not sure however which userspace tools use the T: entries and whether they are
smart enough to consider entry hierarchies.

> Thanks,
> Bastian
> 
>> - Patch misses the "net" annotation.
>> - Prefix should be "net: phy:", not "phy:".
>>
>> At least the formal aspects should have been covered by the internal review.
>>
>>> ---
>>>   drivers/net/phy/phy.c | 6 ++++--
>>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>>> index a3bfb156c83d..f740b533abba 100644
>>> --- a/drivers/net/phy/phy.c
>>> +++ b/drivers/net/phy/phy.c
>>> @@ -770,6 +770,8 @@ static int phy_poll_aneg_done(struct phy_device *phydev)
>>>   int phy_ethtool_ksettings_set(struct phy_device *phydev,
>>>                     const struct ethtool_link_ksettings *cmd)
>>>   {
>>> +    int ret = 0;
>>
>> Why initializing ret?
>>
>>> +
>>>       __ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
>>>       u8 autoneg = cmd->base.autoneg;
>>>       u8 duplex = cmd->base.duplex;
>>> @@ -815,10 +817,10 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
>>>       phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
>>>         /* Restart the PHY */
>>> -    _phy_start_aneg(phydev);
>>> +    ret = _phy_start_aneg(phydev);
>>>         mutex_unlock(&phydev->lock);
>>> -    return 0;
>>> +    return ret;
>>>   }
>>>   EXPORT_SYMBOL(phy_ethtool_ksettings_set);
>>>  
>>

