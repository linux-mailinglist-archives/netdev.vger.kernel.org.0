Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C36C114F37A
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 21:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgAaU4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 15:56:36 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39715 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgAaU4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 15:56:36 -0500
Received: by mail-wr1-f66.google.com with SMTP id y11so10234900wrt.6
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 12:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J5gqFK3T+5LiPbHOhu7QHD2f0ZpsUmkr/xtGei5/lco=;
        b=H/CpXE9F1SWa1rIv9Lj7Z1kjVgFdSZQlDelslwbRIwUxtoT5iGmc2xgUs8pHPdB2Hw
         4aHPuGIbG/8gJWnS7O8e2abHMmspvbSDHb2313U8E9wvPfN+Ztk1/d1/uH9ok+gRlB6p
         fXI+A6Ffw6eROKNTSKx2k4QfS6+h2w/EaeXRQbZzTMT8jZThUGOijkxYTOObAayZQqQo
         8o1ulRt7WbGM/3DB6dcmZWDyHFB3gX9Epc7fN2bVFPhX/Y71Wm2BdqHE5Ud23sbkUdo7
         S0sj5JUfYdzCW2/mUOzaKuFBRG94XwwHoPjfYnMUv6PyG0yXUrlgU8sp7tM4qQD5Ffp3
         vFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J5gqFK3T+5LiPbHOhu7QHD2f0ZpsUmkr/xtGei5/lco=;
        b=oJhvGXgj8AzimEoVQfrZUOVEJ1d436FHJjIJhUMaIdEf7zQI1uj2XiGvw0IDEC2EOE
         oZiwo37jxzHZRqC75O3S9XUFGAGktF4uIXzRqieV9oY3pGNR7p+titzRsKjhHB0+mdlI
         NXNPgtctdUzZCRxYyYEv53RhLDU4ljiFyLd+744mfkEF6HWAYtosDp849W2SWskXLtA8
         aNupa0MlDGGb5BTSFkhsZgw6sTAlE7pwmGr127YSK3Ze5JJpumr8E9crh2WXX2MwCIIl
         NKm+JCUad+Wbh+aaM5cZ1zD2/YHrtE0sg9kGFo6EH9nn3yo0y5RMQNWTD1yZQuwOL+xk
         f7cA==
X-Gm-Message-State: APjAAAXofVWPkY2GFjidALfT+pcXy0E5dRYW9Ez+QiEWsj3T8xRZFRH4
        XQJCOGVVyLMfzkrgLaxUcqo=
X-Google-Smtp-Source: APXvYqwtX4Zf1pTou3g4l1mtmvJXgf5mZdrF41eROm6IMnY/UY8w7y8GhwwW6wpxNNFOxSNqp17Tcw==
X-Received: by 2002:adf:b352:: with SMTP id k18mr267237wrd.242.1580504193147;
        Fri, 31 Jan 2020 12:56:33 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:8922:4c51:f8d2:7862? (p200300EA8F29600089224C51F8D27862.dip0.t-ipconnect.de. [2003:ea:8f29:6000:8922:4c51:f8d2:7862])
        by smtp.googlemail.com with ESMTPSA id e17sm449508wrn.62.2020.01.31.12.56.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 12:56:32 -0800 (PST)
Subject: Re: [PATCH net v2] phy: avoid unnecessary link-up delay in polling
 mode
To:     poros@redhat.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        ivecera@redhat.com
References: <20200129101308.74185-1-poros@redhat.com>
 <20200129121955.168731-1-poros@redhat.com>
 <69228855-7551-fc3c-06c5-2c1d9d20fe0c@gmail.com>
 <7d2c26ac18d0ce7b76024fec86a9b1a084ad3fd3.camel@redhat.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <414b2dc1-2421-e4c8-ea81-1177545fb327@gmail.com>
