Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1360E202CA6
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 22:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730625AbgFUUQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 16:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730572AbgFUUQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 16:16:42 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A072CC061794;
        Sun, 21 Jun 2020 13:16:40 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id k6so2162223wrn.3;
        Sun, 21 Jun 2020 13:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K1bE7hioO+jCeg02N2LK3QidAcdsCxuVYmIXB9dPoQ8=;
        b=NAqQ9+cchNxOX/8XjjaJ23UwqsEXMbnd9qBGlTvVlWkqwFzxrvFKE4wddAuikmi+iq
         8+oe/oLHh8JrBW/NBhBq3UePr0bvNl/ZuDgqRpI60e3Pif3I2B7n1FjKLOw9L181aNW2
         OtO5Wj4VrTYDcb+factsZYiFdOQVfiVlVnLPZG9GWp7oRFVzD3FpY19UH80F7ndzQd4B
         byy8Ol3hwGyoO0UPKvObwwIPVfcwyncUyBCGRk4j6A5h8rvglHs6xxvCb7B7oO/u3DYT
         HZbEHl9hi/JSOzw26TInfmjO+dRcUJsbRuw5KemW1WcLPFLupnnQsJ8puXkvdV/YCYqj
         zFDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K1bE7hioO+jCeg02N2LK3QidAcdsCxuVYmIXB9dPoQ8=;
        b=pJmR8ozpCdrRNr5jMrYiL0sjYzM0fbCX6V5naG9Kyn0iZUDJZIMGy8RgslMDfDYuoP
         gsDYrYkEK7Jb97ydz1nbkaqWGP8xzbGR4HkpVDQc6RJ+fkZLHY+Evj9U4MVnhdsmQjgD
         AGhdytQkFeL7ZGIXChV+XNVBQ2Lhjwbn7BEMYmpNg4og/M2s+fdE+ym+KSWUhYma93tN
         E2qW3m234+xHeNZskQJuuuMyHS6DAdxoxnf179StsSjHnaHBNxbrBEjP94AmsQa9w57t
         cPISpLo6sP5lkb0YmBNOtTz8xR87rKZcqcu1qMSAGIe8X+PCP4r/c/chzqkxkw2pdGxo
         U6Wg==
X-Gm-Message-State: AOAM533DM9KbjPyIIt8YGthP3+mPrC2xNEAO/orpbewHHCaOw0B7hUA5
        bYxMe8ZRhOsuHp5fGkL/TMm5ef+X
X-Google-Smtp-Source: ABdhPJwid9A8vjptsbQu7XdBibwoYVW+sszApPGr3eOGNxVxWozirwOCThkH48DiSfprXVclDmjB4Q==
X-Received: by 2002:adf:f707:: with SMTP id r7mr3352481wrp.70.1592770598974;
        Sun, 21 Jun 2020 13:16:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:6017:5dc5:df4:d4ec? (p200300ea8f23570060175dc50df4d4ec.dip0.t-ipconnect.de. [2003:ea:8f23:5700:6017:5dc5:df4:d4ec])
        by smtp.googlemail.com with ESMTPSA id x13sm15326146wre.83.2020.06.21.13.16.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jun 2020 13:16:38 -0700 (PDT)
Subject: Re: [PATCH] net: phy: realtek: clear interrupt during init for
 rtl8211f
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200512184601.40b1758a@xhacker.debian>
 <7735a257-21ff-e6c0-acdc-f5ee187b1f57@gmail.com>
 <20200513145151.04a6ee46@xhacker.debian>
 <a0aac85d-064f-2672-370b-404fd83e83f3@gmail.com>
 <20200514142537.63b478fd@xhacker.debian>
 <bbb70281-d477-d227-d1d2-aeecffdb6299@gmail.com>
 <20200515154128.41ee2afa@xhacker.debian>
 <18d7bdc7-b9f3-080f-f9df-a6ff61cd6a87@gmail.com>
 <e81ad573-ba30-a449-4529-d9a578ce0ee7@gmail.com>
 <20200617170926.5e582bad@xhacker.debian>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <5657764c-3de8-667f-b4a7-5dbaf2e15303@gmail.com>
