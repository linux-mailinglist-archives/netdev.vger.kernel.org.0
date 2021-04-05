Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21324354313
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 16:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237628AbhDEO7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 10:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235835AbhDEO7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 10:59:00 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83304C061756;
        Mon,  5 Apr 2021 07:58:54 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id o20-20020a05600c4fd4b0290114265518afso2951831wmq.4;
        Mon, 05 Apr 2021 07:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KnJ3LRa9TqVuz0aF+3zQMTMMBwdIj28G7mOLyeRXiqg=;
        b=M66iGJj7O3ECiR8zcr9TOdzVdsP2THXNzYVqJeN9MjSYLmVPzOxqB4JQVQ8lxZ+Sf5
         eUKXbMpMT1lfpkIRMCIXye/wtPPeDQc6H311PI/1BYN16rwZ4Z7uQyo3QpqpTMrHKdo0
         s1RAWmJMHkLnBDiejf2AOSGIm7qLP/noMsxXZhSffAsVzapC20cBFfLSJDgXL8izWN+o
         JHGCR9Gpqz/ELL95K2S33YGvonPEHjvSbkWiFsvyeinZmxs9uMUFrfg7e0CSx+Gdu0W5
         DT5UktFjL1+1EDlijBdfhIRJSS/90TMfUeYWw+/EkSTrSq7z0jFnlYUeRMKOnbPTOKjJ
         wtUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KnJ3LRa9TqVuz0aF+3zQMTMMBwdIj28G7mOLyeRXiqg=;
        b=ZchrsKR8gd1LxR0nsHcCxzpbRcnRHoxxQ7tfCvytuT4wBB/kT8jE3qi1/zW4KRDBFB
         vt+rmCROl5Od/ZTmY7KIeRuYPSfgcjylvmV2ocmMljBbWY+j91eCPCB75ZD087w+CN+i
         Vfwaagedcql75GPydIu/ZvwuVVF+odWeuu6jg541T22xHn8FGEozCgmmcEtZvjI5u1dY
         8gZwg2kOtKLhfhqZ6YIVmSw/DTPw1+iExqUFbvhNNUSLXV7/qxgMTzrkizfOG8PbpiY2
         h2dS3CvhoVgpULl+vBM4JK8PY/BG/vDILkilgrJsh2LRG31mbYN5aPFrJB2L0wFw74g1
         9qaw==
X-Gm-Message-State: AOAM533Pe01Yw0lHrMZqQzVvD7meOrOLLzHt7cNZbtYa6aPBOxe+EBic
        cKbwxShQT6lykO8obICj2Tg=
X-Google-Smtp-Source: ABdhPJyCyFIFfSOWafSMG7ISt0zY+Y1D+XdNeKan9YTsya4r/O2DxYfQ+3og0rLMx28ZgzbJ/a6pYQ==
X-Received: by 2002:a05:600c:4f8e:: with SMTP id n14mr26084086wmq.34.1617634733224;
        Mon, 05 Apr 2021 07:58:53 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:417d:b38d:188d:9829? (p200300ea8f1fbb00417db38d188d9829.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:417d:b38d:188d:9829])
        by smtp.googlemail.com with ESMTPSA id f9sm7288420wmj.38.2021.04.05.07.58.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 07:58:52 -0700 (PDT)
To:     christian.melki@t2data.com, Joakim Zhang <qiangqing.zhang@nxp.com>,
        andrew@lunn.ch, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
References: <20210404100701.6366-1-qiangqing.zhang@nxp.com>
 <97e486f8-372a-896f-6549-67b8fb34e623@gmail.com>
 <ed600136-2222-a261-bf08-522cc20fc141@gmail.com>
 <ff5719b4-acd7-cd27-2f07-d8150e2690c8@t2data.com>
 <010f896e-befb-4238-5219-01969f3581e3@gmail.com>
 <1ded1438-b3cf-19d2-c3f4-1c1da3505295@t2data.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phy: fix PHY possibly unwork after MDIO bus resume
 back
