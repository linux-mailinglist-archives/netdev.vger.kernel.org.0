Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13EC3349C0
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhCJVPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbhCJVPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 16:15:36 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDA3C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 13:15:36 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id s21so2336899pjq.1
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 13:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a5DmH7nS0LBPa0S8uLRnkFmLHn8b1TnGXl4N1l+URbo=;
        b=YEO8DEZG+xYHDbnax3rU9Jvv3plmEZ5VRinPjDBTGR9fUPiEMKM7ae1gBgVc5dWT/u
         N9kWaCdX7kLlbrgq9NnQi9LvKp4k4vVm6UdLUF8NMDBPeyEzGBp8Au7KziR5v/UKzu9D
         TuNQZAEH8B/6rOfKGp/3FF6QCHtFbKXhEhBu790ai1UiDOmh6kr2kFVpYjsoOvZ79tx7
         RMvfaREBT+ng45WhRsBDBP2LtWeqRbNVRSmPAXoDmykm35Pw9Y3MNwqvnzH+mRBgGvni
         qXdocCS3x0vgPdeXgR+z2U3K7kI2BlBf2sLuy410jM9X7/ZZZi286lS1oPdJdEyQ+1Ex
         Y0MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a5DmH7nS0LBPa0S8uLRnkFmLHn8b1TnGXl4N1l+URbo=;
        b=RIKmXUNEYb2rrM2XEUGB6c/Lx0ZKoLBPAu5r475zU2fR9urD+35QFhZBYHDQPs8XVA
         +F7LgDspIkh0ptnjOeCHVYBPpVoRdJAodMjPXszhBMj8lMTkLvZ/F9kznCkXSUtaHAlj
         wbr/e3pV1IWr14lkOGdQgT2KaTA/O80XjB9zWTssa1Gts5HchwjXIsSbktnOern7Tx1z
         BzCr/5j769/FEYOK+7iFVyXc7BTnmbFKEgyDOhNkigNs+3+dC25yBwqaZ4ZUx0znqdyy
         /zc5dJokJteyrB5/odJYl7/pxAgIkKZCPM9Hi3khxEI/tfbGHJpUAYO9w2ulgCvbVj2i
         1SJw==
X-Gm-Message-State: AOAM531VkK9Jtr6JgW9u5iNVEmG8usm5aASld7STX/kWWcNF5MpYmGAa
        qqZhZbZY/x81BxxF3teVl5s=
X-Google-Smtp-Source: ABdhPJw4zXKEDULFhZkG7nYkyf2dVt896WnQglP0JVlURVWHv6UpTO5LgHK93iMg9CnEexkFoCRv4g==
X-Received: by 2002:a17:90a:9f4a:: with SMTP id q10mr5524310pjv.129.1615410936169;
        Wed, 10 Mar 2021 13:15:36 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f2sm255131pju.46.2021.03.10.13.15.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 13:15:35 -0800 (PST)
Subject: Re: [PATCH net 2/3] net: phy: broadcom: Only set BMCR.PDOWN to
 suspend
To:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, kuba@kernel.org, davem@davemloft.net
References: <20210310204106.2767772-1-f.fainelli@gmail.com>
 <20210310204106.2767772-3-f.fainelli@gmail.com>
 <d2dec3e9-146a-1e07-5eb5-690b972c3315@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f7f0e6d2-447d-4b12-94f6-5e483e02ca87@gmail.com>
Date:   Wed, 10 Mar 2021 13:15:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <d2dec3e9-146a-1e07-5eb5-690b972c3315@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 1:07 PM, Heiner Kallweit wrote:
> On 10.03.2021 21:41, Florian Fainelli wrote:
>> B50212E PHYs have been observed to get into an incorrect state with the
>> visible effect of having both activity and link LEDs flashing
>> alternatively instead of being turned off as intended when
>> genphy_suspend() was issued. The BCM54810 is a similar design and
>> equally suffers from that issue.
>>
>> The datasheet is not particularly clear whether a read/modify/write
>> sequence is acceptable and only indicates that BMCR.PDOWN=1 should be
>> utilized to enter the power down mode. When this was done the PHYs were
>> always measured to have power levels that match the expectations and
>> LEDs powered off.
>>
>> Fixes: fe26821fa614 ("net: phy: broadcom: Wire suspend/resume for BCM54810")
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  drivers/net/phy/broadcom.c | 17 ++++++++++++++++-
>>  1 file changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
>> index b8eb736fb456..b33ffd44f799 100644
>> --- a/drivers/net/phy/broadcom.c
>> +++ b/drivers/net/phy/broadcom.c
>> @@ -388,6 +388,21 @@ static int bcm54xx_config_init(struct phy_device *phydev)
>>  	return 0;
>>  }
>>  
>> +static int bcm54xx_suspend(struct phy_device *phydev)
>> +{
>> +	/* We cannot perform a read/modify/write like what genphy_suspend()
>> +	 * does because depending on the time we can observe the PHY having
>> +	 * both of its LEDs flashing indicating that it is in an incorrect
>> +	 * state and not powered down as expected.
>> +	 *
>> +	 * There is not a clear indication in the datasheet whether a
>> +	 * read/modify/write would be acceptable, but a blind write to the
>> +	 * register has been proven to be functional unlike the
>> +	 * Read/Modify/Write.
>> +	 */
>> +	return phy_write(phydev, MII_BMCR, BMCR_PDOWN);
> 
> This clears all other bits in MII_BMCR, incl. ANENABLE and the ones used in
> forced mode. So you have to rely on somebody calling genphy_config_aneg()
> to sync the register bits with the values cached in struct phy_device
> on resume. Typically the phylib state machine takes care, but do we have
> to consider use cases where this is not the case?

Good point, how about if we had forced the link before suspending, does
PHYLIB take care of re-applying the same parameters? It arguably should
do that in all cases given that power to the PHY can be cut depending on
the suspend mode.
-- 
Florian
