Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57509336AB7
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 04:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhCKDbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 22:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhCKDbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 22:31:23 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65892C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 19:31:23 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id g4so12777177pgj.0
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 19:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dDs4qsFHVKqF+qWC9HUMHvcmVxJ/+MSDMy6QHn89jFQ=;
        b=hN2DIID81Sev65sWVxU0KBZkK/I2EKb2D6EGugJz2WF+j/aSE75e/X9pYoAtLZQdYE
         JFdgktGY9knR1cpRRaDP5jVdy0alq0OGeJl+Rbo2gtNneCdcWDRA+/iHflfdKaue0wvd
         CgXeht5Q53zkuUQAqai5ZSP2WkPftVcJzJ3rOWdW52rHNT/BqhprLB434tfoczc/9Bir
         sD/P3V2eEE5AO16AtaUgksS7GRqq3m4/vaNdyjxw2I1dI25zwrtI4pSLW6iMdJvzohec
         cUuYJprIwC2mODmLNVNJW65Wo0M+GzGdUAz/WSzBUNOfrdK18cYYhQPdMD9qrxeFinVm
         0DiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dDs4qsFHVKqF+qWC9HUMHvcmVxJ/+MSDMy6QHn89jFQ=;
        b=hpMsxFrUgkVJufIfRD99d4fsEZPYeCXqF8hrgJcNmiGMRd0YPW5TEV6G0v6lxhBDaD
         o3bZHCzUsl7MHCiV2oB5HrAFvGmJ17asVmWNEeiH3zitvrD9Nf9gRcLhEKWVuOwKNuYv
         ezqWA1O4aZx21rrtAoY3aisEwWqlcVCWnC+DNK74XxT0geCQnWhO13uqYBiXwmJn6gJV
         8swJtvrxSGt3w7UyFH8jKUz1N1DlnEJobpGxCtlTuwCuEluH2tq+5B+3RiK0cLWY5YiR
         rtuTHSIKRKCYu+Jpeed7v7ITGpxW5s83aL2o0uWLsY8FFGmTwt9iUbBNTcs+5RtSExcu
         b3YQ==
X-Gm-Message-State: AOAM532Ke6vd8blUoAiPszkaMrLWUOTV3kuQCD3cenHxxNwvtkMTfiJ8
        t2sp8ULz8FqBmi7QSa4Igzo=
X-Google-Smtp-Source: ABdhPJxs8QxnQUyjbI0QpCCS5W/QRjfvcRyA7114ED4blkrvUxjtshxucR15TdocduQ9qBpZyQH4og==
X-Received: by 2002:a63:5044:: with SMTP id q4mr5392090pgl.178.1615433482873;
        Wed, 10 Mar 2021 19:31:22 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q205sm865019pfc.126.2021.03.10.19.31.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 19:31:22 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net 2/3] net: phy: broadcom: Only set BMCR.PDOWN to
 suspend
To:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, kuba@kernel.org, davem@davemloft.net
References: <20210310204106.2767772-1-f.fainelli@gmail.com>
 <20210310204106.2767772-3-f.fainelli@gmail.com>
 <d2dec3e9-146a-1e07-5eb5-690b972c3315@gmail.com>
 <f7f0e6d2-447d-4b12-94f6-5e483e02ca87@gmail.com>
 <c8c68a18-334b-373d-f24c-2e646b121881@gmail.com>
 <ddb8b1f3-73ad-0d63-6022-69046cb15497@gmail.com>
