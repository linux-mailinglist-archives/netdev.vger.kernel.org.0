Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D693C1735
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 18:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhGHQoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 12:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhGHQoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 12:44:38 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFCDC061574;
        Thu,  8 Jul 2021 09:41:55 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id h4so6606835pgp.5;
        Thu, 08 Jul 2021 09:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GylP2h/vGk7rUHYwB/QVPhjkfxYbehLyp/bT9npB0Yg=;
        b=LMDdcytOc0Z2ciYeBY8dEa8I1jmlRbOcH/X+ADarQXDMKb06H1m0FXVLHAq9fAGtV0
         UkXcpcNGPdCx7kXglylmKcOgzjSmX5DycwkvVlzl80380L6rPIEPaDPtF+Ks+xCPhZL4
         zuBqapjmzA4ckNeVWkvdGA4WI0zVLcraFxMgVtqMwCNKIj2+q3q8GjO6e+WtLzWnpYVW
         PWuy/e8MnFcuSx4iIkaunj1CT901rl1vI50VYjq9E8fdYVmVYJUEOZm1GcyAnW4aw3UV
         bp4j1JHkP6F2gTiiQA5ZtmwHuksnWhEkSFt4eLzsLUmdTick0+pkXidC0/R4iLMZ8kVY
         +5Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GylP2h/vGk7rUHYwB/QVPhjkfxYbehLyp/bT9npB0Yg=;
        b=lW7527+JTiJvK1P1lzdpq/2DYT8BkFZ9LzumlSCKst0jZr0yoRJhYk2cIpdy4C8E9u
         Uyx/4BwhMzF0cerHFIuwbZt+gwCxs4wsI5UD0Gynl2CRtHmTiF0TrYNlZNLsSurBe0cA
         0F4EIPONK72WPUwjplNCPj72NxcstWHYtI1uTibhCf9LAGXGkzoMC/N5UM6BeW1BqVIU
         wmKVaxsPCtEeyez2FxYjXRoh5Alzf9KlH2evjrOL7KiekDhAfn6rqKfs3lF1dstRu3bd
         V7yZALvHgKO0SrwcKM1Vb0+waGjI8y1tu+AKM8FLzJomBxyPaScL1jDUaE/EbNrUcKq1
         HwLw==
X-Gm-Message-State: AOAM530CIuWNeJWPxRQg0GePke8VAI5mRg2N1UrDYiktLbUyUQ0bv9I4
        VQSnzftduKdWBuzRPABSv20IYj4QDnUSRQ==
X-Google-Smtp-Source: ABdhPJxJFZ4WqZ2x+jy1EH6AaS76n/tnnlNBEqSyLLyKLS7XrC9am9Huo+b3X+VARYTDQ8wpiawxVA==
X-Received: by 2002:a62:4e97:0:b029:312:7b4c:55b7 with SMTP id c145-20020a624e970000b02903127b4c55b7mr31638752pfb.47.1625762514387;
        Thu, 08 Jul 2021 09:41:54 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y5sm9387095pjy.2.2021.07.08.09.41.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 09:41:53 -0700 (PDT)
Subject: Re: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL option
 still enabled
To:     "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210708004253.6863-1-mohammad.athari.ismail@intel.com>
 <YOZTmfvVTj9eo+to@lunn.ch> <4e159b98-ec02-33b7-862a-0e35832c3a5f@gmail.com>
 <CO1PR11MB477144A2A055B390825A9FF4D5199@CO1PR11MB4771.namprd11.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9871a015-bcfb-0bdb-c481-5e8f2356e5ba@gmail.com>
Date:   Thu, 8 Jul 2021 09:41:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CO1PR11MB477144A2A055B390825A9FF4D5199@CO1PR11MB4771.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/21 3:10 AM, Ismail, Mohammad Athari wrote:
> 
> 
>> -----Original Message-----
>> From: Florian Fainelli <f.fainelli@gmail.com>
>> Sent: Thursday, July 8, 2021 10:49 AM
>> To: Andrew Lunn <andrew@lunn.ch>; Ismail, Mohammad Athari
>> <mohammad.athari.ismail@intel.com>
>> Cc: Heiner Kallweit <hkallweit1@gmail.com>; David S . Miller
>> <davem@davemloft.net>; Russell King <linux@armlinux.org.uk>; Jakub Kicinski
>> <kuba@kernel.org>; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL
>> option still enabled
>>
>>
>>
>> On 7/7/2021 6:23 PM, Andrew Lunn wrote:
>>> On Thu, Jul 08, 2021 at 08:42:53AM +0800,
>> mohammad.athari.ismail@intel.com wrote:
>>>> From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
>>>>
>>>> When the PHY wakes up from suspend through WOL event, there is a need
>>>> to reconfigure the WOL if the WOL option still enabled. The main
>>>> operation is to clear the WOL event status. So that, subsequent WOL
>>>> event can be triggered properly.
>>>>
>>>> This fix is needed especially for the PHY that operates in PHY_POLL
>>>> mode where there is no handler (such as interrupt handler) available
>>>> to clear the WOL event status.
>>>
>>> I still think this architecture is wrong.
>>>
>>> The interrupt pin is wired to the PMIC. Can the PMIC be modelled as an
>>> interrupt controller? That would allow the interrupt to be handled as
>>> normal, and would mean you don't need polling, and you don't need this
>>> hack.
>>
>> I have to agree with Andrew here, and if the answer is that you cannot model
>> this PMIC as an interrupt controller, cannot the config_init() callback of the
>> driver acknowledge then disable the interrupts as it normally would if you were
>> cold booting the system? This would also allow you to properly account for the
>> PHY having woken-up the system.
> 
> Hi Florian,
> 
> Thank you for the suggestion. 
> If I understand correctly, you are suggesting to acknowledge and clear the WOL status in config_init() callback function. Am I correct?
> If yes, I did try to add a code to clear WOL status in marvell_config_init() function (we are using Marvell Alaska 88E1512). But, I found that, if the platform wake up from S3(mem) or S4(disk), the config_init() callback function is not called. As the result, WOL status not able to be cleared in config_init().
> 
> Please advice if you any suggestion.

This is presumably that you are seeing with stmmac along with phylink?

During S3 resume you should be going back to the kernel provided
re-entry point and resume where we left (warm boot) so
mdio_bus_phy_resume() should call phy_init_hw() which calls
config_init(), have you traced if that is somehow not happening?

During S4 resume (disk), I suppose that you have to involve the boot
loader to restore the DRAM image from the storage disk, and so that does
effectively look like a quasi cold boot from the kernel? If so, that
should still lead to config_init() being called when the PHY is
attached, no?
-- 
Florian
