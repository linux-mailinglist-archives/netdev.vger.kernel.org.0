Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F58D334C10
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 23:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbhCJW4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 17:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbhCJW4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 17:56:11 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10652C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 14:56:11 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso8339785pjb.4
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 14:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=713NPQvml1s/M2aK5I+UC+V2qUho8WCRIx0c79g6DqE=;
        b=F/Vf/D0Uv/XFhxX02Z1jR3gq336/QAljOU/iPDe6k5qHiKU0Wdzqbi6xn3h9oLPboV
         iJ/opczWrY/y/6seaQKEs8PnO9itvKg7doW0g5Xrbl/mUqLDC/fbR7ieZrR2QffyRuMw
         tLujfG993CXbXMFOx2tJbLZYAhBHv+B+MFxUNs5qk/P1/vUjP8r8k+y7rd8I9uJWhQiY
         6znkP7tS6MVmR1ITsa0bTY+JV6ZVFaw9oRJBEb2eSBzj44g7H9uhcjghSwsohPHRk3UG
         PB7kWLXIrhkUfQdXMf0syzLOUYCIg1vdgd3COr7n+rRsN4QwEW5Wf5e3+Zxg+3yp8gNR
         cPuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=713NPQvml1s/M2aK5I+UC+V2qUho8WCRIx0c79g6DqE=;
        b=kOtB0Tk3UDDj9+AsgwqOFpg3QnRscTucvDPU2zxP92Dvs2Dvw2p3jRcDFc0Tg/S+v3
         GSjD9X6+ULUcjY8LgdBEKRuabywo78T6nqRiRaU4eoV5aY941814ymj7lIWErfmUSn2r
         G9LCANOpKXH2C6bDF2PinhSirJ/8enNo3P9YHvYa3psgxT1212rEy/XTjla6BXIguv0h
         ciyFVf3j7+8fXMWNQdq88jEsXQEX8bcSaht4XwyNa+IzNoqvtnNwJnQJV3XuRnn22kZu
         /ud5TKIBEu2VS5rH+hegHeCNJu6gut9XBdUPcVu06sPe5Voo4CDIlV7EXyRMNhZVaoEK
         7n3Q==
X-Gm-Message-State: AOAM530A3jSWGzBNzOF/fJBFo772OZ0brra3HhkvS5X7qFFueKXJT8iG
        aODiFis0Dys/nS1H6R18up8=
X-Google-Smtp-Source: ABdhPJy/GeWVgK4bLNnrN7uZxVvbe3DC/wLGeZ016TD6maEtDpu/rM+hvby91zSf5T70WvfPawxgqQ==
X-Received: by 2002:a17:902:ff15:b029:e4:51ae:e1ee with SMTP id f21-20020a170902ff15b02900e451aee1eemr4983745plj.83.1615416970490;
        Wed, 10 Mar 2021 14:56:10 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a20sm506089pfl.97.2021.03.10.14.56.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 14:56:10 -0800 (PST)
Subject: Re: [PATCH net 2/3] net: phy: broadcom: Only set BMCR.PDOWN to
 suspend
To:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, kuba@kernel.org, davem@davemloft.net
References: <20210310204106.2767772-1-f.fainelli@gmail.com>
 <20210310204106.2767772-3-f.fainelli@gmail.com>
 <d2dec3e9-146a-1e07-5eb5-690b972c3315@gmail.com>
 <f7f0e6d2-447d-4b12-94f6-5e483e02ca87@gmail.com>
 <c8c68a18-334b-373d-f24c-2e646b121881@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ddb8b1f3-73ad-0d63-6022-69046cb15497@gmail.com>
Date:   Wed, 10 Mar 2021 14:56:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <c8c68a18-334b-373d-f24c-2e646b121881@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 1:43 PM, Heiner Kallweit wrote:
> On 10.03.2021 22:15, Florian Fainelli wrote:
>> On 3/10/21 1:07 PM, Heiner Kallweit wrote:
>>> On 10.03.2021 21:41, Florian Fainelli wrote:
>>>> B50212E PHYs have been observed to get into an incorrect state with the
>>>> visible effect of having both activity and link LEDs flashing
>>>> alternatively instead of being turned off as intended when
>>>> genphy_suspend() was issued. The BCM54810 is a similar design and
>>>> equally suffers from that issue.
>>>>
>>>> The datasheet is not particularly clear whether a read/modify/write
>>>> sequence is acceptable and only indicates that BMCR.PDOWN=1 should be
>>>> utilized to enter the power down mode. When this was done the PHYs were
>>>> always measured to have power levels that match the expectations and
>>>> LEDs powered off.
>>>>
>>>> Fixes: fe26821fa614 ("net: phy: broadcom: Wire suspend/resume for BCM54810")
>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>> ---
>>>>  drivers/net/phy/broadcom.c | 17 ++++++++++++++++-
>>>>  1 file changed, 16 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
>>>> index b8eb736fb456..b33ffd44f799 100644
>>>> --- a/drivers/net/phy/broadcom.c
>>>> +++ b/drivers/net/phy/broadcom.c
>>>> @@ -388,6 +388,21 @@ static int bcm54xx_config_init(struct phy_device *phydev)
>>>>  	return 0;
>>>>  }
>>>>  
>>>> +static int bcm54xx_suspend(struct phy_device *phydev)
>>>> +{
>>>> +	/* We cannot perform a read/modify/write like what genphy_suspend()
>>>> +	 * does because depending on the time we can observe the PHY having
>>>> +	 * both of its LEDs flashing indicating that it is in an incorrect
>>>> +	 * state and not powered down as expected.
>>>> +	 *
>>>> +	 * There is not a clear indication in the datasheet whether a
>>>> +	 * read/modify/write would be acceptable, but a blind write to the
>>>> +	 * register has been proven to be functional unlike the
>>>> +	 * Read/Modify/Write.
>>>> +	 */
>>>> +	return phy_write(phydev, MII_BMCR, BMCR_PDOWN);
>>>
>>> This clears all other bits in MII_BMCR, incl. ANENABLE and the ones used in
>>> forced mode. So you have to rely on somebody calling genphy_config_aneg()
>>> to sync the register bits with the values cached in struct phy_device
>>> on resume. Typically the phylib state machine takes care, but do we have
>>> to consider use cases where this is not the case?
>>
>> Good point, how about if we had forced the link before suspending, does
>> PHYLIB take care of re-applying the same parameters? It arguably should
>> do that in all cases given that power to the PHY can be cut depending on
>> the suspend mode.
>>
> 
> When entering power-down mode the link is lost and we go to HALTED state.
> On resume, phy_start() sets UP state and state machine calls
> phy_start_aneg(), which takes care of syncing the BMCR forced mode bits.
> A potential issue arises if we have a driver that doesn't use the
> phylib state machine and prefers to do it on its own.
> IIRC I once stumbled across this when I also relied on the phylib state
> machine running in a change.
> I'm not sure whether we can run into a problem, but it's worth spending
> a thought before somebody complains after applying the change.

That is a fair point, I could save the BMCR before modifying it and
restore it in bcm54xx_resume() and phy_start_aneg() should not issue an
additional re-negotiation in that case. Let me explore a bit more to
find out which of these BMCR bits makes the PHY go bonkers.

Thanks
-- 
Florian