Message-ID: <8a2d96d8-826f-00cc-888c-450abad858f1@gmail.com>
Date:   Wed, 10 Mar 2021 19:31:20 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <ddb8b1f3-73ad-0d63-6022-69046cb15497@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 2:56 PM, Florian Fainelli wrote:
> On 3/10/21 1:43 PM, Heiner Kallweit wrote:
>> On 10.03.2021 22:15, Florian Fainelli wrote:
>>> On 3/10/21 1:07 PM, Heiner Kallweit wrote:
>>>> On 10.03.2021 21:41, Florian Fainelli wrote:
>>>>> B50212E PHYs have been observed to get into an incorrect state with the
>>>>> visible effect of having both activity and link LEDs flashing
>>>>> alternatively instead of being turned off as intended when
>>>>> genphy_suspend() was issued. The BCM54810 is a similar design and
>>>>> equally suffers from that issue.
>>>>>
>>>>> The datasheet is not particularly clear whether a read/modify/write
>>>>> sequence is acceptable and only indicates that BMCR.PDOWN=1 should be
>>>>> utilized to enter the power down mode. When this was done the PHYs were
>>>>> always measured to have power levels that match the expectations and
>>>>> LEDs powered off.
>>>>>
>>>>> Fixes: fe26821fa614 ("net: phy: broadcom: Wire suspend/resume for BCM54810")
>>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>>> ---
>>>>>  drivers/net/phy/broadcom.c | 17 ++++++++++++++++-
>>>>>  1 file changed, 16 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
>>>>> index b8eb736fb456..b33ffd44f799 100644
>>>>> --- a/drivers/net/phy/broadcom.c
>>>>> +++ b/drivers/net/phy/broadcom.c
>>>>> @@ -388,6 +388,21 @@ static int bcm54xx_config_init(struct phy_device *phydev)
>>>>>  	return 0;
>>>>>  }
>>>>>  
>>>>> +static int bcm54xx_suspend(struct phy_device *phydev)
>>>>> +{
>>>>> +	/* We cannot perform a read/modify/write like what genphy_suspend()
>>>>> +	 * does because depending on the time we can observe the PHY having
>>>>> +	 * both of its LEDs flashing indicating that it is in an incorrect
>>>>> +	 * state and not powered down as expected.
>>>>> +	 *
>>>>> +	 * There is not a clear indication in the datasheet whether a
>>>>> +	 * read/modify/write would be acceptable, but a blind write to the
>>>>> +	 * register has been proven to be functional unlike the
>>>>> +	 * Read/Modify/Write.
>>>>> +	 */
>>>>> +	return phy_write(phydev, MII_BMCR, BMCR_PDOWN);
>>>>
>>>> This clears all other bits in MII_BMCR, incl. ANENABLE and the ones used in
>>>> forced mode. So you have to rely on somebody calling genphy_config_aneg()
>>>> to sync the register bits with the values cached in struct phy_device
>>>> on resume. Typically the phylib state machine takes care, but do we have
>>>> to consider use cases where this is not the case?
>>>
>>> Good point, how about if we had forced the link before suspending, does
>>> PHYLIB take care of re-applying the same parameters? It arguably should
>>> do that in all cases given that power to the PHY can be cut depending on
>>> the suspend mode.
>>>
>>
>> When entering power-down mode the link is lost and we go to HALTED state.
>> On resume, phy_start() sets UP state and state machine calls
>> phy_start_aneg(), which takes care of syncing the BMCR forced mode bits.
>> A potential issue arises if we have a driver that doesn't use the
>> phylib state machine and prefers to do it on its own.
>> IIRC I once stumbled across this when I also relied on the phylib state
>> machine running in a change.
>> I'm not sure whether we can run into a problem, but it's worth spending
>> a thought before somebody complains after applying the change.
> 
> That is a fair point, I could save the BMCR before modifying it and
> restore it in bcm54xx_resume() and phy_start_aneg() should not issue an
> additional re-negotiation in that case. Let me explore a bit more to
> find out which of these BMCR bits makes the PHY go bonkers.

I re-tested with different kernels and was convinced that the
problem I saw due to the lack of locking in the 4.9 kernel around
phydrv->suspend() since 4.9 was where I started working on this. It
turns out this was reproducible with different kernel versions as well
so there is really something that is possibly specific to the BCM54810
PHY and the specific design.

I will run more tests to get to the bottom of this hopefully.
-- 
Florian
