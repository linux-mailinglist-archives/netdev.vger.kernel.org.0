Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A91097A11A
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 08:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbfG3GI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 02:08:59 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36796 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfG3GI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 02:08:59 -0400
Received: by mail-wm1-f65.google.com with SMTP id g67so51355687wme.1;
        Mon, 29 Jul 2019 23:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vXZFEIMyaqjf8/yrqJ6vwTJxuzdckyXlhrvkpantsso=;
        b=elZONvUUCYTDmcJU9mza3ggivxr19sNxWYIHKROEzHzbtb/By7dPj5oVq9Uz+S7Yia
         blb7vR2pYTB/D4lfs0VGV5HS4JC3JKk3Tq+4IefhKh+J39G/F2AyLAfLFssTBq1MzwsD
         cLdcs0lezF/xU23FcXciATuA7Km/59Ru4Q3EMxo2LiPTkuRxFI8AThEjkTDyWov2Zhpj
         /eu8FjhtIGL8+oKIkZVcmdvIf9Jn+5/lB2PPXNzNz25x5YxDRobWkmWmIxOwFp/iwgOf
         Kg4pR0WC4nlWSg9xFbRxVslZwOVkP9oXIISu1xGsFouwbcLlbr0uXf7fEVZWuPuytCEN
         kIwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vXZFEIMyaqjf8/yrqJ6vwTJxuzdckyXlhrvkpantsso=;
        b=ho5SgsRh39CJbk4eeh4IgwGXkBSvWJYyTq1oOLu3+ggwnqh4zXSsY+ClZQ7QOwRNWt
         KVhFbHRdb7aYkk50d0U+Yw7h4fZgpZN3apAhdPvuVQ02QNLXORZgTCcDD+x8ZISO82Sg
         3oxEkxS66uS1n1MU1IFR5df3G/CfjZcKFKCr0q66j2Lb+4owplJ3bPZnBggTJ4Wv7Jcp
         FWHcNvIPxEPavKexb3LQc8LQ0XgMiC43Y5pI3A1Nh7IKTFRdKvD3BsRQdj1uu2zTnu3r
         DN2h2O5r7dnH/Bi26da/iwhEvn3ZyOpoYttU8vGYnAH37JG2Hh/ssBssiuhPy/d4Czah
         KU2Q==
X-Gm-Message-State: APjAAAU0BfwMy4QSpJuAwQvNBmu3CpoW6ycb5MnO+MrfafcMi53rueYI
        bdq0hfoWft7JB5Bd7n/fwtQ=
X-Google-Smtp-Source: APXvYqxOu7yvFESpqlzA9IufS7zMteNlDKZbTxtDGKRZRFO+mQw50T/NEGukqh/OrgM3pWFERoGJJg==
X-Received: by 2002:a1c:6c01:: with SMTP id h1mr3271003wmc.30.1564466936465;
        Mon, 29 Jul 2019 23:08:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:6c98:6a00:6f0a:eb31? (p200300EA8F4342006C986A006F0AEB31.dip0.t-ipconnect.de. [2003:ea:8f43:4200:6c98:6a00:6f0a:eb31])
        by smtp.googlemail.com with ESMTPSA id o6sm131096259wra.27.2019.07.29.23.08.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 23:08:55 -0700 (PDT)
Subject: Re: [RFC] net: phy: read link status twice when
 phy_check_link_status()
To:     liuyonglong <liuyonglong@huawei.com>, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, shiju.jose@huawei.com
References: <1564134831-24962-1-git-send-email-liuyonglong@huawei.com>
 <92f42ee8-3659-87a7-ac96-d312a98046ba@gmail.com>
 <4b4ba599-f160-39e7-d611-45ac53268389@huawei.com>
 <a0b26e4b-e288-cf44-049a-7d0b7f5696eb@gmail.com>
 <1d4be6ad-ffe6-2325-ceab-9f35da617ee9@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <5087ee34-5776-f02b-d7e5-bce005ba3b92@gmail.com>
