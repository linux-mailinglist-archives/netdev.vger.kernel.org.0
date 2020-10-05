Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA86283BD8
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 18:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbgJEQAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 12:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgJEQAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 12:00:09 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8C2C0613CE;
        Mon,  5 Oct 2020 09:00:09 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y14so3960539pfp.13;
        Mon, 05 Oct 2020 09:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oX6OvXiflnMfGLVHCLZGsVZedfOvn0ntZsEufHpP9j8=;
        b=fWyrtFjmqKFe1LW0tYk6KC2EBSgmUz5Ft6qzszryhm4fcQG0EI6PHs7Fm7t/K8piGU
         9SXWclZR4mRkHMLpIycvmSJN/3uuSrbNqMcjUQCfLZ7TzRixfzO3tOnI0S/oT0/E0CeM
         muX+BBl155Sotc5o01Tkzh+1a7PZBuDEETVOXfH0aHSFDkbNOwSrvLQiw98VFMMisbRo
         pUVGPmzJiVzA6js+JaocKM1HYj4Ffc9FtppHGOVujy602LOXoCrNi7oQLZIJHPJybCm2
         0XKNFdzkTqhn2c0c4UaP7sO3b3q5ZfsxtPRsLJFbViOQG76b9OvVJ6KFY2AcVP7wLNhu
         CGdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oX6OvXiflnMfGLVHCLZGsVZedfOvn0ntZsEufHpP9j8=;
        b=SIipaXC3UQEHRx9l0yXVSUFjkBGp/R0Yw2q5OTli/spkucZBz7En8jojrnC12JaVn5
         u7fwpWxCEWjXbHmASezwxhtisgFJsN6uabegX2uHCTzWpV7maGEKG47R1sWHc3PDK+v5
         5Q+8dm5R+pfvQDZtnFAE/ZnUkhCeL9Z2GhuIMY5cFDmMnZ3uzw9vVHFBwptfGaigxy6H
         7UjLmOlm6L8OFDGJc1zyyFAmFwLLLh7EXIuXHRBH2A1xquM2D2nEsj1GteN37lsCFTDE
         wRrmJLMWQnbs1LEbaeQpw4GCJtbqyd4toZXbsigkoYS/fQhiGJEAzOC8oUMS2KgjMKoC
         Kc4w==
X-Gm-Message-State: AOAM5337fz56Ii/CWzHghQHC4NT6j6P5ugaF6yjwyyLVQoI/VagiD1tO
        +6RmwKsmUvzKrZJoZgg8oTJiyboem+b9EQ==
X-Google-Smtp-Source: ABdhPJwsuH/nDc8vh3P8U5cetcMLZGYbKCx42neLGaHmta8yFbJEFfwq6v7f5c07lBPY83n5QMx5Wg==
X-Received: by 2002:a63:1d5a:: with SMTP id d26mr136105pgm.432.1601913607944;
        Mon, 05 Oct 2020 09:00:07 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 189sm64222pfw.123.2020.10.05.09.00.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2020 09:00:07 -0700 (PDT)
Subject: Re: [RFC] net: phy: add shutdown hook to struct phy_driver
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200930174419.345cc9b4@xhacker.debian>
 <20200930190911.GU3996795@lunn.ch>
 <bab6c68f-8ed7-26b7-65ed-a65c7210e691@gmail.com>
 <20200930201135.GX3996795@lunn.ch>
 <379683c5-3ce5-15a6-20c4-53a698f0a3d0@gmail.com>
 <20201005165356.7b34906a@xhacker.debian>
 <95121d4a-0a03-0012-a845-3a10aa31f253@gmail.com>
 <0d565005-45ad-e85f-bc79-8e9100ceaf6c@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c7cc2088-19ca-8fcc-925d-2183634da073@gmail.com>
