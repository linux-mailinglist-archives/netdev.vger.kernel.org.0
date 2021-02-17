Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4912531E020
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 21:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbhBQUWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 15:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbhBQUWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 15:22:37 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF0BC061574
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 12:21:57 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id s16so4123609plr.9
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 12:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AarxRd7mh8Y2QeV684GLzPc5OfxvgHDmodBzIV70CFU=;
        b=OudmF9Ervi+aW91ACjzmG2Pgz6ScZcsI2YTSY8OoAFX8IMJH0asFT90dBnHkwbYfpN
         Qs+KYbFoIIsF4/w6/p76QJTkZr8hoKv9EZvyXJz3qeBgKSNv1UrV8K+c0nI3iM24ZZbV
         8Cf3UPzQEfDWeJ5MPz8HENRbqQtMBeLCcvss1m7vZVhFcvrnBb30ppFjisLpYsh3bdkX
         gbxw7IVr9CNzOU9yCX3gIfm2xmHrEhsfLFO3PHOUAoDvVkD1MsTBuP8r3xoYveyQhnxV
         ZE1MC+If1qNFZW55ZIfkntLc2hrN26Hs0CtjTFo2Zu/mRFJDyOHZvi6cDH0gFPBMoc1g
         C+xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AarxRd7mh8Y2QeV684GLzPc5OfxvgHDmodBzIV70CFU=;
        b=I3sDB3EI51T7ijAK10vzND2d3KzrA57+6P49IwrJYX1A0oJJdCIzVUiZE2vSk7pPjW
         bA91pDOIETqiBbtsDdjLpuYKllO7DB5TGM7G9cLgIHyootx9WfuavjTJn0TV+mhRFsJc
         P8XChquj5OfWD5ZgSWk8wLXx3gi948JbQJVkqo3/+b0HVVmDJxzAt+ZO3U6sNbINmZMf
         LN8vSoYtJHtHwpMm1k+Lo5YEgYyMfgJ06cz1Tw0MrHrdrgLhBm1em0oyKUN0BAzu/4+J
         Wfzy+iH0dv3Shn7rmkT8G4Fxuo3UrlrDcKYoyfoH7/iacL5X9TAEkG6wqvzfOwJyH/j1
         LZVQ==
X-Gm-Message-State: AOAM532sOSkmjvtrtZ6if1LJ1pQIT/ovTSfvLpR+hDsPgOp3vOSO/MX4
        PY2SxyYkEbTK5f2DECodjXjLeQjZNss=
X-Google-Smtp-Source: ABdhPJx4qo2rGEYEX8aED7P1xmDmUpxrHK78ONJzRe8DJ4h7JKZUFw3T3R45u+v5WwK2NmligSiQ6Q==
X-Received: by 2002:a17:90a:c684:: with SMTP id n4mr548962pjt.13.1613593316040;
        Wed, 17 Feb 2021 12:21:56 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c69sm3320251pfb.88.2021.02.17.12.21.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Feb 2021 12:21:55 -0800 (PST)
Subject: Re: [PATCH net-next v4 2/3] net: phy: Add is_on_sfp_module flag and
 phy_on_sfp helper
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Robert Hancock <robert.hancock@calian.com>, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
References: <20210216225454.2944373-1-robert.hancock@calian.com>
 <20210216225454.2944373-3-robert.hancock@calian.com>
 <YCyUYqPt1X37bqpI@lunn.ch> <20210217103455.GF1463@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e5f69b4f-ec4a-665e-2d0f-957c695b59bf@gmail.com>
Date:   Wed, 17 Feb 2021 12:21:53 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210217103455.GF1463@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/17/2021 2:34 AM, Russell King - ARM Linux admin wrote:
> On Wed, Feb 17, 2021 at 04:58:26AM +0100, Andrew Lunn wrote:
>> On Tue, Feb 16, 2021 at 04:54:53PM -0600, Robert Hancock wrote:
>>> Add a flag and helper function to indicate that a PHY device is part of
>>> an SFP module, which is set on attach. This can be used by PHY drivers
>>> to handle SFP-specific quirks or behavior.
>>>
>>> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
>>> ---
>>>  drivers/net/phy/phy_device.c |  2 ++
>>>  include/linux/phy.h          | 11 +++++++++++
>>>  2 files changed, 13 insertions(+)
>>>
>>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>>> index 05261698bf74..d6ac3ed38197 100644
>>> --- a/drivers/net/phy/phy_device.c
>>> +++ b/drivers/net/phy/phy_device.c
>>> @@ -1377,6 +1377,8 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
>>>  
>>>  		if (phydev->sfp_bus_attached)
>>>  			dev->sfp_bus = phydev->sfp_bus;
>>> +		else if (dev->sfp_bus)
>>> +			phydev->is_on_sfp_module = true;
>>
>> I get lost here. It this correct?
>>
>> We have setups with two PHY. The marvell10g PHY can play the role of
>> media converter. It converts the signal from the MAC into signals
>> which can be connected to an SFP cage.
>>
>> And then inside the cage, we can have a copper module with a second
>> PHY. It is this second PHY which we need to indicate is_on_sfp_module
>> true.
> 
> We don't support that setup, at least at the moment. There's no support
> for stacking PHYs precisely because we have the net_device structure
> containing a pointer to the PHY (which will be the first PHY in the
> chain.) That has the effect of making the second PHY inaccessible to the
> normal network APIs.
> 
>> We probably want to media convert PHYs LEDs to work, since those
>> possible are connected to the front panel. So this needs to be
>> specific to the SFP module PHY, and i'm not sure it is. Russell?
> 
> The main reason I'm hessitant with using the net_device structure
> to detect this is that we know that phylink has been converted to
> work without the net_device structure - it will be NULL. This includes
> attaching the "primary" PHY - phylib will be given a NULL net_device.
> 
> The good news is that if a SFP cage is attempted to be attached in
> that situation, phylink will oops in phylink_sfp_attach(). So it
> isn't something that we support. However, the point is that we can
> end up in situations where phylib has a NULL net_device.
> 
> Florian mentioned in response to one of my previous emails that he's
> working on sorting out the phylib dev_flags - I think we should wait
> for that to be resolved first, so we can allocate a dev_flag (or
> maybe we can do that already today?) that says "this PHY is part of
> a SFP module". That will give us a clearly defined positive condition
> that is more maintainable into the future.

We could be allocating a generic flag today starting from bit 31 and
down and that would certainly be fine without necessarily making my
rework any harder.

The existing issues with phydev->dev_flags as I am sure you are all
aware is that the flags are not name-spaced per driver yet all Ethernet
MAC drivers make assumptions (tg3.c, bcmgenet.c, etc.) and it is not
possible to pass arbitrary configuration settings down the PHY driver,
etc.  I would not hold my breath on this rework as I keep getting sucked
into various issues at work.

FWIW, this series appears to have already been applied.
-- 
Florian
