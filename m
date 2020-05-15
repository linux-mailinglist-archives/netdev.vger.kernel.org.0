Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3DCC1D57EC
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgEORar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726170AbgEORar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:30:47 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BCFC061A0C;
        Fri, 15 May 2020 10:30:47 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l11so4515462wru.0;
        Fri, 15 May 2020 10:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0rjXFEjiU1HQ34BY0HSdIF2xQgEtvUx+Hlj2Tn/G+F0=;
        b=a82BgWsBhe0lJ0k/ryPOqGBU95C+kYdL9KByvDN/9pjwdnKITiHJWHsPWB/IrOQ4HV
         z4OgIkzQw4QCN2Jm4TLSdbMKzwHqx9566JJZLbvhS2opKPEv97cGrU9mjb1sz/SBUrYK
         /s3h408tEBHuEEvahYNzegyVaRxglH8N8rNNTUjWlCeFHPe9R4BvNaiiUJr/ykVb2SIf
         GsMsr2MQUYh12z+3xxWP3endxXCxLtyqMnObgkxPlVgSzG1M7HyyUWhp/HoHgFkWmaV1
         JkrFUvPLKMPM1KDoHZhOTzdBCoH9AvQ7ogAjDoJknS3AxVwFtceD1tGfKUilNydV2MI7
         yFNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0rjXFEjiU1HQ34BY0HSdIF2xQgEtvUx+Hlj2Tn/G+F0=;
        b=dV7OKkqIRB4Maqyqalfs3f28dps/mnJRW0T+GXl3TCv9zAZnLYjIZcEPULSllJVmq3
         x6sCFn4Fd9msvM+L9atGwXyBpImC916gKM0ZzAdzVrGMtkUJR+ESfCEIx8zHCxwI3+hm
         NacIwdS97viETjZZGBfRXqes6i8VSsGVQF5jVaj2OWA9Yu77AkpMnHlenG2N511mRO1R
         2XtorT8ayzFCCOcjE4jcxWzJhHxwcOJZPaFmJ+4vw1Q4IzV/5ZPUBNa4jG2Dgf21jURK
         cfdgQO3tM+UQg1HCYihMt1An3XlZbhH+BiaDWz8nSDChsYHc9ysTl/sDepGobePikjH6
         3y2g==
X-Gm-Message-State: AOAM5318k3kWl0S3HaNqfmKynriajgs40fUA/maWlk8/9OYjgW85UPUD
        ThpRFcnghrG2Ui2GKsycN2d01aQv
X-Google-Smtp-Source: ABdhPJxOXdkOXE6j91QFA6gzCUdMVExB0FqcQCTF1pA2XGGIOUWDe9o8SgSaIhcKRAfoWyaBia0ucg==
X-Received: by 2002:adf:ce05:: with SMTP id p5mr196540wrn.423.1589563845549;
        Fri, 15 May 2020 10:30:45 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:6d66:4a8e:52c9:2691? (p200300EA8F2852006D664A8E52C92691.dip0.t-ipconnect.de. [2003:ea:8f28:5200:6d66:4a8e:52c9:2691])
        by smtp.googlemail.com with ESMTPSA id p7sm4388130wmg.38.2020.05.15.10.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 10:30:45 -0700 (PDT)
Subject: Re: [PATCH] net: phy: realtek: clear interrupt during init for
 rtl8211f
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200512184601.40b1758a@xhacker.debian>
 <7735a257-21ff-e6c0-acdc-f5ee187b1f57@gmail.com>
 <20200513145151.04a6ee46@xhacker.debian>
 <a0aac85d-064f-2672-370b-404fd83e83f3@gmail.com>
 <20200514142537.63b478fd@xhacker.debian>
 <bbb70281-d477-d227-d1d2-aeecffdb6299@gmail.com>
 <20200515154128.41ee2afa@xhacker.debian>
 <18d7bdc7-b9f3-080f-f9df-a6ff61cd6a87@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e81ad573-ba30-a449-4529-d9a578ce0ee7@gmail.com>
