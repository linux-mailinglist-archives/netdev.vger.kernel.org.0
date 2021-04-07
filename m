Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2024335695D
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 12:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350908AbhDGKWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 06:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235325AbhDGKWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 06:22:04 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD6DC061756;
        Wed,  7 Apr 2021 03:21:54 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id y18so1232111wrn.6;
        Wed, 07 Apr 2021 03:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TOHH117ABuxv/fg54mJTSdEtkwlXztH7OFpsYr64pZo=;
        b=SCgdIm8yXjPeeFD27DTDxS8iDmWZws/M/VlUXGHTO3674wc/wE/LEQQ+ZgR/lyPpcy
         wWUWWBwkTc2FSc6zB37ECkhibmKecemfXYiFkvTWPFYVfyVrNCL3Ggn8lZnGj74zXFOH
         uSwRfcGSaTZ+ZM/zIcxZlMP1F6kGP8gxJ20I+oSJWMOkgDR2o4mF+Ua0vYnU2MqAKwAi
         R91cpLkKbAHS6CwWR2UI+Rjq2ewf+qVGFBzmiXzMP5YuH1GYfCa0ycswF1yrmtX/H+O0
         ++Uvh96Q1fFl4xP9UGFNeBpMYNVX7ng8J5/OpHcFV99xSE6IscU0OIF5e/YTOUKb+diu
         0svA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TOHH117ABuxv/fg54mJTSdEtkwlXztH7OFpsYr64pZo=;
        b=qRhn4tPzc25EpbnhWMWIn4G6wfFxaqjXY06enCnk1SA747zc/D2JhiTEsatWcglOYb
         MSXDyPW35XhMVS+ezvtP4Vd9iJH2bUK6uU19y2caT17XMOoLMD+haI+D9tNgUlucEUlC
         b641z1dGWB2PqtH3PyOhyYsyVRxp3v/gC2Oi3a+YbR/XD5VvxiAgChaKJR0dIxORxaQf
         oZ9gU9PB+Mei/m91xan4nfGY98KxScVxSz2gAYOvO2H+tD+ilq3+m2J1PMdG4DD1UZu8
         aEZTG7xMxd9gIuh03TbtazU2GoE9LJQh1/n7SYDkkxgWi1c+STdxS5uEmdETYxG+/Xow
         N9CQ==
X-Gm-Message-State: AOAM532RUp9o/8vwbLsJnJdDY80imUmd1DFtnlXftHNRdQjaqlz1dQ6E
        02mRKuHeHjJNY7zMlaM2KLw=
X-Google-Smtp-Source: ABdhPJyFNrTCOIESxU0dlbQtPw19NrYmg+6cJAxRE38e/TcR/fEf7LgvHgwkbGvp0HWz5gKmEZeFsg==
X-Received: by 2002:a05:6000:18ab:: with SMTP id b11mr3404799wri.403.1617790913567;
        Wed, 07 Apr 2021 03:21:53 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:15f8:68c8:25bd:c1f8? (p200300ea8f38460015f868c825bdc1f8.dip0.t-ipconnect.de. [2003:ea:8f38:4600:15f8:68c8:25bd:c1f8])
        by smtp.googlemail.com with ESMTPSA id j1sm9217263wrq.90.2021.04.07.03.21.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 03:21:52 -0700 (PDT)
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "christian.melki@t2data.com" <christian.melki@t2data.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <20210404100701.6366-1-qiangqing.zhang@nxp.com>
 <97e486f8-372a-896f-6549-67b8fb34e623@gmail.com>
 <ed600136-2222-a261-bf08-522cc20fc141@gmail.com>
 <ff5719b4-acd7-cd27-2f07-d8150e2690c8@t2data.com>
 <010f896e-befb-4238-5219-01969f3581e3@gmail.com>
 <DB8PR04MB6795CC9AA84D14BA98FB6598E6769@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <0e6bd756-f46c-7caf-d45b-a19e7fb80b67@gmail.com>
 <DB8PR04MB6795D52C6FA54D17D43D1E99E6769@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <b34ccbf5-18eb-681b-3336-4c93325c2a43@gmail.com>
 <a58f3259-d638-7506-1c07-660562d3527f@gmail.com>
 <VI1PR04MB68006AF55FA866B1CEBD0D04E6759@VI1PR04MB6800.eurprd04.prod.outlook.com>
 <902bd022-a135-a481-1a7f-2781998b2ee8@gmail.com>
 <DB8PR04MB6795C3B549B984381B833AF9E6759@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <DB8PR04MB6795C9E05E48361C0D462926E6759@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phy: fix PHY possibly unwork after MDIO bus resume
 back