Message-ID: <e6840b72-4b6b-773f-0748-0c635b2eef17@gmail.com>
Date:   Mon, 5 Apr 2021 16:58:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <1ded1438-b3cf-19d2-c3f4-1c1da3505295@t2data.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.04.2021 15:53, Christian Melki wrote:
> On 4/5/21 2:09 PM, Heiner Kallweit wrote:
>> On 05.04.2021 10:43, Christian Melki wrote:
>>> On 4/5/21 12:48 AM, Heiner Kallweit wrote:
>>>> On 04.04.2021 16:09, Heiner Kallweit wrote:
>>>>> On 04.04.2021 12:07, Joakim Zhang wrote:
>>>>>> commit 4c0d2e96ba055 ("net: phy: consider that suspend2ram may cut
>>>>>> off PHY power") invokes phy_init_hw() when MDIO bus resume, it will
>>>>>> soft reset PHY if PHY driver implements soft_reset callback.
>>>>>> commit 764d31cacfe4 ("net: phy: micrel: set soft_reset callback to
>>>>>> genphy_soft_reset for KSZ8081") adds soft_reset for KSZ8081. After these
>>>>>> two patches, I found i.MX6UL 14x14 EVK which connected to KSZ8081RNB doesn't
>>>>>> work any more when system resume back, MAC driver is fec_main.c.
>>>>>>
>>>>>> It's obvious that initializing PHY hardware when MDIO bus resume back
>>>>>> would introduce some regression when PHY implements soft_reset. When I
>>>>>
>>>>> Why is this obvious? Please elaborate on why a soft reset should break
>>>>> something.
>>>>>
>>>>>> am debugging, I found PHY works fine if MAC doesn't support suspend/resume
>>>>>> or phy_stop()/phy_start() doesn't been called during suspend/resume. This
>>>>>> let me realize, PHY state machine phy_state_machine() could do something
>>>>>> breaks the PHY.
>>>>>>
>>>>>> As we known, MAC resume first and then MDIO bus resume when system
>>>>>> resume back from suspend. When MAC resume, usually it will invoke
>>>>>> phy_start() where to change PHY state to PHY_UP, then trigger the stat> machine to run now. In phy_state_machine(), it will start/config
>>>>>> auto-nego, then change PHY state to PHY_NOLINK, what to next is
>>>>>> periodically check PHY link status. When MDIO bus resume, it will
>>>>>> initialize PHY hardware, including soft_reset, what would soft_reset
>>>>>> affect seems various from different PHYs. For KSZ8081RNB, when it in
>>>>>> PHY_NOLINK state and then perform a soft reset, it will never complete
>>>>>> auto-nego.
>>>>>
>>>>> Why? That would need to be checked in detail. Maybe chip errata
>>>>> documentation provides a hint.
>>>>>
>>>>
>>>> The KSZ8081 spec says the following about bit BMCR_PDOWN:
>>>>
>>>> If software reset (Register 0.15) is
>>>> used to exit power-down mode
>>>> (Register 0.11 = 1), two software
>>>> reset writes (Register 0.15 = 1) are
>>>> required. The first write clears
>>>> power-down mode; the second
>>>> write resets the chip and re-latches
>>>> the pin strapping pin values.
>>>>
>>>> Maybe this causes the issue you see and genphy_soft_reset() isn't
>>>> appropriate for this PHY. Please re-test with the KSZ8081 soft reset
>>>> following the spec comment.
>>>>
>>>
>>> Interesting. Never expected that behavior.
>>> Thanks for catching it. Skimmed through the datasheets/erratas.
>>> This is what I found (micrel.c):
>>>
>>> 10/100:
>>> 8001 - Unaffected?
>>> 8021/8031 - Double reset after PDOWN.
>>> 8041 - Errata. PDOWN broken. Recommended do not use. Unclear if reset
>>> solves the issue since errata says no error after reset but is also
>>> claiming that only toggling PDOWN (may) or power will help.
>>> 8051 - Double reset after PDOWN.
>>> 8061 - Double reset after PDOWN.
>>> 8081 - Double reset after PDOWN.
>>> 8091 - Double reset after PDOWN.
>>>
>>> 10/100/1000:
>>> Nothing in gigabit afaics.
>>>
>>> Switches:
>>> 8862 - Not affected?
>>> 8863 - Errata. PDOWN broken. Reset will not help. Workaround exists.
>>> 8864 - Not affected?
>>> 8873 - Errata. PDOWN broken. Reset will not help. Workaround exists.
>>> 9477 - Errata. PDOWN broken. Will randomly cause link failure on
>>> adjacent links. Do not use.
>>>
>>> This certainly explains a lot.
>>>
>>>>>>
>>>>>> This patch changes PHY state to PHY_UP when MDIO bus resume back, it
>>>>>> should be reasonable after PHY hardware re-initialized. Also give state
>>>>>> machine a chance to start/config auto-nego again.
>>>>>>
>>>>>
>>>>> If the MAC driver calls phy_stop() on suspend, then phydev->suspended
>>>>> is true and mdio_bus_phy_may_suspend() returns false. As a consequence
>>>>> phydev->suspended_by_mdio_bus is false and mdio_bus_phy_resume()
>>>>> skips the PHY hw initialization.
>>>>> Please also note that mdio_bus_phy_suspend() calls phy_stop_machine()
>>>>> that sets the state to PHY_UP.
>>>>>
>>>>
>>>> Forgot that MDIO bus suspend is done before MAC driver suspend.
>>>> Therefore disregard this part for now.
>>>>
>>>>> Having said that the current argumentation isn't convincing. I'm not
>>>>> aware of such issues on other systems, therefore it's likely that
>>>>> something is system-dependent.
>>>>>
>>>>> Please check the exact call sequence on your system, maybe it
>>>>> provides a hint.
>>>>>
>>>>>> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
>>>>>> ---
>>>>>>  drivers/net/phy/phy_device.c | 7 +++++++
>>>>>>  1 file changed, 7 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>>>>>> index cc38e326405a..312a6f662481 100644
>>>>>> --- a/drivers/net/phy/phy_device.c
>>>>>> +++ b/drivers/net/phy/phy_device.c
>>>>>> @@ -306,6 +306,13 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
>>>>>>  	ret = phy_resume(phydev);
>>>>>>  	if (ret < 0)
>>>>>>  		return ret;
>>>>>> +
>>>>>> +	/* PHY state could be changed to PHY_NOLINK from MAC controller resume
>>>>>> +	 * rounte with phy_start(), here change to PHY_UP after re-initializing
>>>>>> +	 * PHY hardware, let PHY state machine to start/config auto-nego again.
>>>>>> +	 */
>>>>>> +	phydev->state = PHY_UP;
>>>>>> +
>>>>>>  no_resume:
>>>>>>  	if (phydev->attached_dev && phydev->adjust_link)
>>>>>>  		phy_start_machine(phydev);
>>>>>>
>>>>>
>>>>
>>>
>>
>> This is a quick draft of the modified soft reset for KSZ8081.
>> Some tests would be appreciated.
>>
>>
>> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
>> index a14a00328..4902235a8 100644
>> --- a/drivers/net/phy/micrel.c
>> +++ b/drivers/net/phy/micrel.c
>> @@ -1091,6 +1091,42 @@ static void kszphy_get_stats(struct phy_device *phydev,
>>  		data[i] = kszphy_get_stat(phydev, i);
>>  }
>>  
>> +int ksz8081_soft_reset(struct phy_device *phydev)
>> +{
>> +	int bmcr, ret, val;
>> +
>> +	phy_lock_mdio_bus(phydev);
>> +
>> +	bmcr = __phy_read(phydev, MII_BMCR);
>> +	if (bmcr < 0)
>> +		return bmcr;
>> +
>> +	bmcr |= BMCR_RESET;
>> +
>> +	if (bmcr & BMCR_PDOWN)
>> +		__phy_write(phydev, MII_BMCR, bmcr);
>> +
>> +	if (phydev->autoneg == AUTONEG_ENABLE)
>> +		bmcr |= BMCR_ANRESTART;
>> +
>> +	__phy_write(phydev, MII_BMCR, bmcr & ~BMCR_ISOLATE);
>> +
> 
> Wouldn't this re-set BMCR_PDOWN?

No. A soft reset is supposed to reset all bits to their defaults.
Therefore power-down bit should be cleared.
See genphy_soft_reset(), there we do it the same way.

> Since this is probably required by a few other micrel phys,
> maybe a kszphy_type flag and continue with genphy_soft_reset?
> 
It seems only Micrel PHY's have this quirky behavior, therefore
I'd like to keep the special soft reset handling in the Micrel
PHY driver. But yes, we would have to switch more Micrel PHY
drivers to the new soft reset callback.


>> +	phy_unlock_mdio_bus(phydev);
>> +
>> +	phydev->suspended = 0;
>> +
>> +	ret = phy_read_poll_timeout(phydev, MII_BMCR, val, !(val & BMCR_RESET),
>> +				    50000, 600000, true);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* BMCR may be reset to defaults */
>> +	if (phydev->autoneg == AUTONEG_DISABLE)
>> +		ret = genphy_setup_forced(phydev);
>> +
>> +	return ret;
>> +}
>> +
>>  static int kszphy_suspend(struct phy_device *phydev)
>>  {
>>  	/* Disable PHY Interrupts */
>> @@ -1303,7 +1339,7 @@ static struct phy_driver ksphy_driver[] = {
>>  	.driver_data	= &ksz8081_type,
>>  	.probe		= kszphy_probe,
>>  	.config_init	= ksz8081_config_init,
>> -	.soft_reset	= genphy_soft_reset,
>> +	.soft_reset	= ksz8081_soft_reset,
>>  	.config_intr	= kszphy_config_intr,
>>  	.handle_interrupt = kszphy_handle_interrupt,
>>  	.get_sset_count = kszphy_get_sset_count,
>>
> 

