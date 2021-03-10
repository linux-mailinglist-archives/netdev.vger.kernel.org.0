Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87653349FB
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhCJVnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbhCJVnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 16:43:51 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86F9C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 13:43:50 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id 7so25019767wrz.0
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 13:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5ZhUZCOzWoN4DMpEjtesNdEFtIqnN0iAmbMb/2T7IhM=;
        b=UNnv9ueHKK0cw/81y8Ta0RkR8fNqpysVCgz/lM9hkweXVBZqb7XyFxst/rx7wAXyRl
         /6fcffhiWohqivIRX1NJb96BTG8Jk+zeeYHjC2W9RJeTkQ8Q6q8xZnp6Nc9bC8cyO3Zd
         75KYQOSgmXEfqPDX559k0Pz8g5TGgujaQTtu6vGhDPejqCtrn58UxWGY4xHZjXPyupMz
         BK3PYl0noGXtSvEaBm1dwBgyu23PCPYaFvMteR7uemfkNEtRDKqVJoZWtsKCxOZjqMEv
         iB2wxb0YKveG9qVYYKQLKIpclYGqy071PV4CRGE04rBYe51LBEzprNo1vl1MCI7PUjqE
         0inw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5ZhUZCOzWoN4DMpEjtesNdEFtIqnN0iAmbMb/2T7IhM=;
        b=bzcz7lgiyiJy+toj9lClkHKH8zC7HLLbdt7Jz5LJDCSb5th+kUR/DyfECpFdmuWbPr
         eoyij6ThTRF/rTAW6JWLf1kS1CgXyob08zp5Vih4f5KQ/yZ2tO9QLcFV/hcXp7x0ptBm
         eGyEjVI2163hmmlYeWQgDoUaIGO2bJfHQx4Fy6cnFOc+5mnSbR0RO9Tu8IqexDIH2O5Z
         QnEZYET0GabqU0ld07DACykfHYvgj/FbY1s/1stee4DzvOC2BjY/9pZD5r0vCUy14NfN
         i/7aPsb1Mel58F24K1DziBErpTost7wOxwMmPmz90X9/WN2i0wIarOmhESLapmBLuo7l
         L0sw==
X-Gm-Message-State: AOAM530S6vyaVlOXVrqzbnIgl64+Gu20Ds+DIaKJcxXhPECKbE3uiEwO
        PfSRDmsWJc/PMPnxA/Upt6qOFNQpyQWnbA==
X-Google-Smtp-Source: ABdhPJy15Dyt2RVxiD0R8avk3gQ3t6PlB+s+LregGR0zUPI7d0lYfWzve6B+LQgQVk4FdKLSEz4H8w==
X-Received: by 2002:a5d:4341:: with SMTP id u1mr5610495wrr.88.1615412629570;
        Wed, 10 Mar 2021 13:43:49 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:bb00:1d99:917d:ce16:eefa? (p200300ea8f1fbb001d99917dce16eefa.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:1d99:917d:ce16:eefa])
        by smtp.googlemail.com with ESMTPSA id n6sm739055wrw.63.2021.03.10.13.43.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 13:43:48 -0800 (PST)
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, kuba@kernel.org, davem@davemloft.net
References: <20210310204106.2767772-1-f.fainelli@gmail.com>
 <20210310204106.2767772-3-f.fainelli@gmail.com>
 <d2dec3e9-146a-1e07-5eb5-690b972c3315@gmail.com>
 <f7f0e6d2-447d-4b12-94f6-5e483e02ca87@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net 2/3] net: phy: broadcom: Only set BMCR.PDOWN to
 suspend
Message-ID: <c8c68a18-334b-373d-f24c-2e646b121881@gmail.com>
Date:   Wed, 10 Mar 2021 22:43:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <f7f0e6d2-447d-4b12-94f6-5e483e02ca87@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.03.2021 22:15, Florian Fainelli wrote:
> On 3/10/21 1:07 PM, Heiner Kallweit wrote:
>> On 10.03.2021 21:41, Florian Fainelli wrote:
>>> B50212E PHYs have been observed to get into an incorrect state with the
>>> visible effect of having both activity and link LEDs flashing
>>> alternatively instead of being turned off as intended when
>>> genphy_suspend() was issued. The BCM54810 is a similar design and
>>> equally suffers from that issue.
>>>
>>> The datasheet is not particularly clear whether a read/modify/write
>>> sequence is acceptable and only indicates that BMCR.PDOWN=1 should be
>>> utilized to enter the power down mode. When this was done the PHYs were
>>> always measured to have power levels that match the expectations and
>>> LEDs powered off.
>>>
>>> Fixes: fe26821fa614 ("net: phy: broadcom: Wire suspend/resume for BCM54810")
>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>> ---
>>>  drivers/net/phy/broadcom.c | 17 ++++++++++++++++-
>>>  1 file changed, 16 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
>>> index b8eb736fb456..b33ffd44f799 100644
>>> --- a/drivers/net/phy/broadcom.c
>>> +++ b/drivers/net/phy/broadcom.c
>>> @@ -388,6 +388,21 @@ static int bcm54xx_config_init(struct phy_device *phydev)
>>>  	return 0;
>>>  }
>>>  
>>> +static int bcm54xx_suspend(struct phy_device *phydev)
>>> +{
>>> +	/* We cannot perform a read/modify/write like what genphy_suspend()
>>> +	 * does because depending on the time we can observe the PHY having
>>> +	 * both of its LEDs flashing indicating that it is in an incorrect
>>> +	 * state and not powered down as expected.
>>> +	 *
>>> +	 * There is not a clear indication in the datasheet whether a
>>> +	 * read/modify/write would be acceptable, but a blind write to the
>>> +	 * register has been proven to be functional unlike the
>>> +	 * Read/Modify/Write.
>>> +	 */
>>> +	return phy_write(phydev, MII_BMCR, BMCR_PDOWN);
>>
>> This clears all other bits in MII_BMCR, incl. ANENABLE and the ones used in
>> forced mode. So you have to rely on somebody calling genphy_config_aneg()
>> to sync the register bits with the values cached in struct phy_device
>> on resume. Typically the phylib state machine takes care, but do we have
>> to consider use cases where this is not the case?
> 
> Good point, how about if we had forced the link before suspending, does
> PHYLIB take care of re-applying the same parameters? It arguably should
> do that in all cases given that power to the PHY can be cut depending on
> the suspend mode.
> 

When entering power-down mode the link is lost and we go to HALTED state.
On resume, phy_start() sets UP state and state machine calls
phy_start_aneg(), which takes care of syncing the BMCR forced mode bits.
A potential issue arises if we have a driver that doesn't use the
phylib state machine and prefers to do it on its own.
IIRC I once stumbled across this when I also relied on the phylib state
machine running in a change.
I'm not sure whether we can run into a problem, but it's worth spending
a thought before somebody complains after applying the change.