Message-ID: <bc801f4d-19fb-11cb-d04d-21d59ab20b35@gmail.com>
Date:   Wed, 7 Apr 2021 12:21:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB6795C9E05E48361C0D462926E6759@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.04.2021 12:05, Joakim Zhang wrote:
> 
> Hi Heiner,
> 
>> -----Original Message-----
>> From: Joakim Zhang <qiangqing.zhang@nxp.com>
>> Sent: 2021年4月7日 15:46
>> To: Heiner Kallweit <hkallweit1@gmail.com>; christian.melki@t2data.com;
>> andrew@lunn.ch; linux@armlinux.org.uk; davem@davemloft.net;
>> kuba@kernel.org
>> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; dl-linux-imx
>> <linux-imx@nxp.com>; Florian Fainelli <f.fainelli@gmail.com>
>> Subject: RE: [PATCH] net: phy: fix PHY possibly unwork after MDIO bus resume
>> back
>>
>>
>> Hi Heiner,
>>
>>> -----Original Message-----
>>> From: Heiner Kallweit <hkallweit1@gmail.com>
>>> Sent: 2021年4月7日 15:12
>>> To: Joakim Zhang <qiangqing.zhang@nxp.com>;
>>> christian.melki@t2data.com; andrew@lunn.ch; linux@armlinux.org.uk;
>>> davem@davemloft.net; kuba@kernel.org
>>> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; dl-linux-imx
>>> <linux-imx@nxp.com>; Florian Fainelli <f.fainelli@gmail.com>
>>> Subject: Re: [PATCH] net: phy: fix PHY possibly unwork after MDIO bus
>>> resume back
>>>
>>> On 07.04.2021 03:43, Joakim Zhang wrote:
>>>>
>>>> Hi Heiner,
>>>>
>>>>> -----Original Message-----
>>>>> From: Heiner Kallweit <hkallweit1@gmail.com>
>>>>> Sent: 2021年4月7日 2:22
>>>>> To: Joakim Zhang <qiangqing.zhang@nxp.com>;
>>>>> christian.melki@t2data.com; andrew@lunn.ch; linux@armlinux.org.uk;
>>>>> davem@davemloft.net; kuba@kernel.org; Russell King - ARM Linux
>>>>> <linux@armlinux.org.uk>
>>>>> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>>>>> dl-linux-imx <linux-imx@nxp.com>; Florian Fainelli
>>>>> <f.fainelli@gmail.com>
>>>>> Subject: Re: [PATCH] net: phy: fix PHY possibly unwork after MDIO
>>>>> bus resume back
>>>>>
>>>>> On 06.04.2021 13:42, Heiner Kallweit wrote:
>>>>>> On 06.04.2021 12:07, Joakim Zhang wrote:
>>>>>>>
>>>>>>>> -----Original Message-----
>>>>>>>> From: Heiner Kallweit <hkallweit1@gmail.com>
>>>>>>>> Sent: 2021年4月6日 14:29
>>>>>>>> To: Joakim Zhang <qiangqing.zhang@nxp.com>;
>>>>>>>> christian.melki@t2data.com; andrew@lunn.ch;
>>>>>>>> linux@armlinux.org.uk; davem@davemloft.net; kuba@kernel.org
>>>>>>>> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>>>>>>>> dl-linux-imx <linux-imx@nxp.com>
>>>>>>>> Subject: Re: [PATCH] net: phy: fix PHY possibly unwork after
>>>>>>>> MDIO bus resume back
>>>>>>>>
>>>>>>>> On 06.04.2021 04:07, Joakim Zhang wrote:
>>>>>>>>>
>>>>>>>>> Hi Heiner,
>>>>>>>>>
>>>>>>>>>> -----Original Message-----
>>>>>>>>>> From: Heiner Kallweit <hkallweit1@gmail.com>
>>>>>>>>>> Sent: 2021年4月5日 20:10
>>>>>>>>>> To: christian.melki@t2data.com; Joakim Zhang
>>>>>>>>>> <qiangqing.zhang@nxp.com>; andrew@lunn.ch;
>>>>>>>>>> linux@armlinux.org.uk; davem@davemloft.net; kuba@kernel.org
>>>>>>>>>> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>>>>>>>>>> dl-linux-imx <linux-imx@nxp.com>
>>>>>>>>>> Subject: Re: [PATCH] net: phy: fix PHY possibly unwork after
>>>>>>>>>> MDIO bus resume back
>>>>>>>>>>
>>>>>>>>>> On 05.04.2021 10:43, Christian Melki wrote:
>>>>>>>>>>> On 4/5/21 12:48 AM, Heiner Kallweit wrote:
>>>>>>>>>>>> On 04.04.2021 16:09, Heiner Kallweit wrote:
>>>>>>>>>>>>> On 04.04.2021 12:07, Joakim Zhang wrote:
>>>>>>>>>>>>>> commit 4c0d2e96ba055 ("net: phy: consider that suspend2ram
>>>>> may
>>>>>>>>>>>>>> cut off PHY power") invokes phy_init_hw() when MDIO bus
>>>>>>>>>>>>>> resume, it will soft reset PHY if PHY driver implements
>>>>>>>>>>>>>> soft_reset
>>>>> callback.
>>>>>>>>>>>>>> commit 764d31cacfe4 ("net: phy: micrel: set soft_reset
>>>>>>>>>>>>>> callback to genphy_soft_reset for KSZ8081") adds
>>>>>>>>>>>>>> soft_reset for
>>>>> KSZ8081.
>>>>>>>>>>>>>> After these two patches, I found i.MX6UL 14x14 EVK which
>>>>>>>>>>>>>> connected to KSZ8081RNB doesn't work any more when
>> system
>>>>>>>> resume
>>>>>>>>>>>>>> back, MAC
>>>>>>>>>> driver is fec_main.c.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> It's obvious that initializing PHY hardware when MDIO bus
>>>>>>>>>>>>>> resume back would introduce some regression when PHY
>>>>>>>>>>>>>> implements soft_reset. When I
>>>>>>>>>>>>>
>>>>>>>>>>>>> Why is this obvious? Please elaborate on why a soft reset
>>>>>>>>>>>>> should break something.
>>>>>>>>>>>>>
>>>>>>>>>>>>>> am debugging, I found PHY works fine if MAC doesn't
>>>>>>>>>>>>>> support suspend/resume or phy_stop()/phy_start() doesn't
>>>>>>>>>>>>>> been called during suspend/resume. This let me realize,
>>>>>>>>>>>>>> PHY state machine
>>>>>>>>>>>>>> phy_state_machine() could do something breaks the PHY.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> As we known, MAC resume first and then MDIO bus resume
>>> when
>>>>>>>>>>>>>> system resume back from suspend. When MAC resume, usually
>>> it
>>>>>>>>>>>>>> will invoke
>>>>>>>>>>>>>> phy_start() where to change PHY state to PHY_UP, then
>>>>>>>>>>>>>> trigger the
>>>>>>>>>>>>>> stat> machine to run now. In phy_state_machine(), it will
>>>>>>>>>>>>>> start/config auto-nego, then change PHY state to
>>>>>>>>>>>>>> PHY_NOLINK, what to next is periodically check PHY link
>>>>>>>>>>>>>> status. When MDIO bus resume, it will initialize PHY
>>>>>>>>>>>>>> hardware, including soft_reset, what would soft_reset
>>>>>>>>>>>>>> affect seems various from
>>>>> different PHYs.
>>>>>>>>>>>>>> For KSZ8081RNB, when it in PHY_NOLINK state and then
>>>>>>>>>>>>>> perform a soft reset,
>>>>>>>>>> it will never complete auto-nego.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Why? That would need to be checked in detail. Maybe chip
>>>>>>>>>>>>> errata documentation provides a hint.
>>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> The KSZ8081 spec says the following about bit BMCR_PDOWN:
>>>>>>>>>>>>
>>>>>>>>>>>> If software reset (Register 0.15) is used to exit power-down
>>>>>>>>>>>> mode (Register 0.11 = 1), two software reset writes
>>>>>>>>>>>> (Register
>>>>>>>>>>>> 0.15 = 1) are required. The first write clears power-down
>>>>>>>>>>>> mode; the second write resets the chip and re-latches the
>>>>>>>>>>>> pin strapping pin
>>>>> values.
>>>>>>>>>>>>
>>>>>>>>>>>> Maybe this causes the issue you see and genphy_soft_reset()
>>>>>>>>>>>> isn't appropriate for this PHY. Please re-test with the
>>>>>>>>>>>> KSZ8081 soft reset following the spec comment.
>>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Interesting. Never expected that behavior.
>>>>>>>>>>> Thanks for catching it. Skimmed through the datasheets/erratas.
>>>>>>>>>>> This is what I found (micrel.c):
>>>>>>>>>>>
>>>>>>>>>>> 10/100:
>>>>>>>>>>> 8001 - Unaffected?
>>>>>>>>>>> 8021/8031 - Double reset after PDOWN.
>>>>>>>>>>> 8041 - Errata. PDOWN broken. Recommended do not use. Unclear
>>>>>>>>>>> if reset solves the issue since errata says no error after
>>>>>>>>>>> reset but is also claiming that only toggling PDOWN (may) or
>>>>>>>>>>> power will
>>> help.
>>>>>>>>>>> 8051 - Double reset after PDOWN.
>>>>>>>>>>> 8061 - Double reset after PDOWN.
>>>>>>>>>>> 8081 - Double reset after PDOWN.
>>>>>>>>>>> 8091 - Double reset after PDOWN.
>>>>>>>>>>>
>>>>>>>>>>> 10/100/1000:
>>>>>>>>>>> Nothing in gigabit afaics.
>>>>>>>>>>>
>>>>>>>>>>> Switches:
>>>>>>>>>>> 8862 - Not affected?
>>>>>>>>>>> 8863 - Errata. PDOWN broken. Reset will not help. Workaround
>>> exists.
>>>>>>>>>>> 8864 - Not affected?
>>>>>>>>>>> 8873 - Errata. PDOWN broken. Reset will not help. Workaround
>>> exists.
>>>>>>>>>>> 9477 - Errata. PDOWN broken. Will randomly cause link failure
>>>>>>>>>>> on adjacent links. Do not use.
>>>>>>>>>>>
>>>>>>>>>>> This certainly explains a lot.
>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> This patch changes PHY state to PHY_UP when MDIO bus
>>> resume
>>>>>>>>>>>>>> back, it should be reasonable after PHY hardware
>>>>>>>>>>>>>> re-initialized. Also give state machine a chance to
>>>>>>>>>>>>>> start/config
>>>>> auto-nego again.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> If the MAC driver calls phy_stop() on suspend, then
>>>>>>>>>>>>> phydev->suspended is true and mdio_bus_phy_may_suspend()
>>>>>>>>>>>>> phydev->returns
>>>>>>>>>>>>> false. As a consequence
>>>>>>>>>>>>> phydev->suspended_by_mdio_bus is false and
>>>>>>>>>>>>> phydev->mdio_bus_phy_resume()
>>>>>>>>>>>>> skips the PHY hw initialization.
>>>>>>>>>>>>> Please also note that mdio_bus_phy_suspend() calls
>>>>>>>>>>>>> phy_stop_machine() that sets the state to PHY_UP.
>>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> Forgot that MDIO bus suspend is done before MAC driver
>> suspend.
>>>>>>>>>>>> Therefore disregard this part for now.
>>>>>>>>>>>>
>>>>>>>>>>>>> Having said that the current argumentation isn't convincing.
>>>>>>>>>>>>> I'm not aware of such issues on other systems, therefore
>>>>>>>>>>>>> it's likely that something is system-dependent.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Please check the exact call sequence on your system, maybe
>>>>>>>>>>>>> it provides a hint.
>>>>>>>>>>>>>
>>>>>>>>>>>>>> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>  drivers/net/phy/phy_device.c | 7 +++++++
>>>>>>>>>>>>>>  1 file changed, 7 insertions(+)
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> diff --git a/drivers/net/phy/phy_device.c
>>>>>>>>>>>>>> b/drivers/net/phy/phy_device.c index
>>>>>>>>>>>>>> cc38e326405a..312a6f662481
>>>>>>>>>>>>>> 100644
>>>>>>>>>>>>>> --- a/drivers/net/phy/phy_device.c
>>>>>>>>>>>>>> +++ b/drivers/net/phy/phy_device.c
>>>>>>>>>>>>>> @@ -306,6 +306,13 @@ static __maybe_unused int
>>>>>>>>>> mdio_bus_phy_resume(struct device *dev)
>>>>>>>>>>>>>>  	ret = phy_resume(phydev);
>>>>>>>>>>>>>>  	if (ret < 0)
>>>>>>>>>>>>>>  		return ret;
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +	/* PHY state could be changed to PHY_NOLINK from MAC
>>>>>>>>>>>>>> +controller
>>>>>>>>>> resume
>>>>>>>>>>>>>> +	 * rounte with phy_start(), here change to PHY_UP after
>>>>>>>>>> re-initializing
>>>>>>>>>>>>>> +	 * PHY hardware, let PHY state machine to start/config
>>>>>>>>>>>>>> +auto-nego
>>>>>>>>>> again.
>>>>>>>>>>>>>> +	 */
>>>>>>>>>>>>>> +	phydev->state = PHY_UP;
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>  no_resume:
>>>>>>>>>>>>>>  	if (phydev->attached_dev && phydev->adjust_link)
>>>>>>>>>>>>>>  		phy_start_machine(phydev);
>>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> This is a quick draft of the modified soft reset for KSZ8081.
>>>>>>>>>> Some tests would be appreciated.
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> I test this patch at my side, unfortunately, it still can't work.
>>>>>>>>>
>>>>>>>>> I have not found what soft reset would affect in 8081 spec, is
>>>>>>>>> there ang common Description for different PHYs?
>>>>>>>>>
>>>>>>>>
>>>>>>>> You can check the clause 22 spec: 802.3 22.2.4.1.1
>>>>>>>>
>>>>>>>> Apart from that you can check BMCR value and which modes your
>>>>>>>> PHY advertises after a soft reset. If the PHY indeed wouldn't
>>>>>>>> restart aneg after a soft reset, then it would be the only one
>>>>>>>> with this behavior I know. And I'd wonder why there aren't more such
>> reports.
>>>>>>>
>>>>>>> Hi Heiner,
>>>>>>>
>>>>>>> We have reasons to believe it is a weird behavior of KSZ8081. I
>>>>>>> have another two PHYs at my side, AR8031 and RTL8211FD, they can
>>>>>>> work fine if
>>>>> soft_reset implemented.
>>>>>>>
>>>>>>> As commit message described, phy_start() would change PHY state
>>>>>>> to
>>>>> PHY_UP finally to PHY_NOLINK when MAC resume.
>>>>>>> After MDIO bus resume back, it will periodically check link status.
>>>>>>> I did below
>>>>> code change to dump all PHY registers.
>>>>>>>
>>>>>>> --- a/drivers/net/phy/phy.c
>>>>>>> +++ b/drivers/net/phy/phy.c
>>>>>>> @@ -35,7 +35,7 @@
>>>>>>>  #include <net/genetlink.h>
>>>>>>>  #include <net/sock.h>
>>>>>>>
>>>>>>> -#define PHY_STATE_TIME HZ
>>>>>>> +#define PHY_STATE_TIME (10 * HZ)
>>>>>>>
>>>>>>>  #define PHY_STATE_STR(_state)                  \
>>>>>>>         case PHY_##_state:                      \
>>>>>>> @@ -738,6 +738,28 @@ static int phy_check_link_status(struct
>>>>>>> phy_device
>>>>> *phydev)
>>>>>>>         if (err)
>>>>>>>                 return err;
>>>>>>>
>>>>>>> +       printk("offset 0x00 data = %0x\n", phy_read(phydev, 0x00));
>>>>>>> +       printk("offset 0x01 data = %0x\n", phy_read(phydev, 0x01));
>>>>>>> +       printk("offset 0x02 data = %0x\n", phy_read(phydev, 0x02));
>>>>>>> +       printk("offset 0x03 data = %0x\n", phy_read(phydev, 0x03));
>>>>>>> +       printk("offset 0x04 data = %0x\n", phy_read(phydev, 0x04));
>>>>>>> +       printk("offset 0x05 data = %0x\n", phy_read(phydev, 0x05));
>>>>>>> +       printk("offset 0x06 data = %0x\n", phy_read(phydev, 0x06));
>>>>>>> +       printk("offset 0x07 data = %0x\n", phy_read(phydev, 0x07));
>>>>>>> +       printk("offset 0x08 data = %0x\n", phy_read(phydev, 0x08));
>>>>>>> +       printk("offset 0x09 data = %0x\n", phy_read(phydev, 0x09));
>>>>>>> +       printk("offset 0x10 data = %0x\n", phy_read(phydev, 0x10));
>>>>>>> +       printk("offset 0x11 data = %0x\n", phy_read(phydev, 0x11));
>>>>>>> +       printk("offset 0x15 data = %0x\n", phy_read(phydev, 0x15));
>>>>>>> +       printk("offset 0x16 data = %0x\n", phy_read(phydev, 0x16));
>>>>>>> +       printk("offset 0x17 data = %0x\n", phy_read(phydev, 0x17));
>>>>>>> +       printk("offset 0x18 data = %0x\n", phy_read(phydev, 0x18));
>>>>>>> +       printk("offset 0x1b data = %0x\n", phy_read(phydev, 0x1b));
>>>>>>> +       printk("offset 0x1c data = %0x\n", phy_read(phydev, 0x1c));
>>>>>>> +       printk("offset 0x1d data = %0x\n", phy_read(phydev, 0x1d));
>>>>>>> +       printk("offset 0x1e data = %0x\n", phy_read(phydev, 0x1e));
>>>>>>> +       printk("offset 0x1f data = %0x\n", phy_read(phydev, 0x1f));
>>>>>>> +       printk("\n\n");
>>>>>>>         if (phydev->link && phydev->state != PHY_RUNNING) {
>>>>>>>                 phy_check_downshift(phydev);
>>>>>>>                 phydev->state = PHY_RUNNING;
>>>>>>>
>>>>>>> After MDIO bus resume back, results as below:
>>>>>>>
>>>>>>> [  119.545383] offset 0x00 data = 1100 [  119.549237] offset 0x01
>>>>>>> data = 7849 [  119.563125] offset 0x02 data = 22 [  119.566810]
>>>>>>> offset 0x03 data = 1560 [  119.570597] offset 0x04 data = 85e1 [
>>>>>>> 119.588016] offset 0x05 data = 0 [  119.592891] offset 0x06 data
>>>>>>> =
>>>>>>> 4 [  119.596452] offset 0x07 data = 2001 [  119.600233] offset
>>>>>>> 0x08 data = 0 [  119.617864] offset 0x09 data = 0 [  119.625990]
>>>>>>> offset
>>>>>>> 0x10 data = 0 [  119.629576] offset 0x11 data = 0 [  119.642735]
>>>>>>> offset 0x15 data = 0 [  119.646332] offset 0x16 data = 202 [
>>>>>>> 119.650030] offset 0x17 data = 5c02 [  119.668054] offset 0x18
>>>>>>> data =
>>>>>>> 801 [  119.672997] offset 0x1b data = 0 [  119.676565] offset
>>>>>>> 0x1c data = 0 [  119.680084] offset 0x1d data = 0 [  119.698031]
>>>>>>> offset 0x1e data = 20 [  119.706246] offset 0x1f data = 8190 [
>>>>>>> 119.709984] [  119.709984] [  120.182120] offset 0x00 data = 100
>>>>>>> [ 120.185894] offset 0x01 data = 784d [  120.189681] offset 0x02
>>>>>>> data = 22 [ 120.206319] offset 0x03 data = 1560 [  120.210171]
>>>>>>> offset
>>>>>>> 0x04 data =
>>>>>>> 8061 [  120.225353] offset 0x05 data = 0 [  120.228948] offset
>>>>>>> 0x06 data = 4 [  120.242936] offset 0x07 data = 2001 [
>>>>>>> 120.246792] offset
>>>>>>> 0x08 data = 0 [  120.250313] offset 0x09 data = 0 [  120.266748]
>>>>>>> offset 0x10 data = 0 [  120.270335] offset 0x11 data = 0 [
>>>>>>> 120.284167] offset 0x15 data = 0 [  120.287760] offset 0x16 data
>>>>>>> =
>>>>>>> 202 [  120.301031] offset 0x17 data = 3c02 [  120.313209] offset
>>>>>>> 0x18 data = 801 [  120.316983] offset 0x1b data = 0 [
>>>>>>> 120.320513] offset 0x1c data = 1 [  120.336589] offset 0x1d data
>>>>>>> = 0 [ 120.340184] offset 0x1e data = 115 [  120.355357] offset
>>>>>>> 0x1f data = 8190 [ 120.359112] [  120.359112] [  129.785396]
>>>>>>> offset 0x00 data = 1100 [ 129.789252] offset 0x01 data = 7849 [
>>>>>>> 129.809951] offset
>>>>>>> 0x02 data =
>>>>>>> 22 [  129.815018] offset 0x03 data = 1560 [  129.818845] offset
>>>>>>> 0x04 data = 85e1 [  129.835808] offset 0x05 data = 0 [
>>>>>>> 129.839398] offset
>>>>>>> 0x06 data = 4 [  129.854514] offset 0x07 data = 2001 [
>>>>>>> 129.858371] offset 0x08 data = 0 [  129.873357] offset 0x09 data
>>>>>>> = 0 [ 129.876954] offset 0x10 data = 0 [  129.880472] offset 0x11
>>>>>>> data =
>>>>>>> 0 [  129.896450] offset 0x15 data = 0 [  129.900038] offset 0x16
>>>>>>> data =
>>>>>>> 202 [  129.915041] offset 0x17 data = 5c02 [  129.918889] offset
>>>>>>> 0x18 data = 801 [  129.932735] offset 0x1b data = 0 [
>>>>>>> 129.946830] offset 0x1c data = 0 [  129.950424] offset 0x1d data
>>>>>>> = 0 [ 129.964585] offset 0x1e data = 0 [  129.968192] offset 0x1f
>>>>>>> data =
>>>>>>> 8190 [ 129.972938] [  129.972938] [  130.425125] offset 0x00 data
>>>>>>> =
>>>>>>> 100 [ 130.428889] offset 0x01 data = 784d [  130.442671] offset
>>>>>>> 0x02 data =
>>>>>>> 22 [  130.446360] offset 0x03 data = 1560 [  130.450142] offset
>>>>>>> 0x04 data = 8061 [  130.467207] offset 0x05 data = 0 [
>>>>>>> 130.470789] offset
>>>>>>> 0x06 data = 4 [  130.485071] offset 0x07 data = 2001 [
>>>>>>> 130.488934] offset 0x08 data = 0 [  130.504320] offset 0x09 data
>>>>>>> = 0 [ 130.507911] offset 0x10 data = 0 [  130.520950] offset 0x11
>>>>>>> data =
>>>>>>> 0 [  130.532865] offset 0x15 data = 0 [  130.536461] offset 0x16
>>>>>>> data =
>>>>>>> 202 [  130.540156] offset 0x17 data = 3c02 [  130.557218] offset
>>>>>>> 0x18 data = 801 [  130.560987] offset 0x1b data = 0 [
>>>>>>> 130.575158] offset 0x1c data = 1 [  130.578754] offset 0x1d data
>>>>>>> = 0 [ 130.593543] offset 0x1e data = 115 [  130.597312] offset
>>>>>>> 0x1f data = 8190
>>>>>>>
>>>>>>> We can see that BMCR and BMSR changes from 0x1100,0x7849 to
>>>>> 0x100,0x784d (BMCR[12] bit and BMSR[2]), and loop it.
>>>>>>> Above process is auto-nego enabled, link is down, auto-nego is
>>>>>>> disabled, link
>>>>> is up. And auto-nego complete bit is always 0.
>>>>>>>
>>>>>>> PHY seems become unstable if soft reset after start/config
>>>>>>> auto-nego. I also
>>>>> want to fix it in micrel driver, but failed.
>>>>>>>
>>>>>>
>>>>>> Waiting for ANEG_COMPLETE to be set wouldn't be a good option.
>>>>>> Aneg may never complete for different reasons, e.g. no physical
>>>>>> link. And even if we use a timeout this may add unwanted delays.
>>>>>>
>>>>>>> Do you have any other insights that can help me further locate the
>> issue?
>>>>> Thanks.
>>>>>>>
>>>>>>
>>>>>> I think current MAC/PHY PM handling isn't perfect. Often we have
>>>>>> the following
>>>>>> scenario:
>>>>>>
>>>>>> *suspend*
>>>>>> 1. PHY is suspended (mdio_bus_phy_suspend) 2. MAC suspend callback
>>>>>> (typically involving phy_stop())
>>>>>>
>>>>>> *resume*
>>>>>> 1. MAC resume callback (typically involving phy_start()) 2. PHY is
>>>>>> resumed (mdio_bus_phy_resume), incl. calling phy_init_hw()
>>>>>>
>>>>>> Calling phy_init_hw() after phy_start() doesn't look right.
>>>>>> It seems to work in most cases, but there's a certain risk that
>>>>>> phy_init_hw() overwrites something, e.g. the advertised modes.
>>>>>> I think we have two valid scenarios:
>>>>>>
>>>>>> 1. phylib PM callbacks are used, then the MAC driver shouldn't
>>>>>>    touch the PHY in its PM callbacks, especially not call
>>>>>>    phy_stop/phy_start.
>>>>>>
>>>>>> 2. MAC PM callbacks take care also of the PHY. Then I think we would
>>>>>>    need a flag at the phy_device telling it to make the PHY PM
>>>>>>    callbacks a no-op.
>>>>>>
>>>>>> Andrew, Russell: What do you think?
>>>>>>
>>>>>>> Best Regards,
>>>>>>> Joakim Zhang
>>>>>>>
>>>>>>> [...]
>>>>>>>
>>>>>> Heiner
>>>>>>
>>>>>
>>>>> Based on scenario 1 you can also try the following.
>>>>>
>>>>> diff --git a/drivers/net/ethernet/freescale/fec_main.c
>>>>> b/drivers/net/ethernet/freescale/fec_main.c
>>>>> index 3db882322..cdf9160fc 100644
>>>>> --- a/drivers/net/ethernet/freescale/fec_main.c
>>>>> +++ b/drivers/net/ethernet/freescale/fec_main.c
>>>>> @@ -3805,7 +3805,6 @@ static int __maybe_unused fec_suspend(struct
>>>>> device *dev)
>>>>>  	if (netif_running(ndev)) {
>>>>>  		if (fep->wol_flag & FEC_WOL_FLAG_ENABLE)
>>>>>  			fep->wol_flag |= FEC_WOL_FLAG_SLEEP_ON;
>>>>> -		phy_stop(ndev->phydev);
>>>>>  		napi_disable(&fep->napi);
>>>>>  		netif_tx_lock_bh(ndev);
>>>>>  		netif_device_detach(ndev);
>>>>> @@ -3864,7 +3863,6 @@ static int __maybe_unused fec_resume(struct
>>>>> device *dev)
>>>>>  		netif_device_attach(ndev);
>>>>>  		netif_tx_unlock_bh(ndev);
>>>>>  		napi_enable(&fep->napi);
>>>>> -		phy_start(ndev->phydev);
>>>>>  	}
>>>>>  	rtnl_unlock();
>>>>
>>>> As I described in commit message:
>>>>
>>>> "When I am debugging, I found PHY works fine if MAC doesn't support
>>> suspend/resume or phy_stop()/phy_start() doesn't been called during
>>> suspend/resume. This let me realize, PHY state machine
>>> phy_state_machine() could do something breaks the PHY."
>>>>
>>>> So I have tried your above code change before, and it works. But it
>>>> is a very
>>> common phenomenon that MAC suspend/resume invokes phy_stop/start or
>>> phylink_stop/start, and it's been around for a long time.
>>>>
>>>> As the scenarios you list, it is indeed unreasonable to soft reset
>>>> or config PHY
>>> after calling phy_start_aneg() in state machine. PHY state should be
>>> PHY_UP after calling phy_init_hw(), It seems more reasonable.
>>>>
>>>> Best Regards,
>>>> Joakim Zhang
>>>>> --
>>>>> 2.31.1
>>>>>
>>>>
>>>
>>> Following is a draft patch for scenario 1:
>>> Make PHY PM a no-op if MAC manages PHY PM.
>>> Can you give it a try?
>>>
>>
>> It can work for my case. Thanks.
> 
> I have another question, if it is possible to change the suspend/resume sequence?
> MAC should suspend before MDIO bus, and MDIO bus should resume before MAC. For some MACs, they need PHY feed clocks. It seems more reasonable.
> 

On the other hand we have cases where the PHY depends on the MAC.
If the MAC suspends first, the MDIO bus (and therefore the PHY)
may not be accessible any longer. Therefore it's not that easy. 

This speaks for my proposal to be able to make the PHY PM ops no-ops.
Then we can handle MAC + PHY PM in the MAC PM callbacks and consider
any such dependency.

I don't think we can change the PM ordering, AFAIK the PM core does it
based on registration order of devices.


> Best Regards,
> Joakim Zhang
>> Best Regards,
>> Joakim Zhang
>>> diff --git a/drivers/net/phy/phy_device.c
>>> b/drivers/net/phy/phy_device.c index a009d1769..73d29fd5e 100644
>>> --- a/drivers/net/phy/phy_device.c
>>> +++ b/drivers/net/phy/phy_device.c
>>> @@ -273,6 +273,9 @@ static __maybe_unused int
>>> mdio_bus_phy_suspend(struct device *dev)  {
>>>  	struct phy_device *phydev = to_phy_device(dev);
>>>
>>> +	if (phydev->mac_managed_pm)
>>> +		return 0;
>>> +
>>>  	/* We must stop the state machine manually, otherwise it stops out of
>>>  	 * control, possibly with the phydev->lock held. Upon resume, netdev
>>>  	 * may call phy routines that try to grab the same lock, and that
>>> may @@
>>> -294,6 +297,9 @@ static __maybe_unused int mdio_bus_phy_resume(struct
>>> device *dev)
>>>  	struct phy_device *phydev = to_phy_device(dev);
>>>  	int ret;
>>>
>>> +	if (phydev->mac_managed_pm)
>>> +		return 0;
>>> +
>>>  	if (!phydev->suspended_by_mdio_bus)
>>>  		goto no_resume;
>>>
>>> diff --git a/include/linux/phy.h b/include/linux/phy.h index
>>> 8e2cf84b2..46702af18 100644
>>> --- a/include/linux/phy.h
>>> +++ b/include/linux/phy.h
>>> @@ -567,6 +567,7 @@ struct phy_device {
>>>  	unsigned loopback_enabled:1;
>>>  	unsigned downshifted_rate:1;
>>>  	unsigned is_on_sfp_module:1;
>>> +	unsigned mac_managed_pm:1;
>>>
>>>  	unsigned autoneg:1;
>>>  	/* The most recently read link state */
>>> --
>>> 2.31.1
>>>
>>>
>>>
>>> diff --git a/drivers/net/ethernet/freescale/fec_main.c
>>> b/drivers/net/ethernet/freescale/fec_main.c
>>> index 3db882322..70aea9c27 100644
>>> --- a/drivers/net/ethernet/freescale/fec_main.c
>>> +++ b/drivers/net/ethernet/freescale/fec_main.c
>>> @@ -2048,6 +2048,8 @@ static int fec_enet_mii_probe(struct net_device
>>> *ndev)
>>>  	fep->link = 0;
>>>  	fep->full_duplex = 0;
>>>
>>> +	phy_dev->mac_managed_pm = 1;
>>> +
>>>  	phy_attached_info(phy_dev);
>>>
>>>  	return 0;
>>> @@ -3864,6 +3866,7 @@ static int __maybe_unused fec_resume(struct
>>> device *dev)
>>>  		netif_device_attach(ndev);
>>>  		netif_tx_unlock_bh(ndev);
>>>  		napi_enable(&fep->napi);
>>> +		phy_init_hw(ndev->phydev);
>>>  		phy_start(ndev->phydev);
>>>  	}
>>>  	rtnl_unlock();
>>> --
>>> 2.31.1
> 