Date:   Mon, 5 Oct 2020 09:00:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <0d565005-45ad-e85f-bc79-8e9100ceaf6c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/5/2020 8:54 AM, Heiner Kallweit wrote:
> On 05.10.2020 17:41, Florian Fainelli wrote:
>>
>>
>> On 10/5/2020 1:53 AM, Jisheng Zhang wrote:
>>> On Wed, 30 Sep 2020 13:23:29 -0700 Florian Fainelli wrote:
>>>
>>>
>>>>
>>>> On 9/30/2020 1:11 PM, Andrew Lunn wrote:
>>>>> On Wed, Sep 30, 2020 at 01:07:19PM -0700, Florian Fainelli wrote:
>>>>>>
>>>>>>
>>>>>> On 9/30/2020 12:09 PM, Andrew Lunn wrote:
>>>>>>> On Wed, Sep 30, 2020 at 05:47:43PM +0800, Jisheng Zhang wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> A GE phy supports pad isolation which can save power in WOL mode. But once the
>>>>>>>> isolation is enabled, the MAC can't send/receive pkts to/from the phy because
>>>>>>>> the phy is "isolated". To make the PHY work normally, I need to move the
>>>>>>>> enabling isolation to suspend hook, so far so good. But the isolation isn't
>>>>>>>> enabled in system shutdown case, to support this, I want to add shutdown hook
>>>>>>>> to net phy_driver, then also enable the isolation in the shutdown hook. Is
>>>>>>>> there any elegant solution?
>>>>>>>   
>>>>>>>> Or we can break the assumption: ethernet can still send/receive pkts after
>>>>>>>> enabling WoL, no?
>>>>>>>
>>>>>>> That is not an easy assumption to break. The MAC might be doing WOL,
>>>>>>> so it needs to be able to receive packets.
>>>>>>>
>>>>>>> What you might be able to assume is, if this PHY device has had WOL
>>>>>>> enabled, it can assume the MAC does not need to send/receive after
>>>>>>> suspend. The problem is, phy_suspend() will not call into the driver
>>>>>>> is WOL is enabled, so you have no idea when you can isolate the MAC
>>>>>>> from the PHY.
>>>>>>>
>>>>>>> So adding a shutdown in mdio_driver_register() seems reasonable.  But
>>>>>>> you need to watch out for ordering. Is the MDIO bus driver still
>>>>>>> running?
>>>>>>
>>>>>> If your Ethernet MAC controller implements a shutdown callback and that
>>>>>> callback takes care of unregistering the network device which should also
>>>>>> ensure that phy_disconnect() gets called, then your PHY's suspend function
>>>>>> will be called.
>>>>>
>>>>> Hi Florian
>>>>>
>>>>> I could be missing something here, but:
>>>>>
>>>>> phy_suspend does not call into the PHY driver if WOL is enabled. So
>>>>> Jisheng needs a way to tell the PHY it should isolate itself from the
>>>>> MAC, and suspend is not that.
>>>>
>>>> I missed that part, that's right if WoL is enabled at the PHY level then
>>>> the suspend callback is not called, how about we change that and we
>>>> always call the PHY's suspend callback? This would require that we audit
>>>
>>> Hi all,
>>>
>>> The PHY's suspend callback usually calls genphy_suspend() which will set
>>> BMCR_PDOWN bit, this may break WoL. I think this is one the reason why
>>> we ignore the phydrv->suspend() when WoL is enabled. If we goes to this
>>> directly, it looks like we need to change each phy's suspend implementation,
>>> I.E if WoL is enabled, ignore genphy_suspend() and do possible isolation;
>>> If WoL is disabled, keep the code path as is.
>>>
>>> So compared with the shutdown hook, which direction is better?
>>
>> I believe you will have an easier time to add an argument to the PHY driver suspend's function to indicate the WoL status, or to move down the check for WoL being enabled/supported compared to adding support for shutdown into the MDIO bus layer, and then PHY drivers.
> 
> Maybe the shutdown callback of mdio_bus_type could be implemented.
> It could iterate over all PHY's on the bus, check for WoL (similar to
> mdio_bus_phy_may_suspend) and do whatever is needed.
> Seems to me to be the most generic way.

OK and we optionally call into a PHY device's shutdown function if 
defined so it can perform PHY specific work? That would work for me.
-- 
Florian
