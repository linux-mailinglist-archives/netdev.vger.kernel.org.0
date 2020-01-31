Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8477614F300
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 21:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgAaUCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 15:02:37 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35504 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgAaUCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 15:02:37 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so3159844plt.2;
        Fri, 31 Jan 2020 12:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=emYDodvZ9nQGl0MDqKYt//whPWtob3Kz4fWGNJWn8ak=;
        b=Q//n7ySnXqrs2JhW1t+g4TdV0nz5qiHGiYpZ3HkG2oBTf9T3kju3/E4bhVVLMQTW05
         l8Zm5dzZ3VU3A0MnwcwmqYwjYGQTuVrVtNyUv64WdzG6EsGkUxmqa98s56HpbW+ErUrT
         wMOEzOfnRw03bhotV0CYlEhtPr0acE7DsgT+3AM6kw75IvN6ElOKkMgBzuw2mzBDkNpM
         AsLyONn5L4nWkJH97ghEvEoks8akxcL1jW8vR6nHUWJiEtf70aMOU3kHW2miOoPyj6vD
         SeJOUSkwYF+sKvpVT02PdpcR2HKR4lHOCm6FTq0jpKiE9publVzDf490IuVw1atBRaOo
         0hug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=emYDodvZ9nQGl0MDqKYt//whPWtob3Kz4fWGNJWn8ak=;
        b=o6e14eVosdPUe5jun9CzjaezKZGnimZ8qqWIivGbaScsW0bFDCN+/HCGF9e/RMSlaC
         pquzwW4sf1QX9dRDQcsbvTqhU0UlcJhD+jqwt0nMYb+UmwqbjH2tanAydtp7bdIEwft4
         osa24rInS21BtxmTPrL4p4YGOgAjUNB/ppQgVp7Zjs4FRbCT+dW2kjAJB/3VWIk3nGJy
         txd//C40Y+TgNOGyYVEVe2k4hZJ5yZAfP6/b00roQ8dsf5lQTEOpU3GY7QfaxsWJM/Qv
         cDG1k5ogEyK9BMDAtCYw3VKqPNWhmtDaMREu/BI49sSAscLUTHzZiiZDzsr1tooQmTr5
         9Kdg==
X-Gm-Message-State: APjAAAUGGnEOhnQc6KiYUYXXST6xfoiCmj6Jxogpc97rRWbDKEHBj+Uc
        CGHBNKr1SWJ4UM5kTc5zNf8=
X-Google-Smtp-Source: APXvYqz05mZ7LNa5ibduoA0ucZ39W/htfmlj/WexDEzA2uI3j13Aw6xG1K8Xh9k/UO/KS/hZ36IQsQ==
X-Received: by 2002:a17:90a:23e5:: with SMTP id g92mr14807277pje.14.1580500956513;
        Fri, 31 Jan 2020 12:02:36 -0800 (PST)
Received: from [10.67.48.234] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j9sm11323672pfn.152.2020.01.31.12.02.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 12:02:35 -0800 (PST)
Subject: Re: [PATCH net-master 1/1] net: phy: dp83867: Add speed optimization
 feature
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, hkallweit1@gmail.com,
        bunk@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, grygorii.strashko@ti.com
References: <20200131151110.31642-1-dmurphy@ti.com>
 <20200131151110.31642-2-dmurphy@ti.com>
 <8f0e7d61-9433-4b23-5563-4dde03cd4b4a@gmail.com>
 <d03b5867-a55b-9abc-014f-69ce156b09f3@ti.com>
 <5c956a5a-cd83-f290-9995-6ea35383f5f0@gmail.com>
 <516ae353-e068-fe5e-768f-52308ef670a9@ti.com>
 <77b55164-5fc3-6022-be72-4d58ef897019@gmail.com>
 <07701542-2a94-7333-6682-a8e8986ea6d4@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <d194f979-ca6e-b33f-b18c-f8f238b66897@gmail.com>