Date:   Fri, 31 Jan 2020 21:50:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <7d2c26ac18d0ce7b76024fec86a9b1a084ad3fd3.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.01.2020 16:09, Petr Oros wrote:
> Heiner Kallweit píše v St 29. 01. 2020 v 22:01 +0100:
>> On 29.01.2020 13:19, Petr Oros wrote:
>>> commit 93c0970493c71f ("net: phy: consider latched link-down status in
>>> polling mode") removed double-read of latched link-state register for
>>> polling mode from genphy_update_link(). This added extra ~1s delay into
>>> sequence link down->up.
>>> Following scenario:
>>>  - After boot link goes up
>>>  - phy_start() is called triggering an aneg restart, hence link goes
>>>    down and link-down info is latched.
>>>  - After aneg has finished link goes up. In phy_state_machine is checked
>>>    link state but it is latched "link is down". The state machine is
>>>    scheduled after one second and there is detected "link is up". This
>>>    extra delay can be avoided when we keep link-state register double read
>>>    in case when link was down previously.
>>>
>>> With this solution we don't miss a link-down event in polling mode and
>>> link-up is faster.
>>>
>>
>> I have a little problem to understand why it should be faster this way.
>> Let's take an example: aneg takes 3.5s
>> Current behavior:
>>
>> T0: aneg is started, link goes down, link-down status is latched
>>     (phydev->link is still 1)
>> T0+1s: state machine runs, latched link-down is read,
>>        phydev->link goes down, state change PHY_UP to PHY_NOLINK
>> T0+2s: state machine runs, up-to-date link-down is read
>> T0+3s: state machine runs, up-to-date link-down is read
>> T0+4s: state machine runs, aneg is finished, up-to-date link-up is read,
>>        phydev->link goes up, state change PHY_NOLINK to PHY_RUNNING
>>
>> Your patch changes the behavior of T0+1s only. So it should make a
>> difference only if aneg takes less than 1s.
>> Can you explain, based on the given example, how your change is
>> supposed to improve this?
>>
> 
> 
> I see this behavior on real hw:
> With patch:
> T0+3s: state machine runs, up-to-date link-down is read
> T0+4s: state machine runs, aneg is finished (BMSR_ANEGCOMPLETE==1),
>        first BMSR read: BMSR_ANEGCOMPLETE==1 and BMSR_LSTATUS==0,
>        second BMSR read: BMSR_ANEGCOMPLETE==1 and BMSR_LSTATUS==1,
>        phydev->link goes up, state change PHY_NOLINK to PHY_RUNNING
> 
> line: 1917 is first BMSR read
> line: 1921 is second BMSR read
> 
> [   24.124572] xgene-mii-rgmii:03: genphy_restart_aneg()
> [   24.132000] xgene-mii-rgmii:03: genphy_update_link(), line: 1895, link: 0
> [   24.139347] xgene-mii-rgmii:03: genphy_update_link(), line: 1917, status:
> 0x7949
> [   24.146783] xgene-mii-rgmii:03: genphy_update_link(), line: 1921, status:
> 0x7949
> [   24.154174] xgene-mii-rgmii:03: genphy_update_link(), line: 1927, link: 0
> 
> . supressed 3 same messages in T0+1,2,3s
> 
> [   28.609822] xgene-mii-rgmii:03: genphy_update_link(), line: 1895, link: 0
> [   28.629906] xgene-mii-rgmii:03: genphy_update_link(), line: 1917, status:
> 0x7969
> ^^^^^^^^^^^^^^^ detected BMSR_ANEGCOMPLETE but not BMSR_LSTATUS
> [   28.644590] xgene-mii-rgmii:03: genphy_update_link(), line: 1921, status:
> 0x796d
> ^^^^^^^^^^^^^^^ here is detected BMSR_ANEGCOMPLETE and BMSR_LSTATUS
> [   28.658681] xgene-mii-rgmii:03: genphy_update_link(), line: 1927, link: 1
> 

I see, thanks. Strange behavior of the PHY. Did you test also with other PHY's
whether they behave the same?

> --------------------------------------------------------------------------------
> ---
> 
> Without patch:
> T0+3s: state machine runs, up-to-date link-down is read
> T0+4s: state machine runs, aneg is finished (BMSR_ANEGCOMPLETE==1),
>        here i read link-down (BMSR_LSTATUS==0),
> T0+5s: state machine runs, aneg is finished (BMSR_ANEGCOMPLETE==1),
>        up-to-date link-up is read (BMSR_LSTATUS==1),
>        phydev->link goes up, state change PHY_NOLINK to PHY_RUNNING
> 
> line: 1917 is first BMSR read (status is zero because without patch it is readed
> once)
> line: 1921 is second BMSR read
> 
> [   24.862702] xgene-mii-rgmii:03: 1768: genphy_restart_aneg
> [   24.869070] xgene-mii-rgmii:03: genphy_update_link(), line: 1895, link: 0
> [   24.876409] xgene-mii-rgmii:03: genphy_update_link(), line: 1917, status: 0x0
> [   24.885999] xgene-mii-rgmii:03: genphy_update_link(), line: 1921, status:
> 0x7949
> [   24.893401] xgene-mii-rgmii:03: genphy_update_link(), line: 1927, link: 0
> 
> . supressed 3 same messages in T0+1,2,3s
> 
> [   29.319613] xgene-mii-rgmii:03: genphy_update_link(), line: 1895, link: 0
> [   29.326408] xgene-mii-rgmii:03: genphy_update_link(), line: 1917, status: 0x0
> [   29.333557] xgene-mii-rgmii:03: genphy_update_link(), line: 1921, status:
> 0x7969
> ^^^^^^^^^^^^^^^ detected BMSR_ANEGCOMPLETE but not BMSR_LSTATUS
> [   29.340923] xgene-mii-rgmii:03: genphy_update_link(), line: 1927, link: 0
> 
> [   30.359713] xgene-mii-rgmii:03: genphy_update_link(), line: 1895, link: 0
> [   30.366507] xgene-mii-rgmii:03: genphy_update_link(), line: 1917, status: 0x0
> [   30.373650] xgene-mii-rgmii:03: genphy_update_link(), line: 1921, status:
> 0x796d
> ^^^^^^^^^^^^^^^ here is detected BMSR_ANEGCOMPLETE and BMSR_LSTATUS
> [   30.381016] xgene-mii-rgmii:03: genphy_update_link(), line: 1927, link: 1
> 
> I tried many variants and it is deterministic behavior. Without patch is delay
> one second longer due to later detect link up after aneg finish
> 
> -Petr
> 
> 
>> And on a side note: I wouldn't consider this change a fix, therefore
>> it would be material for net-next that is closed at the moment.
>>
>> Heiner
>>
>>> Changes in v2:
>>> - Fixed typos in phy_polling_mode() argument
>>>
>>> Fixes: 93c0970493c71f ("net: phy: consider latched link-down status in polling mode")
>>> Signed-off-by: Petr Oros <poros@redhat.com>
>>> ---
>>>  drivers/net/phy/phy-c45.c    | 5 +++--
>>>  drivers/net/phy/phy_device.c | 5 +++--
>>>  2 files changed, 6 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
>>> index a1caeee1223617..bceb0dcdecbd61 100644
>>> --- a/drivers/net/phy/phy-c45.c
>>> +++ b/drivers/net/phy/phy-c45.c
>>> @@ -239,9 +239,10 @@ int genphy_c45_read_link(struct phy_device *phydev)
>>>  
>>>  		/* The link state is latched low so that momentary link
>>>  		 * drops can be detected. Do not double-read the status
>>> -		 * in polling mode to detect such short link drops.
>>> +		 * in polling mode to detect such short link drops except
>>> +		 * the link was already down.
>>>  		 */
>>> -		if (!phy_polling_mode(phydev)) {
>>> +		if (!phy_polling_mode(phydev) || !phydev->link) {
>>>  			val = phy_read_mmd(phydev, devad, MDIO_STAT1);
>>>  			if (val < 0)
>>>  				return val;
>>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>>> index 6a5056e0ae7757..05417419c484fa 100644
>>> --- a/drivers/net/phy/phy_device.c
>>> +++ b/drivers/net/phy/phy_device.c
>>> @@ -1930,9 +1930,10 @@ int genphy_update_link(struct phy_device *phydev)
>>>  
>>>  	/* The link state is latched low so that momentary link
>>>  	 * drops can be detected. Do not double-read the status
>>> -	 * in polling mode to detect such short link drops.
>>> +	 * in polling mode to detect such short link drops except
>>> +	 * the link was already down.
>>>  	 */
>>> -	if (!phy_polling_mode(phydev)) {
>>> +	if (!phy_polling_mode(phydev) || !phydev->link) {
>>>  		status = phy_read(phydev, MII_BMSR);
>>>  		if (status < 0)
>>>  			return status;
>>>
> 
> 