Date:   Sun, 21 Jun 2020 22:16:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200617170926.5e582bad@xhacker.debian>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.06.2020 11:09, Jisheng Zhang wrote:
> On Fri, 15 May 2020 19:30:38 +0200 Heiner Kallweit wrote:
> 
> 
>>
>>
>> On 15.05.2020 18:18, Florian Fainelli wrote:
>>>
>>>
>>> On 5/15/2020 12:41 AM, Jisheng Zhang wrote:  
>>>> On Thu, 14 May 2020 21:50:53 +0200 Heiner Kallweit wrote:
>>>>  
>>>>>
>>>>>
>>>>> On 14.05.2020 08:25, Jisheng Zhang wrote:  
>>>>>> On Wed, 13 May 2020 20:45:13 +0200 Heiner Kallweit wrote:
>>>>>>  
>>>>>>>
>>>>>>> On 13.05.2020 08:51, Jisheng Zhang wrote:  
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> On Tue, 12 May 2020 20:43:40 +0200 Heiner Kallweit wrote:
>>>>>>>>  
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On 12.05.2020 12:46, Jisheng Zhang wrote:  
>>>>>>>>>> The PHY Register Accessible Interrupt is enabled by default, so
>>>>>>>>>> there's such an interrupt during init. In PHY POLL mode case, the
>>>>>>>>>> INTB/PMEB pin is alway active, it is not good. Clear the interrupt by
>>>>>>>>>> calling rtl8211f_ack_interrupt().  
>>>>>>>>>
>>>>>>>>> As you say "it's not good" w/o elaborating a little bit more on it:
>>>>>>>>> Do you face any actual issue? Or do you just think that it's not nice?  
>>>>>>>>
>>>>>>>>
>>>>>>>> The INTB/PMEB pin can be used in two different modes:
>>>>>>>> INTB: used for interrupt
>>>>>>>> PMEB: special mode for Wake-on-LAN
>>>>>>>>
>>>>>>>> The PHY Register Accessible Interrupt is enabled by
>>>>>>>> default, there's always such an interrupt during the init. In PHY POLL mode
>>>>>>>> case, the pin is always active. If platforms plans to use the INTB/PMEB pin
>>>>>>>> as WOL, then the platform will see WOL active. It's not good.
>>>>>>>>  
>>>>>>> The platform should listen to this pin only once WOL has been configured and
>>>>>>> the pin has been switched to PMEB function. For the latter you first would
>>>>>>> have to implement the set_wol callback in the PHY driver.
>>>>>>> Or where in which code do you plan to switch the pin function to PMEB?  
>>>>>>
>>>>>> I think it's better to switch the pin function in set_wol callback. But this
>>>>>> is another story. No matter WOL has been configured or not, keeping the
>>>>>> INTB/PMEB pin active is not good. what do you think?
>>>>>>  
>>>>>
>>>>> It shouldn't hurt (at least it didn't hurt for the last years), because no
>>>>> listener should listen to the pin w/o having it configured before.
>>>>> So better extend the PHY driver first (set_wol, ..), and then do the follow-up
>>>>> platform changes (e.g. DT config of a connected GPIO).  
>>>>
>>>> There are two sides involved here: the listener, it should not listen to the pin
>>>> as you pointed out; the phy side, this patch tries to make the phy side
>>>> behave normally -- not keep the INTB/PMEB pin always active. The listener
>>>> side behaves correctly doesn't mean the phy side could keep the pin active.
>>>>
>>>> When .set_wol isn't implemented, this patch could make the system suspend/resume
>>>> work properly.
>>>>
>>>> PS: even with set_wol implemented as configure the pin mode, I think we
>>>> still need to clear the interrupt for phy poll mode either in set_wol
>>>> or as this patch does.  
>>>
>>> I agree with Jisheng here, Heiner, is there a reason you are pushing
>>> back on the change? Acknowledging prior interrupts while configuring the
>>> PHY is a common and established practice.
>>>  
>> First it's about the justification of the change as such, and second about the
>> question whether the change should be in the driver or in phylib.
>>
>> Acking interrupts we do already if the PHY is configured for interrupt mode,
>> we call phy_clear_interrupt() at the beginning of phy_enable_interrupts()
>> and at the end of phy_disable_interrupts().
>> When using polling mode there is no strict need to ack interrupts.
>> If we say however that interrupts should be acked in general, then I think
>> it's not specific to RTL8211F, but it's something for phylib. Most likely
>> we would have to add a call to phy_clear_interrupt() to phy_init_hw().
> 
> it's specific to RTL8211F from the following two PoV:
> 1. the PIN is shared between INTB and PMEB.
> 2. the PHY Register Accessible Interrupt is enabled by default
> 
If we clear the interrupt in config_init() and one interrupt source is
active per chip default, then wouldn't the irq pin be active soon again?

I was thinking about calling phy_disable_interrupts() in phy_init_hw(),
to have a defined init state, as we don't know in which state the PHY is
if the PHY driver is loaded. We shouldn't assume that it's the chip
power-on defaults, BIOS or boot loader could have changed this.
Or in case of dual-boot systems the other OS could leave the PHY in
whatever state.

This made me think about an issue we may have currently:
Interrupts are enabled in phy_request_interrupt() only. If the system
hibernates, then PHY may load power-on defaults on restore.
And mdio_bus_phy_restore() just calls phy_init_hw() and doesn't
care about interrupt config. Means after waking up from hibernation
we may have lost PHY interrupt config.

> I didn't see such behaviors with other PHYs.
> 
> Thanks
> 
Heiner