Date:   Fri, 15 May 2020 19:30:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <18d7bdc7-b9f3-080f-f9df-a6ff61cd6a87@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.05.2020 18:18, Florian Fainelli wrote:
> 
> 
> On 5/15/2020 12:41 AM, Jisheng Zhang wrote:
>> On Thu, 14 May 2020 21:50:53 +0200 Heiner Kallweit wrote:
>>
>>>
>>>
>>> On 14.05.2020 08:25, Jisheng Zhang wrote:
>>>> On Wed, 13 May 2020 20:45:13 +0200 Heiner Kallweit wrote:
>>>>  
>>>>>
>>>>> On 13.05.2020 08:51, Jisheng Zhang wrote:  
>>>>>> Hi,
>>>>>>
>>>>>> On Tue, 12 May 2020 20:43:40 +0200 Heiner Kallweit wrote:
>>>>>>  
>>>>>>>
>>>>>>>
>>>>>>> On 12.05.2020 12:46, Jisheng Zhang wrote:  
>>>>>>>> The PHY Register Accessible Interrupt is enabled by default, so
>>>>>>>> there's such an interrupt during init. In PHY POLL mode case, the
>>>>>>>> INTB/PMEB pin is alway active, it is not good. Clear the interrupt by
>>>>>>>> calling rtl8211f_ack_interrupt().  
>>>>>>>
>>>>>>> As you say "it's not good" w/o elaborating a little bit more on it:
>>>>>>> Do you face any actual issue? Or do you just think that it's not nice?  
>>>>>>
>>>>>>
>>>>>> The INTB/PMEB pin can be used in two different modes:
>>>>>> INTB: used for interrupt
>>>>>> PMEB: special mode for Wake-on-LAN
>>>>>>
>>>>>> The PHY Register Accessible Interrupt is enabled by
>>>>>> default, there's always such an interrupt during the init. In PHY POLL mode
>>>>>> case, the pin is always active. If platforms plans to use the INTB/PMEB pin
>>>>>> as WOL, then the platform will see WOL active. It's not good.
>>>>>>  
>>>>> The platform should listen to this pin only once WOL has been configured and
>>>>> the pin has been switched to PMEB function. For the latter you first would
>>>>> have to implement the set_wol callback in the PHY driver.
>>>>> Or where in which code do you plan to switch the pin function to PMEB?  
>>>>
>>>> I think it's better to switch the pin function in set_wol callback. But this
>>>> is another story. No matter WOL has been configured or not, keeping the
>>>> INTB/PMEB pin active is not good. what do you think?
>>>>  
>>>
>>> It shouldn't hurt (at least it didn't hurt for the last years), because no
>>> listener should listen to the pin w/o having it configured before.
>>> So better extend the PHY driver first (set_wol, ..), and then do the follow-up
>>> platform changes (e.g. DT config of a connected GPIO).
>>
>> There are two sides involved here: the listener, it should not listen to the pin
>> as you pointed out; the phy side, this patch tries to make the phy side
>> behave normally -- not keep the INTB/PMEB pin always active. The listener
>> side behaves correctly doesn't mean the phy side could keep the pin active.
>>
>> When .set_wol isn't implemented, this patch could make the system suspend/resume
>> work properly.
>>
>> PS: even with set_wol implemented as configure the pin mode, I think we
>> still need to clear the interrupt for phy poll mode either in set_wol
>> or as this patch does.
> 
> I agree with Jisheng here, Heiner, is there a reason you are pushing
> back on the change? Acknowledging prior interrupts while configuring the
> PHY is a common and established practice.
> 
First it's about the justification of the change as such, and second about the
question whether the change should be in the driver or in phylib.

Acking interrupts we do already if the PHY is configured for interrupt mode,
we call phy_clear_interrupt() at the beginning of phy_enable_interrupts()
and at the end of phy_disable_interrupts().
When using polling mode there is no strict need to ack interrupts.
If we say however that interrupts should be acked in general, then I think
it's not specific to RTL8211F, but it's something for phylib. Most likely
we would have to add a call to phy_clear_interrupt() to phy_init_hw().
