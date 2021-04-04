Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30356353A16
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 00:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbhDDWtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 18:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbhDDWtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 18:49:13 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C1BC061756;
        Sun,  4 Apr 2021 15:49:05 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id k8so3392041edn.6;
        Sun, 04 Apr 2021 15:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dXl+ZSripteSPphiSM7KqQ+zInzo0PRRkYyrWUfZl+A=;
        b=etZmb2hc/jwkn9EZP9JMcrVMCtnfR6IIN4dhackbTiCawa1hyj0y31HP38k2kSFPxE
         YYziDtu5ToSZ9n8A0ux1dPE+yVbI+T4KRIDI0uEtv9Th4fC2GvZ7xB092dTt8C1QGBOm
         jvN18s2ytY1SaVhEqrWhBkmCxRSw/M5hE8lD4vf5lzq1Y/thkH21iqKkXsu43h1q1i4l
         uJJZrNnl2Qx3EWPL2up8uGczpNvYhlUin6dTa3E0w82u2QYxegKsRbTkjpIzkykyjsWJ
         0flNG7w+RNaoQqcC9X5Tt9jxprR0EeewNCD1kcYMbCx+Gi0lyJ47B4M4Z49DFoeKDAfZ
         0dug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dXl+ZSripteSPphiSM7KqQ+zInzo0PRRkYyrWUfZl+A=;
        b=Civ+8mvfeI/1/dJZXnSFbznNFvXCVoUEbFCfrwcsPbS3Umycu8MdveCn60NRw7fZjC
         3hUoZ6d9D+Bp/iX2uX+yDku1gK+gEwaCi/2Pr5KVs1lbgaxnqXgClbHGMV5k+CLo589j
         dU5E4oaGkeIb3x9tVWZGvfBkai+Q9Fp9Y1JjXPto8cKjtSR1sP5BdOh6IPG6D6S7EyVL
         OlxxN8VGhjsZH+VGi9p5rC64y3c033mtkYGR3mKIL3eu3ALvHppO7r8CSga18MqRjBRm
         C6DFDyI/aXACMFbiFv0ziWmVKgPYbBzTKwt3sTsiOM/v/KpTgWDklohydmp68/UNqbf3
         kncg==
X-Gm-Message-State: AOAM531Ch3nYs4qbBugpo9Z0VAkqJ3rqhpkC0MvP2JvlAi+ooDQcP82b
        fle8qiZn9NQkovwfyo76d80=
X-Google-Smtp-Source: ABdhPJzZqDwfun5lGdihL/MSUS/8Sxm3ipiFN0dTOr55yWXzqcycCOFpG9PSprzlj43NnX15QcCVog==
X-Received: by 2002:aa7:da46:: with SMTP id w6mr28667852eds.40.1617576544586;
        Sun, 04 Apr 2021 15:49:04 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:4523:8396:f5be:75e8? (p200300ea8f1fbb0045238396f5be75e8.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:4523:8396:f5be:75e8])
        by smtp.googlemail.com with ESMTPSA id p20sm1373667eds.92.2021.04.04.15.49.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Apr 2021 15:49:03 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>, andrew@lunn.ch,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, christian.melki@t2data.com
References: <20210404100701.6366-1-qiangqing.zhang@nxp.com>
 <97e486f8-372a-896f-6549-67b8fb34e623@gmail.com>
Subject: Re: [PATCH] net: phy: fix PHY possibly unwork after MDIO bus resume
 back
Message-ID: <ed600136-2222-a261-bf08-522cc20fc141@gmail.com>
Date:   Mon, 5 Apr 2021 00:48:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <97e486f8-372a-896f-6549-67b8fb34e623@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.04.2021 16:09, Heiner Kallweit wrote:
> On 04.04.2021 12:07, Joakim Zhang wrote:
>> commit 4c0d2e96ba055 ("net: phy: consider that suspend2ram may cut
>> off PHY power") invokes phy_init_hw() when MDIO bus resume, it will
>> soft reset PHY if PHY driver implements soft_reset callback.
>> commit 764d31cacfe4 ("net: phy: micrel: set soft_reset callback to
>> genphy_soft_reset for KSZ8081") adds soft_reset for KSZ8081. After these
>> two patches, I found i.MX6UL 14x14 EVK which connected to KSZ8081RNB doesn't
>> work any more when system resume back, MAC driver is fec_main.c.
>>
>> It's obvious that initializing PHY hardware when MDIO bus resume back
>> would introduce some regression when PHY implements soft_reset. When I
> 
> Why is this obvious? Please elaborate on why a soft reset should break
> something.
> 
>> am debugging, I found PHY works fine if MAC doesn't support suspend/resume
>> or phy_stop()/phy_start() doesn't been called during suspend/resume. This
>> let me realize, PHY state machine phy_state_machine() could do something
>> breaks the PHY.
>>
>> As we known, MAC resume first and then MDIO bus resume when system
>> resume back from suspend. When MAC resume, usually it will invoke
>> phy_start() where to change PHY state to PHY_UP, then trigger the stat> machine to run now. In phy_state_machine(), it will start/config
>> auto-nego, then change PHY state to PHY_NOLINK, what to next is
>> periodically check PHY link status. When MDIO bus resume, it will
>> initialize PHY hardware, including soft_reset, what would soft_reset
>> affect seems various from different PHYs. For KSZ8081RNB, when it in
>> PHY_NOLINK state and then perform a soft reset, it will never complete
>> auto-nego.
> 
> Why? That would need to be checked in detail. Maybe chip errata
> documentation provides a hint.
> 

The KSZ8081 spec says the following about bit BMCR_PDOWN:

If software reset (Register 0.15) is
used to exit power-down mode
(Register 0.11 = 1), two software
reset writes (Register 0.15 = 1) are
required. The first write clears
power-down mode; the second
write resets the chip and re-latches
the pin strapping pin values.

Maybe this causes the issue you see and genphy_soft_reset() isn't
appropriate for this PHY. Please re-test with the KSZ8081 soft reset
following the spec comment.


>>
>> This patch changes PHY state to PHY_UP when MDIO bus resume back, it
>> should be reasonable after PHY hardware re-initialized. Also give state
>> machine a chance to start/config auto-nego again.
>>
> 
> If the MAC driver calls phy_stop() on suspend, then phydev->suspended
> is true and mdio_bus_phy_may_suspend() returns false. As a consequence
> phydev->suspended_by_mdio_bus is false and mdio_bus_phy_resume()
> skips the PHY hw initialization.
> Please also note that mdio_bus_phy_suspend() calls phy_stop_machine()
> that sets the state to PHY_UP.
> 

Forgot that MDIO bus suspend is done before MAC driver suspend.
Therefore disregard this part for now.

> Having said that the current argumentation isn't convincing. I'm not
> aware of such issues on other systems, therefore it's likely that
> something is system-dependent.
> 
> Please check the exact call sequence on your system, maybe it
> provides a hint.
> 
>> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
>> ---
>>  drivers/net/phy/phy_device.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index cc38e326405a..312a6f662481 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -306,6 +306,13 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
>>  	ret = phy_resume(phydev);
>>  	if (ret < 0)
>>  		return ret;
>> +
>> +	/* PHY state could be changed to PHY_NOLINK from MAC controller resume
>> +	 * rounte with phy_start(), here change to PHY_UP after re-initializing
>> +	 * PHY hardware, let PHY state machine to start/config auto-nego again.
>> +	 */
>> +	phydev->state = PHY_UP;
>> +
>>  no_resume:
>>  	if (phydev->attached_dev && phydev->adjust_link)
>>  		phy_start_machine(phydev);
>>
> 

