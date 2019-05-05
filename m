Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D80851429C
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 00:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbfEEWAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 18:00:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35863 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfEEWAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 18:00:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id n25so629350wmi.1
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 15:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IUmgFC5Hr3TFhUp5EcDjdtmxJD5BsWEMn5rPzzaHQAA=;
        b=oQNVVrAe1geIcO/WIHTJrdMYObbEbPbpLuEI9qjV4rlf9lUZUHEEsacbGTL48KbESA
         NdFOVRDxb4Wtezbu9qvCQ3odObfUbLYIqf5pbBn4I7BlfaAib31bwL107Scb6zzZoNEU
         VuKMUl0c1yRub/x8rwhsXVusO7YkJrVJa8cnj2Trb2C97LWeln0pOsgDwPvCq1RP+sMY
         8/1i3TNoOV3ehTIx9RvZbYk/dF26sl8fpd26L4Y/KLOg5DJ+qYBSRsMO7zuSRkB7qft8
         BooXsuZ1B1J2wgN3uMY47ms/BgR3OQLu6Cl8pD5CdO30pnwrq5b19zsP8eioqLlxiA8p
         RAew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IUmgFC5Hr3TFhUp5EcDjdtmxJD5BsWEMn5rPzzaHQAA=;
        b=JD2umCwfFe2kuiGMivmzACMy++fQLX43iy5CbWH3h9XktUjlJgqH9ZC7miQUpQnclQ
         0BDX9M+BLbQXTwQjeTG2oLN7gEySmqGdTcCHyaob28LriyIRtICRjO4Lw7kh/zccbLy0
         Xs4BK2kPKK5QfU3ObHUryaRZjrJodjeVOYKCkKEt6WZOgIZVRx3il+RaBe04KTuSm3z+
         ufxsQuFDr74aCsk8lv9kZh94j4bhF+ISymdbyzybu6VQ3yVnM76raAFF4HInxA6iOsXE
         +cSjVXZ81Qz7NN8EATbycm7BCedcOUGUjTfo+Al5v0hAJCEz1mT+S4WkYRcign9tmAyV
         IPiQ==
X-Gm-Message-State: APjAAAUPJA4sW9Cl7Kd1ihA6aT+OAuDOJk3Ar5ZpciOZpdxFYeE//dFN
        73SerZPb6cMluP9qa0O6P+1oiO6+
X-Google-Smtp-Source: APXvYqwNlGR7o/4WZojh2tyoyjynyOnLIycn+xrGKEMbWhjUme0Y1C9Pp480blkqHC8K7IWTD2nIzw==
X-Received: by 2002:a1c:99d5:: with SMTP id b204mr13741735wme.141.1557093651357;
        Sun, 05 May 2019 15:00:51 -0700 (PDT)
Received: from [192.168.1.2] (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id c139sm16507449wmd.26.2019.05.05.15.00.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 15:00:50 -0700 (PDT)
Subject: Decoupling phy_device from net_device (was "Re: [PATCH] net: dsa:
 fixed-link interface is reporting SPEED_UNKNOWN")
To:     Heiner Kallweit <hkallweit1@gmail.com>, f.fainelli@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190411230139.13160-1-olteanv@gmail.com>
 <3661ec3f-1a13-26d8-f7dc-7a73ac210f08@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Message-ID: <a10e3ef7-2928-8865-c463-f9edc7261410@gmail.com>
Date:   Mon, 6 May 2019 01:00:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <3661ec3f-1a13-26d8-f7dc-7a73ac210f08@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/12/19 8:57 PM, Heiner Kallweit wrote:
> On 12.04.2019 01:01, Vladimir Oltean wrote:
>> With Heiner's recent patch "b6163f194c69 net: phy: improve
>> genphy_read_status", the phydev->speed is now initialized by default to
>> SPEED_UNKNOWN even for fixed PHYs. This is not necessarily bad, since it
>> is not correct to call genphy_config_init() and genphy_read_status() for
>> a fixed PHY.
>>
> What do you mean with "it is not correct"? Whether the calls are always
> needed may be a valid question, but it's not forbidden to use these calls
> with a fixed PHY. Actually in phylib polling mode genphy_read_status is
> called every second also for a fixed PHY. swphy emulates all relevant
> PHY registers.
> 
>> This dates back all the way to "39b0c705195e net: dsa: Allow
>> configuration of CPU & DSA port speeds/duplex" (discussion thread:
>> https://www.spinics.net/lists/netdev/msg340862.html).
>>
>> I don't seem to understand why these calls were necessary back then, but
>> removing these calls seemingly has no impact now apart from preventing
>> the phydev->speed that was set in of_phy_register_fixed_link() from
>> getting overwritten.
>>
> I tend to agree with the change itself, but not with the justification.
> For genphy_config_init I'd rather say:
> genphy_config_init removes invalid modes based on the abilities read
> from the chip. But as we emulate all registers anyway, this doesn't
> provide any benefit for a swphy.
> 
>> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
>> ---
>>   net/dsa/port.c | 3 ---
>>   1 file changed, 3 deletions(-)
>>
>> diff --git a/net/dsa/port.c b/net/dsa/port.c
>> index 87769cb38c31..481412c892a7 100644
>> --- a/net/dsa/port.c
>> +++ b/net/dsa/port.c
>> @@ -485,9 +485,6 @@ static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
>>   		mode = PHY_INTERFACE_MODE_NA;
>>   	phydev->interface = mode;
>>   
>> -	genphy_config_init(phydev);
>> -	genphy_read_status(phydev);
>> -
>>   	if (ds->ops->adjust_link)
>>   		ds->ops->adjust_link(ds, port, phydev);
>>   
>>
> 

Hi,

I'd like to resend this, but I'm actually thinking of a nicer way to 
deal with the whole situation.
Would people be interested in making phylib/phylink decoupled from the 
phydev->attached_dev? The PHY state machine could be made to simply call 
a notifier block (similar to how switchdev works) registered by 
interested parties (MAC driver).
To keep API compatibility (phylink_create), this notifier block could be 
put inside the net_device structure and the PHY state machine would call 
it. But a new phylink_create_raw could be added, which passes only the 
notifier block with no net_device. The CPU port and DSA ports would be 
immediate and obvious users of this (since they don't register net 
devices), but there are some other out-of-tree Ethernet drivers out 
there that have strange workarounds (create a net device that they don't 
register) to have the PHY driver do its work.
Wondering what's your opinion on this and if it would be worth exploring.

Thanks,
-Vladimir