Date:   Tue, 30 Jul 2019 08:08:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1d4be6ad-ffe6-2325-ceab-9f35da617ee9@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.07.2019 06:03, liuyonglong wrote:
> 
> 
> On 2019/7/30 4:57, Heiner Kallweit wrote:
>> On 29.07.2019 05:59, liuyonglong wrote:
>>>
>>>
>>> On 2019/7/27 2:14, Heiner Kallweit wrote:
>>>> On 26.07.2019 11:53, Yonglong Liu wrote:
>>>>> According to the datasheet of Marvell phy and Realtek phy, the
>>>>> copper link status should read twice, or it may get a fake link
>>>>> up status, and cause up->down->up at the first time when link up.
>>>>> This happens more oftem at Realtek phy.
>>>>>
>>>> This is not correct, there is no fake link up status.
>>>> Read the comment in genphy_update_link, only link-down events
>>>> are latched. Means if the first read returns link up, then there
>>>> is no need for a second read. And in polling mode we don't do a
>>>> second read because we want to detect also short link drops.
>>>>
>>>> It would be helpful if you could describe your actual problem
>>>> and whether you use polling or interrupt mode.
>>>>
>>>
>>> [   44.498633] hns3 0000:bd:00.1 eth5: net open
>>> [   44.504273] hns3 0000:bd:00.1: reg=0x1, data=0x79ad -> called from phy_start_aneg
>>> [   44.532348] hns3 0000:bd:00.1: reg=0x1, data=0x798d -> called from phy_state_machine,update link.
>>
>> This should not happen. The PHY indicates link up w/o having aneg finished.
>>
>>>
>>> According to the datasheet:
>>> reg 1.5=0 now, means copper auto-negotiation not complete
>>> reg 1.2=1 now, means link is up
>>>
>>> We can see that, when we read the link up, the auto-negotiation
>>> is not complete yet, so the speed is invalid.
>>>
>>> I don't know why this happen, maybe this state is keep from bios?
>>> Or we may do something else in the phy initialize to fix it?
>>> And also confuse that why read twice can fix it?
>>>
>> I suppose that basically any delay would do.
>>
>>> [   44.554063] hns3 0000:bd:00.1: invalid speed (-1)
>>> [   44.560412] hns3 0000:bd:00.1 eth5: failed to adjust link.
>>> [   45.194870] hns3 0000:bd:00.1 eth5: link up
>>> [   45.574095] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x7989
>>> [   46.150051] hns3 0000:bd:00.1 eth5: link down
>>> [   46.598074] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x7989
>>> [   47.622075] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x79a9
>>> [   48.646077] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x79ad
>>> [   48.934050] hns3 0000:bd:00.1 eth5: link up
>>> [   49.702140] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x79ad
>>>
>>>>> I add a fake status read, and can solve this problem.
>>>>>
>>>>> I also see that in genphy_update_link(), had delete the fake
>>>>> read in polling mode, so I don't know whether my solution is
>>>>> correct.
>>>>>
>>
>> Can you test whether the following fixes the issue for you?
>> Also it would be interesting which exact PHY models you tested
>> and whether you built the respective PHY drivers or whether you
>> rely on the genphy driver. Best use the second patch to get the
>> needed info. It may make sense anyway to add the call to
>> phy_attached_info() to the hns3 driver.
>>
> 
> [   40.100716] RTL8211F Gigabit Ethernet mii-0000:bd:00.3:07: attached PHY driver [RTL8211F Gigabit Ethernet] (mii_bus:phy_addr=mii-0000:bd:00.3:07, irq=POLL)
> [   40.932133] hns3 0000:bd:00.3 eth7: net open
> [   40.932458] hns3 0000:bd:00.3: invalid speed (-1)
> [   40.932541] 8021q: adding VLAN 0 to HW filter on device eth7
> [   40.937149] hns3 0000:bd:00.3 eth7: failed to adjust link.
> 
> [   40.662050] Generic PHY mii-0000:bd:00.2:05: attached PHY driver [Generic PHY] (mii_bus:phy_addr=mii-0000:bd:00.2:05, irq=POLL)
> [   41.563511] hns3 0000:bd:00.2 eth6: net open
> [   41.563853] hns3 0000:bd:00.2: invalid speed (-1)
> [   41.563943] 8021q: adding VLAN 0 to HW filter on device eth6
> [   41.568578] IPv6: ADDRCONF(NETDEV_CHANGE): eth6: link becomes ready
> [   41.568898] hns3 0000:bd:00.2 eth6: failed to adjust link.
> 
> I am using RTL8211F, but you can see that, both genphy driver and
> RTL8211F driver have the same issue.
> 
>>
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index 6b5cb87f3..fbecfe210 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -1807,7 +1807,8 @@ int genphy_read_status(struct phy_device *phydev)
>>  
>>  	linkmode_zero(phydev->lp_advertising);
>>  
>> -	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
>> +	if (phydev->autoneg == AUTONEG_ENABLE &&
>> +	    (phydev->autoneg_complete || phydev->link)) {
>>  		if (phydev->is_gigabit_capable) {
>>  			lpagb = phy_read(phydev, MII_STAT1000);
>>  			if (lpagb < 0)
>>
> 
> I have try this patch, have no effect. I suppose that at this time,
> the autoneg actually not complete yet.
> 
> Maybe the wrong phy state is passed from bios? Invalid speed just
> happen at the first time when ethX up, after that, repeat the
> ifconfig down/ifconfig up command can not see that again.
> 
> So I think the bios should power off the phy(writing reg 1.11 to 1)
> before it starts the OS? Or any other way to fix this in the OS?
> 
To get a better idea of whats going on it would be good to see a full
MDIO trace. Can you enable MDIO tracing via the following sysctl file
/sys/kernel/debug/tracing/events/mdio/enable
and provide the generated trace?

Due to polling mode each second entries will be generated, so you
better stop network after the issue occurred.

> 
> 
> 

Heiner
