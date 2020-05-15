Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E5D1D55BA
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgEOQS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 12:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726162AbgEOQS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 12:18:58 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9559C061A0C;
        Fri, 15 May 2020 09:18:58 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x13so1143333pfn.11;
        Fri, 15 May 2020 09:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YarDuVlVYf6RY5LhI+cxh6o9ataicSsU1JAbBrOD00M=;
        b=M3T7qFUboMA/ALBd2rJpebQ3r8DrGmPWoDnBzzxs3XVDGbrPfpXiOI9stRc0Oqc0+g
         bgKhGdHh39IeIDJaNzXoxWDYPvPGOeKbZ6NvQUYDrO7KWf4lWhqRNgiRPvPcWoigcCrw
         May/oa+G2m34AnkscQeGeWKjDmBZyM17MczcKDSwBkgPLUMIskD9tMbKYX/JTsU6JA7h
         84PISpVhKw9MtLSiJryu7edaZNCbqHENbg/kbyYQ6+uWJyl71AazhLeu3R1X6yRfmHHy
         tKhkievdDnOzwY4EWw4q3oV30KaM88nBu1+TXFiZqaAr3OBBXm2r9eUTc79EPBdw7EHz
         /Z6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YarDuVlVYf6RY5LhI+cxh6o9ataicSsU1JAbBrOD00M=;
        b=WPZtfrRCVW/NiKXve8OASrw9caHTWW44UzR00dAXwhNN+wW7c2axQAwgki7VC7TrIM
         Y+nIPTb9iqsQ6RMe4YWGq3eucSirBc1Eb/sEFHUuc8zh2WQTKQe7ffqsQdzkO0BKKnL0
         ZVRJm8ksIjfFZdcGT53XFH8AWeNXZOT9F68KZesva8S6JIGsupRQ8L4MBbAs77Raf6q6
         T1Ci4sYxspJru2MhYwBoZSpNjYNpLLKl2obubfw/YI88L3Cv3QYQIFY0k2ACI1rqB1+v
         9hsTYstpr0QFvz8HMEYnBeo7BYT9ioRHfMnwL3k3QMTJi/By+3rE7iRWs0dfFhph1fxd
         ljpg==
X-Gm-Message-State: AOAM533Q4Z9T8/XomObiR8RBk7sO5hGUAY6YIFooL0eivSn552bJXpSO
        gRtlhdzkgo3Nurf23WfW3cQGnbr/
X-Google-Smtp-Source: ABdhPJxYaLz5Tf88VWPvMDcn/Vl/pIVrcT14u0MxHdO2GhTVgz33TdTWVePdJ4CpSibF1y9crWpO2w==
X-Received: by 2002:a62:1d4c:: with SMTP id d73mr4503216pfd.226.1589559537503;
        Fri, 15 May 2020 09:18:57 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j32sm2093718pgb.55.2020.05.15.09.18.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 09:18:56 -0700 (PDT)
Subject: Re: [PATCH] net: phy: realtek: clear interrupt during init for
 rtl8211f
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
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
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <18d7bdc7-b9f3-080f-f9df-a6ff61cd6a87@gmail.com>
Date:   Fri, 15 May 2020 09:18:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200515154128.41ee2afa@xhacker.debian>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/15/2020 12:41 AM, Jisheng Zhang wrote:
> On Thu, 14 May 2020 21:50:53 +0200 Heiner Kallweit wrote:
> 
>>
>>
>> On 14.05.2020 08:25, Jisheng Zhang wrote:
>>> On Wed, 13 May 2020 20:45:13 +0200 Heiner Kallweit wrote:
>>>  
>>>>
>>>> On 13.05.2020 08:51, Jisheng Zhang wrote:  
>>>>> Hi,
>>>>>
>>>>> On Tue, 12 May 2020 20:43:40 +0200 Heiner Kallweit wrote:
>>>>>  
>>>>>>
>>>>>>
>>>>>> On 12.05.2020 12:46, Jisheng Zhang wrote:  
>>>>>>> The PHY Register Accessible Interrupt is enabled by default, so
>>>>>>> there's such an interrupt during init. In PHY POLL mode case, the
>>>>>>> INTB/PMEB pin is alway active, it is not good. Clear the interrupt by
>>>>>>> calling rtl8211f_ack_interrupt().  
>>>>>>
>>>>>> As you say "it's not good" w/o elaborating a little bit more on it:
>>>>>> Do you face any actual issue? Or do you just think that it's not nice?  
>>>>>
>>>>>
>>>>> The INTB/PMEB pin can be used in two different modes:
>>>>> INTB: used for interrupt
>>>>> PMEB: special mode for Wake-on-LAN
>>>>>
>>>>> The PHY Register Accessible Interrupt is enabled by
>>>>> default, there's always such an interrupt during the init. In PHY POLL mode
>>>>> case, the pin is always active. If platforms plans to use the INTB/PMEB pin
>>>>> as WOL, then the platform will see WOL active. It's not good.
>>>>>  
>>>> The platform should listen to this pin only once WOL has been configured and
>>>> the pin has been switched to PMEB function. For the latter you first would
>>>> have to implement the set_wol callback in the PHY driver.
>>>> Or where in which code do you plan to switch the pin function to PMEB?  
>>>
>>> I think it's better to switch the pin function in set_wol callback. But this
>>> is another story. No matter WOL has been configured or not, keeping the
>>> INTB/PMEB pin active is not good. what do you think?
>>>  
>>
>> It shouldn't hurt (at least it didn't hurt for the last years), because no
>> listener should listen to the pin w/o having it configured before.
>> So better extend the PHY driver first (set_wol, ..), and then do the follow-up
>> platform changes (e.g. DT config of a connected GPIO).
> 
> There are two sides involved here: the listener, it should not listen to the pin
> as you pointed out; the phy side, this patch tries to make the phy side
> behave normally -- not keep the INTB/PMEB pin always active. The listener
> side behaves correctly doesn't mean the phy side could keep the pin active.
> 
> When .set_wol isn't implemented, this patch could make the system suspend/resume
> work properly.
> 
> PS: even with set_wol implemented as configure the pin mode, I think we
> still need to clear the interrupt for phy poll mode either in set_wol
> or as this patch does.

I agree with Jisheng here, Heiner, is there a reason you are pushing
back on the change? Acknowledging prior interrupts while configuring the
PHY is a common and established practice.
-- 
Florian