Date:   Fri, 31 Jan 2020 12:02:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <07701542-2a94-7333-6682-a8e8986ea6d4@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/20 11:54 AM, Dan Murphy wrote:
> Florian
> 
> On 1/31/20 1:29 PM, Florian Fainelli wrote:
>> On 1/31/20 11:14 AM, Dan Murphy wrote:
>>> Florian
>>>
>>> On 1/31/20 12:42 PM, Florian Fainelli wrote:
>>>> On 1/31/20 10:29 AM, Dan Murphy wrote:
>>>>> Florian
>>>>>
>>>>> On 1/31/20 11:49 AM, Florian Fainelli wrote:
>>>>>> On 1/31/20 7:11 AM, Dan Murphy wrote:
>>>>>>> Set the speed optimization bit on the DP83867 PHY.
>>>>>>> This feature can also be strapped on the 64 pin PHY devices
>>>>>>> but the 48 pin devices do not have the strap pin available to enable
>>>>>>> this feature in the hardware.  PHY team suggests to have this bit
>>>>>>> set.
>>>>>> OK, but why and how does that optimization work exactly?
>>>>> I described this in the cover letter.  And it is explained in the data
>>>>> sheet Section 8.4.6.6
>>>> Sorry I complete missed that and just focused on the patch, you should
>>>> consider not providing a cover letter for a single patch, and
>>>> especially
>>>> not when the cover letter contains more information than the patch
>>>> commit message itself.
>>> Sorry I usually give a cover letter to all my network related patches.
>>>
>>> Unless I misinterpreted David on his reply to me about cover letters.
>>>
>>> https://www.spinics.net/lists/netdev/msg617575.html
>> This was a 2 patches series, for which a cover letter is mandatory:
>>
>> but for single patches, there really is no need, and having to replicate
>> the same information in two places is just error prone.
>>
>>> And I seemed to have missed David on the --cc list so I will add him for
>>> v2.
>>>
>>> I was also asked not to provide the same information in the cover letter
>>> and the commit message.
>> The cover letter is meant to provide some background about choices you
>> have made, or how to merge the patches, or their dependencies, and
>> describe the changes in a big picture. The patches themselves are
>> supposed to be comprehensive.
> 
> As always thank you for the guidance.  I will update the commit with
> better information and remove the cover letter.

No worries, every subsystem has its own rules, because why not :)

> 
> 
>>
>>> Either way I am ok with not providing a cover letter and updating the
>>> commit message with more information.
>>>
>>>
>>>>>>     Departing from
>>>>>> the BMSR reads means you possibly are going to introduce bugs and/or
>>>>>> incomplete information. For instance, you set phydev->pause and
>>>>>> phydev->asym_pause to 0 now, is there no way to extract what the link
>>>>>> partner has advertised?
>>>>> I was using the marvel.c as my template as it appears to have a
>>>>> separate
>>>>> status register as well.
>>>>>
>>>>> Instead of setting those bits in the call back I can call the
>>>>> genphy_read_status then override the duplex and speed based on the
>>>>> physts register like below.  This way link status and pause values can
>>>>> be updated and then we can update the speed and duplex settings.
>>>>>
>>>>>         ret = genphy_read_status(phydev);
>>>>>       if (ret)
>>>>>           return ret;
>>>>>
>>>>>       if (status < 0)
>>>>>           return status;
>>>>>
>>>>>       if (status & DP83867_PHYSTS_DUPLEX)
>>>>>           phydev->duplex = DUPLEX_FULL;
>>>>>       else
>>>>>           phydev->duplex = DUPLEX_HALF;
>>>>>
>>>>>       if (status & DP83867_PHYSTS_1000)
>>>>>           phydev->speed = SPEED_1000;
>>>>>       else if (status & DP83867_PHYSTS_100)
>>>>>           phydev->speed = SPEED_100;
>>>>>       else
>>>>>           phydev->speed = SPEED_10;
>>>>>
>>>> OK, but what if they disagree, are they consistently latched with
>>>> respect to one another?
>>> Well in parsing through the code for genphy read status when auto
>>> negotiation is set the phydev structure appears to be setup per what has
>>> been configured.  I did not see any reading of speed or duplex when auto
>>> neg is set it is just taking the LPA register. But I am probably not
>>> right here.  So we and our customers found that the phy was always
>>> reporting a 1Gbps connection when the 4 wire cable connected when using
>>> genphy_read_status.  This PHYSTS register provides a single location
>>> within the register set for quick access to commonly accessed
>>> information.
>> That is the kind of information that you want to put in the commit
>> message, and that sounds like a Fix more than a feature to me. If the
>> BMSR is not reflecting the correct speed, clearly something is not quite
>> good. You may also consider reflecting whether downshift was in action
>> and that led to reducing the speed, something like
>> m88e1011_link_change_notify() does.
> 
> But what is it fixing?  When the driver was originally submitted it was
> meant to be a Giga bit PHY.  No requirement for any connection less then
> 1Gbps. Now we have a customer who wants to use this feature and they
> want it upstreamed.  (YAY for them pushing upstream).
> 
> Do I reference my original commit?  Because I am actually flipping the
> bits to turn it on as well only way this was a fix is if the user had
> the feature strapped to on.  But to date we have not had any requests
> for this support.
> 
> So then it would be ok to do a genphy_read_status and then override the
> speed and duplex mode from the PHYSTS register?

I would think so yes, especially if that is needed for reporting the
actual link speed that ended up being negotiated, and not the one that
the link was initially trained at. That assumes I understand that the
problem is that you advertise and want Gigabit, but because of a 4-wire
cable being plugged in, you ended up at 100Mbits/sec.

> 
> I don't think that the link change notification is needed.  The speed
> should not change once the cable is plugged in and the speed is negotiated.

The link change notification is just to signal to the user that the
speed may have been reduced due to downshifting, which would/could
happen with 4-wires instead of the expected 8-wires. Certainly not
strictly necessary right now, I agree.
-- 
Florian
